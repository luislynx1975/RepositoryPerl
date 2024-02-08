unit u_guias;

interface
{$WARNINGS OFF}
uses DMdb, lsCombobox, DB, SysUtils, Forms, comun, Printers, Winspool,
     variants, Data.SqlExpr;

Const
    _GUIA_OPERADOR = 'SELECT TRIM(TRAB_ID)AS TRAB_ID, (CONCAT(PATERNO,'' '',MATERNO,'' '',NOMBRES))AS NOMBRE FROM EMPLEADOS '+
                     'WHERE ID_SERVICIO_ACTUAL <> 0 ORDER BY 1';

    _GUIA_AUTOBUS  = 'SELECT A.ID_AUTOBUS, S.ABREVIACION '+
                     'FROM T_C_AUTOBUS A INNER JOIN SERVICIOS S ON A.ID_SERVICIO = S.TIPOSERVICIO ORDER BY 1';

    _GUIA_DE_VIAJE = 'INSERT INTO PDV_T_GUIA(ID_GUIA, ID_TERMINAL, FECHA, ID_CORRIDA, ID_DESTINO, NO_BUS, INGRESO, '+
                     ' ID_OPERADOR, TRAB_ID, TIPOSERVICIO, ID_RUTA, FECHA_HORA, OLLIN_FOLIO, OLLIN_TIPO_CUOTA, OLLIN_PROVEEDOR, '+
                     ' TIPO_SERVICIO_CEMO, FOLIO_CEMO, BOLETERA_FOLIO, HORA_CORRIDA, TIPO_CORRIDA) '+
                     'VALUES(%s,''%s'',''%s'',''%s'',''%s'', %s , %s,''%s'',''%s'',%s,%s,NOW(),  %s, %s, %s, ''%s'', %s, ''%s'', ''%s'', ''%s'')';

    _GUIA_DE_VIAJE_BORRAR = 'DELETE FROM PDV_T_GUIA WHERE ID_GUIA = %s AND ID_TERMINAL = ''%s'' ';


    _GUIA_DE_VIAJE_SERVER = 'INSERT INTO PDV_T_GUIA(ID_GUIA, ID_TERMINAL, FECHA, ID_CORRIDA, ID_DESTINO, NO_BUS, INGRESO, '+
                     ' ID_OPERADOR, TRAB_ID, TIPOSERVICIO, ID_RUTA, FECHA_HORA) '+
                     'VALUES(%s,''%s'',''%s'',''%s'',''%s'', %s , %s,''%s'',''%s'',%s,%s,''%s'')';

    _GUIA_UPDATE_REIMPRESION = 'UPDATE PDV_T_GUIA SET  NO_BUS = %s, ID_OPERADOR = ''%s'', TRAB_ID = ''%s'', ID_DESTINO = ''%s'', '+
                               'INGRESO = %s, BOLETERA_FOLIO = %s, REIMPRESION = 1 '+
                               'WHERE ID_GUIA = %s  AND FECHA = ''%s'' AND ID_CORRIDA = ''%s'' AND ID_TERMINAL = ''%s'' ';

    _GUIA_CLAVE_SELECCION_REIMPRESION = 'SELECT G.ID_GUIA FROM PDV_T_GUIA G WHERE G.ID_CORRIDA = ''%s'' AND G.FECHA = ''%s'' ';
//MODIFICAR
    _GUIA_EXISTE_TABLA = 'SELECT (COALESCE(COUNT(*),0)) AS EXISTE '+
                         'FROM PDV_T_GUIA G INNER JOIN PDV_T_CORRIDA C ON G.ID_CORRIDA = C.ID_CORRIDA AND G.FECHA = C.FECHA  '+
                         'WHERE G.FECHA = ''%s'' AND G.ID_CORRIDA = ''%s'' '+
                         ' AND C.HORA = CAST(''%s'' AS TIME) AND G.ID_TERMINAL = ''%s''';

    _GUIA_EXISTENTE = 'SELECT ID_GUIA, ID_CORRIDA, ID_TERMINAL, FECHA, FECHA_HORA FROM PDV_T_GUIA '+
                      'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_TERMINAL = ''%s'' ';
    _GUIA_BORRAR_EXISTENTE = 'DELETE FROM PDV_T_GUIA WHERE ID_GUIA = %s';
    _GUIA_BORRAR_EXISTENTE_SERVER = 'DELETE FROM PDV_T_GUIA WHERE ID_GUIA = %s AND ID_TERMINAL = ''%s'' AND FECHA = ''%s'' ';
    _GUIA_SERVICIOID = 'SELECT TIPOSERVICIO FROM SERVICIOS WHERE ABREVIACION = ''%s''';
