unit frm_tarjeta_catalogo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, FMTBcd, Data.SqlExpr;

type
  Tfrm_catalogo_pago = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    cmb_tarjetas: TlsComboBox;
    Button1: TButton;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cmb_tarjetasKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_catalogo_pago: Tfrm_catalogo_pago;

implementation

uses DMdb, u_comun_venta, U_venta;

{$R *.dfm}

procedure Tfrm_catalogo_pago.Button1Click(Sender: TObject);
var
    li_idx : integer;
begin
    if cmb_tarjetas.ItemIndex = -1 then begin
        ShowMessage('Debe seleccionar un tipo de tarjeta Credito o Debito');
        exit;
    end;
    gs_tarjeta_usuario := cmb_tarjetas.CurrentID;
    gs_tarjeta_CD := cmb_tarjetas.CurrentID;
    Close;
end;


procedure Tfrm_catalogo_pago.cmb_tarjetasKeyPress(Sender: TObject;
  var Key: Char);
begin
    if Key = #27 then
        Button1Click(Sender);
end;

procedure Tfrm_catalogo_pago.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    if length(gs_tarjeta_usuario) = 0 then begin
        ShowMessage('Seleccione el tipo de tarjeta');
        Action := caNone;
        cmb_tarjetas.SetFocus;
    end else begin
        Close;
    end;
end;

procedure Tfrm_catalogo_pago.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_F4) and (ssAlt in Shift) then
        Key := 0;
    if key = 27 then
        key := 0;
end;

procedure Tfrm_catalogo_pago.FormShow(Sender: TObject);
var
    qry : TSQLQuery;
begin
    qry := TSQLQuery.Create(nil);

    qry.SQLConnection := DM.Conecta;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT ABREVIACION, DESCRIPCION FROM PDV_C_CATALOGO_PAGO');
    qry.Open;
    with qry do begin
      First;
      while not EoF do begin
          cmb_tarjetas.Add(qry['DESCRIPCION'],qry['ABREVIACION']);
          Next;
      end;
    end;
    cmb_tarjetas.itemIndex := 0;
    cmb_tarjetas.SetFocus;
    qry.Free;
    qry := nil;
end;

end.
