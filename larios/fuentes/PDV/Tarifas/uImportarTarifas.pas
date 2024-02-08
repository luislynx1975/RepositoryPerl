unit uImportarTarifas;

interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids,
   XPStyleActnCtrls, ActnList, Data.SqlExpr, ActnMan, ImgList, Buttons;
const
  _PREGUNTA_ALTA_TARIFAS ='¿Desea realizar el alta de las tarifas con fecha %s y hora %s?';

  procedure replicarTodosT(sentencia: String);

var  QueryT: TSQLQuery;

implementation

uses comunii, comun, DMdb;

procedure replicarTodosT(sentencia: String);
var
  n: integer;
  sentenciaLocal: String;
begin
  // showmessage(sentencia);
  //si se ocupa esta funcion debera de colocarse estas dos lineas en el create de la
  // forma que la utiliza
  {
  comunii.QueryReplica := TSQLQuery.Create(nil);
  comunii.QueryReplica.SQLConnection := dm.Conecta;
  }
  for n := 0 to terminalesAutomatizadas.Count - 1 do
  begin
   // SHOWMESSAGE(terminalesAutomatizadas[n]);
    Sleep(10);
    comunii.QueryReplica.Close;
    comunii.QueryReplica.sql.Clear;
    sentenciaLocal :=
      'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
      'SELECT NOW(), ''' + terminalesAutomatizadas[n] + ''', :sql';
    comunii.QueryReplica.sql.Add(sentenciaLocal);
    comunii.QueryReplica.Params[0].AsString := sentencia;
    comunii.QueryReplica.ExecSQL;
    comunii.QueryReplica.Close;
  end;
  // de igual forma esta linea en el oncancel de la forma
  {QueryReplica.Destroy;}
end;


end.