//(COALESCE(SUM(TARIFA),0) - COALESCE(SUM(TOTAL_IVA),0))AS INGRESO
//    _GUIA_INGRESO_BOLETO = 'SELECT (COALESCE(SUM(TARIFA),0))AS INGRESO FROM PDV_T_BOLETO '+
    _GUIA_INGRESO_BOLETO = 'SELECT (COALESCE(SUM(TARIFA),0) - COALESCE(SUM(TOTAL_IVA),0))AS INGRESO FROM PDV_T_BOLETO '+
                           'WHERE ID_CORRIDA = ''%s''  AND FECHA = ''%s'' AND '+
                           ' ESTATUS = ''V''  AND ID_TERMINAL = ''%s''  ';
    _GUIA_NOW = 'SELECT (NOW())AS FECHA';

    _GUIA_UPDATE_CORRIDA = 'UPDATE PDV_T_CORRIDA_D SET ESTATUS = ''%s'' '+
                           'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_TERMINAL = ''%s'' AND '+
                           'HORA = ''%s''';


    _GUIA_UPDATE_CORRIDA_VACIO = 'UPDATE PDV_T_CORRIDA_D SET ESTATUS = ''V'' '+
                           'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_TERMINAL = ''%s'' AND '+
                           'HORA = ''%s''';

    _GUIA_AUTOBUS_CORRIDA = 'UPDATE PDV_T_CORRIDA SET NO_BUS = %s '+
                            'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND HORA = CAST(''%s'' AS TIME) ';

    _AUTOBUS_CORRIDA_MASTER = 'UPDATE PDV_T_CORRIDA SET NO_BUS = %s '+
                            'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s''  ';


    _GUIA_TARJETA = 'SELECT G.ID_GUIA, E.TRAB_ID, G.BOLETERA_FOLIO, TRIM(E.TRAB_ID) AS CONDUCTOR, (CONCAT(E.TRAB_ID,'' '',E.PATERNO,'' '',E.MATERNO,'' '',E.NOMBRES))AS OPERADOR, '+
                    '  G.ID_RUTA, TRIM(G.ID_CORRIDA) AS ID_CORRIDA, '+
                    '  (CONCAT((SELECT T.DESCRIPCION '+
                    '          FROM T_C_TERMINAL T '+
                    '          WHERE T.ID_TERMINAL = R.ORIGEN ),'' - '', '+
                    '          (SELECT T.DESCRIPCION '+
                    '                    FROM T_C_TERMINAL T '+
                    '                    WHERE T.ID_TERMINAL = R.DESTINO ) '+
                    '  ))AS RUTA, TRIM(G.NO_BUS) AS NO_BUS, C.HORA, (CAST(G.FECHA_HORA AS TIME))AS SALIDA, '+
                    '(SELECT T.ID_TERMINAL FROM T_C_TERMINAL T WHERE T.ID_TERMINAL = R.ORIGEN) AS ORIGEN, '+
                    '(SELECT T.ID_TERMINAL FROM T_C_TERMINAL T WHERE T.ID_TERMINAL = R.DESTINO ) AS DESTINO, C.ID_CORRIDA, '+
                    '(SELECT CONCAT(CREADO_POR,'' '', EM.PATERNO,'' '',EM.MATERNO,'' '',EM.NOMBRES) FROM PDV_T_CORRIDA CO, EMPLEADOS EM '+
                    ' WHERE CO.ID_CORRIDA = C.ID_CORRIDA AND CO.FECHA = C.FECHA AND EM.TRAB_ID = CO.CREADO_POR)AS CREADO, S.DESCRIPCION AS SERVICIO, '+
                    ' CURRENT_TIME AS  AHORA, C.ESTATUS '+
                    'FROM PDV_T_GUIA G INNER JOIN EMPLEADOS E ON E.TRAB_ID = G.ID_OPERADOR '+
                    '                  INNER JOIN T_C_RUTA R ON R.ID_RUTA = G.ID_RUTA '+
                    '                  INNER JOIN PDV_T_CORRIDA_D C ON (C.ID_CORRIDA = G.ID_CORRIDA AND C.FECHA = G.FECHA) '+
                    '                  INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = G.TIPOSERVICIO '+
                    'WHERE G.ID_GUIA = ''%s'' AND C.ID_CORRIDA = ''%s'' AND G.FECHA = ''%s''  AND HORA =   CAST(''%s''  AS TIME)';

    _GUIA_QUIEN_GENERA = 'SELECT PATERNO, MATERNO, NOMBRES FROM EMPLEADOS WHERE TRAB_ID = ''%s'' ';

    _GUIA_EXISTE  = 'SELECT COUNT(ID_GUIA) FROM PDV_T_GUIA '+
                    'WHERE FECHA = ''%s'' AND ID_CORRIDA = ''%s'' AND ID_TERMINAL = ''%s'' ';

    _GUIA_ID_GUIA = 'SELECT ID_GUIA FROM PDV_T_GUIA '+
                    'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_TERMINAL = ''%s'' AND ID_RUTA = %d ';


    _GUIA_DESC_ENCABEZADO = 'SELECT  DISTINCT(DESCUENTO), CASE DESCUENTO  WHEN 0 THEN 100  ELSE  DESCUENTO END AS DESCUENTO1 FROM PDV_C_OCUPANTE O ORDER BY 2 DESC';

    _GUIA_CUENTA_BOLETOS = 'SELECT COUNT(*)AS TOTAL, ROUND(CASE O.DESCUENTO '+
                           ' WHEN 0 THEN 100 '+
                           ' WHEN 100 THEN 0 '+
                           'ELSE  O.DESCUENTO END) AS DESCUENTO, B.DESTINO '+
                           'FROM PDV_T_BOLETO B LEFT JOIN PDV_C_OCUPANTE O ON O.ID_OCUPANTE = B.ID_OCUPANTE '+
                           'INNER JOIN PDV_C_FORMA_PAGO P ON B.ID_FORMA_PAGO = P.ID_FORMA_PAGO '+
                           'WHERE B.FECHA = ''%s'' AND B.ID_CORRIDA = ''%s'' AND B.ESTATUS = ''V''   '+
                           'GROUP BY DESCUENTO,B.DESTINO ORDER BY DESTINO';
    _GUIA_CUENTA_PASES = 'SELECT (COUNT(B.ID_OCUPANTE))AS TOTAL '+
                         'FROM PDV_T_BOLETO B INNER JOIN PDV_T_ASIENTO A ON B.ID_TERMINAL = A.ORIGEN AND '+
                         '                                                  B.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE) AND '+
                         '                                                  B.ID_CORRIDA = A.ID_CORRIDA AND '+
                         '                                                  B.NO_ASIENTO = A.NO_ASIENTO '+
                         '                    INNER JOIN PDV_C_OCUPANTE O ON O.ID_OCUPANTE = B.ID_OCUPANTE '+
                         '                    INNER JOIN PDV_C_FORMA_PAGO P ON P.ID_FORMA_PAGO = B.ID_FORMA_PAGO '+
                         'WHERE B.FECHA = ''%s'' AND B.ID_CORRIDA = ''%s'' AND P.DOCUMENTO = ''T''  AND B.ESTATUS = ''V'' ';
    _GUAI_DETALLE_PASAJERO = 'SELECT (COUNT(B.ID_OCUPANTE))AS TOTAL,  O.ABREVIACION '+
                          'FROM PDV_T_BOLETO B INNER JOIN PDV_T_ASIENTO A ON B.ID_TERMINAL = A.ORIGEN AND '+
                          '                                                  B.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE) AND '+
                          '                                                  B.ID_CORRIDA = A.ID_CORRIDA AND '+
                          '                                                  B.NO_ASIENTO = A.NO_ASIENTO '+
                          '                    INNER JOIN PDV_C_OCUPANTE O ON O.ID_OCUPANTE = B.ID_OCUPANTE '+
                          'WHERE B.FECHA = ''%s'' AND B.ID_CORRIDA = ''%s'' AND B.ESTATUS = ''V'' '+
                          'GROUP BY  B.ID_OCUPANTE ';
    _GUIA_BUS_OPERADOR = 'SELECT NOBUS, TRIM(OPERADOR)AS OPERADOR FROM PDV_C_GUIA_PRECAPTURA WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND DESTINO = ''%s'' ';

    _GUIA_PRECAPTURA_NUEVO = 'INSERT INTO PDV_C_GUIA_PRECAPTURA(ID_CORRIDA, FECHA, DESTINO, ID_RUTA, NOBUS, OPERADOR) '+
                             'VALUES(''%s'', ''%s'', ''%s'', %s, %s, TRIM(''%s''))';
    _GUIA_CAPTURA_ESPECIFICA = 'DELETE FROM PDV_C_GUIA_PRECAPTURA WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' ';

    _GUIA_BORRAR_CAPTURA = 'DELETE FROM PDV_C_GUIA_PRECAPTURA WHERE FECHA < DATE_SUB( CURRENT_DATE(), INTERVAL 2 DAY )';

    _GUIA_PIE_GUIA_IMPRIME = 'SELECT S.DESCRIPCION, (CURRENT_DATE)AS DIA, '+
                             '(SELECT DESCRIPCION FROM T_C_TERMINAL T WHERE ID_TERMINAL = ''%s'')AS LUGAR '+
                             'FROM PDV_T_CORRIDA C INNER JOIN SERVICIOS S ON C.TIPOSERVICIO = S.TIPOSERVICIO '+
                             'WHERE FECHA = ''%s'' AND ID_CORRIDA = ''%s'' ';
    _GUIA_PROMOTOR = 'SELECT CONCAT(PATERNO,'' '',NOMBRES)AS NOMBRE '+
                     'FROM PDV_C_USUARIO U INNER JOIN EMPLEADOS E ON U.TRAB_ID = E.TRAB_ID '+
                     'WHERE E.TRAB_ID = ''%s'' ';
    _GUIA_REIMPRESION = 'SELECT ID_GUIA,ID_TERMINAL,FECHA,ID_CORRIDA,ID_DESTINO, '+
                        'NO_BUS,INGRESO,ID_OPERADOR,TRAB_ID,TIPOSERVICIO,ID_RUTA,FECHA_HORA '+
                        'FROM PDV_T_GUIA '+
                        'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s''  ';
    _GUIA_TOTAL_DESTINO = 'SELECT (COUNT(DESTINO))AS TOTAL,DESTINO, T.DESCRIPCION FROM PDV_T_BOLETO B INNER JOIN T_C_TERMINAL T ON B.DESTINO = T.ID_TERMINAL '+
                          'WHERE B.FECHA = ''%s'' AND B.ID_CORRIDA = ''%s'' AND B.ESTATUS = ''V'' '+
                          'GROUP BY DESTINO';

    _GUIA_UPDATE_REIMPRIME = 'SELECT ID_GUIA, NO_BUS,ID_OPERADOR,TIPOSERVICIO '+
                             'FROM PDV_T_GUIA '+
                             'WHERE ID_TERMINAL = ''%s'' AND ID_DESTINO = ''%s'' AND '+
                             ' ID_CORRIDA = ''%s'' AND FECHA = ''%s'' ';

    _GUIA_ITHACA_DESCENSO = 'SELECT  DESTINO, (COUNT(*)) AS TOTAL FROM PDV_T_BOLETO '+
                            'WHERE ID_CORRIDA = ''%s'' AND ESTATUS = ''V'' AND FECHA = ''%s'' '+
                            'GROUP BY DESTINO ';

    _GUIA_DETALLE_DESCENSOS = 'SELECT  DESTINO, (SELECT COUNT(*) FROM PDV_T_BOLETO WHERE  FECHA = B.FECHA AND ID_CORRIDA = B.ID_CORRIDA AND ESTATUS = B.ESTATUS AND DESTINO = B.DESTINO)AS TOTAL, '+
                      '(SELECT COUNT(*) FROM PDV_T_BOLETO WHERE ID_TERMINAL NOT IN (''MOV'',''WEB'') AND FECHA = B.FECHA AND ID_CORRIDA = B.ID_CORRIDA AND ESTATUS = B.ESTATUS AND DESTINO = B.DESTINO)AS TAQUILLA, '+
                      '(SELECT COUNT(*) FROM PDV_T_BOLETO WHERE ID_TERMINAL IN (''WEB'') AND FECHA = B.FECHA AND ID_CORRIDA = B.ID_CORRIDA AND ESTATUS = B.ESTATUS AND DESTINO = B.DESTINO)AS WEB, '+
                      '(SELECT COUNT(ID_TERMINAL) FROM PDV_T_BOLETO WHERE ID_TERMINAL = ''MOV'' AND FECHA = B.FECHA AND ID_CORRIDA = B.ID_CORRIDA AND ESTATUS = B.ESTATUS AND DESTINO = B.DESTINO) AS MOV '+
                      'FROM PDV_T_BOLETO B '+
                      'WHERE ID_CORRIDA = ''%s'' AND ESTATUS = ''V'' AND FECHA = ''%s'' '+
                      'GROUP BY DESTINO';

    _GUIA_ITHACA_ENCABEZADO = 'SELECT DISTINCT(O.DESCUENTO)AS DESCUENTO '+
                              'FROM PDV_C_OCUPANTE O INNER JOIN PDV_T_BOLETO B ON O. ID_OCUPANTE = B.ID_OCUPANTE '+
                              'WHERE B.ID_CORRIDA = ''%s'' AND B.FECHA = ''%s'' ';

   _GUIA_ITHACA_TARIFAS   = 'SELECT  B.DESTINO, O.ABREVIACION, (COUNT(*)) AS TOTAL '+
                            'FROM PDV_T_BOLETO B INNER JOIN PDV_C_OCUPANTE O ON B.ID_OCUPANTE = O.ID_OCUPANTE '+
                            'WHERE B.ID_CORRIDA = ''%s'' AND B.ESTATUS = ''V'' AND B.FECHA = ''%s'' '+
                            'GROUP BY O.ABREVIACION, B.DESTINO ORDER BY B.DESTINO, O.ABREVIACION ';

    _GUIA_OCUPANTE_DETALLE = 'SELECT CONCAT( O.ABREVIACION , "-" , ROUND( O.DESCUENTO) )AS TARIFAS FROM PDV_C_OCUPANTE O';

    _OLLIN_PROVEEDOR = 'SELECT IDENTIFICADOR, NOMBRE FROM PDV_C_PROVEEDOR_CUOTA WHERE FECHA_BAJA IS NULL';

