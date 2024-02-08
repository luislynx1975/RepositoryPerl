DROP PROCEDURE IF EXISTS SHOW_CORRIDAS;
DELIMITER $$
CREATE PROCEDURE SHOW_CORRIDAS(IN IN_ORIGEN VARCHAR(5), IN IN_DESTINO VARCHAR(5), IN FECHA_INPUT DATE)
BEGIN
    DECLARE LD_FECHA2 DATE;
    DECLARE LT_HORA2 TIME;

-- SI EL DIA ES IGUAL AL ACTUAL Y TENEMOS DESTINO
    IF LENGTH(IN_DESTINO) > 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN

          SET LD_FECHA2 = CAST(CURRENT_DATE() + 1 AS DATE);
          SET LT_HORA2  = CAST(NOW() AS TIME);

          SELECT
                CONCAT((SELECT
                            CASE P.TIPO_CORRIDA
                              WHEN 'E' THEN P.TIPO_CORRIDA
                              WHEN 'N' THEN ''
                              WHEN 'F' THEN ''
                            END AS TEXTO
                         FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA),' ',D.HORA)  AS TIPO,
              D.FECHA, TR.DESTINO, D.HORA,
            ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%T') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,

            (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
             WHERE C.ID_CORRIDA = D.ID_CORRIDA LIMIT 1)AS ABREVIA,

             TR.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA_D   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO   TR ON R.ID_TRAMO    = TR.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE T.ID_TERMINAL = IN_ORIGEN -- AND D.HORA >= LT_HORA2
                                          AND D.FECHA BETWEEN CAST(NOW() AS DATE) AND LD_FECHA2
                                          AND TR.DESTINO = IN_DESTINO
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;



        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
          SET LD_FECHA2 = CAST(CAST(FECHA_INPUT AS DATE) + 1 AS DATE);-- EL SIGUIENTE DIA
          SELECT
                CONCAT((SELECT
                            CASE P.TIPO_CORRIDA
                              WHEN 'E' THEN P.TIPO_CORRIDA
                              WHEN 'N' THEN ''
                              WHEN 'F' THEN ''
                            END AS TEXTO
                         FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA),' ',D.HORA)  AS TIPO,
              D.FECHA, TR.DESTINO, D.HORA,
            ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%T') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,

            (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
             WHERE C.ID_CORRIDA = D.ID_CORRIDA LIMIT 1)AS ABREVIA,

             TR.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA_D   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO   TR ON R.ID_TRAMO    = TR.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE T.ID_TERMINAL = IN_ORIGEN AND D.FECHA BETWEEN FECHA_INPUT AND LD_FECHA2
                                          AND TR.DESTINO = IN_DESTINO
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;
    END IF;-- FIN DE IN_DESTINO CON VALOR


-- CUANDO EL DESTINO TIENE UN VALOR NULO
   IF LENGTH(IN_DESTINO) = 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN

--          SET LD_FECHA2 = CAST(CURRENT_DATE() + 1 AS DATE);
          SET LT_HORA2  = CAST(NOW() AS TIME);

          SELECT
                CONCAT((SELECT
                            CASE P.TIPO_CORRIDA
                              WHEN 'E' THEN P.TIPO_CORRIDA
                              WHEN 'N' THEN ''
                              WHEN 'F' THEN ''
                            END AS TEXTO
                         FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA),' ',D.HORA)  AS TIPO,
              D.FECHA, TR.DESTINO, D.HORA,
            ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%T') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,
            (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
             WHERE C.ID_CORRIDA = D.ID_CORRIDA LIMIT 1)AS ABREVIA,

             TR.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA_D   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO   TR ON R.ID_TRAMO    = TR.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE T.ID_TERMINAL = IN_ORIGEN AND D.FECHA BETWEEN CAST(NOW() AS DATE) AND CAST(CURRENT_DATE() + 1 AS DATE)
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;


        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
--          SET LD_FECHA2 = CAST(CAST(FECHA_INPUT AS DATE) + 1 AS DATE);-- EL SIGUIENTE DIA
          SELECT
                CONCAT((SELECT
                            CASE P.TIPO_CORRIDA
                              WHEN 'E' THEN P.TIPO_CORRIDA
                              WHEN 'N' THEN ''
                              WHEN 'F' THEN ''
                            END AS TEXTO
                         FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA),' ',D.HORA)  AS TIPO,
              D.FECHA, TR.DESTINO, D.HORA,
            ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%T') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,
            (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
             WHERE C.ID_CORRIDA = D.ID_CORRIDA LIMIT 1)AS ABREVIA,

             TR.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA_D   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO   TR ON R.ID_TRAMO    = TR.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE T.ID_TERMINAL = IN_ORIGEN AND D.FECHA BETWEEN FECHA_INPUT AND CAST(CAST(FECHA_INPUT AS DATE) + 1 AS DATE)
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;

   END IF;

END $$
DELIMITER ;