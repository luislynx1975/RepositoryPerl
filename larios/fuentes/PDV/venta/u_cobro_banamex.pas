unit u_cobro_banamex;
//* Cobro con pinpad banamex 2012 lsalez
interface
{$warnings OFF}
uses u_comun_venta, SysUtils, classes, Generics.Collections, DMdb, Data.SqlExpr,
  comun, U_venta, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, IdURI ;


CONST
 _PAGO_BANAMEX_PINPAD = 8;
// _DIRECTORIO = 'C:\VATS LE\'; // INSTALACIPON DE PINPADS 13-DIC-2012
 // _DIRECTORIO = 'e:\Sistemas\PDV\PinPad_Banamex\Documentación\TOTAL ACCESS DEMO PULLMAN\';
 //_DLL = _DIRECTORIO + 'invoke.dll';
 _OPERACION_VENTA = 'VENTA';
 _OPERACION_DEVOLUCION = 'DEVOLUCION';
 _PP_ESTATUS_TERMINAL = 'ESTATUS_TERM';
 _PP_ESTATUS_TRANSACCION =  'ESTATUS_TRANSACCION';
 _PP_FECHA_TRANSACCION = 'FECHA_TRANSACCION';
 _PP_NUMERO_TARJETA =  'NUMERO_TARJETA';
 _PP_ID_TRANSACCION = 'ID_TRANSACCION';
 _PP_CODIGO_AUTORIZACION = 'CODIGO_AUT';
 _PP_MONTO = 'MONTO';
 _PP_REFERENCIA = 'REFERENCIA';
 _PP_TERMINAL = 'TERMINAL';
 _PP_NATURALEZA_CONTABLE = 'NATURALEZA_CONTABLE';
 _PP_TARJETAHABIENTE = 'TARJETAHABIENTE';
 _PP_NOMBRE_TERMINAL = 'POS01';
 _PP_ERROR = 'ERROR';
 _PP_SERVIDOR = 'http://127.0.0.1:8099/TransactionsService?';





 _PP_R_TERMINAL_OK = 'OP';
 _PP_R_CARGO_ACEPTADO = 'CA';
 _PP_R_DEVOLUCION_ACEPTADA = 'RA';
 _PP_R_ERROR_ESTATUS_TERMINAL_INVALIDO = '30';
 _PP_R_ERROR_ERROR = 'error';

 _SAG_CANCELAR = 0;
 _SAG_FOLIO = 1;
 _SAG_PROMOTOR = 2;
 _SAG_CIUDAD = 3;
 _SAG_ORIGEN = 4;
 _SAG_DESTINO = 5;
 _SAG_TARIFA = 6;

 Type
  datosBoleto = Record
    precio : real;
    forma_pago : integer;
    id_pago_pinpad_banamex,
    empleado,
    tipo_tarjeta : String;
  end;
  lArray_asientos  = array[1..50] of datosBoleto;
  tUlimaOperacion = record
    estatus_terminal,
    estatus_transaccion,
    fecha_transaccion,
    id_transaccion,
    codigo_autorizacion,
    monto,
    referencia,
    terminal : string;
  end;


 var

//  directorioActual : String;
  respuestaPinPad : String;
  dRespuesta : TDictionary<string, string>;

//  function sendMSG (args : PAnsiChar): PAnsiChar; stdcall; external  _DLL;

//* Prototipos

Procedure cambiarDeEstructura(origen : u_comun_venta.array_asientos; var destino : lArray_asientos; li_vendidos : Integer); overload;
Procedure cambiarDeEstructura(origen : u_venta.array_asientos; var destino : lArray_asientos; li_vendidos : Integer); overload;


Function precioDe(trab_id, id_terminal : String; id_boleto : Integer; servidor : TSQLConnection) : Double;
Function sePuedeCancelar(trab_id, id_terminal : String; id_boleto : Integer; servidor : TSQLConnection) : Boolean;
Function existenPagosConBanamex(asientos : u_comun_venta.array_asientos; li_vendidos : Integer) : Boolean;  overload;
Function existenPagosConBanamex(asientos : u_venta.array_asientos; li_vendidos : Integer) : Boolean; overload;
Function lExistenPagosConBanamex(asientos: lArray_asientos; li_vendidos : Integer) : Boolean;
Function cobrarConBanamex(var asientos : u_comun_venta.array_asientos; li_vendidos : Integer; conTarjeta : Boolean; servidor : TSQLConnection) : Boolean; overload;
Function cobrarConBanamex(var asientos : u_venta.array_asientos; li_vendidos : Integer; conTarjeta : Boolean; servidor : TSQLConnection) : Boolean; overload;
Function lCobrarConBanamex(var asientos : lArray_asientos; li_vendidos : Integer; conTarjeta : Boolean; servidor : TSQLConnection) : Boolean;
Function totalACobrar(asientos : lArray_asientos; li_vendidos : Integer) : Double;
Function numero_de_boletos(asientos : lArray_asientos; li_vendidos : Integer) : Integer;
Function probarEstatusPinPadBanamex : Boolean;


