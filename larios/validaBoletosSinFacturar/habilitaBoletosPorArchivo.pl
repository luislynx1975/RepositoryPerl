#!/usr/bin/perl
#################################################################################
# Script para la generacion de la factura global de mercurio DIARIA
#version 1.0
#Fecha 2023-01-30
#Solo rebisar que apunte a la tabla correcta del año que corresponde
#Autor Larios Rodriguez Jose Luis
#################################################################################

use DBI;
use strict;
use Net::IP;
use Sys::HostAddr;

########################### F A C T U R A C I O N
my $d_bFACTURA = "FACTURACION";
###my $d_hFACTURA = "192.168.1.26";
my $d_hFACTURA = "192.168.1.15";
my $d_portFACTURA = 3306;
my $d_uFACTURA = "fact";
my $d_pFACTURA = "E141136ce\!\?kes\-AR\*";
my $S_FACTURA = undef;

############################ C O R P O R A T I V O
my $d_bBOLETO = "CORPORATIVO";
my $d_hBOLETO = "192.168.1.13";
#my $d_uBOLETO = "venta";
#my $d_pBOLETO = "GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE";

my $d_uBOLETO = "replicacion";
my $d_pBOLETO = "\#\@Vi\@j\@Mor3l0s";

my $d_portBOLETO = 3306;
my $S_BOLETO = undef;
my $formaPago = undef;
my $archivo  = '';
my $anio = 0;
################################################################################
#my $tableName = "PDV_T_BOLETO_";
my $tableName = "ENERO_";
################################################################################
#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}
################################################################################
sub updateComplemento{
    my @datos = @_;
    my $table = $tableName  . $datos[3];
    my $sql = '';
    if($datos[2] != 0){
    	$sql = "UPDATE $table SET COMPLEMENTO_2 = 'GENERAR' ".
	       "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ";
    	my $db_boleto = $S_BOLETO->prepare($sql);
    	$db_boleto->bind_param(1, $datos[0]);
    	$db_boleto->bind_param(2, $datos[1]);
    	$db_boleto->bind_param(3, $datos[2]);
    	$db_boleto->execute();
print join('***', @datos)."   valor mayor\n";
    }
    if($datos[2] == 0){
    	$sql = "UPDATE $table SET COMPLEMENTO_2 = 'GENERAR' ".
	       "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? ";
    	my $db_boleto = $S_BOLETO->prepare($sql);
    	$db_boleto->bind_param(1, $datos[0]);
    	$db_boleto->bind_param(2, $datos[1]);
    	$db_boleto->execute();
print join('***', @datos)."   valor 0\n";
    }
}

################################# M A I N ###################################
($archivo, $anio) = @ARGV;
if(length($archivo) == 0){
   print("Ingrese el nombre del archivo\n");
   exit;
}

if(length($anio) == 0){
   print("Ingrese el año a procesar\n");
   exit;
}

$S_BOLETO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
my $idx = 0;
my @factura = undef;
my @comprobante = undef;
my $totalCliente = 0;
my $totalIva = 0;
my $porFacturar = 0;
my $porIva = 0;
my $cve = '';
my $archivo = $ARGV[0];
open(FH,  'mayo.csv') or die "Sorry°° i Couldn't open";
while(<FH>){
   my @valores = split('\|', $_);
   $cve = $valores[2];
   $cve =~ s/\s+$//;
   if( length($cve) == 5){
	$cve = '0'.$cve;
   }
#   print($_);
#print("$anio\n");
   &updateComplemento($valores[0], $valores[1], $cve, $anio);
}
close;


$S_BOLETO->disconnect();
$S_FACTURA->disconnect();
