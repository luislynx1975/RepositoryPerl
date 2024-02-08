unit ThreadRemotoTodos;

interface

uses
  Classes, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZConnection, ActiveX;

const
    TERMINAL = 'COR';
    ls_terminal = 'T';
    ls_opcion   = 'A';

type
  RemoTodos = class(TThread)
  private
    { Private declarations }
    host        : string;
    user        : string;
    pass        : string;
    serverLocal : TZConnection;
    function TodasTerminales() : TZQuery;
  protected
    procedure Execute; override;
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure RemoTodos.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ RemoTodos }

procedure RemoTodos.Execute;
var
    zqry : TZQuery;
begin
  { Place thread code here }
    CoInitialize(nil);
    try
        zqry := TZQuery.Create(nil);
        zqry.Connection := serverLocal;

    except
    end;
    CoUninitialize();
end;

function RemoTodos.TodasTerminales: TZQuery;
var
    zqry : TZQuery;
begin
    zqry := TZQuery.Create(nil);
    try
        zqry.Connection := serverLocal;
        zqry.SQL.Clear;
        zqry.SQL.Add('SELECT ID_TERMINAL,IPV4, BD_USUARIO,BD_PASSWORD ');
        zqry.SQL.Add('FROM PDV_C_TERMINAL  ');
        zqry.SQL.Add('WHERE ESTATUS = :ls_opcion AND TIPO = :ls_terminal ');
        zqry.SQL.Add('AND ID_TERMINAL <> :TERMINAL');
        zqry.Params[0].AsString := ls_opcion;
        zqry.Params[1].AsString := ls_terminal;
        zqry.Params[2].AsString := TERMINAL;
        zqry.Open;
    except
    end;
end;

end.
 