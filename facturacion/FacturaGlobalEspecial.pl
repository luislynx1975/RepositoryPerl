#!/bin/perl 

use strict;
use Time::Local;
use DateTime;
use Net::IP;
use Sys::HostAddr;
use DBI;
use feature qw(switch);


########################### F A C T U R A C I O N
#my $d_bFACTURA = "facturacion";
#my $d_hFACTURA = "192.168.2.203";

my $d_bFACTURA = "FACTURACION";
my $d_hFACTURA = "192.168.1.26";
my $d_portFACTURA = 3306;
my $d_uFACTURA = "root";
my $d_pFACTURA = "#R0j0N3no\$";
#my $d_pFACTURA = "larios";
my $S_FACTURA = undef;

############################ C O R P O R A T I V O
my $d_bBOLETO = "CORPORATIVO";
my $d_hBOLETO = "192.168.1.13";
my $d_uBOLETO = "root";
my $d_pBOLETO = "3st\@b\@M0sB13n\$";
my $d_portBOLETO = 3306;
my $S_BOLETO = undef;

my $tableName = 'PDV_T_BOLETO_';



#Funcion para establecer la conexion con la base de datos
sub conectaServer{
    (my $dbase_db, my $ip_db, my $user_db, my $pass_db, my $port) = @_;
    my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
    my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
    return $dbh;
}
#######################################################################
sub getDias{
    my @out = undef;
    my ($s, $min, $h, $d, $m, $y) = localtime();
    my $year = $y+1900;
    my $mes  = $m + 1;
    $mes = ($mes<10? '0' . $mes : $mes);
    push(@out, $year . '-' . $mes . '-' . '01');
    my $yearAnterior = ($mes eq '01' ? $year-- : $year);
    my $mesAnterior  = ($mes eq '01' ? 12 : $mes - 1);
    $mesAnterior = ($mesAnterior < 10 ? '0' . $mesAnterior : $mesAnterior);
    push(@out, $yearAnterior . '-' . $mesAnterior . '-01' );
    my $fecha = DateTime->last_day_of_month( year => $yearAnterior, month => $mesAnterior )
                            ->add( days => 1 )  ->subtract( seconds => 1 );
    $fecha = substr($fecha,0,10);
    push(@out, $fecha);			    
    return @out;
}
#######################################################################
sub getDiaActual{
    my @out = undef;
    my ($s, $min, $h, $d, $m, $y) = localtime();
    my $year = $y+1900;
    my $mes  = $m + 1;
    $mes = ($mes<10? '0' . $mes : $mes);
    my $dia = ($d<10 ? '0' . $d : $d);
    return $year . '-' . $mes . '-' . $dia;
}

################################################################################
#Funcion para obtener las terminales que faltan en el status
sub getTerminalGlobal{
    my @out = ();
    my $sql = "SELECT DISTINCT(ID_TERMINAL) FROM FAC_C_TAQUILLA_GLOBAL";
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->execute();
    my $idx = 0;
    while(my @data = $db_factura->fetchrow_array()){
        $out[$idx] = $data[0];
        $idx = $idx + 1;
    }
    return @out;
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
              "WHERE CAST(FECHA_HORA_BOLETO AS DATE) between ? AND ? AND ID_TERMINAL = ? AND FACTURADO = 0 AND ESTATUS = 'V'";
    my $db_corpo = $S_BOLETO->prepare($sql);
    $db_corpo->bind_param(1, $valor[0] . ' 00:00:00');
    $db_corpo->bind_param(2, $valor[1] . ' 23:59:59');
    $db_corpo->bind_param(3, $valor[2]);
    $db_corpo->execute();

    while(my @datos = $db_corpo->fetchrow_array()){
        $out[$idx] = $datos[0];
        $idx++;
    }
    $db_corpo->finish();
    return @out;
}

################################################################################
#Funcion que inserta las fechas en base a las terminales previamente registradas con las taquillas
sub setFechaStatus{
    my @parametros = @_;
    if ($parametros[3] > 0){
       my $sql = "INSERT INTO FAC_T_STATUS_GLOBAL(ID_TERMINAL, TAQUILLA,FECHA, ID_SERVICIO, STATUS, COMPROBANTE, MES, ANIO, TIPO_GLOBAL) ".
                 "VALUES(?,?,?,?,0,0,?,?,'M')";
       my $db_central = $S_FACTURA->prepare($sql);
       $db_central->bind_param(1,$parametros[1]);
       $db_central->bind_param(2,$parametros[2]);
       $db_central->bind_param(3,$parametros[0]);
       $db_central->bind_param(4,$parametros[3]);
       $db_central->bind_param(5,$parametros[4]);
       $db_central->bind_param(6,$parametros[5]);
       $db_central->execute();
       $db_central->finish();
    }
}


