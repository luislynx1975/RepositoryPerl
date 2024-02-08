unit comunii;

interface
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids, ShellAPI,
  TRemotoRuta, XPStyleActnCtrls, ActnList, ActnMan, Data.SqlExpr ;

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
  _PREGUNTA_IMPRESION   = '¿Desea imprimir el corte?';
  _PREGUNTA_IMPRESION_2 = '¿Desea imprimir el corte de documentos y detalle de efectivo?';
  _PREGUNTA_DESGLOCE = '¿Deseas imprimir el desgloce de boletos?';
  _TIPO_EFECTIVO = 'EFECTIVO'; // COMPRAS REALIZADAS CON EFECTIVO
  _TIPO_FONDO_INICIAL = 'FONDO_INICIAL'; // FONDO INICIAL EN EL CORTE;
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
  _TIPO_FONDO_PRE   = 1;
  _TIPO_FONDO_POST  = 2;
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
  _PREGUNTA_IMPRESION_CORRECTA_3 = '¿Se imprimio correctamente el Fondo Inicial?';
  _ERROR_PRE_LLENADO           = 'Ocurrió un error al leer la tabla de Pre Corte. Avise al Administrador';
  _ERROR_CONSULTA_FORMA_PAGO   = 'Ocurrió un error al consultar las formas de pago.';
  _ERROR_CONSULTA_DESCUENTO    = 'Ocurrió un error al consultar los descuentos.';
  _ERROR_BLOQUES_SIN_DATOS     = 'Faltan datos en los bloques registrados del corte.';
  _ESTATUS_USUARIO_ACTIVO      = 'ACTIVO';
  _ESTATUS_USUARIO_BAJA        = 'BAJA';
  _PRIVILEGIO_VENTA            = '111';


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

type
  _corte = record
      idTerminal  : String;
      idCorte     : Integer;
      idTaquilla  : Integer;
      idEmpleado  : String;
      FechaInicio : TDateTime;
      FechaFin    : TDateTime;
      Estatus     : String;
      Fondo       : Double;
      Cajero      : String;
    end;

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
function regresaNombreUsuario(trabId: String): String;
function regresaStatusUsuario(trabId:String): String;
function privilegioUsuario(trabId, privilegio: String): Boolean;
function existeCorteAbierto(trabId: String): _corte;
function imprimeFondoInicialCaja(var Archivo: TextFile; corte: String): Boolean;
function cargaPromotores(lista: TlsComboBox): Boolean;
function regresaDatosCorte(idCorte:String): _corte;
function regresaLuGarExpedicion(ciudad: string): String;
function NumeroToLetra( mNum:double ): String;


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

uses TRemotoTodos, ThreadMainServer, comun, DMdb, uCortes, frmAsignacionFondo;

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

function regresaNombreUsuario(trabId: String): String;
begin
  result:='NO-NAME';
  sql:='SELECT NOMBRE FROM PDV_C_USUARIO WHERE TRAB_ID = '+QuotedStr(trabId)+';';
  If EjecutaSQL(sql,dm.Query,_LOCAL) then
     result:= dm.Query.FieldByName('NOMBRE').AsString;
end;

function regresaStatusUsuario(trabId:String): String;
begin
  result:='DESCONOCIDO';
  sql:='SELECT FECHA_BAJA FROM PDV_C_USUARIO WHERE TRAB_ID = '+QuotedStr(trabId)+';';
  If EjecutaSQL(sql,dm.Query,_LOCAL) then
     if dm.Query.FieldByName('FECHA_BAJA').IsNull then
        result:= 'ACTIVO'
     else
        result:= 'BAJA';

end;

function privilegioUsuario(trabId, privilegio: String): Boolean;
begin
  result:=false;
  sql:='SELECT ID_PRIVILEGIO FROM PDV_C_PRIVILEGIO_C_USUARIO WHERE ID_EMPLEADO= '
       +QuotedStr(trabId)+' AND ID_PRIVILEGIO= '+privilegio+';';
  If EjecutaSQL(sql,dm.Query,_LOCAL) then
     if dm.Query.IsEmpty then
        result:= false
     else
        result:= true;
