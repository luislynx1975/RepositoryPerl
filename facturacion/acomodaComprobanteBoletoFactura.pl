#!/usr/bin/perl
#################################################################################
# Script para la generacion de la factura global de mercurio
#version 1.0
#Fecha 2018-06-13
#Autor Larios Rodriguez Jose Luis
#################################################################################

use DBI;
use strict;
use Net::IP;
use Sys::HostAddr;

########################### F A C T U R A C I O N
#my $d_bFACTURA = "facturacion";
#my $d_hFACTURA = "192.168.2.203";
#my $d_portFACTURA = 3305;

my $d_bFACTURA = "FACTURACION";
my $d_hFACTURA = "192.168.1.26";
my $d_portFACTURA = 3306;
my $d_uFACTURA = "root";
my $d_pFACTURA = "#R0j0N3no\$";
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
###############################################################################
my $dia_facturar = '2021-01-01';

################################################################################
my $tableName = "PDV_T_BOLETO_";
################################################################################
#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}
################################################################################
#BUSCAMOS EN LA TABLA FAC_T_COMPROBANTE

sub getComprobanteConcepto{
    my $qry_boleto = "SELECT CONCAT(ID_BOLETO,ID_TERMINAL,TRAB_ID)AS IDENTIFICACION ".
		     "FROM PDV_T_BOLETO_2021 B ".
		     "WHERE B.FECHA_BOLETO = '2021-01-02'";
    my $stb = $S_BOLETO->prepare($qry_boleto);
    $stb->execute();
    while(my @boleto = $stb->fetchrow_array()){
	print "Buscando $boleto[0]\n";
	my $qry_factura = "SELECT CC.NOIDENTIFICACION, C.CVE_COMPROBANTE ".
			  "FROM FAC_T_COMPROBANTE C INNER JOIN FAC_T_CONCEPTO_COMPROBANTE CC ON C.CVE_COMPROBANTE = CC.CVE_COMPROBANTE ".
			  "WHERE CC.NOIDENTIFICACION = ?";
        my $stf = $S_FACTURA->prepare($qry_factura);
	$stf->bind_param(1, $boleto[0]);
	$stf->execute();
	while(my @factura = $stf->fetchrow_array()){

		print "$factura[0]   $factura[1]\n";
	}
    }
}


################################# M A I N ###################################

$S_BOLETO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
$S_FACTURA = &conectaServer($d_bFACTURA, $d_hFACTURA, $d_uFACTURA, $d_pFACTURA, $d_portFACTURA ); 
   &getComprobanteConcepto();


$S_BOLETO->disconnect();
$S_FACTURA->disconnect()
