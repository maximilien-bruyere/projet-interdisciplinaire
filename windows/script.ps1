# ID : 12042024
# Author : Maximilien Bruyere
# OS : Windows Server - 2019

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

class WindowsServer 
{
    [System.Net.IPAddress]$ipAddress
    [int]$subnetMask
    [System.Net.IPAddress]$networkAddress
    [System.Net.IPAddress]$defaultGateway
    [string]$hostname
    [string]$domainName

    # Constructor
    WindowsServer([System.Net.IPAddress]$ipAddress, [int]$subnetMask, [System.Net.IPAddress]$defaultGateway, [string]$hostname, [string]$domainName)
    {
        $this.ipAddress = $ipAddress
        $this.subnetMask = $subnetMask
        $this.defaultGateway = $defaultGateway
        $this.hostname = $hostname
        $this.domainName = $domainName
    }

    [void] ConfigureServer() 
    {
        $interfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).Name
        # You could use (Get-NetAdapter).name but you got all interfaces names.

        # Basic Server Configuration
        # - Network
        # - TimeZone
        # - Firewall's rules
        # - Hostname
        
        New-NetIPAddress -InterfaceAlias $interfaceAlias -IPAddress $this.ipAddress -PrefixLength $this.subnetMask -DefaultGateway $this.defaultGateway
        Set-DnsClientServerAddress -InterfaceAlias $interfaceAlias -ServerAddresses ("8.8.8.8", "8.8.4.4")
        Disable-NetAdapterBinding -Name $interfaceAlias -ComponentID ms_tcpip6
        Set-TimeZone -Id "Romance Standard Time"
        New-NetFirewallRule -DisplayName "Allow ICMPv4-In" -Protocol ICMPv4 -Direction Inbound -Action Allow
        New-NetFirewallRule -DisplayName "Allow ICMPv4-Out" -Protocol ICMPv4 -Direction Outbound -Action Allow
        Rename-Computer -NewName $this.hostname -Restart
    }

    [string] WindowsServerMenu()
    {
        Clear-Host
        $menu = "
        +==============+
        |     Menu     |
        +==============+
        1. Configure Windows Server
        2. AD Configuration
        3. DHCP Configuration
        4. GPO Configuration
        5. Show Windows Server Menu
        6. Exit
        =====================
        "
        return $menu
    }
}

class DHCP : WindowsServer 
{

    # Constructor
    DHCP(
        [System.Net.IPAddress]$ipAddress,
        [int]$subnetMask,
        [System.Net.IPAddress]$defaultGateway,
        [string]$hostname,
        [string]$domainName) : base($ipAddress, $subnetMask, $defaultGateway, $hostname, $domainName
        )
    {   
    }

    [void] ConfigureDHCP() 
    {
        # Installation of DHCP services 
        
        Install-WindowsFeature DHCP -IncludeManagementTools
        Set-DhcpServerv4DnsSetting -ComputerName "$($this.hostname)", "$($this.domainName)" -join "." -DynamicUpdates "Always" -DeleteDnsRRonLeaseExpiry $True
        Add-DhcpServerInDC -DnsName $this.domainName -IPAddress $this.ipAddress
        Restart-Service dhcpserver
    }
    
    [void] ConfigureScope() 
    {
        # Scope's Configuration 
        # with policy (optionnal)

        $scopeName = Read-Host "Scope's name : "
        $descriptionScope = Read-Host "Description ($($scopeName)) : "
       
        $startScopeRange = [System.Net.IPAddress]::Parse((Read-Host "Start Scope Range : "))
        $endScopeRange = [System.Net.IPAddress]::Parse((Read-Host "End Scope Range : "))
        
        $startExclusionRange = [System.Net.IPAddress]::Parse((Read-Host "Start Exclusion Range : "))
        $endExclusionRange = [System.Net.IPAddress]::Parse((Read-Host "End Exclusion Range : "))
        
        $subnetMask = Read-Host "SubnetMask : "
        $networkAddress = [System.Net.IPAddress]::Parse((Read-Host "Network Address : "))

        $leaseDuration = [timespan]::Parse()
        
        Add-DhcpServerv4Scope -Name $scopeName -Description $descriptionScope -StartRange $startScopeRange -EndRange $endScopeRange -SubnetMask $subnetMask -State Active
        Add-DhcpServerv4ExclusionRange -ScopeID $networkAddress -StartRange $startExclusionRange -EndRange $endExclusionRange
        Set-DhcpServerv4OptionValue -ScopeId $networkAddress -OptionId 3 -Value $this.defaultGateway -ComputerName "$($this.hostname)", "$($this.domainName)" -join "."
        Set-DhcpServerv4OptionValue -DnsDomain $this.domainName -DnsServer $this.ipAddress
    
        # User Class
        $addUserClass = Read-Host "Do you want to add a user class? (yes/no) : "
        if ($addUserClass -eq "yes") {
            DHCPClientClass -ScopeId $networkAddress
        }
    
        Restart-Service dhcpserver
    }
    
    [void] DHCPClientClass($ScopeId) 
    {
        $className = Read-Host "Class name : "
        $classData = Read-Host "ASCII Code : "

        # User Class Creation
        Add-DhcpServerv4Class -Name $className -Type User -Data $classData
    
        # User CLass Options
        $addOptions = Read-Host "Do you want to add specific options for this class? (yes/no) : "
        while ($addOptions -eq "yes") {
            $optionId = Read-Host "Option ID : "
            $optionValue = Read-Host "Option Value : "
            Set-DhcpServerv4OptionValue -ScopeId $ScopeId -ClassName $className -OptionId $optionId -Value $optionValue
            $addOptions = Read-Host "Do you want to add another option? (yes/no) : "
        }
    }
    
    [string] DHCPMenu() 
    {
        $menu = "
        +==============+
        |     Menu     |
        +==============+
        1. Configure DHCP
        3. Scope Configuration
        4. Show DHCP Menu
        5. Exit
        =====================
        "
        return $menu
    }
}


