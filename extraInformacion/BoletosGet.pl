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
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

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
               "WHERE ESTATUS = 'A' AND ID_TERMINAL NOT IN ('WEB','MOV') ".
               " AND ID_TERMINAL  IN ('TCS') ORDER BY 1";
#               "WHERE ESTATUS = 'A' AND ID_TERMINAL NOT IN ('WEB','MOV') AND ID_TERMINAL in ('CUE','MEX') ORDER BY 1";
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
   my $query = "SELECT DISTINCT(FECHA_BOLETO) FROM PDV_T_BOLETO  ".
	       "WHERE FECHA_BOLETO BETWEEN '2020-01-01' AND (SELECT DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY)) AND  ".
	       "FECHA_BOLETO  NOT IN (SELECT DISTINCT(FECHA) FROM ADM_STATUS_TABLA WHERE ID_TERMINAL = ? AND ".
	       " TABLA = 'PDV_T_BOLETO' AND STATUS <> 0) ".
	       " ORDER BY 1 DESC ".
               "LIMIT 1";	

   my $stv = $_SERVER->prepare( $query );
   $stv->bind_param(1, $terminal);
   $stv->execute();
   while(my @kk = $stv->fetchrow_array()){
     eval{
	my $query = "INSERT INTO ADM_STATUS_TABLA(FECHA, ID_TERMINAL, TABLA, STATUS) ".
		    "VALUES(?, ?, 'PDV_T_BOLETO', 0)";
        my $stq = $_SERVER->prepare( $query );
        $stq->bind_param(1, $kk[0]);
        $stq->bind_param(2, $terminal);
	$stq->execute();
      };
   }
   $query = "SELECT FECHA ".
	    "FROM ADM_STATUS_TABLA ".
	    "WHERE ID_TERMINAL = ? AND TABLA = 'PDV_T_BOLETO' AND STATUS = 0 ". 
	    "ORDER BY 1 ASC ".
	    "LIMIT 1";
   $stv = $_SERVER->prepare( $query );
   $stv->bind_param(1, $terminal);
   $stv->execute();
   while(my @y = $stv->fetchrow_array() ){
      $p = $y[0];
   }
   return $p;
}


sub getBoletoAnticipado{
   my ($fecha, $terminal, $anio) = @_;
   my $inserta = "";
   my $tabla_anual = "PDV_T_BOLETO_" . $anio;
   my $consulta = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ".
		  "ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, ".
		  "NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ".
		  "ID_PAGO_PINPAD_BANAMEX, TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, COMPLEMENTO_1, ".
		  " HORA_CORRIDA ".
		  "FROM PDV_T_BOLETO ".
		  "WHERE (FECHA_HORA_BOLETO BETWEEN ? AND ? )AND FECHA > ?  AND ID_TERMINAL = ? ";
   my $stc = $_REMOTO->prepare( $consulta );
   $stc->bind_param(1, $fecha . " 00:00");
   $stc->bind_param(2, $fecha . " 23:59");
   $stc->bind_param(3, $fecha);
   $stc->bind_param(4, $terminal);
   $stc->execute();
   while( my @yy = $stc->fetchrow_array()){
      eval{
         $inserta = "INSERT INTO PDV_T_BOLETO( ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ".
		     "ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, ".
		     "NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ".
		     "ID_PAGO_PINPAD_BANAMEX, TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, COMPLEMENTO_1) ".
		     "VALUES($yy[0], '$yy[1]', '$yy[2]', '$yy[3]', '$yy[4]', '$yy[5]', $yy[6], $yy[7], $yy[8], '$yy[9]', '$yy[10]', '$yy[11]', '$yy[12]', ".
                     "'$yy[13]', $yy[14], $yy[15], '$yy[16]', $yy[17], $yy[18], '$yy[19]', '$yy[20]', $yy[21], $yy[22], '$yy[23]', '$yy[24]' ) ";
                     
         my $sth = $_SERVER->prepare( $inserta );
         $sth->execute();
      };
      if ($@){
	 $inserta = "UPDATE PDV_T_BOLETO SET ESTATUS = ? ".
                    "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ";
         my $ste = $_SERVER->prepare( $inserta );
	 $ste->bind_param(1, $yy[3]);
	 $ste->bind_param(2, $yy[0]);
	 $ste->bind_param(3, $yy[1]);
	 $ste->bind_param(4, $yy[2]);
         $ste->execute();

	 $inserta = "UPDATE $tabla_anual SET ESTATUS = ?, HORA_CORRIDA = ? ".
                    "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ";
         my $ste = $_SERVER->prepare( $inserta );
	 $ste->bind_param(1, $yy[3]);
	 $ste->bind_param(2, $yy[25]);
	 $ste->bind_param(3, $yy[0]);
	 $ste->bind_param(4, $yy[1]);
	 $ste->bind_param(5, $yy[2]);
         $ste->execute();
      }
   }
}


