#!/bin/sh

i=1

while [ $i -lt 150 ]; do

    echo "Iniciando "
    date +"%T"
    perl /root/configuration/extraInformacion/getTaller.pl


    echo "Termina el script"
    date +"%T"

#    i=$(($i+1))
    #sleep 1m
    echo "despues del sleep"
    date +"%T"
done

