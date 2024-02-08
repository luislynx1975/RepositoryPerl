#!/usr/bin/env python

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
    selectStatement = "SELECT `ID_TERMINAL`, `IPv4`, `BD_USUARIO`, `BD_PASSWORD`, `FECHA_HORA`, `ESTATUS`, `TIPO`, `BD_BASEDATOS` FROM PDV_C_TERMINAL LIMIT 1 ;"
    remoto.execute(selectStatement)
    
    #sqlSelectUpdated   = "INSERT INTO `PDV_C_TERMINAL_GLOBAL` (`ID_TERMINAL`, `IPv4`, `BD_USUARIO`, `BD_PASSWORD`, `FECHA_HORA`, `ESTATUS`, `TIPO`, `BD_BASEDATOS`) VALUES ('CUA', '192.168.9.5', 'venta', 'GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE', '2014-10-14 17:20:52', 'A', 'T', 'CORPORATIVO');"

    # Execute the SQL SELECT query
    #remoto.execute(sqlSelectUpdated)
    
    # Fetch the updated row
    updatedRow = remoto.fetchall()
    
    # Print the updated row...
    for column in updatedRow:
        TER= column[0]
        #IP= column[1]
        #BDUSUARIO= column[2]
        #BDPASSWORD= column[3]
        #FECHA= column[4]
        #ESTATUS= column[5]
        #TIPO= column[6]
        #BDBASEDATOS= column[7]
        #TERMINAL= column[0]
        #IP= column[1]
	    #print("TERMINAL = {0}, IP = {1}".format(TERMINAL, IP))  
        #print("Respuesta obtenida de la actualizacion:") 
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

qry = "SELECT T.ID_TERMINAL, D.DESCRIPCION, T.IPv4, T.BD_USUARIO, T.BD_PASSWORD, T.BD_BASEDATOS   FROM PDV_C_TERMINAL T INNER JOIN T_C_TERMINAL D ON T.ID_TERMINAL = D.ID_TERMINAL WHERE T.ESTATUS = 'A'  AND T.ID_TERMINAL NOT IN ('MOV', 'WEB') AND T.CONECTADO = 1 GROUP BY T.IPv4 ORDER BY 3 LIMIT 2;"
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

# desconecta del servidor
db.close()
