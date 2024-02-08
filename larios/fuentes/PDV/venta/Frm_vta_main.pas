unit Frm_vta_main;

interface

{$WARNINGS OFF}
{$HINTS OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ToolWin, ExtCtrls, DB,
  StdCtrls, Grids, lsCombobox, Menus, ActnMan, ActnCtrls, ActnMenus,
  XPStyleActnCtrls, FMTBcd, WideStrings, frm_mensaje_corrida, Mask, DateUtils,
  DBGrids, DBClient, SimpleDS;

type
  TFrm_venta_principal = class(TForm)
    TimerAsignado: TTimer;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    pnlBUS: TPanel;
    Splitter2: TSplitter;
    Gr_Corridas: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    stb_venta: TStatusBar;
    Label6: TLabel;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    stg_detalle: TStringGrid;
    ls_Origen_vta: TlsComboBox;
    ls_Desde_vta: TlsComboBox;
    ls_Origen: TlsComboBox;
    pnl_main: TPanel;
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
    ActionMainMenuBar3: TActionMainMenuBar;
    Image: TImage;
    GroupBox3: TGroupBox;
    grp_asientos: TGroupBox;
    lblEdt_cuantos: TLabeledEdit;
    ls_servicio: TlsComboBox;
    grp_cuales: TGroupBox;
    lbledt_cuales: TLabeledEdit;
    stg_listaOcupantes: TStringGrid;
    lbledt_tipo: TLabeledEdit;
    medt_fecha: TMaskEdit;
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
    Ed_Hora: TEdit;
    StatusBar1: TStatusBar;
    PopupMenu: TPopupMenu;
    Predespachar1: TMenuItem;
    Agrupar1: TMenuItem;
    Modificar1: TMenuItem;
    ActionManager1: TActionManager;
    ac111: TAction;
    ac116: TAction;
    ac99: TAction;
    ac160: TAction;
    acInicial: TAction;
    ac179: TAction;
    edt_corrida: TEdit;
    Label3: TLabel;
    acboleto: TAction;
    acAnticipada: TAction;
    acimprimevta: TAction;
    stg_ocupantes: TStringGrid;
    timer_pintabus: TTimer;
    lbl_nombre: TLabel;
    Action1: TAction;
    TRefrescaCorrida: TTimer;
    Cerrarcorrida1: TMenuItem;
    Action2: TAction;
    acPrueba: TAction;
{    procedure ac99Execute(Sender: TObject);
    procedure TimerAsignadoTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure a111Execute(Sender: TObject);
    procedure ac116Execute(Sender: TObject);
    procedure Ed_fechaKeyPress(Sender: TObject; var Key: Char);
    procedure ls_Desde_vtaExit(Sender: TObject);
    procedure ls_Origen_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure ls_Desde_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure stg_corridaKeyPress(Sender: TObject; var Key: Char);
    procedure stg_corridaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lblEdt_cuantosKeyPress(Sender: TObject; var Key: Char);
    procedure ls_servicioExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblEdt_cuantosChange(Sender: TObject);
    procedure lbledt_cualesChange(Sender: TObject);
    procedure lbledt_tipoChange(Sender: TObject);
    procedure lbledt_cualesExit(Sender: TObject);
    procedure lbledt_tipoEnter(Sender: TObject);
    procedure lbledt_cualesEnter(Sender: TObject);
    procedure lblEdt_cuantosEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lblEdt_cuantosExit(Sender: TObject);
    procedure medt_fechaExit(Sender: TObject);
    procedure medt_fechaKeyPress(Sender: TObject; var Key: Char);
    procedure Ed_Hora1KeyPress(Sender: TObject; var Key: Char);
    procedure ls_servicioKeyPress(Sender: TObject; var Key: Char);
    procedure Ed_HoraChange(Sender: TObject);
    procedure Ed_HoraKeyPress(Sender: TObject; var Key: Char);
    procedure Ed_HoraExit(Sender: TObject);
    procedure Predespachar1Click(Sender: TObject);
    procedure stg_corridaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ac160Execute(Sender: TObject);
    procedure Agrupar1Click(Sender: TObject);
    procedure Modificar1Click(Sender: TObject);
    procedure ac179Execute(Sender: TObject);
    procedure edt_corridaChange(Sender: TObject);
    procedure edt_corridaKeyPress(Sender: TObject; var Key: Char);
    procedure acboletoExecute(Sender: TObject);
    procedure acAnticipadaExecute(Sender: TObject);
    procedure acimprimevtaExecute(Sender: TObject);
    procedure lbledt_cualesKeyPress(Sender: TObject; var Key: Char);
    procedure stg_corridaSelectCell(Sender: TObject; ACol, ARow: Integer;  var CanSelect: Boolean);
    procedure timer_pintabusTimer(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure medt_fechaEnter(Sender: TObject);
    procedure lbledt_tipoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TRefrescaCorridaTimer(Sender: TObject);
    procedure Cerrarcorrida1Click(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure acPruebaExecute(Sender: TObject);}
  private
    { Private declarations
    procedure Titles();
    procedure clearPantalla();
    procedure asignarseVenta();
    procedure consigueCorridas();
    procedure datos();
    function valida_Busqueda_Corrida(): Boolean;
    procedure stringDatosVenta();
    procedure disableTextInput();
    procedure enableTextInput();
    procedure pintaBusCorrida(li_indx: Integer);
    procedure limpiaAsientosArreglo();
    procedure ejecutaCualesEnter();
    { disableTextInput();
      enableTextInput(); }
  public
    { Public declarations }

  end;

var
  Frm_venta_principal: TFrm_venta_principal;

implementation
{
uses DMdb, comun, U_venta, u_main, Math, DrawAsiento, Frm_vta_pagos,
  frm_usuario_boletos, Frm_vta_agrupa_corrida, Frm_fondo_inicial,
  modificarCorrida, frmMrecolecccion, comunii, Frm_cancela_boletos,
  frm_venta_anticipada, frm_vta_anticipados, frm_anticipada_venta,
  ThreadCorrida, ThreadDetalleRuta, ThreadTrazaLugar, frm_cambio_password,
  frm_ultimaventa, u_boleto;

var
  li_contador: Integer;
  lq_query: TSQLQuery;
  AsientoFree: TDibujaAsiento;
  StoreSeat: TSQLStoredProc;
  lsOrigen, lsDestino: string;
  li_ultima_corrida_procesada: Integer;
  lb_opcion: Boolean;
  li_tecla_espera: Integer;
  li_cuales: Integer;
  asientos_pago: array_asientos;
  la_labels: labels_asientos;
  li_despachada: Integer;
  frm: Tfrm_forma_pago;
  li_corrida_selecciona: Integer;
  simple: TSimpleDataSet;
  li_ocupados_cuales: Integer;
  li_extra_corrida: Integer;
  array_ocupantes : array[1..20]of string;
  li_ocupados_array : integer;
  li_key_press_tipo : word;
  li_consulto_venta : integer;
  li_valor_refresca : integer;

procedure TFrm_venta_principal.ac99Execute(Sender: TObject);
var
  lq_query: TSQLQuery;
begin
  li_ctrl_asiento := 1; // variable para el control de asientos asignados
  gi_cuales := 0;
  limpiar_La_labels(la_labels); // limpiamos las etiquetas
  Close;
end;

procedure TFrm_venta_principal.acAnticipadaExecute(Sender: TObject);
var
  lfr_forma: Tfrm_vta_anticipada;
  ls_promotor : String;
begin
    ls_promotor := gs_trabid;
    if not AccesoPermitido(188, False) then begin
      gs_trabid := ls_promotor;
      exit;
    end;
    lfr_forma := Tfrm_vta_anticipada.Create(Self);
    MostrarForma(lfr_forma);
    gs_trabid := ls_promotor;
end;

procedure TFrm_venta_principal.acboletoExecute(Sender: TObject);
var
  lfr_forma: TFrm_cancelaciones;
  ls_promotor : string;
begin
  ls_promotor := gs_trabid;
  lfr_forma := TFrm_cancelaciones.Create(Self);
  MostrarForma(lfr_forma);
  pintaBusCorrida(stg_corrida.Row);
  gs_trabid := ls_promotor;
end;

procedure TFrm_venta_principal.acimprimevtaExecute(Sender: TObject);
var
  lfr_forma: Tfrm_anticipa_vender;
  ls_promotor : String;
begin
    ls_promotor := gs_trabid;
    if not AccesoPermitido(189, False) then begin
      gs_trabid := ls_promotor;
      exit;
    end;
    lfr_forma := Tfrm_anticipa_vender.Create(Self);
    MostrarForma(lfr_forma);
    gs_trabid := ls_promotor;
end;

procedure TFrm_venta_principal.Action1Execute(Sender: TObject);
var
  lfr_password: TFrm_contrasena;
begin
  lfr_password := TFrm_contrasena.Create(Self);
  MostrarForma(lfr_password);
end;


procedure TFrm_venta_principal.Action2Execute(Sender: TObject);
var
    lfr_forma : Tfrm_venta_ultima;
    F : TextFile;
    ls_name,text, ls_promotor : string;
    li_idx  : integer;
begin
    ls_promotor:= gs_trabid;
    if not AccesoPermitido(194,False) then begin
        gs_trabid := ls_promotor;
        Exit;
    end;
    lfr_forma := Tfrm_venta_ultima.Create(nil);
    lfr_forma.cve_Empleado := ls_promotor;
    MostrarForma(lfr_forma);
    gs_trabid := ls_promotor;
    gb_asignado := true;
end;


procedure TFrm_venta_principal.acPruebaExecute(Sender: TObject);
begin
    imprimirBoletoDatamax('','','','','Prueba de impresion','',
                          Copy(Ahora(),1,10),'','PRUEBA DE IMPRESION',
                          '','','',Copy(Ahora(),12,5),
                          '','PRUEBA DE IMPRESION','PRUEBA DE IMPRESION','PRUEBA DE IMPRESION',
                          'PRUEBA DE IMPRESION','PRUEBA DE IMPRESION',gs_puerto);
end;

procedure TFrm_venta_principal.Agrupar1Click(Sender: TObject);
var
  lfrm_forma: TFrm_corrida_agrupa;
  ls_promotor : string;
  li_row  : integer;
begin
    try
      ls_promotor := '';
      ls_promotor:= gs_trabid;
      if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then begin
        gs_trabId:= ls_promotor;
        exit;
      end;
      li_agrupa_corrida := 0;
      lfrm_forma := TFrm_corrida_agrupa.Create(nil);
      li_row := stg_corrida.Row;
      lfrm_forma.ventaStringGrid := stg_corrida;
      lfrm_forma.li_row_corrida := stg_corrida.Row;
      lfrm_forma.ls_origen      := ls_Origen_vta.CurrentID;
      MostrarForma(lfrm_forma);
      if li_agrupa_corrida = 1 then
      begin
        FormShow(Sender);
        GridDeleteRow(stg_corrida.Row, stg_corrida);
//        stg_corrida.Row := GridCorridaActualNueva(stg_corrida.Row, stg_corrida);
        FormActivate(Sender);
        li_agrupa_corrida := 0;
        pintaBusCorrida(li_row);
      end;
    finally
      gs_trabId:= ls_promotor;
      if Length(ls_promotor) = 0 then begin
        gb_asignado := False;
        gs_trabid := '';
      end else gb_asignado := true;
    end;
end;


procedure TFrm_venta_principal.ac160Execute(Sender: TObject);
begin
  ImprimeCargaInicial(gs_trabid);
end;


procedure TFrm_venta_principal.ac179Execute(Sender: TObject);
var
  lfrm_forma: TfrmRecoleccion;
  ls_promotor : String;
begin
  try
    ls_promotor:= gs_trabid;
    if not AccesoPermitido(179, False) then begin
      gs_trabId:= ls_promotor;
      gb_asignado := true;
      exit;
    end;
    comunii.Recaudado := gs_trabid;
    lfrm_forma := TfrmRecoleccion.Create(nil);
    MostrarForma(lfrm_forma);
    gs_trabId:= ls_promotor;
    gb_asignado := true;
  finally
    gs_trabId:= ls_promotor;
    gb_asignado := true;
  end;
end;


procedure TFrm_venta_principal.clearPantalla;
begin
  FormShow(Self);
  Activate();
  LimpiaSag(stg_corrida);
  LimpiaSagTodo(stg_detalle);
  // LimpiaSagTodo(stg_ocupantes);
  ls_Origen.Text := '';
  ls_Origen_vta.Text := '';
  ls_Desde_vta.Text := '';
  edt_corrida.Clear;
  Ed_Hora.Clear;
  Ed_Hora.Clear;
  Gr_Corridas.Enabled := False;
  Image.Visible := False;
  ac116.Enabled := False;
  ac111.Enabled := True;
  try
    grp_asientos.Visible := False;
    grp_corridas.Visible := True;
  except

  end;
end;


procedure TFrm_venta_principal.consigueCorridas;
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
  if length(ls_Origen_vta.Text) <> 0 then
    lsOrigen := ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf
      (ls_Origen_vta.Text)]
  else
    lsOrigen := '';
  if length(ls_Desde_vta.Text) <> 0 then
    lsDestino := ls_Desde_vta.IDs[ls_Desde_vta.Items.IndexOf(ls_Desde_vta.Text)]
  else
    lsDestino := '';
  if (length(Ed_Hora.Text) > 0) or (ls_servicio.ItemIndex >= 0) or
    (length(edt_corrida.Text) > 0) then begin
    corridasParametros(lsOrigen, lsDestino, medt_fecha.Text, Ed_Hora.Text,ls_servicio.CurrentID, 1, stg_corrida, edt_corrida.Text);
    li_consulto_venta := 2;
    // mostramos la corrida
  end else begin
            corridasParametros(lsOrigen, lsDestino, medt_fecha.Text, '', '', 0, stg_corrida, ''); // mostramos la corrida
            stg_corrida.Enabled := True;
            stg_corrida.SetFocus;
            li_consulto_venta := 1;
  end;
  if gi_select_corrida = 0 then begin
    splitLine(ls_Origen_vta.Text, '-', la_datos, li_num);
    ls_server := la_datos[1];
    if CONEXION_VTA <> DM.Conecta then begin
      splitLine(ls_Origen_vta.Text, '-', la_datos, li_num);
      ls_server := la_datos[1];
    end;
    Mensaje(format(_MSG_NO_HAY_CORRIDAS, [medt_fecha.Text, ls_server]), 0);
    medt_fecha.SetFocus;
    exit;
  end;
  pintaBusCorrida(gi_select_corrida); // pintamos el autobus
  stg_corrida.Row := gi_select_corrida;
  TRefrescaCorrida.Enabled := False;
end;




function SecondsIdle: DWord;
var
  liInfo: TLastInputInfo;
begin
  liInfo.cbSize := SizeOf(TLastInputInfo);
  GetLastInputInfo(liInfo);
  Result := (GetTickCount - liInfo.dwTime) DIV 1000;
 end;

procedure TFrm_venta_principal.TRefrescaCorridaTimer(Sender: TObject);
var
    li_row, li_ctrl : integer;
    segundos : DWORD;
begin
    if stg_corrida.Row > 1 then
       pintaBusCorrida(stg_corrida.Row);
end;


procedure TFrm_venta_principal.TimerAsignadoTimer(Sender: TObject);
var
  li_row  : Integer;
  seconds : Dword;
  ls_quien_ocupa: string;
begin
  seconds := SecondsIdle;
  if(TimerAsignado.Enabled = False) then// Desasignamos de la venta y cambiamos el estatus
      seconds := 0;
  Caption := 'Pantalla para la venta de boletos ' + Format('Tiempo de venta %d seconds',[Seconds]);
  if ((seconds >= (li_tecla_espera * 60)) and (gb_asignado = True) and (gi_usuario_ocupado = 0)) then begin
    gb_asignado := False;
    TimerAsignado.Enabled := False;// Desasignamos de la venta y cambiamos el estatus
    seconds := 0;
    Caption := 'Pantalla para la venta de boletos ' + Format('Tiempo de venta %d seconds',[seconds]);
    if EjecutaSQL(format(_VTA_SI_YA_EXISTE, [gs_trabid, GetIPList, gs_terminal]), lq_query, _LOCAL) then // si existe el dato
      if EjecutaSQL(format(_VTA_UPDATE_NO_VENTA,[StrToInt(lq_query['ID_CORTE']), gs_terminal]), lq_query, _LOCAL) then begin // estatus = A
            enableTextInput();
            limpiar_La_labels(la_labels); // limpiamos las etiquetas
            gb_asignado := False;
            gs_trabid   := '';
            ac111.Enabled := True;
            ac116.Enabled := False;
            ac179.Enabled := False;
            acboleto.Enabled := False;
            acInicial.Enabled := False;
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
            if formPago = 1 then begin
                BorraAsiento(asientos_pago, li_ctrl_asiento);
                frm.Close;
                formPago := 0;
            end;
            if length(gs_corrida_apartada) > 0 then
                apartaCorrida(gs_corrida_apartada, gd_fecha_apartada,
                              gs_hora_apartada, gs_terminal_apartada, gs_trabid, gi_ruta_apartada);
      end;
  end;
end;


procedure TFrm_venta_principal.FormActivate(Sender: TObject);
var
  li_flujo: Integer;
begin
  enableTextInput();
  li_despachada := 0;
  stb_venta.Panels[0].Text := 'F1 Buscar';
  stb_venta.Panels[1].Text := 'F3 Opcion de busqueda';
  stb_venta.Panels[2].Text := 'F4 Ultima venta realizada';
  stb_venta.Panels[3].Text := 'F5 Cancela venta (Otra)';
  stb_venta.Panels[4].Text := 'F8 Forma pago (Otra)';
  // stb_venta.Panels[3].Text := 'F2 ';
  if gi_seleccion = _VENTA_INICIO then
  begin
    grp_cuales.Visible := False;
    lbledt_cuales.Clear;
    try
      grp_asientos.Visible := False;
      grp_corridas.Visible := True;
    except
    end;
    gi_cuales := 1;
    for li_flujo := low(asientos_pago) to high(asientos_pago) do
    begin
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

procedure TFrm_venta_principal.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if (gb_asignado) and (length(gs_trabid) > 0) then
    ac116Execute(Sender);
  BorraAsiento(asientos_pago,gi_idx_asientos);
  gb_asignado := False; // salir de la venta
  li_msg_password := 0;
  CONEXION_VTA := DM.Conecta;
  TRefrescaCorrida.Enabled := False;
  Close;
end;

procedure TFrm_venta_principal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  ls_mensaje_ocupante: string;
  frm: Tfrm_nombre_boleto;
  fpago: Tfrm_forma_pago;
  li_ctrl_grid, li_num, li_tmp: Integer;
  la_datos: gga_parameters;
begin
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key := 0;

  if Key = VK_F10 then
    keybd_event(VK_ESCAPE, 1, 0, 0);

  if (Key = VK_RETURN) and (gi_cuales = 2) then begin
    ejecutaCualesEnter();
  end;

  if (Key = VK_F1) and (li_corrida_selecciona = 0) then
  begin
    lb_opcion := False;
    splitLine(ls_Origen_vta.Text, '-', la_datos, li_num);
    if la_datos[1] = ls_Origen.Text then begin
      DM.desconectaServer();
      CONEXION_VTA := DM.Conecta;
      TRefrescaCorrida.Enabled := true;
      consigueCorridas();
    end;
  end;

  if (Key = vk_f3) and (ls_Desde_vta.Enabled) then
  begin
    ls_Desde_vta.ItemIndex := -1;
    Ed_Hora.Clear;
    ls_servicio.ItemIndex := -1;
    ls_Desde_vta.SetFocus;
    edt_corrida.Clear;
    exit;
  end;

  if ((Key = VK_F4) and (li_f4 = 1)) then begin
    corridasParametros(CORRIDA_ULTIMA.origen, CORRIDA_ULTIMA.destino,CORRIDA_ULTIMA.fecha, '', '', 0, stg_corrida, ''); // mostramos la corrida
    for li_ctrl_grid := 1 to stg_corrida.RowCount - 1 do begin
      if ((CORRIDA_ULTIMA.destino = stg_corrida.Cols[_COL_DESTINO].Strings[li_ctrl_grid]) and
          (CORRIDA_ULTIMA.hora = stg_corrida.Cols[_COL_HORA].Strings[li_ctrl_grid]) and
          (CORRIDA_ULTIMA.fecha = stg_corrida.Cols[_COL_FECHA].Strings[li_ctrl_grid]) and
          (CORRIDA_ULTIMA.servicio = stg_corrida.Cols[_COL_SERVICIO].Strings[li_ctrl_grid])) then begin
              Break;
          end;
    end;
    ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(CORRIDA_ULTIMA.origen);
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(CORRIDA_ULTIMA.servicio);
    ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(CORRIDA_ULTIMA.destino);
    medt_fecha.Text := CORRIDA_ULTIMA.fecha;
    Ed_Hora.Text := CORRIDA_ULTIMA.hora;
    edt_corrida.Text := CORRIDA_ULTIMA.corrida;
    pintaBusCorrida(stg_corrida.Row);
  end;


  if ((key = VK_F5) and (gi_seleccion = _VENTA_ELIGE_OTRA)) then begin
      BorraAsiento(asientos_pago, gi_arreglo);
      mensaje('Se han liberado los asientos de la venta',2);
      pintaBusCorrida(stg_corrida.Row);
      gi_seleccion := _VENTA_INICIO;
      gi_arreglo := 1;
  end;

  // Si presionamos F8 _VENTA_ELIGE_OTRA
  if ((Key = VK_F8) and (li_corrida_selecciona = 1)) then
  begin
    try
      lblEdt_cuantos.Visible := False;
      gi_seleccion := _VENTA_EFECTUADA;
      grp_cuales.Visible := True;
      lbledt_cuales.Clear;
      lbledt_cuales.SetFocus;
      gi_cuales := 1;
      gi_seleccion := _VENTA_INICIO;
    except
    end;
    exit;
  end;

  // usamos la tecla F7 = cuantos and F5 = cancelar
  if ((gi_ocupados = gi_cupo_ruta) and (gi_solo_pie > 0) and (gi_vta_pie = 1)
      and (Key = VK_F7)) then
  begin // podemos vender de pie
    Mensaje('Para esta venta solo se asignan los permitidos', 0);
    exit;
  end
  else
  begin
    if ((Key = VK_F7) and (li_corrida_selecciona = 1)) then
    begin
      try
        lblEdt_cuantos.EditLabel.Caption := 'Cuantos :';
//      lblEdt_cuantos.Visible := false;
        lbledt_cuales.Clear;
        lbledt_tipo.Clear;
        lblEdt_cuantos.Clear;
        grp_corridas.Visible := False;
        lbledt_cuales.Text := ' ';
        grp_cuales.Visible := False;
        grp_asientos.Visible := True;
        lblEdt_cuantos.Visible := True;
        lblEdt_cuantos.SetFocus;
        gi_seleccion := 0;
      except
      end;
      exit;
    end;
  end;

  if ((Key = VK_F5) and (li_corrida_selecciona = 1)) then
  begin
    try
    /// mostramos cancelar
      lbledt_cuales.Text := ' ';
      enableTextInput();
      apartaCorrida(gs_corrida_apartada, gd_fecha_apartada, gs_hora_apartada,
                    gs_terminal_apartada, gs_trabid,StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
      BorraAsiento(asientos_pago, li_ctrl_asiento);
      limpiaAsientosArreglo();

      lbledt_tipo.Clear;
      lblEdt_cuantos.Clear;
      grp_asientos.Visible := False;
      grp_asientos.Visible := False;
      grp_corridas.Visible := True;
      stg_corrida.Enabled := True;
      stg_corrida.SetFocus;
      gi_seleccion := _VENTA_INICIO;
      gi_cuales := 1;
      li_corrida_selecciona := 0;
      pintaBusCorrida(stg_corrida.Row);
    except
    end;
    exit;
  end;
end;

procedure TFrm_venta_principal.FormShow(Sender: TObject);
begin
  lbl_nombre.Caption := _NO_REGISTRADO;
  li_vta_anticipada_pago := 0;
  li_msg_password := 1;
  llenarArregloCaracteres(); // para la validacion del cuantos
  Titles; // coloca los titulos en el grid
  li_tecla_espera := tiempo_Espera_Grid();
  TimerAsignado.Enabled := False;
  ac111.Enabled := True;
  datos();
  li_ctrl_asiento := 1; // variable para el control de asientos asignados
  gi_cuales := 0;
  limpiar_La_labels(la_labels); // limpiamos las etiquetas
  gi_vta_pie := 0;
  li_corrida_selecciona := 0;
  Ed_Hora.Clear;
  gb_asignado := False;
  ac116.Enabled := False;
  li_f4 := 0;
  timer_pintabus.Interval := _RETRADADO;
  CONEXION_VTA := DM.Conecta;
  llenaOcupantesSAdulto();
  if EjecutaSQL('SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 12',lq_query,_LOCAL) then begin
      li_valor_refresca := lq_query['VALOR'];
  end;
  gi_arreglo := 1;
end;


procedure TFrm_venta_principal.lbledt_tipoChange(Sender: TObject);
var
  li_ctrl,  li_option, li_ctrl_ocupantes,li_num, li_ctrl_gga,li_indx,li_inc : integer;
  ls_input, lc_char, lc_espacio, lc_guion,lc_anterior, ls_union: String;
  la_datos  : gga_parameters;
begin
  lc_espacio := ' ';
  lc_guion := '-';
  li_option := 0;
  ls_input := lbledt_tipo.Text;
  for li_ctrl := 1 to length(ls_input) do begin
    if li_key_press_tipo = 8 then begin
        li_option := 5;
        break;
    end;

    if not(ls_input[1] in ['1' .. '9']) then begin
        lbledt_tipo.Clear;
        lbledt_tipo.setfocus;
        exit;
    end;

    lc_char := gds_ListaOcupantes.IDOf(gds_ListaOcupantes.ValueOf(UpperCase(ls_input[li_ctrl])));
    if ls_input[li_ctrl] <> ' ' then
      if not(ls_input[li_ctrl] in ['0' .. '9']) then begin
        if lc_char <> ls_input[li_ctrl] then begin // si no esta en la lista
          li_option := 1;
          Break;
        end;
        if lc_char = ls_input[li_ctrl] then begin//tenemos un caracter
            li_option := 4;
        end;
      end; // fin if
    if li_ctrl > 1 then begin
      lc_anterior := ls_input[li_ctrl - 1];
      if ((ls_input[li_ctrl - 1] = lc_espacio) or (ls_input[li_ctrl] = lc_guion)
        ) or ((ls_input[li_ctrl - 1] = lc_espacio) or (ls_input[li_ctrl] = lc_guion)) then
        li_option := 2;
    end; // fin if li_ctrl
    if (ls_input[1] = lc_espacio) or (ls_input[1] = lc_guion) then
      li_option := 2;
  end; // fin for

  for li_ctrl_gga := 1 to high(array_ocupantes) do
      array_ocupantes[li_ctrl_gga] := '';
  li_ctrl_ocupantes := 1;
  for li_ctrl := 1 to length(ls_input) do begin
    lc_char := gds_ListaOcupantes.IDOf(gds_ListaOcupantes.ValueOf(UpperCase(ls_input[li_ctrl])));
    if lc_char = ls_input[li_ctrl] then begin//tenemos un caracter
        if li_ctrl_ocupantes = 1 then
            array_ocupantes[li_ctrl_ocupantes] := lc_char +'|1';
        if li_ctrl_ocupantes > 1 then begin //tenemos datos
            for li_ctrl_gga := 1 to li_ctrl_ocupantes - 1 do begin
                splitLine(array_ocupantes[li_ctrl_gga],'|',la_datos,li_num);
                if la_datos[0] = lc_char then begin
                    li_inc := StrToInt(la_datos[1]);
                    inc(li_inc);
                    if li_inc > 1 then begin
                        Mensaje('Error en el tipo de boleto',1);
                        lbledt_tipo.Clear;
                        lbledt_tipo.SetFocus;
                        exit;
                    end;
                end else begin
                        array_ocupantes[li_ctrl_ocupantes] := lc_char +'|1';
                end;
            end;
        end;
        inc(li_ctrl_ocupantes);
    end;
  end;

  case li_option of
    1: lbledt_tipo.Text := UpperCase(reWrite(ls_input));
    4: lbledt_tipo.Text := UpperCase(reWrite(ls_input))+lc_char+' ';
    3: lbledt_tipo.Text := UpperCase(validaTipoHueco(ls_input));
  end;

  lbledt_tipo.SelStart := length(lbledt_tipo.Text);
end;



procedure TFrm_venta_principal.lbledt_tipoEnter(Sender: TObject);
begin
  li_ocupados_array := 1;
  gi_cuales := 1;
  if length(lbledt_cuales.Text) = 0 then
  begin
    lbledt_cuales.SetFocus;
    lbledt_cuales.Clear;
    Mensaje('Ingrese el numero de asiento a vender', 1);
    gi_cuales := 1;
    exit;
  end
  else
  begin
    gi_cuales := 2;
    li_memoria_cuales := 1;
  end;

end;

procedure TFrm_venta_principal.lbledt_tipoKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    li_key_press_tipo := Key;
end;

procedure TFrm_venta_principal.limpiaAsientosArreglo;
var
  li_flujo: Integer;
begin
  for li_flujo := low(asientos_pago) to high(asientos_pago) do
  begin
    asientos_pago[li_flujo].corrida := '';
    asientos_pago[li_flujo].asiento := 0;
    asientos_pago[li_flujo].fecha_hora := '';
    asientos_pago[li_flujo].empleado := '';
    asientos_pago[li_flujo].origen := '';
    asientos_pago[li_flujo].destino := '';
    asientos_pago[li_flujo].status := ' ';
  end;
  li_ctrl_asiento := 1; // variable para el control de asientos asignados
end;

procedure TFrm_venta_principal.lbledt_cualesChange(Sender: TObject);
var
  li_ctrl_input, li_ajusta: Integer;
  lc_char: Char;
  ls_input, ls_out, ls_anterior: String;
  lb_write: Boolean;
begin
  lb_write := False;
  li_ajusta := 0;
  ls_input := lbledt_cuales.Text;
  for li_ctrl_input := 1 to length(ls_input) do begin
    lc_char := ls_input[li_ctrl_input];
    if not existe(lc_char) then begin
      lb_write := True;
      Break;
    end; // sustituir caracter , por space
    if lc_char = la_separador[1] then begin
      lbledt_cuales.Text := reWrite(ls_input) + ' ';
    end;
    if li_ctrl_input > 1 then begin
      ls_anterior := ls_input[li_ctrl_input - 1];
      if ((ls_input[li_ctrl_input - 1] = ' ') and (ls_input[li_ctrl_input] = '-')) or
        ((ls_input[li_ctrl_input - 1] = '-') and  (ls_input[li_ctrl_input] = ' ')) or
        ((ls_input[li_ctrl_input - 1] = ' ') and  (ls_input[li_ctrl_input] = ' ')) then
        li_ajusta := 1;
    end; // fin li_ctrl
  end;
  if lb_write then
    lbledt_cuales.Text := reWrite(ls_input);

  if li_ajusta = 1 then begin
    for li_ctrl_input := 1 to length(ls_input) - 2 do begin
      ls_out := ls_out + ls_input[li_ctrl_input];
    end; // fin for
    lbledt_cuales.Text := ls_out + '-';
  end;
  lbledt_cuales.SelStart := length(lbledt_cuales.Text);
end;


procedure TFrm_venta_principal.lbledt_cualesEnter(Sender: TObject);
begin
  gi_cuales := 2;
  // liberamos la memoria de los registros
  if li_memoria_cuales = 1 then begin // regreso del cuadro de texto tipo es necesario borrarlos
    BorraAsientoArreglo(asientos_pago, gi_idx_asientos,
      stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]);
    lbledt_cuales.Clear;
    lbledt_cuales.SetFocus;
    li_memoria_cuales := 0;
  end;
  try
    pintaBusCorrida(stg_corrida.Row);
  except
  end;
  if length(lbledt_cuales.Text) = 0 then
  begin
    gi_cuales := 1;
  end;
end;

procedure TFrm_venta_principal.lbledt_cualesExit(Sender: TObject);
var
  la_unicos, la_rangos: gga_parameters;
  li_ctrl, li_num, li_new_ctrl, li_numero_asientos, li_idx_valida: Integer;
  array_cuales: la_asientos;
  lb_asientos_ok: Boolean;
  ls_str_store, ls_fecha_corrida_hora: string;
  ls_fecha_hora: String;
  store : TSQLStoredProc;
begin
  if length(lbledt_cuales.Text) = 0 then begin
    Mensaje(_ASIENTOS_VACIO,1);
    lbledt_cuales.SetFocus;
    exit;
  end;
  for li_ctrl := 0 to 50 do memoria_cuales[li_ctrl] := 0;

  try//obtenemos la tarifa
    ld_tarifa := tarifaCorrida(stg_corrida, ls_Origen_vta.CurrentID);
    li_numero_asientos := StrToInt(stg_corrida.Cols[_COL_ASIENTOS].Strings[stg_corrida.Row]);
    splitLine(lbledt_cuales.Text, ' ', la_unicos, li_num);
    // analizamos la linea previamente separada
    gi_idx_asientos := 0;
    lb_asientos_ok := False;
    for li_ctrl := 0 to li_num do begin
      if not rangoAsientos(la_unicos[li_ctrl]) then  begin // si no son por rango
        if la_unicos[li_ctrl] = '' then exit;
        array_cuales[gi_idx_asientos] := StrToInt(la_unicos[li_ctrl]);
        inc(gi_idx_asientos);
      end else begin
                splitLine(la_unicos[li_ctrl], '-', la_rangos, li_num);
                for li_new_ctrl := StrToInt(la_rangos[0]) to StrToInt(la_rangos[1]) do begin
                  array_cuales[gi_idx_asientos] := li_new_ctrl;
                  inc(gi_idx_asientos); // para el procedimiento
                end;
      end;
    end; // fin for
    for li_idx_valida := 0 to high(array_cuales) do begin
      if array_cuales[li_idx_valida] > li_numero_asientos then begin
        lb_asientos_ok := True;
        Break;
      end;
    end; // validamos el arreglo
    for li_idx_valida := 0 to gi_idx_asientos - 1 do begin
      if array_cuales[li_idx_valida] = 0 then begin
          Mensaje('No se pueden vender asientos "0"',1);
          li_ocupados_cuales := 1;
          lbledt_cuales.Clear;
          lbledt_cuales.SetFocus;
          exit;
      end;
    end;
    if gi_idx_asientos = 0 then begin
        Mensaje('Verifique los asientos a vender',1);
        li_ocupados_cuales := 1;
        lbledt_cuales.Clear;
        lbledt_cuales.SetFocus;
        exit;
    end;

    if gi_idx_asientos > gi_permitido_cupo then begin
      Mensaje(_MSG_VTA_PIE_LIMITE + #10#13 +' se ha excedido el cupo permitido : ' + IntToStr(gi_permitido_cupo),0);
      lbledt_cuales.Clear;
      lbledt_cuales.SetFocus;
      exit;
    end;

    if lb_asientos_ok then begin
        Mensaje(_MSG_ASIENTO_MAYOR_PERMITIDO, 0);
        apartaCorrida(gs_corrida_apartada, gd_fecha_apartada, gs_hora_apartada,
                      gs_terminal_apartada, gs_trabid,
                      StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
        lbledt_cuales.Clear;
        lbledt_cuales.SetFocus;
        gi_cuales := 1;
        exit;
    end; // valida que el numero de asiento sea permitido por el bus

    for li_ctrl := 0 to gi_idx_asientos - 1 do
      ls_str_store := ls_str_store + IntToStr(array_cuales[li_ctrl]) + ',';

    ls_str_store := Copy(ls_str_store, 0, length(ls_str_store) - 1);
    // CHECAR LA DISPONIBILIDAD DE LOS ASIENTOS
    li_opcion_fecha_string := 1;
    ls_fecha_hora := FormatDateTime('YYYY-MM-DD', StrToDateTime(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]));
    store := TSQLStoredProc.Create(nil);
    store.SQLConnection := CONEXION_VTA;
    store.Close;
    store.StoredProcName := 'PDV_STORE_BUSCA_CUALES_NEW_CUALES';
    store.Params.ParamByName('IN_FECHA').AsString    := FormatDateTime('YYYY-MM-DD', StrToDateTime(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]));
    store.Params.ParamByName('IN_CORRIDA').AsString  := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
    store.Params.ParamByName('IN_ASIENTOS').AsString :=  ls_str_store;
    store.Open;
    lb_asientos_ok := false;
    with store do begin
        First;
        while not EoF do begin
            lb_asientos_ok := true;
            next;
        end;
    end;
    store.Free;
    store := nil;
    if lb_asientos_ok then begin
      Mensaje('Los lugares se encuentran ocupados o reservados', 1);
      lbledt_cuales.Clear;
      lbledt_cuales.SetFocus;
      li_ocupados_cuales := 1;
      exit;
    end;

    ls_fecha_corrida_hora := FormatDateTime('YYYY-MM-DD', StrToDate(medt_fecha.Text)) + ' ' + Ed_Hora.Text;
    if tarifaCorrida(stg_corrida, ls_Origen_vta.CurrentID) <= 0 then begin
      Mensaje(format(_MENSAJE_TARIFA_CERO,[stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                      stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row],
                      stg_corrida.Cols[_COL_SERVICIO].Strings[stg_corrida.Row]]), 0);
      apartaCorrida(gs_corrida_apartada, gd_fecha_apartada, gs_hora_apartada, gs_terminal_apartada, gs_trabid,
                    StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
      try
        lbledt_cuales.Clear;
        lbledt_tipo.Clear;
        lblEdt_cuantos.Clear;
        grp_asientos.Visible := False;
        grp_corridas.Visible := True;
        stg_corrida.Enabled := True;
        stg_corrida.SetFocus;
        gi_cuales := 1;
      except
      end;
      exit;
    end;/// valida cupo por terminal si es mayor mensaje numero disponibles
    if tarifaCorrida(stg_corrida, ls_Origen_vta.CurrentID) = 0 then
        ld_tarifa := tarifaCorrida(stg_corrida, ls_Origen_vta.CurrentID);

    li_opcion_fecha_string := 1;
    procesoVentaCuales(array_cuales, gi_idx_asientos, stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row], // corrida
                      FormatDateTime('YYYY-MM-DD', StrToDate(medt_fecha.Text)) + ' ' + Ed_Hora.Text,
                      ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf(ls_Origen_vta.Text)],
                      ls_Desde_vta.IDs[ls_Desde_vta.Items.IndexOf(ls_Desde_vta.Text)],
                      gs_trabid, nombreServicio(stg_corrida.Cols[_COL_SERVICIO].Strings[stg_corrida.Row]),
                      ld_tarifa, asientos_pago, StrToInt(gs_maquina));
    memoria_cuales := array_cuales;
    try
      pintaBusCorrida(stg_corrida.Row);
    except
    end;
  except
  end;
end;


procedure TFrm_venta_principal.lbledt_cualesKeyPress(Sender: TObject;
  var Key: Char);
begin
  if (Key = #13)then begin
    li_ocupados_cuales := 0;
    lbledt_cualesExit(Sender);
    if li_ocupados_cuales = 1 then begin
      gi_cuales := 1;
      lbledt_cuales.Clear;
      lbledt_cuales.SetFocus;
      exit;
    end;
        ejecutaCualesEnter();
  end;
end;


procedure TFrm_venta_principal.lblEdt_cuantosChange(Sender: TObject);
var
  ls_input: string;
  li_ctrl_input: Integer;
begin
  ls_input := trim(lblEdt_cuantos.Text);
  for li_ctrl_input := 1 to length(ls_input) - 1 do
  begin
    if not(ls_input[li_ctrl_input] in ['0' .. '9']) then
    begin
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
    end;
  end;
end;


procedure TFrm_venta_principal.lblEdt_cuantosEnter(Sender: TObject);
begin
  gi_cuales := 1;
end;

procedure TFrm_venta_principal.lblEdt_cuantosExit(Sender: TObject);
begin
  lblEdt_cuantos.Clear;
end;

procedure TFrm_venta_principal.lblEdt_cuantosKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_fecha_corrida_hora, ls_mensaje: string;
  li_numero_asientos, li_asientos_insertados : Integer;
  lb_asientos_ok: Boolean;
begin
  if Key = #13 then begin // enter
    if length(lblEdt_cuantos.Text) = 0 then begin
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end; // fin if
    // validamos para la venta de pie
    if lblEdt_cuantos.Text = '0' then begin
      Mensaje('Seleccione un lugar correcto', 1);
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end;

    if (StrToInt(lblEdt_cuantos.Text) > gi_solo_pie) and (gi_vta_pie = 1) then begin
      Mensaje(_MSG_VTA_PIE_LIMITE, 0);
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end;
    if StrToInt(lblEdt_cuantos.Text) > gi_permitido_cupo then begin
      Mensaje(_MSG_VTA_PIE_LIMITE + #10#13 +
               ' se ha excedido el cupo permitido : ' + IntToStr(gi_permitido_cupo),0 );
      lblEdt_cuantos.Text := IntToStr(gi_permitido_cupo);
      lblEdt_cuantos.SelStart := length(lblEdt_cuantos.Text);
      lblEdt_cuantos.SetFocus;
      exit;
    end;

    li_cuales := 0;
    li_numero_asientos := StrToInt(stg_corrida.Cols[_COL_ASIENTOS].Strings
        [stg_corrida.Row]);
    // valida que el numero ingresado no sea mayor al numero de asientos del bus permitidos
    if StrToInt(lblEdt_cuantos.Text) > li_numero_asientos then begin
      Mensaje(_MSG_ASIENTO_MAYOR_PERMITIDO, 0);
      lblEdt_cuantos.Clear;
      lblEdt_cuantos.SetFocus;
      exit;
    end; // valida que el numero de asiento sea permitido por el bus
    // comparamos el numero de boletos solicitado  y el existente y disponible

    ls_fecha_corrida_hora := FormatDateTime('YYYY-MM-DD',
      StrToDate(medt_fecha.Text)) + ' ' + Ed_Hora.Text;
    // ld_tarifa := StrToFloat(stg_corrida.Cols[_COL_TARIFA].Strings[stg_corrida.Row]);
    if ld_tarifa <= 0 then begin
      Mensaje(format(_MENSAJE_TARIFA_CERO,
          [stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
          stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row],
          stg_corrida.Cols[_COL_SERVICIO].Strings[stg_corrida.Row]]), 0);
      apartaCorrida(gs_corrida_apartada, gd_fecha_apartada, gs_hora_apartada,
        gs_terminal_apartada, gs_trabid,
        StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
      try
        grp_asientos.Visible := False;
        grp_corridas.Visible := True;
        stg_corrida.Enabled := True;
        stg_corrida.SetFocus;
      except

      end;
      exit;
    end;
    procesoVentaCuantos(StrToInt(gds_buses.ValueOf(stg_corrida.Cols[_COL_AUTOBUS].Strings[stg_corrida.Row])),
                        stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],StrToInt(lblEdt_cuantos.Text),
                        stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]+ ' ' + Ed_Hora.Text,
                        ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf(ls_Origen_vta.Text)],
                        ls_Desde_vta.IDs[ls_Desde_vta.Items.IndexOf(ls_Desde_vta.Text)],gs_trabid,
                        nombreServicio(stg_corrida.Cols[_COL_SERVICIO].Strings[stg_corrida.Row]), ld_tarifa,
                        asientos_pago, StrToInt(gs_maquina),
                        StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]),li_asientos_insertados);
    pintaBusCorrida(stg_corrida.Row);
    stg_corrida.Enabled := True;
    if gi_arreglo > 1 then
        gi_arreglo := gi_arreglo + li_asientos_insertados;
    if gi_arreglo = 1 then
        gi_arreglo := li_asientos_insertados;
    if length(gs_corrida_apartada) > 0 then
      apartaCorrida(gs_corrida_apartada, gd_fecha_apartada,
        gs_hora_apartada, gs_terminal_apartada, gs_trabid,
        gi_ruta_apartada);
    // ShowMessage(lblEdt_cuantos.Text + ' boletos procesados en :' + FormatDateTime('HH:nn:ss.zzz', now-inicio));
    // si el usuario dio enter busca los lugares y aparta hacemos la busqueda a la
    frm := Tfrm_forma_pago.Create(nil); // validamos el cupo
    frm.vendidos := asientos_pago;
    formPago := 1;
    li_corrida_selecciona := 0;
    MostrarForma(frm);
    asientos_pago := asientos_regreso;// enableTextInput();
    keybd_event(VK_ESCAPE,1,0,0);  /// para enfocar en el grid
    try
      grp_asientos.Visible := False;
      grp_corridas.Visible := True;
    except
    end;
    ///
    pintaBusCorrida(stg_corrida.Row);
    if gi_seleccion = _VENTA_INICIO then begin
      FormActivate(Sender);
      stg_corrida.SetFocus;
    end;

    // si es cancelada borrar los lugares y refresh al picture
    if gi_seleccion = _VENTA_CANCELADA then begin
      try
        grp_corridas.Visible := True;
        grp_asientos.Visible := False;
        lblEdt_cuantos.Clear;
        stg_corrida.SetFocus;
        FormActivate(Self);
        CONEXION_VTA := DM.Conecta;
      except
      end;
    end;

    // Esta en memoria la seleccion del asiento y mostramos la corrida
    if gi_seleccion = _VENTA_ELIGE_OTRA then begin
      try
        ls_Desde_vta.ItemIndex := -1;
        ls_servicio.ItemIndex := -1;
        edt_corrida.Clear;
        enableTextInput;
        Ed_Hora.Clear;
        lblEdt_cuantos.Clear;
        grp_asientos.Visible := False;
        grp_corridas.Visible := True;
        medt_fecha.SetFocus;
      except
      end;
      exit;
    end;
    enableTextInput();
  end;
