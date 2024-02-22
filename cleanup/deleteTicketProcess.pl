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
my $_DIAS_NO_EMP = 45;
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
    my $termnl = shift;
    my @out = undef;
    my $idx = 0;
    my $query = "SELECT BD_BASEDATOS, IPV4, BD_USUARIO, BD_PASSWORD, IPV4, ID_TERMINAL ".
	        "FROM PDV_C_TERMINAL ".
		"WHERE ESTATUS = 'A' AND ID_TERMINAL = ? ";
    my $d_terminal = $S_CORPO->prepare( $query );
    $d_terminal->bind_param(1, $termnl);
    $d_terminal->execute();
    while( my @data = $d_terminal->fetchrow_array() ){
	$out[$idx] = \@data;
        $idx++;
    }
    return @out;

}

################################################################################
sub messageHelp(){
   print("###############################################\n");
   print("#  El script se ejecuta desde linea de comando o terminal de Linux  #\n");
   print("#  Se ejecuta con el interprete de PERL  #\n");
   print("#  EJEMPLO DE EJECUCION  #\n");
   print("#  perl cleanerTables.pl MEX \n #");
   print("###############################################\n");
}

################################################################################
sub getEmployeeTicket(){
   my $li = 0;
   my @salida;
   my $query = "SELECT DISTINCT(TRAB_ID) FROM PDV_T_TICKET_FOR_DELETE  ";
   my $d_qry = $R_SERVER->prepare($query);
   $d_qry->execute();
   while(@out = $d_qry->fetchrow_array()){
      $salida[$li] = $out[0];
      $li++;
   } 
   return @salida;
}

################################################################################
sub deleteTickets{
     my ($cve, $cuantos) = @_;
     my $query = "SELECT * FROM PDV_T_TICKET_FOR_DELETE WHERE TRAB_ID = ? LIMIT $cuantos";
     my $d_ticket = $R_SERVER->prepare( $query );
     $d_ticket->bind_param(1, $cve);
     $d_ticket->execute();
     while(my @outs = $d_ticket->fetchrow_array()){
	 print("$outs[0]   $outs[1]  $outs[2]\n");
	 $query = "DELETE FROM PDV_T_BOLETO WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
         my $d_borra = $R_SERVER->prepare( $query );
	 $d_borra->bind_param(1, $outs[0]);
	 $d_borra->bind_param(2, $outs[1]);
	 $d_borra->bind_param(3, $outs[2]);
	 $d_borra->execute();
     }
}

################################################################################
sub getTotalTickets{
    my ($cve, $cuantos) = @_;
    my $qry = "SELECT COUNT(*) / ? FROM PDV_T_TICKET_FOR_DELETE ".
              "WHERE TRAB_ID = ?";
    my $d_how = $R_SERVER->prepare( $qry );
    $d_how->bind_param(1,$cuantos);  
    $d_how->bind_param(2,$cve);  
    $d_how->execute();
    my @out = $d_how->fetchrow_array();
    my $n = int($out[0]);
    return $n++; 
}

################################# M A I N ###################################
system("cls");
system("clear");
my $argv_terminal = $ARGV[0];
if ($#ARGV != 0){
   messageHelp();
   exit;
}

$S_CORPO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
my @aTerminals = &getTerminalsDB($argv_terminal);
if($argv_terminal =~ 'Test'){
    $argv_terminal = 'MEX';
}
#Create table where store the tickets for deleted of database by administrator
$R_SERVER = &conectaServer($aTerminals[0][0], $aTerminals[0][1],  $aTerminals[0][2],  $aTerminals[0][3], $d_portBOLETO);
print("$aTerminals[0][0], $aTerminals[0][1],  $aTerminals[0][2],  $aTerminals[0][3], $d_portBOLETO\n");
if(!$R_SERVER){
  die "Failed to connect to MySql database DBI->errstr()";
}else{  #Si esta establecida la conexion a la base de datos
    my @datos = &getEmployeeTicket();
    my $cuantos = 100;
    foreach my $cve (@datos){
       my $total = &getTotalTickets($cve, $cuantos);
	for(my $i = 0; $i < $total; $i++){
           &deleteTickets( $cve, $cuantos );
	}
    }

}#//fin else if
$R_SERVER->disconnect();

$S_CORPO->disconnect();
