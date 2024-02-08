﻿DROP PROCEDURE IF EXISTS PDV_STORE_ASIENTO_VENDIDO;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_ASIENTO_VENDIDO(IN IN_CORRIDA VARCHAR(10), IN IN_FECHA DATETIME, IN ASIENTO INTEGER,
                                 IN IN_TRABID VARCHAR(7), IN IN_ORIGEN VARCHAR(5), IN DESTINO VARCHAR(5))
BEGIN
    INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,TRAB_ID,ORIGEN,DESTINO)
    VALUES(IN_CORRIDA, IN_FECHA, ASIENTO, IN_TRABID, IN_ORIGEN, IN_DESTINO);
END $$

DELIMITER ;