end;


procedure TFrm_venta_principal.ls_Desde_vtaExit(Sender: TObject);
var
  li_tmp: Integer;
begin
  li_tmp := ls_Desde_vta.IDs.IndexOf(UpperCase(ls_Desde_vta.Text));

  if ls_Desde_vta.ItemIndex < 0 then
    if li_tmp >= 0 then
      ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf
        (UpperCase(ls_Desde_vta.Text))
    else
      ls_Desde_vta.Text := '';
end;


procedure TFrm_venta_principal.ls_Desde_vtaKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_char: Char;
begin
  if Key = #13 then
  begin
    lb_opcion := False;
    consigueCorridas();
    li_valor_refresca := 2;
  end;
end;

procedure TFrm_venta_principal.ls_Origen_vtaKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_char: Char;
  ls_origen_terminal, ls_Origen: string;
begin
  if Key = #13 then
  begin
    // verificamos la terminal si es identica a la del archivo ini
    ls_origen_terminal := ls_Origen_vta.CurrentID;
    if ls_origen_terminal <> gs_terminal then
    begin
      if not conexionAServidor(ls_origen_terminal) then
      begin
        // regresamos el ls_origen al de la terminal gs_terminal
        ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf
          (UpperCase(gs_terminal));
        LimpiaSag(stg_corrida);
        LimpiaSag(stg_detalle);
      end;
      // generar el registro en el log se conexion
    end
    else
    begin
      DM.conectandoServer();
      CONEXION_VTA := DM.Conecta; // switch la conexion
      LimpiaSag(stg_corrida);
    end;
    if not gb_asignado then
      exit;
    consigueCorridas(); // @conseguimos las corridas
    stg_corrida.Row := gi_select_corrida;
  end;
