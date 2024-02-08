unit Uusuarios;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids,
  TRemotoRuta,
  XPStyleActnCtrls, ActnList, ActnMan, DB, SqlExpr;
const
   _ACTUALIZACION_PASSWORD_EXITOSA = 'Se ha asignado correctamente la clave predeterminada.'+char(13)+
                                     'Se solicitara su cambio en el siguiente login de usuario.';
   _UPDATE_EXITOSO       = 'La actualizacion de los datos se realizo exitosamente.';
   _INSERT_EXITOSO       = 'La insercion de los datos se realizo exitosamente.';
   _BAJA_USUARIO         = 'Baja de usuario exitosa.';
   _OPERACION_INVALIDA   = 'Operacion Inválida...';
   _PASSWORD_BASE        = 'MERCURIO';

procedure llenaPuestos(combo: TlsComboBox);
Function ExisteEmpleado(Trabid: String; esConductor: Boolean): Boolean;
Function ExisteUsuario(Trabid: String): Boolean;
procedure llenaServicios(combo: TlsComboBox);
Function ActualizaUsuario(TrabId, Nombre, Puesto: String): boolean;
Function ActualizaEmpleado(TrabId, Nombre, Paterno, Materno, Puesto, TipoEmpleado: String; Servicio: Integer): Boolean;
Function InsertaUsuario(TrabId, Nombre, Puesto: String): Boolean;
Function InsertaEmpleado(TrabId, Nombre, Paterno, Materno, Puesto, TipoEmpleado: String; Servicio: Integer): Boolean;
Function InsertaPrivilegios(TrabId, Grupo: String): Boolean;
Function replicaEmpleado(trabID: String): Boolean;


var
    Query, Query2 : TSQLQuery;


implementation

uses comunii, comun, uImportarTarifas;

procedure llenaPuestos(combo: TlsComboBox);
begin
  sql:='SELECT ID_GRUPO, DESCRIPCION  FROM PDV_C_GRUPO_USUARIO WHERE FECHA_BAJA IS NULL ORDER BY DESCRIPCION;';
  if not EjecutaSQL(sql,Query,_LOCAL) then
  begin
     ShowMessage('Error al cargar la lista de puestos.');
     Exit;
  end;
  combo.Clear;
  while not Query.Eof do
  begin
     combo.Add(query.FieldByName('DESCRIPCION').AsString,
                      query.FieldByName('ID_GRUPO').AsString);
     Query.Next;
  end;
end;

Function ExisteEmpleado(Trabid: String; esConductor: Boolean): Boolean;
{regresa true si esta y false si no esta}
begin
   if esConductor then
          sql:='SELECT * FROM EMPLEADOS  '+
               ' WHERE TRAB_ID='+ QuotedStr(TrabId)
   else
          sql:='SELECT * FROM PDV_C_USUARIO AS U JOIN EMPLEADOS AS E '+
               ' ON (U.TRAB_ID = E.TRAB_ID) '+
               ' WHERE U.TRAB_ID='+ QuotedStr(TrabId);
      if not EjecutaSQL(sql,Query,_LOCAL) then
      begin
         ShowMessage('Error al revisar el empleado.');
         result:= True;
         Exit;
      end;
      if query.IsEmpty then
        result:= False
      else
        result:= True;
end;


Function ExisteUsuario(Trabid: String): Boolean;
{regresa true si esta y false si no esta}
begin
  sql:='SELECT TRAB_ID FROM PDV_C_USUARIO WHERE TRAB_ID='+ QuotedStr(TrabId);
  if not EjecutaSQL(sql,Query,_LOCAL) then
  begin
     ShowMessage('Error al buscar el empleado.');
     result:= True;
     Exit;
  end;
  if query.IsEmpty then
    result:= False
  else
    result:= True;

end;

