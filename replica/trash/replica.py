#!/usr/bin/env python
# -*- coding: latin-1 -*-
import sys
sys.path.insert(0,"/usr/lib/python3/dist-packages")
import pymysql
import pymysql.cursors

def get_name(server, dbName):

#if dbName == '' or dbName is None:
#    print('There was a problem connecting to the database...exiting')
#    	sys.exit()
#try:
    dbUser = "root"
    dbUserPassword = "#R0j0N3no$"
    cursorType      = pymysql.cursors.DictCursor
    dbCharset       = "utf8mb4"
    	
    databaseConnection = pymysql.connect(host=server, user=dbUser, password=dbUserPassword, db=dbName, charset=dbCharset, cursorclass=cursorType, autocommit=True)

    remoto = databaseConnection.cursor()
    #updateStatement = "UPDATE PDV_C_PERIODO_VACACIONAL SET FECHA_INICIO='2020-03-18 00:00:00', FECHA_FIN='2020-04-20 23:59:00' WHERE ID_PERIODO_VACACIONAL=1;"
    #updateStatement = "UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.103' WHERE ID_TERMINAL='CUAT'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.104' WHERE ID_TERMINAL='OAX';" 
    
    #updateStatement = "UPDATE PDV_C_OCUPANTE SET FECHA_BAJA='2020-07-10 08:16:40' WHERE ID_OCUPANTE=10;" 
    #updateStatement = "REPLACE INTO `PDV_C_FORMA_PAGO` (`ID_FORMA_PAGO`, `ABREVIACION`, `DESCRIPCION`, `DOCUMENTO`, `CANCELACION_EFECTIVO`, `TIPO_CAMBIO`, `DESCUENTO`, `NOMINATIVO`, `ORDEN`, `FECHA_BAJA`, `MENSAJE_CANCELACION`, `CANCELABLE`, `SUMA_EFECTIVO_COBRO`, `POSEIDON`) VALUES (15, 'ROLLO', 'PROMOCION ROLLO', 'T', 'F', 0, 100, 'F', 15, NULL, 'No devolver efectivo', 'F', 0, 0);"
    #updateStatement = "ALTER TABLE PDV_T_PRECORTE ADD COLUMN PRO_ROLLO INT NOT NULL DEFAULT '0';" 
    
    #updateStatement = "UPDATE T_C_AUTOBUS SET ID_SERVICIO = 3, ID_SERVICIO_ACTUAL = 3 WHERE ID_AUTOBUS BETWEEN 532 AND 537;"
    #updateStatement = "UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.22' WHERE ID_TERMINAL='AMC'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.23' WHERE ID_TERMINAL='VAC'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.24' WHERE ID_TERMINAL='MDO'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.24' WHERE ID_TERMINAL='TMC'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.26' WHERE ID_TERMINAL='ZHT'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.27' WHERE ID_TERMINAL='SD1'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.29' WHERE ID_TERMINAL='XOA'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.34' WHERE ID_TERMINAL='EZA'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.35' WHERE ID_TERMINAL='CHI'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.36' WHERE ID_TERMINAL='XOH'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.37' WHERE ID_TERMINAL='BVCU'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.37' WHERE ID_TERMINAL='BVC'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.38' WHERE ID_TERMINAL='IXS'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.39' WHERE ID_TERMINAL='ALC'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.40' WHERE ID_TERMINAL='JIU'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.41' WHERE ID_TERMINAL='TJL'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.43' WHERE ID_TERMINAL='COA'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.44' WHERE ID_TERMINAL='TET'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.45' WHERE ID_TERMINAL='MZT'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.46' WHERE ID_TERMINAL='GRU'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.47' WHERE ID_TERMINAL='CPT'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.48' WHERE ID_TERMINAL='MIA'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.49' WHERE ID_TERMINAL='COR'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.50' WHERE ID_TERMINAL='GAL'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.51' WHERE ID_TERMINAL='TMF'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.52' WHERE ID_TERMINAL='APA'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.53' WHERE ID_TERMINAL='JOJ'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.54' WHERE ID_TERMINAL='XCO'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.55' WHERE ID_TERMINAL='CPC'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.56' WHERE ID_TERMINAL='COT'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.57' WHERE ID_TERMINAL='JLV'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.58' WHERE ID_TERMINAL='DIEZ'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.59' WHERE ID_TERMINAL='SD2'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.109' WHERE ID_TERMINAL='TEJ'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.105' WHERE ID_TERMINAL='CUC'; UPDATE PDV_C_TERMINAL SET IPv4='192.168.21.101' WHERE ID_TERMINAL='TCS';  "
    #updateStatement = "REPLACE INTO `PDV_C_TERMINAL` (`ID_TERMINAL`, `IPv4`, `BD_USUARIO`, `BD_PASSWORD`, `FECHA_HORA`, `ESTATUS`, `TIPO`, `BD_BASEDATOS`) VALUES ('VAC', '192.168.21.23', 'venta', 'GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE', '2011-03-23 00:00:00', 'A', 'T', 'CORPORATIVO');"
    #updateStatement = "REPLACE INTO `PDV_C_TERMINAL` (`ID_TERMINAL`, `IPv4`, `BD_USUARIO`, `BD_PASSWORD`, `FECHA_HORA`, `ESTATUS`, `TIPO`, `BD_BASEDATOS`) VALUES ('MDO', '192.168.21.24', 'venta', 'GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE', '2018-07-17 11:50:58', 'A', 'T', 'CORPORATIVO');"
    #updateStatement = "REPLACE INTO PDV_C_PARAMETRO VALUES (45, 'Consume servicio salidas', 0);"
    
    updateStatement   = "INSERT INTO PDV_C_GRUPO_SERVICIOS VALUES('PUL','WTC','Autobuses de 1ra Clase Mex-Zac S.A de C.V','Av. Taxquena 1800 Col. Paseos de Taxqueña','Del. Coyoacán, D.F. C.P. 04250', 'APC580909L82','Mexico, D.F.');"
    
    remoto.execute(updateStatement)
    
    #sqlSelectUpdated   = "SELECT ID_TERMINAL, IPv4 FROM PDV_C_TERMINAL WHERE ID_TERMINAL IN ('CUAT', 'OAX');"
    #sqlSelectUpdated   = "SELECT ID_OCUPANTE, FECHA_BAJA FROM PDV_C_OCUPANTE WHERE ID_OCUPANTE=10;"
    #sqlSelectUpdated   = "SELECT TRIGGER_NAME, COUNT(*) FROM INFORMATION_SCHEMA.TRIGGERS WHERE TRIGGER_SCHEMA='CORPORATIVO' AND TRIGGER_NAME='PDV_TIRGGER_INSERTA_BOLETO';;"
    #sqlSelectUpdated   = "SELECT DESCRIPCION FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 45;"
    #sqlSelectUpdated   = "SELECT ID_SERVICIO, ID_SERVICIO_ACTUAL FROM T_C_AUTOBUS WHERE ID_AUTOBUS BETWEEN 532 AND 537;"
    #sqlSelectUpdated   = "SELECT ID_FORMA_PAGO, ABREVIACION FROM PDV_C_FORMA_PAGO WHERE ID_FORMA_PAGO = 15;"

    

    sqlSelectUpdated   = "SELECT * FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL ='WTC';"

	

    # Execute the SQL SELECT query
    remoto.execute(sqlSelectUpdated)
    
    # Fetch the updated row
    updatedRow = remoto.fetchall()
    
    # Print the updated row...
    for column in updatedRow:
        #TERMINAL= column[0]
        #IP= column[1]
	#print("TERMINAL = {0}, IP = {1}".format(TERMINAL, IP))  
        print("Respuesta obtenida de la actualizacion:") 
        print(column)         
    databaseConnection.close()
