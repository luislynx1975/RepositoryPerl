unit Frm_fondo_inicial;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ComCtrls, lsStatusBar;

type
  TFrm_reg_fondo_inicial = class(TForm)
    msk_fondo: TMaskEdit;
    Button1: TButton;
    Label1: TLabel;
    lsStatusBar1: TlsStatusBar;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure msk_fondoChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure msk_fondoKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_reg_fondo_inicial: TFrm_reg_fondo_inicial;

implementation

uses comun, U_venta;

{$R *.dfm}

procedure TFrm_reg_fondo_inicial.Button1Click(Sender: TObject);
begin
    if Length(msk_fondo.Text) = 0 then begin
        Mensaje('Ingrese el fondo inicial',0);
        exit;
    end;
    gs_fondo_inicial := msk_fondo.text;
    gb_fondo_ingresado := true;
    Close;
end;

procedure TFrm_reg_fondo_inicial.Button2Click(Sender: TObject);
begin
    gb_fondo_ingresado := False;
    Close;
end;

procedure TFrm_reg_fondo_inicial.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_F4) and (ssAlt in Shift) then Key := 0;
end;

procedure TFrm_reg_fondo_inicial.msk_fondoChange(Sender: TObject);
var
    ls_efectivo, ls_input, ls_output : string;
    lc_char, lc_new     : char;
    li_idx, li_ctrl      : integer;
begin
    ls_input := '';
    ls_efectivo := msk_fondo.text;
    for li_idx := 1 to length(ls_efectivo) do begin
         lc_char := ls_efectivo[li_idx];
         if  ls_efectivo[1] = ' ' then begin
            msk_fondo.Clear;
            msk_fondo.SetFocus;
            exit;
         end else
              ls_input := ls_input + lc_char;
        if not (lc_char in _CARACTERES_VALIDOS_FONDO) then begin
            for li_ctrl := 1 to length(ls_input) -1 do begin
                lc_new := ls_input[li_ctrl];
                ls_output := ls_output + lc_new;
            end;
            msk_fondo.Text := ls_output;
            msk_fondo.SelStart := length(ls_output);
        end;
    end;
end;

procedure TFrm_reg_fondo_inicial.msk_fondoKeyPress(Sender: TObject;
  var Key: Char);
begin
    if key = #13 then
      Button1Click(Sender);
end;

end.