end;


procedure TFrm_venta_principal.ls_servicioExit(Sender: TObject);
var
  li_tmp: Integer;
begin
  exit;
  li_tmp := ls_servicio.IDs.IndexOf(UpperCase(ls_servicio.Text));
  if ls_servicio.ItemIndex < 0 then
    if li_tmp >= 0 then
      ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf
        (UpperCase(ls_servicio.Text))
    else
      ls_servicio.Text := '';
end;


procedure TFrm_venta_principal.ls_servicioKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    lb_opcion := False;
    consigueCorridas();
    li_valor_refresca := 2;
  end;
end;


procedure TFrm_venta_principal.medt_fechaEnter(Sender: TObject);
begin
  medt_fecha.SelStart := 0;
end;


procedure TFrm_venta_principal.medt_fechaExit(Sender: TObject);
var
  ls_fecha: string;
  li_num: Integer;
  la_fecha: gga_parameters;
  myYear, myMonth, myDay: Word;
begin
  splitLine(medt_fecha.Text, '/', la_fecha, li_num);
  ls_fecha := la_fecha[0];
  if ls_fecha[1] = '0' then
    li_num := StrToInt(Copy(ls_fecha, 2, 1));
  try
    if li_num > DaysInMonth(StrToDateTime(medt_fecha.Text)) then
    begin
      Mensaje('Error en la fecha', 0);
      exit;
    end;
  except
    medt_fecha.Text := FechaServer();
  end;
