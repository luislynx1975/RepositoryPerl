unit frm_personalizacion_boletos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, Buttons, Grids,
  ExtCtrls;

type
  TFrm_boleto_personalizado = class(TForm)
    Panel1: TPanel;
    stg_nombres: TStringGrid;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    ActionManager1: TActionManager;
    Salir: TAction;
    procedure SalirExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FnumeroBoletos : integer;
    procedure titulos();
  public
    { Public declarations }
    property numero : integer write FnumeroBoletos;
  end;

var
  Frm_boleto_personalizado: TFrm_boleto_personalizado;

implementation

uses DMdb, u_comun_venta, comun;

{$R *.dfm}

procedure TFrm_boleto_personalizado.FormShow(Sender: TObject);
begin
    stg_nombres.RowCount := FnumeroBoletos + 1;
    titulos();
end;

procedure TFrm_boleto_personalizado.SalirExecute(Sender: TObject);
var
    li_rows : integer;
begin
    for li_rows := 1 to stg_nombres.rowCount do begin
        if length(stg_nombres.cells[0,li_rows]) > 0 then begin
            ga_boletos_nombres[li_rows] := quiapo(stg_nombres.cells[0,li_rows]) + '*' + quiapo(stg_nombres.cells[1,li_rows]);
        end;
    end;
    close;
end;


procedure TFrm_boleto_personalizado.titulos;
begin
    stg_nombres.Cells[0,0] := 'Nombre';
    stg_nombres.Cells[1,0] := 'Credencial';
end;


end.