sub setUpdateMovWeb{
    my ($anio) = @_;
    my @a_anual = undef;
    my $tabla_anual = "PDV_T_BOLETO_" . $anio;
    my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ORIGEN, DESTINO, ID_CORRIDA , B.FECHA, ". 
		"DATE_FORMAT(B.FECHA_HORA_BOLETO, '%Y-%m-%d')AS dia,  ".
		"DATE_FORMAT(B.FECHA_HORA_BOLETO, '%H:%i:%s')AS hora ".
	        "FROM $tabla_anual B ".
	        "WHERE B.HORA_CORRIDA IS NULL ";
    my $sth = $_SERVER->prepare( $query );
    $sth->execute();
    while(@a_anual = $sth->fetchrow_array()){
	$query = "SELECT D.HORA ".
		 "FROM PDV_T_CORRIDA_D D ".
		 "WHERE D.ID_TERMINAL = ? AND D.ID_CORRIDA = ? AND D.FECHA = ? ";
	my $stq = $_SERVER->prepare( $query );
	$stq->bind_param(1, $a_anual[3]);
	$stq->bind_param(2, $a_anual[5]);
	$stq->bind_param(3, $a_anual[6]);
	$stq->execute();

	my @a_hora = $stq->fetchrow_array();
	$query = "UPDATE $tabla_anual SET HORA_CORRIDA = ?, FECHA_BOLETO = ?, HORA_BOLETO = ? ".
		 "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
	my $stt = $_SERVER->prepare( $query );
        $stt->bind_param(1, $a_hora[0]);
        $stt->bind_param(2, $a_anual[7]);
        $stt->bind_param(3, $a_anual[8]);
        $stt->bind_param(4, $a_anual[0]);
	$stt->bind_param(5, $a_anual[1]);
	$stt->bind_param(6, $a_anual[2]);
	$stt->execute();

	$query = "UPDATE PDV_T_BOLETO SET HORA_CORRIDA = ?, FECHA_BOLETO = ?, HORA_BOLETO = ? ". 
		 "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
	$stt = $_SERVER->prepare( $query );
        $stt->bind_param(1, $a_hora[0]);
        $stt->bind_param(2, $a_anual[7]);
        $stt->bind_param(3, $a_anual[8]);
        $stt->bind_param(4, $a_anual[0]);
	$stt->bind_param(5, $a_anual[1]);
	$stt->bind_param(6, $a_anual[2]);
	$stt->execute();
    }
}


sub sgBoletosTerminal{
   my ($fecha, $terminal, $anio) = @_;
   my $inserta = "";
   my $tabla_anual = "PDV_T_BOLETO_" . $anio;
   my $consulta = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ".
		  "ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, ".
		  "NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ".
		  "ID_PAGO_PINPAD_BANAMEX, TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, COMPLEMENTO_1, ".
		  " HORA_CORRIDA ".
		  "FROM PDV_T_BOLETO ".
		  "WHERE (FECHA_HORA_BOLETO BETWEEN ? AND ? OR  CAST(FECHA_BOLETO as DATE) = CURRENT_DATE)   AND ID_TERMINAL = ? ";
   my $stc = $_REMOTO->prepare( $consulta );
   $stc->bind_param(1, $fecha . " 00:00");
   $stc->bind_param(2, $fecha . " 23:59");
   $stc->bind_param(3, $terminal);
   $stc->execute();
   while( my @yy = $stc->fetchrow_array()){
      eval{
         $inserta = "INSERT INTO PDV_T_BOLETO( ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ".
		     "ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, ".
		     "NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ".
		     "ID_PAGO_PINPAD_BANAMEX, TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, COMPLEMENTO_1) ".
		     "VALUES($yy[0], '$yy[1]', '$yy[2]', '$yy[3]', '$yy[4]', '$yy[5]', $yy[6], $yy[7], $yy[8], '$yy[9]', '$yy[10]', '$yy[11]', '$yy[12]', ".
                     "'$yy[13]', $yy[14], $yy[15], '$yy[16]', $yy[17], $yy[18], '$yy[19]', '$yy[20]', $yy[21], $yy[22], '$yy[23]', '$yy[24]' ) ";
                     
         my $sth = $_SERVER->prepare( $inserta );
         $sth->execute();
      };
      if ($@){
	 $inserta = "UPDATE PDV_T_BOLETO SET ESTATUS = ? ".
                    "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ";
         my $ste = $_SERVER->prepare( $inserta );
	 $ste->bind_param(1, $yy[3]);
	 $ste->bind_param(2, $yy[0]);
	 $ste->bind_param(3, $yy[1]);
	 $ste->bind_param(4, $yy[2]);
         $ste->execute();

	 $inserta = "UPDATE $tabla_anual SET ESTATUS = ?, HORA_CORRIDA = ? ".
                    "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ";
         my $ste = $_SERVER->prepare( $inserta );
	 $ste->bind_param(1, $yy[3]);
	 $ste->bind_param(2, $yy[25]);
	 $ste->bind_param(3, $yy[0]);
	 $ste->bind_param(4, $yy[1]);
	 $ste->bind_param(5, $yy[2]);
         $ste->execute();
      }
   }
}

