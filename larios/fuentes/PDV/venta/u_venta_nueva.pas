unit u_venta_nueva;

interface
{$WARNINGS OFF}
{$HINTS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, Grids, StdCtrls, Mask, lsCombobox, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ActnMenus,
  u_comun_venta, DB, Menus, u_cobro_banamex, System.Actions, Data.SqlExpr;

type
  Tfrm_nueva_venta = class(TForm)
    Panel1: TPanel;
    Gr_Corridas: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    lbl_nombre: TLabel;
    ls_Desde_vta: TlsComboBox;
    ls_Origen_vta: TlsComboBox;
    ls_Origen_: TlsComboBox;
    ls_servicio: TlsComboBox;
    medt_fecha: TMaskEdit;
    Ed_Hora: TEdit;
    edt_corrida: TEdit;
    GroupBox2: TGroupBox;
    stg_detalle: TStringGrid;
    GroupBox3: TGroupBox;
    stg_ocupantes: TStringGrid;
    Panel2: TPanel;
    Splitter2: TSplitter;
    pnlBUS: TPanel;
    Image: TImage;
    Label125: TLabel;
    Label150: TLabel;
    Label149: TLabel;
    Label148: TLabel;
    Label147: TLabel;
    Label146: TLabel;
    Label145: TLabel;
    Label144: TLabel;
    Label143: TLabel;
    Label142: TLabel;
    Label141: TLabel;
    Label140: TLabel;
    Label139: TLabel;
    Label138: TLabel;
    Label137: TLabel;
    Label136: TLabel;
    Label135: TLabel;
    Label134: TLabel;
    Label133: TLabel;
    Label132: TLabel;
    Label131: TLabel;
    Label130: TLabel;
    Label129: TLabel;
    Label128: TLabel;
    Label127: TLabel;
    Label126: TLabel;
    Label124: TLabel;
    Label123: TLabel;
    Label122: TLabel;
    Label121: TLabel;
    Label120: TLabel;
    Label119: TLabel;
    Label118: TLabel;
    Label117: TLabel;
    Label116: TLabel;
    Label115: TLabel;
    Label114: TLabel;
    Label113: TLabel;
    Label112: TLabel;
    Label111: TLabel;
    Label110: TLabel;
    Label109: TLabel;
    Label108: TLabel;
    Label107: TLabel;
    Label106: TLabel;
    Label105: TLabel;
    Label104: TLabel;
    Label103: TLabel;
    Label102: TLabel;
    Label101: TLabel;
    Label100: TLabel;
    pnl_main: TPanel;
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
    grp_asientos: TGroupBox;
    grp_cuales: TGroupBox;
    lbledt_cuales: TLabeledEdit;
    stg_listaOcupantes: TStringGrid;
    lbledt_tipo: TLabeledEdit;
    lblEdt_cuantos: TLabeledEdit;
    StatusBar1: TStatusBar;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action2: TAction;
    ac111: TAction;
    TRefrescaCorrida: TTimer;
    TimerAsignado: TTimer;
    timer_pintabus: TTimer;
    ac116: TAction;
    ac179: TAction;
    ac160: TAction;
    acboleto: TAction;
    acAnticipada: TAction;
    acimprimevta: TAction;
    PopupMenu: TPopupMenu;
    Predespachar1: TMenuItem;
    Agrupar1: TMenuItem;
    Modificar1: TMenuItem;
    Cerrarcorrida1: TMenuItem;
    stb_venta: TStatusBar;
    Action1: TAction;
    acPrueba: TAction;
    Action3: TAction;
    Apartaasientos1: TMenuItem;
    arjetadeviaje1: TMenuItem;
    Action4: TAction;
    Action5: TAction;
    timer_Hora: TTimer;
    VentaReservados1: TMenuItem;
    CancelaReservacion1: TMenuItem;
    LiberaCorrida1: TMenuItem;
    CorridaExtra1: TMenuItem;
    acReimprimirVoucher: TAction;
    acCancela: TAction;
    CancelaReservacion2: TMenuItem;
    acCorteBanamex: TAction;
    Timer_guias: TTimer;
    img_central: TImage;
    mem_conectado: TMemo;
    Tping: TTimer;
    procedure Action2Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ls_servicioExit(Sender: TObject);
    procedure stg_corridaKeyPress(Sender: TObject; var Key: Char);
    procedure ac111Execute(Sender: TObject);
    procedure lbledt_cualesChange(Sender: TObject);
    procedure lbledt_cualesKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbledt_cualesExit(Sender: TObject);
    procedure cuales_primer_paso();
    procedure lbledt_tipoKeyPress(Sender: TObject; var Key: Char);
    procedure Predespachar1Click(Sender: TObject);
    procedure Agrupar1Click(Sender: TObject);
    procedure Modificar1Click(Sender: TObject);
    procedure Cerrarcorrida1Click(Sender: TObject);
    procedure lbledt_cualesEnter(Sender: TObject);
    procedure lbledt_tipoEnter(Sender: TObject);
    procedure lbledt_tipoChange(Sender: TObject);
    procedure lblEdt_cuantosKeyPress(Sender: TObject; var Key: Char);
    procedure lblEdt_cuantosExit(Sender: TObject);
    procedure lblEdt_cuantosEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TimerAsignadoTimer(Sender: TObject);
    procedure stg_corridaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure stg_corridaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure timer_pintabusTimer(Sender: TObject);
    procedure ac116Execute(Sender: TObject);
    procedure ac160Execute(Sender: TObject);
    procedure ac179Execute(Sender: TObject);
    procedure acboletoExecute(Sender: TObject);
    procedure acAnticipadaExecute(Sender: TObject);
    procedure acimprimevtaExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure acPruebaExecute(Sender: TObject);
    procedure TRefrescaCorridaTimer(Sender: TObject);
    procedure ls_Desde_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure ls_Desde_vtaExit(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Apartaasientos1Click(Sender: TObject);
    procedure arjetadeviaje1Click(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure ls_Origen_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure lbledt_tipoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure timer_HoraTimer(Sender: TObject);
    procedure medt_fechaEnter(Sender: TObject);
    procedure VentaReservados1Click(Sender: TObject);
    procedure CancelaReservacion1Click(Sender: TObject);
    procedure LiberaCorrida1Click(Sender: TObject);
    procedure CorridaExtra1Click(Sender: TObject);
    procedure acReimprimirVoucherExecute(Sender: TObject);
    procedure acCancelaExecute(Sender: TObject);
    procedure acBlancoExecute(Sender: TObject);
    procedure acCorteBanamexExecute(Sender: TObject);
    procedure ls_servicioKeyPress(Sender: TObject; var Key: Char);
    procedure TpingTimer(Sender: TObject);
  private
    { Private declarations }
    procedure Titles;
    procedure llenamosDatosInicio();
    procedure limpiaEntrada();
    procedure consigueCorridas();
    function valida_Busqueda_Corrida(): Boolean;
    procedure enableTextInput();
    procedure disableTextInput();
    procedure pintaBusCorrida(li_indx: Integer);
    procedure asignarseVenta();
    procedure muestraImagenPatalla();
  public
    { Public declarations }
    li_hora, li_minuto, li_segundo : Integer;
  end;

var
  frm_nueva_venta: Tfrm_nueva_venta;
  ga_labels: ga_labels_asientos;
  lsOrigen, lsDestino: string;
  gi_ultima_corrida_procesada: Integer;
  asientos_pago: array_asientos;
  lb_opcion: Boolean;
  li_valor_refresca: Integer;

implementation

uses DMdb, comun, Frm_fondo_inicial, frm_mensaje_corrida, frm_pago_nueva,
  Frm_vta_agrupa_corrida, modificarCorrida, frmMrecolecccion, comunii,
  Frm_cancela_boletos, frm_venta_anticipada, frm_anticipada_venta,
  frm_cambio_password, u_boleto, u_fondo_inicial_nuevo, frm_ultimaventa,
  frm_aparta_asientos, frm_guias_despacho, Unit1, frm_calendario_venta,
  frm_cancela_boletos_new, u_venta_usuarios, u_ithaca_print,
  u_ToshibaMini_print, frm_reservacion_vender, frm_cancela_reservacion_new,
  frm_vta_libera_corrida, extras, Frm_cancela_reservacion, frm_registro_folios,
  u_impresion, ThreadPingServer, TLiberaAsientosRuta, uLitteScreen;
{$R *.dfm}

var
  li_corrida_seleccionada: Integer;
  gi_local_cuales: Integer;
  li_key_press_tipo: Word;
  array_ocupantes: array [1 .. 20] of string;
  li_tecla_espera: Integer;
  li_ultima_corrida_procesada: Integer;
  li_activo_refresh: Integer;
  gs_descripcion_lugar: String;
  li_conectado_remotamente : integer;
  gli_carga : integer;
  pingHilo : TPingServer;


function SecondsIdle: DWord;
var
  liInfo: TLastInputInfo;
begin
  liInfo.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(liInfo);
  Result := (GetTickCount - liInfo.dwTime) DIV 1000;
end;


procedure Tfrm_nueva_venta.ac111Execute(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
  gi_opcion := 20;
  if not AccesoPermitido(_TAG_VENTA, False) then begin
    FormShow(Sender);
    exit;
  end else begin
          lbl_nombre.Caption := gs_nombre_trabid;
          gb_asignado := True;
          asignarseVenta();
  end;
end;


procedure Tfrm_nueva_venta.ac116Execute(Sender: TObject);
var
  lq_query: TSQLQuery;
  lf_folio : Tfrm_folio_registro;
begin
    if not gb_asignado then begin
        Mensaje('El usuario no esta asignado a la venta',1);
        gb_asignado := False;
        gs_trab_unico := '';
        exit;
    end;
  try
    gi_opcion := 21;
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta; // Conexion local al server de venta
    asignaVentaNew(gs_trabid, gs_terminal, StrToInt(gs_maquina));
    limpiar_La_labels(ga_labels); // limpiamos las etiquetas
    If Application.MessageBox(PWideChar('¿Desea pausar la venta?' + #13#10 +
          'SI : pausara la venta' + #13#10 + 'NO: generara un corte'),  'Atención',
          MB_YESNO + MB_DEFBUTTON1 + MB_ICONQUESTION) = IDYES then  Begin
      if EjecutaSQL(format(_VTA_UPDATE_NO_VENTA, [gi_corte_store, gs_terminal]), lq_query, _LOCAL) then
                ;
          insertaEvento(gs_trab_unico,gs_terminal,'Pausa la venta '+ gs_trab_unico);
          gb_asignado := False;
          gli_carga := 0;
          gi_corte_store := 0;
          gs_trab_unico := '';
          gs_trabid := '';
          ac111.Enabled := True;
          ac116.Enabled := False;
          ac160.Enabled := False;
          ac179.Enabled := False;
          acboleto.Enabled := False;
          acAnticipada.Enabled := False;
          acimprimevta.Enabled := False;
          lbl_nombre.Caption := _NO_REGISTRADO;
          edt_corrida.Clear;
          ls_servicio.ItemIndex := -1;
          Ed_Hora.Clear;
          ls_Desde_vta.ItemIndex := -1;
          Image.Visible := False;
          LimpiaSag(stg_corrida);
          LimpiaSagTodo(stg_ocupantes);
          LimpiaSagTodo(stg_detalle);
          Titles; // coloca los titulos en el grid
          Self.Caption := 'Pantalla de venta';
    end else begin
          If Application.MessageBox(PWideChar('Si la seleccion es "si"' + #13#10 +
                'no podra realizar venta' + #13#10 +
                'hasta que se realize el corte' ),
            'Advertencia ', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION) = IDYES then begin
            if EjecutaSQL(format(_VTA_UPDATE_EN_PROCESO, [gi_corte_store,
                gs_terminal]), lq_query, _LOCAL) then ;
            insertaEvento(gs_trab_unico,gs_terminal,'Proceso de corte '+ gs_trab_unico);
//imprime la carga final
            if EjecutaSQL(_VTA_PRINT_FINAL, lq_query, _LOCAL) then begin
                if lq_query['VALOR'] = 1 then//larioz
                    if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
                      ImprimeCargaInicial(gs_trab_unico,' Final ');
                    end;
            end;
            gb_asignado := False;
            gli_carga := 0;
            gs_trab_unico := '';
            gs_trabid := '';
            gi_corte_store := 0;
            ac111.Enabled := True;
            ac116.Enabled := False;
            ac179.Enabled := False;
            ac160.Enabled := False;
            acboleto.Enabled := False;
            acAnticipada.Enabled := False;
            acimprimevta.Enabled := False;
            LimpiaSagTodo(stg_ocupantes);
            LimpiaSagTodo(stg_detalle);
            edt_corrida.Clear;
            ls_servicio.ItemIndex := -1;
            Ed_Hora.Clear;
            ls_Desde_vta.ItemIndex := -1;
            lbl_nombre.Caption := _NO_REGISTRADO;
            Self.Caption := 'Pantalla de venta';
            ImprimeCargaFinal(gs_trabid);
      end else begin
            if EjecutaSQL(format(_VTA_UPDATE_NO_VENTA, [gi_corte_store, gs_terminal]), lq_query, _LOCAL) then
                  ;
            insertaEvento(gs_trab_unico,gs_terminal,'Pausa la venta '+ gs_trab_unico);
            lbl_nombre.Caption := _NO_REGISTRADO;
            gb_asignado := False;
            gli_carga := 0;
            gs_trab_unico := '';
            gs_trabid := '';
            gi_corte_store := 0;
            ac111.Enabled := True;
            ac116.Enabled := False;
            ac179.Enabled := False;
            acboleto.Enabled := False;
            acAnticipada.Enabled := False;
            acimprimevta.Enabled := False;
            LimpiaSagTodo(stg_ocupantes);
            LimpiaSagTodo(stg_detalle);
            edt_corrida.Clear;
            ls_servicio.ItemIndex := -1;
            Ed_Hora.Clear;
            ls_Desde_vta.ItemIndex := -1;
            Self.Caption := 'Pantalla de venta';
      end;
    end;
    lq_query.Free;
    lq_query := nil;
  except
  end;
//  if gi_Pantalla_duplex = 1 then
      gi_imagen_servicio := 0;
      muestraImagenPatalla;
  FormShow(Sender);
  TRefrescaCorrida.Enabled := False;
  TimerAsignado.Enabled := False;
  Self.Caption := 'Pantalla de venta';
  ac160.Caption := 'Imprime Carga Inicial';
end;


procedure Tfrm_nueva_venta.ac160Execute(Sender: TObject);
var
    lf_folio : Tfrm_folio_registro;
    lq_query : TSQLQuery;
begin
    gi_opcion := 22;
    if not gb_asignado then begin
        Mensaje('El usuario no esta asignado a la venta',1);
        gb_asignado := False;
        gs_trab_unico := '';
        exit;
    end;
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    if gli_carga =  0 then begin
          if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
              ImprimeCargaInicial(gs_trab_unico,'Inicial');
              ac160.Caption := 'Imprime Carga Final';
              gli_carga := 1;
           end;
    end else begin
                if gli_carga =  1 then begin
                       if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
                          ImprimeCargaInicial(gs_trab_unico,'Final');
                          ac160.Caption := 'Imprime Carga Inicial';
                          gli_carga := 0;
                       end;
                    ac116Execute(Sender);
                end;
    end;
    lq_query.Free;
    lq_query := nil;
end;


procedure Tfrm_nueva_venta.ac179Execute(Sender: TObject);
var
  lfrm_forma: TfrmRecoleccion;
  ls_promotor: String;
begin
  gi_opcion := 23;
  if not gb_asignado then begin
      Mensaje('El usuario no esta asignado a la venta',1);
      gb_asignado := False;
      gs_trab_unico := '';
      exit;
  end;
  ls_promotor := '';
  ls_promotor := gs_trab_unico;
  try
    if not AccesoPermitido(179, False) then begin
      gs_trabid := ls_promotor;
      gb_asignado := True;
      exit;
    end;
    if ls_promotor <> gs_trabid then begin
        Mensaje('No puede hacer la recoleccion al no estar '+#10#13+
                'asignado en esta taquilla',2);
        gs_trabid := ls_promotor;
        gb_asignado := True;
        exit;
    end;
    comunii.Recaudado := gs_trabid;
    lfrm_forma := TfrmRecoleccion.Create(nil);
    MostrarForma(lfrm_forma);
    gs_trabid := gs_trab_unico;
    gb_asignado := True;
  finally
    gs_trabid := gs_trab_unico;
    gb_asignado := True;
  end;
end;

procedure Tfrm_nueva_venta.acAnticipadaExecute(Sender: TObject);
var
  lfr_forma: Tfrm_vta_anticipada;
  ls_promotor: String;
begin
    gi_opcion := 25;
    if not gb_asignado then begin
        Mensaje('El usuario no esta asignado a la venta',1);
        gb_asignado := False;
        gs_trab_unico := '';
        exit;
    end;
    ls_promotor := '';
    ls_promotor := gs_trabid;
    if not AccesoPermitido(188, False) then begin
      gs_trabid := ls_promotor;
      exit;
    end;
    lfr_forma := Tfrm_vta_anticipada.Create(Self);
    MostrarForma(lfr_forma);
    gs_trabid := gs_trab_unico;
    if length(ls_promotor) = 0 then begin
        gb_asignado := False;
        gs_trabid := '';
    end else
        gb_asignado := True;
end;

procedure Tfrm_nueva_venta.acBlancoExecute(Sender: TObject);
var
    lf_forma : Tfrm_folio_registro;
begin
    if not gb_asignado then begin
        Mensaje('Es necesario que este asignado a la venta'+#10#13+
                'para registrar los folios',2);
        exit;
    end;
    try
      lf_forma := Tfrm_folio_registro.Create(nil);
      lf_forma.Fcorte := gi_corte_store; //corteNumero(gs_trab_unico);
      lf_forma.Ftrabid := gs_trab_unico;
      lf_forma.FInicialFin := _FOL_TREINTA;
      MostrarForma(lf_forma);
    finally
      lf_forma := nil;
    end;
end;

procedure Tfrm_nueva_venta.acboletoExecute(Sender: TObject);
var
  lfr_forma: TFrm_cancelaciones;
  ls_promotor: string;
  frm      : Tfrm_cancelacion_boletos;
begin
    gi_opcion := 24;
    if not gb_asignado then begin
        Mensaje('El usuario no esta asignado a la venta',1);
        gb_asignado := False;
        gs_trab_unico := '';
        exit;
    end;
    ls_promotor := '';
    ls_promotor := gs_trabid;
    CONEXION_ULTIMA := CONEXION_VTA;
    frm := Tfrm_cancelacion_boletos.Create(Self);
    frm.UserAsignado := gs_trab_unico;
    frm.taquilla :=  StrToInt(gs_maquina);
    MostrarForma(frm);
    gs_trabid := gs_trab_unico;
    if length(ls_promotor) = 0 then
    begin
      gb_asignado := False;
      gs_trabid := '';
    end else
            gb_asignado := True;
end;

procedure Tfrm_nueva_venta.acCancelaExecute(Sender: TObject);
var
    frm : TFrm_reserva_cancela;
    frm_n : Tfrm_cancela_new;
begin
    gi_opcion := 11;
    insertaEvento(gs_trabid,gs_terminal,'Cancela reservacion');
    frm_n := Tfrm_cancela_new.Create(self);
    MostrarForma(frm_n);
end;

procedure Tfrm_nueva_venta.acCorteBanamexExecute(Sender: TObject);
var
 ssql : String;
 lQuery : TSQLQuery;
begin
//* Corte Banamex
 if (lbl_nombre.Caption = _NO_REGISTRADO) or (Length(Trim(gs_trab_unico)) = 0) then Begin
   ShowMessage('Debe de estar asignado a la venta para realizar este corte.');
   exit;
 end;

 lQuery := TSQLQuery.Create(nil);
 try
   lQuery.SQLConnection := CONEXION_VTA;
   ssql := 'SELECT C.FECHA_INICIO FROM PDV_T_CORTE AS C WHERE C.ID_EMPLEADO = ' +
           QuotedStr(gs_trab_unico) +
           ' AND C.FECHA_FIN IS NULL ORDER BY C.FECHA_INICIO LIMIT 1;';
   lQuery.SQL.Clear;
   lQuery.SQL.Add(ssql);
   lQuery.Open;
   if not lQuery.Eof then
     cortePinPadBanamex( lQuery.FieldByName('FECHA_INICIO').AsDateTime);
   lQuery.Close;
 finally
   lQuery.Free;
 end;
end;


procedure Tfrm_nueva_venta.acimprimevtaExecute(Sender: TObject);
var
  lfr_forma: Tfrm_anticipa_vender;
  ls_promotor: String;
begin
    gi_opcion := 26;
    if not gb_asignado then begin
        Mensaje('El usuario no esta asignado a la venta',1);
        gb_asignado := False;
        gs_trab_unico := '';
        exit;
    end;
    ls_promotor := '';
    ls_promotor := gs_trabid;
    if not AccesoPermitido(189, False) then
    begin
      gs_trabid := ls_promotor;
      exit;
    end;
    lfr_forma := Tfrm_anticipa_vender.Create(Self);
    MostrarForma(lfr_forma);
    gs_trabid := gs_trab_unico;
    if length(ls_promotor) = 0 then
    begin
      gb_asignado := False;
      gs_trabid := '';
    end else
      gb_asignado := True;
end;

procedure Tfrm_nueva_venta.acPruebaExecute(Sender: TObject);
var
    ls_ithaca : string;
    ls_OPOS   : string;
begin
    gi_opcion := 28;
    if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
      if gi_boleto_tamano = 0 then begin
         imprimirBoletoDatamax('', '', '', '', 'Prueba de impresion', '',
            Copy(Ahora(), 1, 10), '', 'PRUEBA DE IMPRESION', '', '', '',
            Copy(Ahora(), 12, 5), '', 'PRUEBA DE IMPRESION', 'PRUEBA DE IMPRESION',
            'PRUEBA DE IMPRESION', 'PRUEBA DE IMPRESION', 'PRUEBA DE IMPRESION',
            gs_puerto);
      end else begin
         imprimirBoletoDatamax101('', '', '', '', 'Prueba de impresion', '',
            Copy(Ahora(), 1, 10), '', 'PRUEBA DE IMPRESION', '', '', '',
            Copy(Ahora(), 12, 5), '', 'PRUEBA DE IMPRESION', 'PRUEBA DE IMPRESION',
            'PRUEBA DE IMPRESION', '', gs_puerto);
      end;
    end;
    if gs_impresora_boleto = _IMP_IMPRESORA_OPOS then begin
        ls_OPOS := inicializarImpresora_OPOS;
        ls_OPOS := ls_OPOS + textoAlineado_OPOS('PRUEBA DE IMPRESION', 'c');
        ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(0);
        ls_OPOS := ls_OPOS + corte_OPOS;
        escribirAImpresora(gs_impresora_boletos, ls_OPOS);
    end;

end;

procedure Tfrm_nueva_venta.acReimprimirVoucherExecute(Sender: TObject);
begin
  reimprimirUltimoVoucherBanamex;
end;

procedure Tfrm_nueva_venta.Action1Execute(Sender: TObject);
var
  lfr_password: TFrm_contrasena;
begin
    gi_opcion := 27;
    if not gb_asignado then begin
        Mensaje('El usuario no esta asignado a la venta',1);
        gb_asignado := False;
        gs_trab_unico := '';
        exit;
    end;
    lfr_password := TFrm_contrasena.Create(Self);
    MostrarForma(lfr_password);
end;

procedure Tfrm_nueva_venta.Action2Execute(Sender: TObject);
begin
  li_ctrl_asiento := 1; // variable para el control de asientos asignados
  gi_local_cuales := 0;
  limpiar_La_labels(ga_labels); // limpiamos las etiquetas
  Close;
end;


procedure Tfrm_nueva_venta.Action3Execute(Sender: TObject); var
   lfr_forma: Tfrm_venta_ultima;
   F: TextFile;
   ls_name, text, ls_promotor: string;
   li_idx: Integer;
begin
   if gb_asignado then begin
       try
           ls_promotor := '';
           ls_promotor := gs_trab_unico;
           if not AccesoPermitido(194, False) then
           begin
             gs_trabid := ls_promotor;
             exit;
           end;
           lfr_forma := Tfrm_venta_ultima.Create(nil);
           lfr_forma.cve_Empleado := gs_trab_unico;
           MostrarForma(lfr_forma);
       finally
         gs_trabid := gs_trab_unico;
         if length(ls_promotor) = 0 then
         begin
           gb_asignado := False;
           gs_trabid := '';
         end
         else
           gb_asignado := True;
       end;
   end else begin
        Mensaje('No se encuentra asignado a la venta',1);
        exit;
   end;
end;


procedure Tfrm_nueva_venta.Action4Execute(Sender: TObject);
var
  frm: Tfrm_calculadora;
begin
  frm := Tfrm_calculadora.Create(Self);
  MostrarForma(frm);
end;

procedure Tfrm_nueva_venta.Action5Execute(Sender: TObject);
var
  frm: Tfrm_calendario;
begin
  frm := Tfrm_calendario.Create(Self);
  MostrarForma(frm);
end;

procedure Tfrm_nueva_venta.Agrupar1Click(Sender: TObject);
var
  lfrm_forma: TFrm_corrida_agrupa;
  ls_promotor: string;
  li_row: Integer;
begin
    try
      gi_opcion := 2;
      ls_promotor := '';
      ls_promotor := gs_trab_unico;
      if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then begin
        gs_trabid := ls_promotor;
        exit;
      end;
      gli_agrupa_corrida := 0;
      lfrm_forma := TFrm_corrida_agrupa.Create(nil);
      li_row := stg_corrida.Row;
      lfrm_forma.ventaStringGrid := stg_corrida;
      lfrm_forma.li_row_corrida := stg_corrida.Row;
      lfrm_forma.ls_origen := ls_Origen_vta.CurrentID;
      MostrarForma(lfrm_forma);
      if gli_agrupa_corrida = 1 then begin
          GridDeleteRow(li_row, stg_corrida);
          FormShow(Sender);
          gli_agrupa_corrida := 0;
          pintaBusCorrida(li_row);
          insertaEvento(gs_trabid,gs_terminal,'agrupa corrida ' +
                        stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]+' '+
                        stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]+' '+
                        gs_trabid);

      end;
    finally
        gs_trabid := gs_trab_unico;
        if (length(ls_promotor) = 0) or (ls_promotor = '') then begin
            gb_asignado := False;
            gs_trabid := '';
        end else
            gb_asignado := True;
    end;
end;


procedure Tfrm_nueva_venta.Apartaasientos1Click(Sender: TObject);
var
  lfr_forma: Tfrm_aparta_lugares;
  frm_Ocupada: TFrm_Corrida_Ocupada;
  ls_ocupa, ls_promotor: String;
begin
    gi_opcion := 5;
    ls_promotor := '';
//    ls_promotor := gs_trabid;
    ls_promotor := gs_trab_unico;
    if not AccesoPermitido(205, False) then begin
      gs_trabid := ls_promotor;
      if length(ls_promotor) = 0 then begin
          gb_asignado := False;
          gs_trabid := '';
      end else begin
              gb_asignado := true;
      end;
     exit;
    end;
//revisar larios se pasa la terminal ver para que
    if estatus_corrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                      stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row], gs_terminal) <> 'A' then begin
      Mensaje('El estatus de la corrida no se encuentra abierta para la venta',1);
      exit;
    end;
    ls_ocupa := storeApartacorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                   StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),gs_terminal, gs_trabid);
    if ls_ocupa <> gs_trabid then begin
      frm_Ocupada := TFrm_Corrida_Ocupada.Create(Self);
      frm_Ocupada.corrida := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
      frm_Ocupada.fecha := stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row];
      frm_Ocupada.hora := stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row];
      MostrarForma(frm_Ocupada);
      if gi_corrida_en_uso > 0 then begin // salimos
        stg_corrida.Row := stg_corrida.Row;
        stg_corrida.Enabled := True;
        stg_corrida.SetFocus;
        gi_corrida_en_uso := 0;
        pintaBusCorrida(stg_corrida.Row);
        exit;
      end;
    end;
    lfr_forma := Tfrm_aparta_lugares.Create(nil);
    lfr_forma.TraficoGrid := stg_corrida;
    lfr_forma.li_row_corrida := stg_corrida.Row;
    MostrarForma(lfr_forma);
    pintaBusCorrida(stg_corrida.Row);

    gs_trabid := gs_trab_unico;
    if length(ls_promotor) = 0 then begin
        gb_asignado := False;
        gs_trabid := '';
    end else begin
            gb_asignado := true;
            gs_trabid := ls_promotor;
    end;
