#!/bin/bash
arch=$(uname -a)
numproc=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
numvcpu=$(nproc)
totram=$(free -m | awk '$1 == "Mem:" {print $2}')
usedram=$(free -m | awk '$1 == "Mem:" {print $3}')
puseram=$(free | awk '$1 == "Mem:" {printf("%.2f", $3/$2*100)}')
totdsk=$(df -Bg -t ext4 --total | grep 'total' | awk '{print $2}')
useddsk=$(df -BM -t ext4 --total | grep 'total' | awk '{print $3}')
pusedsk=$(df -t ext4 --total | grep 'total' | awk '{print $5}')
# this version of cpuload uses aggregated cpu runtime from boot
# not accurate in showing recent cpu usage load
# and if cpu has been up a long time, average will smooth out
#cpuload=$(grep "cpu" /proc/stat | awk '$1=="cpu"{
#	idle=$5;
#	for (i=2; i<=11; i++) {
#		sum += $i
#	}; 
#	printf("%.1f", (sum - idle) / sum * 100)
#}')

# install sysstat to use mpstat
cpuload=$(mpstat | awk '/all/{idle=$12;printf("%.1f", 100 - idle)}')
lstboot=$(who -b | awk '{print $3, $4}')
lvmuse=$(if [ $(lsblk | grep 'lvm' | wc -l) -eq 0 ]; then echo "no"; else echo "yes"; fi)
conntcp=$(ss -s | awk '/TCP:/{print $4}' | tr -d ',')
usrlog=$(users | wc -w)
ip=$(hostname -I)
mac=$(ip link | awk '/ether/{print $2}')
sudocmd=$(journalctl _COMM=sudo | grep 'COMMAND' | wc -l)

wall "	#Architecture: $arch
		#CPU physical : $numproc
		#vCPU : $numvcpu
		#Memory Usage: $usedram/${totram}MB ($puseram%)
		#Disk Usage: ${useddsk}B/${totdsk}B ($pusedsk%)
		#CPU load: $cpuload%
		#Last boot: $lstboot
		#LVM use: $lvmuse
		#Connections TCP : $conntcp ESTABLISHED
		#User log: $usrlog
		#Network: IP $ip ($mac)
		#Sudo : $sudocmd cmd
		"
