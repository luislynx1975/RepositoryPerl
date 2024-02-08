//////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Comun                                                         //
//  Pantalla:                                                                  //
//  Descripción:                                                               //
//  Fecha:       16 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
/////////////////////////////////////////////////////////////////////////////////
unit comun;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    windows, Classes, DB, SysUtils, Grids, Forms,Dialogs,  ActnList, lsCombobox,Variants,
    ExtCtrls, Graphics, WinSock, SqlExpr, DBXMySql, TRemotoRuta,  Printers, Winspool,
    Math, IniFiles, StdCtrls, ActiveX, System.win.ComObj, Vcl.Clipbrd,  uLitteScreen;

Const
    _TAB = #9;
    c1 = 52845;
    c2 = 22719;
    miKey = 9934;
    LARRAY_     = 50;
    _LOCAL      = -1;
    _RUTA       = 0;
    _ALL        = 'TODAS';
    _TODOS      = -2;
    _SERVIDOR_CENTRAL = -3;
    _LOG = 'pdv-errLog.log';//para registrar los errores del sistema
    _BOLETOS = 'boletaje.log';
    _OK = 64;
    _ERROR = 16;
    _ATENCION = MB_ICONWARNING;
    _CONFIRMAR = MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1;
    _ERR_SQL = 'Ocurrió un error, reporte este ' + #10#13 + 'mensaje a su administrador';// : %s';
    _ACTIVO = 'A';

    _AUTOMATICO = '000000';
    _PREGUNTA_ELIMINA='¿Realmente desea eliminar la ' + #10#13 + ' información mostrada en pantalla?';
    _NO_AFECTA_REMOTO = 0;
    _OPERACION_SATISFACTORIA='La operación se realizo ' + #10#13 + ' satisfactoriamente.';
    _INFORMACION_INSUFICIENTE= 'Falta información requerida para continuar.';
    _INFORMACION_EXISTENTE= 'La informacion capturada ya existe en la ' + #10#13 + ' Base de Datos.';
    _AGREGAR_INFORMACION='¿Realmente desea insertar ' + #10#13 + ' los datos capturados?';
    _ACTUALIZAR_INFORMACION= '¿Realmente desea actualizar ' + #10#13 + ' los datos capturados?';
    _INFORMACION_NO_EXISTE='La información solicitada no existe.';
    _AGREGAR_TRAMOS='¿Deseas agregar los tramos a esta ruta?';
    _IMPRIMIR_BOLETO = '¿Deseas asignar la venta anticipada a estos asientos?';
    _ACTUALIZAR_DATO    = 'Desea actualizar la informacion ' + #10#13 + '%s';
    _ACTUALIZAR_AUTOBUS = 'Si actualiza el autobus esto afectara ' + #10#13 +
                          'para todos los lugares de venta ';
    _ELIMINAR_REGISTRO  = 'Desea eliminar el registro ' + #10#13 + ' %s';
    _ACTUALIZAR_EMPLEADO = 'Desea actualizar el estatus del usuario ' + #10#13 + ' %s';
    _NO_GUARDO_DATO     = 'La informacion no fue registrada reportelo al ' + #10#13 + ' administrador';
    _INFORMACION_UPDATE = 'Se actualizo correctamente';

    _PASSWORD_DENEGADO  = 'El usuario no tiene permisos para ' + #10#13 + ' %s';
    _LIMITE_EXCEDIDO    = 'La longitud se ha excedido';
    _LIBRARYNAME = 'ImagesBuses.dll';
    _MSG_EXPORTADO = 'La información fue copiada a memoria.' + #10#13 + 'Abra una hoja de cálculo y pegue (CTRL+V) la información.';

    _VTA_TERMINALES_ORIGEN  = 'SELECT T.ID_TERMINAL, DESCRIPCION '+
                              'FROM PDV_C_TERMINAL K INNER JOIN T_C_TERMINAL T ON T.ID_TERMINAL = K.ID_TERMINAL '+
                              'WHERE K.ESTATUS = ''A'' AND K.ID_TERMINAL IN (SELECT ID_TERMINAL '+
                              'FROM T_C_TERMINAL T '+
                              'WHERE T.EMPRESA IN (SELECT EMPRESA FROM T_C_TERMINAL C WHERE AUTO = ''A'' AND ID_TERMINAL = ''%s'') ) '+
                              'UNION '+
                              'SELECT ID_TERMINAL, DESCRIPCION '+
                              'FROM T_C_TERMINAL '+
                              'WHERE ID_TERMINAL = ''%s'' '+
                              'ORDER BY 1';


    _TERMINAL_BAJA = 'SELECT P.ID_TERMINAL FROM PDV_C_TERMINAL P INNER JOIN T_C_TERMINAL T ON T.ID_TERMINAL = P.ID_TERMINAL '+
                     'WHERE ESTATUS = ''A'' ';

    _AGE_TODAS = 'SELECT NOMBRE,ASIENTO_INICIAL,ASIENTO_FINAL,ID_AGENCIA FROM PDV_C_AGENCIA ';
    _PASSWORD  = '#<m1&/%?.@56\@)e>$*,!--//&--,*54°\?¡2r$_1@<73$:t#<%9 "#(. &-8&#(%@&35$*,--& /1/-)-,*$0&%#';
    _OBTIENE_ASIENTO_AGENCIA = 'SELECT ASIENTO_INICIAL, ASIENTO_FINAL FROM PDV_C_AGENCIA '+
                               'WHERE ID_AGENCIA = ''%s'' ';
    _OBTIENE_HORA_APAGADO = 'SELECT TIEMPO_APAGADO FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND ID_TAQUILLA = %s AND IP = ''%s''';
    _VALIDA_PARA_APAGAR = 'SELECT APAGADO FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND ID_TAQUILLA = %s AND IP = ''%s'' ';
    _INSERT_FOLIO_INICIAL = 'INSERT INTO PDV_FOLIOS(ID_CORTE, TRAB_ID, FOLIO_INICIAL_B, FOLIO_INICIAL, FOLIO_FINAL_B) '+
                            'VALUES(%s, ''%s'', ''%s'', NOW(), 0)';
    _UPDATE_FOLIO_FINAL = 'UPDATE PDV_FOLIOS SET FOLIO_FINAL_B = %s, FOLIO_FINAL = NOW() '+
                          'WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND SERIAL = %s ';
    _FOLIO_EXISTE =    'SELECT COUNT(*) AS FOLIO FROM PDV_FOLIOS_GENERAL WHERE TRAB_ID = ''%s'' AND '+
                       'ID_CORTE = %s AND FOLIO = ''%s'' ';
    _OBTEN_SRIAL_CORTE = 'SELECT (MAX(SERIAL))AS SERIAL FROM PDV_FOLIOS '+
                        'WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND FOLIO_FINAL_B = 0';
    _CONSIGE_TAQUILLA = 'SELECT ID_TAQUILLA, IFNULL(IMP_BOLETO,0)AS IMP_BOLETO, '+
                        'IFNULL(IMP_OPCIONAL,0)AS IMP_OPCIONAL,  '+
                        'IFNULL(TARJETA_FISICA,0)AS TARJETA_FISICA,  '+
                        'IFNULL(APAGADO,0)AS APAGADO,  '+
                        'IFNULL(CARGA_FINAL,0)AS CARGA_FINAL,  '+
                        'IFNULL(TIEMPO_APAGADO,''00:00:00'')AS TIEMPO_APAGADO,  '+
                        'IFNULL(PUERTO_BOLETO,0)AS PUERTO_BOLETO,  '+
                        'IFNULL(PUERTO_OPCIONAL,0)AS PUERTO_OPCIONAL, '+
                        'IFNULL(SECURE_ACCES,0)AS SECURE_ACCES, '+
                        'IFNULL(OPERACION_REMOTA,0)AS OPERACION_REMOTA,  '+
                        'IFNULL(BOLETO_TAMANO,0)AS BOLETO,  '+
                        'IFNULL(CONTINUO, 0) AS CONTINUO '+
                        'FROM PDV_C_TAQUILLA WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
    _INSERTA_RECO_FOLIO = 'INSERT INTO PDV_FOLIOS_GENERAL(ID_CORTE,TRAB_ID,FOLIO,FECHA_REGISTRO,TIPO_FOLIO) '+
                        'VALUES(%s,''%s'',%s,NOW(),''%s'')';
    _EXISTE_FOLIO_GENERAL = 'SELECT COUNT(*)AS TOTAL FROM PDV_FOLIOS_GENERAL '+
                        'WHERE TRAB_ID = ''%s'' AND ID_CORTE = %s AND FOLIO = %s AND TIPO_FOLIO = ''%s'' ';

    _INS_PARA19 = 'INSERT INTO PDV_C_PARAMETRO VALUES(19,"Bloque de boletos",700) ';
    _BUSCA_PARA19 = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 19';
    _IMPRESORA_BOLETOS = 'SELECT IMP_BOLETO FROM PDV_C_TAQUILLA WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
    _BOLETOS_BLANCO = 'SELECT FOLIO FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND TIPO_FOLIO = ''B'' ';

    _PARAMETRO_26 = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 26';

    _TAQUILLA_CONEXION = 'SELECT T.CONEXION_CENTRAL FROM PDV_C_TAQUILLA T WHERE T.ID_TERMINAL = ''%s'' AND T.ID_TAQUILLA = %s AND T.IP = ''%s'' ';

    _VALIDO_FOLIO = 'SELECT (IF(%s > FOLIO_INICIAL_B + VALOR, 1,0)) AS VALIDO, '+
                    '(IF(%s < FOLIO_INICIAL_B + VALOR, 1,0))AS MENOR, '+
                    '(IF(%s < FOLIO_INICIAL_B + VALOR, 1,0))AS PERMITIDO '+
                    'FROM PDV_FOLIOS, PDV_C_PARAMETRO WHERE ID_CORTE = %s AND TRAB_ID = ''%s''  AND ID_PARAMETRO = 19 '+
                    'AND SERIAL = %s AND %s > FOLIO_INICIAL_B';

    _BORRA_FOLIO_BLANCO  = 'DELETE FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND FOLIO = ''%s'' AND TIPO_FOLIO = ''B'' ';

    _OBTEN_FOLIOS_USER = 'SELECT FOLIO FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND TIPO_FOLIO = ''B'' ';

    _CHECA_CORTE_P = 'SELECT (COUNT(ID_CORTE))AS TOTAL, ID_CORTE FROM PDV_T_CORTE WHERE ID_EMPLEADO = ''%s'' AND '+
                     'ESTATUS = ''P'' AND ID_TERMINAL = ''%s'' GROUP BY ID_CORTE';

    _OBTEN_DATOS_CORTE = 'SELECT (COUNT(*))AS NUMERO, COALESCE(SUM(IMPORTE),0)AS TOTAL FROM PDV_T_RECOLECCION '+
                         'WHERE ID_CORTE = %s AND ID_EMPLEADO = ''%s'' ';

    _OBTEN_RECOLECCION = 'SELECT SUM(IMPORTE)AS IMPORTE FROM PDV_T_RECOLECCION WHERE ID_CORTE = %s AND ID_EMPLEADO = ''%s'' AND ID_TERMINAL = ''%s'' ';
    _OBTEN_TOTAL_RECOLECCION = 'SELECT COUNT(*) AS TOTAL FROM PDV_T_RECOLECCION WHERE ID_CORTE = %s AND ID_EMPLEADO = ''%s'' AND ID_TERMINAL = ''%s'' ';

    _OBTEN_TOTAL_TICKETS_BMX = 'SELECT COUNT(DISTINCT(TC))AS TOTAL '+
                      'FROM PDV_T_BOLETO B '+
                      'WHERE B.TRAB_ID = ''%s'' AND '+
                      'B.FECHA_HORA_BOLETO BETWEEN (SELECT FECHA_INICIO '+
                      'FROM PDV_T_CORTE C '+
                      'WHERE C.ID_CORTE = %s) AND '+
                      'NOW() AND B.ID_FORMA_PAGO = 8 AND B.ESTATUS = ''V'' ';

    _OBTEN_TOTAL_TARIFA_BMX = 'SELECT SUM(B.TARIFA)AS TOTAL '+
                      'FROM PDV_T_BOLETO B '+
                      'WHERE B.TRAB_ID = ''%s'' AND '+
                      'B.FECHA_HORA_BOLETO BETWEEN (SELECT FECHA_INICIO '+
                      'FROM PDV_T_CORTE C '+
                      'WHERE C.ID_CORTE = %s) AND '+
                      'NOW() AND B.ID_FORMA_PAGO = 8 AND B.ESTATUS = ''V'' ';

    _OBTEN_TOTAL_BOLETOS_BMX = 'SELECT COUNT(TARIFA)AS TOTAL '+
                      'FROM PDV_T_BOLETO B '+
                      'WHERE B.TRAB_ID = ''%s'' AND '+
                      'B.FECHA_HORA_BOLETO BETWEEN (SELECT FECHA_INICIO '+
                      'FROM PDV_T_CORTE C '+
                      'WHERE C.ID_CORTE = %s) AND '+
                      'NOW() AND B.ID_FORMA_PAGO = 8 AND B.ESTATUS = ''V'' ';

    _OBTEN_TOTAL_CANCELADO = 'SELECT COUNT(*)AS TOTAL '+
                             'FROM PDV_T_BOLETO_CANCELADO B '+
                             'WHERE TRAB_ID_CANCELADO = ''%s'' AND B.FECHA_HORA_CANCELADO BETWEEN '+
                             '(SELECT C.FECHA_INICIO FROM PDV_T_CORTE C WHERE id_corte = %s)  AND NOW()';



    _OBTEN_FONDO_I = 'SELECT FONDO_INICIAL FROM PDV_T_CORTE WHERE ID_CORTE = %s AND ID_EMPLEADO = ''%s'' ';

    _INSERTA_PRECORTE = 'INSERT INTO PDV_T_PRECORTE(ID_CORTE,TRAB_ID,FONDO_INICIAL,BOL_CANCELADOS, NO_RECOLECCION, '+
                        'TOTAL_RECOL, FECHA, BAN_TICKETS, BAN_IMPORTE, BAN_BOLETOS) '+
                        'VALUES(%s, ''%s'', %s, %s, %s, %s, now(), %s, %s, %s)';

    _OBTEN_PRECORTE = 'SELECT ID_CORTE, FONDO_INICIAL, BOL_CANCELADOS,NO_RECOLECCION, '+
                      '       TOTAL_RECOL, TOTAL_EFECTIVO, APA, ORD100,ORD50, SEDENA, '+
                      '       TICKETBUS,FAM, IXE_BOLETOS, IXE_TICKETS, IXE_IMPORTE, '+
                      '       BAN_BOLETOS, BAN_TICKETS, BAN_IMPORTE, SEDENA2, FAM2,PAS_TRAS, TURNO, AGE_NCIA, PRO_ROLLO, PAS_TCC '+
                      'FROM PDV_T_PRECORTE WHERE TRAB_ID = ''%s'' AND ID_CORTE = %s';


    _OBTEN_BANAMEX_DATOS = 'SELECT COUNT(DISTINCT(B.ID_PAGO_PINPAD_BANAMEX))AS TOTAL_TICKETS, COALESCE(SUM(B.TARIFA),0)AS TOTAL_IMPORTE '+
                           'FROM PDV_T_BOLETO B '+
                           'WHERE B.TRAB_ID = ''%s'' AND B.FECHA_HORA_BOLETO BETWEEN ( '+
                           ' SELECT C.FECHA_INICIO '+
                           ' FROM PDV_T_CORTE C '+
                           ' WHERE C.ID_EMPLEADO = ''%s'' AND C.ID_CORTE = %s ) '+
                           'AND NOW() AND B.ID_FORMA_PAGO = 8 AND B.ESTATUS = ''V'' ';

    _OBTEN_BANAME_TOTAL_BOLETOS = 'SELECT COUNT(*)AS TOTAL FROM PDV_T_BOLETO B '+
                           'WHERE B.TRAB_ID = ''%s'' AND B.FECHA_HORA_BOLETO BETWEEN ( '+
                           'SELECT C.FECHA_INICIO '+
                           'FROM PDV_T_CORTE C '+
                           'WHERE C.ID_EMPLEADO = ''%s'' AND C.ID_CORTE = %s ) '+
                           'AND NOW() AND B.ID_FORMA_PAGO = 8 AND B.ESTATUS = ''V'' ';

    _OBTEN_IXE_TOTAL_BOLETOS = 'SELECT COUNT(*)AS TOTAL FROM PDV_T_BOLETO B '+
                           'WHERE B.TRAB_ID = ''%s'' AND B.FECHA_HORA_BOLETO BETWEEN ( '+
                           'SELECT C.FECHA_INICIO '+
                           'FROM PDV_T_CORTE C '+
                           'WHERE C.ID_EMPLEADO = ''%s'' AND C.ID_CORTE = %s ) '+
                           'AND NOW() AND B.ID_FORMA_PAGO = 2 AND B.ESTATUS = ''V'' ';

    _OBTEN_PROMOTOR = 'SELECT TRAB_ID, CONCAT(PATERNO,'' '',MATERNO,'' '',NOMBRES) AS PROMOTOR '+
                      'FROM EMPLEADOS WHERE TRAB_ID = ''%s'' ';

    _OBTEN_FONDO = 'SELECT FONDO_INICIAL FROM PDV_T_CORTE WHERE ID_EMPLEADO = ''%s'' AND ID_CORTE = %s AND ID_TERMINAL = ''%s'' ';

    _OBTEN_BOLCANCE = 'SELECT COUNT(*)AS TOTAL FROM PDV_T_BOLETO_CANCELADO '+
                   'WHERE FECHA_HORA_CANCELADO BETWEEN ('+
                   'SELECT FECHA_INICIO FROM PDV_T_CORTE WHERE ID_CORTE = %s) AND '+
                   '(NOW() ) AND TRAB_ID_CANCELADO = ''%s'' AND ID_TERMINAL = ''%s'' ';

    _UPDATE_PRECORTE = 'UPDATE PDV_T_PRECORTE SET FONDO_INICIAL = %s, BOL_CANCELADOS = %s,  NO_RECOLECCION = %s, TOTAL_RECOL = %s, '+
                   'TOTAL_EFECTIVO = %s, APA = %s, ORD100 = %s, ORD50 = %s, SEDENA = %s, '+
                   'SEDENA2 = %s, TICKETBUS = %s, FAM = %s, FAM2 = %s, IXE_BOLETOS = %s, IXE_TICKETS = %s, IXE_IMPORTE = %s, '+
                   'BAN_BOLETOS = %s, BAN_TICKETS = %s, BAN_IMPORTE = %s, TURNO = ''%s'', PAS_TRAS = %s, AGE_NCIA = %s, '+
                   'PRO_ROLLO = %s, PAS_TCC = %s '+
                   'WHERE ID_CORTE = %s and TRAB_ID = ''%s'' ';

    _VERIFICA_FOLIO_FINAL = 'SELECT (FOLIO_FINAL_B) AS VALIDO FROM PDV_FOLIOS '+
                   'WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND SERIAL = ( '+
                   'SELECT MAX(SERIAL) FROM PDV_FOLIOS WHERE ID_CORTE = %s AND TRAB_ID = ''%s'') ';

    _INSERT_FOLIOS = 'INSERT INTO PDV_FOLIOS(ID_CORTE, TRAB_ID, FOLIO_INICIAL_B, FOLIO_INICIAL, FOLIO_FINAL_B, FOLIO_FINAL) '+
                     'VALUES(%s, ''%s'', ''%s'', NOW(), ''%s'', NOW() )';

    _DELETE_FOLIOS = 'DELETE FROM PDV_FOLIOS WHERE ID_CORTE = %s and TRAB_ID = ''%s'' ';

    _DELETE_FOLIOS_GRAL = 'DELETE FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' ';


    _OBTEN_FOLIOS_TABLA = 'SELECT FOLIO_INICIAL_B, FOLIO_FINAL_B FROM PDV_FOLIOS WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' ';

    _OBTEN_RECOL_FOLIOS = 'SELECT FOLIO FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' AND TIPO_FOLIO = ''%s'' ';

    _NAME_PUERTO = 'SELECT DESCRIPCION FROM PDV_C_PUERTO WHERE ID_PUERTO = %s';

    _GET_MAXIMO_EVENTO = 'SELECT COALESCE( COUNT(*), 0)AS MAXIMO, '+
                         ' CONCAT(EXTRACT(YEAR_MONTH FROM CURRENT_DATE()), '+
                         ' CONCAT(repeat(''0'',2 - LENGTH( DAY( CURRENT_DATE() )  )), DAY( CURRENT_DATE() ) ) )AS REGISTRO '+
                         'FROM EVENTOS E '+
                         'WHERE DATE(E.FECHA_HORA) = CURRENT_DATE() AND E.TERMINAL = ''%s'' ';

    _INSERTA_EVENTO = 'INSERT INTO EVENTOS(ID_EVENTO, TERMINAL, TRAB_ID, EVENTO, FECHA_HORA) VALUES(%s, ''%s'', ''%s'', ''%s'', NOW() )';


    _DESTALLA_B_ABIERTO = 'SELECT B.ID_BOLETO, B.TRAB_ID, B.ID_TERMINAL, B.ORIGEN, B.DESTINO, '+
                          'B.TIPOSERVICIO, B.ID_RUTA, B.ID_OCUPANTE '+
                          'FROM PDV_T_REGISTRO_BOLETO_ABIERTO A INNER JOIN PDV_T_BOLETO B ON A.ID_BOLETO = B.ID_BOLETO AND '+
                          'A.TRAB_ID = B.TRAB_ID AND A.ID_TERMINAL = B.ID_TERMINAL '+
                          'WHERE CODIGO_BOLETO = ''%s'' ';


    _GROUP_BOLETO_ABIERTO = 'SELECT DESCRIPCION, COUNT(B.ID_OCUPANTE)AS CUANTOS '+
                          'FROM PDV_T_REGISTRO_BOLETO_ABIERTO A INNER JOIN PDV_T_BOLETO B ON A.ID_BOLETO = B.ID_BOLETO AND '+
                          'A.TRAB_ID = B.TRAB_ID AND A.ID_TERMINAL = B.ID_TERMINAL '+
                          'INNER JOIN PDV_C_OCUPANTE O ON O.ID_OCUPANTE = B.ID_OCUPANTE '+
                          'WHERE CODIGO_BOLETO = ''%s'' '+
                          'GROUP BY DESCRIPCION';

    _LONGITUD  = 1000;

    _COL_HORA     = 0;
    _COL_DESTINO  = 1;
    _COL_SERVICIO = 2;
    _COL_FECHA    = 3;
    _COL_TRAMO    = 4;
    _COL_RUTA     = 5;
    _COL_CORRIDA  = 6;
    _COL_AUTOBUS  = 7;
    _COL_NAME_IMAGE = 8;
    _COL_ASIENTOS = 9;
    _COL_TIPOSERVICIO = 10;
    _COL_CUPO     = 11;
    _COL_PIE      = 12;
    _COL_TARIFA = 13;
    _COL_IVA    = 14;

    _COL_STATUS   = 11;
    _COL_TRABID   = 11;//para liberar corridas

    _IMGLIST_WIDTH = 800;
    _IMGLIST_HEIGHT = 240;