end;


procedure Tfrm_nueva_venta.arjetadeviaje1Click(Sender: TObject);
var
  lfrm_forma: Tfrm_guias_servicio;
  ls_promotor: String;
begin
  gi_opcion := 6;
  ls_promotor := '';
//  ls_promotor := gs_trabid;
  ls_promotor := gs_trab_unico;
  if not AccesoPermitido(154, False) then
  begin
    gs_trabid := ls_promotor;
    exit;
  end;
  insertaEvento(gs_trabid,gs_terminal,'Accede a la tarjeta de viaje ');
  valoresIniciales();
  lfrm_forma := Tfrm_guias_servicio.Create(nil);
  MostrarForma(lfrm_forma);
  gs_trabid := gs_trab_unico;
  if length(ls_promotor) = 0 then  begin
    gb_asignado := False;
    gs_trabid := '';
  end else
    gb_asignado := True;
end;


procedure Tfrm_nueva_venta.CorridaExtra1Click(Sender: TObject);
var
   lfrm_forma : TfrmExtras;
   ls_promotor : string;
begin
    gi_opcion := 10;
    ls_promotor := '';
    ls_promotor := gs_trab_unico;
    if not AccesoPermitido(176, False) then begin
       gs_trabid := ls_promotor;
       exit;
    end;
    insertaEvento(gs_trabid,gs_terminal,'Corrida Extra ');
    lfrm_forma := TfrmExtras.Create(self);
    MostrarForma(lfrm_forma);
    gs_trabid := gs_trab_unico;
    if length(ls_promotor) = 0 then begin
      gb_asignado := False;
      gs_trabid := '';
    end else
      gb_asignado := True;