end;

procedure TFrm_venta_principal.medt_fechaKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
    consigueCorridas();
end;


procedure TFrm_venta_principal.Modificar1Click(Sender: TObject);
var
    lfrm_forma: TfrmModificarCorrida;
    ls_promotor : string;
begin
      try
        ls_promotor := '';
        ls_promotor:= gs_trabid;
        if not AccesoPermitido(178, False) then begin
          gs_trabId:= ls_promotor;
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
      finally
        gs_trabId:= ls_promotor;
      if Length(ls_promotor) = 0 then begin
        gb_asignado := False;
        gs_trabid := '';
      end else
            gb_asignado := true;
      end;
end;

procedure TFrm_venta_principal.Cerrarcorrida1Click(Sender: TObject);
var
    ls_promotor : string;
    li_total : integer;
    la_datos : gga_parameters;
    li_num   : integer;
    hora     : string;
    lq_qry   : TSQLQuery;
begin
      try
          ls_promotor := '';
          ls_promotor:= gs_trabid;
        if not AccesoPermitido(184, False) then begin
          gs_trabId:= ls_promotor;
          exit;
        end;
      if Application.MessageBox(PChar(format(_MSG_CERRAR_CORRIDA,[stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.row]])), 'Confirme', _CONFIRMAR)
              = IDYES then begin
        li_total :=  existeVentaDeCorrida( StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                                StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                                stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],0);
        if li_total > 0 then begin
           mensaje(PWideChar(format(_MSG_ERROR_EXISTE_VENTA_CORRIDA,[li_total,stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]])),1);
           exit;
        end;
        splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row], ' ', la_datos,li_num);
        if li_num = 0 then hora := la_datos[0]
        else
            hora := la_datos[1];
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := CONEXION_VTA;
        if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,
            ['C',stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                formatDateTime('YYYY-MM-DD',
                      StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                hora,
                stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]]),lq_qry,_LOCAL) then begin
            Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
            GridDeleteRow(stg_corrida.Row, stg_corrida);
            pintaBusCorrida(stg_corrida.Row);
        end;
        lq_qry.Free;
        lq_qry := nil;
      end;
      finally
        gs_trabId:= ls_promotor;
        if Length(ls_promotor) = 0 then begin
          gb_asignado := False;
          gs_trabid := '';
        end else gb_asignado := true;

      end;
