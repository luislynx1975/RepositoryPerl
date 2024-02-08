unit u_gral_venta;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    StdCtrls, DB,  comun, SysUtils, Grids, DateUtils, ExtCtrls,
    Graphics, Variants,Classes, maskUtils, Data.SqlExpr;
    function insertaBoleto(CONECTA : TSQLConnection; terminal, empleado, estatus, origen, destino, tarifa : String;
                            formaPago, taquilla : integer; tipoTarifa, corrida, fecha, pasajero : String;
                            asiento, ocupante : integer; fechaHora : string; ruta : integer; servicio, banamex, tc : string;
                            iva : Double; CoD : String) : integer;
    procedure insertaBoletoRemoto(CONECTA : TSQLConnection; terminal, empleado, estatus, origen, destino, tarifa : String;
                            formaPago, taquilla : integer; tipoTarifa, corrida, fecha, pasajero : String;
                            asiento, ocupante : integer; fechaHora : string; ruta : integer; servicio, banamex, tc : string;
                            iva : Double; CoD : String);
    function registraBoleto(CONECTA : TSQLConnection; terminal, empleado, estatus, origen, destino, tarifa : String;
                            formaPago, taquilla : integer; tipoTarifa, corrida, fecha, pasajero : String;
                            asiento, ocupante : integer; fechaHora : string; ruta : integer; servicio, banamex, tc : string;
                            iva : Double; CoD : String) : integer;
    procedure insertaBoletoServer(CONECTA : TSQLConnection;  STORE: TSQLStoredProc);
    procedure insertaBoletoAbierto(CONECTA : TSQLConnection; codigo : string);
    procedure consultaBoleto(idBoleto: integer; terminal, empleado: string; var STORE : TSQLStoredProc);
    function CadenaReturn(str_dato : String):String;


Const
    _SERVER_BOLETO_QUERY = 'INSERT INTO PDV_T_BOLETO(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, '+
                           ' ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, '+
                           ' ID_TAQUILLA, TIPO_TARIFA,   FECHA_HORA_BOLETO, ID_CORRIDA, '+
                           ' FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, TIPOSERVICIO, ID_RUTA, '+
                           ' ID_PAGO_PINPAD_BANAMEX, TC, IVA, TOTAL_IVA, ID_FORMA_PAGO_SUB) '+
                           'VALUES(%s,''%s'',''%s'',''%s'',''%s'',''%s'', %s, %s,%s,''%s'', ''%s'', ''%s'', '+
                           '  ''%s'', ''%s'', %s , %s, %s, %s, ''%s'',''%s'',''%s'',''%s'',''%s'')';

implementation



function CadenaReturn(str_dato : String):String;
var
    ls_str : string;
    li_len : integer;
    lc_char : char;
begin
    for li_len := 1 to length(str_dato) do begin
        lc_char := str_dato[li_len];
        ls_str := ls_str + lc_char;
    end;
    result := ls_str;
end;

function insertaBoleto(CONECTA : TSQLConnection; terminal, empleado, estatus, origen, destino, tarifa : String;
                            formaPago, taquilla : integer; tipoTarifa, corrida, fecha, pasajero : String;
                            asiento, ocupante : integer; fechaHora : string; ruta : integer; servicio, banamex, tc : string;
                            iva : Double; CoD : String) : integer;
var
    lq_qry : TSQLQuery;
    ls_qry : String;
    ga_datos : gga_parameters;
    li_idx :integer;
begin
    splitLine(fecha,' ',ga_datos, li_idx);
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONECTA;
    lq_qry.SQL.Add('SELECT PDV_FUNCTION_REGISTRA_BOLETO(:terminal, :empleado, :estatus, :origen, :destino, '+
                                                  ':tarifa, :formaPago, :taquilla, :tipoTarifa, :corrida, :fecha, '+
                                                  ':pasajero, :asiento, :ocupante, :fechaHora, :ruta, :servicio, :banamex, :tc, '+
                                                  ':iva, :CoD ) AS BOLETO ');
    lq_qry.Params[0].AsString := terminal;
    lq_qry.Params[1].AsString := empleado;
    lq_qry.Params[2].AsString := estatus;
    lq_qry.Params[3].AsString := origen;
    lq_qry.Params[4].AsString := destino;
    lq_qry.Params[5].AsString := tarifa;
    lq_qry.Params[6].AsInteger := formaPago;
    lq_qry.Params[7].AsInteger := taquilla;
    lq_qry.Params[8].AsString := tipoTarifa;
    lq_qry.Params[9].AsString := corrida;
    lq_qry.Params[10].AsString := ga_datos[0];
    lq_qry.Params[11].AsString := pasajero;
    lq_qry.Params[12].AsInteger := asiento;
    lq_qry.Params[13].AsInteger := ocupante;
    lq_qry.Params[14].AsString  := fechaHora;
    lq_qry.Params[15].AsInteger := ruta;
    lq_qry.Params[16].AsString  := servicio;
    lq_qry.Params[17].AsString  := banamex;
    lq_qry.Params[18].AsString  := tc;
    lq_qry.Params[19].AsFloat   := iva;
    lq_qry.Params[20].AsString  := CoD;
    lq_qry.open();
    result := lq_qry['BOLETO'];
    lq_qry.Free;
    lq_qry := nil;