end;

procedure Tfrm_nueva_venta.asignarseVenta;
var
  ls_ip, ls_taquilla, ls_status, ls_ip_qry: string;
  ls_qry: string;
  lf_forma: Tfrm_fondo_nuevo;
  lf_folio : Tfrm_folio_registro;
  lq_query: TSQLQuery;
begin
  lq_query := TSQLQuery.Create(nil);
  lq_query.SQLConnection := CONEXION_VTA;
  ac111.Enabled := False;
  ac116.Enabled := True;
  ac179.Enabled := True;
  acboleto.Enabled := True;
  acAnticipada.Enabled := True;
  acimprimevta.Enabled := True;
  ls_ip := GetIPList;
  gs_trab_unico := '';
  asignaVentaNew(gs_trabid, gs_terminal, StrToInt(gs_maquina));
  gs_trab_unico := gs_trabid;
  gb_asignado := True;
  TimerAsignado.Enabled := False;
  if gi_out_valida_asignarse = _E_ASIGNA_VTA_DUPLICADO then begin
      Mensaje('El usuario se encuentra asignado en otra taquilla', 1);
      gs_nombre_trabid := '';
      gs_trab_unico := '';
      gb_asignado := False;
      lbl_nombre.Caption := _NO_REGISTRADO;
      ls_Origen_.Visible := True;
      ac111.Enabled := True;
      ac116.Enabled := False;
      ac160.Enabled := False;
      ac179.Enabled := False;
      acboleto.Enabled := False;
      acAnticipada.Enabled := False;
      acimprimevta.Enabled := False;
      exit;
  end;
  if gi_out_valida_asignarse = _E_ASIGNA_PROCESO_CORTE then begin
      Mensaje('El usuario se encuentra en proceso de corte', 1);
      gs_nombre_trabid := '';
      gs_trab_unico := '';
      gb_asignado := False;
      lbl_nombre.Caption := _NO_REGISTRADO;
      ls_Origen_.Visible := True;
      ac111.Enabled := True;
      ac116.Enabled := False;
      ac160.Enabled := False;
      ac179.Enabled := False;
      acboleto.Enabled := False;
      acAnticipada.Enabled := False;
      acimprimevta.Enabled := False;
      exit;
  end;
  if gi_fondo_inicial_store = -1 then begin
    lf_forma := Tfrm_fondo_nuevo.Create(nil);
    MostrarForma(lf_forma);
    if VarIsNull(gi_fondo_inicial_store) then begin
      if EjecutaSQL(format(_VTA_CORTE_FONDO, ['0', gi_corte_store, gs_trab_unico]), lq_query, _LOCAL) then
    end else begin//nuevo se imprime la carga inicial
               if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
//                    ImprimeCargaInicial(gs_trab_unico,'Inicial');
                    gli_carga := 1;
               end else
                      ac160.Enabled := False;
    end;
  end;
  if gi_impresion_carga = 0 then begin
      if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
          ImprimeCargaInicial(gs_trab_unico,'Inicial');
          gli_carga := 1;
          if EjecutaSQL(format(_VTA_CORTE_IMPRESION, [gi_corte_store, gs_trab_unico]), lq_query, _LOCAL) then
                ;
      end;
  end;

  if gi_fondo_inicial_store >= 0 then begin
    gb_fondo_ingresado_new := True;
    gb_asignado := True;
  end;
  if gb_fondo_ingresado_new = False then begin /// cuando se sale
     Mensaje('Se asigno a la venta sin registrar un fondo incial', 1);
     gs_nombre_trabid := '';
     gs_trab_unico := '';
     gs_fondo_inicial_new := '0';
     if EjecutaSQL(format(_VTA_CORTE_FONDO, ['0', gi_corte_store, gs_trab_unico]), lq_query, _LOCAL) then begin
          if gs_impresora_boleto = _IMP_TOSHIBA_TEC then begin
             ImprimeCargaInicial(gs_trab_unico,'Inicial');
             gli_carga := 1;
           end else
                  ac160.Enabled := False;
     end;
  end;

  if gi_fondo_inicial_store = -1 then begin // solicitamos el fondo inicial
    if EjecutaSQL(format(_VTA_CORTE_FONDO, [gs_fondo_inicial_new,
        gi_corte_store, gs_trab_unico]), lq_query, _LOCAL) then
      Gr_Corridas.Enabled := True;
  end;
  if gb_asignado then ac160.Enabled := True;

  TimerAsignado.Enabled := True;
  Gr_Corridas.Enabled := True;//FOLIOS

  if gli_carga = 0 then
      ac160.Caption := 'Imprime Carga Inicial';
  if gli_carga = 1 then
          ac160.Caption := 'Imprime Carga Final';
//  insertaEvento(gs_trab_unico,gs_terminal,'Se asigna a la venta usuario '+ gs_trab_unico);
  lq_query.Free;
  lq_query := nil;
end;



procedure Tfrm_nueva_venta.Cerrarcorrida1Click(Sender: TObject);
var
  ls_promotor, hora, sentencia : string;
  li_total, li_num : Integer;
  la_datos: gga_parameters;
  lq_qry: TSQLQuery;
  ThreadQuerys : Libera_Asientos;
begin
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
    exit;
  try
    gi_opcion := 4;
    ls_promotor := '';
//    ls_promotor := gs_trabid;
    ls_promotor := gs_trab_unico;
    li_total := existeVentaDeCorrida(StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                                     StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                                     stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],     // _COL_SERVICIO
                                     StrToInt(stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[stg_corrida.Row])
                                     );
    if li_total > 0 then begin
      MessageDlg(PWideChar(format(_MSG_ERROR_EXISTE_VENTA_CORRIDA, [li_total,
                          stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]])), mtInformation, [mbOK], 0);
      exit;
    end;

    if not AccesoPermitido(184, False) then
    begin
      gs_trabid := ls_promotor;
      exit;
    end;


    if Application.MessageBox(PChar(format(_MSG_CERRAR_CORRIDA,[stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]])),
      'Confirme', _CONFIRMAR) = IDYES then begin
      splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row], ' ',la_datos, li_num);
      if li_num = 0 then
        hora := la_datos[0]
      else
        hora := la_datos[1];
      lq_qry := TSQLQuery.Create(nil);
      lq_qry.SQLConnection := CONEXION_VTA;
      if EjecutaSQL(format(_STATUS_CORRIDA_VENTA, ['C', stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
          formatDateTime('YYYY-MM-DD', StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
          hora, stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]]), lq_qry, _RUTA) then
      begin
        sentencia := Format(_STATUS_CORRIDA_ELEGIDA,['C',stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                                       formatDateTime('YYYY-MM-DD', StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                                                       stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]
                                                  ]);
        ThreadQuerys := Libera_Asientos.Create(true);
        ThreadQuerys.server := CONEXION_VTA;
        ThreadQuerys.sentenciaSQL := sentencia;
        ThreadQuerys.ruta   := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
        ThreadQuerys.origen := gs_terminal;
        ThreadQuerys.destino := stg_corrida.Cols[_COL_DESTINO].Strings[stg_corrida.Row];
        ThreadQuerys.Priority := tpNormal;
        ThreadQuerys.FreeOnTerminate := True;
        ThreadQuerys.start;
        Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS, 2);
        GridDeleteRow(stg_corrida.Row, stg_corrida);
        pintaBusCorrida(stg_corrida.Row);
        insertaEvento(gs_trabid,gs_terminal,'Cierra corrida ' +
                      stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]+' '+
                      stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]+' '+
                      gs_trabid);

      end;
      lq_qry.Free;
      lq_qry := nil;
    end;
  finally
    gs_trabid := gs_trab_unico;
    if length(ls_promotor) = 0 then begin
      gb_asignado := False;
      gs_trabid := '';
    end else
      gb_asignado := True;
  end;
end;


procedure Tfrm_nueva_venta.consigueCorridas;
var
  li_idx, li_num: Integer;
  ls_char: Char;
  li_ctrl_asiento, ls_server: string;
  la_datos: gga_parameters;
