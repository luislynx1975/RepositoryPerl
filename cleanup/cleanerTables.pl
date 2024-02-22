#!/usr/bin/perl
#################################################################################
# Script para la depurar la base de datos de mercurio
#version 1.0
#Fecha 2022-04-19
#Autor Larios Rodriguez Jose Luis
#################################################################################
use DBI;
#use strict;
use Net::IP;
use Sys::HostAddr;
############################ C O R P O R A T I V O
my $d_bBOLETO = "CORPORATIVO";
my $d_hBOLETO = "192.168.1.13";
my $d_uBOLETO = "replicacion";
my $d_pBOLETO = "\#\@Vi\@j\@Mor3l0s";
my $d_portBOLETO  = 3306;
my $S_CORPO  = undef;
my $R_SERVER = undef;
my $_DIAS_NO_EMP = 45;
################################################################################
#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}

################################################################################
sub getTerminalsDB{
    my $termnl = shift;
    my @out = undef;
    my $idx = 0;
    my $query = "SELECT BD_BASEDATOS, IPV4, BD_USUARIO, BD_PASSWORD, IPV4, ID_TERMINAL ".
	        "FROM PDV_C_TERMINAL ".
		"WHERE ESTATUS = 'A' AND ID_TERMINAL = ? ";
    my $d_terminal = $S_CORPO->prepare( $query );
    $d_terminal->bind_param(1, $termnl);
    $d_terminal->execute();
    while( my @data = $d_terminal->fetchrow_array() ){
	$out[$idx] = \@data;
        $idx++;
    }
    return @out;

}

################################################################################
sub getBoletoTrabId{
    my $cve = shift;
    my @datos = undef;
    my $idx = 0;
    my $query = "SELECT DISTINCT(B.TRAB_ID), COUNT(*)AS TOTAL FROM PDV_T_BOLETO B WHERE B.ID_TERMINAL = ? GROUP BY 1 HAVING TOTAL > 1 ORDER BY 1 ";
    $query = "SELECT DISTINCT(TRAB_ID) FROM PDV_T_BOLETO";		
    my $d_cves = $R_SERVER->prepare( $query );
    $d_cves->execute();
    while( my @vals = $d_cves->fetchrow_array() ){
	$datos[$idx] = $vals[0];
	$idx++;
    }
    return @datos;
}

################################################################################
sub getBoletoTrabUno{
    my $cve = shift;
    my @datos = undef;
    my $idx = 0;
    my $query = "SELECT DISTINCT(B.TRAB_ID), COUNT(*)AS TOTAL ".
		"FROM PDV_T_BOLETO B ".
		"WHERE B.ID_TERMINAL = ? ".
		"GROUP BY 1 ".
	        "HAVING TOTAL = 1 ".
		"ORDER BY 1 ";
    my $d_cves = $R_SERVER->prepare( $query );
    $d_cves->bind_param(1, $cve);
    $d_cves->execute();
    while( my @vals = $d_cves->fetchrow_array() ){
	$datos[$idx] = $vals[0];
	$idx++;
    }
    return @datos;
}