//colores en los asientos del bus
    _ASIENTO_OCUPADO   = clRed;
    _ASIENTO_VENDIDO   = clBlue;
    _ASIENTO_RESERVADO = clGreen;
    _ASIENTO_APARTADO  = clMaroon;
    _ASIENTO_LIBRE     = clBlack;

//grid ocupantes
    _OCUPANTES_DESCRIBE = 0;
    _OCUPANTES_TOTAL    = 1;

//RECONOCIMIENTO DE TECLAS EN LA VENTA
    _TECLAS_ARRAY : array[1..10] of integer = (33,34,37,38,39,40,41,42,43,44);

    _TAG_VENTA = 111;
    _TAG_CANCELA_VENTA = 168;


    _VENTA_INICIO = 0;
    _VENTA_EFECTUADA = 1;
    _VENTA_CANCELADA = 1;
    _VENTA_ELIGE_OTRA = 2;

    //BASE DE DATOS
    _BASE_DE_DATOS = '';

//para la dll
//    dll = 'datamax.dll';

 //gilberto
    _ASIGNACION = 1;  // asignacion de una fecha cuando se esta abriendo por primera vez la forma
    _CAMBIO     = 2;  // cambio de la fecha ya que esta abierta la forma
    _CORTE_FIN_DIA    =   1;    // indica que la forma esta mostrando los cortes de fin de dia unicamente
    _CORTE_PASADO     =   2;    // indica que la forma esta mostrando los cortes pasados unicamente
///para conexiones foraneas
    _STORE_ERROR = 'No se efectuo la solicitud correctamente : %s'+#10#13 +
                   'notifiquelo al area de sistemas ';
    _KEY_INI  = 6474;