begin
  TRefrescaCorrida.Enabled := False;
  ls_servicioExit(nil);
  if not valida_Busqueda_Corrida then
    exit;
  if length(ls_Origen_vta.text) <> 0 then
    lsOrigen := ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf
      (ls_Origen_vta.text)]
  else
    lsOrigen := '';
  if length(ls_Desde_vta.text) <> 0 then begin
    try
      lsDestino := ls_Desde_vta.IDs[ls_Desde_vta.Items.IndexOf(ls_Desde_vta.text)];
    except
        Mensaje('Verifique el destino',1);
        ls_Desde_vta.ItemIndex := -1;
        exit;
    end;
  end else begin
            lsDestino := '';
           end;
  if (length(Ed_Hora.text) > 0) or (ls_servicio.ItemIndex >= 0) or
     (length(edt_corrida.text) > 0) then begin
          gs_terminal_ruta := lsOrigen;
          corridasParametrosVenta(lsOrigen, lsDestino, medt_fecha.text, Ed_Hora.text,ls_servicio.CurrentID, 1, stg_corrida, edt_corrida.text);
  end else begin// agregamos el detalle de la ruta
              gs_terminal_ruta := lsOrigen;
              corridasParametrosVenta(lsOrigen, lsDestino, medt_fecha.text, '', '', 0,stg_corrida, ''); // mostramos la corrida
              stg_corrida.Enabled := True;
              stg_corrida.SetFocus;
  end;
  if gi_select_corrida = 0 then begin
    splitLine(ls_Origen_vta.text, '-', la_datos, li_num);
    ls_server := la_datos[1];
    if CONEXION_VTA <> DM.Conecta then begin
      splitLine(ls_Origen_vta.text, '-', la_datos, li_num);
      ls_server := la_datos[1];
    end;
    Mensaje(format(_MSG_NO_HAY_CORRIDAS, [medt_fecha.text, ls_server,gs_descripcion_lugar]), 0);
    medt_fecha.SetFocus;
    exit;
  end;
  pintaBusCorrida(gi_select_corrida); // pintamos el autobus
  stg_corrida.Row := gi_select_corrida;
end;



procedure Tfrm_nueva_venta.disableTextInput;
begin
  ls_Origen_vta.Enabled := False;
  ls_Desde_vta.Enabled := False;
  ls_servicio.Enabled := False;
  edt_corrida.Enabled := False;
  Ed_Hora.Enabled := False;
  medt_fecha.Enabled := False;
end;

procedure Tfrm_nueva_venta.enableTextInput;
begin
  if gi_operacion_remota = 1 then
      ls_Origen_vta.Enabled := True;
  ls_Desde_vta.Enabled := True;
  ls_servicio.Enabled := True;
  edt_corrida.Enabled := True;
  Ed_Hora.Enabled := True;
  medt_fecha.Enabled := True;
end;

procedure Tfrm_nueva_venta.FormActivate(Sender: TObject);
var
  li_flujo: Integer;
begin
  stb_venta.Panels[0].text := 'F1 Buscar';
  stb_venta.Panels[1].text := 'F2 Elegir ciudad Origen';
  stb_venta.Panels[2].text := 'F3 Elegir ciudad Destino';
  stb_venta.Panels[3].text := 'F4 Ultima venta realizada';
  stb_venta.Panels[4].text := 'F5 Cancela venta (Otra)';

  if gi_seleccion = _VENTA_INICIO_NUEVA then begin
    grp_cuales.Visible := False;
    lbledt_cuales.Clear;
    try
      grp_asientos.Visible := False;
      grp_corridas.Visible := True;
    except
    end;
    gi_local_cuales := 0;
    for li_flujo := low(asientos_pago) to high(asientos_pago) do begin
      asientos_pago[li_flujo].corrida := '';
      asientos_pago[li_flujo].asiento := 0;
      asientos_pago[li_flujo].fecha_hora := '';
      asientos_pago[li_flujo].empleado := '';
      asientos_pago[li_flujo].origen := '';
      asientos_pago[li_flujo].destino := '';
      asientos_pago[li_flujo].status := ' ';
    end;
  end;
  medt_fecha.SelStart := 0;

end;

procedure Tfrm_nueva_venta.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (gb_asignado) and (length(gs_trabid) > 0) then
    ac116Execute(Sender);

  Timer_guias.Enabled := False;
  BorraArregloAsientos(asientos_pago);
  gb_asignado := False; // salir de la venta
  CONEXION_VTA := DM.Conecta;
  try
    if CONEXION_REMOTO <> nil then
    begin
      CONEXION_REMOTO.Destroy;
    end;
  except
    CONEXION_REMOTO := nil;
  end;
  TRefrescaCorrida.Enabled := False;
  if Assigned(pingHilo) then begin
      TerminateThread(pingHilo.Handle,0);
      Tping.Enabled := False;
  end;
  gi_imagen_servicio := 0;
  Close;
end;


procedure Tfrm_nueva_venta.FormCreate(Sender: TObject);
begin
  gi_local_cuales := 0;
  ga_labels[1] := Addr(Label100);
  ga_labels[2] := Addr(Label101);
  ga_labels[3] := Addr(Label102);
  ga_labels[4] := Addr(Label103);
  ga_labels[5] := Addr(Label104);
  ga_labels[6] := Addr(Label105);
  ga_labels[7] := Addr(Label106);
  ga_labels[8] := Addr(Label107);
  ga_labels[9] := Addr(Label108);
  ga_labels[10] := Addr(Label109);
  ga_labels[11] := Addr(Label110);
  ga_labels[12] := Addr(Label111);
  ga_labels[13] := Addr(Label112);
  ga_labels[14] := Addr(Label113);
  ga_labels[15] := Addr(Label114);
  ga_labels[16] := Addr(Label115);
  ga_labels[17] := Addr(Label116);
  ga_labels[18] := Addr(Label117);
  ga_labels[19] := Addr(Label118);
  ga_labels[20] := Addr(Label119);
  ga_labels[21] := Addr(Label120);
  ga_labels[22] := Addr(Label121);
  ga_labels[23] := Addr(Label122);
  ga_labels[24] := Addr(Label123);
  ga_labels[25] := Addr(Label124);
  ga_labels[26] := Addr(Label125);
  ga_labels[27] := Addr(Label126);
  ga_labels[28] := Addr(Label127);
  ga_labels[29] := Addr(Label128);
  ga_labels[30] := Addr(Label129);
  ga_labels[31] := Addr(Label130);
  ga_labels[32] := Addr(Label131);
  ga_labels[33] := Addr(Label132);
  ga_labels[34] := Addr(Label133);
  ga_labels[35] := Addr(Label134);
  ga_labels[36] := Addr(Label135);
  ga_labels[37] := Addr(Label136);
  ga_labels[38] := Addr(Label137);
  ga_labels[39] := Addr(Label138);
  ga_labels[40] := Addr(Label139);
  ga_labels[41] := Addr(Label140);
  ga_labels[42] := Addr(Label141);
  ga_labels[43] := Addr(Label142);
  ga_labels[44] := Addr(Label143);
  ga_labels[45] := Addr(Label144);
  ga_labels[46] := Addr(Label145);
  ga_labels[47] := Addr(Label146);
  ga_labels[48] := Addr(Label147);
  ga_labels[49] := Addr(Label148);
  ga_labels[50] := Addr(Label149);
  ga_labels[51] := Addr(Label150);
end;

procedure Tfrm_nueva_venta.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  la_datos: gga_parameters;
  li_num, li_ctrl_grid: Integer;
  ls_mensaje_ocupante: string;
  frm: Tfrm_nueva_pagoF;
begin
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key := 0;
  if (Key = VK_RETURN) and (gi_local_cuales = 2) then begin // cuales con descuentos y pasa a la forma de pago
    gds_ocupantes_asignados := TDualStrings.Create();
    ls_mensaje_ocupante := validaCualesOcupantes(lbledt_tipo.text);
    if length(ls_mensaje_ocupante) > 0 then
    begin
      Mensaje(ls_mensaje_ocupante, 0);
      lbledt_tipo.Clear;
      lbledt_tipo.SetFocus;
      lbledt_tipo.SelStart := length(lbledt_tipo.text);
      exit;
    end else begin
      recalculaPrecioConDescuento(asientos_pago);
      for li_num := gi_arreglo to 50 do begin
        if asientos_pago[li_num].corrida <> '' then begin
          asientos_pago[li_num].calculado := 1;
          inc(gi_arreglo);
        end;
      end;
      if length(lbledt_cuales.text) = 0 then begin
        lbledt_cuales.SetFocus;
        gi_local_cuales := 0;
        exit;
      end;
      apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                    StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
      split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]),
      ls_Origen_vta.CurrentID, gs_trabid,
      StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
      frm := Tfrm_nueva_pagoF.Create(nil);
      frm.vendidos := asientos_pago;
      MostrarForma(frm);
      gi_control_pago := 0;
      asientos_pago := asientos_regreso;
      enableTextInput();
      pintaBusCorrida(stg_corrida.Row);
      lbledt_cuales.Clear;
      lbledt_tipo.Clear;
      lbledt_cuales.text := ' ';
      grp_asientos.Visible := False;
      grp_corridas.Visible := True;
      gi_local_cuales := 0;
      li_corrida_seleccionada := 0;
      stg_corrida.Enabled := True;
      stg_corrida.SetFocus;
      keybd_event(VK_ESCAPE, 1, 0, 0);
    end;
  end;

  if Key = VK_F1 then begin
    splitLine(ls_Origen_vta.text, '-', la_datos, li_num);
    TRefrescaCorrida.Enabled := True;
    consigueCorridas();
  end;
  if (Key = VK_F12) and (ls_Origen_vta.Enabled) then begin
    ls_Origen_vta.SetFocus;
    ls_Desde_vta.ItemIndex := -1;
    Ed_Hora.Clear;
    ls_servicio.ItemIndex := -1;
    edt_corrida.Clear;
    medt_fecha.SelStart := 0;
    exit;
  end;

  if (Key = VK_F2) and (ls_Origen_vta.Enabled) then begin
    ls_Origen_vta.SetFocus;
    ls_Desde_vta.ItemIndex := -1;
    Ed_Hora.Clear;
    ls_servicio.ItemIndex := -1;
    edt_corrida.Clear;
    exit;
  end;

  if (Key = vk_f3) and (ls_Desde_vta.Enabled) then begin
    ls_Desde_vta.ItemIndex := -1;
    Ed_Hora.Clear;
    ls_servicio.ItemIndex := -1;
    ls_Desde_vta.SetFocus;
    edt_corrida.Clear;
    medt_fecha.SelStart := 0;
    exit;
  end;

  if (Key = VK_F4) and (CORRIDA_ULTIMA_VTA.origen <> '') then begin
    corridasParametros(CORRIDA_ULTIMA_VTA.origen, CORRIDA_ULTIMA_VTA.destino,
      CORRIDA_ULTIMA_VTA.fecha, '', '', 0, stg_corrida, '');
    for li_ctrl_grid := 1 to stg_corrida.RowCount - 1 do begin
      if ((CORRIDA_ULTIMA_VTA.destino = stg_corrida.Cols[_COL_DESTINO].Strings
            [li_ctrl_grid]) and (CORRIDA_ULTIMA_VTA.corrida = stg_corrida.Cols
            [_COL_CORRIDA].Strings[li_ctrl_grid])) then begin
        break;
      end;
    end;
    ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(CORRIDA_ULTIMA_VTA.origen);
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(CORRIDA_ULTIMA_VTA.servicio);
    ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(CORRIDA_ULTIMA_VTA.destino);
    medt_fecha.text := CORRIDA_ULTIMA_VTA.fecha;
    Ed_Hora.text := CORRIDA_ULTIMA_VTA.hora;
    edt_corrida.text := CORRIDA_ULTIMA_VTA.corrida;
    pintaBusCorrida(li_ctrl_grid);
    stg_corrida.Row := li_ctrl_grid;
    gi_local_cuales := 0;
  end;

  if (Key = vk_f5) and (gi_arreglo > 1) then begin
    enableTextInput();
    lbledt_cuales.text := ' ';
    lbledt_tipo.Clear;
    lblEdt_cuantos.Clear;
    grp_asientos.Visible := False;
    grp_asientos.Visible := False;
    grp_corridas.Visible := True;
    stg_corrida.Enabled := True;
    stg_corrida.SetFocus;
    li_corrida_seleccionada := 0;
    gi_arreglo := 1; // contador general borrar los registros que esten el la tabla de asientos
    gi_local_cuales := 0;
    gi_idx_asientos := 1;
    gi_arreglo := 1;
    li_ctrl_asiento := 0;
    li_memoria_cuales := 0;
    BorraArregloAsientos(asientos_pago);
    BorraArregloLibera(asientos_pago);
    Mensaje('Se ha liberado la venta', 2);
    pintaBusCorrida(stg_corrida.Row);
  end;

  if (Key = vk_f5) and (li_corrida_seleccionada = 1) then begin
    enableTextInput();
    lbledt_cuales.text := ' ';
    lbledt_tipo.Clear;
    lblEdt_cuantos.Clear;
    grp_asientos.Visible := False;
    grp_asientos.Visible := False;
    grp_corridas.Visible := True;
    stg_corrida.Enabled := True;
    stg_corrida.SetFocus;
    li_corrida_seleccionada := 0;
    apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
      StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]),
      ls_Origen_vta.CurrentID, gs_trabid,StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
    gi_arreglo := 1; // contador general borrar los registros que esten el la tabla de asientos
    gi_local_cuales := 0;
    gi_idx_asientos := 1;
    gi_arreglo := 1;
    li_ctrl_asiento := 0;
    BorraArregloAsientos(asientos_pago);
    pintaBusCorrida(stg_corrida.Row);
  end;

  if (Key = VK_F8) and (li_corrida_seleccionada = 1) then begin
    if gi_vta_pie = 1 then
        exit;
    lblEdt_cuantos.Visible := False;
    grp_cuales.Visible := True;
    lbledt_cuales.Clear;
    lbledt_cuales.SetFocus;
  end;

  if (Key = VK_F7) and (li_corrida_seleccionada = 1) then begin
    lblEdt_cuantos.EditLabel.Caption := 'Cuantos :';
    lbledt_cuales.Clear;
    lbledt_tipo.Clear;
    lblEdt_cuantos.Clear;
    grp_corridas.Visible := False;
    lbledt_cuales.text := ' ';
    grp_cuales.Visible := False;
    grp_asientos.Visible := True;
    lblEdt_cuantos.Visible := True;
    lblEdt_cuantos.SetFocus;
  end;