end;

function existeCorteAbierto(trabId: String): _corte;
var
   corteExistente: _corte;
begin
  corteExistente.idCorte:= -1;
  result:=corteExistente;
  sql:='SELECT   * FROM PDV_T_CORTE WHERE ID_EMPLEADO= '+quotedStr(trabId)+' AND ESTATUS <> '+_FINALIZADO+
       ' AND ID_TERMINAL = '+ QuotedStr(gs_terminal)+ ';';
  If EjecutaSQL(sql,dm.Query,_LOCAL) then
     if dm.Query.IsEmpty then
        exit
     else
     begin
        corteExistente.Cajero:=    dm.Query.FieldByName('ID_CAJERO').AsString;
        corteExistente.Estatus:=   dm.Query.FieldByName('ESTATUS').AsString;
        corteExistente.FechaInicio:=  dm.Query.FieldByName('FECHA_INICIO').AsDateTime;
        corteExistente.Fondo  := dm.Query.FieldByName('FONDO_INICIAL').AsFloat;
        corteExistente.idCorte:= dm.Query.FieldByName('ID_CORTE').AsInteger;
        corteExistente.idTaquilla:= dm.Query.FieldByName('ID_TAQUILLA').AsInteger;
        corteExistente.idTerminal:= dm.Query.FieldByName('ID_TERMINAL').AsString;
        corteExistente.idEmpleado:= dm.Query.FieldByName('ID_EMPLEADO').AsString;
        result:= corteExistente;
     end;
end;

function imprimeFondoInicialCaja(var Archivo: TextFile; corte: String): Boolean;
var nombrePromotor: String;
    fecha: TDateTime;
    Query: TSQLQuery;
begin
   Query := TSQLQuery.Create(nil);
   Query.SQLConnection := dm.Conecta;
   sql:= 'SELECT * FROM PDV_T_CORTE WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
          quotedStr(gs_terminal)+ ';';
   If not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      result:= false;
      exit;
   end;
   fecha:=  Query.FieldByName('FECHA_INICIO').AsDateTime ;
   WriteLn(Archivo,'PAGARÉ                                 NO. __________                  BUENO POR    $ '+
                    forza_der(Format(_FORMATO_CANTIDADES_CORTES,[Query.FieldByName('FONDO_INICIAL').AsFloat]), 10));
   WriteLn(Archivo,'');
   WriteLn(Archivo,'                                       En '+  forza_der(regresaLuGarExpedicion(gs_terminal), 20) + ' a ' +
                                                           forza_der(formatDateTime('dddd d "de" mmmm yyyy',fecha)+'.', 30)  );
   WriteLn(Archivo,'');
   Write(Archivo,'Debo y pagaré incondicionalmente por este Pagaré a la orden de: Autobuses de Primera Clase México Zacatepec ');
   WriteLn(Archivo,'S. A. de C. V. en Ciudad de México, la cantidad de ('+ LowerCase(numeroToLetra(Query.FieldByName('FONDO_INICIAL').AsFloat))+' '+
           ' pesos 00/100 M.N.'+ ')  ');
   WriteLn(Archivo,'');
   Write(Archivo,'Valor recibido a mi entera satisfacción. Este pagaré forma parte de una serie numerada de 1 al 1 ');
   Write(Archivo,' y todos están sujetos a la condición de que, al no pagarse cualquiera de ellos a su vencimiento,');
   Write(Archivo,' serán exigibles todos los que le sigan en número, además de los ya vencidos desde la fecha de vencimiento');
   Write(Archivo,' de este documento hasta el día de su liquidación, causará intereses moratorios al tipo mensual, pagadero');
   Write(Archivo,' en esta ciudad juntamente con el principal.');
   WriteLn(Archivo,'');
   WriteLn(Archivo,'');
   WriteLn(Archivo,'Clave: '+Query.FieldByName('ID_EMPLEADO').AsString+
                   ' Promotor: '+regresaNombreUsuario(Query.FieldByName('ID_EMPLEADO').AsString));
    WriteLn(Archivo,'');
   WriteLn(Archivo,'Dirección _______________________________________________ Acepto');
   WriteLn(Archivo,'');
   WriteLn(Archivo,'Población _______________________________________________ Firma_____________________________________');
   WriteLn(Archivo,'');
   WriteLn(Archivo,'');
   WriteLn(Archivo,'');
   result:= true;
   query.Free;
