unit ThreadRutas;

interface

uses
  Classes, Grids, ActiveX,  DB, SysUtils, DBGrids, SimpleDS, Uni;

type
  TodasRutasDetalle = class(TThread)
  private
    { Private declarations }
    store : TUniStoredProc;
    procedure escribeGrid;
    procedure escribeTarifas;
  protected
    procedure Execute; override;
  public
    server    : TUniConnection;
    grid      : TStringGrid;
    grid_tarifa : TStringGrid;
  end;

implementation


{ TodasRutasDetalle }

procedure TodasRutasDetalle.escribeGrid;
var
    li_ctrl : integer;
begin
    store := TUniStoredProc.Create(nil);
    try
        store.Connection := server;
        store.Close;
        store.StoredProcName := 'PDV_STORE_RUTAS';
        store.Prepare;
        store.ParamByName('ENTRADA').AsString := '1';
        store.open;
        with store do begin
            DisableControls;
            First;
            li_ctrl := 0;
            while not Eof do begin
                Grid.Cells[0,li_ctrl] := Store['ID_RUTA'];
                Grid.Cells[1,li_ctrl] := Store['ORDEN'];
                Grid.Cells[2,li_ctrl] := Store['ID_TRAMO'];
                Grid.Cells[3,li_ctrl] := Store['ORIGEN'];
                Grid.Cells[4,li_ctrl] := Store['DESTINO'];
                Grid.Cells[5,li_ctrl] := Store['DESCRIPCION'];
                inc(li_ctrl);
                Next;
            end;
            EnableControls;
        end;
        grid.RowCount := li_ctrl;
    finally
      store.Free;
      store := nil;
    end;
end;

procedure TodasRutasDetalle.escribeTarifas;
var
    li_ctrl : integer;
begin
    store := TUniStoredProc.Create(nil);
    try
        store.Connection := server;
        store.StoredProcName := 'PDV_STORE_RUTAS_TARIFA';
        store.Prepare;
        store.ParamByName('INPUT').AsInteger := 1;
        store.open;
        with store do begin
            DisableControls;
            First;
            li_ctrl := 0;
            while not Eof do begin
                grid_tarifa.Cells[0,li_ctrl] := Store['ID_RUTA'];
                grid_tarifa.Cells[1,li_ctrl] := Store['ORDEN'];
                grid_tarifa.Cells[2,li_ctrl] := Store['ID_TRAMO'];
                grid_tarifa.Cells[3,li_ctrl] := Store['ORIGEN'];
                grid_tarifa.Cells[4,li_ctrl] := Store['DESTINO'];
                grid_tarifa.Cells[5,li_ctrl] := Store['ID_SERVICIO'];
                grid_tarifa.Cells[6,li_ctrl] := FloatToStr(store['MONTO']);
                inc(li_ctrl);
                Next;
            end;
            EnableControls;
        end;
        grid.RowCount := li_ctrl;
    finally
      store.Free;
    end;
end;

procedure TodasRutasDetalle.Execute;
begin
  { Place thread code here }
    CoInitialize(nil);
    Synchronize(escribeGrid);
    CoUninitialize();
end;

end.
