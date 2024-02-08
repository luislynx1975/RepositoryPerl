#!/usr/bin/perl
use DBI;
use warnings;
use strict;
use Switch;
use 5.010;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
my $user = "root";
my $pass = "#R0j0N3no\$";
my $port = 3306;
my $_SERVER = undef;
my $_REMOTO = undef;
my @a_fechas = ();
my @a_terminales = ();
my $cuantos = 0;
my @a_tablas = ('PDV_T_BOLETO','PDV_T_CORRIDA','PDV_T_CORRIDA_D','PDV_T_GUIA','PDV_T_CORTE','PDV_T_BOLETO_CANCELADO','PDV_T_RECOLECCION');
#my @a_tablas = ('PDV_T_RECOLECCION');

######################################################################
sub conectaServer(){
	my $dbase_db = undef;
 	my $ip_db = undef;
 	my $user_db = undef;
 	my $pass_db = undef;;
        ($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
	my $dbh = undef;
	eval{
            $dbh = DBI->connect($connectionInfo, $user_db, $pass_db, {RaiseError=>0, PrintError=>0}) || die "Without Connection";
	};
	if ($@){
	   $dbh = undef;
	}
        return $dbh;
}

######################################################################
#Obtenemos la lista de las terminales que se tienen registrado en la tabla de terminales
sub getTerminales{
	my %a_ter = ();
	my $idx = 0;
	my $sth = $_SERVER->prepare("SELECT T.ID_TERMINAL, T.IPv4, T.BD_BASEDATOS, T.BD_USUARIO, T.BD_PASSWORD, T.ESTATUS ".
				    "FROM PDV_C_TERMINAL T ".
				    "WHERE T.ESTATUS = 'A' AND ID_TERMINAL = 'DIEZ' ORDER BY 1 ");
	$sth->execute();
	while(my @outs = $sth->fetchrow_array()){
		$a_ter{$outs[0]} =  \@outs;
	}
	$sth->finish();
	return %a_ter;
}

######################################################################
###Obtenemos las fechas de los boletos que se tiene registrado en la tabla de boleto
sub getFechasSistema{
	my $terminal = shift;
	my @a_fchs = undef;
	my $idx = 0;
	#my $sth = $_SERVER->prepare("SELECT DISTINCT(FECHA) FROM PDV_T_BOLETO ".
				    #"WHERE FECHA < CURRENT_DATE() AND FECHA > '2010-01-01' AND ".
				    #"FECHA NOT IN (SELECT DISTINCT(FECHA) FROM ADM_STATUS_TABLA WHERE ID_TERMINAL = ?) ".
				    #"ORDER BY 1 DESC");
	my $sth = $_SERVER->prepare("SELECT DISTINCT(FECHA) FROM PDV_T_BOLETO ".
				    "WHERE FECHA < CURRENT_DATE() AND FECHA > '2010-01-01' AND ".
                                    "FECHA NOT IN (SELECT DISTINCT(FECHA) FROM ADM_STATUS_TABLA WHERE ID_TERMINAL = ? AND ".
                                    "TABLA = 'PDV_T_BOLETO' AND STATUS = 0) ");
	$sth->bind_param(1, $terminal);
	$sth->execute();
	while( my @outs = $sth->fetchrow_array()){
		$a_fchs[$idx] = $outs[0];
		$idx++;
	}
        if($idx == 0){
           $sth = $_SERVER->prepare("SELECT DISTINCT(FECHA) FROM PDV_T_BOLETO ".
                                    "WHERE FECHA < CURRENT_DATE() AND FECHA > '2010-01-01' ORDER BY 1 DESC");
           $sth->execute();
           while( my @outs = $sth->fetchrow_array()){
                $a_fchs[$idx] = $outs[0];
                $idx++;
           }
        }
	$sth->finish();
	return @a_fchs;
}

######################################################################
sub setInsertADM{
	my($tabla, $terminal, $fecha) = @_;
	my $query = "INSERT INTO ADM_STATUS_TABLA(FECHA,ID_TERMINAL,TABLA) VALUES(?,?,?)";
	my $sti = $_SERVER->prepare( $query );
	$sti->bind_param(1, $fecha);
	$sti->bind_param(2, $terminal);
	$sti->bind_param(3, $tabla);
	$sti->execute();
	$sti->finish();
}

######################################################################
sub setADMDatos{
	my($tabla, $terminal, $fecha) = @_;
	my $query = "SELECT FECHA FROM ADM_STATUS_TABLA WHERE FECHA = ? AND ID_TERMINAL = ? AND TABLA = ?";
	my $sth = $_SERVER->prepare( $query );
	$sth->bind_param(1, $fecha);
	$sth->bind_param(2, $terminal);
	$sth->bind_param(3, $tabla);
	$sth->execute();
	my $rows = $sth->rows;
	if($rows == 0){
		&setInsertADM($tabla, $terminal, $fecha);	
	}	
	$sth->finish();
}

######################################################################
#Preparamos los datos para insertarlos en la tabla
sub setADMTabla{
	my $terminal_into = shift;
#a_tablas arreglo de tablas para hacer las insercciones
	foreach my $tabla (@a_tablas){
	      foreach my $fecha (@a_fechas){
		  &setADMDatos($tabla,$terminal_into,$fecha);
	      }
	}
}

######################################################################
sub getConexion{
	my $terminal = shift;
	my $query = "SELECT IPV4, BD_BASEDATOS, BD_USUARIO, BD_PASSWORD ".
		    "FROM PDV_C_TERMINAL ".
		    "WHERE ID_TERMINAL = ?";
	my $stc = $_SERVER->prepare( $query );
	$stc->bind_param(1, $terminal);
	$stc->execute();
	my @outs = $stc->fetchrow_array();
	return @outs;
}

######################################################################
sub getADMTablaTerminal{
	my $terminal = shift;
	my @a_status = undef;
	my $li_idx = 0;
	foreach my $tabla (@a_tablas){
	   my $query = "SELECT FECHA, TABLA, CORPORATIVO, LUGAR ".
                       "FROM ADM_STATUS_TABLA A ".
                       "WHERE A.STATUS = 0 AND TABLA = ? AND ID_TERMINAL = ?".
                       "ORDER BY FECHA DESC ".
                       "LIMIT 1";
	   my $sth = $_SERVER->prepare( $query );
	   $sth->bind_param(1, $tabla);
	   $sth->bind_param(2, $terminal);
	   $sth->execute(); 
	   while(my @outs = $sth->fetchrow_array()){
#print join("-",@outs);
		$a_status[$li_idx] = \@outs;
		$li_idx++;
	   }
	   $sth->finish();
	}
	return @a_status;
}

######################################################################
#Extraemos como esta contruida la tabla en la base de datos remota
sub getDescripcionTabla(){
	my $tabla = shift;
	my $li_indice = 0;
	my @describe = undef;
	my $query = "DESCRIBE " . $tabla;
	my $sth = $_REMOTO->prepare( $query );
	$sth->execute();
	while(my @outs = $sth->fetchrow_array()) {
	    $describe[$li_indice] = $outs[0];
	    $li_indice++;
	}
	$sth->finish();
	return @describe;
}

######################################################################
#Prepara el query para extraer la informacion de los puntos de venta
sub getQueryTabla(){
	my ($tabla, $fecha, $terminal, @a_fields) = @_;
	my $query = "SELECT ";
	my $query_where = "";
	foreach my $campo (@a_fields){
	   $query = $query . $campo . ',';
	}
	$query = substr($query , 0 , length($query) -1) . " FROM $tabla WHERE ";

	switch($tabla){
	   case "PDV_T_BOLETO" {
		$query_where = " CAST(FECHA_HORA_BOLETO AS DATE) = '$fecha'";
		#$query_where = " FECHA = '$fecha' AND ID_TERMINAL = '$terminal'";
	   }
	   case "PDV_T_GUIA" {
		$query_where = " CAST(FECHA_HORA AS DATE) = '$fecha'";
	   }
	   case "PDV_T_CORRIDA" {
		$query = "";
		$query_where = "SELECT C.ID_CORRIDA,C.FECHA,C.HORA,ID_TIPO_AUTOBUS,TIPOSERVICIO,C.ID_RUTA,NO_BUS,TIPO_CORRIDA, C.CREADO_POR ".
			       "FROM PDV_T_CORRIDA C INNER JOIN PDV_T_CORRIDA_D D ON C.ID_CORRIDA = D.ID_CORRIDA AND C.FECHA = D.FECHA ".
			       "WHERE C.FECHA = '$fecha' AND D.ID_TERMINAL = '$terminal'".
			       "UNION ".
			       "SELECT C.ID_CORRIDA,C.FECHA,C.HORA,ID_TIPO_AUTOBUS,TIPOSERVICIO,C.ID_RUTA,NO_BUS,TIPO_CORRIDA, C.CREADO_POR ".
			       "FROM PDV_T_CORRIDA C INNER JOIN PDV_T_CORRIDA_D D ON C.ID_CORRIDA = D.ID_CORRIDA AND C.FECHA = D.FECHA ".
			       "WHERE C.FECHA = CURRENT_DATE() AND D.ID_TERMINAL = '$terminal'";
	   }
	   case "PDV_T_CORRIDA_D" {
		$query_where = "FECHA IN  ('$fecha', CURRENT_DATE()) AND ID_TERMINAL = '$terminal' ";
	   }
	   case "PDV_T_CORTE" {
		$query_where = "CAST(FECHA_INICIO AS DATE) =  '$fecha' AND ID_TERMINAL = '$terminal'";
	   }

	   case "PDV_T_BOLETO_CANCELADO" {
		$query_where = "CAST(FECHA_HORA_CANCELADO AS DATE) =  '$fecha' AND ID_TERMINAL = '$terminal'";
	   }
	   case "PDV_T_PAGO_PINPAD_BANAMEX" {
		$query_where = "CAST(FECHA_HORA AS DATE) =  '$fecha'";
	   }
	   case "PDV_T_RECOLECCION" {
	        $query_where = "CAST(FECHA_HORA AS DATE) = '$fecha'";
           }
	}
	$query = $query . $query_where;
	return $query;
}


######################################################################
#Ejecuta el query obteniendo todos los datos de la tabla remota
sub getDatosTabla(){
	my ($query) = @_;
	my @a_outs = ();
	my $li_indice = 0;
	my $sth = $_REMOTO->prepare( $query );
#print  $query ."\n";
	$sth->execute();
	while(my @outs = $sth->fetchrow_array()){
	    $a_outs[$li_indice] = \@outs;
	    $li_indice++;
	}
	$sth->finish();
	return @a_outs;
}

######################################################################
#Prepara el insert en base a los campos que tiene la tabla
sub getQueryInsert(){
	my ($s_tabla , @a_fields) = @_;
	my $s_qry = "INSERT INTO " . uc($s_tabla) . "(";
	my $s_campos = "";
        my $s_params = "";
	my $li_ctrl = 0;
	foreach (@a_fields){
	   $s_campos = $s_campos . $_ . ",";
	   $s_params = $s_params . "?,";
	   $li_ctrl++;
	}
	$s_campos = substr($s_campos,0, length($s_campos)-1) . ") VALUES(" .
		    substr($s_params,0, length($s_params)-1) .")";
	return $s_qry = $s_qry . $s_campos;
}

######################################################################
#Buscamos el boleto si existe en la base de datos del  CORPORATIVO
sub getBoletoCorpo(){
     my (@a_fields) = @_;
     my $li_encontrado = 0;
     my $query = "SELECT COUNT(*) FROM PDV_T_BOLETO B ".
                 "WHERE B.ID_BOLETO = ? AND B.ID_TERMINAL = ? AND B.TRAB_ID = ? AND B.TC = ?";
     my $stc = $_SERVER->prepare( $query );
     $stc->bind_param(1,$a_fields[0]);
     $stc->bind_param(2,$a_fields[1]);
     $stc->bind_param(3,$a_fields[2]);
     $stc->bind_param(4,$a_fields[20]);
     $stc->execute();
     my @outs = $stc->fetchrow_array();
     return $outs[0];
}

######################################################################
#obtenemos el numero de registros que existen en la base de corporativo
#este es por tabla
sub getTotalRegistrosTabla(){
     my ($table_name, $fecha, $terminal) = @_;

     if($table_name =~ 'PDV_T_BOLETO_CANCELADO'){
	my $query = "SELECT COUNT(*) ".
		    "FROM PDV_T_BOLETO_CANCELADO ".
		    "WHERE ID_TERMINAL = '$terminal' AND CAST(FECHA_HORA_CANCELADO AS DATE) = '$fecha' ";
	my $stl = $_SERVER->prepare( $query );
	$stl->execute();
	my @outs = $stl->fetchrow_array();
	return $outs[0];
     }

     if($table_name =~ 'PDV_T_GUIA'){
	my $query = "SELECT COUNT(*) ".
		    "FROM PDV_T_GUIA A ".
		    "WHERE A.FECHA = ? AND A.ID_TERMINAL = ?";
	my $stl = $_SERVER->prepare( $query );
	$stl->bind_param(1, $fecha );
	$stl->bind_param(2, $terminal);
	$stl->execute();
	my @outs = $stl->fetchrow_array();
	return $outs[0];
     }

     if($table_name =~ 'PDV_T_CORRIDA'){
	my $query = "SELECT COUNT(*) ".
		    "FROM PDV_T_CORRIDA C RIGHT  JOIN PDV_T_CORRIDA_D D ON C.ID_CORRIDA = D.ID_CORRIDA AND C.FECHA = D.FECHA ".
		    "WHERE CAST(C.FECHA AS DATE) = ? AND D.ID_TERMINAL = ? ".
		    "ORDER BY 1";
	my $stl = $_SERVER->prepare( $query );
	$stl->bind_param(1, $fecha );
	$stl->bind_param(2, $terminal);
	$stl->execute();
	my @outs = $stl->fetchrow_array();
	return $outs[0];
     }

     if($table_name =~ 'PDV_T_CORRIDA_D'){
	my $query = "SELECT COUNT(*) FROM PDV_T_CORRIDA_D ".
		    "WHERE ID_TERMINAL = '$terminal' AND FECHA = '$fecha'";
	my $stl = $_SERVER->prepare( $query );
	$stl->execute();
	my @outs = $stl->fetchrow_array();
	return $outs[0];
     }

     if($table_name =~ 'PDV_T_BOLETO'){
	my $query = "SELECT COUNT(*) FROM PDV_T_BOLETO ".
		    "WHERE ID_TERMINAL = '$terminal' AND FECHA BETWEEN '$fecha 00:00:00' AND '$fecha 23:59:59' ";
	my $stl = $_SERVER->prepare( $query );
	$stl->execute();
	my @outs = $stl->fetchrow_array();
	return $outs[0];
     }

     if($table_name =~ 'PDV_T_CORTE'){
	my $query = "SELECT COUNT(*) FROM PDV_T_CORTE ".
		    "WHERE ID_TERMINAL = '$terminal' AND CAST(FECHA_INICIO AS DATE) = '$fecha'";
	my $stl = $_SERVER->prepare( $query );
	$stl->execute();
	my @outs = $stl->fetchrow_array();
	return $outs[0];
     }
}

######################################################################
#Inserta la informacion en la tabla del corporativo a la que corresponde
sub setDatosTabla(){
  	my ($s_tabla, $s_fecha, $s_terminal, $s_insert, @a_datos)= @_;
	my $li_adm = 0;
	my $li_cuantos = 0;
	my $total_registros_remotos = scalar(@a_datos);
	foreach my $x (0..@a_datos-1){
	   my @describe = undef;
	   my $li_indice = 0;
	   foreach my $y (0..@{$a_datos[$x]} ){
	      $describe[$li_indice] = $a_datos[$x][$y]; 
	      $li_indice++;
	   }#insertamos en el servidor central
	  $li_indice = 1;
	  my $stg = $_SERVER->prepare( $s_insert );
	  foreach my $row (@describe){
	     $stg->bind_param($li_indice, $row);
	     $li_indice++;
	  }#fin foreach describe
	  #$stg->execute()|| die "execute: $stg: $DBI::errstr"; 
	  $stg->execute();
	  $li_adm++;


	  if($s_tabla =~ 'PDV_T_CORTE'){
#borramos en pdv_corte_d los cortes de ese dia	
	     my $s_borra_detalle = "DELETE FROM PDV_CORTE_D WHERE ID_CORTE = ? AND ID_TERMINAL = ?";
	     my $sth_corteD = $_SERVER->prepare($s_borra_detalle);
	     $sth_corteD->bind_param(1,$describe[1]);
	     $sth_corteD->bind_param(2,$describe[0]);
	     $sth_corteD->execute();
	
              my $s_get_corteD = "SELECT ID_TERMINAL, ID_CORTE, ENTREGA, SISTEMA, TIPO, ID_OCUPANTE, ID_FORMA_PAGO ".
			    "FROM PDV_CORTE_D ".
			    "WHERE ID_TERMINAL = ? AND ID_CORTE = ?";
	     $sth_corteD = $_REMOTO->prepare( $s_get_corteD );
	     $sth_corteD->bind_param(1, $describe[0] );
	     $sth_corteD->bind_param(2, $describe[1] );
	     $sth_corteD->execute();
	     while( my @outs_corte = $sth_corteD->fetchrow_array()){
	        my $s_set_corteD = "INSERT INTO PDV_CORTE_D(ID_TERMINAL, ID_CORTE, ENTREGA, SISTEMA, TIPO, ID_OCUPANTE, ID_FORMA_PAGO) ".
			       "VALUES(?,?,?,?,?,?,?)";
	        my $sth_corteI = $_SERVER->prepare( $s_set_corteD );
	        $sth_corteI->bind_param(1, $outs_corte[0]);
	        $sth_corteI->bind_param(2, $outs_corte[1]);
	        $sth_corteI->bind_param(3, $outs_corte[2]);
	        $sth_corteI->bind_param(4, $outs_corte[3]);
	        $sth_corteI->bind_param(5, $outs_corte[4]);
	        $sth_corteI->bind_param(6, $outs_corte[5]);
	        $sth_corteI->bind_param(7, $outs_corte[6]);
	        $sth_corteI->execute();
	        $sth_corteI->finish();
	     }
	     $sth_corteD->finish();
	  }

	  if($stg->errstr){
	      #verificamos que la tabla sea BOLETO 
	      if($s_tabla =~ 'PDV_T_BOLETO'){
		  my $s_qry_problema = $s_insert;
		  $s_qry_problema =~ s/PDV_T_BOLETO\(/PDV_T_BOLETO_PROBLEMA\(/g;
		  #buscamos si no existe el boleto en la base de datos
		  if(&getBoletoCorpo(@describe) == 0){
		      #insertamos en la tabla PDV_T_BOLETO_PROBLEMA
		      my $sth_problema = $_SERVER->prepare( $s_qry_problema );
		      $li_indice = 1;
	  	      foreach my $row (@describe){
	      	          $stg->bind_param($li_indice, $row);
	     	          $li_indice++;
	     	      }
		      $sth_problema->execute();
		      $sth_problema->finish();
		  }
	      }#fin if

	      if($s_tabla =~ 'PDV_T_CORRIDA'){
		 my $s_corrida = "UPDATE PDV_T_CORRIDA SET CREADO_POR = ? WHERE ID_CORRIDA = ? AND FECHA = ?";
		 my $sth_corrida = $_SERVER->prepare( $s_corrida );
		 $sth_corrida->bind_param(1, $describe[8]);
		 $sth_corrida->bind_param(2, $describe[0]);
		 $sth_corrida->bind_param(3, $describe[1]);
		 $sth_corrida->execute();
		 $sth_corrida->finish();

	      }

	      if($s_tabla =~ 'PDV_T_CORRIDA_D'){
		  my $s_corrida_d = "UPDATE PDV_T_CORRIDA_D SET ESTATUS = ? WHERE ID_CORRIDA = ? AND FECHA = ? AND ID_TERMINAL = ? ";
		  my $sth_corridaD = $_SERVER->prepare( $s_corrida_d );  
		  $sth_corridaD->bind_param(1,$describe[6]);
		  $sth_corridaD->bind_param(2,$describe[0]);
		  $sth_corridaD->bind_param(3,$describe[1]);
		  $sth_corridaD->bind_param(4,$describe[2]);
		  $sth_corridaD->execute();
		  $sth_corridaD->finish();
	      }

	      if($s_tabla =~ 'PDV_T_GUIA'){
		  my $s_guia = "UPDATE PDV_T_GUIA SET NO_BUS = ?, INGRESO = ?, ID_OPERADOR = ?, OLLIN_FOLIO = ?, OLLIN_TIPO_CUOTA = ?, BOLETERA_FOLIO = ? ".
			       "WHERE ID_GUIA = ? AND ID_TERMINAL = ? ";
		  my $sth_guia = $_SERVER->prepare( $s_guia );
		  $sth_guia->bind_param(1,$describe[5]);
		  $sth_guia->bind_param(2,$describe[6]);
		  $sth_guia->bind_param(3,$describe[7]);
		  $sth_guia->bind_param(4,$describe[12]);
		  $sth_guia->bind_param(5,$describe[13]);
		  $sth_guia->bind_param(6,$describe[17]);
		  $sth_guia->bind_param(7,$describe[0]);
		  $sth_guia->bind_param(8,$describe[1]);
		  $sth_guia->execute();
		  $sth_guia->finish();
	      }
	  }	
	  $stg->finish();
	}
#print $li_adm . "\n";
	if($li_adm > 0){
	   my $total_corporativo = &getTotalRegistrosTabla($s_tabla, $s_fecha, $s_terminal);
	   my $status_adm = 0;
	   if( $total_corporativo == $total_registros_remotos ){
		$status_adm = 1;
	   }else{
		$status_adm = 2;
	   }
#print "total corporativo : " . $total_corporativo . "----" . $total_registros_remotos . "\n";
	   my $s_qry_update = "UPDATE ADM_STATUS_TABLA SET STATUS = ?, LUGAR = ?, CORPORATIVO = ?  WHERE FECHA = ? AND ID_TERMINAL = ? AND TABLA = ? ";
	   my $stg = $_SERVER->prepare( $s_qry_update );
	   $stg->bind_param(1, $status_adm);
	   $stg->bind_param(2, $total_registros_remotos );
	   $stg->bind_param(3, $total_corporativo );
	   $stg->bind_param(4, $s_fecha );
	   $stg->bind_param(5, $s_terminal );
	   $stg->bind_param(6, $s_tabla);
	   $stg->execute();
	   $stg->finish();
	   print "Proceso $s_tabla de la terminal $s_terminal\n";
	}
}


#############################################################################
sub borraTablaTerminal(){
	my ($fecha, $tabla, $terminal) = @_;	
  	if($tabla =~ 'PDV_T_CORRIDA_D'){
	#print "entra............ \n";
	    my $s_borra_corrida_d = "DELETE FROM PDV_T_CORRIDA_D WHERE FECHA = IN(?) AND ID_TERMINAL = ? ";
	    my $sth_corridaD = $_SERVER->prepare($s_borra_corrida_d);
	    $sth_corridaD->bind_param(1, $fecha);
	    $sth_corridaD->bind_param(2, $terminal);
	    $sth_corridaD->execute();
	#print "Salida............\n";
  	}
}

#################     Main    ###############################################
$_SERVER = &conectaServer($base, $host, $user, $pass);
my %hash = &getTerminales();

foreach my $k (keys %hash) {
   if (length(@{$hash{$k}}[0]) > 0){
      @a_fechas = &getFechasSistema(@{$hash{$k}}[0]);   #extraemos las fechas para insertalas en la tabla ADM_STATUS_TABLA
      &setADMTabla(@{$hash{$k}}[0]);                    #insertamos la fecha que no se encuentre en la tabla
      $_REMOTO = &conectaServer(@{$hash{$k}}[2],@{$hash{$k}}[1],@{$hash{$k}}[3],@{$hash{$k}}[4]);
      if(defined $_REMOTO){
	  my @a_fecha_tablas = &getADMTablaTerminal(@{$hash{$k}}[0]);
	  foreach my $x (0..@a_fecha_tablas -1){
	  	my @a_adm_tabla = undef;
	  	my $li_busca = 0;
		if(defined @{$a_fecha_tablas[$x]}){
		    foreach my $y (0..@{$a_fecha_tablas[$x]}  ){
    		        $a_adm_tabla[$li_busca] = $a_fecha_tablas[$x][$y];
		        $li_busca++;
		    }
		    my @a_campos = &getDescripcionTabla(uc($a_adm_tabla[1]))  ;
		    my $query_consulta = &getQueryTabla(uc($a_adm_tabla[1]), $a_adm_tabla[0], @{$hash{$k}}[0], @a_campos ) ;
		    my @a_remoto = &getDatosTabla( $query_consulta, $a_adm_tabla[0], &getDescripcionTabla(uc($a_adm_tabla[1]))  );
		    if (scalar @a_remoto > 0 ){
		       &borraTablaTerminal($a_adm_tabla[0],$a_adm_tabla[1], @{$hash{$k}}[0]);
		       &setDatosTabla($a_adm_tabla[1], $a_adm_tabla[0], $k, &getQueryInsert($a_adm_tabla[1], @a_campos), @a_remoto);
		    }else{
	   		my $s_qry_update = "UPDATE ADM_STATUS_TABLA SET STATUS = 3, LUGAR = 0, CORPORATIVO = 0  WHERE FECHA = ? AND ID_TERMINAL = ? AND TABLA = ? ";
	   		my $stg = $_SERVER->prepare( $s_qry_update );
	   		$stg->bind_param(1, $a_adm_tabla[0]  );
	   		$stg->bind_param(2, @{$hash{$k}}[0] );
	   		$stg->bind_param(3, $a_adm_tabla[1] );
	   		$stg->execute();
	   		$stg->finish();
		    }
		}
	  }
#agregar para que traer la informacion del dia actual
      }else{
	  print "Sin conexion @{$hash{$k}}[0]\n";
      }
      if(defined $_REMOTO){
         $_REMOTO->disconnect();
      }
   }
}
$_SERVER->disconnect();
