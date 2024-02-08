use DBI;
use Net::Ping;
use Time::HiRes;

my $db = "CORPORATIVO";
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
            $dbh = DBI->connect($connectionInfo,$user_db,$pass_db, {RaiseError => 1, PrintError => 0} );
	};
	if($@){
	   $dbh = undef;
	}
        return $dbh;
}

sub querys($){
	local($terminal) = shift;
	local $rows_affected = 0;
	$qry = "SELECT ID_TERMINAL, SENTENCIA, CONSECUTIVO FROM PDV_T_QUERY WHERE ID_TERMINAL = ? ORDER BY CONSECUTIVO  LIMIT 80";
        $ltr = $_SERVER->prepare($qry);
	$ltr->bind_param(1,$terminal);
	$ltr->execute();
	
	#open(ARCHIVO,">>$dir") || die "No puedo escribir al archivo\n";			

	while( @outs = $ltr->fetchrow_array() ){

		#if($outs[0] = '1730' )
		#{	
		#	print ARCHIVO  "$outs[1]\n ";
		#}

		$rows_affected = 0;
		#ejecuta el query en forma remota
		if( ($outs[1] =~ /^INSERT/) ){
		    eval{
			$valor = $_REMOTO->prepare( $outs[1] ) ;
			$valor->execute();
			$rows_affected = 1;
		    };
		    if( $@ =~ /Duplicate/){
			$rows_affected = 1;
		    }
	        }
		if( ($outs[1] =~ /^UPDATE/) ){
		   eval{
		      $rows_affected = $_REMOTO->do( $outs[1] ) ;
		   };#if($@){ 
    		#	local $_ = $@;
		#	print $_;
    		#	&$catch();
  		#   }
		}

		if( ($outs[1] =~ /^DELETE/) ){
		      $rows_affected = $_REMOTO->do( $outs[1] ) ;
		}

		if(  ($rows_affected == 1) || ($rows_affected =~ '0E0') ){
			#print "Eliminado el query\n";
		        #borramos los datos de manera local de la tabla de query
			$query = "DELETE FROM PDV_T_QUERY WHERE  CONSECUTIVO = ? ";
			$llocal = $_SERVER->prepare($query);
			$llocal->bind_param(1, $outs[2]);
			$llocal->execute();
		}else{
			$query = "INSERT INTO ERROR_TABLA(HORA_ERROR, ERROR, INSTRUCCION) VALUES(NOW(),?,?)";
			$lerror = $_SERVER->prepare($query);
			$lerror->bind_param(1, $outs[0] . '-Replicador' );
			$lerror->bind_param(2, $outs[1] );
			#$lerror->execute();

			$query = "DELETE FROM PDV_T_QUERY WHERE  CONSECUTIVO = ? ";
			$llocal = $_SERVER->prepare($query);
			$llocal->bind_param(1, $outs[2]);
			$llocal->execute();
		}
	}

	 close(ARCHIVO);

	$ltr->finish();
}


#main 
$_SERVER = &conectaServer($db, $host, $user, $password);

$qry = "SELECT DISTINCT(Q.ID_TERMINAL), T.IPv4, T.BD_USUARIO, T.BD_PASSWORD, T.BD_BASEDATOS ".
       "FROM PDV_T_QUERY Q INNER JOIN PDV_C_TERMINAL T ON Q.ID_TERMINAL = T.ID_TERMINAL ".
       "WHERE T.ESTATUS = 'A' ORDER BY 2 ";
$str = $_SERVER->prepare( $qry );
$str->execute();
$idx = 0;
$duracion = 5;
while(@data = $str->fetchrow_array()){
	#$p = Net::Ping->new("icmp",$duracion);
  #$p = Net::Ping->new("icmp");
	#$p = Net::Ping->new("tcp",$duracion);
	#$p->port_number("3306");
	#($ret, $duracion, $ip ) = $p->ping($data[1], $duracion);
	
  $p = Net::Ping->new("tcp");
  $p->port_number("3306");
  $p->hires();
  
  #$p = Net::Ping->new();
  #$p->hires();
  ($ret, $duration, $ip) = $p->ping($data[1], 5.5);
  print $data[0].' ==> '. $data[1].' ==> '. $ret.' ==> '. $duration.' ==> '. $ip ."\n";

    if($ret == 1){
    $_REMOTO = &conectaServer($data[4], $data[1], $data[2], $data[3]);
		if(defined $_REMOTO){
		  &querys($data[0]);
      $p->close();
		}else{
		  print "no se creo conexion\n";
      $p->close();
		}
		if(defined $_REMOTO){
		  $_REMOTO->disconnect();
      $p->close();
     }
     $p->close();
     $ret = -1;
  }

  $ret = -1;
  $p->close();
}
$str->finish();
$_SERVER->disconnect();
