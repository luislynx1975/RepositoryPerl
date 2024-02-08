﻿DROP PROCEDURE IF EXISTS PDV_STORE_BUSCA_CUALES_NEW;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_BUSCA_CUALES_NEW(IN IN_FECHA DATE, IN IN_CORRIDA VARCHAR(15),
                                                              IN IN_ASIENTOS VARCHAR(30))
BEGIN
      SELECT COUNT(NO_ASIENTO) AS NUMERO
      FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = A.ID_CORRIDA AND C.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE))
      WHERE CAST(A.FECHA_HORA_CORRIDA AS DATE) = IN_FECHA AND A.ID_CORRIDA = IN_CORRIDA AND NO_ASIENTO IN (IN_ASIENTOS);

END $$

DELIMITER ;