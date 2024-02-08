#!/bin/bash

   perl /root/configuration/extraInformacion/getCGCD_datos.pl
   sleep 1m
   perl /root/configuration/extraInformacion/getRecoleccion.pl
   sleep 1m
   perl /root/configuration/extraInformacion/getCancelados.pl
#   perl /root/configuration/extraInformacion/getGuia.pl
   perl /root/configuration/extraInformacion/getCorrida.pl
   perl /root/configuration/extraInformacion/getCorridaD.pl
   perl /root/configuration/extraInformacion/getGuiaComplemento.pl
   perl /root/configuration/extraInformacion/getBoletosDia.pl
   perl /root/configuration/extraInformacion/getGuiaDespacho.pl
   perl /root/configuration/extraInformacion/getTaller.pl