//    _VERSION = 1.06315; _FECHA_VERSION = '17-JUL-2013';
//    _VERSION = 1.064; _FECHA_VERSION = '13-AGO-2013';
//    _VERSION = 1.071; _FECHA_VERSION = '27-AGO-2013';
//    _VERSION = 1.071; _FECHA_VERSION = '27-AGO-2013';//correcion en el corte para todas las impresoras
//    _VERSION = 1.072; _FECHA_VERSION = '03-SEP-2013';//correcion en la impresion
//    _VERSION = 1.073; _FECHA_VERSION = '03-SEP-2013';//correcion en el tamaño de la hora a 38
//    _VERSION = 1.074; _FECHA_VERSION = '03-SEP-2013';//correcion en la taquilla borra la seleccionada
//    _VERSION = 1.0752 Eliminación del StringAlinGrid.  y ya compita el XE5
//    _VERSION = 1.0752; _FECHA_VERSION = '24-SEP-2013';//correcion para las formas de pago se modifica por la orden
//    _VERSION = 1.08; _FECHA_VERSION = '29-OCT-2013';//Se integra el valor agregado y para los pueblos magicos
//    _VERSION = 1.091; _FECHA_VERSION = '03-DIC-2013';//Se integra el COUNT boleto en C.I actualiza el precorte validacion
//    _VERSION = 1.0911; _FECHA_VERSION = '04-DIC-2013';//Se actualiza la replicacion y la preuba de impresion para todos los formato
//    _VERSION = 1.0912; _FECHA_VERSION = '04-DIC-2013';//correcion en la prueba de impresion
//    _VERSION = 1.0913;//coreccion de la impresion de carga inicial
//    _VERSION = 1.0914;//integracion para la impresion de la carga final al salir al corte
//    _VERSION = 1.0915;//correcion en los decimales en el precorte 09-DIC-2013
//    _VERSION = 1.0916;//Modificacion en tarifas con impuesto y impresion parametrizada del iva
//    _VERSION = 1.0917;//Integracion de la leyenda fiscal variables _LS_LEYENDA y _LS_LEYENDAR
//    _VERSION = 1.0919;//Corrección en la impresión del boleto con reservación
//    _VERSION = 1.0920;//Corrección en la llamada del store PDV_STORE_BOLETO_VENDIDO_IVA
//    _VERSION = 1.0921;//Corrección en la impresion con las leyendas de regimen fiscal
//    _VERSION = 1.0922;//Corrección en la impresion del codigo de barras en la impresora toshiba y ithaca
//    _VERSION = 1.0923;//implementacion de los corte la sumatoria de los impuestos
//    _VERSION = 1.0924;//Modificacion en los cortes para todos loc comisionistas
//    _VERSION = 1.0925;//secuencias de impresion para el  nuevo boleto '15-ENE-2014';
//    _VERSION = 1.0926;//Modificación en el calculo de la guia '23-ENE-2014'
//    _VERSION = 1.0927;//Se agrega la forma de pago a la impresion '23-ENE-2014'
//    _VERSION = 1.0928;//Se integra la impresion del la recoleccion '27-ENE-2014';
//    _VERSION = 1.0929;//Se corrige la impresion de la carga final y se elimina el acceso apartar boletos en la venta'27-ENE-2014';
//    _VERSION = 1.0930;
//    _VERSION = 1.0931;//Se corrige la cancelacion se notifica al servidor central '05-FEB-2014'
//    _VERSION = 1.0932;//Para la homologacion de todos los ejecutables '12-FEB-2014'
//    _VERSION = 1.0933;//Tiempo para la cancelacion en el parametro 23 '24-FEB-2014'
//    _VERSION = 1.0934;// Cambio para cobro con banamex DESHABILITAR_PROMO  LSALEZ '26-MAY-2014'
//    _VERSION = 1.0935;// Cambio para cobro con banamex Valido que la referencia de ida se a igual a la de regreso para que no exista el voleto Gratis  LSALEZ Y agrego funcion QUIAPO al password para que no inyecten codigo sql '18-jun-2014'
//    _VERSION = 1.0936;// Se agrega el módulo de cortes banamex lsalez '24-JUN-2014'
//    _VERSION = 1.0937;// Se codifica el url de banamex lsalez '25-JUN-2014'
//    _VERSION = 1.0938;// Se actualiza para el error asignado, modifica para las guias y impresion del boleto
//    _VERSION = 2.0;//Se modifica para la actualizacion para solucionar el paso a la venta
//    _VERSION = 2.01;//Se corrige en la pantalla del password no admitia caracteres 2014-07-11
//    _VERSION = 2.02;//Se todos los accesos para la venta
//    _VERSION = 2.03;//Se actualiza para registrar los eventos de venta
//    _VERSION = 2.04;//Se actualiza para borrar la gi_corte_store := 0 validar al imprimir el boleto
//    _VERSION = 2.05;//Se por el registro de evento y bajas de usuario
//    _VERSION = 2.051;//2014-07-21 Se agrega un store para el registro de eventos y se cambia la estructura
//    _VERSION = 2.052;//2014-07-21 Se modifica por el indice de los proveedor y cuotas en trafico
//    _VERSION = 2.053;//2014-11-18 Se aplica modificacion para los precortes que separen por terminal
//    _VERSION = 2.06;//2015-03-02 Se aplica modificacion para valida que el campo de password lo solicite
//    _VERSION = 2.061;//2015-03-18 Manda a imprimir la recoleccion al nuevo formato de impresion
//    _VERSION = 2.070;//2015-04-27 Se integra el detalle de corridas extras, precaptura de la guia en la ruta
//    _VERSION = 2.071;//24-JUN-2015 Integracion de el modulo de impresion
//    _VERSION = 2.072;//29-JUN-2015 Modificacion de cortes
//    _VERSION = 2.073;/tratar de corregir la actualizacion de las guias
//    _VERSION = 2.0731;
//    _VERSION = 2.08;//29-JUN-2015 correccion en la constante de la base de datos
//    _VERSION = 2.09;//06-AGO-2015 Se modifica laventa de reservaciones venta y visualizacion de reservacion
//    _VERSION = 2.091;//18-SEP-2015 correccion la replicacion de las guias
//    _VERSION = 2.092;//22-EP-2015 Impresion de la boletera en la guia
//    _VERSION = 2.093;//28-SEP-2015 Modificación en trafico para no modificar las precapturas de la guia
//    _VERSION = 2.094;//30-SEP-2015 Modificacion en las guias y incluye semaforo de comunicacion al server central
//    _VERSION = 2.095;//02-OCT-2015 Se agrega la actualizacion al server del iva y total
//    _VERSION = 2.096;//06-OCT-2015 Se modifica el ping se elimina la guia al central para que inserte la nueva
//    _VERSION = 2.097;//08-oct-2015 Se integra la correccion de la guia si no se ha generado esta la hace he inserta en BD's
//    _VERSION = 2.098;//19-OCT-2015 Se integra la generacion de corridas de vacio remotas y se corrige la leyenda de guia de vacio
//    _VERSION = 2.099;//06-NOV-2015 Se restringue los dias para generar corridas extras
//    _VERSION = 2.0991;//09-NOV-2015 Se modifica la guia de viaje en la validacion para generar la reimpresion y validacion de la existente
//    _VERSION = 2.0992;//13-04-2016 Se corrige la leyende de impresion y reimpresion de la guia
//    _VERSION = 2.0993;//28-04-2016 Se modifica la cancelacion de boletos
//    _VERSION = 2.0994;//05-05-2016 Modificacion en la forma frmUsuarios Gil
//    _VERSION = 2.0995;//14-06-2016 modeificacion en la replicacion de las guias
//    _VERSION = 2.0996;//12-07-2016 Modificacion en la tarjeta de credito replica, guias de vacio remotas ademas de generar de dias anteriores
//    _VERSION = 2.0997;modificacion en la impresion de las guias no se imprimian correctamente
//    _VERSION = 2.0998;Modificacion para la apertura de corrida restringida y genearacion de corrida
//    _VERSION = 2.0999;Modificacion en la generacion de corrida extra por el mismo horario
//    _VERSION = 2.100modificacion en la validadcion de generar corridas con el mismo horario
//    _VERSION = 2.101;'30-SEP-2016' modificacion en el store de insertaBoleto y lector de codigo barras para comisionistas, encripta passwords
//    _VERSION = 2.102; 17-10-2016 Se actualiza para la modificacion de impresion de boletos y problema de trafico
//    _VERSION = 2.103; 25-10-2016 Actualizacion en la ventana de tarjeta y validacion de tarjeta ixe en Pago
//    _VERSION = 2.104; 29-11-2016 se actualiza la terminal en la inserccion del boleto para la venta remota
//    _VERSION = 2.105; 19-01-2017 Se filtra los servicios en el combo, en corrida extra y en la impresion del boleto
//    _VERSION = 2.106; 03-02-2017 Se anexa la impresion con el tipo de tarifa una S para especificar que es sedena
//    _VERSION = 2.107;   10-02-2017 Se modifica para la impresion de guias de viaje
//    _VERSION = 2.108;   13-02-2017 ,Modificacion en la guia de viaje imprime correctamente
//    _VERSION = 2.109;   22-02-2017 actualiza la tabla de pdv_t_corrida el bus
//    _VERSION = 2.1091;  27-02-2017 Se actualiza para cerrar la corrida, valida que no exista venta no lo permite
//    _VERSION = 2.1092;  28-02-2017 Se modifica el store para validar la venta y se envia el servicio 0 catalogo de sedena
//    _VERSION = 2.10921; 02-03-2017 Se actualiza para la replicacion del curp de sd1
//    _VERSION = 2.10922; 01-06-2017 Se modifica las corridas extras, cortes, codigo de barras y impresion del codigo
//    _VERSION = 2.10923; 11-07-2017 Se modifica el boleto cuando sea impreso por pullman travel
//    _VERSION = 2.10924;12-09-2017 Se realizaron modificaciones en la guia y impresion del boleto leyendas
//    _VERSION = 2.110;2018-02-07 SE Elimina la leyenda de 30 dias para facturar
//    _VERSION = 2.111;27-fEB-2018 SE ACTUALIZA EL BUS CUANDO REIMPRIME DE FORMA REMOTA
//    _VERSION = 2.112;14-03-2018 se corrige el error en el nombre al cambiar el password
//    _VERSION = 2.113;23-03-2018 correccion en la impresion de de reservados
//    _VERSION = 2.114;23-04-2018 La configuracion de impresion de hoja detalle encortes depende de CAJA
//    _VERSION = 2.115; 25-04-2018 Se agrega la taquilla en la hoja de corte
//    _VERSION = 2.116; 20-11-2018 se agrega el control de los folios de salida de la terminal en las guias
//    _VERSION = 2.117; Modificacion de reporte de corte fin de turno, asignacion de fondos en caja, baja-alta operadores
//    _VERSION = 2.118; 2019-03-26 Creacion store remoto de boleto, cancelacion de remota en forma local
//    _VERSION = 2.120; Se actualiza para la ccancelacion de boletos de forma remota
//    _VERSION = 2.121; Se integra el campo de hora de la corrida en la guia
//    _VERSION = 2.122; 23-Abr-2019 Se integra el compo status corrida y se corrige el envio de guias
//    _VERSION = 2.123; 05-jun-2019 se integra la mdoificacion de Gilberto para el fondo incial desde el cajero
//    _VERSION = 2.124; 10-07-2019 Modificacion de la parte del fondo inicial ajustes
//    _VERSION = 2.124; 22-07-2019 Modificacion para el reuso de folios asignados en la salida del autobus en la guias
//    _VERSION = 2.125; 31-jul-2019 Se corrige la impresion de la carga inicial
//    _VERSION = 2.126;  14-11-2019 Se integra las modificiacion para el boleto abierto y aplicacion de descuento, ademas la integracion de Gilberto
//    _VERSION = 2.127; 22-01-2020 Correccion en la presentacion de autobuses solo los que corresponden a la terminal
//    _VERSION = 2.128; 29-01-2020 Correcion para el asiento en 0 y se ordena el combo de autobus y operador de trafico
//    _VERSION = 2.129; 26-02-2020 Se integra la modificacion de Gil para el area de finanazas y se precalcula los tickets de banamex
//    _VERSION = 2.130; 16-04-2020 Se actualiza la version para productivo
//    _VERSION = 2.131; 28-06-2020 Integracion de el servicio de la teminal
//    _VERSION = 2.14; 29-06-2020 cambio en la respuesta del json se separa por splitLine
//    _VERSION = 2.1423; 08-07-2020 correccion en la venta de las reservaciones en el nombre del pasajero en pagos
//    _VERSION = 2.1424;10-07-2020 correccion en la consulta del precorte para obtener el total de vta de banamex
//    _VERSION = 2.1425;15-07-2020 Se integra la modificacion de la promocio rollo en precorte y corte
//    _VERSION = 2.1426;16-07-2020 correccion en el precorte y en la salida de la terminal e guias
//    _VERSION = 2.1427;correccion en la visualizacion en los boletos de ixe en el precorte
//    _VERSION = 2.1428;correccion en boletos cancelados en los precortes
//    _VERSION = 2.1429;modificacion para que no genere salida en corridas remotas
//    _VERSION = 2.1430;Se integra la generacion de corridas extras de forma remota
//    _VERSION = 2.1431;Se integra el control remoto de abri y cerrrar corridas modulo nuevo
//   _VERSION = 2.1432;07-09-2020 Se corrige que no inserte el asiento 0 en la reservacion
//    _VERSION = 2.1433;14-Sep-2020 Se guarda una cadena de la salida de la terminal en la tabla pdv_t_guia_despacho
//    _VERSION = 2.1434;
//    _VERSION = 2.1440;06-Nov-2020 Se modifica la funcion de cancelar con agregar un try except para que pueda cancelar
//    _VERSION = 2.1441; 11-12-2020 se revisa la venta de pie
//    _VERSION = 2.1442; 2020-21-21 sE HACE MODIFICACIONES EN LA VENTA AL SELECCIONAR UNA CORRIDA Y MAS RAPIDA LA IMPRESION
//    _VERSION = 2.1443;2020-12-30 Se modifica para la impresion en el formato remoto al no poder actualizar la hora en el boleto
//    _VERSION = 2.1444;2021-01-29 Se actualiza por la parte de los cancelados en los precortes
//    _VERSION = 2.1445;2021-02-04 Se integra la salida de la terminal, en regsitro de paso y se modifica la cancelacion en precorte
//    _VERSION = 2.1446;2021-02-26 Se modirfica la venta de reservaciones para que no se duplique el codigo
//    _VERSION = 2.1446;2021-04-05 Se revisa la venta en diferentes formas remota inividual
//    _VERSION = 2.1447; 2021-06-15 Se valida el arreglo antes de imprimir y valida en banamex, inserta valores nulos
//    _VERSION = 2.1448; 2021-06-21 Se valida que los datos del arreglo la forma de pago se la correcta que esta en los combobox
//    _VERSION = 2.1449; 2021-09-29 se anexa comprobante de impresion de guia y salidas a taller esto esta parametrizado en la tabla  57y 58
//    _VERSION = 2.1450; 12-11-2021 se actualiza las salidas de taller
//    _VERSION = 2.1451; 30-11-2021 se registra en una tabla nuebla la reimpresion de las guias historicas
//    _VERSION = 2.1452; 02-03-2022 se integra la capcaidad de habilitar la vetna web, se corrige la impresion de boleto y la tarjeta de viaje
//                                  se modifica para que el usuario sea el correcto
//    _VERSION = 2.1453; se elimina en la parte de pago un query que hace busqueda por abreviacion en el vk_f10
//    _VERSION = 2.1454; 22-03-2022.- se corrige funcion de replicar a todos los servidores para que se guarde correctamente los acentos en los catálogos.
//                                    se agrega en la forma de terminales el campo nombre al cliente.
//    _VERSION = 2.1455; 2023-03-23 Se actualiza el ejecutable desde la perdida de informacion
    _VERSION = 3.0001;
    _FECHA_VERSION = '22-MAR-2022';
    FMasculino = True;
    FSeparador = '.';
    FMoneda = 'pax.';
    _PI = 53;
//para la impresion
    _IMP_TOSHIBA_TEC = 0;
    _IMP_TOSHIBA_MINI = 1;
    _IMP_ITHACA_MINI = 2;
    _IMP_IMPRESORA_OPOS = 3;
    _IMP_DEFAUTL_PRINTER = 0;
//folios
    _FOL_CERO = 0;
    _FOL_UNO  = 1;
    _FOL_DIEZ = 10;
    _FOL_VEINTE = 20;
    _FOL_TREINTA = 30;
    _CARACTERES_VALIDOS_EFECTIVO : SET OF CHAR = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.'];
