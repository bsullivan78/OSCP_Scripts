#!/bin/bash 

#checks for proper format
if [ -z $1 ]
then	
	echo "Requires IP Ex: \"StartScan.sh 1.1.1.1\""
	exit
fi

#find the ip and create a folder with nessasary files
h=$(echo $1 | cut -d'.' -f4)
loc="/home/kali/Documents/"${h}		#change to which directory to use.
mkdir $loc
cd $loc
touch scratch.txt
touch process.txt
echo "Port Scan" >> ./process.txt

#nmap syn scan
sudo nmap -sS $1 -p1-65535 -oN "${h}sN.txt"

declare -a ports
while IFS= read -r line; do
	if [[ $line == *"open"* ]]; then
		p=$(echo $line | cut -d'/' -f1)
		ports+="${p},"
	fi
done < ./${h}sN.txt
str=${ports[*]}

#nmap Version scan
sudo nmap -sV $1 -p${str%?} -oN "${h}sV.txt"

mousepad ./${h}sV.txt
exit