function ultimaOperacion : tUlimaOperacion;

function existeEstaOperacion(id_transaccion, codigo_autorizacion : string; servidor : TSQLConnection) : Boolean;


Function formatearMensaje(mensaje : String) : TDictionary<String, String>;
Function guardarTransaccionPinPadBanamex(id_terminal, id_empleado : String; boletos : Integer; tarjetaFisica : Boolean;  tipoOperacion : String; servidor : TSQLConnection) : String;
Function referenciaDe(id_empleado, id_terminal : String; servidor : TSQLConnection) : String;
Function boletosRelacionadosPinPadBanamex(id_pago : String; servidor : TSQLConnection) : Integer;
Procedure reimprimirUltimoVoucherBanamex;
Procedure cortePinPadBanamex(fechaInicio: TDateTime);
Procedure regresarAEstructuraPago(origen : lArray_asientos; var destino : u_comun_venta.array_asientos; li_vendidos : Integer); overload;
Procedure regresarAEstructuraPago(origen : lArray_asientos; var destino : u_venta.array_asientos; li_vendidos : Integer); overload;

Function idPagoPinPadBanamex(trab_id : String; id_boleto : Integer; servidor : TSQLConnection) : String;

Function cancelarConBanamex(id_pago, empleado : String; monto_a_devolver :  Double; no_boletos_cancelados : Integer; servidor : TSQLConnection) : Boolean;


function sendMSG(args : AnsiString) : AnsiString;


implementation


procedure loguear(texto: String);
Const
 _LOG = 'c:\mercurio\logPinPadBanamex.txt';
var
 lf_archivo : TextFile;

begin
 try
   AssignFile(lf_archivo,_LOG);
   if FileExists(_LOG) then
     Append(lf_archivo)
   else
     SYSTEM.Rewrite(lf_archivo);
   Write(lf_archivo,FormatDateTime('dd/mm/yyyy hh:nn:ss ',now));
   Writeln(lf_archivo,texto);
   CloseFile(lf_archivo);
 except
 end;
end;


Function precioDe(trab_id, id_terminal : String; id_boleto : Integer; servidor : TSQLConnection) : Double;
var
 ssql : String;
 lQuery : TSQLQuery;
Begin
 lQuery := TSQLQuery.Create(nil);
 try
   lQuery.SQLConnection := servidor;
   ssql := 'SELECT TARIFA FROM PDV_T_BOLETO WHERE ID_BOLETO = ' +
           IntToStr(id_boleto) +
           ' AND TRAB_ID = ' +
           QuotedStr(trab_id) +
           ' AND ESTATUS = ''V''' +
           ' AND ID_TERMINAL = ' +
           QuotedStr(id_terminal) +
           ';';
   lQuery.SQL.Clear;
   lQuery.SQL.Add(ssql);
   lQuery.Open;
   if not lQuery.Eof then
     result := lQuery.FieldByName('TARIFA').AsFloat
   else
     result := 0;

   lQuery.Close;
 finally
   lQuery.Free;
 end;
End;



Function sePuedeCancelar(trab_id, id_terminal : String; id_boleto : Integer; servidor : TSQLConnection) : Boolean;
var
 ssql : String;
 lQuery : TSQLQuery;
Begin
 result := False;
 lQuery := TSQLQuery.Create(nil);
 try
   lQuery.SQLConnection := servidor;
   ssql := 'SELECT B.ESTATUS FROM PDV_T_BOLETO AS B WHERE B.ESTATUS = ''V'' AND B.TRAB_ID = ' +
           QuotedStr(trab_id) +
           ' AND B.ID_BOLETO = ' +
           IntToStr(id_boleto) +
           ' AND ID_TERMINAL = ' +
           QuotedStr(id_terminal) +
           ';';
   lQuery.SQL.Clear;
   lQuery.SQL.Add(ssql);
   lQuery.Open;
   result := not lQuery.Eof;
   lQuery.Close;
 finally
   lQuery.Free;
 end;
End;



Procedure cambiarDeEstructura(origen : u_comun_venta.array_asientos; var destino : lArray_asientos; li_vendidos : Integer); overload;
Var
 n : Integer;
