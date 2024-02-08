unit u_main;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    windows, Grids, Dialogs, StdCtrls, comun, DMdb, lsCombobox, SysUtils,
    ExtCtrls, Graphics, Variants, Data.SqlExpr;
Const
    c1 = 52845;
    c2 = 22719;
    _KEY = 100;
    _CARACTERES_VALIDOS_NUMEROS : SET OF CHAR = ['0','1','2','3','4','5','6','7','8','9'];
    _qry_privilegios_usr   = 'SELECT ID_PRIVILEGIO FROM PDV_C_GRUPO_PRIVILEGIOS P WHERE ID_GRUPO = %s';
    _qry_userprivi_delete  = 'DELETE FROM PDV_C_PRIVILEGIO_C_USUARIO WHERE ID_PRIVILEGIO = %s AND ID_EMPLEADO = ''%s'';';
    _qry_insert_privilegio = 'INSERT INTO PDV_C_PRIVILEGIO_C_USUARIO VALUES(%s,''%s''); ';
    _qry_UserEqualsGroup   = 'SELECT  PP.ID_PRIVILEGIO, PP.ID_EMPLEADO '+
                             ' FROM PDV_C_GRUPO_PRIVILEGIOS P INNER JOIN PDV_C_USUARIO PU ON P.ID_GRUPO=PU.ID_GRUPO '+
                             '                                INNER JOIN PDV_C_PRIVILEGIO_C_USUARIO PP ON P.ID_PRIVILEGIO=PP.ID_PRIVILEGIO '+
                             ' WHERE NOW() < FECHA_BAJA AND NOW() < FECHA_PASSWORD AND '+
                             '       PP.ID_PRIVILEGIO = P.ID_PRIVILEGIO AND P.ID_GRUPO = %s';
    _qry_UserEqualsGroupUnique = 'SELECT  DISTINCT PP.ID_EMPLEADO '+
                                 'FROM PDV_C_GRUPO_PRIVILEGIOS P INNER JOIN PDV_C_USUARIO PU ON P.ID_GRUPO=PU.ID_GRUPO '+
                                 '                            INNER JOIN PDV_C_PRIVILEGIO_C_USUARIO PP ON P.ID_PRIVILEGIO=PP.ID_PRIVILEGIO '+
                                 'WHERE NOW() < FECHA_BAJA AND NOW() < FECHA_PASSWORD AND '+
                                 '   PP.ID_PRIVILEGIO = P.ID_PRIVILEGIO AND P.ID_GRUPO = %s ';
    _qry_priv_user_delete = 'DELETE FROM PDV_C_PRIVILEGIO_C_USUARIO WHERE ID_EMPLEADO = ''%s''';
    _qry_priv_user_insert = 'INSERT INTO PDV_C_PRIVILEGIO_C_USUARIO VALUES(%s,%s);';

    _qry_descrip_privilegios = 'SELECT ID_PRIVILEGIO, DESCRIPCION FROM PDV_C_PRIVILEGIO ORDER BY 1;';


    _qry_grupos_select = 'SELECT ID_GRUPO, DESCRIPCION  FROM PDV_C_GRUPO_USUARIO ORDER BY DESCRIPCION';
    _qry_grupos_select_uno = 'SELECT ID_GRUPO, DESCRIPCION, FECHA_BAJA FROM PDV_C_GRUPO_USUARIO WHERE DESCRIPCION = ''';
    _qry_grupos_insert = 'INSERT INTO PDV_C_GRUPO_USUARIO(ID_GRUPO, DESCRIPCION, FECHA_BAJA) VALUES(';
    _qry_emp_combox_Uno  = 'SELECT TRAB_ID, CONCAT( PATERNO,"  ",MATERNO," ",NOMBRES)AS NOMBRE FROM EMPLEADOS WHERE TRAB_ID = %s';
    _qry_emp_combobox  = 'SELECT E.TRAB_ID, CONCAT( PATERNO,'' '',MATERNO,'' '',NOMBRES)AS NOMBRE '+
                         'FROM EMPLEADOS E WHERE ID_SERVICIO = 0 '+
                         'ORDER BY 2';
    _qry_emp_sin_permisos = 'SELECT E.TRAB_ID, CONCAT( PATERNO,'' '',MATERNO,'' '',NOMBRES)AS NOMBRE '+
                            'FROM EMPLEADOS E '+
                            'WHERE TIPO_EMPLEADO = 0 AND E.TRAB_ID NOT IN ( '+
                            'SELECT DISTINCT(U.TRAB_ID) '+
                            'FROM PDV_C_GRUPO_USUARIO G INNER JOIN PDV_C_USUARIO U ON G.ID_GRUPO = U.ID_GRUPO '+
                            'UNION '+
                            'SELECT DISTINCT(U.TRAB_ID) '+
                            'FROM PDV_C_PRIVILEGIO_C_USUARIO C INNER JOIN PDV_C_USUARIO U ON C.ID_EMPLEADO = U.TRAB_ID) ';
   _qry_user_baja_pass = 'UPDATE PDV_C_USUARIO SET FECHA_BAJA = NOW() WHERE TRAB_ID = ''%s'' ';


    _qry_cve_combobox  = 'SELECT CONCAT( PATERNO,'' '',MATERNO,'' '',NOMBRES)AS NOMBRE, TRAB_ID FROM EMPLEADOS ORDER BY 2';
    _qry_usuario       = 'SELECT U.TRAB_ID, P.DESCRIPCION, U.NOMBRE, CAST(CAST(U.FECHA_BAJA AS DATE)AS CHAR(10)), '+
                         '        CAST(CAST(U.FECHA_PASSWORD AS DATE) AS CHAR(10)) '+
                         'FROM PDV_C_USUARIO U INNER JOIN PDV_C_GRUPO_USUARIO P ON U.ID_GRUPO = P.ID_GRUPO '+
                         'WHERE U.FECHA_BAJA IS NULL ORDER BY 1 ';

