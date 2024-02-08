unit U_venta;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  StdCtrls, DB, SysUtils, comun, Data.SqlExpr, Grids, DateUtils, variants,
  TRemotoPorTerminal, Classes, u_main, Forms, ExtCtrls, ImgList, Controls,
  Dialogs, WideStrings, FMTBcd,  Windows, MaskUtils;

Const
    _MILISEGUNDO = (1/24/60/60/1000);
    _RETRADADO = 500;
    _TECLAS_EN_TU_TIEMPO = _MILISEGUNDO * _RETRADADO;//se multiplica por milisegundo
    _NO_REGISTRADO = 'NO ASIGNADO';
    _CARACTERES_VALIDOS_FONDO : SET OF CHAR = ['0','1','2','3','4','5','6','7','8','9','.'];
    _CARACTERES_VALIDOS_CORRIDA : SET OF CHAR = ['0','1','2','3','4','5','6','7','8','9',
                                                 'A','B','C','D','E','F','G','H','I','J','K','L',
                                                 'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    _CARACTERES_VALIDOS : SET OF CHAR = ['0','1','2','3','4','5','6','7','8','9',
                                         'A','B','C','D','E','F','G','H','I','J','K','L',
                                         'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',' '];

    _BASE = 'CORPORATIVO';
    _DRIVER = 'MySql';
    _LOG = 'ConexionServer.log';//para registrar los errores del Thread

    _E_ASIGNA_VTA_DUPLICADO = 0;
    _E_ASIGNA_PROCESO_CORTE = 4;

    _VTA_COL_FORMA_ID  = 4;
    _VTA_CANTIDAD_PAGAR = 1;
    _PTO_IMPRESION =  'LPT1';
    _LOG_BOLETO    =  'boleto.log';

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

    _KEY_INGRESA_DATOS = 122;//VK_F11

    _RESERVA_ASIENTOS = 1;
    _NOMBRE_RESERVADO = 40;


    _VTA_MSG_YA_EXISTE = 'EL PROMOTOR YA ESTA ASIGNADO EN OTRA TERMINAL';
    _VTA_CUPO_MAXIMO   = 'El valor es mayor al parametrizado';
    _VTA_NOMBRE_MAYOR_AL_PERMITIDO = 'El nombre del pasajero es #10#13 mayor a %d caracteres';

    _VTA_CORRIDA = 'SELECT C.ID_CORRIDA,C.FECHA_HORA_CORRIDA, A.TIPO_AUTOBUS, S.DESCRIPCION '+
                   'FROM PDV_T_CORRIDA C INNER JOIN PDV_C_TIPO_AUTOBUS A ON A.ID_TIPO_AUTOBUS = C.ID_TIPO_AUTOBUS  '+
                   '          INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO '+
                   ' WHERE FECHA_HORA_CORRIDA > (SELECT localtime()) order by C.FECHA_HORA_CORRIDA; ';
    _VTA_TERMINALES  = 'SELECT ID_TERMINAL,DESCRIPCION FROM T_C_TERMINAL T WHERE FECHA_BAJA IS NULL ORDER BY 1; ';

    _VTA_BOLETO_A_DESTINO = 'SELECT DISTINCT(T.DESTINO),  TE.DESCRIPCION '+
                            'FROM PDV_T_CORRIDA C INNER JOIN PDV_T_CORRIDA_D D ON D.ID_CORRIDA = C.ID_CORRIDA AND '+
                            'D.FECHA = C.FECHA '+
                            'INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA '+
                            'INNER JOIN T_C_RUTA_D RU ON RU.ID_RUTA = D.ID_RUTA '+
                            'INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = RU.ID_TRAMO '+
                            'INNER JOIN T_C_TERMINAL TE ON TE.ID_TERMINAL = T.DESTINO '+
                            'WHERE D.FECHA BETWEEN CURRENT_DATE() AND (SELECT ADDDATE(CURRENT_DATE(),INTERVAL 365 DAY)) '+
                            'ORDER BY 1';

    _VTA_BOLETO_A_SERIVICO = 'SELECT  DISTINCT(C.TIPOSERVICIO), S.DESCRIPCION '+
                            'FROM PDV_T_CORRIDA C INNER JOIN PDV_T_CORRIDA_D D ON D.ID_CORRIDA = C.ID_CORRIDA AND '+
                            'D.FECHA = C.FECHA '+
                            'INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA '+
                            'INNER JOIN T_C_RUTA_D RU ON RU.ID_RUTA = D.ID_RUTA '+
                            'INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = RU.ID_TRAMO '+
                            'INNER JOIN T_C_TERMINAL TE ON TE.ID_TERMINAL = T.DESTINO '+
                            'INNER JOIN SERVICIOS S ON C.TIPOSERVICIO = S.TIPOSERVICIO '+
                            'WHERE D.FECHA BETWEEN CURRENT_DATE() AND (SELECT ADDDATE(CURRENT_DATE(),INTERVAL 365 DAY)) AND '+
                            'D.ID_TERMINAL = ''%s'' AND T.DESTINO =  ''%s'' ' +
                            'ORDER BY 1';

    _VTA_CORTE_ASIGNADO = 'INSERT INTO PDV_T_CORTE(ID_TERMINAL,ID_CORTE,ID_TAQUILLA,ID_EMPLEADO,FECHA_INICIO,ESTATUS,FONDO_INICIAL) '+
                          'VALUES(''%s'',%d,%s,''%s'',''%s'',''%s'',%s);';
    _VTA_CORTE_FONDO    = 'UPDATE PDV_T_CORTE SET FONDO_INICIAL = %s '+
                          ' WHERE ID_CORTE = %d AND ID_EMPLEADO = ''%s'' ';

    _VTA_CORTE_RESERVADO = 'INSERT INTO PDV_T_CORTE(ID_TERMINAL,ID_CORTE,ID_TAQUILLA,ID_EMPLEADO,FECHA_INICIO,ESTATUS) '+
                          'VALUES(''%s'',%d,%s,''%s'',''%s'',''%s'');';

    _VTA_IP_EXISTE_YA = 'SELECT  P.ID_TAQUILLA, P.ID_CORTE, T.IP, P.ESTATUS FROM PDV_T_CORTE P INNER JOIN PDV_C_TAQUILLA T ON P.ID_TAQUILLA = T.ID_TAQUILLA '+
                        ' WHERE P.ID_EMPLEADO = ''%s'' AND  '+
                        '      P.FECHA_INICIO < (SELECT NOW()) AND P.ESTATUS IN (''A'',''S'',''P'') AND T.IP = ''%s'' AND T.ID_TERMINAL = ''%s'' ';

    _VTA_SI_YA_EXISTE = 'SELECT T.ID_TAQUILLA, T.IP, P.ID_CORTE, P.ESTATUS FROM PDV_T_CORTE P INNER JOIN PDV_C_TAQUILLA T ON '+
                        ' P.ID_TAQUILLA = T.ID_TAQUILLA '+
                        'WHERE ID_EMPLEADO = ''%s'' AND P.FECHA_INICIO < (SELECT NOW()) AND P.ESTATUS IN (''A'',''S'',''P'') '+
                        '       AND T.IP = ''%s'' AND T.ID_TERMINAL = ''%s'' ';

    _VTA_UPDATE_SI_EXISTE = 'UPDATE PDV_T_CORTE SET ESTATUS = ''A'' WHERE ID_CORTE = %d AND ID_TERMINAL = ''%s'';';
    _VTA_UPDATE_NO_VENTA = 'UPDATE PDV_T_CORTE SET ESTATUS = ''S'' WHERE ID_CORTE = %d AND ID_TERMINAL = ''%s'';';
    _VTA_UPDATE_EN_PROCESO = 'UPDATE PDV_T_CORTE SET ESTATUS = ''P'' WHERE ID_CORTE = %d AND ID_TERMINAL = ''%s'';';
    _VTA_TECLA_ESPERA_GRID = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 1';
    _VTA_TIPO_SERVICIO = 'SELECT TIPOSERVICIO, DESCRIPCION '+
                         'FROM SERVICIOS WHERE ID_GRUPO IN ( '+
                         'SELECT ID_GRUPO FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL = ''%s'') AND TIPOSERVICIO > 0';

    //'SELECT TIPOSERVICIO,  DESCRIPCION FROM SERVICIOS WHERE TIPOSERVICIO > 0 ORDER BY 1;';
    _VTA_PROMOTOR_ANTICIPADOS = 'SELECT TRAB_ID, (CONCAT(NOMBRES,'' '',PATERNO,'' '',MATERNO))AS PROMOTOR '+
                                'FROM EMPLEADOS WHERE ID_SERVICIO = 0 AND STATUS = ''A'' ';
    //ABREVIACION,
    _VTA_OCUPANTES    = 'SELECT ABREVIACION, DESCRIPCION FROM PDV_C_OCUPANTE WHERE FECHA_BAJA IS NULL';
    _VTA_OCUPANTE_NO_ADULTO = 'SELECT ABREVIACION FROM PDV_C_OCUPANTE WHERE FECHA_BAJA IS NULL AND ID_OCUPANTE > 1 ';
    _VTA_PARAMETRO_CUPO = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = %d;';

    _VTA_AUTOBUSES_GET = 'SELECT ID_TIPO_AUTOBUS,ASIENTOS FROM PDV_C_TIPO_AUTOBUS ORDER BY 1;';
    _VTA_TARIFA_TRAMO  = 'SELECT MONTO, FECHA_HORA_APLICA '+
                         'FROM PDV_C_TARIFA T INNER JOIN SERVICIOS S ON T.ID_SERVICIO = S.TIPOSERVICIO '+
                         '                    INNER JOIN PDV_C_TARIFA_D D ON D.ID_TARIFA = T.ID_TARIFA '+
                         'WHERE T.ID_TRAMO = %d AND S.ABREVIACION = ''%s'' AND FECHA_HORA_APLICA <= ''%s'' '+
                         'ORDER BY FECHA_HORA_APLICA DESC '+
                         'LIMIT 1 ';

    _VTA_TARIFA = 'SELECT MONTO '+
                  'FROM PDV_C_TARIFA TA INNER JOIN SERVICIOS SE ON TA.ID_SERVICIO = SE.TIPOSERVICIO '+
                  'INNER JOIN PDV_C_TARIFA_D DT ON DT.ID_TARIFA = TA.ID_TARIFA '+
                  'WHERE TA.ID_TRAMO = (SELECT ID_TRAMO FROM T_C_TRAMO TR WHERE TR.ORIGEN = ''%s'' AND TR.DESTINO = ''%S'') '+
                  'AND SE.TIPOSERVICIO = %s AND FECHA_HORA_APLICA <= NOW() ORDER BY FECHA_HORA_APLICA DESC LIMIT 1 ';

    _VTA_CTRL_BOLETO = 'SELECT CONSECUTIVO, DIARIO FROM PDV_C_INICIO WHERE ULTIMA_FECHA = CAST(NOW() AS DATE)';
    _VTA_UPDATE_INICIO = 'UPDATE PDV_C_INICIO SET ULTIMA_FECHA = CAST(NOW()AS DATE), CONSECUTIVO = 1, DIARIO = 0;';

    _VTA_FORMAS_PAGO   = 'SELECT ID_FORMA_PAGO, ABREVIACION, DESCRIPCION, DESCUENTO '+
                         'FROM PDV_C_FORMA_PAGO P '+
                         'WHERE FECHA_BAJA IS NULL ';
    _VTA_NOMBRE_SERVICIO = 'SELECT DESCRIPCION FROM SERVICIOS WHERE ABREVIACION = ''%s'' ';
//    _VTA_BOLETO_EMPLEADO = 'SELECT COALESCE(MAX(ID_BOLETO),0) + 1 AS INDICE    FROM PDV_T_BOLETO P WHERE TRAB_ID = ''%s'' AND ID_TERMINAL = ''%s'' ';
    _VTA_BOLETO_EMPLEADO = 'SELECT COALESCE(MAX(ID_BOLETO),0) + 1 AS INDICE    FROM PDV_T_BOLETO P WHERE TRAB_ID = ''%s''  ';
    _VTA_ID_TAQUILLA = 'SELECT ID_TERMINAL,ID_TAQUILLA FROM PDV_C_TAQUILLA WHERE IP = ''%s'' ';

    _VTA_CORRIDA_OCUPADA = 'La corrida esta en proceso de venta por el usuario: #10#13 %s #10#13 espere un momento';


///RESERVACIONES
    _VTA_BUSCA_NOM_RESERVA   = 'SELECT DISTINCT(NOMBRE_PASAJERO), NOMBRE_PASAJERO FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA_D D ON A.ID_CORRIDA = D.ID_CORRIDA AND '+
                               '                               D.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE) AND '+
                               '                               D.HORA  = CAST(A.FECHA_HORA_CORRIDA AS TIME) '+
                               'WHERE STATUS = ''R'' AND FECHA_HORA_CORRIDA >= CURRENT_DATE() AND D.ESTATUS = ''A'';';

    _VTA_BUSCA_FECHA_RESERVA = 'SELECT DISTINCT(SUBSTR(FECHA_HORA_CORRIDA,1,10)),  SUBSTR(FECHA_HORA_CORRIDA,1,10) FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA_D D ON A.ID_CORRIDA = D.ID_CORRIDA AND '+
                               '                               D.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE) AND '+
                               '                               D.HORA  = CAST(A.FECHA_HORA_CORRIDA AS TIME) '+
                               'WHERE STATUS = ''R'' AND FECHA_HORA_CORRIDA >= CURRENT_DATE() AND D.ESTATUS = ''A'';';

    _VTA_BUSCA_RESERVA_ALL   = 'SELECT ID_CORRIDA,(CAST(FECHA_HORA_CORRIDA AS DATE))as FECHA, (CAST(FECHA_HORA_CORRIDA AS TIME))AS HORA, DESTINO FROM PDV_T_ASIENTO WHERE STATUS = ''R'' ORDER BY NO_ASIENTO';
    _VTA_BUSCA_RESERVA_NOMBRE = 'SELECT ID_CORRIDA,(CAST(FECHA_HORA_CORRIDA AS DATE))as FECHA, (CAST(FECHA_HORA_CORRIDA AS TIME))AS HORA, DESTINO FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND NOMBRE_PASAJERO = ''%s'' ORDER BY NO_ASIENTO';
    _VTA_BUSCA_RESERVA_FECHA =  'SELECT ID_CORRIDA,(CAST(FECHA_HORA_CORRIDA AS DATE))as FECHA, (CAST(FECHA_HORA_CORRIDA AS TIME))AS HORA, DESTINO FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE)  ORDER BY NO_ASIENTO;';
    _VTA_BUSCA_RESERVA_AMBOS =  'SELECT DISTINCT(ID_CORRIDA),(CAST(FECHA_HORA_CORRIDA AS DATE))as FECHA, (CAST(FECHA_HORA_CORRIDA AS TIME))AS HORA, DESTINO, ORIGEN, NOMBRE_PASAJERO FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND  '+
                               ' NOMBRE_PASAJERO = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE)  ORDER BY NO_ASIENTO;';
    _VTA_BUSCA_ASIENTOS = 'SELECT NO_ASIENTO FROM PDV_T_ASIENTO '+
                          'WHERE STATUS = ''R'' AND   NOMBRE_PASAJERO = ''%s'' AND '+
                          '  CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE)  ORDER BY NO_ASIENTO ';

    _VTA_BUSCA_ASIENTOS_CORRIDA = 'SELECT NO_ASIENTO FROM PDV_T_ASIENTO '+
                                  'WHERE STATUS = ''R'' AND   NOMBRE_PASAJERO = ''%s'' AND '+
                                  '  CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE) AND ID_CORRIDA = ''%s'' ORDER BY NO_ASIENTO ';


    _VTA_BUSCA_FECHA_AMBOS =   'SELECT DISTINCT(ID_CORRIDA),(CAST(FECHA_HORA_CORRIDA AS DATE))as FECHA,  '+
                               '(CAST(FECHA_HORA_CORRIDA AS TIME))AS HORA, ORIGEN,DESTINO, NOMBRE_PASAJERO  '+
                               ' FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND  '+
                               ' CAST(FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE)  ORDER BY NO_ASIENTO;';


    _VTA_VERIFICA_RESERVACION = 'SELECT COUNT(*) FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND NO_ASIENTO = %d';

    _VTA_BUSCA_ASIENTO_RESERVA = 'SELECT (COUNT(*))AS TOTAL FROM PDV_T_ASIENTO WHERE ID_CORRIDA = ''%s'' AND '+
                                 'FECHA_HORA_CORRIDA = ''%s'' AND NO_ASIENTO = %d '+ //AND TERMINAL_RESERVACION = ''%s'' '+
                                 ' AND NOMBRE_PASAJERO = ''%s'' ';
    _VTA_BUSCA_ORIDES_RESERVADA = 'SELECT ORIGEN,DESTINO FROM PDV_T_ASIENTO WHERE STATUS = ''R'' AND ID_CORRIDA = ''%s'' AND FECHA_HORA_CORRIDA = ''%s'' LIMIT 1';
    _VTA_BUSCA_DISPONIBLE_RESERVA = 'SELECT (COUNT(*)) AS TOTAL FROM PDV_T_ASIENTO WHERE FECHA_HORA_CORRIDA = ''%s'' AND '+
                                    'ID_CORRIDA = ''%s'' AND NO_ASIENTO = %d AND STATUS = ''V'';';

    _VTA_BUSCA_RESERVADO_APARTADO = 'SELECT (COUNT(*)) AS TOTAL FROM PDV_T_ASIENTO '+
                                 'WHERE FECHA_HORA_CORRIDA = ''%s'' AND ID_CORRIDA = ''%s'' AND NO_ASIENTO = %d AND STATUS = ''A'' ';
//                                 ' AND TERMINAL_RESERVACION = ''%s'' ';

    _VTA_RESERVADO_CORRIDA_HOY = 'SELECT DISTINCT A.ID_CORRIDA, D.FECHA, D.HORA, A.DESTINO '+
                                 'FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA_D D ON D.ID_CORRIDA = D.ID_CORRIDA AND '+
                                 '      CAST(A.FECHA_HORA_CORRIDA AS DATE) = D.FECHA AND '+
                                 '      CAST(A.FECHA_HORA_CORRIDA AS TIME) = D.HORA '+
                                 'WHERE A.STATUS IN (''R'')  AND CAST(A.FECHA_HORA_CORRIDA AS DATE) >= CURRENT_DATE() '+
                                 '      ORDER BY 2,3 ';

    _VTA_RESERVA_ASIENTOS_PASAJERO = 'SELECT NOMBRE_PASAJERO,NO_ASIENTO, ID_CORRIDA, FECHA_HORA_CORRIDA, STATUS FROM PDV_T_ASIENTO '+
                                     ' WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s'' AND '+
                                     ' CAST(FECHA_HORA_CORRIDA AS TIME) = ''%s'' AND STATUS IN (''R'') ORDER BY 1';

    _VTA_BORRA_RESERVADOS = 'DELETE FROM PDV_T_ASIENTO WHERE STATUS <> ''V'' AND ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE)  = ''%s'' '+
                            'AND  NOMBRE_PASAJERO = ''%s'' AND NO_ASIENTO IN (%s)';

    _VTA_T_PAGO_AL_100_TIEMPO     = 'SELECT DESCRIPCION,VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 4';
    _VTA_T_MENOR_100_TIEMPO       = 'SELECT DESCRIPCION,VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 5';
    _VTA_T_PAGO_AL_100_PORCENTAJE = 'SELECT DESCRIPCION,VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 6';
    _VTA_T_MENOR_100_PORCENTAJE   = 'SELECT DESCRIPCION,VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 7';
    _VTA_T_TIEMPO_A_CANCELAR      = 'SELECT DESCRIPCION,VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 23';


//cancelacion
    _CAN_T_INFORMA_CANCELAR = 'Desea efectuar la cancelacion para el boleto '+#10#13 +
                              ' %s ';

//////querys genericos
    _CONFIG_IPS_SERVERS = 'SELECT P.ID_TERMINAL,P.IPV4,P.BD_USUARIO, P.BD_PASSWORD,P.ESTATUS, P.TIPO '+
                          'FROM PDV_C_TERMINAL P INNER JOIN T_C_TERMINAL T ON T.ID_TERMINAL = P.ID_TERMINAL '+
                          'WHERE BD_USUARIO IS NOT NULL AND BD_PASSWORD IS NOT NULL AND IPV4 <> "" ';

    _VENTA_APARTA_CORRIDA_VENTA = 'UPDATE PDV_T_CORRIDA_D SET TRAB_ID = ''%s'' '+
                                  'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND HORA = CAST(''%s''AS TIME) AND ID_RUTA = %d';
    _STATUS_CORRIDA_VENTA = 'UPDATE PDV_T_CORRIDA_D SET ESTATUS = ''%s'' '+
                            'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND HORA = ''%s'' AND ID_RUTA = %s';


    _VENTA_NULL_CORRIDA_VENTA = 'UPDATE PDV_T_CORRIDA_D SET TRAB_ID = NULL '+
                                  'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND HORA = ''%s'' AND ID_RUTA = %d';

    _MENSAJE_TARIFA_CERO  = 'No existe la tarifa para esta corrida : %s ' + #10#13 + ' Con la ruta : %s y servicio %s';
    _MENSAJE_TARIFA_ANTICIPADA = 'No existe la tarifa ';

    _MENSAJE_CORRIDA_OCUPADA = 'La corrida esta en uso por el usuario : %s '+ #10#13 +
                               'El nombre del usuario : %s ';
    _CORRIDA_OCUPADA_VENTA = 'SELECT U.TRAB_ID, (CONCAT(E.PATERNO,'' '',E.MATERNO,'' '',E.NOMBRES))AS NOMBRE '+
                             'FROM PDV_T_CORRIDA_D D INNER JOIN PDV_C_USUARIO U ON D.TRAB_ID = U.TRAB_ID '+
                             '                       INNER JOIN EMPLEADOS E ON E.TRAB_ID = U.TRAB_ID '+
                             'WHERE D.FECHA = ''%s'' AND D.HORA = ''%s'' ';
    _VTA_FORMA_PAGO_DESCRIPCION  = 'SELECT ID_FORMA_PAGO,ABREVIACION, SUMA_EFECTIVO_COBRO, CANCELABLE '+
                             ' FROM PDV_C_FORMA_PAGO WHERE DESCRIPCION = ''%s'' ';
    _VTA_FORMA_PAGO_ABREVIACION  = 'SELECT ID_FORMA_PAGO,ABREVIACION, SUMA_EFECTIVO_COBRO, CANCELABLE '+
                             ' FROM PDV_C_FORMA_PAGO WHERE ABREVIACION = ''%s'' ';
