﻿DROP PROCEDURE IF EXISTS PDV_STORE_DESCUENTO_OCUPANTE;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_DESCUENTO_OCUPANTE(IN IN_ABREVIA VARCHAR(1))
BEGIN
    SELECT O.ID_OCUPANTE,O.DESCRIPCION, O.DESCUENTO FROM PDV_C_OCUPANTE O
    WHERE O.ABREVIACION = IN_ABREVIA;
END $$

DELIMITER ;