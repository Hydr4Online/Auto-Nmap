#!/bin/bash

# Colours

greenCl="\e[0;32m\033[1m"
endCl="\033[0m\e[0m"
redCl="\e[0;31m\033[1m"
blueCl="\e[0;34m\033[1m"
yellowCl="\e[0;33m\033[1m"
purpleCl="\e[0;35m\033[1m"
turquoiseCl="\e[0;36m\033[1m"
grayCl="\e[0;37m\033[1m"

trap ctrl_c INT

function ctrl_c(){

clear
tput civis
salida
sleep 0.5
tput cnorm
exit 1

}


function banner(){

clear
sleep 0.090
echo -e "$greenCl  ___        _          _   _                       $endCl"
sleep 0.090
echo -e "$greenCl / _ \      | |        | \ | |                      $endCl"
sleep 0.090
echo -e "$greenCl/ /_\ \_   _| |_ ___   |  \| |_ __ ___   __ _ _ __  $endCl"
sleep 0.090
echo -e "$greenCl|  _  | | | | __/ _ \  | . \` | '_ \` _ \ / _\` | '_ \ $endCl"
sleep 0.090
echo -e "$greenCl| | | | |_| | || (_) | | |\  | | | | | | (_| | |_) |$endCl"
sleep 0.090
echo -e "$greenCl\_| |_/\__,_|\__\___/  \_| \_/_| |_| |_|\__,_| .__/ $endCl"
sleep 0.090
echo -e "$greenCl                                             | |    $endCl"
sleep 0.090
echo -e "$greenCl                                             |_|    $endCl"
sleep 0.1

}

function tab(){

  read -p "$( echo -e "\n${greenCl}Presiona enter para continuar${endCl}" )"

}


function Menu(){

  echo -e "${grayCl}Que tipo de escaneo deseas hacer${endCl}\n"
  echo -e "${grayCl}tcp)${endCl}"
  echo -e "${grayCl}udp)${endCL}"
  echo -e "${grayCl}exit)${endCl}"

}

function tcp(){

  local IP
  local OPTION
  local ARCHIVO
  local CONTENIDO
  local SCV
  local PUERTOS

  echo -e "${yellowCl}Has elegido escaneo tcp${endCl}\n"

  read -p "$( echo -e "${grayCl}Ingresa la ip de la maquina victima: ${endCl}")" IP

  read -p "$( echo -e "${grayCl}Deseas guardar tu escaneo en un archivo yay/nay: ${endCl}")" OPTION

  if [ $OPTION == "yay" ]; then

    read -p "$( echo -e "${grayCl}Que nombre deseas ponerle al archivo: ${endCl}")" ARCHIVO

    read -p "$( echo -e "${grayCl}Mirar por pantalla el contenido del escaneo yay/nay: ${endCl}")" CONTENIDO

    if [ $CONTENIDO == "yay" ]; then

    clear
    sudo nmap -p- --open --min-rate 2000 -sS -Pn -n -vvv $IP -oG $ARCHIVO 

    echo -e "\n${redCl}[+] Escaneo terminado ${endCl}"

    read -p "$( echo -e "\n${greenCl}Presiona enter para continuar${endCl}")"

    clear
    
    PUERTOS=$(cat $ARCHIVO | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')  

    echo -e "${grayCl}Puertos encontrados a escanear: ${PUERTOS} ${endCl}"
    read -p "$(echo -e "${grayCl}nombre del archivo de versiones y servicios: ${endCl}")" SCV

    clear

    nmap -p$PUERTOS -sCV -Pn -n $IP -oN $SCV 

    echo -e "\n${redCl}[!] Escaneo terminado revisa tus archivos ${endCl}"
    
    elif [ $CONTENIDO == "nay" ]; then
    
    echo -e "${grayCl}[+] Escanenando los 65535 puertos existentes${endCL}"
    sudo nmap -p- --open --min-rate 2000 -sS -Pn -n -vvv $IP -oG $ARCHIVO &>/dev/null
    echo -e "\n${redCl}[!] Escaneo terminado ${endCL}"

    read -p "$( echo -e "\n${greenCl}Presiona enter para continuar${endCl}")"

    clear
    
    PUERTOS=$(cat $ARCHIVO | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')  

    echo -e "${grayCl}Puertos encontrados a escanear: ${PUERTOS} ${endCl}"
    read -p "$(echo -e "${grayCl}nombre del archivo de versiones y servicios: ${endCl}")" SCV
    #read -p "$(echo -e "${grayCl}Puertos a escanear separados por una coma: ")" PUERTOS
    echo -e "${grayCl}[+] Escaneando versiones y servicios de los puertos:${endCl} $PUERTOS"
    nmap -p$PUERTOS -sCV -Pn -n $IP -oN $SCV &>/dev/null

    echo -e "\n${redCl}[!] Escaneo terminado revisa tus archivos ${endCl}"
    
    else 
    
    clear
    echo -e "${grayCl}[!] Opcion invalida Verifica escribir${endCl} ${redCl}yay/nay${endCl}"
    sleep 2
    clear

    fi

  elif [ $OPTION == "nay" ]; then

    clear

    echo -e "${greenCl}[+] Escaneando la ip ${IP}${endCl}\n"

    sudo nmap -p- --open --min-rate 2000 -sS -Pn -n -vvv $IP -oG escaneo

    read -p "$( echo -e "\n${greenCl}Presiona enter para continuar${endCl}")"

    clear

    PUERTOS=$(cat escaneo | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')  

    echo -e "${greenCl}[+] Escaneando versiones y servicios de los puertos encontrados${endCl}\n"

    nmap -p$PUERTOS -sCV -Pn -n $IP

    echo -e "\n${redCl}[!] Escaneo terminado ${endCl}" 

    rm -rf escaneo

  else
    clear
    echo -e "${grayCl}[!] Opcion invalida verifica escribir${endCl} ${redCl}yay/nay${endCl}"
    sleep 2
    clear
    tcp

  fi

}

function salida(){

echo -e "${grayCl}                    ___.-------.___               ${endCl}"
echo -e "${grayCl}                _.-´ ___.--;--.___ \`-._          ${endCl}"
echo -e "${grayCl}             .-´ _.-´  /  .|.  \\  \`-._ \`-.     ${endCl}"
echo -e "${grayCl}           .´ .-´      |---o---|      \`-. \`.    ${endCl}"
echo -e "${grayCl}         <(_ < __      \\  \`|´  /      __ > _)>   ${endCl}"
echo -e "${grayCl}            \`--._\`\`-..__\`._|_.´__..-´´_.--´   ${endCl}"
echo -e "${grayCl}                  \`\`--._________.--´´           ${endCl}"

}

function main(){
  
  clear
  banner
  clear

  while true; do
  
  clear
  Menu
  read -p "$( echo -e "\n${redCl}Escribe tu opcion deseada: ${endCl}")" option

  case "$option" in 

  tcp)
    clear
    tcp
    tab
  ;;

  udp)
    clear
    tcp
    tab
  ;;

  exit)
    clear
    tput civis
    salida
    sleep 1
    tput cnorm
    exit 1
  ;;

  *)
    
    clear
    echo -e "${redCl}[!] Opcion no valida${endCl}"
    sleep 2

  ;;

  esac
  done
}

main

