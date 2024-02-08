unit frm_cambio_password;

interface
 {$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ActnMan, ActnCtrls, ActnMenus, ActnList,
  PlatformDefaultStyleActnCtrls, StdCtrls, lsCombobox, ExtCtrls,
  System.Actions, Vcl.Mask, Data.SqlExpr;


type
  TFrm_contrasena = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lbl_passd: TLabeledEdit;
    lbledt_password1: TLabeledEdit;
    lbledt_password2: TLabeledEdit;
    ls_empleado: TlsComboBox;
    ActionManager1: TActionManager;
    acGuardar: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    acSalir: TAction;
    procedure acGuardarExecute(Sender: TObject);
    procedure acSalirExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_contrasena: TFrm_contrasena;

implementation

uses DMdb, comun, U_venta, u_main, Hashes;
var
    trabid : string;

{$R *.dfm}

procedure TFrm_contrasena.acGuardarExecute(Sender: TObject);
var
    li_ctrl_pass, li_num, li_ctrl : integer;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
    ls_trabid : string;
    ls_qry : string;
begin
  if ls_empleado.ItemIndex =  -1 then begin
      Mensaje('Elija el usuario ',1);
      ls_empleado.ItemIndex := -1;
      ls_empleado.SetFocus;
      Exit;
  end else begin
        trabid := ls_empleado.CurrentID;
  end;
  if (Length(lbledt_password1.Text) = 0) or (length(lbledt_password2.Text) = 0) then begin
      Mensaje('No se permite valores en blanco verifique los passwords',1);
      if (Length(lbledt_password1.Text) = 0) then begin
          lbledt_password1.SetFocus;
          exit;
      end;
      if (Length(lbledt_password2.Text) = 0) then begin
          lbledt_password2.SetFocus;
          exit;
      end;
  end;
  ///  que los dos sean identicos
  if lbledt_password1.Text <> lbledt_password2.Text then begin
      Mensaje('Deben de ser identicos ',1);
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lbledt_password1.SetFocus;
      exit;
  end;

  if lbl_passd.Text = lbledt_password1.Text then begin
      Mensaje('No puede ingresar el antiguo password, verifiquelo',1);
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lbledt_password1.SetFocus;
      exit;
  end;

  if length(lbledt_password1.Text) < 6 then begin
      Mensaje('El password debe de ser de mayor a 6 caracteres',1);
      lbledt_password1.Clear;
      lbledt_password2.Clear;
      lbledt_password1.SetFocus;
      exit;
  end;

  lq_qry := TSQLQuery.Create(nil);
  lq_qry.SQLConnection := DM.Conecta;
  ///primero validamos que el password anterior sea identico al existente
  ls_qry := 'SELECT PASSWORD FROM PDV_C_USUARIO WHERE TRAB_ID = ''%s'' AND PASSWORD = ''%s'' ';
  if EjecutaSQL(format(ls_qry,[trabid,CalcHash2(lbl_passd.Text, haMD5)]),lq_qry,_LOCAL) then begin
      if lq_qry.IsEmpty then begin
            ls_qry := 'SELECT PASSWORD FROM PDV_C_USUARIO WHERE TRAB_ID = ''%s'' AND PASSWORD = ''%s''';
            if EjecutaSQL(format(ls_qry,[trabid,lbl_passd.Text]),lq_qry,_LOCAL) then begin
              if lq_qry.IsEmpty then begin
                  Mensaje('La contraseña anterior no es igual a la registrada',2);
                  lbl_passd.Clear;
                  lbledt_password1.Clear;
                  lbledt_password2.Clear;
                  lbl_passd.SetFocus;
                  li_num := 0;
                  exit;
              end else li_num := 1;
            end;

       end else li_num := 1;
  end;

  li_ok_password := 0;
  if li_num = 1 then begin
      if EjecutaSQL(Format(_qry_update_pass_usuario,[CalcHash2( lbledt_password2.Text, haMD5),trabid ]),lq_qry,_TODOS) then begin
        gds_user.Destroy;
        CargarDualStrings(lq_qry);
        li_ok_password := 1;
        lbledt_password1.Clear;
        lbledt_password2.Clear;
        lbl_passd.Clear;
        ls_empleado.ItemIndex := -1;
        close;
      end;
  end;
  lq_qry.Free;
  lq_qry := nil;
end;


procedure TFrm_contrasena.acSalirExecute(Sender: TObject);
begin
    Close;
end;

procedure TFrm_contrasena.FormShow(Sender: TObject);
var
    ls_str : String;
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    try
    lq_qry.SQLConnection := DM.Conecta;
    ls_str := 'SELECT TRAB_ID, CONCAT(PATERNO,'' '',MATERNO,'' '',NOMBRES) '+
              'FROM EMPLEADOS E '+
              'WHERE STATUS = ''ACTIVO'' AND TIPO_EMPLEADO = 0 ';
    if EjecutaSQL(ls_str,lq_qry,_LOCAL) then begin
       LlenarComboBox(lq_qry,ls_empleado,true);
       ls_empleado.SetFocus;
    end;
    finally
      lq_qry.Free;
      lq_qry := nil
    end;
end;

end.
