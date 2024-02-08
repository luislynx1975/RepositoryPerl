﻿DROP PROCEDURE IF EXISTS PDV_STORE_LIBERA_CORRIDAS;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_LIBERA_CORRIDAS(IN_ORIGEN VARCHAR(5))
BEGIN
    SELECT DISTINCT(D.ID_CORRIDA),
        CONCAT((SELECT
                    CASE P.TIPO_CORRIDA
                      WHEN 'E' THEN P.TIPO_CORRIDA
                      WHEN 'N' THEN ''
                      WHEN 'F' THEN ''
                    END AS TEXTO
                 FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
    D.FECHA, T.DESTINO, D.HORA,
    (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA
    , (S.ABREVIACION)AS ABREVIA, T.ID_TRAMO, D.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
    A.NOMBRE_IMAGEN,A.ASIENTOS,C.TIPOSERVICIO,
                      (SELECT COALESCE((SELECT MONTO
                      FROM PDV_C_TARIFA TF INNER JOIN PDV_C_TARIFA_D FD ON TF.ID_TARIFA = FD.ID_TARIFA
                      WHERE TF.ID_TRAMO = T.ID_TRAMO AND TF.ID_SERVICIO = S.TIPOSERVICIO),0))AS TARIFA,
    D.TRAB_ID
    FROM PDV_T_CORRIDA_D D INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA
                           INNER JOIN T_C_RUTA_D RD ON RD.ID_RUTA = R.ID_RUTA
                           INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = RD.ID_TRAMO
                           INNER JOIN PDV_C_TARIFA TA ON TA.ID_TRAMO = T.ID_TRAMO
                           INNER JOIN PDV_C_TARIFA_D TD ON TD.ID_TARIFA = TA.ID_TARIFA
                           INNER JOIN PDV_T_CORRIDA C ON C.ID_CORRIDA = D.ID_CORRIDA AND
                                                         C.FECHA = D.FECHA
                           INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                           INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
    WHERE T.ORIGEN = IN_ORIGEN AND D.FECHA BETWEEN CAST(NOW() AS DATE)  AND (SELECT (CURRENT_DATE() + INTERVAL (1) DAY))
                                    AND D.ESTATUS = 'A' AND D.TRAB_ID IS NOT NULL
    ORDER BY D.FECHA, D.HORA;
END $$
DELIMITER ;