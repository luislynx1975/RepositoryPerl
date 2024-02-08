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
my $d_bFACTURA = "FACTURACION";
my $d_hFACTURA = "192.168.1.15";
my $d_portFACTURA = 3306;
my $d_uFACTURA = "fact";
my $d_pFACTURA = "E141136ce\!\?kes\-AR\*";
my $S_FACTURA = undef;

################################################################################
#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}

################################################################################
sub store{
     my $v = 10;
     my $query = "CALL ESTE(?, \@uno, \@dos)";
     my $dbh = $S_FACTURA->prepare( $query );
     $dbh->bind_param(1, $v);
     $dbh->execute();

     
     my $query = " SELECT \@uno, \@dos";
     my $dbh = $S_FACTURA->prepare( $query );
     $dbh->execute();
     my @out = $dbh->fetchrow_array();
     print("$out[0]   $out[1]\n");
}


################################# M A I N ###################################
$S_FACTURA = &conectaServer($d_bFACTURA, $d_hFACTURA, $d_uFACTURA, $d_pFACTURA, $d_portFACTURA ); 
&store();
$S_FACTURA->disconnect()
