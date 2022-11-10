#===
#v0.3
#!/bin/bash
#requirements 
#this is mostly comments, isn't it...
#for testing, watch lsof nvidia*
#get processes utilizing nvidia driver units
procs=$(sudo lsof -w /dev/nvidia* |cut -f1 -d ' ')

#stop lightdm, bc that's DEF the only thing using nv drivers :O
sudo service lightdm stop
#loop to kill all processes using NV drivers
for proc in $procs
do
#while [ $proc != "COMMAND" ] ##looks like pkill will not complain about trying to kill ill-defined procs :3
#while [ 0=0 ]
##maybe test command instead of != 
#do
  sudo pkill -f $proc
done

#after processes are killed...
mods=$(lsmod |grep nvidia |cut -f1 -d ' ')
for mod in $mods
do
 sudo rmmod "$mod"
done

#restart lightdm service
sudo service lightdm start
#done

#sudo service lightdm start
#successfully kills them when no error. If error, however, need to kill any running apps using them.
#===