///total de asiento disponibles
    _CUPO_ASIENTOS_TERMINAL = 'SELECT COUNT(NO_ASIENTO) '+
                              'FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA C ON A.ID_CORRIDA = C.ID_CORRIDA AND '+
                              '    CAST(A.FECHA_HORA_CORRIDA AS DATE) = C.FECHA AND '+
                              '    CAST(A.FECHA_HORA_CORRIDA AS TIME) = C.HORA '+
                              'WHERE A.ID_CORRIDA = ''%s'' '+
                              'AND CAST(A.FECHA_HORA_CORRIDA AS DATE) = CAST(''%s'' AS DATE) AND '+
                              '    CAST(A.FECHA_HORA_CORRIDA AS TIME) = ''%s'' AND A.STATUS IN (''V'',''R'',''A'') ';
    _CUPO_CORRIDA_VENTA_ACTUAL = 'SELECT (COALESCE(COUNT(NO_ASIENTO),0))AS CUPO FROM PDV_T_ASIENTO '+
                                 'WHERE ID_CORRIDA = ''%s'' '+
                                 ' AND FECHA_HORA_CORRIDA = ''%s''  '+
                                 ' AND STATUS IN (''V'',''R'',''A'') ';

    //MENSAJES PARA LA CANCELACION
    _REGRESA_EFECTIVO  = 'El importe del boleto :' + #10#13 + '$%s' + #10#13 + 'el boleto ha sido cancelado ' ;
    _REGRESA_DOCUMENTO = 'Regrese el documento tipo: ' + #10#13 + ' %s';
    _REGRESA_TARJETA   = 'Efectue la cancelacion electronica a: ' + #10#13 + ' %s';

    _MSG_VALIDA_CANCELA = 'Error al efectuar la consultar verifique la fecha de ingreso';

    _MSG_ASIENTO_CANCELA_NO_LIBRE = 'El lugar no se encuentra disponible para cancelar';


    _MSG_NO_HAY_CORRIDAS = 'No tenemos corridas para esa fecha: %s' + #10#13 +
                            'con esos parametros favor de procesarlas en el servidor ';
    _MSG_NO_HAY_RESERVACION = 'No tenemos corridas para la reservacion';

    _MSG_CAMPOS_INICIO = 'El nombre y la fecha es necesaria verifiquelo';
    _MSG_SALIR_VENTA   = ' ';
    _MSG_ACTUALIZA_CORRIDA   = 'Desea cambiar el estatus de la corrida %s';
    _MSG_ASIENTO_MAYOR_PERMITIDO = 'El numero de asiento no es '+#10#13+
                                   'valido para este autobus';
    _MSG_MAYOR_ASIENTO_PERMITIDO = 'El numero ingresado es mayor al permitido en el autobus';
    _MSG_ABRIR_CORRIDA = 'Confirme para abrir la corrida %s';
    _MSG_CERRAR_CORRIDA = 'Confirme para cerrar la corrida %s';
    _MSG_PRESDESPACHAR_CORRIDA = 'Confirme para predespachar la corrida %s';
    _MSG_DESPACHAR_CORRIDA = 'Confirme para Despachar la corrida %s';
    _MSG_IMPRIME_GUIA = 'Confirme para reimprimir la guia de la corrida %s';

    _MSG_DESPACHAR_TRAFICO = 'Desea continuar con la generacion de la guia';
    _MSG_NO_PERMITE_VENTA_CUPO = 'No se puede efectuar la venta no existen '+#10#13+
                                 'lugares disponibles ';
    _MSG_NO_VTA_DISPONIBLE = 'No tenemos lugares disponibles para la venta';
    _MSG_NO_VTA_CUALES = 'No se disponen de lugares para esta venta solo de Pie';
    _MSG_VTA_PIE_LIMITE = 'No puede disponer de la cantidad permitida ';


    ///conecta a server
    _CONECTA_TERMINAL = 'SELECT IPV4, BD_USUARIO, BD_PASSWORD FROM PDV_C_TERMINAL '+
                        'WHERE ESTATUS = ''A'' AND  ID_TERMINAL = ''%s'' ';


    ///mensaje no existe datos
    _MSG_DATOS_CORRIDA = 'No existen corridas con estos criterios de búsqueda';

    _TRAB_NOMBRE_COMPLETO = 'SELECT (CONCAT(PATERNO,'' '',MATERNO,'' '',NOMBRES)) AS NOMBRE from EMPLEADOS '+
                            'WHERE TRAB_ID = ''%s''';

    _STATUS_ASIENTO_VENDIDO = 'UPDATE PDV_T_ASIENTO SET STATUS = ''V'' '+
                              'WHERE ID_CORRIDA = ''%s'' AND FECHA_HORA_CORRIDA = ''%s'' AND '+
                              '       NO_ASIENTO = %d';
    _BORRA_RESERVADOS_ASIENTO = 'DELETE FROM PDV_T_ASIENTO '+
                                'WHERE ID_CORRIDA = ''%s'' AND FECHA_HORA_CORRIDA = ''%s'' AND STATUS = ''R'' AND '+
                                'NOMBRE_PASAJERO = ''%s''';
    _BORRA_RESERVADOS_RETURN = 'DELETE FROM PDV_T_ASIENTO '+
                                'WHERE ID_CORRIDA = ''%s'' AND FECHA_HORA_CORRIDA = ''%s'' AND STATUS = ''R'' AND NO_ASIENTO = %s';

    _CANCELA_EFECTIVO  = 'SELECT CANCELACION_EFECTIVO FROM PDV_C_FORMA_PAGO WHERE ID_FORMA_PAGO = %D';

    _BORRA_CANCELADO_ASIENTO = 'DELETE FROM PDV_T_ASIENTO '+
                                'WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s'' AND  '+
                                'NO_ASIENTO IN (%s) ';
    _CONSULTA_ASIENTOS_A_CANCELAR = 'SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID, (1)AS TAQUILLA, NOW(), '+
                                    'P.MENSAJE_CANCELACION, A.ID_CORRIDA,  A.NO_ASIENTO, A.FECHA_HORA_CORRIDA, B.ID_TAQUILLA, B.TARIFA , P.CANCELABLE '+
                                    'FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA C ON A.ID_CORRIDA = C.ID_CORRIDA AND '+
                                    '   CAST(A.FECHA_HORA_CORRIDA AS DATE) = C.FECHA AND '+
                                    '   CAST(A.FECHA_HORA_CORRIDA AS TIME) = C.HORA '+
                                    '    INNER JOIN PDV_T_BOLETO B ON (C.ID_CORRIDA = C.ID_CORRIDA AND C.FECHA = B.FECHA AND '+
                                    '                                 A.NO_ASIENTO = B.NO_ASIENTO) '+
                                    '    INNER JOIN PDV_C_FORMA_PAGO P ON P.ID_FORMA_PAGO = B.ID_FORMA_PAGO '+
                                    ' WHERE A.ID_CORRIDA = ''%s'' AND A.FECHA_HORA_CORRIDA = ''%s'' AND A.NO_ASIENTO = %d ';
    _CONSULTA_ASIENTO_CANCELABLE = 'SELECT DISTINCT(B.NO_ASIENTO),P.CANCELABLE,P.MENSAJE_CANCELACION,'+
                                   'B.TARIFA,B.ID_CORRIDA,B.ID_BOLETO,B.ID_TERMINAL,B.TRAB_ID,B.ID_TAQUILLA, P.DESCRIPCION '+
                                   'FROM PDV_T_ASIENTO A INNER JOIN PDV_T_BOLETO B ON A.ID_CORRIDA = B.ID_CORRIDA AND '+
                                   '                                                  CAST(A.FECHA_HORA_CORRIDA AS DATE) = B.FECHA '+
                                   '                     INNER JOIN PDV_C_FORMA_PAGO P ON P.ID_FORMA_PAGO = B.ID_FORMA_PAGO '+
                                   'WHERE  B.ESTATUS = ''V'' AND A.ID_CORRIDA = ''%s'' AND  CAST(A.FECHA_HORA_CORRIDA AS DATE) = ''%s'' AND B.NO_ASIENTO IN (%s)';

    _ACTUALIZA_CANCELADO_BOLETO = 'UPDATE PDV_T_BOLETO SET ESTATUS = ''C'' '+
                                  'WHERE ID_BOLETO = %s AND ID_TERMINAL = ''%s'' AND TRAB_ID = ''%s'' ';
    _REGISTRA_BOLETO_CANCELADO = 'INSERT INTO PDV_T_BOLETO_CANCELADO(ID_BOLETO, ID_TERMINAL,TRAB_ID_CANCELADO, '+
                                 ' FECHA_HORA_CANCELADO,ID_TAQUILLA, TRAB_ID,TRAB_ID_AUTORIZA) '+
                                 'VALUES(%s, ''%s'', ''%s'', NOW(), %s, ''%s'', ''%s'')';

    _MSG_BOLETO_CANCELADO = 'Los boletos han sido cancelados correctamente';
    _MSG_AGRUPAR_CORRIDA  = 'Confirme para agrupar las corridas elegidas';

    _A_CORRIDA_EMISORA_ASIENTOS = 'SELECT NO_ASIENTO,NOMBRE_PASAJERO,TERMINAL_RESERVACION,TRAB_ID,ORIGEN,DESTINO,STATUS '+
                                  'FROM PDV_T_ASIENTO '+
                                  'WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s'' '+
                                  ' AND ORIGEN = ''%s'' AND DESTINO = ''%s'' ';
    _A_BOLETO_EMISOR = 'SELECT ID_BOLETO,ID_TERMINAL,TRAB_ID,ESTATUS,ORIGEN,DESTINO,TARIFA, '+
                       'ID_FORMA_PAGO,ID_TAQUILLA,TIPO_TARIFA,FECHA_HORA_BOLETO,ID_CORRIDA,FECHA,NOMBRE_PASAJERO,NO_ASIENTO,ID_OCUPANTE,ESTATUS_PROCESADO  '+
                       'FROM PDV_T_BOLETO  '+
                       'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ORIGEN = ''%s'' AND DESTINO = ''%s''';
    _A_BORRA_ASIENTO_EMISOR = 'DELETE FROM PDV_T_ASIENTO WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s'' AND '+
                              'ORIGEN = ''%s'' AND DESTINO = ''%s'' ';
    _A_INSERTA_ASIENTO_RECEPTOR = 'INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,NOMBRE_PASAJERO, '+
                                  '  TERMINAL_RESERVACION, TRAB_ID, ORIGEN, DESTINO,STATUS) '+
                                  'VALUES(''%s'',''%s'',%s,''%s'',''%s'',''%s'',''%s'',''%s'',''%s'')';

    _LOCAL_BOLETO = 'SELECT B.IVA, B.TOTAL_IVA FROM PDV_T_BOLETO B '+
                    'WHERE B.ID_BOLETO = %s AND ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND B.NO_ASIENTO = %s AND B.TRAB_ID = ''%s'' ';

    _SERVER_IVA_UPDATE = 'UPDATE PDV_T_BOLETO SET IVA = %s, TOTAL_IVA = %s WHERE ID_BOLETO = %s AND TRAB_ID = ''%s'' AND NO_ASIENTO = %s';

    _A_INSERTA_ASIENTO_RECEPTOR_RESERVA = 'INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,NOMBRE_PASAJERO, '+
                                  '  TERMINAL_RESERVACION, TRAB_ID, ORIGEN, DESTINO,STATUS,FECHA_HORA_ORIGEN) '+
                                  'VALUES(''%s'',''%s'',%s,''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'')';

    _A_UPDATE_ASIENTO_RECEPTOR = 'UPDATE PDV_T_ASIENTO SET STATUS = ''V'' '+
                                 'WHERE ID_CORRIDA = ''%s'' AND FECHA_HORA_CORRIDA = ''%s'' AND '+
                                 'NO_ASIENTO = %s ';
    _A_ACTUALIZA_BOLETO_NO_EXISTE = 'UPDATE PDV_T_BOLETO SET ID_CORRIDA = ''%s''  '+
                                 'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ORIGEN = ''%s'' '+
                                 'AND DESTINO = ''%s'' AND ID_BOLETO = %s AND TRAB_ID = ''%s'' ';
    _A_ACTUALIZA_BOLETO_EXISTE = 'UPDATE PDV_T_BOLETO SET ID_CORRIDA = ''%s'' , NO_ASIENTO = %s '+
                                 'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ORIGEN = ''%s'' '+
                                 'AND DESTINO = ''%s'' AND ID_BOLETO = %s AND TRAB_ID = ''%s'' ';

    _MSG_AGRUPADA_OK = 'La corrida ha sido agrupada correctamente';
    _MSG_CANCELACION_NULA = 'No se pueden cancelar este boleto(s) '+#10#13+
                            'no se tiene venta registrada';
    _BUSCA_CUALES_SOLUCION = 'SELECT A.NO_ASIENTO, '+
                               '            CASE A.STATUS '+
                               '                WHEN ''V'' THEN CONCAT(A.ORIGEN, '' '' ,A.DESTINO) '+
                               '                WHEN ''R'' THEN ''R'' '+
                               '                WHEN ''A'' THEN ''A'' '+
                               '            END AS TEXTO '+
                               '    FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA C ON '+
                               '                      (C.ID_CORRIDA = A.ID_CORRIDA AND C.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE)) '+
                               '    WHERE CAST(A.FECHA_HORA_CORRIDA AS DATE) = ''%s'' AND A.ID_CORRIDA = ''%s'' AND NO_ASIENTO IN (%s) ';
    _OCUPANTES_MUESTRA_CEROS = 'SELECT DESCRIPCION , (0) AS TOTAL '+
                               '          FROM PDV_C_OCUPANTE O  '+
                               '          WHERE ID_OCUPANTE NOT IN (1,2,3)  '+
                               '        UNION  '+
                               '          SELECT DESCRIPCION,  '+
                               '          (COALESCE((SELECT CO.MAXIMO FROM PDV_T_CORRIDA_OCUPANTE CO  '+
                               '           WHERE CO.ID_OCUPANTE = 4 AND CO.ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND CO.ID_TERMINAL = ''%s''),0) -  '+
                               '           (SELECT COUNT(*) FROM PDV_T_BOLETO B  '+
                               '            WHERE B.FECHA = ''%s'' AND B.ID_OCUPANTE = O.ID_OCUPANTE AND  '+
                               '                  ESTATUS = ''V'' AND ORIGEN = ''%s'' AND ID_CORRIDA = ''%s''))  '+
                               '          FROM PDV_C_OCUPANTE O  '+
                               '          WHERE O.ID_OCUPANTE = 4  '+
                               '        UNION  '+
                               '          SELECT ''PIE'',(PIE - (SELECT COALESCE(COUNT(NO_ASIENTO),0)  '+
                               '                               FROM PDV_T_ASIENTO  '+
                               '                               WHERE NO_ASIENTO > 100 AND ID_CORRIDA = ''%s'' AND STATUS = ''V'' AND  '+
                               '                                     CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s'' ))   '+
                               '          FROM PDV_T_CORRIDA_D  '+
                               '          WHERE ID_CORRIDA = ''%s'' AND  FECHA = ''%s'' AND ID_TERMINAL = ''%s''  ';
    _COMPARA_FECHA_VACACIONAL = 'SELECT (COALESCE(COUNT(*),0))AS EXISTE FROM PDV_C_PERIODO_VACACIONAL '+
                                'WHERE CAST(FECHA_INICIO AS DATE) <= ''%s'' AND CAST(FECHA_FIN AS DATE) >=  ''%s'' ';

    _ASIENTOS_VACIO = 'Es necesario ingresar los asientos a vender';
    _MSG_CORRIDA_MENSAJE_ESTATUS = 'La corrida se ha actualizado ';
    _MSG_ERROR_EXISTE_VENTA_CORRIDA = 'Hay %d asientos vendidos o reservados, así que no se puede cerrar la corridas: %s';

    _SERVER_BOLETO_QUERY = 'INSERT INTO PDV_T_BOLETO(ID_BOLETO, ID_TERMINAL, TRAB_ID, ESTATUS, '+
                           ' ORIGEN, DESTINO, TARIFA, ID_FORMA_PAGO, '+//
                           ' ID_TAQUILLA, TIPO_TARIFA,   FECHA_HORA_BOLETO, ID_CORRIDA, '+
                           ' FECHA, NOMBRE_PASAJERO, NO_ASIENTO, ID_OCUPANTE, ID_RUTA, TIPOSERVICIO, ID_PAGO_PINPAD_BANAMEX, TC,IVA,TOTAL_IVA,'+
                           ' ID_FORMA_PAGO_SUB ) '+
                           'VALUES(%s,''%s'',''%s'',''%s'',''%s'',''%s'', %s, %s,%s,''%s'', ''%s'', ''%s'', '+
                           '        ''%s'', ''%s'', %s , %s, %s, %s,''%s'', ''%s'',%s, %s, ''%s'' )';


    _SERVER_QUERY_LOCAL = 'INSERT INTO PDV_T_QUERY(ID_TERMINAL, SENTENCIA, FECHA_HORA) VALUES( "%s", "%s", now())';

    _VENTA_ANTICIPADA_QUERY = 'SELECT TA.ID_SERVICIO,S.DESCRIPCION, S.ABREVIACION, TD.MONTO, R.ID_RUTA '+
                              'FROM PDV_T_CORRIDA_D D INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA  '+
                              '                       INNER JOIN T_C_RUTA_D RD ON RD.ID_RUTA = R.ID_RUTA '+
                              '                       INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = RD.ID_TRAMO '+
                              '                       INNER JOIN PDV_C_TARIFA TA ON TA.ID_TRAMO = T.ID_TRAMO '+
                              '                       INNER JOIN PDV_C_TARIFA_D TD ON TD.ID_TARIFA = TA.ID_TARIFA '+
                              '                       INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = TA.ID_SERVICIO '+
                              'WHERE D.ID_TERMINAL = ''%s'' AND T.DESTINO = ''%s'' AND TA.ID_SERVICIO = %s AND TD.FECHA_HORA_APLICA <= NOW() '+
                              'LIMIT 1';

    _VENTA_ANTICIPADO_BUSCA = 'SELECT (COUNT(ID_BOLETO))AS TOTAL, NOMBRE_PASAJERO, TARIFA, FECHA, '+
                              '       ID_FORMA_PAGO, ID_TAQUILLA, TIPO_TARIFA, ID_OCUPANTE '+
                              'FROM PDV_T_BOLETO '+
                              'WHERE ORIGEN = ''%s'' AND DESTINO = ''%s'' AND FECHA = ''%s'' AND TRAB_ID = ''%s'' AND NO_ASIENTO = 0';

    _VENTA_BOLETOS_ANTICIPADOS = 'SELECT ID_BOLETO,ID_TERMINAL,TRAB_ID,ESTATUS,ORIGEN, '+
                              'DESTINO,TARIFA,ID_FORMA_PAGO,ID_TAQUILLA,FECHA_HORA_BOLETO,ID_CORRIDA,FECHA,'+
                              'NOMBRE_PASAJERO,NO_ASIENTO,ID_OCUPANTE,TIPO_TARIFA '+
                              'FROM PDV_T_BOLETO '+
                              'WHERE ORIGEN = ''%s'' AND DESTINO = ''%s'' AND FECHA = ''%s'' AND TRAB_ID = ''%s'' ';

    _ACTUALIZA_BOLETO_ANTICIPADO = 'UPDATE PDV_T_BOLETO SET ID_CORRIDA = ''%s'', NO_ASIENTO =  %s   '+
                               'WHERE ID_BOLETO = %s AND ORIGEN = ''%s'' AND DESTINO = ''%s'' AND FECHA_HORA_BOLETO = ''%s'' ';

    _PERIODO_VACACIONAL = 'SELECT FECHA_INICIO, FECHA_FIN FROM PDV_C_PERIODO_VACACIONAL';


    _V_APLICACION = 'UPDATE PDV_C_TAQUILLA SET VERSION = ''%s'' WHERE ID_TERMINAL = ''%s'' AND  ID_TAQUILLA = ''%s'' AND IP = ''%s'' ';

    _AGRUPA_CORRIDAS = 'CALL PDV_STORE_AGRUPA_CORRIDAS(''%s'',''%s'',''%s'',''%s'')';



    _BOLETO_REMOTO = 'SELECT ID_BOLETO,(''%s'')AS TERMINAL,TRAB_ID,(''C'')AS CANCELADO,ORIGEN,DESTINO,TARIFA,ID_FORMA_PAGO,TIPO_TARIFA, '+
                     'FECHA_HORA_BOLETO,ID_CORRIDA,FECHA,NOMBRE_PASAJERO,NO_ASIENTO,ID_OCUPANTE,ID_TAQUILLA '+
                     'FROM PDV_T_BOLETO '+
                     'WHERE ORIGEN = ''%s'' AND DESTINO = ''%s'' AND ID_CORRIDA = ''%s''  AND FECHA = ''%s'' AND '+
                     'NO_ASIENTO = %s';

    _CODIGO_UNICO_FACTURA = 'SELECT MD5(CONCAT(''%s'',SUBSTR(CURRENT_dATE,1,4 ),SUBSTR(CURRENT_dATE,6,2),SUBSTR(CURRENT_dATE,9,2) '+
                    ',SUBSTR(CURRENT_TIME,1,2),SUBSTR(CURRENT_TIME,4,2), SUBSTR(CURRENT_TIME,7,2) )) AS CODE';

 //   _BOLETO_NUEVO_LOCAL = 'INSERT INTO PDV_T_BOLETO(ID_BOLETO,ID_TERMINAL,TRAB_ID,ESTATUS,ORIGEN,DESTINO,TARIFA, '+
 //                         '   ID_FORMA_PAGO, ID_TAQUILLA, FECHA_HORA_BOLETO, ID_CORRIDA, FECHA,NO_ASIENTO, ID_OCUPANTE) '+
 //                         'VALUES(%s,''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',%s,%s,''%s'',''%s'',''%s'',%s,%s)';