Begin
 for n := 1 to li_vendidos do Begin
   destino[n].forma_pago := origen[n].forma_pago;
   destino[n].id_pago_pinpad_banamex := origen[n].id_pago_pinpad_banamex;
   destino[n].precio := origen[n].precio;
   destino[n].empleado := origen[n].empleado;
   destino[n].tipo_tarjeta := origen[n].tipo_tarjeta;
 End;
End;


Procedure cambiarDeEstructura(origen : u_venta.array_asientos; var destino : lArray_asientos; li_vendidos : Integer); overload;
Var
 n : Integer;
Begin
 for n := 1 to li_vendidos do Begin
   destino[n].forma_pago := origen[n].forma_pago;
   destino[n].id_pago_pinpad_banamex := origen[n].id_pago_pinpad_banamex;
   destino[n].precio := origen[n].precio;
   destino[n].empleado := origen[n].empleado;
   destino[n].tipo_tarjeta := origen[n].tipo_tarjeta;
 End;
End;

Function lExistenPagosConBanamex(asientos: lArray_asientos; li_vendidos : Integer) : Boolean;
var
  n: Integer;
Begin
 result := False;
 for n := 1 to li_vendidos do
  if asientos[n].forma_pago = _PAGO_BANAMEX_PINPAD then Begin
    result := True;
    exit;
  End;
End;


Function existenPagosConBanamex(asientos : u_comun_venta.array_asientos; li_vendidos : Integer) : Boolean;  overload;
var
  destino : lArray_asientos;
Begin
 cambiarDeEstructura(asientos, destino, li_vendidos);
 result := lExistenPagosConBanamex(destino, li_vendidos);
End;


Function existenPagosConBanamex(asientos : u_venta.array_asientos; li_vendidos : Integer) : Boolean; overload;
var
  destino : lArray_asientos;
Begin
 cambiarDeEstructura(asientos, destino, li_vendidos);
 result := lExistenPagosConBanamex(destino, li_vendidos);
End;

Procedure reimprimirUltimoVoucherBanamex;
var
 cadena : AnsiString;
// directorioActual : String;
Begin
// directorioActual := GetCurrentDir;
// SetCurrentDir(_DIRECTORIO);
 //* armado de la cadena de reimpresion
 cadena := 'LANG=sp'; //Va en idioma español
 cadena := cadena + '&TRANSACCION=imprimir'; // Indica que es una reimpresion
 cadena := cadena + '&IMPRIMIR_SALIDA=1'; // Intenta imprimir el voucher
 cadena := cadena + '&TERMINAL=' + _PP_NOMBRE_TERMINAL;
 sendMSG(cadena);
// SetCurrentDir(directorioActual);
End;


Procedure cortePinPadBanamex(fechaInicio : TDateTime);
var
 cadena : AnsiString;
// directorioActual : String;
Begin
// directorioActual := GetCurrentDir;
// SetCurrentDir(_DIRECTORIO);
 //* armado de la cadena de reimpresion
 cadena := 'LANG=sp'; //Va en idioma español
 cadena := cadena + '&TRANSACCION=cierre'; // Indica que es el corte
 cadena := cadena + '&IMPRIMIR_SALIDA=1'; // Intenta imprimir el voucher
 cadena := cadena + '&TERMINAL=' + _PP_NOMBRE_TERMINAL;
 cadena := cadena + '&FECHA_INICIAL=' + FormatDateTime('DD/MM/YYYY HH:NN:SS', fechaInicio);


 sendMSG(cadena);
// SetCurrentDir(directorioActual);
End;




Function totalACobrar(asientos : lArray_asientos; li_vendidos : Integer) : Double;
var
  n: Integer;
Begin
 result := 0.0;
 for n := 1 to li_vendidos do
   if asientos[n].forma_pago = _PAGO_BANAMEX_PINPAD then
     result := result + asientos[n].precio;
End;


Function numero_de_boletos(asientos : lArray_asientos; li_vendidos : Integer) : Integer;
var
  n,
  vendidos : Integer;
Begin
 vendidos := 0;
 for n := 1 to li_vendidos do
   if asientos[n].forma_pago = _PAGO_BANAMEX_PINPAD then
     inc(vendidos);
 result := vendidos;
End;



Function lCobrarConBanamex(var asientos : lArray_asientos; li_vendidos : Integer; conTarjeta : Boolean; servidor : TSQLConnection) : Boolean;
Var
 porCobrar : Double;
 monto : string;
 cadena : AnsiString;
 respuestaPinPad : String;
 lReferncia,
 lValor,
 lError : String;
 referencia : String;
 id_terminal,
 id_pago : String;
 n : Integer;
 fUltimaOperacion : tUlimaOperacion;
 lTipo_tarjeta : String;
Begin
 result := False;
 id_terminal := gs_terminal;
