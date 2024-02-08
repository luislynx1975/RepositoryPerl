/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Acceso                                                        //
//  Pantalla:    Sistema para el Punto De Venta                                //
//  Descripción: //
//  Fecha:       16 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
//  version:  1.00 version prototipo para pruebas en la venta 24-08-2010
/////////////////////////////////////////////////////////////////////////////////
unit frm_pdv_main;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IniFiles, StdCtrls, Grids, DBGrids,
  ComCtrls, ToolWin, Menus, ActnList, ExtCtrls, comun, Frm_vta_reservacion,
  frm_reservacion_vender, Frm_cancela_boletos,
  Frm_cancela_reservacion, U_acceso, frm_guias_despacho, frm_vta_libera_corrida,
  ActnMan, ActnCtrls, ActnMenus, RibbonActnMenus, Ribbon,
  RibbonLunaStyleActnCtrls, Buttons, ScreenTips, lsCombobox, FMTBcd, Data.SqlExpr,
  SimpleDS, ShellApi, IdBaseComponent, IdComponent, IdRawBase, IdRawClient,
  IdIcmpClient, Winsock, IdTCPConnection, IdTCPClient, ActiveX, System.Win.ComObj,
  System.Actions;
//  pBarcode1D, pCode93;

type
  TFrm_main = class(TForm)
    com: TActionManager;
    Ribbon1: TRibbon;
    ac99: TAction;
    RibbonApplicationMenuBar1: TRibbonApplicationMenuBar;
    ac100: TAction;
    ac103: TAction;
    ac105: TAction;
    ac106: TAction;
    ac108: TAction;
    ac112: TAction;
    ac116: TAction;
    ac120: TAction;
    ac158: TAction;
    RibbonPage1: TRibbonPage;
    RibbonPage2: TRibbonPage;
    RibbonPage3: TRibbonPage;
    RibbonGroup4: TRibbonGroup;
    RibbonGroup5: TRibbonGroup;
    acGenerarcorridas: TAction;
    acItinerario: TAction;
    acExtras: TAction;
    RibbonGroup1: TRibbonGroup;
    RibbonGroup2: TRibbonGroup;
    RibbonPage4: TRibbonPage;
    RibbonGroup6: TRibbonGroup;
    actarjetaViaje: TAction;
    RibbonPage5: TRibbonPage;
    RibbonGroup3: TRibbonGroup;
    Action1: TAction;
    Action2: TAction;
    acBoleto: TAction;
    acCnlReservacion: TAction;
    RibbonGroup8: TRibbonGroup;
    RibbonGroup9: TRibbonGroup;
    RibbonPage6: TRibbonPage;
    RibbonGroup11: TRibbonGroup;
    act161: TAction;
    act162: TAction;
    act163: TAction;
    RibbonGroup12: TRibbonGroup;
    act126: TAction;
    act125: TAction;
    RibbonGroup13: TRibbonGroup;
    act164: TAction;
    act127: TAction;
    ScreenTipsManager1: TScreenTipsManager;
    Action3: TAction;
    acVacacional: TAction;
    act186: TAction;
    Action4: TAction;
    RibbonGroup10: TRibbonGroup;
    act146: TAction;
    act147: TAction;
    Action5: TAction;
    Action6: TAction;
    acApagar: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    act195: TAction;
    ac200: TAction;
    lbl_Hora: TLabel;
    acPrecorte: TAction;
    Timer1: TTimer;
    RibbonGroup14: TRibbonGroup;
    Act208: TAction;
    acBars: TAction;
    RibbonGroup7: TRibbonGroup;
    act214: TAction;
    act214_: TAction;
    RibbonGroup15: TRibbonGroup;
    act216: TAction;
    Action11: TAction;
    act219: TAction;
    Action12: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ac100Execute(Sender: TObject);
    procedure ac103Execute(Sender: TObject);
    procedure ac105Execute(Sender: TObject);
    procedure acSAlirExecute(Sender: TObject);
    procedure ac108Execute(Sender: TObject);
    procedure ac112Execute(Sender: TObject);
    procedure ac106Execute(Sender: TObject);
    procedure ac120Execute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Ventapublico1Click(Sender: TObject);
    procedure Reservaciones1Click(Sender: TObject);
    procedure Cancelaciones1Click(Sender: TObject);
    procedure Boletos1Click(Sender: TObject);
    procedure Reservaciones2Click(Sender: TObject);
    procedure Despachar1Click(Sender: TObject);
    procedure ac158Execute(Sender: TObject);
    procedure ac99Execute(Sender: TObject);
    procedure acGenerarcorridasExecute(Sender: TObject);
    procedure acItinerarioExecute(Sender: TObject);
    procedure acExtrasExecute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure acCnlReservacionExecute(Sender: TObject);
    procedure acBoletoExecute(Sender: TObject);
    procedure actarjetaViajeExecute(Sender: TObject);
    procedure act161Execute(Sender: TObject);
    procedure act162Execute(Sender: TObject);
    procedure act163Execute(Sender: TObject);
    procedure act125Execute(Sender: TObject);
    procedure act126Execute(Sender: TObject);
    procedure act164Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure act186Execute(Sender: TObject);
    procedure acVacacionalExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Action4Execute(Sender: TObject);
    procedure act146Execute(Sender: TObject);
    procedure act147Execute(Sender: TObject);
    procedure act127Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action7Execute(Sender: TObject);
    procedure Action8Execute(Sender: TObject);
    procedure Action9Execute(Sender: TObject);
    procedure act195Execute(Sender: TObject);
    procedure ac200Execute(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ac203Execute(Sender: TObject);
    procedure acPrecorteExecute(Sender: TObject);
    procedure Act208Execute(Sender: TObject);
    procedure acBarsExecute(Sender: TObject);
    procedure act214Execute(Sender: TObject);
    procedure act214_Execute(Sender: TObject);
    procedure act216Execute(Sender: TObject);
    procedure Action11Execute(Sender: TObject);
    procedure act219Execute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Action12Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    // li_hora, li_minuto, li_segundo : Integer;
    hora_servidor : TDateTime;
  end;

var
  Frm_main: TFrm_main;

implementation

uses Frm_Ini_Config,  Frm_acc_grupos, Frm_acc_usuario,
  Frm_grp_permiso, DMdb, Frm_splash, frm_acc_password, u_main,
  frm_bus_autobus, Frm_vta_main, frm_cat_configuracion,  frm_iti_ocupante,
  Asiento, U_venta, corridas, frm_iti_itinerario, extras, comunii, frmCorte,
  frmCtramos, frmCrutas, frmFaltantesYSobrantes,
  frm_vta_status_corrida, Frm_vta_reservacion1, frm_venta_anticipada,
  frm_periodo_vacacional, frmAdministracionCortes, ThreadRutas,
  frm_cambio_password, frmCorteFinDeDia, frmCorteTipoServicio,
  Printers, Winspool, frmMenuTarifas, u_venta_nueva, frm_historico_venta,
  e_reporte, frm_cancela_reservacion_new, frmUsuarios, frm_agencia,
  frm_visualiza_corridas, frmCRutaII, frmCTerminales, u_pax_corrida,
  frm_src_taquillas, frm_elimina_usuario, frmPrecorte, u_cobro_banamex,
  u_impresion, frmModificacionRemotaGuias, frm_codigoBars, frmAsignacionFondo,
  frmReportePrivilegios, frmImportesAlertas, frm_pinpad_banamex_cancelar,
  updateCorridasRemotas, uLitteScreen;

var
    Fpassword : TPasswordDlg;
    li_ctrl   : Integer;
    ls_hora_apagado : string;
    gli_valida_apagado : integer;
{$R *.dfm}


procedure TFrm_main.FormShow(Sender: TObject);
var
     lfile_ini  : TIniFile;
     frm_ini    : TFrm_Ini;//nombre la forma
     ls_NameIni : String;
     ls_cadena : string;
     lq_qry1   : TSQLQuery;
     ga_datos : gga_parameters;
     li_num : integer;
     ar_version : array[0..10]of char;
begin

  gs_version := FloatToStr(_VERSION);
   try
      li_msg_password := 0;
      if li_ctrl_conectando = 1 then begin
          lq_qry1 := TSQLQuery.Create(nil);
          lq_qry1.SQLConnection := CONEXION_VTA;
          splitLine(gs_server,'.',ga_datos, li_num);
//para el sistema de apagado del equipo
          ls_cadena := 'SELECT DESCRIPCION FROM T_C_TERMINAL WHERE ID_TERMINAL = '+ QuotedStr(gs_terminal);
          if (comunii.EmpresaTerminal(gs_terminal)  = 'TER') then  begin
                act163.Visible := True;
                act163.Enabled := True;
          end else begin
                act163.Visible := False;
                act163.Enabled := False;
          end;

          if li_ctrl_conectando = 1 then begin
              if EjecutaSQL(ls_cadena,lq_qry1, _LOCAL) then begin
                  Ribbon1.Caption := 'Conectado a :' + lq_qry1['DESCRIPCION'] + ' ' + FloatToStr(_VERSION)+ '-'+
                                     ga_datos[2] +'.'+ga_datos[3];
              end;
          end;

          if StrToInt(gs_agencia) = 1 then begin
            if EjecutaSQL(format(_OBTIENE_ASIENTO_AGENCIA,[gs_agencia_clave]),lq_qry1,_LOCAL) then begin
                gi_inicial_agencia := lq_qry1['ASIENTO_INICIAL'];
                gi_final_agencia   := lq_qry1['ASIENTO_FINAL'];
            end else begin
                        gi_inicial_agencia := 0;
                        gi_final_agencia   := 0;
            end;
          end;
          lq_qry1.Free;
          lq_qry1 := nil;
          exit;
      end;
   except
        Mensaje('Error en la homoclave de la terminal no existe en la tabla PDV_C_TERMINAL',1);
        Application.Terminate;
   end;

end;



procedure TFrm_main.Reservaciones1Click(Sender: TObject);
var
    lfrm_forma : tFrm_reservacion;
begin
    lfrm_forma := TFrm_reservacion.Create(self);
    MostrarForma(lfrm_forma);
end;


procedure TFrm_main.Reservaciones2Click(Sender: TObject);
var
    frm : TFrm_reserva_cancela;
begin
    frm := TFrm_reserva_cancela.Create(Self);
    MostrarForma(frm);
end;


procedure TFrm_main.Timer1Timer(Sender: TObject);
var
    ls_hora_actual : String;
begin
 hora_servidor := hora_servidor + (1/24/60/60);
// lbl_Hora.Caption := getHora();
// lbl_Hora.Caption := FormatDateTime('hh:nn:ss', hora_servidor);
{
    inc(li_segundo);
    if li_segundo = 60 then begin
      li_segundo := 0;
      li_minuto:= li_minuto +1;
    end;

    if li_minuto = 60 then begin
      li_minuto:= 0;
      li_hora := li_hora + 1;
    end;
    if li_hora = 24 then
        li_hora := 0;

    lbl_Hora.Caption := FormatFloat('00',li_hora)+':'+FormatFloat('00',li_minuto)+':'+FormatFloat('00',li_segundo);
    ls_hora_actual := lbl_Hora.Caption;
    if ls_hora_apagado <> '' then
        if StrToTime(ls_hora_apagado) = StrToTime(ls_hora_actual) then
            if gli_valida_apagado = 1 then
               apagarElEquipo;
 }
end;


procedure TFrm_main.Ventapublico1Click(Sender: TObject);
var
    lfrm_forma : TFrm_venta_principal;
begin
    lfrm_forma := TFrm_venta_principal.Create(Self);
    MostrarForma(lfrm_forma);
end;


procedure TFrm_main.FormActivate(Sender: TObject);
var
    lq_qry1 : TSQLQuery;
begin
    if length(gs_terminal) > 1 then begin

        try
            lq_qry1 := TSQLQuery.Create(nil);
            lq_qry1.SQLConnection := DM.Conecta;

    {    if EjecutaSQL('SELECT CURTIME() AS HORA_SERVIDOR;',lq_qry1, _LOCAL) then begin
            hora_servidor :=  lq_qry1['HORA_SERVIDOR'];
        end;}

        {
        if EjecutaSQL('SELECT (EXTRACT(HOUR FROM CURTIME()))AS HORA,(EXTRACT(MINUTE FROM CURTIME())) AS MINUTO, '+
                      '(EXTRACT(SECOND FROM CURTIME()))AS SEGUNDO;',lq_qry1, _LOCAL) then begin
            lbl_Hora.Caption := IntToStr(lq_qry1['HORA'])+':'+IntToStr(lq_qry1['MINUTO'])+':'+IntToStr(lq_qry1['SEGUNDO']);
            li_hora := lq_qry1['HORA'];
            li_minuto := lq_qry1['MINUTO'];
            li_segundo := lq_qry1['SEGUNDO'];
        end;
        }

            if EjecutaSQL(Format(_VALIDA_PARA_APAGAR,[gs_terminal,gs_maquina,gs_local]),lq_qry1,_LOCAL) then
                if VarIsNull(lq_qry1['APAGADO']) then
                    gli_valida_apagado := 0
                else
                    gli_valida_apagado := lq_qry1['APAGADO'];

            if EjecutaSQL(FORMAT(_OBTIENE_HORA_APAGADO,[gs_terminal,gs_maquina,gs_local]),lq_qry1,_LOCAL) then
                if VarIsNull(lq_qry1['TIEMPO_APAGADO']) then
                    ls_hora_apagado := '00:00:00'
                else
                    ls_hora_apagado := lq_qry1['TIEMPO_APAGADO'];

            lq_qry1.Free;
            lq_qry1 := nil;
        except
            lq_qry1.Free;
            lq_qry1 := nil;
        end;
    end;
end;


procedure TFrm_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    DM.desconectaServer();
    if Assigned(pantalla) then
        pantalla.Destroy;
end;


procedure TFrm_main.FormCreate(Sender: TObject);
begin
    Ribbon1.Caption := 'version '+ FloatToStr(_VERSION);
    FormatSettings.ShortTimeFormat := 'HH:MM:SS';
    li_ctrl := 0;
    FormShow(Sender);
    gds_actions := TDualStrings.Create;
end;


procedure TFrm_main.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_F4) and (ssAlt in Shift) then Key := 0;
end;


