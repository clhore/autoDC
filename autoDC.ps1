# Banner
function banner {

	$banner = @()
	$banner += ''
	$banner += '             _        _____   _____' 
	$banner += '            | |      |  __ \ / ____|'
	$banner += '  __ _ _   _| |_ ___ | |  | | |'     
	$banner += ' / _` | | | | __/ _ \| |  | | |'     
	$banner += '| (_| | |_| | || (_) | |__| | |____   [By Adrian Lujan Munoz (aka clhore)]' 
	$banner += ' \__,_|\__,_|\__\___/|_____/ \_____|'
	$banner += ''
	$banner | foreach-object {
	    Write-Host $_ -ForegroundColor (Get-Random -Input @('Cyan','Green','gray','white', 'yellow'))
	}
}

# comprobar servidor NTP
# $ w32tm /dumpreg /subkey:parameters
# sincronizar relog con la rediris (en este caso son los servidores de Valencia)
# $ w32tm /config /syncfromflags:manual /manualpeerlist:"EB-Valencia1.rediris.es EB-Valencia0.rediris.es" /update

# Configura los parametros de la interfaz
$Global:ifIndex = 2 # Revisalo con el comando Get-NetAdapter

# Configuracion de la red
$Global:ipParams = @{
    InterfaceIndex = $ifIndex
    IPAddress = "192.168.188.125"
    DefaultGateway = "192.168.188.1"
    PrefixLength = 24
    AddressFamily = "IPv4"
}
$Global:dnsParams = @{
    InterfaceIndex = $ifIndex
    ServerAddresses = ("8.8.8.8","8.8.4.4")
}

# Configuracion del DC
$Global:namePc = 'LUJAN'
$Global:domainName = 'OSORNO.IES'

# Usuarios a crear
$Global:ADUsers = @('alujan', 'amic2')
$Global:ADPasswords = @('P@ssw0rd', 'P@ssw0rd')
$Global:ADUserNames = @('Adrian Lujan', '')

# Grupos a crear
$Global:ADGroups = @('G_PRUEBA', 'G_PRUEBA2', 'G_PRUEBA3')
$Global:GroupScopeSelect = @('DomainLocal', 'DomainLocal', 'DomainLocal')

# Panel de ayuda
function helpPanel {

    banner
    
    $textColor = 'Green'
    $textColor2 = 'yellow'


    Write-Output ''
    Write-Host '    1. Importe los modulos:' -Foreground $textColor
    Write-Output ''
    Write-Host '          - Import-Module .\autoDC.ps1' -Foreground $textColor2
    Write-Output ''
    Write-Host '    2. Ejecute el comando redConfig'  -Foreground $textColor
    Write-Output ''
    Write-Host "    3. Ejecuta el comando namePc_and_domainServicesInstallation_1" -Foreground $textColor
    Write-Output ''
    Write-Host "    4. Tras el rpimer reinicio ejecute el comando domainServicesInstallation_2" -Foreground $textColor
    Write-Output ''
    Write-Host "          - En este punto equipo deberia quedar configurado como DC. " -Foreground $textColor2
    Write-Output ''
    Write-Host "    5. Ejecute el comando createUsers para crear los usuarios que previamente has configurado" -Foreground $textColor
    Write-Output ''
    Write-Host "    6. Ejecute el comando createGroup para crear los grupos que previamente as configurado" -Foreground $textColor
    Write-Output ''

}

function redConfig {

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

        $confAD = @{
            CreateDnsDelegation = $false
            DatabasePath = "C:\\Windows\\NTDS" 
            DomainMode = "7" 
            DomainName = $domainName 
            DomainNetbiosName = $domainName | %{ $_.Split('.')[0]; }
            ForestMode = "7" 
            InstallDns = $true
            LogPath = "C:\\Windows\\NTDS" 
            NoRebootOnCompletion = $false
            SysvolPath = "C:\\Windows\\SYSVOL" 
            Force = $true
        }
        
        Install-ADDSForest @confAD
        
        #Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "C:\\Windows\\NTDS" -DomainMode "7" -DomainName $domainName -DomainNetbiosName $DomainNetbiosName -ForestMode "7" -InstallDns:$true -LogPath "C:\\Windows\\NTDS" -NoRebootOnCompletion:$false -SysvolPath "C:\\Windows\\SYSVOL" -Force:$true 

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
        
		$givenName = $ADUserNames[$count] | %{ $_.Split(' ')[0]; }
		$surName = $ADUserNames[$count] | %{ $_.Split(' ')[1]; }
		$userPassword = $ADPasswords[$count]

		$secpass = ConvertTo-SecureString -String $userPassword -AsPlainText -Force

        Try {

            $confUser = @{
                Name = $user 
                GivenName = $givenName 
                Surname = $surName 
                UserPrincipalName = $user
                SamAccountName = $user 
                AccountPassword = $secpass
                ChangePasswordAtLogon = $False
                DisplayName = $ADUserNames[$count]
                Enabled = $True
            }

            New-ADUser @confUser
        
        } Catch { 
            Write-Output ''
	    Write-Host "[x] Error creando el usuario >> $user" -ForegroundColor 'Red'
	    Write-Output ''
        }
        
        $count += 1

    }
    
}

function createGroup {

    $count = 0

    Foreach ($GroupName in $ADGroups) {
        
		Write-Output ''
		Write-Host "[*] Creando el grupo >> $GroupName" -ForegroundColor 'Cyan'
		Write-Output ''

        Try {

            $DC1 = $domainName | %{ $_.Split('.')[0]; }
            $DC2 = $domainName | %{ $_.Split('.')[1]; }

            $confGrup = @{
                Name = $GroupName
                GroupScope = $GroupScopeSelect[$count]
                Path = "CN=Users,DC=$DC1,DC=$DC2"    
            }

            New-ADGroup @confGrup
        
        } Catch { 
            Write-Output ''
	    Write-Host "[x] Error creando el grupo >> $GroupName" -ForegroundColor 'Red'
	    Write-Output ''
        }
        
        $count += 1

    }
    
}