// directorioActual := GetCurrentDir;
// SetCurrentDir(_DIRECTORIO);
 porCobrar := totalACobrar(asientos, li_vendidos);
 referencia := referenciaDe(asientos[1].empleado, id_terminal, servidor);
 // Si un punto decimal no está presente en el valor, los últimos dos dígitos son considerados como decimales.
 monto := FloatToStrF(porCobrar, ffFixed, 10,2);
 //* armado de la cadena de cobro
 cadena := 'LANG=sp'; //Va en idioma español
 cadena := cadena + '&TRANSACCION=cargo'; // Indica que es un cargo
 cadena := cadena + '&MONTO=' + monto; // el monto a cobrar
 cadena := cadena + '&IMPRIMIR_SALIDA=1'; // Intenta imprimir el voucher
 cadena := cadena + '&REFERENCIA=' + referencia; // Referencia0 MAX_BOL_VENDIDOS+1 * ID_CORTE
 cadena := cadena + '&VENDEDOR=' + asientos[1].empleado; //Referencia de hasta 20 caracteres clave del empleado.
// cadena := cadena + '&MONEDA=' +'1'; // 1 = peso mexicano, 2 = us dollar
 cadena := cadena + '&DESHABILITAR_PROMO=1'; //Deshabilita las promociones
 cadena := cadena + '&TERMINAL=' + _PP_NOMBRE_TERMINAL;

{ La nueva modalidad no permite cobro MOTO
 cadena := cadena +'&MOTO=';
 if conTarjeta then // ingegracion MOTO
   cadena := cadena + '0' // Disable
 else
   cadena := cadena + '1'; // Enable
}

 dRespuesta := TDictionary<String, String>.Create;
 try
   respuestaPinPad := sendMSG(cadena);
   dRespuesta := formatearMensaje(respuestaPinPad);
 except
   fUltimaOperacion :=  ultimaOperacion;
   if existeEstaOperacion(fUltimaOperacion.id_transaccion, fUltimaOperacion.codigo_autorizacion, servidor) then begin
     // no se efectuó la operación nueva, la última operación ya se encuentra en la base de datos
     Result := False;
     Exit;
   end else Begin
     // La operación es nueva
     if (fUltimaOperacion.estatus_transaccion = _PP_R_CARGO_ACEPTADO) and (fUltimaOperacion.referencia = referencia) then begin
       // Datos Reales de la última transacción
       dRespuesta.Add(_PP_ESTATUS_TERMINAL, fUltimaOperacion.estatus_terminal);
       dRespuesta.Add(_PP_ESTATUS_TRANSACCION, fUltimaOperacion.estatus_transaccion);
       dRespuesta.Add(_PP_FECHA_TRANSACCION, fUltimaOperacion.fecha_transaccion);
       dRespuesta.Add(_PP_ID_TRANSACCION, fUltimaOperacion.id_transaccion);
       dRespuesta.Add(_PP_CODIGO_AUTORIZACION, fUltimaOperacion.codigo_autorizacion);
       dRespuesta.Add(_PP_MONTO, fUltimaOperacion.monto);
       dRespuesta.Add(_PP_REFERENCIA, fUltimaOperacion.referencia);
       dRespuesta.Add(_PP_TERMINAL, fUltimaOperacion.terminal);

       // Los inventados porque son necesarios
       dRespuesta.Add(_PP_NUMERO_TARJETA, '*****');
       dRespuesta.Add(_PP_NATURALEZA_CONTABLE, 'S');
       dRespuesta.Add(_PP_TARJETAHABIENTE, 'SIN');
     end;
   End;
 end;




 dRespuesta.TryGetValue(_PP_ESTATUS_TRANSACCION, lValor);
 // 1.0935
 dRespuesta.TryGetValue(_PP_REFERENCIA, lReferncia);
 dRespuesta.TryGetValue(_PP_ERROR, lError);
 //* Si regresa el Error=30 El estatus de la terminal es inválido. B - No disponible, procesando operaciones.
 if (lError = _PP_R_ERROR_ESTATUS_TERMINAL_INVALIDO) or (lError = _PP_R_ERROR_ERROR) then Begin
   try
     probarEstatusPinPadBanamex;
     dRespuesta.Clear;
     respuestaPinPad := sendMSG(cadena);
     dRespuesta := formatearMensaje(respuestaPinPad);
     dRespuesta.TryGetValue(_PP_ESTATUS_TRANSACCION, lValor);
     dRespuesta.TryGetValue(_PP_REFERENCIA, lReferncia);
   except
   end;
 End;

 if (lValor = _PP_R_CARGO_ACEPTADO) AND (lReferncia = referencia) then Begin
   id_pago := guardarTransaccionPinPadBanamex(id_terminal, asientos[1].empleado, numero_de_boletos(asientos, li_vendidos), conTarjeta, _OPERACION_VENTA, servidor );
   // actualizo el dato en la estructura de asientos
   for n := 1 to li_vendidos do
     if asientos[n].forma_pago = _PAGO_BANAMEX_PINPAD then begin
       asientos[n].id_pago_pinpad_banamex := id_pago;
       dRespuesta.TryGetValue(_PP_NATURALEZA_CONTABLE, lTipo_tarjeta);
       asientos[n].tipo_tarjeta := lTipo_tarjeta;
     end else begin
       asientos[n].id_pago_pinpad_banamex := '';
       asientos[n].tipo_tarjeta := '';
     end;
   result := True;
 End else Begin
   dRespuesta.TryGetValue('MENSAJES', gs_pinpad_banamex_error);
 End;
 dRespuesta.free;
