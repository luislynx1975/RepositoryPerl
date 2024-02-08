#!/usr/bin/perl

use DBI;
use Net::Ping;

my $host = "localhost";
my $db = "CORPORATIVO";
my $port = 3306;
my $user = "backup";
my $password = "3c0M0t0*1027";
my $_SERVER = undef;
my $_REMOTO = undef;

#Conectamos al server local y regresa la conexion
sub conectaServer{
        local($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        $dbh = DBI->connect($connectionInfo,$user_db,$pass_db, {RaiseError => 1, PrintError => 0} );
        return $dbh;
}

sub querys{
  my $inicio = shift;
  $qry = "SELECT B.ID_TERMINAL, B.TRAB_ID, SUM(B.TARIFA), COUNT(*) ".
	 "FROM PDV_T_BOLETO B INNER JOIN PDV_C_GRUPO_SERVICIOS G ON G.ID_TERMINAL = B.ID_TERMINAL ".
	 "WHERE FECHA_HORA_BOLETO BETWEEN '2022-05-01 00:00:00' AND '2022-05-31 00:00:00' AND B.ESTATUS = 'V' AND G.ID_GRUPO = 'PUL' AND B.ID_TERMINAL = ? ".
	 "GROUP BY 1, 2";
  my $db_venta = $_REMOTO->prepare( $qry );
  $db_venta->bind_param(1, $inicio);
  $db_venta->execute(); 
  while(my @data = $db_venta->fetchrow_array()){
     print("$data[0]  , $data[1] ,  $data[2] , $data[3] \n"); 
  }
}

#main 
$_SERVER = &conectaServer($db, $host, $user, $password);

$qry = "SELECT T.ID_TERMINAL, T.IPv4, T.BD_USUARIO, T.BD_PASSWORD, T.BD_BASEDATOS ".
       "FROM PDV_C_TERMINAL T INNER JOIN PDV_C_GRUPO_SERVICIOS G ON T.ID_TERMINAL = G.ID_TERMINAL ".
       "WHERE T.ESTATUS = 'A'  AND G.ID_GRUPO = 'PUL' ".
       "ORDER BY 1";
$str = $_SERVER->prepare( $qry );
$str->execute();
$idx = 0;
$duracion = 4;
$dura=5;

#recorremos de forma loca		
while(@data = $str->fetchrow_array()){
  $p = Net::Ping->new("tcp",8);
  $p->port_number("3306");
  $duration = $p->ping($data[1],$dura); 
print("Terminal : $data[0]\n");
#  print join('=',@data) . "\n";
#  print $data[1]." ==> ".$data[0]." ==> ".$duration . "\n";
  if($duration  ==  1){
    $_REMOTO = &conectaServer($data[4], $data[1] , $data[2], $data[3]);
    &querys($data[0]);
  }else{
#    &querys($data[0]);	
  }
	$p->close();
}

$_REMOTO->disconnect();

$str->finish();
$_SERVER->disconnect();
