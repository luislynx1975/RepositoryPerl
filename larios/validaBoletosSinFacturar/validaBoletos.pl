#!/usr/bin/perl
#################################################################################
# Script para la generacion de la factura global de mercurio DIARIA
#version 1.0
#Fecha 2022-05-17
#Fecha Modificacion 2023-01-24
#Modificacion se modifica para realizar la factura al ser por terminal, dia y servicio
#se incluye la descripcion en el concepto esta se mejora de la version anterior
#Autor Larios Rodriguez Jose Luis
#################################################################################

use DBI;
use strict;
use Net::IP;
use Sys::HostAddr;

########################### F A C T U R A C I O N
my $d_bFACTURA = "FACTURACION";
######my $d_hFACTURA = "192.168.1.15";
my $d_hFACTURA = "192.168.1.26";
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
################################################################################
#####my $tableName = "ENERO_";
my $tableName = "PDV_T_BOLETO_";
my $_MES_COMPLEMENTO = 'JUNIO';
my $_CLIENTE_MES = 'CLIENTE_JUNIO';
################################################################################
#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}
################################################################################
sub seekBoletos{
    my @datos = @_;
    my $table = $tableName  . $datos[3];
    my $sql = "SELECT COMPROBANTE, FACTURADO, ID_REFERENCIA, TARIFA, TOTAL_IVA, ID_BOLETO, TRAB_ID, ID_TERMINAL, TIPOSERVICIO ".
	      "FROM $table E ".
	      "WHERE E.ID_BOLETO = ? AND E.TRAB_ID like '%$datos[2]' AND E.ID_TERMINAL = ? AND ESTATUS = 'V' ";
    my $db_boleto = $S_BOLETO->prepare( $sql );
    $db_boleto->bind_param(1, $datos[0]); 
#    $db_boleto->bind_param(2, $datos[2]); 
    $db_boleto->bind_param(2, $datos[1]); 
    $db_boleto->execute();
    my @out = $db_boleto->fetchrow_array();
    return @out;
}
################################################################################
sub seekFacturacion{
    my $cveFactura = shift;
    my $sql = "SELECT UUID, ERROR_PROFACT, STATUS, FECHA_CANCELACION, RECEPTOR_RFC, FECHA_TIMBRADO, C_TIPODECOMPROBANTE ".
	      "FROM FAC_T_COMPROBANTE  ".
	      "WHERE CVE_COMPROBANTE = $cveFactura";
    my $db_factura = $S_FACTURA->prepare($sql);
    $db_factura->execute();
    my @out = $db_factura->fetchrow_array();
   return @out; 
}

################################################################################
sub getCve0{
   my @datos = @_;
   my $sql = "SELECT TRAB_ID ".
	     "FROM ENERO_2022 e ".
	     "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TC = ?";
   my $db_corp = $S_BOLETO->prepare( $sql );
   $db_corp->bind_param(1, $datos[0]);
   $db_corp->bind_param(2, $datos[1]);
   $db_corp->bind_param(3, $datos[2]);
   $db_corp->execute();
   my @out = $db_corp->fetchrow_array();
   return $out[0];
}

################################################################################
sub updateBoletoParaFacturar{
    my @datos = @_;
    my $table = $tableName  . $datos[3];
    my $sql = '';
    if($datos[2] != 0){
        $sql = "UPDATE $table SET COMPLEMENTO_2 = ? ".
               "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? AND ESTATUS = 'V' ";
        my $db_boleto = $S_BOLETO->prepare($sql);
        $db_boleto->bind_param(1, $datos[4]);
        $db_boleto->bind_param(2, $datos[0]);
        $db_boleto->bind_param(3, $datos[1]);
        $db_boleto->bind_param(4, $datos[2]);
        $db_boleto->execute();
    }
    if($datos[2] == 0){
        $sql = "UPDATE $table SET COMPLEMENTO_2 = ? ".
               "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND ESTATUS = 'V' ";
        my $db_boleto = $S_BOLETO->prepare($sql);
        $db_boleto->bind_param(1, $datos[4]);
        $db_boleto->bind_param(2, $datos[0]);
        $db_boleto->bind_param(3, $datos[1]);
        $db_boleto->execute();
    }
}


################################# M A I N ###################################
my $file = $ARGV[0];
my $anio = $ARGV[1];
if(length($file) == 0){
   print("perl validaBoletos.pl archivo  año\n");
   exit;
}
if($anio == 0){
  print("Ingrese el año \n");
  print("Ejemplo perl validaBoletos.pl archivo 2022 \n");
  exit;
}
$S_BOLETO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
$S_FACTURA = &conectaServer($d_bFACTURA, $d_hFACTURA, $d_uFACTURA, $d_pFACTURA, $d_portFACTURA ); 
my $idx = 0;
my @factura = undef;
my @comprobante = undef;
my $totalCliente = 0;
my $totalIva = 0;
my $porFacturar = 0;
my $porIva = 0;
my $cve = '';
open(FH,  $file) or die "Sorry°° i Couldn't open";
while(<FH>){
   my @valores = split('\|', $_);
   $cve = $valores[2];
   $cve =~ s/\s+$//;
   if (($cve =~ /^[1-9]/) && (length($cve) == 5)){
	$cve = '0'.$cve;
   }
   if( length($cve) == 1){
      $cve = &getCve0( $valores[0], $valores[1], $valores[19]);
   }

   @comprobante = &seekBoletos( $valores[0], $valores[1], $cve, $anio) ;
   if(length($comprobante[2]) == 0){
   	print("$valores[0],$valores[1],$cve, $comprobante[3], $comprobante[4], $comprobante[8]\n");
	&updateBoletoParaFacturar($valores[0], $valores[1], $cve, 2022, $_MES_COMPLEMENTO );
   }else{
   	@factura = &seekFacturacion($comprobante[2] );
        if( $factura[2] == 1){
	  print("Facturado por Cliente $valores[0],$valores[1],$cve,$comprobante[3],$comprobante[4],$comprobante[2],$factura[0],$factura[5],$factura[6], Factura cancelada\n");
	}else{
	  print("Facturado por Cliente $valores[0],$valores[1],$cve,$comprobante[3],$comprobante[4],$comprobante[2],$factura[0],$factura[5],$factura[6]\n");
	  &updateBoletoParaFacturar($valores[0], $valores[1], $cve, 2022, $_CLIENTE_MES );
        }
   }
}
close;


$S_BOLETO->disconnect();
$S_FACTURA->disconnect();