// SetCurrentDir(directorioActual);
End;

Procedure regresarAEstructuraPago(origen : lArray_asientos; var destino : u_comun_venta.array_asientos; li_vendidos : Integer); overload;
Var
 n : Integer;
Begin
 for n := 1 to li_vendidos do begin
   destino[n].id_pago_pinpad_banamex := origen[n].id_pago_pinpad_banamex;
   destino[n].tipo_tarjeta := origen[n].tipo_tarjeta;
 end;
End;

Procedure regresarAEstructuraPago(origen : lArray_asientos; var destino : u_venta.array_asientos; li_vendidos : Integer); overload;
Var
 n : Integer;
Begin
 for n := 1 to li_vendidos do begin
   destino[n].id_pago_pinpad_banamex := origen[n].id_pago_pinpad_banamex;
   destino[n].tipo_tarjeta := origen[n].tipo_tarjeta;
 end;
End;


Function cobrarConBanamex(var asientos : u_comun_venta.array_asientos; li_vendidos : Integer; conTarjeta : Boolean; servidor : TSQLConnection) : Boolean; overload;
 var
  destino : lArray_asientos;
Begin
 cambiarDeEstructura(asientos, destino, li_vendidos);
 result := lcobrarConBanamex(destino, li_vendidos, conTarjeta, servidor);
 regresarAEstructuraPago(destino, asientos, li_vendidos);
End;

Function cobrarConBanamex(var asientos : u_venta.array_asientos; li_vendidos : Integer; conTarjeta : Boolean; servidor : TSQLConnection) : Boolean; overload;
 var
  destino : lArray_asientos;
Begin
 cambiarDeEstructura(asientos, destino, li_vendidos);
 result := lcobrarConBanamex(destino, li_vendidos, conTarjeta, servidor);
 regresarAEstructuraPago(destino, asientos, li_vendidos);
End;


function ultimaOperacion : tUlimaOperacion;
// Manda a llamar al pinpad para saber cual fue su última operación registrada.
var
 dRespuestaUltima : TDictionary<string, string>;
 respuesta : tUlimaOperacion;
 valor : String;
Begin
// directorioActual := GetCurrentDir;
// SetCurrentDir(_DIRECTORIO);
 respuestaPinPad := sendMSG('TRANSACCION=estatus'+ '&TERMINAL=' + _PP_NOMBRE_TERMINAL);
 dRespuestaUltima := TDictionary<String, String>.Create;
 dRespuestaUltima := formatearMensaje(respuestaPinPad);

 dRespuestaUltima.TryGetValue(_PP_ESTATUS_TERMINAL, respuesta.estatus_terminal);
 dRespuestaUltima.TryGetValue(_PP_ESTATUS_TRANSACCION, respuesta.estatus_transaccion);
 dRespuestaUltima.TryGetValue(_PP_FECHA_TRANSACCION, respuesta.fecha_transaccion);
 dRespuestaUltima.TryGetValue(_PP_ID_TRANSACCION, respuesta.id_transaccion);
 dRespuestaUltima.TryGetValue(_PP_CODIGO_AUTORIZACION, respuesta.codigo_autorizacion);
 dRespuestaUltima.TryGetValue(_PP_MONTO, respuesta.monto);
 dRespuestaUltima.TryGetValue(_PP_REFERENCIA, respuesta.referencia);
 dRespuestaUltima.TryGetValue(_PP_TERMINAL, respuesta.terminal);

 Result := respuesta;
 dRespuestaUltima.Free;
// SetCurrentDir(directorioActual);

end;


function existeEstaOperacion(id_transaccion, codigo_autorizacion : string; servidor : TSQLConnection) : Boolean;
// Verifica si la transacción dada existe ya almacenada en la base de datos
// de las transacciones efectuadas.
var
 ssql : String;
 lQuery : TSQLQuery;
