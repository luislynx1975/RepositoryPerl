unit frm_vta_libera_corrida;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, comun, U_venta, DMdb, ActnList, Menus, ExtCtrls,
  ComCtrls, ToolWin, System.Actions;

type
  Tfrm_corrida_libera = class(TForm)
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
    PopupMenu1: TPopupMenu;
    ActionList1: TActionList;
    ac159: TAction;
    Liberarcorrida1: TMenuItem;
    Timer: TTimer;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ac99: TAction;
    Liberatodascorridas1: TMenuItem;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure ac159Execute(Sender: TObject);
    procedure stg_corridaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TimerTimer(Sender: TObject);
    procedure ac99Execute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Liberatodascorridas1Click(Sender: TObject);
  private
    { Private declarations }
    procedure Titles();
  public
    { Public declarations }
  end;

var
  frm_corrida_libera: Tfrm_corrida_libera;

implementation

{$R *.dfm}

{ Tfrm_corrida_libera }

procedure Tfrm_corrida_libera.Liberatodascorridas1Click(Sender: TObject);
var
    li_ctrl : integer;
begin
{    if not AccesoPermitido(ac159.Tag,FALSE) then
        Exit;}
    for li_ctrl := 1 to stg_corrida.RowCount - 1 do begin
      gs_hora_apartada    := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[li_ctrl]);
      apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[li_ctrl],
                    StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_ctrl]),
                    gs_hora_apartada, gs_terminal,'N',
                    StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[li_ctrl]));
    end;
    Titles();
    Close;
end;


procedure Tfrm_corrida_libera.ac159Execute(Sender: TObject);
begin
{      if not AccesoPermitido(ac159.Tag,FALSE) then
          Exit;}
      if stg_corrida.Row > 0 then begin
          gs_hora_apartada    := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
          apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                        StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                        gs_hora_apartada, gs_terminal,'N',
                        StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
          Titles();
      end;
end;



procedure Tfrm_corrida_libera.ac99Execute(Sender: TObject);
begin
    Close();
end;

procedure Tfrm_corrida_libera.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Timer.Enabled := False;
end;

procedure Tfrm_corrida_libera.FormShow(Sender: TObject);
begin
    Titles();
    Timer.Enabled := true;
end;


procedure Tfrm_corrida_libera.stg_corridaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    Col, fila : Integer;
begin
    if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
        exit;

    if Button = mbRight then begin
        stg_corrida.MouseToCell(X,Y,Col,fila);
        stg_corrida.Col := Col;
        stg_corrida.Row := fila;
    end;
end;



procedure Tfrm_corrida_libera.TimerTimer(Sender: TObject);
begin
    Titles();
end;

procedure Tfrm_corrida_libera.Titles;
begin
    titulosCorridaGrid(stg_corrida);
    stg_corrida.ColWidths[_COL_TARIFA] := 0;
    stg_corrida.Cells[_COL_TRABID,0] := 'Usuario';
    MuestraCorridasLiberar(gs_terminal,stg_corrida);
end;

end.
