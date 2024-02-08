unit frm_nombre_credencial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, ActnList, PlatformDefaultStyleActnCtrls,
  ActnMan;

type
  Tfrm_entrada_boleto = class(TForm)
    edit_nombre: TLabeledEdit;
    edt_card: TLabeledEdit;
    ActionManager1: TActionManager;
    acCerrar: TAction;
    SpeedButton1: TSpeedButton;
    procedure edt_cardKeyPress(Sender: TObject; var Key: Char);
    procedure acCerrarExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_entrada_boleto: Tfrm_entrada_boleto;

implementation

uses U_venta, DMdb;

{$R *.dfm}

procedure Tfrm_entrada_boleto.acCerrarExecute(Sender: TObject);
begin
    close;
end;

procedure Tfrm_entrada_boleto.edt_cardKeyPress(Sender: TObject;
  var Key: Char);
begin
    gs_nombre_pax := edit_nombre.Text +'.'+ edt_card.Text;
end;

end.
