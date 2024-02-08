DROP PROCEDURE IF EXISTS PDV_PROCEDURE_CUPO_RUTA;
DELIMITER $$
CREATE PROCEDURE PDV_PROCEDURE_CUPO_RUTA(IN_CORRIDA INTEGER,IN_HORA VARCHAR(8),IN_FECHA VARCHAR(10),IN_TERMINAL VARCHAR(7),IN_RUTA INTEGER)
BEGIN
      SELECT (COALESCE(SUM(ID.CUPO),0)+
                    (SELECT CUPO
                    FROM PDV_T_CORRIDA_D C
                    WHERE C.ID_CORRIDA = IN_CORRIDA AND C.HORA = IN_HORA AND
                          C.ID_RUTA = IN_RUTA AND C.FECHA = IN_FECHA) ) AS CUPO
      FROM PDV_C_ITINERARIO_D ID
      WHERE ID_TERMINAL IN (
                          SELECT T.ORIGEN
                          FROM T_C_RUTA_D RD INNER JOIN T_C_TRAMO T ON RD.ID_TRAMO = T.ID_TRAMO
                          WHERE RD.ID_RUTA = IN_RUTA AND RD.ORDEN < (
                                SELECT D.ORDEN
                                FROM PDV_T_CORRIDA_D C INNER JOIN T_C_RUTA R ON C.ID_RUTA = R.ID_RUTA
                                                     INNER JOIN T_C_RUTA_D D ON R.ID_RUTA = D.ID_RUTA
                                                     INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = D.ID_TRAMO
                                WHERE C.ID_CORRIDA = IN_CORRIDA AND C.HORA = IN_HORA AND R.ID_RUTA = IN_RUTA AND C.FECHA = IN_FECHA
                                      AND T.ORIGEN = IN_TERMINAL
                                )
                          );
END $$
DELIMITER;