end;


function cargaPromotores(lista: TlsComboBox): Boolean;
var nombrePromotor: String;
    Query: TSQLQuery;
begin
  Query := TSQLQuery.Create(nil);
  Query.SQLConnection := dm.Conecta;
  sql:='SELECT C.ID_CORTE, U.NOMBRE, U.TRAB_ID , C.ID_CORTE, C.FECHA_INICIO '+
        ' FROM PDV_T_CORTE AS C JOIN PDV_C_USUARIO AS U ON (U.TRAB_ID = C.ID_EMPLEADO) '+
        ' WHERE ESTATUS <> ''F'' AND ' +
        ' C.ID_TERMINAL='+QuotedStr(gs_terminal)+' AND  FONDO_INICIAL=0; ';
  // ShowMEssage(sql);
  if not EjecutaSQL(sql,Query,_LOCAL) then
  begin
     ShowMessage('Error al cargar la lista de promotores asignados.');
     Exit;
  end;
  lista.Clear;

  while not Query.Eof do
  begin
     lista.Add( forza_izq(query.FieldByName('NOMBRE').AsString,35)   +
                      forza_der(VarToStr(FormatDateTime('dd/mm/yyyy',query.FieldByName('FECHA_INICIO').AsDateTime)),10),
                      QUERY.FieldByName('ID_CORTE').AsString);

     Query.Next;
  end;
end;

function regresaDatosCorte(idCorte:String): _corte;
var
   corteExistente: _corte;
begin
  corteExistente.idCorte:= -1;
  result:=corteExistente;
  sql:='SELECT   * FROM PDV_T_CORTE WHERE ID_CORTE = '+idCorte + ';';
  If EjecutaSQL(sql,dm.Query,_LOCAL) then
     if dm.Query.IsEmpty then
        exit
     else
     begin
        corteExistente.Cajero:=    dm.Query.FieldByName('ID_CAJERO').AsString;
        corteExistente.Estatus:=   dm.Query.FieldByName('ESTATUS').AsString;
        corteExistente.FechaInicio:=  dm.Query.FieldByName('FECHA_INICIO').AsDateTime;
        corteExistente.Fondo  := dm.Query.FieldByName('FONDO_INICIAL').AsFloat;
        corteExistente.idCorte:= dm.Query.FieldByName('ID_CORTE').AsInteger;
        corteExistente.idTaquilla:= dm.Query.FieldByName('ID_TAQUILLA').AsInteger;
        corteExistente.idTerminal:= dm.Query.FieldByName('ID_TERMINAL').AsString;
        corteExistente.idEmpleado:= dm.Query.FieldByName('ID_EMPLEADO').AsString;
        result:= corteExistente;
     end;

end;

function regresaLuGarExpedicion(ciudad: string): String;
begin
  sql:='SELECT LUGAR_EXPEDICION FROM PDV_C_GRUPO_SERVICIOS '+
       ' WHERE ID_TERMINAL= '+QuotedStr(ciudad);
  if EjecutaSQL(sql, dm.Query, _LOCAL) then
  begin
     result:= dm.Query.FieldByName('LUGAR_EXPEDICION').AsString;
     exit;
  end;
  result:= 'ésta plaza';
end;