//    _qry_usuario_all   = 'SELECT NOMBRE,TRAB_ID,ID_GRUPO,FECHA_BAJA, FECHA_PASSWORD FROM PDV_C_USUARIO P WHERE FECHA_BAJA IS NULL';
    _qry_usuario_all   = 'SELECT TRAB_ID,NOMBRE,ID_GRUPO,FECHA_BAJA, FECHA_PASSWORD FROM PDV_C_USUARIO P WHERE FECHA_BAJA IS NULL ORDER BY 1';
    _qry_new_usuario   = 'INSERT INTO PDV_C_USUARIO (TRAB_ID,ID_GRUPO,PASSWORD,NOMBRE,FECHA_PASSWORD) VALUES(TRIM(''%s''),%s,TRIM(%s),TRIM(%s),NOW())';

    _qry_update_usuario = 'UPDATE PDV_C_USUARIO SET ID_GRUPO = %s, PASSWORD = %s,  NOMBRE = %s,  '+
                          'FECHA_PASSWORD = (SELECT NOW() + INTERVAL (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 8) DAY)'+
                          ' WHERE TRAB_ID = ''%s''';

    _qry_update_pass_usuario = 'UPDATE PDV_C_USUARIO SET FECHA_PASSWORD = '+
                          '(SELECT NOW() + INTERVAL (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 8) DAY), '+
                          ' PASSWORD = ''%s'' '+
                          'WHERE TRAB_ID = ''%s'' ';
    _qry_baja_usuario  = 'UPDATE  PDV_C_GRUPO_USUARIO SET FECHA_BAJA = NOW() WHERE ID_GRUPO = %s';

    _qry_select_grupoP = 'SELECT ID_GRUPO, DESCRIPCION, FECHA_BAJA FROM PDV_C_GRUPO_USUARIO WHERE FECHA_BAJA > CURRENT_DATE()';

    _qry_delete_grupoP = 'DELETE FROM PDV_C_GRUPO_PRIVILEGIOS WHERE ID_GRUPO = %s';

    _qry_agrega_grupoP = 'INSERT INTO PDV_C_GRUPO_PRIVILEGIOS(ID_GRUPO, ID_PRIVILEGIO) VALUES(%s,%s)';

    _qry_busca_grupoP  = 'SELECT ID_GRUPO, ID_PRIVILEGIO FROM PDV_C_GRUPO_PRIVILEGIOS WHERE ID_GRUPO = ''%s''';

    _USER_BUSCA_DATOS = 'SELECT E.TRAB_ID, E.PATERNO, E.MATERNO, E.NOMBRES, STATUS '+
                        'from EMPLEADOS E INNER JOIN PDV_C_USUARIO U ON E.TRAB_ID = U.TRAB_ID WHERE E.TRAB_ID = ''%s'' ';

    _USER_BAJA_USER = 'UPDATE PDV_C_USUARIO SET FECHA_BAJA = NOW() WHERE TRAB_ID =  "%s" ';
    _USER_ALTA_USER = 'UPDATE PDV_C_USUARIO SET FECHA_BAJA = NULL WHERE TRAB_ID =  "%s" ';


    _qry_busca_usuarioP = 'SELECT ID_EMPLEADO, ID_PRIVILEGIO FROM PDV_C_PRIVILEGIO_C_USUARIO WHERE ID_EMPLEADO = ''%s'' '+
                          ' UNION '+
                          'SELECT TRAB_ID ,P.ID_PRIVILEGIO '+
                          ' FROM PDV_C_GRUPO_PRIVILEGIOS P INNER JOIN PDV_C_USUARIO U ON P.ID_GRUPO = U.ID_GRUPO '+
                          ' WHERE U.TRAB_ID = ''%s'' ';

    _qry_user_privile  = 'SELECT U.TRAB_ID, P.ID_PRIVILEGIO, U.PASSWORD,U.NOMBRE, U.FECHA_BAJA, U.FECHA_PASSWORD, P.ID_PRIVILEGIO '+
                         'FROM PDV_C_PRIVILEGIO P INNER JOIN PDV_C_GRUPO_PRIVILEGIOS PG ON P.ID_PRIVILEGIO = PG.ID_PRIVILEGIO '+
                         '                        INNER JOIN PDV_C_GRUPO_USUARIO PU ON PU.ID_GRUPO = PG.ID_GRUPO '+
                         '                        INNER JOIN PDV_C_USUARIO U ON U.ID_GRUPO = PU.ID_GRUPO '+
                         'WHERE U.FECHA_BAJA IS NULL AND U.TRAB_ID = ''%s'' AND U.PASSWORD = ''%s'' AND P.ID_PRIVILEGIO = %s '+
                         'UNION '+
                         'SELECT U.TRAB_ID, P.ID_PRIVILEGIO, U.PASSWORD,U.NOMBRE,U.FECHA_BAJA, U.FECHA_PASSWORD, P.ID_PRIVILEGIO '+
                         'FROM PDV_C_PRIVILEGIO P INNER JOIN PDV_C_PRIVILEGIO_C_USUARIO PU ON P.ID_PRIVILEGIO = PU.ID_PRIVILEGIO '+
                         '                        INNER JOIN PDV_C_USUARIO U ON U.TRAB_ID = PU.ID_EMPLEADO '+
                         'WHERE U.FECHA_BAJA IS NULL AND U.TRAB_ID = ''%s'' AND U.PASSWORD = ''%s'' AND P.ID_PRIVILEGIO = %s '+
                         'ORDER BY  1,2 ';


    _qry_guias_remotas_vacio = 'SELECT U.TRAB_ID, P.ID_PRIVILEGIO, U.PASSWORD,U.NOMBRE, U.FECHA_BAJA, U.FECHA_PASSWORD, P.ID_PRIVILEGIO '+
                         'FROM PDV_C_PRIVILEGIO P INNER JOIN PDV_C_GRUPO_PRIVILEGIOS PG ON P.ID_PRIVILEGIO = PG.ID_PRIVILEGIO '+
                         'INNER JOIN PDV_C_GRUPO_USUARIO PU ON PU.ID_GRUPO = PG.ID_GRUPO '+
                         'INNER JOIN PDV_C_USUARIO U ON U.ID_GRUPO = PU.ID_GRUPO '+
                         'WHERE U.FECHA_BAJA IS NULL AND U.TRAB_ID = ''%s'' AND P.ID_PRIVILEGIO IN (207) '+
                         'UNION '+
                         'SELECT U.TRAB_ID, P.ID_PRIVILEGIO, U.PASSWORD,U.NOMBRE,U.FECHA_BAJA, U.FECHA_PASSWORD, P.ID_PRIVILEGIO '+
                         'FROM PDV_C_PRIVILEGIO P INNER JOIN PDV_C_PRIVILEGIO_C_USUARIO PU ON P.ID_PRIVILEGIO = PU.ID_PRIVILEGIO '+
                         'INNER JOIN PDV_C_USUARIO U ON U.TRAB_ID = PU.ID_EMPLEADO '+
                         'WHERE U.FECHA_BAJA IS NULL AND U.TRAB_ID = ''%s'' AND P.ID_PRIVILEGIO IN (207) '+
                         'ORDER BY  1,2';

    _qry_parametro_28 = 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 28';

    _qry_fecha_vencerse = 'SELECT CURRENT_DATE() AS VENCER';
    _ITI_INSERT_OCUPAN = 'INSERT INTO PDV_C_OCUPANTE(ID_OCUPANTE,DESCRIPCION,ABREVIACION,DESCUENTO) '+
                         ' VALUES(%d,%s,%s,%s);';
    _ITI_UPDATE_OCUPAN = 'UPDATE PDV_C_OCUPANTE SET DESCRIPCION = %s, FECHA_BAJA = %s, ABREVIACION = %s, DESCUENTO = %d WHERE ID_OCUPANTE = %d';
    _ITI_DELETE_OCUPAN = 'DELETE FROM PDV_C_OCUPANTE WHERE ID_OCUPANTE = %d;';
    _ITI_OCUPANTES_ALL = 'SELECT ID_OCUPANTE, DESCRIPCION, FECHA_BAJA, ABREVIACION, DESCUENTO FROM PDV_C_OCUPANTE ORDER BY ID_OCUPANTE;';


    _BUSES_IMAGENS = 'SELECT ID_TIPO_AUTOBUS,NOMBRE_IMAGEN FROM PDV_C_TIPO_AUTOBUS ;';

    _INICIALIZA = 'SELECT (COUNT(*)) AS TOTAL FROM PDV_C_INICIO;';

    _INICIALIZA_NUEVOS = 'INSERT INTO PDV_C_INICIO VALUES(CAST(NOW() AS DATE),CAST(NOW() AS DATE),1);';
    _BUSCA_IP_MAQUINA  = 'SELECT COUNT(*)AS ID_TAQUILLA FROM PDV_C_TAQUILLA WHERE '+
                         'ID_TERMINAL = ''%s'' AND ID_TAQUILLA = ''%s'' AND IP = ''%s''';

    _VERIFICA_IP = 'SELECT COUNT(*)AS VERIFICA FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = ''%s'' AND ID_TAQUILLA = %s AND IP = ''%s'' ';

    _AGREGA_TAQUILLA_BASE = 'INSERT INTO PDV_C_TAQUILLA(ID_TERMINAL, ID_TAQUILLA, IP) VALUES(''%s'',%s,''%s'');';

    _UPDATE_CORRIDA_D = 'UPDATE PDV_T_CORRIDA_D SET ESTATUS = ''%s'', TRAB_ID = ''%s'' '+
                        'WHERE ID_CORRIDA = ''%s'' AND FECHA = ''%s'' AND ID_TERMINAL = ''%s'' AND HORA = ''%s'' AND ID_RUTA = %s';

    _PERIODO_VACACIONAL = 'SELECT ID_PERIODO_VACACIONAL, (CAST(FECHA_INICIO AS DATE))AS FECHA_INICIO, '+
                          '(CAST(FECHA_FIN AS DATE))AS FECHA_FIN, (CAST(FECHA_INICIO AS TIME))AS HORA_INICIO, '+
                          '(CAST(FECHA_FIN AS TIME))AS HORA_FIN '+
                          'FROM PDV_C_PERIODO_VACACIONAL; ';
    _PERIODO_VACACIONAL_UPDATE = 'UPDATE PDV_C_PERIODO_VACACIONAL SET FECHA_INICIO = ''%s'', FECHA_FIN = ''%s'' '+
                                 'WHERE ID_PERIODO_VACACIONAL = 1';
    _MSG_PERIODO_VACACIONAL = 'Nueva asignacion al periodo vacacional %s al %s';
    _MSG_PERIODO_ERROR = 'La fecha de inicio es mayor al la fecha final del periodo vacacional';

    procedure LlenarStringGridAll(lpq_query : TSQLQuery; Stg : TStringGrid);

    procedure ListaFill;
    procedure CargarDualStrings(lpq_query : TSQLQuery);
    function  getMaxTable(IdField,dbTable : String) : integer;
    function  FechaFormato(fecha : TDateTime) : String;
    procedure agregaTaquillaIP();

    function Encrypt (const s: string; Key: Word) : string;
    function Decrypt (const s: string; Key: Word) : string;