type
  a_imagens = array of Timage;

  TDualStrings = class(TObject)
  private
    FID: TStrings;
    FValue: TStrings;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(ID, Value: string);
    procedure clear();
    function Count: Integer;
    function IDOf(Value: string): string;
    function ValueOf(ID: string): string;
    property ID: TStrings read FID write FID;
    property Value: TStrings read FValue write FValue;
  end;

    gga_parameters = array[0..LARRAY_]of String;

    function EjecutaSQL(lps_sentencia : String; var lpq_query : TSQLQuery; lpi_ruta : integer) : Boolean;
    function Ahora() : String;
    function FechaServer() : String;
    function AccesoPermitido(tag : Integer; ToFDual : boolean) : Boolean;
    procedure splitLine(lps_linea: string; lpc_delim: char;
                        var output: gga_parameters; var lpi_numstr: integer);
    procedure ajustArreglo(var output: gga_parameters; del : char);
    procedure ErrorLog(Error, sql : string);
    procedure ImpresionDatos(ls_str : string);
    procedure MostrarForma(lfrm_forma : TForm); overload;
    procedure MostrarForma(lfrm_forma : TForm; padre : Tform); overload;
    procedure Mensaje(text : String; li_tag : Integer);
    procedure LlenarComboBox(lpq_query : TSQLQuery; combo : TlsComboBox; concatenado : boolean);
    procedure LimpiaSag(sag: TStringGrid);
    procedure LimpiaSagTodo(sag: TStringGrid);
    function GetIPList() : String;
    function getTerminal() : String;
    function getNamePuerto(valor : integer): String;
    function getPuertoImpresora(valor : integer): integer;
    function getImpresora(valor : integer): integer;
    function getTeminalesAuto() : TSQLQuery;
    function validaUserHistorico(action : integer) : integer;
    function  DataSetToSag(data : TDataSet; sag : TStringGrid) : boolean;
    function registrosDe(dataSet: TDataSet): Integer;
    procedure GridDeleteRow(RowNumber: Integer; Grid: TstringGrid);

    function Decrypt (const s: ansistring; Key: Word) : ansistring;
    function Encrypt (const s: ansistring; Key: Word) : ansistring;
    function SpoolFile(const FileName, PrinterName: string): Integer;
    function NumeroATexto: String;
    function NTSetPrivilege(sPrivilege: string; bEnabled: Boolean): Boolean;
    Function p(v : Integer) : Integer; // Pivot Salez
    procedure apagarElEquipo;
    function papelContinuo(terminal, ip, taquilla : String) : integer;
    function impresionBoletos(terminal, ip, taquilla : String) : integer;
    function impresionBoletosComun(terminal, ip, taquilla : String) : string;
    function BoletosTamano(terminal, ip, taquilla : String) : integer;
    function getPueblosMagicos() : integer;
    function getBoletoContinuo() : integer;
    function getTiempoPing() : integer;
    function getparametroProveedor():integer;
    function getParametroLector() : integer;
    function getParametroCemos() : integer;
    function getParametroServicio(): integer;
    function getParametroServicioPaso(): integer;
    function getParametroTabla(parametro : integer): integer;
    function impresionGuiasCortes(terminal, ip, taquilla : String) : integer;
    function impresionGeneral(terminal, ip, taquilla : String) : string;
    function obtieneOperacionRemota(terminal, ip : String) : integer;
    function getSecureAcces(terminal, ip, taquilla : String) : integer;
    function getCobroConIva() : integer;
    function getBanamePinPad(terminal, ip : String) : integer;
    function getCargaFinal(terminal, ip : String) : integer;
    function StringtoHex(Data: string): string;
    function randomCaracteres() : string;
    function getAbiertaRestringida() : integer;
    function getGeneraHoraIgual() : integer;
    procedure creaBeginFile(local, terminal, taquilla, server, agencia, clave_agencia : string);
    function getBoletaje() : integer;
    procedure getBoletoBlancos(li_corte : integer; user : String; grid : TStringGrid);
    procedure insertaEvento(id_trabid, terminal, evento : String);
    function RemplazaDecimal(cadena : String) : String;
    function obtenImpresionIva() : integer;
    function ventaMasivaTC(terminal : string; IdTaquilla : integer) : integer;
    function quiapo(cad_con_apos :String) :String;
    function getHora(): string;
    procedure valoresIniciales();
    procedure inicializaImpresionVars();
    procedure image_servidorCentral(IMAGE : TImage; MEMO : TMemo);
    procedure Ping(const Address:string;Retries,BufferSize:Word; IMAGE : TImage; MEMO : TMemo);
    function llenaEspacios(texto : String; longitud : integer) : String;
    function replaceChar(texto : string; letra : Char) : String;
    function forza_der(cadena:string;no:integer):string;
    function espacios(no:integer):string;


    procedure focusEditComponent(Edit : TEdit);

    procedure cargaDiaSemana(grid : TStringGrid);
    procedure updateDiaSemana(grid : TStringGrid);

    Function copiarAMemoria(grid : TStringGrid) : Boolean;
    procedure ExcelMigrar(grid : TStringGrid);

    procedure showPantallaImagen(servicio : integer);

var
    gs_server  : String;//variable que apunta al server local
    gs_local   : String;//direccion al que apunta la base de datos local en la terminal
    gs_user    : String;//variable para identificar el usuario DB
    gs_terminal: String;//variable para la identificacion de la terminal en la que se encuentra el equipo
    gs_maquina : String;//variable para la identificacion de el numero del equipo
    gs_dbName  : String;//variable para la identificiacion de la base de datos
    gs_password: String;//variable para la almacenacion del password de la base de datos
    gs_trabid  : String;//variable para conocer quien ha accesado
    gs_agencia : String;//variable que almacena un valor de 1 o 0
    gs_agencia_clave : String;//variable para buscar en el catalogo de agencias
    gs_tarjeta_fisica : string;//variable para la tarjeta fisica
    gs_pinpad_banamex_error : String;//Variable para el error del pinpad banamex.
    gs_apagar : string;// Variable para saber si el equipo se apaga despues de desasignarse de la venta
    gs_cargaFinal : string;// Variable para saber si se arroja o no la carga final al desasignarse.
    gs_ImprimirAdicional : integer;// Variable para saber en que dispositivo debe de imprimir las impresones adicionales
                                   // 0: Predeterminada de Windows
                                   // 1: Toshiba miniPrinter
                                   // 2: Ithaca miniPrinter
                                   // 3: Archivo TXT
                                   // 4: PDF
    gs_impresora_boleto : integer; //nuevas variables globales para la impresion de boletos
    gs_toshiba : string;
    gi_inicial_agencia : integer;
    gi_final_agencia   : integer;
    gi_secure_access   : integer; //para solicitar solo un dia, al mostrar las corridas y no 2 como se hacia
    gi_cobro_con_iva   : integer;
    gi_pueblos_magicos : integer;
    gi_conexion_server : integer;
    gi_tiempo_ping     : integer;

    gs_impresora_boletos : string;
    gs_impresora_general : string;
    gi_boleto_tamano   : integer; //para que imprima el boleto segun se haya confiruado la taquilla
    sql        : String;// Instruccion SQL
    gs_puerto  : String;// Puerto de impresion
    gs_puerto_opc : string;
    gds_user   : TDualStrings;
    gds_privilegio   : TDualStrings;
    gb_acceptado : Boolean;
    gi_select_corrida : Integer;
    array_imagens : a_imagens;
    gi_cancelada  : Integer;
    gds_buses      : TDualStrings;///usada para guaradar los buses y su indice de la tabla
    gi_seleccion : Integer;
    gds_ocupantes_disponibles : TDualStrings;
    ///gilberto
    tipoBusqueda : integer;
    gds_actions : TDualStrings; //para el registro del actios
    li_msg_password   : integer;//para el caption del password
    gs_NombreImagenBusModificado : String;
    gs_TipoBusModificado : String;
    gs_NoAsientosBusModificado : String;
    li_ctrl_conectando : integer;
    FNumero : Double;
    FCentavos : String;
    gi_impresion_itaca : integer;
    gi_impresion_personalizada : integer;
    gs_destino_ruta : String;
    gi_operacion_remota : integer;
    gi_hora, gi_minuto, gi_segundo : Integer;
    gi_impresion_iva : integer;
    gi_venta_masiva : integer;
    gi_guia_procesa : integer;

    gi_corrida_restringida : integer;
    gi_genera_hora_igual   : integer;
    gi_boleto_continuo : integer;
    CONEXION_CENTRAL : TSQLconnection;
    gs_version : STring;

    pantalla : LitteScreen;
    gi_imagen_servicio : integer;
    gi_Pantalla_duplex : integer;

implementation

uses DMdb, frm_acc_password, ThreadRemoto, ThreadMainServer, TRemotoTodos, u_comun_base,
  u_guias;

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

function forza_der(cadena:string;no:integer):string;
var
  temp : string;
begin
  temp := '';
  if length(cadena) < no then
    temp := espacios(no - length(cadena)) + cadena;

  if length(cadena) = no then
      temp := cadena;
  result := temp;
end;


function getHora(): string;
var
    lq_qry : TSQLQuery;
    ls_out : string;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL('SELECT CURRENT_TIME AS HORA', lq_qry, _LOCAL) then
        ls_out := TimeToStr(lq_qry['HORA']);
    lq_qry.Destroy;
    result := ls_out;
end;

function p(v : Integer) : Integer;
Begin
 result := _PI - v;
End;



function NTSetPrivilege(sPrivilege: string; bEnabled: Boolean): Boolean;
var
  hToken: THandle;
  TokenPriv: TOKEN_PRIVILEGES;
  PrevTokenPriv: TOKEN_PRIVILEGES;
  ReturnLength: Cardinal;
begin
  Result := True;
  // Only for Windows NT/2000/XP and later.
  if not (Win32Platform = VER_PLATFORM_WIN32_NT) then Exit;
  Result := False;

  // obtain the processes token
  if OpenProcessToken(GetCurrentProcess(),
    TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken) then
  begin
    try
      // Get the locally unique identifier (LUID) .
      if LookupPrivilegeValue(nil, PChar(sPrivilege),
        TokenPriv.Privileges[0].Luid) then
      begin
        TokenPriv.PrivilegeCount := 1; // one privilege to set

        case bEnabled of
          True: TokenPriv.Privileges[0].Attributes  := SE_PRIVILEGE_ENABLED;
          False: TokenPriv.Privileges[0].Attributes := 0;
        end;

        ReturnLength := 0; // replaces a var parameter
        PrevTokenPriv := TokenPriv;
        // enable or disable the privilege

        AdjustTokenPrivileges(hToken, False, TokenPriv, SizeOf(PrevTokenPriv),
          PrevTokenPriv, ReturnLength);
      end;
    finally
      CloseHandle(hToken);
    end;
  end;
  // test the return value of AdjustTokenPrivileges.
  Result := GetLastError = ERROR_SUCCESS;
  if not Result then
    raise Exception.Create(SysErrorMessage(GetLastError));
end;
{
********************************* TDualStrings *********************************
}
constructor TDualStrings.Create;
begin
  FID := TStringList.Create;
  FValue := TStringList.Create;
end;

destructor TDualStrings.Destroy;
begin
  FID.Free;
  FValue.Free;
end;

procedure TDualStrings.Add(ID, Value: string);
begin
  FID.Add(Trim(ID));
  FValue.Add(Trim(Value));
end;

procedure TDualStrings.clear;
begin
    ID.Clear;
    Value.Clear;
end;

function TDualStrings.Count: Integer;
begin
  Result := ID.Count;
end;

function TDualStrings.IDOf(Value: string): string;
var
  index: Integer;
begin
  index := FValue.IndexOf(Trim(Value));
  if index < 0 then
    Result := ''
  else
    Result := FID[index];
end;

function TDualStrings.ValueOf(ID: string): string;
var
  index: Integer;
begin
  index := FID.IndexOf(Trim(ID));
  if index < 0 then
    Result := ''
  else
    Result := FValue[index];
end;
{
********************************* TDualStrings *********************************
}
{@procedimiento splitLine
 @Params lps_linea: string;
 @Params lpc_delim: char;
 @Params var output: gga_parameters;
 @Params var lpi_numstr: integer
 @regresa un arreglo de cadenas separadas por un caracter delimitante}
procedure splitLine(lps_linea: string; lpc_delim: char;
                        var output: gga_parameters; var lpi_numstr: integer);
var
    ls_wrk: string;
    lc_char: char;
    li_i, li_k, li_len: integer;
begin
    li_k := 0;
    ls_wrk := '';
    li_len := length(lps_linea);
    for li_i:=1 to li_len do  begin
        lc_char := lps_linea[li_i];
        if lc_char <> lpc_delim then
            ls_wrk := ls_wrk + lc_char
        else begin
                output[li_k] := ls_wrk;
                ls_wrk := '';
                li_k := li_k + 1;
                if li_k > LARRAY_ then exit;
            end;
    end;
    if ls_wrk <> '' then begin
        output[li_k] := ls_wrk;
        lpi_numstr := li_k;
    end else
           lpi_numstr := li_k - 1;
end;


procedure ajustArreglo(var output: gga_parameters; del : char);
var
    li_ctrl, li_dat : integer;
    ls_arr : string;
begin
    li_dat := 0;
    for li_ctrl := 0 to High(output) do begin
        if output[li_ctrl] <> '' then begin
            ls_arr := output[li_ctrl];
            output[li_ctrl] := '';
            output[li_dat] := ls_arr;
            inc(li_dat);
        end;
    end;
end;


{@procedure ImpresionDatos
@Params ls_str   : Datos que se imprimen en el boleto}
procedure ImpresionDatos(ls_str : string);
var
    lf_archivo : TextFile;
begin
    try
        AssignFile(lf_archivo,_BOLETOS);
        if not FileExists(_BOLETOS) then
            Rewrite(lf_archivo)
        else
            Append(lf_archivo);

        Writeln(lf_archivo,ls_str);
        CloseFile(lf_archivo);
    except
    end;
end;


{@function EjecutaSQL
@Params lps_sentencia : ingresa la sentencia sql
@Params lpq_query     : Se pasa el objeto sqlQuery
@Params lpi_ruta      : El numero de la ruta que se utilice en ese momento
@Descripcion ejecuta la instruccion sql dependiendo el tipo de operacion, si esta es 1
  entonces invocara un TThread para actualizar las bases de datos en los diferentes sitios}
function EjecutaSQL(lps_sentencia : String; var lpq_query : TSQLQuery; lpi_ruta : integer) : Boolean;
const
  operaciones : array[0..4] of String[7] =
              ('SELECT ', 'INSERT ', 'UPDATE ', 'DELETE ', 'EXECUTE');
var
    lb_ejecutada : Boolean;
    ls_error     : PWideString;
    li_operacion : integer;
    ls_operacion : String;
    Hilo_todos   : RemotoTodos;
    Hilo_Ruta    : RemotoRuta;
    Hilo_Server  : QryMainServer;
