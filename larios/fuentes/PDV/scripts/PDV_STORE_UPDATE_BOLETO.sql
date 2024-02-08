﻿DROP PROCEDURE IF EXISTS PDV_STORE_UPDATE_BOLETO;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_UPDATE_BOLETO(IN IN_CORRIDA VARCHAR(10), IN IN_FECHA DATE, IN IN_HORA TIME,
                                         IN IN_ASIENTO INTEGER, OUT OUT_BOLETO INTEGER,
                                         OUT OUT_TERMINAL VARCHAR(5), OUT OUT_TRABID VARCHAR(10))
BEGIN
    UPDATE PDV_T_CORRIDA C INNER JOIN PDV_T_BOLETO B ON C.ID_CORRIDA = B.ID_CORRIDA
    SET B.ESTATUS = 'C'
    WHERE C.ID_CORRIDA = IN_CORRIDA AND C.FECHA = IN_FECHA AND C.HORA = IN_HORA AND B.NO_ASIENTO = IN_ASIENTO;

-- necesitamos el boleto, terminal, trab_id

    SELECT B.ID_BOLETO, B.ID_TERMINAL, B.TRAB_ID INTO OUT_BOLETO, OUT_TERMINAL, OUT_TRABID
    FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA C ON A.ID_CORRIDA = C.ID_CORRIDA AND
                                      CAST(A.FECHA_HORA_CORRIDA AS DATE) = C.FECHA AND
                                      CAST(A.FECHA_HORA_CORRIDA AS TIME) = C.HORA
                         INNER JOIN PDV_T_BOLETO B ON B.ID_CORRIDA = C.ID_CORRIDA AND B.FECHA = C.FECHA AND
                                                      B.NO_ASIENTO = A.NO_ASIENTO
    WHERE A.ID_CORRIDA = IN_CORRIDA AND CAST(A.FECHA_HORA_CORRIDA AS DATE) = IN_FECHA AND
          A.NO_ASIENTO = IN_ASIENTO AND C.HORA = IN_HORA;

-- borra de la tabla de asiento el asiento correspondiente

    DELETE A.*
    FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA C ON A.ID_CORRIDA = C.ID_CORRIDA AND
                                      CAST(A.FECHA_HORA_CORRIDA AS DATE) = C.FECHA AND
                                      CAST(A.FECHA_HORA_CORRIDA AS TIME) = C.HORA
                         INNER JOIN PDV_T_BOLETO B ON B.ID_CORRIDA = C.ID_CORRIDA AND B.FECHA = C.FECHA AND
                                                      B.NO_ASIENTO = A.NO_ASIENTO
    WHERE A.ID_CORRIDA = IN_CORRIDA AND CAST(A.FECHA_HORA_CORRIDA AS DATE) = IN_FECHA AND
          A.NO_ASIENTO = IN_ASIENTO AND C.HORA = IN_HORA;

END $$
DELIMITER;