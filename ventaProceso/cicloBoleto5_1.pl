#programa que extra la información de la tabla de venta que es 
#PDV_T_BOLETO esta información es guardada en la tabla 
#proceso que toma una cantidad de dias por procesar esto puede reasignarse 
#copia el valor a la tabla que le corresponde
#!/usr/bin/perl
use DBI;
use strict;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
#my $user = "venta";
#my $pass = "GbS\=aVw0oMoHT8\!$6cw\!7;b8R3+ella\?bCZE";
my $user = "root";
my $pass = "3st\@b\@M0sB13n\$";
my $port = 3306;
my @a_fecha_boleto = undef;
my @a_anios_boleto = undef;
my $SERVER = undef;
my $table_nombre = "PDV_T_BOLETO_";
#my $anio = 2016;

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

sub getAnioBoleto
{
	my $fecha = shift;
	my $l_anio = substr($fecha,0,4);
	if(($year+1900) == $l_anio)
	{
		return 1;
	}
	return 0;
}

sub getFechasBoleto{
	my $idx = 0;
	my $query = undef;
	my $sth = undef;
	my @a_fechas = undef;
	my %h_fechas = ();
	#$query = "SELECT CURRENT_DATE()";
	$query = "select * from ".
"(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t0, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t1, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t2, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t3, ".
" (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) t4) v ".
"where fechas between '2019-02-01' and '2019-09-31'";

#"where fechas = '2019-10-23' ";
#"where fechas between ( SELECT DATE_SUB(CURRENT_DATE(),INTERVAL 30 DAY) ) and ( CURRENT_DATE() )";
#"where fechas between ( SELECT DATE_SUB(CURRENT_DATE(),INTERVAL 3 DAY) ) and ( SELECT DATE_SUB(CURRENT_DATE(),INTERVAL 1 DAY) )";
#print $query ."\n";
	$sth = $SERVER->prepare( $query );
	$sth->execute();
	while( (@a_fechas ) = $sth->fetchrow_array() ){
		$a_fecha_boleto[$idx] = $a_fechas[0];	
		$idx++;
	}
	foreach my $fecha (@a_fecha_boleto){
		push @a_fechas, $fecha if not $h_fechas{$fecha}++;
	}
	return @a_fechas;
}

sub getAniosBoleto{
	my @la_fecha = @_;
	my $year = undef;
	my @years = undef;
	my $idx = undef;
	$idx = 0;
	foreach(@la_fecha){
		$year = substr($_, 0,4);
		if( grep (/$year/, @years) ) {
			;
		}else{
			$years[$idx] = $year;
			$idx++;
		}
	}
	return @years;
}

sub existeTablaBoletoAnio{
	my $year = shift;
	my $query = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ".
		    "WHERE TABLE_NAME = ? AND TABLE_SCHEMA = 'CORPORATIVO'";
	my $sth = $SERVER->prepare( $query );
	$sth->bind_param(1, $table_nombre . $year);
	my $respuesta = $sth->execute();
	$sth->finish();
	if($respuesta == 0){
	   return 0;
	}else{
	   return 1;
	}
}


