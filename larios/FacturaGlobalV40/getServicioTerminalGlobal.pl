#!/usr/bin/perl

use DBI;
use strict;
use Net::Ping;
#Variables
my $S_COORPORATIVO = undef;
my $S_POS = undef;
my $S_FACTURA = undef;
my $d_dbCORPORATIVO = "CORPORATIVO";
my $d_hCORPORATIVO = "192.168.1.13";
#my $d_uCORPORATIVO = "root";
#my $d_pCORPORATIVO = "3st\@b\@M0sB13n\$";

my $d_uCORPORATIVO = "replicacion";
my $d_pCORPORATIVO = "\#\@Vi\@j\@Mor3l0s";

my $d_dbFactura = "FACTURACION";
my $d_hFactura  = "192.168.1.26";
my $d_uFactura  = "root";
my $d_pFactura  = "#R0j0N3no\$";


#Funcion para la conexion a la base de datos
sub conectaServer{
        (my $dbase_db, my $ip_db, my $user_db, my $pass_db) = @_;
	my $port = 3306;
        my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        my $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
        return $dbh;
}

#Funcion que obtiene toda la lista de terminales de venta
sub getTerminales{
   my %h_terminal = undef;
   my $sql = "SELECT BD_USUARIO, BD_PASSWORD, BD_BASEDATOS, IPV4, ID_TERMINAL ".
	     "FROM PDV_C_TERMINAL ".
	     "WHERE ID_TERMINAL NOT IN('SD1','SD2') ".
	     "ORDER BY ID_TERMINAL";
   my $dh_central = $S_COORPORATIVO->prepare( $sql );
   $dh_central->execute();
   while(my @data = $dh_central->fetchrow_array()) {
      $h_terminal{$data[4]} =  \@data;
   }
   return %h_terminal;
}

#Funcion que regresa las taquilla que realizaron venta por punto de esta misma
sub getWhatEmpresa{
   my $terminal = shift;
   my $rfc = undef;
   my $sql = "SELECT EMPRESA FROM T_C_TERMINAL WHERE ID_TERMINAL = ?";
   my $dh = $S_COORPORATIVO->prepare( $sql );
   $dh->bind_param(1, $terminal);
   $dh->execute(); 
   my @data = $dh->fetchrow_array();

   if ($data[0] =~ "TER"){
      $rfc = "TCC591104A74";
   }else{
      $rfc = "APC580909L82";
   }
   return $rfc;
}

#Funcion get Dia actual en formato YYYY-MM-DD
sub getDiaActual{
   my ($segundos, $minutos, $horas,$dia_mes, $mes, $anyo, $dia_semana,undef, undef) = localtime(time());
   $mes++;
   my $dd = $dia_mes < 10 ? '0' . $dia_mes : $dia_mes;
   my $mm = $mes < 10 ? '0' . $mes  : $mes ;
   my $anio = $anyo + 1900;
   return $anio . '-' . $mm . '-' . $dd;
}


#Funcion que regresa el tipo de servicio, terminal 
sub getTipoTerminal{
   my @datos = @_;
   my @out = undef;
   my $idx = 0;
   my $fecha_inicio = $datos[1] . ' 00:00:00';
   my $fecha_fin = $datos[1] . ' 23:59:59';
   my $sql = "SELECT DISTINCT(B.TIPOSERVICIO) ".
	     "FROM PDV_T_BOLETO B ".
	     "WHERE B.ID_TERMINAL = ? AND B.FECHA_HORA_BOLETO BETWEEN ? AND ? AND ESTATUS = 'V'";
   my $db_boleto = $S_POS->prepare($sql);
   $db_boleto->bind_param(1, $datos[0]);
   $db_boleto->bind_param(2, $fecha_inicio);
   $db_boleto->bind_param(3, $fecha_fin);
   $db_boleto->execute(); 
   while(my @valor = $db_boleto->fetchrow_array()){
	$out[$idx] = $valor[0];
  	$idx++;
   }
   return @out;
}

#procedimiento inserta en la factura Global
sub setGlobalFactura{ 
   my @datos = @_;
print join('**', @datos) ."\n";
   my $sql = "INSERT INTO FAC_T_GLOBAL_FACTURA(ID_TERMINAL, FECHA, SERVICIO,EXTRAORDINARIA,  STATUS) ".
	     "VALUES(?, ?, ?, ?, 0) ";
   my $db_factura = $S_FACTURA->prepare($sql);
   $db_factura->bind_param(1, $datos[0]);
   $db_factura->bind_param(2, $datos[1]);
   $db_factura->bind_param(3, $datos[2]);
   $db_factura->bind_param(4, $datos[3]);
   $db_factura->execute();
   $db_factura->finish();
}


#Main
$S_COORPORATIVO = &conectaServer($d_dbCORPORATIVO, $d_hCORPORATIVO, $d_uCORPORATIVO, $d_pCORPORATIVO);
$S_FACTURA = &conectaServer($d_dbFactura, $d_hFactura, $d_uFactura, $d_pFactura);
my $fecha = &getDiaActual();
print("Fecha a buscar es : $fecha  ......\n");
my %h_terminal = &getTerminales();
my $duration = 5;
my $ip = '';
my $ret = undef;
my $p = undef;
foreach my $llave (keys %h_terminal){
  my $user = (@{$h_terminal{$llave}}[0]);
  my $pass = (@{$h_terminal{$llave}}[1]);
  my $bdname = (@{$h_terminal{$llave}}[2]);
  my $db_ip = (@{$h_terminal{$llave}}[3]);
  my $termi = (@{$h_terminal{$llave}}[4]);
  if( length($termi) > 0 ){
        $p = Net::Ping->new("tcp");
        $p->port_number("3306");
        $p->hires();
	($ret, $duration, $ip) = $p->ping($db_ip, 5.5);
	print $termi.' ==> '. $duration ."\n";
	if($ret == 1){
  	   $S_POS = &conectaServer($bdname, $db_ip, $user, $pass);
  	   if(defined $S_POS){
   	      print("Conectado   $termi\n");
	      my @a = &getTipoTerminal($termi, $fecha);		
	      foreach my $servicio (@a){
		   print("el valor : $servicio\n");
	         if($servicio > 0 ){
		    &setGlobalFactura($termi, $fecha, $servicio, 0);
		    if($servicio == 5){
		       &setGlobalFactura($termi, $fecha, $servicio, 1);
		    }
	         }
	      }	
  	   }else{
       		print "Sin conexion $termi    $db_ip\n";
  	   }
	}
  }
}
$S_FACTURA->disconnect;
$S_COORPORATIVO->disconnect;
