#!/usr/bin/perl
#################################################################################
# Script para la generacion de la factura global de mercurio DIARIA
#version 1.0
#Fecha 2022-05-17
#Autor Larios Rodriguez Jose Luis
#################################################################################

use DBI;
use strict;
use Net::IP;
use Sys::HostAddr;

########################### F A C T U R A C I O N
my $d_bFACTURA = "FACTURACION";
my $d_hFACTURA = "192.168.1.26";
# my $d_hFACTURA = "192.168.1.15";
my $d_portFACTURA = 3306;
my $d_uFACTURA = "fact";
my $d_pFACTURA = "E141136ce\!\?kes\-AR\*";
my $S_FACTURA = undef;

############################ C O R P O R A T I V O
my $d_bBOLETO = "CORPORATIVO";
my $d_hBOLETO = "192.168.1.13";
#my $d_uBOLETO = "venta";
#my $d_pBOLETO = "GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE";

my $d_uBOLETO = "replicacion";
my $d_pBOLETO = "\#\@Vi\@j\@Mor3l0s";

my $d_portBOLETO = 3306;
my $S_BOLETO = undef;
my $formaPago = undef;
################################################################################
my $tableName = "PDV_T_BOLETO_";
################################################################################
#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}
################################################################################
#Funcion para obtener las terminales que faltan en el status
sub getTerminalGlobal{
    my @out = ();
    my $sql = "SELECT DISTINCT(ID_TERMINAL),TAQUILLA FROM FAC_C_TAQUILLA_GLOBAL ".
	      "WHERE ID_TERMINAL NOT IN ('SD1', 'SD2')"; 
#	      "WHERE ID_TERMINAL IN ('CCS')";
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->execute();
    my $idx = 0;
    while(my @data = $db_factura->fetchrow_array()){
	$out[$idx] = \@data;
	$idx = $idx + 1;
    }
    return @out;
}

################################################################################
#Funcion que regresa la fechas definidas por rango de fechas
sub getFechas{
   my $dato = shift;
   my @valor = ();
   my $sql = "select * from  ".
             "(select adddate('1970-01-01',t4.i*10000 + t3.i*1000 + t2.i*100 + t1.i*10 + t0.i) fechas from ".
             " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union ".
             "select 6 union select 7 union select 8 union select 9) t0, ".
             " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union ".
             "select 6 union select 7 union select 8 union select 9) t1, ".
             " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union ".
             "select 6 union select 7 union select 8 union select 9) t2, ".
             " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union ".
             "select 6 union select 7 union select 8 union select 9) t3, ".
             " (select 0 i union select 1 union select 2 union select 3 union select 4 union select 5 union ".
             "select 6 union select 7 union select 8 union select 9) t4) v ".
             "where fechas between (SELECT SUBDATE(CURRENT_DATE(),INTERVAL (SELECT VALOR + " . $dato . " FROM FAC_C_PARAMETRO ".
              "WHERE ID_PARAMETRO = 11) DAY)) and CURRENT_DATE() LIMIT 1";
    my $db_central = $S_FACTURA->prepare( $sql );
    $db_central->execute();
    while(my @data = $db_central->fetchrow_array()){
	push(@valor, $data[0]);
    }
    $db_central->finish();
    return @valor;
}

################################################################################
#Funcion que inserta las fechas en base a las terminales previamente registradas con las taquillas
sub setFechaStatus{
    my @parametros = @_;
    if ($parametros[3] > 0){
	  my $sql = "SELECT COUNT(*) AS TOTAL FROM FAC_T_STATUS_GLOBAL ".
		    "WHERE ID_TERMINAL = ? AND TAQUILLA = ? AND FECHA = ? AND ID_SERVICIO = ?";
	  my $db_valida = $S_FACTURA->prepare( $sql );
          $db_valida->bind_param(1,$parametros[1]);
          $db_valida->bind_param(2,$parametros[2]);
          $db_valida->bind_param(3,$parametros[0]);
          $db_valida->bind_param(4,$parametros[3]);
	  $db_valida->execute();
	  my @data = $db_valida->fetchrow_array();
	  if($data[0] =~ 0){
             eval{
                my $sql = "INSERT INTO FAC_T_STATUS_GLOBAL(ID_TERMINAL, TAQUILLA,FECHA, ID_SERVICIO, STATUS, COMPROBANTE) ".
	                  "VALUES(?,?,?,?,0,0)";
                my $db_central = $S_FACTURA->prepare($sql);
                $db_central->bind_param(1,$parametros[1]);
                $db_central->bind_param(2,$parametros[2]);
                $db_central->bind_param(3,$parametros[0]);
                $db_central->bind_param(4,$parametros[3]);
                $db_central->execute();
                $db_central->finish(); 
	      }or do {
		      my $error = $@ || 'Ya existe en la tabla';
        	      warn "Could not parse  $error";
	      };
	}
    }
}

