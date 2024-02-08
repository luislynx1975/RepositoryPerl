﻿DROP PROCEDURE IF EXISTS PDV_STORE_SHOW_CUPO;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_SHOW_CUPO(IN IN_CORRIDA VARCHAR(10), IN IN_FECHA DATE, IN IN_TERMINAL VARCHAR(5))
BEGIN
    SELECT CUPO FROM PDV_T_CORRIDA_D
    WHERE ID_CORRIDA = IN_CORRIDA AND FECHA = IN_FECHA AND ID_TERMINAL = IN_TERMINAL;
END $$
DELIMITER ;