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
               "WHERE ESTATUS = 'A' AND ID_TERMINAL = 'MEX'";
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
   my $query = "SELECT DISTINCT(CAST(FECHA_HORA AS DATE))AS FECHA ".
	       "FROM PDV_T_TALLER_JSON ".
	       "WHERE CAST(FECHA_HORA AS DATE) BETWEEN '2020-09-01' AND (SELECT DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) ";

   my $stv = $_REMOTO->prepare( $query );
   $stv->execute();

   while(my @kk = $stv->fetchrow_array()){
     eval{
	my $query = "INSERT INTO ADM_STATUS_TABLA(FECHA, ID_TERMINAL, TABLA, STATUS) ".
		    "VALUES(?, ?, 'PDV_T_TALLER_JSON', 0)";
        my $stq = $_SERVER->prepare( $query );
        $stq->bind_param(1, $kk[0]);
        $stq->bind_param(2, $terminal);
	$stq->execute();
      };
   }
   $query = "SELECT FECHA ".
	    "FROM ADM_STATUS_TABLA ".
	    "WHERE ID_TERMINAL = ? AND TABLA = 'PDV_T_TALLER_JSON' AND STATUS = 0 ". 
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


sub getTotalGuiaCorporativo{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_TALLER_JSON ".
               "WHERE cast(FECHA_HORA AS DATE) = ? ";
   my $sth = $_SERVER->prepare($query);
   $sth->bind_param(1, $fecha);
   $sth->execute();
   while(@out = $sth->fetchrow_array()){
      return $out[0];
   }
}

sub getTotalGuiaREMOTO{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_TALLER_JSON ".
               "WHERE cast(FECHA_HORA as DATE) = ? ";
   my $sth = $_REMOTO->prepare($query);
   $sth->bind_param(1, $fecha);
   $sth->execute();
   while(@out = $sth->fetchrow_array()){
      return $out[0];
   }
}

sub actualizaADM{
    my ($fecha, $ter) = @_;
    my $tt_corpo = &getTotalGuiaCorporativo($fecha, $ter);
    my $tt_lugar = &getTotalGuiaREMOTO($fecha, $ter);
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
    my $query = "UPDATE ADM_STATUS_TABLA SET STATUS = ?, LUGAR  = ?, CORPORATIVO = ?  WHERE FECHA = ? AND TABLA = 'PDV_T_TALLER_JSON' ".
                "AND ID_TERMINAL = ?";
    my $sth = $_SERVER->prepare( $query ); 
    $sth->bind_param(1, $estado );
    $sth->bind_param(2, $tt_lugar );
    $sth->bind_param(3, $tt_corpo );
    $sth->bind_param(4, $fecha );
    $sth->bind_param(5, $ter );
    $sth->execute();
}

sub getGuiaDespacho{
    my ($fecha, $terminal) = @_;
    my $query = "SELECT  ID_REGISTRO, BUS, FECHA_HORA, OCULTO, USER, WEB_SERVICE ".
	       "FROM PDV_T_TALLER_JSON  ".
               "WHERE CAST(FECHA_HORA AS DATE) = ? ";
    my $stv = $_REMOTO->prepare( $query );
    $stv->bind_param(1, $fecha);
    $stv->execute();

    while(my @outs = $stv->fetchrow_array()){
	    $query = "INSERT INTO PDV_T_TALLER_JSON(ID_REGISTRO, BUS, FECHA_HORA, OCULTO, USER, WEB_SERVICE) ".
	             "VALUES($outs[0], $outs[1], '$outs[2]',  '$outs[3]', '$outs[4]', $outs[5] )";
	eval{
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
     $_REMOTO = &conectaServer($db, $tabla[3], $tabla[1], $tabla[2]);
     my $aFechaNew = &getFechaTerminal($tabla[0]);
print "$aFechaNew   $afechaNew ....\n";
     &getGuiaDespacho($aFechaNew, $tabla[0]);
     &actualizaADM($aFechaNew, $tabla[0]);
     $_REMOTO->disconnect();
}
$_SERVER->disconnect();
