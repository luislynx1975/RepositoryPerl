unit u_fondo_inicial_nuevo;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, lsStatusBar, StdCtrls, Mask;

type
  Tfrm_fondo_nuevo = class(TForm)
    Label1: TLabel;
    msk_fondo: TMaskEdit;
    Button1: TButton;
    lsStatusBar1: TlsStatusBar;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure msk_fondoChange(Sender: TObject);
    procedure msk_fondoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_fondo_nuevo: Tfrm_fondo_nuevo;

implementation

uses u_comun_venta;

{$R *.dfm}

procedure Tfrm_fondo_nuevo.Button1Click(Sender: TObject);
begin
    if Length(msk_fondo.Text) = 0 then begin
        ShowMessage('Ingrese el fondo inicial');
        exit;
    end;
    gs_fondo_inicial_new := msk_fondo.text;
    gb_fondo_ingresado_new := true;
    Close;
end;

procedure Tfrm_fondo_nuevo.Button2Click(Sender: TObject);
begin
    gb_fondo_ingresado_new := False;
    Close;
end;

procedure Tfrm_fondo_nuevo.FormCreate(Sender: TObject);
begin
    KeyPreview := true;
end;

procedure Tfrm_fondo_nuevo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_F4) and (ssAlt in Shift) then Key := 0;
//    if (Key = 18) or (Key = 115) then Key := 0;
//    if Key = 27 then ModalResult := mrCancel;
    if key = 27 then
        key := 0;

end;


procedure Tfrm_fondo_nuevo.msk_fondoChange(Sender: TObject);
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

procedure Tfrm_fondo_nuevo.msk_fondoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_RETURN then begin
        Button1Click(Sender);
    end;
end;

end.
