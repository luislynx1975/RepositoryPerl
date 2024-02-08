﻿DROP PROCEDURE IF EXISTS RESERVA_ASIENTO;
DELIMITER $$
CREATE PROCEDURE RESERVA_ASIENTO(IN IN_CORRIDA INTEGER, IN IN_FECHA VARCHAR(19), IN IN_ASIENTO INTEGER,
                                 IN IN_TERMINAL VARCHAR(5), IN TRABID VARCHAR(10), IN IN_ORIGEN VARCHAR(5),
                                 IN IN_DESTINO VARCHAR(5))
BEGIN
    INSERT INTO PDV_T_ASIENTO(ID_CORRIDA,FECHA_HORA_CORRIDA,NO_ASIENTO,TERMINAL_RESERVACION,
                              TRAB_ID, ORIGEN, DESTINO,STATUS)
    VALUES(IN_CORRIDA,CAST(IN_FECHA AS DATETIME),IN_ASIENTO,IN_TERMINAL,TRABID,IN_ORIGEN,IN_DESTINO,'R');
END$$
DELIMITER;