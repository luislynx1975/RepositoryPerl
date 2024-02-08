use DBI;
use Net::Ping;

my $db = "CORPORATIVO";
my $host = "localhost";
my $db = "CORPORATIVO";
my $port = 3306;
my $user = "replicacion";
my $password = "\#\@Vi\@j\@Mor3l0s";
#my $user = "root";
#my $password = "\#R0j0N3no\$";
my $_SERVER = undef;
my $_REMOTO = undef;

my @a_tablas = ('PDV_T_GUIA','PDV_T_CORRIDA','PDV_T_CORRIDA_D');

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
               "WHERE ESTATUS = 'A' AND ID_TERMINAL not in ('WEB','SD1','MOV')  ORDER BY 1";
   my $stt = $_SERVER->prepare($query);
   $stt->execute();
   while(my @ins =  $stt->fetchrow_array() ){
       $outs[$id] = \@ins;
       $id++;
   }
   return @outs;
}

sub getTotalBoletosCorporativo{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_BOLETO ".
              "WHERE CAST(FECHA_HORA_BOLETO AS DATE) = ? AND ID_TERMINAL = ?";
   my $sth = $_SERVER->prepare($query);
   $sth->bind_param(1, $fecha);
   $sth->bind_param(2, $terminal);
   $sth->execute();
   while(@out = $sth->fetchrow_array()){
      return $out[0];
   }
}

sub getTotalBoletosREMOTO{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_BOLETO ".
              "WHERE CAST(FECHA_HORA_BOLETO AS DATE) = ? AND ID_TERMINAL = ?";
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
    my $tt_corpo = &getTotalBoletosCorporativo($fecha, $ter);
    my $tt_lugar = &getTotalBoletosREMOTO($fecha, $ter);
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
    my $query = "UPDATE ADM_STATUS_TABLA SET STATUS = ?, LUGAR  = ?, CORPORATIVO = ?  WHERE FECHA = ? AND TABLA = 'PDV_T_BOLETO' ".
                "AND ID_TERMINAL = ?";
    my $sth = $_SERVER->prepare( $query ); 
    $sth->bind_param(1, $estado );
    $sth->bind_param(2, $tt_lugar );
    $sth->bind_param(3, $tt_corpo );
    $sth->bind_param(4, $fecha );
    $sth->bind_param(5, $ter );
    $sth->execute();
}


sub getBoletoCancelado{
    print "getBoletoCancelado\n";
    my $query = "SELECT A.ID_BOLETO, A.ID_TERMINAL, A.TRAB_ID_CANCELADO, A.FECHA_HORA_CANCELADO, A.ID_TAQUILLA, ".
                "A.TRAB_ID, A.TRAB_ID_AUTORIZA, YEAR(B.FECHA_HORA_BOLETO)AS ANIO ".
                "FROM PDV_T_BOLETO_CANCELADO A INNER JOIN PDV_T_BOLETO B ON B.ID_BOLETO = A.ID_BOLETO AND ".
                "B.TRAB_ID = A.TRAB_ID AND B.ID_TERMINAL = A.ID_TERMINAL ".
		"WHERE REPLICADO = 0";
    my $str = $_REMOTO->prepare($query);
    $str->execute();
    while(@outs = $str->fetchrow_array()){
       eval{
          $insert = "INSERT INTO PDV_T_BOLETO_CANCELADO(ID_BOLETO, ID_TERMINAL, TRAB_ID_CANCELADO, FECHA_HORA_CANCELADO, ID_TAQUILLA, TRAB_ID, ".
                    "TRAB_ID_AUTORIZA) ".
		    "VALUES($outs[0], '$outs[1]', '$outs[2]', '$outs[3]', $outs[4], '$outs[5]', '$outs[6]')";
          my $stg = $_SERVER->prepare( $insert);
          $stg->execute();	
       };
       my $update = "UPDATE PDV_T_BOLETO_CANCELADO SET REPLICADO = 1 WHERE ID_BOLETO = $outs[0] AND ".
                 "ID_TERMINAL = '$outs[1]' AND TRAB_ID =  '$outs[5]' ";
       my $ste = $_REMOTO->prepare( $update );
       $ste->execute();
       my $servidor = "UPDATE PDV_T_BOLETO SET ESTATUS = 'C' WHERE ID_BOLETO = $outs[0] AND ".
                      "ID_TERMINAL = '$outs[1]' AND TRAB_ID = '$outs[5]' ";
       my $sts = $_SERVER->prepare( $servidor );
       $stg = $_SERVER->prepare( $servidor );
       $stg->execute();	
       $servidor = "UPDATE PDV_T_BOLETO_$outs[7] SET ESTATUS = 'C' WHERE ID_BOLETO = $outs[0] AND ".
                   "ID_TERMINAL = '$outs[1]' AND TRAB_ID = '$outs[5]' ";
       my $sts = $_SERVER->prepare( $servidor );
       $stg = $_SERVER->prepare( $servidor );
       $stg->execute();	
    }
}

#main 
$_SERVER = &conectaServer($db, $host, $user, $password);
my @ttDatos = &getTerminales();
foreach my $x (0..@ttDatos -1){
     my @tabla = @{$ttDatos[$x]};
     my $duracion = 4;
     $p = Net::Ping->new();
     $p->hires();
     (my $ret, my $duracion, my $ip ) = $p->ping($tabla[3], $duracion);
     if($ret == 1){
print 'boleto cancelado :  ' . $tabla[0] . "  " . $tabla[1] . "  " . $tabla[2] . "  " . $tabla[3]. "....   " . $aFechaNew . "\n";
	$_REMOTO = &conectaServer($db, $tabla[3], $tabla[1], $tabla[2]);
	if(defined $_REMOTO){
	    &getBoletoCancelado($tabla[0]);
        }else{
	    print "no se creo conexion $tabla[0]\n";
        }
     }
     $p->close();
}


$_SERVER->disconnect();
