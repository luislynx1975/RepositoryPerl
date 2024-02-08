/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Acceso                                                        //
//  Pantalla:    Password Dialog                                               //
//  Descripción: //
//  Fecha:       29 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
/////////////////////////////////////////////////////////////////////////////////
unit frm_acc_password;
interface
{$WARNINGS OFF}
uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, lsCombobox, comun,  Dialogs , DMdb, Data.SqlExpr;

type
  TPasswordDlg = class(TForm)
    Label1: TLabel;
    Password: TEdit;
    OKBtn: TButton;
    CancelBtn: TButton;
    Label2: TLabel;
    lsCombo_login: TlsComboBox;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Frm_mainac106Execute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function  checkFecha(ld_usuario, ld_password, idx_main : Integer) : String;
    function validaEntrada(): Boolean;
  public
    { Public declarations }
  end;

var
  PasswordDlg: TPasswordDlg;
  NumeroAction : Integer;
  Bagregadual  : Boolean;


implementation

uses u_main, frm_acc_password_nuevo, U_venta, u_comun_venta, Hashes;


{$R *.dfm}

procedure TPasswordDlg.CancelBtnClick(Sender: TObject);
begin
    gb_acceptado := False;
    Close;
end;

function TPasswordDlg.validaEntrada: Boolean;
var
    lb_ok : Boolean;
    li_ctrl_bool : integer;
begin
    lb_ok := true;
    li_ctrl_bool := 0;
    if (lsCombo_login.ItemIndex = -1) and (li_ctrl_bool = 0) then begin
        Mensaje('Es necesario el login para accesar',1);
        lb_ok := false;
        li_ctrl_bool := 1;
    end;
    if (length(Password.Text) = 0) and (li_ctrl_bool = 0) then begin
        Mensaje('Ingrese el password para entrar',1);
        lb_ok := false;
        li_ctrl_bool := 2;
    end;
    Result := lb_ok;
end;


{@Procedure OKBtnClick
@Params Sender : TObject
@Descripcion buscamos los valores que tenemos almacenados en el
@ DualString dependiendo si es por grupo o usuario para mostrar o validar el proceso
@ que pretende ejecutar}
procedure TPasswordDlg.OKBtnClick(Sender: TObject);
var
    li_ctrl, li_num, li_vencida : Integer;
    la_datos : gga_parameters;
    ls_pass, ls_vencerse  : string;
    qry     : TSQLQuery;
    lfr_forma : Tfrm_pass_nuevo;
    lg_accept : Boolean;
begin
    gs_trabid := '';
    qry := TSQLQuery.Create(nil);
    qry.SQLConnection := DM.Conecta;
    li_vencida := 0;
    gb_acceptado := false;
    if not validaEntrada then begin
        exit;
    end;
    if EjecutaSQL(_qry_fecha_vencerse,qry,_LOCAL) then
        ls_vencerse := DateToStr(qry['VENCER']);

    if EjecutaSQL(format(_qry_user_privile,[lsCombo_login.Text, CalcHash2(Password.Text, haMD5),IntToStr(NumeroAction),
                         quiapo(lsCombo_login.Text), CalcHash2(Password.Text, haMD5), IntToStr(NumeroAction)]),qry,_LOCAL) then begin
        if ((qry['TRAB_ID'] = quiapo(lsCombo_login.Text)) and (qry['PASSWORD'] = CalcHash2( quiapo(Password.Text), haMD5) ) and
            (NumeroAction = qry['ID_PRIVILEGIO'])) then begin
            if StrToDate(ls_vencerse)  >= qry['FECHA_PASSWORD'] then begin
                Mensaje('Actualice la contraseña : '+ qry['TRAB_ID'],0);
                li_vencida := 1;
                gb_acceptado := false;
            end else begin
                if Bagregadual then
                     gds_actions.Add(lsCombo_login.Text,IntToStr(NumeroAction));
                 gb_acceptado := true;
                 gs_nombre_trabid := gds_user.ValueOf(qry['TRAB_ID']);
                 gs_trabid := lsCombo_login.Text;
            end;
          insertaEvento(gs_trabid,gs_terminal, 'Accede  : ' + gds_privilegio.ValueOf(IntToStr(NumeroAction)));
          lg_accept := True;
        end else begin
                insertaEvento(lsCombo_login.Text,gs_terminal, 'Fallo al acceso  : ' +
                                              Format(_PASSWORD_DENEGADO,[gds_privilegio.ValueOf(IntToStr(NumeroAction))]));
                gb_acceptado := false;
                lg_accept := False;
        end;
    end else begin
                 gb_acceptado := false;
    end;