{    _OLLIN_CUOTAS = 'SELECT PC.TIPO_CUOTA, CONCAT(C.NOMBRE,"-",C.EMPRESA)AS NOMBRE '+
                    'FROM PDV_C_PROVEEDOR_TIPO_CUOTA PC INNER JOIN PDV_C_TIPO_CUOTA C ON PC.TIPO_CUOTA = C.IDENTIFICADOR '+
                    'WHERE C.FECHA_BAJA IS NULL AND C.IDENTIFICADOR = %s';}
    _OLLIN_CUOTAS = 'Select TC.IDENTIFICADOR, CONCAT(TC.NOMBRE ,'' '', TC.EMPRESA )as NOMBRE '+
                    'from PDV_C_PROVEEDOR_TIPO_CUOTA as PTC '+
                    'join PDV_C_TIPO_CUOTA as TC on(TC.identificador=PTC.TIPO_CUOTA) '+
                    'where PTC.identificador = %s';

    _VERIFICA_VENTA_SGUIA = 'SELECT DISTINCT(B.ID_CORRIDA), B.ID_TERMINAL, B.FECHA, B.DESTINO, SUM(B.TARIFA)AS INGRESO, B.TIPOSERVICIO, B.ID_RUTA, D.HORA '+
                    'FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_BOLETO B ON D.ID_CORRIDA = B.ID_CORRIDA AND '+
										' D.ID_TERMINAL = B.ID_TERMINAL AND D.FECHA = B.FECHA '+
                    'WHERE D.FECHA BETWEEN (SELECT DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY)) AND CURRENT_DATE() AND D.ESTATUS = ''A'' '+
                    'HORA <  DATE_FORMAT( DATE_SUB( CURRENT_TIMESTAMP(),INTERVAL (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 26) HOUR_MINUTE), ''%H:%i:%S'') '+
                    'GROUP BY B.ID_CORRIDA, B.ID_TERMINAL '+
                    'ORDER BY D.FECHA LIMIT 25';

    _CODIGO_BARS = 'SELECT C.FECHA, C.HORA, C.ID_TIPO_AUTOBUS, C.TIPOSERVICIO, C.ID_RUTA, C.ID_CORRIDA '+
                   'FROM PDV_T_CORRIDA C '+
                   'WHERE C.ID_CORRIDA = ''%s'' AND FECHA = ''%s'' ';

    _CODE_BARS_LINEA = 'SELECT ID_TERMINAL, SENTENCIA FROM PDV_T_QUERY WHERE SENTENCIA LIKE "%s" AND SENTENCIA LIKE "%s" ';

    _CODE_BARS_DETALLE = 'SELECT SENTENCIA FROM PDV_T_QUERY WHERE (SENTENCIA LIKE "%s" AND SENTENCIA LIKE "%s") AND ID_TERMINAL = "%s"';

    procedure LlenarComboTarjeta(lpq_query : TSQLQuery; combo : TlsComboBox);
    procedure generaGuiaViaje(guia, corrida, fecha, hora : String; impresion : integer; terminal, user : string);
    procedure escribeTarjetaEncabezado(qry : TSQLQuery; li_opcion : integer; fecha,terminal, quien : string);
    procedure escribeTarjetaCuerpo(qry : TSQLQuery);
    function Detalle(qry :  TSQLQuery; dia, corrida : String) : integer;
    procedure escribeOcupante(qry : TSQLQuery);
    procedure escribeTarjetaPie(terminal,fecha,corrida,trabid : string);
    function seEncuentra(destino : string) : integer;
    function forza(cadena:string;no:integer):string;
    function espacios(no:integer):string;
    function separaCadena(var cadena : String; tamano : integer) : string;
    function remplazaChar(cadena : string; del : char) : string;
    function quitaEspacios(cadena : string) : string;
    function getQuienGenera(usuario : string) : string;

