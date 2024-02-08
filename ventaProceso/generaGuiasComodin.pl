#!/usr/bin/perl
use DBI;
use warnings;
use strict;
use Switch;
use Data::Dumper;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
my $user = "root";
my $pass = "3st\@b\@M0sB13n\$";
my $port = 3306;
my $_SERVER = undef;
my $_REMOTO = undef;
my @a_terminales = ();

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
        my $sth = $_SERVER->prepare("SELECT S.ID_TERMINAL, T.IPv4, T.BD_BASEDATOS, T.BD_USUARIO, T.BD_PASSWORD  ".
                                     "FROM PDV_C_GRUPO_SERVICIOS S INNER JOIN PDV_C_TERMINAL T ON S.ID_TERMINAL  = T.ID_TERMINAL ");
        $sth->execute();
        while(my @outs = $sth->fetchrow_array()){
                $a_ter{$outs[0]} =  \@outs;
        }
        $sth->finish();
        return %a_ter;
}

######################################################################
sub getHora()
{
	my $sth = $_REMOTO->prepare("SELECT SUBTIME(CURRENT_TIME(),'1:00:00.000000')AS HORA");
	$sth->execute();
	my @outs = $sth->fetchrow_array();
	return $outs[0];
}

######################################################################
sub procesaCorridaGuias()
{
	my ($terminal) = shift;
	my %h_corridas = ();
	my $sth = $_REMOTO->prepare("SELECT ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, ID_RUTA, TRAB_ID ".
                                  "FROM  PDV_T_CORRIDA_D D  ".
                                  "WHERE D.ESTATUS = 'A' AND D.FECHA = SUBDATE(CURRENT_DATE(),INTERVAL 1 DAY) AND D.ID_TERMINAL = ? ".
                                  "UNION ".
                                  "SELECT ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, ID_RUTA, TRAB_ID ".
                                  "FROM  PDV_T_CORRIDA_D D  ".
                                  "WHERE D.ESTATUS = 'A' AND D.FECHA = CURRENT_DATE AND D.ID_TERMINAL = ? AND HORA < SUBTIME(CURRENT_TIME(),'1:00:00.000000') ".
                                  "ORDER BY FECHA, HORA");

	$sth->bind_param(1, $terminal);
	$sth->bind_param(2, $terminal);
	$sth->execute();
	while(my @outs = $sth->fetchrow_array()){
		$h_corridas{$outs[0]} = \@outs;
	}
	$sth->finish();
	return %h_corridas;
}

######################################################################
sub getCorridaGuia()
{
	my ($corrida, $fecha) = @_;
#	print $corrida . " " . $fecha . "\n";
	my $stg = $_REMOTO->prepare("SELECT G.ID_GUIA, G.ID_OPERADOR, G.NO_BUS ".
				 "FROM PDV_T_GUIA G ".
				 "WHERE G.ID_CORRIDA = ? AND G.FECHA = ? ");
	$stg->bind_param(1, $corrida);
	$stg->bind_param(2, $fecha);
	$stg->execute();
	my @outs = $stg->fetchrow_array();
	return @outs;
}

######################################################################
sub getTieneVenta()
{
	my ($corrida, $fecha) = @_;
	my $sth = $_REMOTO->prepare("SELECT COALESCE(SUM(TARIFA),0) ".
				    "FROM PDV_T_BOLETO B ".
				    "WHERE B.ID_CORRIDA = ? AND FECHA = ? AND ESTATUS = 'V'");
	$sth->bind_param(1, $corrida);
	$sth->bind_param(2, $fecha);
	$sth->execute();
	my @outs = $sth->fetchrow_array();
	return $outs[0];
}

######################################################################
sub getGuia()
{
        my (@a_guia) = @_;
        my $query = "SELECT COALESCE(MAX(ID_GUIA+1),1) AS MAXIMO FROM PDV_T_GUIA";
        my $_max = $_REMOTO->prepare($query);
        $_max->execute();
        my $idGuias = $_max->fetchrow_hashref;
        my $insert_guia = "INSERT INTO PDV_T_GUIA(ID_GUIA, ID_TERMINAL, FECHA, ID_CORRIDA, ID_DESTINO, NO_BUS, INGRESO, ".
                       " ID_OPERADOR, TRAB_ID, TIPOSERVICIO, ID_RUTA, FECHA_HORA, OLLIN_FOLIO, OLLIN_TIPO_CUOTA, ".
                       "OLLIN_PROVEEDOR, TIPO_SERVICIO_CEMO, FOLIO_CEMO ) \n".
                       "VALUES($idGuias->{MAXIMO}, '$a_guia[2]', '$a_guia[1]', '$a_guia[0]', '$a_guia[3]', $a_guia[4], $a_guia[5], '$a_guia[6]',".
                       " '$a_guia[7]', $a_guia[8], $a_guia[9], NOW(), 0, 0, 0, 'Automatizado', 0)";
        my $Q_guia = $_REMOTO->prepare($insert_guia);
        $Q_guia->execute();
        $_max->finish();
	my $sts = $_SERVER->prepare($insert_guia);
	$sts->execute();
}