end;


procedure TFrm_venta_principal.pintaBusCorrida(li_indx: Integer);
var
  la_datos: gga_parameters;
  li_num: Integer;
  ls_fecha_ocupante: string;
  hilo_grid: DetalleRuta;
begin
  if length(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]) = 0 then
  begin
    Mensaje(_MSG_DATOS_CORRIDA, 0);
    exit;
  end;//obtenemos la tarifa
//  ld_tarifa := tarifaCorrida(stg_corrida, ls_Origen_vta.CurrentID);
  Image.Visible := True;
  splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos,
    li_num);
  if la_datos[0] = 'E' then
    ls_extra_imprime := ' Extra'
  else
    ls_extra_imprime := '';
  if li_num = 0 then
    Ed_Hora.Text := la_datos[0]
  else
    Ed_Hora.Text := la_datos[1];
  tarifaGridLlena(stg_corrida, ls_Origen_vta.CurrentID);
  ld_tarifa := StrToFloat(stg_corrida.Cols[_COL_TARIFA].Strings[stg_corrida.Row]);
  // @ mostramos los ocupantes para la corrida boleto y ocupante
  ls_fecha_ocupante := FormatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]));
  ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[li_indx]);
  edt_corrida.Text := stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx];
  ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(stg_corrida.Cols[_COL_DESTINO].Strings[li_indx]);
  medt_fecha.Text := stg_corrida.Cols[_COL_FECHA].Strings[li_indx];
  limpiar_La_labels(la_labels); // @ limpiamos las etiquetas

  showDetalleRuta(StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]), stg_detalle);
  obtenImagenBus(Image, stg_corrida.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
  muestraAsientosArreglo(la_labels,StrToInt(stg_corrida.Cols[_COL_AUTOBUS].Strings[li_indx]), pnlBUS);
  asientosOcupados(la_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),StrToTime(Ed_Hora.Text), stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
  showOcupantes(ls_Origen_vta.CurrentID, stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx],StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]), stg_ocupantes);

  gi_ruta := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]);
  Screen.Cursor := crDefault;
