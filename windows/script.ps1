################
# INFORMATIONS #
################
#
# ID : 12042024
# Author : Maximilien Bruyere
# OS : Windows Server - 2019
#
################

###############
# DESCRIPTION #
###############
#
# Services who will be installed :
# - DHCP
# - Active Directory
# - GPO
# - Quotas
# - Backup
#
###############



<#
WINDOWSSERVER
#>
class WindowsServer 
{
    [System.Net.IPAddress]$ipAddress
    [int]$subnetMask
    [System.Net.IPAddress]$networkAddress
    [System.Net.IPAddress]$defaultGateway
    [string]$hostname
    [string]$domainName

    # Constructor
    WindowsServer(
                [System.Net.IPAddress]$ipAddress,
                [int]$subnetMask,
                [System.Net.IPAddress]$networkAddress,
                [System.Net.IPAddress]$defaultGateway,
                [string]$hostname,
                [string]$domainName
                )
    {
        $this.ipAddress = $ipAddress
        $this.subnetMask = $subnetMask
        $this.networkAddress = $networkAddress
        $this.defaultGateway = $defaultGateway
        $this.hostname = $hostname
        $this.domainName = $domainName
    }

    [void] ConfigureServer() 
    {
        try 
        {
            $interfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).Name
            New-NetIPAddress -InterfaceAlias $interfaceAlias -IPAddress $this.ipAddress -PrefixLength $this.subnetMask -DefaultGateway $this.defaultGateway
            Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses ("$($this.ipAddress)")
            Disable-NetAdapterBinding -Name $interfaceAlias -ComponentID ms_tcpip6
            Set-TimeZone -Id "Romance Standard Time"
            New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -Direction Inbound -Action Allow
            New-NetFirewallRule -DisplayName "Allow ICMPv4-Out" -Protocol ICMPv4 -Direction Outbound -Action Allow
            Rename-Computer -NewName $this.hostname -Restart
        } 
        
        catch 
        {
            Write-Host "An error occurred during server configuration: $_"
            throw
        }
    }
}


<#
DHCP
#>
class DHCP : WindowsServer {

    # Constructor
    DHCP(
        [System.Net.IPAddress]$ipAddress,
        [int]$subnetMask,
        [System.Net.IPAddress]$networkAddress,
        [System.Net.IPAddress]$defaultGateway,
        [string]$hostname,
        [string]$domainName
        ) : base($ipAddress, $subnetMask, $networkAddress, $defaultGateway, $hostname, $domainName) 
    {}

    [void] InstallDHCP() 
    {
        try 
        {
            Install-WindowsFeature DHCP -IncludeManagementTools
            Restart-Computer
        } 
        
        catch 
        {
            Write-Host "An error occurred during DHCP configuration: $_"
            throw
        }
    }

    [void] ConfigureDHCP() 
    {
        try 
        {
            Set-DhcpServerv4DnsSetting -ComputerName "$($this.hostname).$($this.domainName)" -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True
            Add-DhcpServerInDC -DnsName $this.domainName -IPAddress $this.ipAddress
            Restart-Service dhcpserver
        } 
        
        catch 
        {
            Write-Host "An error occurred during DHCP configuration: $_"
            throw
        }
    }

    [void] ConfigureScope($scopeName, 
                        $descriptionScope,
                        $networkScopeAddress,
                        $startScopeRange,
                        $endScopeRange,
                        $startExclusionRange,
                        $endExclusionRange,
                        $subnetMask,
                        $leaseDuration)
    {

        $startScopeRange = [System.Net.IPAddress]::Parse($startScopeRange)
        $endScopeRange = [System.Net.IPAddress]::Parse($endScopeRange)

        $startExclusionRange = [System.Net.IPAddress]::Parse($startExclusionRange)
        $endExclusionRange = [System.Net.IPAddress]::Parse($endExclusionRange)

        $subnetMask = [System.Net.IPAddress]::Parse($subnetMask)
        $networkScopeAddress = [System.Net.IPAddress]::Parse($networkScopeAddress)

        $leaseDuration = [TimeSpan]::Parse($leaseDuration)

        try 
        {
            Add-DhcpServerv4Scope -Name $scopeName -StartRange $startScopeRange -EndRange $endScopeRange -SubnetMask $subnetMask -LeaseDuration $leaseDuration -Description $descriptionScope
            Add-Dhcpserverv4ExclusionRange -ScopeId $networkScopeAddress -StartRange $startExclusionRange -EndRange $endExclusionRange

            if ($this.defaultGateway -ne [System.Net.IPAddress]::Parse("0.0.0.0")) {
                Set-DhcpServerv4OptionValue -ScopeId $networkScopeAddress -OptionId 3 -Value $this.defaultGateway
            } else {
                Write-Host "Invalid default gateway address."
            }

            if ($this.domainName -ne "") {
                Set-DhcpServerv4OptionValue -ScopeId $networkScopeAddress -OptionId 15 -Value $this.domainName
            } else {
                Write-Host "Invalid domain name."
            }

            if ($this.ipAddress -ne [System.Net.IPAddress]::Parse("0.0.0.0")) {
                Set-DhcpServerv4OptionValue -ScopeId $networkScopeAddress -OptionId 6 -Value $this.ipAddress
            } else {
                Write-Host "Invalid DNS server address."
            }

            $addUserClass = Read-Host "Do you want to add a user class ? (yes/no) "
            if ($addUserClass -eq "yes") 
            {
                $this.DHCPClientClass($this.networkAddress)
            }

            $addPolicy = Read-Host "Do you want to add a policy on this scope ? (yes/no) "

            if ($addPolicy -eq "yes")
            {
                $this.ConfigurePolicyScope($networkScopeAddress)
            }

            Restart-Service dhcpserver
        }

        catch 
        {
            Write-Host "An error occurred during DHCP scope configuration: $_"
            throw
        }
    }


