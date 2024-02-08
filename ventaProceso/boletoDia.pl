#!/usr/bin/perl -w
use DBI;
use strict;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
my $user = "root";
my $pass = "#R0j0N3no\$";
my $port = 3306;
my $SERVER = undef;
my ($sec ,$min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
my @a_fechas = undef;
my $f_archivo = "/opt/larios/temporal.txt";

my $header = "(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ".
             "ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX, ".
             "TC, IVA, TOTAL_IVA, FACTURADO, ID_REFERENCIA, COPIADO)";

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

sub getFechasProcesado{
	my $idx = 0;
	my $query = "SELECT FECHA FROM REP_C_FECHA WHERE PROCESADO = 0 ORDER BY 1 DESC";
	my $sth = $SERVER->prepare( $query );
	$sth->execute();
	while( my @fecha = $sth->fetchrow_array() ){
		#print join(',', @fecha ) . "\n";
		$a_fechas[$idx] = $fecha[0];
		$idx++;
	}
	$sth->finish();
}


sub setInsertTabla{
	my ($anio, $tabla, @outs) = @_;
        my $s_inserta = "INSERT INTO $tabla$anio(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ".
                        "  ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ".
                        "  ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ".
                        "  ID_PAGO_PINPAD_BANAMEX, TC, IVA, TOTAL_IVA, FACTURADO, ID_REFERENCIA, COPIADO) ".
                        "VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?)";
        my $sti = $SERVER->prepare($s_inserta);
        $sti->bind_param(1,$outs[0]);
        $sti->bind_param(2,$outs[1]);
        $sti->bind_param(3,$outs[2]);
        $sti->bind_param(4,$outs[3]);
        $sti->bind_param(5,$outs[4]);
        $sti->bind_param(6,$outs[5]);
        $sti->bind_param(7,$outs[6]);
        $sti->bind_param(8,$outs[7]);
        $sti->bind_param(9,$outs[8]);
        $sti->bind_param(10,$outs[9]);
        $sti->bind_param(11,$outs[10]);
        $sti->bind_param(12,$outs[11]);
        $sti->bind_param(13,$outs[12]);
        $sti->bind_param(14,$outs[13]);
        $sti->bind_param(15,$outs[14]);
        $sti->bind_param(16,$outs[15]);
        $sti->bind_param(17,$outs[16]);
        $sti->bind_param(18,$outs[17]);
        $sti->bind_param(19,$outs[18]);
        $sti->bind_param(20,$outs[19]);
        $sti->bind_param(21,$outs[20]);
        $sti->bind_param(22,$outs[21]);
        $sti->bind_param(23,$outs[22]);
        $sti->bind_param(24,$outs[23]);
        $sti->bind_param(25,$outs[24]);
        $sti->bind_param(26,$outs[25]);
        $sti->execute();
        $sti->finish();
}

sub getBoletos{
	my $dia = shift;
	my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ".
                    "ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX, ".
                    "TC, IVA, TOTAL_IVA, FACTURADO, ID_REFERENCIA, COPIADO ".
                    "FROM PDV_T_BOLETO B ".
                    "WHERE FECHA = ? ";
	my $sth = $SERVER->prepare( $query );
	$sth->bind_param(1, $dia);
	$sth->execute();
#	print $dia . "   " .$sth->rows();
	if($sth->rows > 0){
                while( (my @outs) = $sth->fetchrow_array() ){
			&setInsertTabla( substr($dia,0,4), 'PDV_T_BOLETO_', @outs);
		}
	}
	$sth->finish();
}

sub updateRepFecha{
	my $dia = shift;
	my $query = "UPDATE REP_C_FECHA SET PROCESADO = 1 WHERE FECHA = ?";
	my $sth = $SERVER->prepare( $query );
	$sth->bind_param( 1, $dia );	
	$sth->execute();
	$sth->finish();
	print "Update........\n";
}

$SERVER = &conectaServer($base, $host, $user, $pass);
&getFechasProcesado();
my $dia = undef;
foreach $dia (@a_fechas){
#	print "Dia a procesar : " . $dia ."\n";
	&getBoletos($dia);
	&updateRepFecha($dia);
	print "saliendo........\n";
}
$SERVER->disconnect();