var
    li_existe_tabla : integer;
    gi_parametro_13 : integer;
    ls_OPOS : string;

implementation

uses u_ithaca_print, u_ToshibaMini_print, u_impresion;

var
    F : TextFile;
    array_descuento : array[1..10] of string;
    detalle_tarjeta : array[1..20,1..20] of string;
    li_conta_lineas, li_lineas_rows, li_ultimo : integer;
    ls_linea_total : string;

procedure LlenarComboTarjeta(lpq_query : TSQLQuery; combo : TlsComboBox);
var
    ls_primer_dato, ls_complemento : string;
    li_lon  : Integer;
begin
    combo.Clear;
    with lpq_query do begin
        First;
        while not EoF do begin
            if Length(lpq_query.Fields[0].AsString) < 10 then begin //se ajusta para que se vea uniforme
                ls_primer_dato := lpq_query.Fields[0].AsString;
                for li_lon := Length(lpq_query.Fields[0].AsString) to 8 do
                    ls_complemento := ls_complemento + ' ';

                ls_primer_dato :=  ls_primer_dato + ls_complemento;
                ls_complemento := '';
            end;
            combo.Add(ls_primer_dato+'   '+lpq_query.Fields[1].AsString, lpq_query.Fields[0].AsString);
//            combo.Add(lpq_query.Fields[1].AsString, lpq_query.Fields[0].AsString);
            Next;
        end;
    end;
