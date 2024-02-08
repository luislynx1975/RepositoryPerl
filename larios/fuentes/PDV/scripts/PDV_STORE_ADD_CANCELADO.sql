﻿DROP PROCEDURE IF EXISTS PDV_STORE_ADD_CANCELADO;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_ADD_CANCELADO(IN IN_BOLETO INTEGER, IN IN_TERMINAL VARCHAR(5),
                                         IN IN_TRAB_CANCELA VARCHAR(10), IN IN_TAQUILLA INTEGER,
                                         IN IN_TRABID VARCHAR(10))
BEGIN
    INSERT INTO PDV_T_BOLETO_CANCELADO(ID_BOLETO, ID_TERMINAL,TRAB_ID_CANCELADO, FECHA_HORA_CANCELADO,
                                       ID_TAQUILLA, TRAB_ID)
    VALUES(IN_BOLETO,IN_TERMINAL,IN_TRAB_CANCELA,NOW(),IN_TAQUILLA,IN_TRABID);

END$$
DELIMITER ;