implementation

uses Frm_vta_main;



{@Procedure LlenarStringGridAll
@Params lpq_query : TZQuery
@Params Stg : TStringGrid
@Descripcion Llena un componente visual StringGrid directamente de un componente Query}
procedure LlenarStringGridAll(lpq_query : TSQLQuery; Stg : TStringGrid);
var
    li_ctrl : integer;
    li_row  : integer;
begin
    with lpq_query do begin
        First;
        li_row := 1;
        while not EoF do begin
            for li_ctrl := 0 to lpq_query.FieldCount - 1 do begin
                stg.Cells[li_ctrl, li_row] := lpq_query.Fields[li_ctrl].AsString;
            end;//fin for
            inc(li_row);
            next;
        end;//fin while
    end;//fin with
    if Stg.RowCount = 1 then begin
      Stg.RowCount := 2;
      Stg.FixedRows := 1;
    end else Stg.RowCount := li_row;
end;


{@Function getMaxTable
@Params lpq_query : TZQuery;
@Params dbTable : String
@Descripcion Regresa el numero maximo registrado en la tabla esta es parametrizada
  a la funcion y concatenada para la solicitud del EjecutaSQL}
function  getMaxTable(IdField,dbTable : String) : integer;
var
    lpq_query : TSQLQuery;
