unit u_comun_venta;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    StdCtrls, DB, SqlExpr, DBXMySql, comun, SysUtils, Grids, DateUtils, ExtCtrls,
    Graphics, Variants,Classes, maskUtils, Dialogs;

const
    _MENSAJE_TARIFA_CERO  = 'No existe la tarifa para esta corrida : %s ' + #10#13 + ' Con la ruta : %s y servicio %s';
    _LS_LEYENDA = 'REGIMEN FISCAL DE LOS COORDINADOS';
    _VTA_TERMINALES  = 'SELECT ID_TERMINAL,DESCRIPCION FROM T_C_TERMINAL T WHERE FECHA_BAJA IS NULL ORDER BY 1; ';
    _VTA_TERMINAL_AGENCIA = 'SELECT A.ID_TERMINAL, T.DESCRIPCION '+
                        'FROM PDV_C_AGENCIA_TERMINAL A INNER JOIN T_C_TERMINAL T ON T.ID_TERMINAL = A.ID_TERMINAL '+
                        'WHERE FECHA_BAJA IS NULL AND A.ID_AGENCIA = ''%s'' ORDER BY 1 ';
    _VTA_TERMINALES_ORIGEN  = 'SELECT CT.ID_TERMINAL,CT.DESCRIPCION '+
                              'FROM T_C_TERMINAL CT INNER JOIN PDV_C_TERMINAL T ON CT.ID_TERMINAL = T.ID_TERMINAL '+
                              'WHERE CT.FECHA_BAJA IS NULL AND T.ESTATUS = ''A'' AND T.ID_TERMINAL IN (SELECT ID_TERMINAL '+
                              'FROM T_C_TERMINAL T '+
                              'WHERE T.EMPRESA IN (SELECT EMPRESA FROM T_C_TERMINAL C WHERE AUTO = ''A'' AND ID_TERMINAL = ''%s'')) '+
                              'UNION '+
                              'SELECT ID_TERMINAL, DESCRIPCION '+
                              'FROM T_C_TERMINAL '+
                              'WHERE ID_TERMINAL = ''%s'' '+
                              'ORDER BY 1';
    _VTA_TIPO_SERVICIO = 'SELECT TIPOSERVICIO, DESCRIPCION '+
                         'FROM SERVICIOS WHERE ID_GRUPO IN ( '+
                         'SELECT ID_GRUPO FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL = ''%s'') AND TIPOSERVICIO > 0';

    _VTA_OCUPANTE_NO_ADULTO = 'SELECT ABREVIACION FROM PDV_C_OCUPANTE WHERE FECHA_BAJA IS NULL AND ID_OCUPANTE > 1 ';
    _VTA_CORTE_FONDO    = 'UPDATE PDV_T_CORTE SET FONDO_INICIAL = %s '+
                          ' WHERE ID_CORTE = %d AND ID_EMPLEADO = ''%s'' ';
    _VTA_CORTE_IMPRESION = 'UPDATE PDV_T_CORTE SET CARGA_INICIAL = 1 '+
                           ' WHERE ID_CORTE = %d AND ID_EMPLEADO = ''%s'' ';

    _CUPO_CORRIDA_VENTA_ACTUAL = 'SELECT (COALESCE(COUNT(NO_ASIENTO),0))AS CUPO FROM PDV_T_ASIENTO '+
                                 'WHERE ID_CORRIDA = ''%s'' '+
                                 ' AND FECHA_HORA_CORRIDA = ''%s'' '+
                                 ' AND STATUS IN (''V'',''R'',''A'') ';
    _CORRIDA_OCUPADA_VENTA = 'SELECT U.TRAB_ID, (CONCAT(E.PATERNO,'' '',E.MATERNO,'' '',E.NOMBRES))AS NOMBRE '+
                             'FROM PDV_T_CORRIDA_D D INNER JOIN PDV_C_USUARIO U ON D.TRAB_ID = U.TRAB_ID '+
                             '                       INNER JOIN EMPLEADOS E ON E.TRAB_ID = U.TRAB_ID '+
                             'WHERE D.FECHA = ''%s'' AND D.HORA = ''%s'' ';
    _VTA_NOMBRE_SERVICIO = 'SELECT DESCRIPCION FROM SERVICIOS WHERE ABREVIACION = ''%s'' ';

    _VTA_OCUPANTES    = 'SELECT ABREVIACION, DESCRIPCION FROM PDV_C_OCUPANTE WHERE FECHA_BAJA IS NULL AND ABIERTO >= %s';

    _VTA_FORMAS_PAGO   = 'SELECT ID_FORMA_PAGO, ABREVIACION, DESCRIPCION, DESCUENTO '+
                         'FROM PDV_C_FORMA_PAGO P '+
                         'WHERE P.FECHA_BAJA IS NULL '+
                         'ORDER BY ORDEN';

    _VTA_FORMA_PAGO_DESCRIPCION  = 'SELECT ID_FORMA_PAGO,ABREVIACION, SUMA_EFECTIVO_COBRO, CANCELABLE '+
                             ' FROM PDV_C_FORMA_PAGO WHERE DESCRIPCION = ''%s'' ';

    _VTA_FORMA_PAGO_ID_FORMA  = 'SELECT ID_FORMA_PAGO,ABREVIACION, SUMA_EFECTIVO_COBRO, CANCELABLE '+
                              ' FROM PDV_C_FORMA_PAGO WHERE ID_FORMA_PAGO = %s ';

    _VTA_FORMA_PAGO_ABREVIACION  = 'SELECT ID_FORMA_PAGO,ABREVIACION, SUMA_EFECTIVO_COBRO, CANCELABLE '+
                             ' FROM PDV_C_FORMA_PAGO WHERE ABREVIACION = ''%s'' ';
    _UPDATE_CORRIDA_D = 'UPDATE PDV_T_CORRIDA_D SET ESTATUS = ''%s'', TRAB_ID = ''%s'' '+
                        'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_TERMINAL = ''%s'' AND HORA = ''%s'' AND ID_RUTA = %s';
    _STATUS_CORRIDA_VENTA = 'UPDATE PDV_T_CORRIDA_D SET ESTATUS = ''%s'' '+
                            'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND HORA = ''%s'' AND ID_RUTA = %s';
    _STATUS_CORRIDA_ELEGIDA = 'UPDATE PDV_T_CORRIDA_D SET ESTATUS = ''%s'' '+
                            'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_RUTA = %s';
    _VTA_TECLA_ESPERA_GRID = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 1';
    _VTA_GRUPAL_PARAMETRO = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = %s';
    _VTA_GRUPAL_PORCENTAJE = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = %s';

    _VTA_VIAJE_REDONDO = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = %s';


    _VTA_TECLA_REFRESH_GRID = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 14';
    _VTA_SI_YA_EXISTE = 'SELECT T.ID_TAQUILLA, T.IP, P.ID_CORTE, P.ESTATUS FROM PDV_T_CORTE P INNER JOIN PDV_C_TAQUILLA T ON '+
                        ' P.ID_TAQUILLA = T.ID_TAQUILLA '+
                        'WHERE ID_EMPLEADO = ''%s'' AND P.FECHA_INICIO < (SELECT NOW()) AND P.ESTATUS IN (''A'',''S'',''P'') '+
                        '       AND T.IP = ''%s'' AND T.ID_TERMINAL = ''%s'' ';
    _VTA_UPDATE_NO_VENTA = 'UPDATE PDV_T_CORTE SET ESTATUS = ''S'' WHERE ID_CORTE = %d AND ID_TERMINAL = ''%s'';';
    _VTA_UPDATE_EN_PROCESO = 'UPDATE PDV_T_CORTE SET ESTATUS = ''P'', FECHA_PRECORTE = NOW() WHERE ID_CORTE = %d AND ID_TERMINAL = ''%s'';';
    _VTA_PRINT_FINAL = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 30';
    _TRAB_NOMBRE_COMPLETO = 'SELECT (CONCAT(PATERNO,'' '',MATERNO,'' '',NOMBRES)) AS NOMBRE from EMPLEADOS '+
                            'WHERE TRAB_ID = ''%s''';




    _LOCAL_BOLETO = 'SELECT B.IVA, B.TOTAL_IVA FROM PDV_T_BOLETO B '+
                    'WHERE B.ID_BOLETO = %s AND ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND B.NO_ASIENTO = %s AND B.TRAB_ID = ''%s'' ';

    _SERVER_IVA_UPDATE = 'UPDATE PDV_T_BOLETO SET IVA = %s, TOTAL_IVA = %s WHERE ID_BOLETO = %s AND TRAB_ID = ''%s'' AND NO_ASIENTO = %s';

    _CODIGO_UNICO = 'SELECT MD5(CONCAT(''%s'',SUBSTR(CURRENT_DATE,1,4 ),SUBSTR(CURRENT_DATE,6,2),SUBSTR(CURRENT_dATE,9,2) '+
                    ',SUBSTR(CURRENT_TIME,1,2),SUBSTR(CURRENT_TIME,4,2), SUBSTR(CURRENT_TIME,7,2) )) AS CODE';

    _ABIERTO_ASIENTO_VTA = 'UPDATE PDV_T_ASIENTO A SET STATUS = ''V'', NOMBRE_PASAJERO = ''%s'' '+
                          'WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s'' AND NO_ASIENTO = %s';
    _UPDATE_ABIERTO_BOLETO = 'UPDATE PDV_T_REGISTRO_BOLETO_ABIERTO SET NO_ASIENTO = %s, FECHA_CORRIDA = ''%s'', FECHA_IMPRESION = NOW(),  '+
                          'TRAB_ID_ASIGNACION = ''%s'' , ID_CORRIDA = ''%s'' '+
                          'WHERE ID_BOLETO = %s AND TRAB_ID = ''%s'' AND ID_TERMINAL = ''%s'' ';

    _A_INSERTA_ASIENTO_RECEPTOR = 'INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,NOMBRE_PASAJERO, '+
                                  '  TERMINAL_RESERVACION, TRAB_ID, ORIGEN, DESTINO,STATUS) '+
                                  'VALUES(''%s'',''%s'',%s,''%s'',''%s'',''%s'',''%s'',''%s'',''%s'')';

    _CONECTA_TERMINAL = 'SELECT IPV4, BD_USUARIO, BD_PASSWORD, BD_BASEDATOS FROM PDV_C_TERMINAL '+
                        'WHERE ESTATUS = ''A'' AND  ID_TERMINAL = ''%s'' ';

    _NO_REGISTRADO = 'NO ASIGNADO';

    _TABLA_CREA_USUARIO = 'CREATE TABLE IF NOT EXISTS %s ( '+
                          '   ID_BOLETO INTEGER NOT NULL, '+
                          '   ID_TERMINAL VARCHAR(5) NOT NULL, '+
                          '   TRAB_ID VARCHAR(7) NOT NULL, '+
                          '   ESTATUS VARCHAR(1) NOT NULL, '+
                          '   ORIGEN VARCHAR(5), '+
                          '   DESTINO VARCHAR(5) NOT NULL, '+
                          '   TARIFA DECIMAL(9,2) NOT NULL, '+
                          '   ID_FORMA_PAGO INTEGER, '+
                          '   ID_TAQUILLA INTEGER, '+
                          '   TIPO_TARIFA VARCHAR(1) NOT NULL, '+
                          '   FECHA_HORA_BOLETO DATETIME, '+
                          '   ID_CORRIDA VARCHAR(10), '+
                          '   FECHA DATE, '+
                          '   NOMBRE_PASAJERO VARCHAR(40), '+
                          '   NO_ASIENTO INTEGER, '+
                          '   ID_OCUPANTE INTEGER, '+
                          '   ESTATUS_PROCESADO VARCHAR(1), '+
                          '   PRIMARY KEY (ID_BOLETO, ID_TERMINAL, TRAB_ID) '+
                          '); ';
    _TABLA_BORRA_USUARIO = 'DROP TABLE IF EXISTS %s;';

    _MUESTRA_IPS = 'SELECT IP,IP FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' ORDER BY 1';

    _MUESTRA_PUERTOS = 'SELECT * FROM PDV_C_PUERTO ORDER BY 1';

    _NUEVA_TAQUILLA = 'UPDATE PDV_C_TAQUILLA SET IMP_BOLETO = %s, IMP_OPCIONAL = %s,  '+
                      'TARJETA_FISICA = %s, APAGADO = %s, CARGA_FINAL = %s, TIEMPO_APAGADO = ''%s'', '+
                      'PUERTO_BOLETO = %s, PUERTO_OPCIONAL = %s, ID_TAQUILLA = %s WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';

    _INSERT_TAQUILLA_FIJA = 'INSERT INTO PDV_C_TAQUILLA(ID_TERMINAL, ID_TAQUILLA, IP, IMP_BOLETO,IMP_OPCIONAL,'+
                            'TARJETA_FISICA, APAGADO,CARGA_FINAL,TIEMPO_APAGADO,PUERTO_BOLETO, PUERTO_OPCIONAL, '+
                            'OPERACION_REMOTA, BOLETO_TAMANO, VENTA_MASIVA, IMPRESORA_BOLETOS, IMPRESORA_GENERAL, CONEXION_CENTRAL, VERSION, CONTINUO ) '+
                            'VALUES(''%s'',%s,''%s'',%s,%s,%s,%s,%s,''%s'',%s,%s,%s,%s,%s, ''%s'', ''%s'', %s, %s, %s)';

    _UPDATE_CONTINUO_TAQUILLA = 'UPDATE PDV_C_TAQUILLA SET CONTINUO = %s WHERE ID_TERMINAL = ''%s'' AND ID_TAQUILLA = %s and IP = ''%s'' ';

    _BORRA_TODAS_IPIGUAL = 'DELETE FROM PDV_C_TAQUILLA WHERE IP = ''%s'' AND ID_TERMINAL = ''%s''  ';