end;


function forza(cadena:string;no:integer):string;
begin
  if length(cadena) > no then
  forza := copy(cadena,1,no)
  else
  forza := cadena + espacios(no - length(cadena));
end;


function espacios(no:integer):string;
var
  temp : string;
  x : integer;
begin
  temp := '';
  for x := 1 to no do
    temp := temp + ' ';
  result := temp;
end;

function separaCadena(var cadena : String; tamano : integer) : string;
var
    li_idx : integer;
    ls_out : String;
    lc_char : Char;
begin
    for li_idx := 1 to tamano do begin
        lc_char := cadena[li_idx];
        ls_out := ls_out + lc_char;
    end;
    cadena := Copy(cadena, tamano + 1, length(cadena) );
    result := ls_out;
end;




function remplazaChar(cadena : string; del : char) : string;
var
    li_idx : integer;
    lc_char : Char;
    ls_out : string;
begin
    for li_idx := 1 to length(cadena) do begin
        lc_char := cadena[li_idx];
        if lc_char = del then begin
            lc_char := '-';
        end;
        ls_out := ls_out + lc_char;
    end;
    result := ls_out;
end;

function quitaEspacios(cadena : string) : string;
var
    li_ctrl : integer;
    lc_char : Char;
    ls_out  : String;
begin
    for li_ctrl := 1 to length(cadena) do begin
        lc_char := cadena[li_ctrl];
        if lc_char <> ' ' then
            ls_out := ls_out + lc_char;
    end;
    Result := ls_out;
end;


procedure escribeTarjetaEncabezado(qry : TSQLQuery; li_opcion : integer; fecha, terminal, quien : string);
var
    ls_dato, ls_bus, ls_creado : string;
    ls_hora : Variant;
begin
  with qry do begin
      First;
      Writeln(F,'');
      Writeln(F, espacios(28)+ forza('GRUPO PULLMAN DE MORELOS',24) );
      if (qry['ESTATUS'] = 'V') then
          ls_creado := 'Guía de vacío creado por : ' + qry['CREADO'];
      if li_opcion = 1 then
          Writeln(F,espacios(18)+ forza('Rimpresion Guía De Víaje (MERCURIO)',24))
      else
          Writeln(F,espacios(19)+forza('Impresion Guía De Víaje (MERCURIO)',23));

      Writeln(F,espacios(10)+forza(ls_creado,100));

      ls_dato := IntToStr(qry['ID_GUIA']);
      ls_hora :=  copy(qry['HORA'],1,5);
      ls_bus  := IntToStr(qry['NO_BUS']);
      Writeln(F,'Folío de Guia : '+ ls_dato+ espacios(5)+'Hora Salida : ' +
                  FormatDateTime('HH:nn',qry['HORA'])+'/'+ FormatDateTime('HH:nn',qry['AHORA'])+espacios(5)+
                  'Autobus : ' + ls_bus);
      Writeln(F,'Clave Terminal : '+gs_terminal+espacios(5)+ 'Conductor : '+qry['OPERADOR'] + ' Boletera : ' + qry['BOLETERA_FOLIO']);
      ls_dato := IntToStr(qry['ID_RUTA']);
      Writeln(F,'Clave Ruta : ' + ls_dato+ espacios(5)+ ' Ruta : ' + qry['RUTA'] +'  Servicio : '+ qry['SERVICIO'] + '  Corrida : ' + qry['ID_CORRIDA']);
      Writeln(F,'Lugar y Fecha : '+ terminal +' ' +fecha );
      Writeln(F,quien);
  end;
end;


procedure escribeTarjetaCuerpo(qry : TSQLQuery);
var
    ls_str : string;
    li_lon, li_str : integer;
    li_espacios, li_interno, li_array : integer;
    ls_linea : string;
begin
    with qry do begin
        First;
        li_lineas_rows := 1;
        qry.First;
        while  not qry.Eof do begin
              inc(li_lineas_rows);
              qry.next;
        end;
        inc(li_lineas_rows);
        li_espacios :=  8 + ((70 div li_lineas_rows)) ;
        li_interno := 1;
        li_array := 1;
        array_descuento[li_array] := 'Destino';
        inc(li_array);
        qry.First;
        while  not qry.EoF do begin
            if li_interno = 1 then begin
                ls_str := ls_str + espacios(((70 div li_lineas_rows))) + forza(IntToStr(qry['DESCUENTO1'])+'%',5);
                ls_linea := ls_linea + espacios(((70 div li_lineas_rows))) + '-----';
                array_descuento[li_array] := IntToStr(qry['DESCUENTO1']);
                inc(li_interno);
                inc(li_array);
            end else begin
                ls_str := ls_str + espacios(((70 div li_lineas_rows))) + forza(IntToStr(qry['DESCUENTO1'])+'%',5);
                array_descuento[li_array] := IntToStr(qry['DESCUENTO1']);
                ls_linea := ls_linea + espacios((70 div li_lineas_rows)) + '-----';
                inc(li_array);
            end;
            qry.next;
        end;
        array_descuento[9] := 'Pases';
        inc(li_array);
        array_descuento[10] := 'Total';
        ls_str := 'Destino ' + ls_str + espacios(4)+ 'Pases'+ espacios(5)+'Total';
        ls_linea := '------- ' + ls_linea + espacios(4)+ '-----'+espacios(5)+'-----';
    end;
    Writeln(F,ls_str);
    Writeln(F,ls_linea);
    ls_linea_total := ls_linea;
    li_conta_lineas := 11;//ultima que tenemos registro ahora sera dinamica
end;


function seEncuentra(destino : string) : integer;
var
    li_row, li_col :integer;
    lb_ok : Boolean;
