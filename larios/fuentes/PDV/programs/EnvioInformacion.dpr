program EnvioInformacion;

uses
  Forms,
  main in 'main.pas' {Form1},
  modulo in 'modulo.pas' {DataModulo: TDataModule},
  funcs_generals in 'funcs_generals.pas',
  ThreadRemotoTodos in 'ThreadRemotoTodos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModulo, DataModulo);
  Application.Run;
end.