sub getTotalBoletosCorporativo{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_BOLETO ".
                "WHERE CAST(FECHA_HORA_BOLETO AS DATE) = ? AND ID_TERMINAL = ? AND ESTATUS = 'V' AND ORIGEN = ? ";
   my $sth = $_SERVER->prepare($query);
   $sth->bind_param(1, $fecha);
   $sth->bind_param(2, $terminal);
   $sth->bind_param(3, $terminal);
   $sth->execute();
   while(@out = $sth->fetchrow_array()){
      return $out[0];
   }
}

sub getTotalBoletosREMOTO{
   my ($fecha, $terminal) = @_;
   my $query = "SELECT COUNT(*) AS TOTAL ".
	       "FROM PDV_T_BOLETO ".
               "WHERE CAST(FECHA_HORA_BOLETO AS DATE) = ? AND ID_TERMINAL = ? AND ESTATUS = 'V' AND ORIGEN = ?";
   my $sth = $_REMOTO->prepare($query);
   $sth->bind_param(1, $fecha);
   $sth->bind_param(2, $terminal);
   $sth->bind_param(3, $terminal);
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



sub getFechaActual{
    my $query = "SELECT CURRENT_DATE()";
    my $sth = $_SERVER->prepare($query);
    $sth->execute();
    while(@out = $sth->fetchrow_array()){
       return $out[0];
    }
}


#main 
$_SERVER = &conectaServer($db, $host, $user, $password);
my @ttDatos = &getTerminales();
my $anioActual = 0;
foreach my $x (0..@ttDatos -1){
     my @tabla = @{$ttDatos[$x]};
     my $aFechaNew = &getFechaTerminal($tabla[0]);
     my @afchs = split(/-/, $aFechaNew);
     my $exFecha =  scalar @afchs;
     $anioActual = $afchs[0];
     if($exFecha == 3){
         my $duracion = 4;
         $p = Net::Ping->new();
         $p->hires();
         (my $ret, my $duracion, my $ip ) = $p->ping($tabla[3], $duracion);
         if($ret == 0){
	    $_REMOTO = &conectaServer($db, $tabla[3], $tabla[1], $tabla[2]);
	    if(defined $_REMOTO){
	       &sgBoletosTerminal($aFechaNew, $tabla[0], $afchs[0]);
               &actualizaADM($aFechaNew, $tabla[0]);
            }else{
	        print "no se creo conexion $tabla[0]\n";
            }
         }
         $p->close();
     }
     if($exFecha == 0){
         my $duracion = 4;
         my $aFechaNew = &getFechaActual();
         my @afchs = split(/-/, $aFechaNew);
         $p = Net::Ping->new();
         $p->hires();
         (my $ret, my $duracion, my $ip ) = $p->ping($tabla[3], $duracion);
         if($ret == 0){
	    $_REMOTO = &conectaServer($db, $tabla[3], $tabla[1], $tabla[2]);
	    if(defined $_REMOTO){
	       &getBoletoAnticipado($aFechaNew, $tabla[0], $afchs[0]);
            }else{
	        print "no se creo conexion $tabla[0]\n";
            }
         }
         $p->close();
     }
}

&setUpdateMovWeb($year+1900);

$_SERVER->disconnect();
