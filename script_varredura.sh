#!/bin/bash

clear

echo "##########################################"
echo "#   Validação de requisitos de servidor  #"
echo "##########################################"$'\n'$'\n'


echo "-------------------------"
echo "|    Validação de IP    |"
echo "-------------------------"
# Valida ip da maquina 
ip=`hostname -I | cut -f1 -d' '`
val=`ip -o -4 route show to default | awk '{print $5}'`
echo "IP da maquina: $ip"$'\n'

# Valida se o IP eh estatico ou dinamico
INTERFACE="`ip -o -4 route show to default | awk '{print $5}'`"

# Obtém informações sobre a interface
ip_info=$(ip r show dev $INTERFACE)

# Extrai a parte "static" usando awk
ip_type=$(echo "$ip_info" | awk '/proto static/{print $5}')

# Verifica se a interface tem um endereço IP estático

if [ "$ip_type" == "static" ]; then
    echo "Tipo do IP: IP é estático!."
else
    echo "Tipo do IP: Solicitar a configuração de IP estático, o mesmo está como dinâmico"
fi

echo $'\n'


################ Valida SO ################
echo "-------------------------"
echo "|    Validação de SO    |"
echo "-------------------------"
so=`cat /etc/*-release |grep DISTRIB_DESCRIPTION |cut -d "=" -f 2`
echo "Sistema operacional: $so"$'\n'


################ Valida Memoria RAM #######
echo "--------------------------"
echo "|Validação de memoria RAM|"
echo "--------------------------"
ram=`free --giga | awk '/^Mem/ {print $2}'`
if [ $ram -lt 16 ];then
	echo "O servidor está abaixo do requisito recomendado"
	echo "Memoria atual: $ram GB"
	echo "Solicitar a adequação!"
else 
	echo "O servidor está dentro do requisito"
	echo "Memoria atual: $ram GB"
fi
echo $'\n'

