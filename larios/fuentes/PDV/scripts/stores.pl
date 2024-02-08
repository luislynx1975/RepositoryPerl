#!/bin/perl -w

$dir_pdv = "c:/PDV/";

sub printHash{
	while(($key, $value) = each(%store)){
		print "$key\n";
	}
}

sub storeOnly{
	$str = shift;
	@line = split/=/;
	$line[1] =~ s/';$/ /;
	$line[1] =~ s/^ '/ /;
	$store{$line[1]} = $line[1];
}

sub ReadPas{
	$ruta = shift;
	$archivo = shift;
	open(DATOS,$ruta) || die;
	while(<DATOS>){
		chomp;
		if(($_ =~ /StoredProcName :/) && ($_ !~ /\//) &&
		   ($_ !~ /\{/)){
			&storeOnly($_);	
		}
	}
}

opendir(my $dh, $dir_pdv) || die;

while(readdir $dh){
	$d = $dir_pdv.$_;
	opendir(my $dh_n,$d) || die;
	  while(readdir $dh_n){
		$do = $d."/".$_;
		if($_ =~ /\.pas$/){
			&ReadPas($do,$_);
		}
	  }
	closedir $dh_n;
}
closedir $dh;

&printHash();
