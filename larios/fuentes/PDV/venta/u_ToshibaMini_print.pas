unit u_ToshibaMini_print;

interface

uses
CPort, sysutils;


Var
 port : Tcomport;

 // Prototipos de funciones
function imprimirToshibaMini(puerto, cadena : WideString) : Integer;
Function ToshibaMiniTextoAlineado(cadena : String; alineacion : Char) : String;
Function ToshibaMiniSaltosDeLinea(cuantos : Integer) : String;
Function ToshibaMiniPDF417(cadena : String) : String;
Function ToshibaMiniCorte : String;
Function ToshibaMiniInicializar(fontGrande, negritas : Boolean) : String;



implementation

Function ToshibaMiniTextoAlineado(cadena : String; alineacion : Char) : String;
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


Function ToshibaMiniSaltosDeLinea(cuantos : Integer) : String;
var
 n : Integer;
Begin
 result := '';
 for n := 1 to cuantos do
    result := result +  #13#10;
end;


Function ToshibaMiniPDF417(cadena : String) : String;
begin
 Result := #29#107 +
           #75 + // Barra PDF417
           Chr(length(cadena)) +
           cadena;
end;


Function ToshibaMiniCorte : String;
Begin
 result := #27 +
           #100 +
           #5 + // Espacio que se salta para efectuar el corte
           #29 +
           #86 +
           #0; // Tipo de corte 0 total, 1 parcial
end;


function imprimirToshibaMini(puerto, cadena : WideString) : Integer;
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

Function ToshibaMiniInicializar(fontGrande, negritas : Boolean) : String;
Var
 temp : String;
 font,
 negrita : Char;

Begin
 temp :=  #27 + // esc
          #64; // inicializar la impresora

 temp := temp +
          #27 + // esc
          #116 + // Seleccion de la tabla de caracteres
           #12; // Latinos para Toshiba Mini, para la epson #16

 if fontGrande then
   font := #48
 else
   font := #49;

 temp := temp +
          #27 + // esc
          #77 + // Font
          font;

 if negritas then
   negrita := #01
 else
   negrita := #00;


 temp := temp +
         #27 +
         #71 +
         negrita;
           {
           00 Desactivado
           01 Negritas
           }

 result := temp;
End;



{

//underline
 cadena := cadena +
           #27 +
           #45 +
           #00;
          // 00 Desactivado
          // 01 Linea simple
          // 02 linea doble


}


end.