begin
    if lpi_ruta <> _SERVIDOR_CENTRAL then begin
        for li_operacion := 0 to high(operaciones) do
            if UpperCase(copy(lps_sentencia,1,7)) = operaciones[li_operacion] then
                break;
        lpq_query.SQL.Clear;//clear al componente
        lpq_query.SQL.Add(lps_sentencia);//se agrega la sentencia
        try
            if li_operacion = 0 then//Cuando es Select solo ejecuta Open
                lpq_query.Open//Abrimos el Query
            else begin
                  lpq_query.ExecSQL()//ejecuta el query
            end;
            lb_ejecutada := true;
        except
            on E : Exception do begin
              ErrorLog(E.Message,lps_sentencia);//escribimos al archivo
              lb_ejecutada := false;
            end;
        end;
    end;

    if lpi_ruta > _RUTA then begin //invocamos el TThread remoto  para la ruta si es mayor a 0
        Hilo_Ruta := RemotoRuta.Create(true);
        Hilo_Ruta.ruta := lpi_ruta;
        Hilo_Ruta.destino := gs_destino_ruta;
        Hilo_Ruta.server :=DM.Conecta;
        Hilo_Ruta.sentencia := lps_sentencia;
        Hilo_Ruta.terminal  := gs_terminal;
        Hilo_Ruta.Priority  := tpNormal;
        Hilo_Ruta.FreeOnTerminate := True;
        Hilo_Ruta.Resume;
    end;

    if lpi_ruta = _TODOS then begin
        Hilo_todos := RemotoTodos.Create(true);
        Hilo_todos.server := DM.Conecta;//SqlConnection
        Hilo_todos.sentenciaSQL := lps_sentencia;
        Hilo_todos.Terminal     := gs_terminal;
        Hilo_todos.Priority := tpNormal;
        Hilo_todos.FreeOnTerminate := true;
        Hilo_todos.Resume;
    end;
    if lpi_ruta = _SERVIDOR_CENTRAL then begin
        Hilo_Server := QryMainServer.Create(true);
        Hilo_Server.server   := DM.Conecta;
        Hilo_Server.sentenciaSQL := lps_sentencia;
        Hilo_Server.Terminal     := '1730';
        Hilo_Server.Priority := tpNormal;
        Hilo_Server.FreeOnTerminate := true;
        Hilo_Server.Resume;
    end;
    Result := lb_ejecutada;
end;


{@procedure ErrorLog
@Params Error : error que atrapa la excepcion
@Params sql   : Sentencia sql que detecta el error}
procedure ErrorLog(Error, sql : string);
var
    lq_qry     : TSQLQuery;
    ls_qry     : string;
    lf_archivo : TextFile;
begin
{    ls_qry := 'INSERT INTO ERROR_TABLA(HORA_ERROR, ERROR, INSTRUCCION) VALUES(NOW(), ''%s'', ''%s'')';
    ls_qry := Format(ls_qry,[error,sql]);
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if  EjecutaSQL(ls_qry,lq_qry,_LOCAL) then
        ;
    lq_qry.Free;}
    try
        ls_qry := extractFilePath(Application.ExeName)+_LOG;
        AssignFile(lf_archivo,_LOG);
        if FileExists(_LOG) then
            Append(lf_archivo)
        else
            Rewrite(lf_archivo);
        Writeln(lf_archivo,'//------------------------------------------------------------');
        Writeln(lf_archivo,FormatDateTime('"Fecha : "dd/mm/yyyy hh":"nn ',now));
        Writeln(lf_archivo,format('Error : %s',[error]));
        Writeln(lf_archivo,format('SQL   : %s',[sql]));
        Writeln(lf_archivo,'//------------------------------------------------------------');
        CloseFile(lf_archivo);
    except
    end;
end;



{@ProcedureError
@Params Processor: TZSQLProcessor;
@Params StatementIndex: Integer;
@Params E: Exception;
@Params var ErrorHandleAction: TZErrorHandleAction
@Descripcion verificamos sino tenemos algun error de ser asi destruimos el obtejo de consulta}
{procedure ProcessorError(Processor: TZSQLProcessor;  StatementIndex: Integer; E: Exception;
                             var ErrorHandleAction: TZErrorHandleAction);
begin
    Processor.Destroy;
end;
}



{@function Ahora
@Descripcion Regresa la fecha y la hora actual del servidor en el formato yyyy-mm-dd hh:mm:ss}
function Ahora() : String;
var
    lq_query : TSQLQuery;
    ls_qryStr : string;
    ld_time   : String;
begin
    ls_qryStr := 'SELECT (DATE_FORMAT(current_timestamp(),''%Y-%m-%d %T''))as ahora';
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(ls_qryStr,lq_query,_LOCAL) then
          ld_time := lq_query['ahora'];
    except
      on E : Exception do
         ErrorLog(E.Message,ls_qryStr);//escribimos al archivo
    end;
    lq_query.Destroy;
    Result := ld_time;
end;



{@function FechaServer
@Descripcion Regresa la fecha y la hora actual del servidor en el formato yyyy-mm-dd hh:mm:ss}
function FechaServer() : String;
var
    lq_query : TSQLQuery;
    ls_qryStr : string;
    ld_time   : String;
begin
    ls_qryStr := 'SELECT (DATE_FORMAT(current_timestamp(),''%d/%m/%Y''))as ahora';
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(ls_qryStr,lq_query,_LOCAL) then
          ld_time := lq_query['ahora'];
    except
      on E : Exception do
         ErrorLog(E.Message,ls_qryStr);//escribimos al archivo
    end;
    lq_query.Destroy;
    Result := ld_time;
end;


{@Procedure LimpiaSag
@Params sag : TStringGrid
@Descripcion Limpiar celdas un StringAlingGrid para nueva captura ·*}
procedure LimpiaSag(sag: TStringGrid);
var
   col : byte;
begin
     sag.RowCount := 2;
     col := 0;
     while col <= sag.ColCount do begin
       sag.Cells[col,1] := '';
       Inc(col);
     end;
end;


procedure LimpiaSagTodo(sag: TStringGrid);
var
   col : byte;
begin{*· Limpiar celdas un StringAlingGrid para nueva captura ·*}
{     sag.RowCount := 1;
     col := 0;
     while col <= sag.ColCount do begin
       sag.Cells[col,0] := '';
       Inc(col);
     end;}
     for col := 0 to sag.ColCount -1 do begin
       sag.Cols[col].Clear;
     end;
end;


(*)****************************************************************************
 --> registrosDe
 + Regresa el número de registros en el dataset, lo uso en lugar de .recordcount
   debido a que en ocaciones me arrojaba datos erroneos.
****************************************************************************(*)
function registrosDe(dataSet: TDataSet): Integer;
var
   n: Integer;
begin
   n := 0;
   if not dataSet.IsEmpty then begin
     dataSet.First;
     while not dataSet.Eof do begin
       inc(n);
       dataSet.Next;
     end;
   end;
   result := n;
   dataSet.First;
end;


(*)****************************************************************************
 --> DataSetToSag
 + Manda el dataset al sag dado.
****************************************************************************(*)
function  DataSetToSag(data : TDataSet; sag : TStringGrid) : boolean;
var
 vRegistros, vCol, vRow : Integer;
 campos : TStringList;
 formatSettings : TFormatSettings;
begin
   result := False;
   GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);
   sag.ColCount := data.FieldCount;
   vRegistros := registrosDe(data);
   sag.RowCount := vRegistros + 1;
   campos := TStringList.Create;
   try
     campos.AddStrings(data.FieldList);
     for vCol := 0 to campos.Count - 1  do
       sag.Cells[vcol,0] := campos[vCol];
     data.First;
     vRow := 1;
     while not data.Eof do begin
       for vCol := 0 to campos.Count - 1  do
         if (data.FieldDefs.Items[vCol].DataType = ftDateTime) or
         (data.FieldDefs.Items[vCol].DataType = ftTimeStamp) then
           sag.Cells[vCol, vRow] := FormatDateTime('', data.Fields[vCol].AsDateTime,  formatSettings)
         else
           sag.Cells[vcol,vRow] := data.Fields[vCol].AsString;
       inc(vRow);
       data.Next;
     end;
   finally
     campos.Free;
     result := True;
   end;
end;

{@Procedure MostrarForma
@Params lfrm_forma : TForm
@Descripcion Muestra la forma y esta es liberada }
procedure MostrarForma(lfrm_forma : TForm);
var
    li_ctrl : Integer;
begin
    try
        lfrm_forma.ShowModal;
    finally
        lfrm_forma.Free;
        lfrm_forma := nil;
    end;
end;

procedure MostrarForma(lfrm_forma : TForm; padre : Tform); overload;
var
    li_ctrl : Integer;
begin
    try
        lfrm_forma.Parent := padre;
        lfrm_forma.ShowModal;
    finally
        lfrm_forma.Free;
        lfrm_forma := nil;
    end;
end;
{@Procedure MensajeERRROR
@Paramas text : String
@Descripcion Despleaga mensaje de Error}
procedure Mensaje(text : String; li_tag : Integer);
var
    msg : TMsgDlgType;
begin
    case li_tag of
       0 :  msg := TMsgDlgType.mtWarning;
       1 :  msg := TMsgDlgType.mtError;
       2 :  msg := TMsgDlgType.mtInformation;
       3 :  msg := TMsgDlgType.mtConfirmation;
       4 :  msg := TMsgDlgType.mtCustom;
    end;
    MessageDlg(text,msg,[mbOK],0)
end;


{@function validaUserHistorico
@Params action : integer
@Paras user   : String
@Descripcion regresa un valor dependiendo si se encuentra en el dualstring
             1 si se encuentra de no ser asi regresa 0 }
function validaUserHistorico(action : integer) : integer;
var
    li_out : integer;
begin
    if length(gds_actions.IDOf(IntToStr(action))) = 0 then
        li_out := 0
    else li_out := 1;
    Result := li_out;
end;



{@function AccesoPermitido
@Params tag : Integer
@Descripcion Funcion que muestra el password Dialog para logearse
@ si esta accion es valida regresa de tipo boleano para continuar con
@ sus flujo correpondiente}
function AccesoPermitido(tag : Integer; ToFDual : boolean) : Boolean;
var
    lb_aceptado : Boolean;
    frm : TForm;
begin
    gb_acceptado := False;
//    if validaUserHistorico(tag) = 0 then begin
      try
          frm := TPasswordDlg.Create(nil);
          NumeroAction := tag;
          Bagregadual  := ToFDual;
          frm.ShowModal;
      finally
          frm.Free;
          frm := nil;
      end;
//    end;
      if not gb_acceptado then begin
          Mensaje(Format(_PASSWORD_DENEGADO,[gds_privilegio.ValueOf(IntToStr(tag))]) ,1);
      end;
    result := gb_acceptado;
end;

{@procedire LlenarComboBox
@Params lpq_query : TZReadOnlyQuery;
@Params combo : TlsComboBox
@Descripcion Llena la informacion del query al lscombobox}
procedure LlenarComboBox(lpq_query : TSQLQuery; combo : TlsComboBox; concatenado : boolean);
begin
    combo.Clear;
    with lpq_query do begin
        First;
        while not EoF do begin
            if concatenado then
                combo.Add(lpq_query.Fields[0].AsString+'-'+lpq_query.Fields[1].AsString,lpq_query.Fields[0].AsString)
            else
                combo.Add(lpq_query.Fields[1].AsString,lpq_query.Fields[0].AsString);
            Next;
        end;
    end;
end;

{afunction GetIpList : String
@Solicitamos la ip de la maquina en donde se esta instalando el programa}
function GetIPList() : String;
var
  WSAData: TWSAData;
  HostName: array[0..255] of ansiChar;//Char;
  HostInfo: PHostEnt;
  InAddr: ^PInAddr;
  ip_str : STring;
begin
  if WSAStartup($0101, WSAData) = 0 then
  try
    if gethostname(HostName, SizeOf(HostName)) = 0 then
    begin
      HostInfo := gethostbyname(HostName);
      if HostInfo <> nil then
      begin
        InAddr := Pointer(HostInfo^.h_addr_list);
        if (InAddr <> nil) then
          while InAddr^ <> nil do
          begin
            ip_str := inet_ntoa(InAddr^^);
            Inc(InAddr);
            Break;// solo nos interesa la primer ip
          end;
      end;
    end;
  finally
    WSACleanup;
  end;
  Result := ip_str;
end;


function  getTerminal() : String;
var
    lq_query : TSQLQuery;
    ip : String;
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    ip := GetIPList();
    lq_query.SQL.Clear;
    lq_query.SQL.Add('SELECT ID_TERMINAL FROM PDV_C_TAQUILLA WHERE IP = :ip ');
    lq_query.Params[0].AsString := ip;
    lq_query.Open;
    if not lq_query.IsEmpty then
        Result := lq_query['ID_TERMINAL']
    else
        Result := '';
end;



function getTeminalesAuto() : TSQLQuery;
var
    lq_query : TSQLQuery;
begin
    lq_query := TSQLQuery.Create(nil);
    try
      lq_query.SQLConnection := DM.Conecta;
    finally
      lq_query.Free;
    end;
end;

{@ Procedure GridDeleteRow
@Params RowNumber: Integer; Grid: TstringGrid
@Descripcion Eliminamos la fila de un StringGrid}
procedure GridDeleteRow(RowNumber: Integer; Grid: TstringGrid);
var
  i: Integer;
begin
  Grid.Row := RowNumber;
  if (Grid.Row = Grid.RowCount - 1) then
    { On the last row}
    Grid.RowCount := Grid.RowCount - 1
  else
  begin
    { Not the last row}
    for i := RowNumber to Grid.RowCount - 1 do
      Grid.Rows[i] := Grid.Rows[i + 1];
    Grid.RowCount := Grid.RowCount - 1;
  end;
end;

function Encrypt (const s: ansistring; Key: Word) : ansistring;
var
    i : byte;
begin
    result := s;
    for i := 1 to (length(s)) do begin
        result[i] := AnsiChar ( byte(AnsiChar(ord(s[i])+1) ) xor (Key shr 8));
        Key := (byte (Result[i]) + Key) * c1 + c2
    end
end;

function Decrypt (const s: ansistring; Key: Word) : ansistring;
var
    i : byte;
begin
    Result:=s;
    for i := 1 to (length (s)) do begin
        Result[i] := AnsiChar ((byte(s[i]) xor (Key shr 8)) - 1);
        Key := (byte (s[i]) + Key) * c1 + c2
    end
end;


function SpoolFile(const FileName, PrinterName: string): Integer;
var
  Buffer: record
    JobInfo: record // ADDJOB_INFO_1
      Path: PChar;
      JobID: DWORD;
    end;
    PathBuffer: array[0..255] of Char;
  end;
  SizeNeeded: DWORD;
  Handle: THandle;
  PrtName: string;
  ok: Boolean;