################################################################################
#funcion para obtener la fecha de la tabla de status global que corresponde
sub getFechaGlobalTerminal{
    my @valor = @_;
    my $fecha = undef;
    my $sql = "SELECT FECHA ".
	      "FROM FAC_T_STATUS_GLOBAL ".
	      "WHERE ID_TERMINAL = ? AND TAQUILLA = ? AND FECHA = ".
	      "(SELECT SUBDATE(CURRENT_DATE(), INTERVAL (SELECT VALOR + " . $valor[2] . " FROM FAC_C_PARAMETRO WHERE ID_PARAMETRO = 11) DAY)) AND STATUS = 0 ".
	      "LIMIT 1";
    my $db_central = $S_FACTURA->prepare( $sql );
    $db_central->bind_param(1, $valor[0]);
    $db_central->bind_param(2, $valor[1]);
    $db_central->execute();
    while(my @data = $db_central->fetchrow_array()){
	$fecha = $data[0];
    }
    $db_central->finish();
    return $fecha;
}

################################################################################
sub getSubtotal{
    my $comprobante = shift;
    my $sql = "SELECT SUM(C.IMPORTE) FROM FAC_T_CONCEPTO_COMPROBANTE C ".
	      "WHERE C.CVE_COMPROBANTE = ?";
    my $db_translado = $S_FACTURA->prepare( $sql );
    $db_translado->bind_param(1, $comprobante );
    $db_translado->execute();
    while(my @data = $db_translado->fetchrow_array()){
	return $data[0];
    }
    $db_translado->finish();
}

################################################################################
sub getTTTranslado{
    my $comprobante = shift;
    my $sql = "SELECT COALESCE(SUM(T.IMPORTE),0) ".
	      "FROM FAC_T_CONCEPTO_COMPROBANTE C INNER JOIN FAC_T_CONCEPTO_TRASLADO T ON T.ID_CVEPROD = C.ID_CVEPROD ".
	      "WHERE C.CVE_COMPROBANTE = ?";
    my $db_concepto = $S_FACTURA->prepare( $sql );
    $db_concepto->bind_param(1, $comprobante);
    $db_concepto->execute();
    while(my @data = $db_concepto->fetchrow_array()){
	return $data[0]; 
    }
    $db_concepto->finish();
}

################################################################################
#funcion que verificar si se tiene boletos para generar  la factura
sub getExistenBoletos{
    my @valor = @_;
    my $f_inicial = $valor[1] . " 00:00:00";
    my $f_final   = $valor[1] . " 23:59:59";
    my $tableNombre = $tableName . $valor[0];
    my $facturar = 0;
    my $sql = "SELECT COUNT(*)AS TOTAL ".
	      "FROM $tableNombre B ".
	      "WHERE FECHA_HORA_BOLETO  BETWEEN ? AND ? AND ESTATUS = 'V' AND B.ID_TERMINAL = ? AND ".
	      "B.ID_TAQUILLA = ? AND B.FACTURADO = ? AND TARIFA > 0 AND TIPOSERVICIO = ?";
    my $db_boleto = $S_BOLETO->prepare( $sql );
    $db_boleto->bind_param(1, $f_inicial );
    $db_boleto->bind_param(2, $f_final);
    $db_boleto->bind_param(3, $valor[2]);
    $db_boleto->bind_param(4, $valor[3]);
    $db_boleto->bind_param(5, $facturar);
    $db_boleto->bind_param(6, $valor[4]);
    $db_boleto->execute();
    my @datos = $db_boleto->fetchrow_array();
    $db_boleto->finish();
    return $datos[0];
}


