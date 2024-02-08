unit u_impresion;
interface
uses
WinSpool, windows, SysUtils, shellApi, Forms, Dialogs;

//* Prototipos
function escribirAImpresora(impresora: String; cadena: String): Boolean;
function corte_OPOS: AnsiString;
function corte_OPOS_seccion : AnsiString;
function inicializarImpresora_OPOS: AnsiString;
Function textoAlineado_OPOS(cadena : AnsiString; alineacion : AnsiChar) : AnsiString; overload;
Function textoAlineado_OPOS(cadena : AnsiString; alineacion : AnsiChar; aumenta : boolean) : AnsiString; overload;
Function codigoDeBarrasUniDimensional_OPOS(texto : AnsiString) : AnsiString;
Function SaltosDeLinea_OPOS(cuantos : Integer) : AnsiString;
procedure imprimeDireccionado(archivo_nombre, nombre_impresora, path_archivo : string);

function InicializaBAbierto : AnsiString;
function TamanioLetraPie() : AnsiString;
function TamanioLetraDetalle() : AnsiString;
function limpiaBuffer() : AnsiString;


implementation



Function SaltosDeLinea_OPOS(cuantos : Integer) : AnsiString;
var
 n : Integer;
begin
 result := '';
 for n := 1 to cuantos do
    result := result +  #13#10;
end;


Function codigoDeBarrasUniDimensional_OPOS(texto : AnsiString) : AnsiString;
var
 lTexto : AnsiString;
 impresion : AnsiString;
 cadena : AnsiString;
Begin
 //* sólo puede imprimir 17 caracteres
 lTexto := Copy(texto, 1, 27);

 Result := #29'h2' + // lo alto de la barra
           #29'w'#2 + // lo ancho de la barra
           #29'H2' +  // 2 abajo , 1 arriba , 3 arriba y abajo ,0 sin
           #29'f2' + // el font
           #29#107 +  //107
           #72 + Chr(length(lTexto)) + lTexto;
end;


Function textoAlineado_OPOS(cadena : AnsiString; alineacion : AnsiChar) : AnsiString;
var
 ali : AnsiChar;
begin
 if UpperCase(alineacion) = 'C' then
   ali := '1'
 else if UpperCase(alineacion) = 'D' then
   ali := '2'
 else if UpperCase(alineacion) = 'I' then
   ali := '0';
 result := #27#97 + ali + cadena + #10;
end;


Function textoAlineado_OPOS(cadena : AnsiString; alineacion : AnsiChar; aumenta : boolean) : AnsiString;
var
 ali : AnsiChar;
begin
 if UpperCase(alineacion) = 'C' then
   ali := '1'
 else if UpperCase(alineacion) = 'D' then
   ali := '2'
 else if UpperCase(alineacion) = 'I' then
   ali := '0';
 if aumenta then
//   result := #29 + #33 + #32  + cadena  +  #10 + #29 + #33 + #0
   result := #29 + #33 + #20+ #2  + #27#97 + ali +   cadena  +  #10 + #29 + #33 + #0
 else
   result := #27#97 + ali + cadena + #10;
end;

function limpiaBuffer() : AnsiString;
var
  lCadena : AnsiString;
begin
  lCadena := lCadena +
          #27 +
          #64;
  Result := lCadena;
end;

function TamanioLetraDetalle() : AnsiString;
var
  lCadena : AnsiString;
begin

 lCadena := lCadena +
           #27 +
           #77 +
           #48;//49 mas chica la letra

  Result := limpiaBuffer +  lCadena;
end;


function TamanioLetraPie() : AnsiString;
var
  lCadena : AnsiString;
begin

 lCadena := lCadena +
           #27 +
           #77 +
           #49;//48 mas chica la letra

  Result := limpiaBuffer +  lCadena;
end;


function InicializaBAbierto : AnsiString;
const
 _FONT = #48; // 49
var
 lCadena : AnsiString;
begin
 lCadena := #27 + // esc
           #64; // inicializar la impresora

 lCadena := lCadena +
          #27 + // esc
          #116 + // Seleccion de la tabla de caracteres
          #16;

//Select character font
 lCadena := lCadena +
          #27 + // esc
          #77 + // Font
          _FONT;

 lCadena := lCadena +
          #29 +
          #33 +
          #4;

 { lcadena := lcadena +
          #27 +
          #71 +
          #1;}

  result := lCadena;
end;


function inicializarImpresora_OPOS: AnsiString;
const
 _LATIN = #16;
 _FONT = #48; // 49
var
 lCadena : AnsiString;
begin
 lCadena := #27 + // esc
           #64; // inicializar la impresora


 lCadena := lCadena +
          #27 + // esc
          #116 + // Seleccion de la tabla de caracteres
          _LATIN;

//Select character font
 lCadena := lCadena +
          #27 + // esc
          #77 + // Font
          _FONT;

 //underline
 lCadena := lCadena +
           #27 +
           #45 +
           #00; {
           00 Desactivado
           01 Linea simple
           02 linea doble
           }

  // Negritas
 lCadena := lCadena +
           #27 +
           #71 +
           #01;
           {
           00 Desactivado
           01 Negritas
           }
 result := lCadena;
end;



function corte_OPOS: AnsiString;
var
 lCadena : AnsiString;
begin
// corte
  lCadena := #27 +
           #100 +
           #6 + // Espacio que se salta para efectuar el corte
           #29 +
           #86 +
           #1; // Tipo de corte 0 total, 1 parcial
 result := lCadena;
end;

function corte_OPOS_seccion : AnsiString;
var
  lCadena : AnsiString;
begin
{  lCadena := #29 +
           #86 +
           #49; }
  lCadena := #29 +
           #86 +
           #66 +
           #0;
  result := lCadena;
end;


function escribirAImpresora(impresora: String; cadena: String): Boolean;
var
 hndImpresora : THandle;
 DocInfo: TDocInfo1;
 i: Integer;
 B: Byte;
 Escritos: DWORD;
begin
 Result:= FALSE;
 if not OpenPrinter(PChar(impresora), hndImpresora, nil) then
   exit;
 try
   FillChar(DocInfo,Sizeof(DocInfo),#0);
   DocInfo.pDocName:= PChar('Mercurio');
   DocInfo.pOutputFile:= nil;
   DocInfo.pDataType:= 'RAW';

   if StartDocPrinter(hndImpresora, 1, @DocInfo) <> 0 then
     try
       if StartPagePrinter(hndImpresora) then
         try
           while Length(cadena) > 0 do begin
             if Copy(cadena, 1, 1) = '\' then begin
               if Uppercase(Copy(cadena, 2, 1)) = 'X' then
                 cadena[2]:= '$';
               if not TryStrToInt(Copy(cadena, 2, 3),i) then
                 Exit;
               B := Byte(i);
               Delete(cadena, 1, 3);
             end else
               B:= Byte(cadena[1]);
             Delete(cadena,1,1);
             WritePrinter(hndImpresora, @B, 1, Escritos);
           end;
           Result:= TRUE;
         finally
           EndPagePrinter(hndImpresora);
         end;
     finally
       EndDocPrinter(hndImpresora);
     end;
 finally
   ClosePrinter(hndImpresora);
 end;
end;

procedure imprimeDireccionado(archivo_nombre, nombre_impresora, path_archivo : string);
begin
    ShellExecute(Application.MainForm.Handle, 'printto',
                PChar(archivo_nombre), PChar(nombre_impresora),
                PChar(path_archivo), 0);
end;

end.
