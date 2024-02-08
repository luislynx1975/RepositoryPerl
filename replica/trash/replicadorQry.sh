#!/bin/bash

# Script que replica querys
# 2016-06-10
# Pullman de Morelos.

terminal=('172.16.100.14' '192.168.1.16' '192.168.12.5' '192.168.15.53' '192.168.19.11' '192.168.19.13' '192.168.19.14' '192.168.19.16' '192.168.19.17' '192.168.19.18' '192.168.19.20' '192.168.19.21' '192.168.19.22' '192.168.19.23' '192.168.19.28' '192.168.19.29' '192.168.19.33' '192.168.19.34' '192.168.19.35' '192.168.19.36' '192.168.19.37' '192.168.19.42' '192.168.19.44' '192.168.19.45' '192.168.19.46' '192.168.19.47' '192.168.19.48' '192.168.19.49' '192.168.19.50' '192.168.19.51' '192.168.19.52' '192.168.19.55' '192.168.19.59' '192.168.19.60' '192.168.19.62' '192.168.19.63' '192.168.19.74' '192.168.19.75' '192.168.19.76' '192.168.19.81' '192.168.19.85' '192.168.19.87' '192.168.19.88' '192.168.21.22' '192.168.21.23' '192.168.21.24' '192.168.5.5' '192.168.6.5' '192.168.7.5' '192.168.9.5')
nombre=('MOV' 'HTR' 'PTEI' 'VGL' 'BVCU' 'COA' 'GAL' 'IMS' 'JIU' 'MIA' 'TJL' 'TEJ' 'TMF' 'ZAC' 'TCS' 'CTC' 'IGU' 'CUAT' 'OAX' 'CUC' 'JOJU' 'EZA' 'XOH' 'XCO' 'MZT' 'TET' 'ALC' 'XOA' 'COR' 'CPT' 'GRU' 'IXS' 'SCA' 'TLAYA' 'CPC' 'COT' 'SD1' 'SD2' 'JOJ' 'DIEZ' 'ZHT' 'APA' 'CHI' 'AMC' 'VAC' 'MDO' 'MEX' 'CUE' 'CSE' 'CUA')
descripcion=('MOVIL' 'HOTEL ROYAL' 'TER PUENTE DE IXTLA' 'VERGEL' 'TER BUENA VISTA DE CUELLAR' 'COATLAN DEL RIO' 'GALEANA' 'DRAGON IMSS' 'JIUTEPEC' 'MIACATLAN' 'TEJALPA' 'TER TEJALPA' 'TRES MARIAS FEDERAL' 'ZACATEPEC' 'TER MEXICO TAXQUEÑA' 'CENTRO TURISTICO CUERNAVACA' 'TER IGUALA' 'TER CUAUTLIXCO' 'TER OAXTEPEC' 'TER CUERNAVACA' 'TER JOJUTLA' 'EMILIANO ZAPATA' 'XOCHITEPEC' 'EXHACIENDA TEMIXCO' 'MAZATEPEC' 'TETECALA' 'ALPUYECA CASETA' 'XOXOCOTLA 2' 'CRUCERO CORONA' 'CRUCERO PUENTE DE IX' 'GRUTAS' 'IXTAPAN DE LA SAL' 'TER SAN CARLOS' 'TER TLAYACAPAN' 'CUENTEPEC' 'COATETELCO' 'SEDENA 1' 'SEDENA 2' 'JOJUTLA' 'DIEZ' 'ZONA DE HOSPITALES' 'APATLACO' 'CHICONCUAC' 'AMACUZAC' 'CIVAC' 'MERCADO ALM' 'MEXICO TAXQUEÑA' 'CUERNAVACA' 'TER CASINO DE LA SELVA' 'TER CUAUTLA' )