//principal
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
      servicio    : string;
      forma_pago  : integer;
      descuento   : integer;
      Ocupante    : String;
      tipo_tarifa : string;
      idOcupante  : Integer;
      taquilla    : integer;
      nombre      : String;
      abrePago    : string;
      ruta        : integer;
      pago_efectivo : integer;
      calculado   : integer;
      id_pago_pinpad_banamex : String; // Salez
      iva         : Real;
      tipo_tarjeta : String;
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
      ruta     : integer;
      servicio : integer;
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
    array_lugares   = array[1..1000] of PDV_POSICION_ASIENTO;
    array_boletos   = array[1..50]of PDV_Boleto;
    array_asientos  = array[1..50] of PDV_Asientos;//arreglo para la venta de boletos
    array_reservaciones = array[1..50] of PDV_Reservaciones;//arreglo para las reservaciones
    array_servers   = array[1..1000]of PDV_Servers;//arreglo para las ips de los servers
   //para el control de los asientos
    la_asientos  = array[0..50] of Integer;
    la_acancelar = array[1..50] of Integer;
    labels_asientos = array[1..51] of ^Tlabel;


    function existeVentaDeCorrida(fecha_inicio, fecha_fin : TDate;
                                  Corrida : String; servicio : integer) : integer;
    procedure llenarTerminales(query : TSQLQuery);
    procedure showDetalleRuta(lpi_ruta : integer; Grid : TStringGrid);
    procedure corridasParametros(origen, destino, fecha, lps_hora, lps_servicio : String; li_codicion : integer; Grid : TStringGrid;
                                 corrida : String);
    procedure corridasPredespacho(origen, destino, fecha, lps_hora, lps_servicio : String;
                                  li_codicion : integer; Grid : TStringGrid);
    procedure showOcupantes(Terminal : String; Corrida : String; fecha : TDate;  Grid : TStringGrid);
    procedure OcupantesCorrida(Terminal : String; Corrida : String; fecha : TDate;  Grid : TStringGrid);
    procedure muestraEstatus(origen : String; Grid : TStringGrid);
    procedure muestraEstatustTimer(origen : String; Grid : TStringGrid; linea : Integer);
    procedure clearGridVenta(grid : TStringGrid; linea : integer);
    procedure buscaOcupantes(grid : TStringGrid);
    procedure llenaOcupantesSAdulto();
    function split_Hora(Input : String) : string;
    function tiempo_Espera_Grid(): Integer;
    function horaServer() : string;

    procedure guardaVendidos(li_corrida : Integer; ls_fecha : string; li_asiento : Integer;
                         ls_trabid, ls_origen, ls_destino : string);
    procedure AutobusesDuales();
    function AsientoOcupado(store : TSQLStoredProc; li_continuo : integer) : Boolean;
    procedure procesoVentaCuantos(li_asientos : integer; ls_corrida : String; li_elegidos_asientos : integer;
                       fecha, Origen, Destino, user, servicio : string; costo : real;
                       var array_Seat : array_asientos; taquilla : Integer;
                       ruta : integer; var li_insertados : integer);
    procedure procesoVentaAnticipada(li_asientos_ingresados : integer;
                                     fecha, Origen, Destino,user,servicio : String; costo : real;
                                     taquilla, ruta : integer; var array_Seat : array_asientos; pasajero : String);

    procedure procesoVentaCuales(CualesAsientos : la_asientos; li_maximo : integer; ls_corrida,
                             fecha, Origen, Destino, user, servicio : string; costo : real;
                             var array_Seat : array_asientos; taquilla : Integer; iva : real);
    procedure procesoCuales(CualesAsientos : la_asientos; li_maximo : integer; ls_corrida: string;
                             var array_Seat : array_boletos;
                             ls_origen, ls_destino,ls_nombre,ls_fecha, ls_trabid,ls_fecha_corrida,ls_hora : string);
    procedure actualizaBoletoAnticipado(array_Seat : array_boletos; ls_fecha_original : string; li_maximo : integer);
    procedure asignaReservados(li_corrida : String; origen, destino, terminal_reservacion : string;
                               la_asientos : la_asientos; fecha: String; li_asientos : integer;
                               var arreglo : array_reservaciones; idTrab : String;
                               ruta, servicio : integer);

    procedure liberaReservacion(reservado : array_reservaciones; Pasajero : String; li_asientos : integer; terminal : string);
    procedure NoliberaReservacion(reservado : array_reservaciones; Pasajero : String; li_asientos : integer; terminal : string);
    procedure registraReservados(reservado : PDV_Reservaciones);
    function calcula(arreglo : array_asientos; li_vendidos : Integer) : Currency;
    procedure limpiarArregloAsientos(arreglo : array_asientos);

    procedure ImprimeBoletos(asientos : array_asientos; li_vendidos : Integer);
    function getCodeImprimeFactura(str_user : String) : string;
    procedure ImprimeCargaInicial(trabid : String);
    procedure ImprimeCargaArqueo(Terminal, Taquilla, trabid, autoriza, importe, promotor_name : String);
    procedure BorraAsiento(var asientos : array_asientos; li_vendidos : Integer);
    procedure BorraArregloAsientos(var asientos : array_asientos);
    procedure BorraAsientoArreglo(asientos : array_asientos; li_vendidos : Integer;corrida : String);
    function  validaSiguienteFecha(fecha_consulta : TDate) : TDate;
    function  nombreServicio(cortoName : string) : string;
    procedure estatus_ASIENTO(asientos : PDV_Asientos; lc_opcion : Char);
    procedure estatus_boleto(boletos : PDV_Boleto; lc_opcion : char; fecha_original, ls_hora :String);
    function folioBoleto(trabid, terminal : String) : integer;
    procedure RegistrarBoleto(asientos : PDV_Asientos; boleto : integer; fechaCorrida, folio_factura : String);
    procedure ActualizaPrecioArreglo(var asientos : array_asientos; li_indice : Integer;
                                 lf_precio : Real);
    function getExpedicion(terminal : string) : String;
    procedure llenarArregloCaracteres;
    procedure recalculaPrecioConDescuento(var arreglo : array_asientos);
    function asientoReservado(ls_fecha : string; Grid : TStringGrid) : integer; overload;
    function getFechaSistema() : integer;
    function asientoReservado(ls_nombre,ls_fecha : string; Grid : TStringGrid) : integer; overload;


    procedure cargarGridReservadoCorrida(li_corrida : String; ls_fecha, ls_hora, ls_destino, ls_origen : string;
                                         Grid : TStringGrid; li_idx : integer);
    procedure cargarGridReservadoCorridaNew(ls_fecha : string; Grid : TStringGrid;
                                            var li_idx : integer);
    procedure muestraCorridaCancelarGrid(ls_origen,ls_destino, fecha, corrida : String; Grid : TStringGrid);
    procedure borramosAsientoCancelado(li_corrida, li_asiento : integer; fecha, hora : String;
                                        store : TSQLStoredProc);
    procedure registraCancelado(li_boleto, li_taquilla : integer;
                            ls_terminal, ls_trab_cancela, ls_trabid :String);
    procedure creaStoreConnecion();

    procedure limpiaStringGrid(Grid : TStringGrid);
    function reWrite(ls_cadena: String) : String;
    function porSeparador(ls_cadena : string) : string;
    function validaTipoHueco(ls_cadena : String) : string;
    function existe(lc_carac : Char) : Boolean;
    function rangoAsientos(ls_cadena : string) : boolean;
    function verificaDisponibles(ls_asiento, fecha, corrida : String): Boolean;
    function validaCualesOcupantes(ls_cadena : string) :  String;
    function verificaCorridaDisponible( corrida : string; fecha : TDate;
                                      hora : String; terminal : string): string;
    function obtenerIpsServer() : array_servers;
    function ConexionObtenIPServer(ls_terminal : string) : TSQLConnection;

    function accesoQueryStoreLocalRemoto(lp_origen : String) : TSQLConnection;

    function buscAsientoCancela(li_corrida : String;fecha, time : string; var li_max :integer): la_acancelar;
    procedure limpiar_La_labels(lbl_asientos : labels_asientos);
    procedure llenarGridCorridas(lps_hora : String; store : TSQLStoredProc;
                                  var li_indice : integer; Grid : TStringGrid);
    function comparaHoraCorrida(lps_hora, lps_store : String): Boolean;
    procedure titulosCorridaGrid(grid : TStringGrid);
    function storeApartacorrida(corrida : String; fecha : TDate; terminal : String; trabid : string) : string;
    procedure apartaCorrida(corrida : String; fecha : TDate; hora : String;
                            terminal : String; trabid : string; ruta : integer);

    procedure MuestraCorridasLiberar(Origen : string; Grid : TStringGrid);

    procedure limpiarPDV(var asientos : array_asientos);
    procedure actualizaStatusAsiento(array_Seat : array_asientos;
              li_maximo : integer; nombre : String);

    procedure asientosEmisora(ls_corrida,fecha,ls_origen, ls_destino : String;
              var output: gga_parameters; var indice : integer);

    procedure insertaReceptora(output: gga_parameters; ls_corrida,hora : string;
                              fecha : TDate; maximo, lugares : integer; Grid : TStringGrid);
    procedure ErrorLog(Error, sql : string);
    procedure HoraEntradaEdit(var Ed_Hora : TEdit);
    procedure ValidaFormatoHora(var Ed_Hora : TEdit);

    procedure llenarArregloBoletos(qry : TSQLQuery);
    procedure actualizaBoletoAgrupado(corrida, fecha, origen,
                                      destino,  asiento,trab_id, asiento_nuevo : String;
                                      inserta : integer);
    procedure tarifaGridLlena(Grid : TStringGrid; origen : String);

    procedure llenaPosicionLugares();
    procedure obtenPeriodoVacacional();
    procedure guardarVersion(version : string);

    function cupoRutaYTerminal(corrida : String; ruta : integer; hora,fecha,
                              terminal : string; servicio : integer) : integer;
    function cupoCorridaVigente(corrida, fecha, hora : string; conexion : TSQLConnection) : integer;
    function cupoPieCorrida(corrida,fecha,terminal : string) : Integer;
    function conexionAServidor(terminal : string) : Boolean;
    function nombreCompletoTrabid(trabid : string) : string;

    function borraEmisora(ls_corrida,fecha,ls_origen, ls_destino : String; ruta : integer): string;
    function GridCorridaActualNueva(renglon : integer; Grid : TStringGrid) : integer;
    function tarifaCorrida(Grid : TStringGrid; origen : String) : real;
    function EstaEnPeriodoVacacional(fecha_actual : String) : integer;

    procedure guardamosAutobus();
    procedure obtenImagenBus(img : TImage; Nombre : string);
    procedure muestraAsientosArreglo(labels : labels_asientos; id_bus : integer; panel : TPanel);
    procedure asientosOcupados(labels : labels_asientos; ld_fecha : TDate; lt_hora : TTime;
                           ls_corrida : string);
    procedure asignaVenta(trabid, terminal : string; taquilla:integer);
    function estatus_corrida(corrida, fecha : string) : string;
    function total_pasajeros_corrida(corrida, fecha : String) : integer;
    procedure carga_reimpresion(fecha, terminal : string; Grid : TStringGrid);


    function conexionServidorRemoto(terminal : string) : TSQLConnection;
    function getDescripcionTerminal(terminal : String) : string;
    function getParametroItaca : integer;
    function getPrinterBoleto  : integer;
    function obtieneDigitoVerificador(str_cadenaUnica :String) : string;
    function RegresaIVA(iva : String): real;

//special



var
    gds_terminales : TDualStrings;
    venta_asiento   : PDV_Asientos;
    li_ctrl_asiento : integer;
    gds_formas_pago : TDualStrings;
    gds_tabla_forma_pago : TDualStrings;
    la_caracteres : array[0..12]of Char;
    la_separador  : array[0..2]of char;
    gds_ocupantes_disponibles : TDualStrings;
    gds_ListaOcupantes : TDualStrings;
    gi_cuales     : integer;
    gds_ocupantes_asignados : TDualStrings;
    gi_idx_asientos  : Integer; //numero de asientos en cuales
    gb_forma_pago  : Boolean;
    key_numericos : array[0..20]of Integer;
    ocupanteSinAdulto : array[1..20]of String;

    gs_corrida_apartada : String;
    gd_fecha_apartada   : TDate;
    gs_hora_apartada    : string;
    gs_terminal_apartada : string;
    gi_ruta_apartada : Integer;
    gi_usuario_ocupado : Integer;

    gb_asignado : Boolean;
    ga_servers  : array_servers;
    ga_lugares_bus : array_lugares;
    gi_numCorrida : integer;
    gi_corrida_en_uso : Integer;//para cuando tenemos la corrida en uso
    gi_fila_corrida : integer;

    ConexionRemota : TSQLConnection;
    storeRemota    : TSQLStoredProc;
    formPago       : Integer;

    gi_otro_boleto : integer;
    gi_solo_pie    : integer;
    gi_cupo_ruta   : integer;
    gi_ocupados    : integer;
    gi_permitido_cupo : integer;
    gi_vta_pie     : integer;

    CONEXION_VTA : TSQLConnection;


    li_opcion_fecha_string : integer;

    li_existe_reservacion : integer;//0 no hay 1 si tiene
    li_impresion_boleto : integer;
    li_agrupa_corrida : integer;
    li_ocupantes_no_hay : integer;
    gs_fondo_inicial : String;
    gb_fondo_ingresado : Boolean;



    fecha_agrupada : string;
    hora_agrupada  : String;
    corrida_agrupada : string;
    BOLETOS_PDV : array_boletos;
    li_maximo_boletos : integer;

    li_memoria_cuales :  integer;
    memoria_cuales : la_asientos;
    CORRIDA_ULTIMA : PDV_ULTIMA_VENTA;
    CORRIDA_ACTUAL : PDV_REFRESCA_VENTA;
    ls_corrida : string;
    li_ok_password : integer;
    li_tarjeta_viaje : integer;

    li_vta_anticipada_pago : integer;
    ld_costo_anticipado  : Real;
    ls_fecha_anticipada  : String;

    ls_asientos_reservados : String;
    ld_tarifa: Real;
    li_maximo_asientos : integer;
    gd_vacacional_inicio : string;
    gd_vacacional_fin : string;


    grid_rutas      : TStringGrid;
    grid_r_tarifas  : TStringGrid;

//    gs_nombre_trabid : string;
    key_sag_venta : char;
    tiempo_key    : TDateTime;
    li_actualiza_ruta : integer;
    li_f4: Integer;
    ls_extra_imprime : String;

    gi_fondo_inicial_store : integer;
    gs_trabid_store        : string;
    gs_estatus_store       : string;
    gi_taquilla_store      : integer;
    gi_corte_store         : integer;
    gi_out_valida_asignarse : integer;
    gi_ruta   : integer;
    ls_promotor_asignado   : string;
    gs_nombre_pax : String;

    gi_arreglo : integer;
    asientos_regreso: array_asientos;

    CONEXION_REMOTO : TSQLConnection;
    gi_ruta_reserva : integer;
    gi_corrida_reserva,    gi_fecha_reserva, gi_hora_reserva  : String;

    gs_patron_terminal : String;

    gs_tarjeta_CD : String;


implementation

uses DMdb, TLiberaAsientosRuta, Graphics, Frm_cancela_boletos, u_boleto,
     u_ithaca_print, u_ToshibaMini_print, u_impresion, u_gral_venta;


function validaSiguienteFecha(fecha_consulta : TDate) : TDate;
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


procedure llenarGridCorridas(lps_hora : String; store : TSQLStoredProc; var li_indice : integer; Grid : TStringGrid);
var
    ld_tarifa : real;
    ls_fecha_hora : String;
begin
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
//    Grid.Cells[_COL_TARIFA,li_indice] := FormatFloat('##.00',store.FieldByName('TARIFA').AsFloat);//Format('%0.2f',[ld_tarifa]);
{    try
    Grid.Cells[_COL_IVA,li_indice]    := FloatToStr(store.FieldByName('IVA').AsFloat);
//    if gi_cobro_con_iva = 0 then
        Grid.Cells[_COL_TARIFA,li_indice] := FormatFloat('##.00',store.FieldByName('TARIFA').AsFloat);//Format('%0.2f',[ld_tarifa]);
  {  if gi_cobro_con_iva = 1 then
      Grid.Cells[_COL_TARIFA,li_indice] := format('%0.2f',[(store.FieldByName('TARIFA').asFloat * store.FieldByName('IVA').AsFloat / 100) +
                                                         store.FieldByName('TARIFA').asFloat])  ;}
 //   except
//    end;}
    try
        Grid.Cells[_COL_IVA,li_indice] := FloatToStr(store.FieldByName('IVA').AsFloat);
    except
        Grid.Cells[_COL_IVA,li_indice] := '0.00';
    end;
    Grid.Cells[_COL_TARIFA,li_indice] := FormatFloat('##.00',store.FieldByName('TARIFA').AsFloat);//Format('%0.2f',[ld_tarifa]);
    inc(li_indice);
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


procedure corridasPredespacho(origen, destino, fecha, lps_hora, lps_servicio : String;
                                  li_codicion : integer; Grid : TStringGrid);
var
    store : TSQLStoredProc;
    fecha_next : TDate;
    ls_char : Char;
    ls_hora : string;
    li_idx: Integer;
    lb_opcion  : Boolean;
begin
    fecha_next := validaSiguienteFecha(StrToDate(fecha));
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := DM.Conecta;
    store.close;
    store.StoredProcName := 'PDV_STORE_VENTA_MUESTRA_PREDESPACHO';
    store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
    store.Params.ParamByName('IN_DESTINO').AsString := Destino;
    store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
    store.Params.ParamByName('FECHA_SIGUIENTE').AsString := FormatDateTime('YYYY-MM-DD',fecha_next);
    store.Open;
    li_idx := 1;
    with store do begin
        First;
        while not EoF do begin
            ls_char := Store.FieldByName('TIPO').AsString[1];
            case ls_char of
                'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
            end;
            if ((Store['COMPARA'] = 1) and (lb_opcion = False)) then begin
                gi_select_corrida := li_idx;
                lb_opcion := true;
            end;
            ls_char := Store.FieldByName('ESTATUS').AsString[1];
            case ls_char of
                'A' : Grid.Cells[_COL_STATUS,li_idx] := 'Abierta';
                'P' : Grid.Cells[_COL_STATUS,li_idx] := 'Predespachada';
                'D' : Grid.Cells[_COL_STATUS,li_idx] := 'Despachada';
                'C' : Grid.Cells[_COL_STATUS,li_idx] := 'Cerrada';

            end;
            llenarGridCorridas(ls_hora,store,li_idx,Grid);
            next;
        end;
    end;
    if li_idx = 1 then
       Inc(li_idx);

    Grid.RowCount := li_idx;
    Grid.Row := gi_select_corrida;
end;


procedure muestraCorridaCancelarGrid(ls_origen,ls_destino, fecha, corrida : String; Grid : TStringGrid);
var
    li_idx : integer;
    ls_char : Char;
    store : TSQLStoredProc;
    fecha_next : TDate;
    ls_hora :  String;
    lb_hora_menor : Boolean;
begin
    store := TSQLStoredProc.Create(nil);
    fecha_next := validaSiguienteFecha(StrToDate(fecha));
    gi_numCorrida := 0;
    try
        store.SQLConnection := CONEXION_VTA;
        store.close;
        store.StoredProcName := 'PDV_STORE_FOR_CANCELAR';
        store.Params.ParamByName('IN_ORIGEN').AsString := ls_origen;
        store.Params.ParamByName('IN_DESTINO').AsString := ls_destino;
        store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        store.Open;
        li_idx := 1;
        gi_select_corrida := 0;
        with store do begin
            First;
            while not EoF do begin
                ls_char := Store.FieldByName('TIPO').AsString[1];
                case ls_char of
                    'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                    else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                end;
                llenarGridCorridas(ls_hora,store,li_idx,Grid);
                gi_select_corrida := 1;
                inc(gi_numCorrida);
                next;
            end;//
        end;//fin with
          if li_idx = 1 then
             Inc(li_idx);
          if (gi_select_corrida = 0) and (gi_numCorrida > 0) then
              gi_select_corrida := gi_numCorrida;
          if gi_select_corrida = 0 then
              gi_select_corrida := 1;
          Grid.RowCount := li_idx;
          Grid.Row := gi_select_corrida;
    finally
        store.free;
        store := nil;
    end;
end;//fin muestraCorridaCancelarGrid



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
//          store.StoredProcName := 'PDV_STORE_MUESTRA_CORRIDAS'; PDV_STORE_VENTA_MUESTRA_CORRIDAS
          store.close;
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

procedure muestraEstatustTimer(origen : String; Grid : TStringGrid; linea : Integer);
var
    store : TSQLStoredProc;
    ls_char : Char;
    ls_hora : string;
    li_idx: Integer;
    lb_opcion  : Boolean;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA; //DM.Conecta;
    store.close;
    store.StoredProcName := 'PDV_STORE_STATUS_CORRIDAS';
    store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
    store.Open;
    li_idx := 1;
    with store do begin
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
            ls_char := Store.FieldByName('ESTATUS').AsString[1];
            case ls_char of
                'A' : Grid.Cells[_COL_STATUS,li_idx] := 'Abierta';
                'P' : Grid.Cells[_COL_STATUS,li_idx] := 'Predespachada';
                'C' : Grid.Cells[_COL_STATUS,li_idx] := 'Cerrada';
                'D' : Grid.Cells[_COL_STATUS,li_idx] := 'Despachada';
            end;
            llenarGridCorridas(ls_hora,store,li_idx,Grid);
            inc(li_idx);
            Next;
        end;// fin while
    end;//fin with
    Grid.RowCount := li_idx;
    Grid.Row := linea;
end;


procedure carga_reimpresion(fecha, terminal : string; Grid : TStringGrid);
var
    store  : TSQLStoredProc;
    li_out : Integer;
    ls_hora : string;
    ls_char : Char;
    lb_opcion  : Boolean;
    li_idx: Integer;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.close;
        store.StoredProcName := 'PDV_STORE_CORRIDAS_IMPRESION';
        store.Params.ParamByName('IN_ORIGEN').AsString := terminal;
        store.Params.ParamByName('FECHA_INPUT').AsString := fecha;
        store.Open;
        li_idx := 1;
        with store do begin
            First;
            while not EoF do begin
                ls_char := Store.FieldByName('TIPO').AsString[1];
                case ls_char of
                    'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                    else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                end;
                if ((Store['COMPARA'] = 1) and (lb_opcion = False)) then begin
                    gi_select_corrida := li_idx;
                    lb_opcion := true;
                end;
                llenarGridCorridas(ls_hora,store,li_idx,Grid);
                if store['ESTATUS'] = 'D' then
                    Grid.Cells[_COL_TARIFA,li_idx - 1] := 'Despachada';
                if store['ESTATUS'] = 'V' then
                    Grid.Cells[_COL_TARIFA,li_idx - 1] := 'Vacio';
                if store['ESTATUS'] = 'P' then
                    Grid.Cells[_COL_TARIFA,li_idx - 1] := 'Predespachada';
                Next;
            end;//fin while
        end;
        if li_idx = 1 then
           Inc(li_idx);
        Grid.RowCount := li_idx;
    finally
        store.Free;
        store := nil;
    end;
end;


procedure muestraEstatus(origen : String; Grid : TStringGrid);
var
    store : TSQLStoredProc;
    ls_char : Char;
    ls_hora : string;
    li_idx: Integer;
    lb_opcion  : Boolean;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA; //DM.Conecta;
    store.close;
    store.StoredProcName := 'PDV_STORE_STATUS_CORRIDAS';
    store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
    store.Open;
    li_idx := 1;
    with store do begin
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
            ls_char := Store.FieldByName('ESTATUS').AsString[1];
            case ls_char of
                'A' : Grid.Cells[_COL_STATUS,li_idx] := 'Abierta';
                'P' : Grid.Cells[_COL_STATUS,li_idx] := 'Predespachada';
                'C' : Grid.Cells[_COL_STATUS,li_idx] := 'Cerrada';
                'D' : Grid.Cells[_COL_STATUS,li_idx] := 'Despachada';
                'V' : Grid.Cells[_COL_STATUS,li_idx] := 'Vacio';
                    {begin
                          if li_tarjeta_viaje = 1 then begin
                              Grid.Cells[_COL_STATUS,li_idx] := 'Despachada';
                          end;
                      end;}
            end;
            llenarGridCorridas(ls_hora,store,li_idx,Grid);
            Next;
        end;// fin while
    end;//fin with
    store.free;
    store := nil;
    if li_idx = 1 then
       Inc(li_idx);
    if (gi_select_corrida = 0) and (gi_numCorrida > 0) then
        gi_select_corrida := gi_numCorrida;
    Grid.RowCount := li_idx;
    if gi_select_corrida  = 0 then
        gi_select_corrida := li_idx - 1;
    Grid.Row := gi_select_corrida;
end;

procedure MuestraCorridasLiberar(Origen : string; Grid : TStringGrid);
var
    store : TSQLStoredProc;
    li_idx: Integer;
    ls_hora,ls_muestra : string;
    ls_char : Char;
    lb_opcion  : Boolean;
    fecha_next : TDate;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_LIBERA_CORRIDAS';
        store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
        store.Open;
        li_idx := 1;
        with store do begin
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
              llenarGridCorridas(ls_hora,store,li_idx,Grid);
              Grid.Cells[_COL_TRABID,li_idx - 1] := store.FieldByName('TRAB_ID').AsString;
              Next;
            end;
            Grid.RowCount := li_idx;
        end;
    finally
        store.Free;
        store := nil;
    end;
end;

procedure cargarGridReservadoCorridaNew(ls_fecha : string; Grid : TStringGrid;
                                        var li_idx : integer);
var
    store : TSQLStoredProc;
    ls_char : Char;
    ls_hora : String;
begin
    store := TSQLStoredProc.Create(nil);
    try
        gi_numCorrida := 0;
        store.SQLConnection := DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_RESERVADOS_NEW';
        store.Params.ParamByName('IN_FECHA').AsString    := FormatDateTime('YYYY-MM-DD',StrToDate(ls_fecha));//ls_fecha;
        store.Open;
        li_idx := 1;
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
        store.close;
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

function getFechaSistema() : integer;
var
    lq_qry : TSQLQuery;
    li_out : Integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONEXION_VTA;
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add('SELECT CONCAT(YEAR(CURRENT_DATE()),lpad(MONTH(CURRENT_DATE()),2,0),lpad(DAY(CURRENT_DATE()),2,0))AS FECHA');
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
{origen, destino, fecha, lps_hora, lps_servicio : String; li_codicion : integer; Grid : TStringGrid);}
                    cargarGridReservadoCorrida(lq_query['ID_CORRIDA'],lq_query['FECHA'],
                                               lq_query['HORA'],lq_query['DESTINO'],lq_query['ORIGEN'],Grid,li_idx);
