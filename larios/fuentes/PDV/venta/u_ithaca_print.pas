unit u_ithaca_print;


interface

uses
CPort, sysutils;


Var
 port : Tcomport;

// Prototipos de funciones
function imprimirIthaca(puerto, cadena : WideString) : Integer;
Function IthacaTextoAlineado(cadena : String; alineacion : Char) : String;
Function IthacaSaltosDeLinea(cuantos : Integer) : String;
Function IthacaPDF417(cadena : String) : String;
Function IthacaCorte : String;


implementation


Function IthacaTextoAlineado(cadena : String; alineacion : Char) : String;
var
 ali : String;
begin
 if UpperCase(alineacion) = 'C' then
   ali := '1'
 else if UpperCase(alineacion) = 'D' then
   ali := '2'
 else if UpperCase(alineacion) = 'I' then
   ali := '0';
 result := #27#97 + ali + cadena + #10;
end;

Function IthacaSaltosDeLinea(cuantos : Integer) : String;
var
 n : Integer;
Begin
 result := '';
 for n := 1 to cuantos do
    result := result +  #13#10;
end;

Function IthacaPDF417(cadena : String) : String;
begin
 result := #27#98#9 + Chr(length(cadena)) + #0 + cadena;
end;

Function IthacaCorte : String;
Begin
  result := #27#118;
end;

function imprimirIthaca(puerto, cadena : WideString) : Integer;
Begin
 port := TComPort.Create(nil);
 result := -1;
 try
   port.Port := Trim(puerto);
   port.BaudRate := br9600;
   port.StopBits := sbOneStopBit;
   port.DataBits := dbEight;
   port.Parity.Bits := prNone;
   port.Connected := True;
   if port.Connected then
     result := port.WriteStr(cadena);
 finally
   port.Connected := False;
   port.Free;
 end;
end;


end.
