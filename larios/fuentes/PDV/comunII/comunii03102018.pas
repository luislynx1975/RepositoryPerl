unit comunii;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids,
  TRemotoRuta,
  XPStyleActnCtrls, ActnList, ActnMan, DB, SqlExpr;

const
  _CIUDAD_TERMINAL = 'T';
  _RECUERDA_TAGS = True;
  _NO_RECUERDA_TAGS = False;
  _CIUDAD_COMISION = 'C';
  _EMPLEADOS_VENTA = '1,5'; // GRUPO DE LOS EMPLEADOS QUE REALIZAN VENTA
  _ASIGNADO = '''A''';
  _NO_FINALIZADO = '''A'',''S'',''P''';
  _NO_LISTO = '''A'',''S''';
  _F10 = VK_F10;
  _PROCESO_DE_CORTE = '''P''';
  _STAND_BY = '''S''';
  _FINALIZADO = '''F''';
  _CORTE_FIN_DIA = 1;
  _CORTE_PASADO = 2;
  _CORTE_AUDITORIA = 3;
  _ESTATUS_CANCELADO = 'C';
  _ESTATUS_VENDIDO = 'V';
  _DATOS_LIMPIOS = 'L'; // Datos de catalogos que vienen sin llenar
  _DATOS_GUARDADOS = 'G'; // datos de tablas almacenados previamente
  _BLANCO = #0; // caracter que se usa cuando no quiero que pinte el teclazo
  _PREGUNTA_PROCESO =
    '¿Esta seguro de procesar el corte con los datos capturados?';
  _PREGUNTA_PRE_CORTAR = '¿Esta seguro de pre cortar el corte numero %s?';
  _PREGUNTA_IMPRESION = '¿Desea imprimir el corte?';
  _PREGUNTA_DESGLOCE = '¿Deseas imprimir el desgloce de boletos?';
  _TIPO_EFECTIVO = 'EFECTIVO'; // COMPRAS REALIZADAS CON EFECTIVO
  _TIPO_IMPORTE_IXES = 'IMPORTE_IXES'; // COMPRAS REALIZADAS CON IXE
  _TIPO_IMPORTE_BANAMEX = 'IMPORTE_BANAMEX'; // COMPRAS REALIZADAS CON PIN PAD BANAMEX
  _TIPO_RECOLECCIONES = 'RECOLECCIONES'; // RECOLECCIONES REALIZADAS AL PROMOTOR
  _TOTAL_RECOLECCIONES = 'TOTAL_RECOLECCIONES';
  _TIPO_CANCELADOS = 'CANCELADOS'; // CANCELACIONES AL PROMOTOR
  _TIPO_FORMAS = 'FORMAS_DE_PAGO'; // DISTINTOS TIPO DE FORMAS DE PAGO, VER CATALOGO PDV_C_FORMA_PAGO
  _TIPO_DESCUENTO = 'DESCUENTO'; // DISTINTOS DESCUENTOS, VER CATALOGO PDV_C_OCUPANTE
  _EMPLEADOS_FILTRO =
    ' FECHA_INICIO  BETWEEN ''%S'' AND ''%S'' ORDER BY 1 ASC; ';
  _EMPLEADOS_TODOS = ' FECHA_FIN IS NULL ORDER BY 1 ASC;';
  _CORTE_CON_ARQUEO = True;
  _CORTE_SIN_ARQUEO = False;
  _TIPO_VACIO = 0;
  _TIPO_PRE_LLENADO = 1;
  _OPERACION_SATISFACTORIA = 'La operacion se realizo exitosamente';
  _PROCESO_FALLO = 'El proceso del corte ha fallado, intentelo nuevamente.';
  _REPORTE_FALLO =
    'Se ha producido un error en el reporte de Faltantes y Sobrantes, intentelo nuevamente.';
  _REPORTE_EXISOTO = 'Se realizo el reporte correctamente.';
  _FORMATO_CANTIDADES_CORTES = '%.2n';
  _FORMATO_BOLETOS_CORTES = '%d';
  _FALTA_PROMOTOR = 'Elija un promotor para continuar.';
  _CORTES_PENDIENTES =
    'Existen %d cortes pendientes, procesar antes de continuar.';
  _PREGUNTA_IMPRESION_CORRECTA   = '¿Se imprimio correctamente el corte?';
  _PREGUNTA_IMPRESION_CORRECTA_2 = '¿Se imprimio correctamente el detalle de Documentos y Efectivo?';
  _ERROR_PRE_LLENADO           = 'Ocurrió un error al leer la tabla de Pre Corte. Avise al Administrador';
  _ERROR_CONSULTA_FORMA_PAGO   = 'Ocurrió un error al consultar las formas de pago.';
  _ERROR_CONSULTA_DESCUENTO    = 'Ocurrió un error al consultar los descuentos.';
  _ERROR_BLOQUES_SIN_DATOS     = 'Faltan datos en los bloques registrados del corte.';


  _CAMPO_FORMA_PAGO_APA              = 'APA';
  _CAMPO_FORMA_PAGO_IXES             = 'IXE';
  _CAMPO_FORMA_PAGO_BANAMEX          = 'BNX';
  _CAMPO_FORMA_PAGO_ORD100           = 'OR1';
  _CAMPO_FORMA_PAGO_PASE_TRASLADO    = 'PAS';
  _CAMPO_FORMA_PAGO_AGENCIA          = 'AGE';
  _CAMPO_FORMA_PAGO_ORD50            = 'OR5';
  _CAMPO_FORMA_PAGO_SEDENA           = 'SED';
  _CAMPO_FORMA_PAGO_PASE_PULLMAN     = 'PAS';
  _CAMPO_DESCUENTO_FAM               = 'F';

  _FOLIOS_CANCELADOS                 = 'C';
  _FOLIOS_EN_BLANCO                  = 'B';
  _FOLIOS_DE_RECOLECCION             = 'R';


