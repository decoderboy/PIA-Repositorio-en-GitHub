#Escaneo de puertos activos en la red
#
# Elaborado por: Ivan Eduardo Reyes Garcia
# Matricula: 1918865
#
Write-host Menú
Write-host ====
Write-host "1) Escaneo de toda la subred."
Write-host "2) Escaneo de puertos para un equipo o dirección ip en particular"
Write-host "3) Escaneo de puertos para todos los equipos que estén activos en la red."
Write-host "4) Salir"
$opcion = Read-Host
switch($opcion)
{
	1 {
	#Escaneo de equipos activos en la red
	#
	# Determinando gateway
	$subred = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
	Write-Host "== Determinando tu gateway ..."
	Write-Host "Tu gateway: $subred"
	#
	## Determinando rango de subred
	#
	$rango = $subred.Substring(0,$subred.IndexOf('.') + 1 + $subred.Substring($subred.IndexOf('.') + 1).IndexOf('.') + 3)
	Write-Host "== Determinando tu rango de subred ..."
	echo $rango
	#
	## Determinando si $rango termina en "."
	## En ocasiones el rango de subred no termina en punto, necesitamos forzarlo.
	#
	$punto = $rango.EndsWith('.')
	if ( $punto -like "False" )
	{
	    $rango = $rango +  '.' #agregamos el punto en caso de que no estuviera.
	}
	#
	## Creamos un array con 254 numeros ( 1 a 254) y se almacenan
	## En una variable que se llamara $rango_ip
	#
	$rango_ip = @(1..254)
	#
	## Generamos bucle foreach para validar hosts activos en nuestra subred.
	#
	Write-Output ""
	Write-Host "-- Subred actual:"
	Write-Host "Escaneando: " -NoNewline ; Write-Host $rango -NoNewline; Write-Host "0/24" -ForegroundColor Red
	Write-Output ""
	foreach ( $r in $rango_ip )
	{
	    $actual = $rango + $r # se genera dirección ip
	    $responde = Test-Connection $actual -Quiet -Count 1 #Validamos conexión contra ip actual.
	    if ( $responde -eq "True" )
	    {
	        Write-Output ""
	        Write-Host "Host responde: " -NoNewline; Write-Host $actual -ForegroundColor Green
	    }
	}
	#
	## Fin del script
	#
	}
	2 {
	#Escaneo de puertos activos en la red
	#
	# Determinando gateway
	$subred = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
	Write-Host "== Determinando tu gateway..."
	Write-Host "Tu gateway: $subred"
	#
	## Determinando rango de subred
	#
	$rango = $subred.Substring(0,$subred.IndexOf('.') + 1 + $subred.Substring($subred.IndexOf('.') + 1).IndexOf('.') + 3)
	Write-Host "== Determinando tu rango de subred..."
	echo $rango
	#
	## Determinando si $rango termina en "."
	## En ocasiones el rango de subred no termina en punto, necesitamos forzarlo.
	#
	$punto = $rango.EndsWith('.')
	if ( $punto -like "False" )
	{
	    $rango = $rango +  '.' #agregamos el punto en caso de que no estuviera.
	}
	#
	## Definimos un array con puertos a escanear
	## Establecemos una variable para waittime
	#
	$portstoscan = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
	$waittime = 100
	#
	## Solicitamos dirección ip a escanear
	#
	Write-Host "Direccion ip a escanear:" -NoNewline
	$direccion = Read-Host
	#
	## Generamos bucle foreach para evaluar cada puerto en $portscan
	#
	foreach ( $p in $portstoscan )
	{
		$TCPObject = new-object System.Net.Sockets.TcpClient
			try{ $resultado = $TCPObject.ConnectAsync($direccion,$p).Wait($waittime)}catch{}
			if ( $resultado -eq "True")
			{
				Write-Host "Puerto abierto: " -NoNewline; Write-Host $p -ForegroundColor Green
			}
	}
	}
	3 {
	#Escaneo de puertos para todos los equipos que estén activos en la red.
	#
	# Determinando gateway
	$subred = (Get-NetRoute -DestinationPrefix 0.0.0.0/0).NextHop
	Write-Host "== Determinando tu gateway ..."
	Write-Host "Tu gateway: $subred"
	#
	## Determinando rango de subred
	#
	$rango = $subred.Substring(0,$subred.IndexOf('.') + 1 + $subred.Substring($subred.IndexOf('.') + 1).IndexOf('.') + 3)
	Write-Host "== Determinando tu rango de subred ..."
	echo $rango
	#
	## Determinando si $rango termina en "."
	## En ocasiones el rango de subred no termina en punto, necesitamos forzarlo.
	#
	$punto = $rango.EndsWith('.')
	if ( $punto -like "False" )
	{
	    $rango = $rango +  '.' #agregamos el punto en caso de que no estuviera.
	}
	#
	## Creamos un array con 254 numeros ( 1 a 254) y se almacenan
	## En una variable que se llamara $rango_ip
	#
	$rango_ip = @(100..120)
	#
	## Definimos un array con puertos a escanear
	## Establecemos una variable para waittime
	#
	$portstoscan = @(20,21,22,23,25,50,51,53,80,110,119,135,136,137,138,139,143,161,162,389,443,445,636,1025,1443,3389,5985,5986,8080,10000)
	$waittime = 100
	## Generamos bucle foreach para validar y escanear cada puertos en cada host activo.
	#
	Write-Output ""
	Write-Host "-- Subred actual:"
	Write-Host "Escaneando: " -NoNewline ; Write-Host $rango -NoNewline; Write-Host "0/24" -ForegroundColor Red
	Write-Output ""
	foreach ( $r in $rango_ip )
	{
	    $actual = $rango + $r # se genera dirección ip
	    $responde = Test-Connection $actual -Quiet -Count 1 #Validamos conexión contra ip actual.
	    if ( $responde -eq "True" )
	    {
	        Write-Output ""
	        Write-Host "Host responde: " -NoNewline; Write-Host $actual -ForegroundColor Green
	        foreach ( $p in $portstoscan )
			{
				$TCPObject = new-object System.Net.Sockets.TcpClient
					try{ $resultado = $TCPObject.ConnectAsync($actual,$p).Wait($waittime)}catch{}
					if ( $resultado -eq "True")
					{
						Write-Host "Puerto abierto: " -NoNewline; Write-Host $p -ForegroundColor Green
					}
			}
	    }
	}
	#
	## Fin del script
	#
	}
	4 {exit;break}
	default {break}
}