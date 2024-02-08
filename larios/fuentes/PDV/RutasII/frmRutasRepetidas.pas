unit frmRutasRepetidas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TfrmRutaRepetida = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    edtOrigen: TEdit;
    edtDestino: TEdit;
    btnClose: TButton;
    sagRutas: TStringGrid;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRutaRepetida: TfrmRutaRepetida;

implementation

{$R *.dfm}

procedure TfrmRutaRepetida.btnCloseClick(Sender: TObject);
begin
   Close;
end;

end.
