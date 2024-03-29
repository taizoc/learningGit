#!/bin/bash
#v0.3.1
#features to add: 
##detect and stop services envoking any processes touching nvidia driver units. (is that wording right?) 
##catch if lightdm is running or not. don't stop it unless necessary. that's embarassing. 
#requirements for specific OS version? 
#this thing is mostly comments, isn't it... 
###for testing, watch sudo lsof /dev/nvidia* 
###for testing lightdm watch sudo service lightdm status 

#get processes utilizing nvidia driver units 
procs=$(sudo lsof -w /dev/nvidia* |cut -f1 -d ' ')

#stop lightdm, bc that's DEF the only thing using nv drivers :O
######lightdm=$(systemctl is-active lightdm|grep in)
sudo service lightdm stop
##this will throw an error if service doesn't exist... but that seems to be OK. 
#loop to kill all processes using NV drivers
for proc in $procs
do
#while [ $proc != "COMMAND" ]
#do 
  sudo pkill -f $proc
  ##looks like pkill will not complain about trying to kill ill-defined procs "COMMAND" :3 
done
#after processes are killed... get names of NV driver units to rmmod  
mods=$(lsmod |grep nvidia |cut -f1 -d ' ')
for mod in $mods
do
 sudo rmmod "$mod"
done

#start lightdm service
sudo service lightdm start
##will also throw error but not matter if service doesn't exist on the system. 
# looks like lightdm isn't consistently restarting. this really needs to be "only if it's running, sleep 5 and check again"