################################################################################
#funcion que extrae los datos de la tabla de boletos por anio
sub getBoletosAnio{
    my @valor = @_;
    my $f_inicial = $valor[1] . " 00:00:00";
    my $f_final   = $valor[1] . " 23:59:59";
    my $tableNombre = $tableName . $valor[0];
    my $ld_ttTranslado = 0;
    my $ld_sbTotal     = 0;
    my $Objeto  = "01";
    my $facturar = 0;
    my $sql = "SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, ORIGEN, DESTINO, FECHA_HORA_BOLETO, ".
	      "TC, IVA, TOTAL_IVA, TARIFA, (TARIFA - TOTAL_IVA) AS SUBTOTAL ".
	      "FROM $tableNombre B ".
	      "WHERE FECHA_HORA_BOLETO  BETWEEN ? AND ? AND ESTATUS = 'V' AND B.ID_TERMINAL = ? AND ".
	      "B.ID_TAQUILLA = ? AND B.FACTURADO = ? AND TARIFA > 0 AND TIPOSERVICIO = ?";
    my $db_boleto = $S_BOLETO->prepare( $sql );
    $db_boleto->bind_param(1, $f_inicial );
    $db_boleto->bind_param(2, $f_final);
    $db_boleto->bind_param(3, $valor[2]);
    $db_boleto->bind_param(4, $valor[3]);
    $db_boleto->bind_param(5, $facturar);
    $db_boleto->bind_param(6, $valor[5]);
    $db_boleto->execute();
    while(my @datos = $db_boleto->fetchrow_array()){#insertamos en la tabla de factura los conceptos
	if($datos[7] > 0){
	   $Objeto = "02"; 
	}else{
	   $Objeto = "01";
	}
	$sql = "SELECT fCOMPROBANTE_CONCEPTO_INSERTA_V40(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)AS CONCEPTOID ";
	my $db_factura = $S_FACTURA->prepare($sql);
	$db_factura->bind_param(1, '01010101');
	$db_factura->bind_param(2, $datos[0].$datos[1].$datos[2] );
	$db_factura->bind_param(3, 1);
	$db_factura->bind_param(4, 'ACT');
	$db_factura->bind_param(5, ''); #unidad
	$db_factura->bind_param(6, 'Venta');
	$db_factura->bind_param(7, $datos[10]);
	$db_factura->bind_param(8, $datos[10]);
	$db_factura->bind_param(9, 0);
	$db_factura->bind_param(10, $valor[4]);
	$db_factura->bind_param(11, $Objeto);
	$db_factura->execute();
	my @concepto = $db_factura->fetchrow_array();
	###################Insertamos en la tabla de translado
print("  $datos[0]  $datos[1]  $datos[2]    Estos valores se insertan :   $datos[8]   002  Tasa  0.160000  $datos[8]   $concepto[0] $Objeto   $valor[2]\n");
	if($datos[8] > 0){#antes 10
	    $sql = 'CALL pCONCEPTO_TRASLADO_INSERTA(?, ?, ?, ?, ?, ?)';
	    $db_factura = $S_FACTURA->prepare( $sql );
	    $db_factura->bind_param(1, $datos[10]);
	    $db_factura->bind_param(2, '002');
	    $db_factura->bind_param(3, 'Tasa');
	    $db_factura->bind_param(4, 0.160000);
	    $db_factura->bind_param(5, $datos[8]);
	    $db_factura->bind_param(6, $concepto[0]);
	    $db_factura->execute();
	    $ld_ttTranslado = $ld_ttTranslado + $datos[8];
	    $ld_sbTotal    = $ld_sbTotal     + $datos[10];
	}
	#####Aactualizamos la tabla de boleto con el comprobante y tipo_factura = G
        if($valor[4] > 0){
	    my $sql = "UPDATE $tableNombre SET COMPROBANTE = ?, TIPO_FACTURA = ?, FACTURADO = 1 ".
		      "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
	    my $db_corpo = $S_BOLETO->prepare( $sql );
    	    $db_corpo->bind_param(1, $valor[4]);
	    $db_corpo->bind_param(2, 'G');
	    $db_corpo->bind_param(3,  $datos[0]);
	    $db_corpo->bind_param(4,  $datos[1]);
	    $db_corpo->bind_param(5,  $datos[2]);
	    $db_corpo->execute();
	}
    }
################Insertamos en la tabla de translados el iva del boleto
    $ld_ttTranslado = &getTTTranslado($valor[4]);#comprobante
    $ld_sbTotal     = &getSubtotal($valor[4]);#comprobante
    $sql = 'CALL piMPUESTO_TOTAL_INSERTA(?, ?, ?)';
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param(1, 0);
    $db_factura->bind_param(2, $ld_ttTranslado);
    $db_factura->bind_param(3, $valor[4]);
    $db_factura->execute();

    $sql = 'UPDATE FAC_T_COMPROBANTE SET SUBTOTAL = ?, TOTAL = ?, PROCESADO_PROFACT = 0, ERROR_PROFACT = ""  WHERE CVE_COMPROBANTE = ?';
    $db_factura = $S_FACTURA->prepare($sql );
    $db_factura->bind_param(1, $ld_sbTotal );
    $db_factura->bind_param(2, $ld_sbTotal + $ld_ttTranslado  );
    $db_factura->bind_param(3, $valor[4]);
    $db_factura->execute();
    $sql = 'UPDATE FAC_T_STATUS_GLOBAL SET COMPROBANTE = ?, STATUS = 1 WHERE ID_TERMINAL = ? and TAQUILLA = ? AND FECHA = ? AND ID_SERVICIO = ?';
    $db_factura = $S_FACTURA->prepare($sql);
    $db_factura->bind_param(1, $valor[4]);
    $db_factura->bind_param(2, $valor[2]);
    $db_factura->bind_param(3, $valor[3]);
    $db_factura->bind_param(4, $valor[1]);
    $db_factura->bind_param(5, $valor[5]);
    $db_factura->execute();
    $db_factura->finish();
    $db_boleto->finish();
}