end;


procedure TFrm_venta_principal.Predespachar1Click(Sender: TObject);
var
  lq_qry: TSQLQuery;
  ls_fecha, ls_promotor: string;
begin
    if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
      exit;

    lq_qry := TSQLQuery.Create(nil);
     try
          ls_promotor := '';
          ls_promotor:= gs_trabid;
        if not AccesoPermitido(153, False) then begin
              gs_trabId:= ls_promotor;
            exit;
        end else begin
            lq_qry.SQLConnection := DM.Conecta;
            if EjecutaSQL(format(_UPDATE_CORRIDA_D, ['P', gs_trabid,
                stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                FormatDateTime('YYYY-MM-DD',
                  StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                gs_terminal, Ed_Hora.Text,
                stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]]), lq_qry,
              _LOCAL) then
              GridDeleteRow(stg_corrida.Row, stg_corrida);
            pintaBusCorrida(stg_corrida.Row);
            ls_Desde_vta.ItemIndex := 0;
            ls_servicio.ItemIndex := 0;
        end;
        lq_qry.Destroy;
    finally
    gs_trabId:= ls_promotor;
    if Length(ls_promotor) = 0 then begin
    gb_asignado := False;
    gs_trabid := '';
    end else gb_asignado := true;
  end;

end;

procedure TFrm_venta_principal.stg_corridaKeyPress(Sender: TObject; var Key: Char);
var
  frm: Tfrm_forma_pago;
  frm_Ocupada: TFrm_Corrida_Ocupada;
  ls_quien_ocupa: string;
  li_indx, li_num: Integer;
  la_datos: gga_parameters;
begin
  if Key = #13 then begin
    if length(stg_corrida.Cells[_COL_HORA, 1]) = 0 then
      exit;
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[stg_corrida.Row]);
    edt_corrida.Text := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
    ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(stg_corrida.Cols[_COL_DESTINO].Strings[stg_corrida.Row]);
    medt_fecha.Text := stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row];//validamos el estatus de la corrida
    if estatus_corrida( stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                       stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]) <> 'A' then begin
        Mensaje('El estatus de la corrida no se encuentra abierta para la venta',1);
        exit;
    end;
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row], ' ', la_datos,
      li_num);
    if la_datos[0] = 'E' then
      ls_extra_imprime := 'Extra'
    else
      ls_extra_imprime := '';
    if li_num = 0 then
      li_extra_corrida := 0
    else
      li_extra_corrida := 1;
//obtenemos la tarifa
    ld_tarifa := tarifaCorrida(stg_corrida, ls_Origen_vta.CurrentID);
    if ld_tarifa = 0 then begin
      Mensaje(format(_MENSAJE_TARIFA_CERO,[stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                    stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row],stg_corrida.Cols[_COL_SERVICIO].Strings[stg_corrida.Row]]), 2);
      exit;
    end;
    // antes aqui pintaba el bus
    if not gb_asignado then begin
      if not AccesoPermitido(_TAG_VENTA, False) then begin
        exit;
      end else begin
        asignarseVenta(); // @invocamos la asignacion a ala venta
        if gb_asignado = False then begin
          exit;
        end;
//        lbl_nombre.Caption := gs_nombre_trabid;
        if gb_fondo_ingresado = False then
          exit;
        gb_asignado := True;
      end; // gi_otro_boleto
    end;
    /// asignamos el valor de a las variables pertinentes
    TRefrescaCorrida.Enabled := False;
    stringDatosVenta();
    li_corrida_selecciona := 1;
    gi_fila_corrida := stg_corrida.Row;
    ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(UpperCase(stg_corrida.Cols[_COL_DESTINO].Strings[stg_corrida.Row]));
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[stg_corrida.Row]);
    gs_corrida_apartada := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
    gi_ruta_apartada := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
    gd_fecha_apartada := StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]);
    gs_hora_apartada := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
    gs_terminal_apartada := ls_Origen_vta.CurrentID;
    gi_ruta_apartada := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
    // obtiene todos los lugares por la ruta - 1 y la terminal donde se solicita
    gi_cupo_ruta := StrToInt(stg_corrida.Cols[_COL_ASIENTOS].Strings[stg_corrida.Row]); //Grid.Cells[_COL_ASIENTOS,li_indice]
    gi_ocupados := cupoCorridaVigente(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                      FormatDateTime('YYYY-MM-DD', gd_fecha_apartada), gs_hora_apartada,
                                      CONEXION_VTA);
    gi_solo_pie := cupoPieCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                  FormatDateTime('YYYY-MM-DD', gd_fecha_apartada), gs_terminal); // @cargamos el el grid
    if (gi_ocupados < (gi_cupo_ruta + gi_solo_pie)) then
      gi_permitido_cupo := (gi_cupo_ruta + gi_solo_pie) - gi_ocupados
    else
    begin
      Mensaje('no se puede vender, no hay mas lugares disponibles', 1);
      pintaBusCorrida(stg_corrida.Row);
      exit;
    end;

    if (gi_ocupados = gi_cupo_ruta) and (gi_solo_pie > 0) then
    // @ podemos vender de pie
      gi_vta_pie := 1;

    if (gi_ocupados > gi_cupo_ruta) and (gi_solo_pie = 0) then begin // podemos vender de pie
      Mensaje(_MSG_NO_VTA_DISPONIBLE, 1);
      stg_corrida.Row := stg_corrida.Row + 1;
      exit;
    end;

    ls_quien_ocupa := storeApartacorrida(gs_corrida_apartada,gd_fecha_apartada, gs_terminal_apartada, gs_trabid);
    gi_corrida_en_uso := 0; // valor de 0 si esta ocupada cambia a 1

    if ls_quien_ocupa <> gs_trabid then begin
      frm_Ocupada := TFrm_Corrida_Ocupada.Create(Self);
      frm_Ocupada.corrida := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
      frm_Ocupada.fecha := stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row];
      frm_Ocupada.hora := gs_hora_apartada;
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
    disableTextInput(); // desahabilitamos los cuadros de texto de entrada
    try
      stg_corrida.Enabled := False;
      grp_corridas.Visible := False;
      grp_asientos.Visible := True;
      grp_cuales.Visible := true;
      lblEdt_cuantos.EditLabel.Caption := '';
      lblEdt_cuantos.Visible := false;
      lbledt_cuales.SetFocus;
      stg_listaOcupantes.Cells[0, 0] := 'Abreviacion';
      stg_listaOcupantes.Cells[1, 0] := 'Descripcion';
      buscaOcupantes(stg_listaOcupantes);
    except
    end;
    if gi_cancelada = _VENTA_CANCELADA then begin
      try
        lblEdt_cuantos.Clear;
        grp_corridas.Visible := True;
        grp_asientos.Visible := False;
        stg_corrida.Enabled := True;
        stg_corrida.SetFocus;
      except
      end;
    end;
  end;