end;


procedure Tfrm_nueva_venta.FormShow(Sender: TObject);
var
    lq_qry1 : TSQLQuery;
begin

  if gi_operacion_remota = 1 then
      ls_Origen_vta.Enabled := True
  else
      ls_Origen_vta.Enabled := False;

//para el intervalo del ping al server central
  Tping.Interval := gi_tiempo_ping;
  Tping.Enabled := True;

  CONEXION_VTA := DM.Conecta;
  gb_venta_remota := False;
  gs_descripcion_lugar := getDescripcionTerminal(gs_terminal);
  llenaPosicionLugares();
  if lbl_nombre.Caption = _NO_REGISTRADO then
      lbl_nombre.Caption := _NO_REGISTRADO;
  llenarArregloCaracteres(); // llenamso caracteres en los arreglos
  Titles(); // titulos del grid
  llenamosDatosInicio(); // llenamos datos inciales
  limpiar_La_labels(ga_labels);
  limpiaEntrada();
  llenaOcupantesSAdulto();
  gi_arreglo := 1; // contador general
  gi_seleccion_venta := _VENTA_INICIO_NUEVA;
  timer_pintabus.Interval := _RETRADADO;
  li_tecla_espera := tiempo_Espera_Grid();
  li_activo_refresh := tiempo_refresh_Grid();
  medt_fecha.SelStart := 0;
  buscaOcupantes(stg_listaOcupantes, 0);
  gi_control_pago := 0;
  lq_qry1 := TSQLQuery.Create(nil);
  lq_qry1.SQLConnection := DM.Conecta;
  if EjecutaSQL('SELECT (EXTRACT(HOUR FROM CURTIME()))AS HORA,(EXTRACT(MINUTE FROM CURTIME())) AS MINUTO, '+
                '(EXTRACT(SECOND FROM CURTIME()))AS SEGUNDO;',lq_qry1, _LOCAL) then begin
      stb_venta.Panels[6].text := IntToStr(lq_qry1['HORA'])+':'+IntToStr(lq_qry1['MINUTO'])+':'+IntToStr(lq_qry1['SEGUNDO']);
      li_hora := lq_qry1['HORA'];
      li_minuto := lq_qry1['MINUTO'];
      li_segundo := lq_qry1['SEGUNDO'];
  end;
  if not Timer_guias.Enabled then
  begin
      Timer_guias.Enabled := False;
      Timer_guias.Interval := 60000 * gi_guia_procesa;
      Timer_guias.Enabled := True;
  end;

  if gi_conexion_server = 1 then begin
//            image_servidorCentral(img_central, mem_conectado);
{{        pingHilo := TPingServer.Create(true);
        pingHilo.memo  := mem_conectado;
        pingHilo.image := img_central;
        pingHilo.Priority := tpTimeCritical;
        pingHilo.FreeOnTerminate := true;
        pingHilo.Resume; }
  end;

  lq_qry1.Free;
  lq_qry1 := nil;

end;



procedure Tfrm_nueva_venta.lbledt_cualesChange(Sender: TObject);
var
  li_ctrl_input, li_ajusta: Integer;
  lc_char: Char;
  ls_input, ls_out, ls_anterior: String;
  lb_write: Boolean;
begin
  lb_write := False;
  li_ajusta := 0;
  ls_input := lbledt_cuales.text;
  for li_ctrl_input := 1 to length(ls_input) do begin
    lc_char := ls_input[li_ctrl_input];
    if not existe(lc_char) then begin
      lb_write := True;
      break;
    end; // sustituir caracter , por space
    if lc_char = ga_separador[1] then begin
      lbledt_cuales.text := reWrite(ls_input) + ' ';
    end;
    if li_ctrl_input > 1 then begin
      ls_anterior := ls_input[li_ctrl_input - 1];
      if ((ls_input[li_ctrl_input - 1] = ' ') and
          (ls_input[li_ctrl_input] = '-')) or
        ((ls_input[li_ctrl_input - 1] = '-') and
          (ls_input[li_ctrl_input] = ' ')) or
        ((ls_input[li_ctrl_input - 1] = ' ') and
          (ls_input[li_ctrl_input] = ' ')) then
        li_ajusta := 1;
    end; // fin li_ctrl
  end;
  if lb_write then
    lbledt_cuales.text := reWrite(ls_input);

  if li_ajusta = 1 then begin
    for li_ctrl_input := 1 to length(ls_input) - 2 do begin
      ls_out := ls_out + ls_input[li_ctrl_input];
    end; // fin for
    lbledt_cuales.text := ls_out + '-';
  end;
  lbledt_cuales.SelStart := length(lbledt_cuales.text);
end;


procedure Tfrm_nueva_venta.lbledt_cualesEnter(Sender: TObject);
var
  li_ctrl_mem, li_ctr_ext, li_ctrl_out: Integer;
  ga_datos : gga_parameters;
  ls_hora  : string;
begin
  if li_memoria_cuales = 1 then begin
    for li_ctrl_mem := 0 to gi_idx_asientos - 1 do begin
        splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row],' ',ga_datos,li_ctrl_out);
        if li_ctrl_out > 0 then ls_hora := ga_datos[1]
        else ls_hora := ga_datos[0];

        li_ctrl_asiento := li_ctrl_asiento - BorraArregloLiberaMemoria
                           (asientos_pago, formatDateTime('YYYY-MM-DD',
                           StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]))
                           + ' ' + formatDateTime('HH:nn',
                           StrToTime(ls_hora)),
                           stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                           memoria_cuales[li_ctrl_mem]);
    end;
    if li_ctrl_asiento = 1 then begin
      li_ctrl_asiento := 0;
    end;
    lbledt_tipo.Clear;
    lbledt_cuales.Clear;
    lbledt_cuales.SetFocus;
    li_memoria_cuales := 0;
  end;
  pintaBusCorrida(stg_corrida.Row);
  li_memoria_cuales := 0;
end;


procedure Tfrm_nueva_venta.lbledt_cualesExit(Sender: TObject);
begin
  pintaBusCorrida(stg_corrida.Row);
  cuales_primer_paso();
end;




procedure Tfrm_nueva_venta.cuales_primer_paso;
var
  la_unicos, la_rangos: gga_parameters;
  li_num, li_ctrl, li_new_ctrl, li_idx_valida: Integer;
  ls_mensaje_ocupante: string;
  array_cuales: ga_asientos;
  lb_asientos_ok: Boolean;
  store: TSQLStoredProc;
begin
  if length(lbledt_cuales.text) = 0 then begin
    Mensaje(_ASIENTOS_VACIO, 1);
    lbledt_cuales.SetFocus;
    gi_local_cuales := 0;
    exit;
  end;
  splitLine(lbledt_cuales.text, ' ', la_unicos, li_num);
  gi_idx_asientos := 0;
  lb_asientos_ok := False;
  for li_ctrl := 0 to li_num do begin
    if not rangoAsientos(la_unicos[li_ctrl]) then begin // si no son por rango
      if la_unicos[li_ctrl] = '' then
        exit;
      array_cuales[gi_idx_asientos] := StrToInt(la_unicos[li_ctrl]);
      inc(gi_idx_asientos);
    end else begin
      splitLine(la_unicos[li_ctrl], '-', la_rangos, li_num);
      for li_new_ctrl := StrToInt(la_rangos[0]) to StrToInt(la_rangos[1]) do
      begin
        array_cuales[gi_idx_asientos] := li_new_ctrl;
        inc(gi_idx_asientos); // para el procedimiento
      end;
    end;
  end; // fin for

  if validaDobles(array_cuales) then begin
      Mensaje('Ha ingresado dos asientos identicos',1);
      lbledt_cuales.Clear;
      lbledt_cuales.SetFocus;
      exit;
  end;

  //validamos que
  for li_idx_valida := 0 to high(array_cuales) do begin
    if array_cuales[li_idx_valida] > StrToInt
      (stg_corrida.Cols[_COL_ASIENTOS].Strings[stg_corrida.Row]) then begin
      lb_asientos_ok := True;
      break;
    end;
  end; // validamos el arreglo
  for li_idx_valida := 0 to gi_idx_asientos - 1 do begin
    if array_cuales[li_idx_valida] = 0 then begin
      Mensaje('No se pueden vender asientos "0"', 1);
      gi_local_cuales := 0;
      lbledt_cuales.Clear;
      lbledt_cuales.SetFocus;
      exit;
    end;
  end;
  if gi_idx_asientos = 0 then begin
    Mensaje('Verifique los asientos a vender', 1);
    gi_local_cuales := 0;
    lbledt_cuales.Clear;
    lbledt_cuales.SetFocus;
    exit;
  end;
  if gi_idx_asientos > gi_permitido_cupo then begin
    Mensaje(_MSG_VTA_PIE_LIMITE + #10#13 +
        ' se ha excedido el cupo permitido : ' + IntToStr(gi_permitido_cupo),0);
    lbledt_cuales.Clear;
    lbledt_cuales.SetFocus;
    gi_local_cuales := 0;
    exit;
  end;
  if lb_asientos_ok then begin
    Mensaje(_MSG_ASIENTO_MAYOR_PERMITIDO, 0);
    apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                  StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                  split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]),
                  ls_Origen_vta.CurrentID, gs_trabid,
                  StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
    lbledt_cuales.Clear;
    lbledt_cuales.SetFocus;
    gi_local_cuales := 0;
    exit;
  end; // valida que el numero de asiento sea permitido por el bus
  for li_ctrl := 0 to gi_idx_asientos - 1 do begin
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA;
    store.close;
    store.StoredProcName := 'PDV_STORE_BUSCA_TOTAL_CUALES';

    store.Params.ParamByName('IN_FECHA').AsString := formatDateTime('YYYY-MM-DD',
                                  StrToDateTime(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]));
    store.Params.ParamByName('IN_CORRIDA').AsString := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
    store.Params.ParamByName('IN_ASIENTOS').AsString := IntToStr(array_cuales[li_ctrl]);
    store.Open;
    lb_asientos_ok := False;
    if store['TOTAL'] > 0 then begin
      lb_asientos_ok := True;
      break;
    end;
    store.Free;
    store := nil;
  end;
  if lb_asientos_ok then begin
    Mensaje('Los lugares se encuentran ocupados o reservados', 1);
    lbledt_cuales.Clear;
    lbledt_cuales.SetFocus;
    gi_local_cuales := 0;
    exit;
  end;
  gi_ruta := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
  if li_ctrl_asiento = 0 then
    li_ctrl_asiento := gi_arreglo;
  procesoVentaCuales(array_cuales, gi_idx_asientos,stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row], // corrida
                     formatDateTime('YYYY-MM-DD', StrToDate(medt_fecha.text))
                     + ' ' + Ed_Hora.text,ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf(ls_Origen_vta.text)],
                     ls_Desde_vta.IDs[ls_Desde_vta.Items.IndexOf(ls_Desde_vta.text)], gs_trab_unico,
                     stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[stg_corrida.Row],
                     StrToFloat(stg_corrida.Cols[_COL_TARIFA].Strings[stg_corrida.Row]),
                     asientos_pago, StrToInt(gs_maquina),
                     gi_cobro_con_iva,
                     StrToFloat(stg_corrida.Cols[_COL_IVA].Strings[stg_corrida.Row]));
  gi_idx_asientos := li_ctrl_asiento - 1;
  memoria_cuales := array_cuales;
  pintaBusCorrida(stg_corrida.Row);
  gi_local_cuales := 2;
