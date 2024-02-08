DROP PROCEDURE IF EXISTS PDV_STORE_FOR_CANCELAR;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_FOR_CANCELAR(IN IN_ORIGEN VARCHAR(5), IN IN_DESTINO VARCHAR(5),
                                                     IN FECHA_INPUT DATE, IN FECHA_SIGUIENTE DATE)
BEGIN
-- SI EL DIA ES IGUAL AL ACTUAL Y TENEMOS DESTINO
 IF LENGTH(IN_DESTINO) > 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
            SELECT DISTINCT A.ID_CORRIDA,
                          CONCAT((SELECT
                                      CASE P.TIPO_CORRIDA
                                        WHEN 'E' THEN P.TIPO_CORRIDA
                                        WHEN 'N' THEN ''
                                        WHEN 'F' THEN ''
                                      END AS TEXTO
                                   FROM PDV_T_CORRIDA P
                      WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO, D.FECHA, A.DESTINO, D.HORA,
                      (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                     (S.ABREVIACION)AS ABREVI, (1)AS ID_TRAMO , D.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                      AU.NOMBRE_IMAGEN,AU.ASIENTOS,C.TIPOSERVICIO, 0
            FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA_D D ON A.ID_CORRIDA = D.ID_CORRIDA AND
                                                              CAST(A.FECHA_HORA_CORRIDA AS DATE) = D.FECHA AND
                                                              CAST(A.FECHA_HORA_CORRIDA AS TIME) = D.HORA
                                  INNER JOIN PDV_T_CORRIDA C ON D.FECHA = C.FECHA AND D.HORA = C.HORA
                                  INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                  INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA
                                  INNER JOIN PDV_C_TIPO_AUTOBUS AU ON C.ID_TIPO_AUTOBUS = AU.ID_TIPO_AUTOBUS
            WHERE A.ORIGEN = IN_ORIGEN AND A.DESTINO = IN_DESTINO AND D.FECHA BETWEEN CURRENT_DATE() AND FECHA_SIGUIENTE
                                   AND D.ESTATUS = 'A'
            ORDER BY D.FECHA, D.HORA;
        END IF;

        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
            SELECT DISTINCT A.ID_CORRIDA,
                          CONCAT((SELECT
                                      CASE P.TIPO_CORRIDA
                                        WHEN 'E' THEN P.TIPO_CORRIDA
                                        WHEN 'N' THEN ''
                                        WHEN 'F' THEN ''
                                      END AS TEXTO
                                   FROM PDV_T_CORRIDA P
                      WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO, D.FECHA, A.DESTINO, D.HORA,
                      (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                     (S.ABREVIACION)AS ABREVI, (1)AS ID_TRAMO , D.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                      AU.NOMBRE_IMAGEN,AU.ASIENTOS,C.TIPOSERVICIO, 0
            FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA_D D ON A.ID_CORRIDA = D.ID_CORRIDA AND
                                                              CAST(A.FECHA_HORA_CORRIDA AS DATE) = D.FECHA AND
                                                              CAST(A.FECHA_HORA_CORRIDA AS TIME) = D.HORA
                                  INNER JOIN PDV_T_CORRIDA C ON D.FECHA = C.FECHA AND D.HORA = C.HORA
                                  INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                  INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA
                                  INNER JOIN PDV_C_TIPO_AUTOBUS AU ON C.ID_TIPO_AUTOBUS = AU.ID_TIPO_AUTOBUS
            WHERE A.ORIGEN = IN_ORIGEN AND A.DESTINO = IN_DESTINO AND D.FECHA BETWEEN FECHA_INPUT AND FECHA_SIGUIENTE
                                   AND D.ESTATUS = 'A'
            ORDER BY D.FECHA, D.HORA;
        END IF;
    END IF;-- FIN DE IN_DESTINO CON VALOR


-- CUANDO EL DESTINO TIENE UN VALOR NULO
   IF LENGTH(IN_DESTINO) = 0 THEN
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') = DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
          SELECT DISTINCT A.ID_CORRIDA,
                        CONCAT((SELECT
                                    CASE P.TIPO_CORRIDA
                                      WHEN 'E' THEN P.TIPO_CORRIDA
                                      WHEN 'N' THEN ''
                                      WHEN 'F' THEN ''
                                    END AS TEXTO
                                 FROM PDV_T_CORRIDA P
                    WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO, D.FECHA, A.DESTINO, D.HORA,
                    (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                   (S.ABREVIACION)AS ABREVI, (1)AS ID_TRAMO , D.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                    AU.NOMBRE_IMAGEN,AU.ASIENTOS,C.TIPOSERVICIO, 0
          FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA_D D ON A.ID_CORRIDA = D.ID_CORRIDA AND
                                                            CAST(A.FECHA_HORA_CORRIDA AS DATE) = D.FECHA AND
                                                            CAST(A.FECHA_HORA_CORRIDA AS TIME) = D.HORA
                                INNER JOIN PDV_T_CORRIDA C ON D.FECHA = C.FECHA AND D.HORA = C.HORA
                                INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA
                                INNER JOIN PDV_C_TIPO_AUTOBUS AU ON C.ID_TIPO_AUTOBUS = AU.ID_TIPO_AUTOBUS
          WHERE A.ORIGEN = IN_ORIGEN AND  D.FECHA BETWEEN CURRENT_DATE() AND FECHA_SIGUIENTE
                                 AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;
        IF  DATE_FORMAT(FECHA_INPUT,'%Y %m %d') != DATE_FORMAT(NOW(  ),'%Y %m %d')  THEN
          SELECT DISTINCT A.ID_CORRIDA,
                        CONCAT((SELECT
                                    CASE P.TIPO_CORRIDA
                                      WHEN 'E' THEN P.TIPO_CORRIDA
                                      WHEN 'N' THEN ''
                                      WHEN 'F' THEN ''
                                    END AS TEXTO
                                 FROM PDV_T_CORRIDA P
                    WHERE P.ID_CORRIDA = D.ID_CORRIDA AND P.FECHA = D.FECHA),' ',D.HORA)  AS TIPO, D.FECHA, A.DESTINO, D.HORA,
                    (SELECT CURRENT_TIMESTAMP() <= (CAST(CONCAT(D.FECHA,' ',D.HORA) AS DATETIME)))AS COMPARA,
                   (S.ABREVIACION)AS ABREVI, (1)AS ID_TRAMO , D.ID_RUTA, D.ID_CORRIDA, C.ID_TIPO_AUTOBUS,
                    AU.NOMBRE_IMAGEN,AU.ASIENTOS,C.TIPOSERVICIO, 0
          FROM PDV_T_ASIENTO A INNER JOIN PDV_T_CORRIDA_D D ON A.ID_CORRIDA = D.ID_CORRIDA AND
                                                            CAST(A.FECHA_HORA_CORRIDA AS DATE) = D.FECHA AND
                                                            CAST(A.FECHA_HORA_CORRIDA AS TIME) = D.HORA
                                INNER JOIN PDV_T_CORRIDA C ON D.FECHA = C.FECHA AND D.HORA = C.HORA
                                INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO
                                INNER JOIN T_C_RUTA R ON R.ID_RUTA = D.ID_RUTA
                                INNER JOIN PDV_C_TIPO_AUTOBUS AU ON C.ID_TIPO_AUTOBUS = AU.ID_TIPO_AUTOBUS

          WHERE A.ORIGEN = IN_ORIGEN AND  D.FECHA BETWEEN FECHA_INPUT AND FECHA_SIGUIENTE
                                 AND D.ESTATUS = 'A'
          ORDER BY D.FECHA, D.HORA;
        END IF;

   END IF;



END $$

DELIMITER ;