///MENSAJES
    _MSG_NO_HAY_CORRIDAS = 'No tenemos corridas para esa fecha: %s' + #10#13 + 'con esos parametros favor de procesarlas en el servidor de'+
                           ' %s.';
    _MSG_DATOS_CORRIDA = 'No existen corridas con estos criterios de búsqueda';
    _MSG_NO_VTA_DISPONIBLE = 'No tenemos lugares disponibles para la venta';
    _MENSAJE_CORRIDA_OCUPADA = 'La corrida esta en uso por el usuario : %s '+ #10#13 +
                               'El nombre del usuario : %s ';
    _ASIENTOS_VACIO = 'Es necesario ingresar los asientos a vender';
    _MSG_VTA_PIE_LIMITE = 'No puede disponer de la cantidad permitida ';
    _MSG_ASIENTO_MAYOR_PERMITIDO = 'El numero de asiento no es '+#10#13+'valido para este autobus';
    _MSG_CERRAR_CORRIDA = 'Confirme para cerrar la corrida %s';
    _MSG_ERROR_EXISTE_VENTA_CORRIDA = 'Hay %d asientos vendidos o reservados, así que no se puede cerrar la corrida: %s '+ #10#13 +
                                      'Se recomienda agrupar la corrida';
    _MSG_CORRIDA_MENSAJE_ESTATUS = 'La corrida se ha actualizado ';




    _MSG_CONEXION_REMOTA = 'Se establecio conexion al server de %s ';

    _MSG_CANCELA_REMOTA = 'Se cancelo la conexion al server de %s ';

    _VERIFICA_FOLIO_INICIAL = 'SELECT COUNT(*)AS FOLIO FROM PDV_FOLIOS WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND FOLIO_FINAL_B = 0 '+
                              'AND FOLIO_FINAL = ''0000-00-00 00:00:00'' ';

    _FOLIO_INICIAL = 'SELECT FOLIO_INICIAL_B FROM PDV_FOLIOS WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND FOLIO_FINAL_B = ''0'' ';
    _CORTE_TRABID = 'SELECT ID_CORTE FROM PDV_T_CORTE WHERE ID_EMPLEADO = ''%s'' AND ESTATUS IN (''A'',''S'',''P'') ';

    _ABIERTO_BOLETOS_IMPRIME = 'SELECT B.ID_BOLETO, ID_TERMINAL, TRAB_ID, ORIGEN, DESTINO, TARIFA, TIPO_TARIFA, NOMBRE_PASAJERO '+
                    'FROM PDV_T_BOLETO B WHERE B.ID_CORRIDA = ''%s'' ';

    _ABIERTO_UPDATE_BOLETO = 'UPDATE PDV_T_BOLETO SET ID_CORRIDA = ''%s'', FECHA = ''%s'', HORA_CORRIDA = ''%s'', '+
                    '  nombre_pasajero = ''%s'' , NO_ASIENTO = %d, id_ruta = %d '+
                    'WHERE ID_BOLETO = %d AND ID_TERMINAL = ''%s'' AND TRAB_ID = ''%s'' ';

    _ABIERTO_BUSCA_CODIGO = 'SELECT COUNT(*) FROM PDV_T_REGISTRO_BOLETO_ABIERTO WHERE CODIGO_BOLETO = ''%s'' ';

    _ABIERTO_UPDATE_CODIGO = 'UPDATE PDV_T_REGISTRO_BOLETO_ABIERTO SET FECHA_VIGENCIA = ADDDATE(FECHA_VIGENCIA,INTERVAL 29 DAY), ID_CORRIDA = ''%s'', '+
                             'CODIGO_BOLETO = ''%s'', TRAB_ID_VIGENCIA = ''%s'' '+
                             'WHERE CODIGO_BOLETO = ''%s'' ';


    _ABIERTO_PROMOCION_BOLETO = 'SELECT ORIGEN, DESTINO, SUM(TARIFA)AS TOTAL, SERVICIO, FECHA_HORA_COMPRA, FECHA_VIGENCIA, '+
                    'TC, COUNT(*)AS PASAJEROS, CODIGO_BOLETO '+
                    'FROM PDV_T_REGISTRO_BOLETO_ABIERTO '+
                    'WHERE CODIGO_BOLETO = ''%s'' '+
                    'GROUP BY ORIGEN, DESTINO, SERVICIO';

    _ABIERTO_CORRIDA_UPDATE = 'UPDATE PDV_T_BOLETO SET ID_CORRIDA = ''%s'' WHERE ID_CORRIDA = ''%s'' ';


    _VTA_CODE_ABIERTO = 'SELECT UPPER(substr(SHA1((CURRENT_TIMESTAMP() / 999) * (FLOOR(RAND()*(RAND(5000000)-5+1)+5))), 3, 8) )AS CODE';


    _CODIGO_BOLETO_VIGENCIA = 'SELECT COUNT(*)AS TOTAL '+
                              'FROM PDV_T_REGISTRO_BOLETO_ABIERTO '+
                              'WHERE CODIGO_BOLETO = ''%s'' AND TRAB_ID_ASIGNACION IS NULL';


    _VTA_BUSCA_FECHA_AMBOS =   'SELECT DISTINCT(ID_CORRIDA),(CAST(FECHA_HORA_CORRIDA AS DATE))as FECHA,  '+
                               '(CAST(FECHA_HORA_CORRIDA AS TIME))AS HORA, ORIGEN,DESTINO, NOMBRE_PASAJERO  '+
                               ' FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND  '+
                               ' CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE)  ORDER BY NO_ASIENTO;';

    _VTA_BUSCA_RESERVA_AMBOS =  'SELECT DISTINCT(ID_CORRIDA),(CAST(FECHA_HORA_CORRIDA AS DATE))as FECHA, (CAST(FECHA_HORA_CORRIDA AS TIME))AS HORA, DESTINO, ORIGEN, NOMBRE_PASAJERO FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND  '+
                               ' NOMBRE_PASAJERO = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE)  ORDER BY NO_ASIENTO;';


    _VTA_BUSCA_ASIENTOS = 'SELECT NO_ASIENTO FROM PDV_T_ASIENTO '+
                          'WHERE STATUS = ''R'' AND   NOMBRE_PASAJERO = ''%s'' AND '+
                          '  CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE)  ORDER BY NO_ASIENTO ';

    _VTA_BUSCA_ASIENTOS_CORRIDA = 'SELECT NO_ASIENTO FROM PDV_T_ASIENTO '+
                                  'WHERE STATUS = ''R'' AND   NOMBRE_PASAJERO = ''%s'' AND '+
                                  '  CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE) AND ID_CORRIDA = ''%s'' ORDER BY NO_ASIENTO ';

    _VTA_BUSCA_ASIENTO_RESERVA = 'SELECT (COUNT(*))AS TOTAL FROM PDV_T_ASIENTO WHERE ID_CORRIDA = ''%s'' AND '+
                                 'FECHA_HORA_CORRIDA = ''%s'' AND NO_ASIENTO = %d '+ //AND TERMINAL_RESERVACION = ''%s'' '+
                                 ' AND NOMBRE_PASAJERO = ''%s'' ';

    _VTA_BUSCA_DISPONIBLE_RESERVA = 'SELECT (COUNT(*)) AS TOTAL FROM PDV_T_ASIENTO WHERE FECHA_HORA_CORRIDA = ''%s'' AND '+
                                    'ID_CORRIDA = ''%s'' AND NO_ASIENTO = %d AND STATUS = ''V'';';

    _VTA_BUSCA_RESERVADO_APARTADO = 'SELECT (COUNT(*)) AS TOTAL FROM PDV_T_ASIENTO '+
                                 'WHERE FECHA_HORA_CORRIDA = ''%s'' AND ID_CORRIDA = ''%s'' AND NO_ASIENTO = %d AND STATUS = ''A'' ';

    _VTA_BUSCA_ORIDES_RESERVADA = 'SELECT ORIGEN,DESTINO FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND ID_CORRIDA = ''%s'' AND FECHA_HORA_CORRIDA = ''%s'' LIMIT 1';

    _VTA_HISTORICO_POR_CORRIDA = 'SELECT COUNT(B.NO_ASIENTO)AS OCUPADOS, '+
                                 '(SELECT COUNT(A.NO_ASIENTO) '+
                                 'FROM PDV_T_BOLETO A '+
                                 'WHERE A.FECHA = B.FECHA AND A.ID_TERMINAL = B.ID_TERMINAL AND A.ESTATUS = ''V'' '+
                                 'AND A.ID_cORRIDA = B.ID_CORRIDA AND A.NO_ASIENTO > 100 '+
                                 ')AS PIE, '+
                                 '(SELECT COUNT(A.NO_ASIENTO) '+
                                 'FROM PDV_T_BOLETO A '+
                                 'WHERE A.FECHA = B.FECHA AND A.ID_TERMINAL = B.ID_TERMINAL AND A.ESTATUS = ''C''  '+
                                 'AND A.ID_cORRIDA = B.ID_CORRIDA '+
                                 ')AS CANCELADOS, '+
                                 'IFNULL((SELECT DESTINO FROM T_C_RUTA R WHERE R.ID_RUTA = B.ID_RUTA ),'''') AS DESTINO '+
                                 'FROM PDV_T_BOLETO B '+
                                 'WHERE B.FECHA = ''%s'' AND B.ID_TERMINAL = ''%s'' AND B.ESTATUS = ''V'' '+
                                 'AND ID_CORRIDA = ''%s'' AND B.NO_ASIENTO < 100';



//para el corte
    _E_ASIGNA_VTA_DUPLICADO = 0;
    _E_ASIGNA_PROCESO_CORTE = 4;

    _VTA_COL_FORMA_ID  = 4;
    _VTA_CANTIDAD_PAGAR = 1;


    _GRID_ASIENTO = 0;
    _GRID_TIPO    = 1;
    _GRID_PRECIO  = 2;
    _GRID_ORI_DES = 3;
    _GRID_PAGO    = 4;
    _GRID_PRECIO_FIJO  = 5;
    _GRID_FECHA_CORRIDA = 6;
    _GRID_FECHA_HORA    = 7;


    _GRID_PAS_ASIENTO  = 0;
    _GRID_PAS_PASAJERO = 1;
    _GRID_PAS_PRECIO   = 2;
    _GRID_PAS_SERVICIO = 3;
    _GRID_PAS_ORIGEN   = 4;


    _VENTA_INICIO_NUEVA = 0;
    _VENTA_EFECTUADA_NUEVA = 1;
    _VENTA_CANCELADA_NUEVA = 2;
    _VENTA_ELIGE_OTRA_NUEVA = 3;

    _MILISEGUNDO = (1/24/60/60/1000);
    _RETRADADO = 500;
    _TECLAS_EN_TU_TIEMPO = _MILISEGUNDO * _RETRADADO;//se multiplica por milisegundo
    _CARACTERES_VALIDOS_FONDO : SET OF CHAR = ['0','1','2','3','4','5','6','7','8','9','.'];

    _DRIVER = 'MySql';

    _ERROR_LUGARES = 'Error en el origen y destino verifiquelo';


type
    PDV_Asientos = record
      corrida     : String;
      fecha_hora  : String;
      asiento     : integer;
      empleado    : String;
      origen      : String;
      destino     : String;
      status      : Char;
      precio      : real;
      precio_original  : real;
      servicio    : integer;
      forma_pago  : integer;
      descuento   : real;
      Ocupante    : String;
      tipo_tarifa : string;
      idOcupante  : Integer;
      taquilla    : integer;
      nombre      : String;
      abrePago    : string;
      ruta        : integer;
      pago_efectivo : integer;
      calculado   : integer;
      impreso     : integer;
      id_pago_pinpad_banamex : String;   //salez
      iva         : real; ///nuevo para el cobro de iva por boleto
      boleto_iva  : real;
      tipo_tarjeta : String;
      tarifa_real : Real;
    end;//para la venta

    PDV_Reservaciones = record
      corrida  : String;
      fecha    : String;
      asiento  : Integer;
      pasajero : String;
      terminal : String;
      Trab_id  : String;
      origen   : String;
      Destino  : String;
      Status   : String;
    end;//para la reservaciones

    PDV_Servers = record
      terminal  : string;
      ip        : string;
      user      : string;
      pass      : string;
      estatus   : String;
      tipo      : String;
    end;//para las ips de los server

    PDV_Boleto = record
      id_boleto : String;
      terminal  : String;
      trab_id   : String;
      status    : String;
      origen    : String;
      destino   : String;
      tarifa    : String;
      id_forma_pago : String;
      taquilla  : String;
      tipo_tarifa : String;
      fecha_boleto : String;
      id_corrida : String;
      fecha      : String;
      nombre_pasajero : String;
      no_asiento : String;
      id_ocupante : String;
      estatus_procesado : String;
    end;
    PDV_ULTIMA_VENTA = record
      origen  : String;
      destino : String;
      hora    : String;
      fecha   : String;
      servicio : String;
      corrida : String;
    end; //fin estructura

    PDV_REFRESCA_VENTA = record
      origen  : String;
      destino : String;
      hora    : String;
      fecha   : String;
      servicio : String;
      corrida : string;
    end; //fin estructura


    PDV_POSICION_ASIENTO = record
       id_tipo_autobus : integer;
       asiento         : integer;
       x               : integer;
       y               : integer;
    end;

    PDV_VIAJE_REDONDO = record
        origen  : string;
        destino : String;
        total   : integer;
    end;

    ga_labels_asientos = array[1..51] of ^Tlabel;
    array_lugares   = array[1..1000] of PDV_POSICION_ASIENTO;
    ga_asientos  = array[0..50] of Integer;
    array_asientos  = array[1..50] of PDV_Asientos;//arreglo para la venta de boletos
    la_asientos  = array[0..50] of Integer;



    procedure llenarArregloCaracteres;
    procedure llenarTerminales(query : TSQLQuery);
    procedure limpiar_La_labels(lbl_asientos : ga_labels_asientos);
    procedure llenaOcupantesSAdulto();
    function  validaSiguienteFecha(fecha_consulta : TDate) : TDate;
    function comparaHoraCorrida(lps_hora, lps_store : String): Boolean;
    procedure corridasParametrosVenta(origen, destino, fecha, lps_hora, lps_servicio : String; li_codicion : integer; Grid : TStringGrid;
                                 corrida : String);
    procedure llenarGridCorridas(lps_hora : String; store : TSQLStoredProc;
                                  var li_indice : integer; Grid : TStringGrid);

    procedure showDetalleRuta(lpi_ruta : integer; Grid : TStringGrid);
    procedure tarifaGridLlena(Grid : TStringGrid; origen : String);
    procedure obtenImagenBus(img : TImage; Nombre : string);
    procedure muestraAsientosArreglo(labels : ga_labels_asientos; id_bus : integer; panel : TPanel);
    procedure llenaPosicionLugares();
    procedure asientosOcupados(labels : ga_labels_asientos; ld_fecha : TDate; lt_hora : TTime; ls_corrida : string);
    procedure ventaHistorica(labels : ga_labels_asientos; ld_fecha : TDate; ls_corrida : string);
    procedure showOcupantes(Terminal : String; Corrida : String; fecha : TDate;  Grid : TStringGrid);

    ///boleto abierto
    procedure imprimeBoleto101(STORE : TSQLStoredProc ; imprime : String);
    procedure imprimeBoletoContinuo(STORE : TSQLStoredProc ; imprime : String);
    procedure imprimeBoletoTermica(STORE : TSQLStoredProc ; imprime : String);
    procedure asientoReplicaRuta(STORE : TSQLStoredProc);
    procedure asientoActualiza(corrida, fecha, nombre : String; no : integer);
    procedure asignaBoletoAbierto(STORE : TSQLStoredProc);
    procedure imprimeVigenciaNuevaTermica(qry : TSQLQuery);
    procedure imprimeVigenciaSX4(qry : TSQLQuery);

    procedure asignaVentaNew(trabid, terminal : string; taquilla:integer);
    function estatus_corrida(corrida, fecha, terminal : string) : string;
    function split_Hora(Input : String) : string;
    function cupoCorridaVigente(corrida, fecha, hora : string; conexion : TSQLConnection) : integer;
    function cupoPieCorrida(corrida,fecha,terminal : string) : Integer;
    function storeApartacorrida(corrida : String; fecha : TDate; terminal : String; trabid : string) : string;
    function storeApartacorridaVenta(corrida : String; fecha : TDate; terminal : String; trabid : string) : string;
    procedure apartaCorrida(corrida : String; fecha : TDate; hora : String; terminal : String; trabid : string; ruta : integer);
    function existe(lc_carac : Char) : Boolean;
    function reWrite(ls_cadena: String) : String;
    function rangoAsientos(ls_cadena : string) : boolean;
    procedure procesoVentaCuales(CualesAsientos : ga_asientos; li_maximo : integer; ls_corrida,
                             fecha, Origen, Destino, user, servicio : string; costo : real;
                             var array_Seat : array_asientos; taquilla, cobro_iva : integer; iva : Double);
    function  nombreServicio(cortoName : string) : string;
    procedure estatus_ASIENTO(asientos : PDV_Asientos; lc_opcion : Char);
    function validaCualesOcupantes(ls_cadena : string) :  String;
    procedure recalculaPrecioConDescuento(var arreglo : array_asientos);
    procedure buscaOcupantes(Grid : TStringGrid; opcion : integer);
    function calcula(arreglo : array_asientos; li_vendidos : Integer) : Currency;
    function codigoUnico(seats : array_asientos; indice : integer) : string;
    procedure ImprimeBoletos(var asientos : array_asientos; li_vendidos : Integer);
    function  existeBoletoPromotor(corrida, fecha : string; asiento : integer; trab_id : string) : boolean;
    procedure BorraArregloIDs(var asientos : array_asientos; li_elegido : integer);
    procedure BorraArregloAsientos(var asientos : array_asientos);
    function verificaMismaCorrida(var asientos : array_asientos) : boolean;
    function verificaSoloAdulto(var asientos : array_asientos) : boolean;
    function minimoAdultoPermitidos(var asientos : array_asientos) : boolean;
    function parametroValor(parametro : integer): integer;
    procedure calculaDtoGrupal(var asientos : array_asientos);
    procedure calculoDtoViajeRndo(var asientos : array_asientos);

//DTO viaje redondo
    function siEsViajeRedondo(var asientos : array_asientos): boolean;
    function igualIdeRegreso(var asientos : array_asientos): boolean;

    procedure BorraArregloLibera(var asientos : array_asientos);
    function BorraArregloLiberaMemoria(var asientos : array_asientos; fecha : string; corrida : string; asiento : integer) : integer;
    function existeVentaDeCorrida(fecha_inicio, fecha_fin : TDate; Corrida : String; servicio : integer) : integer;
    function DiaMas(fecha : String) : string;
    function validaTipoHueco(ls_cadena : String) : string;
    procedure procesoVentaCuantos(li_asientos : integer; ls_corrida : String; li_elegidos_asientos : integer;
                                  fecha, Origen, Destino, user, servicio : string; costo : real;
                              var array_Seat : array_asientos; taquilla : Integer;
                                  ruta : integer; var li_insertados : integer; iva : Double; cobro_iva : integer);
    function AsientoOcupado(store : TSQLStoredProc; var li_continuo : integer) : Boolean;
    function tiempo_Espera_Grid(): Integer;
    function tiempo_refresh_Grid(): Integer;
    procedure ImprimeCargaInicial(trabid, texto : String);
    procedure ImprimeCargaFinal(trabid : String);
    function nombreCompletoTrabid(trabid : string) : string;
    procedure corridasParametros(origen, destino, fecha, lps_hora, lps_servicio : String;
                                      li_codicion : integer; Grid : TStringGrid; corrida : String);
    procedure corridasHistoricoVenta(origen, destino, fecha, lps_hora, lps_servicio : String; li_codicion : integer; Grid : TStringGrid;
                                 corrida : String);
    function conexionServidorRemoto(terminal : string) : TSQLConnection;
//    function conexionServidorCentral(terminal : string) : TSQLConnection;
    function getDescripcionTerminal(terminal : String) : string;
    procedure muestraReservaciones(Grid : TStringGrid; origen, fecha : String);
    function getEmisionBoleto  : integer;
    function  validaDobles(a_elegidos : ga_asientos): Boolean;
    function obtieneDigitoVerificador(str_cadenaUnica :String) : string;
    function getCodeImprime( str_user : String) : string;
    function generaCodigoVerificador(str_cifrada : String): String;
    procedure borrrarItemArreglo(var asientos : array_asientos; li_idx : integer);
    function EnteroReturn(int_dato : integer) : integer;
    function validaFolio(corte : integer; user : String): integer;
    function corteNumero(user : String): integer;
    function getDecimalTrunco(str_monto: string):string;
    function RegresaIVA(iva : String): real;
    function getExpedicion(terminal : string) : String;
    function verificaCorteTrabId(corte_num : integer) : string;
    function getComplementoTTarifa() : string;
    function getCodeBoletoAbierto : String;
    function getTarifaIvaOrigenDestino(origen, destino : String; servicio : integer; var tarifa, iva : double) : boolean;
    function getFechaSistema() : integer;
    function asientoReservado(ls_nombre,ls_fecha : string; Grid : TStringGrid) : integer; overload;
    function asientoReservado(ls_fecha : string; Grid : TStringGrid) : integer; overload;

    function validaCamposarray(asientos : array_asientos; li_vendidos : Integer) : Boolean;


    procedure asignaVenta(trabid, terminal : string; taquilla:integer);
    function acompleta_ceros_izquierda(cadena_in: string; no: integer): string;

    function compareSizeBus(ori_corrida, fec_origen : String; des_corrida, fec_destino : String ) : Boolean;
    function getTotalBoleto(corrida : String; fecha : String): integer;
    function getSizeAutbos(corrida : String; fecha : String): integer;


var
    ga_caracteres : array[0..12]of Char;
    ga_separador  : array[0..2]of char;
    gds_terminales : TDualStrings;
    gda_ruta       : TDualStrings;
    CONEXION_VTA : TSQLconnection;
    CONEXION_REMOTO : TSQLconnection;
    CONEXION_ULTIMA : TSQLconnection;
    ocupanteSinAdulto : array[1..20]of String;
    gi_numCorrida : integer;
    gs_extra_imprime : string;
    ga_lugares_bus : array_lugares;
    gi_fondo_inicial_store : integer;
    gs_trabid_store        : string;
    gs_estatus_store       : string;
    gi_taquilla_store      : integer;
    gi_corte_store         : integer;
    gi_out_valida_asignarse : integer;
    gi_impresion_carga : integer;
    gb_asignado            : Boolean;
    gs_nombre_trabid       : string;
    gb_fondo_ingresado_new : Boolean;
    gs_fondo_inicial_new : String;
    gi_cupo_ruta   : integer;
    gi_ocupados    : integer;
    gi_solo_pie    : integer;
    gi_permitido_cupo : integer;
    gi_vta_pie     : integer;
    gi_corrida_en_uso : integer;
    gi_usuario_ocupado : integer;
    gds_ocupantes_asignados : TDualStrings;
    gds_ListaOcupantes : TDualStrings;
    gi_idx_asientos  : Integer; //numero de asientos en cuales
    li_ctrl_asiento : integer;
    gi_arreglo : integer;
    gi_ruta    : integer;
    gds_formas_pago : TDualStrings;
    gds_tabla_forma_pago : TDualStrings;
    gs_nombre_pax_nueva : String;
    gi_venta_grupal_dto : integer;
    gi_vta_dto_viaje_rdo : integer;

    gs_imprime_extra    : String;
    memoria_cuales : ga_asientos;
    li_memoria_cuales :  integer;
    li_agrupa_corrida : integer;
    gi_seleccion_venta : integer;
    formPago       : Integer;
    key_sag_venta : char;
    tiempo_key    : TDateTime;
    asientos_regreso: array_asientos;
    CORRIDA_ULTIMA_VTA : PDV_ULTIMA_VENTA;
    gb_venta_remota : boolean;
    ga_boletos_nombres : array[1..50] of string;
    gs_terminal_ruta : String;

    gs_trab_unico    : String;
    gi_opcion : integer;
    gi_porEmisionBoleto : integer;
    gi_control_pago  : integer;
    gli_agrupa_corrida : integer;
    gs_usuario_venta : string;
    gs_tarjeta_usuario : string;
    gb_boleto_abierto : Boolean;
    gi_ruta_reserva : integer;
    gi_corrida_reserva,    gi_fecha_reserva, gi_hora_reserva  : String;
    ls_asientos_reservados : String;


    li_opcion_fecha_string : integer;

    gs_nombre_pax : String;
    gs_hora_apartada    : string;
implementation

uses DMdb, TRemotoPorTerminal, u_boleto, u_ithaca_print, TLiberaAsientosRuta,
  u_ToshibaMini_print, u_venta_usuarios, u_comun_base, u_impresion,
  u_gral_venta, u_especial;

var
    li_maximo_asientos : integer;
    ga_viaje_redondo : array[0..1] of PDV_VIAJE_REDONDO;
//    li_ctrl_interna    : integer;


function validaCamposarray(asientos : array_asientos; li_vendidos : Integer) : Boolean;
var
    lci_ctrl : integer;
    lb_ok : Boolean;
begin
    lb_ok := True;
    for lci_ctrl := 1 to li_vendidos do begin
       if ((asientos[lci_ctrl].origen = '') and (asientos[lci_ctrl].corrida = '') and
           (asientos[lci_ctrl].asiento = 0)) then begin
            lb_ok := False;
            break;
       end;
    end;
    Result := lb_ok;
end;


function getCodeBoletoAbierto : String;
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONEXION_VTA;

    if EjecutaSQL(_VTA_CODE_ABIERTO, lq_qry, _LOCAL) then
        Result := lq_qry['CODE'];
    lq_qry.Free;
end;


function getDecimalTrunco(str_monto: string):string;
var
    la_datos : gga_parameters;
    li_num : integer;
begin
    splitLine(str_monto,'.',la_datos,li_num);
    result := la_datos[0]+'.'+copy(la_datos[1],0,2);
end;


function RegresaIVA(iva : String): real;
var
     li_iva  : integer;
     lf_iva  : Real;
     ls_iva  : string;
begin
    li_iva := Round( StrToFloat(iva) );
    if li_iva > 0 then
        lf_iva := StrToFloat(  '1.'+ IntToStr(li_iva) )
    else
        lf_iva := 0;
    result := lf_iva;
end;

procedure asignaBoletoAbierto(STORE : TSQLStoredProc);
var
    ls_sentencia : String;
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_UPDATE_ABIERTO_BOLETO, [IntToStr(STORE['NO_ASIENTO']),  formatDateTime('YYYY-MM-DD',STORE['FECHA']), gs_trabid, STORE['ID_CORRIDA'],
                                                  IntToStr(STORE['ID_BOLETO']), STORE['TRAB_ID'], STORE['ID_TERMINAL']]), lq_qry, _LOCAL) then
        ;

    lq_qry.Free;
    lq_qry := nil;
end;

procedure imprimeVigenciaNuevaTermica(qry : TSQLQuery);
var
    ls_OPOS : String;
begin
      ls_OPOS := '';
      ls_OPOS := ls_OPOS + InicializaBAbierto;
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('P  R  O  M  O  C  I  O  N', 'c');
      ls_OPOS := ls_OPOS + TamanioLetraDetalle;
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Origen   : ' + qry['ORIGEN'],'i' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Destino  : ' + qry['DESTINO'],'i' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Servicio : ' + qry['SERVICIO'],'i' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Fecha de compra : ' + FormatDateTime('YYYY-MM-DD', qry['FECHA_HORA_COMPRA']),'i' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Fecha de vigencia : ' + FormatDateTime('YYYY-MM-DD', qry['FECHA_VIGENCIA']),'i' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Total    : $' + FormatFloat('###,###,##0.00', qry['TOTAL']),'i' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Total Pasajeros  : ' + IntToStr(qry['PASAJEROS']),'i' );
      ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(1);
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('-------------------------------------','c' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('TC : ' + qry['TC'],'i' );
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Codigo de boleto abierto : ' + gs_terminal +'-'+ qry['CODIGO_BOLETO'], 'i' );
      ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(1);
      ls_OPOS := ls_OPOS + TamanioLetraPie;
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Vigencía del boleto, 30 dias a partir de la fecha de compra.', 'i');
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('No se aplica cambios, ni cancelaciones en promociones.', 'i');
      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Es necesario presentar este boleto fisico en taquillas.','i');
      ls_OPOS := ls_OPOS + corte_OPOS;
      escribirAImpresora(gs_impresora_boletos, ls_OPOS);
end;

procedure imprimeVigenciaSX4(qry : TSQLQuery);
begin
{      imprimirBoletoDataAbierto(
                                'Promocion',//0
                                'Origen  : ' + qry['ORIGEN'],
                                'Destino : ' + qry['DESTINO'],//1
                                'Servicio : ' + qry['SERVICIO'],//2
                                'Fecha de compra   : ' + FormatDateTime('YYYY-MM-DD', qry['FECHA_HORA_COMPRA']),//3
                                'Fecha de vigencia : ' + FormatDateTime('YYYY-MM-DD', qry['FECHA_VIGENCIA']),//4
                                'Total : $'  + FormatFloat('###,###,##0.00', qry['TOTAL']),//5
                                'Total Pasajeros : '+  IntToStr(qry['PASAJEROS']),//6
                                'TC : ' + qry['TC'],//7
                                'Codigo de boleto abierto : ' +  gs_terminal +'-'+ qry['CODIGO_BOLETO'],//8
                                'Total Pasajeros : '+  IntToStr(qry['PASAJEROS']),//9
                                'Vigencia del boleto, 30 dias a partir de la fecha de compra.',//10
                                'No se aplica cambios, ni cancelacion en promociones',//11
                                'Es necesario presentar este boleto fisico en taquillas.',//12
                                gs_puerto
                                );}
end;


procedure asientoActualiza(corrida, fecha, nombre : String; no : integer);
var
    sentencia : String;
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    sentencia := format(_ABIERTO_ASIENTO_VTA,[nombre, corrida, fecha, IntToStr(no)]);
    if EjecutaSQL(sentencia, lq_qry, _LOCAL) then
        ;
    lq_qry.Free;
    lq_qry := nil;
end;



procedure asientoReplicaRuta(STORE : TSQLStoredProc);
var
    hilo_libera : Libera_Asientos;
    sentencia : String;
begin
      sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR,[STORE['ID_CORRIDA'],
                          formatDateTime('YYYY-MM-DD',STORE['FECHA']) + ' 00:00:00',
                          intToStr(STORE['NO_ASIENTO']),STORE['NOMBRE_PASAJERO'],gs_terminal,
                          STORE['TRAB_ID'], STORE['ORIGEN'], STORE['DESTINO'],'V']);
      hilo_libera := Libera_Asientos.Create(true);
      hilo_libera.server := CONEXION_VTA;
      hilo_libera.sentenciaSQL := sentencia;
      hilo_libera.ruta   := STORE['ID_RUTA'];
      hilo_libera.origen := STORE['ORIGEN'];
      hilo_libera.destino := STORE['DESTINO'];
      hilo_libera.Priority := tpNormal;
      hilo_libera.FreeOnTerminate := True;
      hilo_libera.start;

end;


procedure imprimeBoletoContinuo(STORE : TSQLStoredProc ; imprime : String);
var
    ls_asiento, ls_iva_boleto : string;

begin
    ls_iva_boleto := 'IVA' + formatfloat('00',(STORE['IVA'] ) )  +'%    : $'+ formatfloat('####0.00',STORE['TOTAL_IVA']);

    if STORE['NO_ASIENTO'] > 100 then
        ls_asiento := 'Sin Asiento'
    else
        ls_asiento := IntToStr(STORE['NO_ASIENTO']);
{     imprimePapelContinuo(FormatDateTime('YYYY-MM-DD',STORE['FECHA']),//1
                          FormatDateTime('HH:nn',StrToDateTime(STORE['HORA'])),//2
                          STORE['ID_CORRIDA'],//3
                          STORE['ORIGEN']+gs_imprime_extra,//4
                          STORE['DESTINO'],//5
                          STORE['SERVICIO'],//6
                          ls_asiento,//7
                          STORE['DESCRIPCION'],//8
                          FormatFloat('###,##.00',STORE['TARIFA']),//9
                          ls_iva_boleto,//10
                          IntToStr(STORE['ID_BOLETO'])+ '.' + STORE['TRAB_ID']+'.'+gs_terminal,//1
                          FormatMaskText('000000-000000-000000-000000-000000-000000;0', STORE['TC']),//2
                          _LS_LEYENDA,//3
                          '',//4
                          '',//5
                          '',//6
                          '',//7
                          '',//18
                          gs_puerto
                          ); }
end;

procedure imprimeBoleto101(STORE : TSQLStoredProc ; imprime : String);
var
    ls_asiento, ls_iva_boleto : string;

begin
    ls_iva_boleto := 'IVA' + formatfloat('00',(STORE['IVA'] ) )  +'%    : $'+ formatfloat('####0.00',STORE['TOTAL_IVA']);

    if STORE['NO_ASIENTO'] > 100 then
        ls_asiento := 'Sin Asiento'
    else
        ls_asiento := IntToStr(STORE['NO_ASIENTO']);


    imprimirBoletoDatamax101(
                          'Fecha Salida : '+ FormatDateTime('YYYY-MM-DD',STORE['FECHA']),//0
                          _LS_LEYENDA,//1
                          imprime,//2
                          'TC#:'+FormatMaskText('000000-000000-000000-000000-000000-000000;0', STORE['TC']),//3
                          'Origen   : '+ STORE['ORIGEN']+gs_imprime_extra+' Destino : '+STORE['DESTINO'],//4
                          'Hora Salida  : '+ FormatDateTime('HH:nn',StrToDateTime(STORE['HORA'])),//5
                          'Asiento  : ' + ls_asiento +' Pasajero : ' + STORE['DESCRIPCION'],//6
                          'Corrida       : ' + STORE['ID_CORRIDA'],//7
                          'Servicio : '+STORE['SERVICIO'],//8
                          'Importe    : $'+FormatFloat('###,##.00',STORE['TARIFA'])+ ' '+ STORE['ABREVIACION'],//9
                           ls_iva_boleto,//10
                          'No. :'+IntToStr(STORE['ID_BOLETO'])+ '.' + STORE['TRAB_ID']+'.'+gs_terminal,//11
                          'v'+FloatToStr(_VERSION),//12
//                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('v' + FloatToStr(_VERSION), 'c');
                          '',//13
                          '  Lugar de expedicion : ' + getExpedicion(gs_terminal),//14
                          'Origen : '+ STORE['ORIGEN']+gs_imprime_extra+
                                    ' Destino : '+STORE['DESTINO']+ ' Total : $'+FormatFloat('###,##.00',STORE['TARIFA']),//15
                          'Folio  :'+IntToStr(STORE['ID_BOLETO'])+ '.' + STORE['TRAB_ID']+'.'+gs_terminal+
                            ' Asiento : ' +IntToStr(STORE['NO_ASIENTO']) +' Tipo pasajero : ' + STORE['DESCRIPCION'] ,//16
                          STORE['TIPO_TARIFA'],  //25
                          gs_puerto
                          );
end;


procedure imprimeBoletoTermica(STORE : TSQLStoredProc ; imprime : String);
var
    ls_qry, ls_iva_boleto, ls_OPOS, ls_hora_server : String;
    ld_subtotal, ld_iva, ld_total : Double;
    lq_query : TSQLQuery;
begin
    ls_qry := 'SELECT NOMBRE_EMPRESA, DIRECCION, DIRECCION1, RFC, LUGAR_EXPEDICION, (CURRENT_TIMESTAMP())as ahora '+
             'FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL = ''%s'' ';
    ld_subtotal := STORE['TARIFA'] - STORE['TOTAL_IVA'];
    ld_iva := STORE['TOTAL_IVA'];
    ld_total := STORE['TARIFA'];
    if gi_impresion_iva = 0 then
       ls_iva_boleto := '';
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;

    if EjecutaSQL(Format(ls_qry,[gs_terminal]),lq_query,_LOCAL) then begin
       ls_hora_server := lq_query['ahora'];
       ls_OPOS := inicializarImpresora_OPOS;
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('REGIMEN FISCAL', 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('"REGIMEN DE LOS COORDINADOS"', 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS(lq_query['NOMBRE_EMPRESA'], 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS(lq_query['DIRECCION'], 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS(lq_query['DIRECCION1'], 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS(lq_query['RFC'], 'c');
       if lq_query['RFC'] = 'PTR950406QK1' then begin
           ls_OPOS := ls_OPOS + textoAlineado_OPOS('Integrante del Coordinado', 'c');
           ls_OPOS := ls_OPOS + textoAlineado_OPOS('Autobuses de Primera Clase Mexico', 'c');
           ls_OPOS := ls_OPOS + textoAlineado_OPOS('Zacatepec SA de CV', 'c');
           ls_OPOS := ls_OPOS + textoAlineado_OPOS('APC580909L82', 'c');
       end;

       if gi_pueblos_magicos = 1 then begin
           ls_OPOS := ls_OPOS + textoAlineado_OPOS(_LS_LEYENDA, 'c');
           ls_OPOS := ls_OPOS + textoAlineado_OPOS(lq_query['LUGAR_EXPEDICION']+','+ Ahora(), 'c');
       end;
       ls_iva_boleto := 'IVA' + formatfloat('00',(STORE['IVA'] ) )  +'%    : $'+ formatfloat('####0.00',STORE['TOTAL_IVA']);

       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Origen   : '+STORE['ORIGEN'] + '   Destino :'+STORE['DESTINO'] + ' ' +gs_imprime_extra, 'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Corrida  : '+STORE['ID_CORRIDA']+ ' Tipo : ' + STORE['DESCRIPCION'],'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS( getComplementoTTarifa() + ' ' + STORE['TIPO_TARIFA'], 'c', true);
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Fecha    : '+FormatDateTime('YYYY-MM-DD',STORE['FECHA'])+ ' ' +'   Hora :'+FormatDateTime('HH:nn',StrToDateTime(STORE['HORA'])) , 'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Asiento  : ' + IntToStr(STORE['NO_ASIENTO']), 'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Servicio : '+STORE['SERVICIO'],'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Importe  : $'+Format('%0.2f',[ld_total]) + '    ' + STORE['ABREVIACION'],'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS(ls_iva_boleto,'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('TC # '+FormatMaskText('000000-000000-000000-000000-000000-000000;0', STORE['TC']),'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Lugar de expedicion : ' + getExpedicion(gs_terminal), 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('AGRADECEMOS SU PREFERENCIA', 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('v' + FloatToStr(_VERSION), 'c');
       if gi_pueblos_magicos = 1 then begin
          ls_OPOS := ls_OPOS + textoAlineado_OPOS('Folio : '+ IntToStr(STORE['ID_BOLETO'])+ '.' + STORE['TRAB_ID']+'.'+gs_terminal, 'c');
          ls_OPOS := ls_OPOS + textoAlineado_OPOS('Servicio : Ruta Turistica','c');
          ls_OPOS := ls_OPOS + textoAlineado_OPOS('Este boleto es valido para la fecha y hora ','c');
          ls_OPOS := ls_OPOS + textoAlineado_OPOS('que se expide y da derecho','c');
          ls_OPOS := ls_OPOS + textoAlineado_OPOS('al seguro del viajero','c');
       end else begin
          ls_OPOS := ls_OPOS + textoAlineado_OPOS(IntToStr(STORE['ID_BOLETO'])+ '.' + STORE['TRAB_ID']+'.'+gs_terminal, 'c');
       end;
       ls_OPOS := ls_OPOS + textoAlineado_OPOS(ls_hora_server, 'c');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS(imprime, 'c');
       ls_OPOS := ls_OPOS + inicializarImpresora_OPOS;   //codigoDeBarrasUniDimensional_OPOS
       ls_OPOS := ls_OPOS + codigoDeBarrasUniDimensional_OPOS(STORE['ORIGEN'] + gs_imprime_extra+ ' '+
                                                              STORE['DESTINO'] + ' '+ STORE['ID_CORRIDA']   + ' ' +
                                                              FormatDateTime('YYYY-MM-DD',STORE['FECHA'])   + ' ' +
                                                              FormatDateTime('HH',STORE['HORA']));
       ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(2);
       ls_OPOS := ls_OPOS + inicializarImpresora_OPOS;
       ls_OPOS := ls_OPOS + corte_OPOS_seccion();
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Origen: '+ STORE['ORIGEN'] + ' Destino: '+ STORE['DESTINO'] +' Corrida: '+ STORE['ID_CORRIDA'], 'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Total : $' + Format('%0.2f',[ld_total]) + ' Fecha : '+FormatDateTime('YYYY-MM-DD',STORE['FECHA'])+ ' ' + FormatDateTime('HH:nn',StrToDateTime(STORE['HORA'])) , 'i');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('Folio : ' +IntToStr(STORE['ID_BOLETO'])+ ' ' + STORE['TRAB_ID']+' Asiento : '+ IntToStr(STORE['NO_ASIENTO']) + ' Pax : ' + STORE['DESCRIPCION'], 'I');
       ls_OPOS := ls_OPOS + textoAlineado_OPOS('v' + FloatToStr(_VERSION), 'd');
       ls_OPOS := ls_OPOS + corte_OPOS;
       escribirAImpresora(gs_impresora_boletos, ls_OPOS);
     end;
     lq_query.Free;
     lq_query := nil;
end;



procedure llenarArregloCaracteres;
begin
    ga_caracteres[0] := '0';
    ga_caracteres[1] := '1';
    ga_caracteres[2] := '2';
    ga_caracteres[3] := '3';
    ga_caracteres[4] := '4';
    ga_caracteres[5] := '5';
    ga_caracteres[6] := '6';
    ga_caracteres[7] := '7';
    ga_caracteres[8] := '8';
    ga_caracteres[9] := '9';
    ga_caracteres[10] := ' ';
    ga_caracteres[11] := ',';
    ga_caracteres[12] := '-';
    ga_separador[0] := ' ';
    ga_separador[1] := ',';
    ga_separador[2] := '-';
end;


procedure llenarTerminales(query : TSQLQuery);
begin
    gds_terminales := TDualStrings.Create();
    with query do begin
        First;
        while not EoF do begin
            gds_terminales.Add(query['ID_TERMINAL'],query['DESCRIPCION']);
            next;
        end;
    end;
end;


procedure limpiar_La_labels(lbl_asientos : ga_labels_asientos);
var
    li_ctrl_labels : integer;
begin
      for li_ctrl_labels := 1 to high(lbl_asientos) do begin
          lbl_asientos[li_ctrl_labels]^.Caption := '';
          lbl_asientos[li_ctrl_labels]^.Visible := False;
      end;
end;

procedure llenaOcupantesSAdulto();
var
    lq_query : TSQLQuery;       //_VTA_OCUPANTES
    li_ctrl : integer;
begin
    try//ocupanteSinAdulto
      lq_query := TSQLQuery.Create(nil);
      lq_query.SQLConnection := CONEXION_VTA;
      if EjecutaSQL(_VTA_OCUPANTE_NO_ADULTO,lq_query,_LOCAL) then begin
          with lq_query do begin
              First;
              li_ctrl := 1;
              while not EoF do begin
                  ocupanteSinAdulto[li_ctrl] := lq_query['ABREVIACION'];
                  inc(li_ctrl);
                  next;
              end;
          end;
      end;
    finally
        lq_query.Free;
        lq_query := nil;
    end;
end;


function  validaSiguienteFecha(fecha_consulta : TDate) : TDate;
var
    myYear, myMonth, myDay : Word;
begin
    DecodeDate(fecha_consulta,myYear,myMonth,myDay);
    inc(myDay);
    if myDay > DaysInMonth(fecha_consulta) then begin
        myDay := 1;
        inc(myMonth);
    end;

    if myMonth > 12 then begin
      myMonth := 1;
      myYear  := myYear + 1;
    end;

    Result := EncodeDate(myYear,myMonth,myDay);
end;


function comparaHoraCorrida(lps_hora, lps_store : String): Boolean;
var
    ldh_actual, ldh_base : TTime;
    li_compara : integer;
    lb_out : Boolean;
    lc_char : char;
begin

    if lps_store[1] = 'E' then lps_store := Copy(lps_store,2,9);
    li_compara := CompareStr(lps_hora,lps_store);

    if lps_hora = lps_store then lb_out := true
    else lb_out := False;
    result := lb_out;
end;


procedure llenarGridCorridas(lps_hora : String; store : TSQLStoredProc;
                         var li_indice : integer; Grid : TStringGrid);
var
    ld_tarifa : real;
    ls_fecha_hora : String;
begin//recorremos el nuevo query para mostrar informacion mas exacta
    Grid.Cells[_COL_HORA,li_indice] := lps_hora;
    Grid.Cells[_COL_DESTINO,li_indice] := Store.FieldByName('DESTINO').AsString;
    Grid.Cells[_COL_SERVICIO,li_indice] := Store.FieldByName('ABREVIA').AsString;
    Grid.Cells[_COL_FECHA,li_indice] := Store.FieldByName('FECHA').AsString;
    Grid.Cells[_COL_TRAMO,li_indice] := IntToStr(Store.FieldByName('ID_TRAMO').AsInteger);
    Grid.Cells[_COL_RUTA,li_indice] := IntToStr(Store.FieldByName('ID_RUTA').AsInteger);
    Grid.Cells[_COL_CORRIDA,li_indice] := Store.FieldByName('ID_CORRIDA').AsString;
    Grid.Cells[_COL_AUTOBUS,li_indice] := IntToStr(Store.FieldByName('ID_TIPO_AUTOBUS').AsInteger);
    Grid.Cells[_COL_NAME_IMAGE,li_indice] := Store.FieldByName('NOMBRE_IMAGEN').AsString;
    Grid.Cells[_COL_ASIENTOS,li_indice] := IntToStr(Store.FieldByName('ASIENTOS').AsInteger);
    Grid.Cells[_COL_TIPOSERVICIO,li_indice] := IntToStr(store.FieldByName('TIPOSERVICIO').AsInteger);
    try
        Grid.Cells[_COL_IVA,li_indice] := FloatToStr(store.FieldByName('IVA').AsFloat);
    except
        Grid.Cells[_COL_IVA,li_indice] := '0.00';
    end;
    Grid.Cells[_COL_TARIFA,li_indice] := FormatFloat('##.00',store.FieldByName('TARIFA').AsFloat);//Format('%0.2f',[ld_tarifa]);

    inc(li_indice);
end;

procedure corridasHistoricoVenta(origen, destino, fecha, lps_hora, lps_servicio : String; li_codicion : integer; Grid : TStringGrid;
                             corrida : String);
var
    store : TSQLStoredProc;
    li_idx: Integer;
    ls_hora,ls_muestra : string;
    ls_char : Char;
    lb_opcion  : Boolean;
    fecha_next : TDate;
    lf_moneda  : Real;
begin
    store := TSQLStoredProc.Create(nil);
    try
      fecha_next := validaSiguienteFecha(StrToDate(fecha));
    except
      fecha := DateToStr(Now);
      fecha_next := validaSiguienteFecha(StrToDate(fecha));
    end;
    gi_numCorrida := 0;
    try
      try
          store.SQLConnection := CONEXION_VTA; //DM.Conecta;
          store.Close;
          store.StoredProcName := 'PDV_STORE_MUESTRA_CORRIDAS_HISTORICAS';
          store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
          store.Params.ParamByName('IN_DESTINO').AsString := Destino;
          store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
          store.Params.ParamByName('FECHA_SIGUIENTE').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha)); //FormatDateTime('YYYY-MM-DD',fecha_next);
          store.Open;
          li_idx := 1;
          lb_opcion := false;
          if Store.IsEmpty then
              exit;

          with Store do begin
            First;
            while not Eof do begin
              ls_char := Store.FieldByName('TIPO').AsString[1];
              case ls_char of
                  'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                  else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
              end;

              if ((Store['COMPARA'] = 1) and (lb_opcion = False)) then begin
                  gi_select_corrida := li_idx;
                  lb_opcion := true;
              end;

              if li_codicion = 1 then begin
                  if ((length(lps_hora) <> 0)  or (Length(lps_servicio) <> 0 ) or (length(corrida) <> 0) )then begin
                      if (( comparaHoraCorrida(lps_hora,FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime))) and
                          (lps_servicio = store['ABREVIA']) and (store['ID_CORRIDA'] = corrida) and
                          (store['ID_CORRIDA'] = corrida) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);
                      if (( comparaHoraCorrida(lps_hora,FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime))) and
                          (length(lps_servicio) = 0) and (length(corrida) = 0) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);

                      if (( length(lps_hora) = 0) and (length(corrida) = 0) and (lps_servicio = store['TIPOSERVICIO'])  ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);
                      if (( length(lps_hora) = 0) and (length(lps_servicio) = 0) and (store['ID_CORRIDA'] = corrida) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);
                      if gi_select_corrida = 1 then
                            gi_select_corrida := 1;
                  end;
              end else begin
                    llenarGridCorridas(ls_hora,store,li_idx,Grid);
              end;
              inc(gi_numCorrida);
              Next;
            end;
//            Grid.FixedRows := 1;
          end;//FIN WITH
          if li_idx = 1 then
             Inc(li_idx);
          if (gi_select_corrida = 0) and (gi_numCorrida > 0) then
              gi_select_corrida := gi_numCorrida;
          if li_idx = gi_select_corrida then
              gi_select_corrida := gi_select_corrida - 1;

          Grid.RowCount := li_idx;
          try
            Grid.Row := gi_select_corrida;
          except
             Grid.Row := li_idx;
          end;
      finally
          store.Free;
          store := nil;
      end;
    except
          on E : Exception do begin
              ErrorLog(E.Message, store.StoredProcName);
          end;
    end;
end;


procedure muestraReservaciones(Grid : TStringGrid; origen, fecha : String);
var
    store : TSQLStoredProc;
    li_idx: Integer;
    ls_hora,ls_muestra : string;
    ls_char : Char;
    lb_opcion  : Boolean;
    fecha_next : TDate;
    lf_moneda  : Real;
    ls_nombre, ls_asientos, ls_corrida : String;
begin
    try
        store := TSQLStoredProc.Create(nil);
        store.SQLConnection := DM.Conecta; //DM.Conecta;
        store.Close;
        store.StoredProcName := 'PDV_STORE_MUESTRA_RESERVACIONES_NOMBRES';
        store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
        store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
        store.Open;
        with store do begin
              li_idx := 1;
              while not EoF do begin

                    if ((ls_nombre <> store['NOMBRE_PASAJERO']) or (ls_corrida <> store['ID_CORRIDA'])) then begin
                        ls_corrida := store['ID_CORRIDA'];
                        if VarIsNull(store['NOMBRE_PASAJERO']) then begin
                             ls_nombre := '';
                        end else ls_nombre := store['NOMBRE_PASAJERO'];
                        Grid.Cells[0,li_idx] := ls_nombre;
                        Grid.Cells[2,li_idx] := store['ID_CORRIDA'];
                        Grid.Cells[3,li_idx] := FormatDateTime('YYYY-MM-DD',store['FECHA_HORA_CORRIDA']);
                        Grid.Cells[4,li_idx] := FormatDateTime('HH:nn:SS',store['FECHA_HORA_CORRIDA']);
                        Grid.Cells[5,li_idx] := 'Reservado';
                        Grid.Cells[6,li_idx] := store['DESTINO'];
                        Grid.Cells[7,li_idx] := store['ID_RUTA'];
                        ls_asientos := '';
                        inc(li_idx);
                    end;
                    ls_asientos := ls_asientos + ' ' + IntToStr(store['No_ASIENTO']);
                    Grid.Cells[1,li_idx - 1] := ls_asientos;
                  next;
              end;//fin while
              if li_idx = 1 then
                Grid.RowCount := 2
              else
                Grid.RowCount := li_idx;
        end;
    finally
        store.Free;
        store := nil;
    end;
end;//muestra reservaciones


procedure corridasParametrosVenta(origen, destino, fecha, lps_hora, lps_servicio : String; li_codicion : integer; Grid : TStringGrid;
                             corrida : String);
var
    store : TSQLStoredProc;
    li_idx: Integer;
    ls_hora,ls_muestra : string;
    ls_char : Char;
    lb_opcion  : Boolean;
    fecha_next : TDate;
    lf_moneda  : Real;
begin
    store := TSQLStoredProc.Create(nil);
    try
      fecha_next := validaSiguienteFecha(StrToDate(fecha));
    except
      fecha := DateToStr(Now);
      fecha_next := validaSiguienteFecha(StrToDate(fecha));
    end;

    gi_numCorrida := 0;
      try
          store.SQLConnection := CONEXION_VTA; //DM.Conecta;
          store.Close;
          store.Params.Clear;
          store.StoredProcName := 'PDV_STORE_VENTA_MUESTRA_CORRIDAS';
          store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
          store.Params.ParamByName('IN_DESTINO').AsString := Destino;
          store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
          store.Params.ParamByName('FECHA_SIGUIENTE').AsString := FormatDateTime('YYYY-MM-DD',fecha_next);
          store.Open;
          li_idx := 1;
          lb_opcion := false;
          if Store.IsEmpty then
              exit;
          with Store do begin
            First;
            while not Eof do begin
              ls_char := Store.FieldByName('TIPO').AsString[1];
              case ls_char of
                  'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                  else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
              end;
              if ((Store['COMPARA'] = 1) and (lb_opcion = False)) then begin
                  gi_select_corrida := li_idx;
                  lb_opcion := true;
              end;
              if li_codicion = 1 then begin
                  if ((length(lps_hora) <> 0)  or (Length(lps_servicio) <> 0 ) or (length(corrida) <> 0) )then begin

                      if (( comparaHoraCorrida(lps_hora,FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime))) and
                          (lps_servicio = store['ABREVIA']) and (store['ID_CORRIDA'] = corrida) and (store['ID_CORRIDA'] = corrida) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);

                      if (( comparaHoraCorrida(lps_hora,FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime))) and
                          (length(lps_servicio) = 0) and (length(corrida) = 0) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);

                      if (( length(lps_hora) = 0) and (length(corrida) = 0) and (lps_servicio = store['TIPOSERVICIO'])  ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);

                      if (( length(lps_hora) = 0) and (length(lps_servicio) = 0) and (store['ID_CORRIDA'] = corrida) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);

                      if (( length(lps_hora) = 0) and (length(lps_servicio) = store['TIPOSERVICIO']) and (length(corrida) = 0) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);

                      if gi_select_corrida = 1 then
                            gi_select_corrida := 1;
                  end;
              end else begin
                    llenarGridCorridas(ls_hora,store,li_idx,Grid);
              end;
              inc(gi_numCorrida);
              Next;
            end;
//            Grid.FixedRows := 1;
          end;//FIN WITH
          if li_idx = 1 then
             Inc(li_idx);
          if (gi_select_corrida = 0) and (gi_numCorrida > 0) then
              gi_select_corrida := gi_numCorrida;
          if li_idx = gi_select_corrida then
              gi_select_corrida := gi_select_corrida - 1;

          Grid.RowCount := li_idx;
          try
            Grid.Row := gi_select_corrida;
          except
             Grid.Row := li_idx;
          end;
      finally
          store.Free;
          store := nil;
      end;
end;


procedure showDetalleRuta(lpi_ruta : integer; Grid : TStringGrid);
var
    store : TSQLStoredProc;
    li_row : integer;
    lf_moneda : Real;
begin
    store := TSQLStoredProc.Create(nil);
    try
      store.SQLConnection := CONEXION_VTA; //DM.Conecta;
        li_row := 0;
        try
            store.Close;
            store.StoredProcName := 'PDV_STORE_SHOW_DETALLE_RUTA_NEW1';
            store.Params.ParamByName('IN_RUTA').AsInteger := lpi_ruta;
            store.Open;
            with store do begin
                First;
                while not EoF do begin
                    Grid.Cells[0,li_row] := Store.FieldByName('DESTINO').AsString;
                     Grid.Cells[1,li_row] := Store.FieldByName('DESCRIPCION').AsString;
                    inc(li_row);
                    next;
                end;
            end;
            store.Close;
            store.StoredProcName := 'PDV_STORE_SHOW_DETALLE_RUTA_NEW2';
            store.Params.ParamByName('IN_RUTA').AsInteger := lpi_ruta;
            store.Open;
            with store do begin
                First;
                while not EoF do begin
                    Grid.Cells[0,li_row] := Store.FieldByName('DESTINO').AsString;
                     Grid.Cells[1,li_row] := Store.FieldByName('DESCRIPCION').AsString;
                    inc(li_row);
                    next;
                end;
            end;
            Grid.RowCount := li_row;
        finally
            store.Free;
            store := nil;
        end;
    except
          on E : Exception do begin
              ErrorLog(E.Message, store.StoredProcName);
          end;
    end;
end;


procedure tarifaGridLlena(Grid : TStringGrid; origen : String);
var
    store : TSQLStoredProc;
    ld_tarifa : real;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.Close;
        store.StoredProcName := 'PDV_STORE_TARIFA_FINAL';
        store.ParamByName('IN_ORIGEN').AsString := origen;
        store.ParamByName('IN_DESTINO').AsString := Grid.Cols[_COL_DESTINO].Strings[Grid.Row];
        store.ParamByName('IN_SERVICIO').AsString := Grid.Cols[_COL_TIPOSERVICIO].Strings[Grid.Row];
        store.Open;
        if store.IsEmpty then
            Grid.Cells[_COL_TARIFA,Grid.Row] := '0.00'
        else begin
            ld_tarifa := store['MONTO'];
            Grid.Cells[_COL_TARIFA,Grid.Row] := Format('%0.2f',[ld_tarifa]);
        end;
    finally
        store.free;
        store := nil;
    end;
end;

procedure obtenImagenBus(img : TImage; Nombre : string);
var
    li_ctrl : integer;
    bitmap : TBitmap;
begin
    for li_ctrl := 1 to 20 do begin
        if imagenes_autobuses[li_ctrl].Name = Nombre then begin
           bitmap := imagenes_autobuses[li_ctrl].Picture.Bitmap;
           img.Width := bitmap.Width;
           img.Height := bitmap.Height;
           img.Canvas.Draw(0,0,bitmap);
           img.Visible := True;
           break;
        end;
    end;
end;

procedure muestraAsientosArreglo(labels : ga_labels_asientos; id_bus : integer; panel : TPanel);
var
    li_ctrl, li_ctrl_asiento, li_y, li_x : integer;
begin
    li_ctrl_asiento := 1;
    for li_ctrl := 1 to 1000 do begin
        if ga_lugares_bus[li_ctrl].id_tipo_autobus = id_bus then begin
            li_y := ga_lugares_bus[li_ctrl].y + 5;
            li_x := ga_lugares_bus[li_ctrl].x;
            labels[li_ctrl_asiento]^.Top   := li_y;
            labels[li_ctrl_asiento]^.Left  := li_x;
            labels[li_ctrl_asiento]^.Font.Color := _ASIENTO_LIBRE;
            labels[li_ctrl_asiento]^.Font.Size := 10;
            labels[li_ctrl_asiento]^.Caption := IntToStr(ga_lugares_bus[li_ctrl].asiento);
            labels[li_ctrl_asiento]^.Font.Style := [fsBold];
            labels[li_ctrl_asiento]^.WordWrap   := true;
            if StrToInt(gs_agencia) = 1 then begin
                if ((ga_lugares_bus[li_ctrl].asiento >= gi_inicial_agencia) and
                     (ga_lugares_bus[li_ctrl].asiento <= gi_final_agencia)) then
                    labels[li_ctrl_asiento]^.visible := True
                else
                    labels[li_ctrl_asiento]^.visible := False;
            end else begin
                       labels[li_ctrl_asiento]^.visible := True;
            end;
            labels[li_ctrl_asiento]^.Parent := panel;
            Inc(li_ctrl_asiento);
        end;
    end;
end;


procedure llenaPosicionLugares();
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    try
        lq_qry.SQLConnection := CONEXION_VTA;
        lq_qry.SQL.Clear;
        lq_qry.SQL.Add('SELECT ID_TIPO_AUTOBUS,ASIENTO,X,Y FROM PDV_C_TIPO_AUTOBUS_D ORDER BY 1, 2');
        lq_qry.Open;
        li_maximo_asientos := 1;
        with  lq_qry do begin
            First;
            while not EoF do begin
                ga_lugares_bus[li_maximo_asientos].id_tipo_autobus := lq_qry['ID_TIPO_AUTOBUS'];
                ga_lugares_bus[li_maximo_asientos].asiento := lq_qry['ASIENTO'];
                ga_lugares_bus[li_maximo_asientos].x := lq_qry['X'];
                ga_lugares_bus[li_maximo_asientos].y := lq_qry['Y'];
                inc(li_maximo_asientos);
                Next;
            end;//fin while
        end;//fin if
    finally
        lq_qry.free;
        lq_qry := nil;
    end;
end;


procedure asientosOcupados(labels : ga_labels_asientos; ld_fecha : TDate; lt_hora : TTime; ls_corrida : string);
var
    store : TSQLStoredProc;
    lc_tipo : Char;
    li_asiento : integer;
begin
    Store := TSQLStoredProc.Create(nil);
    try
      Store.SQLConnection := CONEXION_VTA;
      store.Close;
      store.StoredProcName := 'PDV_STORE_VENTA_ASIENTOS_DISPONIBLES';
      store.Params.ParamByName('IN_CORRIDA').AsString := ls_Corrida;
      store.Params.ParamByName('FECHA_INPUT').AsString  := FormatDateTime('YYYY-MM-DD',ld_fecha);
      store.Params.ParamByName('IN_PIE').AsInteger := 0;
      store.Open;
      store.First;
      li_asiento := 1;
      while not store.Eof do begin
           if li_asiento <= 50 then begin
              try
                 lc_tipo := Store.FieldByName('STATUS').AsString[1];
                 case  lc_tipo of
                    'V' : labels[StrToInt(store['NO_ASIENTO'])].Font.Color := _ASIENTO_VENDIDO;
                    'R' : labels[StrToInt(store['NO_ASIENTO'])].Font.Color := _ASIENTO_RESERVADO;
                    'A' : labels[StrToInt(store['NO_ASIENTO'])].Font.Color := _ASIENTO_APARTADO;
                    'O' : labels[StrToInt(store['NO_ASIENTO'])].Font.Color := _ASIENTO_OCUPADO;
                 end;
                labels[StrToInt(store['NO_ASIENTO'])].Caption := store['TEXTO'];
                store.Next;
              except
              end;
           end;
           Inc(li_asiento);
      end;
    finally
      store.Free;
      store := nil;
    end;
end;


procedure ventaHistorica(labels : ga_labels_asientos; ld_fecha : TDate; ls_corrida : string);
var
    store : TSQLStoredProc;
    lc_tipo : Char;
begin
    Store := TSQLStoredProc.Create(nil);
    try
      Store.SQLConnection := CONEXION_VTA;
      store.Close;
      store.StoredProcName := 'PDV_STORE_HISTORICOS';
      store.Params.ParamByName('IN_CORRIDA').AsString := ls_Corrida;
      store.Params.ParamByName('FECHA_INPUT').AsString  := FormatDateTime('YYYY-MM-DD',ld_fecha);
      store.Open;
      store.First;
      while not store.Eof do begin
           lc_tipo := Store.FieldByName('STATUS').AsString[1];
           case  lc_tipo of
              'V' : labels[StrToInt(store['NO_ASIENTO'])].Font.Color := _ASIENTO_VENDIDO;
              'R' : labels[StrToInt(store['NO_ASIENTO'])].Font.Color := _ASIENTO_RESERVADO;
              'A' : labels[StrToInt(store['NO_ASIENTO'])].Font.Color := _ASIENTO_APARTADO;
           end;
          labels[StrToInt(store['NO_ASIENTO'])].Caption := store['TEXTO'];
          store.Next;
      end;
    except
    end;
    store.Free;
    store := nil;
end;


procedure showOcupantes(Terminal : String; Corrida : String; fecha : TDate;  Grid : TStringGrid);
var
    Store : TSQLStoredProc;
    qry   : TSQLQuery;
    li_row : Integer;
    tiempo : string;
    li_total : integer;
begin
    Store := TSQLStoredProc.Create(nil);
    qry   := TSQLQuery.Create(nil);
    gds_ocupantes_disponibles := TDualStrings.Create();
    try
        tiempo := FormatDateTime('HH:nn',now());
        Store.SQLConnection := CONEXION_VTA; //DM.Conecta;
        Store.Close;
        Store.StoredProcName := 'PDV_STORE_SHOW_OCUPANTES';
        Store.Params.ParamByName('IN_TERMINAL').AsString := Terminal;
        Store.Params.ParamByName('IN_FECHA').AsString := FormatDateTime('YYYY-MM-DD',fecha)+ ' ' + tiempo;
        Store.Params.ParamByName('IN_CORRIDA').AsString := Corrida;
        Store.Open;
        li_row := 0;
        with Store do begin
            Store.First;
            while not EoF do begin
                if Store['TOTAL'] < 0 then
                    li_total := 0
                else
                    li_total := Store['TOTAL'];
                Grid.Cells[_OCUPANTES_DESCRIBE,li_row] := UpperCase(Store['DESCRIPCION']);
                Grid.Cells[_OCUPANTES_TOTAL, li_row] := IntToStr(li_total);
                gds_ocupantes_disponibles.Add(Store['DESCRIPCION'],IntToStr(li_total));
                Inc(li_row);
                Next;
            end;
        end;
        Grid.RowCount := li_row;
    finally
        Store.Free;
        Store := nil;
        qry.Free;
        qry := nil;
    end;

end;


procedure asignaVentaNew(trabid, terminal : string; taquilla:integer);
var
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := DM.Conecta;
        store.StoredProcName := 'PDV_STORE_REGISTRA_CORTE';
        store.Params.ParamByName('IN_TRABID').AsString := trabid;
        store.Params.ParamByName('IN_TERMINAL').AsString := terminal;
        store.Params.ParamByName('IN_TAQUILLA').AsInteger := taquilla;
        store.Open;
        if VarIsNull(store['FONDO_INICIAL']) then
          gi_fondo_inicial_store := -1
        else gi_fondo_inicial_store := store['FONDO_INICIAL'];
        try
          gi_corte_store         := store['ID_CORTE'];
          gs_trabid_store        := store['ID_EMPLEADO'];
          gs_estatus_store       := store['ESTATUS'];
          gi_taquilla_store      := store['ID_TAQUILLA'];
          gi_out_valida_asignarse := store['OUT_OK'];
          gi_impresion_carga     := store['CARGA_INICIAL'];
        except
        end;
    finally
       store.Free;
       store := nil;
    end;
end;


function estatus_corrida(corrida, fecha, terminal : string) : string;
var
    lq_query : TSQLQuery;
    ls_out : string;
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := CONEXION_VTA;
    lq_query.sql.Clear;
    lq_query.SQL.Add('SELECT ESTATUS');
    lq_query.SQL.Add('FROM PDV_T_CORRIDA_D');
    lq_query.SQL.Add('WHERE ID_CORRIDA = :corrida AND FECHA = :fecha AND ID_TERMINAL = :terminal ');
    lq_query.Params[0].AsString := corrida;
    lq_query.Params[1].AsString := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
    lq_query.Params[2].AsString := terminal;
    lq_query.Open;
    if VarIsNull(lq_query['ESTATUS']) then
        ls_out := ''
    else
        ls_out := lq_query['ESTATUS'];
    lq_query.Free;

    Result := ls_out;
{var
    store : TSQLStoredProc;
    ls_out : string;
begin
    if length(corrida) = 0 then begin
        ls_out := '';
    end else begin
        store := TSQLStoredProc.Create(nil);
        try
            store.SQLConnection := CONEXION_VTA;
            store.Close;
            store.StoredProcName := 'PDV_STORE_ESTATUS_CORRIDAe';
            store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
            store.Params.ParamByName('IN_FECHA').AsString   := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
            store.Open;
            if VarIsNull(store['ESTATUS']) then
              ls_out := ''
            else
              ls_out := store['ESTATUS'];
        finally
            store.Free;
            store := nil;
        end;
    end;
    Result := ls_out;}
end;

function split_Hora(Input : String) : string;
var
    la_datos : gga_parameters;
    li_num : Integer;
begin
    splitLine(Input,' ',la_datos,li_num);
    if li_num = 0 then
       result :=  la_datos[0]
    else result :=  la_datos[1];

end;


function cupoCorridaVigente(corrida, fecha, hora : string; conexion : TSQLConnection) : integer;
var
    lq_qry : TSQLQuery;
    li_out : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    try
        lq_qry.SQLConnection := CONEXION_VTA;
        if EjecutaSQL(Format(_CUPO_CORRIDA_VENTA_ACTUAL,[corrida,fecha + ' ' +hora]),lq_qry,_LOCAL) then
            li_out := lq_qry['CUPO'];
    finally
        lq_qry.free;
        lq_qry := nil;
    end;
    Result := li_out;

end;


function cupoPieCorrida(corrida,fecha,terminal : string) : Integer;
var
    li_ctrl : integer;
    li_pie  : integer;
    str_query : string;
    lq_query : TSQLQuery;
begin //lo busque en la base
    lq_query := tsqlquery.Create(nil);
    lq_query.SQLConnection := CONEXION_VTA;
    try
        li_pie := 0;
        str_query := 'SELECT PIE FROM PDV_T_CORRIDA_D WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_TERMINAL = ''%s''';
        if EjecutaSQL(format(str_query,[corrida,fecha,terminal]),lq_query,_LOCAL) then begin
            if varisNull(lq_query['PIE']) then
                li_pie := 0
            else
                li_pie := lq_query['PIE'];
        end;
    finally
        lq_query.Free;
        lq_query := nil;
    end;
    Result := li_pie;
