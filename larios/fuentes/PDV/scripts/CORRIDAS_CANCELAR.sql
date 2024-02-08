﻿DROP PROCEDURE IF EXISTS CORRIDAS_CANCELAR;
DELIMITER $$
CREATE PROCEDURE CORRIDAS_CANCELAR(IN IN_ORIGEN VARCHAR(5), IN IN_DESTINO VARCHAR(5),
                                                     IN FECHA_INPUT DATE, IN IN_HORA TIME, IN IN_CORRIDA INTEGER)
BEGIN
    SELECT
          CONCAT((SELECT
                      CASE P.TIPO_CORRIDA
                        WHEN 'E' THEN P.TIPO_CORRIDA
                        WHEN 'N' THEN ''
                        WHEN 'F' THEN ''
                      END AS TEXTO
                   FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ', D.HORA)  AS TIPO,
        D.FECHA, TR.DESTINO, D.HORA,
      ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%H:%i:%s') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,
      (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
       WHERE C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)AS ABREVIA,
       TR.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS, C.TIPOSERVICIO
    FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                           INNER JOIN T_C_RUTA_D   R ON D.ID_RUTA     = R.ID_RUTA
                           INNER JOIN T_C_TRAMO   TR ON R.ID_TRAMO    = TR.ID_TRAMO
                           INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                           INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
    WHERE T.ID_TERMINAL = IN_ORIGEN  AND D.HORA >= IN_HORA
                                    AND D.FECHA = FECHA_INPUT
                                    AND TR.DESTINO = IN_DESTINO
                                    AND D.ESTATUS = 'A' AND D.ID_CORRIDA = IN_CORRIDA;


END$$
DELIMITER;