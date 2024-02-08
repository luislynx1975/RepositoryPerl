/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Acceso                                                        //
//  Pantalla:    Configuracion de acceso a la Base Datos                       //
//  Descripción: //
//  Fecha:       21 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
/////////////////////////////////////////////////////////////////////////////////

unit Frm_Ini_Config;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ToolWin, ComCtrls, StdCtrls, Buttons, ActnList, IniFiles, WinSock,
  u_main, lsStatusBar, System.Actions;

type
  TFrm_Ini = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ActionList1: TActionList;
    ac99: TAction;
    ac999: TAction;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit_iplocal: TEdit;
    Edit_localidad: TEdit;
    Edit_NoClient: TEdit;
    Label4: TLabel;
    Edit_dbase: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit_user: TEdit;
    Edit_pass: TEdit;
    Edit_Server: TEdit;
    ToolButton2: TToolButton;
    lsStatusBar1: TlsStatusBar;
    ch_agencia: TCheckBox;
    Label9: TLabel;
    edt_agencia: TEdit;
    procedure ac99Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ac999Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_Ini: TFrm_Ini;

implementation

uses DMdb, comun, u_comun_base;

{$R *.dfm}





procedure TFrm_Ini.ac999Execute(Sender: TObject);
begin
    Close;
end;

procedure TFrm_Ini.ac99Execute(Sender: TObject);

var
    lfile_fileIni : TIniFile;
    ls_NameIni : String;
begin//SALEZ GUARDA LOS DATOS AL BEGIN
    if (ch_agencia.Checked) then
        if (Length(edt_agencia.Text) = 0) or (edt_agencia.Text = '' ) then begin
            Mensaje('Debe de ingresar la clave para la agencia',1);
            exit;
        end;
     if (Length(edt_agencia.Text) > 0)  then
         ch_agencia.Checked := true;
     if ch_agencia.Checked then
         creaBeginFile(Edit_iplocal.Text,Edit_localidad.Text,Edit_NoClient.Text,Edit_Server.Text,
                       '1',edt_agencia.Text);
     if not ch_agencia.Checked then
         creaBeginFile(Edit_iplocal.Text,Edit_localidad.Text,Edit_NoClient.Text,Edit_Server.Text,
                       '0',edt_agencia.Text);
     li_ctrl_conectando := 1;
     Close;
end;



procedure TFrm_Ini.FormShow(Sender: TObject);
begin
    Edit_iplocal.Text := GetIPList();
    Edit_dbase.Text := _BASE_DATOS_MERCURIO;
end;

end.