end;


function storeApartacorrida(corrida : String; fecha : TDate; terminal : String; trabid : string) : string;
var
    store : TSQLStoredProc;
    ls_out : string;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA;
    try
        store.Close;
        store.StoredProcName := 'PDV_STORE_VENTA_APARTA_CORRIDA';
        store.Params.ParamByName('IN_TRABID').AsString :=  trabid;
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        store.Params.ParamByName('IN_FECHA').AsString := FormatDateTime('YYYY-MM-DD',fecha);
        store.Open();
        store.First;
        ls_out := store['TRAB_ID'];
    finally
        store.Free;
        store := nil;
    end;
    Result := ls_out;
end;


function storeApartacorridaVenta(corrida : String; fecha : TDate; terminal : String; trabid : string) : string;
var
    store : TSQLStoredProc;
    ls_out : string;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA;
    try
        store.Close;
        store.StoredProcName := 'PDV_STORE_APARTA_CORRIDA';
        store.Params.ParamByName('IN_TRABID').AsString :=  trabid;
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        store.Params.ParamByName('IN_FECHA').AsString := FormatDateTime('YYYY-MM-DD',fecha);
        store.Open();
        store.First;
        ls_out := store['TRAB_ID'];
    finally
        store.Free;
        store := nil;
    end;
    Result := ls_out;
