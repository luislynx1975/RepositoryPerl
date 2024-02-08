use DBI;
use Net::Ping;

my $db = "CORPORATIVO";
my $host = "192.168.1.13";
my $db = "CORPORATIVO";
my $port = 3306;
my $user = "replicacion";
my $password = "\#\@Vi\@j\@Mor3l0s";
my $_SERVER = undef;
my $_REMOTO = undef;


my $ahora = time();
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($ahora);
my $diaMesAnio = '-01-01';
my $mesDiciembre = '-12-';
my $lastDay = 31;

#Conectamos al server local y regresa la conexion
sub conectaServer{
        local($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
	eval{
            $dbh = DBI->connect($connectionInfo,$user_db,$pass_db, {RaiseError => 1, PrintError => 0} );
	};
	if($@){
	   $dbh = undef;
	}
        return $dbh;
}


sub getDiaSemana{
	my $fecha = shift;
#	my $query = "SELECT MAKEDATE(YEAR(NOW()), 1 ), DAYOFWEEK(MAKEDATE(YEAR('$fecha'), 1 ))AS DIA";
	my $query = "SELECT MAKEDATE(YEAR(NOW()), 1 ), DAYOFWEEK('$fecha')AS DIA";
	my $sth = $_SERVER->prepare( $query );
	$sth->execute();
	my @a_datos = $sth->fetchrow_array();
        return $a_datos[1];
}


#main 
$_SERVER = &conectaServer($db, $host, $user, $password);
$diaMesAnio = $year + 1900 . $diaMesAnio;
my $_diaSemana = &getDiaSemana($diaMesAnio);
my $dia = 0;
if($_diaSemana == 2){
   ;
}else{
     do{
	$diaMesAnio = ($year - 1) + 1900 . $mesDiciembre . ($lastDay - $dia);
	$_diaSemana = &getDiaSemana($diaMesAnio);	
        $dia++; 	
     }while($_diaSemana != 2);
}



$_SERVER->disconnect();
