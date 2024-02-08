unit frm_lectorBarras;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons;

type
  Tfrm_lector = class(TForm)
    SpeedButton1: TSpeedButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_lector: Tfrm_lector;

implementation

{$R *.dfm}

procedure Tfrm_lector.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_F4) and (ssAlt in Shift) then
      Key := 0;
end;

procedure Tfrm_lector.SpeedButton1Click(Sender: TObject);
begin
    close;
end;

end.
