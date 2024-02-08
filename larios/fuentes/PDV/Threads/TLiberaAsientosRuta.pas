unit TLiberaAsientosRuta;

interface
{$warnings off}
{$hints off}
uses
  Classes, StdCtrls, DB, ActiveX, SysUtils, Data.SqlExpr;

type
  Libera_Asientos = class(TThread)
  private
    { Private declarations }
    procedure ejecutaLiberacion();
  protected
    procedure Execute; override;
  public
    { Public declarations }
    server       : TSQLConnection;
    sentenciaSQL : string;
    ruta         : integer;
    origen       : string;
    destino      : string;
  end;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TLibera_Asientos.UpdateCaption;
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

{ TLibera_Asientos }

procedure Libera_Asientos.ejecutaLiberacion;
var
    lq_qry : TSQLQuery;
    lq_qry_server : TSQLQuery;
begin
    try
        lq_qry := TSQLQuery.Create(nil);
        lq_qry_server := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := server;
        lq_qry_server.SQLConnection := server;
        lq_qry.SQL.Clear;
        lq_qry.SQL.Add('SELECT T.DESTINO ');
        lq_qry.SQL.Add('FROM T_C_RUTA_D AS R JOIN T_C_TRAMO AS T ON R.ID_TRAMO = T.ID_TRAMO ');
        lq_qry.SQL.Add('WHERE R.ID_RUTA = '+ IntToStr(ruta) );
        lq_qry.SQL.Add(' AND T.DESTINO IN (SELECT ID_TERMINAL ');
        lq_qry.SQL.Add('                  FROM PDV_C_TERMINAL ');
        lq_qry.SQL.Add('                  WHERE ESTATUS = ''A'' AND TIPO = ''T'') ');
        lq_qry.SQL.Add('AND R.ORDEN >= (SELECT D.ORDEN ');
        lq_qry.SQL.Add('                FROM T_C_RUTA_D D INNER JOIN  T_C_TRAMO T ON T.ID_TRAMO = D.ID_TRAMO ');
        lq_qry.SQL.Add('                WHERE ID_RUTA = '+ IntToStr(ruta) + ' AND T.ORIGEN = :origen');
        lq_qry.SQL.Add(' ) AND R.ORDEN < (SELECT D.ORDEN ');
        lq_qry.SQL.Add('                 FROM T_C_RUTA_D D INNER JOIN  T_C_TRAMO T ON T.ID_TRAMO = D.ID_TRAMO ');
        lq_qry.SQL.Add('                 WHERE ID_RUTA = '+ IntToStr(ruta) + ' AND T.DESTINO  = :dest ) ');
        lq_qry.SQL.Add('ORDER BY ORDEN ');
        lq_qry.Params[0].AsString   := origen;
        lq_qry.Params[1].AsString   := destino;
        lq_qry.Open;
        with lq_qry do begin
            lq_qry.First;
            while not EoF do begin
                lq_qry_server.SQLConnection := server;

                lq_qry_server.SQL.Clear;
                lq_qry_server.SQL.Add('INSERT INTO PDV_T_QUERY(ID_TERMINAL,SENTENCIA,FECHA_HORA) ');
                lq_qry_server.SQL.Add('VALUES(:terminal, :sentenciaSQL, now())');
                lq_qry_server.Params[0].AsString := lq_qry['DESTINO'];
                lq_qry_server.Params[1].AsString := sentenciaSQL;
                lq_qry_server.ExecSQL();
                lq_qry.Next;
            end;//fin while
        end;//fin with
    finally
        lq_qry.Destroy;
    end;
end;

procedure Libera_Asientos.Execute;
begin
  { Place thread code here }
  { Place thread code here }
    CoInitialize(nil);
    ejecutaLiberacion();
    CoUninitialize();
end;

end.
