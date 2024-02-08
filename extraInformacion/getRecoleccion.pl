use DBI;
use Net::Ping;

my $db = "CORPORATIVO";
my $host = "localhost";
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


sub getTerminales{
   my @outs = undef;
   my $id = 0;
   my $query = "SELECT ID_TERMINAL, BD_USUARIO, BD_PASSWORD,IPV4 ".
	       "FROM PDV_C_TERMINAL ".
               "WHERE ESTATUS = 'A' AND ID_TERMINAL not in ('WEB','SD1','MOV') ORDER BY 1";
   my $stt = $_SERVER->prepare( $query );
   $stt->execute();
   while(my @ins =  $stt->fetchrow_array() ){
       $outs[$id] = \@ins;
       $id++;
   }
   return @outs;
}

sub getFechaTerminal{
   my $terminal = shift;
   my $idx = 0;
   my @outs = undef;

   my $query = "select * from ".
               " (select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from ".
               " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, ".
               " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1, ".
               " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2, ".
               " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3, ".
               " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v ".
               "where fechas between ( SELECT DATE_SUB(CURRENT_DATE(),INTERVAL 900 DAY) ) and ( SELECT DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY) ) ".
               "ORDER BY 1 desc";
   my $stv = $_SERVER->prepare( $query );
   $stv->execute();
   while(my @kk = $stv->fetchrow_array()){
        $query = "SELECT COUNT(*) total ".
                 "FROM ADM_STATUS_TABLA  ".
                 "WHERE FECHA = ? AND ID_TERMINAL = ? AND TABLA = 'PDV_T_RECOLECCION' ";
        my $sts_tabla = $_SERVER->prepare( $query );
        $sts_tabla->bind_param(1, $kk[0]);
        $sts_tabla->bind_param(2, $terminal);
        $sts_tabla->execute();
        my @atotal = $sts_tabla->fetchrow_array();
        if($atotal[0] == 0){
     		eval{
			my $query = "INSERT INTO ADM_STATUS_TABLA(FECHA, ID_TERMINAL, TABLA, STATUS) ".
		    		    "VALUES(?, ?, 'PDV_T_RECOLECCION', 0)";
        		my $stq = $_SERVER->prepare( $query );
        		$stq->bind_param(1, $kk[0]);
        		$stq->bind_param(2, $terminal);
			$stq->execute();
      		};
	}
   }
   $query = "SELECT FECHA ".
	    "FROM ADM_STATUS_TABLA ".
	    "WHERE ID_TERMINAL = ? AND TABLA = 'PDV_T_RECOLECCION' AND STATUS = 0 ". 
	    "ORDER BY 1 desc ".
	    "LIMIT 1";
   $stv = $_SERVER->prepare( $query );
   $stv->bind_param(1, $terminal);
   $stv->execute();
   while(my @y = $stv->fetchrow_array() ){
      $p = $y[0];
   }
   return $p;
}


sub getTotalRecoleccionCorporativo{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_RECOLECCION ".
              "WHERE CAST(FECHA_HORA AS DATE) = ? AND ID_TERMINAL = ?";
   my $sth = $_SERVER->prepare($query);
   $sth->bind_param(1, $fecha);
   $sth->bind_param(2, $terminal);
   $sth->execute();
   while(@out = $sth->fetchrow_array()){
      return $out[0];
   }
}

sub getTotalRecoleccionREMOTO{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_RECOLECCION ".
              "WHERE CAST(FECHA_HORA AS DATE) = ? AND ID_TERMINAL = ?";
   my $sth = $_REMOTO->prepare($query);
   $sth->bind_param(1, $fecha);
   $sth->bind_param(2, $terminal);
   $sth->execute();
   while(@out = $sth->fetchrow_array()){
      return $out[0];
   }
}

sub actualizaADM{
    my ($fecha, $ter) = @_;
    my $tt_corpo = &getTotalRecoleccionCorporativo($fecha, $ter);
    my $tt_lugar = &getTotalRecoleccionREMOTO($fecha, $ter);
    my $estado = 0;
    if($tt_corpo == $tt_lugar){
	$estado = 1;
    }
    if($tt_corpo > $tt_lugar){
	$estado = 2;
    }
    if($tt_corpo < $tt_lugar){
	$estado = 3;
    }
    my $query = "UPDATE ADM_STATUS_TABLA SET STATUS = ?, LUGAR  = ?, CORPORATIVO = ?  WHERE FECHA = ? AND TABLA = 'PDV_T_RECOLECCION' ".
                "AND ID_TERMINAL = ?";
    my $sth = $_SERVER->prepare( $query ); 
    $sth->bind_param(1, $estado );
    $sth->bind_param(2, $tt_lugar );
    $sth->bind_param(3, $tt_corpo );
    $sth->bind_param(4, $fecha );
    $sth->bind_param(5, $ter );
    $sth->execute();
}

sub getRecoleccion{
    my ($fecha, $terminal) = @_;
    my $query = "SELECT ID_TERMINAL, ID_TAQUILLA, ID_CORTE, FECHA_HORA, ID_EMPLEADO, ID_EMPLEADO_REALIZA, IMPORTE ".
		"FROM PDV_T_RECOLECCION  ".
		"WHERE CAST(FECHA_HORA AS DATE) = ? AND ID_TERMINAL = ? ";
    my $str = $_REMOTO->prepare($query);
    $str->bind_param(1, $fecha);
    $str->bind_param(2, $terminal);
    $str->execute();
    while(my @outs = $str->fetchrow_array()){
	$query = "INSERT INTO PDV_T_RECOLECCION(ID_TERMINAL, ID_TAQUILLA, ID_CORTE, FECHA_HORA, ID_EMPLEADO, ID_EMPLEADO_REALIZA, IMPORTE) ".
	         "VALUES('$outs[0]', $outs[1], $outs[2], '$outs[3]', '$outs[4]', '$outs[5]', $outs[6] )";
	eval{
#print $query . "\n";
	    my $stl = $_SERVER->prepare( $query );
            $stl->execute();
        };
    }
}



#main 
$_SERVER = &conectaServer($db, $host, $user, $password);
my @ttDatos = &getTerminales();
foreach my $x (0..@ttDatos -1){
     my @tabla = @{$ttDatos[$x]};
     my $aFechaNew = &getFechaTerminal($tabla[0]);
     my $duracion = 4;
     $p = Net::Ping->new();
     $p->hires();
     (my $ret, my $duracion, my $ip ) = $p->ping($tabla[3], $duracion);
     if( $ret == 1){
print("$tabla[0]  $aFechaNew   $tabla[3], $tabla[1], $tabla[2]\n"); 
	$_REMOTO = &conectaServer($db, $tabla[3], $tabla[1], $tabla[2]);
	if(defined $_REMOTO){
           &getRecoleccion($aFechaNew, $tabla[0]);
           &actualizaADM($aFechaNew, $tabla[0]);
        }else{
	    print "no se creo conexion $tabla[0]\n";
        }
     }
     $p->close();
}


$_SERVER->disconnect();