//                    ls_asientos_reservados := ls_asientos_reservados + IntToStr(lq_query['NO_ASIENTO']) + ' ';
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



procedure registraCancelado(li_boleto, li_taquilla : integer;
                            ls_terminal, ls_trab_cancela, ls_trabid :String);
var
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_ADD_CANCELADO';
        store.Params.ParamByName('IN_BOLETO').AsInteger  := li_boleto;
        store.Params.ParamByName('IN_TERMINAL').AsString := ls_terminal;
        store.Params.ParamByName('IN_TRAB_CANCELA').AsString := ls_trab_cancela;
        store.Params.ParamByName('IN_TAQUILLA').AsInteger := li_taquilla;
        store.Params.ParamByName('IN_TRABID').AsString := ls_trabid;
        store.ExecProc;
    finally
      store.Free;
      store := nil;
    end;
end;


procedure borramosAsientoCancelado(li_corrida, li_asiento : integer; fecha, hora : String;
                                        store : TSQLStoredProc);
begin
    try
      store.Close;
      store.StoredProcName := 'PDV_STORE_UPDATE_BOLETO';
      store.Params.ParamByName('IN_CORRIDA').AsInteger  := li_corrida;
      store.Params.ParamByName('IN_FECHA').AsString     := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
      store.Params.ParamByName('IN_HORA').AsString      := FormatDateTime('HH:nn:SS', StrToTime(hora));
      store.Params.ParamByName('IN_ASIENTO').AsInteger  := li_asiento;
      store.ExecProc();
      registraCancelado(store.Params.ParamByName('OUT_BOLETO').AsInteger,StrToInt(gs_maquina),
                        store.Params.ParamValues['OUT_TERMINAL'].AsString,
                        gs_trabid,store.Params.ParamValues['OUT_TRABID'].AsString);
    except
       on E : Exception do begin
           ErrorLog(E.Message,'Error en el store');
       end;
    end;
end;

{@procedure showOcupantes
@Params Terminal : String; Corrida : integer; fecha : TDate;  Grid : TStringGrid
@descripcion mostramos los ocupantesque tiene disponible la corrida}
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
      try
          tiempo := FormatDateTime('HH:nn',now());
          Store.SQLConnection := CONEXION_VTA; //DM.Conecta;
          store.close;
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
          li_ocupantes_no_hay := li_row;
          Grid.RowCount := li_row;
      finally
          Store.Free;
          Store := nil;
          qry.Free;
          qry := nil;
      end;
    except
          on E : Exception do begin
              ErrorLog(E.Message, store.StoredProcName);
          end;
    end;
end;

procedure OcupantesCorrida(Terminal : String; Corrida : String; fecha : TDate;  Grid : TStringGrid);
var
    store : TSQLStoredProc;
    li_row : integer;
begin
    store := TSQLStoredProc.Create(nil);
    try
        Store.SQLConnection := CONEXION_VTA; //DM.Conecta;
        store.close;
        Store.StoredProcName := 'PDV_STORE_SHOW_OCUPANTES';
        Store.Params.ParamByName('IN_TERMINAL').AsString := Terminal;
        Store.Params.ParamByName('IN_FECHA').AsString := FormatDateTime('YYYY-MM-DD',fecha);
        Store.Params.ParamByName('IN_CORRIDA').AsString := Corrida;
        Store.Open;
        li_row := 0;
        while not Store.EoF do begin
            Grid.Cells[_OCUPANTES_DESCRIBE,li_row] := UpperCase(Store['DESCRIPCION']);
            Grid.Cells[_OCUPANTES_TOTAL, li_row] := IntToStr(Store['TOTAL']);
            Inc(li_row);
            store.Next;
        end;
        Grid.RowCount :=li_row;
    finally
        store.Free;
        store := nil;
    end;
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


{procedure showDetalleRuta
@Params lpi_ruta : integer; Grid : TStringGrid
@Descripcion Store que muestra el detalle de la ruta esta es
despleagada en un grid}
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
            store.close;
            store.StoredProcName := 'PDV_STORE_SHOW_DETALLE_RUTA';
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


procedure clearGridVenta(grid : TStringGrid; linea : integer);
var
    li_row, li_col : Integer;
begin
    for li_col := 0 to grid.ColCount do begin

    end;
end;


{@Procedure actualizaCorrida
@Params corrida : integer; empleado : string;
                           fecha : TDate; hora : String; terminal : string
@Descripcion Actualizamos la corrida para que no sea ocupada}
procedure actualizaCorrida(corrida : integer; empleado : string;
                           fecha : TDate; hora : String; terminal : string);
var
    store : TSQLStoredProc;
begin
//    ErrorLog('Ini : Bloqueamos corrida' ,FormatDateTime('HH:MM:SS.zzz', Now()));
    try
      try
        store := TSQLStoredProc.Create(nil);
        store.SQLConnection := DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_CORRIDA_ACTUALIZADA';
        store.Params.ParamByName('CORRIDA').AsInteger  := corrida;
        store.Params.ParamByName('EMPLEADO').AsString  := empleado;
        store.Params.ParamByName('INPUT_FECHA').AsString := FormatDateTime('YYYY-MM-DD',fecha);
        store.Params.ParamByName('INPUT_HORA').AsString  := FormatDateTime('hh:nn:ss', StrToDateTime(hora));
        store.Params.ParamByName('TERMINAL').AsString  := terminal;
        store.ExecProc;
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

{@function verificaCorridaDisponible
@Params corrida : integer;
        fecha : TDate;
        hora : String;
        terminal : string
@Descripcion Verificac si la corrida se encuentra disponible de no ser asi mostrada que la esta utilizando
@ y en que taquilla esta en uso}
function verificaCorridaDisponible( corrida : string; fecha : TDate; hora : String; terminal : string): string;
var
    store : TSQLStoredProc;
    ls_out_str : string;
begin
    store := TSQLStoredProc.Create(nil);
    try
        ls_out_str := '';
        store.SQLConnection := CONEXION_VTA; //DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_VERIFICA_CORRIDA';
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        store.Params.ParamByName('INPUT_FECHA').AsString := FormatDateTime('YYYY-MM-DD',fecha);
        store.Params.ParamByName('INPUT_HORA').AsString  := FormatDateTime('hh:nn:ss', StrToDateTime(hora));
        store.Params.ParamByName('TERMINAL').AsString    := terminal;
        store.Open;
        with store do begin
          First;
          while not EoF do begin
              ls_out_str := store['TRAB_ID'] + ' '+ UpperCase(store['NOMBRE']);
              next;
          end;
        end;
    finally
      store.Free;
      store := nil;
    end;
    result := ls_out_str;
end;

{@Procedure buscaOcupantes
@Params Grid : TStringGrid
@Descripcion Busca los ocupantes permitidos ahora valida por la fecha
  actual para conocer si aplica descuentos o no }
procedure buscaOcupantes(Grid : TStringGrid);
var
    lq_query : TSQLQuery;
    li_row, li_ctrl,li_fila,li_col  : Integer;
begin
    try
        lq_query := TSQLQuery.Create(nil);
        lq_query.SQLConnection := CONEXION_VTA; //DM.Conecta;
        gds_ListaOcupantes := TDualStrings.Create();
        if EjecutaSQL(_VTA_OCUPANTES,lq_query,_LOCAL) then
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


function horaServer() : string;
var
    lq_query : TSQLQuery;
    ls_out : string;
begin
    try
      lq_query := TSQLQuery.Create(nil);
      lq_query.SQLConnection := DM.Conecta;
      if EjecutaSQL('SELECT (DATE_FORMAT(CURRENT_TIMESTAMP(),''%T''))AS HORASERVER; ',lq_query,_LOCAL) then
          ls_out := lq_query['HORASERVER'];
    finally
        lq_query.Free;
        lq_query := nil;
    end;
    Result := ls_out;
end;





procedure guardaVendidos(li_corrida : Integer; ls_fecha : string; li_asiento : Integer;
                         ls_trabid, ls_origen, ls_destino : string);
var
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_ASIENTO_VENDIDO';
        store.Params.ParamByName('IN_CORRIDA').AsInteger := li_corrida;
        store.Params.ParamByName('IN_FECHA').AsString  := FormatDateTime('YYYY-MM-DD HH:nn:SS',StrToDateTime(ls_fecha));
        store.Params.ParamByName('ASIENTO').AsInteger  := li_asiento;
        store.Params.ParamByName('IN_TRABID').AsString := ls_trabid;
        store.Params.ParamByName('IN_ORIGEN').AsString := ls_origen;
        store.Params.ParamByName('IN_DESTINO').AsString := ls_destino;
        store.ExecProc;
    finally
      store.Free;
      store := nil;
    end;
end;


procedure AutobusesDuales();
var
    lq_query : TSQLQuery;
begin
    lq_query := TSQLQuery.Create(nil);
    try
        gds_buses := TDualStrings.Create;
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(_VTA_AUTOBUSES_GET,lq_query,_LOCAL) then
        lq_query.First;
        while not lq_query.Eof do begin
            gds_buses.Add(lq_query['ID_TIPO_AUTOBUS'],lq_query['ASIENTOS']);
            lq_query.Next;
        end;
    finally
      lq_query.Free;
      lq_query := nil;
    end;
end;

{@Procedure AsientoOcupado
@Params store : TSQLStoredProc; li_continuo : integer

@Descripcion valida los asientos si estan ocupados regresa true o false}
function AsientoOcupado(store : TSQLStoredProc; li_continuo : integer) : Boolean;
var
    lb_ok : Boolean;
begin
    lb_ok := false;
    store.First;
    while not store.Eof do begin
        if li_continuo = store['NO_ASIENTO'] then begin
            lb_ok := true;
            Break;
        end;
        store.Next;
    end;
    Result := lb_ok;
end;

function folioBoleto(trabid, terminal : String) : integer;
var
    lq_query : TSQLQuery;
    li_boleto : Integer;
begin
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := CONEXION_VTA; //DM.Conecta;
        if EjecutaSQL(format(_VTA_BOLETO_EMPLEADO,[trabid]),lq_query,_LOCAL) then
            li_boleto := lq_query['INDICE'];
    finally
      lq_query.Free;
      lq_query := nil;
    end;
    Result := li_boleto;
end;

procedure estatus_boleto(boletos : PDV_Boleto; lc_opcion : char; fecha_original, ls_hora :String );
var
    store_asiento : TSQLStoredProc;
    ls_fecha : string;
begin
    store_asiento := TSQLStoredProc.Create(nil);
    try
        try
            store_asiento.SQLConnection := CONEXION_VTA; //DM.Conecta;
            store_asiento.close;
            store_asiento.StoredProcName := 'PDV_STORE_ASIENTO_NEW_DELETE';
            store_asiento.Params.ParamByName('IN_CORRIDA').AsString := boletos.id_corrida;
            store_asiento.Params.ParamByName('IN_FECHA').AsString  := fecha_original + ' ' + ls_hora;
            store_asiento.Params.ParamByName('IN_ASIENTO').AsInteger := StrToInt(boletos.no_asiento);
            store_asiento.Params.ParamByName('IN_TRABID').AsString   := boletos.trab_id;
            store_asiento.Params.ParamByName('IN_ORIGEN').AsString   := boletos.origen;
            store_asiento.Params.ParamByName('IN_DESTINO').AsString   := boletos.destino;
            store_asiento.Params.ParamByName('IN_STATUS').AsString   := boletos.status;
            store_asiento.Params.ParamByName('IN_NUEVO').AsString    := lc_opcion;
            store_asiento.ExecProc();
        except
            li_existe_reservacion := 1;
        end;
    finally
      store_asiento.Free;
      store_asiento := nil;
    end;
end;


procedure estatus_ASIENTO(asientos : PDV_Asientos; lc_opcion : Char);
var
    store_asiento : TSQLStoredProc;
    ls_fecha : string;
begin
    store_asiento := TSQLStoredProc.Create(nil);
    try
        try
            store_asiento.SQLConnection := CONEXION_VTA; //DM.Conecta;
            store_asiento.close;
            store_asiento.StoredProcName := 'PDV_STORE_ASIENTO_NEW_DELETE';
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
            store_asiento.Params.ParamByName('IN_DESTINO').AsString   := asientos.destino;
            store_asiento.Params.ParamByName('IN_STATUS').AsString   := asientos.status;
            store_asiento.Params.ParamByName('IN_NUEVO').AsString    := lc_opcion;
            store_asiento.ExecProc();
        except
            li_existe_reservacion := 1;
        end;
    finally
      store_asiento.Free;
      store_asiento := nil;
    end;

end;


function  verificaDisponibles(ls_asiento, fecha, corrida : String): Boolean;
var
    store : TSQLStoredProc;
    lb_ok : Boolean;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;  //DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_ASIENTOS_DISPONIBLES_CUALES';
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        if li_opcion_fecha_string <> 0 then
            store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD HH:nn:SS',StrToDateTime(fecha))//fecha;
        else
            store.Params.ParamByName('FECHA_INPUT').AsString :=  fecha;
        store.Params.ParamByName('ASIENTO').AsString     := ls_asiento;
        store.Open;
        lb_ok := False;
        with store do begin
          First;
          while not EoF do begin
              lb_ok := True;
              next;
          end;
        end;
    finally
       store.Free;
       store := nil;
    end;
    Result := lb_ok;
end;

{@Procedure procesoVentaCuantos
@Paramas li_asientos,li_corrida,li_elegidos_asientos : integer;
@                       fecha, Origen, Destino, user, servicio : string; costo : real;
@                       var array_Seat : array_asientos; taquilla : Integer;
@                       ruta : integer
@Descripcion se lee la informacion de los asientos que se estan vendiendo estos
@ se almacenan en un arreglo y se apartan en la tabla pdv_t_asiento como en proceso de venta}
procedure procesoVentaCuantos(li_asientos : integer; ls_corrida : String; li_elegidos_asientos : integer;
                       fecha, Origen, Destino, user, servicio : string; costo : real;
                       var array_Seat : array_asientos; taquilla : Integer;
                       ruta : integer; var li_insertados : integer);
var
    store : TSQLStoredProc;
    li_asiento_continuo : Integer;
    li_asiento_insertado : Integer;
begin///buscamos en la base referente a la corrida y fecha
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.close;
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
                      array_Seat[li_ctrl_asiento].Ocupante := 'Pie';//descripcion del ocupante
                      array_Seat[li_ctrl_asiento].asiento    := li_asiento_continuo + 100;
                  end else begin
                      array_Seat[li_ctrl_asiento].Ocupante := 'Adulto';//descripcion del ocupante
                      array_Seat[li_ctrl_asiento].asiento    := li_asiento_continuo;
                  end;
                  array_Seat[li_ctrl_asiento].corrida    := ls_corrida;
                  array_Seat[li_ctrl_asiento].fecha_hora := fecha;
                  array_Seat[li_ctrl_asiento].empleado   := user;
                  array_Seat[li_ctrl_asiento].origen     := Origen;
                  array_Seat[li_ctrl_asiento].destino    := Destino;
                  array_Seat[li_ctrl_asiento].status     := 'V';
                  array_Seat[li_ctrl_asiento].precio     := StrToFloat(Format('%0.2f',[costo]));
                  array_Seat[li_ctrl_asiento].precio_original     := StrToFloat(Format('%0.2f',[costo]));
                  array_Seat[li_ctrl_asiento].servicio   := servicio;
                  array_Seat[li_ctrl_asiento].forma_pago := 1; // para que se  efectivo
                  array_Seat[li_ctrl_asiento].taquilla   := taquilla;//numero de la taquilla
                  array_Seat[li_ctrl_asiento].descuento  := 0;
                  array_Seat[li_ctrl_asiento].tipo_tarifa := 'A';//tipo ocupante
                  array_Seat[li_ctrl_asiento].idOcupante  := 1;//siempre adulto
                  array_Seat[li_ctrl_asiento].nombre      := '';
                  array_Seat[li_ctrl_asiento].abrePago    := 'EFE';
                  array_Seat[li_ctrl_asiento].ruta       := ruta;
                  array_Seat[li_ctrl_asiento].pago_efectivo := 1;
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


procedure procesoVentaAnticipada(li_asientos_ingresados : integer;
                                 fecha, Origen, Destino,user,servicio : String; costo : real;
                                 taquilla, ruta : integer; var array_Seat : array_asientos; pasajero : String);
var
    li_ctrl : integer;
begin
    for li_ctrl := 1 to li_asientos_ingresados do begin
        array_Seat[li_ctrl_asiento].corrida    := '';
        array_Seat[li_ctrl_asiento].fecha_hora := fecha;
        array_Seat[li_ctrl_asiento].empleado   := user;
        array_Seat[li_ctrl_asiento].origen     := Origen;
        array_Seat[li_ctrl_asiento].destino    := Destino;
        array_Seat[li_ctrl_asiento].status     := 'V';
        array_Seat[li_ctrl_asiento].precio     := StrToFloat(Format('%0.2f',[costo]));
        array_Seat[li_ctrl_asiento].precio_original     := StrToFloat(Format('%0.2f',[costo]));
        array_Seat[li_ctrl_asiento].servicio   := servicio;
        array_Seat[li_ctrl_asiento].forma_pago := 1; // para que se  efectivo
        array_Seat[li_ctrl_asiento].taquilla   := taquilla;//numero de la taquilla
        array_Seat[li_ctrl_asiento].descuento  := 0;
        array_Seat[li_ctrl_asiento].tipo_tarifa := 'A';//tipo ocupante
        array_Seat[li_ctrl_asiento].idOcupante  := 1;//siempre adulto
        array_Seat[li_ctrl_asiento].nombre      := pasajero;
        array_Seat[li_ctrl_asiento].abrePago    := 'EFE';
        array_Seat[li_ctrl_asiento].ruta       := ruta;
        array_Seat[li_ctrl_asiento].pago_efectivo := 1;
        array_Seat[li_ctrl_asiento].Ocupante := 'Adulto';
        Inc(li_ctrl_asiento);
    end;

end;


procedure actualizaBoletoAnticipado(array_Seat : array_boletos; ls_fecha_original : string; li_maximo : integer);
var
    lq_query : TSQLQuery;
    li_ctrl  : integer;
begin
    lq_query := TSQLQuery.Create(nil);
//_ACTUALIZA_BOLETO_ANTICIPADO
    try
       lq_query.SQLConnection := CONEXION_VTA;
       for li_ctrl := 1 to li_maximo do begin
      if EjecutaSQL(format(_ACTUALIZA_BOLETO_ANTICIPADO,[
                            array_seat[li_ctrl].id_corrida,
                            array_seat[li_ctrl].no_asiento,
                            array_seat[li_ctrl].id_boleto,
                            array_seat[li_ctrl].origen,
                            array_seat[li_ctrl].destino,
                            array_seat[li_ctrl].fecha_boleto
                          ]),lq_query,_LOCAL) then

      if EjecutaSQL(format(_ACTUALIZA_BOLETO_ANTICIPADO,[
                            array_seat[li_ctrl].id_corrida,
                            array_seat[li_ctrl].no_asiento,
                            array_seat[li_ctrl].id_boleto,
                            array_seat[li_ctrl].origen,
                            array_seat[li_ctrl].destino,
                            array_seat[li_ctrl].fecha_boleto
                          ]),lq_query,_SERVIDOR_CENTRAL) then

       end;//fin for
    finally
       lq_query.free;
        lq_query := nil;
    end;
end;

procedure procesoCuales(CualesAsientos : la_asientos; li_maximo : integer; ls_corrida: string;
                             var array_Seat : array_boletos;
                             ls_origen, ls_destino,ls_nombre,ls_fecha, ls_trabid,ls_fecha_corrida,ls_hora : string);
var
    li_ctrl : integer;
    lq_qry  : TSQLQuery;
