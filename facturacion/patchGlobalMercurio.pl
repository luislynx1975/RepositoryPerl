#!/usr/bin/perl

#################################################################################
# Script para la generacion de la factura global de mercurio
#version 1.0
#Fecha 2018-06-13
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
my $d_uFACTURA = "root";
my $d_pFACTURA = "#R0j0N3no\$";
my $S_FACTURA = undef;

############################ C O R P O R A T I V O
my $d_bBOLETO = "CORPORATIVO";
my $d_hBOLETO = "192.168.1.13";
my $d_uBOLETO = "venta";
my $d_pBOLETO = "GbS=aVw0oMoHT8!$6cw!7;b8R3+ella?bCZE";
my $d_portBOLETO = 3306;
my $S_BOLETO = undef;

my $tableName = "PDV_T_BOLETO_";

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
sub subtotalNULL{
    my @out = undef;
    my $sql = "SELECT C.CVE_COMPROBANTE, YEAR(G.FECHA) ".
	      "FROM FAC_T_COMPROBANTE C INNER JOIN FAC_T_STATUS_GLOBAL G ON C.CVE_COMPROBANTE = G.COMPROBANTE ".
	      "WHERE CAST(C.FECHA AS DATE) = CURRENT_DATE() AND C.TIPO_COMPROBANTE = 'G' AND C.SUBTOTAL IS NULL";
    my $db_comprobante = $S_FACTURA->prepare($sql);
    $db_comprobante->execute();
    my $id = 0;
    while(my @data = $db_comprobante->fetchrow_array()){
       @out[$id] = \@data;
       $id++;
    }
    return @out;
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
sub setBoletoComprobante{
    my($comprobante, $anio) = @_;
    my $ld_ttTranslado = 0;
    my $ld_sbTotal = 0;
    my $tableNombre = $tableName . $anio;
    my $sql = "SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, ORIGEN, DESTINO, FECHA_HORA_BOLETO, ".
              "TC, IVA, TOTAL_IVA, TARIFA, (TARIFA - TOTAL_IVA) AS SUBTOTAL ".
              "FROM $tableNombre B ".
              "WHERE COMPROBANTE = ?";
    my $db_boleto = $S_BOLETO->prepare( $sql );
    $db_boleto->bind_param(1, $comprobante);
    $db_boleto->execute();
exit;
    while(my @datos = $db_boleto->fetchrow_array()){#insertamos en la tabla de factura los conceptos
        $sql = "SELECT fCOMPROBANTE_CONCEPTO_INSERTA(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)AS CONCEPTOID ";
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
        $db_factura->bind_param(10, $comprobante);
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
    }
    $ld_ttTranslado = &getTTTranslado($comprobante);#comprobante
    $ld_sbTotal     = &getSubtotal($comprobante);#comprobante
    $sql = 'CALL piMPUESTO_TOTAL_INSERTA(?, ?, ?)';
    my $db_factura = $S_FACTURA->prepare( $sql );
    $db_factura->bind_param(1, 0);
    $db_factura->bind_param(2, $ld_ttTranslado);
    $db_factura->bind_param(3, $comprobante);
    $db_factura->execute();
    $sql = 'UPDATE FAC_T_COMPROBANTE SET SUBTOTAL = ?, TOTAL = ?, PROCESADO_PROFACT = 0, ERROR_PROFACT = ""  WHERE CVE_COMPROBANTE = ?';
    $db_factura = $S_FACTURA->prepare($sql );
    $db_factura->bind_param(1, $ld_sbTotal );
    $db_factura->bind_param(2, $ld_sbTotal + $ld_ttTranslado  );
    $db_factura->bind_param(3, $comprobante);
    $db_factura->execute();

    $db_factura->finish();
    $db_boleto->finish();
}
################################# M A I N ######################################

$S_BOLETO = &conectaServer($d_bBOLETO, $d_hBOLETO, $d_uBOLETO, $d_pBOLETO, $d_portBOLETO ); 
$S_FACTURA = &conectaServer($d_bFACTURA, $d_hFACTURA, $d_uFACTURA, $d_pFACTURA, $d_portFACTURA ); 

my @valor = &subtotalNULL();
foreach my $x (0..@valor -1){
    &setBoletoComprobante($valor[$x][0],$valor[$x][1]);
   print $valor[$x][0]  . "    " . $valor[$x][1] ."\n";
}
$S_BOLETO->disconnect();
$S_FACTURA->disconnect()