end;

procedure apartaCorrida(corrida : String; fecha : TDate; hora : String;
                        terminal : String; trabid : string; ruta : integer);
var
    serverRemoto : TSQLConnection;
    STORE    : TSQLStoredProc;
    HTerminal  : PorTerminal;
    ls_fecha : String;
begin
    STORE := TSQLStoredProc.Create(nil);
    ls_fecha := FormatDateTime('YYYY-MM-DD',fecha);
    try
//    if terminal = gs_terminal then begin///@para un acceso remoto
         STORE.SQLConnection := CONEXION_VTA;
         STORE.Close;
         STORE.StoredProcName := 'PDV_STORE_LIBERA_CORRIDA_UNICA';
         STORE.Params.ParamByName('IN_TRABID').AsString := trabid;
         STORE.Params.ParamByName('IN_CORRIDA').AsString := corrida;
         STORE.Params.ParamByName('IN_FECHA').AsString   := FormatDateTime('YYYY-MM-DD',fecha);
         STORE.ExecProc;
//    end;
    finally
      STORE.free;
      STORE := nil;
    end;
end;

function existe(lc_carac : Char) : Boolean;
var
    li_ctrl : Integer;
    lb_ok : Boolean;
begin
    lb_ok := false;
    for li_ctrl := 0 to  high(ga_caracteres) do
        if lc_carac = ga_caracteres[li_ctrl] then begin
            lb_ok := true;
            break;
        end;
    Result := lb_ok;
