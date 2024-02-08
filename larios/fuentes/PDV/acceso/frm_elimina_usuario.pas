unit frm_elimina_usuario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, Data.SqlExpr, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ActnMenus,
  ComCtrls, System.Actions;

type
  Tfrm_usuario_baja = class(TForm)
    Label1: TLabel;
    cmb_users: TlsComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edt_status: TEdit;
    edt_paterno: TEdit;
    edt_materno: TEdit;
    edt_nombre: TEdit;
    Label6: TLabel;
    edt_trabid: TEdit;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    StatusBar1: TStatusBar;
    cb_todas: TCheckBox;
    cbEstatus: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure cmb_usersClick(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    { Private declarations }
    procedure limpiar();
  public
    { Public declarations }
  end;

var
  frm_usuario_baja: Tfrm_usuario_baja;

implementation

uses DMdb, comun, u_main;

{$R *.dfm}

procedure Tfrm_usuario_baja.Action1Execute(Sender: TObject);
const
  _SERVER_QUERY_LCL = 'INSERT INTO PDV_T_QUERY(ID_TERMINAL,SENTENCIA,FECHA_HORA) VALUES( ''%s'', ''%s'', now())';
var
    lq_qry, lq_qry_q : TSQLQuery;
    ls_qry : String;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    lq_qry_q := TSQLQuery.Create(nil);
    lq_qry_q.SQLConnection := DM.Conecta;
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_EMPLEADO,[ edt_trabid.Text])), 'Atención', _CONFIRMAR) = IDYES then begin
        if cb_todas.Checked then begin
            if EjecutaSQL(_TERMINAL_BAJA,lq_qry_q,_LOCAL) then begin
                lq_qry_q.First;
                while not lq_qry_q.Eof do begin
                     if cbEstatus.checked then
                         ls_qry := format(_USER_BAJA_USER,[edt_trabid.Text])
                     else
                         ls_qry := format(_USER_ALTA_USER,[edt_trabid.Text]);

                     if EjecutaSQL( format(_SERVER_QUERY_LCL,[lq_qry_q['ID_TERMINAL'],ls_qry]),lq_qry,_LOCAL) then
                          ;
                     lq_qry_q.Next;
                end;
                if EjecutaSQL(ls_qry,lq_qry_q,_LOCAL) then
                    ;
                Mensaje('Se ha actualizado el usuario '+edt_trabid.Text+ ' en todas las bases de datos',2);
                limpiar();
                FormShow(Sender);
            end;//fin if
        end else begin
                    if EjecutaSQL(format(_USER_BAJA_USER,[edt_trabid.Text]),lq_qry,_LOCAL) then begin
                        Mensaje('Se ha actualizado el usuario '+edt_trabid.Text,2);
                        limpiar();
                        FormShow(Sender);
                    end;
        end;
    end;
    lq_qry.Free;
    lq_qry := nil;

    lq_qry_q.Free;
    lq_qry_q := nil;
end;

procedure Tfrm_usuario_baja.Action2Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_usuario_baja.cmb_usersClick(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_USER_BUSCA_DATOS,[cmb_users.CurrentID]),lq_qry,_LOCAL) then begin
         edt_status.Text := lq_qry['STATUS'];
         edt_paterno.Text := lq_qry['PATERNO'];
         edt_materno.Text := lq_qry['MATERNO'];
         edt_nombre.Text := lq_qry['NOMBRES'];
         edt_trabid.Text := lq_qry['TRAB_ID'];
    end;
    lq_qry.Free;
    lq_qry := nil;
end;

procedure Tfrm_usuario_baja.FormShow(Sender: TObject);
const
    _users = 'SELECT E.TRAB_ID, CONCAT(PATERNO,'' '',MATERNO,'' '',NOMBRES), U.FECHA_BAJA '+
             'FROM PDV_C_USUARIO U INNER JOIN EMPLEADOS E ON U.TRAB_ID = E.TRAB_ID '+
             'WHERE U.FECHA_BAJA IS NULL ORDER BY 2';
var
    lq_qry : TSQLQuery;

begin
    cmb_users.Clear;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_users,lq_qry,_LOCAL) then
        LlenarComboBox(lq_qry,cmb_users,true);
    lq_qry.Free;
    lq_qry := nil;

end;


procedure Tfrm_usuario_baja.limpiar;
begin
    edt_status.Clear;
    edt_paterno.Clear;
    edt_materno.Clear;
    edt_nombre.Clear;
    edt_trabid.Clear;
end;

end.
