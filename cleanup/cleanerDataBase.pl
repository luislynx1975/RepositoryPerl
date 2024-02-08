#!/usr/bin/perl
#################################################################################
# Script para la depurar la base de datos de mercurio
#version 1.0
#Fecha 2022-04-19
#Autor Larios Rodriguez Jose Luis
#################################################################################
use DBI;
#use strict;
use Net::IP;
use Sys::HostAddr;
############################ C O R P O R A T I V O
my $d_bBOLETO = "CORPORATIVO";
my $d_hBOLETO = "192.168.1.13";
my $d_uBOLETO = "replicacion";
my $d_pBOLETO = "\#\@Vi\@j\@Mor3l0s";
my $d_portBOLETO  = 3306;
my $S_CORPO  = undef;
my $R_SERVER = undef;

################################################################################
#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}

################################################################################
sub getTerminalsDB{
    my @out = undef;
    my $idx = 0;
    my $query = "SELECT BD_BASEDATOS, IPV4, BD_USUARIO, BD_PASSWORD, IPV4, ID_TERMINAL ".
	        "FROM PDV_C_TERMINAL ".
		"WHERE ESTATUS = 'A' AND ID_TERMINAL = 'XOA' ";
    my $d_terminal = $S_CORPO->prepare( $query );
    $d_terminal->execute();
    while( my @data = $d_terminal->fetchrow_array() ){
	$out[$idx] = \@data;
        $idx++;
    }
    return @out;

}

################################################################################
sub getBoletoTrabId{
    my $cve = shift;
    my @datos = undef;
    my $idx = 0;
    my $query = "SELECT DISTINCT(B.TRAB_ID), COUNT(B.TRAB_ID)AS TOTAL ".
		"FROM PDV_T_BOLETO B  ".
		"WHERE B.ID_TERMINAL = ? ".
		"GROUP BY 1 ".
		"HAVING TOTAL > 1 ".
		"ORDER BY 1";
    my $d_cves = $R_SERVER->prepare( $query );
    $d_cves->bind_param(1, $cve);
    $d_cves->execute();
    while( my @vals = $d_cves->fetchrow_array() ){
	$datos[$idx] = \@vals;
	$idx++;
    }
    return @datos;
}

################################# M A I N ###################################
$S_CORPO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
my @aTerminals = &getTerminalsDB();
foreach my $x(0..@aTerminals - 1 ){
	$R_SERVER = &conectaServer($aTerminals[$x][0], $aTerminals[$x][1],  $aTerminals[$x][2],  $aTerminals[$x][3], $d_portBOLETO);
	if(!$R_SERVER){
	  die "Failed to connect to MySql database DBI->errstr()";
	}else{  #Si esta establecida la conexion a la base de datos
	   my @cves = &getBoletoTrabId( $aTerminals[$x][5] );
	   foreach my $y (0.. @cves -1 ){
		print("$cves[$y][0]  $cves[$y][1]  \n");
	   }
	}
}

$S_CORPO->disconnect();


