procedure TFrm_main.acSAlirExecute(Sender: TObject);
begin
    Application.Terminate;
end;


procedure TFrm_main.act125Execute(Sender: TObject);
begin
   if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   try
        comunii.tipoVentanaTramos:= comunii._TIPO_VACIO;
        frmTramos := TfrmTramos.Create(Self);
        frmTramos.ShowModal;
   finally
       frmTramos.Free;
       frmTramos := nil
   end;
end;


procedure TFrm_main.act126Execute(Sender: TObject);
begin
       if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   try
        comunii.tipoVentanaTramos:= comunii._TIPO_VACIO;
        frmCRutasII := TfrmCRutasII.Create(Self);
        frmCRutasII.ShowModal;
   finally
        frmCRutasII.Free;
        frmCRutasII := nil;
   end;
end;


procedure TFrm_main.act127Execute(Sender: TObject);
 var forma : TForm;
begin
   try
        forma:= TfrmMenuTarifa.Create(self);
        forma.ShowModal;
   finally
        forma.Free;
        forma := nil;
   end;
end;


procedure TFrm_main.act146Execute(Sender: TObject);
begin
    if not AccesoPermitido(tAction(Sender).Tag,_RECUERDA_TAGS) then
      Exit;
   try

     frmCorteFinDia:= tfrmCorteFinDia.Create(Self);
     frmCorteFinDia.ShowModal;
   finally
     frmCorteFinDia.Free;
     frmCorteFinDia := nil;
   end;
