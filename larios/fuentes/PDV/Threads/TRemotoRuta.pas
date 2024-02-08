unit TRemotoRuta;

interface
//no envia la terminal local

uses
  Classes, StdCtrls, DB, ActiveX, SysUtils, Data.SqlExpr;


Const
  _LOG = 'ConexionServer.log';//para registrar los errores del Thread
  _DRIVER = 'MySql';

type
  RemotoRuta = class(TThread)
  private
    { Private declarations }
    function getRutaTerminales(): TSQLQuery;
    procedure ejecutaSentencia(query : TSQLQuery);
    procedure ErrorLog(Error, sql : string);
    procedure insertLocalSentencia();
  protected
    { Protected declarations }
    procedure Execute; override;
  public
    { Public declarations }
    ruta  : integer;
    terminal : String;
    server   : TSQLConnection;
    sentencia : string;
    destino : string;
  end;

implementation


{ RemotoRuta }
procedure RemotoRuta.insertLocalSentencia;
var
    qryLocal : TSQLQuery;
begin
    try
        qryLocal := TSQLQuery.Create(nil);
        qryLocal.SQLConnection := server;
        qryLocal.SQL.Clear;
        qryLocal.SQL.Add('INSERT INTO PDV_T_QUERY ');
        qryLocal.SQL.Add('VALUES(:terminal, :sentencia, NOW()) ');
        qryLocal.Params[0].AsString := terminal;
        qryLocal.Params[1].AsString := sentencia;
        qryLocal.ExecSQL();
    except
          ;
    end;
end;


procedure RemotoRuta.ejecutaSentencia(query: TSQLQuery);
var
    qryLocal     : TSQLQuery;
begin
    qryLocal := TSQLQuery.Create(nil);
    try
      qryLocal.SQLConnection := server;
      with query do begin
          First;
          while not EoF do begin
              qryLocal.SQL.Clear;
              qryLocal.SQL.Add('INSERT INTO PDV_T_QUERY(ID_TERMINAL,SENTENCIA,FECHA_HORA) ');
              qryLocal.SQL.Add('VALUES(:terminal, :sentencia, now())');
              qryLocal.Params[0].AsString := terminal;
              qryLocal.Params[1].AsString := sentencia;
              qryLocal.ExecSQL();
              next;
          end;
      end;
    finally
        qryLocal.Destroy;
    end;
end;


procedure RemotoRuta.ErrorLog(Error, sql: string);
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



procedure RemotoRuta.Execute;
begin
  { Place thread code here }
    CoInitialize(nil);
    getRutaTerminales();
    CoUninitialize();
end;


function RemotoRuta.getRutaTerminales: TSQLQuery;
Const
    QUERY = 'SELECT PT.ID_TERMINAL,PT.IPV4, BD_BASEDATOS, BD_USUARIO, BD_PASSWORD, R.ORDEN '+
            'FROM T_C_RUTA_D R INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = R.ID_TRAMO '+
            '	INNER JOIN PDV_C_TERMINAL PT ON PT.ID_TERMINAL = T.ORIGEN '+
            'WHERE R.ID_RUTA = %s '+
            'AND R.ORDEN > (SELECT R.ORDEN '+
            'FROM T_C_RUTA_D R INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = R.ID_TRAMO '+
            'WHERE T.ORIGEN = ''%s'' AND R.ID_RUTA = %s) AND '+
            '           R.ORDEN < (SELECT ORDEN '+
            '                      FROM T_C_RUTA_D R INNER JOIN T_C_TRAMO T ON T.ID_TRAMO = R.ID_TRAMO '+
            '                      WHERE R.ID_RUTA = %s AND T.DESTINO = ''%s'') AND	PT.ESTATUS = ''A'' '+
            'ORDER BY R.ORDEN ';
var
    qry : TSQLQuery;
    qrylocal : TSQLQuery;
    ls_qry : string;

begin
    qry := TSQLQuery.Create(nil);
    try
        qry.SQLConnection := server;

        ls_qry := Format(QUERY,[IntToStr(ruta), terminal, IntToStr(ruta), IntToStr(ruta), destino]);
        qry.SQL.Clear;
        qry.SQL.Add(ls_qry);
        qry.Open;

        qrylocal := TSQLQuery.Create(nil);
        qrylocal.SQLConnection := server;
        with qry do begin
            First;
            while not EoF do begin
              try
                qryLocal.SQL.Clear;
                qryLocal.SQL.Add('INSERT INTO PDV_T_QUERY(ID_TERMINAL,SENTENCIA,FECHA_HORA) ');
                qryLocal.SQL.Add('VALUES(:terminal, :sentencia, now())');
                qryLocal.Params[0].AsString := qry['ID_TERMINAL'];
                qryLocal.Params[1].AsString := sentencia;
                qryLocal.ExecSQL();
              except
                    ;
              end;
                next;

            end;
        end;
        qrylocal.Free;
        qrylocal := nil;
    finally
      qry.Destroy;
    end;
    Result := qrylocal;
end;


end.
