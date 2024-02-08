#!/usr/bin/perl

use DBI;
#use strict;
##############################################PARAMETROS CORPORATIVO ##################
my $d_dCENTRAL = "CORPORATIVO";
my $d_hCENTRAL = "192.168.1.13";
my $d_uCENTRAL = "venta";
my $d_pCENTRAL = "GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE";
my $port = 3306;
my $S_CENTRAL = undef;
my $S_TERMINAL = undef;
my $header = "TERMINAL,CAJERO,PROMOTOR,DIA,HORA,MONTO\n";
my @fechas = ();
#Funcion para la conexion a la base de datos
sub conectaServer{
        (my $dbase_db, my $ip_db, my $user_db, my $pass_db) = @_;
        my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
        return $dbh;
}

sub getFechas{
	my @valor = ();
	my $sql = "select * from  ".
"(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v ".
"where fechas between '2018-05-01' and '2018-05-31'";
	my $db_central = $S_CENTRAL->prepare( $sql );
	$db_central->execute();
	while(@data = $db_central->fetchrow_array()){
	    push(@valor, $data[0]);
	}
	return @valor;
}

sub getTerminales{
	open(DATOS, ">/root/configuration/facturacion/recolecciones.csv") || die "No puedo crear el archivo";
	open(INGRESO, ">/root/configuration/facturacion/ingreso.csv") || die "No puedo crear el archivo";
	my $sql = "SELECT T.ID_TERMINAL, T.BD_USUARIO, T.BD_PASSWORD, T.BD_BASEDATOS, T.IPv4 ".
		  "FROM PDV_C_TERMINAL T  ".
		  "WHERE T.ESTATUS = 'A' ORDER BY 1 ";
	my $db_central = $S_CENTRAL->prepare( $sql );
	$db_central->execute();
	while(my @data = $db_central->fetchrow_array()){
	    my $opcion = 1;
	    print join (',', @data). "\n";
	    $S_TERMINAL = &conectaServer($data[3], $data[4], $data[1], $data[2]);
	    if(defined $S_TERMINAL){
		$sql = 'SELECT ID_TERMINAL, ID_EMPLEADO_REALIZA AS CAJERO, ID_EMPLEADO AS PROMOTOR, '.
		   'CAST(FECHA_HORA AS DATE)AS DIA, CAST(FECHA_HORA AS TIME)AS HORA, IMPORTE '.
		   'FROM PDV_T_RECOLECCION '.
		   'WHERE CAST(FECHA_HORA AS DATE) BETWEEN  "2018-05-01" AND  "2018-05-31" AND ID_TERMINAL = ?';
		my $db_remoto = $S_TERMINAL->prepare( $sql );
		$db_remoto->bind_param(1, $data[0]);
		$db_remoto->execute();
		while(my @cajero = $db_remoto->fetchrow_array()){
		    if ($opcion =~ 1){	
		    	print DATOS $header;
			$opcion = 0;
		    }
		    print DATOS join(',', @cajero) . "\n";
	    	}
		foreach my $dia(@fechas){
		    $sql = "SELECT ID_TERMINAL, SUM(TARIFA) ".
			   "FROM PDV_T_BOLETO B ".
			   "WHERE CAST(B.FECHA_HORA_BOLETO AS DATE) = ? AND ESTATUS = 'V' ";
		    $db_remoto = $S_TERMINAL->prepare( $sql );
		    $db_remoto->bind_param(1, $dia );
		    $db_remoto->execute();
		    while(@datos = $db_remoto->fetchrow_array()){
			print INGRESO  $dia.",".$datos[0].",".$datos[1]."\n";
		    }
		}
	    }
	}
	close(DATOS);
	close(INGRESO);
}


#Main
$S_CENTRAL = &conectaServer($d_dCENTRAL, $d_hCENTRAL, $d_uCENTRAL, $d_pCENTRAL);
@fechas = getFechas();
&getTerminales();
