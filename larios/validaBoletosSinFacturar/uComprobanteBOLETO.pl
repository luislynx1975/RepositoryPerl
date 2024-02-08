#!/usr/bin/perl
no warnings 'utf8';
my $filename = 'oo.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
  chomp $row;
  @primero = split(',',$row);
  $s = s/\s//g;
  @out = split('-',$primero[1]);
  $out[2] =~ s/^\s+//;
  print("UPDATE ENERO_2022 SET COMPROBANTE = $primero[0] WHERE ID_BOLETO = $out[0] AND ID_TERMINAL = '$out[1]' AND TRAB_ID = '$out[2]';\n");
}