sub createTableAnio{
	my $nombre_tabla = shift;
	my $query = "CREATE TABLE $nombre_tabla( ".
		    " ID_BOLETO INT(11) NOT NULL, ".
		    "ID_TERMINAL VARCHAR(5) NOT NULL COMMENT 'Lugar de la  Venta del Boleto', ".
		    "TRAB_ID VARCHAR(7) NOT NULL, ".
		    "ESTATUS VARCHAR(1) NOT NULL COMMENT 'V Vendido C Cancelado', ".
		    "ORIGEN VARCHAR(5) NULL DEFAULT NULL, ".
		    "DESTINO VARCHAR(5) NOT NULL, ".
		    "TARIFA DECIMAL(9,2) NOT NULL, ".
		    "ID_FORMA_PAGO INT(11) NULL DEFAULT NULL, ".
		    "ID_TAQUILLA INT(11) NULL DEFAULT NULL, ".
		    "TIPO_TARIFA VARCHAR(1) NOT NULL COMMENT 'ESTUDIANTE, SENECTUD, PROFESOR, MENOR Y NORMAL', ".
		    "FECHA_HORA_BOLETO DATETIME NOT NULL COMMENT 'Fecha y hora de la transaccion sobre el boleto', ".
		    "ID_CORRIDA VARCHAR(10) NULL DEFAULT NULL, ".
		    "FECHA DATE NULL DEFAULT NULL COMMENT 'Fecha de la corrida.', ".
		    "NOMBRE_PASAJERO VARCHAR(40) NULL DEFAULT NULL, ".
		    "NO_ASIENTO INT(11) NULL DEFAULT NULL, ".
		    "ID_OCUPANTE INT(11) NULL DEFAULT NULL, ".
		    "ESTATUS_PROCESADO VARCHAR(1) NULL DEFAULT NULL, ".
		    "ID_RUTA INT(11) NULL DEFAULT NULL, ".
		    "TIPOSERVICIO INT(11) NULL DEFAULT NULL, ".
		    "ID_PAGO_PINPAD_BANAMEX VARCHAR(14) NULL DEFAULT NULL, ".
		    "TC VARCHAR(80) NULL DEFAULT NULL, ".
		    "IVA DECIMAL(9,2) NOT NULL DEFAULT '0.00' COMMENT 'REGISTRA EL IVA A COBRAR', ".
		    "TOTAL_IVA DECIMAL(9,2) NOT NULL DEFAULT '0.00' COMMENT 'IVA DEL BOLETO', ".
		    "FACTURADO SMALLINT(6) NOT NULL DEFAULT '0', ".
		    "ID_REFERENCIA VARCHAR(25) NULL DEFAULT NULL COMMENT 'REFERENCIA CON LA TABLA DE FACURAS PARA WEB', ".
		    "COPIADO INT(11) NULL DEFAULT '0', ".
	            "FECHA_BOLETO DATE NULL DEFAULT NULL, ".
	            "HORA_BOLETO TIME NULL DEFAULT NULL, ".
	            "TARIFA_REAL DECIMAL(10,2) NULL DEFAULT NULL, ".
	            "HORA_CORRIDA TIME NULL DEFAULT NULL, ".
	            "COMPLEMENTO_1 VARCHAR(50) NULL DEFAULT NULL, ".
	            "COMPLEMENTO_2 VARCHAR(50) NULL DEFAULT NULL, ".
	            "COMPLEMENTO_3 VARCHAR(50) NULL DEFAULT NULL, ".
		    "COMPROBANTE INT DEFAULT 0,".
		    "TIPO_FACTURA VARCHAR(3) DEFAULT NULL, ".
		    "ID_FORMA_PAGO_SUB VARCHAR(5) DEFAULT NULL, ".
		    "PRIMARY KEY (ID_BOLETO, ID_TERMINAL, TRAB_ID), ".
		    "INDEX IDX_PDV_T_BOLETO_3 (FECHA), ".
		    "INDEX IDX_PDV_T_BOLETO (ID_FORMA_PAGO, ID_TAQUILLA, ID_OCUPANTE), ".
		    "INDEX IDX_PDV_T_BOLETO_2 (ID_CORRIDA), ".
		    "INDEX PorBoleto (ID_BOLETO), ".
		    "INDEX PorPromotor (TRAB_ID), ".
		    "INDEX PINPAD (ID_PAGO_PINPAD_BANAMEX), ".
		    "INDEX TERMINAL (ID_TERMINAL), ".
		    "INDEX TC_Index (TC, FECHA_HORA_BOLETO), ".
		    "INDEX IDX_PDV_T_BOLETO_FECHA (FECHA) USING HASH, ".
		    "INDEX FECHA_PAGO (FECHA, ID_FORMA_PAGO) ".
	    	    ") ".
	    	    "COMMENT='ESTUDIANTE, SENECTUD, PROFESOR, MENOR Y NORMAL' ".
	            "COLLATE='latin1_swedish_ci' ".
	            "ENGINE=InnoDB";
	my $sth = $SERVER->prepare( $query );
	$sth->execute();
	$sth->finish();
}


sub existenTablas{
	my @a_anios = @_;
	foreach(@a_anios){
		if(!&existeTablaBoletoAnio($_)){
			&createTableAnio($table_nombre.$_);
		}
	}
}