end;



procedure Tfrm_nueva_venta.lbledt_cualesKeyPress(Sender: TObject;
  var Key: Char);
var
  la_unicos, la_rangos: gga_parameters;
  li_num, li_ctrl, li_new_ctrl, li_idx_valida: Integer;
  ls_str_store, ls_mensaje_ocupante: string;
  array_cuales: ga_asientos;
  lb_asientos_ok: Boolean;
  store: TSQLStoredProc;
  frm: Tfrm_nueva_pagoF;
begin// validamos los asientos que tiene elegidos

  if not(Key = #13) then begin
    gi_local_cuales := 0;
    exit;
  end;
  if length(lbledt_cuales.text) = 0 then begin
    Mensaje(_ASIENTOS_VACIO, 1);
    lbledt_cuales.SetFocus;
    gi_local_cuales := 0;
    exit;
  end;

  if length(lbledt_cuales.text) = 0 then begin
    Mensaje(_ASIENTOS_VACIO, 1);
    lbledt_cuales.SetFocus;
    gi_local_cuales := 0;
    exit;
  end;

  cuales_primer_paso();
  if gi_local_cuales = 0 then
    exit;
  gds_ocupantes_asignados := TDualStrings.Create();
  ls_mensaje_ocupante := validaCualesOcupantes(lbledt_tipo.text);
  if length(ls_mensaje_ocupante) > 0 then begin
      Mensaje(ls_mensaje_ocupante, 0);
      lbledt_tipo.Clear;
      lbledt_tipo.SetFocus;
      lbledt_tipo.SelStart := length(lbledt_tipo.text);
      exit;
  end else begin
            recalculaPrecioConDescuento(asientos_pago);
            for li_num := gi_arreglo to 50 do begin
              if asientos_pago[li_num].corrida <> '' then begin
                asientos_pago[li_num].calculado := 1;
                inc(gi_arreglo);
              end;
  end;
  apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]),
                ls_Origen_vta.CurrentID, gs_trab_unico,//gs_trabid,
                StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
  frm := Tfrm_nueva_pagoF.Create(nil);
  frm.vendidos := asientos_pago;
  MostrarForma(frm);
  asientos_pago := asientos_regreso;
  enableTextInput();
  pintaBusCorrida(stg_corrida.Row);
  lbledt_cuales.Clear;
  lbledt_tipo.Clear;
  lbledt_cuales.text := ' ';
  grp_asientos.Visible := False;
  grp_corridas.Visible := True;
  gi_local_cuales := 0;
  li_corrida_seleccionada := 0;
  stg_corrida.Enabled := True;
  stg_corrida.SetFocus;
  keybd_event(VK_ESCAPE, 1, 0, 0);
  end;
end;


procedure Tfrm_nueva_venta.lblEdt_cuantosEnter(Sender: TObject);
begin
    gi_local_cuales := 0;
end;

procedure Tfrm_nueva_venta.lblEdt_cuantosExit(Sender: TObject);
begin
    lblEdt_cuantos.Clear;
end;


procedure Tfrm_nueva_venta.lblEdt_cuantosKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_fecha_corrida_hora, ls_mensaje: string;
  li_numero_asientos, li_asientos_insertados: Integer;
  lb_asientos_ok: Boolean;
  frm: Tfrm_nueva_pagoF;
begin
  if Key = #13 then begin // enter
    if length(lblEdt_cuantos.text) = 0 then begin
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end; // validamos para la venta de pie
    if lblEdt_cuantos.text = '0' then begin
      Mensaje('Seleccione un lugar correcto', 1);
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end;
    try
       if (StrToInt(lblEdt_cuantos.text) > 0) then
          ;
    except
        on E : EconvertError  do begin
            Mensaje('Ingrese un valor permitido "Numerico"',1);
            lblEdt_cuantos.Clear;
            lblEdt_cuantos.SetFocus;
            exit;
        end;
    end;
    if (StrToInt(lblEdt_cuantos.text) > gi_solo_pie) and (gi_vta_pie = 1) then begin
      Mensaje(_MSG_VTA_PIE_LIMITE, 0);
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end;
    if StrToInt(lblEdt_cuantos.text) > gi_permitido_cupo then begin
      Mensaje(_MSG_VTA_PIE_LIMITE + #10#13 +' se ha excedido el cupo permitido : ' + IntToStr(gi_permitido_cupo),0);
      lblEdt_cuantos.text := IntToStr(gi_permitido_cupo);
      lblEdt_cuantos.SelStart := length(lblEdt_cuantos.text);
      lblEdt_cuantos.SetFocus;
      exit;
    end;
    gi_local_cuales := 0;
    li_numero_asientos := StrToInt(stg_corrida.Cols[_COL_ASIENTOS].Strings
        [stg_corrida.Row]);
    if (StrToInt(lblEdt_cuantos.text) > li_numero_asientos)  and (gi_vta_pie = 0 )then begin
      Mensaje(_MSG_ASIENTO_MAYOR_PERMITIDO, 0);
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end; // valida que el numero de asiento sea permitido por el bus comparamos el numero de boletos solicitado  y el existente y disponible
    ls_fecha_corrida_hora := formatDateTime('YYYY-MM-DD',
    StrToDate(medt_fecha.text)) + ' ' + Ed_Hora.text;
    if li_ctrl_asiento = 0 then li_ctrl_asiento := gi_arreglo;
    procesoVentaCuantos(gi_permitido_cupo,
                        stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row], StrToInt(lblEdt_cuantos.text),
                        stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row] + ' ' + Ed_Hora.text,
                        ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf(ls_Origen_vta.text)],
                        ls_Desde_vta.IDs[ls_Desde_vta.Items.IndexOf(ls_Desde_vta.text)], gs_trab_unico, //gs_trabid,
                        stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[stg_corrida.Row],
                        StrToFloat(stg_corrida.Cols[_COL_TARIFA].Strings[stg_corrida.Row]),
                        asientos_pago, StrToInt(gs_maquina),
                        StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]),
                        li_asientos_insertados,
                        StrToFloat(stg_corrida.Cols[_COL_IVA].Strings[stg_corrida.Row]),
                        gi_cobro_con_iva);
    gi_idx_asientos := li_ctrl_asiento - 1;
    pintaBusCorrida(stg_corrida.Row);
    apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                  StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                  split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]),
                  ls_Origen_vta.CurrentID, gs_trab_unico, //gs_trabid,
                  StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
    frm := Tfrm_nueva_pagoF.Create(nil);
    frm.vendidos := asientos_pago;
    MostrarForma(frm);
    asientos_pago := asientos_regreso;
    enableTextInput();
    pintaBusCorrida(stg_corrida.Row);
    lbledt_cuales.Clear;
    lbledt_tipo.Clear;
    lbledt_cuales.text := ' ';
    grp_asientos.Visible := False;
    grp_corridas.Visible := True;
    gi_local_cuales := 0;
    li_corrida_seleccionada := 0;
    stg_corrida.Enabled := True;
    stg_corrida.SetFocus;
    keybd_event(VK_ESCAPE, 1, 0, 0);
  end;
end;


procedure Tfrm_nueva_venta.lbledt_tipoChange(Sender: TObject);
var
  li_ctrl, li_option, li_ctrl_ocupantes, li_num, li_ctrl_gga, li_indx,
    li_inc: Integer;
  ls_input, lc_char, lc_espacio, lc_guion, lc_anterior, ls_union: String;
  la_datos: gga_parameters;
begin
  lc_espacio := ' ';
  lc_guion := '-';
  li_option := 0;
  ls_input := lbledt_tipo.text;
  for li_ctrl := 1 to length(ls_input) do begin
    if li_key_press_tipo = 8 then begin
      li_option := 5;
      break;
    end;
    if not(ls_input[1] in ['1' .. '9']) then begin
      lbledt_tipo.Clear;
      lbledt_tipo.SetFocus;
      exit;
    end;
    lc_char := gds_ListaOcupantes.IDOf(gds_ListaOcupantes.ValueOf(UpperCase(ls_input[li_ctrl])));
    if ls_input[li_ctrl] <> ' ' then
      if not(ls_input[li_ctrl] in ['0' .. '9']) then begin
        if lc_char <> ls_input[li_ctrl] then begin // si no esta en la lista
          li_option := 1;
          break;
        end;
        if lc_char = ls_input[li_ctrl] then begin // tenemos un caracter
          li_option := 4;
        end;
      end; // fin if
    if li_ctrl > 1 then begin
      lc_anterior := ls_input[li_ctrl - 1];
      if ((ls_input[li_ctrl - 1] = lc_espacio) or (ls_input[li_ctrl] = lc_guion)
        ) or ((ls_input[li_ctrl - 1] = lc_espacio) or
          (ls_input[li_ctrl] = lc_guion)) then
        li_option := 2;
    end; // fin if li_ctrl
    if (ls_input[1] = lc_espacio) or (ls_input[1] = lc_guion) then
      li_option := 2;
  end; // fin for

  for li_ctrl_gga := 1 to high(array_ocupantes) do
    array_ocupantes[li_ctrl_gga] := '';
  li_ctrl_ocupantes := 1;
  for li_ctrl := 1 to length(ls_input) do begin
    lc_char := gds_ListaOcupantes.IDOf
      (gds_ListaOcupantes.ValueOf(UpperCase(ls_input[li_ctrl])));
    if lc_char = ls_input[li_ctrl] then begin // tenemos un caracter
      if li_ctrl_ocupantes = 1 then
        array_ocupantes[li_ctrl_ocupantes] := lc_char + '|1';
      if li_ctrl_ocupantes > 1 then begin // tenemos datos
        for li_ctrl_gga := 1 to li_ctrl_ocupantes - 1 do begin
          splitLine(array_ocupantes[li_ctrl_gga], '|', la_datos, li_num);
          if la_datos[0] = lc_char then begin
            li_inc := StrToInt(la_datos[1]);
            inc(li_inc);
            if li_inc > 1 then begin
              Mensaje('Error en el tipo de boleto', 1);
              lbledt_tipo.Clear;
              lbledt_tipo.SetFocus;
              exit;
            end;
          end else begin
                      array_ocupantes[li_ctrl_ocupantes] := lc_char + '|1';
          end;
        end;
      end;
      inc(li_ctrl_ocupantes);
    end;
  end;
  case li_option of
    1: lbledt_tipo.text := UpperCase(reWrite(ls_input));
    4: lbledt_tipo.text := UpperCase(reWrite(ls_input)) + lc_char + ' ';
    3: lbledt_tipo.text := UpperCase(validaTipoHueco(ls_input));
  end;
  lbledt_tipo.SelStart := length(lbledt_tipo.text);
end;

procedure Tfrm_nueva_venta.lbledt_tipoEnter(Sender: TObject);
begin
  li_memoria_cuales := 1;
end;

procedure Tfrm_nueva_venta.lbledt_tipoKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(8) then begin
    lbledt_tipo.Clear;
    lbledt_tipo.SetFocus;
  end;
  gi_local_cuales := 2;
end;


procedure Tfrm_nueva_venta.lbledt_tipoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ls_input: String;
begin
  if Key = 32 then begin
    ls_input := Copy(lbledt_tipo.text, 1, length(lbledt_tipo.text) - 1);
    lbledt_tipo.text := ls_input;
    exit;
  end;
end;



procedure Tfrm_nueva_venta.limpiaEntrada;
begin
  Ed_Hora.Clear;
  edt_corrida.Clear;
  ls_Desde_vta.ItemIndex := -1;
  ls_servicio.ItemIndex := -1;
end;

procedure Tfrm_nueva_venta.llenamosDatosInicio;
var
  lq_terminals: TSQLQuery;
begin
  lq_terminals := TSQLQuery.Create(nil);
  lq_terminals.SQLConnection := DM.Conecta;
  if StrToInt(gs_agencia) = 1 then begin
      if EjecutaSQL(format(_VTA_TERMINAL_AGENCIA,[gs_agencia_clave]),lq_terminals,_LOCAL) then begin
          LlenarComboBox(lq_terminals, ls_Origen_, True);
          LlenarComboBox(lq_terminals, ls_Origen_vta, True);
      end;
  end else begin
              if EjecutaSQL(format(_VTA_TERMINALES_ORIGEN, [gs_terminal, gs_terminal]), lq_terminals, _LOCAL) then begin
                LlenarComboBox(lq_terminals, ls_Origen_, True);
                LlenarComboBox(lq_terminals, ls_Origen_vta, True);
              end;
  end;
  if EjecutaSQL(_VTA_TERMINALES, lq_terminals, _LOCAL) then begin
    LlenarComboBox(lq_terminals, ls_Desde_vta, True);
    llenarTerminales(lq_terminals);
    ls_Origen_.text := gds_terminales.ValueOf(gs_terminal);
    ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(gs_terminal);
    medt_fecha.text := FechaServer();
    if EjecutaSQL(format(_VTA_TIPO_SERVICIO,[gs_terminal]), lq_terminals, _LOCAL) then begin
      LlenarComboBox(lq_terminals, ls_servicio, True);
    end;
    edt_corrida.Clear;
    Ed_Hora.Clear;
  end;
  gi_porEmisionBoleto := getEmisionBoleto();
