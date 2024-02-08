unit u_autobus;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    DB, Grids, Dialogs,
    StdCtrls, comun, DMdb, lsCombobox, SysUtils, Data.SqlExpr;

Const
    _BUS_SELCCIONA_ALL = 'SELECT ID_TIPO_AUTOBUS,TIPO_AUTOBUS,ASIENTOS,NOMBRE_IMAGEN FROM PDV_C_TIPO_AUTOBUS P;';
    _BUS_ELIMINA_SEATS = 'DELETE FROM PDV_C_TIPO_AUTOBUS_D WHERE ID_TIPO_AUTOBUS = %s;';
    _BUS_SALVA_SEATS   = 'INSERT INTO PDV_C_TIPO_AUTOBUS_D VALUES(%s,%s,%s,%s);';

    procedure borrar(id_bus : integer);
    procedure add_asientos(grid : TStringGrid; id_bus : integer);
implementation

var
    Store : TSQLStoredProc;


procedure borrar(id_bus : integer);
begin
    Store := TSQLStoredProc.Create(nil);
    try
        Store.SQLConnection := DM.Conecta;
        store.close;
        Store.StoredProcName := 'PDV_STORE_BORRA_BUS_CORDENADA';
        Store.Params.ParamByName('BUS_ID').AsInteger := id_bus;
        Store.ExecProc;
    finally
        Store.Free;
        Store := nil;
    end;
end;


procedure add_asientos(grid : TStringGrid; id_bus : integer);
var
    li_idx : Integer;
begin
    Store := TSQLStoredProc.Create(nil);
    Store.SQLConnection := DM.Conecta;
    for li_idx := 0 to grid.RowCount - 1 do begin
        Store.Close;
        Store.StoredProcName := 'PDV_STORE_ADD_COORDENADAS';
        Store.Params.ParamByName('ID_BUS').AsInteger := id_bus;
        Store.Params.ParamByName('X').AsInteger := StrToInt(grid.Cells[1,li_idx]);
        Store.Params.ParamByName('Y').AsInteger := StrToInt(grid.Cells[2,li_idx]);
        Store.Params.ParamByName('NUMERO').AsInteger := StrToInt(grid.Cells[0,li_idx]);
        Store.ExecProc;
    end;
end;


end.
