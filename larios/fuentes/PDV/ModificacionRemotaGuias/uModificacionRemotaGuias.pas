unit uModificacionRemotaGuias;
{Autor: Gilberto Almanza Maldonado
Fecha : 14 de Febrero de 2018
Descripción:
   unidad que contiene las funciones y variables del módulo de frmModificacionRemotoGuias
   se genera para agregar la funcionalidad de que al actualizar una guia debe modificar
   también la tabla PDV_T_CORRIDA y PDV_T_CORRIDA_D, ya que actualmente no lo hace.
   Solicita Óscar Parrilla.
}
interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids, Aligrid,
  XPStyleActnCtrls, ActnList, ActnMan,  DB, ImgList, Buttons, Data.SqlExpr,
  Printers;
type
  _Guia = record
     idGuia     : integer;
     idTerminal : String;
     Fecha      : TDateTime;
     idCorrida  : String;
     idDestino  : String;
     Bus        : Integer;
     idOperador : String;
     idServicio : Integer;
     idRuta     : Integer;
     boletera   : Integer;
  end;
  function actualizaCorrida(guia: _Guia; servidor : TSQLConnection; query: TSQLQuery): Boolean;

implementation

uses frmModificacionRemotaGuias, DMdb, comun, comunii;

  function actualizaCorrida(guia: _Guia; servidor: TSQLConnection ; query: TSQLQuery): Boolean;
  begin
      result:= false;
      frmModificacionRemotaGuias.sql:= 'UPDATE PDV_T_CORRIDA SET NO_BUS = '+ IntToStr(guia.Bus) +
                                       ' WHERE ID_CORRIDA = ' + QuotedStr(guia.idCorrida)       +
                                       ' AND FECHA = ' + QuotedStr(FormatDateTime('yyyy/mm/dd', guia.Fecha));
      if(comun.EjecutaSQL(frmModificacionRemotaGuias.sql, query , comun._LOCAL)) then
      begin
         comunii.replicaAterminal(servidor, guia.idTerminal ,   frmModificacionRemotaGuias.sql);
         result:= true;
         exit;
      end;
  end;


end.
