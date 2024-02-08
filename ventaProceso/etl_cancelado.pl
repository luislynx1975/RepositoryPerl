#programa que extra la información de la tabla de venta que es 
#PDV_T_BOLETO esta información es guardada en la tabla 
#REP_T_VENTA_TRANSPORTADO 
#!/usr/bin/perl
use DBI;
use strict;

my $base = "CORPORATIVO";
my $host = "192.168.1.27";
my $user = "venta";
my $pass = "GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE";
my $port = 3306;
my @a_fecha_boleto = undef;
my @a_anios_boleto = undef;
my $SERVER = undef;
my $table_nombre = "PDV_T_BOLETO_";
my $anio = 2016;

my ($sec ,$min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);

sub conectaServer{
	my $dbase_db = undef; 
        my $ip_db = undef; 
        my $user_db = undef; 
        my $pass_db = undef; 
	my $connectionInfo = undef;
	my $dbh = undef; 
	($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
        return $dbh;
}

sub getTablaAnio{
	my $fecha = shift;
	$anio = substr($fecha, 0, 4);
	return "PDV_T_BOLETO_" . $anio;

}

sub getBoletoAnio{
	my @a_boleto = @_;
	my $query = "SELECT FECHA FROM PDV_T_BOLETO WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
	my $stb = $SERVER->prepare( $query );
	$stb->bind_param(1, $a_boleto[0]);
	$stb->bind_param(2, $a_boleto[1]);
	$stb->bind_param(3, $a_boleto[2]);
	$stb->execute();
	while( my @outs = $stb->fetchrow_array() ){
		my $tabla = &getTablaAnio($outs[0]);
		$query = "UPDATE $tabla SET ESTATUS = 'C' WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
		my $stu = $SERVER->prepare( $query );
		$stu->bind_param(1, $a_boleto[0]);
		$stu->bind_param(2, $a_boleto[1]);
		$stu->bind_param(3, $a_boleto[2]);
		$stu->execute();
		$stu->finish();
	}
}

sub getBoletoCancelado{
	my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID FROM PDV_T_BOLETO_CANCELADO B WHERE B.PROCESADO = 0";
	my $sth = $SERVER->prepare( $query );
	$sth->execute();
	while( my @outs = $sth->fetchrow_array()){
#		print join(',',@outs) . "\n";
		&getBoletoAnio(@outs);
		$query = "UPDATE PDV_T_BOLETO_CANCELADO SET PROCESADO = 1 WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
		my $stc = $SERVER->prepare($query);
		$stc->bind_param(1, $outs[0]);
		$stc->bind_param(2, $outs[1]);
		$stc->bind_param(3, $outs[2]);
		$stc->execute();
	}
	 	
}

$SERVER = &conectaServer($base, $host, $user, $pass);
&getBoletoCancelado();
$SERVER->disconnect();
