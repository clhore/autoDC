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
    <li>namePc</li>
    <li>domainName</li>
</ul> 
<div align="center">
  <img src="img/conf/userGrup.png">
</div>