procedure llenaServicios(combo: TlsComboBox);
begin
   sql:='SELECT TIPOSERVICIO AS ID, ABREVIACION AS DESCRIPCION FROM SERVICIOS '+
        ' WHERE FECHA_BAJA IS NULL AND TIPOSERVICIO <> 0;';
   if  EjecutaSQL(sql,Query,_LOCAL) then
   begin
      combo.Clear;
      while not Query.Eof do
      begin
         combo.Add(Query.fieldByName('ID').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
         Query.Next;
      end;
   end;
end;


Function ActualizaUsuario(TrabId, Nombre, Puesto: String): Boolean;
begin
  sql:='UPDATE PDV_C_USUARIO '+
           ' SET ID_GRUPO= '+ Puesto + ',' +
           ' NOMBRE =      '+ QuotedStr(Nombre) +
           ' WHERE TRAB_ID= '+ QuotedStr(TrabId)   + ';';
  if EjecutaSQL(sql,Query,_TODOS) then
     result:= True
  else
     result:= False;
end;


Function ActualizaEmpleado(TrabId, Nombre, Paterno, Materno, Puesto, TipoEmpleado: String; Servicio: Integer): Boolean;
begin
  SQL:='UPDATE EMPLEADOS SET '+
               '  NOMBRES= '+ QuotedStr(Nombre)    + ',' +
               '  PATERNO= '+ QuotedStr(Paterno)   + ',' +
               '  MATERNO= '+ QuotedStr(Materno)   + ',' +
               '  PUESTO_ID = '+ Puesto ;
          if (Servicio<> -1 ) then
               sql:= sql +' , ID_SERVICIO=' + IntToStr(Servicio)  + ',' +
                     ' ID_SERVICIO_ACTUAL = ' + IntToStr(Servicio)  + ',' +
                     ' TIPO_EMPLEADO   = ' + TipoEmpleado ;
          sql:= sql +' WHERE TRAB_ID= '+ QuotedStr(TrabId) + ';';
  if EjecutaSQL(sql,Query,_TODOS) then
     result:= True
  else
     result:= False;
end;


Function InsertaUsuario(TrabId, Nombre, Puesto: String): Boolean;
begin
   sql:='INSERT INTO PDV_C_USUARIO(TRAB_ID, ID_GRUPO, PASSWORD, NOMBRE, FECHA_PASSWORD) '+
           'VALUES('+ QuotedStr(TrabId) + ',' +
           Puesto + ',' +
           QuotedStr(_PASSWORD_BASE) + ',' +
           QuotedStr(Nombre)   + ',' +
           ' CURDATE());';
   if EjecutaSQL(sql,Query,_TODOS) then
          result:= True
   else
          result:= False;
end;

Function InsertaEmpleado(TrabId, Nombre, Paterno, Materno, Puesto, TipoEmpleado: String; Servicio: Integer): Boolean;
begin
  SQL:='INSERT EMPLEADOS(TRAB_ID, NOMBRES, PATERNO, MATERNO, STATUS, ID_SERVICIO, ID_SERVICIO_ACTUAL,TIPO_EMPLEADO, PUESTO_ID)'+
          ' VALUES('+ QuotedStr(TrabId) + ',' +
          QuotedStr(Nombre)    + ',' +
          QuotedStr(Paterno)   + ',' +
          QuotedStr(Materno)   + ',' +
          QuotedStr('ACTIVO')  + ',' +
          intToStr(Servicio)      + ',' +
          intToStr(Servicio)     + ',' +
          TipoEmpleado + ',' +
          Puesto + ')';
   if EjecutaSQL(sql,Query,_TODOS) then
               result:= True
   else
               result:= False;
end;

Function InsertaPrivilegios(TrabId, Grupo: String): Boolean;
begin
    sql:='DELETE FROM PDV_C_PRIVILEGIO_C_USUARIO WHERE ID_EMPLEADO = '+ QuotedStr(TrabId)+';';
    if EjecutaSQL(sql,Query,_TODOS) then
          Sleep(1000); // para que se inserte primero el delete de los insert  ;
    sql:='SELECT ID_PRIVILEGIO FROM PDV_C_GRUPO_PRIVILEGIOS WHERE ID_GRUPO = '+ Grupo + ';';
    if EjecutaSQL(sql,Query,_LOCAL) then
    begin
       Query.First;
       while not Query.Eof do begin
               sql:= 'INSERT INTO PDV_C_PRIVILEGIO_C_USUARIO(ID_EMPLEADO, ID_PRIVILEGIO) '+
                 ' VALUES('+QuotedStr(TrabId) + ','  +
                 Query.FieldByName('ID_PRIVILEGIO').AsString +   '); ';
               if EjecutaSQL(sql,Query2,_TODOS) then
                        ;
               Query.Next;
       end; //insertamos en batch a la tabla pdv_c_privilegio_c_usuario
    end;
end;

Function replicaEmpleado(trabID: String): Boolean;
begin
  sql:='SELECT * FROM EMPLEADOS WHERE TRAB_ID='+ QuotedStr(TrabId);
  if EjecutaSQL(sql,Query,_LOCAL) then
  begin
     if(not Query.IsEmpty) then
     begin
         sql:= 'INSERT INTO  EMPLEADOS  (TRAB_ID , PATERNO, MATERNO, NOMBRES, '+
               ' STATUS, ID_SERVICIO, ID_SERVICIO_ACTUAL,TIPO_EMPLEADO ,  PUESTO_ID ) '+
               ' VALUES( ' + quotedStr(Query.FieldByName('TRAB_ID').AsString) + ',' +
               quotedStr(Query.FieldByName('PATERNO').AsString) + ',' +
               quotedStr(Query.FieldByName('MATERNO').AsString) + ',' +
               quotedStr(Query.FieldByName('NOMBRES').AsString) + ',' +
               quotedStr(Query.FieldByName('STATUS').AsString) + ',' +
               quotedStr(Query.FieldByName('ID_SERVICIO').AsString) + ',' +
               quotedStr(Query.FieldByName('ID_SERVICIO_ACTUAL').AsString) + ',' +
               quotedStr(Query.FieldByName('TIPO_EMPLEADO').AsString) + ',' +
               quotedStr(Query.FieldByName('PUESTO_ID').AsString) + ');';
         comunii.replicarTodos(sql);

     end;

  end;

  sql:='SELECT * FROM PDV_C_USUARIO WHERE TRAB_ID='+ QuotedStr(TrabId);
  if EjecutaSQL(sql,Query,_LOCAL) then
  begin
     if(not Query.IsEmpty) then
     begin
         sql:= 'INSERT INTO  PDV_C_USUARIO(TRAB_ID, ID_GRUPO, PASSWORD, NOMBRE, FECHA_BAJA, FECHA_PASSWORD) '+
               ' VALUES( ' + quotedStr(Query.FieldByName('TRAB_ID').AsString) + ',' +
               quotedStr(Query.FieldByName('ID_GRUPO').AsString) + ',' +
               quotedStr(Query.FieldByName('PASSWORD').AsString) + ',' +
               quotedStr(Query.FieldByName('NOMBRE').AsString) + ',';
         if(Query.FieldByName('FECHA_BAJA').IsNull) then
         begin
               sql:= sql + 'null, ';
         end
         else
         begin
           sql := sql + quotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',Query.FieldByName('FECHA_BAJA').AsDateTime)) + ',';
         end;
         sql:= sql + quotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',Query.FieldByName('FECHA_PASSWORD').AsDateTime)) + ');';
         comunii.replicarTodos(sql);
     end;

     InsertaPrivilegios(TrabId, Query.FieldByName('ID_GRUPO').AsString);

  end;


end;

end.
