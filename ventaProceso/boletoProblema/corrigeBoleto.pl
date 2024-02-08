#!/usr/bin/perl

#Creado el 05-04-2016
#version 1.0

use DBI;
use warnings;
use strict;

my $db = "CORPORATIVO";
my $host = "192.168.1.13";
my $port = 3306;
my $user = "root";
my $pass = '#R0j0N3no$';
my $_REMOTO = undef;
my $_SERVER = undef;

##################################################################
sub conectaServer{
        my ($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
	my $dbh = undef;
	eval{
        	$dbh = DBI->connect($connectionInfo,$user_db,$pass_db, {RaiseError => 1, PrintError => 0} );
	};
	if($@){
		$dbh = undef;
	}
        return $dbh;
}

##################################################################
sub borrarExiste(){
	my @a_input = @_;
	my $query = "DELETE FROM PDV_T_BOLETO_PROBLEMA WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? AND ID_BOLETO_NUEVO = 0";
	my $std = $_SERVER->prepare($query);
	$std->bind_param(1, $a_input[0]);
	$std->bind_param(2, $a_input[1]);
	$std->bind_param(3, $a_input[2]);
	$std->execute();
	$std->finish();
}

##################################################################
sub getBoletoExiste(){
	my @a_existe = @_;
	my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, TC FROM PDV_T_BOLETO ".
		    "WHERE ID_TERMINAL = ? AND TRAB_ID = ? AND ESTATUS = ? AND ORIGEN = ? AND DESTINO = ? AND TARIFA = ? AND NO_ASIENTO = ? ".
		    "AND ID_CORRIDA = ? AND FECHA = ? ";
	my $stb = $_SERVER->prepare( $query );	
	$stb->bind_param(1,$a_existe[1] );
	$stb->bind_param(2,$a_existe[2] );
	$stb->bind_param(3,$a_existe[3] );
	$stb->bind_param(4,$a_existe[4] );
	$stb->bind_param(5,$a_existe[5] );
	$stb->bind_param(6,$a_existe[6] );
	$stb->bind_param(7,$a_existe[14] );
	$stb->bind_param(8,$a_existe[11] );
	$stb->bind_param(9,$a_existe[12] );
	$stb->execute();
	my $ok = 0;
	if($stb->rows > 0){
	    $ok = 1;
	}
	$stb->finish();
	return $ok;
}


##################################################################
sub setParaExtraer(){
	my @a_update = @_;
	my $query = "UPDATE PDV_T_BOLETO_PROBLEMA SET ID_BOLETO_NUEVO = 20160411 ".
		    "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? ";
	my $stu = $_SERVER->prepare($query);
	$stu->bind_param(1, $a_update[0]);
	$stu->bind_param(2, $a_update[1]);
	$stu->bind_param(3, $a_update[2]);
	$stu->execute();
	$stu->finish();
}


##################################################################
#Conseguimos los datos de la tabla problema y comparamos si existe, borramos
sub getBoletoProblema(){
	my $query = "SELECT * FROM PDV_T_BOLETO_PROBLEMA WHERE ID_BOLETO_NUEVO = 0";
	my $sth = $_SERVER->prepare( $query );
	$sth->execute();	
	while(my @outs = $sth->fetchrow_array()){
	   if (&getBoletoExiste(@outs) == 1){
		&borrarExiste(@outs);
	   }else{
		&setParaExtraer(@outs);
	   }
	}
	$sth->finish();
}
##################################################################
#extraemos los datos para la conexion de los boletos problema
sub getTerminalesProblema(){
	my %h_terminal = ();
	my $query = "SELECT DISTINCT(IPV4), BD_USUARIO, BD_PASSWORD, BD_BASEDATOS, B.ID_TERMINAL ".
		    "FROM PDV_C_TERMINAL T INNER JOIN PDV_T_BOLETO_PROBLEMA B ON T.ID_TERMINAL = B.ID_TERMINAL ".
		    "WHERE B.ID_BOLETO_NUEVO = 0 ".
		    "ORDER BY ID_TERMINAL ";
	my $stt = $_SERVER->prepare( $query );
	$stt->execute();
	while(my @outs = $stt->fetchrow_array() ){
	   $h_terminal{$outs[4]} = \@outs;
	}
	$stt->finish();
	return %h_terminal;
}
##################################################################
#conseguimos los empleados por terminal de la tabla de pdv_t_boleto_problema
sub getTrabidTerminal(){
	my @a_trabids = ();
	my $i_idx = 0;
	my $s_terminal = shift;	
	my $query = "SELECT DISTINCT(TRAB_ID) ".
		    "FROM PDV_T_BOLETO_PROBLEMA ".
		    "WHERE ID_TERMINAl = ? AND ID_BOLETO_NUEVO = 0";
	my $stt = $_SERVER->prepare($query);
	$stt->bind_param(1, $s_terminal);
	$stt->execute();
	while(my @out = $stt->fetchrow_array()){
		$a_trabids[$i_idx] = $out[0];
		$i_idx++;
	}
	$stt->finish();
	return @a_trabids;
}

##################################################################
#obtener el maximo + 1 registro en la tabla de pdv_t_boleto
sub getMaxBoleto(){
	my ($s_terminal, $s_user)= @_;
	my $val = 0;
	my $query = "SELECT (MAX(ID_BOLETO))AS MAXIMO ".
		    "FROM PDV_T_BOLETO ".
		    "WHERE ID_TERMINAL = ? AND TRAB_ID = ?";
	my $stq = $_SERVER->prepare( $query );
	$stq->bind_param(1, $s_terminal);
	$stq->bind_param(2, $s_user);
	$stq->execute();
	while( my @out = $stq->fetchrow_array()){
		$val = $out[0];
	}
	$stq->finish();
	return $val + 1;
}

##################################################################
#verfica si se encuentra en un corte actualmente
sub getVentaActual(){
	my ($s_terminal, $s_trabid) = @_;
	my $li_out = 0;
	my $query = "SELECT ID_CORTE ".
		    "FROM PDV_T_CORTE ".
		    "WHERE ID_EMPLEADO = ? AND ID_TERMINAL = ? AND ESTATUS IN ('A','S','P')";
	my $str = $_REMOTO->prepare( $query );
	$str->bind_param(1, $s_trabid );
	$str->bind_param(2, $s_terminal);
	$str->execute();
	if($str->rows > 0){
		my @out = $str->fetchrow_array();
		$li_out = $out[0];
	}else{
		$li_out = 0;
	}
	$str->finish();
	return $li_out;
}

##################################################################
#obtenemos la informacion de la tabla problema con la terminal y usuario
sub getDatosProblema(){
	my ($s_terminal, $s_trabid) = @_;
	my @a_outs = ();
	my $li_idx = 0;
	my $query = "SELECT ID_BOLETO,ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ".
		    "ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ".
		    "ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ".
		    "ID_PAGO_PINPAD_BANAMEX, IFNULL(TC,'')AS TC, IVA, TOTAL_IVA ".
		    "FROM PDV_T_BOLETO_PROBLEMA B ".
		    "WHERE B.ID_TERMINAL = ? AND B.TRAB_ID = ? AND ID_BOLETO_NUEVO = 20160411 ".
		    "ORDER BY 1 "; 
	my $stp = $_SERVER->prepare( $query );
	$stp->bind_param(1, $s_terminal );
	$stp->bind_param(2, $s_trabid );
	$stp->execute();
	while(my @outs  = $stp->fetchrow_array() ){
	    $a_outs[$li_idx] = \@outs;	
	    $li_idx++;
	}
	$stp->finish();
	return @a_outs;
}

##################################################################
#Actualizamos la tabla problema en el id_boleto_nuevo
sub setBoletoProblema(){
	my ($li_nuevo, @a_boleto) = @_;
	my $query = "UPDATE PDV_T_BOLETO_PROBLEMA SET ID_BOLETO_NUEVO = ? ".
		    "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ? AND ID_BOLETO_NUEVO = 0";
	my $stu = $_SERVER->prepare( $query );
	$stu->bind_param(1, $li_nuevo);
	$stu->bind_param(2, $a_boleto[0]);
	$stu->bind_param(3, $a_boleto[1]);
	$stu->bind_param(4, $a_boleto[2]);
	$stu->execute();
	$stu->finish();
}

##################################################################
#insertamos el boleto en la tabla de pvd_t_boleto con el nuevo id_boleto
sub setPDV_T_BOLETO(){
	my ($li_idBoleto, @a_boleto) = @_;
	my $query = "INSERT INTO PDV_T_BOLETO(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, ".
		    		             "DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, ".
		             		     "FECHA_HORA_BOLETO, ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ".
		             		     "ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX, ".
					     "TC, IVA, TOTAL_IVA) ".
		    "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	my $sti = $_SERVER->prepare($query);
	$sti->bind_param(1,$li_idBoleto);
	$sti->bind_param(2,$a_boleto[1]);
	$sti->bind_param(3,$a_boleto[2]);
	$sti->bind_param(4,$a_boleto[3]);
	$sti->bind_param(5,$a_boleto[4]);
	$sti->bind_param(6,$a_boleto[5]);
	$sti->bind_param(7,$a_boleto[6]);
	$sti->bind_param(8,$a_boleto[7]);
	$sti->bind_param(9,$a_boleto[8]);
	$sti->bind_param(10,$a_boleto[9]);
	$sti->bind_param(11,$a_boleto[10]);
	$sti->bind_param(12,$a_boleto[11]);
	$sti->bind_param(13,$a_boleto[12]);
	$sti->bind_param(14,$a_boleto[13]);
	$sti->bind_param(15,$a_boleto[14]);
	$sti->bind_param(16,$a_boleto[15]);
	$sti->bind_param(17,$a_boleto[16]);
	$sti->bind_param(18,$a_boleto[17]);
	$sti->bind_param(19,$a_boleto[18]);
	$sti->bind_param(20,$a_boleto[19]);
	$sti->bind_param(21,$a_boleto[20]);
	$sti->bind_param(22,$a_boleto[21]);
	$sti->bind_param(23,$a_boleto[22]);
	$sti->execute();
	
}
##################################################################
#Insertamos un registro en el servidor remoto
sub setBoletoRemoto(){
	my ($li_idxBoleto, $s_terminal, $s_trabid) = @_;
	my $query = "INSERT INTO PDV_T_BOLETO(ID_BOLETO,ID_TERMINAL,TRAB_ID, ESTATUS,TIPO_TARIFA,FECHA_HORA_BOLETO,".
		   			      "ID_RUTA,IVA,TOTAL_IVA, DESTINO,ORIGEN,TARIFA,".
					      "ID_FORMA_PAGO,ID_TAQUILLA,ID_CORRIDA) ".
		    "VALUES(?,?,?,'V','A',NOW(),1,0,0,'','',0,0,0,'')";
	my $str = $_REMOTO->prepare( $query );
	$str->bind_param(1, $li_idxBoleto );
	$str->bind_param(2, $s_terminal );
	$str->bind_param(3, $s_trabid );
	$str->execute();
}

###################### MAIN ######################################

$_SERVER = &conectaServer($db, $host, $user, $pass); 
#verificamos los boleto si estan repetidos en la tabla pdv_t_boleto
&getBoletoProblema();

exit;
my %h_hash = &getTerminalesProblema();

while(my ($k, $v) = each %h_hash){
	print "$h_hash{$k}[4]  \n";
	$_REMOTO = &conectaServer($h_hash{$k}[3], $h_hash{$k}[0], $h_hash{$k}[1], $h_hash{$k}[2]);
	if(defined $_REMOTO){
		print "Connectado \n";
		foreach my $s_trabid (&getTrabidTerminal($h_hash{$k}[4])){
	#obtenemos el valor maximo de la terminal por el trabid
			print "Terminal : $h_hash{$k}[4]   $s_trabid ".   &getMaxBoleto($h_hash{$k}[4], $s_trabid) . " \n";
		   my $li_max_problema = &getMaxBoleto($h_hash{$k}[4], $s_trabid);

		   if(&getVentaActual($h_hash{$k}[4], $s_trabid) == 0){
			#consultamos la informacion de la tabla problema
			my @a_datos_problema = &getDatosProblema($h_hash{$k}[4], $s_trabid);
			foreach my $row (0..@a_datos_problema-1){
#			    my @a_columnas = @{$a_datos_problema[$row]};
			    &setPDV_T_BOLETO($li_max_problema, @{$a_datos_problema[$row]} );
			    &setBoletoProblema($li_max_problema, @{$a_datos_problema[$row]} );
			    $li_max_problema++;
			}
			#print "El valor maximo es $li_max_problema \n";
			&setBoletoRemoto($li_max_problema + 1, $h_hash{$k}[4], $s_trabid);
		   }
		}
	}else{
		print "No esta OnLine \n";
	}
	if(defined $_REMOTO){
	     $_REMOTO->disconnect();
	}
}
$_SERVER->disconnect();

#	for my $i (0..$#{ $h_hash{$k}} ) {
#		print "$i = $h_hash{$k}[$i] \n";
#	}