begin
    lb_ok := False;
    for li_row := 1 to 10 do begin
        if detalle_tarjeta[li_row,1] = destino then begin
            Result := li_row;
            lb_ok := True;
            break;
        end;
    end;
   if not lb_ok  then begin
        for li_row := 1 to 10 do begin
            if length(detalle_tarjeta[li_row,1]) = 0 then begin
                Result := li_row;
                lb_ok := True;
                break;
            end;
        end;
       if not lb_ok  then
          li_row := 1;
       detalle_tarjeta[li_row,1] := destino;
       li_col := li_row;
   end else
            li_col := li_row;
   Result :=li_col;
end;



function Detalle(qry :  TSQLQuery; dia, corrida : String) : integer;
var
    ls_str : String;
    li_fila, li_col, li_pases, li_total : integer;
    lb_ok_col : boolean;
begin
    for li_fila := 1 to 10 do begin
       for li_col := 1 to 10 do begin
          detalle_tarjeta[li_fila,li_col] := '';
       end;
    end;

    with qry do begin
        First;
        while not Eof do begin
            li_fila := seEncuentra(qry['DESTINO']);
            for li_col := 2 to 8 do begin
                if length(array_descuento[li_col]) > 0 then  begin
                    if array_descuento[li_col] = qry['DESCUENTO'] then begin
                      detalle_tarjeta[li_fila,li_col] := qry['TOTAL'];
                    end else begin
                            if length(detalle_tarjeta[li_fila,li_col]) = 0 then
                                detalle_tarjeta[li_fila,li_col] := '0';
                    end;
                end;
            end;
            inc(li_fila);
            next;
        end;
    end;//fin
    for li_fila := 1 to 10 do begin
        li_total := 0;
        li_pases := 0;
        if length(Detalle_tarjeta[li_fila,1]) > 0 then begin
            for li_col := 2 to 8 do begin
                if Length(Detalle_tarjeta[li_fila,li_col]) > 0 then begin
                    li_total := li_total + StrToInt(Detalle_tarjeta[li_fila,li_col]);
                    if li_col > 2 then
                        li_pases := li_pases + StrToInt(Detalle_tarjeta[li_fila,li_col]);
                end;
            end;
            detalle_tarjeta[li_fila,9] := IntToStr(li_pases);
            detalle_tarjeta[li_fila,10] := IntToStr(li_total);
            li_ultimo := li_fila + 1;
        end;
    end;
    for li_col := 2 to 10 do begin
        li_total := 0;
        lb_ok_col := false;
        for li_fila := 1 to 10 do begin
            if length(detalle_tarjeta[li_fila,li_col])  > 0 then begin
                li_total := li_total + StrToInt(detalle_tarjeta[li_fila,li_col]);
                lb_ok_col := true;
            end;
        end;
        if lb_ok_col then begin
            detalle_tarjeta[li_ultimo,1] := 'TOTALES';
            detalle_tarjeta[li_ultimo,li_col] := IntToStr(li_total);
        end;
    end;
    for li_fila := 1 to li_ultimo - 1 do begin
        ls_str := '';
        for li_col := 1 to 8 do begin
            if length(detalle_tarjeta[li_fila,li_col]) > 0 then begin
                if li_col = 1 then begin
                      ls_str := ls_str + forza(detalle_tarjeta[li_fila,li_col],5) + espacios(((70 div li_lineas_rows)) + 5) ;
                end else
                      ls_str := ls_str + forza(detalle_tarjeta[li_fila,li_col],5) + espacios(((70 div li_lineas_rows))) ;
            end;
        end;
        ls_str := Copy(ls_str,1,(length(ls_str) - (70 div li_lineas_rows) ));
        ls_str := ls_str + espacios(4)+ forza(detalle_tarjeta[li_fila,9],5)+espacios(4)+ forza(detalle_tarjeta[li_fila,10],5);
        Writeln(F,ls_str);
    end;
    Result := li_ultimo;
end;



procedure escribeOcupante(qry : TSQLQuery);
var
    ls_str : string;
    li_fila, li_col : integer;
begin
    with qry do begin
        First;
        ls_str := espacios(20);
        while not Eof do begin
            ls_str := ls_str + qry['ABREVIACION']+ espacios(1) + ':' + espacios(1)+IntToStr(qry['TOTAL']) + espacios(3);;
            next;
        end;
    end;
    Writeln(F,ls_str);
    ls_str := '';
    for li_col := 1 to 8 do begin
        if length(detalle_tarjeta[li_ultimo,li_col]) > 0 then begin
            if li_col = 1 then begin
                  ls_str := ls_str + forza(detalle_tarjeta[li_ultimo,li_col],5) + espacios(((70 div li_lineas_rows)) + 5) ;
            end else
                  ls_str := ls_str + forza(detalle_tarjeta[li_ultimo,li_col],5) + espacios(((70 div li_lineas_rows))) ;
        end;
    end;
    WriteLn(F,ls_linea_total);
    ls_str := Copy(ls_str,1,(length(ls_str) - (70 div li_lineas_rows) ));
    ls_str := ls_str + espacios(4)+ forza(detalle_tarjeta[li_ultimo,9],5)+espacios(4)+ forza(detalle_tarjeta[li_ultimo,10],5);
    try
        if detalle_tarjeta[li_ultimo,10] <> '' then
            FNumero := StrToInt(detalle_tarjeta[li_ultimo,10])
        else
            FNumero := 0;
    except
        FNumero := 0;
    end;
    Writeln(F,ls_str);
    ls_str := NumeroATexto;
    Writeln(F,'  Total de pasajeros con letra : '+ UpperCase(ls_str));

end;

function getQuienGenera(usuario : string) : string;
var
    lq_quien : TSQLQuery;
begin
    lq_quien := TSQLQuery.Create(nil);
    lq_quien.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_GUIA_QUIEN_GENERA,[usuario]), lq_quien, _LOCAL) then
        Result := 'Impreso por: ' + usuario +' '+ lq_quien['NOMBRES'] +' '+lq_quien['PATERNO'];
    lq_quien.Free;
