#!/bin/sh

i=1

while [ $i -lt 360 ]; do

    echo "Iniciando "
    date +"%T"

    perl /root/configuration/ventaProceso/setMueveBoletosMEX.pl
    echo "Termina el script"
    date +"%T"

    i=$(($i+1))
    echo "despues del sleep"
    date +"%T"
done