################################################################################
#funcion que extrae la forma de pago mas utilizada
sub getFormaPagoBoleto{
    my @valor = @_;
    my $forma = 0;
    my $total = 0;
    my %hh = {};
    my $f_inicial = $valor[1] . " 00:00:00";
    my $f_final   = $valor[1] . " 23:59:59";
    my $tableNombre = $tableName . $valor[0];
    my $facturar = 0; 
    my $sql = "SELECT B.ID_FORMA_PAGO, COUNT(B.ID_FORMA_PAGO)AS TOTAL ".
	      "FROM $tableNombre B ".
	      "WHERE FECHA_HORA_BOLETO  BETWEEN ? AND ? AND ESTATUS = 'V' AND B.ID_TERMINAL = ? AND ".
	      "B.ID_TAQUILLA = ? AND TIPOSERVICIO = ? AND B.FACTURADO = ? GROUP BY ID_FORMA_PAGO ORDER BY 2 DESC LIMIT 1";
    my $db_boleto = $S_BOLETO->prepare( $sql );
    $db_boleto->bind_param(1, $f_inicial );
    $db_boleto->bind_param(2, $f_final);
    $db_boleto->bind_param(3, $valor[2]);
    $db_boleto->bind_param(4, $valor[3]);
    $db_boleto->bind_param(5, $valor[4]);
    $db_boleto->bind_param(6, $facturar);
    $db_boleto->execute();
    $forma = 0;
    while(my @datos = $db_boleto->fetchrow_array()){
	$forma = $datos[0];
	$total = $datos[1];
    }
    #if(($forma =~ 1) || ($forma =~ 3) || ($forma =~ 4) || ($forma =~ 5) || ($forma =~ 6) || ($forma =~ 7) ||
#$forma =~ 9) || ($forma =~ 10) || ($forma =~ 11) || ($forma =~ 12) || ($forma =~ 13) || ($forma =~ 14)){
#forma = '01';
#  }*/
    $forma = '01';
    if(($forma =~2) || ($forma =~ 8)){
	$forma = '04';
    }
    $db_boleto->finish();
    return $forma;
}

################################################################################
#funcion que regresa la ip del equipo
sub getIP{
    my $sysaddr = Sys::HostAddr->new();
    my $ip = $sysaddr->first_ip();
    return $ip;
}
################################################################################
#funcion para obtener RFC DEL EMISOR
sub getEmisorGlobal{
    my $terminal = shift;
    my $out = undef;
    my $sql = "SELECT ID_GRUPO FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL = ?";
    my $db_corpo = $S_BOLETO->prepare($sql);
    $db_corpo->bind_param(1, $terminal);
    $db_corpo->execute();
    while(my @data = $db_corpo->fetchrow_array()){
	$out = $data[0];	
    }
    if($out eq 'TER'){
	$out = 'TCC591104A74';
    }
    if($out eq 'PUL'){
	$out = 'APC580909L82';
    }
    $db_corpo->finish();
    return $out;
}

