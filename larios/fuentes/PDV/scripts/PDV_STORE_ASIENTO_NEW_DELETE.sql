﻿DROP PROCEDURE IF EXISTS PDV_STORE_ASIENTO_NEW_DELETE;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_ASIENTO_NEW_DELETE(IN IN_CORRIDA VARCHAR(10),   IN IN_FECHA VARCHAR(20), IN IN_ASIENTO INTEGER,
                                    IN IN_TRABID VARCHAR(8), IN IN_ORIGEN VARCHAR(8),
                                    IN IN_DESTINO VARCHAR(8), IN IN_STATUS CHAR(1), IN IN_NUEVO CHAR(1))
BEGIN
    IF IN_NUEVO = 'N' THEN
      INSERT INTO PDV_T_ASIENTO(ID_CORRIDA, FECHA_HORA_CORRIDA, NO_ASIENTO, TRAB_ID, ORIGEN, DESTINO,STATUS)
      VALUES(IN_CORRIDA, IN_FECHA, IN_ASIENTO, IN_TRABID, IN_ORIGEN, IN_DESTINO, 'V');
    END IF;

    IF IN_NUEVO = 'D' THEN
        DELETE FROM PDV_T_ASIENTO
        WHERE ID_CORRIDA = IN_CORRIDA AND FECHA_HORA_CORRIDA = IN_FECHA AND NO_ASIENTO = IN_ASIENTO AND
          TRAB_ID = IN_TRABID AND STATUS = IN_STATUS;
    END IF;

END $$

DELIMITER ;