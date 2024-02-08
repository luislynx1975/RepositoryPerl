﻿DROP PROCEDURE IF EXISTS PDV_STORE_RUTAS_TARIFA;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_RUTAS_TARIFA(IN INPUT INTEGER)
BEGIN
      SELECT D.ID_RUTA, D.ORDEN, T.ID_TRAMO, ORIGEN,DESTINO,ID_SERVICIO,
                      ((SELECT MONTO FROM PDV_C_TARIFA_D D
                        WHERE D.ID_TARIFA = TA.ID_TARIFA AND
                              D.FECHA_HORA_APLICA <= NOW()))AS MONTO
      FROM T_C_RUTA_D D INNER JOIN T_C_TRAMO T ON  T.ID_TRAMO = D.ID_TRAMO
                        INNER JOIN PDV_C_TARIFA TA ON TA.ID_TRAMO = T.ID_TRAMO
      ORDER BY 1;
END$$
DELIMITER;