################################################################################
sub getEmailGlobal{
    my $terminal = shift;
    my $out = undef;
    my $sql = "SELECT ID_GRUPO FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL = ?";
    my $db_corpo = $S_BOLETO->prepare($sql);
    $db_corpo->bind_param(1, $terminal);
    $db_corpo->execute();
    while(my @data = $db_corpo->fetchrow_array()){
	    $out = $data[0];	
    }
    if($out eq 'TER'){
	    $out = 'facturaglobalter@gmail.com';
    }
    if($out eq 'PUL'){
	    $out = 'facturaglobalpullman@pullman.com';
    }
    $db_corpo->finish();
    return $out;
}

################################################################################
sub getRFCEmisor{
   my $servicio = shift;
   my $sql = "SELECT RFC_FACTURA FROM SERVICIOS WHERE TIPOSERVICIO = ?";
   my $db_corpo = $S_BOLETO->prepare( $sql );
   $db_corpo->bind_param(1, $servicio);
   $db_corpo->execute();
   while(my @data = $db_corpo->fetchrow_array()){
	return $data[0];
   }
   $db_corpo->finish();
}
################################################################################
sub getRFCEmpresa{
   my $rfc = shift;
   my $sql = "SELECT RAZON_SOCIAL FROM FAC_C_EMPRESA WHERE RFC = ?";
   my $db_empresa = $S_FACTURA->prepare( $sql); 
   $db_empresa->bind_param(1, $rfc);
   $db_empresa->execute();
   while(my @data = $db_empresa->fetchrow_array()){
	return $data[0];
   }
   $db_empresa->finish();
}

################################################################################
sub getMesAnio{
	my $sql = "SELECT  YEAR(SUBDATE(CURRENT_DATE(), INTERVAL 1 DAY))AS ANIO, LPAD(MONTH(SUBDATE(CURRENT_DATE(), INTERVAL 1 DAY)),'2','0')AS MES";
	my $db_periodo = $S_FACTURA->prepare( $sql );
	$db_periodo->execute();
	my @data = $db_periodo->fetchrow_array() ;
    	$db_periodo->finish();
	return @data;
}

################################################################################
#Funcion para insertar el comprobante
sub getComprobanteV40{
    my @datos = @_;
    my @globalPeriodo = &getMesAnio();
    my $RFC = &getRFCEmisor($datos[2]);
    my $empresa = &getRFCEmpresa($RFC);
    my $out = '';
    my $str_PUBLICO = 'XAXX010101000';  
    my $str_NOMBRE_PUBLICO = 'PUBLICO EN GENERAL';
    my $cve;
    my $estatus;
    my $outClave; 
    my $outEstatus;
    my $estatus;
    my $sql = "CALL pCOMPROBANTE_INSERTA_V40(?, ?, ?, ?, ?, ". #5
                                            "?, ?, ?, ?, ?, ". #10
                                            "?, ?, ?, ?, ?, ". #15
                                            "?, ?, ?, ?, ?, ". #20
                                            "?, ?, ?, ?, ?, ". #25
					    "?, ?, ?, ?, ?, ". #30
					    "?, \@outClave, \@outEstatus ) ";

    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param(1, 3);          #aplicacion
    $db_factura->bind_param(2, $datos[0]);  #forma de pago
    $db_factura->bind_param(3, '');         #condiciones de pago 
    $db_factura->bind_param(4, 0);          #subtotal
    $db_factura->bind_param(5, 0);          #descuento
    $db_factura->bind_param(6, 'MXN');      #moneda
    $db_factura->bind_param(7, 0.0);        #tipo de cambio
    $db_factura->bind_param(8, 0);          #total 
    $db_factura->bind_param(9, 'I');        #tipo comprobante
    $db_factura->bind_param(10, 'PUE');     #Metodo de pago
    $db_factura->bind_param(11, '04250');   #lugar expedicion
    $db_factura->bind_param(12, '');        #confirmacion
    $db_factura->bind_param(13, $RFC);      #rfc emisor
    $db_factura->bind_param(14, '019969');  #usuario
    $db_factura->bind_param(15, &getIP());  #IP
    $db_factura->bind_param(16, $str_PUBLICO); #receptor rfc 
    $db_factura->bind_param(17, $str_NOMBRE_PUBLICO); #receptor nombre 
    $db_factura->bind_param(18, '04250');   #domicilio fiscal
    $db_factura->bind_param(19, '');        #receptor fiscal
    $db_factura->bind_param(20, '');        #receptor num reg trib
    $db_factura->bind_param(21, 'S01');     #usoCfdi
    $db_factura->bind_param(22, 616);       #receptor regimen
    $db_factura->bind_param(23, &getEmailGlobal($datos[1])); #email
    $db_factura->bind_param(24,  'DIARIA');       #referencia
    $db_factura->bind_param(25,  'FA');     #profact referencia   FACTURA
    $db_factura->bind_param(26, 'G');       #tipoGlobal
    $db_factura->bind_param(27, '01');      #periodicidad
    $db_factura->bind_param(28, $globalPeriodo[1]);      #mes
    $db_factura->bind_param(29, $globalPeriodo[0]);      #anio
    $db_factura->bind_param(30, 1);      #region
    $db_factura->bind_param(31, '01');      #region
    $db_factura->execute();

    my $query = "SELECT \@outClave, \@outEstatus ";
    $db_factura = $S_FACTURA->prepare( $query );
    $db_factura->execute();
    my @datos = $db_factura->fetchrow_array();
    return $datos[0];
    $db_factura->finish();
}