    [void] ConfigurePolicyScope($networkScopeAddress)
    {
        try
        {
            $policyName = Read-Host "Policy name "
            $userClass = Read-Host "User Class "
            $condition = Read-Host "Condition (OR/AND) "
            $router = [System.Net.IPAddress]::Parse((Read-Host "Router (x.x.x.x) "))
            $dnsServer = [System.Net.IPAddress]::Parse((Read-Host "DNS Server (x.x.x.x) "))
            $dnsDomainName = Read-Host "DNS Domain Name "
            $startPolicyScopeRange = [System.Net.IPAddress]::Parse((Read-Host "Start Policy Scope Range (x.x.x.x) "))
            $endPolicyScopeRange = [System.Net.IPAddress]::Parse((Read-Host "End Policy Scope Range (x.x.x.x) "))

            Add-DhcpServerv4Policy -Name $policyName -ScopeId $networkScopeAddress -Condition $condition -UserClass EQ,$userClass

            Add-DhcpServerv4PolicyIPRange -ComputerName "$($this.hostname).$($dnsDomainName)" -ScopeId $networkScopeAddress -Name $policyName -StartRange $startPolicyScopeRange -EndRange $endPolicyScopeRange

            Set-DhcpServerv4OptionValue -ComputerName "$($this.hostname).$($dnsDomainName)" -ScopeId $networkScopeAddress -PolicyName $policyName -OptionId 3 -Value $router
            Set-DhcpServerv4OptionValue -ComputerName "$($this.hostname).$($dnsDomainName)" -ScopeId $networkScopeAddress -PolicyName $policyName -OptionId 15 -Value $dnsDomainName
            Set-DhcpServerv4OptionValue -ComputerName "$($this.hostname).$($dnsDomainName)" -ScopeId $networkScopeAddress -PolicyName $policyName -OptionId 6 -Value $dnsServer
        }

        catch 
        {
            Write-Host "An error occurred during DHCP policy scope configuration: $_"
            throw
        }
    }


    [void] DHCPClientClass($ScopeId) 
    {
        try 
        {
            $className = Read-Host "Class name "
            $classData = Read-Host "ASCII Code "
            Add-DhcpServerv4Class  -Name $className -Type User -Data $classData
        } 
        
        catch 
        {
            Write-Host "An error occurred while adding the DHCP client class: $_"
            throw
        }
    }
}


<#
ACTIVE DIRECTORY
#>
class ActiveDirectory : WindowsServer 
{
    # Constructor
    ActiveDirectory( 
                    [System.Net.IPAddress]$ipAddress,
                    [int]$subnetMask,
                    [System.Net.IPAddress]$networkAddress,
                    [System.Net.IPAddress]$defaultGateway,
                    [string]$hostname,
                    [string]$domainName) : base($ipAddress, $subnetMask, $networkAddress, $defaultGateway, $hostname, $domainName)
    {
    }

    [string] GetNetBIOSName([string]$domainName) 
    {
        $netBIOSName = $domainName.Split('.')[0].ToUpper()
        if ($netBIOSName.Length -gt 15) 
        {
            $netBIOSName = $netBIOSName.Substring(0, 15)
        }
        return $netBIOSName
    }