################################################################################
sub getTicketsRemote{
    my ($cve, $dia) = @_;
    my @out = undef;
    my $idx = 0;
    my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, ".
	        "NOMBRE_PASAJERO, NO_ASIENTO, id_ocupante, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX,  ".
	        "TC, IVA, TOTAL_IVA, IFNULL(ID_FORMA_PAGO_SUB,'')AS ID_FORMA_PAGO_SUB, IFNULL(FECHA_BOLETO,FECHA)AS FECHA_BOLETO,  ".
	        "IFNULL(HORA_BOLETO,(SELECT SUBSTRING_INDEX(FECHA_HORA_BOLETO,' ', -1) FROM PDV_T_BOLETO  WHERE TRAB_ID = B.TRAB_ID AND ID_BOLETO = B.ID_BOLETO LIMIT 1))AS HORA_BOLETO, ".
	        "(SELECT  100 * TARIFA / (SELECT (100 - DESCUENTO) FROM PDV_C_OCUPANTE WHERE ABREVIACION = B.TIPO_TARIFA))AS TARIFA_REAL,  ".
	        "IFNULL(HORA_CORRIDA, (SELECT HORA FROM PDV_T_CORRIDA_D  D WHERE D.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = B.FECHA LIMIT 1))HORA_CORRIDA ".
	        "FROM PDV_T_BOLETO B ".
	        "WHERE B.TRAB_ID = ? AND FECHA = ? ";
     my $d_tickets = $R_SERVER->prepare( $query );
     $d_tickets->bind_param(1, $cve );
     $d_tickets->bind_param(2, $dia );
     $d_tickets->execute();
     while( my @datos = $d_tickets->fetchrow_array() ){
	$out[$idx] = \@datos;
	$idx++;
     }
     $d_tickets->finish();
     return @out;
}

################################################################################
sub insertCopyTable{
     my @datas = @_;
     my $query = "INSERT INTO PDV_T_BOLETO_DEPURA(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, ".
		 "NOMBRE_PASAJERO, NO_ASIENTO, id_ocupante, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX,  ".
		 "TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, FECHA_BOLETO, HORA_BOLETO, TARIFA_REAL, HORA_CORRIDA) ".
		 "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  )";
     my $d_table = $S_CORPO->prepare( $query );
     $d_table->execute( @datas );
     $d_table->finish();
}

################################################################################
#Insertamos en la tabla maestra de boleto
sub insertServerBoleto{
    my @datas = @_;
     my $query = "INSERT INTO PDV_T_BOLETO(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, ".
		 "NOMBRE_PASAJERO, NO_ASIENTO, id_ocupante, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX,  ".
		 "TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, FECHA_BOLETO, HORA_BOLETO, TARIFA_REAL, HORA_CORRIDA) ".
		 "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  )";
     my $d_table = $S_CORPO->prepare( $query );
     $d_table->execute( @datas );
     $d_table->finish();
}

################################################################################
#Si no se encuentra en la tabla PDV_T_BOLETO se inserta en la tabla del servidor
#y hacemos una insercion en la tabla de PDV_T_BOLETO_DEPURA como notificacion de
#que no se encontraba y se guarda la referencia en esta tabla
sub seekInsertTicketServer{
#Busca si existe en la table pdv_t_boleto del corrporativo
     my @valor = @_;
     my $s = scalar(@valor);
     my $query = "SELECT count(*)as total FROM PDV_T_BOLETO ".
		 "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ";
     my $d_bol = $S_CORPO->prepare( $query );
     $d_bol->bind_param(1, $valor[0]);
     $d_bol->bind_param(2, $valor[1]);
     $d_bol->bind_param(3, $valor[2]);
     $d_bol->execute();
     my @dts = $d_bol->fetchrow_array();
     if( $dts[0] == 0){
	&insertCopyTable( @valor );
	&insertServerBoleto( @valor );
     }
     $d_bol->finish();
}

################################################################################
sub backUpTickets{
     my ($cve, $terminal, $dias) = @_;
     my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, ".
		 "NOMBRE_PASAJERO, NO_ASIENTO, id_ocupante, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX,  ".
		 "TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, FECHA_BOLETO, HORA_BOLETO, TARIFA_REAL, HORA_CORRIDA ".
		 "FROM PDV_T_BOLETO B ".
	         "WHERE B.TRAB_ID = ? AND CAST(B.FECHA_HORA_BOLETO AS DATE) = ? AND B.ID_TERMINAL = ? ";
     my $d_ticketCentral = $R_SERVER->prepare( $query );
     $d_ticketCentral->bind_param(1, $cve); 
     $d_ticketCentral->bind_param(2, $dias); 
     $d_ticketCentral->bind_param(3, $terminal); 
     $d_ticketCentral->execute();
     while( my @outs = $d_ticketCentral->fetchrow_array() ){
	my $query = "INSERT INTO PDV_T_BOLETO_BORRADOS(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ".
                    "ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, ".
		    "NOMBRE_PASAJERO, NO_ASIENTO, id_ocupante, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX,  ".
		    "TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB, FECHA_BOLETO, HORA_BOLETO, TARIFA_REAL, HORA_CORRIDA) ".
		    "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?  )";
	my $d_borra = $S_CORPO->prepare( $query );
	   $d_borra->execute ( @outs );
	   $d_borra->finish();
     }
     $d_ticketCentral->finish();
}

