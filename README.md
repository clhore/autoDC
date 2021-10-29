<div align="center">
  <h1>autoDC</h1>
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