begin
    try
      lpq_query := TSQLQuery.Create(nil);
      lpq_query.SQLConnection := DM.Conecta;
      if EjecutaSQL('SELECT COALESCE(MAX('+IdField +' + 1),1) AS MAXIMO  FROM '+dbTable,lpq_query,_LOCAL) then
          Result := lpq_query['Maximo'];
    except
        Result := 1;
    end;
    lpq_query.Destroy;
end;


procedure agregaTaquillaIP();
var
    query : TSQLQuery;
    li_ctrl : integer;
    ls_ips  : string;
begin
    li_ctrl := 0;
    query := TSQLQuery.Create(nil);
    try
        try
           ls_ips := GetIPList;
           query.SQLConnection := DM.Conecta;
           query.SQL.Clear;
           query.SQL.Add('SELECT COUNT(*)AS TAQUILLA FROM PDV_C_TAQUILLA WHERE ID_TERMINAL = :gs_terminal  AND IP = :ls_ips');
           query.Params[0].AsString := gs_terminal;
           query.Params[1].AsString := ls_ips;
           query.Open;
           if query['TAQUILLA'] = 0 then begin
              if EjecutaSQL(Format(_AGREGA_TAQUILLA_BASE,[gs_terminal,gs_maquina,ls_ips]),query,_LOCAL ) then
                  ;
           end;
        except
            on E : Exception do begin
                  Mensaje('Elimine el archivo .ini y ejecutelo nuevamente',0);
            end;
        end
    finally
       query.Free;
       query := nil;
    end;
