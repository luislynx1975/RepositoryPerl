unit TRemotoTodos;

interface
//no envia la terminal local
{$warnings off}
{$hints off}
uses
  Classes, StdCtrls, DB, ActiveX, SysUtils, Data.SqlExpr;

Const
    _LOG = 'ConexionServer.log';//para registrar los errores del Thread
    _DRIVER = 'MySql';

type
  RemotoTodos = class(TThread)
  private
    { Private declarations }
    host : string;
    user : string;
    pass : string;
    serverRemoto : TSQLConnection;
    function Todas_termnales : TSQLQuery;
    procedure QuerysRemotos(Remoto : TSQLConnection);
    procedure ErrorLog(Error, sql : string);
    procedure acceso_conexion;
  protected
    procedure Execute; override;
  public
    Priority : TThreadPriority;
    server : TSQLConnection;
    sentenciaSQL : string;
    Terminal  : string;
  end;

implementation

uses u_comun_base;

{ RemotoTodos }

procedure RemotoTodos.acceso_conexion();
begin
    try
{        serverRemoto.DriverName := _DRIVER;
        serverRemoto.Params.Values['HOSTNAME']  := host;
        serverRemoto.Params.Values['DATABASE']  := _BASE_DATOS_MERCURIO;
        serverRemoto.Params.Values['USER_NAME'] := user;
        serverRemoto.Params.Values['PASSWORD']  := pass;
        serverRemoto.LoginPrompt := False;
        serverRemoto.Connected := true;}
    except
        on E : exception do begin// si no se accede al server guardar localmente a la tabla de query
            ErrorLog('No se puede acceder al servidor Server Remoto:' + host,E.Message);
            serverRemoto.Free;
        end;
    end;
end;



procedure RemotoTodos.ErrorLog(Error, sql: string);
var
    lf_archivo : TextFile;
begin
    try
        AssignFile(lf_archivo,_LOG);
        if FileExists(_LOG) then
            Append(lf_archivo)
        else
            Rewrite(lf_archivo);
        Writeln(lf_archivo,'//------------------------------------------------------------');
        Writeln(lf_archivo,FormatDateTime('"Fecha : "dd/mm/yyyy hh":"nn ',now));
        Writeln(lf_archivo,format('Error : %s',[error]));
        Writeln(lf_archivo,format('Sistema   : %s',[sql]));
        Writeln(lf_archivo,'//------------------------------------------------------------');
        CloseFile(lf_archivo);
    except
    end;
end;

function RemotoTodos.Todas_termnales: TSQLQuery;
var
    qryTerminales : TSQLQuery;
    ls_opcion : string;
    ls_terminal, ls_server : string;
begin
     qryTerminales := TSQLQuery.Create(nil);
     ls_opcion := 'A';
     ls_terminal := 'T';
     ls_server := 'S';
     try
        qryTerminales.SQLConnection := server;
        qryTerminales.SQL.Clear;
        qryTerminales.SQL.Add('SELECT ID_TERMINAL,IPV4, BD_USUARIO,BD_PASSWORD ');
        qryTerminales.SQL.Add('FROM PDV_C_TERMINAL  ');
        qryTerminales.SQL.Add('WHERE ESTATUS = :ls_opcion AND TIPO = :ls_terminal AND ESTATUS = ''A'' ');
        qryTerminales.Params[0].AsString := ls_opcion;
        qryTerminales.Params[1].AsString := ls_terminal;
        qryTerminales.Open;
     except
        on E : exception do begin
            ErrorLog('Error en catalogo de terminales', E.Message);
            qryTerminales.Free;
        end;
     end;
     Result := qryTerminales;
end;


procedure RemotoTodos.Execute;
var
    queryLocal : TSQLQuery;
    queryInserts : TSQLQuery;
    terminal : string;
begin
  { Place thread code here }
    CoInitialize(nil);
    try
        queryLocal := TSQLQuery.Create(nil);
        queryInserts := TSQLQuery.Create(nil);
        queryLocal := Todas_termnales();
        queryInserts.SQLConnection := server;
        with queryLocal do begin
            First;
            while  not Eof  do begin
                terminal := queryLocal['ID_TERMINAL'];
                queryInserts.SQL.Clear;
                queryInserts.SQL.Add('INSERT INTO PDV_T_QUERY(ID_TERMINAL,SENTENCIA,FECHA_HORA) ');
                queryInserts.SQL.Add('VALUES(:terminal, :instruccion, now())');
                queryInserts.Params[0].AsString := terminal;
                queryInserts.Params[1].AsString := sentenciaSQL;
                queryInserts.ExecSQL();
                Next;
            end;
        end;
    finally
      queryLocal.Destroy;
      queryInserts.Destroy;
    end;
    CoUninitialize();
end;


procedure RemotoTodos.QuerysRemotos(Remoto: TSQLConnection);
var
    queryRemoto : TSQLQuery;
begin
    queryRemoto := TSQLQuery.Create(nil);
    try
      queryRemoto.SQLConnection := Remoto;//conexion con el server
      queryRemoto.SQL.Clear;
      queryRemoto.SQL.Add(sentenciaSQL);
      queryRemoto.ExecSQL();
    except
        on E : exception do begin
            ErrorLog('Error en el query :' + sentenciaSQL, E.Message);
        end;
    end;
    queryRemoto.Free;
end;





end.