end;


procedure Tfrm_nueva_venta.ls_Desde_vtaExit(Sender: TObject);
var
  li_tmp: Integer;
begin
  li_tmp := ls_Desde_vta.IDs.IndexOf(UpperCase(ls_Desde_vta.text));

  if ls_Desde_vta.ItemIndex < 0 then
    if li_tmp >= 0 then
      ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(UpperCase(ls_Desde_vta.text))
    else
      ls_Desde_vta.text := '';
end;


procedure Tfrm_nueva_venta.ls_Desde_vtaKeyPress(Sender: TObject; var Key: Char);
var
  ls_char: Char;
begin
  if Key = #13 then begin
    if ls_Origen_vta.CurrentID = ls_Desde_vta.CurrentID then begin
      Mensaje(_ERROR_LUGARES, 1);
      ls_Desde_vta.ItemIndex := -1;
      Ed_Hora.Clear;
      ls_servicio.ItemIndex := -1;
      ls_Desde_vta.SetFocus;
      edt_corrida.Clear;
      medt_fecha.SelStart := 0;
      exit;
    end;
    lb_opcion := False;
    consigueCorridas();
    li_valor_refresca := 2;
  end;
end;


procedure Tfrm_nueva_venta.ls_Origen_vtaKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_origen_terminal, ls_origen: string;
  li_ctrl : integer;
begin
  if Key = #13 then begin // hacemos el swicht de la conexion
    ls_origen_terminal := ls_Origen_vta.CurrentID;
    if ls_origen_terminal <> gs_terminal then begin
      CONEXION_VTA := conexionServidorRemoto(ls_origen_terminal);
      if CONEXION_VTA.Connected then begin
        gs_descripcion_lugar := getDescripcionTerminal(ls_origen_terminal);
        LimpiaSag(stg_corrida);
        LimpiaSag(stg_detalle);
        LimpiaSag(stg_ocupantes);
        Label1.Caption := 'Conexion Remota :';
        ls_Origen_.Visible := False;
        gb_venta_remota := True;
        Mensaje('Conectado a :'+gs_descripcion_lugar,2);
        li_conectado_remotamente := 1;
        ls_Desde_vta.ItemIndex := -1;
        Ed_Hora.Clear;
        ls_servicio.ItemIndex := -1;
        edt_corrida.Clear;
      end else begin
        Mensaje(format(_MSG_CONEXION_REMOTA, [gs_descripcion_lugar]), 2);
        ls_Origen_vta.IDs.IndexOf(gs_terminal);
        CONEXION_VTA := DM.Conecta; // se conecta al server local
        gs_descripcion_lugar := getDescripcionTerminal(gs_terminal);
        LimpiaSag(stg_corrida);
        LimpiaSag(stg_detalle);
        LimpiaSag(stg_ocupantes);
        gb_venta_remota := False;
        Mensaje('Conectado a :'+gs_descripcion_lugar,2);
        li_conectado_remotamente := 0;
        ls_Desde_vta.ItemIndex := 1;
        Ed_Hora.Clear;
        ls_servicio.ItemIndex := -1;
        edt_corrida.Clear;
        try
          if CONEXION_REMOTO <> nil then begin
            CONEXION_REMOTO.Free;
            CONEXION_REMOTO := nil;
          end;
        except
        end;
        exit;
      end;
    end else begin // se reconecta localmente
      CONEXION_VTA := DM.Conecta;
      li_conectado_remotamente := 0;
      Label1.Caption := 'Ciudad Origen :';
      ls_Origen_.Visible := True;
      ls_Origen_vta.IDs.IndexOf(gs_terminal);
      gs_descripcion_lugar := getDescripcionTerminal(gs_terminal);
      LimpiaSag(stg_corrida);
      LimpiaSag(stg_detalle);
      LimpiaSag(stg_ocupantes);
      gb_venta_remota := False;
      Mensaje('Conectado a :'+gs_descripcion_lugar,2);
      try
        if CONEXION_REMOTO <> nil then begin
          CONEXION_REMOTO.Free;
          CONEXION_REMOTO := nil;
        end;
      except
      end;
    end;
    if not gb_asignado then
      exit;
  end;
  Image.Visible := False;
  limpiar_La_labels(ga_labels); // limpiamos las etiquetas
end;


procedure Tfrm_nueva_venta.ls_servicioExit(Sender: TObject);
var
  li_tmp: Integer;
begin
  li_tmp := ls_servicio.IDs.IndexOf(UpperCase(ls_servicio.text));
  if ls_servicio.ItemIndex < 0 then
    if li_tmp >= 0 then
      ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf
        (UpperCase(ls_servicio.text))
    else
      ls_servicio.text := '';
end;

procedure Tfrm_nueva_venta.ls_servicioKeyPress(Sender: TObject; var Key: Char);
begin
//    ShowMessage('aqui va todo');
end;

procedure Tfrm_nueva_venta.medt_fechaEnter(Sender: TObject);
begin
    medt_fecha.SelStart := 0;
end;

procedure Tfrm_nueva_venta.Modificar1Click(Sender: TObject);
var
  lfrm_forma: TfrmModificarCorrida;
  ls_promotor: string;
begin
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
    exit;
  try
      gi_opcion := 3;
      ls_promotor := '';
//      ls_promotor := gs_trabid;
      ls_promotor := gs_trab_unico;
      if not AccesoPermitido(178, False) then begin
        gs_trabid := ls_promotor;
        exit;
      end;
      lfrm_forma := TfrmModificarCorrida.Create(Self);
      lfrm_forma.valoresDeInicio(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]));
      MostrarForma(lfrm_forma);
      stg_corrida.Cells[_COL_NAME_IMAGE, stg_corrida.Row] := gs_NombreImagenBusModificado;
      stg_corrida.Cells[_COL_AUTOBUS, stg_corrida.Row] := gs_TipoBusModificado;
      stg_corrida.Cells[_COL_ASIENTOS, stg_corrida.Row] := gs_NoAsientosBusModificado;
      pintaBusCorrida(stg_corrida.Row);
      insertaEvento(gs_trabid,gs_terminal,'Modifica cupos ' +
                    stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]+' '+
                    stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]+' '+
                    gs_trabid);
  finally
      gs_trabid := gs_trab_unico;
      if length(ls_promotor) = 0 then begin
        gb_asignado := False;
        gs_trabid := '';
      end else
        gb_asignado := True;
  end;
end;



procedure Tfrm_nueva_venta.muestraImagenPatalla;
begin
    if not gb_asignado then begin
        if gi_imagen_servicio <> 0 then
            showPantallaImagen(0);
        if gi_imagen_servicio = 0 then
            showPantallaImagen(0);

    end else
      showPantallaImagen(stg_corrida.cells[_COL_TIPOSERVICIO, stg_corrida.row].toInteger);
end;

procedure Tfrm_nueva_venta.pintaBusCorrida(li_indx: Integer);
var
  la_datos: gga_parameters;
  li_num: Integer;
begin
    if length(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]) = 0 then begin
      Mensaje(_MSG_DATOS_CORRIDA, 0);
      exit;
    end;
    Image.Visible := True;
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos,li_num);
    if la_datos[0] = 'E' then gs_imprime_extra := ' Extra'
    else gs_imprime_extra := '';
    if li_num = 0 then Ed_Hora.text := la_datos[0]
    else Ed_Hora.text := la_datos[1];
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[li_indx]);
    edt_corrida.text := stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx];
    ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(stg_corrida.Cols[_COL_DESTINO].Strings[li_indx]);
    medt_fecha.text := stg_corrida.Cols[_COL_FECHA].Strings[li_indx];
    limpiar_La_labels(ga_labels);
    showDetalleRuta(StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]), stg_detalle);
    obtenImagenBus(Image, stg_corrida.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
    muestraAsientosArreglo(ga_labels,StrToInt(stg_corrida.Cols[_COL_AUTOBUS].Strings[li_indx]), pnlBUS);
    asientosOcupados(ga_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),
                     StrToTime(Ed_Hora.text),stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
    showOcupantes(ls_Origen_vta.CurrentID,stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx],
                  StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),stg_ocupantes);
end;


procedure Tfrm_nueva_venta.Predespachar1Click(Sender: TObject);
var
  lq_qry: TSQLQuery;
  ls_fecha, ls_promotor: string;
begin { Predespachamos ls corrida }
  gi_opcion := 1;
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then exit;
  lq_qry := TSQLQuery.Create(nil);
  try
    ls_promotor := '';
    ls_promotor := gs_trabid;
    if not AccesoPermitido(153, False) then begin
      gs_trabid := ls_promotor;
      exit;
    end else begin
        lq_qry.SQLConnection := DM.Conecta;
        if EjecutaSQL(format(_UPDATE_CORRIDA_D, ['P', gs_trabid,stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
            formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
            gs_terminal, Ed_Hora.text,stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]]), lq_qry,_RUTA) then begin
            GridDeleteRow(stg_corrida.Row, stg_corrida);
            if EjecutaSQL(format(_UPDATE_CORRIDA_D, ['P', gs_trabid, stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
              formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
              gs_terminal, Ed_Hora.text, stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]]), lq_qry, _SERVIDOR_CENTRAL) then
                  insertaEvento(gs_trabid,gs_terminal,'Predespacha corrida ' +
                                stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]+' '+
                                gs_trabid);
        end;
        pintaBusCorrida(stg_corrida.Row);
        ls_Desde_vta.ItemIndex := 0;
        ls_servicio.ItemIndex := 0;
    end;
    lq_qry.Destroy;
  finally
    gs_trabid := gs_trab_unico;
    if (length(ls_promotor) = 0) or (ls_promotor = '') then begin
      gb_asignado := False;
      gs_trabid := '';
    end else
      gb_asignado := True;
  end;
end;


procedure Tfrm_nueva_venta.stg_corridaKeyPress(Sender: TObject; var Key: Char);
var
  ls_quien_ocupa: string;
  frm_Ocupada: TFrm_Corrida_Ocupada;
  la_datos : gga_parameters;
  li_num : integer;
begin
  li_corrida_seleccionada := 0;
//  if gi_Pantalla_duplex = 1 then
      muestraImagenPatalla;
  gi_imagen_servicio := stg_corrida.cells[_COL_TIPOSERVICIO, stg_corrida.row].toInteger;
  if Key = #13 then begin
    if ( (lbl_nombre.Caption = _NO_REGISTRADO) and (gb_asignado = true)) then begin
        gb_asignado := false;
    end;

    if not gb_asignado then begin
      if not AccesoPermitido(_TAG_VENTA, False) then
        exit
      else begin
        asignarseVenta(); // @invocamos la asignacion a ala venta
        if gb_asignado = False then exit;
        lbl_nombre.Caption := gs_nombre_trabid;
        if gb_fondo_ingresado_new = False then
          exit;
        gb_asignado := True;
//        if gi_Pantalla_duplex = 1 then
            muestraImagenPatalla;
        gi_imagen_servicio := stg_corrida.cells[_COL_TIPOSERVICIO, stg_corrida.row].toInteger;
      end;
    end;
    if(stg_corrida.RowCount < 2) then begin
        splitLine(ls_Origen_vta.text, '-', la_datos, li_num);
        TRefrescaCorrida.Enabled := True;
        consigueCorridas();
        exit;
    end;

    gi_vta_pie := 0;
//revisar se pasa la terminal para que
    if estatus_corrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                       stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row], gs_terminal) <> 'A' then begin
            Mensaje('El estatus de la corrida no se encuentra abierta para la venta',1);
            exit;
    end;

    if StrToFloat(stg_corrida.Cells[_COL_TARIFA, stg_corrida.Row]) = 0 then begin
      Mensaje('Verifique la tarifa de la corrida, con el supervisor', 2);
      exit;
    end;

    gi_cupo_ruta := StrToInt(stg_corrida.Cols[_COL_ASIENTOS].Strings[stg_corrida.Row]);//CUPO POR LA RUTA ES LA PERMITIDA INCIALMENTE