end;


procedure TFrm_venta_principal.stg_corridaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  li_ctrl: Integer;
  lb_ejecuta: Boolean;
  li_fila: Integer;
begin
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
      exit
    else pintaBusCorrida(stg_corrida.Row);
    if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) > 0 then  begin
      timer_pintabus.Enabled := True;
    end;
  end;
end;


procedure TFrm_venta_principal.timer_pintabusTimer(Sender: TObject);
begin
    timer_pintabus.Enabled := False;
    if li_ultima_corrida_procesada <> stg_corrida.Row then
    begin
      pintaBusCorrida(stg_corrida.Row);
      li_ultima_corrida_procesada := stg_corrida.Row;
    end;
end;


procedure TFrm_venta_principal.stg_corridaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, fila: Integer;
begin
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


procedure TFrm_venta_principal.stg_corridaSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
var
  Row, Col: Integer;
  Val: String;
begin
  Val := stg_corrida.Cells[ACol, ARow];
  Col := ACol;
  Row := ARow;
end;


procedure TFrm_venta_principal.stringDatosVenta;
var
  li_num: Integer;
  la_datos: gga_parameters;
begin
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row], ' ',
      la_datos, li_num);
    if li_num = 0 then // 0
      Ed_Hora.Text := la_datos[0]
    else
      Ed_Hora.Text := la_datos[1];
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(stg_corrida.Cols[_COL_SERVICIO].Strings[stg_corrida.Row]);
    ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(stg_corrida.Cols[_COL_DESTINO].Strings[stg_corrida.Row]);
    medt_fecha.Text := stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row];
end;

procedure TFrm_venta_principal.Titles;
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
  // stg_corrida.ColWidths[_COL_TARIFA] := 0;

  stg_ocupantes.ColWidths[0] := 160;
  stg_ocupantes.ColWidths[1] := 30;
end;


function TFrm_venta_principal.valida_Busqueda_Corrida: Boolean;
var
  lb_ok: Boolean;
begin
  lb_ok := True;
  if length(medt_fecha.Text) = 0 then begin
    lb_ok := False;
    medt_fecha.SetFocus;
    exit;
  end;
  if length(ls_Origen_vta.Text) = 0 then begin
    lb_ok := False;
    ls_Origen_vta.SetFocus;
    exit;
  end;
  Result := lb_ok;
end;

procedure TFrm_venta_principal.datos();
var
  lq_terminals: TSQLQuery;
begin
  lq_terminals := TSQLQuery.Create(nil);
  lq_terminals.SQLConnection := DM.Conecta;
  if EjecutaSQL(_VTA_TERMINALES, lq_terminals, _LOCAL) then begin
    LlenarComboBox(lq_terminals, ls_Origen, True);
    LlenarComboBox(lq_terminals, ls_Origen_vta, True);
    LlenarComboBox(lq_terminals, ls_Desde_vta, True);
    llenarTerminales(lq_terminals);
    ls_Origen.Text := gds_terminales.ValueOf(gs_terminal);
    /// la terminal actual
    ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(gs_terminal);
    medt_fecha.Text := FechaServer();

    if EjecutaSQL(_VTA_TIPO_SERVICIO, lq_terminals, _LOCAL) then
      LlenarComboBox(lq_terminals, ls_servicio, True);
    edt_corrida.Clear;
    Ed_Hora.Clear;
  end;
end;


procedure TFrm_venta_principal.edt_corridaChange(Sender: TObject);
var
  ls_efectivo, ls_input, ls_output: string;
  lc_char, lc_new: Char;
  li_idx, li_ctrl: Integer;
begin
  ls_input := '';
  ls_efectivo := edt_corrida.Text;
  for li_idx := 1 to length(ls_efectivo) do
  begin
    lc_char := UpCase(ls_efectivo[li_idx]);
    if ls_efectivo[1] = '0' then
    begin
      edt_corrida.Clear;
      edt_corrida.SetFocus;
      exit;
    end
    else
      ls_input := ls_input + lc_char;
    if not(lc_char in _CARACTERES_VALIDOS_CORRIDA) then
    begin
      for li_ctrl := 1 to length(ls_input) - 1 do
      begin
        lc_new := ls_input[li_ctrl];
        ls_output := ls_output + lc_new;
      end;
      edt_corrida.Text := UpperCase(ls_output);
      edt_corrida.SelStart := length(ls_output);
    end;
  end;
end;


procedure TFrm_venta_principal.edt_corridaKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_char: Char;
begin
  if Key = #13 then begin
    consigueCorridas();
    stg_corrida.Row := gi_select_corrida;
    li_valor_refresca := 2;
  end;
end;

procedure TFrm_venta_principal.Ed_fechaKeyPress(Sender: TObject; var Key: Char);
var
  ls_char: Char;
begin
  if Key = #13 then begin
    consigueCorridas();
    stg_corrida.Row := gi_select_corrida;
  end;
end;

procedure TFrm_venta_principal.Ed_Hora1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then begin
    lb_opcion := False;
    consigueCorridas();
    stg_corrida.Row := gi_select_corrida;
  end;
end;

/// validamos para el ingreso de formato de hora corta HH:MM
procedure TFrm_venta_principal.Ed_HoraChange(Sender: TObject);
begin
  HoraEntradaEdit(Ed_Hora);
  li_consulto_venta := 2;
end;

procedure TFrm_venta_principal.Ed_HoraExit(Sender: TObject);
begin // validamos el dato si tiene hora
  if length(Ed_Hora.Text) > 1 then
  begin
    if length(Ed_Hora.Text) < 5 then
    begin // colocamos la hora del server
      Ed_Hora.Text := horaServer();
    end;
  end;
end;

procedure TFrm_venta_principal.Ed_HoraKeyPress(Sender: TObject; var Key: Char);
var
  ls_char: Char;
begin
  if Key = #13 then
  begin
    lb_opcion := False;
    consigueCorridas();
    li_valor_refresca := 2;
  end;
end;

procedure TFrm_venta_principal.ejecutaCualesEnter;
var
  ls_mensaje_ocupante: string;
  frm: Tfrm_nombre_boleto;
  fpago: Tfrm_forma_pago;
  li_ctrl_grid, li_num: Integer;
  la_datos: gga_parameters;