end;


procedure insertaBoletoRemoto(CONECTA : TSQLConnection; terminal, empleado, estatus, origen, destino, tarifa : String;
                            formaPago, taquilla : integer; tipoTarifa, corrida, fecha, pasajero : String;
                            asiento, ocupante : integer; fechaHora : string; ruta : integer; servicio, banamex, tc : string;
                            iva : Double; CoD : String);
var
    lq_qry : TSQLQuery;
    ls_qry : String;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONECTA;
    lq_qry.SQL.Add('CALL PDV_STORE_REGISTRA_BOLETO_REMOTO(:terminal, :empleado, :estatus, :origen, :destino, '+
                                                  ':tarifa, :formaPago, :taquilla, :tipoTarifa, :corrida, :fecha, '+
                                                  ':pasajero, :asiento, :ocupante, :fechaHora, :ruta, :servicio, :banamex, :tc, '+
                                                  ':iva, :CoD )');
    lq_qry.Params[0].AsString := terminal;
    lq_qry.Params[1].AsString := empleado;
    lq_qry.Params[2].AsString := estatus;
    lq_qry.Params[3].AsString := origen;
    lq_qry.Params[4].AsString := destino;
    lq_qry.Params[5].AsString := tarifa;
    lq_qry.Params[6].AsInteger := formaPago;
    lq_qry.Params[7].AsInteger := taquilla;
    lq_qry.Params[8].AsString := tipoTarifa;
    lq_qry.Params[9].AsString := corrida;
    lq_qry.Params[10].AsString := fecha;
    lq_qry.Params[11].AsString := pasajero;
    lq_qry.Params[12].AsInteger := asiento;
    lq_qry.Params[13].AsInteger := ocupante;
    lq_qry.Params[14].AsString  := fechaHora;
    lq_qry.Params[15].AsInteger := ruta;
    lq_qry.Params[16].AsString  := servicio;
    lq_qry.Params[17].AsString  := banamex;
    lq_qry.Params[18].AsString  := tc;
    lq_qry.Params[19].AsFloat   := iva;
    lq_qry.Params[20].AsString  := CoD;
    lq_qry.ExecSQL();
    lq_qry.Free;
    lq_qry := nil;


end;



function registraBoleto(CONECTA : TSQLConnection; terminal, empleado, estatus, origen, destino, tarifa : String;
                        formaPago, taquilla : integer; tipoTarifa, corrida, fecha, pasajero : String;
                        asiento, ocupante : integer; fechaHora : string; ruta : integer; servicio, banamex, tc : string;
                        iva : Double; CoD : String) : integer;
var
    lq_qry : TSQLQuery;
    ls_qry : String;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONECTA;
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add('SELECT PDV_FUNCTION_REGISTRA_BOLETO(:terminal, :empleado, :estatus, :origen, :destino, '+
                                                  ':tarifa, :formaPago, :taquilla, :tipoTarifa, :corrida, :fecha, '+
                                                  ':pasajero, :asiento, :ocupante, :fechaHora, :ruta, :servicio, :banamex, :tc, '+
                                                  ':iva, :CoD )as TICKET');
    lq_qry.Params[0].AsString := terminal;
    lq_qry.Params[1].AsString := empleado;
    lq_qry.Params[2].AsString := estatus;
    lq_qry.Params[3].AsString := origen;
    lq_qry.Params[4].AsString := destino;
    lq_qry.Params[5].AsString := tarifa;
    lq_qry.Params[6].AsInteger := formaPago;
    lq_qry.Params[7].AsInteger := taquilla;
    lq_qry.Params[8].AsString := tipoTarifa;
    lq_qry.Params[9].AsString := corrida;
    lq_qry.Params[10].AsString := fecha;
    lq_qry.Params[11].AsString := pasajero;
    lq_qry.Params[12].AsInteger := asiento;
    lq_qry.Params[13].AsInteger := ocupante;
    lq_qry.Params[14].AsString  := fechaHora;
    lq_qry.Params[15].AsInteger := ruta;
    lq_qry.Params[16].AsString  := servicio;
    lq_qry.Params[17].AsString  := banamex;
    lq_qry.Params[18].AsString  := tc;
    lq_qry.Params[19].AsFloat   := iva;
    lq_qry.Params[20].AsString  := CoD;
    lq_qry.Open();
    Result := lq_qry['TICKET'];
    lq_qry.Free;
    lq_qry := nil;

end;



procedure consultaBoleto(idBoleto: integer; terminal, empleado: string; var STORE : TSQLStoredProc);
begin
    STORE.Close;
    STORE.StoredProcName := 'PDV_STORE_BOLETO_ABIERTO_IMPRIME';
    STORE.Params.ParamByName('IN_BOLETO').AsInteger := idBoleto;
    STORE.Params.ParamByName('IN_TRABID').AsString  := empleado;
    STORE.Params.ParamByName('IN_TERMINAL').AsString  := terminal;
    STORE.Open;
