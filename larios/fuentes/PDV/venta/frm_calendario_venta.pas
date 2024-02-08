unit frm_calendario_venta;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls;

type
  Tfrm_calendario = class(TForm)
    MonthCalendar1: TMonthCalendar;
    Label1: TLabel;
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_calendario: Tfrm_calendario;

implementation

{$R *.dfm}

procedure Tfrm_calendario.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
      if Key = VK_ESCAPE then
          Close;
end;

procedure Tfrm_calendario.FormShow(Sender: TObject);
begin
    MonthCalendar1.Date := Now();
end;

end.