//gi_ocupados
    gi_ocupados := cupoCorridaVigente(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                      formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                                      split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]),CONEXION_VTA);
    gi_solo_pie := cupoPieCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row], formatDateTime('YYYY-MM-DD',
                                  StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                                  gs_terminal); // @cargamos el el grid
    if (gi_ocupados = (gi_cupo_ruta + gi_solo_pie)) then begin
              Mensaje('No se puede vender, no hay mas lugares disponibles aun de pie', 1);
              pintaBusCorrida(stg_corrida.Row);
              exit;
    end;

    if (gi_ocupados < (gi_cupo_ruta + gi_solo_pie)) then
      gi_permitido_cupo := (gi_cupo_ruta + gi_solo_pie) - gi_ocupados
    else begin
              Mensaje('no se puede vender, no hay mas lugares disponibles', 1);
              pintaBusCorrida(stg_corrida.Row);
              exit;
    end;
    if (gi_ocupados >= gi_cupo_ruta) and (gi_solo_pie > 0) then
          gi_vta_pie := 1; // @ podemos vender de pie
    if (gi_ocupados >= gi_cupo_ruta) and (gi_solo_pie = 0) then begin // podemos vender de pie
          Mensaje(_MSG_NO_VTA_DISPONIBLE, 1);
          stg_corrida.Row := stg_corrida.Row + 1;
          exit;
    end;
    if length(asientos_regreso[1].corrida) = 0 then begin
        ls_quien_ocupa := storeApartacorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                             StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                                             ls_Origen_vta.CurrentID, gs_trab_unico);
    end else begin
        ls_quien_ocupa := storeApartacorridaVenta(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                             StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                                             ls_Origen_vta.CurrentID, gs_trab_unico);
    end;

    gi_corrida_en_uso := 0; // valor de 0 si esta ocupada cambia a 1
    if ls_quien_ocupa <> gs_trab_unico then begin
      frm_Ocupada := TFrm_Corrida_Ocupada.Create(Self);
      frm_Ocupada.corrida := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
      frm_Ocupada.fecha := stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row];
      frm_Ocupada.hora := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
      MostrarForma(frm_Ocupada);
      pintaBusCorrida(stg_corrida.Row);
      TRefrescaCorrida.Enabled := True;
      if gi_corrida_en_uso > 0 then begin // salimos
        stg_corrida.Row := stg_corrida.Row;
        stg_corrida.Enabled := True;
        stg_corrida.SetFocus;
        gi_corrida_en_uso := 0;
        pintaBusCorrida(stg_corrida.Row);
        exit;
      end;
    end;
    disableTextInput();
    stg_corrida.Enabled := False;
    grp_corridas.Visible := False;
    grp_asientos.Visible := True;
    grp_cuales.Visible := True;
    if StrToInt(gs_agencia) = 1 then
       lbledt_tipo.Enabled := False;
    if gi_vta_pie = 0 then begin
        lblEdt_cuantos.EditLabel.Caption := '';
        lblEdt_cuantos.Visible := False;
        lbledt_cuales.SetFocus;
        stg_listaOcupantes.Cells[0, 0] := 'Abreviacion';
        stg_listaOcupantes.Cells[1, 0] := 'Descripcion';
    end;
    if gi_vta_pie = 1 then begin//mostramos lo que contenga el f7
        lblEdt_cuantos.EditLabel.Caption := 'Cuantos :';
        lbledt_cuales.Clear;
        lbledt_tipo.Clear;
        lblEdt_cuantos.Clear;
        grp_corridas.Visible := False;
        lbledt_cuales.text := ' ';
        grp_cuales.Visible := False;
        grp_asientos.Visible := True;
        lblEdt_cuantos.Visible := True;
        lblEdt_cuantos.SetFocus;
    end;
    li_corrida_seleccionada := 1;
  end;
end;


procedure Tfrm_nueva_venta.stg_corridaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  li_ctrl: Integer;
  lb_ejecuta: Boolean;
  li_fila: Integer;
begin
//  if gi_Pantalla_duplex = 1 then
      muestraImagenPatalla;
  timer_pintabus.Enabled := False;
  TRefrescaCorrida.Enabled := False;
  if (ord(key_sag_venta) = Key) and (now <= tiempo_key + _TECLAS_EN_TU_TIEMPO) then begin
    tiempo_key := now();
    timer_pintabus.Enabled := True;
    exit;
  end else begin
              tiempo_key := now();
  end;
  TRefrescaCorrida.Enabled := True;
  tiempo_key := now();
  key_sag_venta := chr(Key);
  lb_ejecuta := False;
  for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do begin
    if Key = _TECLAS_ARRAY[li_ctrl] then begin
      lb_ejecuta := True;
    end;
  end;
  if lb_ejecuta then begin
    if li_ultima_corrida_procesada = stg_corrida.Row then
      exit;
    if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) > 0 then begin
       timer_pintabus.Enabled := True;
    end;
  end;
end;


procedure Tfrm_nueva_venta.stg_corridaMouseDown(Sender: TObject;
                Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, fila: Integer;
begin
//  if gi_Pantalla_duplex = 1 then
      muestraImagenPatalla;
  if li_conectado_remotamente = 1 then begin
    Mensaje('No puede hacer modificaciones de forma remota',1);
    exit;
  end;
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
    exit;
  try
    pintaBusCorrida(stg_corrida.Row);
  except
  end;
  if Button = mbRight then begin
    stg_corrida.MouseToCell(X, Y, Col, fila);
    stg_corrida.Col := Col;
    stg_corrida.Row := fila;
  end;
end;


procedure Tfrm_nueva_venta.TimerAsignadoTimer(Sender: TObject);
var
  li_row: Integer;
  seconds: DWord;
  ls_quien_ocupa: string;
  lq_query: TSQLQuery;
begin
  seconds := SecondsIdle;
  if (TimerAsignado.Enabled = False) then // Desasignamos de la venta y cambiamos el estatus
    seconds := 0;
    Caption := 'Pantalla para la venta de boletos : ' + UpperCase
    (gs_descripcion_lugar) + ' ' + format('Tiempo de venta %d seconds',
    [seconds]);
  if ((seconds >= (li_tecla_espera * 60)) and (gb_asignado = True) and (gi_usuario_ocupado = 0)) then begin
    gb_asignado := False;
    TimerAsignado.Enabled := False; // Desasignamos de la venta y cambiamos el estatus
    seconds := 0;
    Caption := 'Pantalla para la venta de boletos : ' + UpperCase
              (gs_descripcion_lugar) + ' ' + format('Tiempo de venta %d seconds', [seconds]);
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := CONEXION_VTA;
    if EjecutaSQL(format(_VTA_SI_YA_EXISTE, [gs_trabid, GetIPList,
        gs_terminal]), lq_query, _LOCAL) then // si existe el dato
      if EjecutaSQL(format(_VTA_UPDATE_NO_VENTA,[StrToInt(lq_query['ID_CORTE']), gs_terminal]), lq_query, _LOCAL) then  begin // estatus = A
        enableTextInput();
        limpiar_La_labels(ga_labels); // limpiamos las etiquetas
        gb_asignado := False;
        gs_trabid := '';
        ac111.Enabled := True;
        ac116.Enabled := False;
        ac179.Enabled := False;
        acboleto.Enabled := False;
        acAnticipada.Enabled := False;
        acimprimevta.Enabled := False;
        lbl_nombre.Caption := _NO_REGISTRADO;
        LimpiaSagTodo(stg_ocupantes);
        LimpiaSagTodo(stg_detalle);
        edt_corrida.Clear;
        ls_servicio.ItemIndex := -1;
        Ed_Hora.Clear;
        ls_Desde_vta.ItemIndex := -1;
        try
          grp_asientos.Visible := False;
          grp_corridas.Visible := True;
        except
        end;
        FormShow(Self);
        medt_fecha.SetFocus; // foco en la fecha
      end;
    lq_query.Free;
    lq_query := nil;
  end;
end;


procedure Tfrm_nueva_venta.timer_HoraTimer(Sender: TObject);
begin
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
    if Self.Visible then begin
      try
        stb_venta.Panels[6].text := 'Hora Actual : '+ getHora();
      except
      end;
    end;
end;


procedure Tfrm_nueva_venta.timer_pintabusTimer(Sender: TObject);
begin
  timer_pintabus.Enabled := False;
  if li_ultima_corrida_procesada <> stg_corrida.Row then
  begin
    pintaBusCorrida(stg_corrida.Row);
    li_ultima_corrida_procesada := stg_corrida.Row;
  end;
end;


procedure Tfrm_nueva_venta.Titles;
begin
  stg_corrida.Cells[_COL_HORA, 0] := 'HORA';
  stg_corrida.Cells[_COL_DESTINO, 0] := 'DESTINO';
  stg_corrida.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
  stg_corrida.Cells[_COL_FECHA, 0] := 'FECHA';
  stg_corrida.Cells[_COL_RUTA, 0] := 'Ruta';
  stg_corrida.Cells[_COL_CORRIDA, 0] := 'Corrida';
  stg_corrida.Cells[_COL_TARIFA, 0] := 'Tarifa';
  stg_corrida.ColWidths[_COL_TRAMO] := 0;
  stg_corrida.ColWidths[_COL_AUTOBUS] := 0;
  stg_corrida.ColWidths[_COL_ASIENTOS] := 0;
  stg_corrida.ColWidths[_COL_NAME_IMAGE] := 0;
  stg_corrida.ColWidths[_COL_TIPOSERVICIO] := 0;
  stg_corrida.ColWidths[_COL_PIE] := 0;
  stg_corrida.ColWidths[_COL_CUPO] := 0;
  stg_ocupantes.ColWidths[0] := 160;
  stg_ocupantes.ColWidths[1] := 30;
end;


procedure Tfrm_nueva_venta.TpingTimer(Sender: TObject);
begin
    if gi_conexion_server = 1 then begin
        pingHilo := TPingServer.Create(true);
        pingHilo.memo  := mem_conectado;
        pingHilo.image := img_central;
        pingHilo.Priority := tpTimeCritical;
        pingHilo.FreeOnTerminate := true;
        pingHilo.Resume;
    end;
end;

procedure Tfrm_nueva_venta.TRefrescaCorridaTimer(Sender: TObject);
var
  li_row, li_ctrl: Integer;
  segundos: DWord;
begin
  if (stg_corrida.Row > 1) and (tiempo_refresh_Grid() = 1) and
    (stg_corrida.Enabled = True) then begin
      pintaBusCorrida(stg_corrida.Row);
  end;
end;



function Tfrm_nueva_venta.valida_Busqueda_Corrida: Boolean;
var
  lb_ok: Boolean;
begin
  lb_ok := True;
  if length(medt_fecha.text) = 0 then
  begin
    lb_ok := False;
    medt_fecha.SetFocus;
    exit;
  end;
  if length(ls_Origen_vta.text) = 0 then
  begin
    lb_ok := False;
    ls_Origen_vta.SetFocus;
    exit;
  end;
  Result := lb_ok;
end;

procedure Tfrm_nueva_venta.VentaReservados1Click(Sender: TObject);
var
    lfrm_forma : Tfrm_reservados_vta;
    ls_promotor : String;
begin
    try
        gi_opcion := 7;
        ls_promotor := '';
        ls_promotor := gs_trab_unico;
//        gi_boleto_tamano   :=  BoletosTamano(gs_terminal,gs_local,gs_maquina);
        valoresIniciales();
        insertaEvento(gs_trabid,gs_terminal,'Venta de reservados ');
        lfrm_forma := Tfrm_reservados_vta.Create(self);
        MostrarForma(lfrm_forma);
    finally
        gs_trabid := gs_trab_unico;
        if (length(ls_promotor) = 0) or (ls_promotor = '') then begin
          gb_asignado := False;
          gs_trabid := '';
        end else
          gb_asignado := True;
    end;
end;

procedure Tfrm_nueva_venta.CancelaReservacion1Click(Sender: TObject);
var
    frm_n : Tfrm_cancela_new;
    ls_promotor : String;
begin
    try
        gi_opcion := 8;
        ls_promotor := '';
        ls_promotor := gs_trab_unico;
        frm_n := Tfrm_cancela_new.Create(self);
        MostrarForma(frm_n);
        insertaEvento(gs_trabid,gs_terminal,'Cancela Reservados ');
    finally
        gs_trabid := gs_trab_unico;
        if (length(ls_promotor) = 0) or (ls_promotor = '') then begin
          gb_asignado := False;
          gs_trabid := '';
        end else
          gb_asignado := True;
    end;
end;

procedure Tfrm_nueva_venta.LiberaCorrida1Click(Sender: TObject);
var
    lfrm_forma : Tfrm_corrida_libera;
    ls_promotor : string;
begin
    gi_opcion := 9;
    ls_promotor := '';
    ls_promotor := gs_trab_unico;
    if not AccesoPermitido(158,False) then begin
        gs_trabid := ls_promotor;
        exit;
    end;
    try
        lfrm_forma := Tfrm_corrida_libera.Create(Self);
        MostrarForma(lfrm_forma);
        insertaEvento(gs_trabid,gs_terminal,'Libera corrida ');
    finally
        gs_trabid := gs_trab_unico;
        if (length(ls_promotor) = 0) or (ls_promotor = '') then begin
          gb_asignado := False;
          gs_trabid := '';
        end else
          gb_asignado := True;                
    end;
end;

end.