end;


procedure TFrm_main.act147Execute(Sender: TObject);
begin
   if not AccesoPermitido(tAction(Sender).Tag, _RECUERDA_TAGS) then
      Exit;
   try

     frmCorteServicio:= tfrmCorteServicio.Create(Self);
     frmCorteServicio.ShowModal;
   finally
     frmCorteServicio.Free;
     frmCorteServicio := nil;
   end;
end;


procedure TFrm_main.act161Execute(Sender: TObject);
begin
    if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
             Exit;
    tipoCambio:= _ASIGNACION;
    tipoCorte:= _CORTE_FIN_DIA;
    fechaCorte:= Now;
    frmCortes := TfrmCortes.Create(Self);
    frmCortes.edEfectivo.PasswordChar:= '*';
    frmCortes.edRecolecciones.PasswordChar := '*';
    frmCortes.edIxes.PasswordChar := '*';
    frmCortes.edtBanamex.PasswordChar := '*';
    frmCortes.edtNoRecos.PasswordChar := '*';
    frmCortes.edRecolecciones.PasswordChar := '*';
    frmCortes.edCancelados.PasswordChar    := '*';
    MostrarForma(frmCortes);
end;


procedure TFrm_main.act162Execute(Sender: TObject);
begin
   if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
             Exit;
   tipoCambio:= _ASIGNACION;
   tipoCorte:= _CORTE_PASADO;
   fechaCorte:= Now;
   inicializaImpresionVars();
   try
            frmCortes := TfrmCortes.Create(Self);
            frmCortes.ShowModal;
   finally
            frmCortes.Free;
            frmCortes := nil;
   end;