####################################################################
sub getServicioTaquilla{
    my @valor = @_;
    my @out = undef;
    my $idx = 0;
    my @a_fecha = split('-', $valor[0]);
    my $name_table =  $tableName  . $a_fecha[0];
    my $sql = "SELECT DISTINCT(TIPOSERVICIO) ".
	      "FROM $name_table  ".
      	      "WHERE CAST(FECHA_HORA_BOLETO AS DATE) = ? AND ID_TERMINAL = ? AND ID_TAQUILLA = ?";
    my $db_corpo = $S_BOLETO->prepare($sql);	
    $db_corpo->bind_param(1, $valor[0]);
    $db_corpo->bind_param(2, $valor[1]);
    $db_corpo->bind_param(3, $valor[2]);
    $db_corpo->execute();
    while(my @datos = $db_corpo->fetchrow_array()){
	$out[$idx] = $datos[0];
	$idx++;
    }
    $db_corpo->finish();
    return @out;
}

################################# M A I N ###################################
$S_BOLETO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
$S_FACTURA = &conectaServer($d_bFACTURA, $d_hFACTURA, $d_uFACTURA, $d_pFACTURA, $d_portFACTURA ); 
my $valorParametro = 0;
if (defined $S_FACTURA){
    my @valor = &getTerminalGlobal();# obtenemos terminal, taquilla de FAC_C_TAQUILLA_GLOBAL
    foreach my $x (0..@valor -1){
	my $terminal = $valor[$x][0];
	my $taquilla = $valor[$x][1];
	foreach my $dia  (&getFechas($valorParametro))  {
	   foreach my $servicio( &getServicioTaquilla($dia, $terminal, $taquilla)){
	        &setFechaStatus($dia, $terminal, $taquilla, $servicio);
	        my $fecha = &getFechaGlobalTerminal($terminal, $taquilla, $valorParametro);
	        my @a_fecha = split('-', $fecha);
		if(length($a_fecha[0]) > 1){
print("Procesando el dia $dia  $terminal   $taquilla\n");
		   $formaPago = &getFormaPagoBoleto($a_fecha[0], $fecha, $terminal, $taquilla,$servicio);
		   if(&getExistenBoletos($a_fecha[0], $fecha, $terminal, $taquilla, $servicio) > 0) {
	    	     my $idComprobante = &getComprobanteV40($formaPago, $terminal, $servicio);
	    	      &getBoletosAnio($a_fecha[0], $fecha, $terminal, $taquilla, $idComprobante, $servicio);
		   }#fin getExisten
		}
	   }
       }
    }
}
$S_BOLETO->disconnect();
$S_FACTURA->disconnect()