begin
  // Flush job to printer
  PrtName := PrinterName;
  if PrtName = '' then
    PrtName := Printer.Printers[Printer.PrinterIndex]; // Default printer name
  ok := False;
  if OpenPrinter(PChar(PrtName), Handle, nil) then
    if AddJob(Handle, 1, @Buffer, SizeOf(Buffer), SizeNeeded) then
      if CopyFile(PChar(FileName), Buffer.JobInfo.Path, True) then
        if ScheduleJob(Handle, Buffer.JobInfo.JobID) then
          ok := True;
  if not ok then Result := GetLastError
  else
    Result := 0;
end;

function NumeroATexto: String;
     (*** NUEVA ***)
     (*** Ej: 'treinta y una millones' --> 'treinta y un millones' ***)
     function Cambiar_na_a_masculino(Texto: String): String;
     var
       P: Integer;
     begin
       Result:= Texto;
       P:= Pos('na', Result);
       while P > 0 do begin
         Delete(Result, P+1, 1);
         P:= Pos('na', Result);
       end;
     end;

     (*** NUEVA ***)
     (*** Ej: 'quinientas millones' --> 'quinientos millones' ***)
     function Cambiar_as_a_masculino(Texto: String): String;
     var
       P: Integer;
     begin
       Result:= Texto;
       P:= Pos('as', Result);
       while P > 0 do begin
         Result[P]:='o';
         P:= Pos('as', Result);
       end;
     end;

     (*** Optimizada ***)
     function Unidades(numero:Integer): String;
     begin
       case numero of
         0: Result:='';
         1: if FMasculino
            then Result:='un'
            else Result:='una';
         2: Result:='dos';
         3: Result:='tres';
         4: Result:='cuatro';
         5: Result:='cinco';
         6: Result:='seis';
         7: Result:='siete';
         8: Result:='ocho';
         9: Result:='nueve';
       end;
     end;

     (*** Optimizada ***)
     function Decenas(numero:integer): String;
     begin
       Case numero of
         0:Result:='';
         1..9:Result:=Unidades(numero);
         10: Result:='diez';
         11: Result:='once';
         12: Result:='doce';
         13: Result:='trece';
         14: Result:='catorce';
         15: Result:='quince';
         16: Result:='dieciséis';
         17: Result:='diecisiete';
         18: Result:='dieciocho';
         19: Result:='diecinueve';
         20: Result:='veinte';
         21,24,25,27..29: Result:='veinti'+Unidades(numero mod 10);
         22: Result:='veintidós';
         23: Result:='veintitrés';
         26: Result:='veintiséis';
         30: Result:='treinta';
         40: Result:='cuarenta';
         50: Result:='cincuenta';
         60: Result:='sesenta';
         70: Result:='setenta';
         80: Result:='ochenta';
         90: Result:='noventa';
         else Result:=Decenas(numero - numero mod 10)+' y '+ unidades(numero mod 10);
       end;
     end;

     (*** Optimizada ***)
     function Centenas(numero:integer): String;
     begin
       case numero of
         0: Result:='';
         1..99: Result:=Decenas(numero);
         100: Result:='cien';
         101..199: Result:='ciento '+Decenas(numero mod 100);
         500: if FMasculino
              then Result:='quinientos '
              else Result:='quinientas ';
         700: if FMasculino
              then Result:='setecientos '
              else Result:='setecientas ';
         900: if FMasculino
              then Result:='novecientos '
              else Result:='novecientas ';
         501..599,
         701..799,
         901..999: Result:= Centenas(numero - numero mod 100)+Decenas(numero mod 100);
         else if FMasculino
              then Result:=Unidades(numero div 100)+'cientos'+' '+Decenas(numero mod 100)
              else Result:=Unidades(numero div 100)+'cientas'+' '+Decenas(numero mod 100);
       end;
     end;

     (*** NUEVA ***)
     (*** Esta funcion traduce los números menores a un millón ***)
     function Millares(numero: Longint): String;
     begin
       if numero > 999 then begin
         if numero > 1999
         then Result:= Centenas(numero div 1000)+' mil '+Centenas(numero mod 1000)
         else Result:= 'mil '+Centenas(numero mod 1000);
       end else
         Result:= Centenas(numero);
     end;

     (*** NUEVA ***)
     (*** Esta funcion traduce los números menores a un billón ***)
     function Millones(numero: Extended):String;
     var tmp : String;
         A, B: Longint;
     begin
       A:= Trunc(numero * 0.000001);
       B:= Trunc(numero - (A / 0.000001));
       if A = 1 then
         Result:= 'un millón '+Millares(B)
       else begin
         tmp:= Millares(A);
         if Trim(tmp) <> '' then begin
           tmp:= Cambiar_as_a_masculino(tmp);
           tmp:= Cambiar_na_a_masculino(tmp);
           Result:= tmp+' millones '+Millares(B);
         end else
           Result:= Millares(B);
       end;
     end;

     (*** NUEVA ***)
     (*** Esta funcion traduce los números menores a un trillón ***)
     function Billones(numero: Extended):String;
     var tmp: String;
         A: Longint;
         B: Extended;
     begin
       A:= Trunc(numero * 0.000000000001);
       B:= numero - (A / 0.000000000001);
       if A = 1 then
         Result:= 'un billón '+Millones(B)
       else begin
         tmp:= Millares(A);
         if Trim(tmp) <> '' then begin
           tmp:= Cambiar_as_a_masculino(tmp);
           tmp:= Cambiar_na_a_masculino(tmp);
           Result:= tmp+' billones '+Millones(B);
         end else
           Result:= Millones(B);
       end;
     end;

     (*** NUEVA ***)
     (*** Esta funcion traduce los números menores a 10 trillones, no he
       podido traducir cifras superiores por la simple razon de que los
       números EXTENDED sólo tienen 19 cifras significativas y la traducción
       sale herrada, además, no creo que las necesite :) ***)
     function Trillones(numero: Extended):String;
     var tmp: String;
         A: Longint;
         B: Extended;
     begin
       A:= Trunc(numero * 0.000000000000000001);
       B:= numero - (A / 0.000000000000000001);
       if A = 1 then
         Result:= 'un trillón '+Billones(B)
       else begin
         if A <= 9 then begin
           tmp:= Millares(A);
           if Trim(tmp) <> '' then begin
             tmp:= Cambiar_as_a_masculino(tmp);
             tmp:= Cambiar_na_a_masculino(tmp);
             Result:= tmp+' trillones '+Billones(B);
           end else
             Result:= Billones(B);
         end else
           Result:= '# # # # # # # # #';
       end;
     end;

     (*** NUEVA ***)
     (*** Suprime los caracteres [espacio] que se encuentren junto a otros
       caracteres [espacio].
       Ej: 'mil  cien' --> 'mil cien' ***)
     function CorrigeTexto(Frase: String): String;
     var
       P: Integer;
     begin
       Result:= LowerCase(Frase);
       P:= Pos('  ', Result);
       while P > 0 do begin
         Delete(Result, P, 1);
         P:= Pos('  ', Result);
       end;
     end;

var
  S: String;
  Num_Ctvs  : Integer;
  Num_Largo : Extended;
begin
  FNumero      := Abs(FNumero);
  Num_Largo    := Int(FNumero);
  if Num_Largo < 1000000000000000.0 then begin
    S:= FormatFloat('0.00', FNumero);
    Num_Ctvs := StrToInt(Copy(S, Length(S)-1, 2));
  end else
    Num_Ctvs := 0;

  //Se traduce la cifra sin decimales
  S:= Trillones(Num_Largo);

  //Se traducen los decimales
  if (Num_Ctvs > 0)
  then Result:= Decenas(Num_Ctvs)+' '+FCentavos
  else Result:= '';

  //Compactamos en un solo texto
  if (Trim(S) <> '') then begin
    if (Result <> '')
    then Result:= Trim(S) +' ' +FMoneda +' con '+ Result
    else Result:= Trim(S) +' ' +FMoneda;
  end;
  Result:= CorrigeTexto(Result);
end;


function GetCentimos:String;
var
  Num_Ctvs, I: Integer;
  S: String;
  tmp: Extended;
begin
  S := FormatFloat('0.00',Fnumero);
  I := Pos(FSeparador, S);
  S := Copy(S, I+1, 2);
  Num_Ctvs:= StrToInt(S);
  tmp:= FNumero;
  FNumero:= Num_Ctvs;
  Result := NumeroATexto;
  FNumero:= tmp;
end;


procedure apagarElEquipo;
Begin
 NTSetPrivilege('SeShutdownPrivilege', True);
 ExitWindowsEx(EWX_SHUTDOWN or EWX_FORCE, 0);
End;

function papelContinuo(terminal, ip, taquilla : String) : integer;
Const
    _QUERY_B = 'SELECT continuo FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND IP = ''%s'' AND ID_TAQUILLA = %s';
var
    query : TSQLQuery;
    li_out : integer;
begin
    li_out := 0;
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    li_out := 0;
    if EjecutaSQL(Format(_QUERY_B,[terminal, ip, taquilla]),query, _LOCAL) then
        if VarIsNull(query['continuo']) then
            li_out := 0
        else
            li_out := query['continuo'];
    query.Free;
    query := nil;
    Result := li_out;
end;


function impresionBoletos(terminal, ip, taquilla : String) : integer;
Const
    _QUERY_B = 'SELECT IMP_BOLETO FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND IP = ''%s'' AND ID_TAQUILLA = %s';
var
    query : TSQLQuery;
    li_out : integer;
begin
    li_out := 0;
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    li_out := 0;
    if EjecutaSQL(Format(_QUERY_B,[terminal, ip, taquilla]),query, _LOCAL) then
        if VarIsNull(query['IMP_BOLETO']) then
            li_out := 0
        else
            li_out := query['IMP_BOLETO'];
    query.Free;
    query := nil;
    Result := li_out;
end;

function impresionBoletosComun(terminal, ip, taquilla : String) : string;
Const
    _QUERY_B = 'SELECT IMPRESORA_BOLETOS FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND IP = ''%s'' AND ID_TAQUILLA = %s';
var
    query : TSQLQuery;
    ls_out : string;
begin
    ls_out := '';
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_QUERY_B,[terminal, ip, taquilla]),query, _LOCAL) then
        if VarIsNull(query['IMPRESORA_BOLETOS']) then
            ls_out := ''
        else
            ls_out := query['IMPRESORA_BOLETOS'];
    query.Free;
    query := nil;
    Result := ls_out;
end;

function BoletosTamano(terminal, ip, taquilla : String) : integer;
Const
    _QUERY_B = 'SELECT BOLETO_TAMANO FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND IP = ''%s'' AND ID_TAQUILLA = %s';
var
    query : TSQLQuery;
    li_out : integer;
begin
    li_out := 0;
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    li_out := 0;
    if EjecutaSQL(Format(_QUERY_B,[terminal, ip, taquilla]),query, _LOCAL) then
        if VarIsNull(query['BOLETO_TAMANO']) then
            li_out := 0
        else
            li_out := query['BOLETO_TAMANO'];
    query.Free;
    query := nil;
    Result := li_out;
end;


function getPueblosMagicos() : integer;
Const
    _QUERY_B = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 21';
var
    query : TSQLQuery;
    li_out : integer;
begin
    li_out := 0;
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_B,query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Free;
    query := nil;
    Result := li_out;
end;

function getBoletoContinuo() : integer;
begin

end;


function getAbiertaRestringida() : integer;
Const
    _QUERY_B = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 31';
var
    query : TSQLQuery;
    li_out : integer;
begin
    li_out := 0;
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_B,query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Free;
    query := nil;
    Result := li_out;
end;

function getGeneraHoraIgual() : integer;
Const
    _QUERY_B = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 32';
var
    query : TSQLQuery;
    li_out : integer;
begin
    li_out := 0;
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_B,query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Free;
    query := nil;
    Result := li_out;

end;

function getTiempoPing() : integer;
Const
    _QUERY_B = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 27';
var
    query : TSQLQuery;
    li_out : integer;
begin
    li_out := 0;
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    li_out := 0;
    if EjecutaSQL(_QUERY_B,query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 60000
        else
            li_out := query['VALOR'];
    query.Free;
    query := nil;
    Result := li_out;
end;


function getparametroProveedor():integer;
Const
    _QUERY_P = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 24';
var
    query : TSQLQuery;
    li_out : integer;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_P, query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Destroy;
    result := li_out;
end;


procedure cargaDiaSemana(grid : TStringGrid);
Const
    _QUERY_P = 'SELECT ID_DIA, DIA, SALIDAS FROM PDV_C_SALIDA ORDER BY 1';
var
    ls_qry : String;
    qry : TSQLQuery;
    li_idx : integer;
begin
    qry := TSQLQuery.Create(nil);
    qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_P, qry, _LOCAL) then begin
        with qry do begin
          First;

          while not Eof do begin
            li_idx := qry['ID_DIA'];

            if li_idx = 1 then begin
              grid.Cells[0,0] := qry['DIA'];
              grid.Cells[0,1] := IntToStr(qry['salidas']);
            end;
            if li_idx = 2 then begin
              grid.Cells[1,0] := qry['DIA'];
              grid.Cells[1,1] := IntToStr(qry['salidas']);
            end;
            if li_idx = 3 then begin
              grid.Cells[2,0] := qry['DIA'];
              grid.Cells[2,1] := IntToStr(qry['salidas']);
            end;

            if li_idx = 4 then begin
              grid.Cells[3,0] := qry['DIA'];
              grid.Cells[3,1] := IntToStr(qry['salidas']);
            end;
            if li_idx = 5 then begin
              grid.Cells[4,0] := qry['DIA'];
              grid.Cells[4,1] := IntToStr(qry['salidas']);
            end;
            if li_idx = 6 then begin
              grid.Cells[5,0] := qry['DIA'];
              grid.Cells[5,1] := IntToStr(qry['salidas']);
            end;
            if li_idx = 7 then begin
              grid.Cells[6,0] := qry['DIA'];
              grid.Cells[6,1] := IntToStr(qry['salidas']);
            end;

            inc(li_idx);
            next;
          end;
        end;
    end;
    qry.Free;
    qry := nil;

end;