procedure ErrorLog(Error, sql: string);
function forza_izq(cadena: string; no: integer): string;
function espacios(no: integer): string;
function forza_der(cadena: string; no: integer): string;
procedure replicarTodos(sentencia: String);
procedure cargarTodasLasTerminalesAutomatizadas;
procedure replicaCORPORATIVO(sentencia: String);
function EmpresaTerminal(terminal: String): String;
function TipoImpresion: String;
procedure  cargaOperadores(lscb: TlsComboBox);
function replicaAterminal(miConexion: TSQLConnection;terminal, sentencia: String):boolean;


var
  tipoVentanaTramos: integer;
  { donde tipoVentanaTramos puede contener los siguientes valores
    0 : donde el catalogo es abierto para administrar tramos
    1 : donde el catalogo es abierto con pre-llenado y usa las variables de
    Origen y Destino }
  Origen, Destino: String;
  terminalesAutomatizadas: TStrings; // todas las terminales automatizadas

  banderaInsertaTramos: Boolean;
  { si esta variable es True quiere decir que si pida contraseña
    si la variable es False no pedira la contraseña }

  fechaCorte: TDateTime; // Contiene la fecha de los cortes mostrados en la forma de Cortes
  tipoCorte: Byte; { Contiene el tipo de cortes que se pueden visualizar, procesar e
    imprimir en esta Forma, los valores son:
    _CORTE_FIN_DIA    =   1;
    _CORTE_PASADO     =   2;
    }
  tipoCambio: Byte; { Contiene el cambio de la fecha, pudiendo tener estos  valores:
    _ASIGNACION = 1;   // cuando se esta entrando a la forma
    _CAMBIO     = 2;   // cuando la forma esta activa
    }
  Recaudado, Recaudador: String; { Variables para almacenar los numeros de empleado
    al que se recaudara y el que realiza la accion
    respectivamente }
  QueryReplica: TSQLQuery;

implementation

uses TRemotoTodos, ThreadMainServer, comun, DMdb, uCortes;

{ @procedure ErrorLog
  @Params Error : error que atrapa la excepcion
  @Params sql   : Sentencia sql que detecta el error }
procedure ErrorLog(Error, sql: string);
var
  lf_archivo: TextFile;
begin
  try
    AssignFile(lf_archivo, _LOG);
    if FileExists(_LOG) then
      Append(lf_archivo)
    else
      Rewrite(lf_archivo);
    Writeln(lf_archivo,
      '//------------------------------------------------------------');
    Writeln(lf_archivo, FormatDateTime('"Fecha : "dd/mm/yyyy hh":"nn ', now));
    Writeln(lf_archivo, format('Error : %s', [Error]));
    Writeln(lf_archivo, format('SQL   : %s', [sql]));
    Writeln(lf_archivo,
      '//------------------------------------------------------------');
    CloseFile(lf_archivo);
  except
  end;
end;

{
  Funcion que forza a una cadena de caracteres a alinearse a la izquierda
}
function forza_izq(cadena: string; no: integer): string;
var
  temp: string;
begin
  temp := '';
  if length(cadena) <= no then
  begin
    temp := cadena + espacios(no - length(cadena));
  end
  else
    temp := copy(cadena, 1, no);

  result := temp;
end;

{ Funcion que regresa n espacios como resultado }
function espacios(no: integer): string;
var
  temp: string;
  x: integer;
begin
  temp := '';
  for x := 1 to no do
    temp := temp + ' ';

  result := temp;
end;

{
  Funcion que forza a una cadena de caracteres a alinearse a la derecha
}
function forza_der(cadena: string; no: integer): string;
var
  temp: string;
begin
  temp := '';
  if length(cadena) <= no then
  begin
    temp := espacios(no - length(cadena)) + cadena;
  end
  else
    temp := copy(cadena, 1, no);

  result := temp;
end;

