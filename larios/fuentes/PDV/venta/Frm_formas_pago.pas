unit Frm_formas_pago;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, U_venta, lsCombobox, Data.SqlExpr;

type
  Tfrm_pago_boleto = class(TForm)
    GroupBox1: TGroupBox;
    stg_formas: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stg_formasSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    BoletosVendidos : array_asientos;
    indiceBoleto    :  integer;
    procedure setBoletosPago(const Value: array_asientos);
    procedure setIndexBoletos(const Value: integer);
//    procedure llenarComboDescuentos (combo : TlsComboBox);
  public
    { Public declarations }
    property boletos : array_asientos write setBoletosPago;
    property indice  : integer  write setIndexBoletos;
  end;

var
  frm_pago_boleto: Tfrm_pago_boleto;

implementation

uses DMdb, comun;

{$R *.dfm}

var
    lq_query : TSQLQuery;
    combo : array[1..30]of TlsComboBox;
    li_combo : Integer;



procedure Tfrm_pago_boleto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Close;
end;


procedure Tfrm_pago_boleto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_F10 then
        Close;
end;

procedure Tfrm_pago_boleto.FormShow(Sender: TObject);
var
    li_ctrl_interno : Integer;
begin
    stg_formas.Row := 1;
    stg_formas.Col := 1;
    stg_formas.SetFocus;
    stg_formas.EditorMode := True;
    for li_ctrl_interno := 1 to indiceBoleto - 1 do begin
{        stg_formas.Cells[_DESCRIPCION_BOLETO,li_ctrl_interno] :=
              BoletosVendidos[li_ctrl_interno].origen + ' - ' +
              BoletosVendidos[li_ctrl_interno].destino;
 }
        combo[li_ctrl_interno]            := TlsComboBox.Create(Self);
        combo[li_ctrl_interno].Parent     := stg_formas;
        combo[li_ctrl_interno].BoundsRect := stg_formas.CellRect(1,li_ctrl_interno);
        combo[li_ctrl_interno].Name       := 'cb_descuento' + IntToStr(li_ctrl_interno);
//        combo[li_ctrl_interno].Style := csSimple;
//        combo[li_ctrl_interno].OnExit := ComboExit;
        LlenarComboBox(lq_query,combo[li_ctrl_interno],false);
    end;
    stg_formas.RowCount := indiceBoleto;
end;


{
procedure TFrm_venta_principal.ls_Desde_vtaExit(Sender: TObject);
var
    li_tmp : integer;
begin
    li_tmp := ls_Desde_vta.IDs.IndexOf(UpperCase(ls_Desde_vta.Text));

    if ls_Desde_vta.ItemIndex < 0 then
        if li_tmp >= 0 then
           ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(UpperCase(ls_Desde_vta.Text))
        else ls_Desde_vta.Text := '';
end;}


{procedure Tfrm_pago_boleto.llenarComboDescuentos (combo : TlsComboBox);
begin
    with lq_query do begin
        First;
        while not EoF do begin
            combo.Add(lq_query.Fields[2].AsString,lq_query.Fields[1].AsString);
            Next;
        end;
    end;
end;}


procedure Tfrm_pago_boleto.setBoletosPago(const Value: array_asientos);
begin
    BoletosVendidos := Value;
end;

procedure Tfrm_pago_boleto.setIndexBoletos(const Value: integer);
begin
    indiceBoleto := Value;
end;

procedure Tfrm_pago_boleto.stg_formasSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    li_combo := stg_formas.Row;
    if (ACol = 1) then
        stg_formas.Options := stg_formas.Options+[goEditing]
    else
        stg_formas.Options := stg_formas.Options-[goEditing]
end;


end.
