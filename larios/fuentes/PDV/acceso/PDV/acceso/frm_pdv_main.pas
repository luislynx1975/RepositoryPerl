/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Acceso                                                        //
//  Pantalla:    Sistema para el Punto De Venta                                //
//  Descripción: //
//  Fecha:       16 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
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
  RibbonLunaStyleActnCtrls, Buttons, ScreenTips, lsCombobox, FMTBcd, DB, SqlExpr,
  SimpleDS;

type
  TFrm_main = class(TForm)
    ActionManager1: TActionManager;
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
    acVenta: TAction;
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
    RibbonGroup7: TRibbonGroup;
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
    stg_detalle: TStringGrid;
    act146: TAction;
    act147: TAction;
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
    procedure acVentaExecute(Sender: TObject);
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_main: TFrm_main;

implementation

uses Frm_Ini_Config,  Frm_acc_grupos, Frm_acc_usuario,
  Frm_grp_permiso, DMdb, Frm_splash, frm_acc_password, u_main,
  frm_bus_autobus, Frm_vta_main, frm_cat_configuracion,  frm_iti_ocupante,
  Asiento, U_venta, corridas, frm_iti_itinerario, extras, comunii, frmCorte,
  frmCtramos, frmCrutas, frmFaltantesYSobrantes, frmTarifas,
  frm_vta_status_corrida, Frm_vta_reservacion1, frm_venta_anticipada,
  frm_periodo_vacacional, frmAdministracionCortes, ThreadRutas,
  frm_cambio_password, frmCorteFinDeDia, frmCorteTipoServicio;

var
    Fpassword : TPasswordDlg;
    li_ctrl   : Integer;


{$R *.dfm}

procedure TFrm_main.FormShow(Sender: TObject);
var
     lfile_ini  : TIniFile;
     frm_ini    : TFrm_Ini;//nombre la forma
     ls_NameIni : String;
     hilo_ruta  : TodasRutasDetalle;
begin
      li_msg_password := 0;
      if li_ctrl_conectando = 1 then
          exit;

      ls_NameIni := ExtractFilePath(Application.ExeName);
      ls_NameIni := ls_NameIni + 'begin.ini';
      lfile_ini  := TIniFile.Create(ls_NameIni);
      if FileExists(ls_NameIni) then begin
        try
          gs_local    := lfile_ini.ReadString('CompanyInfo','ip','localhost');
          gs_terminal := lfile_ini.ReadString('CompanyInfo','terminal','Mex');
          gs_maquina  := lfile_ini.ReadString('CompanyInfo','Maquina','1');
          gs_puerto   := lfile_ini.ReadString('CompanyInfo','Puerto','LPT1');
          gs_server   := lfile_ini.ReadString('ServerLocal','server','localhost');
          gs_dbName   := lfile_ini.ReadString('ServerLocal','DbName','pullman');
          gs_user     := lfile_ini.ReadString('ServerLocal','user','pullman');
          gs_password := lfile_ini.ReadString('ServerLocal','acceso','pullman');
        finally
          lfile_ini.Free;//liberamos el archivo
        end;//presentar la pantalla para la configuracion del usuario
      end else begin//Creamos el archivo atravez de la forma Ini
                  if li_ctrl_conectando = 0 then begin
                    try
                      frm_ini := TFrm_Ini.Create(Self);
                      frm_ini.ShowModal();
                    finally
                      gs_local    := lfile_ini.ReadString('CompanyInfo','ip','localhost');
                      gs_terminal := lfile_ini.ReadString('CompanyInfo','terminal','Mex');
                      gs_maquina  := lfile_ini.ReadString('CompanyInfo','Maquina','1');
                      gs_puerto   := lfile_ini.ReadString('CompanyInfo','Puerto','LPT1');
                      gs_server   := lfile_ini.ReadString('ServerLocal','server','localhost');
                      gs_dbName   := lfile_ini.ReadString('ServerLocal','DbName','pullman');
                      gs_user     := lfile_ini.ReadString('ServerLocal','user','pullman');
                      gs_password := lfile_ini.ReadString('ServerLocal','acceso','pullman');
                      frm_ini.Free;
                      frm_ini := nil;
                    end;
                  end;
      end;