################################################################################
sub deleteTickets{
     my ($cve, $terminal, $dias, $_REMOTO) = @_;
     &backUpTickets($cve, $terminal, $dias);
     my $query = "DELETE FROM PDV_T_BOLETO ".
		 "WHERE TRAB_ID = ? AND ID_TERMINAL = ? AND CAST(FECHA_HORA_BOLETO AS DATE) = ?";
     my $d_ticket = $R_SERVER->prepare( $query );
     $d_ticket->bind_param(1, $cve);
     $d_ticket->bind_param(2, $terminal);
     $d_ticket->bind_param(3, $dias);
    ##$d_ticket->execute();

 print("aqui vamos  $cve   $terminal  $dias \n");
     my $query = "INSERT INTO PDV_T_TICKET_FOR_DELETE ".
                 "SELECT b.ID_BOLETO, b.ID_TERMINAL, b.TRAB_ID ".
                 "FROM PDV_T_BOLETO b ".
                 "WHERE b.TRAB_ID = ? AND b.ID_TERMINAL = ? AND cAST(FECHA_HORA_BOLETO AS DATE) = ? ";
     $d_ticket = $_REMOTO->prepare( $query );
     $d_ticket->bind_param(1, $cve );
     $d_ticket->bind_param(2, $terminal );
     $d_ticket->bind_param(3, $dias );
     $d_ticket->execute() or die "execution failed: $d_ticket->errstr()";

#insert in the table ticket for delete

     $query = "DELETE FROM PDV_T_ASIENTO WHERE CAST(FECHA_HORA_CORRIDA AS DATE) = ?";
     $d_ticket = $R_SERVER->prepare( $query );
     $d_ticket->bind_param(1, $dias);
     $d_ticket->execute();


     $query = "DELETE FROM EVENTOS WHERE CAST(FECHA_HORA AS DATE) = ?";
     $d_ticket = $R_SERVER->prepare( $query );
     $d_ticket->bind_param(1, $dias);
     $d_ticket->execute();

     $query = "DELETE FROM PDV_T_CORRIDA_OCUPANTE WHERE FECHA = ?";
     $d_ticket = $R_SERVER->prepare( $query );
     $d_ticket->bind_param(1, $dias);
     $d_ticket->execute();

     $query = "DELETE FROM PDV_T_CORRIDA_D WHERE FECHA = ?";
     $d_ticket = $R_SERVER->prepare( $query );
     $d_ticket->bind_param(1, $dias);
     $d_ticket->execute();

     $query = "DELETE FROM PDV_T_CORRIDA WHERE FECHA = ?";
     $d_ticket = $R_SERVER->prepare( $query );
     $d_ticket->bind_param(1, $dias);
     $d_ticket->execute();

}

################################################################################
sub getLastTicketTrabIdServer{
    my ($cve, $terminal) = @_;
    my $query = "SELECT COALESCE(MAX(ID_BOLETO),0)AS MAXIMO FROM PDV_T_BOLETO WHERE TRAB_ID = ? AND ID_TERMINAL = ? ";
    my $d_ticket = $S_CORPO->prepare( $query );
    $d_ticket->bind_param(1, $cve);
    $d_ticket->bind_param(2, $terminal);
    $d_ticket->execute();
    my @datos = $d_ticket->fetchrow_array();
    return $datos[0]; 
    $d_ticket->finish();

}