end;


procedure TFrm_main.act163Execute(Sender: TObject);
begin
    if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
             Exit;
    tipoCambio:= _ASIGNACION;
    tipoCorte:= _CORTE_AUDITORIA;
    fechaCorte:= Now;

    try
            frmCortes := TfrmCortes.Create(Self);
            frmCortes.ShowModal;
    finally
            frmCortes.Free;
            frmCortes := nil;
    end;
end;


procedure TFrm_main.act214Execute(Sender: TObject);
begin
   if not AccesoPermitido(214, _NO_RECUERDA_TAGS) then
        Exit;
   try
        frmAsignarFondo := TfrmAsignarFondo.Create(Self);
        frmAsignarFondo.tipoFormulario:= _TIPO_FONDO_PRE;
        frmAsignarFondo.ShowModal;
    finally
        frmAsignarFondo.Free;
        frmAsignarFondo := nil;
    end;
end;

procedure TFrm_main.act214_Execute(Sender: TObject);
begin
   if not AccesoPermitido(214, _NO_RECUERDA_TAGS) then
        Exit;
   try
        frmAsignarFondo := TfrmAsignarFondo.Create(Self);
        frmAsignarFondo.tipoFormulario:= _TIPO_FONDO_POST;
        frmAsignarFondo.ShowModal;
    finally
        frmAsignarFondo.Free;
        frmAsignarFondo := nil;
    end;