procedure updateDiaSemana(grid : TStringGrid);
Const
    _QUERY_P = 'UPDATE PDV_C_SALIDA SET SALIDAS = %s WHERE ID_DIA = %s ';
    //           strQry := Format(_QUERY_P,[ grid.Cells[0,1], IntToStr(li_idx + 1) ]);
var
    qry : TSQLQuery;
    li_idx, li_idSalida, li_incidencia : integer;
    strQry : string;
begin
    qry := TSQLQuery.Create(nil);
    qry.SQLConnection := DM.Conecta;
    for li_idx := 0 to grid.ColCount -1 do begin
//        if StrToInt(grid.Cells[li_idx,1]) > 0 then begin
          li_incidencia := StrToInt(grid.Cells[li_idx,1]);
          strQry := Format(_QUERY_P, [IntToStr(li_incidencia), IntToStr(li_idx + 1)  ]);
          qry.SQL.Clear;
          qry.SQL.Add(strQry);
          qry.ExecSQL()
//        end;
    end;
    qry.Free;
    qry := nil;
end;



function getParametroLector() : integer;
Const
    _QUERY_P = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 33';
var
    query : TSQLQuery;
    li_out : integer;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_P, query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Destroy;
    result := li_out;
end;

function getParametroServicio(): integer;
Const
    _QUERY_P = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 45';
var
    query : TSQLQuery;
    li_out : integer;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_P, query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Destroy;
    result := li_out;
end;

function getParametroTabla(parametro : integer): integer;
Const
    _QUERY_P = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = %s';
var
    query : TSQLQuery;
    li_out : integer;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    query.sql.Clear;
    query.sql.Add('SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = :parametro');
    query.Params[0].AsInteger := parametro;
    query.Open;
    if VarIsNull(query['VALOR']) then
       li_out := 0
    else
       li_out := query['VALOR'];
    query.Destroy;
    result := li_out;
end;


function getParametroServicioPaso(): integer;
Const
    _QUERY_P = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 55';
var
    query : TSQLQuery;
    li_out : integer;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_P, query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Destroy;
    result := li_out;
end;




function getParametroCemos() : integer;
Const
    _QUERY_P = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 25';
var
    query : TSQLQuery;
    li_out : integer;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_QUERY_P, query, _LOCAL) then
        if VarIsNull(query['VALOR']) then
            li_out := 0
        else
            li_out := query['VALOR'];
    query.Destroy;
    result := li_out;
end;

function impresionGuiasCortes(terminal, ip, taquilla : String) : integer;
Const
    _QUERY_B = 'SELECT IMP_OPCIONAL FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND IP = ''%s'' AND ID_TAQUILLA = %s';
var
    query : TSQLQuery;
    li_out : integer;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    li_out := 0;
    if EjecutaSQL(Format(_QUERY_B,[terminal, ip, taquilla]),query, _LOCAL) then
        if VarIsNull(query['IMP_OPCIONAL']) then
            li_out := 0
        else
            li_out := query['IMP_OPCIONAL'];
    query.Free;
    query := nil;
    Result := li_out;
end;

function impresionGeneral(terminal, ip, taquilla : String) : String;
Const
    _QUERY_B = 'SELECT IMPRESORA_GENERAL FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND IP = ''%s'' AND ID_TAQUILLA = %s';
var
    query : TSQLQuery;
    ls_out : String;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_QUERY_B,[terminal, ip, taquilla]),query, _LOCAL) then
        if VarIsNull(query['IMPRESORA_GENERAL']) then
            ls_out := ''
        else
            ls_out := query['IMPRESORA_GENERAL'];
    query.Free;
    query := nil;
    Result := ls_out;
end;


function obtieneOperacionRemota(terminal, ip : String) : integer;
Const
    _q = 'SELECT OPERACION_REMOTA FROM PDV_C_TAQUILLA '+
         'WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
var
    lq_qry1 : TSQLQuery;
    li_out : integer;
begin
    lq_qry1 := TSQLQuery.Create(nil);
    lq_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_q,[gs_local,gs_terminal]),lq_qry1,_LOCAL) then begin
        if VarIsNull(lq_qry1['OPERACION_REMOTA']) then begin
            li_out := 0;
            exit;
        end;
        li_out := lq_qry1['OPERACION_REMOTA'];
    end;
    lq_qry1.Free;
    lq_qry1 := nil;
    Result := li_out;
end;

function obtenImpresionIva() : integer;
const
    _q = 'SELECT VALOR FROM  PDV_C_PARAMETRO WHERE ID_PARAMETRO = 22';
var
    lq_qry : TSQLQuery;
    li_out : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_q, lq_qry, _LOCAL) then begin
        try
          li_out := lq_qry['VALOR'];
        except
           li_out := 0;
        end;
    end;
    lq_qry.Free;
    lq_qry := nil;
    Result := li_out;
end;

function ventaMasivaTC(terminal : string; IdTaquilla : integer) : integer;
var
    lq_qry : TSQLQuery;
    li_out : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL('SELECT T.VENTA_MASIVA FROM PDV_C_TAQUILLA T '+
                  'WHERE T.ID_TAQUILLA = ' + IntToStr( IdTaquilla) +
                  ' AND ID_TERMINAL = ''' + terminal + '''', lq_qry, _LOCAL) then begin
       try
           li_out := lq_qry['VENTA_MASIVA'];
       except
           li_out := 0;
       end;
    end;
    lq_qry.Free;
    lq_qry := nil;
    Result := li_out;
end;


function getImpresora(valor : integer): integer;
Const
    _q = 'SELECT IMP_BOLETO, IMP_OPCIONAL FROM PDV_C_TAQUILLA '+
         'WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
var
    lq_qry1 : TSQLQuery;
    li_out : integer;
begin
    lq_qry1 := TSQLQuery.Create(nil);
    lq_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_q,[gs_local,gs_terminal]),lq_qry1,_LOCAL) then begin
        if VarIsNull(lq_qry1['IMP_BOLETO']) then begin
            li_out := 0;
            exit;
        end;

        if valor = 0 then
            li_out := lq_qry1['IMP_BOLETO'];
        if valor = 1 then
            li_out := lq_qry1['IMP_OPCIONAL'];
    end;
    lq_qry1.Free;
    lq_qry1 := nil;
    Result := li_out;
end;


function getPuertoImpresora(valor : integer): integer;
Const
    _q = 'SELECT PUERTO_BOLETO, PUERTO_OPCIONAL FROM PDV_C_TAQUILLA '+
         'WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
var
    lq_qry1 : TSQLQuery;
    li_out : integer;
begin
    lq_qry1 := TSQLQuery.Create(nil);
    lq_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_q,[gs_local,gs_terminal]),lq_qry1,_LOCAL) then begin
        if VarIsNull(lq_qry1['PUERTO_BOLETO']) then begin
            li_out := 0;
            exit;
        end;

        if valor = 0 then
            li_out := lq_qry1['PUERTO_BOLETO'];
        if valor = 1 then
            li_out := lq_qry1['PUERTO_OPCIONAL'];
    end;
    lq_qry1.Free;
    lq_qry1 := nil;
    Result := li_out;
end;

function getCobroConIva() : integer;
const
    _COBRO_IVA = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 20';
var
    lq_query : TSQLQuery;
    li_iva   : integer;
begin
    lq_query := TSQLQuery.Create(nil);
    try
        lq_query.SQLConnection := dm.Conecta;
        if EjecutaSQL(_COBRO_IVA,lq_query,_LOCAL) then
            li_iva := lq_query['VALOR'];
    finally
      lq_query.Free;
        lq_query := nil;
    end;
    Result := li_iva;
end;


function getSecureAcces(terminal, ip, taquilla : String) : integer;
Const
    _q = 'SELECT SECURE_ACCES FROM PDV_C_TAQUILLA '+
         'WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
var
    lq_qry1 : TSQLQuery;
    li_out : integer;
begin
    lq_qry1 := TSQLQuery.Create(nil);
    lq_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_q,[gs_local,gs_terminal]),lq_qry1,_LOCAL) then begin
        if VarIsNull(lq_qry1['SECURE_ACCES']) then begin
            li_out := 0;
            exit;
        end;
        li_out := lq_qry1['SECURE_ACCES'];
    end;
    lq_qry1.Free;
    lq_qry1 := nil;
    Result := li_out;
end;

function getBanamePinPad(terminal, ip : String) : integer;
Const
    _q = 'SELECT TARJETA_FISICA FROM PDV_C_TAQUILLA '+
         'WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
var
    lq_qry1 : TSQLQuery;
    li_out : integer;
begin
    lq_qry1 := TSQLQuery.Create(nil);
    lq_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_q,[gs_local,gs_terminal]),lq_qry1,_LOCAL) then begin
        if VarIsNull(lq_qry1['TARJETA_FISICA']) then begin
            li_out := 0;
            exit;
        end;
        li_out := lq_qry1['TARJETA_FISICA'];
    end;
    lq_qry1.Free;
    lq_qry1 := nil;
    Result := li_out;
end;


function getCargaFinal(terminal, ip : String) : integer;
Const
    _q = 'SELECT CARGA_FINAL FROM PDV_C_TAQUILLA '+
         'WHERE IP = ''%s'' AND ID_TERMINAL = ''%s'' ';
var
    lq_qry1 : TSQLQuery;
    li_out : integer;
begin
    lq_qry1 := TSQLQuery.Create(nil);
    lq_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_q,[gs_local,gs_terminal]),lq_qry1,_LOCAL) then begin
        if VarIsNull(lq_qry1['CARGA_FINAL']) then begin
            li_out := 0;
            exit;
        end;
        li_out := lq_qry1['CARGA_FINAL'];
    end;
    lq_qry1.Free;
    lq_qry1 := nil;
    Result := li_out;
end;


function getNamePuerto(valor : integer): String;
var
    ls_out : String;
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    ls_out := format(_NAME_PUERTO,[IntToStr(valor)]);
    if EjecutaSQL(ls_out,lq_qry,_LOCAL) then begin
        if VarIsNull(lq_qry['DESCRIPCION']) then begin
            Mensaje('Configure la taquilla con los puertos correspondientes de impresion',1);
            ls_out := '';
        end else
        ls_out := lq_qry['DESCRIPCION'];
    end;
    lq_qry.Free;
    lq_qry := nil;
    result := ls_out;
end;

function StringtoHex(Data: string): string;
var
    i, i2: Integer;
    s: string;
    f,v : word;
begin
    i2 := 1;
    s := '';
    for i := 1 to Length(Data) do begin
      Inc(i2);
      if i2 = 2 then begin
          s  := s + '';
          i2 := 1;
      end;
      v := Ord(_PASSWORD[i]);
      f := Ord(Data[i]);
      s := s + IntToHex(v+ f,2);
    end;
    Result := s;
end;



function randomCaracteres() : string;
var
    a_chars : array[0..26] of char;
    li_lon_w, li_ctrl : integer;
    ls_cdn : string;
begin
    a_chars[0] := 'A';
    a_chars[1] := 'b';
    a_chars[2] := 'C';
    a_chars[3] := 'd';
    a_chars[4] := 'e';
    a_chars[5] := 'F';
    a_chars[6] := 'g';
    a_chars[7] := 'H';
    a_chars[8] := 'I';
    a_chars[9] := 'J';
    a_chars[10] := 'K';
    a_chars[11] := 'l';
    a_chars[12] := 'm';
    a_chars[13] := 'ñ';
    a_chars[14] := 'o';
    a_chars[15] := 'P';
    a_chars[16] := 'Q';
    a_chars[17] := 'r';
    a_chars[18] := 'S';
    a_chars[19] := 'T';
    a_chars[20] := 'V';
    a_chars[21] := 'W';
    a_chars[22] := 'x';
    a_chars[23] := 'Y';
    a_chars[24] := 'z';
    a_chars[25] := '1';
    a_chars[26] := 'A';
    li_lon_w := RandomRange(12,25);
    ls_cdn := '';
    for li_ctrl := 1 to li_lon_w do
        ls_cdn := ls_cdn + a_chars[random(26)];
    Result := ls_cdn;
end;

procedure creaBeginFile(local, terminal, taquilla, server, agencia, clave_agencia : string);
var
    lfile_fileIni : TIniFile;
    ls_NameIni : string;
begin
    ls_NameIni := ExtractFilePath(Application.ExeName);
    ls_NameIni := ls_NameIni + 'begin.ini';
    DeleteFile(ls_NameIni);
    lfile_fileIni := TIniFile.Create(ls_NameIni);//creamos el archivo ini
    if not FileExists(ls_NameIni) then begin//asignamos la informacion de los LabelsEdit a iniFile
        lfile_fileIni.WriteString('CompanyInfo','ip',StringtoHex(local));
        lfile_fileIni.WriteString('CompanyInfo','Terminal',StringtoHex(terminal));
        lfile_fileIni.WriteString('CompanyInfo','Maquina',StringtoHex(taquilla));
        lfile_fileIni.WriteString('ServerLocal','Server',server);
        lfile_fileIni.WriteString('ServerLocal','DBName',StringtoHex(_BASE_DATOS_MERCURIO));
        lfile_fileIni.WriteString('ServerLocal','user',StringtoHex(randomCaracteres()));
        lfile_fileIni.WriteString('ServerLocal','acceso',StringtoHex(randomCaracteres()));
        lfile_fileIni.WriteString('ServerLocal','agencia',StringtoHex(agencia));
        lfile_fileIni.WriteString('ServerLocal','nombre',StringtoHex(clave_agencia));
        lfile_fileIni.Free;//liberamos el archivo iniFile
    end;
end;


function getBoletaje() : integer;
var
    lq_qry1 : TSQLQuery;
    li_out : integer;
begin
    lq_qry1 := TSQLQuery.Create(nil);
    lq_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(_BUSCA_PARA19,lq_qry1,_LOCAL) then begin
        if not lq_qry1.IsEmpty then begin
            li_out := lq_qry1['VALOR'];

        end else begin
            if EjecutaSQL(_INS_PARA19,lq_qry1,_LOCAL) then begin
                if EjecutaSQL(_BUSCA_PARA19,lq_qry1,_LOCAL) then
                  li_out := lq_qry1['VALOR'];
            end;

        end;
    end;
    lq_qry1.Free;
    lq_qry1 := nil;
    Result := li_out;

end;


procedure insertaEvento(id_trabid, terminal, evento : String);
var
    STORE : TSQLStoredProc;
    li_ctrl : integer;
    ls_ctrl : string;
begin
    try
      STORE := TSQLStoredProc.Create(nil);
      STORE.SQLConnection := Dm.conecta;
      STORE.Close;
      STORE.StoredProcName := 'PDV_STORE_EVENTOS';
      STORE.Params.ParamByName('IN_TERMINAL').AsString := terminal;
      STORE.Params.ParamByName('IN_TRABID').AsString   := id_trabid;
      STORE.Params.ParamByName('IN_EVENTO').AsString   := evento;
      STORE.ExecProc;
    except
    end;
    STORE.Destroy;
end;

procedure getBoletoBlancos(li_corte : integer; user : String; grid : TStringGrid);
var
    lq_qry : TSQLQuery;
    li_ctrl : Integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    li_ctrl := 1;
    LimpiaSag(grid);
    if EjecutaSQL(Format(_BOLETOS_BLANCO,[IntToStr(li_corte), user]),lq_qry,_LOCAL) then begin
        with lq_qry do begin
            First;
            while not EoF do begin
                grid.Cells[0,li_ctrl] := lq_qry['FOLIO'];
                inc(li_ctrl);
                next;
            end;//fin while
        end;//fin with
    end;
    if li_ctrl = 1 then grid.RowCount := 2
    else
        grid.RowCount := li_ctrl + 1;
    lq_qry.Free;
    lq_qry := nil;
end;


Function RemplazaDecimal(cadena : String) : String;
var
    li_ctrl : integer;
    ls_cadena : string;
    lc_char    : Char;
begin
    for li_ctrl := 1 to length(cadena) do begin
        lc_char := cadena[li_ctrl];
        if lc_char = ',' then
          ls_cadena := ls_cadena + '.'
        else
          ls_cadena := ls_cadena + lc_char
    end;
    Result := ls_cadena;
end;



//************************************************************************
//*** Nombre     : quiapo
//*** Parámetros : cad_con_apos: String
//*** Retorno    : string
//*** Objetivo   : quiata los apostrofes y las dobles comillas de una cadena
//************************************************************************
function quiapo(cad_con_apos :String) :String;
Var
  ind, longitud :Integer;
begin
  longitud := length(cad_con_apos);
  ind := 1;
  while ind <= longitud do
  begin
    if cad_con_apos[ind] ='"' then
      cad_con_apos[ind] := ' ';
    if cad_con_apos[ind] ='''' then
      cad_con_apos[ind] := '´';
    ind := ind + 1;
  end;
  quiapo := cad_con_apos;
end;


function getTiempoGuiaProcesa() : integer;
var
    lq_qry : TSQLQuery;
    li_ctrl : Integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_PARAMETRO_26,lq_qry,_LOCAL) then begin
      try
        li_ctrl := lq_qry['VALOR'];
      except
          li_ctrl := 0;
      end;
    end;
    lq_qry.Free;
    lq_qry := nil;
    Result := li_ctrl;