function NumeroToLetra( mNum:double ): String;
const
    iIdioma : Smallint = 1;   // 1 castellano     2 catalán
    iModo : Smallint = 1;   // 1 masculino     2 femenino

  iTopFil: Smallint = 6;
  iTopCol: Smallint = 10;
  aCastellano: array[0..5, 0..9] of PChar =
  ( ('UNA ','DOS ','TRES ','CUATRO ','CINCO ',
    'SEIS ','SIETE ','OCHO ','NUEVE ','UN '),
    ('ONCE ','DOCE ','TRECE ','CATORCE ','QUINCE ',
    'DIECISEIS ','DIECISIETE ','DIECIOCHO ','DIECINUEVE ',''),
    ('DIEZ ','VEINTE ','TREINTA ','CUARENTA ','CINCUENTA ',
    'SESENTA ','SETENTA ','OCHENTA ','NOVENTA ','VEINTI'),
    ('CIEN ','DOSCIENTAS ','TRESCIENTAS ','CUATROCIENTAS ','QUINIENTAS ',
    'SEISCIENTAS ','SETECIENTAS ','OCHOCIENTAS ','NOVECIENTAS ','CIENTO '),
    ('CIEN ','DOSCIENTOS ','TRESCIENTOS ','CUATROCIENTOS ','QUINIENTOS ',
    'SEISCIENTOS ','SETECIENTOS ','OCHOCIENTOS ','NOVECIENTOS ','CIENTO '),
    ('MIL ','MILLON ','MILLONES ','CERO ','Y ',
    'UNO ','DOS ','CON ','','') );
  aCatalan: array[0..5, 0..9] of PChar =
  ( ( 'UNA ','DUES ','TRES ','QUATRE ','CINC ',
    'SIS ','SET ','VUIT ','NOU ','UN '),
    ( 'ONZE ','DOTZE ','TRETZE ','CATORZE ','QUINZE ',
    'SETZE ','DISSET ','DIVUIT ','DINOU ',''),
    ( 'DEU ','VINT ','TRENTA ','QUARANTA ','CINQUANTA ',
    'SEIXANTA ','SETANTA ','VUITANTA ','NORANTA ','VINT-I-'),
    ( 'CENT ','DOS-CENTES ','TRES-CENTES ','QUATRE-CENTES ','CINC-CENTES ',
    'SIS-CENTES ','SET-CENTES ','VUIT-CENTES ','NOU-CENTES ','CENT '),
    ( 'CENT ','DOS-CENTS ','TRES-CENTS ','QUATRE-CENTS ','CINC-CENTS ',
    'SIS-CENTS ','SET-CENTS ','VUIT-CENTS ','NOU-CENTS ','CENT '),
    ( 'MIL ','MILIO ','MILIONS ','ZERO ','-',
    'UN ','DOS ','AMB ','','') );
var
  aTexto: array[0..5, 0..9] of PChar;
  cTexto, cNumero: String;
  iCentimos, iPos: Smallint;
  bHayCentimos, bHaySigni, negativo: Boolean;

  (*************************************)
  (* Cargar Textos según Idioma / Modo *)
  (*************************************)

  procedure NumLetra_CarTxt;
  var
    i, j: Smallint;
  begin
    (* Asignación según Idioma *)

    for i := 0 to iTopFil - 1 do
      for j := 0 to iTopCol - 1 do
        case iIdioma of
          1: aTexto[i, j] := aCastellano[i, j];
          2: aTexto[i, j] := aCatalan[i, j];
        else
          aTexto[i, j] := aCastellano[i, j];
        end;

    (* Asignación si Modo Masculino *)

    if (iModo = 1) then
    begin
      for j := 0 to 1 do
        aTexto[0, j] := aTexto[5, j + 5];

      for j := 0 to 9 do
        aTexto[3, j] := aTexto[4, j];
    end;
  end;

  (****************************)
  (* Traducir Dígito -Unidad- *)
  (****************************)

  procedure NumLetra_Unidad;
  begin
    if not( (cNumero[iPos] = '0') or (cNumero[iPos - 1] = '1')
     or ((Copy(cNumero, iPos - 2, 3) = '001') and ((iPos = 3) or (iPos = 9))) ) then
      if (cNumero[iPos] = '1') and (iPos <= 6) then
        cTexto := cTexto + aTexto[0, 9]
      else
        cTexto := cTexto + aTexto[0, StrToInt(cNumero[iPos]) - 1];

    if ((iPos = 3) or (iPos = 9)) and (Copy(cNumero, iPos - 2, 3) <> '000') then
      cTexto := cTexto + aTexto[5, 0];

    if (iPos = 6) then
      if (Copy(cNumero, 1, 6) = '000001') then
        cTexto := cTexto + aTexto[5, 1]
      else
        cTexto := cTexto + aTexto[5, 2];
  end;

  (****************************)
  (* Traducir Dígito -Decena- *)
  (****************************)

  procedure NumLetra_Decena;
  begin
    if (cNumero[iPos] = '0') then
      Exit
    else if (cNumero[iPos + 1] = '0') then
      cTexto := cTexto + aTexto[2, StrToInt(cNumero[iPos]) - 1]
    else if (cNumero[iPos] = '1') then
      cTexto := cTexto + aTexto[1, StrToInt(cNumero[iPos + 1]) - 1]
    else if (cNumero[iPos] = '2') then
      cTexto := cTexto + aTexto[2, 9]
    else
      cTexto := cTexto + aTexto[2, StrToInt(cNumero[iPos]) - 1]
        + aTexto[5, 4];
  end;

  (*****************************)
  (* Traducir Dígito -Centena- *)
  (*****************************)

  procedure NumLetra_Centena;
  var
    iPos2: Smallint;
  begin
    if (cNumero[iPos] = '0') then
      Exit;

    iPos2 := 4 - Ord(iPos > 6);

    if (cNumero[iPos] = '1') and (Copy(cNumero, iPos + 1, 2) <> '00') then
      cTexto := cTexto + aTexto[iPos2, 9]
    else
      cTexto := cTexto + aTexto[iPos2, StrToInt(cNumero[iPos]) - 1];
  end;

  (**************************************)
  (* Eliminar Blancos previos a guiones *)
  (**************************************)

  procedure NumLetra_BorBla;
  var
    i: Smallint;
  begin
    i := Pos(' -', cTexto);

    while (i > 0) do
    begin
      Delete(cTexto, i, 1);
      i := Pos(' -', cTexto);
    end;
  end;

