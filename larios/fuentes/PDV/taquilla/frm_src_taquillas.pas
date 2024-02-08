unit frm_src_taquillas;

interface
{$WARNINGS OFF}
{$HINTS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, StdCtrls, ComCtrls, lsCombobox,IniFiles, Printers, System.Actions,
  Data.SqlExpr;

type
  Tfrm_taquilla = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    acSalir: TAction;
    Action1: TAction;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    edt_terminal: TEdit;
    Label2: TLabel;
    edt_taquilla: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cmb_ips: TlsComboBox;
    cmb_imp_boleto: TlsComboBox;
    cmb_imp_opcional: TlsComboBox;
    Label6: TLabel;
    cmb_tarjeta: TlsComboBox;
    Label7: TLabel;
    cmb_apagado: TlsComboBox;
    Label8: TLabel;
    cmb_carga: TlsComboBox;
    DTP_apagado: TDateTimePicker;
    Label9: TLabel;
    edt_iplocal: TEdit;
    Label11: TLabel;
    cbx_Remota: TlsComboBox;
    Label12: TLabel;
    cmb_tamano: TlsComboBox;
    Cb_masiva: TCheckBox;
    cmb_name_printer: TlsComboBox;
    cmb_printer_gral: TlsComboBox;
    cb_conexion: TCheckBox;
    chk_continuo: TCheckBox;
    procedure acSalirExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cmb_ipsClick(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure edt_taquillaKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure inicializar();
    procedure llenarCombos();
    procedure limpiarDatos();
    function validaDatos() : Boolean;
  public
    { Public declarations }
  end;

var
  frm_taquilla: Tfrm_taquilla;

implementation

uses DMdb, comun, u_comun_venta;

{$R *.dfm}


procedure Tfrm_taquilla.acSalirExecute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_taquilla.Action1Execute(Sender: TObject);
var
    li_boleto, li_opcional, li_masivo, li_central: integer;
    ls_ip, ls_NameIni, ls_continuo : string;
    Query : TSQLQuery;
    lfile_fileIni : TIniFile;
begin
    if not validaDatos then
        exit;
    ls_ip := FormatDateTime('HH:MM:SS',DTP_apagado.Time);
    Query := TSQLQuery.Create(nil);
    Query.SQLConnection := DM.Conecta;
    ls_ip := copy(TimeToStr(DTP_apagado.Time),1, Length(TimeToStr(DTP_apagado.Time))-4);
    if Cb_masiva.Checked then
        li_masivo := 1 else li_masivo := 0;

    if cb_conexion.Checked then
        li_central := 1 else li_central := 0;

    if chk_continuo.Enabled  then
        ls_continuo := '1' else ls_continuo := '0';

    if (cmb_ips.CurrentID = edt_iplocal.Text) and (gs_maquina  <> edt_taquilla.Text) then begin
        Mensaje('El numero de taquilla o maquina no es identico a la '+#10+#13+
                'configuracion registrada, se actualizara y'+#10+#13+
                'se registrará con el número de maquina : '+edt_taquilla.Text,2);
        creaBeginFile(edt_iplocal.Text,edt_terminal.Text,edt_taquilla.Text,gs_server,gs_agencia,gs_agencia_clave);
    end;
    if EjecutaSQL(Format(_BORRA_TODAS_IPIGUAL,[cmb_ips.CurrentID, edt_terminal.Text]),Query,_LOCAL) then
        ;


    if EjecutaSQL(format(_INSERT_TAQUILLA_FIJA,[edt_terminal.Text,edt_taquilla.Text,cmb_ips.CurrentID,
                          cmb_imp_boleto.CurrentID, cmb_imp_opcional.CurrentID, cmb_tarjeta.CurrentID,
                          cmb_apagado.CurrentID, cmb_carga.CurrentID, FormatDateTime('HH:mm:ss',DTP_apagado.Time),
                          '0',//cmb_imp_puerto.CurrentID,
                          '0',//cmb_opc_puerto.CurrentID,
                          cbx_Remota.CurrentID, cmb_tamano.CurrentID, intToStr(li_masivo),
                          cmb_name_printer.Text, cmb_printer_gral.Text, intToStr(li_central),
                          FloatToStr(_VERSION), ls_continuo
                          ]),Query,_LOCAL) then begin
        Mensaje('La información de la taquilla se actualizo correctamente',3);
        limpiarDatos();
        inicializar;
        llenarCombos;
    end;
    Query.Free;
    Query := NIL;
end;

function Tfrm_taquilla.validaDatos: Boolean;
var
    lb_ok : Boolean;
begin
    lb_ok := true;
    if cmb_ips.ItemIndex = -1 then begin
        Mensaje('Seleccione para la actualizacion',1);
        cmb_ips.SetFocus;
        lb_ok := False;
        exit;
    end;
{    if cmb_imp_boleto.ItemIndex = -1 then begin
        Mensaje('Seleccione la impresora de boleto',1);
        cmb_imp_boleto.SetFocus;
        lb_ok := False;
        Exit;
    end;
    if cmb_imp_opcional.ItemIndex = -1 then begin
        Mensaje('Seleccion la impresora',1);
        cmb_imp_opcional.SetFocus;
        lb_ok := False;
        exit;
    end;}
    if cbx_Remota.ItemIndex = -1 then begin
        Mensaje('Seleccion el acceso remoto o no?',1);
        cbx_Remota.SetFocus;
        lb_ok := False;
        exit;
    end;

    if cmb_tamano.ItemIndex = -1  then begin
        Mensaje('Seleccione el tipo de boleto para la venta de boletos',1);
        cmb_tamano.SetFocus;
        lb_ok := False;
        Exit;
    end;
    if cmb_name_printer.ItemIndex = -1 then begin
        Mensaje('Seleccione el nombre de la impresora boletos',1);
        cmb_name_printer.SetFocus;
        lb_ok := False;
        exit;
    end;
    if cmb_printer_gral.ItemIndex = -1 then begin
        Mensaje('Seleccione el nombre de la impresora general',1);
        cmb_printer_gral.SetFocus;
        lb_ok := False;
        exit;
    end;

    Result := lb_ok;
end;


procedure Tfrm_taquilla.cmb_ipsClick(Sender: TObject);
var
    Query : TSQLQuery;
begin
    Query := TSQLQuery.Create(nil);
    Query.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_CONSIGE_TAQUILLA,[cmb_ips.CurrentID,edt_terminal.Text]),Query, _LOCAL) then begin
        edt_taquilla.Text := IntToStr(Query['ID_TAQUILLA']);
        cmb_imp_boleto.ItemIndex := cmb_imp_boleto.IDs.IndexOf(Query['IMP_BOLETO']);
        cmb_imp_opcional.ItemIndex := cmb_imp_opcional.IDs.IndexOf(Query['IMP_OPCIONAL']);
        cmb_tarjeta.ItemIndex := cmb_tarjeta.IDs.IndexOf(Query['TARJETA_FISICA']);
        cmb_apagado.ItemIndex := cmb_apagado.IDs.IndexOf(Query['APAGADO']);
        cmb_carga.ItemIndex   := cmb_carga.IDs.IndexOf(Query['CARGA_FINAL']);
        cmb_tamano.ItemIndex := cmb_tamano.IDs.IndexOf(Query['BOLETO']);
        cbx_Remota.ItemIndex := cbx_Remota.IDs.IndexOf(Query['OPERACION_REMOTA']);
        DTP_apagado.DateTime := StrToTime(Query['TIEMPO_APAGADO']);
    end;
    Query.Free;
    Query := nil;