end;

function reWrite(ls_cadena: String) : String;
var
    li_ctrl_input : Integer;
    ls_out : String;
begin
    for li_ctrl_input := 1 to Length(ls_cadena) - 1 do
        ls_out := ls_out + ls_cadena[li_ctrl_input];
    Result := ls_out;
end;

function rangoAsientos(ls_cadena : string) : boolean;
var
    li_ctrl : Integer;
    lb_ok : Boolean;
begin
    lb_ok := False;
    try
      if Length(ls_cadena) > 0 then begin
          for li_ctrl := 0 to length(ls_cadena) do
              if ls_cadena[li_ctrl] = '-' then begin
                  lb_ok := true;
              end;
      end;///fin end
    except
    end;
    Result := lb_ok;
end;

function  nombreServicio(cortoName : string) : string;
var
    lq_query : TSQLQuery;
    ls_out   : string;
begin
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := dm.Conecta;
        if EjecutaSQL(Format( _VTA_NOMBRE_SERVICIO,[cortoName]),lq_query,_LOCAL) then
            ls_out := lq_query['DESCRIPCION'];
    finally
      lq_query.Free;
        lq_query := nil;
    end;
    Result := ls_out;
end;

procedure procesoVentaCuales(CualesAsientos : ga_asientos; li_maximo : integer; ls_corrida,
                         fecha, Origen, Destino, user, servicio : string; costo : real;
                         var array_Seat : array_asientos; taquilla, cobro_iva : integer; iva : Double);
var
    li_ctrl : integer;
    store   :  TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA;
    for li_ctrl := 0 to li_maximo - 1 do begin
        array_Seat[li_ctrl_asiento].corrida       := ls_corrida;
        array_Seat[li_ctrl_asiento].fecha_hora    := fecha;
        array_Seat[li_ctrl_asiento].asiento       := CualesAsientos[li_ctrl];    //li_asiento_continuo;
        array_Seat[li_ctrl_asiento].empleado      := user;
        array_Seat[li_ctrl_asiento].origen        := Origen;
        array_Seat[li_ctrl_asiento].destino       := Destino;
        array_Seat[li_ctrl_asiento].status        := 'V';
        array_Seat[li_ctrl_asiento].precio        := StrToFloat(Format('%0.2f',[costo]));
        array_Seat[li_ctrl_asiento].precio_original   := StrToFloat(Format('%0.2f',[costo]));
        array_Seat[li_ctrl_asiento].servicio      := StrToInt(servicio);
        array_Seat[li_ctrl_asiento].forma_pago    := 1; // para que se  efectivo
        array_Seat[li_ctrl_asiento].taquilla      := taquilla;//numero de la taquilla
        array_Seat[li_ctrl_asiento].descuento     := 0;
        array_Seat[li_ctrl_asiento].Ocupante      := 'Adulto';//descripcion del ocupante
        array_Seat[li_ctrl_asiento].tipo_tarifa   := 'A';//tipo ocupante
        array_Seat[li_ctrl_asiento].idOcupante    := 1;//siempre adulto pago_efectivo
        array_Seat[li_ctrl_asiento].pago_efectivo := 1;
        array_Seat[li_ctrl_asiento].abrePago      := 'EFE';
        array_Seat[li_ctrl_asiento].ruta          := gi_ruta;
        array_Seat[li_ctrl_asiento].calculado     := 0;
        array_Seat[li_ctrl_asiento].impreso       := 0;
        array_Seat[li_ctrl_asiento].iva           :=  RegresaIVA(FloatToStr(iva));
        array_Seat[li_ctrl_asiento].tipo_tarjeta  := ' ';
        array_Seat[li_ctrl_asiento].tarifa_real   := StrToFloat(Format('%0.2f',[costo]));
        if cobro_iva = 1 then
           array_Seat[li_ctrl_asiento].boleto_iva := StrToFloat(Format('%0.2f',[( (costo * iva / 100) + costo)]));
        if cobro_iva = 0 then
           array_Seat[li_ctrl_asiento].boleto_iva := StrToFloat(Format('%0.2f',[costo]));
        estatus_ASIENTO(array_Seat[li_ctrl_asiento],'N');
        inc(li_ctrl_asiento);
    end;
end;


procedure estatus_ASIENTO(asientos : PDV_Asientos; lc_opcion : Char);
var
    store_asiento : TSQLStoredProc;
    ls_fecha : string;
begin
    store_asiento := TSQLStoredProc.Create(nil);
    try
            store_asiento.SQLConnection := CONEXION_VTA; //DM.Conecta;
            store_asiento.Close;
            store_asiento.StoredProcName := 'PDV_STORE_VENTA_ASIENTO_DELETE';
            store_asiento.Params.ParamByName('IN_CORRIDA').AsString := asientos.corrida;
            if asientos.fecha_hora[3] = '/' then
               ls_fecha := copy(asientos.fecha_hora,7,4)+'-'+
                           copy(asientos.fecha_hora,4,2)+'-'+
                           copy(asientos.fecha_hora,1,2)+copy(asientos.fecha_hora,11,6)
            else
                ls_fecha := asientos.fecha_hora;
            store_asiento.Params.ParamByName('IN_FECHA').AsString  := ls_fecha;

            store_asiento.Params.ParamByName('IN_ASIENTO').AsInteger := asientos.asiento;
            store_asiento.Params.ParamByName('IN_TRABID').AsString   := asientos.empleado;
            store_asiento.Params.ParamByName('IN_ORIGEN').AsString   := asientos.origen;
            store_asiento.Params.ParamByName('IN_DESTINO').AsString  := asientos.destino;
            store_asiento.Params.ParamByName('IN_STATUS').AsString   := asientos.status;
            store_asiento.Params.ParamByName('IN_NUEVO').AsString    := lc_opcion;
            store_asiento.ExecProc();
    except
            ;
    end;
      store_asiento.Free;
      store_asiento := nil;

end;



function validaCualesOcupantes(ls_cadena : string) :  String;
var
    li_cantidad, li_num, li_ctrl,li_compara : integer;
    la_valida   : gga_parameters;
    ls_out,ls_letra      : String;
begin
    splitLine(ls_cadena,' ',la_valida,li_num);
    if li_num = 0 then begin
        ls_cadena := Trim(ls_cadena);
        try
        li_cantidad := StrToInt(Copy(ls_cadena,1, length(ls_cadena) - 1));
        except
            Mensaje('No es un valor correcto verifiquelo',2);
        end;
        ls_letra   := Copy(ls_cadena,length(ls_cadena),1);//letra M
        if ls_letra = 'A' then begin
            result := 'El tipo de ocupante Adulto es por default';
            exit;
        end;
        ls_cadena   := gds_ListaOcupantes.ValueOf(Copy(ls_letra,length(ls_letra),1));//valor descripcion
        try
            li_compara := StrToInt(gds_ocupantes_disponibles.ValueOf(ls_cadena));
        except
            li_compara := 0;
        end;
        if (li_cantidad > li_compara) or (li_compara = 0) then
          ls_out := ls_cadena + ': Es mayor a la permitida'
        else begin //agregamos en dualstring el numero de ocupantes y tipo
                  gds_ocupantes_asignados.Add(ls_letra, IntToStr(li_cantidad));
                  ls_out := '';
        end;
    end else begin
        for li_ctrl := 0 to li_num do begin
           li_cantidad := StrToInt(Copy(la_valida[li_ctrl],1, length(la_valida[li_ctrl]) - 1));
           la_valida[li_ctrl] := Trim(la_valida[li_ctrl]);
           ls_letra := Copy(la_valida[li_ctrl],length(la_valida[li_ctrl]),1);//letra
           if ls_letra = 'A' then begin
                result := 'El tipo de ocupante Adulto es por default';
                exit;
           end;
           ls_cadena   := gds_ListaOcupantes.ValueOf(Copy(ls_letra,length(ls_letra),1));//valor descripcion
           try
               li_compara := StrToInt(gds_ocupantes_disponibles.ValueOf(ls_cadena));
           except
               li_compara := 0;
           end;
           if (li_cantidad > li_compara) or (li_compara = 0)then begin
              ls_out := ls_out + #10#13 + ls_cadena + ': Es mayor a la permitida';
              break;
           end else begin
                   gds_ocupantes_asignados.Add(ls_letra, IntToStr(li_cantidad));
                   ls_out := '';
           end;
        end;
    end;
    result := ls_out;

end;



procedure recalculaPrecioConDescuento(var arreglo : array_asientos);
var
    li_ctrl, li_cantidad, li_ctrl_interno :  Integer;
    li_descuento : real;
    li_idOcupante : integer;
    ls_id, ls_valor, ls_descripcion : string;
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := DM.Conecta;
    for li_ctrl := 0 to gds_ocupantes_asignados.Count - 1 do begin
         ls_id := gds_ocupantes_asignados.ID[li_ctrl];//letra
         li_cantidad := StrToInt(gds_ocupantes_asignados.ValueOf(ls_id));
         store.Close;
         store.StoredProcName := 'PDV_STORE_DESCUENTO_OCUPANTE';
         store.Params.ParamByName('IN_ABREVIA').AsString := ls_id;
         store.Open;
         with store do begin
            First;
            while not EoF do begin
              li_idOcupante  := store['ID_OCUPANTE'];
              li_descuento   := store['DESCUENTO'];
              ls_descripcion := store['DESCRIPCION'];
              Next;
            end;
         end;
         for li_ctrl_interno := 1 to li_cantidad do begin
            if arreglo[gi_arreglo].calculado = 0 then begin
               arreglo[gi_arreglo].precio      := arreglo[gi_arreglo].precio_original -
                                                    (arreglo[gi_arreglo].precio_original * li_descuento/100);
               arreglo[gi_arreglo].precio := StrToFloat(format('%0.2f',[arreglo[gi_arreglo].precio]));
               arreglo[gi_arreglo].precio_original := arreglo[gi_arreglo].precio;
               arreglo[gi_arreglo].Ocupante    := ls_descripcion;
               arreglo[gi_arreglo].idOcupante  := li_idOcupante;
               arreglo[gi_arreglo].descuento   := li_descuento;//aqui modifica
               arreglo[gi_arreglo].tipo_tarifa := ls_id;
               arreglo[gi_arreglo].abrePago    := 'EFE';
               arreglo[gi_arreglo].calculado   := 1;
               arreglo[gi_arreglo].boleto_iva  := ((arreglo[gi_arreglo].precio * arreglo[gi_arreglo].iva) / 100) + arreglo[gi_arreglo].precio;
               inc(gi_arreglo);
            end;
         end;
    end;

end;


procedure buscaOcupantes(Grid : TStringGrid; opcion : integer);
var
    lq_query : TSQLQuery;
    li_row, li_ctrl,li_fila,li_col  : Integer;
begin
    try
        lq_query := TSQLQuery.Create(nil);
        lq_query.SQLConnection := CONEXION_VTA; //DM.Conecta;
        gds_ListaOcupantes := TDualStrings.Create();
        if EjecutaSQL(Format(_VTA_OCUPANTES,[intToStr(opcion)]),lq_query,_LOCAL) then
          with lq_query do begin
            First;
            li_row := 1;
            li_col := 1;
            li_fila := 1;
            while not EoF do begin
              for li_ctrl := 0 to lq_query.FieldCount - 1 do begin
                  Grid.Cells[li_ctrl, li_row] := lq_query.Fields[li_ctrl].AsString;
              end;//fin for
              gds_ListaOcupantes.Add(lq_query['ABREVIACION'],lq_query['DESCRIPCION']);
              inc(li_row);
              next;
            end;//fin while
          end;//fin with
          grid.RowCount := li_row;
    finally
        lq_query.Free;
        lq_query := nil;
    end;

end;


function calcula(arreglo : array_asientos; li_vendidos : Integer) : Currency;
var
    li_ctrl_int :  Integer;
    ld_total    : Currency;
begin
    ld_total := 0.0;
    for li_ctrl_int := 1 to li_ctrl_asiento - 1 do begin
          ld_total := ld_total + arreglo[li_ctrl_int].precio;
    end;
    Result := ld_total;
end;

function codigoUnico(seats : array_asientos; indice : integer) : string;
var
    STOREN : TSQLStoredProc;
    str_clave : string;
begin
    STOREN := TSQLStoredProc.Create(nil);
    STOREN.SQLConnection := DM.Conecta;
    STOREN.Close;
    STOREN.StoredProcName := 'PDV_STORE_EXTRAE_CODIGO';
    STOREN.Params.ParamByName('IN_TERMINAL').AsString := gs_terminal;
    STOREN.Params.ParamByName('IN_TRABID').AsString   := seats[indice].empleado;
    STOREN.Params.ParamByName('IN_ORIGEN').AsString   := seats[indice].origen;
    STOREN.Params.ParamByName('IN_DESTINO').AsString  := seats[indice].destino;
    STOREN.Params.ParamByName('IN_CORRIDA').AsString  := seats[indice].corrida;
    STOREN.Params.ParamByName('IN_ASIENTO').AsInteger := seats[indice].asiento;
    STOREN.Params.ParamByName('IN_FECHA').AsString    := Copy(seats[indice].fecha_hora,1,10);
    STOREN.Open;
    if VarIsNull(STOREN['CLAVE']) then
        str_clave := '10000.root.mex'
    else
        str_clave := STOREN['CLAVE'];
    STOREN.Free;
    Result := str_clave;
end;

function generaCodigoVerificador(str_cifrada : String): String;
var
    li_ctrl, li_multiplica, li_total, li_mod, li_calcular : integer;
begin
    li_multiplica := 2;
    li_total := 0;
    for li_ctrl := 1 to length(str_cifrada) do begin
        li_calcular := (StrToInt(str_cifrada[li_ctrl]) * (li_multiplica));
        li_total := li_total + li_calcular;
        if li_multiplica < 7 then
            inc(li_multiplica)
        else
            li_multiplica := 2;
    end;
    li_mod := li_total  mod 11;
    li_total := 11 - li_mod;
    Result := IntToStr(li_total)
end;


function obtieneDigitoVerificador(str_cadenaUnica :String) : string;
var
    str_out : string;
    li_ctrl : integer;
    c_Caracter : char;
    out_entero : string;
begin
    for li_ctrl := 1 to length(str_cadenaUnica) do begin
        c_Caracter := str_cadenaUnica[li_ctrl];
        if not (c_Caracter in ['1'..'9']) then begin
            //entonces no es numero
            out_entero := out_entero + IntToStr(Ord(c_Caracter));
        end else
             out_entero := out_entero + c_Caracter;
    end;
    Result := generaCodigoVerificador(out_entero);
end;

function getCodeImprime(str_user : String) : string;
var
   lq_codigo : TSQLQuery;
   str_cdn, str_tmp   : string;
   li_ctrl, li_pro : integer;
   lc_char : char;
begin
    lq_codigo := TSQLQuery.Create(nil);
    lq_codigo.SQLConnection := Dm.conecta;
    if EjecutaSQL(Format(_CODIGO_UNICO,[str_user]),lq_codigo,_LOCAL) then
        str_cdn := lq_codigo['CODE'];
    lq_codigo.Free;
    result := str_cdn;
//    result := FormatMaskText('000000-000000-000000-000000-000000-000000;0',  str_cdn);
end;

procedure borrrarItemArreglo(var asientos : array_asientos; li_idx : integer);
var
    li_ctrl : integer;
begin
   asientos[li_ctrl].corrida := '';
   asientos[li_ctrl].fecha_hora := '';
   asientos[li_ctrl].asiento := 0;
   asientos[li_ctrl].empleado := '';
   asientos[li_ctrl].origen   := '';
   asientos[li_ctrl].destino  := '';
   asientos[li_ctrl].status   := ' ';
   asientos[li_ctrl].precio   := 0;
   asientos[li_ctrl].precio_original := 0;
   asientos[li_ctrl].servicio := 0;
   asientos[li_ctrl].forma_pago := 0;
   asientos[li_ctrl].descuento := 0;
   asientos[li_ctrl].Ocupante  := '';
   asientos[li_ctrl].tipo_tarifa := '';
   asientos[li_ctrl].idOcupante := 0;
   asientos[li_ctrl].taquilla  := 0;
   asientos[li_ctrl].nombre    := '';
   asientos[li_ctrl].abrePago  := '';
   asientos[li_ctrl].ruta      := 0;
   asientos[li_ctrl].pago_efectivo := 0;
   asientos[li_ctrl].calculado := 0;
   asientos[li_ctrl].impreso   := 0;
   asientos[li_ctrl].iva       := 0;
   asientos[li_ctrl].boleto_iva := 0;
end;




function EnteroReturn(int_dato : integer) : integer;
var
    li_out : Integer;
begin
    li_out := int_dato;
    result := li_out;
end;

procedure BorraArregloIDs(var asientos : array_asientos; li_elegido : integer);
begin
      asientos[li_elegido].corrida     := '';
      asientos[li_elegido].fecha_hora  := '';
      asientos[li_elegido].asiento     := 0;
      asientos[li_elegido].empleado    := '';
      asientos[li_elegido].origen      := '';
      asientos[li_elegido].destino     := '';
      asientos[li_elegido].status      := ' ';
      asientos[li_elegido].precio      := 0;
      asientos[li_elegido].precio_original  := 0;
      asientos[li_elegido].servicio    := 0;
      asientos[li_elegido].forma_pago  := 0;
      asientos[li_elegido].descuento   := 0;
      asientos[li_elegido].Ocupante    := '';
      asientos[li_elegido].tipo_tarifa := '';
      asientos[li_elegido].idOcupante  := 0;
      asientos[li_elegido].taquilla    := 0;
      asientos[li_elegido].nombre      := '';
      asientos[li_elegido].abrePago    := '';
      asientos[li_elegido].ruta        := 0;
      asientos[li_elegido].pago_efectivo := 0;
      asientos[li_elegido].calculado   := 0;
      asientos[li_elegido].impreso   := 0;
      asientos[li_elegido].iva       := 0;
      asientos[li_elegido].boleto_iva := 0;
end;

function existeBoletoPromotor(corrida, fecha : string; asiento : integer; trab_id : string) : boolean;
var
    STORE : TSQLStoredProc;
    out_b : Boolean;