end;

procedure TFrm_main.act216Execute(Sender: TObject);
begin
   if not AccesoPermitido(216, _NO_RECUERDA_TAGS) then
      exit;
   try
     frmReportePrivilegio := TfrmReportePrivilegio.Create(self);
     frmReportePrivilegio.tipoFormulario := 0;
     frmReportePrivilegio.ShowModal;
   finally
     frmReportePrivilegio.Free;
     frmReportePrivilegio := nil;
   end;
end;

procedure TFrm_main.act219Execute(Sender: TObject);
var
  forma: TfrmImportes;
begin
   if not AccesoPermitido(218, _RECUERDA_TAGS) then
          Exit;
   forma := TfrmImportes.Create(self);
   MostrarForma(forma);

end;

procedure TFrm_main.actarjetaViajeExecute(Sender: TObject);
var
    lfrm_forma : Tfrm_guias_servicio;
begin
    if not AccesoPermitido(154,False) then
        exit;
    valoresIniciales();
    lfrm_forma := Tfrm_guias_servicio.Create(nil);
    MostrarForma(lfrm_forma);
end;


procedure TFrm_main.act195Execute(Sender: TObject);
begin
   if not AccesoPermitido(195 ,False) then
     EXIT;
   frmTerminales := TfrmTerminales.Create(self);
   frmTerminales.ShowModal;
   frmTerminales.Free;
end;


procedure TFrm_main.Act208Execute(Sender: TObject);
begin
   if not AccesoPermitido(208, _NO_RECUERDA_TAGS) then
      Exit;
   try
        ModificacionRemotaGuias := TModificacionRemotaGuias.Create(self);
        ModificacionRemotaGuias.ShowModal;
    finally
        ModificacionRemotaGuias.Free;
        ModificacionRemotaGuias := nil;
    end;
end;