Begin
 lQuery := TSQLQuery.Create(nil);
 try
   lQuery.SQLConnection := servidor;
   ssql := 'SELECT ID_TRANSACCION FROM PDV_T_PAGO_PINPAD_BANAMEX WHERE ID_TRANSACCION = ' +
      QuotedStr(id_transaccion) +
      ' AND CODIGO_AUT = ' +
      QuotedStr(codigo_autorizacion) + ';';
   lQuery.SQL.Clear;
   lQuery.SQL.Add(ssql);
   lQuery.Open;
   Result :=  not lQuery.Eof;
   lQuery.Close;
 finally
   lQuery.Free;
 end;

end;

Function formatearMensaje(mensaje : String) : TDictionary<String, String>;
Const
 _DELIMITADOR = '&';
 _SEPARADOR = '=';
Var
 delta : Integer;
 dx : integer;
 ns : string;
 txt : String;
 id, valor : String;
 dicLocal : TDictionary<String, String>;
Begin
 delta := Length(_DELIMITADOR);
 txt := mensaje + _DELIMITADOR;
 dicLocal := TDictionary<String, String>.Create;
 while Length(txt) > 0 do begin
   dx := Pos(_DELIMITADOR, txt);
   ns := Copy(txt,0,dx-1);
   id := Copy(ns,0, pos(_SEPARADOR, ns)-1);
   valor := Copy(ns, pos(_SEPARADOR, ns)+1, MaxInt);
   if NOT dicLocal.ContainsKey(id) then
     dicLocal.Add(id, valor);
   txt := Copy(txt,dx+delta,MaxInt);
 end;
 result := dicLocal;
End;


Function probarEstatusPinPadBanamex : Boolean;
var
 dRespuesta : TDictionary<string, string>;
 valor : String;
Begin
// directorioActual := GetCurrentDir;
// SetCurrentDir(_DIRECTORIO);
 respuestaPinPad := sendMSG('LANG=sp&TRANSACCION=estatus'+ '&TERMINAL=' + _PP_NOMBRE_TERMINAL);
 dRespuesta := TDictionary<String, String>.Create;
 dRespuesta := formatearMensaje(respuestaPinPad);
 dRespuesta.TryGetValue(_PP_ESTATUS_TERMINAL, valor);
 result := valor = _PP_R_TERMINAL_OK;
// SetCurrentDir(directorioActual);
 dRespuesta.Free;
End;


Function referenciaDe(id_empleado, id_terminal : String; servidor : TSQLConnection) : String;
Var
 sp : TSQLStoredProc;
Begin
 result := 'SinReferncia';
 sp := TSQLStoredProc.Create(nil);
 try
   sp.SQLConnection := servidor;
   SP.close;
   sp.StoredProcName := 'PDV_PINPAD_BANAMEX_OBTENER_REFERENCIA';
   sp.Params.ParamByName('_ID_TERMINAL').AsString := id_terminal;
   sp.Params.ParamByName('_ID_EMPLEADO').AsString := id_empleado;
   sp.Open;
   sp.First;
   Result := sp.FieldByName('_ID').AsString;
   sp.Close;
 finally
   sp.Free;
 end;

End;


Function guardarTransaccionPinPadBanamex(id_terminal, id_empleado : String; boletos : Integer; tarjetaFisica : Boolean;  tipoOperacion : String; servidor : TSQLConnection) : String;
 Function valorDe(id : String) : String;
 Begin
   dRespuesta.TryGetValue(id, result);
 End;

Var
 sp : TSQLStoredProc;
 sTarjetaFisica : String;
