unit uRutasII;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids,  TRemotoRuta,
  XPStyleActnCtrls, ActnList,ActnMan, DB,  SqlExpr;

const
   _CAMPO_ORIGEN           = 'ORIGEN';
   _CAMPO_DESTINO          = 'DESTINO';
   _ORDEN                  = 'ORDEN';
   _CONFIRMACION_USUARIO   = 'Confirmacion de Usuario';
   _FALTA_TRAMO            = 'Favor de seleccionar un tramo antes de continuar.';
   _ORIGEN_DESTINO_IGUALES = 'El origen y el destino deben de ser diferentes.';
   _CONFIRMA_NUEVA_RUTA    = '¿Desea insertar una ruta totalmente nueva?';
   _CONFIRMA_ACTUALIZA_RUTA= '¿Desea actualizar la ruta actual (%s)?';
   _SQL_ELIMINA_RUTA_D       = 'DELETE FROM  T_C_RUTA_D WHERE ID_RUTA= %s;';
   _SQL_INSERTA_RUTA       = 'INSERT INTO T_C_RUTA(ID_RUTA,     ORIGEN, DESTINO, KM, MINUTOS) '+
                             'SELECT IFNULL(MAX(ID_RUTA)+1, 1),  %s ,     %s   , %s,   %s     '+
                             ' FROM T_C_RUTA; ';
   _SQL_INSERTA_RUTA_VALUE = 'INSERT INTO T_C_RUTA(ID_RUTA, ORIGEN, DESTINO, KM, MINUTOS)     '+
                             'VALUES (                %s,    %s,      %s,    %s,    %s);      ';
   _SQL_INSERTA_RUTA_D     = 'INSERT INTO T_C_RUTA_D(ID_RUTA, ID_TRAMO, ORDEN)                '+
                             ' VALUES               ( %s   ,   %s     , %s);                  ';
   _SQL_ACTUALIZA_RUTA     = 'UPDATE T_C_RUTA SET ' +
                             ' ORIGEN = %s , DESTINO = %s, '+
                             ' MINUTOS= %s'+
                             ', KM=      %s'+
                             ' WHERE ID_RUTA= %s;';
   _SQL_SELECT_RUTA        = 'SELECT * FROM T_C_RUTA WHERE ID_RUTA = %s;';
   _SQL_SELECT_RUTA_D      = 'SELECT T.ORIGEN, T.DESTINO, RD.ORDEN '             +
                             ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
                             ' WHERE RD.ID_RUTA= %s ORDER BY RD.ORDEN';
   _SQL_SELECT_RUTA_D_MIO  = 'SELECT T.ID_TRAMO, T.ORIGEN, T.DESTINO, RD.ORDEN ' +
                             ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
                             ' WHERE RD.ID_RUTA= %s ORDER BY RD.ORDEN';


   procedure CreaQuerysR;
   procedure DestruyeQuerysR;
   procedure LlenaCiudadesTodas(combo: TlsComboBox);
   procedure LlenaTramosCon(tipo, ciudad: String; combo:TlsComboBox);
   function InsertaTramo(idTramo: String; sag, sagMio: TStringGrid):String;
   function RegresaRuta(origen, destino, kilometros, minutos: String): String;

var
   mi_variable: String;
   QueryRutas: TSQLQuery;

implementation

uses comun, DMdb, frmCRutaII;


procedure CreaQuerysR;
begin
  QueryRutas:=   TSQLQuery.Create(nil);
  QueryRutas.SQLConnection:= dm.Conecta;
end;
procedure DestruyeQuerysR;
Begin
  QueryRutas.Destroy;
End;



