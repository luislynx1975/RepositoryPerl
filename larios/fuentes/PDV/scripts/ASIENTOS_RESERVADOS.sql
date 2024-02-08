﻿DROP PROCEDURE IF EXISTS ASIENTOS_RESERVADOS;
DELIMITER $$
CREATE PROCEDURE ASIENTOS_RESERVADOS(IN IN_CORRIDA INTEGER, IN FECHA_INPUT VARCHAR(10), IN PASAJERO VARCHAR(40))
BEGIN
    SELECT A.NO_ASIENTO,
            CASE A.STATUS
                WHEN 'V' THEN CONCAT(A.ORIGEN, ' ' ,A.DESTINO)
                WHEN 'R' THEN 'R'
                WHEN 'A' THEN 'A'
            END AS TEXTO
    FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA C ON
                      (C.ID_CORRIDA = A.ID_CORRIDA AND C.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE))
    WHERE CAST(C.FECHA AS DATE) = CAST(FECHA_INPUT AS DATE) AND A.ID_CORRIDA = IN_CORRIDA OR NOMBRE_PASAJERO = PASAJERO
    ORDER BY A.NO_ASIENTO;
END $$

DELIMITER ;