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


sub getInsertGUIA{
   
   my $s_terminal = shift;
   my $query = "SELECT ID_GUIA, ID_TERMINAL, FECHA, ID_CORRIDA, ID_DESTINO, NO_BUS, INGRESO, ".
               "ID_OPERADOR, TRAB_ID, TIPOSERVICIO, ID_RUTA, FECHA_HORA, ".
	       "OLLIN_FOLIO, OLLIN_TIPO_CUOTA, OLLIN_PROVEEDOR, TIPO_SERVICIO_CEMO, FOLIO_CEMO, BOLETERA_FOLIO ".
	       "FROM PDV_T_GUIA ".
	       "WHERE FECHA = CURRENT_DATE() AND ID_TERMINAL = ?";
   #"WHERE CAST(FECHA_HORA AS DATE) = CURRENT_DATE() AND ID_TERMINAL = ?";
   my $sth = $_REMOTO->prepare( $query );
   $sth->bind_param(1, $s_terminal);
   $sth->execute(); 
   while( @outs = $sth->fetchrow_array() ){
      if($outs[15] =~ /Sin Selecc/){
	$outs[15] = 'Sin Seleccion';
      }
      eval{
         my $sql_insert  = "INSERT INTO PDV_T_GUIA(ID_GUIA, ID_TERMINAL, FECHA, ID_CORRIDA, ID_DESTINO, ".
		     "NO_BUS, INGRESO, ID_OPERADOR, TRAB_ID, TIPOSERVICIO, ID_RUTA, FECHA_HORA, ".
                     "OLLIN_FOLIO, OLLIN_TIPO_CUOTA, OLLIN_PROVEEDOR, TIPO_SERVICIO_CEMO, FOLIO_CEMO, BOLETERA_FOLIO) ".
                     "VALUES($outs[0], '$outs[1]', '$outs[2]', '$outs[3]', '$outs[4]', $outs[5], $outs[6], '$outs[7]', ".
                     "'$outs[8]', $outs[9], $outs[10], '$outs[11]', $outs[12], $outs[13], $outs[14], 'Sin Seleccion', $outs[16], '$outs[17]')";
         my $stg = $_SERVER->prepare( $sql_insert);
         $stg->execute();
      };
   }
}


sub getInsertCorrida{
   my $query = "SELECT ID_CORRIDA, FECHA, HORA, ID_TIPO_AUTOBUS, TIPOSERVICIO, ID_RUTA, NO_BUS, TIPO_CORRIDA, CREADO_POR ".
	       "FROM PDV_T_CORRIDA WHERE FECHA = CURRENT_DATE()";
   my $sth = $_REMOTO->prepare( $query );
   $sth->execute();
   while( @outs = $sth->fetchrow_array() ){
     if (defined($outs[6])){
	$outs[6] = $outs[6];
     }else{
	$outs[6] = 0;
     }
     eval{
       my $sql_insert = "INSERT INTO PDV_T_CORRIDA(ID_CORRIDA, FECHA, HORA, ID_TIPO_AUTOBUS, TIPOSERVICIO, ".
		    "ID_RUTA, NO_BUS, TIPO_CORRIDA, CREADO_POR) ".
		    "VALUES('$outs[0]', '$outs[1]', '$outs[2]', $outs[3], $outs[4], $outs[5], $outs[6], '$outs[7]', '$outs[8]')";;
       my $stg = $_SERVER->prepare( $sql_insert);
       $stg->execute();
     };
   }
} 

sub getInsertCorridaD{
   my $s_terminal = shift;
   $query = "SELECT ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, ID_RUTA, TRAB_ID ".
               "FROM PDV_T_CORRIDA_D WHERE FECHA = CURRENT_DATE() AND ID_TERMINAL = ? ";
   my $sth = $_REMOTO->prepare( $query );
   $sth->bind_param(1, $s_terminal );
   $sth->execute();
   while(@outs = $sth->fetchrow_array()){
      eval{
      my $sql_insert = "INSERT INTO PDV_T_CORRIDA_D(ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, ID_RUTA, TRAB_ID) ".
                    "VALUES('$outs[0]', '$outs[1]', '$outs[2]', '$outs[3]', $outs[4], $outs[5], '$outs[6]', $outs[7], '$outs[8]')";
      my $stq = $_SERVER->prepare( $sql_insert);
      $stq->execute();
      };
   }
}

sub getTerminales{
   my @outs = undef;
   my $id = 0;
   my $query = "SELECT ID_TERMINAL, BD_USUARIO, BD_PASSWORD,IPV4 ".
	       "FROM PDV_C_TERMINAL ".
               "WHERE ESTATUS = 'A' and ID_TERMINAL not in ('WEB','SD1','SD2','MOV') ORDER BY 1";
   my $stt = $_SERVER->prepare( $query );
   $stt->execute();
   while(my @ins =  $stt->fetchrow_array() ){
       $outs[$id] = \@ins;
       $id++;
   }
   return @outs;
}

#main 
$_SERVER = &conectaServer($db, $host, $user, $password);
my @ttDatos = &getTerminales();
foreach my $x (0..@ttDatos -1){
     my @tabla = @{$ttDatos[$x]};
#print $tabla[0] . "  " . $tabla[1] . "  " . $tabla[2] . "  " . $tabla[3]. "\n";
     my $duracion = 5.5;
     $p = Net::Ping->new();
     $p->hires();
     (my $ret, my $duracion, my $ip ) = $p->ping($tabla[3], $duracion);
      if($ret == 0 || $ret == 1){

	$_REMOTO = &conectaServer($db, $tabla[3], $tabla[1], $tabla[2]);
	if(defined $_REMOTO){
	   &getInsertCorridaD($tabla[0]);
	   &getInsertGUIA($tabla[0]);
	   &getInsertCorrida();
        }else{
	    print "no se creo conexion $tabla[0]\n";
        }
     }
     $p->close();
}


$_SERVER->disconnect();
