#!/usr/bin/perl
use Switch;

@rutas = (1,2,3,4,5,6,7,8,9,10,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,99,,105,552,553,554,555,5541);
@servicios = (1,2,3,4,5);
@autobus = (1,2,3);
@Tcorrida = ('N','E','F');
#@Terminals = ('JOJ','ZAC','GAL','MEX','CCS','CUE','ALP','ALC','XOX','XOA','PTE');
$dir = "E:\\PDV\\scripts\\DATOS\\terminal.csv";

sub Dia(){
    $mes = shift;   
    switch ($mes){
	case "01" { return 31; }
	case "02" { return 28; }
	case "03" { return 31; }
	case "04" { return 30; }
	case "05" { return 31; }
	case "06" { return 30; }
	case "07" { return 31; }
	case "08" { return 31; }
	case "09" { return 30; }
	case "10" { return 31; }
	case "11" { return 30; }
	case "12" { return 31; }
    }
}

sub hora(){
    @h = (5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23);
    $hour = $h[int(rand(@h))];
    $min  = int(rand(60));
    $seg  = int(rand(60));
    return sprintf("%02d",$hour) . ":" . sprintf("%02d",$min) . ":" . 
	sprintf("%02d",$seg);
}

sub validarFecha(){
    my @localtime = localtime;
    my ($year, $month, $day, $hour, $minute, $second);
    @dia = split/\//,$fechaActual;
    $year = 1900 + $localtime[5];
    $month = sprintf("%02d",$localtime[4])+1;
    $day   = sprintf("%02d",$localtime[3]);
    $y = 1;
    $ctrl = 1;
    for ($i = 0; $i <= $dias; $i++){
	if($month <= 9){
	    $month = sprintf("%02d",$month);
	}
	if ($day > &Dia($month)){	  
	    $day = sprintf("%02d",1);
	    $month += 1;
	    if($month > 12){
		$month = sprintf("%02d",1);
		$year += 1;
	    }
	}else{
	    $day += $y;
	    $day = sprintf("%02d",$day);
	}

	$tiempo = $year ."-". $month ."-". $day;   	
	$ran = int(rand(30));   
#print "$tiempo\n";    
	for($k = 0; $k < $ran; $k++){	 
  	    for($kk = 0; $kk < 9; $kk++){
		$hora = &hora();
#		print "$tiempo\n";
		$corrida = int(rand(20500));
		$ruta  = int(rand(@rutas) + 1);
		print FILEWRITE "INSERT INTO PDV_T_CORRIDA( " .
#	    print "INSERT INTO PDV_T_CORRIDA( " .
		    "ID_CORRIDA,FECHA,HORA,ID_TIPO_AUTOBUS,".
		    "TIPOSERVICIO,ID_RUTA,TIPO_CORRIDA)\n".
		    "VALUES( $corrida,'$tiempo','$hora'," . 
		    int(rand(@autobus) + 1)  . "," . 
		    int(rand(@servicios) + 1) . "," . 
		    $ruta . ",'" . 
		    $Tcorrida[rand(2)] . "');\n";
		#$ctrl += 1;
		%lista_terminal = undef;

		for($ii = 0; $ii < $t; $ii++){ 
		    $hora = &hora();
		    $ter = $ter_array[int(rand($t))];
		    if (exists $lista_terminal{$ter}){
			$ter = $ter_array[int(rand($t) + 5)];
		    }else{
			$lista_terminal{$ter} = $ter;
		    }			      
		}

		foreach $key (keys %lista_terminal) {
		    if (length($key) > 0){
			print FILEWRITE "INSERT PDV_T_CORRIDA_D(".
#	        print "INSERT PDV_T_CORRIDA_D(".
			    "ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, ID_RUTA) ".
			    "VALUES($corrida,'$tiempo','". $key . "','$hora',".
			    int(rand(44)) . "," . int(rand(20)) . ",'A',$ruta);\n";
			$ctrl += 1;
		    }
		}
	    }
        }
#	print $tiempo . "   " .$i . "\n";
    }
    print "Total de corridas generas : " . $ctrl;
}


print "Numero de dias a procesar\n";
$dias = <STDIN>;
chomp($dias);
open(FILES, $dir) || die "No puedo abrir la terminal";
while(<FILES>){  
    @array_ter = split/,/,$_;
    $ter_array[$t] = substr($array_ter[0],1,3);
    $t += 1;
}
close(FILES);


$archivo = "E:\\PDV\\scripts\\corrida.sql";
open(FILEWRITE, "> $archivo") || die "No puedo crear el archivo";

&validarFecha();
close(FILEWRITE);
