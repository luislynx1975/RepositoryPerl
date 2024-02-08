unit ThreadMainServer;

interface

uses
  Classes, StdCtrls, DB, ActiveX, SysUtils, Data.SqlExpr;

Const
    _DRIVER = 'MySql';
    _LOG = 'ConexionServer.log';//para registrar los errores del Thread

type
  QryMainServer = class(TThread)
  private
    { Private declarations }
    ip  : string;
    user : string;
    pass : string;
    procedure servidor_central();
    procedure enviarSentenciaSQL();
    procedure ErrorLog(Error, sql : string);
  protected
    procedure Execute; override;
  public
    server : TSQLConnection;
    sentenciaSQL : string;
    Terminal  : string;
  end;

implementation

uses u_comun_base;

{ QryMainServer }

procedure QryMainServer.enviarSentenciaSQL;
var
    central : TSQLConnection;
    qryCentral : TSQLQuery;
begin
    central := TSQLConnection.Create(nil);
    qryCentral := TSQLQuery.Create(nil);
    try
{        central.DriverName :=  _DRIVER;
        central.Params.Values['HOSTNAME']  := ip;
        central.Params.Values['DATABASE']  := _BASE_DATOS_MERCURIO;
        central.Params.Values['USER_NAME'] := user;
        central.Params.Values['PASSWORD']  := pass;
        central.LoginPrompt := False;
        central.Connected := true;}
        if central.Connected then begin
            qryCentral.SQLConnection := central;
            qryCentral.SQL.Clear;
            qryCentral.SQL.Add(sentenciaSQL);
            qryCentral.ExecSQL();
        end;
    except
        on E : exception do begin// si no se accede al server guardar localmente a la tabla de query
            ErrorLog('No se puede acceder al servidor :' + ip,E.Message);
            central.Free;
        end;
    end;
end;

procedure QryMainServer.ErrorLog(Error, sql: string);
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



procedure QryMainServer.Execute;
begin
  { Place thread code here }
    CoInitialize(nil);
    servidor_central();
    CoUninitialize();
end;

procedure QryMainServer.servidor_central;
var
    qry : TSQLQuery;
    terminal : string;
begin
    qry := TSQLQuery.Create(nil);
    terminal := '1730';
    try
      qry.SQLConnection := server;
      qry.SQL.Clear;
      qry.SQL.Add('INSERT INTO PDV_T_QUERY(ID_TERMINAL,SENTENCIA,FECHA_HORA) ');
      qry.SQL.Add('VALUES(:terminal, :sentenciaSQL, now())');
      qry.Params[0].AsString := terminal;
      qry.Params[1].AsString := sentenciaSQL;
      qry.ExecSQL();
    finally
      qry.Destroy;
    end;
end;

end.