Begin
 if tarjetaFisica then
   sTarjetaFisica := 'SI'
 else
   sTarjetaFisica := 'N0';

 sp := TSQLStoredProc.Create(nil);
 try
   sp.SQLConnection := servidor;
   sp.close;
   sp.StoredProcName := 'PDV_PINPAD_BANAMEX_REGISTRAR_COBRO';
   sp.Params.ParamByName('_ID_TERMINAL').AsString := id_terminal;
   sp.Params.ParamByName('_ID_EMPLEADO').AsString := id_empleado;
   sp.Params.ParamByName('_FECHA_TRANSACCION').AsString := valorDe(_PP_FECHA_TRANSACCION);
   sp.Params.ParamByName('_NUMERO_TARJETA').AsString := valorDe(_PP_NUMERO_TARJETA);
   sp.Params.ParamByName('_ID_TRANSACCION').AsString := valorDe(_PP_ID_TRANSACCION);
   sp.Params.ParamByName('_CODIGO_AUT').AsString := valorDe(_PP_CODIGO_AUTORIZACION);
   sp.Params.ParamByName('_MONTO').AsFloat := StrToFloat(valorDe(_PP_MONTO));
   sp.Params.ParamByName('_REFERENCIA').AsString := valorDe(_PP_REFERENCIA);
   sp.Params.ParamByName('_TERMINAL').AsString := valorDe(_PP_TERMINAL);
   sp.Params.ParamByName('_NATURALEZA_CONTABLE').AsString := valorDe(_PP_NATURALEZA_CONTABLE);
   // gs_tarjeta_usuario := valorDe(_PP_NATURALEZA_CONTABLE);
   sp.Params.ParamByName('_TARJETAHABIENTE').AsString := valorDe(_PP_TARJETAHABIENTE);
   sp.Params.ParamByName('_BOLETOS_VENDIDOS').AsInteger := boletos;
   sp.Params.ParamByName('_TIPO_OPERACION').AsString := tipoOperacion;
   sp.Params.ParamByName('_TARJETA_FISICA').AsString := sTarjetaFisica;
   sp.Open;
   sp.First;
   Result := sp.FieldByName('_ID_PAGO').AsString;
   sp.Close;
 finally
   sp.Free;
 end;
End;


Function boletosRelacionadosPinPadBanamex(id_pago : String; servidor : TSQLConnection) : Integer;
Var
 sp : TSQLStoredProc;
Begin
 result := 0;
 sp := TSQLStoredProc.Create(nil);
 try
   sp.SQLConnection := servidor;
   sp.close;
   sp.StoredProcName := 'PDV_PINPAD_BANAMEX_DATOS_DEL_PAGO';
   sp.Params.ParamByName('_ID_PAGO').AsString := id_pago;
   sp.Open;
   sp.First;
   Result := sp.FieldByName('BOLETOS_VENDIDOS').AsInteger;
   sp.Close;
 finally
   sp.Free;
 end;
End;


Function idPagoPinPadBanamex(trab_id : String; id_boleto : Integer; servidor : TSQLConnection) : String;
Var
 sp : TSQLStoredProc;
Begin
 result := '';
 sp := TSQLStoredProc.Create(nil);
 try
   sp.SQLConnection := servidor;
   sp.close;
   sp.StoredProcName := 'PDV_PINPAD_BANAMEX_ID_PAGO';
   sp.Params.ParamByName('_TRAB_ID').AsString := trab_id;
   sp.Params.ParamByName('_ID_BOLETO').AsInteger := id_boleto;
   sp.Open;
   sp.First;
   if not sp.Eof then
     Result := sp.FieldByName('ID_PAGO_PINPAD_BANAMEX').AsString;
   sp.Close;
 finally
   sp.Free;
 end;

End;



Function cancelarConBanamex(id_pago, empleado : String; monto_a_devolver :  Double; no_boletos_cancelados : Integer; servidor : TSQLConnection) : Boolean;
Var
 cadena : AnsiString;
 id_transaccion,
 referencia,
 tarjeta_fisica,
 sMonto_a_devolver,
 valor : String;
 monto : Double;
 boletos_vendidos : Integer;
 sp : TSQLStoredProc;
 id_terminal : String;
 conTarjeta : Boolean;
 fUltimaOperacion : tUlimaOperacion;
Begin
 result := False;
