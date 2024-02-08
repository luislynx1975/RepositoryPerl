#!/usr/bin/perl

#Creado el 22-Oct-2015
#version 1.0

use DBI;
use Net::Ping;

my $db = "CORPORATIVO";
my $host = "192.168.1.13";
my $port = 3306;
my $user = "venta";
my $pass = 'GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE';

my $fecha = '2015-11-01';
#my $fecha1 = "(SELECT SUBDATE('". $fecha ."',INTERVAL 1 month) )";
my $fecha1 = '2015-11-01';
my $fecha2 = '2015-11-31';


sub conectaServer{
        local($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
        return $dbh;
}


sub getAsientos{
	$query = "SELECT ID_CORRIDA, FECHA_HORA_CORRIDA, NO_ASIENTO, NOMBRE_PASAJERO, TERMINAL_RESERVACION, TRAB_ID, ORIGEN, DESTINO, STATUS, ".
	         "FECHA_HORA_ORIGEN ".
                 "FROM PDV_T_ASIENTO A ".
                 "WHERE FECHA_HORA_CORRIDA BETWEEN (SELECT SUBDATE(CURRENT_DATE(),INTERVAL 2 DAY)) AND  ".
		 "(SELECT SUBDATE(CURRENT_DATE(),INTERVAL 1 DAY) )";
	$str = $_REMOTO->prepare( $query );
	$str->execute();
	while ( @datos = $str->fetchrow_array() ){
		$query = "INSERT INTO PDV_T_ASIENTO(ID_CORRIDA, FECHA_HORA_CORRIDA, NO_ASIENTO, NOMBRE_PASAJERO, TERMINAL_RESERVACION, ".
                         "TRAB_ID, ORIGEN, DESTINO, STATUS, FECHA_HORA_ORIGEN )".
			 "VALUES(?,?,?,?,?,?,?,?,?,?)";
		$stl = $_SERVER->prepare($query);
		$stl->bind_param(1, $datos[0]);
		$stl->bind_param(2, $datos[1]);
		$stl->bind_param(3, $datos[2]);
		$stl->bind_param(4, $datos[3]);
		$stl->bind_param(5, $datos[4]);
		$stl->bind_param(6, $datos[5]);
		$stl->bind_param(7, $datos[6]);
		$stl->bind_param(8, $datos[7]);
		$stl->bind_param(9, $datos[8]);
		$stl->bind_param(10, $datos[9]);
		$stl->execute();
		$stl->finish();
        }
	$str->finish();
}

#main
$_SERVER = &conectaServer($db, $host, $user, $pass);
$query = "SELECT ID_TERMINAL, IPV4, BD_USUARIO, BD_PASSWORD, BD_BASEDATOS ".
	 "FROM PDV_C_TERMINAL ".
	 "WHERE ESTATUS = 'A'";
$sth = $_SERVER->prepare( $query );
$sth->execute();

$duracion = 4;

while( @outs = $sth->fetchrow_array()){
        print join(',', @outs) . "\n";
        $p = Net::Ping->new("tcp",$duracion);
        $p->port_number("3306");
        ($ret, $duracion, $ip ) = $p->ping($outs[1], $duracion);
        if($ret == 1){
                $_REMOTO = &conectaServer($outs[4], $outs[1], $outs[2], $outs[3]);
                &getAsientos();
                $_REMOTO->disconnect();
        }
        $p->close();
}

$sth->finish();
$_SERVER->disconnect();
