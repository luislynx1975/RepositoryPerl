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
my $_DAY_NUM_LEFT = 100;
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
    my $terminal = shift;
    my @out = undef;
    my $idx = 0;
    my $query = "SELECT BD_BASEDATOS, IPV4, BD_USUARIO, BD_PASSWORD, IPV4, ID_TERMINAL ".
	        "FROM PDV_C_TERMINAL ".
		"WHERE ESTATUS = 'A' AND ID_TERMINAL = ? ";
    my $d_terminal = $S_CORPO->prepare( $query );
    $d_terminal->bind_param(1, $terminal);
    $d_terminal->execute();
    while( my @data = $d_terminal->fetchrow_array() ){
	$out[$idx] = \@data;
#print("$data[0]  $data[1]  $data[2]  $data[3]  $data[4]    \n");
        $idx++;
    }
    return @out;

}



################################################################################
sub getDaysRange(){
	my $cveEmpl = shift;
	my @outDays = undef;
	my $idx = 0;
	my $qry = "select * from ".
		  " (select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from ".
		  " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, ".
		  " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1, ".
		  " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2, ".
		  " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3, ".
		  " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v ".
		  " WHERE fechas BETWEEN (SELECT CAST(MIN(FECHA_HORA_BOLETO)AS DATE) FROM PDV_T_BOLETO)  ".
		  " AND ( SUBDATE(CURRENT_DATE(), INTERVAL 365 DAY) ) ORDER BY 1 ";

	my $d_days = $R_SERVER->prepare( $qry );
	$d_days->execute();
	while( my @data = $d_days->fetchrow_array()) {
	   $outDays[$idx] = $data[0];
	   $idx++;
	}	
	return @outDays;
}

################################################################################
sub creaTable(){
	my $qry = "CREATE TABLE IF NOT EXISTS TEST_BOLETO_BORRAR( ".
		  "BOLETO_ID BIGINT, ".
		  "TERMINAL VARCHAR(7), ".
		  "EMPLEADO varchar(7), ".
		  "FECHA  DATE, ".
		  "PRIMARY KEY(BOLETO_ID, TERMINAL, EMPLEADO)  ) ";
	my $e_tabla = $R_SERVER-> prepare( $qry );
	$e_tabla->execute();
}

################################################################################
sub getEmployee(){
	my @outEmpl = undef;
	my $idx = 0;
	my $sql = "SELECT DISTINCT(TRAB_ID) FROM PDV_T_BOLETO";
	my $db_employee = $R_SERVER->prepare( $sql );
	$db_employee->execute();
	while(my @data = $db_employee->fetchrow_array()){
		$outEmpl[$idx] = $data[0];
		$idx++;
  	}
	return @outEmpl;
}

################################################################################
sub existBoletoCorporativo(){
	my @values = @_;
	my $db_tCorpo = $S_CORPO->prepare("SELECT COUNT(*)  FROM PDV_T_BOLETO ".
			                  "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ");
	$db_tCorpo->execute();	
	my @data = $db_tCorpo->fetchrow_array();
	return $data[0];
}


################################################################################
sub saveTableLocal(){
	my @data = @_;
	my @day = split(' ', $data[10]);
	my $qry = "INSERT INTO TEST_BOLETO_BORRAR ".
		  "VALUES(?, ?, ?, ?) ";
	my $db_test = $R_SERVER->prepare( $qry );
	$db_test->bind_param(1, $data[0]);
	$db_test->bind_param(2, $data[1]);
	$db_test->bind_param(3, $data[2]);
	$db_test->bind_param(4, $data[10]);
	$db_test->execute();
}

sub testNoExisteBoletoCorpo(){
	my $data = @_;

	my $sql = "INSERT INTO TEST_NOEXISTE_BOLETO( ID_BOLETO,ID_TERMINAL,TRAB_ID,ESTATUS,ORIGEN, ".
		  "DESTINO,TARIFA,ID_FORMA_PAGO,ID_TAQUILLA,TIPO_TARIFA, ".
		  "FECHA_HORA_BOLETO,ID_CORRIDA,FECHA,NOMBRE_PASAJERO,NO_ASIENTO, ".
		  "ID_OCUPANTE,ESTATUS_PROCESADO,ID_RUTA,TIPOSERVICIO,ID_PAGO_PINPAD_BANAMEX, ".
		  "TC,IVA,TOTAL_IVA,ID_FORMA_PAGO_SUB,FECHA_BOLETO, ".
		  "HORA_BOLETO,TARIFA_REAL,HORA_CORRIDA,COMPLEMENTO_1,COMPLEMENTO_2, ".
		  "COMPLEMENTO_3 ) ".
		  "VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?  ,?  )";
	my $db_test = $S_SERVER->prepare( $sql );
	for( my $i = 0; $i < @data; $i++){
		$db_test->bind_param($i++, $data[$i] );   
	}
	$db_test->execute();
}

################################################################################
#Consulatos todos los boletos del empleado por fecha , recorremos para verificar si esta
#en el server de corporativo
sub ticketDayEmployee(){
	my @data = @_;
	my $sql = "SELECT ID_BOLETO,ID_TERMINAL,TRAB_ID,ESTATUS,ORIGEN, ".
		  "DESTINO,TARIFA,ID_FORMA_PAGO,ID_TAQUILLA,TIPO_TARIFA, ".
		  "FECHA_HORA_BOLETO,ID_CORRIDA,FECHA,NOMBRE_PASAJERO,NO_ASIENTO, ".
		  "ID_OCUPANTE,ESTATUS_PROCESADO,ID_RUTA,TIPOSERVICIO,ID_PAGO_PINPAD_BANAMEX, ".
		  "TC,IVA,TOTAL_IVA,ID_FORMA_PAGO_SUB,FECHA_BOLETO, ".
		  "HORA_BOLETO,TARIFA_REAL,HORA_CORRIDA,COMPLEMENTO_1,COMPLEMENTO_2, ".
		  "COMPLEMENTO_3 ".
		  "FROM PDV_T_BOLETO B ".
		  "WHERE B.TRAB_ID = ? AND cast(B.FECHA_HORA_BOLETO AS DATE) =  ? ";
	my $db_sth = $R_SERVER->prepare( $sql );
	$db_sth->bind_param(1, $data[0] );
	$db_sth->bind_param(2, $data[1] );
	$db_sth->execute();
	while( my @data = $db_sth->fetchrow_array() ){
		&saveTableLocal( @data );
		if(&existBoletoCorporativo(@data) == 0){
			&testNoExisteBoletoCorpo(@data);		
		}else{
			print("Existe el dato en la base se debe borrar\n");
		}
	}
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


################################# M A I N ###################################
system("cls");
system("clear");
my $argv_terminal = $ARGV[0];
if ($#ARGV != 0){
   messageHelp();
   exit;
}
print($argv_terminal );
$S_CORPO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
my @aTerminals = &getTerminalsDB($argv_terminal );
$R_SERVER = &conectaServer($aTerminals[$x][0], $aTerminals[$x][1],  $aTerminals[$x][2],  $aTerminals[$x][3], $d_portBOLETO);
if(!$R_SERVER){
  die "Failed to connect to MySql database DBI->errstr()";
}else{  #crea tabla para guardar la llave boleto que se borraran los datos de la table de boleto
	&creaTable(); 
	foreach my $employee (&getEmployee()){
		foreach my $day (&getDaysRange($employee)){
			&ticketDayEmployee($employee, $day);	
		}
	}
}#//fin else if

$R_SERVER->disconnect();
$S_CORPO->disconnect();

