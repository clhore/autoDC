<div align="center">
  <h1>autoDC</h1>
<h1>  	         _        _____   _____ </h1>
<h1>	          | |      |  __ \ / ____|</h1>
<h1>  __ _ _   _| |_ ___ | |  | | |     </h1>
<h1> / _` | | | | __/ _ \| |  | | |     </h1>
<h1>| (_| | |_| | || (_) | |__| | |____ </h1>  
<h1> \__,_|\__,_|\__\___/|_____/ \_____|</h1>
  <h4>Esta herramienta esta creada con el fin de automatizar la creación de un DC, la creación de grupos y usuarios utilizando PowerShell.</h4>
</div>
<ul>
    <li>Es te script es capaz de configurar la IP del Windows Server 2016 y los DNS, que previamente hallamos definido en el script.</li>
    <li>En los comentarios del script se puede encontrar también una pequeña explicación de como cambiar los servidores NTP del SO.</li>
</ul> 

Requisitos
======
Este escript está realizado para Windows Server 2016 por lo que si se ejecuta en otro sistema puede que ocasiones problemas al intentar crear el DC.


CONFIGURACION
======
<h4>INTERFAZ DE RED</h4>
<p>Debemos definir en el scriptlos siguientes parametros</p>
<ul>
    <li>ifIndex</li>
    <li>ipParam</li>
    <li>dnsParams</li>
</ul> 
<div align="center">
  <img src="img/conf/red.png">
</div>

<h4>NOMBRE DEL EQUIPO Y DOMINIO</h4>
<p>Debemos definir en el scriptlos siguientes parametros</p>
<ul>
    <li>namePc</li>
    <li>domainName</li>
</ul> 
<div align="center">
  <img src="img/conf/userDomain.png">
</div>
<h4>USUARIOS Y GRUPOS</h4>
<p>En este caso no es obligatorio rellenarlo. Y aque la creacion de grupos y usuarios desde el script de powershell no es obligatoria.</p>
<ul>
    <li>Usuarios:</li>
    <dl>
      <dt>ADUsers</dt>
      <dd>Nombre del usuario que se usara para iniciar sesion en el sistema.</dd>
      <dt>ADPasswords</dt>
      <dd>Contraseña de la cuenta de usuario.<dd>
      <dt>ADUserNames</dt>
      <dd>Nombre completo del usuario. Solo se puede poner el nombre y un apellido si pones dos apellidos, el 2º apellido no se usara.</dd>
    </dl>
    <li>Grupos:</li>
    <dl>
      <dt>ADGroups</dt>
      <dd>Nombre del grupo.</dd>
    </dl>
</ul> 
<div align="center">
  <img src="img/conf/userGrup.png">
</div>

Ejecucion del script PowerShell
======
<div align="center">
  <h4>Una vez ya hemos configurado todos los parametros necesarios, procedemos ha ejecutar PowerShell en Windows Server 2016 y importamos el modulo.</h4>
</div>

    Import-Module .\autoDC
    
<div align="center">
  <img src="img/autoDC_1.png">
</div>

<div align="center">
  <h4>Ejecutamos la funcion helpPanel. Y seguimos los pasos que nos indica.</h4>
</div>

    helpPanel
    
<div align="center">
  <img src="img/autoDC_2.png">
</div>

<div align="center">
  <h4>Configuramos la red, utilizando la funcion redConfig.</h4>
</div>

    redConfig
    
<div align="center">
  <img src="img/autoDC_3.png">
</div>

<div align="center">
  <h4>Ahora comenzamos con el cambio de nombre del equipo y con la parte 1 de la creacion del DC. Una vez acabe se reiniciara y deberas volver ha abrir PowerShell y importar el modulo.</h4>
</div>

    namePc_and_domainServicesInstallation_1
    
<div align="center">
  <img src="img/autoDC_4.png">
</div>

<div align="center">
  <h4>Una vez se ha reiniciado importamos el modulo otravez.</h4>
</div>

    Import-Module .\autoDC
    
<div align="center">
  <img src="img/autoDC_5.png">
</div>

<div align="center">
  <h4>Ejecutamos la parte dos de la creacion del DC. Una vez lo ejecutes te pedira la contraseña de Administrador. Cuando acabe se reiniciara.</h4>
</div>

    namePc_and_domainServicesInstallation_2
    
<div align="center">
  <img src="img/autoDC_6.png"><br>
  <img src="img/autoDC_7.png"><br>
  <img src="img/autoDC_8.png"><br>
</div>

<div align="center">
  <h4>Es posible que se quede en una pantalla de carga durante un largao periodo de tiempo, no apages el equipo y deja que acabe.</h4>
</div>
  
<div align="center">
  <img src="img/autoDC_9.png"><br>
</div>

<div align="center">
  <h4>Una vez inicie si no a aavido ningun error el equipo deveria de quedar configurado como un DC.</h4>
</div>
    
<div align="center">
  <img src="img/autoDC_10.png"><br>
</div>
