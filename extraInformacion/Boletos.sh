#!/bin/sh

i=1

while [ $i -lt 200 ]; do

    echo "Iniciando "
    date +"%T"
    perl /root/configuration/extraInformacion/getBoletosDia.pl
    echo "Termina el script"
    date +"%T"

#    i=$(($i+1))
    #sleep 1m
    echo "despues del sleep"
    date +"%T"
done

