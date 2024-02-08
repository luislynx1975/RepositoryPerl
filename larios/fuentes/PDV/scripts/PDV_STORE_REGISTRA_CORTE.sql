﻿DROP PROCEDURE IF EXISTS PDV_STORE_REGISTRA_CORTE;
DELIMITER $$
CREATE PROCEDURE PDV_STORE_REGISTRA_CORTE(IN IN_TRABID VARCHAR(10),
                                         IN IN_TERMINAL VARCHAR(10),
                                         IN IN_TAQUILLA INTEGER)
BEGIN
     INSERT INTO PDV_T_CORTE
      SELECT IN_TERMINAL,(MAX(ID_CORTE) +1), IN_TAQUILLA,
              ( SELECT E.TRAB_ID
                FROM PDV_C_USUARIO E
                WHERE NOT EXISTS ( SELECT ID_CORTE
                               FROM PDV_T_CORTE WHERE ID_EMPLEADO = IN_TRABID AND
                               ESTATUS IN ('A','F')
                    ) AND E.TRAB_ID = IN_TRABID
          ), NOW(),NULL, 'A', NULL, NULL FROM PDV_T_CORTE;

      UPDATE PDV_T_CORTE SET ESTATUS = 'A', ID_TAQUILLA = IN_TAQUILLA
      WHERE ESTATUS  IN ('S','P') AND ID_EMPLEADO = IN_TRABID;

      SELECT TRABID, ESTATUS, ID_TAQUILLA, FONDO_INICIAL
      FROM PDV_T_CORTE
      WHERE ESTATUS IN ('A') AND ID_EMPLEADO = IN_TRABID;

END $$
DELIMITER ;