#programa que extra la información de la tabla de venta que es 
#PDV_T_BOLETO esta información es guardada en la tabla 
#REP_T_VENTA_TRANSPORTADO 
#!/usr/bin/perl
use DBI;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
my $user = "root";
my $pass = "#R0j0N3no\$";
my $port = 3306;

my $base_reporte = "REPORTES";
my $terminal = undef;
my @a_dates_process = undef;
sub conectaServer{
	local($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
        return $dbh;
}

sub DateSales(){
   my$ter_minl = shift;
   my@dates = undef;
   my$idx = 0;
   local $qry = "SELECT DISTINCT(FECHA) FROM PDV_T_BOLETO WHERE FECHA < CURRENT_DATE() AND FECHA > '2010-01-01'";

   #local $qry = "SELECT DISTINCT(FECHA) FROM PDV_T_BOLETO WHERE FECHA < CURRENT_DATE() AND ID_TERMINAL = ?";
#   my $qry = "SELECT DISTINCT(FECHA) FROM PDV_T_BOLETO WHERE FECHA < '2010-12-31' AND ID_TERMINAL = ?";
   my $out_qry = $SERVER->prepare($qry);
print $ter_minl;
   $out_qry->bind_param(1,$ter_minl);
   $out_qry->execute();
   while( ( @days ) = $out_qry->fetchrow_array() ) {
         $dates[$idx] = $days[0];
	 $idx++;
   }
   $out_qry->finish();
   return @dates;
}

#revisar aqui el error de no inserta nada el valor de total si existe no lo insert sino lo inserta
sub InsertDates(){
   local ($ter_mnl, @Dates) = @_;
   for($idx = 0; $idx < @Dates; $idx++){
  	local $qry = "SELECT COUNT(*)AS TOTAL FROM REP_C_FECHA WHERE FECHA = ?";
   	local $out_qry = $SERVER->prepare($qry);
	$out_qry->bind_param(1,$Dates[$idx]);
	$out_qry->execute();
	@out = $out_qry->fetchrow_array();
        if($out[0] == 0){
   	    $qry = "INSERT INTO REP_C_FECHA(FECHA, REP_PROCESADO_".$ter_mnl.") VALUES(?,0)";
    	    $out_qry = $SERVER->prepare($qry);
    	    $out_qry->bind_param(1,$Dates[$idx]);
	    $out_qry->execute();
	}
   }
   $out_qry->finish();
}


#extraemos todas las terminales y creamos el campo
sub getTerminalServicios{
   my @a_terminales;
   my $idx = 0;
   my $query = "SELECT S.ID_TERMINAL ".
            "FROM PDV_C_GRUPO_SERVICIOS S INNER JOIN T_C_TERMINAL T ON S.ID_TERMINAL  = T.ID_TERMINAL";
   my $sth = $SERVER->prepare( $query );
   $sth->execute();
   while( my @outs = $sth->fetchrow_array() ){
	$a_terminales[$idx] = $outs[0];
	$idx++;	
   }
   $sth->finish();
   return @a_terminales;
}

#creamos la tabla
sub crt_tabla(){
   my @a_terms = &getTerminalServicios();
   my $columnas = "";

   foreach my $valor (@a_terms){
      $columnas = $columnas  . " REP_PROCESADO_$valor INTEGER DEFAULT 0, \n";
   }
#   $columnas =~ s/, $//;
   my $qry = "CREATE TABLE REP_C_FECHA( ".
             " FECHA DATE NOT NULL, ".
	     $columnas .
	     " PRIMARY KEY(FECHA) ".
      	     ")ENGINE=InnoDB DEFAULT CHARSET=utf8";
   $out_do = $SERVER->do($qry) || die "\nError en la creacion de la tabla";
   $out_qry->finish();
}

sub create_table_transportado(){
   local $qry = "CREATE TABLE REP_T_VENTA_TRANSPORTADO ( ".
                " ID BIGINT(20) UNSIGNED NOT NULL, ".
		" ID_TERMINAL VARCHAR(5) NOT NULL, ".
                " TOTAL_TARIFA_TIPOS INT(11) NULL DEFAULT '0', ".
                " TIPO_TARIFA VARCHAR(1) NULL DEFAULT '0', ".
                " TIPO_SERVICIO INT(11) NULL DEFAULT '0', ".
                " TARIFA DECIMAL(9,2) NULL DEFAULT '0.00', ".
                " ORIGEN VARCHAR(10) NULL DEFAULT NULL, ".
                " DESTINO VARCHAR(10) NULL DEFAULT NULL, ".
                " ID_CORRIDA VARCHAR(10) NULL DEFAULT NULL, ".
                " FECHA DATE NULL DEFAULT NULL, ".
                " HORA TIME NULL DEFAULT NULL, ".
		" STATUS VARCHAR(1) NULL, ".
		" IVA DECIMAL(9,2) DEFAULT '0.00', ".
		" TOTAL_IVA DECIMAL(9,2) DEFAULT '0.00', ".
		" ID_RUTA   INTEGER NULL, ".
		" ASIENTOS_BUS INTEGER NULL, ".
		" BUS INTEGER NULL, ".
		" OPERADOR VARCHAR(10) NULL, ".
                " PRIMARY KEY (ID,ID_TERMINAL),".
                " INDEX CORRIDA_FECHA (ID_CORRIDA, FECHA, ID_TERMINAL) ".
                " ) ".
                " COLLATE='latin1_bin' ".
                " ENGINE=InnoDB";
   $out_do = $SERVER->do($qry) || die "\n Error en la creacion de la tabla";
   $out_qry->finish();
}

sub create_table_vendido(){
   local $qry = "CREATE TABLE REP_T_VENTA_VENDIDO( ".
                " ID BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT, ".
		" ID_TERMINAL VARCHAR(5) NOT NULL, ".
                " TOTAL_TARIFA_TIPOS INT(11) NULL DEFAULT '0', ".
                " TIPO_TARIFA VARCHAR(1) NULL DEFAULT '0', ".
                " TIPO_SERVICIO INT(11) NULL DEFAULT '0', ".
                " TARIFA DECIMAL(9,2) NULL DEFAULT '0.00', ".
                " ORIGEN VARCHAR(10) NULL DEFAULT NULL, ".
                " DESTINO VARCHAR(10) NULL DEFAULT NULL, ".
                " ID_CORRIDA VARCHAR(10) NULL DEFAULT NULL, ".
                " FECHA DATE NULL DEFAULT NULL, ".
                " HORA TIME NULL DEFAULT NULL, ".
		" STATUS VARCHAR(1) NULL, ".
                " PRIMARY KEY (ID),".
                " INDEX CORRIDA_FECHA (ID_CORRIDA, FECHA) ".
                " ) ".
                " COLLATE='latin1_bin' ".
                " ENGINE=InnoDB";
   $out_do = $SERVER->do($qry) || die "\n Error en la creacion de la tabla";
   $out_qry->finish();
}

sub chk_report_table(){
   local $qry = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ".
		"WHERE TABLE_NAME = 'REP_T_VENTA_TRANSPORTADO' AND TABLE_SCHEMA = 'CORPORATIVO'";
   local $out_qry = $SERVER->prepare($qry);
   $out = $out_qry->execute();
   if($out == 0){#creamos la tabla
      &create_table_transportado();
   }

#   $qry = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ".
#	  "WHERE TABLE_NAME = 'REP_T_VENTA_VENDIDO' AND TABLE_SCHEMA = 'CORPORATIVO'";
#   $out_qry = $SERVER->prepare($qry);
#   $out = $out_qry->execute();
#   if($out == 0){
#      &create_table_vendido();
#   }

   $out_qry->finish();
}

#i'm check if exist the table REP_C_FECHA
sub chk_tabla {
   local $ter_minl = shift;
   local $qry = "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES ".
		"WHERE TABLE_NAME = 'REP_C_FECHA' AND TABLE_SCHEMA = 'CORPORATIVO'";
   local $out_qry = $SERVER->prepare($qry);
   $out = $out_qry->execute();
   if($out == 0){#creamos la tabla
	&crt_tabla();
#prueba para que genere en la tabla todos las terminales existentes
	&InsertDates( $ter_minl, &DateSales( $ter_minl ) );
   }
   if($out == 1){#existe la tabla y consultamos he insertamos
	&InsertDates( $ter_minl, &DateSales( $ter_minl ) );
   }
   $out_qry->finish();
}

#we obtain  the point sale unique
sub getTerminal(){
   local $out_data = undef;
   local $qry = "SELECT DISTINCT(ID_TERMINAL) FROM PDV_T_BOLETO";
   local $out_qry = $SERVER->prepare($qry);
   $out_qry->execute();
   while( ( @outs ) = $out_qry->fetchrow_array() ) {
         $out_data = $outs[0];
	 break;
   }
   $out_qry->finish();
   return $out_data;
}

#return a hash table
sub getCorridasDia(){
   local ($ter_mnl, $fec_Sales) = @_;
   local @datas = @_;
   local $idx = 0;
   local @corrida_out = undef;
   local $qry = "SELECT DISTINCT(B.ID_CORRIDA) ".
		"FROM PDV_T_BOLETO B ".
		 "WHERE B.FECHA = ? AND B.ID_TERMINAL = ? ORDER BY 1";
   local $out_qry = $SERVER->prepare($qry);
   $out_qry->bind_param(1,$fec_Sales);
   $out_qry->bind_param(2,$ter_mnl);
   local $counts = $out_qry->execute();
   while( (@outs) = $out_qry->fetchrow_array() ){
       $corrida_out[$idx] = $outs[0];
       $idx++;
   }
   return @corrida_out;
}

sub getDatesForProcess(){
   local $trmnl = shift;
   local @Dates = undef;
   local $idx = 0;
   local $qry = "SELECT FECHA FROM REP_C_FECHA WHERE REP_PROCESADO_". $trmnl ." = 0";
   local $out_qry = $SERVER->prepare($qry);
   $out_qry->execute();
   while( (@out) = $out_qry->fetchrow_array() ){
      $Dates[$idx] = $out[0]; 
      $idx++;
   }
   $out_qry->finish();
   return @Dates;
}

sub insertOcupanteTabla(){
   local ($ter_minal, @datos) = @_;
   local $indice = undef;
   local $fecha  = $datos[7];
   local $qry = "SELECT COUNT(*) AS MAXIMO FROM REP_T_VENTA_TRANSPORTADO WHERE FECHA = ? AND ID_TERMINAL = ?";
   local $out_qry = $SERVER->prepare($qry);
   $out_qry->bind_param(1, $fecha);
   $out_qry->bind_param(2, $ter_minal);
   $out_qry->execute();
   $indice = 0;
   $bus_asiento = 0;
   while( (@out) = $out_qry->fetchrow_array() ){
	$indice = $out[0] + 1;	
   }

   $qry = "SELECT DISTINCT(ASIENTOS)AS ASIENTO ".
	  "FROM PDV_T_CORRIDA C INNER JOIN PDV_T_BOLETO B ON C.ID_CORRIDA = B.ID_CORRIDA AND C.FECHA = B.FECHA ".
	  "INNER JOIN PDV_C_TIPO_AUTOBUS A ON A.ID_TIPO_AUTOBUS = C.ID_TIPO_AUTOBUS ".
          "WHERE B.ID_CORRIDA = ? AND B.FECHA = ? AND B.ID_TERMINAL = ?";
   $out_asientos = $SERVER->prepare($qry);
   $out_asientos->bind_param(1, $datos[6]);
   $out_asientos->bind_param(2, $datos[7]);
   $out_asientos->bind_param(3, $ter_minal);
   $out_asientos->execute();
   while( (@out) = $out_asientos->fetchrow_array() ){
	$bus_asiento = $out[0];	
   }

   $qry = "SELECT NO_BUS, ID_OPERADOR FROM PDV_T_GUIA G WHERE G.ID_CORRIDA = ? AND G.FECHA = ? AND G.ID_TERMINAL = ?";
   my $sth = $SERVER->prepare( $qry );
   $sth->bind_param(1, $datos[6]);
   $sth->bind_param(2, $fecha);
   $sth->bind_param(3, $ter_minal);
   $sth->execute();
   my @a_guia = $sth->fetchrow_array();

   $fecha =~ s/[-]//g;
   $fecha = $fecha . $indice;
   $qry = "INSERT INTO REP_T_VENTA_TRANSPORTADO(ID, TOTAL_TARIFA_TIPOS, TIPO_TARIFA, TIPO_SERVICIO,".
          "TARIFA, ORIGEN, DESTINO, ID_CORRIDA, FECHA, ID_TERMINAL, IVA, TOTAL_IVA, ID_RUTA, ASIENTOS_BUS, BUS, OPERADOR) ".
    	  "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
   $out_qry = $SERVER->prepare( $qry );
   $out_qry->bind_param(1, $fecha);
   $out_qry->bind_param(2, $datos[0]);
   $out_qry->bind_param(3, $datos[1]);
   $out_qry->bind_param(4, $datos[2]);
   $out_qry->bind_param(5, $datos[3]);
   $out_qry->bind_param(6, $datos[4]);
   $out_qry->bind_param(7, $datos[5]);
   $out_qry->bind_param(8, $datos[6]);
   $out_qry->bind_param(9, $datos[7]);
   $out_qry->bind_param(10, $ter_minal);
   $out_qry->bind_param(11, $datos[9]);
   $out_qry->bind_param(12, $datos[10]);
   $out_qry->bind_param(13, $datos[11]);
   $out_qry->bind_param(14, $bus_asiento);
   $out_qry->bind_param(15, $a_guia[0]);
   $out_qry->bind_param(16, $a_guia[1]);
   $out_qry->execute();
}

sub getHoraCorrida(){
   local @Datas = @_;
   local $qry = "SELECT HORA, ESTATUS FROM PDV_T_CORRIDA_D WHERE FECHA = ? AND ID_CORRIDA = ?";
   local $out_qry = $SERVER->prepare( $qry );
   $out_qry->bind_param(1, $Datas[0] );
   $out_qry->bind_param(2, $Datas[1] );
   $out_qry->execute();
   @out = $out_qry->fetchrow_array();
   return @out;
}

sub agregaHoraEstatus(){
   local @Datas = @_;
   local $qry = "UPDATE REP_T_VENTA_TRANSPORTADO SET HORA = ?, STATUS = ? ".
		"WHERE ID_CORRIDA = ? AND FECHA = ?";
   local $out_qry = $SERVER->prepare( $qry );
   $out_qry->bind_param(1, $Datas[0] );
   $out_qry->bind_param(2, $Datas[1] );
   $out_qry->bind_param(3, $Datas[2] );
   $out_qry->bind_param(4, $Datas[3] );
   if(length($Datas[0]) > 0){
      $out_qry->execute();
   }
   $out_qry->finish();
}

sub updateRep_c_fecha(){
   local ($recibe, $fecha) = @_;
   local $qry = "UPDATE REP_C_FECHA SET REP_PROCESADO_".$recibe." = 1 WHERE FECHA = ?";
   local $out_qry = $SERVER->prepare( $qry );
   $out_qry->bind_param( 1, $fecha );
   $out_qry->execute();
   $out_qry->finish();
#print $qry."\n";
}


sub getTotalTransportadoCorrida(){
   local @Datas = @_;
   local $terminal_proc = undef;
   local $status = 'V';
   local $qry = "SELECT COUNT(TIPO_TARIFA)AS TOTAL, B.TIPO_TARIFA, B.TIPOSERVICIO, B.TARIFA, ".
		" B.ORIGEN, B.DESTINO, B.ID_CORRIDA, B.FECHA, B.ID_TERMINAL, B.IVA, B.TOTAL_IVA, B.ID_RUTA ".
		" FROM PDV_T_BOLETO B ".
		" WHERE B.FECHA = ? AND B.ID_CORRIDA = ? AND B.ID_TERMINAL = ? AND B.ESTATUS = ? ". 
		" GROUP BY B.TIPO_TARIFA, B.TARIFA, B.TIPOSERVICIO, ".
		" B.ORIGEN, B.DESTINO, B.ID_CORRIDA, B.FECHA";
   local $out_qry = $SERVER->prepare( $qry );
   $out_qry->bind_param(1 , $Datas[0]);
   $out_qry->bind_param(2 , $Datas[1]);
   $out_qry->bind_param(3 , $Datas[2]);
   $out_qry->bind_param(4 , $status);
   $out_qry->execute();
   while( (@outs) = $out_qry->fetchrow_array() ){
	&insertOcupanteTabla( $Datas[2], @outs, );
        @corrida_s_hora = &getHoraCorrida( @valor = ($Datas[0], $outs[6]) );
	if(length($corrida_s_hora[0]) > 0) {
            &agregaHoraEstatus( @values = ($corrida_s_hora[0], $corrida_s_hora[1], $Datas[1], $Datas[0]) );
	}
	#print "Los valores de los datos $Datas[2], $Datas[0]\n";
        &updateRep_c_fecha( $Datas[2], $Datas[0] );
   }
   $out_qry->finish();
}

sub getTotalVendidoCorrida(){
   local @Datas = @_;
   local $terminal_proc = undef;
   local $qry = "SELECT COUNT(TIPO_TARIFA)AS TOTAL, B.TIPO_TARIFA, B.TIPOSERVICIO, B.TARIFA, ".
		" B.ORIGEN, B.DESTINO, B.ID_CORRIDA, B.FECHA, B.ID_TERMINAL, B.IVA, B.TOTAL_IVA, ID_RUTA ".
		" FROM PDV_T_BOLETO B ".
		" WHERE DATE(B.FECHA_HORA_BOLETO) = ? AND B.ID_CORRIDA = ? AND B.ID_TERMINAL = ? ". 
		" GROUP BY B.TIPO_TARIFA, B.TARIFA, B.TIPOSERVICIO, ".
		" B.ORIGEN, B.DESTINO, B.ID_CORRIDA, B.FECHA";
   local $out_qry = $SERVER->prepare( $qry );
   $out_qry->bind_param(1 , $Datas[0]);
   $out_qry->bind_param(2 , $Datas[1]);
   $out_qry->bind_param(3 , $Datas[2]);
   $out_qry->execute();
   while( (@outs) = $out_qry->fetchrow_array() ){
	&insertOcupanteTabla( $Datas[2], @outs, );
#        @corrida_s_hora = &getHoraCorrida();
	if(length($corrida_s_hora[0]) > 0) {
#            &agregaHoraEstatus( @values = ($corrida_s_hora[0], $corrida_s_hora[1], $Datas[1], $Datas[0]) );
	}
#        &updateRep_c_fecha( $Datas[2], $Datas[0] );
   }
   $out_qry->finish();
}

sub getTerminalesTabla(){
   local @Datas = undef;
   local $idx = 0;
   local $qry = "SELECT DISTINCT(B.ID_TERMINAL) ".
		"FROM PDV_T_BOLETO B  ". #INNER JOIN PDV_C_TERMINAL T ON B.ID_TERMINAL = T.ID_TERMINAL ".
#		"WHERE T.ID_TERMINAL = 'AER' ".
		"ORDER BY 1";
   local $out_qry = $SERVER->prepare( $qry );
   $out_qry->execute();
   while( (@outs) = $out_qry->fetchrow_array() ){
	$Datas[$idx] = $outs[0];
        $idx++;
   }
   $out_qry->finish();
   return @Datas;
}

#main 
$SERVER = &conectaServer($base, $host, $user, $pass);
print "Paso 1\n";
&chk_report_table();#si existe la tabla de transportado REP_T_VENTA_TRANSPORTADO 

print "Paso 2\n";
foreach $ter_minal ( &getTerminalesTabla() ){#conseguimos las terminales que estan en la tabla ademas la que tiene venta
print "Paso 3\n";
print $ter_minal . "qui vamos \n";
   &chk_tabla( $ter_minal );  #checamos he insertamos en la tabla de rep_c_fecha

   foreach $fecha_terminal ( &getDatesForProcess( $ter_minal) ){ #obtenemos la fecha que no se ha procesado
print $fecha_terminal . '    ' . $ter_minal . "\n";
      foreach $corrida_dia (&getCorridasDia($ter_minal, $fecha_terminal) ){ #fecha terminal
	if(length($corrida_dia) > 0 ){
	    &getTotalTransportadoCorrida(@values = ( $fecha_terminal, $corrida_dia, $ter_minal ) );
#	    &getTotalVendidoCorrida(@values = ( $fecha_terminal, $corrida_dia, $ter_minal ) );
	}
      }
   }
}

$SERVER->disconnect();
