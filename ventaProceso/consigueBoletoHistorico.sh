#!/bin/sh
perl /root/configuration/ventaProceso/getBoletosCorporativo.pl
sleep(10);
perl /root/configuration/ventaProceso/setGuiaUpdateLCorpo.pl