//      Sleep(2000);
//      Frm_ini_splash.free;
      if li_ctrl_conectando = 1 then begin
         DM.conectandoServer();//agregamos la taquilla con la ip
         CONEXION_VTA := DM.Conecta;
         llenaPosicionLugares();
         guardamosAutobus();
         agregaTaquillaIP();
         obtenPeriodoVacacional();
         ListaFill();//checar por error
         AutobusesDuales();///buscamos los buses y se guardan en la variable dualstring
         ga_servers := obtenerIpsServer();//cargamos las direcciones ips de los servers
         grid_rutas := stg_detalle;
         hilo_ruta := TodasRutasDetalle.Create(true);
         hilo_ruta.server := CONEXION_VTA;
         hilo_ruta.grid   := grid_rutas;
         hilo_ruta.Priority := tpIdle;
         hilo_ruta.FreeOnTerminate := true;
         hilo_ruta.start;
      end;
      li_ctrl_conectando := 1;

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

procedure TFrm_main.Ventapublico1Click(Sender: TObject);
var
    lfrm_forma : TFrm_venta_principal;
begin
    lfrm_forma := TFrm_venta_principal.Create(Self);
    MostrarForma(lfrm_forma);
end;


procedure TFrm_main.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    DM.desconectaServer();
end;

procedure TFrm_main.FormCreate(Sender: TObject);
begin
{    Frm_main.Caption := Frm_main.Caption + '                          '+
                    FloatToStr(_VERSION); }
    Ribbon1.Caption := 'version '+ FloatToStr(_VERSION);
    ShortTimeFormat := 'HH:MM:SS';
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
        frmRutas := TfrmRutas.Create(Self);
        frmRutas.ShowModal;
   finally
        frmRutas.Free;
        frmRutas := nil;
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
        MostrarForma(frmCortes);
end;

procedure TFrm_main.act162Execute(Sender: TObject);
begin
   if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
             Exit;
   tipoCambio:= _ASIGNACION;
   tipoCorte:= _CORTE_PASADO;
   fechaCorte:= Now;
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

procedure TFrm_main.actarjetaViajeExecute(Sender: TObject);
var
    lfrm_forma : Tfrm_guias_servicio;
begin
{    if not AccesoPermitido(154,False) then
        exit;                     }
    lfrm_forma := Tfrm_guias_servicio.Create(nil);
    MostrarForma(lfrm_forma);
end;

procedure TFrm_main.Action1Execute(Sender: TObject);
var
    lfrm_forma : Tfrm_reservados_vta;
begin
    lfrm_forma := Tfrm_reservados_vta.Create(self);
    MostrarForma(lfrm_forma);
end;

procedure TFrm_main.Action2Execute(Sender: TObject);
var
    lfrm_forma : tFrm_reservacion;
begin
    lfrm_forma := TFrm_reservacion.Create(self);
    MostrarForma(lfrm_forma);
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

procedure TFrm_main.act186Execute(Sender: TObject);
var
    lfr_forma : TfrmAdministracionCorte;
begin
   if not AccesoPermitido(TButton(Sender).Tag, _NO_RECUERDA_TAGS) then
          Exit;
    lfr_forma := TfrmAdministracionCorte.Create(Self);
    MostrarForma(lfr_forma);
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
////invocamos el periodo el periodo vacacional
    lfr_forma := Tfrm_vacacional.Create(Self);
    MostrarForma(lfr_forma);
end;

procedure TFrm_main.acVentaExecute(Sender: TObject);
///nuevos actions
var
    lfrm_forma : TFrm_venta_principal;
begin
    lfrm_forma := TFrm_venta_principal.Create(Self);
    MostrarForma(lfrm_forma);
end;

procedure TFrm_main.Boletos1Click(Sender: TObject);
var
    lfr_forma : TFrm_cancelaciones;
begin
    lfr_forma := TFrm_cancelaciones.Create(Self);
    MostrarForma(lfr_forma);
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

end;

procedure TFrm_main.ac99Execute(Sender: TObject);
begin
    Application.Terminate;
end;

procedure TFrm_main.acBoletoExecute(Sender: TObject);
var
    lfr_forma : TFrm_cancelaciones;
begin
    lfr_forma := TFrm_cancelaciones.Create(Self);
    MostrarForma(lfr_forma);
end;

procedure TFrm_main.acCnlReservacionExecute(Sender: TObject);
var
    frm : TFrm_reserva_cancela;
begin
    frm := TFrm_reserva_cancela.Create(Self);
    MostrarForma(frm);
end;

procedure TFrm_main.acExtrasExecute(Sender: TObject);
var
   lfrm_forma : TfrmExtras;
begin
   if not AccesoPermitido(176, False) then
     exit;
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

end.