begin
    STORE := TSQLStoredProc.Create(nil);
    STORE.SQLConnection := Dm.conecta;
    STORE.Close;
    STORE.StoredProcName := 'PDV_STORE_BUSCA_BOLETO_VENDIDO';
    STORE.Params.ParamByName('IN_CORRIDA').AsString     := corrida;
    STORE.Params.ParamByName('IN_FECHA').AsString     := fecha;
    STORE.Params.ParamByName('IN_ASIENTO').AsInteger     := asiento;
    STORE.Params.ParamByName('IN_TRABID').AsString    := trab_id;
    STORE.Open;
    if STORE['EXISTE'] = 1 then
        out_b := true
    else
        out_b := False;
    STORE.Free;
    result := out_b;
end;

function getExpedicion(terminal : string) : String;
const
    _EXPEDIDO = 'SELECT LUGAR_EXPEDICION FROM PDV_C_GRUPO_SERVICIOS GS '+
                'WHERE GS.ID_TERMINAL = ''%s'' ';
var
    lq_expedido : TSQLQuery;
    ls_out : string;
begin
    lq_expedido := TSQLQuery.create(nil);
    lq_expedido.SQLConnection := Dm.conecta;
    if EjecutaSQL(Format(_EXPEDIDO,[terminal]), lq_expedido, _LOCAL) then
        ls_out := lq_expedido['LUGAR_EXPEDICION'];
    lq_expedido.free;

    Result := (ls_out);
end;

function verificaCorteTrabId(corte_num : integer) : string;
CONST
    _VERIFICA_CORTE_TRABID = 'SELECT TRIM(ID_EMPLEADO)AS EMPLEADO FROM PDV_T_CORTE C '+
                             'WHERE C.ID_CORTE = %s AND FECHA_FIN IS NULL AND ESTATUS IN (''A'') ';
var
    lq_corte_trabid : TSQLQuery;
    ls_out_trabId : String;
begin
    lq_corte_trabid := TSQLQuery.Create(nil);
    lq_corte_trabid.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_VERIFICA_CORTE_TRABID, [IntToStr(corte_num)]) , lq_corte_trabid, _LOCAL) then
        ls_out_trabId := lq_corte_trabid['EMPLEADO'];

    lq_corte_trabid.Destroy;
    result := ls_out_trabId;
end;

function getComplementoTTarifa() : string;
begin
      if gs_terminal = 'SD1' then Result := 'S';
      if gs_terminal = 'SD2' then Result := 'S';
      if gs_terminal = 'SD3' then Result := 'S';
      if gs_terminal = 'SD4' then Result := 'S';
      if gs_terminal = 'SD5' then Result := 'S';
      if gs_terminal = 'SD6' then Result := 'S';
      if gs_terminal = 'SD7' then Result := 'S';
      if gs_terminal = 'SD8' then Result := 'S';
      if gs_terminal = 'SD9' then Result := 'S';
      if gs_terminal = 'SD10' then Result := 'S';
end;


procedure ImprimeBoletos(var asientos : array_asientos; li_vendidos : Integer);
var
    li_ctrl_interno, li_num, li_ruta : Integer;
    la_datos, la_imprime : gga_parameters;
    ls_hora, ls_qry, sentencia, sentencia_error : string;
    STORE   : TSQLStoredProc;
    lq_query, lq_local, lq_tarjeta, lq_qry, lq_seatRemote : TSQLQuery;
    ls_ithaca, ls_hora_server, ls_dVerificador, ls_toshiba, ls_usuario_sim, str_factura, ls_iva_boleto, ls_OPOS, ls_asiento : string;
    ls_iva_replica, ls_iva_por_boleto, ls_fecha_ventaBoleto, ls_codigo_abierto : String;
    hilo_libera : Libera_Asientos;
    ld_boleto, ld_subtotal, ld_iva, ld_total : double;
    li_FolioBoleto : integer;
begin
    ls_usuario_sim := '';
    str_factura := '';
    str_factura := UpperCase(getCodeImprime(gs_trab_unico+gs_terminal+gs_maquina));//obtenemos el tc
    if trim(gs_trab_unico) <> verificaCorteTrabId(gi_corte_store) then begin
        gb_asignado := false;
        gs_trab_unico := '';
        Mensaje('No estas asignado a la venta favor de asignarse nuevamente',1);
        ErrorLog('Error se perdio la asignacion',IntToStr(gi_opcion));
        insertaEvento(gs_trab_unico,gs_terminal,'Error esta nulo la clave de usuario ' +
                      intToStr(gi_opcion));
        exit;
    end;
    ls_codigo_abierto := '';
    for li_ctrl_interno := 1 to li_vendidos do begin
       splitLine(asientos[li_ctrl_interno].fecha_hora,' ',la_datos,li_num);
       if gi_venta_masiva = 1 then
          str_factura := UpperCase(getCodeImprime(gs_trab_unico+gs_terminal+gs_maquina+IntToStr(random(999999))));//obtenemos el tc

       if li_num = 0 then ls_hora :=  la_datos[1]
       else  ls_hora := la_datos[li_num];

       try
            if gi_impresion_personalizada = 1 then begin
                if length(ga_boletos_nombres[li_ctrl_interno])  > 0 then
                    gs_nombre_pax_nueva := quiapo(ga_boletos_nombres[li_ctrl_interno])
                else
                    gs_nombre_pax_nueva := '';
            end;
            lq_query := TSQLQuery.Create(nil);
            if (asientos[li_ctrl_interno].empleado = '') or (length(asientos[li_ctrl_interno].empleado) = 0) then
                asientos[li_ctrl_interno].empleado := gs_trab_unico;
            gs_destino_ruta := asientos[li_ctrl_interno].destino;
            lq_query.SQLConnection := Dm.conecta;
            STORE := TSQLStoredProc.Create(nil);
            if gb_boleto_abierto then begin
                ls_codigo_abierto   := asientos[li_ctrl_interno].corrida;
            end;

            li_FolioBoleto := insertaBoleto( Dm.conecta, gs_terminal, gs_trab_unico, 'V',
                                              CadenaReturn(asientos[li_ctrl_interno].origen), CadenaReturn(asientos[li_ctrl_interno].destino),
                                              FloatToStr(asientos[li_ctrl_interno].precio), EnteroReturn(asientos[li_ctrl_interno].forma_pago),
                                              EnteroReturn(asientos[li_ctrl_interno].taquilla), CadenaReturn(asientos[li_ctrl_interno].tipo_tarifa),
                                              CadenaReturn(asientos[li_ctrl_interno].corrida), asientos[li_ctrl_interno].fecha_hora,
                                              UpperCase(gs_nombre_pax_nueva), EnteroReturn(asientos[li_ctrl_interno].asiento),
                                              EnteroReturn(asientos[li_ctrl_interno].idOcupante), asientos[li_ctrl_interno].fecha_hora,
                                              EnteroReturn(asientos[li_ctrl_interno].ruta), IntToStr(asientos[li_ctrl_interno].servicio),
                                              asientos[li_ctrl_interno].id_pago_pinpad_banamex, str_factura,
                                              asientos[li_ctrl_interno].iva ,asientos[li_ctrl_interno].tipo_tarjeta );


            if gb_venta_remota then begin
//                  updateHoraCorrida(DM.Conecta, li_FolioBoleto, gs_terminal, gs_trab_unico, copy(  asientos[li_ctrl_interno].fecha_hora,12, 5 ) );

{
UPDATE PDV_T_BOLETO SET HORA_CORRIDA = (SELECT HORA
										FROM PDV_T_CORRIDA_D
										WHERE ID_CORRIDA =  NAME_CONST('IN_CORRIDA',_latin1'430' COLLATE 'latin1_swedish_ci') AND
										FECHA =  NAME_CONST('IN_FECHA',DATE'2022-12-08') AND
										ID_TERMINAL =  NAME_CONST('IN_TERMINAL',_latin1'MEX' COLLATE 'latin1_swedish_ci'))
WHERE ID_BOLETO =  NAME_CONST('IDBOLETO',NULL) AND ID_TERMINAL =  NAME_CONST('IN_TERMINAL',_latin1'MEX' COLLATE 'latin1_swedish_ci') AND
TRAB_ID =  NAME_CONST('IN_TRABID',_latin1'root' COLLATE 'latin1_swedish_ci')	}
                  insertaBoletoRemoto( CONEXION_VTA, gs_terminal, gs_trab_unico, 'V',
                                 CadenaReturn(asientos[li_ctrl_interno].origen), CadenaReturn(asientos[li_ctrl_interno].destino),
                                 FloatToStr(asientos[li_ctrl_interno].precio), EnteroReturn(asientos[li_ctrl_interno].forma_pago),
                                 EnteroReturn(asientos[li_ctrl_interno].taquilla), CadenaReturn(asientos[li_ctrl_interno].tipo_tarifa),
                                 CadenaReturn(asientos[li_ctrl_interno].corrida), asientos[li_ctrl_interno].fecha_hora,
                                 UpperCase(gs_nombre_pax_nueva), EnteroReturn(asientos[li_ctrl_interno].asiento),
                                 EnteroReturn(asientos[li_ctrl_interno].idOcupante), asientos[li_ctrl_interno].fecha_hora,
                                 EnteroReturn(asientos[li_ctrl_interno].ruta), IntToStr(asientos[li_ctrl_interno].servicio),
                                 asientos[li_ctrl_interno].id_pago_pinpad_banamex, str_factura,
                                 asientos[li_ctrl_interno].iva ,asientos[li_ctrl_interno].tipo_tarjeta );
                try
                    STORE.SQLConnection := CONEXION_VTA;
                    STORE.Close;//solo se registra el asiento
                    STORE.StoredProcName := 'PDV_STORE_ASIENTO_REMOTO';
                    STORE.Params.ParamByName('IN_CORRIDA').AsString   := asientos[li_ctrl_interno].corrida;
                    STORE.Params.ParamByName('IN_FECHAHORA').AsString := asientos[li_ctrl_interno].fecha_hora;
                    STORE.Params.ParamByName('IN_ASIENTO').AsInteger  := asientos[li_ctrl_interno].asiento;
                    STORE.Params.ParamByName('IN_PASAJERO').AsString  := asientos[li_ctrl_interno].Ocupante;
                    STORE.Params.ParamByName('IN_TER_RESERVACION').AsString := gs_terminal;
                    STORE.Params.ParamByName('IN_TRABID').AsString    := gs_trab_unico;//asientos[li_ctrl_interno].empleado;
                    STORE.Params.ParamByName('IN_ORIGEN').AsString    := asientos[li_ctrl_interno].origen;
                    STORE.Params.ParamByName('IN_DESTINO').AsString   := asientos[li_ctrl_interno].destino;
                    STORE.ExecProc();//asegurarse que el asiento esta registrado en el sevidor remoto
                except
                    on E : Exception do begin

                      sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR,[asientos[li_ctrl_interno].corrida,
                                            asientos[li_ctrl_interno].fecha_hora + ' 00:00:00',
                                            intToStr(asientos[li_ctrl_interno].asiento),asientos[li_ctrl_interno].Ocupante,gs_terminal,
                                            gs_trab_unico, asientos[li_ctrl_interno].origen, asientos[li_ctrl_interno].destino,'V']);
                      lq_seatRemote := TSQLQuery.Create(nil);
                      lq_seatRemote.SQLConnection := CONEXION_VTA;
                      if EjecutaSQL(sentencia, lq_seatRemote, _LOCAL ) then
                          ;

                      sentencia_error := 'PDV_STORE_ASIENTO_REMOTO';
                      errorlog('FPago :'+sentencia_error,E.Message);
                    end;
                end;
            end;
            if gb_boleto_abierto = false then begin
                STORE.SQLConnection := Dm.conecta;
                consultaBoleto(li_FolioBoleto, gs_terminal, CadenaReturn(asientos[li_ctrl_interno].empleado), STORE);
                splitLine(STORE['NOMBRE_PASAJERO'],'*',la_imprime,li_num);
                if Length(la_imprime[0]) > 0 then  la_imprime[0] :=  'Nombre : '+ la_imprime[0]
                else  la_imprime[0] := '';

                if gs_impresora_boleto = _IMP_TOSHIBA_TEC then  begin //si es boleto continuo(STORE,la_imprime[0]);
                  if gi_boleto_continuo = 0 then
                      imprimeBoleto101(STORE,la_imprime[0]);
                  if gi_boleto_continuo = 1 then
                      imprimeBoletoContinuo(STORE, la_imprime[0]);
                end;

                if gs_impresora_boleto = _IMP_IMPRESORA_OPOS then
                    imprimeBoletoTermica(STORE,la_imprime[0]);

                insertaBoletoServer(DM.Conecta, STORE);

                sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR,[STORE['ID_CORRIDA'],
                                    formatDateTime('YYYY-MM-DD',STORE['FECHA']) + ' 00:00:00',
                                    intToStr(STORE['NO_ASIENTO']),STORE['NOMBRE_PASAJERO'],gs_terminal,
                                    STORE['TRAB_ID'], STORE['ORIGEN'], STORE['DESTINO'],'V']);
                hilo_libera := Libera_Asientos.Create(true);
                hilo_libera.server := CONEXION_VTA;
                hilo_libera.sentenciaSQL := sentencia;
                hilo_libera.ruta   := asientos[li_ctrl_interno].ruta;//StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
                hilo_libera.origen := asientos[li_ctrl_interno].origen;
                hilo_libera.destino := asientos[li_ctrl_interno].destino;
                hilo_libera.Priority := tpNormal;
                hilo_libera.FreeOnTerminate := True;
                hilo_libera.start;
                CORRIDA_ULTIMA_VTA.origen := STORE['ORIGEN'];
                CORRIDA_ULTIMA_VTA.destino := STORE['DESTINO'];
                CORRIDA_ULTIMA_VTA.hora    := STORE['HORA'];
                CORRIDA_ULTIMA_VTA.fecha   := STORE['FECHA'];
                CORRIDA_ULTIMA_VTA.servicio := IntToStr(STORE['TIPOSERVICIO']);
                CORRIDA_ULTIMA_VTA.corrida := STORE['ID_CORRIDA'];
            end;//fin gb_boleto_abierto = false nuevo
       finally
          STORE.Free;
       end;
       gs_nombre_pax_nueva := '';
       BorraArregloIDs(asientos,li_ctrl_interno);
    end;//fin for
    if gb_boleto_abierto = true then begin
        insertaBoletoAbierto( Dm.conecta, ls_codigo_abierto);
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        if EjecutaSQL(format(_ABIERTO_PROMOCION_BOLETO, [ls_codigo_abierto]), lq_qry, _LOCAL) then begin
            if gs_impresora_boleto = _IMP_TOSHIBA_TEC then //impresora TEC Toshiba
                imprimeVigenciaSX4(lq_qry);
            if gs_impresora_boleto = _IMP_IMPRESORA_OPOS then //impresora Toshiba miniprinter
                imprimeVigenciaNuevaTermica(lq_qry);
        end;
        lq_qry := nil;
    end;
    BorraArregloLibera(asientos);
    gs_nombre_pax_nueva := '';
end;


function verificaMismaCorrida(var asientos : array_asientos) : boolean;
var
    li_ctrl_array : integer;
    ls_corrida : string;
    lb_out : Boolean;
begin
    lb_out := False;
    ls_corrida := asientos[1].corrida;
    for li_ctrl_array := 1 to high(asientos) do begin
        if length(asientos[li_ctrl_array].corrida) > 0 then begin
            if ls_corrida = asientos[li_ctrl_array].corrida then
                lb_out := True
            else
                lb_out := False;
        end;
    end;
    Result := lb_out;
end;

function parametroValor(parametro : integer): integer;
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_VTA_VIAJE_REDONDO,[IntToStr(parametro)]), lq_qry, _LOCAL) then
      result := lq_qry['VALOR'];
    lq_qry.Free;
end;

procedure calculaDtoGrupal(var asientos : array_asientos);
var
    li_ctrl, li_porcentaje : integer;

begin
      li_porcentaje := parametroValor(42);
      for li_ctrl := 0 to li_ctrl_asiento - 1 do begin
        if asientos[li_ctrl].pago_efectivo = 1 then begin
            asientos[li_ctrl].precio :=  (asientos[li_ctrl].precio_original - ((asientos[li_ctrl].precio_original * li_porcentaje) / 100));
        end;
      end;
end;

procedure calculoDtoViajeRndo(var asientos : array_asientos);
var
    li_porcentaje, li_ctrl : integer;
begin
    li_porcentaje := parametroValor(43);
    for li_ctrl := 0 to li_ctrl_asiento - 1 do begin
      if asientos[li_ctrl].pago_efectivo = 1 then begin
          asientos[li_ctrl].precio :=  (asientos[li_ctrl].precio_original - ((asientos[li_ctrl].precio_original * li_porcentaje) / 100));
      end;
    end;
end;



function minimoAdultoPermitidos(var asientos : array_asientos) : boolean;
var
    li_minimo, li_ctrl : integer;
begin
//    li_minimo := parametro41();
    li_minimo := parametroValor(41);
    for li_ctrl := 1 to High(asientos) do begin
      if asientos[li_ctrl].asiento = 0 then
          Break
    end;
    if ((li_ctrl - 1) >= li_minimo)  then
      Result := True
    else
      Result := False;
end;


function siEsViajeRedondo(var asientos : array_asientos) : boolean;
var
    li_ctrl  : integer;
begin
    ga_viaje_redondo[0].origen := '';
    ga_viaje_redondo[0].destino := '';
    ga_viaje_redondo[0].total := 0;

    ga_viaje_redondo[1].origen := '';
    ga_viaje_redondo[1].destino := '';
    ga_viaje_redondo[1].total := 0;

    for li_ctrl := 1 to High(asientos) do begin
        if length(asientos[li_ctrl].origen) > 0 then begin
            if length(ga_viaje_redondo[0].origen) = 0 then begin
                ga_viaje_redondo[0].origen := asientos[li_ctrl].origen;
                ga_viaje_redondo[0].destino := asientos[li_ctrl].destino;
            end else begin
                if ga_viaje_redondo[0].origen <> asientos[li_ctrl].origen then begin
                  ga_viaje_redondo[1].origen := asientos[li_ctrl].origen;
                  ga_viaje_redondo[1].destino := asientos[li_ctrl].destino;
                end;
            end;
        end;
    end;
    if ga_viaje_redondo[0].destino = ga_viaje_redondo[1].origen then
      Result := true
    else
      Result := false;
end;

function igualIdeRegreso(var asientos : array_asientos): boolean;
var
    li_ctrl, li_idx : integer;
begin

    for li_ctrl := 0 to 1 do begin
        for li_idx := 1 to High(asientos) do begin
            if ga_viaje_redondo[li_ctrl].origen = asientos[li_idx].origen then
                ga_viaje_redondo[li_ctrl].total := ga_viaje_redondo[li_ctrl].total + 1;
        end;
    end;
    if ga_viaje_redondo[0].total = ga_viaje_redondo[1].total then
      Result := true
    else
      Result := false;

end;

function verificaSoloAdulto(var asientos : array_asientos) : boolean;
var
    li_ctrl_array : integer;
    ls_Ocupante : string;
    lb_out : Boolean;
begin
    lb_out := False;
    ls_Ocupante := 'A';
    for li_ctrl_array := 1 to high(asientos) do begin
        if length(asientos[li_ctrl_array].tipo_tarifa) > 0 then begin
            if ls_Ocupante = asientos[li_ctrl_array].tipo_tarifa then
                lb_out := True
            else
                lb_out := False;
        end;
    end;
    Result := lb_out;
end;




procedure BorraArregloAsientos(var asientos : array_asientos);
var
    li_ctrl_array : integer;
    store_asiento : TSQLStoredProc;
    ls_fecha : string;
begin
    for li_ctrl_array := 1 to high(asientos) do begin
        if asientos[li_ctrl_array].corrida <> '' then begin
              store_asiento := TSQLStoredProc.Create(nil);
              try
                      store_asiento.SQLConnection := CONEXION_VTA; //DM.Conecta;
                      store_asiento.Close;
                      store_asiento.StoredProcName := 'PDV_STORE_VENTA_ASIENTO_DELETE';
                      store_asiento.Params.ParamByName('IN_CORRIDA').AsString := asientos[li_ctrl_array].corrida;
                      if asientos[li_ctrl_array].fecha_hora[3] = '/' then
                         ls_fecha := copy(asientos[li_ctrl_array].fecha_hora,7,4)+'-'+
                                     copy(asientos[li_ctrl_array].fecha_hora,4,2)+'-'+
                                     copy(asientos[li_ctrl_array].fecha_hora,1,2)+copy(asientos[li_ctrl_array].fecha_hora,11,6)
                      else
                          ls_fecha := asientos[li_ctrl_array].fecha_hora;
                      store_asiento.Params.ParamByName('IN_FECHA').AsString  := ls_fecha;
                      store_asiento.Params.ParamByName('IN_ASIENTO').AsInteger := asientos[li_ctrl_array].asiento;
                      store_asiento.Params.ParamByName('IN_TRABID').AsString   := asientos[li_ctrl_array].empleado;
                      store_asiento.Params.ParamByName('IN_ORIGEN').AsString   := asientos[li_ctrl_array].origen;
                      store_asiento.Params.ParamByName('IN_DESTINO').AsString   := asientos[li_ctrl_array].destino;
                      store_asiento.Params.ParamByName('IN_STATUS').AsString   := asientos[li_ctrl_array].status;
                      store_asiento.Params.ParamByName('IN_NUEVO').AsString    := 'D';
                      store_asiento.ExecProc();
              finally
                store_asiento.Free;
                store_asiento := nil;
              end;
        end;
        asientos[li_ctrl_array].corrida     := '';
        asientos[li_ctrl_array].fecha_hora  := '';
        asientos[li_ctrl_array].asiento     := 0;
        asientos[li_ctrl_array].empleado    := '';
        asientos[li_ctrl_array].origen      := '';
        asientos[li_ctrl_array].destino     := '';
        asientos[li_ctrl_array].status      := ' ';
        asientos[li_ctrl_array].precio      := 0;
        asientos[li_ctrl_array].precio_original  := 0;
        asientos[li_ctrl_array].servicio    := 0;
        asientos[li_ctrl_array].forma_pago  := 0;
        asientos[li_ctrl_array].descuento   := 0;
        asientos[li_ctrl_array].Ocupante    := '';
        asientos[li_ctrl_array].tipo_tarifa := '';
        asientos[li_ctrl_array].idOcupante  := 0;
        asientos[li_ctrl_array].taquilla    := 0;
        asientos[li_ctrl_array].nombre      := '';
        asientos[li_ctrl_array].abrePago    := '';
        asientos[li_ctrl_array].ruta        := 0;
        asientos[li_ctrl_array].pago_efectivo := 0;
        asientos[li_ctrl_array].calculado   := 0;
    end;
