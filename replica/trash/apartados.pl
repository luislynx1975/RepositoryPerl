#!/usr/bin/perl

#Creado el 22-Oct-2015
#version 1.0

use DBI;
use Net::Ping;

my $db = "CORPORATIVO";

my $db = "CORPORATIVO";
my $host = "192.168.1.13";
my $port = 3306;
my $user = "venta";
my $pass = 'GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE';

my $fecha1 = '2011-09-05';
my $fecha2 = '2015-11-31';


sub conectaServer{
        local($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
        return $dbh;
}

sub generaFecha{
	$query = "select * from  ".
"(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from ".
"(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, ".
"(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1, ".
"(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2, ".
"(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3, ".
"(select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v ".
"where fechas between DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)  and CURRENT_DATE()";

	$sta = $_SERVER->prepare( $query );
	$sta->execute();
	$idx = 0;
	while( @a_fecha = $sta->fetchrow_array() ){
		$a_out[ $idx ] = $a_fecha[0];
		$idx++;
	}
	$sta->finish();
	return @a_out;
}

sub registraAsiento{
	local(@a_seats) = @_;
	foreach $values (@a_seats){
	#    $query = "SELECT ID_CORRIDA, FECHA_HORA_CORRIDA, NO_ASIENTO, ORIGEN, DESTINO, TRAB_ID, NOMBRE_PASAJERO ".
	#	     "FROM PDV_T_ASIENTO ".
	#	     "WHERE CAST(FECHA_HORA_CORRIDA AS DATE) BETWEEN (SELECT SUBDATE(CURRENT_DATE(),INTERVAL 1 DAY) AND CURRENTDATE() AND STATUS = 'A' ";

	    $query = "SELECT ID_CORRIDA, FECHA_HORA_CORRIDA, NO_ASIENTO, ORIGEN, DESTINO, TRAB_ID, NOMBRE_PASAJERO ".
		     "FROM PDV_T_ASIENTO ".
		     "WHERE CAST(FECHA_HORA_CORRIDA AS DATE) = ? AND STATUS = 'A' ";
	   $sta = $_SERVER->prepare( $query );
	   $sta->bind_param(1, $values);
	   $sta->execute();	
	   while( @a_outs = $sta->fetchrow_array() ){
		$query = "INSERT INTO REP_W_T_APARTADO(ID_CORRIDA, FECHA_HORA_CORRIDA, NO_ASIENTO, ORIGEN, DESTINO, TRAB_ID, NOMBRE_PASAJERO, STATUS) ".
		         "VALUES(?,?,?,?,?,?,?,?)";
		$stb = $_SERVER->prepare( $query );
		$stb->bind_param(1, $a_outs[0]);#corrida
		$stb->bind_param(2, $a_outs[1]);#fecha
		$stb->bind_param(3, $a_outs[2]);#no_asiento
		$stb->bind_param(4, $a_outs[3]);#origen
		$stb->bind_param(5, $a_outs[4]);#destino
		$stb->bind_param(6, $a_outs[5]);#trab_di
		$stb->bind_param(7, $a_outs[6]);#nombre
		$stb->bind_param(8, 'A');#statu
		$stb->execute();
		$stb->finish();
	   }
	   $sta->finish();	
	}
}

#main
$_SERVER = &conectaServer($db, $host, $user, $pass);
&registraAsiento( &generaFecha() );
#print join(',', &generaFecha() ) ;

$_SERVER->disconnect();
