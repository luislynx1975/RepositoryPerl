#!/usr/bin/perl
#################################################################################
# Script para la generacion de la factura global de mercurio MENSUAL
#version 1.0
#Fecha 2022-05-17
#Fecha Modificacion 2023-01-24
#Modificacion se modifica para realizar la factura al ser por terminal, dia y servicio
#se incluye la descripcion en el concepto esta se mejora de la version anterior
#Autor Larios Rodriguez Jose Luis
#################################################################################

use DBI;
use strict;
use Net::IP;
use Sys::HostAddr;

########################### F A C T U R A C I O N
my $d_bFACTURA = "FACTURACION";
my $d_hFACTURA = "192.168.1.26";
my $d_portFACTURA = 3306;
my $d_uFACTURA = "fact";
my $d_pFACTURA = "E141136ce\!\?kes\-AR\*";
my $S_FACTURA = undef;

############################ C O R P O R A T I V O
my $d_bBOLETO = "CORPORATIVO";
my $d_hBOLETO = "192.168.1.13";

my $d_uBOLETO = "replicacion";
my $d_pBOLETO = "\#\@Vi\@j\@Mor3l0s";

my $d_portBOLETO = 3306;
my $S_BOLETO = undef;
my $formaPago = undef;
my $NUM_ROWS = 7000;
my $idComprobante = 0;
################################################################################
my $tableName = "PDV_T_BOLETO_";
############my $tableName = "FEBRERO_";
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
	      "WHERE ID_TERMINAL NOT IN ('SD1','SD2') AND RFC in ('APC580909L82','TCC591104A74')";
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
             "where fechas between (SELECT SUBDATE(CURRENT_DATE(),INTERVAL (SELECT VALOR FROM FAC_C_PARAMETRO ".
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
sub getBoletosTMP{## terminal, comprobante, servicio, totalBoletos año extraordinario
    my @valor = @_;
    my $tableNombre = $tableName . $valor[4];
    my $comprobanteID = $valor[1];
    my $Objeto  = "02";
    my $facturar = 0;
    my $tasa = "";
    my $iva  = 0.0;
    my $sql = undef;
    my $db_boleto = undef;
    my $des_concepto = undef;
    my $totalBoletos = 0;
    my $listComprobante = '';
    if( $valor[2] != 5){
    	$sql = "SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, ORIGEN, DESTINO, FECHA_HORA_BOLETO, ".
	      	"TC, IVA * 1/100, TOTAL_IVA, TARIFA, (TARIFA - TOTAL_IVA) AS SUBTOTAL, FECHA_BOLETO ".
	      	"FROM TMP_BOLETO B ".
	      	"WHERE ESTATUS = 'V' AND B.ID_TERMINAL = ? AND TARIFA > 0 AND TIPOSERVICIO = ? ";
    	$db_boleto = $S_BOLETO->prepare( $sql );
    	$db_boleto->bind_param(1, $valor[0]);
    	$db_boleto->bind_param(2, $valor[2]);
        $db_boleto->execute();
    }

    if( $valor[2] == 5){
	if($valor[5] == 0){
	    $iva = 16.0;
        }
	if($valor[5] == 1){
	    $iva = 0.0;
	}
    	$sql = "SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, ORIGEN, DESTINO, FECHA_HORA_BOLETO, ".
	       "TC, IVA * 1/100, TOTAL_IVA, TARIFA, (TARIFA - TOTAL_IVA) AS SUBTOTAL, FECHA_BOLETO ".
	       "FROM TMP_BOLETO B ".
	       "WHERE ESTATUS = 'V' AND B.ID_TERMINAL = ? AND TARIFA > 0 AND TIPOSERVICIO = ? AND IVA = ?";
    	$db_boleto = $S_BOLETO->prepare( $sql );
    	$db_boleto->bind_param(1, $valor[0]);
    	$db_boleto->bind_param(2, $valor[2]);
    	$db_boleto->bind_param(3, $iva);
        $db_boleto->execute();
    }
    while(my @datos = $db_boleto->fetchrow_array()){#insertamos en la tabla de factura los conceptos
	$totalBoletos++; 
        $des_concepto = "Venta de boleto en la Terminal : $datos[1] Origen : $datos[3], Destino : $datos[4] Dia : $datos[11] Costo Total : $datos[9] ". 
			&getMesTerminalDescripcion($valor[7]) ;	        

	$sql = "SELECT fCOMPROBANTE_CONCEPTO_INSERTA_V40(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)AS CONCEPTOID ";
	my $db_factura = $S_FACTURA->prepare($sql);
	$db_factura->bind_param(1, '01010101');
	$db_factura->bind_param(2, $datos[0].'-'.$datos[1].'-'.$datos[2] );
	$db_factura->bind_param(3, 1);
	$db_factura->bind_param(4, 'ACT');
	$db_factura->bind_param(5, ''); #unidad
	$db_factura->bind_param(6, $des_concepto);
	$db_factura->bind_param(7, $datos[10]);
	$db_factura->bind_param(8, $datos[10]);
	$db_factura->bind_param(9, 0);
	$db_factura->bind_param(10, $comprobanteID);#comprobante
	$db_factura->bind_param(11, $Objeto);
	$db_factura->execute();
	my @concepto = $db_factura->fetchrow_array();
###################Insertamos en la tabla de translado
	if($datos[7] > 0){
	   $tasa = "Tasa";
	   $iva  = $datos[7];
	}else{
	   $tasa = "Exento";
	   $iva  = 0.0;
	}
	$sql = 'CALL pCONCEPTO_TRASLADO_INSERTA(?, ?, ?, ?, ?, ?)';
	$db_factura = $S_FACTURA->prepare( $sql );
	$db_factura->bind_param(1, $datos[10]);
	$db_factura->bind_param(2, '002');
	$db_factura->bind_param(3, $tasa);
	$db_factura->bind_param(4, $iva);
	$db_factura->bind_param(5, $datos[8]);
	$db_factura->bind_param(6, $concepto[0]);
	$db_factura->execute();
	#####Aactualizamos la tabla de boleto con el comprobante y tipo_factura = G
    }
################Insertamos en la tabla de translados el iva del boleto
    my $ld_ttTranslado = &getTTTranslado($comprobanteID );#comprobante
    my $ld_sbTotal     = &getSubtotal($comprobanteID );#comprobante
    $sql = 'CALL piMPUESTO_TOTAL_INSERTA(?, ?, ?)';
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param(1, 0);
    $db_factura->bind_param(2, $ld_ttTranslado);
    $db_factura->bind_param(3, $valor[1]);
    $db_factura->execute();
    $sql = "UPDATE FAC_T_COMPROBANTE SET SUBTOTAL = ?, TOTAL = ?, PROCESADO_PROFACT = 10, ERROR_PROFACT = ''  WHERE CVE_COMPROBANTE = ?";
    $db_factura = $S_FACTURA->prepare($sql );
    $db_factura->bind_param(1, $ld_sbTotal );
    $db_factura->bind_param(2, $ld_sbTotal + $ld_ttTranslado  );
    $db_factura->bind_param(3, $comprobanteID );
    $db_factura->execute();
    my @a_anio = split('-', $valor[6]);

    $sql = "SELECT COMPROBANTE ".
	   "FROM FAC_T_GLOBAL_MENSUAL ".
	   "WHERE TERMINAL = ? AND INICIO = ? AND FIN = ? AND SERVICIO = ? AND EXTRAORDINARIO = ? ";
    $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param( 1, $valor[0] );
    $db_factura->bind_param( 2, $valor[6] );
    $db_factura->bind_param( 3, $valor[7] );
    $db_factura->bind_param( 4, $valor[2] );
    $db_factura->bind_param( 5, $valor[5] );
    $db_factura->execute();
    my @outs = $db_factura->fetchrow_array();
    if( $outs[0] > 0){ 
       $listComprobante = $outs[0] . ',' . $comprobanteID; 
    }else{
       $listComprobante = $comprobanteID;
    }
print("$listComprobante\n");

    $sql = "UPDATE FAC_T_GLOBAL_MENSUAL  SET ESTATUS = 1, PERTENECE = ?, ANIO = ?,  COMPROBANTE = ? ".
	   "WHERE TERMINAL = ?  AND SERVICIO = ? AND EXTRAORDINARIO  = ? AND INICIO = ? AND FIN = ? ";
    $db_factura = $S_FACTURA->prepare($sql);
    $db_factura->bind_param(1, &getNameMes($valor[6]) ); #pertenece
    $db_factura->bind_param(2, $a_anio[0]); #anio
    $db_factura->bind_param(3, $listComprobante); #$comprobanteID );  #comprobante
    $db_factura->bind_param(4, $valor[0] ); #terminal
    $db_factura->bind_param(5, $valor[2] ); #servicio
    $db_factura->bind_param(6, $valor[5] ); #extraordinaria
    $db_factura->bind_param(7, $valor[6] ); #inicio
    $db_factura->bind_param(8, $valor[7] ); #fin
    $db_factura->execute();
    $db_factura->finish();
    $db_boleto->finish();
}