procedure TFrm_main.Action11Execute(Sender: TObject);
begin
  if not AccesoPermitido(216, _NO_RECUERDA_TAGS) then
      exit;
   try
     frmReportePrivilegio := TfrmReportePrivilegio.Create(self);
     frmReportePrivilegio.tipoFormulario := 1;
     frmReportePrivilegio.ShowModal;
   finally
     frmReportePrivilegio.Free;
     frmReportePrivilegio := nil;
   end;
end;

procedure TFrm_main.Action12Execute(Sender: TObject);
var
    forma : Tfrm_updateCorridas;
begin
   if not AccesoPermitido(221,False) then
          Exit;
    forma := Tfrm_updateCorridas.Create(self);
    MostrarForma(forma);
    gs_trabid := '';
    gb_asignado := False;
end;

procedure TFrm_main.Action1Execute(Sender: TObject);
var
    lfrm_forma : Tfrm_reservados_vta;
begin
    valoresIniciales();
    lfrm_forma := Tfrm_reservados_vta.Create(self);
    MostrarForma(lfrm_forma);
    gs_trabid := '';
    gb_asignado := False;
end;


procedure TFrm_main.Action2Execute(Sender: TObject);
var
    lfrm_forma : tFrm_reservacion;
begin
   if not AccesoPermitido(191,False) then
          Exit;
    gi_operacion_remota := obtieneOperacionRemota(gs_terminal,gs_local);
    lfrm_forma := TFrm_reservacion.Create(self);
    MostrarForma(lfrm_forma);
    gs_trabid := '';
    gb_asignado := False;
end;


procedure TFrm_main.Action3Execute(Sender: TObject);
var
    lfrm_forma : Tfrm_status_corrida;
begin
    lfrm_forma := Tfrm_status_corrida.Create(nil);
    MostrarForma(lfrm_forma);
end;


procedure TFrm_main.Action4Execute(Sender: TObject);
var
    lfr_password : TFrm_contrasena;
begin
    lfr_password := TFrm_contrasena.Create(self);
    MostrarForma(lfr_password);
end;


procedure TFrm_main.Action5Execute(Sender: TObject);
var
    frm : Tfrm_historico;
begin
    frm := Tfrm_historico.Create(self);
    MostrarForma(frm);
end;


procedure TFrm_main.Action6Execute(Sender: TObject);
var
    frm : Tfrm_nueva_venta;
begin
    if li_ctrl_conectando = 1 then
      ListaFill();

    gs_trabid := '';
    gb_asignado := False;
    gi_impresion_personalizada := 0;
    valoresIniciales();
    frm := Tfrm_nueva_venta.Create(Self);
    MostrarForma(frm);
    gs_trabid := '';
    gb_asignado := False;
end;


procedure TFrm_main.Action7Execute(Sender: TObject);
begin
   if not AccesoPermitido(106, _NO_RECUERDA_TAGS) then
       Exit;
   frmUSuario := TfrmUSuario.create(self);
   MostrarForma(frmUsuario);
end;

procedure TFrm_main.Action8Execute(Sender: TObject);
var
    lfr_forma : Tfrm_agencias;
begin
    if not AccesoPermitido(195,_NO_RECUERDA_TAGS) then
        exit;
    lfr_forma := Tfrm_agencias.Create(self);
    MostrarForma(lfr_forma);
end;


procedure TFrm_main.Action9Execute(Sender: TObject);
var
    lfr_forma : Tfrm_agencia_corrida;
begin
   if not AccesoPermitido(198,_NO_RECUERDA_TAGS) then
      exit;
   lfr_forma := Tfrm_agencia_corrida.Create(self);
   MostrarForma(lfr_forma);
end;


procedure TFrm_main.act186Execute(Sender: TObject);
var
    lfr_forma : TfrmAdministracionCorte;
begin
 ShowMessage('Módulo eliminado.');
{ REMOVIDO 24-SEP-2013 GALMANZA
   if not AccesoPermitido(TButton(Sender).Tag, _NO_RECUERDA_TAGS) then
          Exit;
    gs_puerto := getNamePuerto(getPuertoImpresora(1));//impresora
    lfr_forma := TfrmAdministracionCorte.Create(Self);
    MostrarForma(lfr_forma);
    }
end;


