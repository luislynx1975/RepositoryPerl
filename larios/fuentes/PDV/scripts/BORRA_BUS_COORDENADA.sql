﻿DROP PROCEDURE IF EXISTS BORRA_BUS_CORDENADA;
DELIMITER $$
CREATE PROCEDURE BORRA_BUS_CORDENADA(IN BUS_ID INTEGER)
BEGIN
    DELETE FROM PDV_C_TIPO_AUTOBUS_D WHERE ID_TIPO_AUTOBUS = BUS_ID;
END $$
DELIMITER ;