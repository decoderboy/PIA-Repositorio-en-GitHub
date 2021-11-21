#!/bin/bash 
FECHA=`date +"%a %d %b %Y"`
HORA=`date +"%X"`
echo -e "\e[32m$FECHA $HORA \e[0m"
# Definimos el menú 
echo "---------------------------"
echo "    Menu Principal"
echo "---------------------------"
PS3="Selecciona una opcion: "
select opt in "Net Discover" "Actual User" "Hostname" "Exit"; 
do 
	case $opt in 
		"Net Discover")
		#!/bin/bash
		#
		# Escaner de red basico en BASH
		#
		# Determinando el segmento de red
		which ifconfig && { echo "Comando ifconfig existe...";
							direccion_ip=`ifconfig |grep -w inet |grep -v "127.0.0.1" |awk '{ print $2}'`;
							echo " Esta es tu direccion ip: "$direccion_ip;
							subred=`ifconfig |grep -w inet |grep -v "127.0.0.1" |awk '{ print $2}'|awk -F. '{print $1"."$2"."$3"."}'`;
							echo " Esta es tu subred: "$subred;
							}\
						|| { echo "No existe el comando ifconfig...usando ip ";
							direccion_ip=`ip addr show |grep -w inet | grep -v "127.0.0.1" |awk '{ print $2}'`;
							echo " Esta es tu direccion ip: "$direccion_ip;
							subred=`ip addr show |grep -w inet | grep -v "127.0.0.1" |awk '{ print $2}'|awk -F. '{print $1"."$2"."$3"."}'`;
							echo " Esta es tu subred: "$subred;
							}
		for ip in {1..254}
		do
			ping -q -c 4 ${subred}${ip} > /dev/null
			if [ $? -eq 0 ]
			then
				echo "Host responde: " ${subred}${ip}
			fi
		done
;;
		"Actual User")
						whoami
;;
		"Hostname")
					hostname
;;
		"Exit")
				echo "Saliendo..."
				break
;;
		*)
			echo "No es una opcion valida"
;;
	esac 
done