################################################################################
#funcion que extrae los datos de la tabla de boletos por anio
sub getBoletosAnio{#año, fecha, terminal, comprobante, servicio, extraordinario fechaFin
    my @valor = @_;
    my $f_inicial = $valor[1] . " 00:00:00";
    my $f_final   = $valor[6] . " 23:59:59";
    my $tableNombre = $tableName . $valor[0];
    my $Objeto  = "02";
    my $facturar = 0;
    my $tasa = "";
    my $iva  = 0.0;
    my $sql = undef;
    my $db_boleto = undef;
    my $des_concepto = undef;
    my $totalBoletos = 0;
    if( $valor[4] != 5){
    	$sql = "SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, ORIGEN, DESTINO, FECHA_HORA_BOLETO, ".
	      	"TC, IVA * 1/100, TOTAL_IVA, TARIFA, (TARIFA - TOTAL_IVA) AS SUBTOTAL, FECHA_BOLETO ".
	      	"FROM $tableNombre B ".
	      	"WHERE ESTATUS = 'V' AND B.ID_TERMINAL = ? AND TARIFA > 0 AND TIPOSERVICIO = ? AND ".
	      	" COMPLEMENTO_2 = 'FEBRERO'"; 
    	$db_boleto = $S_BOLETO->prepare( $sql );
    	$db_boleto->bind_param(1, $valor[2]);
    	$db_boleto->bind_param(2, $valor[4]);
        $db_boleto->execute();
    }

    if( $valor[4] == 5){
	if($valor[5] == 0){
	    $iva = 16.0;
        }else{
	    $iva = 0.0;
	}
    	$sql = "SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, ORIGEN, DESTINO, FECHA_HORA_BOLETO, ".
	       "TC, IVA * 1/100, TOTAL_IVA, TARIFA, (TARIFA - TOTAL_IVA) AS SUBTOTAL, FECHA_BOLETO ".
	       "FROM $tableNombre B ".
	       "WHERE ESTATUS = 'V' AND B.ID_TERMINAL = ? AND TARIFA > 0 AND TIPOSERVICIO = ? AND  ".
	       "  IVA = ? AND COMPLEMENTO_2 = 'FEBRERO' ";
    	$db_boleto = $S_BOLETO->prepare( $sql );
    	$db_boleto->bind_param(1, $valor[2]);
    	$db_boleto->bind_param(2, $valor[4]);
    	$db_boleto->bind_param(3, $iva);
        $db_boleto->execute();
    }
    while(my @datos = $db_boleto->fetchrow_array()){#insertamos en la tabla de factura los conceptos
	$totalBoletos++; 
        $des_concepto = "Venta de boleto en la Terminal : $datos[1] Origen : $datos[3], Destino : $datos[4] Dia : $datos[11] Costo Total : $datos[9] ". 
			&getMesTerminalDescripcion($valor[1]) ;	        
	$sql = "SELECT fCOMPROBANTE_CONCEPTO_INSERTA_V40(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)AS CONCEPTOID ";
	my $db_factura = $S_FACTURA->prepare($sql);
	$db_factura->bind_param(1, '01010101');
	$db_factura->bind_param(2, $datos[0].'-'.$datos[1].'-'.$datos[2] );
	$db_factura->bind_param(3, 1);
	$db_factura->bind_param(4, 'ACT');
	$db_factura->bind_param(5, ''); #unidad
	$db_factura->bind_param(6, $des_concepto);
	$db_factura->bind_param(7, $datos[10]);
	$db_factura->bind_param(8, $datos[10]);
	$db_factura->bind_param(9, 0);
	$db_factura->bind_param(10, $valor[3]);
	$db_factura->bind_param(11, $Objeto);
	$db_factura->execute();
	my @concepto = $db_factura->fetchrow_array();
###################Insertamos en la tabla de translado
	if($datos[7] > 0){
	   $tasa = "Tasa";
	   $iva  = $datos[7];
	}else{
	   $tasa = "Exento";
	   $iva  = 0.0;
	}
	$sql = 'CALL pCONCEPTO_TRASLADO_INSERTA(?, ?, ?, ?, ?, ?)';
	$db_factura = $S_FACTURA->prepare( $sql );
	$db_factura->bind_param(1, $datos[10]);
	$db_factura->bind_param(2, '002');
	$db_factura->bind_param(3, $tasa);
	$db_factura->bind_param(4, $iva);
	$db_factura->bind_param(5, $datos[8]);
	$db_factura->bind_param(6, $concepto[0]);
	$db_factura->execute();
	#####Aactualizamos la tabla de boleto con el comprobante y tipo_factura = G
	my $sql = "UPDATE $tableNombre SET COMPROBANTE = ?, TIPO_FACTURA = ?, FACTURADO = 1,  COMPLEMENTO_2 = 'FACTURADO MES FEBRERO'  ".
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
    my $ld_ttTranslado = &getTTTranslado($valor[3]);#comprobante
    my $ld_sbTotal     = &getSubtotal($valor[3]);#comprobante
    $sql = 'CALL piMPUESTO_TOTAL_INSERTA(?, ?, ?)';
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param(1, 0);
    $db_factura->bind_param(2, $ld_ttTranslado);
    $db_factura->bind_param(3, $valor[3]);
    $db_factura->execute();
    $sql = "UPDATE FAC_T_COMPROBANTE SET SUBTOTAL = ?, TOTAL = ?, PROCESADO_PROFACT = 0, ERROR_PROFACT = ''  WHERE CVE_COMPROBANTE = ?";
    $db_factura = $S_FACTURA->prepare($sql );
    $db_factura->bind_param(1, $ld_sbTotal );
    $db_factura->bind_param(2, $ld_sbTotal + $ld_ttTranslado  );
    $db_factura->bind_param(3, $valor[3]);
    $db_factura->execute();
#print("getBoletosAnio parametros : $ld_sbTotal   $ld_ttTranslado   $valor[3]\n");
    my @a_anio = split('-', $valor[1]);
    $sql = "UPDATE FAC_T_GLOBAL_MENSUAL  SET ESTATUS = 1, PERTENECE = ?, ANIO = ?, COMPROBANTE = ? ".
	   "WHERE TERMINAL = ?  AND SERVICIO = ? AND EXTRAORDINARIO  = ? AND INICIO = ? AND FIN = ? ";
    $db_factura = $S_FACTURA->prepare($sql);
    $db_factura->bind_param(1, &getNameMes($valor[1]) ); #pertenece
    $db_factura->bind_param(2, $a_anio[0]); #anio
    $db_factura->bind_param(3, $valor[3]);  #comprobante
    $db_factura->bind_param(4, $valor[2]); #terminal
    $db_factura->bind_param(5, $valor[4]); #servicio
    $db_factura->bind_param(6, $valor[5]); #extraordinaria
    $db_factura->bind_param(7, $valor[1]); #inicio
    $db_factura->bind_param(8, $valor[6]); #fin
    $db_factura->execute();

    $db_factura->finish();
    $db_boleto->finish();
}

################################################################################
sub getNameMes{
   my $dia = shift;
   my $sqlQry = "SELECT MONTHNAME(?)";
   my $db_factura = $S_FACTURA->prepare( $sqlQry );
   $db_factura->bind_param(1, $dia);
   $db_factura->execute();
   while(my @meses = $db_factura->fetchrow_array() ){
	return $meses[0];
   }
}


################################################################################
#funcion que extrae la forma de pago mas utilizada
#fechaInicio terminal servicio extraordinario fechaFinal
sub getFormaPagoBoleto{#fechaInicio terminal servicio extraordinario fechaFinal
    my @valor = @_;
    my @anio = split('-', $valor[0]);
    my $forma = 0;
    my $total = 0;
    my $f_inicial = $valor[0] . " 00:00:00";
    my $f_final   = $valor[4] . " 23:59:59";
    my $tableNombre = $tableName . $anio[0];
    my $facturar = 0; 
    my $valorIva = 0;
    my $db_boleto = undef;
    my $sql = '';
    if($valor[2] == 5){
	if($valor[3] == 0){
	   $valorIva = 16.0;	
	}
    	my $sql = "SELECT B.ID_FORMA_PAGO, COUNT(B.ID_FORMA_PAGO)AS TOTAL ".
	      	"FROM $tableNombre B ".
	      	"WHERE FECHA_HORA_BOLETO BETWEEN ? AND ? AND ESTATUS = 'V' AND B.ID_TERMINAL = ? AND ".
	      	" TIPOSERVICIO = ? AND IVA = ? GROUP BY ID_FORMA_PAGO ORDER BY 1 DESC LIMIT 1";
    	$db_boleto = $S_BOLETO->prepare( $sql );
    	$db_boleto->bind_param(1, $f_inicial );
    	$db_boleto->bind_param(2, $f_final);
    	$db_boleto->bind_param(3, $valor[1]);
    	$db_boleto->bind_param(4, $valor[2]);
    	$db_boleto->bind_param(5, $valorIva);
        $db_boleto->execute();
    }else{#procesamos la informacion de forma normal
    	my $sql = "SELECT B.ID_FORMA_PAGO, COUNT(B.ID_FORMA_PAGO)AS TOTAL ".
	      	"FROM $tableNombre B ".
	      	"WHERE FECHA_HORA_BOLETO BETWEEN ? AND ? AND ESTATUS = 'V' AND B.ID_TERMINAL = ? AND ".
	      	" TIPOSERVICIO = ? GROUP BY ID_FORMA_PAGO ORDER BY 1 DESC LIMIT 1";
    	$db_boleto = $S_BOLETO->prepare( $sql );
    	$db_boleto->bind_param(1, $f_inicial );
    	$db_boleto->bind_param(2, $f_final);
    	$db_boleto->bind_param(3, $valor[1]);
    	$db_boleto->bind_param(4, $valor[2]);
        $db_boleto->execute();
    }
    $forma = 0;
    while(my @datos = $db_boleto->fetchrow_array()){
	$forma = $datos[0];
	$total = $datos[1];
    }
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
   my @datos = @_;
   my $outRFC = '';
   my $sql = "SELECT S.RFC_FACTURA ".
	     "FROM SERVICIOS S INNER JOIN PDV_C_GRUPO_SERVICIOS G ON G.ID_GRUPO = S.ID_GRUPO ".
	     "WHERE S.TIPOSERVICIO = ? AND ID_TERMINAL = ?";
   my $db_corpo = $S_BOLETO->prepare( $sql );
   $db_corpo->bind_param(1, $datos[1]);
   $db_corpo->bind_param(2, $datos[0]);
   $db_corpo->execute();
   while(my @data = $db_corpo->fetchrow_array()){
	$outRFC = $data[0];
   }
   if(length($outRFC) == 0){
      $sql = "SELECT RFC_FACTURA ".
             "FROM SERVICIOS ".
	     "WHERE TIPOSERVICIO = ? ";
      $db_corpo = $S_BOLETO->prepare( $sql );
      $db_corpo->bind_param(1, $datos[1]);
      $db_corpo->execute();
      while( my @data = $db_corpo->fetchrow_array()){
         $outRFC = $data[0];
      }
   }
   $db_corpo->finish();
   return $outRFC;
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
sub getComprobanteV40{# formaPago,terminal,TipoServicio,ExtraOdinario
    my @datos = @_;
    my @globalPeriodo = &getMesAnio();
    my $RFC = &getRFCEmisor($datos[1], $datos[2]);#terminal, servicio
    if(  ($RFC =~ 'APM6701103KA') && ($datos[3] =~ 1)){
	$RFC = 'APC580909L82';
    }
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
    $db_factura->bind_param(24,  'MENSUAL ENE');       #referencia
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
print("Error en el comprobante $datos[1]\n");
    return $datos[0];
    $db_factura->finish();
}

####################################################################
sub getStatusGlobal{
    my $anio = shift;
    my @out = ();
    my $idx = 0;
    my $tableNombre = $tableName . $anio;
    my $sql = "SELECT  DISTINCT(e.ID_TERMINAL), e.TIPOSERVICIO, COUNT(*) ".
	      "FROM $tableNombre e ". 
	      "WHERE e.COMPLEMENTO_2 = 'FEBRERO'  AND TARIFA > 0 AND ESTATUS = 'V' ".
	      "GROUP by 2, 1  ".
	      "UNION  ".
	      "SELECT  DISTINCT(e.ID_TERMINAL), e.TIPOSERVICIO, COUNT(*) ".
	      "FROM $tableNombre e  ". 
	      "WHERE e.COMPLEMENTO_2 = 'FEBRERO'  AND e.ID_TERMINAL IN ('WEB','MOV') AND TARIFA > 0 AND ESTATUS = 'V' ".
	      "GROUP by 2, 1 ".
	      "ORDER BY 1"; 
    my $db_status = $S_BOLETO->prepare($sql);
    $db_status->execute();
    while(my @data = $db_status->fetchrow_array() ){
	$out[$idx] = \@data;
	$idx++;
    }
    return @out; 
}

####################################################################
sub setMesMensual{
    my @out = @_;   
    my $sql = "INSERT INTO FAC_T_GLOBAL_MENSUAL(TERMINAL, INICIO, FIN, SERVICIO, EXTRAORDINARIO, BOLETOS_TOTAL, ESTATUS) ".
	      "VALUES(?, ?, ?, ?, ? , ?, 0)";
    my $db_fac = $S_FACTURA->prepare( $sql );
    $db_fac->bind_param(1, $out[0]);
    $db_fac->bind_param(2, $out[1]);
    $db_fac->bind_param(3, $out[2]);
    $db_fac->bind_param(4, $out[3]);
    $db_fac->bind_param(5, $out[4]);
    $db_fac->bind_param(6, $out[5]);
    $db_fac->execute();
}

####################################################################
sub getBoletoServicio5{
    my @datos = @_;
    my $tableNombre = $tableName . $datos[4];
    my $sql = '';
    my $db_boleto = undef;
    my $iva = undef;
    if($datos[5] != 5){
       $sql = "SELECT COUNT(*) ".
	      "FROM $tableNombre e ".
	      "WHERE  e.FECHA_HORA_BOLETO BETWEEN ? AND ?  ".
	      "AND e.TIPOSERVICIO = ? AND id_terminal = ? AND e.COMPLEMENTO_2 = 'FEBRERO' AND TARIFA > 0";
       $db_boleto = $S_BOLETO->prepare( $sql );
       $db_boleto->bind_param(1, $datos[1]);
       $db_boleto->bind_param(2, $datos[2]);
       $db_boleto->bind_param(3, $datos[5]);
       $db_boleto->bind_param(4, $datos[0]);
       $db_boleto->execute();
#print("Se esta ejecutando aqui  \n  $sql \n $datos[1] $datos[2] $datos[5] $datos[0]    ");
    }
    if($datos[5] == 5){
       if($datos[3] == 0){
	  $iva = 16;
       }else{
          $iva = 0;
       }
       $sql = "SELECT COUNT(*) ".
	      "FROM $tableNombre e ".
	      "WHERE  e.FECHA_HORA_BOLETO BETWEEN ? AND ?  ".
	      "AND e.TIPOSERVICIO = ? AND id_terminal = ? AND e.IVA = ? AND e.COMPLEMENTO_2 = 'FEBRERO' AND TARIFA > 0 ";
       $db_boleto = $S_BOLETO->prepare( $sql );
       $db_boleto->bind_param(1, $datos[1]);
       $db_boleto->bind_param(2, $datos[2]);
       $db_boleto->bind_param(3, $datos[5]);
       $db_boleto->bind_param(4, $datos[0]);
       $db_boleto->bind_param(5, $iva);
       $db_boleto->execute();
#print("Se esta ejecutando aqui el servicio es 5\n  $sql \n$datos[1] $datos[2] $datos[5] $datos[0]    ");
    }
    my @out = $db_boleto->fetchrow_array();
#print("\nValor se salida es : $out[0]\n");
    return $out[0];
}

####################################################################
sub getGlobalMensual{
    my @datos = @_;
    my $idx = 0;
    my @out = ();
    my $sql = "SELECT TERMINAL, INICIO, FIN, SERVICIO, BOLETOS_TOTAL, EXTRAORDINARIO, YEAR(INICIO)AS ANIO ".
	      "FROM FAC_T_GLOBAL_MENSUAL ".
	      "WHERE ESTATUS = 0 AND INICIO = '$datos[0]' AND FIN = '$datos[1]' ";
	      "ORDER BY EXTRAORDINARIO ";
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->execute();
    while( my @data = $db_factura->fetchrow_array()){
	$out[$idx] = \@data;
	$idx++;
    }
    return @out;
}


#WHERE  e.FECHA_HORA_BOLETO BETWEEN '2022-05-01 00:00:00' AND '2022-05-31 23:59:59' 
#AND e.TIPOSERVICIO = 2 AND id_terminal = 'MEX' AND e.COMPLEMENTO_2 = 'FEBRERO' 
####################################################################
sub insertTmpBoleto7000{
    my @datos = @_;
    my $tableNombre = $tableName . $datos[4];
    my $sql = "DELETE FROM TMP_BOLETO";
    my $db_corpo = $S_BOLETO->prepare( $sql );
    $db_corpo->execute();
    $sql = "INSERT INTO TMP_BOLETO ".
	   "SELECT * ".
	   "FROM $tableNombre e  ".
	   "WHERE e.TIPOSERVICIO = ? AND id_terminal = ? AND e.COMPLEMENTO_2 = 'FEBRERO' AND ESTATUS = 'V' ".
	   "LIMIT 7000";
    $db_corpo = $S_BOLETO->prepare( $sql );
    $db_corpo->bind_param(1, $datos[2]);
    $db_corpo->bind_param(2, $datos[3]);
    $db_corpo->execute();
}

####################################################################
sub getFormaTMP{
    my $sql = "SELECT DISTINCT(B.ID_FORMA_PAGO), COUNT(*) ".
	      "FROM TMP_BOLETO B ".
	      "GROUP BY 1 ".
	      "ORDER BY 2 DESC ".
	      "LIMIT 1";
    my $db_corpo = $S_BOLETO->prepare( $sql );
    $db_corpo->execute();
    my $forma = 0;
    while(my @datos = $db_corpo->fetchrow_array()){
	$forma = $datos[0];
	my $total = $datos[1];
    }
    $forma = '01';
    if(($forma =~2) || ($forma =~ 8)){
	$forma = '04';
    }
    $db_corpo->finish();
    return $forma;
}

####################################################################
sub cambiaMesComplemento{# año terminal servicio extraordinario
    my @datos = @_;
    my $iva = 0;
    my $tableNombre = $tableName . shift;
    my $sql = "UPDATE $tableNombre e INNER JOIN TMP_BOLETO t ON t.ID_BOLETO = e.ID_BOLETO AND t.ID_TERMINAL = e.ID_TERMINAL AND t.TRAB_ID = e.TRAB_ID ".
	      "SET e.COMPLEMENTO_2 = 'FACTURADO MES FEBRERO'";
    my $db_corpo = $S_BOLETO->prepare( $sql );
    $db_corpo->execute();
}

#############################################################################
sub setTimbra{
   my $id = shift;
   my $sql = "CALL pCOMPROBANTE_TIMBRA( ? )";
   my $db_factura = $S_FACTURA->prepare( $sql );
   $db_factura->bind_param(1, $id);
print("Cambiando estataus.......... $id\n");
   #$db_factura->execute();
   $db_factura->finish();
}


#############################################################################
sub getMesTerminalDescripcion{
   my $datos = shift;
   my @meses = ('ENE','FEB','MAR','ABR','MAY','JUN','JUL','AGO','SEP','OCT','NOV','DIC');
   my @a_valor = split(/-/, $datos);
   my $x = int($a_valor[1]) - 1;
   return " $meses[$x]-$a_valor[0]";
}

################################# M A I N ###################################
my( $inicioSemana, $finSemana ) = @ARGV;
if (not defined $inicioSemana){
  die "Ingrese el dia inicial de la semana\n";
}
if (not defined $finSemana){
  die "Ingrese el dia final de la semana\n";
}
my $bol5ConIva = 0;
$S_BOLETO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
$S_FACTURA = &conectaServer($d_bFACTURA, $d_hFACTURA, $d_uFACTURA, $d_pFACTURA, $d_portFACTURA ); 
my @a_fecha = split(/-/,$inicioSemana);
my @aGblFact = getStatusGlobal($a_fecha[0]);
print("Aqui voy\n");
for my $idx (0..@aGblFact -1){
     if($aGblFact[$idx][1] != 5){
	$bol5ConIva = &getBoletoServicio5( $aGblFact[$idx][0], $inicioSemana . ' 00:00:00',
					   $finSemana . ' 23:59:59', 0, $a_fecha[0], $aGblFact[$idx][1] );	
     }else{
	$bol5ConIva = &getBoletoServicio5( $aGblFact[$idx][0], $inicioSemana . ' 00:00:00',
					   $finSemana . ' 23:59:59', 0, $a_fecha[0], $aGblFact[$idx][1] );	
     }
     if($bol5ConIva > 0){
        &setMesMensual($aGblFact[$idx][0], $inicioSemana, $finSemana, $aGblFact[$idx][1], 0, $bol5ConIva);
     }
     if($aGblFact[$idx][1] == 5){

	$bol5ConIva = &getBoletoServicio5( $aGblFact[$idx][0], $inicioSemana . ' 00:00:00',
					   $finSemana . ' 23:59:59', 1, $a_fecha[0], $aGblFact[$idx][1] );	
	if($bol5ConIva > 0){
            &setMesMensual($aGblFact[$idx][0], $inicioSemana, $finSemana, $aGblFact[$idx][1], 1, $bol5ConIva);
	}
     }
}#fin for
print("$inicioSemana, $finSemana");
my @global = &getGlobalMensual($inicioSemana, $finSemana);
print join('**', @global). "\n";
my $numFactura = 1;
for my $idx (0..@global -1){
   if($global[$idx][4] > $NUM_ROWS ){
      my $cuantos = int($global[$idx][4] / $NUM_ROWS) + 1;
      while($numFactura <= $cuantos){
	my $x = $global[$idx][4] -  ($NUM_ROWS * $numFactura) ;
	&insertTmpBoleto7000($global[$idx][1] . ' 00:00:00', $global[$idx][2] . ' 23:59:59', $global[$idx][3], $global[$idx][0], $global[$idx][6] );
        $formaPago = &getFormaTMP();
        $idComprobante = &getComprobanteV40($formaPago, $global[$idx][0], $global[$idx][3]);# formaPago,terminal,TipoServicio,ExtraOdinario
	print("Numero $numFactura cunatos : $cuantos  Boletos : $x  comprobante : $idComprobante   $global[$idx][0] \n");
        &getBoletosTMP( $global[$idx][0], $idComprobante, $global[$idx][3], $global[$idx][4], 
		        substr( $global[$idx][1], 0, 4), $global[$idx][5], $global[$idx][1], $global[$idx][2] );# terminal, comprobante, servicio, totalBoletos año extraordinario inicio final
        &cambiaMesComplemento( substr( $global[$idx][1], 0, 4 ), $global[$idx][0], $global[$idx][3], $global[$idx][5] ); # año terminal servicio extraordinario
#        &setTimbra($idComprobante);
        $numFactura++;
	sleep(25);
	print("Pause\n");
      }
   }else{
     print(".... $global[$idx][0] $global[$idx][1] $global[$idx][2] $global[$idx][3] $global[$idx][4] $NUM_ROWS\n"); 
        $formaPago = &getFormaPagoBoleto($global[$idx][1], $global[$idx][0], $global[$idx][3], $global[$idx][5],  $global[$idx][2]);  #fechaInicio terminal servicio extraordinario fechaFinal
        $idComprobante = &getComprobanteV40($formaPago, $global[$idx][0], $global[$idx][3], $global[$idx][5]);  # formaPago,terminal,TipoServicio,ExtraOdinario
print("Comprobante : $idComprobante\n");
        my @a_fecha = split('-', $global[$idx][1] );
        &getBoletosAnio($a_fecha[0], $global[$idx][1], $global[$idx][0], $idComprobante, $global[$idx][3], $global[$idx][5], $global[$idx][2]);#año, fecha, terminal, comprobante, servicio, extraordinario fechaFinal
#     	&setTimbra($idComprobante);
   }
}
$S_BOLETO->disconnect();
$S_FACTURA->disconnect();
