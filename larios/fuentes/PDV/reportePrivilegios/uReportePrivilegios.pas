unit uReportePrivilegios;

interface
  uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids, ShellAPI,
  TRemotoRuta,   XPStyleActnCtrls, ActnList, ActnMan, DB, Data.SqlExpr;

  procedure cargaUsuarios(lscbUsuarios: TlscomboBox);
  procedure cargaGrupos(lscbUsuarios: TlscomboBox);
  procedure cargaPrivilegiosUsuario(sag: TStringGrid; usuario: String);
  procedure cargaPrivilegiosGrupo(sag: TStringGrid; grupo: String);
  function descargaSagAArchivo(sag: TStringGrid; var Archivo: TextFile):boolean;

  Var
     _Query: TSQLQuery;
implementation

uses comunii, DMdb, comun;


procedure cargaUsuarios(lscbUsuarios: TlscomboBox);
begin
  _Query:= TSQLQuery.Create(nil);
  _Query.SQLConnection := dm.Conecta;
  sql:='SELECT TRAB_ID, NOMBRE FROM PDV_C_USUARIO WHERE FECHA_BAJA IS NULL;';
  if EjecutaSQL(sql, _Query, _LOCAL) then
  Begin
    while not _Query.Eof do
    Begin
         lscbUsuarios.Add(_Query.FieldByName('TRAB_ID').AsString + '- ' +
                  _Query.FieldByName('NOMBRE').AsString,
                  Trim(_Query.FieldByName('TRAB_ID').AsString));
         _Query.Next;
    End;
  End;
  _Query.Close;
  _Query.Destroy;
end;

procedure cargaGrupos(lscbUsuarios: TlscomboBox);
begin
  _Query:= TSQLQuery.Create(nil);
  _Query.SQLConnection := dm.Conecta;
  sql:='SELECT ID_GRUPO, DESCRIPCION FROM PDV_C_GRUPO_USUARIO WHERE FECHA_BAJA IS NULL;';
  if EjecutaSQL(sql, _Query, _LOCAL) then
  Begin
    while not _Query.Eof do
    Begin
         lscbUsuarios.Add(_Query.FieldByName('DESCRIPCION').AsString,
                  Trim(_Query.FieldByName('ID_GRUPO').AsString));
         _Query.Next;
    End;
  End;
  _Query.Close;
  _Query.Destroy;
end;

procedure cargaPrivilegiosUsuario(sag: TStringGrid; usuario: String);
begin
   _Query:= TSQLQuery.Create(nil);
   _Query.SQLConnection := dm.Conecta;
   sql:= 'SELECT PRI.ID_PRIVILEGIO AS ID, PRI.DESCRIPCION  AS PRIVILEGIO'+
         ' FROM PDV_C_PRIVILEGIO_C_USUARIO AS PS JOIN PDV_C_PRIVILEGIO AS PRI '+
         ' ON PRI.ID_PRIVILEGIO = PS.ID_PRIVILEGIO '+
         ' WHERE ID_EMPLEADO= '+   QuotedStr(usuario);
    if EjecutaSQL(sql, _Query, _LOCAL) then
    Begin
       comun.DataSetToSag(_Query, sag)
    End;
    _Query.Close;
    _Query.Destroy;
end;

procedure cargaPrivilegiosGrupo(sag: TStringGrid; grupo: String);
begin
   _Query:= TSQLQuery.Create(nil);
   _Query.SQLConnection := dm.Conecta;
   sql:= 'SELECT PRI.ID_PRIVILEGIO AS ID, PRI.DESCRIPCION AS PRIVILEGIO '+
         ' FROM PDV_C_GRUPO_PRIVILEGIOS AS PS JOIN PDV_C_PRIVILEGIO AS PRI '+
         ' ON PRI.ID_PRIVILEGIO = PS.ID_PRIVILEGIO '+
         ' WHERE ID_GRUPO= '+   grupo;
    if EjecutaSQL(sql, _Query, _LOCAL) then
    Begin
       comun.DataSetToSag(_Query, sag)
    End;
    _Query.Close;
    _Query.Destroy;

end;

function descargaSagAArchivo(sag: TStringGrid; var Archivo: TextFile):boolean;
Var
 col, ren: integer;
begin
  result:= false;
  for ren := 1 to sag.RowCount do
       writeLn(Archivo, sag.Cells[0,ren] + ',' + sag.Cells[1,ren]);
   result:= true;
end;



end.