################################################################################
#funcion que extrae la forma de pago mas utilizada
#$dayLastMes, $lastDayMes, $terminal, $servicio
sub getFormaPagoBoleto{
    my @valor = @_;
    my $forma = 0;
    my $total = 0;
    my %hh = {};
    my $f_inicial = $valor[0] . " 00:00:00";
    my $f_final   = $valor[1] . " 23:59:59";
    my @a_fecha   = split('-', $valor[0]);
    my $tableNombre = $tableName . $a_fecha[0];
    my $sql = "SELECT B.ID_FORMA_PAGO, COUNT(B.ID_FORMA_PAGO)AS TOTAL ".
              "FROM $tableNombre B ".
              "WHERE FECHA_HORA_BOLETO  BETWEEN ? AND ? AND B.FACTURADO = 0 AND ESTATUS = 'V' AND B.ID_TERMINAL = ? AND ".
              " TIPOSERVICIO = ? AND B.FACTURADO = 0 GROUP BY ID_FORMA_PAGO ORDER BY 2 DESC LIMIT 1";
    my $db_boleto = $S_BOLETO->prepare( $sql );
    $db_boleto->bind_param(1, $f_inicial );
    $db_boleto->bind_param(2, $f_final);
    $db_boleto->bind_param(3, $valor[2]);
    $db_boleto->bind_param(4, $valor[3]);
    $db_boleto->execute();
    $forma = 0;
    while(my @datos = $db_boleto->fetchrow_array()){
        $forma = $datos[0];
        $total = $datos[1];
    }
    if(($forma =~ 1) || ($forma =~ 3) || ($forma =~ 4) || ($forma =~ 5) || ($forma =~ 6) || ($forma =~ 7) ||
        ($forma =~ 9) || ($forma =~ 10) || ($forma =~ 11) || ($forma =~ 12) || ($forma =~ 13) || ($forma =~ 14)){
        $forma = '01';
    }
    if(($forma =~2) || ($forma =~ 8)){
        $forma = '04';
    }
    $db_boleto->finish();
    return $forma;
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
#funcion que regresa la ip del equipo
sub getIP{
    my $sysaddr = Sys::HostAddr->new();
    my $ip = $sysaddr->first_ip();
    return $ip;
}

################################################################################
#Funcion para insertar el comprobante
sub getComprobante{
    my @datos = @_;
    my $RFC = &getRFCEmisor($datos[2]);
    my $empresa = &getRFCEmpresa($RFC);
    my $out = '';
    my $str_PUBLICO = 'XAXX010101000';
    my $str_NOMBRE_PUBLICO = 'PUBLICO EN GENERAL';
    my $sql = "SELECT fCOMPROBANTE_INSERTA(?, ?, ?, ?, ?,".    #5
                                          "?, ? ,? ,?, ? ,? ,?, ".   #7
                                          "?, ?, ?, ?, ?, ?, ".      #6
                                          "?, ?, ?, ?, ?, ?, ?, ".   #7
                                          "?, ?, ?, ?, ?, ?)AS COMPROBANTE ";
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param(1, 3);      #aplicacion
    $db_factura->bind_param(2, '3.3');  #version
    $db_factura->bind_param(3, 'G');    #serie
    $db_factura->bind_param(4, $datos[0]);#Forma de Pago
    $db_factura->bind_param(5, ''); #condiciones de Pago
    $db_factura->bind_param(6, 0); #subtotal
    $db_factura->bind_param(7, 0); #descuento
    $db_factura->bind_param(8, 'MXN'); #moneda
    $db_factura->bind_param(9, 0.0); #tipo de cambio
    $db_factura->bind_param(10, 0); #total
    $db_factura->bind_param(11, 'I'); #Tipo de comprobante
    $db_factura->bind_param(12, 'PUE'); #Metodo de Pago
    $db_factura->bind_param(13, '04250' ); #lugar de expedicion
    $db_factura->bind_param(14, ''); #confirmacion
    $db_factura->bind_param(15, $RFC);
    $db_factura->bind_param(16, $empresa); #Nombre emisor
    $db_factura->bind_param(17, 624); #emisor Regimen
    $db_factura->bind_param(18, '019969');  #usuario
    $db_factura->bind_param(19, 1); #region
    $db_factura->bind_param(20, 'P01'); #usoCFDI
    $db_factura->bind_param(21, &getIP()); #IP
    $db_factura->bind_param(22, $str_PUBLICO); #receotri RFC
    $db_factura->bind_param(23, $str_NOMBRE_PUBLICO); #receptor nombre
    $db_factura->bind_param(24, ''); #receptor Fiscal
    $db_factura->bind_param(25, ''); #recpetor Num Reg Trib
    $db_factura->bind_param(26, &getEmailGlobal($datos[1])); #email
    $db_factura->bind_param(27, 'GLOBAL'); #referencia
    $db_factura->bind_param(28, 10); #procesado profact
    $db_factura->bind_param(29, 'FA'); #referencia profact
    $db_factura->bind_param(30, 0); #status_profact
    $db_factura->bind_param(31, 'G'); #tipo comprobante
    $db_factura->execute();
    while(my @datos = $db_factura->fetchrow_array()){
        $out = $datos[0];
    }
    $db_factura->finish();
    return $out;
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

sub getMes{
    my $dato = shift;
    my @aFecha = split(/-/, $dato);
    my $valor = int($aFecha[1]);
    my $out = undef;
    given($valor){
	when(1) { $out = "Enero"; }
	when(2) { $out = "Febrero"; }
	when(3) { $out = "Marzo"; }
	when(4) { $out = "Abril"; }
	when(5) { $out = "Mayo"; }
	when(6) { $out = "Junio"; }
	when(7) { $out = "Julio"; }
	when(8) { $out = "Agosto"; }
	when(9) { $out = "Septiembre"; }
	when(10) { $out = "Octubre"; }
	when(11) { $out = "Noviembre"; }
	when(12) { $out = "Diciembre"; }
    }
    return $out;
}


################################################################################
#funcion que extrae los datos de la tabla de boletos por anio
#$dayLastMes, $lasDayMes, $terminal, $idComprobante, $servicio);
sub getBoletosAnio{
    my @valor = @_;
    my $f_inicial = $valor[0] . " 00:00:00";
    my $mesCadena = &getMes($valor[0]);
    my $f_final   = $valor[1] . " 23:59:59";
    my @a_fecha   = split('-', $valor[0]);
    my $tableNombre = $tableName . $a_fecha[0];
    my $ld_ttTranslado = 0;
    my $ld_sbTotal     = 0;
    my $sql = "SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, ORIGEN, DESTINO, FECHA_HORA_BOLETO, ".
              "TC, IVA, TOTAL_IVA, TARIFA, (TARIFA - TOTAL_IVA) AS SUBTOTAL ".
              "FROM $tableNombre B ".
              "WHERE FECHA_HORA_BOLETO  BETWEEN ? AND ? AND B.FACTURADO = 0 AND ESTATUS = 'V' AND B.ID_TERMINAL = ? AND ".
              " B.FACTURADO = 0 AND TARIFA > 0 AND TIPOSERVICIO = ?";
    my $db_boleto = $S_BOLETO->prepare( $sql );
    $db_boleto->bind_param(1, $f_inicial );
    $db_boleto->bind_param(2, $f_final);
    $db_boleto->bind_param(3, $valor[2]);
    $db_boleto->bind_param(4, $valor[4]);
    $db_boleto->execute();
    while(my @datos = $db_boleto->fetchrow_array()){#insertamos en la tabla de factura los conceptos
        $sql = "SELECT fCOMPROBANTE_CONCEPTO_INSERTA(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)AS CONCEPTOID ";
        my $db_factura = $S_FACTURA->prepare($sql);
        $db_factura->bind_param(1, '01010101');
        $db_factura->bind_param(2, $datos[0].$datos[1].$datos[2] );
        $db_factura->bind_param(3, 1);
        $db_factura->bind_param(4, 'ACT');
        $db_factura->bind_param(5, ''); #unidad
        $db_factura->bind_param(6, 'Venta del mes de : ' . $mesCadena . ', emitido en : ' . $datos[1] . ', Fecha : ' .$datos[5]);
        $db_factura->bind_param(7, $datos[10]);
        $db_factura->bind_param(8, $datos[10]);
        $db_factura->bind_param(9, 0);
        $db_factura->bind_param(10, $valor[3]);
        $db_factura->execute();
        my @concepto = $db_factura->fetchrow_array();
        ###################Insertamos en la tabla de translado
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
        my $sql = "UPDATE $tableNombre SET COMPROBANTE = ?, TIPO_FACTURA = ?, FACTURADO = 1 ".
                  "WHERE ID_BOLETO = ? AND ID_TERMINAL = ? AND TRAB_ID = ?";
        my $db_corpo = $S_BOLETO->prepare( $sql );
        $db_corpo->bind_param(1, $valor[3]);
        $db_corpo->bind_param(2, 'G');
        $db_corpo->bind_param(3,  $datos[0]);
        $db_corpo->bind_param(4,  $datos[1]);
        $db_corpo->bind_param(5,  $datos[2]);
        $db_corpo->execute();
    }
################Insertamos en la tabla de translados el iva del boleto
    $ld_ttTranslado = &getTTTranslado($valor[3]);#comprobante
    $ld_sbTotal     = &getSubtotal($valor[3]);#comprobante
    $sql = 'CALL piMPUESTO_TOTAL_INSERTA(?, ?, ?)';
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param(1, 0);
    $db_factura->bind_param(2, $ld_ttTranslado);
    $db_factura->bind_param(3, $valor[3]);
    $db_factura->execute();
    if($ld_sbTotal > 0){
    	$sql = 'UPDATE FAC_T_COMPROBANTE SET SUBTOTAL = ?, TOTAL = ?, PROCESADO_PROFACT = 0, ERROR_PROFACT = ""  WHERE CVE_COMPROBANTE = ? ';
    	$db_factura = $S_FACTURA->prepare($sql );
    	$db_factura->bind_param(1, $ld_sbTotal );
    	$db_factura->bind_param(2, $ld_sbTotal + $ld_ttTranslado  );
    	$db_factura->bind_param(3, $valor[3]);
    	$db_factura->execute();
    }
    $sql = 'UPDATE FAC_T_STATUS_GLOBAL SET COMPROBANTE = ?, STATUS = 1 WHERE ID_TERMINAL = ? AND FECHA = ? AND ID_SERVICIO = ?';
    $db_factura = $S_FACTURA->prepare($sql);
    $db_factura->bind_param(1, $valor[3]);
    $db_factura->bind_param(2, $valor[2]);
    $db_factura->bind_param(3, $valor[0]);
    $db_factura->bind_param(4, $valor[4]);
    $db_factura->execute();
    $db_factura->finish();
    $db_boleto->finish();
}

sub getMesAnio(){
   my @fecha = split(/-/,shift);
   my @meses = ('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio',
                 'Agosto','Septiembre','Octubre','Noviembre','Diciembre'); 
   return $meses[int($fecha[1]) -1];
}


############################################  M A I N #################
my @aDias = &getDias();#1 primeriMesActual 2 Primer Dia Mes anterior 3 Dia ultimo del mes anterior 
print "Aqui va todo\n";
print join('--', @aDias) . "\n";
my $mesGlobal = &getMesAnio($aDias[2]);
my @anioGlobal = split(/-/,$aDias[2]);
my $dayMes = $aDias[1];
my $dayLastMes = $aDias[2];
my $lastDayMes  = $aDias[3];
my $diaActual = &getDiaActual();
my $contador = 1;
if ($dayMes eq $diaActual){
   #procesamos los datos en esta parte
   $S_BOLETO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO );
   $S_FACTURA = &conectaServer($d_bFACTURA, $d_hFACTURA, $d_uFACTURA, $d_pFACTURA, $d_portFACTURA );
print "Conectado a servers :  $d_hBOLETO  $d_hFACTURA \n";
   for my $terminal ( &getTerminalGlobal() ){
	for my $servicio ( &getServicioTaquilla( $dayLastMes, $lastDayMes, $terminal )  ){
print "$dayLastMes, $lastDayMes, $terminal  $mesGlobal, $anioGlobal[0]  \n";
	    &setFechaStatus($dayLastMes, $terminal, 9999, $servicio, $mesGlobal, $anioGlobal[0]);
            my $formaPago = &getFormaPagoBoleto($dayLastMes, $lastDayMes, $terminal, $servicio);
            if($formaPago != 0){
	    print "$terminal  $servicio :::::::::::::::::   $contador\n";
                my $idComprobante = &getComprobante($formaPago, $terminal, $servicio);
                &getBoletosAnio($dayLastMes, $lastDayMes, $terminal, $idComprobante, $servicio);
            }
	    print "Contador : $contador \n";
            $contador = $contador + 1;	
        }
   }
}
