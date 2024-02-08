#!/usr/bin/perl
use switch;


sub Dia($){
    $mes = shift;
    if ($mes =~ "01") { return 31; }
    if ($mes =~ "02") { return 28; }
    if ($mes =~ "03") { return 31; }
    if ($mes =~ "04") { return 30; }
    if ($mes =~ "05") { return 31; }
    if ($mes =~ "06") { return 30; }
    if ($mes =~ "07") { return 31; }
    if ($mes =~ "08") { return 31; }
    if ($mes =~ "09") { return 30; }
    if ($mes =~ "10") { return 31; }
    if ($mes =~ "11") { return 30; }
    if ($mes =~ "12") { return 31; }
}

$indice = 0;
$dir = "E:\\PDV\\scripts\\corrida\\";
open(RUTA, $dir ."rutas.csv") || die "no puedo abrir el archivo $!\n";
while(<RUTA>){
    chomp();
    @array = split/,/,$_;
    $rutas[$indice] = $array[0];
    $rutas_filtradas{$array[0]} = $_;
    $indice ++;
}
close(RUTA);

print "Numero de dias a procesar\n";
$no_dias = <STDIN>;
chomp($no_dias);
@h = (5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23);
$li_indice_hora = 0;
$indice= 0;
#la hora en el dia
for($hora = 0; $hora < @h; $hora++){
   $min = 0;
   for($minutos = 0; $minutos < 11; $minutos++){	       
       $min += 5;
       $horas[$indice] =  sprintf("%02d",$h[$hora]).":".sprintf("%02d",$min). ":00";
       $indice ++;
   }
}#fin hora


@localtime = localtime;
$year  = 1900 + $localtime[5];
$month = sprintf("%02d",$localtime[4] + 1);
$day   = sprintf("%02d",$localtime[3]);
@tipoBus = (1,2,3);
@servicio = (1,2,3,4,5,6,7,8,9);
@tipo_corrida = ('N','E','F');
$corrida = 1;
$archivo = "E:\\PDV\\scripts\\corrida\\corrida.sql";
open(FILEWRITE, "> $archivo") || die "No puedo generar el archivo\n";
#los dias que se ejecutaran
for($ctrl = 0; $ctrl <= $no_dias; $ctrl++){    
    if($day > &Dia($month)){#mayor al dia del mes
       $day = sprintf("%02d",1);#primer dia del mes
       $month += 1;#incrmenteamos el mes
       if($month > 12){
	   $month = sprintf("%02d",1);#Enero
	   $year += 1;
       }
    }else{	
	$day = sprintf("%02d",$day);
	$day += 1;
    }
    if($day < 32){
	for($ciclo = 0; $ciclo < @horas; $ciclo++){
	    $ruta_fija = $rutas[int(rand(@rutas))];
	    $idx_ruta = int(rand(@rutas));
	    if($idx_ruta == 0){
		$idx_ruta = 76;
	    }
	    @tabla_ruta = split/,/,$rutas_filtradas{$idx_ruta};
	    print FILEWRITE "INSERT INTO PDV_T_CORRIDA(ID_CORRIDA,FECHA,HORA,ID_TIPO_AUTOBUS,TIPOSERVICIO,ID_RUTA,".
		"TIPO_CORRIDA) \n".
		"VALUES(".
		"$corrida,'$year-$month-$day','$horas[$ciclo]', $tipoBus[int(rand(3))]," .
		"$tabla_ruta[8], $tabla_ruta[1],".
		"'$tipo_corrida[int(rand(@tipo_corrida))]');\n";

	    print FILEWRITE "INSERT INTO PDV_T_CORRIDA_D(ID_CORRIDA,FECHA,ID_TERMINAL,HORA,CUPO,PIE,ESTATUS,ID_RUTA)\n ".
		"VALUES($corrida,'$year-$month-$day','MEX','$horas[$ciclo]',10,0,'A',$tabla_ruta[1]);\n";
	    $corrida ++;
	}
	$corrida = 1;
    }
}#fin for dias


    foreach $letra(sort(keys %rutas_filtradas)){
#	print "$letra   $rutas_filtradas{$letra}\n";
    }

