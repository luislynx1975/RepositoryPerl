unit frmMenuTarifas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ActnList, PlatformDefaultStyleActnCtrls, ActnMan,
  ImgList;

type
  TfrmMenuTarifa = class(TForm)
    btnConsultas: TBitBtn;
    btnAlta: TBitBtn;
    BitBtn3: TBitBtn;
    am: TActionManager;
    act127: TAction;
    act190: TAction;
    img_iconos: TImageList;
    Action1: TAction;
    procedure BitBtn3Click(Sender: TObject);
    procedure act127Execute(Sender: TObject);
    procedure act190Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMenuTarifa: TfrmMenuTarifa;
  forma : Tform;
implementation

uses frmATarifa, frmCTarifas, comun, comunii, DMdb;

{$R *.dfm}

procedure TfrmMenuTarifa.act127Execute(Sender: TObject);
begin
if not AccesoPermitido(TButton(Sender).Tag, _NO_RECUERDA_TAGS) then
        Exit;
   try
        forma := TfrmCTarifa.Create(self);
        forma.ShowModal;
    finally
        forma.Free;
        forma := nil;
    end;
end;

procedure TfrmMenuTarifa.act190Execute(Sender: TObject);
begin
   if not AccesoPermitido(TButton(Sender).Tag, _NO_RECUERDA_TAGS) then
        Exit;
   try
        frmATarifas := TfrmATarifas.Create(Self);
        frmATarifas.ShowModal;
   finally
        frmATarifas.Free;
        frmATarifas := nil;
   end;
end;

procedure TfrmMenuTarifa.Action1Execute(Sender: TObject);
begin
   Close;
end;

procedure TfrmMenuTarifa.BitBtn3Click(Sender: TObject);
begin
   Close;
end;

end.
