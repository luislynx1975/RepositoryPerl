unit ThreadRemoto;

interface

uses
  Classes,  DB, Uni;

type
  TQryRemoto = class(TThread)
  private
    { Private declarations }
    gi_ruta      : Integer;//La ruta que se esta utilizando
    gs_sentencia : string;//El sql que se inserta
    gc_conecta   : TUniConnection;//para conectarnos localmente
    gs_dbName    : String;//base de datos
    gs_terminal  : String;//terminal en donde se encuentra
    function getTerminalRuta() : string;
    function getTerminals():String;
    procedure executeRemoto(lps_ip, lps_user, lps_pass, lps_terminal : string);
    procedure executaLocal(lps_terminal : String);
  protected
    procedure Execute; override;
  public
    gs_estatus : String;
    gi_server  : Integer;
    constructor Create(lps_sentencia : String; lpc_database : TUniConnection;
                       lps_base : String; lpi_ruta : Integer; lps_terminal : String);
    destructor Destroy; override;
  end;

implementation

var
    qry : TUniQuery;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TQryRemoto.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TQryRemoto }

constructor TQryRemoto.Create(lps_sentencia: String;lpc_database: TUniConnection;
                              lps_base: String; lpi_ruta: Integer; lps_terminal : String);
begin
    gs_sentencia := lps_sentencia;
    gc_conecta   := lpc_database;
    gs_dbName    := lps_base;
    gi_ruta      := lpi_ruta;
    gs_terminal  := lps_terminal;
end;


destructor TQryRemoto.Destroy;
begin
    gs_sentencia  := '';
    gc_conecta.Free;
    gs_dbName     := '';
    gi_ruta       := -1;
  inherited;
end;

{@proceudrre executeLocal
@params lps_terminal : Nomenclatura de la terminal en donde se efectua  la venta
@Descripcion almacena el query que se envia a los server remotos al no encontrar respuesta
@ de este se almacena en el server de forma local}
procedure TQryRemoto.executaLocal(lps_terminal : String);
var
    lq_qryLocal : TUniQuery;
begin
    lq_qryLocal := TUniQuery.Create(nil);
    try
        lq_qryLocal.Connection := gc_conecta;
        lq_qryLocal.SQL.Clear;
        lq_qryLocal.SQL.Add('INSERT INTO PDV_T_QUERY ');
        lq_qryLocal.SQL.Add('VALUES(:lps_terminal, :gs_sentencia, CURRENT_TIMESTAMP)');
        lq_qryLocal.Params[0].AsString := lps_terminal;
        lq_qryLocal.Params[1].AsString := gs_sentencia;
        lq_qryLocal.ExecSQL();
    except
        lq_qryLocal.Destroy;
    end;
end;


{@procedure executeRemoto
@params lps_ip   : La ip del servidor remoto
@params lps_user : El usuario de la base de datos
@params lps_pass : Password para accesar a la base de datos
@params lps_terminal : Nomenclatura de la terminal
@Descripcion procedimiento que inserta en la base de datos remota para que la informacion se tenga
@ disponible en todas la terminal a las que afecte un evento, de no encontrarlo se almacena de forma
@ local al servidor de base de datos con executaLocal}
procedure TQryRemoto.executeRemoto(lps_ip, lps_user, lps_pass, lps_terminal: string);
var
    lc_conecta : TUniConnection;
    lq_qry     : TUniQuery;
begin
      lc_conecta := TUniConnection.Create(nil);
      lq_qry     := TUniQuery.Create(nil);
    try
{        lc_conecta.Params.Values['DATABASE']  := gs_dbName;
        lc_conecta.Params.Values['HOSTNAME']  := lps_ip;
        lc_conecta.Params.Values['USER_NAME'] := lps_user;
        lc_conecta.Params.Values['PASSWORD']  := lps_pass;
        lq_qry.SQL.Clear;
        lq_qry.SQL.Add(gs_sentencia);
        lq_qry.ExecSQL();}
    except
        executaLocal(lps_terminal);// save PDV_T_QUERY
        lc_conecta.Destroy;
        lq_qry.Destroy;
    end;
end;


{@function getTerminalRuta
@Descripcion Regresa la consulta para solicitar las terminales que afecto la venta}
function TQryRemoto.getTerminalRuta: string;
begin
    Result := 'select CT.IPV4, CT.BD_USUARIO, CT.BD_PASSWORD, CT.ESTATUS, T.DESTINO, D.ORDEN '+
              'from T_C_RUTA_D D INNER JOIN T_C_TRAMO T ON D.ID_TRAMO = T.ID_TRAMO '+
              '                  INNER JOIN PDV_C_TERMINAL CT ON T.ID_TRAMO = CT.ID_TERMINAL '+
              'WHERE ID_RUTA = :GI_RUTA AND D.ORDEN > ( '+
              '           select D.ORDEN '+
              '           from T_C_RUTA_D D INNER JOIN T_C_TRAMO T ON D.ID_TRAMO = T.ID_TRAMO '+
              '           WHERE T.ORIGEN = :GS_TERMINAL and ID_RUTA = :GI_RUTA ) '+
              ' AND D.ORDEN < (SELECT MAX(ORDEN) FROM T_C_RUTA_D WHERE ID_RUTA = :GI_RUTA) '+
              ' ORDER BY ORDEN;';
end;

{@Procedure getTerminal
@Descripcion consultamos todaslas terminales que esten activas}
function TQryRemoto.getTerminals: String;
begin
    Result := 'SELECT IPV4, BD_USUARIO, BD_PASSWORD FROM PDV_C_TERMINAL P WHERE ESTATUS = ''A'' AND TIPO <> ''S'';';
end;


{@procedure Execute
@Descripcion Ejecuta el TThread}
procedure TQryRemoto.Execute;
begin
//if status equal to all
    qry := TUniQuery.Create(nil);
    qry.Connection := gc_conecta;
    if gi_ruta = gi_server then begin//insert in all servers
        try
            qry.SQL.Clear;
            qry.SQL.Add(getTerminals);
            qry.Open;
            with qry do begin
                First;
                while not Eof do begin
                    if qry['ESTATUS']  = gs_estatus then
                      executeRemoto(qry.FieldByName('IPV4').AsString,
                                    qry.FieldByName('BD_USUARIO').AsString,
                                    qry.FieldByName('BD_PASSWORD').AsString,
                                    qry.FieldByName('DESTINO').AsString);
                    Next;
                end;//fin while
            end;//fin with
        except
            qry.Destroy;
        end;
    end else  begin
          { Place thread code here }
            try
                qry.SQL.Clear;
                qry.SQL.Add(getTerminalRuta);
                qry.Params[0].AsInteger := gi_ruta;
                qry.Params[1].AsString  := gs_terminal;
                qry.Params[2].AsInteger := gi_ruta;
                qry.Params[3].AsInteger := gi_ruta;
                qry.Open;
                with qry do begin //listos para insertar remotamente a las otras bases
                    First;
                    while not EoF do begin//si es A = ACTIVO S = SUSPENDIDO
                          if qry.FieldByName('ESTATUS').AsString = gs_estatus then
                              executeRemoto(qry.FieldByName('IPV4').AsString,
                                            qry.FieldByName('BD_USUARIO').AsString,
                                            qry.FieldByName('BD_PASSWORD').AsString,
                                            qry.FieldByName('DESTINO').AsString);
                        Next;
                    end;//fin while
                end;//fin with
            except
                qry.Destroy;
            end;
    end;
end;




end.
 