procedure TFrm_main.act164Execute(Sender: TObject);
begin
   if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
          Exit;
   try
        frmFaltantesSobrantes := TfrmFaltantesSobrantes.Create(Self);
        frmFaltantesSobrantes.ShowModal;
   finally
        frmFaltantesSobrantes.Free;
        frmFaltantesSobrantes := nil;
   end;
end;


procedure TFrm_main.acVacacionalExecute(Sender: TObject);
var
    lfr_forma : Tfrm_vacacional;
begin
    lfr_forma := Tfrm_vacacional.Create(Self);
    MostrarForma(lfr_forma);
end;


procedure TFrm_main.Boletos1Click(Sender: TObject);
var
    lfr_forma : TFrm_cancelaciones;
begin
    lfr_forma := TFrm_cancelaciones.Create(Self);
    MostrarForma(lfr_forma);
end;


procedure TFrm_main.Button1Click(Sender: TObject);
begin
////
end;

procedure TFrm_main.Cancelaciones1Click(Sender: TObject);
var
    lfrm_forma : Tfrm_reservados_vta;
begin
    lfrm_forma := Tfrm_reservados_vta.Create(self);
    MostrarForma(lfrm_forma);
end;


procedure TFrm_main.Despachar1Click(Sender: TObject);
var
    lfrm_forma : Tfrm_guias_servicio;
begin
    if not AccesoPermitido(154,False) then
        exit;
    lfrm_forma := Tfrm_guias_servicio.Create(nil);
    MostrarForma(lfrm_forma);
end;


procedure TFrm_main.ac100Execute(Sender: TObject);
var
    lfrm_forma : TFrm_grupos;
begin//mostramos la forma para la validacion del grupo
     if not AccesoPermitido(100,False) then
        Exit;
     lfrm_forma := TFrm_grupos.Create(Self);
     MostrarForma(lfrm_forma);
end;

{@Procedure ac103Execute
@Params Sender: TObject
@Descripcion Muestra la pantalla para la asignacion de permisos por grupo}
procedure TFrm_main.ac103Execute(Sender: TObject);
var
     lfrm_forma : TFrm_permisos_grps;
begin
     if not AccesoPermitido(103,False) then
        Exit;
     lfrm_forma := TFrm_permisos_grps.Create(Self);
     lfrm_forma.UserGrupo := 0;
     MostrarForma(lfrm_forma);
end;


{@Procedure ac105Execute
@Params Sender: TObject
@Descripcion Muestra la pantalla para la asignacion de permisos por Usuario}
procedure TFrm_main.ac105Execute(Sender: TObject);
var
     lfrm_forma : TFrm_permisos_grps;
begin
     if not AccesoPermitido(105,False) then
        Exit;
     lfrm_forma := TFrm_permisos_grps.Create(Self);
     lfrm_forma.UserGrupo := 1;
     MostrarForma(lfrm_forma);
end;


{@Procedure ac108Execute
@Params Sender: TObject
@Descripcion Muestra la pantalla para el trazo de asientos en el bus}
procedure TFrm_main.ac108Execute(Sender: TObject);
var
    lfrm_forma : TFrm_autobus;
begin
    if not AccesoPermitido(109,False) then
        exit;
    lfrm_forma := TFrm_autobus.Create(Self);
    MostrarForma(lfrm_forma);
end;


{@Procedure ac108Execute
@Params Sender: TObject
@Descripcion Muestra la pantalla para el trazo de asientos en el bus}
procedure TFrm_main.ac112Execute(Sender: TObject);
var
    lfrm_forma : Tfrm_cat_config;
begin
    if not AccesoPermitido(112,False) then
        exit;
    lfrm_forma := Tfrm_cat_config.Create(Self);
    insertaEvento(gs_trabid,gs_terminal, 'Acceso al catalogo de configuracion');
    MostrarForma(lfrm_forma);
end;

{@Procedure ac106Execute
@Params Sender : TObject
@Descripcion Muestra la pantalla de usuarios}
procedure TFrm_main.ac106Execute(Sender: TObject);
var
    lfr_forma : TFrm_usuarios;
begin
    if not AccesoPermitido(ac106.Tag,False) then
      exit;
    lfr_forma := TFrm_usuarios.Create(Self);
    MostrarForma(lfr_forma);