end;

procedure generaGuiaViaje(guia, corrida, fecha, hora : String; impresion : integer; terminal, user : string);
var
    ls_name : String;
    lq_qry,lq_query : TSQLQuery;
    ls_ithaca, ls_corrida_n,ls_ori_des, ls_fcha, ls_qry, ls_toshiba, ls_fecha_actual : String;
    ls_header, ls_destino : string;
    ls_operador_barra, ls_corrida_barra, ls_bus_barra, ls_comp : String;
    li_total, li_taquilla, li_mov, li_web : integer;
begin
    insertaEvento(user, terminal,'Genera guia : ' + guia + ' corrida : ' + corrida + ' fecha : ' + fecha + ' hora : ' +hora);
    ls_fcha := Copy(fecha,9,2)+'/'+Copy(fecha,6,2)+'/'+Copy(fecha,1,4);
    if gs_ImprimirAdicional  = _IMP_DEFAUTL_PRINTER then begin
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        ls_name := ExtractFilePath(Application.ExeName);
        ls_name := ls_name + 'tarjeta.txt';
        if  FileExists(ls_name) then begin //se crea
            DeleteFile(ls_name)
        end;
        AssignFile(F,ls_name);
        Rewrite(F);
        try
            if EjecutaSQL(format(_GUIA_TARJETA,[guia,corrida,fecha,hora]),lq_qry,_LOCAL) then begin
                escribeTarjetaEncabezado(lq_qry,impresion,fecha, terminal, getQuienGenera(user) );
            if EjecutaSQL(_GUIA_DESC_ENCABEZADO,lq_qry,_LOCAL) then
                escribeTarjetaCuerpo(lq_qry);
            if EjecutaSQL(format(_GUIA_CUENTA_BOLETOS,[fecha,corrida]),lq_qry,_LOCAL) then
                li_conta_lineas := Detalle(lq_qry,fecha,corrida) + li_conta_lineas;
            if EjecutaSQL(Format(_GUAI_DETALLE_PASAJERO,[fecha,corrida]),lq_qry,_LOCAL) then
               if lq_qry['TOTAL'] > 0 then begin
                escribeOcupante(lq_qry);
                li_conta_lineas := li_conta_lineas + 3;
               end;
          end;
          escribeTarjetaPie(terminal,fecha,corrida,user);
        finally
          lq_qry.Destroy;
          Close(F);
          imprimeDireccionado('tarjeta.txt',gs_impresora_general,ExtractFileDir(Application.ExeName));
{          if SpoolFile('tarjeta.txt',gs_impresora_general) = 0 then
              ;}