end;


function BorraArregloLiberaMemoria(var asientos : array_asientos; fecha : string; corrida : string; asiento : integer) : integer;
var
    li_ctrl_array : integer;
    li_ok : integer;
    store_asiento : TSQLStoredProc;
begin
    li_ok := 0;
    for li_ctrl_array := 1 to high(asientos) do begin
        if (asientos[li_ctrl_array].corrida    = corrida) and
           (asientos[li_ctrl_array].fecha_hora = fecha) and
           (asientos[li_ctrl_array].asiento    = asiento ) then begin
            store_asiento := TSQLStoredProc.Create(nil);
            try
                    store_asiento.SQLConnection := CONEXION_VTA; //DM.Conecta;
                    store_asiento.Close;
                    store_asiento.StoredProcName := 'PDV_STORE_VENTA_ASIENTO_DELETE';
                    store_asiento.Params.ParamByName('IN_CORRIDA').AsString := corrida;
                    store_asiento.Params.ParamByName('IN_FECHA').AsString  := fecha;
                    store_asiento.Params.ParamByName('IN_ASIENTO').AsInteger := asiento;
                    store_asiento.Params.ParamByName('IN_TRABID').AsString   := asientos[li_ctrl_array].empleado;
                    store_asiento.Params.ParamByName('IN_ORIGEN').AsString   := asientos[li_ctrl_array].origen;
                    store_asiento.Params.ParamByName('IN_DESTINO').AsString   := asientos[li_ctrl_array].destino;
                    store_asiento.Params.ParamByName('IN_STATUS').AsString   := asientos[li_ctrl_array].status;
                    store_asiento.Params.ParamByName('IN_NUEVO').AsString    := 'D';
                    store_asiento.ExecProc();
            finally
              store_asiento.Free;
              store_asiento := nil;
            end;
            asientos[li_ctrl_array].corrida     := '';
            asientos[li_ctrl_array].fecha_hora  := '';
            asientos[li_ctrl_array].asiento     := 0;
            asientos[li_ctrl_array].empleado    := '';
            asientos[li_ctrl_array].origen      := '';
            asientos[li_ctrl_array].destino     := '';
            asientos[li_ctrl_array].status      := ' ';
            asientos[li_ctrl_array].precio      := 0;
            asientos[li_ctrl_array].precio_original  := 0;
            asientos[li_ctrl_array].servicio    := 0;
            asientos[li_ctrl_array].forma_pago  := 0;
            asientos[li_ctrl_array].descuento   := 0;
            asientos[li_ctrl_array].Ocupante    := '';
            asientos[li_ctrl_array].tipo_tarifa := '';
            asientos[li_ctrl_array].idOcupante  := 0;
            asientos[li_ctrl_array].taquilla    := 0;
            asientos[li_ctrl_array].nombre      := '';
            asientos[li_ctrl_array].abrePago    := '';
            asientos[li_ctrl_array].ruta        := 0;
            asientos[li_ctrl_array].pago_efectivo := 0;
            asientos[li_ctrl_array].calculado   := 0;
            li_ok := 1;
            break;
        end;
    end;
    Result := li_ok;
end;

function DiaMas(fecha : String) : string;
var
    zDia : TSQLQuery;
    ls_out : string;
begin
    zDia := TSQLQuery.Create(nil);
    zDia.SQLConnection := CONEXION_VTA;
    zDia.SQL.Clear;
    zDia.SQL.Add('SELECT DATE_ADD(:fecha, INTERVAL 1 DAY ) AS DIAMAS');
    zDia.Params[0].AsString := fecha;
    zDia.Open;
    ls_out := zDia['DIAMAS'];
    zDia.Free;
    zDia := nil;
    Result := ls_out;
end;

function existeVentaDeCorrida(fecha_inicio, fecha_fin : TDate; Corrida : String; servicio : integer) : integer;
var
   store : TSQLStoredProc;
begin
   store := TSQLStoredProc.Create(nil);
   try
       store.SQLConnection := CONEXION_VTA;
       store.Close;
       store.StoredProcName := 'PDV_HAY_VENTA_PARA';
       store.Params.ParamByName('_FECHA_INICIO').AsDate := Trunc(fecha_inicio);
       store.Params.ParamByName('_FECHA_FIN').AsDate := Trunc(fecha_fin) ;
       store.Params.ParamByName('_ID_CORRIDA').AsString := Corrida;
       store.Params.ParamByName('_TIPOSERVICIO').AsInteger := 0;
       store.Params.ParamByName('_ID_TERMINAL').asString  := gs_terminal;
       store.Open;
       store.First;
       Result := store['TOTAL'];
   finally
     store.Free;
     store := nil;
   end;
end;

procedure BorraArregloLibera(var asientos : array_asientos);
var
    li_ctrl_array : integer;
    ls_fecha : string;
begin
    gs_nombre_pax_nueva := '';
    for li_ctrl_array := 1 to high(asientos) do begin
        asientos[li_ctrl_array].corrida     := '';
        asientos[li_ctrl_array].fecha_hora  := '';
        asientos[li_ctrl_array].asiento     := 0;
        asientos[li_ctrl_array].empleado    := '';
        asientos[li_ctrl_array].origen      := '';
        asientos[li_ctrl_array].destino     := '';
        asientos[li_ctrl_array].status      := ' ';
        asientos[li_ctrl_array].precio      := 0;
        asientos[li_ctrl_array].precio_original  := 0;
        asientos[li_ctrl_array].servicio    := 0;
        asientos[li_ctrl_array].forma_pago  := 0;
        asientos[li_ctrl_array].descuento   := 0;
        asientos[li_ctrl_array].Ocupante    := '';
        asientos[li_ctrl_array].tipo_tarifa := '';
        asientos[li_ctrl_array].idOcupante  := 0;
        asientos[li_ctrl_array].taquilla    := 0;
        asientos[li_ctrl_array].nombre      := '';
        asientos[li_ctrl_array].abrePago    := '';
        asientos[li_ctrl_array].ruta        := 0;
        asientos[li_ctrl_array].pago_efectivo := 0;
        asientos[li_ctrl_array].calculado   := 0;
        asientos[li_ctrl_array].impreso     := 0;
        asientos[li_ctrl_array].id_pago_pinpad_banamex  := '';
    end;
end;



function validaTipoHueco(ls_cadena : String) : string;
var
    li_ctrl : Integer;
    ls_out  : string;
begin
    if ls_cadena[length(ls_cadena) - 1] = ' ' then begin
        for li_ctrl := 1 to length(ls_cadena) - 2 do begin
             ls_out := ls_out + ls_cadena[li_ctrl];
        end;
        ls_out := ls_out + ls_cadena[length(ls_cadena)];
    end else ls_out := ls_cadena;
    Result := ls_out;
end;

function AsientoOcupado(store : TSQLStoredProc; var li_continuo : integer) : Boolean;
var
    lb_ok : Boolean;
begin
    lb_ok := false;
    store.First;
    while not store.Eof do begin
        if li_continuo = store['NO_ASIENTO'] then begin
            lb_ok := true;
            li_continuo := store['NO_ASIENTO'];
            Break;
        end;
        store.Next;
    end;
    Result := lb_ok;
end;

procedure procesoVentaCuantos(li_asientos : integer; ls_corrida : String; li_elegidos_asientos : integer;
                              fecha, Origen, Destino, user, servicio : string; costo : real;
                          var array_Seat : array_asientos; taquilla : Integer;
                              ruta : integer; var li_insertados : integer; iva : Double; cobro_iva : integer);
var
    store,store_pie : TSQLStoredProc;
    li_asiento_continuo, li_asiento_insertado, li_ctrl_pie : Integer;
begin///buscamos en la base referente a la corrida y fecha
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.Close;
        store.StoredProcName := 'PDV_STORE_ASIENTOS_DISPONIBLES';
        store.Params.ParamByName('IN_CORRIDA').AsString := ls_corrida;
        store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD HH:nn:SS',StrToDateTime(fecha));//fecha;
        store.Params.ParamByName('IN_PIE').AsInteger := gi_vta_pie;
        store.Open;
        li_asiento_insertado := 1;
        for li_asiento_continuo := 1 to li_asientos do begin
            if not AsientoOcupado(store,li_asiento_continuo) then begin //llenamos el record con los datos del asiento
                if li_asiento_insertado <= li_elegidos_asientos then begin
                  if gi_vta_pie = 1 then begin
                      store_pie := TSQLStoredProc.create(nil);
                      store_pie.SQLConnection := CONEXION_VTA;
                      store_pie.Close;
                      store_pie.StoredProcName := 'PDV_STORE_ASIENTOS_DISPONIBLES';
                      store_pie.Params.ParamByName('IN_CORRIDA').AsString := ls_corrida;
                      store_pie.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD HH:nn:SS',StrToDateTime(fecha));//fecha;
                      store_pie.Params.ParamByName('IN_PIE').AsInteger := gi_vta_pie;
                      store_pie.Open;
                      if varisnull(store_pie['NO_ASIENTO']) then
                          li_ctrl_pie := 101
                      else begin
                          // li_ctrl_pie := (store_pie['NO_ASIENTO'] + 1);
                          with store_pie do begin
                              First;
                              while not EoF do begin
                                  li_ctrl_pie := (store_pie['NO_ASIENTO'] + 1);
                                  Next;
                              end;
                          end;
                      end;
                      store_pie.Free;
                      array_Seat[li_ctrl_asiento].Ocupante := 'Pie';//descripcion del ocupante
                      array_Seat[li_ctrl_asiento].asiento    := li_ctrl_pie;
                  end else begin
                      array_Seat[li_ctrl_asiento].Ocupante := 'Adulto';//descripcion del ocupante
                      array_Seat[li_ctrl_asiento].asiento    := li_asiento_continuo;
                  end;
                  array_Seat[li_ctrl_asiento].corrida    := ls_corrida;
                  array_Seat[li_ctrl_asiento].fecha_hora := FormatDateTime('YYYY-MM-DD HH:nn:SS',StrToDateTime(fecha));
                  array_Seat[li_ctrl_asiento].empleado   := user;
                  array_Seat[li_ctrl_asiento].origen     := Origen;
                  array_Seat[li_ctrl_asiento].destino    := Destino;
                  array_Seat[li_ctrl_asiento].status     := 'V';
                  array_Seat[li_ctrl_asiento].precio     := StrToFloat(Format('%0.2f',[costo]));
                  array_Seat[li_ctrl_asiento].precio_original     := StrToFloat(Format('%0.2f',[costo]));
                  array_Seat[li_ctrl_asiento].servicio   := StrToInt(servicio);
                  array_Seat[li_ctrl_asiento].forma_pago := 1; // para que se  efectivo
                  array_Seat[li_ctrl_asiento].taquilla   := taquilla;//numero de la taquilla
                  array_Seat[li_ctrl_asiento].descuento  := 0;
                  array_Seat[li_ctrl_asiento].tipo_tarifa := 'A';//tipo ocupante
                  array_Seat[li_ctrl_asiento].idOcupante  := 1;//siempre adulto
                  array_Seat[li_ctrl_asiento].nombre      := '';
                  array_Seat[li_ctrl_asiento].abrePago    := 'EFE';
                  array_Seat[li_ctrl_asiento].ruta        := ruta;
                  array_Seat[li_ctrl_asiento].pago_efectivo := 1;
                  array_Seat[li_ctrl_asiento].iva         := RegresaIVA( FloatToStr(iva) );
                  array_Seat[li_ctrl_asiento].tipo_tarjeta := ' ';
///falta LARIOS
                  estatus_ASIENTO(array_Seat[li_ctrl_asiento],'N');
  //Actualizar la imagen con los asientos y destinos nuevos
                  Inc(li_ctrl_asiento);
                  inc(li_asiento_insertado);
                end;
            end;
        end;
    finally
      store.Free;
      store := nil;
    end;
    li_insertados := li_asiento_insertado - 1;
end;

function tiempo_Espera_Grid(): Integer;
var
    lq_query : TSQLQuery;
    li_out   : Integer;
begin
    try
      try
          lq_query := TSQLQuery.Create(nil);
          lq_query.SQLConnection := DM.Conecta;
          if EjecutaSQL(_VTA_TECLA_ESPERA_GRID,lq_query,_LOCAL) then
              li_out := lq_query['VALOR']
          else
              li_out := 0;
      finally
          lq_query.Free;
          lq_query := nil;
      end;
    except
          on E : Exception do begin
              ErrorLog(E.Message, lq_query.SQL.GetText);
          end;
    end;    Result := li_out;
end;


function tiempo_refresh_Grid(): Integer;
var
    lq_query : TSQLQuery;
    li_out   : Integer;
begin
    try
      try
          lq_query := TSQLQuery.Create(nil);
          lq_query.SQLConnection := DM.Conecta;
          if EjecutaSQL(_VTA_TECLA_REFRESH_GRID,lq_query,_LOCAL) then
              li_out := lq_query['VALOR']
          else
              li_out := 0;
      finally
          lq_query.Free;
          lq_query := nil;
      end;
    except
          on E : Exception do begin
              ErrorLog(E.Message, lq_query.SQL.GetText);
          end;
    end;    Result := li_out;
end;


procedure ImprimeCargaInicial(trabid, texto : String);
var
    ls_nombre, ls_boletos, ls_fecha_ini, ls_hora, ls_ithaca, ls_toshiba : string;
    lq_qry    : TSQLQuery;
begin
    if Length(trabid) > 0 then
        ls_nombre :=  nombreCompletoTrabid(trabid)
    else
        ls_nombre := ' ';
    ls_boletos := 'SELECT C.ID_CORTE, C.FECHA_INICIO AS INICIO, '+
                  '(SELECT COUNT(*) FROM PDV_T_BOLETO '+
                  'WHERE TRAB_ID = ''%s'' AND FECHA_HORA_BOLETO > C.FECHA_INICIO) AS BOLETOS '+
                  'FROM PDV_T_CORTE AS C WHERE C.ESTATUS IN (''A'',''S'')  AND C.ID_EMPLEADO =  ''%s'' ';
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(ls_boletos,[trabid, trabid]),lq_qry, _LOCAL) then begin
        if not VarIsNull(lq_qry.FieldByName('ID_CORTE').AsVariant) then begin
            if lq_qry['BOLETOS'] > 0 then
              ls_boletos := 'Con boletos. vendidos ' + ' Corte : ' + IntToStr(lq_qry['ID_CORTE'])+'.'
            else
              ls_boletos := 'CERO boletos vendidos ' + '. Corte : ' + IntToStr(lq_qry['ID_CORTE'])+'.';
            ls_fecha_ini :=   'Fec. Ini.: ' + FormatDateTime('YYYY-MM-DD HH:nn', lq_qry['INICIO']);
        end else
            ls_boletos  := '-=DESASIGNADO=-';
    end;
    ls_hora := Ahora();

    if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
          if gi_boleto_tamano = 0 then begin
              imprimirBoletoDatamax('','','','',ls_boletos,ls_fecha_ini,
                                    Copy(Ahora(),1,10),'','Carga '+ texto,
                                    ls_nombre,'','',Copy(Ahora(),12,5),
                                    TRABID,'','','','','',gs_puerto);
          end else begin
              imprimirBoletoDatamax101('','','','',ls_boletos,
                                      ls_fecha_ini, Copy(Ahora(),1,10), '', 'Carga '+ texto,
                                    ls_nombre,'','',Copy(Ahora(),12,5),
                                    TRABID,'','','','',gs_puerto);
          end;
    end;

    if gs_impresora_boleto = _IMP_TOSHIBA_MINI then begin
         ToshibaMiniInicializar(True,True);
         ls_toshiba := '';
         ls_toshiba := ls_toshiba + ToshibaMiniTextoAlineado ('Carga Inicial', 'd');
         ls_toshiba := ls_toshiba + ToshibaMiniTextoAlineado (ls_boletos, 'd');
         ls_toshiba := ls_toshiba + ToshibaMiniSaltosDeLinea(0);
         ls_toshiba := ls_toshiba + ToshibaMiniCorte;
         imprimirToshibaMini(gs_puerto, ls_toshiba);
    end;

    if gs_impresora_boleto = _IMP_ITHACA_MINI then begin
         ls_ithaca := ls_ithaca + IthacaTextoAlineado ('Carga inicial ', 'c');
         ls_ithaca := ls_ithaca + IthacaTextoAlineado (ls_boletos, 'c');
         ls_ithaca := ls_ithaca + IthacaSaltosDeLinea(10);
         ls_ithaca := ls_ithaca + IthacaCorte;
         imprimirIthaca(gs_puerto,ls_ithaca);
    end;
end;


procedure ImprimeCargaFinal(trabid : String);
var
 ls_nombre, ls_boletos, ls_fecha_ini, ls_hora,ls_ithaca, ls_toshiba : string;
 lq_qry    : TSQLQuery;
begin
     if Length(trabid) > 0 then
         ls_nombre :=  nombreCompletoTrabid(trabid)
     else
         ls_nombre := ' ';
     ls_boletos := 'SELECT C.ID_CORTE, C.FECHA_INICIO AS INICIO, '+
                   '(SELECT COUNT(*) FROM PDV_T_BOLETO '+
                   'WHERE TRAB_ID = ''%s'' AND FECHA_HORA_BOLETO > C.FECHA_INICIO) AS BOLETOS '+
                   'FROM PDV_T_CORTE AS C WHERE C.ESTATUS IN (''P'',''A'',''S'')  AND C.ID_EMPLEADO =  ''%s'' ORDER BY ID_CORTE LIMIT 1';

     lq_qry := TSQLQuery.Create(nil);
     lq_qry.SQLConnection := DM.Conecta;
     if EjecutaSQL(Format(ls_boletos,[trabid, trabid]),lq_qry, _LOCAL) then begin
         if not VarIsNull(lq_qry.FieldByName('ID_CORTE').AsVariant) then begin
             ls_boletos := // 'Boletos: ' +IntToStr(lq_qry['BOLETOS']) +    <-- se retira la impresión del número de boletos vendidos (20/feb/2013)
                          '.Corte : ' + IntToStr(lq_qry['ID_CORTE'])+'.';
             ls_fecha_ini :=   'Fec. Ini.: ' +FormatDateTime('YYYY-MM-DD HH:nn', lq_qry['INICIO']);
         end else
             ls_boletos  := '-=DESASIGNADO=-';
     end;
     ls_hora := Ahora();
     if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin//impresora TEC Toshiba
         if gi_boleto_tamano = 0 then begin//     if (gi_impresion_itaca = 0) and (StrToInt(gs_toshiba) = 0) then begin
             imprimirBoletoDatamax('','','','','-=DESASIGNADO=-',ls_fecha_ini,
                                   Ahora(),'','CARGA FINAL',
                                   ls_nombre,'','',Ahora(),
                                   TRABID,'','','','','',gs_puerto);
         end;

         if gi_boleto_tamano = 1 then begin
            imprimirBoletoDatamax101('','',TRABID,'','-=DESASIGNADO=-',
                                     Ahora(),'CARGA FINAL',ls_fecha_ini,'','',
                                     '',ls_nombre,Ahora(),ls_fecha_ini,ls_boletos,
                                     '','DESASIGNADO '+TRABID,'',gs_puerto);
         end;
     end;

     if (gi_impresion_itaca = 1) and (StrToInt(gs_toshiba) = 0) then begin
          ls_ithaca := ls_ithaca + IthacaTextoAlineado ('Carga Final ', 'c');
          ls_ithaca := ls_ithaca + IthacaTextoAlineado (ls_boletos, 'c');
          ls_ithaca := ls_ithaca + IthacaTextoAlineado ('DESASIGNADO ', 'c');
          ls_ithaca := ls_ithaca + IthacaTextoAlineado (Ahora,'c');
          ls_ithaca := ls_ithaca + IthacaSaltosDeLinea(3);
          ls_ithaca := ls_ithaca + IthacaCorte;
          imprimirIthaca(gs_puerto,ls_ithaca);
     end;
     if length(gs_toshiba) > 0 then begin
         if StrToInt(gs_toshiba) = 1 then begin
              ToshibaMiniInicializar(True,True);
              ls_toshiba := '';
              ls_toshiba := ls_toshiba + ToshibaMiniTextoAlineado ('Carga Final', 'd');
              ls_toshiba := ls_toshiba + ToshibaMiniTextoAlineado (ls_boletos, 'd');
              ls_toshiba := ls_toshiba + ToshibaMiniTextoAlineado ('DESASIGNADO ', 'c');
              ls_toshiba := ls_toshiba + ToshibaMiniTextoAlineado (Ahora,'c');
              ls_toshiba := ls_toshiba + ToshibaMiniSaltosDeLinea(3);
              ls_toshiba := ls_toshiba + ToshibaMiniCorte;
              imprimirToshibaMini(gs_puerto, ls_toshiba);
         end;
     end;
     lq_qry.Free;
