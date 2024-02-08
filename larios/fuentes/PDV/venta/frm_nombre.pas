unit frm_nombre;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ActnList, PlatformDefaultStyleActnCtrls, ActnMan;

type
  TFrm_credencial = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    ActionManager1: TActionManager;
    acCerrar: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acCerrarExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_credencial: TFrm_credencial;

implementation

uses frm_anticipada_venta, U_venta, DMdb, u_comun_venta, comun;

{$R *.dfm}

procedure TFrm_credencial.acCerrarExecute(Sender: TObject);
begin
    close;
end;

procedure TFrm_credencial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    gs_nombre_pax :=  quiapo(Edit1.Text) + '*' + quiapo(Edit2.Text);
    gs_nombre_pax_nueva := quiapo(Edit1.Text) + '*' + quiapo(Edit2.Text);
end;

procedure TFrm_credencial.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_RETURN then begin
        Close;
    end;
end;

end.