end;



function  FechaFormato(fecha : TDateTime) : String;
begin
    result := ''''+ FormatDateTime('YYYY/MM/DD',fecha)+'''';
end;


{@procedure CargarDualStrings
@Params CargarDualStrings
@Descripcion Generamos la carga de los dualString}
procedure CargarDualStrings(lpq_query : TSQLQuery);
var
    ls_concatena, ls_fecha : String;
    ls_qry : string;
begin
    gds_user  := TDualStrings.Create;
      ls_qry := 'SELECT U.TRAB_ID, U.NOMBRE AS NOMBRE '+
              'FROM PDV_C_USUARIO U INNER JOIN EMPLEADOS E ON U.TRAB_ID = E.TRAB_ID '+
              'WHERE FECHA_BAJA IS NULL';
    if EjecutaSQL(ls_qry,lpq_query,_LOCAL) then begin
      with lpq_query do begin
         First;
         while not EoF do begin
            ls_concatena := lpq_query['NOMBRE'];
            gds_user.Add(lpq_query['TRAB_ID'],ls_concatena );
            next;
         end;
      end;
    end;
    ls_qry := 'SELECT ID_PRIVILEGIO, DESCRIPCION FROM PDV_C_PRIVILEGIO';
    if EjecutaSQL(ls_qry,lpq_query,_LOCAL)then
      gds_privilegio := TDualStrings.Create;
      with lpq_query do begin
          First;
          while not EoF do begin
              gds_privilegio.Add(lpq_query['ID_PRIVILEGIO'],lpq_query['DESCRIPCION']);
              next;
          end;
      end;
end;


{@procedure ListaFill
@Descripcion Solicitamos la carga de los dualStrings gloabales}
procedure ListaFill;
var
   lq_query : TSQLQuery;
begin
    try
      lq_query := TSQLQuery.Create(nil);
      lq_query.SQLConnection := DM.Conecta;
      CargarDualStrings(lq_query);
    except
        lq_query.Free;
    end;
end;



function Decrypt(const s: string; Key: Word): string;
var
i : byte;
begin
    {Result[0] := s[0];}
    Result:=s;
    for i := 0 to (length (s)) do
    begin
    Result[i] := Char (byte (s[i]) xor (Key shr 8));
    Key := (byte (s[i]) + Key) * c1 + c2
    end
end;

function Encrypt(const s: string; Key: Word): string;
var
    i : byte;
    ResultStr : string;
begin
    Result:=s;
    {Result[0] := s[0]; }
    for i := 0 to (length (s)) do
    begin
        Result[i] := Char (byte (s[i]) xor (Key shr 8));
        Key := (byte (Result[i]) + Key) * c1 + c2
    end
end;




end.