    [void] ActiveDirectoryConfiguration() 
    {
        try 
        {
            $netBIOSName = $this.GetNetBIOSName($this.domainName)
            Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools -ErrorAction Stop
            Install-ADDSForest -DomainName $this.domainName -DomainNetBIOSName $netBIOSName -InstallDNS -SafeModeAdministratorPassword (ConvertTo-SecureString "Test123*" -AsPlainText -Force) -ErrorAction Stop
        } 

        catch 
        {
            Write-Host "An error occurred during Active Directory configuration: $_"
            throw
        }
    }

    [void] ConfigureReverseDNS() 
    {
        try 
        {
            $interfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).Name
            Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses ("$($this.ipAddress)") -ErrorAction Stop
            $this.CreatePrimaryZone()
            $this.CreatePTRRecord()
        } 
        
        catch 
        {
            Write-Host "An error occurred during Reverse DNS configuration: $_"
            throw
        }
    }

    [void] CreatePrimaryZone() 
    {
        try 
        {
            Add-DnsServerPrimaryZone -NetworkId "$($this.networkAddress)/$($this.subnetMask)" -ReplicationScope "Forest" -ErrorAction Stop
        } 
        
        catch 
        {
            Write-Host "An error occurred while creating the primary zone: $_"
            throw
        }
    }

    [void] RecycleBin()
    {
        Enable-ADOptionalFeature 'Recycle Bin Feature' -Scope ForestOrConfigurationSet -Target $this.domainName
    }

    [void] CreatePTRRecord() 
    {
        try 
        {
            $reverseZone = ($this.ipAddress.ToString().Split('.')[2..0] -join '.') + ".in-addr.arpa"
            $lastOctet = $this.ipAddress.ToString().Split('.')[-1]
            Add-DnsServerResourceRecordPtr -Name $lastOctet -ZoneName $reverseZone -PtrDomainName "$($this.hostname).$($this.domainName)" -ErrorAction Stop
        } 
        
        catch
        {
            Write-Host "An error occurred while creating the PTR record: $_"
            throw
        }
    }
}


function main () 
{
    param (
        [string]$ipAddress,
        [int]$subnetMask,
        [string]$networkAddress,
        [string]$defaultGateway,
        [string]$hostname,
        [string]$domain
    )

    $windowsServer = [WindowsServer]::new($ipAddress, $subnetMask, $networkAddress, $defaultGateway, $hostname, $domain)
    $dhcpServer = [DHCP]::new($ipAddress, $subnetMask, $networkAddress, $defaultGateway, $hostname, $domain)
    $activeDirectoryServer = [ActiveDirectory]::new($ipAddress, $subnetMask, $networkAddress, $defaultGateway, $hostname, $domain)

    $menu = "+------+
| MENU |
+------+

1. Starting Configuration
2. Active Directory Installation
3. Active Directory DNS
4. DHCP Installation
5. DHCP Configuration
6. DHCP Scope Configuration
    Optionnal : UserClass, Scope Policy
7. Exit

Note : I advice you to select these options
        in order 
    "


    $flag = $true 

    while ($flag)
    {
        Clear-Host
        Write-Host $menu

        $choice = Read-Host "Select Option "

        switch ($choice) {
            1 { $windowsServer.ConfigureServer() }
            2 { $activeDirectoryServer.ActiveDirectoryConfiguration() }
            3 { $activeDirectoryServer.ConfigureReverseDNS() }
            4 { $dhcpServer.InstallDHCP() }
            5 { $dhcpServer.ConfigureDHCP() }
            6 { 
                $scopeName = Read-Host("Scope Name ")
                $descriptionScope = Read-Host("Scope Description ")

                $startScopeRange = Read-Host("[x.x.x.x] Start IP Scope Range ")
                $endScopeRange = Read-Host("[x.x.x.x] End IP Scope Range ")

                $startExclusionRange = Read-Host("[x.x.x.x] Start Exclusion IP Scope Range ")
                $endExclusionRange = Read-Host("[x.x.x.x] End Exclusion IP Scope Range ")

                $ScopeSubnetMask = Read-Host("[x.x.x.x] Scope Subnet Mask ")
                $networkScopeAddress = Read-Host("[x.x.x.x] Network Scope Address ")

                $leaseDuration = Read-Host("[xx:xx:xx] Scope Lease Duration ")
                $dhcpServer.ConfigureScope($scopeName,$descriptionScope,$networkScopeAddress,$startScopeRange,$endScopeRange,$startExclusionRange, $endExclusionRange, $ScopeSubnetMask,$leaseDuration)
            }
            7 { 
                Write-Host "Ciao !"
                $flag = $false
             }
            Default { Write-Host "Invalid option. Please select a valid option from the menu." }
        }
    }
}

main -ipAddress "192.168.3.10" -subnetMask 24 -networkAddress "192.168.3.0" -defaultGateway "192.168.3.1" -hostname "main" -domain "nordic.lan"