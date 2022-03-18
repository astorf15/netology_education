#!/bin/bash
d=`date`
log=~/scripts/error.log
hosts=(192.168.0.1 173.194.222.113 87.250.250.242)
while [ 1 == 1 ]
do
    for h in ${hosts[@]} 
    do
        nc -znvw3 $h 80  &> /dev/null
        if (($? != 0))
        then
                 echo " $h  Порт не доступен " $d  >> $log ; exit  
        fi
    sleep 2
    done 
done