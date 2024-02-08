#!/usr/bin/perl


$dia = '2023-03-24';


@anios = split('-', $dia);

print join ('-', @anios);

$f_inicial = $anios[0] . "-". $anios[1] . "-01 00:00:00";


print("la fecha nueva es : $f_inicial\n");
