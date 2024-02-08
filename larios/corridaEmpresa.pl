#!/usr/bin/perl

use DBI;
use Net::Ping;

my $db = "CORPORATIVO";
my $host = "localhost";
my $db = "CORPORATIVO";
my $port = 3306;
my $user = "root";
my $password = "3st\@b\@M0sB13n\$";



my $f_inicio = '2022-01-01';
my $f_final =  '2022-12-31';

#Conectamos al server local y regresa la conexion
sub conectaServer{
        local($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        $dbh = DBI->connect($connectionInfo,$user_db,$pass_db, {RaiseError => 0, PrintError => 0} );
        return $dbh;
}



sub getOrigenRuta{
     my @datos = [];
     my $idx = 0;
     my $qry = "SELECT DISTINCT(ORIGEN) FROM T_C_RUTA";
     my $db = $_SERVER->prepare($qry);
     $db->execute();
     while(my @out = $db->fetchrow()){
	$datos[$idx] = $out[0];
        $idx++;
     }
     return @datos;
}

sub insertTabla{
     my @datos = @_;
     eval{
     	my $insert = "INSERT INTO LARIOS_CORRIDAS_EMPRESA(ID_CORRIDA, FECHA, ESTATUS, EMPRESA, ORIGEN) ".
		  "VALUES(?,?,?,?,?) ";
     	my $dbTabla = $_SERVER->prepare( $insert );
            	$dbTabla->bind_param(1, $datos[0]);
            	$dbTabla->bind_param(2, $datos[1]);
            	$dbTabla->bind_param(3, $datos[2]);
            	$dbTabla->bind_param(4, $datos[3]);
            	$dbTabla->bind_param(5, $datos[4]);
     	$dbTabla->execute();

     	if( $@ =~ m/Duplicate/){
		print("El dato esta duplicado : $datos[0]   %datos[1]\n");
     	}
     }
}

sub existTable{
    my @datos = @_;
    my $qry = 'SELECT COUNT(ID_CORRIDA)AS TOTAL FROM LARIOS_CORRIDAS_EMPRESA '.
	      'WHERE ID_CORRIDA = ? AND FECHA = ? ';
    my $dbExist = $_SERVER->prepare( $qry );
    $dbExist->bind_param(1, $datos[0]);
    $dbExist->bind_param(2, $datos[2]);
    $dbExist->execute();

    $total = $dbExist->fetchrow_array();

print("El valor es $total\n");
    return $total;
}

sub setCorridaOrigen{
     my $terminal = shift;
     my $qry = "SELECT d.ID_CORRIDA, d.FECHA, d.ESTATUS, ". 
               "(SELECT RFC_FACTURA FROM SERVICIOS S WHERE S.TIPOSERVICIO = c.TIPOSERVICIO)AS EMPRESA, d.ID_TERMINAL ".
               "FROM PDV_T_CORRIDA c INNER JOIN PDV_T_CORRIDA_D d ON c.ID_CORRIDA = d.ID_CORRIDA AND c.FECHA = d.FECHA ".
               "WHERE c.FECHA BETWEEN ? AND ? AND d.ESTATUS IN ('V','D') AND d.ID_TERMINAL = ? ";
    my $dbCorrida = $_SERVER->prepare($qry);
    $dbCorrida->bind_param(1, $f_inicio);
    $dbCorrida->bind_param(2, $f_final);
    $dbCorrida->bind_param(3, $terminal);
    $dbCorrida->execute();
    while(my @out = $dbCorrida->fetchrow()){
	&insertTabla(@out);
    }
}

sub setCorridaManual{
    my $qry = "SELECT d.ID_CORRIDA, d.FECHA, d.ESTATUS, ".
              "(SELECT RFC_FACTURA FROM SERVICIOS S WHERE S.TIPOSERVICIO = c.TIPOSERVICIO)AS EMPRESA, d.ID_TERMINAL ". 
              "FROM PDV_T_CORRIDA_D d INNER JOIN PDV_T_CORRIDA c ON d.ID_CORRIDA = c.ID_CORRIDA AND d.FECHA = c.FECHA ".
              "WHERE d.FECHA BETWEEN ? AND ? AND d.ID_CORRIDA REGEXP CONCAT('^',d.ID_TERMINAL) AND ESTATUS IN ('D','V')";
    my $dbManual = $_SERVER->prepare( $qry );
    $dbManual->bind_param(1, $f_inicio);
    $dbManual->bind_param(2, $f_final);
    $dbManual->execute();
    while(my @out = $dbManual->fetchrow()){

        my $d = &existTable($out[0], $out[1]);
	print("valor es $d\n");
	    &insertTabla(@out);
    }
}


#main 
$_SERVER = &conectaServer($db, $host, $user, $password);
my @origens = &getOrigenRuta();
foreach my $x(@origens){
   print("$x\n");
   &setCorridaOrigen($x);
}

@origens = &setCorridaManual();

$_SERVER->disconnect();


