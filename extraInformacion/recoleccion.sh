#!/bin/sh

i=1

while [ $i -lt 1000 ]; do

    echo "Iniciando "
    date +"%T"
    perl /root/configuration/extraInformacion/getRecoleccion.pl
    echo "Termina el script"
    date +"%T"

#    i=$(($i+1))
    echo "despues del sleep"
    date +"%T"
done