end;



function nombreCompletoTrabid(trabid : string) : string;
var
    lq_query : TSQLQuery;
    ls_out   : String;
begin
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(_TRAB_NOMBRE_COMPLETO,[trabid]),lq_query,_LOCAL) then
            ls_out := lq_query['NOMBRE'];
    finally
        lq_query.free;
        lq_query := nil;
    end;
    Result := ls_out;

end;

{@Procedure corridasParametros
@Params origen, destino, fecha : String; Grid : TStringGrid
@Descripcion Desplegamos las corrida disponibles por terminal
necesitamos pasar los parametros faltantes}
procedure corridasParametros(origen, destino, fecha, lps_hora, lps_servicio : String;
                                  li_codicion : integer; Grid : TStringGrid; corrida : String);
var
    store : TSQLStoredProc;
    li_idx: Integer;
    ls_hora,ls_muestra : string;
    ls_char : Char;
    lb_opcion  : Boolean;
    fecha_next : TDate;
    lf_moneda  : Real;
begin
    store := TSQLStoredProc.Create(nil);
    try
      fecha_next := validaSiguienteFecha(StrToDate(fecha));
    except
      fecha := DateToStr(Now);
      fecha_next := validaSiguienteFecha(StrToDate(fecha));
    end;
    gi_numCorrida := 0;
    try
      try
          store.SQLConnection := CONEXION_VTA; //DM.Conecta;
          store.Close;
          store.StoredProcName := 'PDV_STORE_MUESTRA_CORRIDAS';
          store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
          store.Params.ParamByName('IN_DESTINO').AsString := Destino;
          store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
          store.Params.ParamByName('FECHA_SIGUIENTE').AsString := FormatDateTime('YYYY-MM-DD',fecha_next);
          store.Open;
          li_idx := 1;
          lb_opcion := false;
          if Store.IsEmpty then
              exit;

          with Store do begin
            First;
            while not Eof do begin
              ls_char := Store.FieldByName('TIPO').AsString[1];
              case ls_char of
                  'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                  else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
              end;

              if ((Store['COMPARA'] = 1) and (lb_opcion = False)) then begin
                  gi_select_corrida := li_idx;
                  lb_opcion := true;
              end;

              if li_codicion = 1 then begin
                  if ((length(lps_hora) <> 0)  or (Length(lps_servicio) <> 0 ) or (length(corrida) <> 0) )then begin
                      if (( comparaHoraCorrida(lps_hora,FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime))) and
                          (lps_servicio = store['ABREVIA']) and (store['ID_CORRIDA'] = corrida) and
                          (store['ID_CORRIDA'] = corrida) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);
                      if (( comparaHoraCorrida(lps_hora,FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime))) and
                          (length(lps_servicio) = 0) and (length(corrida) = 0) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);

                      if (( length(lps_hora) = 0) and (length(corrida) = 0) and (lps_servicio = store['TIPOSERVICIO'])  ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);
                      if (( length(lps_hora) = 0) and (length(lps_servicio) = 0) and (store['ID_CORRIDA'] = corrida) ) then
                             llenarGridCorridas(ls_hora,store,li_idx,Grid);
                      if gi_select_corrida = 1 then
                            gi_select_corrida := 1;
                  end;
              end else begin
                    llenarGridCorridas(ls_hora,store,li_idx,Grid);
              end;
              inc(gi_numCorrida);
              Next;
            end;
          end;//FIN WITH
          if li_idx = 1 then
             Inc(li_idx);
          if (gi_select_corrida = 0) and (gi_numCorrida > 0) then
              gi_select_corrida := gi_numCorrida;
          if li_idx = gi_select_corrida then
              gi_select_corrida := gi_select_corrida - 1;

          Grid.RowCount := li_idx;
          try
            Grid.Row := gi_select_corrida;
          except
             Grid.Row := li_idx;
          end;
      finally
          store.Free;
          store := nil;
      end;
    except
          on E : Exception do begin
              ErrorLog(E.Message, store.StoredProcName);
          end;
    end;
end;


function conexionServidorRemoto(terminal : string) : TSQLConnection;
var
    lq_query : TSQLQuery;
    lb_out   : Boolean;
    ls_ip    : string;
    ls_usuario : string;
    ls_password : string;
    ls_base     : string;
begin
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(_CONECTA_TERMINAL,[terminal]),lq_query,_LOCAL) then begin
          if not VarIsNull(lq_query['IPv4']) then begin
             try
                ls_ip := lq_query['IPv4'];
                ls_usuario := lq_query['BD_USUARIO'];
                ls_password := lq_query['BD_PASSWORD'];
                ls_base     := lq_query['BD_BASEDATOS'];
                CONEXION_REMOTO := TSQLConnection.Create(nil);
                CONEXION_REMOTO.Close;
                CONEXION_REMOTO.DriverName := _DRIVER;
                CONEXION_REMOTO.Params.Values['HOSTNAME']  := ls_ip;  //lq_query['IPv4'];
                CONEXION_REMOTO.Params.Values['DATABASE']  := ls_base;  //_BASE_DATOS_MERCURIO;
                CONEXION_REMOTO.Params.Values['USER_NAME'] := ls_usuario;
                CONEXION_REMOTO.Params.Values['PASSWORD']  := ls_password;
                CONEXION_REMOTO.LoginPrompt := False;
                CONEXION_REMOTO.Connected := True;
                lb_out := True;
              except
                  on E : Exception do begin
                    Mensaje('No existe conexion al servidor: '+terminal+#10#13+'Reportelo al area del sistemas',0);
                    ErrorLog(E.Message,'No se puede conectar a el server: '+#10#13+  lq_query['IPV4']);//escribimos al archivo
                    lb_out := False;
                  end;
              end;
          end else begin
                    Mensaje('No existe conexion al servidor: '+terminal+#10#13+'Reportelo al area del sistemas',0);
                    ErrorLog('No se puede conectar a el server : ', terminal );//escribimos al archivo
          end;//fin null
        end else lb_out := False;
    finally
        lq_query.free;
        lq_query := nil;
    end;
    Result := CONEXION_REMOTO;
end;

{    store := TSQLStoredProc.Create(nil);
    try
      store.SQLConnection := CONEXION_VTA; //DM.Conecta;
        li_row := 0;
        try
            store.Close;
            store.StoredProcName := 'PDV_STORE_SHOW_DETALLE_RUTA_NEW1';
            store.Params.ParamByName('IN_RUTA').AsInteger := lpi_ruta;
            store.Open;
            with store do begin
                First;
                while not EoF do begin
                    Grid.Cells[0,li_row] := Store.FieldByName('DESTINO').AsString;
                     Grid.Cells[1,li_row] := Store.FieldByName('DESCRIPCION').AsString;
                    inc(li_row);
                    next;
                end;
            end;
            store.Close;
            store.StoredProcName := 'PDV_STORE_SHOW_DETALLE_RUTA_NEW2';
            store.Params.ParamByName('IN_RUTA').AsInteger := lpi_ruta;
            store.Open;
            with store do begin
                First;
                while not EoF do begin
                    Grid.Cells[0,li_row] := Store.FieldByName('DESTINO').AsString;
                     Grid.Cells[1,li_row] := Store.FieldByName('DESCRIPCION').AsString;
                    inc(li_row);
}
function getTarifaIvaOrigenDestino(origen, destino : String; servicio : integer; var tarifa, iva : double) : Boolean;
var
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA; //DM.Conecta;
    store.Close;
    store.StoredProcName := 'PDV_STORE_TARIFA_IVA';
    store.Params.ParamByName('IN_ORIGEN').AsString := origen;
    store.Params.ParamByName('IN_DESTINO').AsString := destino;
    store.Params.ParamByName('IN_SERVICIO').AsInteger := servicio;
    store.Open;

    if store.IsEmpty then
        Result := false
    else begin
        tarifa := store.FieldByName('MONTO').AsFloat;
        iva := store.FieldByName('IMP_IVA').AsFloat;
        Result := true;
    end;
    store := nil;
end;


function getDescripcionTerminal(terminal : String) : string;
var
    lq_qry : TSQLQuery;
    ls_qry  : String;
begin
    ls_qry := 'SELECT DESCRIPCION FROM T_C_TERMINAL WHERE ID_TERMINAL = ''%s'' ';
    lq_qry := TSQLQuery.Create(nil);
    try
        lq_qry.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(ls_qry,[terminal]),lq_qry,_LOCAL) then
            ls_qry := lq_qry['DESCRIPCION'];
        lq_qry.Free;
        lq_qry := nil;
    except
        result := '';
    end;
    Result := ls_qry;
end;


function getEmisionBoleto  : integer;
var
    lq_qry : TSQLQuery;
    ls_qry : string;
    li_out : integer;
begin
    ls_qry := 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 18';
    lq_qry := TSQLQuery.Create(nil);
    try
        lq_qry.SQLConnection := DM.Conecta;
        if EjecutaSQL(ls_qry,lq_qry,_LOCAL) then
          if VarIsNull(lq_qry['VALOR']) then
              li_out := 0
          else
              li_out := lq_qry['VALOR'];
    finally
        lq_qry.Free;
        lq_qry := nil;
    end;
    Result := li_out;
end;


function  validaDobles(a_elegidos : ga_asientos): Boolean;
var
    lb_ok : Boolean;
    li_idx, li_asiento, li_anuevo : Integer;
    a_nuevos : ga_asientos;
begin
    for li_idx := 0 to 50 do
        a_nuevos[li_idx] := 0;
    for li_idx := 0 to 50 do begin
        li_asiento := a_elegidos[li_idx];
        for li_anuevo := 0 to 50 do begin
            if a_nuevos[li_anuevo] = 0 then begin//insertamos el dato
                a_nuevos[li_anuevo] := li_asiento;
                lb_ok := False;
                break;
            end else begin
                  if a_nuevos[li_anuevo] = li_asiento then begin
                      lb_ok := True;
                      exit;
                  end;
            end;
        end;
    end;
    Result := lb_ok;
end;


function validaFolio(corte : integer; user : String): integer;
var
    lq_query : TSQLQuery;
    li_out   : integer;
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_VERIFICA_FOLIO_INICIAL,[IntToStr(corte),user]),lq_query,_LOCAL) then begin
      if lq_query['FOLIO'] = 0 then
          li_out := 0;
      if lq_query['FOLIO'] = 1 then
          li_out := 1;
    end;
    lq_query.Free;
    lq_query := nil;
    Result := li_out;
end;


function corteNumero(user : String): integer;
var
    li_out : integer;
    lq_query : TSQLQuery;
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    li_out := 0;
    if EjecutaSQL(Format(_CORTE_TRABID,[user]),lq_query,_LOCAL) then begin
        li_out := lq_query['ID_CORTE'];
    end;
    lq_query.Free;
    lq_query := nil;
    Result := li_out;
end;

function getFechaSistema() : integer;
var
    lq_qry : TSQLQuery;
    li_out : Integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONEXION_VTA;
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add('SELECT CONCAT(strSplit(CURRENT_DATE(), "-", 1), strSplit(CURRENT_DATE(), "-", 2) , strSplit(CURRENT_DATE(), "-", 3) )AS FECHA');
    lq_qry.Open;
    li_out := lq_qry['FECHA'];
    lq_qry.Free;
    lq_qry := nil;
    Result := li_out;
end;


function asientoReservado(ls_fecha : string; Grid : TStringGrid) : integer;
var
    lq_query : TSQLQuery;
    ls_qry   : string;
    store    : TSQLStoredProc;
    li_idx   : integer;
    li_corrida : integer;
    ls_hora, ls_destino : String;
begin
    lq_query := TSQLQuery.Create(nil);
    ls_fecha := FormatDateTime('YYYY-MM-DD', StrToDate(ls_fecha));
    try
        lq_query.SQLConnection := CONEXION_VTA;
        li_idx := 1;
        if EjecutaSQL(Format(_VTA_BUSCA_FECHA_AMBOS,[ls_fecha]),lq_query,_LOCAL) then begin
            with lq_query do begin
                First;
                while not Eof do begin
                    Grid.Cells[0,li_idx] := lq_query['NOMBRE_PASAJERO'];
                    Grid.Cells[1,li_idx] := lq_query['ORIGEN'];
                    inc(li_idx);
                    Next;
                end;//fin
                Grid.RowCount := li_idx;
            end;//fin with
        end;//fin ejecuta
        if li_idx = 1 then begin
             Mensaje('No tenemos reservaciones para esa fecha',0);
             LimpiaSag(Grid);
             Grid.FixedRows := 1;
        end;
    finally
      lq_query.Free;
      lq_query := nil;
    end;
    result := li_idx;
end;


procedure cargarGridReservadoCorrida(li_corrida : String; ls_fecha, ls_hora, ls_destino, ls_origen : string;
                                     Grid : TStringGrid; li_idx : integer);
var
    store : TSQLStoredProc;
    ls_char : Char;
begin
    store := TSQLStoredProc.Create(nil);
    try
        gi_numCorrida := 0;
        store.SQLConnection := DM.Conecta;
        store.Close;
        store.StoredProcName := 'PDV_STORE_VENTA_RESERVADOS_IVA';
        store.Params.ParamByName('IN_CORRIDA').AsString := li_corrida;
        store.Params.ParamByName('IN_FECHA').AsString    := FormatDateTime('YYYY-MM-DD',StrToDate(ls_fecha));;
        store.Params.ParamByName('IN_HORA').AsString     := FormatDateTime('HH:nn:SS', StrToTime(ls_hora));
        store.Params.ParamByName('IN_DESTINO').AsString  := ls_destino;
        store.Params.ParamByName('IN_ORIGEN').AsString   := ls_origen;
        store.Open;
        with store do begin
            First;
            while not EoF do begin
              ls_char := Store.FieldByName('TIPO').AsString[1];
              case ls_char of
                  'E' : ls_hora := 'E ' + FormatDateTime('hh:nn:ss',Store.FieldByName('HORA').AsDateTime);
                  else ls_hora := FormatDateTime('hh:nn:ss',Store.FieldByName('HORA').AsDateTime);
              end;
              llenarGridCorridas(ls_hora,store,li_idx,Grid);
              gi_select_corrida := 1;
              Next;
            end;//fin while
        end;//fin storre
        if li_idx = 1 then
           Inc(li_idx);
        if (gi_select_corrida = 0) and (gi_numCorrida > 0) then
            gi_select_corrida := gi_numCorrida;
        Grid.RowCount := li_idx;
        Grid.Row := gi_select_corrida;
    finally
      store.Free;
      store := nil;
    end;
end;

function asientoReservado(ls_nombre,ls_fecha : string; Grid : TStringGrid) : integer; overload;
var
    lq_query : TSQLQuery;
    ls_qry   : string;
    store    : TSQLStoredProc;
    li_idx   : integer;
    li_corrida : integer;
    ls_hora, ls_destino : String;
begin
    ls_asientos_reservados := '';
    lq_query := TSQLQuery.Create(nil);
    ls_fecha := FormatDateTime('YYYY-MM-DD', StrToDate(ls_fecha));
    try
        lq_query.SQLConnection := CONEXION_VTA;
        li_idx := 1;
        if EjecutaSQL(Format(_VTA_BUSCA_RESERVA_AMBOS,[ls_nombre,ls_fecha]),lq_query,_LOCAL) then begin
            with lq_query do begin
                First;
                while not Eof do begin
                    cargarGridReservadoCorrida(lq_query['ID_CORRIDA'],lq_query['FECHA'],
                                               lq_query['HORA'],lq_query['DESTINO'],lq_query['ORIGEN'],Grid,li_idx);
                    inc(li_idx);
                    Next;
                end;//fin
                Grid.RowCount := li_idx;
            end;//fin with
        end;//fin ejecuta
        li_idx := 1;
        ls_asientos_reservados := '';
        if EjecutaSQL(Format(_VTA_BUSCA_ASIENTOS,[ls_nombre,ls_fecha]),lq_query,_LOCAL) then begin
            with lq_query do begin
                First;
                while not Eof do begin
                    ls_asientos_reservados := ls_asientos_reservados + IntToStr(lq_query['NO_ASIENTO']) + ' ';
                    inc(li_idx);
                    Next;
                end;//fin
            end;//fin with
        end;
        if li_idx = 1 then begin
             Mensaje('No tenemos reservaciones para esa fecha',0);
             LimpiaSag(Grid);
             Grid.FixedRows := 1;
        end;
    finally
      lq_query.Free;
      lq_query := nil;
    end;
    result := li_idx;
end;



procedure asignaVenta(trabid, terminal : string; taquilla:integer);
var
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.StoredProcName := 'PDV_STORE_REGISTRA_CORTE';
        store.Params.ParamByName('IN_TRABID').AsString := trabid;
        store.Params.ParamByName('IN_TERMINAL').AsString := terminal;
        store.Params.ParamByName('IN_TAQUILLA').AsInteger := taquilla;
        store.Open;
        if VarIsNull(store['FONDO_INICIAL']) then
          gi_fondo_inicial_store := -1
        else gi_fondo_inicial_store := store['FONDO_INICIAL'];
        try
          gi_corte_store         := store['ID_CORTE'];
          gs_trabid_store        := store['ID_EMPLEADO'];
          gs_estatus_store       := store['ESTATUS'];
          gi_taquilla_store      := store['ID_TAQUILLA'];
          gi_out_valida_asignarse := store['OUT_OK'];
        except
        end;
    finally
       store.Free;
       store := nil;
    end;
end;

function ceros(no: integer): string;
var
  cadena: string;
  x: integer;
begin
  cadena := '';
  for x := 1 to no do
    cadena := cadena + '0';

  result := cadena;
end;

function acompleta_ceros_izquierda(cadena_in: string; no: integer): string;
var
  cadena: string;
begin
  cadena := '';
  if length(cadena_in) < no then
    cadena := cadena + ceros(no - length(cadena_in)) + cadena_in
  else
    cadena := copy(cadena_in, 1, no);

  result := cadena;
end;

function getSizeAutbos(corrida : String; fecha : String): integer;
var
    lq_bus : TSQLQuery;
begin
    lq_bus := TSQLQuery.Create(nil);
    lq_bus.SQLConnection := dm.Conecta;
    lq_bus.sql.Clear;
    lq_bus.SQL.Add('SELECT CUPO FROM PDV_T_CORRIDA_D D ');
    lq_bus.SQL.Add('WHERE D.ID_CORRIDA = :corrida AND D.FECHA = :fecha');
    lq_bus.Params[0].AsString := corrida;
    lq_bus.Params[1].AsString := fecha;
    lq_bus.Open;
    Result := lq_bus['CUPO'];
    lq_bus.Free;
end;


function getTotalBoleto(corrida : String; fecha : String): integer;
var
    lq_query : TSQLQuery;
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    lq_query.SQL.Clear;
    lq_query.sql.Add('SELECT COUNT(*) AS TOTAL FROM PDV_T_BOLETO B');
    lq_query.sql.Add('WHERE B.ESTATUS = ''V'' AND B.FECHA = :fecha AND B.ID_CORRIDA = :corrida ');
    lq_query.Params[0].AsString := fecha;
    lq_query.Params[1].AsString := corrida;
    lq_query.Open;
    Result := lq_query['TOTAL'];
    lq_query.Free;
end;


function compareSizeBus(ori_corrida, fec_origen : String; des_corrida, fec_destino : String ) : Boolean;
var
    lq_qry : TSQLQuery;
    li_tOrigen, li_tDestino : integer;
begin
    li_tOrigen := getTotalBoleto(ori_corrida, fec_origen);
    li_tDestino := getTotalBoleto(des_corrida, fec_destino);
    if ( (li_tOrigen + li_tDestino) > getSizeAutbos(des_corrida, fec_destino)) then
      Result := True
    else
      Result := false;
end;



end.
