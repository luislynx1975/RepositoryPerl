#!/bin/sh

i=1

while [ $i -lt 500 ]; do

    echo "Iniciando "
    date +"%T"
    perl /root/configuration/ventaProceso/boletosPrueba/prueba.pl
    echo "Termina el script"
    date +"%T"

    i=$(($i+1))
    sleep 100
    echo "despues del sleep"
    date +"%T"
done