#terminal=('172.16.100.14' '192.168.1.16' '192.168.1.16' '192.168.12.5' '192.168.13.5' '192.168.15.53' '192.168.19.10' '192.168.19.11' '192.168.19.12' '192.168.19.13' '192.168.19.14' '192.168.19.16' '192.168.19.17' '192.168.19.18' '192.168.19.20' '192.168.19.21' '192.168.19.22' '192.168.19.23' '192.168.19.28' '192.168.19.29' '192.168.19.33' '192.168.19.34' '192.168.19.35' '192.168.19.36' '192.168.19.41' '192.168.19.42' '192.168.19.44' '192.168.19.45' '192.168.19.46' '192.168.19.47' '192.168.19.48' '192.168.19.49' '192.168.19.50' '192.168.19.51' '192.168.19.52' '192.168.19.55' '192.168.19.59' '192.168.19.60' '192.168.19.62' '192.168.19.63' '192.168.19.74' '192.168.19.82' '192.168.19.85' '192.168.19.87' '192.168.19.88' '192.168.5.5' '192.168.6.5' '192.168.7.5' '192.168.9.5')
#nombre=('MOV' 'AER' 'HTR' 'PTEI' 'JOJ' 'VGL' 'AMC' 'BVCU' 'VAC' 'COA' 'GAL' 'IMS' 'JIU' 'MIA' 'TJL' 'TEJ' 'TMF' 'ZAC' 'TCS' 'CTC' 'IGU' 'CUAT' 'OAX' 'CUC' 'PSF' 'EZA' 'XOH' 'XCO' 'MZT' 'TET' 'ALC' 'XOA' 'COR' 'CPT' 'GRU' 'IXS' 'SCA' 'TLAYA' 'CPC' 'COT' 'SD1' 'MDO' 'ZHT' 'APA' 'CHI' 'MEX' 'CUE' 'CSE' 'CUA')
#descripcion=('MOVIL' 'AEROPUERTO' 'HOTEL ROYAL' 'TER PUENTE DE IXTLA' 'JOJUTLA' 'VERGEL' 'AMACUZAC' 'TER BUENA VISTA DE CUELLAR' 'CIVAC' 'COATLAN DEL RIO' 'GALEANA' 'DRAGON IMSS' 'JIUTEPEC' 'MIACATLAN' 'TEJALPA' 'TER TEJALPA' 'TRES MARIAS FEDERAL' 'ZACATEPEC' 'TER MEXICO TAXQUEÑA' 'CENTRO TURISTICO CUERNAVACA' 'TER IGUALA' 'TER CUAUTLIXCO' 'TER OAXTEPEC' 'TER CUERNAVACA' 'PATIO SANTA FE' 'EMILIANO ZAPATA' 'XOCHITEPEC' 'EXHACIENDA TEMIXCO' 'MAZATEPEC' 'TETECALA' 'ALPUYECA CASETA' 'XOXOCOTLA 2' 'CRUCERO CORONA' 'CRUCERO PUENTE DE IX' 'GRUTAS' 'IXTAPAN DE LA SAL' 'TER SAN CARLOS' 'TER TLAYACAPAN' 'CUENTEPEC' 'COATETELCO' 'SEDENA 1' 'MERCADO ALM' 'ZONA DE HOSPITALES' 'APATLACO' 'CHICONCUAC' 'MEXICO TAXQUEÑA' 'CUERNAVACA' 'TER CASINO DE LA SELVA' 'TER CUAUTLA')

#SOLO TER
#terminal=('192.168.19.11' '192.168.7.5' '192.168.9.5' '192.168.19.34' '192.168.19.36' '192.168.19.33' '192.168.19.37' '192.168.19.35' '192.168.12.5' '192.168.19.59' '192.168.19.28' '192.168.19.21' '192.168.19.60')
#nombre=('BVCU' 'CSE' 'CUA' 'CUAT' 'CUC' 'IGU' 'JOJU' 'OAX' 'PTEI' 'SCA' 'TCS' 'TEJ' 'TLAYA')
#descripcion=('TER BUENA VISTA DE CUELLAR' 'TER CASINO DE LA SELVA' 'TER CUAUTLA' 'TER CUAUTLIXCO' 'TER CUERNAVACA' 'TER IGUALA' 'TER JOJUTLA' 'TER OAXTEPEC' 'TER PUENTE DE IXTLA' 'TER SAN CARLOS' 'TER MEXICO TAXQUEÑA' 'TER TEJALPA' 'TER TLAYACAPAN')

#SOLO PULLMAN

#SOLO PEQUEÑOS
#terminal=('192.168.1.17' '192.168.15.53' '192.168.19.10' '192.168.19.11' '192.168.19.12' '192.168.19.13' '192.168.19.14' '192.168.19.16' '192.168.19.17' '192.168.19.18' '192.168.12.5' '192.168.19.20' '192.168.19.21' '192.168.19.22' '192.168.19.23' '192.168.19.28' '192.168.19.29' '192.168.19.33' '192.168.19.34' '192.168.19.35' '192.168.19.36' '192.168.19.41' '192.168.19.42' '192.168.19.44' '192.168.19.45' '192.168.19.46' '192.168.19.47' '192.168.19.48' '192.168.19.49' '192.168.19.50' '192.168.19.51' '192.168.19.52' '192.168.19.55' '192.168.19.59' '192.168.19.60' '192.168.19.62' '192.168.19.63' '192.168.19.74' '192.168.19.82' '192.168.19.85' '192.168.19.87' '192.168.19.88' '192.168.9.5')
#nombre=('HTR' 'VGL' 'AMC' 'BVCU' 'VAC' 'COA' 'GAL' 'IMS' 'JIU' 'MIA' 'PTEI' 'TJL' 'TEJ' 'TMF' 'ZAC' 'TCS' 'CTC' 'IGU' 'CUAT' 'OAX' 'CUC' 'PSF' 'EZA' 'XOH' 'XCO' 'MZT' 'TET' 'ALC' 'XOA' 'COR' 'CPT' 'GRU' 'IXS' 'SCA' 'TLAYA' 'CPC' 'COT' 'SD1' 'MDO' 'ZHT' 'APA' 'CHI' 'CUA')