// directorioActual := GetCurrentDir;
// SetCurrentDir(_DIRECTORIO);
 id_terminal := gs_terminal;
 // Si un punto decimal no está presente en el valor, los últimos dos dígitos son considerados como decimales.
 sMonto_a_devolver := FloatToStrF(monto_a_devolver , ffFixed, 10,2);
 sp := TSQLStoredProc.Create(nil);
 try
   sp.SQLConnection := servidor;
   sp.close;
   sp.StoredProcName := 'PDV_PINPAD_BANAMEX_DATOS_DEL_PAGO';
   sp.Params.ParamByName('_ID_PAGO').AsString := id_pago;
   sp.Open;
   sp.First;

   id_transaccion := sp.FieldByName('ID_TRANSACCION').AsString;
   monto := sp.FieldByName('MONTO').AsInteger;
   referencia := sp.FieldByName('REFERENCIA').AsString;
   boletos_vendidos := sp.FieldByName('BOLETOS_VENDIDOS').AsInteger;
   tarjeta_fisica := sp.FieldByName('TARJETA_FISICA').AsString;
   sp.Close;
 finally
   sp.Free;
 end;

 if monto_a_devolver > monto then Begin
   result := False;
   exit;
 End;

  //* armado de la cadena de cancelación
 cadena := 'LANG=sp'; //Va en idioma español
 cadena := cadena + '&TRANSACCION=devolucion'; // Indica que es una devolucion
 cadena := cadena + '&MONTO=' + sMonto_a_devolver; // el monto a devolver
 cadena := cadena + '&TRANS_ORIGINAL=' + id_transaccion;
 cadena := cadena + '&IMPRIMIR_SALIDA=1'; // Intenta imprimir el voucher
 cadena := cadena + '&REFERENCIA=' + referencia; // Referencia0 MAX_BOL_VENDIDOS+1 * ID_CORTE
 cadena := cadena + '&VENDEDOR=' + empleado; //Referencia de hasta 20 caracteres clave del empleado.
 cadena := cadena + '&TERMINAL=' + _PP_NOMBRE_TERMINAL;
{
 cadena := cadena + '&MONEDA=' +'1'; // 1 = peso mexicano, 2 = us dollar
 cadena := cadena +'&MOTO=';
 if tarjeta_fisica = 'SI' then Begin // ingegracion MOTO
   cadena := cadena + '0'; // Disable
   conTarjeta := True;
 End else Begin
   cadena := cadena + '1';  // Enable
   conTarjeta := False;
 End;
}


 dRespuesta := TDictionary<String, String>.Create;
 try
   respuestaPinPad := sendMSG(cadena);
   dRespuesta := formatearMensaje(respuestaPinPad);
 except
   fUltimaOperacion :=  ultimaOperacion;
   if existeEstaOperacion(fUltimaOperacion.id_transaccion, fUltimaOperacion.codigo_autorizacion, servidor) then begin
     // no se efectuó la operación nueva, la última operación ya se encuentra en la base de datos
     Result := False;
     Exit;
   end else Begin
     // La operación es nueva
     if (fUltimaOperacion.estatus_transaccion = _PP_R_DEVOLUCION_ACEPTADA) and (fUltimaOperacion.referencia = referencia) then begin
       // Datos Reales de la última transacción
       dRespuesta.Add(_PP_ESTATUS_TERMINAL, fUltimaOperacion.estatus_terminal);
       dRespuesta.Add(_PP_ESTATUS_TRANSACCION, fUltimaOperacion.estatus_transaccion);
       dRespuesta.Add(_PP_FECHA_TRANSACCION, fUltimaOperacion.fecha_transaccion);
       dRespuesta.Add(_PP_ID_TRANSACCION, fUltimaOperacion.id_transaccion);
       dRespuesta.Add(_PP_CODIGO_AUTORIZACION, fUltimaOperacion.codigo_autorizacion);
       dRespuesta.Add(_PP_MONTO, fUltimaOperacion.monto);
       dRespuesta.Add(_PP_REFERENCIA, fUltimaOperacion.referencia);
       dRespuesta.Add(_PP_TERMINAL, fUltimaOperacion.terminal);

       // Los inventados porque son necesarios
       dRespuesta.Add(_PP_NUMERO_TARJETA, '*****');
       dRespuesta.Add(_PP_NATURALEZA_CONTABLE, 'S');
       dRespuesta.Add(_PP_TARJETAHABIENTE, 'SIN');
     end;
   End;
 end;


 dRespuesta := TDictionary<String, String>.Create;
 dRespuesta := formatearMensaje(respuestaPinPad);
 dRespuesta.TryGetValue(_PP_ESTATUS_TRANSACCION, valor);

 // Agrego esta línea (17-ene-2013 Salez) por si tiene error la cancelacion.
 //loguear(respuestaPinPad);


 if valor = _PP_R_DEVOLUCION_ACEPTADA then Begin
   id_pago := guardarTransaccionPinPadBanamex(id_terminal, empleado, no_boletos_cancelados, conTarjeta, _OPERACION_DEVOLUCION, servidor );
   result := True;
 end;


 dRespuesta.free;
// SetCurrentDir(directorioActual);
End;




function sendMSG(args : AnsiString) : AnsiString;
Var
 HTTP: TIdHTTP;
 Peticion: AnsiString;
 Buffer: AnsiString;
begin
 try
   HTTP := TIdHTTP.Create;
   http.ProtocolVersion := pv1_0;
   Peticion := _PP_SERVIDOR + args;
   loguear('Peticion : ' +  args); // Logueo la petición.
   Buffer := HTTP.Get(TIdURI.URLEncode(Peticion));
   loguear('Respuesta: ' +  Buffer); // Logueo la respuesta.
   result := Buffer;
   HTTP.Free;
 except
   on E: Exception do Begin
     loguear('Exception : ' +  e.Message); // Logueo la respuesta.
     Result := '';
   end;
 end;
end;



end.
