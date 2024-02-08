#!/usr/bin/perl 
#use CGI:Carp qw(fatalsToBrowser);
#print "Content-type text/html";
use DBI;

$db = "corporativo";
$host = "192.168.2.150";
$port = "3306";
$user = "venta";
$pass = "ventas";

$connextionInfo="DBI:mysql=database=$db;$host;$port";

$dbh= DBI->connect($connextionInfo,$user,$pass);
