#!/bin/sh

i=1

while [ $i -lt 3000 ]; do

    echo "Iniciando "
    date +"%T"
    perl /root/configuration/ventaProceso/boleto_asigna_2017.pl
    echo "Termina el script"
    date +"%T"

    i=$(($i+1))
    sleep 1m
    echo "despues del sleep"
    date +"%T"
done
