unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, ActnList, ComCtrls, ToolWin;

type
  TForm1 = class(TForm)
    lbl_conexion: TLabel;
    lbl_db: TLabel;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ActionList1: TActionList;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    ImageList1: TImageList;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses funcs_generals, modulo, ThreadRemotoTodos;

{$R *.dfm}

procedure TForm1.FormShow(Sender: TObject);
var
    Todos : RemoTodos;
begin
    try
        if accesoPermitido then begin
             lbl_conexion.Caption := lbl_conexion.Caption + ' conectado....';
             lbl_db.Caption       := lbl_db.Caption + ' '+ DataModulo.ZConexion.Database;
             Todos := RemoTodos.Create(true);
        end;
    except
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    desconectar();//desconectamos de labase de datos
end;

end.