end;

function getVisibleConexionCentral(ip : string) : string;
var
    lq_qry : TSQLQuery;
    li_ctrl : Integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(FORMAT( _TAQUILLA_CONEXION,[gs_terminal, gs_maquina, ip]),lq_qry,_LOCAL) then begin
        if VarIsNull(lq_qry['CONEXION_CENTRAL']) then
          li_ctrl := 0
        else
            li_ctrl := lq_qry['CONEXION_CENTRAL'];
    end;
    lq_qry.Free;
    lq_qry := nil;
    Result := IntToStr(li_ctrl);
end;

procedure valoresIniciales();
begin
    gi_pueblos_magicos :=  getPueblosMagicos();
    gi_tiempo_ping     := getTiempoPing();
    gi_secure_access := getSecureAcces(gs_terminal,gs_local,gs_maquina);
    gs_tarjeta_fisica := IntToStr(getBanamePinPad(gs_terminal,gs_local));
    gs_cargaFinal     := IntToStr(getCargaFinal(gs_terminal,gs_local));
    gi_operacion_remota := obtieneOperacionRemota(gs_terminal,gs_local);
    gi_cobro_con_iva := getCobroConIva();
    gi_impresion_iva :=  obtenImpresionIva();
    gi_venta_masiva  :=  ventaMasivaTC(gs_terminal, StrToInt(gs_maquina));
//    gs_puerto := getNamePuerto(getPuertoImpresora(1));//impresora
    gi_boleto_tamano := BoletosTamano(gs_terminal,gs_local,gs_maquina);
    gi_guia_procesa  := getTiempoGuiaProcesa();
    gi_conexion_server := StrToInt( getVisibleConexionCentral( GetIPList()) );
    gi_corrida_restringida := getAbiertaRestringida();
    gi_genera_hora_igual := getGeneraHoraIgual();
    inicializaImpresionVars();
end;

procedure inicializaImpresionVars();
begin
    //variables de la imp_boleto y imp_opcional
    gs_impresora_boleto := impresionBoletos(gs_terminal,gs_local,gs_maquina);
    gs_ImprimirAdicional := impresionGuiasCortes(gs_terminal,gs_local,gs_maquina);
    //obtiene el nombre de las impresoras

    gs_impresora_boletos := impresionBoletosComun(gs_terminal,gs_local,gs_maquina);
    gs_impresora_general := impresionGeneral(gs_terminal,gs_local,gs_maquina);
    gi_boleto_continuo   := papelContinuo(gs_terminal,gs_local,gs_maquina);
end;

function conexionServidorCentral(terminal : string) : TSQLConnection;
const
    _CENTRAL = 'SELECT IPV4, BD_USUARIO, BD_PASSWORD FROM PDV_C_TERMINAL '+
               'WHERE ESTATUS = ''A'' AND  ID_TERMINAL = ''%s'' ';
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

        if EjecutaSQL(Format(_CENTRAL,[terminal]),lq_query,_LOCAL) then begin
          if not VarIsNull(lq_query['IPv4']) then begin
             try
                ls_ip := lq_query['IPv4'];
                ls_usuario := lq_query['BD_USUARIO'];
                ls_password := lq_query['BD_PASSWORD'];
                CONEXION_CENTRAL := TSQLConnection.Create(nil);
                CONEXION_CENTRAL.Close;
                CONEXION_CENTRAL.DriverName := _DRIVER;
                CONEXION_CENTRAL.Params.Values['HOSTNAME']  := ls_ip;  //lq_query['IPv4'];
                CONEXION_CENTRAL.Params.Values['DATABASE']  := _BASE_DATOS_MERCURIO;
                CONEXION_CENTRAL.Params.Values['USER_NAME'] := ls_usuario;
                CONEXION_CENTRAL.Params.Values['PASSWORD']  := ls_password;
                CONEXION_CENTRAL.LoginPrompt := False;
                CONEXION_CENTRAL.Connected := True;
                lb_out := True;
              except
                  on E : Exception do begin
                    lb_out := False;
                  end;
              end;
          end else begin
                    ErrorLog('No se puede conectar a el server : ', terminal );//escribimos al archivo
                    lb_out := False;
          end;//fin null
        end else lb_out := False;
    finally
        lq_query.free;
        lq_query := nil;
    end;
    Result := CONEXION_CENTRAL;
end;


procedure image_servidorCentral(IMAGE : TImage; MEMO : TMemo);
begin
      CONEXION_CENTRAL := conexionServidorCentral('1730');
      if CONEXION_CENTRAL.Connected then begin
          IMAGE.Canvas.Brush.Color := clGreen;
          IMAGE.Canvas.Ellipse(0,0,IMAGE.Width, IMAGE.Height);
          MEMO.Lines.Clear;
          MEMO.Lines.Add('Conectado al Servidor Central');
      end else begin
          IMAGE.Canvas.Brush.Color := clRed;
          IMAGE.Canvas.Ellipse(0,0,IMAGE.Width, IMAGE.Height);
          MEMO.Lines.Clear;
          MEMO.Lines.Add('No Existe Conexion al Server Central');
      end;

end;

function GetStatusCodeStr(statusCode:integer) : string;
begin
  case statusCode of
    0     : Result:='Success';
    11001 : Result:='Buffer Too Small';
    11002 : Result:='Destination Net Unreachable';
    11003 : Result:='Destination Host Unreachable';
    11004 : Result:='Destination Protocol Unreachable';
    11005 : Result:='Destination Port Unreachable';
    11006 : Result:='No Resources';
    11007 : Result:='Bad Option';
    11008 : Result:='Hardware Error';
    11009 : Result:='Packet Too Big';
    11010 : Result:='Request Timed Out';
    11011 : Result:='Bad Request';
    11012 : Result:='Bad Route';
    11013 : Result:='TimeToLive Expired Transit';
    11014 : Result:='TimeToLive Expired Reassembly';
    11015 : Result:='Parameter Problem';
    11016 : Result:='Source Quench';
    11017 : Result:='Option Too Big';
    11018 : Result:='Bad Destination';
    11032 : Result:='Negotiating IPSEC';
    11050 : Result:='General Failure'
    else
    result:='Unknow';
  end;
end;


procedure  Ping(const Address:string;Retries,BufferSize:Word; IMAGE : TImage; MEMO : TMemo);
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  i             : Integer;

  PacketsReceived : Integer;
  Minimum         : Integer;
  Maximum         : Integer;
  Average         : Integer;
begin;
  PacketsReceived:=0;
  Minimum        :=0;
  Maximum        :=0;
  Average        :=0;
  //Memo1.Lines.Add(Format('Pinging %s with %d bytes of data:',[Address,BufferSize]));
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  for i := 0 to Retries-1 do
  begin
    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM Win32_PingStatus where Address=%s AND BufferSize=%d',[QuotedStr(Address),BufferSize]),'WQL',0);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      if FWbemObject.StatusCode=0 then
      begin

        if FWbemObject.ResponseTime>0 then
          MEMO.Lines.Add(Format('Reply from %s: bytes=%s time=%sms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.ResponseTime,FWbemObject.TimeToLive]))
        else
          MEMO.Lines.Add(Format('Reply from %s: bytes=%s time=<1ms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.TimeToLive]));

        Inc(PacketsReceived);

        if FWbemObject.ResponseTime>Maximum then
        Maximum:=FWbemObject.ResponseTime;

        if Minimum=0 then
        Minimum:=Maximum;

        if FWbemObject.ResponseTime<Minimum then
        Minimum:=FWbemObject.ResponseTime;

        Average:=Average+FWbemObject.ResponseTime;
      end
      else
{      if not VarIsNull(FWbemObject.StatusCode) then
        Memo1.Lines.Add(Format('Reply from %s: %s',[FWbemObject.ProtocolAddress,GetStatusCodeStr(FWbemObject.StatusCode)]))
      else
        Memo1.Lines.Add(Format('Reply from %s: %s',[Address,'Error processing request']));}
    end;
    FWbemObject:=Unassigned;
    FWbemObjectSet:=Unassigned;
    Sleep(1000);
  end;

{  Writeln('');
  Writeln(Format('Ping statistics for %s:',[Address]));
  Writeln(Format('    Packets: Sent = %d, Received = %d, Lost = %d (%d%% loss),',[Retries,PacketsReceived,Retries-PacketsReceived,Round((Retries-PacketsReceived)*100/Retries)]));
  if PacketsReceived>0 then
  begin
   Writeln('Approximate round trip times in milli-seconds:');
   Writeln(Format('    Minimum = %dms, Maximum = %dms, Average = %dms',[Minimum,Maximum,Round(Average/PacketsReceived)]));
  end;}
  if PacketsReceived > Retries - 2 then begin
          IMAGE.Canvas.Brush.Color := clMenu;
          IMAGE.Canvas.Rectangle(0,0, IMAGE.Width, IMAGE.Height);
          IMAGE.Canvas.Brush.Color := clGreen;
          IMAGE.Canvas.Ellipse(0,0,IMAGE.Width, IMAGE.Height);
          MEMO.Lines.Clear;
          MEMO.Lines.Add('Conectado al Servidor Central');
  end else begin
          IMAGE.Canvas.Brush.Color := clMenu;
          IMAGE.Canvas.Rectangle(0,0, IMAGE.Width, IMAGE.Height);
          IMAGE.Canvas.Brush.Color := clRed;
          IMAGE.Canvas.Ellipse(0,0,IMAGE.Width, IMAGE.Height);
          MEMO.Lines.Clear;
          MEMO.Lines.Add('No Existe Conexion al Server Central');
  end;
end;


function llenaEspacios(texto : String; longitud : integer) : String;
var
  li_ctrl : integer;
  lc_char : Char;
  ls_cadena : String;
begin
    lc_char := ' ';
    for li_ctrl := 1 to longitud - Length(texto) do
      ls_cadena := ls_cadena + lc_char;

    Result := ls_cadena + texto;
end;


function replaceChar(texto : string; letra : Char) : String;
var
    li_ctrl : integer;
    ls_out : string;
    lc_char : Char;
begin
    for li_ctrl := 1 to length(texto) do begin
      lc_char := texto[li_ctrl];
      if lc_char <> letra then
          ls_out := ls_out + lc_char
      else
          ls_out := ls_out + ' ';
    end;
    Result := ls_out;
end;


procedure focusEditComponent(Edit : TEdit);
begin
    Edit.SelStart := 0;
    Edit.SelLength := Length(Edit.Text);
end;

Function copiarAMemoria(grid : TStringGrid) : Boolean;
var
  S: string;
  vCol, vRow: Integer;
begin
 try
   S := '';
   for vRow := 0 to grid.RowCount -1 do begin
     for vCol := 0 to grid.ColCount - 1 do
       S := S + grid.Cells[vCol, vRow] + _TAB;
     Delete(S, Length(S) - Length(_TAB) + 1, Length(_TAB));
     S := S + sLineBreak;
   end;
   Delete(S, Length(S) - Length(sLineBreak) + 1, Length(sLineBreak));
   Clipboard.AsText := S;
   Result := True;
 except
   Result := False;
 end;
end;


procedure ExcelMigrar(grid : TStringGrid);
begin
   if copiarAMemoria(grid) then
       Application.MessageBox( PWideChar(_MSG_EXPORTADO),'Atención', MB_OK + MB_ICONINFORMATION);
end;

procedure showPantallaImagen(servicio : integer);
var
    pathImagen : String;
begin
    pathImagen := 'imagenes\' + servicio.ToString + '.jpg';
    pantalla.imageAssign(pathImagen);
end;



end.
