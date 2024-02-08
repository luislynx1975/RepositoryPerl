unit TRemotoPorTerminal;

interface
{$warnings off}
{$hints off}
uses
  Classes,  DB, ActiveX, SysUtils, Uni;

Const
    _VENTA_TERMINAL = 'SELECT IPV4,BD_USUARIO,BD_PASSWORD FROM PDV_C_TERMINAL P '+
                  'WHERE ESTATUS = ''A'' AND ID_TERMINAL = ''%s'' ';

type
  PorTerminal = class(TThread)
  private
    { Private declarations }

    procedure apartaCorridaRemoto();
    procedure accesoServer(host, user, passowrd : string);
  protected
    procedure Execute; override;
  public
    lc_conexion   : TUniConnection;//para conectarnos localmente
    ls_corrida   : String;
    ls_fecha     : string;
    ls_hora      : string;
    li_ruta      : Integer;
    ls_terminal  : string;
    ls_user      : string;
  end;

implementation



{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure PorTerminal.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end;

    or
    
    Synchronize( 
      procedure 
      begin
        Form1.Caption := 'Updated in thread via an anonymous method'
      end
      )
    );
    
  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ PorTerminal }

procedure PorTerminal.accesoServer(host, user, passowrd: string);
var
    serverRemoto : TUniConnection;
    lq_qry       :  TUniQuery;
begin{    lc_conexion   : TSQLConnection;//para conectarnos localmente
    li_corrida   : Integer;
    ls_fecha     : string;
    ls_hora      : string;
    li_ruta      : Integer;
    ls_terminal  : string;
    ls_user      : string;}
    serverRemoto := TUniConnection.Create(nil);
    try
{      serverRemoto.DriverName :=  'MySql';
      serverRemoto.Params.Values['HOSTNAME']  := lq_qry['IPV4'];
      serverRemoto.Params.Values['DATABASE']  := 'MySql';
      serverRemoto.Params.Values['USER_NAME'] := lq_qry['BD_USUARIO'];
      serverRemoto.Params.Values['PASSWORD']  := lq_qry['BD_PASSWORD'];
      serverRemoto.LoginPrompt := False;
      serverRemoto.Connected := true;
      lq_qry.SQLConnection := serverRemoto;}
      try
          lq_qry.SQL.Clear;
          lq_qry.SQL.Add('UPDATE PDV_T_CORRIDA_D SET TRAB_ID = :ls_user ');
          lq_qry.SQL.Add('WHERE ID_CORRIDA = :ls_corrida AND FECHA = :ls_fecha ');
          lq_qry.SQL.Add('AND HORA = :ls_hora AND ID_RUTA = :li_ruta ');
          lq_qry.Params[0].AsString  := ls_user;
          lq_qry.Params[1].AsString :=  ls_corrida;
          lq_qry.Params[2].AsString  := ls_fecha;
          lq_qry.Params[3].AsString  := ls_hora;
          lq_qry.Params[4].AsInteger := li_ruta;
          lq_qry.ExecSQL();
      finally
          lq_qry.Destroy;
      end;
    finally
        serverRemoto.Destroy;
    end;
end;

{ _VENTA_TERMINAL = 'SELECT IPV4,BD_USUARIO,BD_PASSWORD FROM PDV_C_TERMINAL P '+
                  'WHERE ESTATUS = ''A'' AND ID_TERMINAL = ''%s'' ';}
procedure PorTerminal.apartaCorridaRemoto;
var
    lq_query : TUniQuery;
    ls_sttr  : string;
begin
    lq_query := TUniQuery.Create(nil);
    try
        lq_query.Connection := lc_conexion;
        ls_sttr := format(_VENTA_TERMINAL,[ls_terminal]);
        lq_query.SQL.Clear;
        lq_query.SQL.Add(ls_sttr);
        lq_query.Open;
        if not lq_query.IsEmpty then begin //conecta al remoto
            accesoServer(lq_query['IPV4'],lq_query['BD_USUARIO'],lq_query['BD_PASSWORD']);
        end;
    finally
         lq_query.Destroy;
    end;
end;

procedure PorTerminal.Execute;
begin
  { Place thread code here }
    CoInitialize(nil);
    apartaCorridaRemoto();
    CoUninitialize();
end;

end.