begin
    try
      lq_qry := TSQLQuery.Create(nil);
      lq_qry.SQLConnection := CONEXION_VTA;
      li_ctrl := 1;
      if EjecutaSQL(format(_VENTA_BOLETOS_ANTICIPADOS,[ls_origen,ls_destino,
                            ls_fecha,ls_trabid]),lq_qry,_LOCAL) then begin
        with lq_qry do begin
           First;
           while not Eof do begin
               array_seat[li_ctrl].id_boleto := lq_qry['ID_BOLETO'];
               array_Seat[li_ctrl].terminal  := lq_qry['ID_TERMINAL'];
               array_Seat[li_ctrl].trab_id   := lq_qry['TRAB_ID'];
               array_Seat[li_ctrl].status    := lq_qry['ESTATUS'];
               array_Seat[li_ctrl].origen    := lq_qry['ORIGEN'];
               array_Seat[li_ctrl].destino   := lq_qry['DESTINO'];
               array_Seat[li_ctrl].tarifa    := lq_qry['TARIFA'];
               array_Seat[li_ctrl].id_forma_pago := lq_qry['ID_FORMA_PAGO'];
               array_Seat[li_ctrl].taquilla  := lq_qry['ID_TAQUILLA'];
               array_Seat[li_ctrl].tipo_tarifa := lq_qry['TIPO_TARIFA'];
               array_Seat[li_ctrl].fecha_boleto := FormatDateTime('YYYY-MM-DD HH:mm:ss',lq_qry['FECHA_HORA_BOLETO']);
               array_Seat[li_ctrl].id_corrida := ls_corrida;
               array_Seat[li_ctrl].fecha     := ls_fecha_corrida;
               array_Seat[li_ctrl].nombre_pasajero := ls_nombre;
               array_Seat[li_ctrl].id_ocupante := lq_qry['ID_OCUPANTE'];
               Inc(li_ctrl);
               Next;
           end;//fin while
        end;//fin with
        for li_ctrl := 0 to li_maximo  - 1 do begin
             array_Seat[li_ctrl + 1].no_asiento :=  IntToStr(CualesAsientos[li_ctrl]);
             estatus_boleto(array_Seat[li_ctrl + 1],'N',ls_fecha_corrida,ls_hora);
        end;//fin for
      end;
    finally
       lq_qry.free;
       lq_qry := nil;
    end;
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



procedure procesoVentaCuales(CualesAsientos : la_asientos; li_maximo : integer; ls_corrida,
                             fecha, Origen, Destino, user, servicio : string; costo : real;
                             var array_Seat : array_asientos; taquilla : Integer; iva : real);
var
    li_ctrl : Integer;
    store   :  TSQLStoredProc;
begin
    li_ctrl_asiento := gi_arreglo;
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA;
    for li_ctrl := 0 to li_maximo - 1 do begin
        array_Seat[li_ctrl_asiento].corrida    := ls_corrida;
        array_Seat[li_ctrl_asiento].fecha_hora := fecha;
        array_Seat[li_ctrl_asiento].asiento    := CualesAsientos[li_ctrl];    //li_asiento_continuo;
        array_Seat[li_ctrl_asiento].empleado   := user;
        array_Seat[li_ctrl_asiento].origen     := Origen;
        array_Seat[li_ctrl_asiento].destino    := Destino;
        array_Seat[li_ctrl_asiento].status     := 'V';
        array_Seat[li_ctrl_asiento].precio     := StrToFloat(Format('%0.2f',[costo]));
        array_Seat[li_ctrl_asiento].precio_original   := StrToFloat(Format('%0.2f',[costo]));
        array_Seat[li_ctrl_asiento].servicio   := servicio;
        array_Seat[li_ctrl_asiento].forma_pago := 1; // para que se  efectivo
        array_Seat[li_ctrl_asiento].taquilla   := taquilla;//numero de la taquilla
        array_Seat[li_ctrl_asiento].descuento  := 0;
        array_Seat[li_ctrl_asiento].Ocupante := 'Adulto';//descripcion del ocupante
        array_Seat[li_ctrl_asiento].tipo_tarifa := 'A';//tipo ocupante
        array_Seat[li_ctrl_asiento].idOcupante  := 1;//siempre adulto pago_efectivo
        array_Seat[li_ctrl_asiento].pago_efectivo := 1;
        array_Seat[li_ctrl_asiento].abrePago    := 'EFE';
        array_Seat[li_ctrl_asiento].ruta := gi_ruta;
        array_Seat[li_ctrl_asiento].calculado := 0;
        array_Seat[li_ctrl_asiento].iva       := RegresaIVA(FloatToStr(iva));
        if li_opcion_fecha_string = 0 then begin//lo buscamos
            if  verificaDisponibles(IntToStr(CualesAsientos[li_ctrl]),fecha,ls_corrida) then begin //               estatus_ASIENTO(array_Seat[li_ctrl_asiento],'N');
                  array_Seat[li_ctrl_asiento].corrida    := ls_corrida;
                  array_Seat[li_ctrl_asiento].fecha_hora := fecha;
                  array_Seat[li_ctrl_asiento].asiento    := CualesAsientos[li_ctrl];    //li_asiento_continuo;
                  array_Seat[li_ctrl_asiento].empleado   := user;
                  array_Seat[li_ctrl_asiento].origen     := Origen;
                  array_Seat[li_ctrl_asiento].destino    := Destino;
                  array_Seat[li_ctrl_asiento].status     := 'V';
                  array_Seat[li_ctrl_asiento].precio     := StrToFloat(Format('%0.2f',[costo]));
                  array_Seat[li_ctrl_asiento].precio_original   := StrToFloat(Format('%0.2f',[costo]));
                  array_Seat[li_ctrl_asiento].servicio   := servicio;
                  array_Seat[li_ctrl_asiento].forma_pago := 1; // para que se  efectivo
                  array_Seat[li_ctrl_asiento].taquilla   := taquilla;//numero de la taquilla
                  array_Seat[li_ctrl_asiento].descuento  := 0;
                  array_Seat[li_ctrl_asiento].Ocupante := 'Adulto';//descripcion del ocupante
                  array_Seat[li_ctrl_asiento].tipo_tarifa := 'A';//tipo ocupante
                  array_Seat[li_ctrl_asiento].idOcupante  := 1;//siempre adulto
                  array_Seat[li_ctrl_asiento].pago_efectivo := 1;
                  array_Seat[li_ctrl_asiento].abrePago    := 'EFE';
                  array_Seat[li_ctrl_asiento].ruta := gi_ruta;
                  array_Seat[li_ctrl_asiento].calculado := 0;
                  array_Seat[li_ctrl_asiento].iva       := RegresaIVA(FloatToStr(iva));
            end else
                    estatus_ASIENTO(array_Seat[li_ctrl_asiento],'N');
        end else
                estatus_ASIENTO(array_Seat[li_ctrl_asiento],'N');
        inc(li_ctrl_asiento);
    end;
//    li_ctrl_asiento := li_ctrl_asiento - 1;
end;


procedure actualizaStatusAsiento(array_Seat : array_asientos; li_maximo : integer; nombre : String);
var
    li_ctrl :  integer;
    lq_query : TSQLQuery;
    ls_corrida,ls_fecha   : string;
begin
    lq_query := TSQLQuery.Create(nil);
    try
      lq_query.SQLConnection := CONEXION_VTA;
      for li_ctrl := 1 to li_maximo  do begin
          if EjecutaSQL(Format(_STATUS_ASIENTO_VENDIDO,[array_seat[li_ctrl].corrida,
                array_seat[li_ctrl].fecha_hora,array_seat[li_ctrl].asiento]),
            lq_query,_RUTA) then begin
                ls_corrida := array_seat[li_ctrl].corrida;
                ls_fecha   := array_seat[li_ctrl].fecha_hora;
          end;
      end;
      //borramos
      if EjecutaSQL(Format(_BORRA_RESERVADOS_ASIENTO,[ls_corrida,ls_fecha, nombre]),lq_query,_LOCAL) then
      begin
          Mensaje('Se ha liberado la reservacion',0);
      end;
    finally
      lq_query.free;
      lq_query := nil;
    end;
end;



procedure registraReservados(reservado : PDV_Reservaciones);
var
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.close;
        store.StoredProcName := 'PDV_STORE_RESERVA_ASIENTO';
        store.Params.ParamByName('IN_CORRIDA').AsString := reservado.corrida;
        store.Params.ParamByName('IN_FECHA').AsString  := reservado.fecha;
        store.Params.ParamByName('IN_ASIENTO').AsInteger := reservado.asiento;
        store.Params.ParamByName('IN_TERMINAL').AsString := reservado.terminal;
        store.Params.ParamByName('TRABID').AsString       := reservado.Trab_id;
        store.Params.ParamByName('IN_ORIGEN').AsString   := reservado.origen;
        store.Params.ParamByName('IN_DESTINO').AsString  := reservado.Destino;
        store.ExecProc;
//registramos los boletos reservados para la ruta
    finally
      store.Free;
      store := nil;
    end;

end;

procedure asignaReservados(li_corrida : String; origen, destino, terminal_reservacion : string;
                               la_asientos : la_asientos; fecha: String; li_asientos : integer;
                               var arreglo : array_reservaciones; idTrab : String; ruta, servicio : integer);
var
    li_ctrl_reserva : integer;

begin
//creamos una estructura propia para guardar los datos en la tabla de asiento
    for li_ctrl_reserva := 0 to li_asientos - 1 do begin
        arreglo[li_ctrl_reserva + 1].corrida := li_corrida;
        arreglo[li_ctrl_reserva + 1].fecha   := FormatDateTime('YYYY-MM-DD',StrToDateTime(fecha)) +
                                                ' ' + gs_hora_apartada;
        arreglo[li_ctrl_reserva + 1].asiento := la_asientos[li_ctrl_reserva];
        arreglo[li_ctrl_reserva + 1].pasajero := '';
        arreglo[li_ctrl_reserva + 1].terminal := terminal_reservacion;
        arreglo[li_ctrl_reserva + 1].Trab_id  := idTrab;
        arreglo[li_ctrl_reserva + 1].origen   := origen;
        arreglo[li_ctrl_reserva + 1].Destino  := destino;
        arreglo[li_ctrl_reserva + 1].Status   := 'R';
        arreglo[li_ctrl_reserva + 1].ruta     := ruta;
        arreglo[li_ctrl_reserva + 1].servicio := servicio;
        registraReservados(arreglo[li_ctrl_reserva + 1]);
    end;
end;


procedure liberaReservacion(reservado : array_reservaciones; Pasajero : String; li_asientos : integer;
                            terminal : string);
var
    store : TSQLStoredProc;
    li_ctrl_reservados : integer;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        for li_ctrl_reservados := 1 to li_asientos do begin
          store.close;
          store.StoredProcName := 'PDV_STORE_AUTOLIBERABLE';
          store.Params.ParamByName('PASAJERO').AsString    := UpperCase(Pasajero);
          store.Params.ParamByName('IN_CORRIDA').AsString := reservado[li_ctrl_reservados].corrida;
          store.Params.ParamByName('FECHA').AsString       := reservado[li_ctrl_reservados].fecha;
          store.Params.ParamByName('IN_ASIENTO').AsInteger := reservado[li_ctrl_reservados].asiento;
          store.Params.ParamByName('IN_TERMINAL').AsString := terminal;
          store.ExecProc;
        end;
    finally
      store.Free;
      store := nil;
    end;
end;


procedure NoliberaReservacion(reservado : array_reservaciones; Pasajero : String; li_asientos : integer;
                             terminal : string);
var
    store : TSQLStoredProc;
    li_ctrl_reservados : integer;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        for li_ctrl_reservados := 1 to li_asientos do begin
          store.close;
          store.StoredProcName := 'PDV_STORE_NO_AUTOLIBERABLE';
          store.Params.ParamByName('PASAJERO').AsString    := UpperCase(Pasajero);
          store.Params.ParamByName('IN_CORRIDA').AsString := reservado[li_ctrl_reservados].corrida;
          store.Params.ParamByName('FECHA').AsString       := reservado[li_ctrl_reservados].fecha;
          store.Params.ParamByName('IN_ASIENTO').AsInteger := reservado[li_ctrl_reservados].asiento;
          store.Params.ParamByName('IN_TERMINAL').AsString := terminal;
          store.ExecProc;
        end;
    finally
      store.Free;
      store := nil;
    end;
end;

procedure recalculaPrecioConDescuento(var arreglo : array_asientos);
var
    li_descuento, li_ctrl, li_cantidad, li_ctrl_interno :  Integer;
    li_idOcupante : integer;
    ls_id, ls_valor, ls_descripcion : string;
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := DM.Conecta;
    for li_ctrl := 0 to gds_ocupantes_asignados.Count - 1 do begin
         ls_id := gds_ocupantes_asignados.ID[li_ctrl];//letra
         li_cantidad := StrToInt(gds_ocupantes_asignados.ValueOf(ls_id));
         store.close;
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
               arreglo[gi_arreglo].precio_original := arreglo[gi_arreglo].precio;
               arreglo[gi_arreglo].Ocupante    := ls_descripcion;
               arreglo[gi_arreglo].idOcupante  := li_idOcupante;
               arreglo[gi_arreglo].descuento   := li_descuento;
               arreglo[gi_arreglo].tipo_tarifa := ls_id;
               arreglo[gi_arreglo].abrePago    := 'EFE';
               arreglo[gi_arreglo].calculado   := 1;
               inc(gi_arreglo);
            end;
         end;
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




procedure limpiarArregloAsientos(arreglo : array_asientos);
begin
    for li_ctrl_asiento := 0 to high(arreglo) do begin
       arreglo[li_ctrl_asiento].corrida := '';
       arreglo[li_ctrl_asiento].fecha_hora := '';
       arreglo[li_ctrl_asiento].asiento := 0;
       arreglo[li_ctrl_asiento].empleado := '';
       arreglo[li_ctrl_asiento].origen   := '';
       arreglo[li_ctrl_asiento].destino  := '';
       arreglo[li_ctrl_asiento].status   := ' ';
       arreglo[li_ctrl_asiento].precio   := 0.0;
       arreglo[li_ctrl_asiento].servicio := '';
    end;
end;


procedure RegistrarBoleto(asientos : PDV_Asientos; boleto : integer; fechaCorrida, folio_factura : String);
var
    store : TSQLStoredProc;
    ls_fecha, ls_server_fecha, ls_qry : String;
    lq_query, lq_tarjeta : TSQLQuery;
    hilo_libera : Libera_Asientos;
    sentencia,fecha_00, ls_fecha_hora_boleto : string;
    ls_iva_replica, ls_iva_por_boleto : String;
begin
   ls_fecha_hora_boleto := Ahora();
   store := TSQLStoredProc.Create(nil);
   lq_query := TSQLQuery.Create(nil);
    try
        if fechaCorrida[5] = '/' then
           ls_fecha := Copy(fechaCorrida,1,4)+'-'+Copy(fechaCorrida,6,2)+'-'+Copy(fechaCorrida,9,2)
        else ls_fecha := fechaCorrida;
        lq_query.SQLConnection := CONEXION_VTA;
        insertaBoleto(CONEXION_VTA, gs_terminal, asientos.empleado, 'V',
                      asientos.origen, asientos.destino, FloatToStr(asientos.precio),
                      asientos.forma_pago, asientos.taquilla, asientos.tipo_tarifa,
                      asientos.corrida, ls_fecha, UpperCase(gs_nombre_pax), asientos.asiento,
                      asientos.idOcupante, ls_fecha_hora_boleto, asientos.ruta, asientos.servicio,
                      asientos.id_pago_pinpad_banamex, folio_factura, asientos.iva, asientos.tipo_tarjeta);
        ls_fecha_hora_boleto := ahora();
        try
            if asientos.iva <> 0 then
                ls_iva_por_boleto := FloatToStr((asientos.iva - 1) * 100)
            else
               ls_iva_por_boleto := '0';
        except
            ls_iva_por_boleto := '0';
        end;

        try
          if asientos.iva <> 0 then
              ls_iva_replica := FormatFloat('###00.00',asientos.precio - (asientos.precio / asientos.iva))
          else
              ls_iva_replica := '0';
        except
          ls_iva_replica := '0';
        end;


        if li_vta_anticipada_pago = 0 then
            try //si la fecha es formato de mysql
              if ls_fecha[5] = '-' then
                  ls_server_fecha := copy(ls_fecha,1,10)
              else
                  ls_server_fecha := formatDateTime('YYYY-MM-DD', StrToDate(ls_fecha));

              ls_qry := format(_SERVER_BOLETO_QUERY,[
                        intToStr(boleto),asientos.origen,asientos.empleado,'V',asientos.origen,
                        asientos.destino, FloatToStr(asientos.precio),intToStr(asientos.forma_pago),
                        intToStr(asientos.taquilla),asientos.tipo_tarifa,
                        ls_fecha_hora_boleto,
                        asientos.corrida,
                        ls_server_fecha,'-',IntToStr(asientos.asiento),IntToStr(asientos.idOcupante),
                        IntToStr(asientos.ruta), asientos.servicio,asientos.id_pago_pinpad_banamex, folio_factura,
                        ls_iva_por_boleto,  ls_iva_replica, asientos.tipo_tarjeta])
            except
              ls_qry := format(_SERVER_BOLETO_QUERY,[
                        intToStr(boleto),asientos.origen,asientos.empleado,'V',asientos.origen,
                        asientos.destino, FloatToStr(asientos.precio),intToStr(asientos.forma_pago),
                        intToStr(asientos.taquilla),asientos.tipo_tarifa,
                        ls_fecha_hora_boleto,
                        asientos.corrida,
                        ls_fecha,'-',IntToStr(asientos.asiento),IntToStr(asientos.idOcupante),
                        IntToStr(asientos.ruta), asientos.servicio, asientos.id_pago_pinpad_banamex, folio_factura,
                        ls_iva_por_boleto,  ls_iva_replica, asientos.tipo_tarjeta])
            end
        else
            ls_qry := format(_SERVER_BOLETO_QUERY,[
                      intToStr(boleto),asientos.origen,asientos.empleado,'V',asientos.origen,
                      asientos.destino, FloatToStr(asientos.precio),intToStr(asientos.forma_pago),
                      intToStr(asientos.taquilla),asientos.tipo_tarifa,
                        ls_fecha_hora_boleto,
                      asientos.corrida,
                      ls_fecha,'-',IntToStr(asientos.asiento),IntToStr(asientos.idOcupante),
                      IntToStr(asientos.ruta), asientos.servicio, asientos.id_pago_pinpad_banamex, folio_factura,
                      ls_iva_por_boleto,  ls_iva_replica, asientos.tipo_tarjeta ]);

        if EjecutaSQL(ls_qry,lq_query,_SERVIDOR_CENTRAL) then//manda a el servidor central
              ;
//liberamos el boleto para la ruta
             if asientos.fecha_hora[5] = '-' then
                  ls_server_fecha := copy(asientos.fecha_hora,1,10);
             if asientos.fecha_hora[3] = '/'  then
                  ls_server_fecha := copy(asientos.fecha_hora,7,4)+'-'+
                                     copy(asientos.fecha_hora,4,2)+'-'+
                                     copy(asientos.fecha_hora,1,2);
