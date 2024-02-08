#!/usr/bin/perl
use DBI;
use warnings;
use strict;
use Switch;

my $base = "CORPORATIVO";
my $host = "192.168.1.13";
my $user = "venta";
my $pass = "GbS=aVw0oMoHT8!\$6cw!7;b8R3+ella?bCZE";
my $port = 3306;
my $_SERVER = undef;

######################################################################
sub conectaServer(){
	my $dbase_db = undef;
 	my $ip_db = undef;
 	my $user_db = undef;
 	my $pass_db = undef;;
        ($dbase_db, $ip_db, $user_db, $pass_db) = @_;
        my $connectionInfo = "DBI:mysql:database=$dbase_db;$ip_db:$port";
	my $dbh = undef;
	eval{
            $dbh = DBI->connect($connectionInfo, $user_db, $pass_db, {RaiseError=>0, PrintError=>0}) || die "Without Connection";
	};
	if ($@){
	   $dbh = undef;
	}
        return $dbh;
}


######################################################################
sub setTramoEmpresa{
	my $empresa= shift;
	my $query = "SELECT ID_TRAMO FROM T_C_TRAMO ".
		    "WHERE DESTINO IN ( ".
	            "SELECT ID_TERMINAL ".
                    "FROM T_C_TERMINAL ".
		    "WHERE EMPRESA = ?)";
		  
	my $stc = $_SERVER->prepare( $query );
	$stc->bind_param(1, $empresa);
	$stc->execute();
	while(my @outs = $stc->fetchrow_array()){
	    $query = "INSERT INTO PDV_C_EMPRESA_TRAMO(ID_TRAMO, EMPRESA) ".
			 "VALUES(?,?)";
            my $sti = $_SERVER->prepare( $query );
	    $sti->bind_param(1, $outs[0] );
	    $sti->bind_param(2, $empresa );
	    $sti->execute();
	    $sti->finish();
	}
	$stc->finish();
}

#################     Main    ###############################################
$_SERVER = &conectaServer($base, $host, $user, $pass);
&setTramoEmpresa('TER');
&setTramoEmpresa('PUL');


$_SERVER->disconnect();