######################################################################
sub generaGuiaComodin()
{
	my ($corrida, $fecha, $terminal) = @_;
	my $query = "SELECT D.ID_CORRIDA, D.FECHA, D.ID_TERMINAL, ".
		 "(SELECT DESTINO FROM T_C_TRAMO T WHERE T.ID_TRAMO =  ".
                 "( SELECT RD.ID_TRAMO FROM T_C_RUTA R INNER JOIN T_C_RUTA_D RD ON R.ID_RUTA = RD.ID_RUTA  ".
                 "WHERE R.ID_RUTA = D.ID_RUTA ORDER BY 1 DESC LIMIT 1) )AS DESTINO, '9999' AS BUS, ".
                 "(SELECT COALESCE(SUM(TARIFA),0) ".
		 " FROM PDV_T_BOLETO B ".
		 " WHERE B.ID_CORRIDA = D.ID_CORRIDA AND B.FECHA = D.FECHA AND B.ESTATUS = 'V' ".
		 " )AS INGRESO,'XX999' AS OPERADOR, '99999' AS TRABID, C.TIPOSERVICIO, D.ID_RUTA, NOW(), D.HORA ".
		 "FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_CORRIDA C ON D.ID_CORRIDA = C.ID_CORRIDA AND D.FECHA = C.FECHA ".
		 "WHERE D.ID_CORRIDA = ? AND D.FECHA = ? AND D.ID_TERMINAL = ? ";
	my $sth = $_REMOTO->prepare($query);
	$sth->bind_param(1, $corrida);
	$sth->bind_param(2, $fecha);
	$sth->bind_param(3, $terminal);
	$sth->execute();
	&getGuia($sth->fetchrow_array() );
	$stl->execute();
	$stl->finish();
}

######################################################################
sub actualizaIngresoGuia()
{
	my ($guia, $operador, $bus) = @_;
	my $sth = $_REMOTO->prepare("UPDATE PDV_T_GUIA G SET INGRESO = (SELECT SUM(TARIFA) FROM PDV_T_BOLETO B ".
				    "WHERE B.FECHA = G.FECHA AND B.ID_CORRIDA = G.ID_CORRIDA AND B.ESTATUS = 'V') ".
				    "WHERE G.ID_GUIA = ? AND G.ID_OPERADOR = ? AND G.NO_BUS = ? ");
	$sth->bind_param(1, $guia);
	$sth->bind_param(2, $operador);
	$sth->bind_param(3, $bus);
	$sth->execute();

	my $sts = $_SERVER->prepare("UPDATE PDV_T_GUIA G SET INGRESO = (SELECT SUM(TARIFA) FROM PDV_T_BOLETO B ".
				    "WHERE B.FECHA = G.FECHA AND B.ID_CORRIDA = G.ID_CORRIDA AND B.ESTATUS = 'V') ".
				    "WHERE G.ID_GUIA = ? AND G.ID_OPERADOR = ? AND G.NO_BUS = ? ");
	$sts->bind_param(1, $guia);
	$sts->bind_param(2, $operador);
	$sts->bind_param(3, $bus);
	$sts->execute();
}


######################################################################
sub actualizaCorrida()
{
	my ($corrida, $fecha, $estado ) = @_;
	my $sth = $_REMOTO->prepare("UPDATE PDV_T_CORRIDA_D SET ESTATUS = ? WHERE ID_CORRIDA = ? AND FECHA = ? ");
	$sth->bind_param(1, $estado);
	$sth->bind_param(2, $corrida);
	$sth->bind_param(3, $fecha);
	$sth->execute();

	my $sts = $_REMOTO->prepare("UPDATE PDV_T_CORRIDA_D SET ESTATUS = 'D' WHERE ID_CORRIDA = ? AND FECHA = ? ");
	$sts->bind_param(1, $estado);
	$sts->bind_param(2, $corrida);
	$sts->bind_param(3, $fecha);
	$sts->execute();

	$sth->finish();
	$sts->finish();
}


####################################################main#################################################
$_SERVER = &conectaServer($base, $host, $user, $pass);
my %hash = &getTerminales();

foreach my $k (keys %hash){
############conectamos al servidor
	$_REMOTO = &conectaServer(@{$hash{$k}}[2], @{$hash{$k}}[1], @{$hash{$k}}[3], @{$hash{$k}}[4] );
	if(defined $_REMOTO)
	{
		my $hora = &getHora();
		#print "Conectado : @{$hash{$k}}[0]\n";
		my %h_corridas = &procesaCorridaGuias( @{$hash{$k}}[0] );	
		foreach my $x (keys %h_corridas){
		   my @a_corridas = @{$h_corridas{$x}};
		   my @a_conguia = &getCorridaGuia( $a_corridas[0], $a_corridas[1]);
		   if(scalar(@a_conguia) == 0)
		   {#No tiene Guia pero tiene venta se genera una guia con el comodin
			if ( &getTieneVenta($a_corridas[0], $a_corridas[1] ) > 0)
			{#generamos la guia comodin
			    &generaGuiaComodin($a_corridas[0], $a_corridas[1], $a_corridas[2]);
			    &actualizaCorrida($a_corridas[0], $a_corridas[1], 'D');
			}else{
			    &actualizaCorrida($a_corridas[0], $a_corridas[1], 'C');
			}
		   }else{
		        #Se actualiza solo el ingreso y se manda al servidor
			#&actualizaIngresoGuia($a_conguia[0], $a_conguia[1], $a_conguia[2]);
			&actualizaCorrida($a_corridas[0], $a_corridas[1], 'D');
		   }
		}
	}else{

		print "Sin conexion @{$hash{$k}}[0]\n";
	}
}





