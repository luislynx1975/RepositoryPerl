#!/usr/bin/perl
use DBI;
use warnings;
use strict;
use Switch;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
my $user = "root";
my $pass = "#R0j0N3no\$";
my $port = 3306;
my $_SERVER = undef;
my $_REMOTO = undef;
my @a_fechas = ();
my @a_terminales = ();
my @a_tablas = ('PDV_T_GUIA' );

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
        my $sth = $_SERVER->prepare("SELECT S.ID_TERMINAL, T.IPv4, T.BD_BASEDATOS, T.BD_USUARIO, T.BD_PASSWORD, T.ID_TERMINAL  ".
                                    "FROM PDV_C_GRUPO_SERVICIOS S INNER JOIN PDV_C_TERMINAL T ON S.ID_TERMINAL  = T.ID_TERMINAL ".
                                    "WHERE T.ID_TERMINAL IN ('MEX')");
        $sth->execute();
        while(my @outs = $sth->fetchrow_array()){
                $a_ter{$outs[0]} =  \@outs;
        }
        $sth->finish();
        return %a_ter;
}

#############################################################################
sub getFechaRegistrada{
	my $terminal = shift;
	my $s_out = "";
	my $sth = $_SERVER->prepare("SELECT FECHA FROM ADM_RESPALDO_REMOTO WHERE ID_TERMINAL = ?");
	$sth->bind_param(1, $terminal);
	$sth->execute();
	my @out = $sth->fetchrow_array();
	if(defined $out[0]){
	    $s_out = $out[0];
	}else{
	    $s_out = "NULO";
	}
	#print $s_out . "\n";
	return $s_out;
}


#############################################################################
sub getFechaBoleto{
	my $sth = $_REMOTO->prepare("SELECT MIN(CAST(FECHA AS DATE)) FROM PDV_T_BOLETO");
	$sth->execute();
	my @out = $sth->fetchrow_array();
	return $out[0];
}

#############################################################################
sub setFechaRespaldo{
	my ($fecha, $terminal, $tabla) = @_;
	my $sth = $_SERVER->prepare("INSERT INTO ADM_RESPALDO_REMOTO(ID_TERMINAL, TABLA, FECHA) ".
				    "VALUES(?,?,?)");
	$sth->bind_param(1, $terminal);
	$sth->bind_param(2, $tabla);
	$sth->bind_param(3, $fecha);
	$sth->execute();
}

#############################################################################
sub setStoreRespaldo{
	my ($origen, $respaldo, $fecha, $terminal ) = @_;
	my $query = "CALL RESPALDA_INFORMACION('$origen','$respaldo','$fecha')";
	my $str = $_REMOTO->prepare("CALL RESPALDA_INFORMACION(?, ?, ?)");
	$str->bind_param(1, $origen);
	$str->bind_param(2, $respaldo);
	$str->bind_param(3, $fecha);
	$str->execute();
	$str->finish();
	
	#print "ya envie el store \n";
 	my $sth = $_SERVER->prepare("UPDATE ADM_RESPALDO_REMOTO SET FECHA = (SELECT DATE_ADD('$fecha', INTERVAL 1 DAY)) ".
				    "WHERE ID_TERMINAL = ? AND TABLA = ? AND FECHA = ? ");
	$sth->bind_param(1, $terminal);
	$sth->bind_param(2, $origen);
	$sth->bind_param(3, $fecha);
	$sth->execute();
	$sth->finish();
}



#################     Main    ###############################################
$_SERVER = &conectaServer($base, $host, $user, $pass);
my %hash = &getTerminales();

foreach my $k (keys %hash) {
      $_REMOTO = &conectaServer(@{$hash{$k}}[2], @{$hash{$k}}[1], @{$hash{$k}}[3], @{$hash{$k}}[4] );
      if(defined $_REMOTO){
	#print "Conectado al server @{$hash{$k}}[1]\n";
	 my $fecha = &getFechaRegistrada(@{$hash{$k}}[5]);
	 if($fecha =~ 'NULO'){
		&setFechaRespaldo(&getFechaBoleto(), @{$hash{$k}}[5], 'PDV_T_BOLETO');
	 }
	$fecha = &getFechaRegistrada(@{$hash{$k}}[5]);
	#print $fecha . "\n";
	#print &getFechaBoleto();
	&setStoreRespaldo('PDV_T_BOLETO','PDV_T_BOLETO_RESPALDO',$fecha, @{$hash{$k}}[5]);
      }else{
	  print "Error no se a establecido conexion @{$hash{$k}}[1] \n";
      }	

      if( defined $_REMOTO){
	 $_REMOTO->disconnect();
      }
}
$_SERVER->disconnect();
