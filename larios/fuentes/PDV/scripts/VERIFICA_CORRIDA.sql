﻿DROP PROCEDURE IF EXISTS VERIFICA_CORRIDA;
DELIMITER $$
CREATE PROCEDURE VERIFICA_CORRIDA(IN IN_CORRIDA INTEGER, IN INPUT_FECHA DATE, IN INPUT_HORA TIME, IN TERMINAL VARCHAR(5))
BEGIN

    SELECT (CONCAT(E.PATERNO,' ', E.MATERNO,' ',E.NOMBRES))AS NOMBRE,D.TRAB_ID
    FROM PDV_T_CORRIDA_D D INNER JOIN EMPLEADOS E ON D.TRAB_ID = E.TRAB_ID
    WHERE D.ID_CORRIDA = IN_CORRIDA AND D.FECHA = CAST(INPUT_FECHA AS DATE) AND D.ID_TERMINAL = TERMINAL AND
          D.HORA = CAST(INPUT_HORA AS TIME);
END $$
DELIMITER;