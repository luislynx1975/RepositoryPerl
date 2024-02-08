/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Acceso                                                        //
//  Pantalla:    Registro de usuarios                                          //
//  Descripción: //
//  Fecha:       26 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
/////////////////////////////////////////////////////////////////////////////////
unit Frm_acc_usuario;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, ExtCtrls, ActnList, ToolWin,
  lsCombobox, System.Actions, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Mask, Data.SqlExpr;


type
  TFrm_usuarios = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Ledit_login: TLabeledEdit;
    Ledit_pass: TLabeledEdit;
    Dtp_baja: TDateTimePicker;
    lsCombo_emp: TlsComboBox;
    lsCombo_grupo: TlsComboBox;
//    ZSQLProcessor1: TZSQLProcessor;
    GroupBox4: TGroupBox;
    stg_usuarios: TStringGrid;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    ac106: TAction;
    ac106a: TAction;
    ac107: TAction;
    ac150: TAction;
    acsalir: TAction;
    procedure ac106aExecute(Sender: TObject);
    procedure ac107Execute(Sender: TObject);
    procedure acSalirExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ac106Execute(Sender: TObject);
    procedure stg_usuariosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lsCombo_empClick(Sender: TObject);
    procedure lsCombo_empExit(Sender: TObject);
    procedure ac150Execute(Sender: TObject);
  private
    { Private declarations }
    procedure Titulos();
    procedure limpiar();
    function ValidaInput() : Boolean;
  public
    { Public declarations }
  end;

var
  Frm_usuarios: TFrm_usuarios;

implementation

uses DMdb, comun, u_main, Hashes;

var
    ls_qry : String;
    li_row   : integer;
    lq_query : TSQLQuery;
{$R *.dfm}

{@function ValidaInput
@Descripcion Validamos los datos de entrada que contegan valores para su insercción}
function TFrm_usuarios.ValidaInput: Boolean;
var
    lb_out : Boolean;
begin
    lb_out := true;
    if Length(lsCombo_emp.Text) = 0 then begin
       lb_out := False;
       MessageDlg(_INFORMACION_INSUFICIENTE,mtError,[mbOK],0);
       lsCombo_emp.SetFocus;
       exit;
    end;
    if Length(lsCombo_grupo.Text) = 0 then begin
       lb_out := False;
       MessageDlg(_INFORMACION_INSUFICIENTE,mtError,[mbOK],0);
       lsCombo_grupo.SetFocus;
       Exit;
    end;
{    if Length(Ledit_login.Text) = 0 then begin
       MessageDlg(_INFORMACION_INSUFICIENTE,mtError,[mbOK],0);
       Ledit_login.SetFocus;
       lb_out := False;
       Exit;
    end;}
    if Length(Ledit_pass.Text) = 0 then begin
       lb_out := False;
       MessageDlg(_INFORMACION_INSUFICIENTE,mtError,[mbOK],0);
       Ledit_pass.SetFocus;
       Exit;
    end;
    Result :=  lb_out;
end;


{@Procedure ac106aExecute
@Params Sender : TObject
@Descripcion Agregamos el registro a la base de datos}
procedure TFrm_usuarios.ac106aExecute(Sender: TObject);
var
    lq_tmp : TSQLQuery;
    ls_insert, ls_aquien : String;
    lb_ok : Boolean;
    la_datos : gga_parameters;
    li_num   : integer;
