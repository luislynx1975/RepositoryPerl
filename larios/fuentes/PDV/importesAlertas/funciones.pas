unit funciones;

interface

uses lsCombobox, Windows, Messages, SysUtils, Variants,
  Classes, Grids,  Dialogs , IniFiles , Forms,
  DateUtils, Uni;

Const
    _ESTATUS_TERMINALES_ACTIVAS = 'A';
    _ESTATUS_BOLETOS_VENDIDOS   = 'V';
    _ESTATUS_BOLETOS_CANCELADOS = 'C';
    _ESTATUS_CORRIDAS_REGULARES = 'N';
    _FORMATO_FECHA              = '';
    _CONFIRMA_ELIMINAR_CORRIDAS = 'Se eliminará las corridas con los parametros indicados. ¿Desea continuar?';
    _CONFIRMA_GENERAR_CORRIDAS  = 'Se generarán las corridas con los parametros indicados. ¿Desea continuar?';
    _CONECTAR_OK                = 'Ciudad conectada con éxito ';
    _DESCONECTAR_OK             = 'Ciudad desconectada con éxito ';
    _ESPACIO_CAMPO              = '            ';
    _SEPARADOR                  = '|';
    _FORMATO_IMPORTES = '%.2n';
    _LONGITUD  = 1000;
    _PASSWORD  = '#<m1&/%?.@56\@)e>$*,!--//&--,*54°\?¡2r$_1@<73$:t#<%9 "#(. &-8&#(%@&35$*,--& /1/-)-,*$0&%#';
    _ANCHO_FORMA = 333;
    _ANCHO_FORMA_DATOS = 490;
    _ALTO_FORMA  = 111;
    _ALTO_FORMA_DATOS = 333;

  type
    FORMAS_DE_PAGO = record
       id: integer;
       abreviacion: string;
  end;
  type
    OCUPANTES = record
       id: Integer;
       abreviacion: String;
    end;
  type
     PARAMETROS = record
       id    : Integer;
       valor : Integer;
  end;

  procedure cargaTerminales(lista:  TlsComboBox);
//  function registrosDe(dataSet: TDataSet): Integer;//error nuevo


  procedure LimpiaSag(sag: TStringGrid);


 Var
    sql: String;
    arrFormaPago: Array of FORMAS_DE_PAGO;
    arrOcupantes: Array of OCUPANTES;
    li_ctrl_conectando : integer;
    idTerminal : String;

implementation

uses DMdb, comun, frmImportesAlertas;



procedure cargaTerminales(lista:  TlsComboBox);
begin
  sql:= 'SELECT ID_TERMINAL FROM PDV_C_TERMINAL WHERE ESTATUS ='+ QuotedStr(_ESTATUS_TERMINALES_ACTIVAS);
  EjecutaSQL(sql, DM.Query, _LOCAL);
  lista.Clear;
  while not dm.Query.Eof do
  begin
    lista.Add(dm.Query.FieldByName('ID_TERMINAL').AsString,
              dm.Query.FieldByName('ID_TERMINAL').AsString);
    dm.Query.Next;
  end;
  dm.Query.Close;
end;


(*)****************************************************************************
 --> registrosDe
 + Regresa el número de registros en el dataset, lo uso en lugar de .recordcount
   debido a que en ocaciones me arrojaba datos erroneos.
****************************************************************************(*)
{function registrosDe(dataSet: TDataSet): Integer;
var
   n: Integer;
begin
   n := 0;
   if not dataSet.IsEmpty then
   begin
     dataSet.First;
     while not dataSet.Eof do
     begin
       inc(n);
       dataSet.Next;
     end;
   end;
   result := n;
   dataSet.First;
end;}//error nuevo


procedure LimpiaSag(sag: TStringGrid);
var
   col,ren : byte;
begin
     for col:=0 to  sag.ColCount do
        for ren:=0 to  sag.RowCount do
               sag.Cells[col,ren] := '';
     sag.RowCount := 2;
end;


end.