#terminal=('192.168.19.29' '192.168.19.22' '192.168.5.5' '192.168.13.5' '192.168.1.16' '192.168.7.5' '192.168.6.5' '192.168.19.48' '192.168.19.74' '192.168.19.85' '192.168.19.63')
#nombre=('AER' 'ALC' 'CCS' 'COT' 'CTC' 'CUE' 'JOJ' 'MEX' 'SD1' 'TMF' 'ZHT')


elementos=${#terminal[@]} #Number of elements in the array
echo "Numero de elementos $elementos"
ini=`date +%Y%m%d_%H:%M:%S`
echo "Fecha de replicacion:  $ini"
echo -e "\n\n"

#echo ${terminal[1]}

for ((i=0; i<elementos; i++));
do

term=${terminal[i]}
ciudad=${nombre[i]}
descterm=${descripcion[i]}


if [ "$ciudad" = "HTR" ];
then
	echo "Procesar query para: $ciudad ==> $term  ==> $descterm"
	/usr/bin/mysql -h $term -u root -p#R0j0N3no$ CORPORATIVO < /root/configuration/replica/datos.sql
	#/usr/bin/mysql -h $term --user=venta --password='GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE' CORPORATIVO < /root/configuration/replica/datos.sql

	#/usr/bin/mysql -h $term -u pullman -p#R0j0N3no$ -e "SELECT count(*) as existe FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 37;"  CORPORATIVO	
	#echo -e "\n"

 
elif [ "$ciudad" = "MOV" ];
then
	echo "Procesar query para: $ciudad ==> $term  ==> $descterm"
	/usr/bin/mysqladmin -h $term -u root -pPdvMysql flush-hosts
	
	#/usr/bin/mysql -h $term --user=venta --password='GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE' CORPORATIVO < /root/configuration/replica/datos.sql
	/usr/bin/mysql -h $term -u root -pPdvMysql CORPORATIVO < /root/configuration/replica/datos.sql
	#/usr/bin/mysql -h $term -u root -pPdvMysql -e "INSERT INTO PDV_C_PARAMETRO (ID_PARAMETRO, DESCRIPCION, VALOR) VALUES (37, 'Minutos para barrer venta', 10);"  CORPORATIVO
	#/usr/bin/mysql -h $term -u root -pPdvMysql -e "SELECT count(*) as existe FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 37;"  CORPORATIVO	
	#echo -e "\n"

else

ping=`/usr/bin/mysqladmin -h $term -u root -p#R0j0N3no$ ping`
#echo $ping

if [ "$ping" = "mysqld is alive" ];
then 
	echo "Procesar query para: $ciudad ==> $term  ==> $descterm"
	#/usr/bin/mysql -h $term --user=venta --password='GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE' CORPORATIVO < /root/configuration/replica/datos.sql
	
	/usr/bin/mysql -h $term -u root -p#R0j0N3no$ --comments CORPORATIVO < /root/configuration/replica/datos.sql 
	echo -e "\n"
        #/usr/bin/mysql -h $term -u root -p#R0j0N3no$ -e "UPDATE PDV_C_PERIODO_VACACIONAL SET FECHA_INICIO='2018-03-24 00:00:00', FECHA_FIN='2018-04-08 23:59:00' WHERE ID_PERIODO_VACACIONAL=1;"  CORPORATIVO
	#/usr/bin/mysql -h $term -u root -p#R0j0N3no$ -e "INSERT INTO PDV_C_PARAMETRO (ID_PARAMETRO, DESCRIPCION, VALOR) VALUES (37, 'Minutos para barrer venta', 10);" CORPORATIVO
	#/usr/bin/mysql -h $term -u root -p#R0j0N3no$ -e "SELECT count(*) as existe FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 37;" CORPORATIVO
else
	echo "Terminal Desconectada: $ciudad ...::... $term ...::... $descterm"
	echo -e "\n"

fi
#done


            
fi    
done