################################################################################
sub getTicketTrabIdLast{
    my ($id, $cve, $terminal) = @_;
    my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, ".
		"FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ID_RUTA, TC, TIPO_TARIFA ".
		"FROM PDV_T_BOLETO  ".
		"WHERE ID_BOLETO = ? AND TRAB_ID = ? AND ID_TERMINAL = ? ";
    my $d_ticket = $S_CORPO->prepare( $query );
    $d_ticket->bind_param(1, $id);
    $d_ticket->bind_param(2, $cve);
    $d_ticket->bind_param(3, $terminal);
    $d_ticket->execute();
    my @datos = $d_ticket->fetchrow_array();
    $d_ticket->finish();
    return @datos;
}


################################################################################
sub getTicketInPlace{
    my ($id, $cve, $terminal) = @_;
    my $query = "SELECT COUNT(*) FROM PDV_T_BOLETO B WHERE B.ID_BOLETO = ? AND B.TRAB_ID = ? AND B.ID_TERMINAL = ?";
    my $d_ticket = $R_SERVER->prepare( $query );
    $d_ticket->bind_param( 1, $id );
    $d_ticket->bind_param( 2, $cve );
    $d_ticket->bind_param( 3, $terminal );
    $d_ticket->execute();
    my @datos = $d_ticket->fetchrow_array();
   
    return $datos[0];
    $d_ticket->finish();
}

################################################################################
sub checkExistLastTicket{
    my ($cve, $terminal) = @_;
    my $boletoID = &getLastTicketTrabIdServer($cve, $terminal);#buscamos en el corporativo el ultimo del empleado PDV_T_BOLETO
    my @ticket = &getTicketTrabIdLast($boletoID, $cve, $terminal);#traemos el boleto para insertarlo
    if(&getTicketInPlace($boletoID, $cve, $terminal) == 0){
    	my $query = "INSERT INTO PDV_T_BOLETO( ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, ".
		    "FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ID_RUTA, TC, TIPO_TARIFA ) ".
		    "VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) ";
  	my $d_place = $R_SERVER->prepare( $query );
        $d_place->execute( @ticket );
	print("No se encuentra en la venta local $ticket[0]  $ticket[1]  $ticket[2] \n");
    }else{
	print("Esta sincronizado el server con la venta local $ticket[0]  $ticket[1]  $ticket[2]   ...... $cve \n");
    }
}


################################################################################
sub getNumberOfDays{
    my $query = "SELECT TIMESTAMPDIFF(DAY,  CONCAT(YEAR(CURRENT_DATE()) - 1,'-01-01'),  CONCAT(YEAR(CURRENT_DATE()) - 1,'-12-31') ) + 30 + ".
	        "TIMESTAMPDIFF(DAY,  CONCAT(YEAR(CURRENT_DATE()),'-01-01'),  CURRENT_DATE() ) AS DIAS";
   my $d_hora = $S_CORPO->prepare( $query );
   $d_hora->execute();
   my @out = $d_hora->fetchrow_array();
   #return $out[0];
   return 730;
   $d_hora->finish();
}


################################################################################
sub getDaysStartEnd(){
	my ($dias, $empleado) = @_;
	my @outDays = undef;
	my $idx = 0;
	my $qry = "select * from  ".
"(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from  ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0,  ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1,  ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2,  ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3,  ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v  ".
"where fechas between ( SELECT MIN(FECHA) FROM PDV_T_BOLETO WHERE TRAB_ID = ?) and ( SUBDATE(CURRENT_DATE(), INTERVAL ? DAY) ) ORDER BY 1";
	my $d_days = $R_SERVER->prepare( $qry );
	$d_days->bind_param(1, $empleado);	
	$d_days->bind_param(2, $dias);	
	$d_days->execute();
	while( my @data = $d_days->fetchrow_array()){
	   $outDays[$idx] = $data[0];
	   $idx++;
	}
	return @outDays;
}