#except Exception as e:
#	print("Exeception occured:{}".format(e))

#finally:
	#databaseConnection.close()



############### CONFIGURAR ESTO ###################
# Abre conexion con la base de datos
db = pymysql.connect("localhost","root","3st@b@M0sB13n$","CORPORATIVO")
##################################################

# prepare a cursor object using cursor() method
cursor = db.cursor()

qry = "SELECT T.ID_TERMINAL, D.DESCRIPCION, T.IPv4, T.BD_USUARIO, T.BD_PASSWORD, T.BD_BASEDATOS   FROM PDV_C_TERMINAL T INNER JOIN T_C_TERMINAL D ON T.ID_TERMINAL = D.ID_TERMINAL WHERE T.ESTATUS = 'A'  AND T.ID_TERMINAL NOT IN ('MOV', 'WEB', 'AER', 'HTR', 'PSF', 'WTC') AND T.CONECTADO = 1 GROUP BY T.IPv4 ORDER BY 3;"
# ejecuta el SQL query usando el metodo execute().
cursor.execute(qry)

# procesa una unica linea usando el metodo fetchone().
#data = cursor.fetchone()
#print ("Database version : {0}".format(data))

# Fetch all the rows in a list of lists.
results = cursor.fetchall()
for row in results:
   ID_TERMINAL= row[0]
   DESCRIPCION= row[1]
   IPv4= row[2]
   BD_USUARIO= row[3]
   BD_PASSWORD= row[4]
   BD_BASEDATOS= row[5]

   # Now print fetched result
   #print ("ID_TERMINAL = {0}, DESCRIPCION = {1}, IPv4 = {2}, BD_USUARIO= {3}, BD_PASSWORD= {4},  BD_BASEDATOS= {5} ".format(ID_TERMINAL,DESCRIPCION,IPv4,BD_USUARIO,BD_PASSWORD,BD_BASEDATOS))
   print ("ID_TERMINAL = {0}, DESCRIPCION = {1}, IPv4 = {2}".format(ID_TERMINAL,DESCRIPCION,IPv4))
   # llamado a la funcion, para conexion remota
   get_name(IPv4, BD_BASEDATOS)
   #get_name(IPv4, 'information_schema');

# desconecta del servidor
db.close()
