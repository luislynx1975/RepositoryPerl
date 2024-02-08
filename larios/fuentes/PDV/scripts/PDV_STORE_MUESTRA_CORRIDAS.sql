DROP PROCEDURE IF EXISTS PDV_STORE_MUESTRA_CORRIDAS;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_MUESTRA_CORRIDAS(IN IN_ORIGEN VARCHAR(5), IN IN_DESTINO VARCHAR(5),
                                                     IN FECHA_INPUT DATE, IN FECHA_SIGUIENTE DATE)
BEGIN
-- SI EL DIA ES IGUAL AL ACTUAL Y TENEMOS DESTINO

    IF LENGTH(IN_DESTINO) > 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
            SELECT DISTINCT D.ID_CORRIDA,
                  CONCAT((SELECT
                                      CASE P.TIPO_CORRIDA
                                        WHEN 'E' THEN P.TIPO_CORRIDA
                                        WHEN 'N' THEN ''
                                        WHEN 'F' THEN ''
                                      END AS TEXTO
                                   FROM PDV_T_CORRIDA P
                          WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
                    D.FECHA, T.DESTINO, D.HORA,(S.ABREVIACION)AS ABREVIA,
                    (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                    D.ID_RUTA, (1)AS ID_TRAMO, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                    A.NOMBRE_IMAGEN,A.ASIENTOS,C.TIPOSERVICIO
            FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_CORRIDA C ON C.FECHA = D.FECHA AND C.HORA = D.HORA
                                   INNER JOIN T_C_RUTA_D R ON R.ID_RUTA = D.ID_RUTA
                                   INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = R.ID_TRAMO
                                   INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                   INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
            WHERE D.FECHA BETWEEN CAST(NOW() AS DATE) AND FECHA_SIGUIENTE AND
                              D.ESTATUS = 'A' AND T.DESTINO =  IN_DESTINO AND D.ID_TERMINAL = IN_ORIGEN
            ORDER BY D.FECHA, D.HORA , R.ORDEN;
        END IF;

        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
            SELECT DISTINCT D.ID_CORRIDA,
                  CONCAT((SELECT
                                      CASE P.TIPO_CORRIDA
                                        WHEN 'E' THEN P.TIPO_CORRIDA
                                        WHEN 'N' THEN ''
                                        WHEN 'F' THEN ''
                                      END AS TEXTO
                                   FROM PDV_T_CORRIDA P
                          WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
                    D.FECHA, T.DESTINO, D.HORA,(S.ABREVIACION)AS ABREVIA,
                    (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                    D.ID_RUTA, (1)AS ID_TRAMO, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                    A.NOMBRE_IMAGEN,A.ASIENTOS,C.TIPOSERVICIO
            FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_CORRIDA C ON C.FECHA = D.FECHA AND C.HORA = D.HORA
                                   INNER JOIN T_C_RUTA_D R ON R.ID_RUTA = D.ID_RUTA
                                   INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = R.ID_TRAMO
                                   INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                   INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
            WHERE D.FECHA BETWEEN FECHA_INPUT AND FECHA_SIGUIENTE AND
                              D.ESTATUS = 'A' AND T.DESTINO =  IN_DESTINO AND D.ID_TERMINAL = IN_ORIGEN
            ORDER BY D.FECHA, D.HORA , R.ORDEN;
        END IF;
    END IF;-- FIN DE IN_DESTINO CON VALOR


-- CUANDO EL DESTINO TIENE UN VALOR NULO
   IF LENGTH(IN_DESTINO) = 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
            SELECT DISTINCT D.ID_CORRIDA,
                  CONCAT((SELECT
                                      CASE P.TIPO_CORRIDA
                                        WHEN 'E' THEN P.TIPO_CORRIDA
                                        WHEN 'N' THEN ''
                                        WHEN 'F' THEN ''
                                      END AS TEXTO
                                   FROM PDV_T_CORRIDA P
                          WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
                    D.FECHA, T.DESTINO, D.HORA,(S.ABREVIACION)AS ABREVIA,
                    (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                    D.ID_RUTA, (1)AS ID_TRAMO, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                    A.NOMBRE_IMAGEN,A.ASIENTOS,C.TIPOSERVICIO
            FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_CORRIDA C ON C.FECHA = D.FECHA AND C.HORA = D.HORA
                                   INNER JOIN T_C_RUTA_D R ON R.ID_RUTA = D.ID_RUTA
                                   INNER JOIN T_C_RUTA RU  ON RU.ID_RUTA = D.ID_RUTA
                                   INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = R.ID_TRAMO
                                   INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                   INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
            WHERE D.FECHA BETWEEN CAST(NOW() AS DATE)  AND FECHA_SIGUIENTE AND D.ESTATUS = 'A' AND
                        T.DESTINO =  RU.DESTINO AND D.ID_TERMINAL = IN_ORIGEN
            ORDER BY D.FECHA, D.HORA , R.ORDEN;


        END IF;
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
            SELECT DISTINCT D.ID_CORRIDA,
                  CONCAT((SELECT
                                      CASE P.TIPO_CORRIDA
                                        WHEN 'E' THEN P.TIPO_CORRIDA
                                        WHEN 'N' THEN ''
                                        WHEN 'F' THEN ''
                                      END AS TEXTO
                                   FROM PDV_T_CORRIDA P
                          WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
                    D.FECHA, T.DESTINO, D.HORA,(S.ABREVIACION)AS ABREVIA,
                    (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                    D.ID_RUTA, (1)AS ID_TRAMO, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                    A.NOMBRE_IMAGEN,A.ASIENTOS,C.TIPOSERVICIO
            FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_CORRIDA C ON C.FECHA = D.FECHA AND C.HORA = D.HORA
                                   INNER JOIN T_C_RUTA_D R ON R.ID_RUTA = D.ID_RUTA
                                   INNER JOIN T_C_RUTA RU  ON RU.ID_RUTA = D.ID_RUTA
                                   INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = R.ID_TRAMO
                                   INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                   INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
            WHERE D.FECHA BETWEEN FECHA_INPUT AND FECHA_SIGUIENTE AND D.ESTATUS = 'A' AND
                        T.DESTINO =  RU.DESTINO AND D.ID_TERMINAL = IN_ORIGEN
            ORDER BY D.FECHA, D.HORA , R.ORDEN;

        END IF;

   END IF;


END $$

DELIMITER ;