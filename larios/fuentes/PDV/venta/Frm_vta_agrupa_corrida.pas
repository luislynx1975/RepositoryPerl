unit Frm_vta_agrupa_corrida;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, comun, ActnList, ComCtrls, ToolWin, DMdb, Menus,
  U_venta, PlatformDefaultStyleActnCtrls, ActnMan, ActnCtrls, ActnMenus,
  DB, System.Actions, Data.SqlExpr;

type
  TFrm_corrida_agrupa = class(TForm)
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
    GroupBox1: TGroupBox;
    stg_origen_agrupa: TStringGrid;
    StatusBar1: TStatusBar;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    ac99: TAction;
    procedure FormShow(Sender: TObject);
    procedure ac99Execute(Sender: TObject);
    procedure stg_corridaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stg_corridaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure Titles();
    procedure recolectarCorridas();
  public
    { Public declarations }
    ventaStringGrid : TStringGrid;
    li_row_corrida  : integer;
    ls_origen       : String;
  end;

var
  Frm_corrida_agrupa: TFrm_corrida_agrupa;

implementation

uses TLiberaAsientosRuta, u_comun_venta;

{$R *.dfm}

var
    la_emisora : gga_parameters;
    la_receptora : gga_parameters;


{ TForm1 }

procedure TFrm_corrida_agrupa.ac99Execute(Sender: TObject);
begin
    Close;
end;

procedure TFrm_corrida_agrupa.FormShow(Sender: TObject);
begin
    Titles;
    recolectarCorridas;
end;


procedure TFrm_corrida_agrupa.recolectarCorridas;
var
    li_idx, li_indice, li_row : Integer;
    ls_ruta, ls_servicio, ls_destino: String;
begin
    ls_ruta := ventaStringGrid.Cols[_COL_RUTA].Strings[li_row_corrida];
    ls_servicio := ventaStringGrid.Cols[_COL_SERVICIO].Strings[li_row_corrida];
    ls_destino   := ventaStringGrid.Cols[_COL_DESTINO].Strings[li_row_corrida];
    li_row := 1;
     stg_origen_agrupa.Cells[_COL_HORA,li_row] := ventaStringGrid.Cols[_COL_HORA].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_DESTINO,li_row] := ventaStringGrid.Cols[_COL_DESTINO].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_SERVICIO,li_row] := ventaStringGrid.Cols[_COL_SERVICIO].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_FECHA,li_row] := ventaStringGrid.Cols[_COL_FECHA].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_TRAMO,li_row] := ventaStringGrid.Cols[_COL_TRAMO].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_RUTA,li_row] := ventaStringGrid.Cols[_COL_RUTA].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_CORRIDA,li_row] := ventaStringGrid.Cols[_COL_CORRIDA].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_AUTOBUS,li_row] := ventaStringGrid.Cols[_COL_AUTOBUS].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_NAME_IMAGE,li_row] := ventaStringGrid.Cols[_COL_NAME_IMAGE].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_ASIENTOS,li_row] := ventaStringGrid.Cols[_COL_ASIENTOS].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_TIPOSERVICIO,li_row] := ventaStringGrid.Cols[_COL_TIPOSERVICIO].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_CUPO,li_row] := ventaStringGrid.Cols[_COL_CUPO].Strings[li_row_corrida];
     stg_origen_agrupa.Cells[_COL_PIE,li_row] := ventaStringGrid.Cols[_COL_PIE].Strings[li_row_corrida];
    for li_idx := li_row_corrida + 1 to ventaStringGrid.RowCount do begin
        if (ls_ruta = ventaStringGrid.Cols[_COL_RUTA].Strings[li_idx]) and
           (ls_destino = ventaStringGrid.Cols[_COL_DESTINO].Strings[li_idx]) and
           (ls_servicio = ventaStringGrid.Cols[_COL_SERVICIO].Strings[li_idx]) then begin
           stg_corrida.Cells[_COL_HORA,li_row] := ventaStringGrid.Cols[_COL_HORA].Strings[li_idx];
           stg_corrida.Cells[_COL_DESTINO,li_row] := ventaStringGrid.Cols[_COL_DESTINO].Strings[li_idx];
           stg_corrida.Cells[_COL_SERVICIO,li_row] := ventaStringGrid.Cols[_COL_SERVICIO].Strings[li_idx];
           stg_corrida.Cells[_COL_FECHA,li_row] := ventaStringGrid.Cols[_COL_FECHA].Strings[li_idx];
           stg_corrida.Cells[_COL_TRAMO,li_row] := ventaStringGrid.Cols[_COL_TRAMO].Strings[li_idx];
           stg_corrida.Cells[_COL_RUTA,li_row] := ventaStringGrid.Cols[_COL_RUTA].Strings[li_idx];
           stg_corrida.Cells[_COL_CORRIDA,li_row] := ventaStringGrid.Cols[_COL_CORRIDA].Strings[li_idx];
           stg_corrida.Cells[_COL_AUTOBUS,li_row] := ventaStringGrid.Cols[_COL_AUTOBUS].Strings[li_idx];
           stg_corrida.Cells[_COL_NAME_IMAGE,li_row] := ventaStringGrid.Cols[_COL_NAME_IMAGE].Strings[li_idx];
           stg_corrida.Cells[_COL_ASIENTOS,li_row] := ventaStringGrid.Cols[_COL_ASIENTOS].Strings[li_idx];
           stg_corrida.Cells[_COL_TIPOSERVICIO,li_row] := ventaStringGrid.Cols[_COL_TIPOSERVICIO].Strings[li_idx];
           stg_corrida.Cells[_COL_CUPO,li_row] := ventaStringGrid.Cols[_COL_CUPO].Strings[li_idx];
           stg_corrida.Cells[_COL_PIE,li_row] := ventaStringGrid.Cols[_COL_PIE].Strings[li_idx];
           inc(li_row);
        end;
    end;
    stg_corrida.RowCount := li_row;
