# Banner
function banner {

	$banner = @()
	$banner += ''
    	$banner += '             _        _____   _____'
	$banner += ' _____      | |_ ___ |  __ \ / ____|'
	$banner += '|  _  \/   \| __/ _ \| |  | | | '
	$banner += '| |_| ||(_) | || (_) | |__| | |____   [By Adrian Lujan Munoz (aka clhore)]'
	$banner += ' \__,_|\___/ \__\___/|_____/ \_____|'
	$banner += ''
	$banner | foreach-object {
		Write-Host $_ -ForegroundColor (Get-Random -Input @('Green','Cyan','gray','white'))
	}
}

# Configuracion de la red
$Global:ipParams = @{
    InterfaceIndex = 2 # Normalmente es el 2 si lo instalas en una maquina virtual pero revisalo con el comando Get-NetAdapter
    IPAddress = "192.168.188.125"
    DefaultGateway = "192.168.188.1"
    PrefixLength = 24
    AddressFamily = "IPv4"
}
$Global:dnsParams = @{
    InterfaceIndex = 2
    ServerAddresses = ("1.1.1.1","8.8.8.8")
}

# Configuracion del DC
$Global:namePc = 'LUJAN'
$Global:DomainNetbiosName = 'OSORNO'
$Global:domainName = 'OSORNO.IES'

# Usuarios a crear
$Global:ADUsers = @('amic1', 'amic2')
$Global:ADPasswords = @('P@ssw0rd', 'P@ssw0rd')

# Panel de ayuda
function helpPanel {

    banner

	Write-Output ''
    Write-Host '1. Importe los modulos:' -Foreground "yellow"
    Write-Output ''
    Write-Host '      - Import-Module .\autoDC.ps1' -Foreground "yellow"
    Write-Output ''
    Write-Host '2. Ejecute el comando redConfig'  -Foreground "yellow"
    Write-Output ''
	Write-Host "3. Ejecuta el comando namePc_and_domainServicesInstallation_1" -Foreground "yellow"
	Write-Output ''
    Write-Host "4. Tras el rpimer reinicio ejecute el comando domainServicesInstallation_2" -Foreground "yellow"
    Write-Host "      - En este punto equipo deberia quedar configurado como DC. " -Foreground "yellow"
    Write-Output ''
    Write-Host "5. Ejecute el comando createUsers" -Foreground "yellow"
    Write-Output ''

}

function redConfig {

    Set-NetIPInterface -InterfaceAlias Ethernet0 -Dhcp Disabled
    New-NetIPAddress @ipParams
    
    Set-DnsClientServerAddress @dnsParams

}

function namePc_and_domainServicesInstallation_1 {

    banner

    Write-Output ''
	Write-Host "[*] Instalando los servicios de dominio y configurando el dominio" -ForegroundColor "yellow"
	Write-Output ''

	Add-WindowsFeature RSAT-ADDS
	Install-WindowsFeature -Name AD-Domain-Services

    Import-Module ServerManager
	Import-Module ADDSDeployment

        Write-Output ''
	    Write-Host "[*] Cambiando el nombre de equipo a $namePc" -ForegroundColor "yellow"
        Write-Output ''

    Rename-Computer -NewName $namePc

    	Write-Output ''
	    Write-Host "[V] Nombre de equipo cambiado exitosamente, el quipo se va a reiniciar" -ForegroundColor "green"
	    Write-Output ''

        Start-Sleep -Seconds 5

	    Restart-Computer
}

function domainServicesInstallation_2 {
    Write-Output ''
    Write-Host "[*] A continuacion, deberas proporcionar la password del usuario Administrador del dominio" -ForegroundColor "yellow"
    Write-Output ''

    Try {

        Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\\Windows\\NTDS" -DomainMode "7" -DomainName $domainName -DomainNetbiosName $DomainNetbiosName -ForestMode "7" -InstallDns:$true -LogPath "C:\\Windows\\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\\Windows\\SYSVOL" -Force:$true 
    
    } Catch { Restart-Computer }

    Write-Output ''
    Write-Host "[!] Se va a reiniciar el equipo. Deberas iniciar sesion como el usuario Administrador a nivel de dominio" -ForegroundColor "red"
    Write-Output ''
}

function createUsers {

    $count = 0

    Foreach ($user in $ADUsers) {
        
		Write-Output ''
		Write-Host "[*] Creando el usuario >> $user" -ForegroundColor 'Cyan'
		Write-Output ''

		$username = $ADUsers[$count]
		$userPassword = $ADPasswords[$count]

		$secpass = ConvertTo-SecureString -String $userPassword -AsPlainText -Force
        Try {

            New-ADUser -Name $username -DisplayName 'nombre a mostra' -Enable $true -AccountPassword $secpass -SamAccountName $username  -UserPrincipalName $username
        
        } Catch { 
            Write-Output ''
	    Write-Host "[x] Error creando el usuario >> $user" -ForegroundColor 'Red'
	    Write-Output ''
        }
        
        $count += 1

    }
    
}
