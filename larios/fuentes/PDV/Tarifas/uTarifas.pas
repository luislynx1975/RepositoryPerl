unit uTarifas;

{Autor: Gilberto Almanza Maldonado
Fecha: Viernes, 12 de Agosto de 2010
Unidad que contiene las funciones, procedimientos  y constantes
que ocupa el modulo de Tarifas.}

interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids,
   XPStyleActnCtrls, ActnList, ActnMan, ImgList, Buttons, Data.SqlExpr;
const
   _FECHAS_ERROR = 'La Fecha Inicial no debe de ser menor a la Fecha Final, corriga para continuar.';
   _FECHA_MAYOR_HOY ='La fecha de aplicacion debe de ser mayor o igual al dia de hoy, corriga para continuar.';
   _ERROR_SERVICIOS ='El Servicio Inicial debe ser menor del servicio Final.';
   _MENSAJE_TARIFAS_NULAS = 'Existen tarifas sin valor, �Desea asignar un valor 0.00?';
   _ERROR_LLENADO = 'Existe un error al llenar la informaci�n, consulte con el administrador del sistema.';
   _PREGUNTA_ALTA_TARIFAS ='�Desea realizar el alta de las tarifas?';

 Procedure CargaCiudad(combo: TlsComboBox);
 Procedure CargaServicio(combo: TlsComboBox);
 Procedure CargaRuta(combo: TLsComboBox);
///agregado para el calculo del iva
 procedure CargarIva(combo : TlsComboBox);
 var  QueryT: TSQLQuery;
implementation

uses frmCTarifas, frmATarifa, comun;
procedure CargarIva(combo : TlsComboBox);
begin
    sql := 'SELECT VALOR FROM PDV_C_IVA WHERE BAJA IS NULL';
    if EjecutaSQL(sql,QueryT, _LOCAL) then begin
        while not QueryT.Eof do begin
            combo.Add(FormatFloat('00.00' ,QueryT['VALOR']), FormatFloat('00.00' ,QueryT['VALOR']));
            QueryT.Next;
        end;
    end;
    QueryT.Close;
end;



 Procedure CargaCiudad(combo: TlsComboBox);
 begin
  sql:='SELECT ID_TERMINAL AS ID, DESCRIPCION FROM T_C_TERMINAL WHERE FECHA_BAJA IS NULL;';
  if not EjecutaSQL(sql,QueryT,_LOCAL) then
  begin
      ShowMessage(_ERR_SQL);
      Exit;
  end;
  combo.Clear;
  while not QueryT.Eof do
  begin
     combo.Add(QueryT.fieldByName('ID').AsString + ' ' + QueryT.FieldByName('DESCRIPCION').AsString,
               QueryT.fieldByName('ID').AsString);
     QueryT.Next;
  end;
  QueryT.Close;
 end;

 procedure CargaServicio(combo: TlsComboBox);
 begin
   sql:='SELECT TIPOSERVICIO AS ID, ABREVIACION AS DESCRIPCION FROM SERVICIOS '+
        ' WHERE FECHA_BAJA IS NULL AND TIPOSERVICIO <> 0;';
   if  EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
      combo.Clear;
      while not QueryT.Eof do
      begin
         combo.Add(QueryT.fieldByName('ID').AsString + ' ' + QueryT.FieldByName('DESCRIPCION').AsString,
                           QueryT.fieldByName('ID').AsString);
         QueryT.Next;
      end;
   end;
 end;



 Procedure CargaRuta(combo: TLsComboBox);
 begin
   sql:='SELECT ID_RUTA,  CONCAT(ORIGEN , ''-'' , DESTINO, '' - '', ID_RUTA ) AS DESCRIPCION FROM T_C_RUTA ORDER BY 2';
   if  EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
      combo.Clear;
      while not QueryT.Eof do
      begin
         combo.Add(QueryT.fieldByName('ID_RUTA').AsString + ' ' + QueryT.FieldByName('DESCRIPCION').AsString,
                           QueryT.fieldByName('ID_RUTA').AsString);
         QueryT.Next;
      end;
   end;

 end;

end.