end;


procedure insertaBoletoServer(CONECTA : TSQLConnection;  STORE: TSQLStoredProc);
var
    ls_qry : string;
    lq_query : TSQLQuery;
begin
    lq_query := TSQLQuery.Create(NIL);
    lq_query.SQLConnection := CONECTA;
    ls_qry := format(_SERVER_BOLETO_QUERY,[
                      intToStr(STORE['ID_BOLETO']),STORE['ID_TERMINAL'],STORE['TRAB_ID'],'V',STORE['ORIGEN'],
                      STORE['DESTINO'], FloatToStr(STORE['TARIFA']),intToStr(STORE['ID_FORMA_PAGO']),
                      intToStr(STORE['ID_TAQUILLA']),STORE['TIPO_TARIFA'],
                      FormatDateTime('YYYY-MM-DD HH:nn.zz',STORE['FECHA_HORA_BOLETO']),
                      STORE['ID_CORRIDA'], FormatDateTime('YYYY-MM-DD',STORE['FECHA']),
                      STORE['NOMBRE_PASAJERO'], IntToStr(STORE['NO_ASIENTO']),
                      IntToStr(STORE['ID_OCUPANTE']), IntToStr(STORE['TIPOSERVICIO']),
                      IntToStr(STORE['ID_RUTA']), STORE['ID_PAGO_PINPAD_BANAMEX'],
                      STORE['TC'], STORE['IVA'], STORE['TOTAL_IVA'], STORE['ID_FORMA_PAGO_SUB'] ]);
    EjecutaSQL(ls_qry,lq_query,_SERVIDOR_CENTRAL);

    lq_query.Free;
end;



procedure insertaBoletoAbierto(CONECTA : TSQLConnection; codigo : string);
var
    lq_qry, lq_inserta : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_inserta := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONECTA;
    lq_inserta.SQLConnection := CONECTA;
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add('SELECT B.ID_BOLETO, B.TRAB_ID, B.ID_TERMINAL, B.FECHA_HORA_BOLETO, B.ID_CORRIDA,');
    lq_qry.SQL.Add('B.FECHA, B.TARIFA, B.ID_CORRIDA,');
    lq_qry.SQL.Add('ADDDATE(B.FECHA,INTERVAL 29 DAY)AS VIGENCIA, B.ORIGEN, B.DESTINO,');
    lq_qry.SQL.Add('(SELECT DESCRIPCION FROM SERVICIOS WHERE TIPOSERVICIO = B.TIPOSERVICIO)AS DESCRIPCION, B.TC');
    lq_qry.SQL.Add('FROM PDV_T_BOLETO B');
    lq_qry.SQL.Add('WHERE B.ID_CORRIDA = :codigo');
    lq_qry.Params[0].AsString := codigo;
    lq_qry.Open;
    with lq_qry do begin
      lq_qry.First;
      while not eof do begin
          lq_inserta.SQL.Clear;
          lq_inserta.SQL.Add('INSERT INTO PDV_T_REGISTRO_BOLETO_ABIERTO(ID_BOLETO, TRAB_ID, ID_TERMINAL,');
          lq_inserta.SQL.Add('FECHA_HORA_COMPRA, ID_CORRIDA, FECHA_CORRIDA, TARIFA, CODIGO_BOLETO,');
          lq_inserta.SQL.Add('FECHA_VIGENCIA, ORIGEN, DESTINO, SERVICIO, TC)');
          lq_inserta.SQL.Add('VALUES(:valor1, :valor2, :valor3, :valor4, :valor5, :valor6, :valor7, :valor8,');
          lq_inserta.SQL.Add(':valor9, :v10, :v11, :va12, :va13)');
          lq_inserta.Params[0].AsInteger := lq_qry['ID_BOLETO'];
          lq_inserta.Params[1].AsString  := lq_qry['TRAB_ID'];
          lq_inserta.Params[2].AsString  := lq_qry['ID_TERMINAL'];
          lq_inserta.Params[3].AsString  := FormatDateTime('YYYY-MM-DD HH:MM:zz', lq_qry['FECHA_HORA_BOLETO']);
          lq_inserta.Params[4].AsString  := lq_qry['ID_CORRIDA'];
          lq_inserta.Params[5].AsDate    := lq_qry['FECHA'];
          lq_inserta.Params[6].AsFloat   := lq_qry['TARIFA'];
          lq_inserta.Params[7].AsString  := lq_qry['ID_CORRIDA'];
          lq_inserta.Params[8].AsDate    := lq_qry['VIGENCIA'];
          lq_inserta.Params[9].AsString  := lq_qry['ORIGEN'];
          lq_inserta.Params[10].AsString := lq_qry['DESTINO'];
          lq_inserta.Params[11].AsString := lq_qry['DESCRIPCION'];
          lq_inserta.Params[12].AsString := lq_qry['TC'];
          lq_inserta.ExecSQL();
          lq_qry.Next;
      end;
    end;
    lq_qry.Free;
    lq_qry := nil;
    lq_inserta.Free;
end;

end.