begin
  (* Control de Argumentos *)

  if {(mNum < 0.00) or }(mNum > 999999999999.99) or (iIdioma < 1) or (iIdioma > 2)
    or (iModo < 1) or (iModo > 2) then
  begin
    Result := 'ERROR EN ARGUMENTOS';
    Abort;
  end;

  // Por si es negativo...
  if mNum < 0.00 then begin
     negativo:=TRUE;
     mNum:=ABS(mNum);
  end
  else
     negativo:=FALSE;

  (* Cargar Textos según Idioma / Modo *)

  NumLetra_CarTxt;

  (* Bucle Exterior -Tratamiento Céntimos-     *)
  (* NOTA: Se redondea a dos dígitos decimales *)

  cNumero := Trim(Format('%12.0f', [Int(mNum)]));
  cNumero := StringOfChar('0', 12 - Length(cNumero)) + cNumero;
  iCentimos := Trunc((Frac(mNum) * 100) + 0.5);

  repeat
    (* Detectar existencia de Céntimos *)

    if (iCentimos <> 0) then
      bHayCentimos := True
    else
      bHayCentimos := False;

    (* Bucle Interior -Traducción- *)

    bHaySigni := False;

    for iPos := 1 to 12 do
    begin
      (* Control existencia Dígito significativo *)

      if not(bHaySigni) and (cNumero[iPos] = '0') then
        Continue
      else
        bHaySigni := True;

      (* Detectar Tipo de Dígito *)

      case ((iPos - 1) mod 3) of
        0: NumLetra_Centena;
        1: NumLetra_Decena;
        2: NumLetra_Unidad;
      end;
    end;

    (* Detectar caso 0 *)

    if (cTexto = '') then
      cTexto := aTexto[5, 3];

    (* Traducir Céntimos -si procede- *)

    if (iCentimos <> 0) then
    begin
      cTexto := cTexto + aTexto[5, 7];
      cNumero := Trim(Format('%.12d', [iCentimos]));
      iCentimos := 0;
    end;
  until not (bHayCentimos);

  (* Eliminar Blancos innecesarios -sólo Catalán- *)

  if (iIdioma = 2) then
    NumLetra_BorBla;

  (* ...Por si es negativo *)
  if negativo then
     cTexto:='MENOS '+cTexto;

  (* Retornar Resultado *)

  Result := Trim(cTexto);
end;



end.