procedure cargarTodasLasTerminalesAutomatizadas;
begin
  comunii.QueryReplica := TSQLQuery.Create(nil);
  comunii.QueryReplica.SQLConnection := dm.Conecta;
  // Todas las terminales A y tipo T excepto donde estoy generando la corrida
  sql := 'SELECT ID_TERMINAL FROM PDV_C_TERMINAL WHERE ESTATUS = ''A'' AND ' +
    'TIPO in (''T'',''S'') AND ID_TERMINAL <> ''' + gs_terminal +
    ''' ORDER BY ID_TERMINAL;';
  if EjecutaSQL(sql, QueryReplica, _LOCAL) then
  Begin
    while not QueryReplica.Eof do
    Begin
      terminalesAutomatizadas.Add(QueryReplica.FieldByName('ID_TERMINAL')
          .AsString);
      QueryReplica.Next;
    End;
  End;
  QueryReplica.Close;
  QueryReplica.Destroy;
end;

procedure replicarTodos(sentencia: String);
var
  n: integer;
  sentenciaLocal: String;
begin
  // showmessage(sentencia);
  comunii.QueryReplica := TSQLQuery.Create(nil);
  comunii.QueryReplica.SQLConnection := dm.Conecta;
  for n := 0 to terminalesAutomatizadas.Count - 1 do
  begin
    QueryReplica.sql.Clear;
    sentenciaLocal :=
      'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
      'SELECT NOW(), ''' + terminalesAutomatizadas[n] + ''', :sql';
    QueryReplica.sql.Add(sentenciaLocal);
    QueryReplica.Params[0].AsString := sentencia;
    QueryReplica.ExecSQL;
  end;
  QueryReplica.Destroy;
end;

procedure replicaCORPORATIVO(sentencia: String);
var
  n: integer;
  sentenciaLocal: String;
begin
  comunii.QueryReplica := TSQLQuery.Create(nil);
  comunii.QueryReplica.SQLConnection := dm.Conecta;
  QueryReplica.sql.Clear;
  sentenciaLocal :=
    'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
    'SELECT NOW(), ''' + '1730' + ''', :sql';
  // ShowMessage(sentenciaLocal);
  QueryReplica.sql.Add(sentenciaLocal);
  QueryReplica.Params[0].AsString := sentencia;
  QueryReplica.ExecSQL;
  QueryReplica.Destroy;
end;

function TipoImpresion: String;
var
  _AUX: String;
begin

  if comun.getImpresora(1) = _IMP_DEFAUTL_PRINTER  then
     uCortes.tipoImpresora := _PREDETERMINADA;

  if comun.getImpresora(1) = _IMP_TOSHIBA_MINI then
      Ucortes.tipoImpresora:= _TOSHIBA_MINI;

  if comun.getImpresora(1) = _IMP_ITHACA_MINI then
      uCortes.tipoImpresora := _ITHACA;


end;


function EmpresaTerminal(terminal: String): String;
begin
  sql:= 'SELECT EMPRESA FROM T_C_TERMINAL WHERE ID_TERMINAL = ' + QuotedStr(terminal) +';';
  if EjecutaSQL(sql,dm.Query,_LOCAL) then
  begin
    if dm.Query.FieldByName('EMPRESA').IsNull then
       result:= 'DESCONOCIDO'
    else
       result:= dm.Query.FieldByName('EMPRESA').AsString;
  end;
end;


function replicaAterminal(miConexion: TSQLConnection;terminal, sentencia: String):boolean;
  var
  n: integer;
  sentenciaLocal: String;
begin
  comunii.QueryReplica := TSQLQuery.Create(nil);
  comunii.QueryReplica.SQLConnection := miConexion;
  QueryReplica.sql.Clear;
  sentenciaLocal :=
    'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
    'SELECT NOW(), ''' + terminal + ''', :sql';
  // ShowMessage(sentenciaLocal);
  QueryReplica.sql.Add(sentenciaLocal);
  QueryReplica.Params[0].AsString := sentencia;
  QueryReplica.ExecSQL;
  QueryReplica.Destroy;
end;


procedure  cargaOperadores(lscb: TlsComboBox);
begin
  sql:='SELECT TRAB_ID, (CONCAT(PATERNO,'' '',MATERNO,'' '',NOMBRES))AS NOMBRE FROM EMPLEADOS '+
       ' WHERE ID_SERVICIO_ACTUAL <> 0 ORDER BY 1;';
  lscb.Clear;
  if(EjecutaSql(sql,dm.Query,_LOCAL))then
  begin
     while(not dm.Query.Eof)do
     begin
         lscb.Add(dm.Query.FieldByName('TRAB_ID').AsString + '- ' +
                  dm.Query.FieldByName('NOMBRE').AsString,
                  Trim(dm.Query.FieldByName('TRAB_ID').AsString));
         dm.Query.Next;
     end;
  end;
end;

end.
