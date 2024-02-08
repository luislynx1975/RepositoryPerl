unit ThreadDetalleRuta;

interface

uses
  Classes, Grids, ActiveX,  DB,  SysUtils, DBGrids,Forms,
  Controls, dATA.SqlExpr;

type
  DetalleRuta = class(TThread)
  private
    { Private declarations }
    store     : TSQLStoredProc;
    procedure DetalleRuta();
    procedure OcupanteDetalle();
  protected
    procedure Execute; override;
  public
     Grid_RTodas      : TStringGrid;
     Grid_DetalleRuta : TStringGrid;
     ruta             : integer;
     server           : TSQLConnection;
     origen           : String;
     corrida          : String;
     fecha            : String;
     Grid_Ocupantes   : TStringGrid;
  end;

implementation


{ DetalleRuta }

procedure DetalleRuta.DetalleRuta;
var
    li_row, li_row_nueva : integer;
begin
    li_row_nueva := 0;
    Grid_DetalleRuta.RowCount := li_row_nueva;
    for li_row := 0 to Grid_RTodas.RowCount - 1 do begin
         if StrToInt(Grid_RTodas.Cells[0,li_row]) = ruta then begin
              Grid_DetalleRuta.Cells[0,li_row_nueva] := Grid_RTodas.Cells[4,li_row];
              Grid_DetalleRuta.Cells[1,li_row_nueva] := Grid_RTodas.Cells[5,li_row];
              inc(li_row_nueva);
         end;
    end;
    Grid_DetalleRuta.RowCount := li_row_nueva;
end;

procedure DetalleRuta.Execute;
begin
  { Place thread code here }
    CoInitialize(nil);
//    Synchronize(DetalleRuta);
//    Synchronize(OcupanteDetalle);
    CoUninitialize();
    server.Connected := False;
end;

procedure DetalleRuta.OcupanteDetalle;
var
    li_row : integer;
    fecha1 : String;
begin
    try
        store := TSQLStoredProc.Create(nil);
        fecha1 := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
        Screen.Cursor:=crDefault;
        store.SQLConnection := server;
        store.close;
        store.StoredProcName := 'PDV_STORE_SHOW_OCUPANTES';
        store.Params.ParamByName('IN_TERMINAL').AsString := origen;
        store.Params.ParamByName('IN_FECHA').AsString := fecha1;
        store.Params.ParamByName('IN_CORRIDA').AsString := corrida;
        store.Open;
        li_row := 0;
        Grid_Ocupantes.Visible := False;
        with store do begin
            DisableControls;
            First;
            while not EoF do begin
                Grid_Ocupantes.Cells[0,li_row] := Store.FieldByName('DESCRIPCION').AsString;
                Grid_Ocupantes.Cells[1,li_row] := Store.FieldByName('TOTAL').AsString;
                inc(li_row);
                next;
            end;
            EnableControls;
        end;
        Grid_Ocupantes.RowCount := li_row;
        Grid_Ocupantes.Visible := True;
    finally
      store.Free;
      store := nil;
    end;
end;

end.
