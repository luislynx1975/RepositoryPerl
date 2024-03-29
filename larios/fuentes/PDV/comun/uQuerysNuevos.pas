unit uQuerysNuevos;

interface

Const
    _LISTA_TERMINALES = 'SELECT CT.ID_TERMINAL,CT.DESCRIPCION '+
              'FROM T_C_TERMINAL CT INNER JOIN PDV_C_TERMINAL T ON CT.ID_TERMINAL = T.ID_TERMINAL '+
              'WHERE CT.FECHA_BAJA IS NULL AND T.ESTATUS = ''A'' AND '+
              'T.ID_TERMINAL IN (SELECT ID_TERMINAL FROM T_C_TERMINAL T WHERE T.EMPRESA IN (SELECT EMPRESA FROM T_C_TERMINAL C WHERE AUTO = ''A'' AND ID_TERMINAL = ''%s'' )) '+
              'UNION '+
              'SELECT ID_TERMINAL, DESCRIPCION FROM T_C_TERMINAL WHERE ID_TERMINAL = ''%s'' '+
              'ORDER BY 1';
    _CONEXION_REMOTA = 'SELECT IPV4, BD_USUARIO, BD_PASSWORD FROM PDV_C_TERMINAL WHERE ESTATUS = ''A'' AND  ID_TERMINAL = :term';

    _DIA_SIGUIENTE = 'SELECT ADDDATE(:dia,INTERVAL 1 DAY )as fecha';


    _UPDATE_CORRIDA_NEWD = 'UPDATE PDV_T_CORRIDA_D D SET ESTATUS = :estado '+
               'WHERE ID_cORRIDA = :corridaId  AND FECHA = :dia AND ID_TERMINAL = :terminalID ';
implementation

end.