begin
    if not AccesoPermitido(106,False) then
        exit;
    lb_ok := ValidaInput;
    if lb_ok = False then exit;//validar los datos
    splitLine(lsCombo_emp.Text,'-',la_datos,li_num);
    ls_aquien := lsCombo_emp.CurrentID;
    ls_qry := Format(_qry_new_usuario, [lsCombo_emp.CurrentID , lsCombo_grupo.CurrentID ,
                      ''''+CalcHash(Ledit_pass.Text, haMD5)+'''',''''+la_datos[1]+'''']);
    if Application.MessageBox(PChar(Format(_AGREGAR_INFORMACION,[ 'De grupos ingresados '])),
                    'Atención', _CONFIRMAR) = IDYES then begin
        insertaEvento(gs_trabid,gs_terminal,'Permiso de grupo ' + lsCombo_grupo.CurrentID);
        lq_tmp := TSQLQuery.Create(nil);
        lq_tmp.SQLConnection := dm.Conecta;
        if EjecutaSQL(ls_qry,lq_query,_TODOS) then begin
            MessageDlg(_OPERACION_SATISFACTORIA,mtConfirmation,[mbOK],0);
            limpiar();
        end;//actualizar los permisos en la table pdv_c_privilegio_c_usuario
        if EjecutaSQL(Format(_qry_privilegios_usr,[lsCombo_grupo.CurrentID]),lq_query,_LOCAL) then begin
            with lq_query do begin
                First;
                while not EoF do begin
                     if EjecutaSQL(Format(_qry_insert_privilegio,[lq_query['ID_PRIVILEGIO'],lsCombo_emp.CurrentID]),lq_tmp,_TODOS) then
                        insertaEvento(gs_trabid,gs_terminal,'Guarda Permiso :' + IntToStr(lq_query['ID_PRIVILEGIO'] +
                                      ' User : ' + ls_aquien));
                  next;
                end;
            end;//insertamos en batch a la tabla pdv_c_privilegio_c_usuario
             MessageDlg(_OPERACION_SATISFACTORIA,mtInformation,[mbOK],0);
        end;
    end;
    ac106.Enabled := True;
    ac106a.Enabled := False;
    ac107.Enabled  := False;
    ac150.Enabled  := False;
    limpiar;
    Ledit_login.Text := '';
    lsCombo_emp.Enabled := true;
    lsCombo_grupo.Enabled := true;
    lsCombo_emp.SetFocus;
    FormShow(Sender);
end;


{@Procedure ac107Execute
@Params Sender
@Descripcion Actualizamos el registro seleccionado del StringGrid}
procedure TFrm_usuarios.ac107Execute(Sender: TObject);
var
    ga_datos : gga_parameters;
    li_num   : integer;
    lsNombre : string;
begin
    if not AccesoPermitido(107,False) then
        exit;
    splitLine(lsCombo_emp.Text, '-', ga_datos, li_num);
    lsNombre := ga_datos[1];
    if Ledit_login.Text = 'root' then
        ls_qry := Format(_qry_update_usuario, [lsCombo_grupo.CurrentID,''''+CalcHash2(Ledit_pass.Text,haMD5)+'''',
                    ''''+Ledit_login.Text+'''','root'])
    else
        ls_qry := Format(_qry_update_usuario, [lsCombo_grupo.CurrentID,''''+CalcHash2(Ledit_pass.Text,haMD5)+'''',
                    ''''+lsNombre+'''',lsCombo_emp.CurrentID]);
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_INFORMACION ,[ 'De usuarios ingresados '])),
                    'Atención', _CONFIRMAR) = IDYES then begin
        if EjecutaSQL(ls_qry,lq_query,_TODOS) then begin
            insertaEvento(gs_trabid,gs_terminal,'Update Grupo :' + lsCombo_grupo.CurrentID +' a quien ' +
                                      lsCombo_emp.CurrentID);
            mensaje(_OPERACION_SATISFACTORIA,2);
            ac106.Enabled := True;
            ac107.Enabled  := False;
            ac150.Enabled  := False;
            limpiar;
            lsCombo_emp.Enabled := true;
            lsCombo_grupo.Enabled := true;
            lsCombo_emp.SetFocus;
            FormShow(Sender);
        end;
    end;
end;


procedure TFrm_usuarios.ac150Execute(Sender: TObject);
begin
    if not AccesoPermitido(150,False) then
        exit;
    if Application.MessageBox(PChar(Format(_ELIMINAR_REGISTRO + #10#13 + ' La fecha de baja es correcta',[ledit_login.Text])),
                    'Atención', _CONFIRMAR) = IDYES then begin
        if EjecutaSQL(Format(_qry_user_baja_pass,[stg_usuarios.Cols[0].Strings[stg_usuarios.Row]]),lq_query,_TODOS) then begin
            ac106.Enabled := True;
            ac107.Enabled  := False;
            ac150.Enabled  := False;
            limpiar;
            lsCombo_emp.Enabled := False;
            lsCombo_grupo.Enabled := False;
            lsCombo_emp.SetFocus;
            FormShow(Sender);
        end;
    end;
end;

{@Procedure acSalirExecute
@Params Sender : TObject
@Descripcion cierra la forma}
procedure TFrm_usuarios.acSalirExecute(Sender: TObject);
begin
    Close;
end;


procedure TFrm_usuarios.FormShow(Sender: TObject);
begin
    Titulos;
    lsCombo_emp.Enabled := False;
    lsCombo_grupo.Enabled := False;
    Ledit_pass.Enabled := False;
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_qry_emp_combobox,lq_query,_LOCAL) then
          LlenarComboBox(lq_query,lsCombo_emp,True);

    if EjecutaSQL(_qry_grupos_select,lq_query,_LOCAL) then
          LlenarComboBox(lq_query,lsCombo_grupo,true);

    if EjecutaSQL(_qry_usuario,lq_query,_LOCAL) then
          LlenarStringGridAll(lq_query,stg_usuarios);
    {Tbtn_actualizar.Enabled := false;
    Tbtn_baja.Enabled       := False;}
end;



procedure TFrm_usuarios.ac106Execute(Sender: TObject);
begin
    ac106.Enabled := false;
    ac106a.Enabled := True;
    ac107.Enabled  := False;
    ac150.Enabled  := False;
    lsCombo_emp.Enabled := true;
    lsCombo_grupo.Enabled := True;
    Ledit_pass.Enabled := true;
    limpiar;
    lsCombo_emp.Enabled := true;
    lsCombo_grupo.Enabled := true;
    lsCombo_emp.SetFocus;
    if EjecutaSQL(_qry_emp_sin_permisos,lq_query,_LOCAL) then
          LlenarComboBox(lq_query,lsCombo_emp,True);
end;


procedure TFrm_usuarios.Titulos;
begin
    stg_usuarios.Cells[0,0] := 'Clave Emp';
    stg_usuarios.Cells[1,0] := 'Nombre Grupo';
    stg_usuarios.Cells[2,0] := 'Usuario';
{    stg_usuarios.Cells[3,0] := 'Fecha baja';
    stg_usuarios.Cells[4,0] := 'Ultimo Password Registrado';}
end;


procedure TFrm_usuarios.stg_usuariosSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
    ls_baja, ls_pass : String;
    li_num : integer;
    la_datos : gga_parameters;
begin
    li_row := ARow;
    if Length(stg_usuarios.Cols[0].Strings[ARow]) = 0 then
        exit;
    if EjecutaSQL(_qry_emp_combobox,lq_query,_LOCAL) then
          LlenarComboBox(lq_query,lsCombo_emp,True);

    if EjecutaSQL(_qry_grupos_select_uno+stg_usuarios.Cols[1].Strings[ARow]+'''',lq_query,_LOCAL) then
          LlenarComboBox(lq_query,lsCombo_grupo,false);

    lsCombo_emp.SetID(stg_usuarios.Cols[0].Strings[ARow]);
    lsCombo_grupo.SetItem(stg_usuarios.Cols[1].Strings[ARow]);
    Ledit_login.Text := stg_usuarios.Cols[0].Strings[ARow];
    if stg_usuarios.Cols[3].Strings[ARow] = '0000-00-00 00:00:00' then
        Dtp_baja.Date := Now();

    if Length(stg_usuarios.Cols[3].Strings[ARow]) > 0 then
        Dtp_baja.Date := StrToDate(Copy(stg_usuarios.Cols[3].Strings[ARow],9,2) + '/' +
                                   Copy(stg_usuarios.Cols[3].Strings[ARow],6,2) + '/' +
                                   Copy(stg_usuarios.Cols[3].Strings[ARow],1,4));
    ac106.Enabled := True;
    ac106a.Enabled := False;
    ac107.Enabled := True;
    ac150.Enabled := True;
    Ledit_pass.Enabled := True;
    lsCombo_emp.Enabled := false;
    lsCombo_grupo.Enabled := True;
    Dtp_baja.Enabled := true;
    lsCombo_grupo.SetFocus;
end;


procedure TFrm_usuarios.limpiar;
begin
    lsCombo_emp.Text := '';
    lsCombo_grupo.Text := '';
    Ledit_login.Clear;
    Ledit_pass.Clear;
    Dtp_baja.Date := now();
end;

procedure TFrm_usuarios.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    lq_query.Free;
    lq_query := nil;
end;


procedure TFrm_usuarios.lsCombo_empClick(Sender: TObject);
begin
    Ledit_login.Text := lsCombo_emp.CurrentID;
end;


procedure TFrm_usuarios.lsCombo_empExit(Sender: TObject);
begin
    Ledit_login.Text := lsCombo_emp.CurrentID;
end;

end.