//          DeleteFile(ls_name);
        end;
    end;
    if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS then begin
        lq_query := TSQLQuery.Create(nil);
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        lq_query.SQLConnection := DM.Conecta;
        ls_qry := 'SELECT NOMBRE_EMPRESA, DIRECCION, DIRECCION1, RFC, CURRENT_DATE() AS FECHA_ACTUAL FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL = ''%s'' ';
        ls_OPOS := inicializarImpresora_OPOS;
        if EjecutaSQL(Format(ls_qry,[gs_terminal]),lq_query,_LOCAL) then
          if impresion = 1 then
               ls_OPOS := ls_OPOS + textoAlineado_OPOS('Rimpresion Guia De Viaje (MERCURIO)','c')
          else
               ls_OPOS := ls_OPOS + textoAlineado_OPOS('Impresion Guia De Viaje (MERCURIO)','c');

          ls_fecha_actual := lq_query['FECHA_ACTUAL'];

          if EjecutaSQL(format(_GUIA_TARJETA,[guia,corrida,fecha,hora]),lq_qry,_LOCAL) then begin
              ls_corrida_n :=  lq_qry['ID_CORRIDA'];
              ls_ori_des := IntToStr(lq_qry['ID_GUIA']) + '.'+ IntToStr(lq_qry['NO_BUS']) +'.'+
                            lq_qry['ORIGEN']+'.'+ lq_qry['DESTINO']+'.'+ lq_qry['ID_CORRIDA'];

              if lq_qry['ESTATUS'] = 'V' then
                  ls_OPOS := ls_OPOS + textoAlineado_OPOS('Guía de vacío creado por : ' + lq_qry['CREADO'], 'i');

              ls_corrida_barra  := llenaEspacios(lq_qry['ID_CORRIDA'], 10);
              ls_operador_barra := llenaEspacios(lq_qry['CONDUCTOR'], 7);
              ls_bus_barra      := llenaEspacios(lq_qry['NO_BUS'], 4);

              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Hora de impresion :    '+ FormatDateTime('HH:nn',lq_qry['AHORA']),'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Salida de la corrida : ' + FormatDateTime('HH:nn',lq_qry['HORA']),'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Numero de Guia :       '+ IntToStr(lq_qry['ID_GUIA']),'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Numero de Autobus :    '+ IntToStr(lq_qry['NO_BUS']),'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Clave de la terminal : ' + terminal,'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Datos del operador :   ','i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('       ' + UpperCase(lq_qry['OPERADOR']),'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Boletera :             ' + lq_qry['BOLETERA_FOLIO'],'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Clave ruta :           ' + IntToStr(lq_qry['ID_RUTA']),'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Origen Tramo   :       '+ lq_qry['ORIGEN'],'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Destino Tramo   :      '+ lq_qry['DESTINO'],'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Fecha :                ' + ls_fcha,'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Corrida :              '+ lq_qry['ID_CORRIDA'],'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Servicio :              '+ lq_qry['SERVICIO'],'i');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Listado de descensos : ','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('===============================================','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Destino     Total    Taquilla     Movil     WEB ','c');


              ls_comp := ls_comp + textoAlineado_OPOS('SmartMac             : ', 'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Numero de Guia       : ' + IntToStr(lq_qry['ID_GUIA']), 'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Fecha                : ' + ls_fcha, 'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Corrida              : '+ lq_qry['ID_CORRIDA'],'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Salida de la corrida : ' + FormatDateTime('HH:nn',lq_qry['HORA']),'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Hora de impresion    : '+ FormatDateTime('HH:nn',lq_qry['AHORA']),'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Clave de la terminal : ' + terminal,'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Numero de Autobus    : '+ IntToStr(lq_qry['NO_BUS']),'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Origen               : '+ lq_qry['ORIGEN'],'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Destino              : '+ lq_qry['DESTINO'],'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Clave Empleado       : '+ lq_qry['DESTINO'],'i');
              ls_comp := ls_comp + textoAlineado_OPOS('Id Operacion         : ','i');
              ls_comp := ls_comp + textoAlineado_OPOS('v' + FloatToStr(_VERSION), 'd');
              ls_comp := ls_comp + textoAlineado_OPOS(getQuienGenera(user), 'i' );
              if EjecutaSQL(format(_GUIA_DETALLE_DESCENSOS,[ls_corrida_n,fecha]) ,lq_qry, _LOCAL) then begin
                  with lq_qry do begin
                      First;
                      li_total := 0;
                      li_taquilla := 0;
                      li_mov := 0;
                      li_web := 0;
                      while not EoF do begin
                          ls_OPOS := ls_OPOS +  textoAlineado_OPOS(forza(' ',3)+forza(lq_qry['DESTINO'], 13)+
                                              forza(IntToStr(lq_qry['TOTAL']),10)+
                                              forza(IntToStr(lq_qry['TAQUILLA']),9) +
                                              forza(IntToStr(lq_qry['MOV']),8) +
                                              IntToStr(lq_qry['WEB'])
                                            ,'I');
                          li_total := li_total + lq_qry['TOTAL'];
                          li_taquilla := li_taquilla + lq_qry['TAQUILLA'];
                          li_mov := li_mov + lq_qry['MOV'];
                          li_web := li_web + lq_qry['WEB'];
                          Next;
                      end;
                  end;
              end;
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('_______________________________________________','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS(forza(' ',5)+forza('Total :', 10) +' '+forza(IntToStr(li_total), 9) +' '+
                                                                   forza(IntToStr(li_taquilla), 8)   +' '+
                                                                   forza(IntToStr(li_mov), 7)+' '+
                                                                   IntToStr(li_web)
                                   ,'I');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Listado de Tarifas ocupantes','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('===============================================','c');
              if EjecutaSQL(format(_GUIA_ITHACA_TARIFAS,[ls_corrida_n,fecha]) ,lq_qry, _LOCAL) then begin
                  with lq_qry do begin
                      First;
                      while not EoF do begin
                           if(Length(ls_header) = 0) then begin
                              ls_header := lq_qry['DESTINO'];
                              ls_destino := forza(' ', 5)+ ls_header + '  ' + lq_qry['ABREVIACION']+'-'+IntToStr(lq_qry['TOTAL']);
                           end else begin
                                 if( (Length(ls_header) > 0) and (ls_header = lq_qry['DESTINO']) ) then begin
                                    ls_destino := ls_destino + '  ' + lq_qry['ABREVIACION']+'-'+IntToStr(lq_qry['TOTAL']);
                                 end;
                           end;
                           if( (Length(ls_header) > 0) and (ls_header <> lq_qry['DESTINO']) ) then begin
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS(ls_destino,'i');
                             ls_header := lq_qry['DESTINO'];
                             ls_destino := forza(' ', 5)+ls_header + '  ' + lq_qry['ABREVIACION']+'-'+IntToStr(lq_qry['TOTAL']);
                           end;
                          Next;
                      end;
                      if(length(ls_destino) > 0) then
                        ls_OPOS := ls_OPOS + textoAlineado_OPOS(ls_destino,'i');
                  end;
              end;

              ls_OPOS := ls_OPOS + textoAlineado_OPOS('===============================================','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Pasajeros Quedados :    ________','d');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Pasajeros Adelantados : ________','d');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Pasajeros Faltantes :   ________','d');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Lugar / Fecha Impresion : ' + terminal+ ' ' + ls_fecha_actual,'c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('______________________','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Promotor','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('______________________','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('Autorizo','c');
              ls_OPOS := ls_OPOS + textoAlineado_OPOS(getQuienGenera(user), 'c' );
              ls_OPOS := ls_OPOS + textoAlineado_OPOS('v' + FloatToStr(_VERSION), 'c');
              ls_OPOS := ls_OPOS + codigoDeBarrasUniDimensional_OPOS(ls_corrida_barra + UpperCase((ls_operador_barra)) + ls_bus_barra );
              ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(0);
              ls_OPOS := ls_OPOS + corte_OPOS;
              escribirAImpresora(gs_impresora_general, ls_OPOS);
              ls_comp := ls_comp + corte_OPOS;
              escribirAImpresora(gs_impresora_general, ls_comp);
          end;
          lq_qry.Free;
          lq_query.Free;
    end;
end;

procedure escribeTarjetaPie(terminal,fecha,corrida,trabid : string);
var
    li_num, li_ctrl : integer;
    lq_qry : TSQLQuery;
    ls_nombre : string;
begin
    li_num := 29 - li_conta_lineas;
    for li_ctrl := 1 to li_num - 1 do
        Writeln(F,'');
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_GUIA_PIE_GUIA_IMPRIME,[terminal,fecha,corrida]),lq_qry,_LOCAL) then begin
        WriteLn(F,'Pax. Queds :'+ espacios(50)+ 'Pax. Falts :');
        Writeln(F,'T.S.: '+ forza(lq_qry['DESCRIPCION'],26) +espacios(10)+' Lugar y Fecha : '+ terminal +' ' +fecha );
    end;
    if EjecutaSQL(Format(_GUIA_PROMOTOR,[trabid]),lq_qry,_LOCAL) then begin
        ls_nombre := 'Promotor :'+lq_qry['NOMBRE'];
    end;

    Writeln(F,''+ forza(ls_nombre,60)+ ' Autorizo:');

    lq_qry.Free;
    lq_qry := nil;
end;

end.
