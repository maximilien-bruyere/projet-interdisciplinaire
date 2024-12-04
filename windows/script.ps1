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

    [void]ConfigureServer() 
    {
        $interfaceAlias = (Get-NetAdapter | Where-Object { $_.Status -eq "Up" }).Name

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
}

class DHCP : WindowsServer {
    [string]$scopeName
    [string]$descriptionScope
    [System.Net.IPAddress]$startRange
    [System.Net.IPAddress]$endRange
    [System.Net.IPAddress]$startExclusionRange
    [System.Net.IPAddress]$endExclusionRange
    [timespan]$leaseDuration

    # Constructor
    DHCP(
        [System.Net.IPAddress]$ipAddress,
        [int]$subnetMask,
        [System.Net.IPAddress]$defaultGateway,
        [string]$hostname,
        [string]$domainName,
        [string]$scopeName,
        [string]$descriptionScope,
        [System.Net.IPAddress]$startRange,
        [System.Net.IPAddress]$endRange,
        [System.Net.IPAddress]$startExclusionRange,
        [System.Net.IPAddress]$endExclusionRange,
        [timespan]$leaseDuration) : base($ipAddress, $subnetMask, $defaultGateway, $hostname, $domainName)
    {   
        $this.scopeName = $scopeName
        $this.descriptionScope = $descriptionScope
        $this.startRange = $startRange
        $this.endRange = $endRange
        $this.startExclusionRange = $startExclusionRange
        $this.endExclusionRange = $endExclusionRange
        $this.leaseDuration = $leaseDuration
    }

    [void]ConfigureDHCP() 
    {
        # DHCP service configuration 
        # - Set up new scope
        # - 

        Add-DhcpServerv4Scope -Name $this.scopeName -Description $this.descriptionScope -StartRange $this.startRange -EndRange $this.endRange -SubnetMask $this.subnetMask -State Active
        Set-DhcpServerv4OptionValue -ScopeId $this.startRange.Split('.')[0..2] -join '.' + ".0" -OptionId 3 -Value $this.defaultGateway
        Set-DhcpServerv4OptionValue -ScopeId $this.startRange.Split('.')[0..2] -join '.' + ".0" -OptionId 6 -Value $this.ipAddress
        Set-DhcpServerv4OptionValue -ScopeId $this.startRange.Split('.')[0..2] -join '.' + ".0" -OptionId 15 -Value $this.domainName
    }

    [void]userClassDHCP()
    {

    }
}

function Get-Menu 
{
    Clear-Host
    Write-Host "+==============+"
    Write-Host "|     Menu     |"
    Write-Host "+==============+"
    Write-Host "1. Basic Server Configuration"
    Write-Host "2. DHCP Configuration"
    Write-Host "3. AD Configuration"
    Write-Host "4. GPO Configuration"
    Write-Host "5. Exit"
    Write-Host "====================="
}

function main 
{
    param (
        [System.Net.IPAddress]$ipAddress,
        [System.Net.IPAddress]$defaultGateway,
        [string]$hostname
    )

    $myServer = [WindowsServer]::new($ipAddress, $defaultGateway, $hostname)

    do {
        Get-Menu
        $choice = Read-Host "Enter your choice (1-5)"
        switch ($choice) {
            1 {
                $myServer.ConfigureServer()
                pause
            }
            2 {

            }
            3 {

            }
            4 {

            }
            5 {
                Write-Host "Exiting..."
                break
            }
            default {
                Write-Host "Invalid choice ... Please retry."
                Pause
            }
        }

    } while ($choice -ne 5)
}
