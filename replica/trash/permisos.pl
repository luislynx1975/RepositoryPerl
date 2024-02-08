use DBI;
use Net::Ping;
use Time::HiRes;

my $host = "localhost";
my $db = "CORPORATIVO";
my $port = 3306;
my $user = "root";
my $password = "3st\@b\@M0sB13n\$";
my $_SERVER = undef;
my $_REMOTO = undef;

#Conectamos al server local y regresa la conexion
sub conectaServer{
        local($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
	eval{
           #$dbh = DBI->connect($connectionInfo,$user_db,$pass_db, {RaiseError => 1, PrintError => 1} );
            $dbh = DBI->connect($connectionInfo,$user_db,$pass_db) or die "No puedo conectarme a $data_source: $dbh->errstr\n";
	};
	if($@){
	   $dbh = undef;
	}
        return $dbh;
}

#main 
$_SERVER = &conectaServer($db, $host, $user, $password);

$qry = "SELECT ID_TERMINAL, IPv4, BD_USUARIO, BD_PASSWORD, BD_BASEDATOS ".
       "FROM PDV_C_TERMINAL WHERE ESTATUS = 'A' AND ID_TERMINAL NOT IN ('MOV', 'WEB', 'HTR') GROUP BY IPv4 ORDER BY IPv4 ASC ;";

$str = $_SERVER->prepare( $qry );
$str->execute();
$idx = 0;
$duracion = 5;
@elementos = ();

$size = @elementos;
print "Elementos: ".$size."\n"; 

while(@data = $str->fetchrow_array()){
	$p = Net::Ping->new("tcp");
	$p->port_number("3306");
	$p->hires();
  
	($ret, $duration, $ip) = $p->ping($data[1], 5.5);
	
	if($ret == '1')
	{
    	$_REMOTO = &conectaServer($data[4], $data[1], 'root', '#R0j0N3no$');
    	$qryP = "SELECT Table_name, Table_priv, (SELECT ID_TERMINAL FROM CORPORATIVO.PDV_C_SERVIDOR ORDER BY ID_TERMINAL LIMIT 1) as terminal".
    	        " FROM mysql.tables_priv WHERE Db = 'CORPORATIVO' AND User = 'venta' ORDER BY Table_name ASC;";
    	$ltr = $_REMOTO->prepare( $qryP );
		$ltr->execute();
	
		while( @outs = $ltr->fetchrow_array() ){

			$sentencia = "INSERT INTO tables_priv (Table_name, Table_priv, terminal) VALUES ('".$outs[0]."', '".$outs[1]."', '".$outs[2] ."');";
			#print $sentencia."\n";
			push @elementos, $sentencia;
		}
		$ltr->finish();
		$_REMOTO->disconnect();

		$p->close();
		#$ret = -1;
	}
	else
	{
		print "Terminal Desconectada: ".$data[1]. " salida: ". $ret."\n";
	}

	#$ret = -1;
	$p->close();
}

$size2 = @elementos;
print "Elementos: ".$size2."\n"; 

$str->finish();
$_SERVER->disconnect();


print "remoto: "."\n"; 
 
$_REGISTRA = &conectaServer("stock", "192.168.1.31", "root", "#R0j0N3no\$");
    foreach $elem (@elementos) {
        #print $elem."\n";
        $reg = $_REGISTRA->prepare( $elem );
		$reg->execute();
	
    }
print "remoto2: "."\n"; 
$reg->finish();
$_REGISTRA->disconnect();
