unit frm_usuario_boletos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, Asiento, U_venta, ComCtrls;

type
  Tfrm_nombre_boleto = class(TForm)
    Panel1: TPanel;
    stg_nombre_boleto: TStringGrid;
    st_statuspnl: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure stg_nombre_boletoSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stg_nombre_boletoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
     asientos : array_asientos;
    procedure setAsientosNombre(const Value: array_asientos);
  public
    { Public declarations }
     property nombres : array_asientos write setAsientosNombre;
  end;

var
  frm_nombre_boleto: Tfrm_nombre_boleto;

implementation

{$R *.dfm}

{ Tfrm_nombre_boleto }

procedure Tfrm_nombre_boleto.FormActivate(Sender: TObject);
begin
    st_statuspnl.Panels[0].Text := 'ESC salir';
end;

procedure Tfrm_nombre_boleto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    li_ctrl : Integer;
begin
    if (Key = VK_F4) and (ssAlt in Shift) then Key := 0;

    if Key = VK_ESCAPE then begin //guardamos en el arreglo de asientos el nombre
        for li_ctrl := 1 to stg_nombre_boleto.RowCount do begin
            asientos[li_ctrl].nombre := UpperCase(stg_nombre_boleto.Cells[_GRID_PAS_PASAJERO,li_ctrl]);
        end;
        Close;
    end;
end;


procedure Tfrm_nombre_boleto.FormShow(Sender: TObject);
var
    li_ctrl : Integer;
begin
    for li_ctrl := 1 to li_ctrl_asiento do begin
        stg_nombre_boleto.Cells[_GRID_PAS_ASIENTO,li_ctrl] := IntToStr(Asientos[li_ctrl].asiento);
        stg_nombre_boleto.Cells[_GRID_PAS_PRECIO,li_ctrl]  := FloatToStr(Asientos[li_ctrl].precio);
        stg_nombre_boleto.Cells[_GRID_PAS_SERVICIO,li_ctrl] := Asientos[li_ctrl].servicio;
        stg_nombre_boleto.Cells[_GRID_PAS_ORIGEN,li_ctrl]  := Asientos[li_ctrl].origen + ' - ' +
                                                              Asientos[li_ctrl].destino;
    end;
    stg_nombre_boleto.RowCount := li_ctrl_asiento + 1;
    stg_nombre_boleto.Row := 1;
    stg_nombre_boleto.SetFocus;
end;

procedure Tfrm_nombre_boleto.setAsientosNombre(const Value: array_asientos);
begin
    asientos := Value;
end;

procedure Tfrm_nombre_boleto.stg_nombre_boletoKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
///si es l ultima fila cerrarlo y guardarlo
end;

procedure Tfrm_nombre_boleto.stg_nombre_boletoSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if (ACol = _GRID_PAS_PASAJERO) then
      stg_nombre_boleto.Options := stg_nombre_boleto.Options+[goEditing]
    else
      stg_nombre_boleto.Options := stg_nombre_boleto.Options-[goEditing]
end;

end.
