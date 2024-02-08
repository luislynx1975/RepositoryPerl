my $filename = 'o.txt';
open(my $fh, '<:encoding(UTF-8)', $filename)
  or die "Could not open file '$filename' $!";
 
while (my $row = <$fh>) {
  chomp $row;
  @out = split('-',$row);
  print("UPDATE PDV_T_BOLETO_2022 SET COMPROBANTE = 2187712 WHERE ID_BOLETO = $out[0] AND ID_TERMINAL = '$out[1]' AND TRAB_ID = '$out[2]';\n");
}