//''%s'',''%s'',%s,''%s'',''%s'',''%s'',''%s'',''%s'',''%s'',''%s'')';
            if li_actualiza_ruta = 0 then
                sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR,[asientos.corrida,
                                    ls_server_fecha + ' 00:00',
                                    intToStr(asientos.asiento),asientos.nombre,gs_terminal,
                                    asientos.empleado, asientos.origen, asientos.destino,'V'])
            else begin
                if asientos.fecha_hora[5] = '-' then
                      ls_server_fecha := copy(asientos.fecha_hora,1,10);
                if asientos.fecha_hora[3] = '/'  then
                      ls_server_fecha := copy(asientos.fecha_hora,7,4)+'-'+
                                         copy(asientos.fecha_hora,4,2)+'-'+
                                         copy(asientos.fecha_hora,1,2);
                fecha_00 := ls_server_fecha + ' 00:00';
                 sentencia := 'DELETE FROM PDV_T_ASIENTO '+
                              'WHERE ID_CORRIDA = '''+asientos.corrida+'''' +
                              ' AND FECHA_HORA_CORRIDA = '''+fecha_00+''''+
                              ' AND NO_ASIENTO = '+ IntToStr(asientos.asiento);
                 hilo_libera := Libera_Asientos.Create(true);
                 hilo_libera.server := CONEXION_VTA;
                 hilo_libera.sentenciaSQL := sentencia;
                 hilo_libera.ruta   := asientos.ruta;
                 hilo_libera.origen := asientos.origen;
                 hilo_libera.destino := asientos.destino;;
                 hilo_libera.Priority := tpNormal;
                 hilo_libera.FreeOnTerminate := True;
                 hilo_libera.start;
                 sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR,[asientos.corrida,
                                     ls_server_fecha + ' 00:00',
                                     intToStr(asientos.asiento),asientos.nombre,gs_terminal,
                                     asientos.empleado, asientos.origen, asientos.destino,'V'])
            end;
            hilo_libera := Libera_Asientos.Create(true);
            hilo_libera.server := CONEXION_VTA;
            hilo_libera.sentenciaSQL := sentencia;
            hilo_libera.ruta   := asientos.ruta;
            hilo_libera.origen := asientos.origen;
            hilo_libera.destino := asientos.destino;;
            hilo_libera.Priority := tpNormal;
            hilo_libera.FreeOnTerminate := True;
            hilo_libera.start;

    finally
      store.Free;
      store := nil;
    end;
end;


{@procedure apartaCorrida
@Params corrida : integer; fecha : TDate; hora : String;
@                        terminal : String; trabid : string; ruta : integer
@Descripcion registramos la corrida como apartada si el local                        }
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
    if terminal = gs_terminal then begin///@para un acceso remoto
         STORE.SQLConnection := CONEXION_VTA;
         STORE.close;
         STORE.StoredProcName := 'PDV_STORE_LIBERA_CORRIDA_UNICA';
         STORE.Params.ParamByName('IN_TRABID').AsString := trabid;
         STORE.Params.ParamByName('IN_CORRIDA').AsString := corrida;
         STORE.Params.ParamByName('IN_FECHA').AsString   := FormatDateTime('YYYY-MM-DD',fecha);
         STORE.ExecProc;
    end;
    finally
      STORE.free;
      STORE := nil;
    end;
end;

function storeApartacorrida(corrida : String; fecha : TDate; terminal : String; trabid : string) : string;
var
    store : TSQLStoredProc;
    ls_out : string;
begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA;
    try
        store.close;
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


procedure ImprimeCargaInicial(trabid : String);
var
    ls_nombre, ls_boletos, ls_fecha_ini, ls_hora : string;
    lq_qry    : TSQLQuery;
begin
    if Length(trabid) > 0 then ls_nombre := nombreCompletoTrabid(trabid)
    else ls_nombre := ' ';

{    ls_boletos := 'SELECT (COUNT(*))AS BOLETOS, ' +
                  '(SELECT ID_CORTE FROM PDV_T_CORTE WHERE ESTATUS IN (''A'',''S'') ' +
                  'AND ID_EMPLEADO =  ''%s'' ) AS ID_CORTE, ' +
                  ' (SELECT FECHA_INICIO FROM PDV_T_CORTE WHERE ESTATUS IN (''A'',''S'') '+
                  ' AND ID_EMPLEADO =  ''%s'' ) AS INICIO '+
                  'FROM PDV_T_BOLETO WHERE FECHA_HORA_BOLETO > ( '+
                  'SELECT FECHA_INICIO FROM PDV_T_CORTE '+
                  'WHERE ESTATUS IN (''A'',''S'') '+
                  'AND ID_EMPLEADO = ''%s'' ) AND TRAB_ID = ''%s'' ';}

    ls_boletos := 'SELECT C.ID_CORTE, C.FECHA_INICIO AS INICIO, '+
                  '(SELECT COUNT(*) FROM PDV_T_BOLETO '+
                  'WHERE TRAB_ID = ''%s'' AND FECHA_HORA_BOLETO > C.FECHA_INICIO) AS BOLETOS '+
                  'FROM PDV_T_CORTE AS C WHERE C.ESTATUS IN (''A'',''S'')  AND C.ID_EMPLEADO =  ''%s'' ';


    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(ls_boletos,[trabid, trabid]),lq_qry, _LOCAL) then begin
        if not VarIsNull(lq_qry.FieldByName('ID_CORTE').AsVariant) then begin
            if lq_qry['BOLETOS'] > 0 then
              ls_boletos := 'Con bol. vend' + '. Corte : ' + IntToStr(lq_qry['ID_CORTE'])+'.'
            else
              ls_boletos := 'CERO bol. vend' + '. Corte : ' + IntToStr(lq_qry['ID_CORTE'])+'.';

            ls_fecha_ini :=   'Fec. Ini.: ' + FormatDateTime('YYYY-MM-DD HH:nn', lq_qry['INICIO']);

        end else
            ls_boletos  := '-=DESASIGNADO=-';
    end;
    ls_hora := Ahora();
    imprimirBoletoDatamax('','','','',ls_boletos,ls_fecha_ini,
                          Copy(Ahora(),1,10),'','CARGA INICIAL',
                          ls_nombre,'','',Copy(Ahora(),12,5),
                          TRABID,'','','','','',gs_puerto);
end;

procedure ImprimeCargaArqueo(Terminal, Taquilla, trabid, autoriza, importe, promotor_name : String); var
     ls_ithaca, ls_toshiba, ls_OPOS : string;
     lf_importe : Double;
begin
     ls_toshiba := '';
     ls_ithaca := '';
     lf_importe := StrToFloat(importe);
     if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
            if gi_boleto_tamano = 0 then
                 imprimirBoletoDatamax('','','', Terminal, 'Taquilla: '+Taquilla,
                                       '',Copy(Ahora(),1,10),'','Boleto de no abordo','Caj:'+autoriza,
                                       'Recoleccion Parcial',importe,Copy(Ahora(),12,8),'Promotor: '+trabid,'Promotor : '+promotor_name,
                                       'Caj:'+autoriza,'Recoleccion Parcial:'+importe,'Fecha y Hora :'+Ahora(),'Promotor: '+trabid,gs_puerto);
            if gi_boleto_tamano = 1 then
                imprimirBoletoDatamax101('Terminal : '+Terminal,  //0
                                         '', //1
                                         '',                         //2
                                         '',         //3
                                         'Boleto de no abordo, Taquilla : ' +Taquilla,      //4
                                         'Cajero : '+ autoriza,      //5
                                         'Promotor:  '+trabid +' '+ promotor_name,          //6
                                         'RECOLECCION PARCIAL',     //7
                                         'Importe : $' +importe,    //8
                                         'Fecha y hora :' + Ahora() + ' Caj: '+ autoriza,//9
                                         '',//10
                                         '',//11
                                         '',//12
                                         '',//13
                                         '',//14
                                         'Recoleccion Parcial: $'+importe+'  Caj : '+autoriza,//15
                                         'Promotor: '+trabid + ' ' + promotor_name +'  Fecha y Hora :'+Ahora(),//16
                                         '',
                                         gs_puerto );
    end;
    if gs_impresora_boleto = _IMP_IMPRESORA_OPOS then begin//impresora Toshiba miniprinter
             ls_OPOS := '';
             ls_OPOS := inicializarImpresora_OPOS;
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Terminal : '+gs_terminal + ' '+'Taquilla : '+gs_terminal, 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Recoleccion Parcial : ','c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS(CurrToStrF(lf_importe,ffCurrency, 2), 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Fecha Hora '+Copy(Ahora(),12,8), 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Promotor : '+gs_trabid + ' Cajero : '+ autoriza, 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Promotor : '+promotor_name, 'c');
             ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(3);
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('_________________________________', 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Firma Cajero: '+ autoriza, 'c');
             ls_OPOS := ls_OPOS + corte_OPOS;
             escribirAImpresora(gs_impresora_boletos, ls_OPOS);
             ls_OPOS := '';
             ls_OPOS := inicializarImpresora_OPOS;
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Terminal : '+gs_terminal + ' '+'Taquilla : '+gs_terminal, 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Recoleccion Parcial : ','c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS(CurrToStrF(lf_importe,ffCurrency, 2), 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Fecha Hora '+Copy(Ahora(),12,8), 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Promotor : '+gs_trabid + ' Cajero : '+ autoriza, 'c');
             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Promotor : '+promotor_name, 'c');
             ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(2);
             ls_OPOS := ls_OPOS + corte_OPOS;
             escribirAImpresora(gs_impresora_boletos, ls_OPOS);
    end;
end;



procedure ErrorLog(Error, sql : string);
begin
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

function codigoUnico(seats : array_asientos; indice : integer) : string;
var
    STOREN : TSQLStoredProc;
    str_clave : string;
begin
    STOREN := TSQLStoredProc.Create(nil);
    STOREN.SQLConnection := DM.Conecta;
    STOREN.close;
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

function getCodeImprimeFactura(str_user : String) : string;
var
   lq_codigo : TSQLQuery;
   str_cdn, str_tmp   : string;
   li_ctrl, li_pro : integer;
   lc_char : char;
begin
    lq_codigo := TSQLQuery.Create(nil);
    lq_codigo.SQLConnection := Dm.conecta;
    if EjecutaSQL(Format(_CODIGO_UNICO_FACTURA,[str_user]),lq_codigo,_LOCAL) then
        str_cdn := lq_codigo['CODE'];
    lq_codigo.Free;
    result := str_cdn;
//    result := FormatMaskText('000000-000000-000000-000000-000000-000000;0',  str_cdn);
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


procedure ImprimeBoletos(asientos : array_asientos; li_vendidos : Integer);
Const

    _LS_LEYENDAR = 'REGIMEN FISCAL DE LOS COORDINADOS';
var
    li_ctrl_interno, li_boleto,li_corrida  : Integer;
    la_datos,la_imprime : gga_parameters;
    li_num : Integer;
    ls_hora, li_no_asiento : string;
    ld_fecha : TDate;
    ls_fecha,fecha, nombre : String;
    ls_ithaca, ls_hora_server, sentencia : string;
    li_impresora : integer;
    store, store1, store2 : TSQLStoredProc;
    lq_query : TSQLQuery;
    hilo_libera : Libera_Asientos;
    ls_dVerificador, ls_qry, ls_toshiba, str_factura, ls_iva_boleto, ls_OPOS, ls_fecha_ventaBoleto  : string;
    ld_total : Double;
    lf_tarifa : Real;
begin//consultamos en la base para obtener el
    str_factura := '';
    li_boleto := folioBoleto(asientos[1].empleado,asientos[1].origen);
    str_factura := UpperCase(getCodeImprimeFactura(asientos[1].empleado+gs_terminal+gs_maquina));
    for li_ctrl_interno := 1 to li_vendidos  - 1 do begin
        splitLine(asientos[li_ctrl_interno].fecha_hora,' ',la_datos,li_num);
        if li_num = 0 then
           ls_hora :=  la_datos[1]
        else ls_hora :=  la_datos[li_num];
        if la_datos[0][5] = '-' then
            ls_fecha := la_datos[0]
        else
            ls_fecha :=  Copy(la_datos[0],7,4) + '-' + Copy(la_datos[0],4,2) + '-' +
                         Copy(la_datos[0],1,2);
        if la_datos[0][5] = '/'then
            ls_fecha :=  Copy(la_datos[0],1,4) + '-' + Copy(la_datos[0],6,2) + '-' +
                         Copy(la_datos[0],9,2);

        if gi_vta_pie = 1 then
            li_no_asiento :=  IntToStr(asientos[li_ctrl_interno].asiento - 100)
        else
            li_no_asiento :=  IntToStr(asientos[li_ctrl_interno].asiento);
        store := TSQLStoredProc.Create(nil);
        store.SQLConnection := CONEXION_VTA;
        store.close;
        store.StoredProcName := 'PDV_STORE_BUSCA_BOLETO_VENDIDO';
        store.Params.ParamByName('IN_CORRIDA').AsString := asientos[li_ctrl_interno].corrida;
        store.Params.ParamByName('IN_FECHA').AsString :=  ls_fecha;
        store.Params.ParamByName('IN_ASIENTO').AsInteger := asientos[li_ctrl_interno].asiento;
        store.Params.ParamByName('IN_TRABID').AsString := asientos[li_ctrl_interno].empleado;
        store.Open;
        if store['EXISTE'] = 0 then begin
            RegistrarBoleto(asientos[li_ctrl_interno],li_boleto, la_datos[0], str_factura);
//            ls_dVerificador := obtieneDigitoVerificador(codigoUnico(asientos,li_ctrl_interno));
            store1 := TSQLStoredProc.Create(nil);
            store1.SQLConnection := CONEXION_VTA;
            store1.close;
            store1.StoredProcName := 'PDV_STORE_BOLETO_VENDIDO_IVA';
            store1.Params.ParamByName('IN_CORRIDA').AsString := asientos[li_ctrl_interno].corrida;
            store1.Params.ParamByName('IN_FECHA_INPUT').AsString :=  ls_fecha;
            store1.Params.ParamByName('IN_ASIENTO').AsInteger := asientos[li_ctrl_interno].asiento;
            store1.Params.ParamByName('IN_HORA').AsString     := Copy(asientos[li_ctrl_interno].fecha_hora,12,5);
            store1.Params.ParamByName('IN_SERVICIO').AsInteger := StrToInt(asientos[li_ctrl_interno].servicio);
            store1.Params.ParamByName('IN_TRABID').AsString := asientos[li_ctrl_interno].empleado;
            store1.Params.ParamByName('IN_TAQUILLA').AsInteger := asientos[li_ctrl_interno].taquilla;
            store1.Open;
            li_num := 0;
            ls_iva_boleto := '';
            if not store1.IsEmpty then begin
                splitLine(store1['NOMBRE_PASAJERO'],'*',la_imprime,li_num);
                lq_query := TSQLQuery.Create(nil);
                lq_query.SQLConnection := CONEXION_VTA;
                   if gi_cobro_con_iva = 1 then begin
                      if asientos[li_ctrl_interno].iva > 0 then
                          ls_iva_boleto := 'IVA' + FloatToStr((asientos[li_ctrl_interno].iva - 1) * 100)  +'% '+
                          formatfloat('####0.00',STORE1['TOTAL_IVA']);
                   end;
                if li_num = -1 then begin
                    store2 := TSQLStoredProc.Create(nil);
                    store2.SQLConnection := CONEXION_VTA;
                    store2.close;
                    store2.StoredProcName := 'PDV_STORE_PASAJERO';
                    store2.Params.ParamByName('IN_CORRIDA').AsString := asientos[li_ctrl_interno].corrida;
                    store2.Params.ParamByName('IN_FECHA_INPUT').AsString :=  ls_fecha;
                    store2.Params.ParamByName('IN_ASIENTO').AsInteger := asientos[li_ctrl_interno].asiento;
                    store2.Open;
                    splitLine(store2['NOMBRE_PASAJERO'],'*',la_imprime,li_num);
                    store2.free;
                    store2 := nil;

                end;
                if EjecutaSQL('SELECT (DATE_FORMAT(current_timestamp(),''%Y-%m-%d %T''))as ahora',lq_query,_LOCAL) then begin
//                     ls_fecha_ventaBoleto := FormatDateTime('YYYY-MM-DD', lq_query['Ahora']);
                end;
                if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin//impresora TEC Toshiba
                   if gi_boleto_tamano = 0 then begin
                      li_num := imprimirBoletoDatamax('',
                                                _LS_LEYENDAR,
                                                'TC # '+FormatMaskText('000000-000000-000000-000000-000000-000000;0', str_factura),
                                                store1['ID_CORRIDA'],
                                                store1['ORIGEN']+ls_extra_imprime,
                                                IntToStr(store1['NO_ASIENTO'])+' '+ store1['DESCRIPCION'],
                                                store1['FECHA'],'',store1['SERVICIO'],
                                                '',store1['DESTINO'],
                                                Format('%0.2f',[StrToFloat(store1['TARIFA'])])+' '+ store1['ABREVIACION'],
                                                ls_iva_boleto,
                                                FormatDateTime('HH:nn',StrToDateTime(ls_hora)),
                                                IntToStr(store1['ID_BOLETO'])+ '.' + store1['TRAB_ID']+'.'+gs_Terminal+ls_dVerificador,
                                                store1['ORIGEN']+'-'+store1['DESTINO'] +' '+FormatDateTime('HH:nn',StrToDateTime(store1['HORA']))+
                                                ' Costo :' +Format('%0.2f',[StrToFloat(store1['TARIFA'])])+ ' ' +store1['ID_CORRIDA'],
                                                IntToStr(store1['ID_BOLETO'])+ '.' + store1['TRAB_ID']+'.'+gs_Terminal+ls_dVerificador,
                                                'Identificacion:'+la_imprime[1]+' '+la_imprime[0],
                                                FormatDateTime('HH:nn',StrToDateTime(store1['HORA'])),gs_puerto);
                   end;
                   if gi_boleto_tamano = 1 then begin
                                imprimirBoletoDatamax101(
                                                      'Fecha Salida : '+ FormatDateTime('YYYY-MM-DD',STORE1['FECHA']),//0
                                                      _LS_LEYENDAR,//1
                                                      la_imprime[0],//2
                                                      'TC # : '+FormatMaskText('000000-000000-000000-000000-000000-000000;0', str_factura),
                                                      'Origen   : '+ STORE1['ORIGEN']+ls_extra_imprime+' Destino : '+STORE1['DESTINO'],
                                                      'Hora Salida  : '+ FormatDateTime('HH:nn',StrToDateTime(ls_hora)),//5
                                                      'Asiento  : ' +IntToStr(STORE1['NO_ASIENTO']) +' Pasajero : ' + STORE1['DESCRIPCION'],
                                                      'Corrida      : ' + STORE1['ID_CORRIDA'],
                                                      'Servicio : '+STORE1['SERVICIO'],
                                                      'Importe    : $'+Format('%0.2f',[StrToFloat(store1['TARIFA'])]) + ' ' + STORE1['ABREVIACION'],//10
                                                       ls_iva_boleto,
                                                      'No. :'+IntToStr(STORE1['ID_BOLETO'])+ '.' + STORE1['TRAB_ID']+'.'+gs_terminal,
                                                      '',//'Dispone de 30 días facturar a partir de '+ ls_fecha_ventaBoleto,//12
                                                      '',
                                                      '',
                                                      'Origen : '+ STORE1['ORIGEN']+ls_extra_imprime+
                                                                ' Destino : '+STORE1['DESTINO']+ ' Total : $'+Format('%0.2f',[StrToFloat(store1['TARIFA'])]),
                                                      'Folio  :'+IntToStr(STORE1['ID_BOLETO'])+ '.' + STORE1['TRAB_ID']+'.'+gs_terminal+
                                                        ' Asiento : ' +IntToStr(STORE1['NO_ASIENTO']) +' Tipo pasajero : ' + STORE1['DESCRIPCION'] ,
                                                      STORE1['TIPO_TARIFA'],
                                                      gs_puerto
                                                      );
                   end;
                end;
                if gs_impresora_boleto = _IMP_IMPRESORA_OPOS then begin//impresora Toshiba miniprinter
                             ls_qry := 'SELECT NOMBRE_EMPRESA, DIRECCION, DIRECCION1, RFC '+
                                       'FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL = ''%s'' ';
//                             ld_total := store1['TARIFA'];
                             if EjecutaSQL(Format(ls_qry,[gs_terminal]),lq_query,_LOCAL) then begin
                                  ls_OPOS := inicializarImpresora_OPOS;

                             ls_OPOS := '';
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
                                 ls_OPOS := ls_OPOS + textoAlineado_OPOS(_LS_LEYENDAR, 'c');
                                 ls_OPOS := ls_OPOS + textoAlineado_OPOS(lq_query['LUGAR_EXPEDICION']+','+ Ahora(), 'c');
                             end;
                             lf_tarifa := store1['TARIFA'];
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Origen   :'+STORE1['ORIGEN'] + '   Destino :'+STORE1['DESTINO'], 'i');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Corrida  :'+STORE1['ID_CORRIDA'] + '  Tipo :' +STORE1['DESCRIPCION'], 'i');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Fecha    :'+FormatDateTime('YYYY-MM-DD',STORE1['FECHA'])+ ' ' +'   Hora :'+FormatDateTime('HH:nn',StrToDateTime(ls_hora)) , 'i');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Asiento  :' + IntToStr(STORE1['NO_ASIENTO']),'i');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Importe  : $'+FormatFloat('###0.00', lf_tarifa)+' Tipo : '+STORE1['ABREVIACION'],'i');

                             ls_OPOS := ls_OPOS + textoAlineado_OPOS( STORE1['TIPO_TARIFA'], 'c', true);

                             ls_OPOS := ls_OPOS + textoAlineado_OPOS(ls_iva_boleto,'i');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('TC # '+FormatMaskText('000000-000000-000000-000000-000000-000000;0', str_factura),'c');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Lugar de expedicion : ' + getExpedicion(gs_terminal), 'c');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('AGRADECEMOS SU PREFERENCIA', 'c');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('v' + FloatToStr(_VERSION), 'c');
                                 if gi_pueblos_magicos = 1 then begin
                                    ls_OPOS := ls_OPOS + textoAlineado_OPOS('Folio : '+ IntToStr(STORE1['ID_BOLETO'])+ '.' + STORE1['TRAB_ID']+'.'+gs_terminal, 'c');
                                    ls_OPOS := ls_OPOS + textoAlineado_OPOS('Servicio : Ruta Turistica','c');
                                    ls_OPOS := ls_OPOS + textoAlineado_OPOS('Este boleto es valido para la fecha y hora que','c');
                                    ls_OPOS := ls_OPOS + textoAlineado_OPOS('se expide y da derecho al seguro del viajero','c');
                                 end else begin
                                    ls_OPOS := ls_OPOS + textoAlineado_OPOS(IntToStr(STORE1['ID_BOLETO'])+ '.' + STORE1['TRAB_ID']+'.'+gs_terminal, 'c');
                                 end;
                              ls_OPOS := ls_OPOS + textoAlineado_OPOS(FormatDateTime('YYYY-MM-DD',STORE1['FECHA'])   + ' ' +
                                                                          FormatDateTime('HH:nn:ss',StrToDateTime(ls_hora)),'c');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS(ls_hora_server, 'c');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS(la_imprime[0], 'c');
                             ls_OPOS := ls_OPOS + inicializarImpresora_OPOS;
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS(codigoDeBarrasUniDimensional_OPOS(STORE1['ORIGEN']+' '+
                                                                          STORE1['DESTINO'] + ' '+ STORE1['ID_CORRIDA']   + ' ' +
                                                                          FormatDateTime('YYYY-MM-DD',STORE1['FECHA'])   + ' ' +
                                                                          FormatDateTime('HH:nn',StrToDateTime(ls_hora))+ ' ' +
                                                                          IntToStr(STORE1['NO_ASIENTO'])), 'c');
{                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Para un mejor servicio ahora tiene 30 días', 'c');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('naturales a partir de la fecha  ', 'c');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('de compra ' + ls_fecha_ventaBoleto, 'c');}

                             ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(2);
                             ls_OPOS := ls_OPOS + inicializarImpresora_OPOS;
                             ls_OPOS := ls_OPOS + corte_OPOS_seccion();
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Origen: '+ STORE1['ORIGEN'] + ' Destino: '+ STORE1['DESTINO'] +' Corrida: '+ STORE1['ID_CORRIDA'], 'i');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Total : $' + Format('%0.2f',[ld_total]) + ' Fecha : '+FormatDateTime('YYYY-MM-DD',STORE1['FECHA'])+ ' ' + FormatDateTime('HH:nn',StrToDateTime(ls_hora)) , 'i');
                             ls_OPOS := ls_OPOS + textoAlineado_OPOS('Folio : ' +IntToStr(STORE1['ID_BOLETO'])+ ' ' + STORE1['TRAB_ID']+' Asiento : '+ IntToStr(STORE1['NO_ASIENTO']) + ' Pax : ' + STORE1['DESCRIPCION'], 'I');
                             ls_OPOS := ls_OPOS + corte_OPOS;
                             escribirAImpresora(gs_impresora_boletos, ls_OPOS);
                           end;

                end;
            end;
//MANDAMOS ACTUALIZAR EL IVA AL SERVER
            if EjecutaSQL(Format(_LOCAL_BOLETO,[intToStr(store1['ID_BOLETO']), store1['ID_CORRIDA'],
                                                formatDateTime('YYYY-MM-DD',store1['FECHA']),
                                                intToStr(store1['NO_ASIENTO']), store1['TRAB_ID']
                                               ] ), lq_query, _LOCAL) then begin
                  sentencia := Format(_SERVER_IVA_UPDATE,[floatTostr(lq_query['IVA']), floatTostr(lq_query['TOTAL_IVA']),
                                                           intToStr(store1['ID_BOLETO']),  store1['TRAB_ID'], intToStr(store1['NO_ASIENTO'])] );
                  EjecutaSQL(sentencia,lq_query,_SERVIDOR_CENTRAL);
            end;


            sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR,[asientos[li_ctrl_interno].corrida,
                                  asientos[li_ctrl_interno].fecha_hora,
                                  IntToStr(asientos[li_ctrl_interno].asiento),
                                  asientos[li_ctrl_interno].nombre, gs_terminal, asientos[li_ctrl_interno].empleado,
                                  asientos[li_ctrl_interno].origen, asientos[li_ctrl_interno].destino,'V'] );
            hilo_libera := Libera_Asientos.Create(true);
            hilo_libera.server := CONEXION_VTA;
            hilo_libera.sentenciaSQL := sentencia;
            hilo_libera.ruta   := asientos[li_ctrl_interno].ruta;//StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
            hilo_libera.origen := asientos[li_ctrl_interno].origen;
            hilo_libera.destino := asientos[li_ctrl_interno].destino;
            hilo_libera.Priority := tpNormal;
            hilo_libera.FreeOnTerminate := True;
            hilo_libera.start;
            store1.Free;
            store1 := nil;
            CONEXION_VTA := CONEXION_VTA;
            CORRIDA_ULTIMA.origen := asientos[li_ctrl_interno].origen;
            CORRIDA_ULTIMA.destino := asientos[li_ctrl_interno].destino;
            CORRIDA_ULTIMA.hora := ls_hora;
            CORRIDA_ULTIMA.fecha := copy(ls_fecha,9,2)+'/'+
                                    copy(ls_fecha,6,2)+'/'+
                                    copy(ls_fecha,1,4); //ls_fecha;
            CORRIDA_ULTIMA.servicio := asientos[li_ctrl_interno].servicio;
            CORRIDA_ULTIMA.corrida := asientos[li_ctrl_interno].corrida;
        end;
        store.Free;
        store := nil;
        inc(li_boleto);///liberamos la corrida para que se utilice en otras terminales con la funcion apartaCorrida
        if li_vta_anticipada_pago = 0 then
            apartaCorrida(asientos[li_ctrl_interno].corrida, gd_fecha_apartada,ls_hora, asientos[li_ctrl_interno].origen,gs_trabid,asientos[li_ctrl_interno].ruta);
    end;
    Finalize(asientos);
end;


procedure BorraAsiento(var asientos : array_asientos; li_vendidos : Integer);
var
    li_ctrl_interno : Integer;
begin
    for li_ctrl_interno := 1 to li_vendidos  do begin
        estatus_ASIENTO(asientos[li_ctrl_interno],'D');
        asientos[li_ctrl_interno].corrida := '';
        asientos[li_ctrl_interno].fecha_hora := '';
        asientos[li_ctrl_interno].asiento := 0;
        asientos[li_ctrl_interno].empleado := '';
        asientos[li_ctrl_interno].origen := '';
        asientos[li_ctrl_interno].destino := '';
        asientos[li_ctrl_interno].status := ' ';
        asientos[li_ctrl_interno].precio := 0;
        asientos[li_ctrl_interno].precio_original := 0;
        asientos[li_ctrl_interno].servicio := '';
        asientos[li_ctrl_interno].forma_pago := 0;
        asientos[li_ctrl_interno].descuento := 0;
        asientos[li_ctrl_interno].Ocupante := '';
        asientos[li_ctrl_interno].tipo_tarifa := '';
        asientos[li_ctrl_interno].idOcupante := 0;
        asientos[li_ctrl_interno].taquilla := 0;
        asientos[li_ctrl_interno].nombre := '';
        asientos[li_ctrl_interno].abrePago := '';
        asientos[li_ctrl_interno].ruta := 0;
        asientos[li_ctrl_interno].pago_efectivo := 0;
        asientos[li_ctrl_interno].calculado := 0;
    end;
end;


procedure BorraArregloAsientos(var asientos : array_asientos);
var
    li_ctrl_array : integer;
begin
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
        asientos[li_ctrl_array].servicio    := '';
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
        asientos[li_ctrl_array].id_pago_pinpad_banamex   := '';
        asientos[li_ctrl_array].iva        := 0;
    end;
end;

procedure BorraAsientoArreglo(asientos : array_asientos; li_vendidos : Integer; corrida : String);
var
    li_ctrl_memoria, li_ctrl_array, li_ctrl : integer;
begin
    for li_ctrl_memoria := 0 to li_vendidos do begin
        for li_ctrl_array := 1 to li_ctrl_asiento - 1 do begin
            if (memoria_cuales[li_ctrl_memoria] = asientos[li_ctrl_array].asiento)  then
            begin
                estatus_ASIENTO(asientos[li_ctrl_array],'D');
                asientos[li_ctrl_array].corrida     := '';
                asientos[li_ctrl_array].fecha_hora  := '';
                asientos[li_ctrl_array].asiento     := 0;
                asientos[li_ctrl_array].empleado    := '';
                asientos[li_ctrl_array].origen      := '';
                asientos[li_ctrl_array].destino     := '';
                asientos[li_ctrl_array].status      := ' ';
                asientos[li_ctrl_array].precio      := 0;
                asientos[li_ctrl_array].precio_original  := 0;
                asientos[li_ctrl_array].servicio    := '';
                asientos[li_ctrl_array].forma_pago  := 0;
                asientos[li_ctrl_array].descuento   := 0;
                asientos[li_ctrl_array].Ocupante    := '';
                asientos[li_ctrl_array].tipo_tarifa := '';
                asientos[li_ctrl_array].idOcupante  := 0;
                asientos[li_ctrl_array].taquilla    := 0;
                asientos[li_ctrl_array].nombre      := '';
                asientos[li_ctrl_array].abrePago    := '';
                asientos[li_ctrl_array].ruta        := 0;
                asientos[li_ctrl_array].ruta        := 0;
                li_ctrl := li_ctrl_array;
            end;//fin if memoria cuales
        end;
    end;
    if li_ctrl > 0 then begin
        li_ctrl_asiento := li_ctrl_asiento - li_ctrl;
    end;
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


procedure ActualizaPrecioArreglo(var asientos : array_asientos; li_indice : Integer;
                                 lf_precio : Real);
var
    lf_dato : Double;
begin
    asientos[li_indice].precio := lf_precio;
//actualizar el tipo de pago
end;


procedure llenarArregloCaracteres;
begin
    la_caracteres[0] := '0';
    la_caracteres[1] := '1';
    la_caracteres[2] := '2';
    la_caracteres[3] := '3';
    la_caracteres[4] := '4';
    la_caracteres[5] := '5';
    la_caracteres[6] := '6';
    la_caracteres[7] := '7';
    la_caracteres[8] := '8';
    la_caracteres[9] := '9';
    la_caracteres[10] := ' ';
    la_caracteres[11] := ',';
    la_caracteres[12] := '-';
    la_separador[0] := ' ';
    la_separador[1] := ',';
    la_separador[2] := '-';
end;


function existe(lc_carac : Char) : Boolean;
var
    li_ctrl : Integer;
    lb_ok : Boolean;
begin
    lb_ok := false;
    for li_ctrl := 0 to  high(la_caracteres) do
        if lc_carac = la_caracteres[li_ctrl] then begin
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


function porSeparador(ls_cadena : string) : string;
var
    li_ctrl_input : Integer;
    ls_out : String;
begin
    for li_ctrl_input := 1 to Length(ls_cadena) - 2 do
        ls_out := ls_out + ls_cadena[li_ctrl_input];
    Result := ls_out;
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



function validaCualesOcupantes(ls_cadena : string) :  String;
var
    li_cantidad, li_num, li_ctrl,li_compara : integer;
    la_valida   : gga_parameters;
    ls_out,ls_letra      : String;
begin
    splitLine(ls_cadena,' ',la_valida,li_num);
    if li_num = 0 then begin
        ls_cadena := Trim(ls_cadena);
        li_cantidad := StrToInt(Copy(ls_cadena,1, length(ls_cadena) - 1));
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
        if li_cantidad > li_compara then
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
           if li_cantidad > li_compara then
              ls_out := ls_out + #10#13 + ls_cadena + ': Es mayor a la permitida'
           else begin
                   gds_ocupantes_asignados.Add(ls_letra, IntToStr(li_cantidad));
                   ls_out := '';
           end;
        end;
    end;
    result := ls_out;
end;

function obtenerIpsServer() : array_servers;
var
    lq_query : TSQLQuery;
    li_ctrl  : integer;
    arreglo_server  : array_servers;
begin
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(_CONFIG_IPS_SERVERS,lq_query,_LOCAL) then begin
            lq_query.First;
            li_ctrl := 1;
            while not lq_query.Eof do begin
                arreglo_server[li_ctrl].terminal := lq_query['ID_TERMINAL'];
                arreglo_server[li_ctrl].ip   := lq_query['IPV4'];
                arreglo_server[li_ctrl].user := lq_query['BD_USUARIO'];
                arreglo_server[li_ctrl].pass := lq_query['BD_PASSWORD'];
                arreglo_server[li_ctrl].estatus := lq_query['ESTATUS'];
                arreglo_server[li_ctrl].tipo := lq_query['TIPO'];
                inc(li_ctrl);
                lq_query.Next;
            end;//fin while
        end;//fin ejecuta
    finally
      lq_query.Free;
       lq_query := nil;
    end;
    Result := arreglo_server;
end;



function ConexionObtenIPServer(ls_terminal : string) : TSQLConnection;
var
    li_ctrl : Integer;
    lb_existe : Boolean;
    connexionNueva : TSQLConnection;
    ls_out : string;
begin
    for li_ctrl := 1 to high(ga_servers) do begin
        if UpperCase(ga_servers[li_ctrl].terminal) = UpperCase(ls_terminal) then begin
            lb_existe := true;
            Break;
        end;
    end;
    ls_out := ga_servers[li_ctrl].ip + #10#13 +
              _BASE_DE_DATOS;

    if lb_existe then begin
        connexionNueva := TSQLConnection.Create(nil);
        try
{            connexionNueva.Params.Values['HOSTNAME']  := ga_servers[li_ctrl].ip;
            connexionNueva.Params.Values['DATABASE']  := _BASE_DE_DATOS;
            connexionNueva.Params.Values['USER_NAME'] := ga_servers[li_ctrl].user;
            connexionNueva.Params.Values['PASSWORD']  := ga_servers[li_ctrl].pass;
            connexionNueva.Connected := true;}
        except
            on E: Exception do
                ErrorLog(E.Message,ls_out);//escribimos al archivo
        end;
    end;//fin existe
    result := connexionNueva;
end;

procedure creaStoreConnecion();
begin
    ConexionRemota := TSQLConnection.Create(nil);
    storeRemota    := TSQLStoredProc.Create(nil);
end;

function accesoQueryStoreLocalRemoto(lp_origen : String) : TSQLConnection;
begin
    if not (lp_origen = gs_terminal) then
        Result := ConexionRemota
    else
        Result := DM.Conecta;

end;

procedure limpiaStringGrid(Grid : TStringGrid);
var
    li_col, li_row : integer;
begin
    for li_row := 0 to Grid.RowCount - 1 do
      for li_col := 0 to Grid.ColCount - 1 do
          Grid.Cells[li_col,li_row] := '';
end;


function buscAsientoCancela(li_corrida : String;
                                fecha, time : string; var li_max :integer): la_acancelar;
var
    la_datos : la_acancelar;
    li_ctrl : integer;
    store : TSQLStoredProc;
begin
    for li_ctrl := 1 to high(la_datos) do
        la_datos[li_ctrl] := 0;
    store := TSQLStoredProc.Create(nil);
    try
      store.SQLConnection := DM.Conecta;
      try
         store.close;
         store.StoredProcName := 'PDV_STORE_ASIENTOS_CANCELA';
         store.Params.ParamByName('IN_CORRIDA').AsString := li_corrida;
         store.Params.ParamByName('IN_FECHA').AsString := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
         store.Params.ParamByName('IN_TIME').AsString  := FormatDateTime('HH:nn:SS', StrToTime(time));
         store.Open;
         store.First;
         li_max := 1;
         while not store.Eof do begin
            la_datos[li_max] := store['NO_ASIENTO'];
            inc(li_max);
            store.Next;
         end;
      except on E: Exception do
      end;
    finally
      store.free;
      store := nil;
    end;
    Result := la_datos;
end;


{@Procedure limpiar_La_labels
@Params lbl_asientos : labels_asientos
@Descripcion limpiamos el arreglo de las labels}
procedure limpiar_La_labels(lbl_asientos : labels_asientos);
var
    li_ctrl_labels : integer;
begin
    try
      for li_ctrl_labels := 1 to high(lbl_asientos) do begin
          lbl_asientos[li_ctrl_labels]^.Caption := '';
          lbl_asientos[li_ctrl_labels]^.Visible := False;
      end;
    except
    end;
end;


procedure titulosCorridaGrid(grid : TStringGrid);
begin
    grid.Cells[_COL_HORA, 0] := 'HORA';
    grid.Cells[_COL_DESTINO, 0] := 'DESTINO';
    grid.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
    grid.Cells[_COL_FECHA, 0] := 'FECHA';
    grid.Cells[_COL_RUTA, 0] := 'Ruta';
    grid.Cells[_COL_CORRIDA, 0] := 'Corrida';
    grid.Cells[_COL_TARIFA, 0] := 'Tarifa';
    grid.ColWidths[_COL_TRAMO] := 0;
    grid.ColWidths[_COL_AUTOBUS] := 0;
    grid.ColWidths[_COL_ASIENTOS] := 0;
    grid.ColWidths[_COL_NAME_IMAGE] := 0;
    grid.ColWidths[_COL_TIPOSERVICIO] := 0;
    grid.ColWidths[_COL_PIE] := 0;
    grid.ColWidths[_COL_CUPO] := 0;
//    grid.ColWidths[_COL_IVA]  := 0;

{  stg_corrida.Cells[_COL_HORA, 0] := 'HORA';
  stg_corrida.Cells[_COL_DESTINO, 0] := 'DESTINO';
  stg_corrida.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
  stg_corrida.Cells[_COL_FECHA, 0] := 'FECHA';
  stg_corrida.Cells[_COL_RUTA, 0] := 'Ruta';
  stg_corrida.Cells[_COL_CORRIDA, 0] := 'Corrida';
  stg_corrida.Cells[_COL_TARIFA, 0] := 'Tarifa';
  stg_corrida.ColWidths[_COL_TRAMO] := 0;
  stg_corrida.ColWidths[_COL_AUTOBUS] := 0;
  stg_corrida.ColWidths[_COL_ASIENTOS] := 0;
  stg_corrida.ColWidths[_COL_NAME_IMAGE] := 0;
  stg_corrida.ColWidths[_COL_TIPOSERVICIO] := 0;
  stg_corrida.ColWidths[_COL_PIE] := 0;
  stg_corrida.ColWidths[_COL_CUPO] := 0;
  stg_ocupantes.ColWidths[0] := 160;
  stg_ocupantes.ColWidths[1] := 30;}

end;

{@function cupoRutaYTerminal
@Params corrida, ruta : integer; hora,fecha, terminal : string
@Descripcion obtenemos el total de ocupantes por toda la ruta desde
@el origen hasta el punto actual de la venta para tener la venta
@permitida en la terminal}
function cupoRutaYTerminal(corrida : String; ruta : integer; hora,fecha, terminal : string;
                           servicio : integer) : integer;
var
    store : TSQLStoredProc;
    li_out : integer;
    ls_inicio, ls_tmp : string;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA; //DM.Conecta;
        store.close;
        store.StoredProcName := 'PDV_STORE_CUPO_RUTA_NEW';
        store.Params.ParamByName('IN_TERMINAL').AsString  := terminal;
        store.Params.ParamByName('IN_RUTA').AsInteger     := ruta;
        store.Params.ParamByName('IN_SERVICIO').AsInteger := servicio;
        store.Open;
        with store do begin
          First;
            while not Eof do begin
                if length(ls_inicio) = 0then
                   ls_inicio :=  store['ID_TERMINAL'];
                if ls_tmp = ls_inicio then
                    break;
                ls_tmp := store['ID_TERMINAL'];
                li_out := li_out + store['CUPO'];
                next;
            end;
        end;
    finally
        store.free;
        store := nil;
    end;
    Result := li_out;
 end;



{@function cupoCorridaVigente
@Params corrida : integer; fecha, hora : string; conexion : TSQLConnection
@Descripcion obtenemos el cupo actual del bus en la terminal actual}
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


{@function cupoPieCorrida
@Params Grid : TStringGrid
@Descripcion regresa el valor del cupo permitido de que tiene
@para vender de pie esto esta en el grid}
function cupoPieCorrida(corrida,fecha,terminal : string) : Integer;
var
    li_ctrl : integer;
    li_pie  : integer;
    str_query : string;
    lq_query : TSQLQuery;
begin //lo busque en la base
{    for li_ctrl := 0 to Grid.RowCount do begin
        if Grid.Cells[0,li_ctrl] = 'PIE' then begin
            li_pie := StrToInt(Grid.Cells[1,li_ctrl]);
            break;
        end;
    end;}
    lq_query := TSQLQuery.Create(nil);
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

function conexionAServidor(terminal : string) : Boolean;
var
    lq_query : TSQLQuery;
    lb_out   : Boolean;
    ls_ip    : string;
    ls_usuario : string;
    ls_password : string;
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
                CONEXION_VTA.Close;
{                CONEXION_VTA.DriverName := _DRIVER;
                CONEXION_VTA.Params.Values['HOSTNAME']  := ls_ip;  //lq_query['IPv4'];
                CONEXION_VTA.Params.Values['DATABASE']  := _BASE;
                CONEXION_VTA.Params.Values['USER_NAME'] := ls_usuario;
                CONEXION_VTA.Params.Values['PASSWORD']  := ls_password;
                CONEXION_VTA.LoginPrompt := False;
                CONEXION_VTA.Connected := True;}
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
    Result := lb_out;
end;


procedure limpiarPDV(var asientos : array_asientos);
var
    li_flujo : Integer;
begin
    for li_flujo := 1 to 50 do begin
      asientos[li_flujo].corrida     := '';
      asientos[li_flujo].fecha_hora  := '';
      asientos[li_flujo].asiento     := 0;
      asientos[li_flujo].empleado    := '';
      asientos[li_flujo].origen      := '';
      asientos[li_flujo].destino     := '';
      asientos[li_flujo].status      := ' ';
      asientos[li_flujo].precio      := 0;
      asientos[li_flujo].precio_original  := 0;
      asientos[li_flujo].servicio    := '';
      asientos[li_flujo].forma_pago  := 0;
      asientos[li_flujo].descuento   := 0;
      asientos[li_flujo].Ocupante    := '';
      asientos[li_flujo].tipo_tarifa := '';
      asientos[li_flujo].idOcupante  := 0;
      asientos[li_flujo].taquilla    := 0;
      asientos[li_flujo].nombre      := '';
      asientos[li_flujo].abrePago    := '';
      asientos[li_flujo].ruta        := 0;
    end;
end;

procedure llenarArregloBoletos(qry : TSQLQuery);
var
  li_num : integer;
begin
    qry.First;
    li_num := 1;
    while not qry.Eof do begin
        BOLETOS_PDV[li_num].id_boleto := qry['ID_BOLETO'];
        BOLETOS_PDV[li_num].terminal  := qry['ID_TERMINAL'];
        BOLETOS_PDV[li_num].trab_id   := qry['TRAB_ID'];
        BOLETOS_PDV[li_num].status    := qry['ESTATUS'];
        BOLETOS_PDV[li_num].origen    := qry['ORIGEN'];
        BOLETOS_PDV[li_num].destino   := qry['DESTINO'];
        BOLETOS_PDV[li_num].id_forma_pago := qry['ID_FORMA_PAGO'];
        BOLETOS_PDV[li_num].taquilla  := qry['ID_TAQUILLA'];
        BOLETOS_PDV[li_num].tipo_tarifa := qry['TIPO_TARIFA'];
        BOLETOS_PDV[li_num].fecha_boleto := qry['FECHA_HORA_BOLETO'];
        BOLETOS_PDV[li_num].fecha       :=  formatDateTime('YYYY-MM-DD', StrtoDate(qry['FECHA']));
        BOLETOS_PDV[li_num].id_corrida  := qry['ID_CORRIDA'];
        BOLETOS_PDV[li_num].nombre_pasajero := qry['NOMBRE_PASAJERO'];
        BOLETOS_PDV[li_num].no_asiento := qry['NO_ASIENTO'];
        BOLETOS_PDV[li_num].id_ocupante := qry['ID_OCUPANTE'];
        Inc(li_num);
        qry.next;
    end;//fin while
    li_maximo_boletos := li_num;
end;


procedure asientosEmisora(ls_corrida,fecha,ls_origen, ls_destino : String;
                          var output: gga_parameters; var indice : integer);
var
    lq_qry : TSQLQuery;
    ls_pasajero, ls_trabid,ls_terminal_reserva : string;

begin
    lq_qry := TSQLQuery.Create(nil);
    fecha := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
    lq_qry.SQLConnection := CONEXION_VTA;
    if EjecutaSQL(format(_A_BOLETO_EMISOR,[ls_corrida,fecha,ls_origen,ls_destino]),lq_qry,_LOCAL) then begin
//guardamos en la estructura PDV_BOLETO
        llenarArregloBoletos(lq_qry);
    end;
    try//NO_ASIENTO,NOMBRE_PASAJERO,TERMINAL_RESERVACION,TRAB_ID,ORIGEN,DESTINO,STATUS
        if EjecutaSQL(Format(_A_CORRIDA_EMISORA_ASIENTOS,[
                      ls_corrida,fecha,ls_origen,ls_destino]),lq_qry,_LOCAL) then begin
          indice := 0;
          with lq_qry do begin
              First;
              while not EoF do begin
                  if VarIsNull(lq_qry['NOMBRE_PASAJERO']) then
                      ls_pasajero := 'NULL'
                  else
                      ls_pasajero := lq_qry['NOMBRE_PASAJERO'];
                  if VarIsNull(lq_qry['TRAB_ID']) then
                      ls_trabid := 'NULL'
                  else
                      ls_trabid := lq_qry['TRAB_ID'];
                  if VarIsNull(lq_qry['TERMINAL_RESERVACION']) then
                      ls_terminal_reserva := 'NULL'
                  else
                      ls_terminal_reserva := lq_qry['TERMINAL_RESERVACION'];

                  output[indice] := IntToStr(lq_qry['NO_ASIENTO'])+'|'+ls_pasajero+'|'+
                                    ls_terminal_reserva+'|'+ls_trabid+'|'+lq_qry['ORIGEN']+'|'+
                                    lq_qry['DESTINO']+'|'+lq_qry['STATUS'];
                  Inc(indice);
                  Next;
              end;
          end;//fin with
        end;//fin if ejecuta
    finally
       lq_qry.free;
       lq_qry := nil;
    end;
end;

function borraEmisora(ls_corrida,fecha,ls_origen, ls_destino : String; ruta : integer): string;
var
    lq_qry : TSQLQuery;
    li_idx : integer;
    ls_out : string;
    hilo_libera : Libera_Asientos;
    sentencia : String;
begin
    lq_qry := TSQLQuery.Create(nil);
    fecha := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
    try
        lq_qry.SQLConnection := CONEXION_VTA;
        sentencia := Format(_A_BORRA_ASIENTO_EMISOR,[
                      ls_corrida,fecha,ls_origen,ls_destino]);
        if EjecutaSQL(sentencia,lq_qry,_LOCAL) then begin
            ls_out := 'Se ha borrado el registro de los asientos';
            hilo_libera := Libera_Asientos.Create(true);
            hilo_libera.server := dm.Conecta;
            hilo_libera.sentenciaSQL := sentencia;
            hilo_libera.ruta   := ruta ;
            hilo_libera.origen := ls_origen;
            hilo_libera.destino := ls_destino;
            hilo_libera.Priority := tpNormal;
            hilo_libera.FreeOnTerminate := True;
            hilo_libera.Resume;
        end;
    finally
       lq_qry.free;
       lq_qry := nil;
    end;
    Result := ls_out;
end;

procedure actualizaBoletoAgrupado(corrida, fecha, origen,
                                      destino, asiento, trab_id, asiento_nuevo : String; inserta : integer);
var
    li_idx, li_boletos :  integer;
    lq_qry : TSQLQuery;
begin
{'UPDATE PDV_T_BOLETO SET ID_CORRIDA = ''  '+
 'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ORIGEN = ''%s'' '+
      'AND DESTINO = ''%s'' AND ID_BOLETO = %s AND TRAB_ID = ''%s'' ';}
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONEXION_VTA;
    if inserta = 0 then begin//buscamos por el numero se asiento corresponden
        for li_idx := 1 to li_maximo_boletos - 1 do begin
            if BOLETOS_PDV[li_idx].no_asiento = asiento then begin
                if EjecutaSQL(Format(_A_ACTUALIZA_BOLETO_NO_EXISTE,[
                   corrida, BOLETOS_PDV[li_idx].id_corrida, BOLETOS_PDV[li_idx].fecha,
                   BOLETOS_PDV[li_idx].origen, BOLETOS_PDV[li_idx].destino,
                   BOLETOS_PDV[li_idx].id_boleto, BOLETOS_PDV[li_idx].trab_id]),lq_qry,_LOCAL) then
                   break;
            end;//fin if
        end;//fin for
    end;//fin if
{'UPDATE PDV_T_BOLETO SET ID_CORRIDA = ''%s''  '+
                                 'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ORIGEN = ''%s'' '+
                                 'AND DESTINO = ''%s'' AND ID_BOLETO = %s AND TRAB_ID = ''%s'' ';}
    if inserta = 1 then begin
        for li_idx := 1 to li_maximo_boletos - 1 do begin
            if BOLETOS_PDV[li_idx].no_asiento = asiento then begin
                if EjecutaSQL(Format(_A_ACTUALIZA_BOLETO_EXISTE,[
                   corrida,asiento_nuevo, BOLETOS_PDV[li_idx].id_corrida, BOLETOS_PDV[li_idx].fecha,
                   BOLETOS_PDV[li_idx].origen, BOLETOS_PDV[li_idx].destino,
                   BOLETOS_PDV[li_idx].id_boleto, BOLETOS_PDV[li_idx].trab_id]),lq_qry,_LOCAL) then
                   break;
            end;//fin if
        end;//fin if
    end;//end if
end;


{@Procedure insertaReceptora
@Params output: gga_parameters; ls_corrida : string
@Descripcion insertamos en la tabla de PDV_T_ASIENTO los lugares de la primera
            corrida si se encuentra ocupado el asiento se asignara el continuo del disponible}
procedure insertaReceptora(output: gga_parameters; ls_corrida,hora : string; fecha : TDate;
                           maximo, lugares : integer; Grid : TStringGrid);
var
    lq_qry :  TSQLQuery;
    ls_fecha_receptor,ls_arreglo,ls_hora : string;
    li_idx, li_num, li_nuev_asientos,li_anterior,li_nuevos : Integer;
    la_datos : gga_parameters;
    la_nuevos_asientos : gga_parameters;
    sentencia : String;
    hilo_asiento : Libera_Asientos;
    hilo_asiento_nuevo : Libera_Asientos;
begin
    lq_qry := TSQLQuery.Create(nil);
    ls_fecha_receptor := FormatDateTime('YYYY-MM-DD', fecha)+ ' '+hora;
    try
        lq_qry.SQLConnection := CONEXION_VTA;
        li_nuev_asientos := 0;
        li_nuevos := 0;
        for li_idx := 0 to maximo - 1 do begin
            splitLine(output[li_idx],'|',la_datos,li_num);
            li_opcion_fecha_string := 0;
            if not verificaDisponibles(la_datos[0],ls_fecha_receptor,ls_corrida) then begin
                sentencia := 'INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,NOMBRE_PASAJERO, '+
                             '  TERMINAL_RESERVACION, TRAB_ID, ORIGEN, DESTINO,STATUS) '+
                             'VALUES('+QuotedStr(ls_corrida)+','+QuotedStr(copy(ls_fecha_receptor,1,10) + ' 00:00')+','+
                             la_datos[0]+','+QuotedStr(la_datos[1])+','+QuotedStr(la_Datos[2])+','+
                             QuotedStr(la_datos[3])+','+QuotedStr(la_datos[4])+','+QuotedStr(la_datos[5])+','+QuotedStr(la_datos[6])+')';
{    _A_INSERTA_ASIENTO_RECEPTOR = 'INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,NOMBRE_PASAJERO, '+
                                  '  TERMINAL_RESERVACION, TRAB_ID, ORIGEN, DESTINO,STATUS) '+
                                  'VALUES(''%s'',''%s'',%s,''%s'',''%s'',''%s'',''%s'',''%s'',''%s'')';}
                if EjecutaSQL(sentencia,lq_qry,_LOCAL) then begin
                    actualizaBoletoAgrupado(ls_corrida, ls_fecha_receptor, la_datos[4],
                                            la_datos[5], la_datos[0],
                                            la_datos[3],'', 0);
{                    hilo_asiento := Libera_Asientos.Create(true);
                    hilo_asiento.server := dm.Conecta;
                    hilo_asiento.sentenciaSQL := sentencia;
                    hilo_asiento.ruta   := StrToInt(Grid.Cols[_COL_RUTA].Strings[grid.Row]);
                    hilo_asiento.origen := la_datos[4];
                    hilo_asiento.destino := la_datos[5];
                    hilo_asiento.Priority := tpNormal;
                    hilo_asiento.FreeOnTerminate := True;
                    hilo_asiento.start;}
                end;
            end else begin
                        la_nuevos_asientos[li_nuevos] := ls_corrida+'|'+
                                          ls_fecha_receptor+'|'+la_datos[0]+'|'+
                                          la_datos[1]+'|'+la_datos[2]+'|'+la_datos[3]+'|'+
                                          la_datos[4]+'|'+la_datos[5]+'|'+la_datos[6];
                        inc(li_nuevos);
            end;
        end;//fin for
//recorremos el numero de asientos para ver su disponibilidad e insertar el asiento
        li_anterior := 1;
        for li_idx := 0 to li_nuevos - 1 do begin
            splitLine(la_nuevos_asientos[li_idx],'|',la_datos,li_num);
            li_opcion_fecha_string := 0;
            for li_nuev_asientos := li_anterior to lugares do begin
//insertamos el nuevo asiento si no esta ocupado
                if not verificaDisponibles(IntToStr(li_nuev_asientos),ls_fecha_receptor,ls_corrida) then begin

                sentencia := 'INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,NOMBRE_PASAJERO, '+
                             '  TERMINAL_RESERVACION, TRAB_ID, ORIGEN, DESTINO,STATUS) '+
                             'VALUES('+QuotedStr(la_datos[0])+','+QuotedStr(copy(la_datos[1],1,10) + ' 00:00')+','+
                             IntToStr(li_nuev_asientos)+','+QuotedStr(la_datos[3])+','+
                             QuotedStr(la_Datos[4])+','+
                             QuotedStr(la_datos[5])+','+QuotedStr(la_datos[6])+','+QuotedStr(la_datos[7])+','+QuotedStr(la_datos[8])+')';
                    if EjecutaSQL(sentencia,lq_qry,_LOCAL) then begin
//actualizamos el boleto con la nueva corrida, asiento
                    actualizaBoletoAgrupado(la_datos[0], la_datos[1], la_datos[6],
                                            la_datos[7],la_datos[2],
                                            la_datos[5], IntToStr(li_nuev_asientos), 1);
                        li_anterior := li_nuev_asientos;
{                        hilo_asiento_nuevo := Libera_Asientos.Create(true);
                        hilo_asiento_nuevo.server := dm.Conecta;
                        hilo_asiento_nuevo.sentenciaSQL := sentencia;
                        hilo_asiento_nuevo.ruta   := StrToInt(Grid.Cols[_COL_RUTA].Strings[grid.Row]);
                        hilo_asiento_nuevo.origen := la_datos[4];
                        hilo_asiento_nuevo.destino := la_datos[5];
                        hilo_asiento_nuevo.Priority := tpNormal;
                        hilo_asiento_nuevo.FreeOnTerminate := True;
                        hilo_asiento_nuevo.Start;}
                        break;
                  end;//fin if
                end;//fin if verificaDisponibles
            end;//fin for
        end;//fin for
      splitLine(Grid.Cols[_COL_HORA].Strings[grid.row], ' ', la_datos,
        li_num);
      if li_num = 0 then // 0
        ls_hora := la_datos[0]
      else
        ls_hora := la_datos[1];
        if EjecutaSQL(Format(_UPDATE_CORRIDA_D,['C','NULL',
                              grid.Cols[_COL_CORRIDA].Strings[Grid.Row],// copy(la_datos[1],1,10),
                              formatDateTime('YYYY-MM-DD',StrToDate(grid.Cols[_COL_FECHA].Strings[Grid.Row])),
                              gs_terminal,Grid.Cols[_COL_HORA].Strings[grid.row],
                              Grid.Cols[_COL_RUTA].Strings[Grid.Row] ]),lq_qry,_LOCAL) then
        begin
          li_agrupa_corrida := 1;
          Mensaje(_MSG_AGRUPADA_OK,0);
        end;

    finally
        sentencia := 'UPDATE PDV_T_ASIENTO SET NOMBRE_PASAJERO = NULL, TERMINAL_RESERVACION = NULL '+
                     'WHERE NOMBRE_PASAJERO = '+ QuotedStr('NULL');
        if EjecutaSQL(sentencia,lq_qry,_LOCAL) then begin

        end;


        lq_qry.free;
        lq_qry := nil;
    end;

end;

procedure HoraEntradaEdit(var Ed_Hora : TEdit);
  var
    ls_input, ls_out: string;
    li_ctrl, li_copia: Integer;
    lc_char: Char;
    li_24: Integer;
  begin
    ls_input := Ed_Hora.Text;
    li_24 := 0;
    for li_ctrl := 1 to length(ls_input) do
    begin
      lc_char := ls_input[li_ctrl];
      if not((lc_char in ['0' .. '9']) or (lc_char = ':')) then
      begin
        Ed_Hora.Clear;
        Ed_Hora.SetFocus;
        Break;
      end;
      li_24 := StrToInt(ls_input[1]);
      if li_24 > 2 then
      begin
        Ed_Hora.Clear;
        Ed_Hora.SetFocus;
        Break;
      end;
      case li_24 of
        0:
          li_24 := 1;
        1:
          li_24 := 2;
        2:
          li_24 := 3;
      end;
      if length(ls_input) = 2 then
      begin
        if (li_24 = 3) and (StrToInt(ls_input[2]) > 3) then
        begin
          for li_copia := 1 to length(ls_input) - 1 do
          begin
            ls_out := ls_out + ls_input[li_copia];
          end; // fin for
          Ed_Hora.Text := ls_out;
          Ed_Hora.SelStart := length(ls_out);
          Break;
        end
        else
        begin
          Ed_Hora.Text := Ed_Hora.Text + ':';
          Ed_Hora.SelStart := length(Ed_Hora.Text);
          Break;
        end;
      end; // fin length
      if length(ls_input) = 4 then
      begin
        if StrToInt(ls_input[4]) > 5 then
        begin
          for li_copia := 1 to length(ls_input) - 1 do
          begin
            ls_out := ls_out + ls_input[li_copia];
          end; // fin for
          Ed_Hora.Text := ls_out;
          Ed_Hora.SelStart := length(ls_out);
          Break;
        end; // fin if
      end;
      if length(ls_input) > 5 then
      begin
        for li_copia := 1 to length(ls_input) - 1 do
        begin
          ls_out := ls_out + ls_input[li_copia];
        end; // fin for
        Ed_Hora.Text := ls_out;
        Ed_Hora.SelStart := length(ls_out);
        Break;
      end;
    end;
end;

procedure ValidaFormatoHora(var Ed_Hora : TEdit);
begin
    if length(Ed_Hora.Text) < 5 then begin
        Mensaje('El formato de la hora es incorrecto',1);
        Ed_Hora.SetFocus;
        Ed_Hora.SelStart := Length(Ed_Hora.Text);
        exit;
    end;
end;


function GridCorridaActualNueva(renglon : integer; Grid : TStringGrid) : integer;
var
    li_ctrl, li_out : integer;
begin
    for li_ctrl := renglon to Grid.RowCount -1 do begin
        if ((Grid.Cols[_COL_HORA].Strings[li_ctrl] = hora_agrupada) and
            (Grid.Cols[_COL_FECHA].Strings[li_ctrl] = fecha_agrupada) and
            (Grid.Cols[_COL_CORRIDA].Strings[li_ctrl] = corrida_agrupada))  then begin
            li_out := li_ctrl;
            break;
        end;
    end;
    Result := li_out;
end;

function existeVentaDeCorrida(fecha_inicio, fecha_fin : TDate;
                              Corrida : String; servicio : integer) : integer;
var
   store : TSQLStoredProc;
begin
   store := TSQLStoredProc.Create(nil);
   try
       store.SQLConnection := CONEXION_VTA;
       store.close;
       store.StoredProcName := 'PDV_HAY_VENTA_PARA';
       store.Params.ParamByName('_FECHA_INICIO').AsDate := Trunc(fecha_inicio);
       store.Params.ParamByName('_FECHA_FIN').AsDate := Trunc(fecha_fin);
       store.Params.ParamByName('_ID_CORRIDA').AsString := Corrida;
       store.Params.ParamByName('_TIPOSERVICIO').AsInteger := servicio;
       store.Open;
       store.First;
       Result := store['TOTAL'];
   finally
     store.Free;
     store := nil;
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
{        store.StoredProcName := 'PDV_STORE_TARIFA';
        store.ParamByName('IN_ORIGEN').AsString := origen;
        store.ParamByName('IN_DESTINO').AsString := Grid.Cols[_COL_DESTINO].Strings[Grid.Row];
        store.ParamByName('IN_ABREVIA').AsString := Grid.Cols[_COL_SERVICIO].Strings[Grid.Row];}
        store.close;
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

function tarifaCorrida(Grid : TStringGrid; origen : String) : real;
var
    li_ctrl : integer;
    ld_tarifa : real;
    store : TSQLStoredProc;
begin
        store := TSQLStoredProc.Create(nil);
        store.SQLConnection :=CONEXION_VTA;
        store.close;
        store.StoredProcName := 'PDV_STORE_TARIFA';
        store.ParamByName('IN_ORIGEN').AsString := origen;
        store.ParamByName('IN_DESTINO').AsString := Grid.Cols[_COL_DESTINO].Strings[Grid.Row];
        store.ParamByName('IN_ABREVIA').AsString := Grid.Cols[_COL_SERVICIO].Strings[Grid.Row];
        store.Open;
        if not store.IsEmpty then
            ld_tarifa := store['MONTO']
        else
            ld_tarifa := 0;
    store.Free;
    store := nil;
    Result := ld_tarifa;
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
//ga_lugares_bus
end;

procedure obtenPeriodoVacacional();
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    try
        if EjecutaSQL(_PERIODO_VACACIONAL,lq_qry,_LOCAL) then begin
          if not VarIsNull(lq_qry['FECHA_INICIO']) then begin
            gd_vacacional_inicio := lq_qry['FECHA_INICIO'];
            gd_vacacional_fin    := lq_qry['FECHA_FIN'];
          end;
        end;
    finally
      lq_qry.Free;
      lq_qry := nil;
    end;
end;



procedure guardarVersion(version : string);
var
    lq_qry : TSQLQuery;
    ls_ip, ls_version : string;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
//     _VERSION_APLICACION = 'UPDATE PDV_C_TAQUILLA SET VERSION = ''%s'' WHERE ID_TERMINAL = ''%s'' AND  ID_TAQUILLA = ''%s'' AND IP = ''%s'' ';
    ls_ip := getiplist();
    ls_version := version;
    try
        if EjecutaSQL(Format(_V_APLICACION,[ls_version, gs_terminal, gs_maquina, ls_ip]), lq_qry, _LOCAL) then
            ;
    finally
        lq_qry.Free;
        lq_qry := nil;
    end;
end;


function EstaEnPeriodoVacacional(fecha_actual : String) : integer;
var
    li_out : integer;
begin
    li_out := 0;
    if Length(gd_vacacional_inicio) > 0 then begin
        if (StrToDate(gd_vacacional_inicio) <= StrToDate(fecha_actual)) and
           (StrToDate(gd_vacacional_fin) >= StrToDate(fecha_actual))  then
            li_out := 1;
    end;
    result := li_out;
end;


procedure guardamosAutobus;
var
    h      : THandle;
    bitmap : TBitmap;
    lq_qry : TSQLQuery;
    img_pnl: TImage;
    li_ctrl : integer;
begin
    try
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        lq_qry.SQL.Clear;
        lq_qry.SQL.Add('SELECT ID_TIPO_AUTOBUS,NOMBRE_IMAGEN, ASIENTOS FROM PDV_C_TIPO_AUTOBUS');
        lq_qry.Open;
        lq_qry.First;
        h := LoadLibrary(_LIBRARYNAME);
        if h <> 0 then begin
          li_ctrl := 1;
          while not lq_qry.Eof do begin
            lq_qry.DisableControls;
            try
              bitmap := TBitmap.Create;
              bitmap.LoadFromResourceName(h,lq_qry['NOMBRE_IMAGEN']);
               imagenes_autobuses[li_ctrl]:=TImage.Create(nil);
               imagenes_autobuses[li_ctrl].AutoSize := True;
               imagenes_autobuses[li_ctrl].Height := bitmap.Height;
               imagenes_autobuses[li_ctrl].Width:=  bitmap.Width;
               imagenes_autobuses[li_ctrl].Visible:= True;
               imagenes_autobuses[li_ctrl].Stretch:= True;
               imagenes_autobuses[li_ctrl].Name:= lq_qry['NOMBRE_IMAGEN'];
               imagenes_autobuses[li_ctrl].Picture.Bitmap :=  bitmap;
               Inc(li_ctrl);
            finally
              bitmap.free
            end;
            lq_qry.Next;
            lq_qry.EnableControls;
          end;
        end;
    finally
      lq_qry.destroy;
      lq_qry := nil;
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


procedure muestraAsientosArreglo(labels : labels_asientos; id_bus : integer; panel : TPanel);
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
            labels[li_ctrl_asiento]^.visible := True;
            labels[li_ctrl_asiento]^.Parent := panel;
            Inc(li_ctrl_asiento);
        end;
    end;
end;


procedure asientosOcupados(labels : labels_asientos; ld_fecha : TDate; lt_hora : TTime;
                           ls_corrida : string);
var
    store : TSQLStoredProc;
    lc_tipo : Char;
    ls_hora : string;
begin
    ls_hora := FormatDateTime('YYYY-MM-DD',ld_fecha); // +' 00:00'; //+ FormatDateTime('HH:MM:SS', lt_hora);
    Store := TSQLStoredProc.Create(nil);
    try
      Screen.Cursor:=crDefault;
      Store.SQLConnection := CONEXION_VTA; //DM.Conecta;
      store.close;
      store.StoredProcName := 'PDV_STORE_ASIENTOS_DISPONIBLES';
      store.Params.ParamByName('IN_CORRIDA').AsString := ls_Corrida;
      store.Params.ParamByName('FECHA_INPUT').AsString  := ls_hora;
      store.Params.ParamByName('IN_PIE').AsInteger := gi_vta_pie;
      store.Open;
      store.First;
      store.DisableControls;
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
      store.EnableControls;
    finally
      store.Free;
      store := nil;
    end;
end;


procedure asignaVenta(trabid, terminal : string; taquilla:integer);
var
    store : TSQLStoredProc;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.close;
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


function estatus_corrida(corrida, fecha : string) : string;
var
    store : TSQLStoredProc;
    ls_out : string;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.close;
        store.StoredProcName := 'PDV_STORE_ESTATUS_CORRIDA';
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        store.Params.ParamByName('IN_FECHA').AsString   := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
        store.Open;
        ls_out := store['ESTATUS'];
    finally
        store.Free;
        store := nil;
    end;
    Result := ls_out;
end;


function total_pasajeros_corrida(corrida, fecha : String) : integer;
var
    store : TSQLStoredProc;
    li_out : integer;
begin
    store := TSQLStoredProc.Create(nil);
    try
        store.SQLConnection := CONEXION_VTA;
        store.close;
        store.StoredProcName := 'PDV_STORE_TOTAL_PAX';
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        store.Params.ParamByName('IN_FECHA_INPUT').AsString := fecha;
        store.Open;
        li_out := store['TOTAL'];
    finally
        store.Free;
        store := nil;
    end;
    Result := li_out;
end;


function conexionServidorRemoto(terminal : string) : TSQLConnection;
var
    lq_query : TSQLQuery;
    lb_out   : Boolean;
    ls_ip    : string;
    ls_usuario : string;
    ls_password : string;
begin
    lq_query := TSQLQuery.Create(nil);
    CONEXION_REMOTO := TSQLConnection.Create(nil);
    try
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(_CONECTA_TERMINAL,[terminal]),lq_query,_LOCAL) then begin
          if not VarIsNull(lq_query['IPv4']) then begin
             try
                ls_ip := lq_query['IPv4'];
                ls_usuario := lq_query['BD_USUARIO'];
                ls_password := lq_query['BD_PASSWORD'];
                CONEXION_REMOTO.Close;
                CONEXION_REMOTO.DriverName := _DRIVER;
                CONEXION_REMOTO.Params.Values['HOSTNAME']  := ls_ip;  //lq_query['IPv4'];
                CONEXION_REMOTO.Params.Values['DATABASE']  := _BASE;
                CONEXION_REMOTO.Params.Values['USER_NAME'] := ls_usuario;
                CONEXION_REMOTO.Params.Values['PASSWORD']  := ls_password;
                CONEXION_REMOTO.LoginPrompt := False;
                CONEXION_REMOTO.Connected := True;
                lb_out := True;
              except
                  on E : Exception do begin
                    Mensaje('No existe conexion al servidor: '+terminal+#10#13+'Reportelo al area del sistemas',0);
                    ErrorLog(E.Message,'No se puede conectar a el server: '+#10#13+  lq_query['IPV4']);//escribimos al archivo
                    CONEXION_REMOTO.Connected := False;
                    lb_out := False;
                  end;
              end;
          end else begin
                    Mensaje('No existe conexion al servidor: '+terminal+#10#13+'Reportelo al area del sistemas',0);
                    ErrorLog('No se puede conectar a el server : ', terminal );//escribimos al archivo
                    CONEXION_REMOTO.Connected := False;
          end;//fin null
        end else lb_out := False;
    finally
        lq_query.free;
        lq_query := nil;
    end;
    Result := CONEXION_REMOTO;
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
    finally
      lq_qry.Free;
      lq_qry := nil;
    end;
    Result := ls_qry;
end;

function getParametroItaca : integer;
var
    lq_qry : TSQLQuery;
    ls_qry : String;
    li_out : integer;
begin
    ls_qry := 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 15';
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

function getPrinterBoleto  : integer;
var
    lq_qry : TSQLQuery;
    ls_qry : string;
    li_out : integer;
begin
    ls_qry := 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 17';
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


end.