################################################################################
sub messageHelp(){
   print("###############################################\n");
   print("#  El script se ejecuta desde linea de comando o terminal de Linux  #\n");
   print("#  Se ejecuta con el interprete de PERL  #\n");
   print("#  EJEMPLO DE EJECUCION  #\n");
   print("#  perl cleanerTables.pl MEX \n #");
   print("###############################################\n");
}

################################################################################
sub  setTableDeleteTicket(){
   my $qry = "CREATE TABLE IF NOT EXISTS PDV_T_TICKET_FOR_DELETE( ".
             "ID_BOLETO INTEGER NOT NULL, ".
             "ID_TERMINAL VARCHAR(10) NOT NULL, ".
             "TRAB_ID     VARCHAR(10) NOT NULL, ".
             "PRIMARY KEY(ID_BOLETO, ID_TERMINAL, TRAB_ID) ".
             ")";
   my $d_tickets = $R_SERVER->prepare( $qry );
   $d_tickets->execute();
}

################################################################################
sub howManyTickets(){
   my $employee = shift;
   my $qry = "SELECT COUNT(*) FROM PDV_T_BOLETO ".
             "WHERE TRAB_ID = ?";
   my $d_tickets = $R_SERVER->prepare( $qry );
   $d_tickets->bind_param(1, $employee);
   $d_tickets->execute();
   my @out = $d_tickets->fetchrow_array();
   return $out[0];
}

################################# M A I N ###################################
system("cls");
system("clear");
my $argv_terminal = $ARGV[0];
if ($#ARGV != 0){
   messageHelp();
   exit;
}

$S_CORPO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
my @aTerminals = &getTerminalsDB($argv_terminal);
if($argv_terminal =~ 'Test'){
    $argv_terminal = 'MEX';
}
my $dias_borrado = &getNumberOfDays();
print("Dias borrados $dias_borrado\n");
#Create table where store the tickets for deleted of database by administrator
#foreach my $x(0..@aTerminals - 1 ){
	$R_SERVER = &conectaServer($aTerminals[0][0], $aTerminals[0][1],  $aTerminals[0][2],  $aTerminals[0][3], $d_portBOLETO);
print("   $aTerminals[0][0], $aTerminals[0][1],  $aTerminals[0][2],  $aTerminals[0][3], $d_portBOLETO\n");
#        &setTableDeleteTicket();

	if(!$R_SERVER){
	  die "Failed to connect to MySql database DBI->errstr()";
	}else{  #Si esta establecida la conexion a la base de datos
	   my @cves = &getBoletoTrabId( $aTerminals[$x][5] );
	   foreach (@cves){#buscamos los boletos he insertamos en la tabla del corporativo sino estan
	      my @array_dias = undef;
              if( &howManyTickets( $_ ) > 1 ){
	          @array_dias = &getDaysStartEnd($dias_borrado, $_);#Obtenemos los dias para buscar los datos por fecha
	      }

	      foreach my $diaBorrado ( @array_dias ){
	          my @atickets = &getTicketsRemote( $_, $diaBorrado );
		  my $valor = scalar @atickets;
		 if($valor > 1){	
	            foreach my $y (0..@atickets -1){
		    	&seekInsertTicketServer( @{$atickets[$y]} );
	            }#borrar boletos 1 año hacia atras y dejando el ultimo local y validado con el server central
	    	    &deleteTickets( $_, $argv_terminal, $diaBorrado, $R_SERVER);
	    	    #&deleteTickets( $_, $aTerminals[$x][5], $diaBorrado, $R_SERVER);
		  }else{
#			print("El dia no tiene datos $diaBorrado\n");
		  }
	      }

	      print("Verificar ultima venta del promotor : $_ \n");
	      &checkExistLastTicket( $_, $aTerminals[$x][5] );#verificar que es el ultimo registro de cada empleado que tenemos en la base de datos de forma local
	   }#//fin foreach
	}#//fin else if
	$R_SERVER->disconnect();
#}

$S_CORPO->disconnect();
