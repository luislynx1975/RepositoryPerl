unit frmMenuTarifas;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmMenuTarifa = class(TForm)
    btnConsultas: TBitBtn;
    btnAlta: TBitBtn;
    BitBtn3: TBitBtn;
    btnImportar: TBitBtn;
    BitBtn1: TBitBtn;
    procedure BitBtn3Click(Sender: TObject);
    procedure btnConsultasClick(Sender: TObject);
    procedure btnAltaClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMenuTarifa: TfrmMenuTarifa;

implementation

uses frmATarifa, frmCTarifas, comun, comunii, frmImportaTarifa,
  frmModificacionTarifas;

{$R *.dfm}

procedure TfrmMenuTarifa.btnImportarClick(Sender: TObject);
begin
    if not AccesoPermitido(190, _NO_RECUERDA_TAGS) then
        Exit;
   try
        importaTarifas := TimportaTarifas.Create(Self);
        importaTarifas.ShowModal;
    finally
        importaTarifas.Free;
        importaTarifas := nil;
    end;

end;

procedure TfrmMenuTarifa.BitBtn1Click(Sender: TObject);
begin
   if not AccesoPermitido(190, _NO_RECUERDA_TAGS) then
        Exit;
   try
        frmModificaTarifa:= TfrmModificaTarifa.Create(self);
        frmModificaTarifa.ShowModal;
    finally
        frmModificaTarifa.Free;
        frmModificaTarifa := nil;
    end;
end;

procedure TfrmMenuTarifa.BitBtn3Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmMenuTarifa.btnAltaClick(Sender: TObject);
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

procedure TfrmMenuTarifa.btnConsultasClick(Sender: TObject);
var forma : Tform;
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

end.