begin
//validamos si tiene un elemento asientos_pago
  if asientos_pago[1].corrida = '' then
      exit;

  try
    li_memoria_cuales := 0;//analizamos laa entrada de los datos si esta repetido los datos error
    gds_ocupantes_asignados := TDualStrings.Create();
    ls_mensaje_ocupante := validaCualesOcupantes(lbledt_tipo.Text);
    if length(ls_mensaje_ocupante) > 0 then begin
        Mensaje(ls_mensaje_ocupante, 0);
        lbledt_tipo.Clear;
        lbledt_tipo.SetFocus;
        lbledt_tipo.SelStart := length(lbledt_tipo.Text);
        exit;
    end else begin // actualizamos la imagen con los datos correspondientes del asiento asignado
      // validar que el nnumero de asientos por tipo no sea mayor a los elegidos
      // gi_idx_asientos
      // mostramos los datos la forma de pagos
      recalculaPrecioConDescuento(asientos_pago); // recalculamos el arreglo de asietnos asignados en base si tenemos ocupantes especiales
      for li_num := gi_arreglo to 50 do begin
          if asientos_pago[li_num].corrida <> '' then begin
             asientos_pago[li_num].calculado   := 1;
             inc(gi_arreglo);
          end;
      end;
      li_actualiza_ruta := 0;
      if length(gs_corrida_apartada) > 0 then
        apartaCorrida(gs_corrida_apartada, gd_fecha_apartada, gs_hora_apartada, gs_terminal_apartada, gs_trabid, gi_ruta_apartada);

      fpago := Tfrm_forma_pago.Create(nil);
      fpago.vendidos := asientos_pago;
      MostrarForma(fpago);
      asientos_pago := asientos_regreso;
      enableTextInput();
      lbledt_cuales.Clear;
      lbledt_tipo.Clear;
      try
          lbledt_cuales.Text := ' ';
          grp_asientos.Visible := False;
          grp_corridas.Visible := True;
          gi_cuales := 1;
          li_corrida_selecciona := 0;
      except
      end;
      if gi_seleccion = _VENTA_INICIO then
          BorraArregloAsientos(asientos_pago);
      if gi_seleccion = _VENTA_CANCELADA then
          gi_seleccion := _VENTA_INICIO;
      try
          pintaBusCorrida(stg_corrida.Row);
      except
      end;
      stg_corrida.Enabled := True;
      stg_corrida.SetFocus;
      keybd_event(VK_ESCAPE, 1, 0, 0);
      stg_corrida.SetFocus;
      keybd_event(VK_ESCAPE, 1, 0, 0);
      /// para enfocar en el grid
      exit;
    end;
  except
    Mensaje('Error al ingresar el ocupante ' + #10#13 + 'Corrijalo y continue',0);
    lbledt_tipo.SetFocus;
    lbledt_tipo.SelStart := length(lbledt_tipo.Text);
  end;
end;


procedure TFrm_venta_principal.enableTextInput;
begin
  medt_fecha.Enabled := True;
  ls_Origen_vta.Enabled := True;
  ls_Desde_vta.Enabled := True;
  Ed_Hora.Enabled := True;
  ls_servicio.Enabled := True;
  edt_corrida.Enabled := True;
end;

procedure TFrm_venta_principal.disableTextInput;
begin
    medt_fecha.Enabled := False;
    ls_Origen_vta.Enabled := False;
    ls_Desde_vta.Enabled := False;
    Ed_Hora.Enabled := False;
    ls_servicio.Enabled := False;
    edt_corrida.Enabled := False;
end;

procedure TFrm_venta_principal.asignarseVenta;
var
      ls_ip, ls_taquilla, ls_status, ls_ip_qry: string;
      ls_qry: string;
      lf_forma: TFrm_reg_fondo_inicial;
begin
      ac111.Enabled := False;
      ac116.Enabled := True;
      ac179.Enabled := True;
      acInicial.Enabled := True;
      acboleto.Enabled := True;
      acAnticipada.Enabled := True;
      acimprimevta.Enabled := True;
      ls_ip := GetIPList;
      asignaVenta(gs_trabid, gs_terminal, StrToInt(gs_maquina));
      gb_asignado := True;
      TimerAsignado.Enabled := False;
      if gi_out_valida_asignarse = _E_ASIGNA_VTA_DUPLICADO then begin
        Mensaje('El usuario se encuentra asignado en otra taquilla', 1);
//        gs_nombre_trabid := '';
        gb_asignado := False;
        exit;
      end;
      if gi_out_valida_asignarse = _E_ASIGNA_PROCESO_CORTE then begin
        Mensaje('El usuario se encuentra en proceso de corte', 1);
//        gs_nombre_trabid := '';
        gb_asignado := False;
        exit;
      end;

      if gi_fondo_inicial_store = -1 then begin // solicitamos el fondo inicial
        lf_forma := TFrm_reg_fondo_inicial.Create(nil);
        MostrarForma(lf_forma);
        if VarIsNull(gi_fondo_inicial_store)  then
            if EjecutaSQL(format(_VTA_CORTE_FONDO, ['0', gi_corte_store, gs_trabid]), lq_query, _LOCAL) then ;
      end;

      if gi_fondo_inicial_store >= 0 then begin
        gb_fondo_ingresado := True;
        gb_asignado := True;
      end;

      if gb_fondo_ingresado = False then begin
        Mensaje('No esta asignado a la venta', 1);
//        gs_nombre_trabid := '';
        if EjecutaSQL(format(_VTA_CORTE_FONDO, ['0', gi_corte_store, gs_trabid]), lq_query, _LOCAL) then ;

        lbl_nombre.Caption := _NO_REGISTRADO;
        ac111.Enabled := True;
        ac116.Enabled := False;
        ac179.Enabled := False;
        acInicial.Enabled := False;
        acboleto.Enabled := False;
        acAnticipada.Enabled := False;
        acimprimevta.Enabled := False;
        gb_asignado := False;
        exit;
      end;

      if gi_fondo_inicial_store = -1 then begin // solicitamos el fondo inicial
        if EjecutaSQL(format(_VTA_CORTE_FONDO, [gs_fondo_inicial, gi_corte_store,
            gs_trabid]), lq_query, _LOCAL) then
          Gr_Corridas.Enabled := True;
      end;
      if gb_asignado then
          ac160.Enabled := True;
      TimerAsignado.Enabled := True;
      ls_promotor_asignado := gs_trabid;
      Gr_Corridas.Enabled := True;
end;




procedure TFrm_venta_principal.a111Execute(Sender: TObject);
begin
  if not AccesoPermitido(_TAG_VENTA, False) then begin
    FormShow(Sender);
    exit;
  end else begin
//    lbl_nombre.Caption := gs_nombre_trabid;
    gb_asignado := True;
    asignarseVenta();
  end;
end;


procedure TFrm_venta_principal.ac116Execute(Sender: TObject);
var
  lq_query: TSQLQuery;
begin
  try
      lq_query := TSQLQuery.Create(nil);
      lq_query.SQLConnection := CONEXION_VTA; // DM.Conecta;
      asignaVenta(gs_trabid, gs_terminal, StrToInt(gs_maquina));
      limpiar_La_labels(la_labels); // limpiamos las etiquetas
      If Application.MessageBox(PWideChar('¿Desea pausar la venta?' + #13#10 + 'SI : pausara la venta' + #13#10 + 'NO: generara un corte'),
        'Atención', MB_YESNO + MB_DEFBUTTON1 + MB_ICONQUESTION) = IDYES then Begin
        if EjecutaSQL(format(_VTA_UPDATE_NO_VENTA, [gi_corte_store, gs_terminal]),lq_query, _LOCAL) then
          ;
        gb_asignado := False;
        ac111.Enabled := True;
        ac116.Enabled := False;
        ac160.Enabled := False;
        ac179.Enabled := False;
        acboleto.Enabled := False;
        acInicial.Enabled := False;
        acAnticipada.Enabled := False;
        acimprimevta.Enabled := False;
        lbl_nombre.Caption := _NO_REGISTRADO;
        edt_corrida.Clear;
        ls_servicio.ItemIndex := -1;
        Ed_Hora.Clear;
        ls_Desde_vta.ItemIndex := -1;
        Image.Visible := false;
        LimpiaSag(stg_corrida);
        LimpiaSagTodo(stg_ocupantes);
        LimpiaSagTodo(stg_detalle);
        Titles; // coloca los titulos en el grid
      end
      else
      begin
        If Application.MessageBox(PWideChar('Si la seleccion es "si"' + #13#10 +
              'no podra realizar venta' + #13#10 +
              'hasta que se realize el corte'), 'Advertencia',
          MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION) = IDYES then
        Begin
          if EjecutaSQL(format(_VTA_UPDATE_EN_PROCESO, [gi_corte_store,
              gs_terminal]), lq_query, _LOCAL) then
            ;
          gb_asignado := False;
          ac111.Enabled := True;
          ac116.Enabled := False;
          ac179.Enabled := False;
          ac160.Enabled := False;
          acboleto.Enabled := False;
          acInicial.Enabled := False;
          acAnticipada.Enabled := False;
          acimprimevta.Enabled := False;
          LimpiaSagTodo(stg_ocupantes);
          LimpiaSagTodo(stg_detalle);
          edt_corrida.Clear;
          ls_servicio.ItemIndex := -1;
          Ed_Hora.Clear;
          ls_Desde_vta.ItemIndex := -1;
          lbl_nombre.Caption := _NO_REGISTRADO;
        end
        else
        begin
          if EjecutaSQL(format(_VTA_UPDATE_NO_VENTA, [gi_corte_store,
              gs_terminal]), lq_query, _LOCAL) then
            ;
          gb_asignado := False;
          ac111.Enabled := True;
          ac116.Enabled := False;
          ac179.Enabled := False;
          acboleto.Enabled := False;
          acInicial.Enabled := False;
          acAnticipada.Enabled := False;
          acimprimevta.Enabled := False;
          LimpiaSagTodo(stg_ocupantes);
          LimpiaSagTodo(stg_detalle);
          edt_corrida.Clear;
          ls_servicio.ItemIndex := -1;
          Ed_Hora.Clear;
          ls_Desde_vta.ItemIndex := -1;
        end;
      end;

      lq_query.Free;
      lq_query := nil;
  except

  end;
  TRefrescaCorrida.Enabled := False;
end;

procedure TFrm_venta_principal.FormCreate(Sender: TObject);
begin
  gi_otro_boleto := 0;
  lq_query := TSQLQuery.Create(Self);
  lq_query.SQLConnection := CONEXION_VTA; // DM.Conecta;
  la_labels[1] := Addr(Label100);
  la_labels[2] := Addr(Label101);
  la_labels[3] := Addr(Label102);
  la_labels[4] := Addr(Label103);
  la_labels[5] := Addr(Label104);
  la_labels[6] := Addr(Label105);
  la_labels[7] := Addr(Label106);
  la_labels[8] := Addr(Label107);
  la_labels[9] := Addr(Label108);
  la_labels[10] := Addr(Label109);
  la_labels[11] := Addr(Label110);
  la_labels[12] := Addr(Label111);
  la_labels[13] := Addr(Label112);
  la_labels[14] := Addr(Label113);
  la_labels[15] := Addr(Label114);
  la_labels[16] := Addr(Label115);
  la_labels[17] := Addr(Label116);
  la_labels[18] := Addr(Label117);
  la_labels[19] := Addr(Label118);
  la_labels[20] := Addr(Label119);
  la_labels[21] := Addr(Label120);
  la_labels[22] := Addr(Label121);
  la_labels[23] := Addr(Label122);
  la_labels[24] := Addr(Label123);
  la_labels[25] := Addr(Label124);
  la_labels[26] := Addr(Label125);
  la_labels[27] := Addr(Label126);
  la_labels[28] := Addr(Label127);
  la_labels[29] := Addr(Label128);
  la_labels[30] := Addr(Label129);
  la_labels[31] := Addr(Label130);
  la_labels[32] := Addr(Label131);
  la_labels[33] := Addr(Label132);
  la_labels[34] := Addr(Label133);
  la_labels[35] := Addr(Label134);
  la_labels[36] := Addr(Label135);
  la_labels[37] := Addr(Label136);
  la_labels[38] := Addr(Label137);
  la_labels[39] := Addr(Label138);
  la_labels[40] := Addr(Label139);
  la_labels[41] := Addr(Label140);
  la_labels[42] := Addr(Label141);
  la_labels[43] := Addr(Label142);
  la_labels[44] := Addr(Label143);
  la_labels[45] := Addr(Label144);
  la_labels[46] := Addr(Label145);
  la_labels[47] := Addr(Label146);
  la_labels[48] := Addr(Label147);
  la_labels[49] := Addr(Label148);
  la_labels[50] := Addr(Label149);
  la_labels[51] := Addr(Label150);
end;
}
end.
