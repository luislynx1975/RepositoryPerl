#/usr/bin/perl
use strict;
use warnings;

my($cmd, $process_name) = ("apache2\|httpd", "apache2");

if(`ps -A | grep $process_name`){
	print "Process is runing\n";

}else{
	#aqui va tu codigo para regresarlo a como estaba ejecutando sin la modificacion
	`$cmd &`;
}
