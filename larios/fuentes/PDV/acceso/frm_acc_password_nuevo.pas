unit frm_acc_password_nuevo;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ToolWin, ActnMan, ActnCtrls, ActnMenus, Data.SqlExpr,
  ActnList, PlatformDefaultStyleActnCtrls, System.Actions, Vcl.Mask;

type
  Tfrm_pass_nuevo = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lbl_passd: TLabeledEdit;
    lbledt_password1: TLabeledEdit;
    lbledt_password2: TLabeledEdit;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure lbledt_password2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbledt_password1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbl_passdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FTrabid : string;
  public
    { Public declarations }
    property trabid : string read FTrabid write FTrabid ;
  end;

var
  frm_pass_nuevo: Tfrm_pass_nuevo;

implementation

uses comun, DMdb, u_main, U_venta, Hashes;

{$R *.dfm}

var
    ls_usuario : String;

procedure Tfrm_pass_nuevo.Action1Execute(Sender: TObject);
var
    li_ctrl_pass, li_num, li_ctrl : integer;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
    ls_qry : string;
begin
  lq_qry := TSQLQuery.Create(nil);
  lq_qry.SQLConnection := DM.Conecta;

  if Length(lbl_passd.Text) = 0 then begin
      Mensaje('Ingrese el password actual',1);
      lbl_passd.SetFocus;
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lq_qry.Free;
      exit;
  end;

  ///  que los dos sean identicos
  if (length(lbledt_password1.Text) = 0) and (length(lbledt_password2.Text) = 0) then begin
      Mensaje('No se permite valores en blanco verifique los passwords',1);
      lbledt_password1.SetFocus;
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lq_qry.Free;
      exit;
  end;

  if lbledt_password1.Text <> lbledt_password2.Text then begin
      Mensaje('Deben de ser identicos ',1);
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lbledt_password1.SetFocus;
      lq_qry.Free;
      exit;
  end;

  if lbl_passd.Text = lbledt_password1.Text then begin
      Mensaje('No puede ingresar el antiguo password, verifiquelo',1);
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lbledt_password1.SetFocus;
      lq_qry.Free;
      exit;
  end;

  if length(lbledt_password1.Text) < 6 then begin
      Mensaje('El password debe de ser de mayor a 6 caracteres',1);
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lbledt_password1.SetFocus;
      lq_qry.Free;
      exit;
  end;

  if length(lbledt_password2.Text) < 6 then begin
      Mensaje('El password debe de ser de mayor a 6 caracteres',1);
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lbledt_password1.SetFocus;
      lq_qry.Free;
      exit;
  end;

  ls_qry := 'SELECT PASSWORD FROM PDV_C_USUARIO WHERE TRAB_ID = ''%s'' AND PASSWORD = ''%S''';
  if not EjecutaSQL(format(ls_qry,[trabid,lbl_passd.Text]),lq_qry,_LOCAL) then begin
      if li_num = 0 then begin
        Mensaje('La contraseña anterior no es igual a la registrada',2);
        lbl_passd.Clear;
        lbledt_password1.Clear;
        lbledt_password2.Clear;
        lbl_passd.SetFocus;
        lq_qry.Free;
        exit;
      end;
  end else li_num := 1;

  li_ok_password := 0;
  if li_num = 1 then begin
      if EjecutaSQL(Format(_qry_update_pass_usuario,
                           [CalcHash2(lbledt_password2.Text,haMD5),FTrabid]),lq_qry,_TODOS) then begin
        gds_user.Destroy;
        CargarDualStrings(lq_qry);
        li_ok_password := 1;
        close;
      end;
  end;
  lq_qry.Free;
  lq_qry := nil;
end;


procedure Tfrm_pass_nuevo.Action2Execute(Sender: TObject);
begin
    Close;
end;


procedure Tfrm_pass_nuevo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    if li_ok_password = 0 then
        trabid := '';
end;


procedure Tfrm_pass_nuevo.FormShow(Sender: TObject);
begin
    ls_usuario := 'Clave del empleado: ';
    Label1.Caption := ls_usuario + FTrabid;
end;

procedure Tfrm_pass_nuevo.lbledt_password1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if Key = VK_RETURN then
        Action1Execute(Sender);
end;

procedure Tfrm_pass_nuevo.lbledt_password2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    if Key = VK_RETURN then
        Action1Execute(Sender);
end;

procedure Tfrm_pass_nuevo.lbl_passdKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_RETURN then
        Action1Execute(Sender);
end;

end.