end;

procedure Tfrm_taquilla.edt_taquillaKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9',#8, #13]) then
           Key := #0;
end;

procedure Tfrm_taquilla.FormShow(Sender: TObject);
begin
    DTP_apagado.Format := 'HH:mm:ss';
    inicializar;
    llenarCombos;
end;

procedure Tfrm_taquilla.inicializar;
var
    Query : TSQLQuery;
begin
    Query := TSQLQuery.Create(nil);
    Query.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_MUESTRA_IPS,[gs_terminal]),Query, _LOCAL) then
        LlenarComboBox(Query,cmb_ips,false);
    Query.Free;
    Query := nil;
    edt_terminal.Text := gs_terminal;
    edt_iplocal.Text := GetIPList;
end;

procedure Tfrm_taquilla.limpiarDatos;
begin
//    edt_terminal.Clear;
    cmb_ips.clear;
    cmb_imp_boleto.clear;
    cmb_imp_opcional.clear;
    cmb_tarjeta.clear;
    edt_taquilla.Clear;
    cmb_apagado.clear;
    cmb_carga.clear;
    cmb_ips.ItemIndex := -1;
    cmb_imp_boleto.ItemIndex := -1;
    cmb_imp_opcional.ItemIndex := -1;
    cmb_tarjeta.ItemIndex := -1;
    cmb_apagado.ItemIndex := -1;
    cmb_carga.ItemIndex := -1;
    cbx_remota.ItemIndex := -1;
    cmb_tamano.ItemIndex := -1;
    Cb_masiva.Checked := False;
    cb_conexion.Checked := False;
    chk_continuo.Checked := False;
end;

procedure Tfrm_taquilla.llenarCombos;
    var
    Query : TSQLQuery;
begin

    cmb_imp_boleto.Add('Toshiba TEC','0');
    cmb_imp_boleto.Add('Mini OPOS','3');

    cmb_imp_opcional.Add('Windows default','0');
    cmb_imp_opcional.Add('Mini OPOS','3');

    cmb_tarjeta.Add('No','0');
    cmb_tarjeta.Add('Si','1');

    cmb_apagado.Add('No','0');
    cmb_apagado.Add('Si','1');

    cmb_carga.Add('No','0');
    cmb_carga.Add('Si','1');
    cmb_name_printer.Items.Assign(Printer.Printers);

    cmb_printer_gral.Items.Assign(Printer.Printers);

    cbx_Remota.Add('Si','1');
    cbx_Remota.Add('No','0');

    cmb_tamano.Add('14.3 cm', '0');
    cmb_tamano.Add('10.1 cm', '1');
end;


end.