///quitar codigo en la proxima actualizacion
    if lg_accept = false then begin
        if EjecutaSQL(format(_qry_user_privile,[lsCombo_login.Text,Password.Text,IntToStr(NumeroAction),
           quiapo(lsCombo_login.Text), quiapo(Password.Text), IntToStr(NumeroAction)]),qry,_LOCAL) then begin
            if ((qry['TRAB_ID'] = quiapo(lsCombo_login.Text)) and (qry['PASSWORD'] = quiapo(Password.Text)) and
                (NumeroAction = qry['ID_PRIVILEGIO'])) then begin
                if StrToDate(ls_vencerse)  >= qry['FECHA_PASSWORD'] then begin
                    Mensaje('Actualice la contraseña : '+ qry['TRAB_ID'],0);
                    li_vencida := 1;
                    gb_acceptado := false;
                end else begin
                    if Bagregadual then
                         gds_actions.Add(lsCombo_login.Text,IntToStr(NumeroAction));
                     gb_acceptado := true;
                     gs_nombre_trabid := gds_user.ValueOf(qry['TRAB_ID']);
                     gs_trabid := lsCombo_login.Text;
                end;
              insertaEvento(gs_trabid,gs_terminal, 'Accede  : ' + gds_privilegio.ValueOf(IntToStr(NumeroAction)));
            end else begin
                    insertaEvento(lsCombo_login.Text,gs_terminal, 'Fallo al acceso  : ' +
                                                  Format(_PASSWORD_DENEGADO,[gds_privilegio.ValueOf(IntToStr(NumeroAction))]));
                    gb_acceptado := false;
            end;
        end else begin
                     gb_acceptado := false;
        end;
    end;

    if ((gb_acceptado = false) and (li_vencida = 1)) then begin
        lfr_forma := Tfrm_pass_nuevo.Create(nil);
        lfr_forma.trabid :=  lsCombo_login.Text;
        MostrarForma(lfr_forma);
        if length(gs_trabid) = 0 then
            gs_trabid := lsCombo_login.Text;

        if li_ok_password > 0 then begin
            gb_acceptado := true;
            gs_nombre_trabid := gds_user.ValueOf(qry['TRAB_ID']);
        end;
    end;
    qry.Destroy;
end;



{@Procedure FormShow
@Params Sender : TObject
@Descripcion Muestra la forma y carga el dual string al lsComboBox esto es para
@ el grupo y el usuario}
procedure TPasswordDlg.FormShow(Sender: TObject);
var
    li_ctrl, li_num : Integer;
    la_datos : gga_parameters;
begin
    case li_msg_password of
      0 : Self.Caption := 'Ingrese usuario y contraseña';
      1 : Self.Caption := 'Validacion de la venta';
    end;

    Self.Caption := gds_privilegio.ValueOf(IntToStr(NumeroAction));

    for li_ctrl := 0 to gds_user.Count - 1 do begin
       splitLine( gds_user.Value[li_ctrl],'|',la_datos,li_num);
       lsCombo_login.Add(gds_user.ID[li_ctrl],la_datos[0]);
    end;
    li_msg_password  := 0;
end;





procedure TPasswordDlg.Frm_mainac106Execute(Sender: TObject);
begin

end;

{@function checkFecha
@Params ld_usuario, ld_password, idx_main : Integer
@Descripcion valida la fechas en base a los indices refenciados, estos verifican si
@ el password y/o usuario/grupo aun se encuentran vigentes de no ser asi mostrara mensaje de error}
function TPasswordDlg.checkFecha(ld_usuario, ld_password, idx_main : Integer): String;
var
    li_num : Integer;
    la_datos : gga_parameters;
    ls_out : String;
begin
{    splitLine(gds_dualWho.Value[idx_main],'|',la_datos,li_num);
    if(StrToDate(la_datos[ld_usuario]) < now) then
        ls_out := 'Cuenta dado de baja';

    if(StrToDate(la_datos[ld_password]) < now) then
        ls_out := 'Password, inhabilitado ';
                     }
    result := ls_out;
end;

procedure TPasswordDlg.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
//    Close;
end;

procedure TPasswordDlg.FormCreate(Sender: TObject);
begin
    KeyPreview := true;
end;

procedure TPasswordDlg.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_F4) and (ssAlt in Shift) then Key := 0;
    if key = 27 then
        key := 0;
end;

end.
