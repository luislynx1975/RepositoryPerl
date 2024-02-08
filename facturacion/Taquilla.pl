#!/usr/bin/perl

use DBI;
use strict;
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
sub getTaquillas{
    my $lugar = shift;
    my @arreglo = ();
    my $sql = "SELECT DISTINCT(ID_TAQUILLA), ID_TERMINAL FROM PDV_T_BOLETO ".
	      "WHERE ID_TERMINAL = ? AND ID_TAQUILLA IS NOT NULL AND FECHA_HORA_BOLETO > '2018-09-01 00:00:00' ORDER BY 1";
    my $dh_remoto = $S_POS->prepare($sql);
    $dh_remoto->bind_param(1, $lugar);
    $dh_remoto->execute();
    my $idx = 0;
    while(my @data = $dh_remoto->fetchrow_array()){
	$arreglo[$idx] = $data[0];	
	$idx= $idx + 1;
    }
    return @arreglo;
}

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


#Funcion para insertar en la tabla las terminales detectadas
sub setTaquilla{
   (my $terminal, my $taq ) = @_;
   my $empresa = &getWhatEmpresa( $terminal);
   my $sql = "INSERT INTO FAC_C_TAQUILLA_GLOBAL(ID_TERMINAL, TAQUILLA, RFC) ".
   	         "VALUES(?, ?, ?)";	
   my $dh = $S_FACTURA->prepare( $sql );
   $dh->bind_param(1, $terminal);
   $dh->bind_param(2, $taq);
   $dh->bind_param(3, $empresa);
   $dh->execute();
}

#Main
$S_COORPORATIVO = &conectaServer($d_dbCORPORATIVO, $d_hCORPORATIVO, $d_uCORPORATIVO, $d_pCORPORATIVO);

$S_FACTURA = &conectaServer($d_dbFactura, $d_hFactura, $d_uFactura, $d_pFactura);
if(defined $S_FACTURA){
  print "Conectado S_FACTURA.... $ d_hFactura \n";
}else{
  print "N se conecto al servicor S_FACTURA $d_hFactura\n";
}
my %h_terminal = &getTerminales();
foreach my $llave (keys %h_terminal){
  my $user = (@{$h_terminal{$llave}}[0]);
  my $pass = (@{$h_terminal{$llave}}[1]);
  my $bdname = (@{$h_terminal{$llave}}[2]);
  my $db_ip = (@{$h_terminal{$llave}}[3]);
  my $termi = (@{$h_terminal{$llave}}[4]);
  $S_POS = &conectaServer($bdname, $db_ip, $user, $pass);
  if(defined $S_POS){
     my @a_taquilla = &getTaquillas($termi);
     my $cuantos = @a_taquilla;
    print $cuantos . "......\n";
    print join(',',@a_taquilla)."\n";
     if($cuantos >0) {
     	foreach my $elemento (@a_taquilla){
		&setTaquilla($termi, $elemento );
     	}
	print join (',', @a_taquilla) ."$termi\n";
	&setTaquilla( );
     }
  }else{
       print "Sin conexion $termi    $db_ip\n";
  }
}
