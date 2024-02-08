#!/usr/bin/env python

###
### El script realiza un escaneo de puertos al host ingresado por el usuario
###

### Se cargan las librerias que se van a utilizar en el programa
### socket: habilita los canales de comunicacion
### subprocess: invoca procesos propios de python de entrada y salida
### sys: controlo los accesos a funciones y objetos
### datetime: funciones y clases de fecha
import socket
import subprocess
import sys
from datetime import datetime

# Clear the screen
### realiza una llamada a un subproceso, en este caso al parametro: clear, para limpiar la pantalla
subprocess.call('clear', shell=True)

# Ask for input
### almacena en la variable remoteServer la cadena ingresada por el usuario
remoteServer    = raw_input("Enter a remote host to scan: ")
### en la variable remoteServerIP se almacena la IP del resultado de resolver el nombre del dominio utilizando la funcion gethostbyname
remoteServerIP  = socket.gethostbyname(remoteServer)

# Print a nice banner with information on which host we are about to scan
### Se imprime en pantalla el guion medio 60 veces
print "-" * 60
### Se imprime en pantalla, que se esta ejecutando el escaneo de la IP ingresada
print "Please wait, scanning remote host", remoteServerIP
### Se imprime en pantalla el guion medio 60 veces
print "-" * 60

# Check what time the scan started
### Se obtiene el valor de la fecha y hora de inicio del escaneo y se almacena en la variable t1
t1 = datetime.now()

# Using the range function to specify ports (here it will scans all ports between 1 and 1024)

# We also put in some error handling for catching errors

### se hace uso de una excepcion 
try:
    
    ### utiliza un ciclo para recorrer los puerto que van del 1 al 1025
    for port in range(1,1025):
        ### se crea un socket INET(IPv4 Internet protocols) de tipo STREAM (socket de flujos)   
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        ### devuelve un indicador de error con la funcion connect_ex 
        result = sock.connect_ex((remoteServerIP, port))
        ### si el  indicador de error es cero, el puerto esta abierto
        if result == 0:
            ### Imprime en pantalla el numero de puerto con el estado de abierto, dando formato al valor del puerto
            print "Port {}:      Open".format(port)
        ### se cierra el socket
        sock.close()

### Excepcion generada al pulsar Ctrl+C en el teclado 
except KeyboardInterrupt:
    print "You pressed Ctrl+C"
    sys.exit()

### excepcion si no encuentra el hostname
except socket.gaierror:
    print 'Hostname could not be resolved. Exiting'
    sys.exit()

### excepcion generada sino logra conectarse al server
except socket.error:
    print "Couldn't connect to server"
    sys.exit()

# Checking the time again
### Se obtiene el valor de la fecha y hora de fin del escaneo y se almacena en la variable t2
t2 = datetime.now()

### realiza el calculo para establecer el tiempo en el que se realizo el escaneo
# Calculates the difference of time, to see how long it took to run the script
total =  t2 - t1

# Printing the information to screen
### imprime los resultados en pantalla de finalizacion del escaneo
print 'Scanning Completed in: ', total

