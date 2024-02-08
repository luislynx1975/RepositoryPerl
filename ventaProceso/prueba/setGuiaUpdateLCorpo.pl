#prueba de escritura
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
#obtenemos los ingresos de las guias para que se actualize el ingreso localmente y en el corporativo
sub getGuiaIngreso{
	my $sth = $_REMOTO->prepare("SELECT G.ID_GUIA, G.ID_TERMINAL, G.ID_CORRIDA,  G.INGRESO ".
				    "FROM PDV_T_GUIA G ".
				    "WHERE G.FECHA = CURRENT_DATE()");
	$sth->execute();
	while(my @outs = $sth->fetchrow_array()){
	    #print join(",", @outs) . "\n";
	    my $stg = $_REMOTO->prepare("SELECT COALESCE(SUM(B.TARIFA),0) FROM PDV_T_BOLETO B ".
					"WHERE B.ID_TERMINAL = ? AND B.ID_CORRIDA = ? AND B.ESTATUS = 'V' AND B.FECHA = CURRENT_DATE()");
	    $stg->bind_param(1, $outs[1]);
	    $stg->bind_param(2, $outs[2]);
	    $stg->execute();
	    while(my @a_ingreso = $stg->fetchrow_array()){
		my $stl = $_REMOTO->prepare("UPDATE PDV_T_GUIA SET INGRESO = ? ".
					   "WHERE ID_GUIA  = ? AND ID_TERMINAL = ? AND FECHA = CURRENT_DATE() AND ID_CORRIDA = ?");
		$stl->bind_param(1, $a_ingreso[0]);	
		$stl->bind_param(2, $outs[0]);
		$stl->bind_param(3, $outs[1]);
		$stl->bind_param(4, $outs[2]);
		$stl->execute();
		$stl->finish();
####actualizamos el server la guia
		my $sts = $_SERVER->prepare("UPDATE PDV_T_GUIA SET INGRESO = ? ".
					   "WHERE ID_GUIA  = ? AND ID_TERMINAL = ? AND FECHA = CURRENT_DATE() AND ID_CORRIDA = ?");
		$sts->bind_param(1, $a_ingreso[0]);	
		$sts->bind_param(2, $outs[0]);
		$sts->bind_param(3, $outs[1]);
		$sts->bind_param(4, $outs[2]);
		$sts->execute();
		$sts->finish();
	    }
	    $stg->finish();
	}
	$sth->finish();
}

######################################################################
#Obtenemos la lista de las terminales que se tienen registrado en la tabla de terminales
sub getTerminales{
        my %a_ter = ();
        my $idx = 0;
        my $sth = $_SERVER->prepare("SELECT S.ID_TERMINAL, T.IPv4, T.BD_BASEDATOS, T.BD_USUARIO, T.BD_PASSWORD  ".
                                    "FROM PDV_C_GRUPO_SERVICIOS S INNER JOIN PDV_C_TERMINAL T ON S.ID_TERMINAL  = T.ID_TERMINAL ");
#                                   "WHERE T.ID_TERMINAL = 'MEX'");
        $sth->execute();
        while(my @outs = $sth->fetchrow_array()){
                $a_ter{$outs[0]} =  \@outs;
        }
        $sth->finish();
        return %a_ter;
}

#################     Main    ###############################################
$_SERVER = &conectaServer($base, $host, $user, $pass);
my %hash = &getTerminales();

foreach my $k (keys %hash) {
      $_REMOTO = &conectaServer(@{$hash{$k}}[2], @{$hash{$k}}[1], @{$hash{$k}}[3], @{$hash{$k}}[4] );
      if(defined $_REMOTO){
	  &getGuiaIngreso();
      }else{
	  print "Error no se a establecido conexion @{$hash{$k}}[1] \n";
      }	

      if( defined $_REMOTO){
	 $_REMOTO->disconnect();
      }
}
$_SERVER->disconnect();
