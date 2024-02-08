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


sub getFechasBoleto{
        my $idx = 0;
        my $query = undef;
        my $sth = undef;
        my @a_fechas = undef;
        my %h_fechas = ();
        #$query = "SELECT CURRENT_DATE()";
        $query = "select * from ".
"(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v ".
"where fechas between '2019-01-01' and '2019-12-31' ORDER BY 1";
        $sth = $_SERVER->prepare( $query );
        $sth->execute();
        while( (@a_fechas ) = $sth->fetchrow_array() ){
                $a_fecha_boleto[$idx] = $a_fechas[0];
                $idx++;
        }
        foreach my $fecha (@a_fecha_boleto){
                push @a_fechas, $fecha if not $h_fechas{$fecha}++;
        }
        return @a_fechas;
}

sub setGetHoraCorrida{
	my $dia = shift;
	my @a_boleto;
	my $inicio = $dia . ' 00:00';
	my $fin = $dia . ' 23:59';
print("Procesando $inicio  al $fin \n");
 	my $query = "SELECT ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, B.ID_CORRIDA, B.FECHA, ".
		    "(SELECT HORA  ".
		    "FROM PDV_T_CORRIDA_D D  ".
		    "WHERE D.ID_CORRIDA = B.ID_CORRIDA AND D.ID_TERMINAL = B.ID_TERMINAL ".
		    "LIMIT 1 ) AS HORA ".
		    "FROM PDV_T_BOLETO_2019 B  ".
		    "WHERE B.HORA_CORRIDA IS NULL  AND B.ID_TERMINAL NOT IN ('MOV', 'WEB')  ".
		    "AND B.FECHA_HORA_BOLETO  BETWEEN ? AND ? ";
	my $sth = $_SERVER->prepare( $query);
	$sth->bind_param(1, $inicio);
	$sth->bind_param(2, $fin);
	$sth->execute();
        while( (@a_boleto ) = $sth->fetchrow_array() ){
	   if (defined $a_boleto[5]){
		my $qry_boleto = "UPDATE PDV_T_BOLETO_2019 SET HORA_CORRIDA = ? ".
				 "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? AND ID_CORRIDA = ?";
		my $stb = $_SERVER->prepare( $qry_boleto );
		$stb->bind_param(1, $a_boleto[5]);
		$stb->bind_param(2, $a_boleto[0]);
		$stb->bind_param(3, $a_boleto[1]);
		$stb->bind_param(4, $a_boleto[2]);
		$stb->bind_param(5, $a_boleto[3]);
		$stb->execute();

		$qry_boleto = "UPDATE PDV_T_BOLETO SET HORA_CORRIDA = ? ".
				 "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? AND ID_CORRIDA = ?";
		$stb = $_SERVER->prepare( $qry_boleto );
		$stb->bind_param(1, $a_boleto[5]);
		$stb->bind_param(2, $a_boleto[0]);
		$stb->bind_param(3, $a_boleto[1]);
		$stb->bind_param(4, $a_boleto[2]);
		$stb->bind_param(5, $a_boleto[3]);
		$stb->execute();
	   }
	}
}

#main 
$_SERVER = &conectaServer($db, $host, $user, $password);
my @a_dias = &getFechasBoleto();
foreach $dia (@a_dias){
    &setGetHoraCorrida($dia);
}
$_SERVER->disconnect();