end;

procedure TFrm_corrida_agrupa.stg_corridaKeyPress(Sender: TObject;
  var Key: Char);
var
    li_maximo : integer;
    store    : TSQLStoredProc;
    ls_sentencia : string;
    hilo_libera : Libera_Asientos;
begin               // _AGRUPA_CORRIDAS
    if Key = #13 then begin///agrupamos las corridas
    ///buscamos que las dos corridas no esten vendiendo
        if Application.MessageBox(_MSG_AGRUPAR_CORRIDA, 'Confirmacion', _CONFIRMAR) = IDYES then begin
          if  not AccesoPermitido(182,False) then
              exit;
            ls_sentencia := Format(_AGRUPA_CORRIDAS,[ stg_origen_agrupa.Cols[_COL_CORRIDA].Strings[stg_origen_agrupa.Row],
                              formatDateTime('YYYY-MM-DD',StrToDate(stg_origen_agrupa.Cols[_COL_FECHA].Strings[stg_origen_agrupa.Row])),
                              stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                              formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]))]);
             store := TSQLStoredProc.Create(nil);
             store.SQLConnection := DM.Conecta;
             store.close;
             store.StoredProcName := 'PDV_STORE_AGRUPA_CORRIDAS';

             store.Params.ParamByName('ORIGEN_CORRIDA').AsString := stg_origen_agrupa.Cols[_COL_CORRIDA].Strings[stg_origen_agrupa.Row];
             store.Params.ParamByName('ORIGEN_FECHA').AsString := formatDateTime('YYYY-MM-DD',StrToDate(stg_origen_agrupa.Cols[_COL_FECHA].Strings[stg_origen_agrupa.Row]));
             store.Params.ParamByName('DESTINO_CORRIDA').AsString := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
             store.Params.ParamByName('DESTINO_FECHA').AsString := formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]));
             store.ExecProc;
             gli_agrupa_corrida := 1;
             hilo_libera := Libera_Asientos.Create(true);
             hilo_libera.server := DM.Conecta;
             hilo_libera.sentenciaSQL := ls_sentencia;
             hilo_libera.ruta   := StrToInt(stg_origen_agrupa.Cols[_COL_RUTA].Strings[stg_origen_agrupa.Row]);
             hilo_libera.origen := ls_origen;
             hilo_libera.destino := stg_origen_agrupa.Cols[_COL_DESTINO].Strings[stg_origen_agrupa.Row];
             hilo_libera.Priority := tpNormal;
             hilo_libera.FreeOnTerminate := True;
             hilo_libera.start;
             Close;
          end;
    end else gli_agrupa_corrida := 0;
end;


procedure TFrm_corrida_agrupa.stg_corridaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, fila: Integer;
begin
  if Button = mbRight then
  begin
    stg_corrida.MouseToCell(X, Y, Col, fila);
    stg_corrida.Col := Col;
    stg_corrida.Row := fila;
  end;
end;


procedure TFrm_corrida_agrupa.Titles;
begin
    stg_corrida.Cells[_COL_HORA, 0] := 'HORA';
    stg_corrida.Cells[_COL_DESTINO, 0] := 'DESTINO';
    stg_corrida.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
    stg_corrida.Cells[_COL_FECHA, 0] := 'FECHA';
    stg_corrida.Cells[_COL_TRAMO, 0] := '';
    stg_corrida.ColWidths[_COL_TRAMO] := 0;
    stg_corrida.ColWidths[_COL_RUTA] := 0;
    stg_corrida.ColWidths[_COL_CORRIDA] := 0;
    stg_corrida.ColWidths[_COL_AUTOBUS] := 0;
    stg_corrida.ColWidths[_COL_ASIENTOS] := 0;
    stg_corrida.ColWidths[_COL_NAME_IMAGE] := 0;
    stg_corrida.ColWidths[_COL_TIPOSERVICIO] := 0;

    stg_origen_agrupa.Cells[_COL_HORA, 0] := 'HORA';
    stg_origen_agrupa.Cells[_COL_DESTINO, 0] := 'DESTINO';
    stg_origen_agrupa.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
    stg_origen_agrupa.Cells[_COL_FECHA, 0] := 'FECHA';
    stg_origen_agrupa.Cells[_COL_TRAMO, 0] := '';
    stg_origen_agrupa.ColWidths[_COL_TRAMO] := 0;
    stg_origen_agrupa.ColWidths[_COL_RUTA] := 0;
    stg_origen_agrupa.ColWidths[_COL_CORRIDA] := 0;
    stg_origen_agrupa.ColWidths[_COL_AUTOBUS] := 0;
    stg_origen_agrupa.ColWidths[_COL_ASIENTOS] := 0;
    stg_origen_agrupa.ColWidths[_COL_NAME_IMAGE] := 0;
    stg_origen_agrupa.ColWidths[_COL_TIPOSERVICIO] := 0;
end;

end.
