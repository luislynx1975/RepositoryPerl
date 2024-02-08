unit Uterminales;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids,  TRemotoRuta,
  XPStyleActnCtrls, ActnList,ActnMan, DB,  SqlExpr;

const
   _MI_CONSTANTE = 'MC';
   _ACTUALIZACION_EXITOSA = 'La actualización de los datos se realizó satisfactoriamente.';
   _OPERACION_FALLIDA     = 'La operación ha fallado, intentelo nuevamente.';
   _INSERCION_EXITOSA     = 'La inserción de los datos se realizó satisfactoriamente.';
   _PREGUNTA_GUARDAR      = '¿Desea guardar la información?';

   function ExisteTerminal(Terminal: String) : Boolean;
   function InsertaTerminal(Terminal, Descripcion, Tipo, Ventanillas, Auto, Empresa, nombreAlCliente: String): boolean;
   function ActualizaTerminal(Terminal, Descripcion, Tipo, Ventanillas, Auto, Empresa, nombreAlCliente: String): boolean;
   procedure CreaQuerysT;
   procedure DestruyeQuerysT;

var
   mi_variable: String;
   QueryTerminales: TSQLQuery;

implementation

uses comun, DMdb, comunii;

function ExisteTerminal(Terminal: String) : Boolean;
begin
  sql:= 'SELECT  * '+
        ' FROM  T_C_TERMINAL '+
        ' WHERE ID_TERMINAL= '+ QuotedStr(Terminal);
  if EjecutaSQL(sql, QueryTerminales, _LOCAL) then
     if QueryTerminales.Eof then
        result:= False
     else
        result:= True;
end;

procedure CreaQuerysT;
begin
  QueryTerminales:=   TSQLQuery.Create(nil);
  QueryTerminales.SQLConnection:= dm.Conecta;

end;
procedure DestruyeQuerysT;
Begin
  QueryTerminales.Destroy;
End;

function InsertaTerminal(Terminal, Descripcion, Tipo, Ventanillas, Auto, Empresa, nombreAlCliente: String): boolean;
begin
  sql:='INSERT INTO T_C_TERMINAL(ID_TERMINAL, DESCRIPCION, TIPO, VENTANILLAS, AUTO, IMPORTE, EMPRESA, NOMBRE_AL_CLIENTE) '+
       ' VALUES('+ QuotedStr(Terminal) + ',' +
       QuotedStr(Descripcion)          + ',' +
       QuotedStr(Tipo)                 + ',' +
       Ventanillas                     + ',' +
       QuotedStr(Auto)                 + ',' +
       '0'                             + ',' +
       QuotedStr(Empresa)              + ',' +
       QuotedStr(nombreAlCliente)      + ');' ;
 { if EjecutaSQL(sql, QueryTerminales, _TODOS) then
     result:= True
  else
     result:= False; }
   if EjecutaSQL(SQL,QueryTerminales,_LOCAL) then
     begin
        comunii.replicarTodos(sql);
     end;

end;
function ActualizaTerminal(Terminal, Descripcion, Tipo, Ventanillas, Auto, Empresa, nombreAlCliente: String): boolean;
begin
  sql:='UPDATE T_C_TERMINAL '+
       ' SET DESCRIPCION= ' + QuotedStr(Descripcion)          + ',' +
       ' TIPO           = ' + QuotedStr(Tipo)                 + ',' +
       ' VENTANILLAS    = ' + Ventanillas                     + ',' +
       ' AUTO           = ' + QuotedStr(Auto)                 + ',' +
       ' EMPRESA        = ' + QuotedStr(Empresa)              + ',' +
       ' NOMBRE_AL_CLIENTE = ' + QuotedStr(nombreAlCliente)   +
       ' WHERE  ID_TERMINAL = ' + QuotedStr(Terminal)+';';
  if EjecutaSQL(sql, QueryTerminales, _LOCAL) then
  BEGIN
     result:= True;
     comunii.replicarTodos(sql);
  END
  else
     result:= False;
end;
end.
