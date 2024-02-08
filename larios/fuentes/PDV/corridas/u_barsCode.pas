unit u_barsCode;

interface

Const
    _MASTER_CORRIDA = 'INSERT INTO PDV_T_CORRIDA(ID_CORRIDA, FECHA, HORA, ID_TIPO_AUTOBUS, TIPOSERVICIO, '+
                      'ID_RUTA, NO_BUS, TIPO_CORRIDA, CREADO_POR) '+
                      'VALUES("%s", "%s", "%s", %s, %s, %s, NULL, "E", "BARS") ';
    _CORRIDA_DETALLE = 'INSERT INTO PDV_T_CORRIDA_D(ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, '+
                      'ID_RUTA, TRAB_ID) '+
                      'VALUES("%s", "%s", "%s", "%s", %s, 0, "A", %s, NULL) ';
    _CORRIDA_EXISTE = 'SELECT COUNT(*)AS TOTAL FROM PDV_T_CORRIDA C WHERE C.FECHA = "%s" AND ID_CORRIDA = "%s" ';

implementation

end.