procedure LlenaCiudadesTodas(combo: TlsComboBox);
begin
  sql:='SELECT  ID_TERMINAL, CONCAT(ID_TERMINAL , '' - '', DESCRIPCION)AS DESCRIPCION_TERMINAL '+
       ' FROM T_C_TERMINAL ORDER BY 1 ASC;';
  if EjecutaSQL(sql, QueryRutas, _LOCAL) then
  begin
    combo.Clear;
    while not QueryRutas.Eof do
    begin
      combo.Add(QueryRutas.FieldByName('DESCRIPCION_TERMINAL').AsString ,
                    QueryRutas.FieldByName('ID_TERMINAL').AsString);
      QueryRutas.Next;
    end;
  end;

end;

procedure LlenaTramosCon(tipo, ciudad: String; combo:TlsComboBox);
begin
  sql:='SELECT TRAMO.ID_TRAMO, CONCAT(TERM.ID_TERMINAL, ''-'' ,TERM.DESCRIPCION) AS DESCRIPCION '+
       ' FROM T_C_TRAMO AS TRAMO JOIN T_C_TERMINAL AS TERM ON (TRAMO.DESTINO = TERM.ID_TERMINAL) '+
       ' WHERE '+ tipo + '=' + QuotedStr(ciudad)+';';
  if EjecutaSQL(sql, QueryRutas, _LOCAL) then
  begin
    combo.Clear;
    while not QueryRutas.Eof do
    begin
      combo.Add(QueryRutas.FieldByName('DESCRIPCION').AsString ,
                    QueryRutas.FieldByName('ID_TRAMO').AsString);
      QueryRutas.Next;
    end;
  end;

end;

function InsertaTramo(idTramo: String; sag, sagMio: TStringGrid):String;
begin
  result:='EXISTE UN ERROR';
  sql:='SELECT ORIGEN, DESTINO FROM T_C_TRAMO WHERE ID_TRAMO='+ idTramo+';';
  if EjecutaSQL(sql, QueryRutas, _LOCAL) then
  begin
    sag.RowCount:= sag.RowCount+1;
    sag.Cells[0,sag.RowCount-2]:= QueryRutas.FieldByName('ORIGEN').AsString ;
    sag.Cells[1,sag.RowCount-2]:= QueryRutas.FieldByName('DESTINO').AsString ;
    sag.Cells[2,sag.RowCount-2]:= '0' ;
    sagMio.RowCount:= sagMio.RowCount+1;
    sagMio.Cells[0,sag.RowCount-2]:= idTramo ;
    sagMio.Cells[2,sag.RowCount-2]:= '0' ;

    frmCRutasII.terminal_origen := QueryRutas.FieldByName('ORIGEN').AsString ;
    frmCRutasII.terminal_destino:= QueryRutas.FieldByName('DESTINO').AsString ;
    sql:='SELECT ID_TERMINAL, CONCAT(ID_TERMINAL , '' - '', DESCRIPCION)AS DESCRIPCION_TERMINAL '+
         ' FROM T_C_TERMINAL WHERE ID_TERMINAL ='+
         QuotedStr(QueryRutas.FieldByName('DESTINO').AsString)+';';
    if EjecutaSQL(sql, QueryRutas, _LOCAL) then
  begin
     result:= QueryRutas.FieldByName('DESCRIPCION_TERMINAL').AsString ;
     uRutasII.LlenaTramosCon(uRutasII._CAMPO_ORIGEN, QueryRutas.FieldByName('ID_TERMINAL').AsString, frmCRutasII.cbTramos);
  end;
  end;
end;

function RegresaRuta(origen, destino, kilometros, minutos: String): String;
begin
   sql:='SELECT MAX(ID_RUTA) AS ID_RUTA '+
        ' FROM T_C_RUTA WHERE ORIGEN='+
       Origen  +  ' AND DESTINO='+  Destino+
       ' AND MINUTOS ='+MINUTOS+
       ' AND KM='+KILOMETROS+';';
     if  EjecutaSQL(sql,QueryRutas,_LOCAL) then
       if not QueryRutas.IsEmpty then
          result:= QueryRutas.FieldByName('ID_RUTA').AsString
       else
          result:= ''
     else
        result:= '';


end;

end.
