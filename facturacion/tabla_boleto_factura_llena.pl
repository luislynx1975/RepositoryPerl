#!/usr/bin/perl
use DBI;
use strict;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
my $user = "root";
my $pass = "3st\@b\@M0sB13n\$";
my $port = 3306;
my $SERVER = undef;
my $table_nombre = "PDV_T_BOLETO_";


sub conectaServer{
	my $dbase_db = undef; 
        my $ip_db = undef; 
        my $user_db = undef; 
        my $pass_db = undef; 
	my $connectionInfo = undef;
	my $dbh = undef; 
	($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
        $dbh = DBI->connect($connectionInfo,$user_db,$pass_db);
        return $dbh;
}

sub getAnioBoleto{
        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$year  += 1900;
	return $year;	
}

sub setTablaGlobal{
	my $tabla = shift;
	$tabla = $table_nombre . $tabla;
	my $query = "SELECT DISTINCT(B.COMPROBANTE) ".
		    "FROM " . $tabla . " B ".
                    "WHERE B.COMPROBANTE > 0";
	my $sth = $SERVER->prepare( $ query );
	$sth->execute();	
	while(my @valor = $sth->fetchrow_array()  ){
	    my $qry = "INSERT INTO TABLA_BOLETO_FACTURA(TABLA_NAME, COMPROBANTE) ".
	              "VALUES( ?, ?)";
            my $sti = $SERVER->prepare( $qry );
            $sti->bind_param(1, $tabla);
            $sti->bind_param(2, $valor[0]); 
	    $sti->execute();
	}
}

sub setTablaWEB{
	my $tabla = shift;
	$tabla = $table_nombre . $tabla;
	my $query = "SELECT DISTINCT(B.ID_REFERENCIA) ".
		    "FROM " . $tabla . " B ".
                    "WHERE length(B.ID_REFERENCIA) > 3 ";
	my $sth = $SERVER->prepare( $ query );
	$sth->execute();	
	while(my @valor = $sth->fetchrow_array()  ){
	    my $qry = "INSERT INTO TABLA_BOLETO_FACTURA(TABLA_NAME, COMPROBANTE) ".
	              "VALUES( ?, ?)";
            my $sti = $SERVER->prepare( $qry );
            $sti->bind_param(1, $tabla);
            $sti->bind_param(2, $valor[0]); 
	    $sti->execute();
	}
}

$SERVER = &conectaServer($base, $host, $user, $pass);
my $actual = getAnioBoleto();
&setTablaGlobal($actual);
&setTablaGlobal($actual - 1);
&setTablaWEB($actual);
&setTablaWEB($actual - 1);
$SERVER->disconnect();