sub getBoletosVenta{
	my ($fecha, $tabla, $anio) = @_;
	my $tabla = "PDV_T_BOLETO_";
	my $boleto = $tabla;
	my $CveBoleto = undef; 
 	my $CveTerminal = undef; 
	my $CveEmpleado = undef;
	my $f_inicial = $fecha . " 00:00:00";
print $f_inicial ."\n";
	my $f_final   = $fecha . " 23:59:59";
	my $query = "SELECT ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ".
		    "ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX, ".
		    "TC, IVA, TOTAL_IVA, FACTURADO, ID_REFERENCIA, COPIADO, ID_FORMA_PAGO_SUB, ".
		    "FECHA_BOLETO, HORA_BOLETO, TARIFA_REAL, COMPLEMENTO_1, HORA_CORRIDA ".
                    "FROM PDV_T_BOLETO B ".
                    "WHERE COPIADO = 0 AND FECHA_HORA_BOLETO BETWEEN  ? AND ? ORDER BY FECHA_HORA_BOLETO LIMIT 500";
	my $sth = $SERVER->prepare( $query );
	$sth->bind_param(1, $f_inicial);
	$sth->bind_param(2, $f_final);
	$sth->execute();
	if($sth->rows > 0){
		while( (my @outs) = $sth->fetchrow_array() ){
			my $tabla = $tabla . substr($outs[10],0,4);
			my $s_inserta = "INSERT INTO $tabla(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, ".
					"  ID_TAQUILLA, TIPO_TARIFA, FECHA_HORA_BOLETO, ".
					"  ID_CORRIDA, FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ESTATUS_PROCESADO, ID_RUTA, TIPOSERVICIO, ".
				        "  ID_PAGO_PINPAD_BANAMEX, TC, IVA, TOTAL_IVA, FACTURADO, ID_REFERENCIA, COPIADO, ID_FORMA_PAGO_SUB, ".
                                        " FECHA_BOLETO, HORA_BOLETO, TARIFA_REAL, COMPLEMENTO_1, HORA_CORRIDA ) ".
					"VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?, ?,   ?,?,?,?,?)";
			eval{
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
			   $sti->bind_param(27,$outs[26]);
			   $sti->bind_param(28,$outs[27]);
			   $sti->bind_param(29,$outs[28]);
			   $sti->bind_param(30,$outs[29]);
			   $sti->bind_param(31,$outs[30]);
			   $sti->bind_param(32,$outs[31]);
			   $sti->execute();
			}or do{
			    my $u_query = "UPDATE PDV_T_BOLETO SET COPIADO = 1 WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
			    my $sti = $SERVER->prepare( $u_query );
			    $sti->bind_param(1, $outs[0]);
			    $sti->bind_param(2, $outs[1]);
			    $sti->bind_param(3, $outs[2]);
			    $sti->execute();
#print "Paso actualiza   $outs[26] $outs[0]  $outs[1] $outs[2]  $outs[10]  $tabla\n";
			};
print "Paso inserta en la tabla 6   $outs[26] $outs[0]  $outs[1] $outs[2] $outs[10]  $tabla\n";
			my $qry2000 = "SELECT COUNT(*) FROM $tabla WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
		        my $st2000 = $SERVER->prepare( $qry2000 );
			$st2000->bind_param(1, $outs[0]);
			$st2000->bind_param(2, $outs[1]);
			$st2000->bind_param(3, $outs[2]);
			$st2000->execute();
			while(my @existe = $st2000->fetchrow_array()){
			    my $u_query = "UPDATE PDV_T_BOLETO SET COPIADO = 1 WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
			    my $sti = $SERVER->prepare( $u_query );
			    $sti->bind_param(1, $outs[0]);
			    $sti->bind_param(2, $outs[1]);
			    $sti->bind_param(3, $outs[2]);
			    $sti->execute();
			}
		}
	}
	$sth->finish();
}

$SERVER = &conectaServer($base, $host, $user, $pass);
my @a_fechas = &getFechasBoleto();
print join(',', @a_fechas)."\n";
@a_anios_boleto = &getAniosBoleto(@a_fechas); 
#print join(',', @a_anios_boleto);
&existenTablas( @a_anios_boleto );
foreach(@a_fechas){
  	#extraemos la informacion y se inserta  
	&getBoletosVenta($_, $table_nombre, substr($_,0,4) );
}

$SERVER->disconnect();
