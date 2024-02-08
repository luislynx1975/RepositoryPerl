DROP PROCEDURE IF EXISTS PDV_STORE_MUESTRA_PREDESPACHO;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_MUESTRA_PREDESPACHO(IN IN_ORIGEN VARCHAR(5), IN IN_DESTINO VARCHAR(5),
                                                     IN FECHA_INPUT DATE, IN FECHA_SIGUIENTE DATE)
BEGIN
-- SI EL DIA ES IGUAL AL ACTUAL Y TENEMOS DESTINO
    IF LENGTH(IN_DESTINO) > 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
          SELECT
              CONCAT((SELECT
                          CASE P.TIPO_CORRIDA
                            WHEN 'E' THEN P.TIPO_CORRIDA
                            WHEN 'N' THEN ''
                            WHEN 'F' THEN ''
                          END AS TEXTO
                       FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
          D.FECHA, TR.DESTINO, D.HORA,
          ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%H:%i:%s') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,
          (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
           WHERE C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)AS ABREVIA,
          RD.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS, C.TIPOSERVICIO
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_RUTA_D RD ON RD.ID_RUTA = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO TR ON TR.ID_TRAMO = RD.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE TR.ORIGEN = IN_ORIGEN -- AND D.HORA >= LT_HORA2
                                          AND D.FECHA BETWEEN CAST(NOW() AS DATE) AND FECHA_SIGUIENTE
                                          AND TR.DESTINO = IN_DESTINO
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;

        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
          SELECT
              CONCAT((SELECT
                          CASE P.TIPO_CORRIDA
                            WHEN 'E' THEN P.TIPO_CORRIDA
                            WHEN 'N' THEN ''
                            WHEN 'F' THEN ''
                          END AS TEXTO
                       FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
          D.FECHA, TR.DESTINO, D.HORA,
          ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%H:%i:%s') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,
          (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
           WHERE C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)AS ABREVIA,
          RD.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS, C.TIPOSERVICIO
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_RUTA_D RD ON RD.ID_RUTA = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO TR ON TR.ID_TRAMO = RD.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE TR.ORIGEN = IN_ORIGEN AND D.FECHA BETWEEN FECHA_INPUT AND FECHA_SIGUIENTE
                                          AND TR.DESTINO = IN_DESTINO
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;
    END IF;-- FIN DE IN_DESTINO CON VALOR


-- CUANDO EL DESTINO TIENE UN VALOR NULO
   IF LENGTH(IN_DESTINO) = 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
          SELECT
              CONCAT((SELECT
                          CASE P.TIPO_CORRIDA
                            WHEN 'E' THEN P.TIPO_CORRIDA
                            WHEN 'N' THEN ''
                            WHEN 'F' THEN ''
                          END AS TEXTO
                       FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
          D.FECHA, TR.DESTINO, D.HORA,
          ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%H:%i:%s') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,
          (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
           WHERE C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)AS ABREVIA,
          RD.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS, C.TIPOSERVICIO
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_RUTA_D RD ON RD.ID_RUTA = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO TR ON TR.ID_TRAMO = RD.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE TR.ORIGEN = IN_ORIGEN AND D.FECHA BETWEEN CAST(NOW() AS DATE) AND FECHA_SIGUIENTE
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
          SELECT
              CONCAT((SELECT
                          CASE P.TIPO_CORRIDA
                            WHEN 'E' THEN P.TIPO_CORRIDA
                            WHEN 'N' THEN ''
                            WHEN 'F' THEN ''
                          END AS TEXTO
                       FROM PDV_T_CORRIDA P WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO,
          D.FECHA, TR.DESTINO, D.HORA,
          ( (SELECT (CAST(DATE_FORMAT(current_timestamp(),'%H:%i:%s') AS TIME))AS HORA ) <= D.HORA)AS COMPARA,
          (SELECT S.ABREVIACION FROM SERVICIOS S INNER JOIN PDV_T_CORRIDA C ON S.TIPOSERVICIO = C.TIPOSERVICIO
           WHERE C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)AS ABREVIA,
          RD.ID_TRAMO, R.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS, A.NOMBRE_IMAGEN, A.ASIENTOS, C.TIPOSERVICIO
          FROM PDV_T_CORRIDA_D D INNER JOIN T_C_TERMINAL T ON D.ID_TERMINAL = T.ID_TERMINAL
                                 INNER JOIN T_C_RUTA   R ON D.ID_RUTA     = R.ID_RUTA
                                 INNER JOIN T_C_RUTA_D RD ON RD.ID_RUTA = R.ID_RUTA
                                 INNER JOIN T_C_TRAMO TR ON TR.ID_TRAMO = RD.ID_TRAMO
                                 INNER JOIN PDV_T_CORRIDA C ON (C.ID_CORRIDA = D.ID_CORRIDA AND D.FECHA = C.FECHA)
                                 INNER JOIN PDV_C_TIPO_AUTOBUS A ON C.ID_TIPO_AUTOBUS = A.ID_TIPO_AUTOBUS
          WHERE TR.ORIGEN = IN_ORIGEN AND D.FECHA BETWEEN FECHA_INPUT AND FECHA_SIGUIENTE
                                          AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;

   END IF;


END $$

DELIMITER ;