end;


procedure TFrm_main.ac120Execute(Sender: TObject);
var
    lfr_forma : TFrm_ocupante;
begin
    if not AccesoPermitido(ac120.Tag,False) then
      exit;

    lfr_forma := TFrm_ocupante.Create(Self);
    MostrarForma(lfr_forma);
end;


procedure TFrm_main.ac158Execute(Sender: TObject);
var
    lfrm_forma : Tfrm_corrida_libera;
begin
    if not AccesoPermitido(ac158.Tag,False) then
        exit;
    lfrm_forma := Tfrm_corrida_libera.Create(Self);
    MostrarForma(lfrm_forma);
    gs_trabid := '';
    gb_asignado := False;
end;


procedure TFrm_main.ac200Execute(Sender: TObject);
var
    forma : Tfrm_taquilla;
begin
    if not AccesoPermitido(200,False) then
        exit;
    forma := Tfrm_taquilla.Create(Self);
    MostrarForma(forma);
    gs_trabid := '';
    gb_asignado := False;
    FormActivate(Sender);
    LeerFileIni();
    valoresIniciales();
end;


procedure TFrm_main.ac203Execute(Sender: TObject);
var
    forma : Tfrm_usuario_baja;
begin
    if not AccesoPermitido(204, False) then
       exit;
    forma := Tfrm_usuario_baja.Create(nil);
    MostrarForma(forma);
end;

procedure TFrm_main.ac99Execute(Sender: TObject);
begin
    Application.Terminate;
end;


procedure TFrm_main.acBarsExecute(Sender: TObject);
var
    frm_forma : Tfrm_bars;
begin
    frm_forma := Tfrm_bars.Create(nil);
    MostrarForma(frm_forma);
end;

procedure TFrm_main.acBoletoExecute(Sender: TObject);
var
    lfr_forma : TFrm_cancelaciones;
begin
    lfr_forma := TFrm_cancelaciones.Create(Self);
    MostrarForma(lfr_forma);
    gb_asignado := False;
end;


procedure TFrm_main.acCnlReservacionExecute(Sender: TObject);
var
    frm : TFrm_reserva_cancela;
    frm_n : Tfrm_cancela_new;
begin
    frm_n := Tfrm_cancela_new.Create(self);
    MostrarForma(frm_n);
    gs_trabid := '';
    gb_asignado := False;
end;


procedure TFrm_main.acExtrasExecute(Sender: TObject);
var
   lfrm_forma : TfrmExtras;
begin
   if not AccesoPermitido(176, False) then
     exit;
   valoresIniciales();
   lfrm_forma := TfrmExtras.Create(self);
   MostrarForma(lfrm_forma);
end;


procedure TFrm_main.acGenerarcorridasExecute(Sender: TObject);
var
 lfrm_forma : TFrmCorridas;
begin
 if not AccesoPermitido(174, False) then
   exit;
 lfrm_forma := TFrmCorridas.Create(self);
 MostrarForma(lfrm_forma);
end;


procedure TFrm_main.acItinerarioExecute(Sender: TObject);
var
   lfrm_forma : TFrm_itinerario;
begin
   if not AccesoPermitido(128, False) then
     exit;
   lfrm_forma := TFrm_itinerario.Create(self);
   MostrarForma(lfrm_forma);
end;

procedure TFrm_main.acPrecorteExecute(Sender: TObject);
var
    lf_forma : tfrm_precorte;
    lq_qry   : TSQLQuery;
begin
    if not AccesoPermitido(_TAG_VENTA, False) then
        Exit;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_CHECA_CORTE_P,[gs_trabid,gs_terminal]),lq_qry,_LOCAL) then
        if (lq_qry['TOTAL'] = 0) or VarIsNull(lq_qry['TOTAL']) then begin
              Mensaje('El estatus de la venta, debe de estar'+#10#13+
                      'preparada para corte',1);
              exit;
        end;
    lf_forma := Tfrm_precorte.Create(nil);
    lf_forma.Pcorte := lq_qry['ID_CORTE'];
    lf_forma.Pcquien := gs_trabid;
    MostrarForma(lf_forma);
    lq_qry.Free;
end;

end.

