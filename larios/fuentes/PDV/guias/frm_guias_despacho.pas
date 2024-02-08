unit frm_guias_despacho;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DMdb, ActnList, ToolWin, ComCtrls, Grids, U_venta, comun, ExtCtrls,
  Menus, StdCtrls, lsCombobox, u_guias, DB, CNumLtr, u_main,
  PlatformDefaultStyleActnCtrls, ActnMan, ActnCtrls, ActnMenus, Buttons,
  System.Win.ComObj, Data.SqlExpr,
  FMTBcd, DBClient, SimpleDS, ActiveX, System.Actions;

type
  Tfrm_guias_servicio = class(TForm)
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    gpo_tarjeta: TGroupBox;
    cmb_operador1: TlsComboBox;
    Label1: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbl_ruta: TLabel;
    lbl_hora: TLabel;
    lbl_fecha: TLabel;
    lbl_terminal: TLabel;
    lbl_destino: TLabel;
    ActionMainMenuBar1: TActionMainMenuBar;
    GroupBox1: TGroupBox;
    stg_despacho: TStringGrid;
    Panel2: TPanel;
    ActionManager1: TActionManager;
    ac155: TAction;
    ac156: TAction;
    ac157: TAction;
    ac99: TAction;
    SpeedButton1: TSpeedButton;
    SimpleDataSet1: TSimpleDataSet;
    Timer: TTimer;
    PopupMenu1: TPopupMenu;
    Abrir1: TMenuItem;
    Cerrar1: TMenuItem;
    Despachar: TMenuItem;
    Panel3: TPanel;
    Reimprime1: TMenuItem;
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
    Label2: TLabel;
    edt_total_pax: TEdit;
    stg_detalle_ocupantes: TStringGrid;
    ApartaAsientos1: TMenuItem;
    Predespacharcorrida1: TMenuItem;
    SpeedButton2: TSpeedButton;
    acGuadarGuia: TAction;
    lbl_proveedor: TLabel;
    lbl_cuota: TLabel;
    cmb_proveedor: TlsComboBox;
    lbl_folio: TLabel;
    edt_folio: TEdit;
    cmb_cuota: TlsComboBox;
    cmb_cemos: TComboBox;
    edt_folio_cemos: TEdit;
    lbl_cemos_tipo: TLabel;
    lbl_folio_cemo: TLabel;
    cmb_autobus: TlsComboBox;
    Timer_guias: TTimer;
    Label4: TLabel;
    edt_boletera: TEdit;
    img_central: TImage;
    mem_conectado: TMemo;
    Tping: TTimer;
    pnl_lector: TPanel;
    SpeedButton3: TSpeedButton;
    edt_barras: TEdit;
    lst_mensaje: TListBox;
    Memo1: TMemo;
    CodigoBarras1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure stg_despachoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ac155Execute(Sender: TObject);
    procedure stg_despachoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Imprime1Click(Sender: TObject);
    procedure ac99Execute(Sender: TObject);
    procedure Abrircorrida1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure stg_despachoKeyPress(Sender: TObject; var Key: Char);
    procedure cmb_operador1KeyPress(Sender: TObject; var Key: Char);
    procedure Abrir1Click(Sender: TObject);
    procedure Cerrar1Click(Sender: TObject);
    procedure DespacharClick(Sender: TObject);
    procedure ac156Execute(Sender: TObject);
    procedure Reimprime1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ac157Execute(Sender: TObject);
    procedure ApartaAsientos1Click(Sender: TObject);
    procedure Predespacharcorrida1Click(Sender: TObject);
    procedure acGuadarGuiaExecute(Sender: TObject);
    procedure cmb_proveedorKeyPress(Sender: TObject; var Key: Char);
    procedure cmb_proveedorSelect(Sender: TObject);
    procedure edt_folioChange(Sender: TObject);
    procedure edt_folio_cemosChange(Sender: TObject);
    procedure edt_boleteraChange(Sender: TObject);
    procedure TpingTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure edt_barrasChange(Sender: TObject);
    procedure edt_barrasKeyPress(Sender: TObject; var Key: Char);
    procedure CodigoBarras1Click(Sender: TObject);
    procedure edt_folioExit(Sender: TObject);
  private
    { Private declarations }
    procedure asignaDatosPanel();
    function  validainputCombo(tipo : String): Boolean;
    procedure pintaBusCorrida(li_indx: Integer);
    procedure llenarProveedor();
    procedure visualizaProveedor();
    function buscaCorrida(corrida: string) : Boolean;
    function getFolioConsult() : Boolean;
    procedure borraFolioSalida();
    procedure predespacharCorrida();
    procedure habilitaPanelCuotas();
    procedure DeshabilitaPanelCuotas();
    procedure Update_SALIDA_CONTROL();
    procedure Insert_Incidencia(ls_idx : string);
    procedure Insert_Salida_Control();
    procedure Insert_folio_salida();
  public
    { Public declarations }
  end;

var
  frm_guias_servicio: Tfrm_guias_servicio;

implementation

uses frm_reimpresion, frm_aparta_asientos, frm_mensaje_corrida,
  ThreadPingServer, frm_lectorBarras, U_acceso, u_impresion, TRemotoRuta;
var
    gli_provedor, gli_cuota, gli_folio, gli_cantidad, gli_inicial : Integer;
    gli_folio_cuota, gli_asignado, gli_consecutivo : integer;
    gli_opcionFolio : Integer;
{$R *.dfm}
var
  la_labels: labels_asientos;
  gi_proveedor : integer;
  gi_lector    : integer;
  gi_cemos     : integer;
  pingHilo : TPingServer;

procedure Tfrm_guias_servicio.Abrir1Click(Sender: TObject);
var
    hora : string;
    li_num : integer;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
begin
    if not AccesoPermitido(183,False) then
        exit;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio') then begin
        Mensaje('No se puede "Abrir" en una corrida de vacio, solo se puede despachar',1);
        Exit;
    end;
//cambiar
    if gi_corrida_restringida = 0 then begin
      if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada') then begin
          Mensaje('No se permisos para abrir la corrida',1);
          exit;
      end;
    end;

    if ((stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Cerrada') or
         (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada') or //then begin
         (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada')) then begin
        if Application.MessageBox(PChar(format(_MSG_ABRIR_CORRIDA,
              [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR) = IDYES then begin
          splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ', la_datos,li_num);
          if li_num = 0 then
              hora := la_datos[0]
          else
              hora := la_datos[1];
          if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,
              ['A',stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                  formatDateTime('YYYY-MM-DD',
                          StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                  hora,
                  stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then begin
              if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada')then begin
                   gpo_tarjeta.Visible := False;
              end;
              Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
              stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Abierta';
              stg_despacho.SetFocus;
              Panel3.Visible := False;
              insertaEvento(gs_trabid,gs_terminal,'Abre la corrida ' +
                            stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row]+' '+
                            stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]+' '+
                            stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]);
              if gi_lector = 1 then begin
                  if gpo_tarjeta.Visible then begin
                      gpo_tarjeta.Visible := False;
                      cmb_operador1.ItemIndex := -1;
                      cmb_cuota.ItemIndex := -1;
                      edt_folio.Clear;
                      cmb_autobus.ItemIndex := -1;
                      cmb_operador1.ItemIndex := -1;
                      edt_folio_cemos.Clear;
                      edt_boletera.Clear;
                  end;

                  pnl_lector.Visible := True;
                  edt_barras.Clear;
              end;
          end;
        end;
    end else begin
        Mensaje('No puede abrir una corrida con estatus "Abierta" ',1);
    end;
    lq_qry.Free;
    lq_qry := nil;

end;

procedure Tfrm_guias_servicio.Abrircorrida1Click(Sender: TObject);
begin
    if not AccesoPermitido(159,False) then
        exit;
    apartaCorrida(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                  StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]),
                  gs_hora_apartada, gs_terminal,gs_trabid,
                  StrToInt(stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]));
    stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Abierta';
end;

procedure Tfrm_guias_servicio.ac155Execute(Sender: TObject);
var
    lq_qry : TSQLQuery;
    ls_servicio,ls_date,ls_idx,ls_hora, ls_status, ls_folio, ls_cuota, ls_proveedor, ls_server    : string;
    ls_sentenciaRuta : String;
    lc_ingreso : Currency;
    la_datos : gga_parameters;
    li_num, li_cemos, I : Integer;
    ls_sel_cemos, ls_str, ls_tipoCorrida, ls_fechaGuia, ls_terminalGuia : string;
    ls_char : char;
    Hilo_Ruta    : RemotoRuta;
begin
    if validainputCombo(stg_despacho.Cells[_COL_STATUS,stg_despacho.Row]) then
        exit;
    lq_qry := TSQLQuery.Create(nil); //solicitamos los datos del proveedor con una nueva forma de entrada de datos
    try
      lq_qry.SQLConnection := DM.Conecta;//obtenemos el servicio
      if EjecutaSQL(FORMAT(_GUIA_SERVICIOID,[stg_despacho.Cells[_COL_SERVICIO,stg_despacho.Row]]),lq_qry,_LOCAL) then
          ls_servicio := lq_qry['TIPOSERVICIO'];
      if EjecutaSQL(_GUIA_NOW,lq_qry,_LOCAL) then//fecha actual
          ls_date := FormatDateTime('YYYY-MM-DD HH:nn:SS',  lq_qry['FECHA']); //obtener el ingreso de la guia todos los boletos de la corrida que se despacha
      if EjecutaSQL(format(_GUIA_INGRESO_BOLETO,[stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                                lbl_fecha.Caption, gs_terminal]),lq_qry,_LOCAL) then
          lc_ingreso := lq_qry['INGRESO'];
      ls_idx := inttoStr(getMaxTable('ID_GUIA','PDV_T_GUIA'));
      splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row],' ',la_datos,li_num);
      if li_num = 0 then
         ls_hora :=  la_datos[0]
      else ls_hora :=  la_datos[1];//BUSCAMOS SI ESTA CORRIDA TIENE UN REGISTRO EN LA GUIA
      if EjecutaSQL(format(_GUIA_EXISTENTE,[stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                              lbl_fecha.Caption,
                                              gs_terminal]),lq_qry,_LOCAL) then
      if not VarIsNull(lq_qry['ID_GUIA']) then begin//obtenemos el dato de la guia
        if EjecutaSQL(format(_GUIA_EXISTENTE,[stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                              lbl_fecha.Caption,
                                              gs_terminal]),lq_qry,_LOCAL) then begin
            ls_idx := lq_qry['ID_GUIA'];
            ls_fechaGuia := FormatDateTime('YYYY-MM-DD', lq_qry['FECHA']);
            ls_terminalGuia := lq_qry['ID_TERMINAL'];
            li_existe_tabla := 1;
            if EjecutaSQL(format(_GUIA_BORRAR_EXISTENTE,[ls_idx]),lq_qry, _LOCAL) then
                ;
            if EjecutaSQL(format(_GUIA_BORRAR_EXISTENTE_SERVER,[ls_idx, ls_terminalGuia, ls_fechaGuia]),lq_qry, _SERVIDOR_CENTRAL) then
                ;
        end;
      end else begin
            li_existe_tabla := 0;
      end;
      if (gi_proveedor = 1) and (stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] <> 'Vacio') then begin
          ls_folio := edt_folio.Text;
          ls_cuota := cmb_cuota.CurrentID;
          ls_proveedor := cmb_proveedor.CurrentID;
      end else begin
          ls_folio := '0';
          ls_cuota := '0';
          ls_proveedor := '0';
      end;
      if gi_cemos = 1 then begin
          if cmb_cemos.ItemIndex = 3 then
              li_cemos := StrToInt(edt_folio_cemos.Text);

      end else begin
          li_cemos := 0;
      end;
      if length(cmb_cemos.Text) = 0 then
          ls_sel_cemos := 'Sin Selección'
      else
          ls_sel_cemos := cmb_cemos.Text;
      if Length(edt_boletera.Text) = 0 then
        edt_boletera.Text := '0';

      EjecutaSQL(Format(_GUIA_DE_VIAJE_BORRAR,[ls_idx, gs_terminal]),lq_qry, _SERVIDOR_CENTRAL);

      ls_char := stg_despacho.Cells[_COL_HORA,stg_despacho.Row][1];
      case ls_char of
          'E' : begin
                  for I := 2 to length(stg_despacho.Cells[_COL_HORA,stg_despacho.Row]) do
                      ls_str := ls_str + stg_despacho.Cells[_COL_HORA,stg_despacho.Row][I];
                end;
          else
              ls_str := stg_despacho.Cells[_COL_HORA,stg_despacho.Row];
      end;
      if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Predespachada' then ls_tipoCorrida := 'D';
      if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Despachada' then ls_tipoCorrida := 'D';
      if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Vacio' then ls_tipoCorrida := 'V';

      ls_server := Format(_GUIA_DE_VIAJE,[ls_idx,///1
                            gs_terminal,//2
                            lbl_fecha.Caption,//3
                            stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],//4
                            stg_despacho.Cells[_COL_DESTINO,stg_despacho.Row],//5
                            cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],//6
                            FloatToStr(lc_ingreso),//7
                            cmb_operador1.IDs[cmb_operador1.Items.IndexOf(cmb_operador1.Text)]//8
                            ,gs_trabid,//9
                            ls_servicio,//10
                            stg_despacho.Cells[_COL_RUTA,stg_despacho.Row],//11
                            ls_folio,//12
                            ls_cuota,//13
                            ls_proveedor,//14
                            ls_sel_cemos,//15
                            IntToStr(li_cemos),//16
                            edt_boletera.Text,
                            ls_str,//17
                            ls_tipoCorrida
                             ]
                             );
            Sleep(100);
            EjecutaSQL(ls_server,lq_qry,_LOCAL);
            EjecutaSQL(ls_server,lq_qry,_SERVIDOR_CENTRAL);

            cmb_cuota.Clear;
            edt_folio.Clear;
            if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio' then ls_status := 'V'
            else ls_status := 'D';
            if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,[ls_status,stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                      formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                      ls_hora, stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then begin
                  if ls_status = 'V' then
                        stg_despacho.Cells[_COL_STATUS,stg_despacho.Row]  := 'Vacio';//liberamos la corrida mandamos los asientos al resto de la ruta
                  generaGuiaViaje(ls_idx,stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row], lbl_fecha.Caption,ls_hora,0,
                                        gs_terminal,gs_trabid);
                  gs_destino_ruta := stg_despacho.Cols[_COL_DESTINO].Strings[stg_despacho.Row];
                  try
                    if EjecutaSQL(_GUIA_BORRAR_CAPTURA, lq_qry, StrToInt(stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]) ) then
                        ;
                  except
                  end;

                  try
                    if EjecutaSQL(Format(_GUIA_CAPTURA_ESPECIFICA, [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                                         formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]))
                                              ]),lq_qry, StrToInt(stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]) )  then
                                ;
                    Sleep(1000);
                   ls_sentenciaRuta := format(_GUIA_PRECAPTURA_NUEVO,[
                                                              stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                              formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                              stg_despacho.Cols[_COL_DESTINO].Strings[stg_despacho.Row],
                                                              stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row],
                                                              cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                                              cmb_operador1.IDs[cmb_operador1.Items.IndexOf(cmb_operador1.Text)]
                                                              ]);
                    Hilo_Ruta := RemotoRuta.Create(true);
                    Hilo_Ruta.ruta := StrToInt(stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]);
                    Hilo_Ruta.destino := gs_destino_ruta;
                    Hilo_Ruta.server :=DM.Conecta;
                    Hilo_Ruta.sentencia := ls_sentenciaRuta;
                    Hilo_Ruta.terminal  := gs_terminal;
                    Hilo_Ruta.Priority  := tpNormal;
                    Hilo_Ruta.FreeOnTerminate := True;
                    Hilo_Ruta.Resume;

                  except
                      ;
                  end;

                  if EjecutaSQL(format(_GUIA_AUTOBUS_CORRIDA,[
                                cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                lbl_fecha.Caption,
                                ls_hora]),lq_qry,_LOCAL) then
                                ;
                  if EjecutaSQL(format(_GUIA_AUTOBUS_CORRIDA,[
                                cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                lbl_fecha.Caption,
                                ls_hora]),lq_qry,_SERVIDOR_CENTRAL) then
                                ;
                  if EjecutaSQL(format(_GUIA_AUTOBUS_CORRIDA,[
                                cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                lbl_fecha.Caption,
                                ls_hora]),lq_qry,_SERVIDOR_CENTRAL) then

                        cmb_operador1.ItemIndex := -1;
                        cmb_autobus.ItemIndex   := -1;
                        gpo_tarjeta.Visible := False;
                        cmb_cemos.ItemIndex := -1;
                        edt_folio_cemos.Clear;
                        panel3.visible := false;
                        edt_boletera.Text := '0';
                        habilitaPanelCuotas();
                  if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio' then
                      ls_status := 'V'
                  else begin
                            ls_status := 'D';
                            stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] := 'Despachada';
                  end;
                  if EjecutaSQL(format(_GUIA_UPDATE_CORRIDA,[ls_status,stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                                lbl_fecha.Caption,gs_terminal,
                                                ls_hora]),lq_qry,_SERVIDOR_CENTRAL) then
              end;
              if gi_lector = 1 then begin
                gpo_tarjeta.Visible := False;
                pnl_lector.Visible := True;
                edt_barras.Clear;
                edt_barras.SetFocus;
              end;
              if gli_opcionFolio = 0 then
                  Insert_Salida_Control();

              if gli_opcionFolio = 1 then begin//no SON IDENTICOS
              //insertamos el evento con #de guia, fecha y hora, folio real, folio permitido , proveedor, cuota
                  Insert_Incidencia(ls_idx);
                  Insert_Salida_Control();
              end;

              if gli_opcionFolio = 2 then //SON IDENTICOS
                  Update_SALIDA_CONTROL();

              if gli_opcionFolio = 3 then //NO SON IDENTICOS GUARDA EN LA TABLA EL EVENTO
                  Update_SALIDA_CONTROL();
              Insert_folio_salida();
    finally
      lq_qry.Destroy;
    end;
end;

procedure Tfrm_guias_servicio.edt_folioExit(Sender: TObject);
var
    lq_qry : TSQLQuery;
    li_cuantos : integer;
begin
    gli_provedor := StrToInt(cmb_proveedor.CurrentID);
    gli_cuota    := StrToInt(cmb_cuota.CurrentID);
    gli_opcionFolio := -1;
    try
      gli_folio_cuota := StrToInt(edt_folio.Text);
    except
        on E : Exception do begin
            ShowMessage(E.Message);
            edt_folio.Clear;
            edt_folio.SetFocus;
        end;
    end;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add('SELECT I.FOLIO, D.FOLIO_INICIAL, CANTIDAD');
    lq_qry.SQL.Add('FROM PDV_T_INVENTARIO_CUOTA I INNER JOIN PDV_T_INVENTARIO_CUOTA_D D ON  D.FOLIO = I.FOLIO');
    lq_qry.SQL.Add('INNER JOIN PDV_C_PROVEEDOR_CUOTA C ON C.IDENTIFICADOR = D.PROVEEDOR');
    lq_qry.SQL.Add('INNER JOIN PDV_C_TIPO_CUOTA  T  ON T.IDENTIFICADOR = D.TIPO_CUOTA');
    lq_qry.SQL.Add('WHERE I.ESTADO = ''A'' AND  I.ID_USUARIO = :gs_trabid AND PROVEEDOR = :li_provedor AND TIPO_CUOTA = :li_cuota');
    lq_qry.Params[0].AsString  := gs_trabid;
    lq_qry.Params[1].AsInteger := gli_provedor;
    lq_qry.Params[2].AsInteger := gli_cuota;
    lq_qry.Open;
    try
       gli_folio    := lq_qry['FOLIO'];
       gli_inicial  := lq_qry['FOLIO_INICIAL'];
       gli_cantidad := lq_qry['CANTIDAD'];
//buscamos si tenemos datos en la tabla
      lq_qry.SQL.Clear;
      lq_qry.SQL.Add('SELECT COUNT(CONSECUTIVO)AS CUANTOS, CONSECUTIVO, IFNULL(ASIGNADO,0)as ASIGNADO FROM PDV_T_SALIDA_CONTROL ');
      lq_qry.SQL.Add('WHERE FOLIO = :li_folio AND ');
      lq_qry.SQL.Add('PROVEEDOR = :li_provedor AND TIPO_CUOTA = :li_cuota');
      lq_qry.SQL.Add('AND INICIAL = :li_inicial AND CANTIDAD = :li_cantidad');
      lq_qry.Params[0].AsInteger := gli_folio;
      lq_qry.Params[1].AsInteger := gli_provedor;
      lq_qry.Params[2].AsInteger := gli_cuota;
      lq_qry.Params[3].AsInteger := gli_inicial;
      lq_qry.Params[4].AsInteger := gli_cantidad;
      lq_qry.Open;
      li_cuantos := lq_qry['CUANTOS'];
    except
      li_cuantos := 0;
    end;
    if li_cuantos = 0 then begin
        try
          gli_asignado := lq_qry['ASIGNADO'];
        except
          gli_asignado := 0;
        end;
        //si el folio ingresado es igual que tenemos registrado en el inventario_cuota_d
        if gli_inicial = gli_folio_cuota then begin
            gli_opcionFolio := 0;
        end;
        if gli_inicial <> gli_folio_cuota then begin
          if MessageDlg('Desea continuar con este folio no, correponde al folio inicial', mtConfirmation,mbYesNo,0)  =  mrYes then begin
            gli_opcionFolio := 1;
            gli_consecutivo := gli_inicial + 1;
          end;
        end;
    end;

    if li_cuantos = 1 then begin
      if (lq_qry['CONSECUTIVO'] + 1) = gli_folio_cuota then begin
          gli_opcionFolio := 2;
          gli_consecutivo := gli_folio_cuota;
      end;
      //buscamos si ya se registro
      if not (getFolioConsult) then begin
          if (((lq_qry['CONSECUTIVO'] + 1) < gli_folio_cuota) or ((lq_qry['CONSECUTIVO'] + 1) > gli_folio_cuota)) then begin
              if MessageDlg('Desea continuar con este folio, no correponde al ultimo consecutivo', mtConfirmation,mbYesNo,0)  =  mrYes then begin
                  gli_opcionFolio := 3;
                  gli_consecutivo := lq_qry['CONSECUTIVO'];
              end;
          end;
      end else begin
//            ShowMessage('No se puede utilizar este numero de folio, ya fue asignado');
              if MessageDlg('Desea utilizar este numero de folio, ya fue asignado', mtConfirmation,mbYesNo,0)  =  mrYes then begin
                  borraFolioSalida();
              end else begin
                        edt_folio.SetFocus;
                        edt_folio.Clear;
              end;
      end;
    end;
    lq_qry.Free;
    lq_qry := nil;
end;




procedure Tfrm_guias_servicio.ac156Execute(Sender: TObject);
var
    lf_forma : Tfrm_reimprimeguia;
begin
    Timer.Enabled := False;
    lf_forma := Tfrm_reimprimeguia.Create(nil);
    MostrarForma(lf_forma);
    Timer.Enabled := True;
    TimerTimer(Sender);
end;


procedure Tfrm_guias_servicio.ac157Execute(Sender: TObject);
var
    lfr_forma : Tfrm_aparta_lugares;
    frm_Ocupada: TFrm_Corrida_Ocupada;
    ls_ocupa : String;
begin
    ls_ocupa := storeApartacorrida(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                      StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]),
                      gs_Terminal,gs_trabid);
    if ls_ocupa <> gs_trabid then begin
      frm_Ocupada := TFrm_Corrida_Ocupada.Create(Self);
      frm_Ocupada.corrida := stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row];
      frm_Ocupada.fecha := stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row];
      frm_Ocupada.hora := stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row];
      MostrarForma(frm_Ocupada);
//      TRefrescaCorrida.Enabled := True;
      if gi_corrida_en_uso > 0 then begin // salimos
        stg_despacho.Row := stg_despacho.Row;
        stg_despacho.Enabled := True;
        stg_despacho.SetFocus;
        gi_corrida_en_uso := 0;
        pintaBusCorrida(stg_despacho.Row);
        exit;
      end;
    end;
    lfr_forma := Tfrm_aparta_lugares.Create(nil);
    lfr_forma.TraficoGrid := stg_despacho;
    lfr_forma.li_row_corrida := stg_despacho.Row;
    MostrarForma(lfr_forma);
    pintaBusCorrida(stg_despacho.Row);
end;

procedure Tfrm_guias_servicio.ac99Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_guias_servicio.acGuadarGuiaExecute(Sender: TObject);
begin
////guardamos la guia
end;

procedure Tfrm_guias_servicio.ApartaAsientos1Click(Sender: TObject);
var
    lfr_forma : Tfrm_aparta_lugares;
    frm_Ocupada: TFrm_Corrida_Ocupada;
    ls_ocupa : String;
begin
    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio') then begin
        Mensaje('No se puede "Apartar Asientos" en una corrida de vacio, solo se puede despachar',1);
        Exit;
    end;
    if not (stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Abierta')  then  begin
        Mensaje('No se puede apartar asientos, el estatus no esta "abierta"',2);
        exit;
    end;

    ls_ocupa := storeApartacorrida(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                      StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]),
                      gs_Terminal,gs_trabid);
    if ls_ocupa <> gs_trabid then begin
      frm_Ocupada := TFrm_Corrida_Ocupada.Create(Self);
      frm_Ocupada.corrida := stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row];
      frm_Ocupada.fecha := stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row];
      frm_Ocupada.hora := stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row];
      MostrarForma(frm_Ocupada);
      if gi_corrida_en_uso > 0 then begin // salimos
        stg_despacho.Row := stg_despacho.Row;
        stg_despacho.Enabled := True;
        stg_despacho.SetFocus;
        gi_corrida_en_uso := 0;
        pintaBusCorrida(stg_despacho.Row);
        exit;
      end;
    end;
    lfr_forma := Tfrm_aparta_lugares.Create(nil);
    lfr_forma.TraficoGrid := stg_despacho;
    lfr_forma.li_row_corrida := stg_despacho.Row;
    MostrarForma(lfr_forma);
    pintaBusCorrida(stg_despacho.Row);
end;


procedure Tfrm_guias_servicio.asignaDatosPanel;
var
    ls_char : Char;
    i : Integer;
    ls_str  : string;
begin
      lbl_terminal.Caption :=  'Clave de Terminal : ' + gs_terminal;
      lbl_ruta.Caption  := stg_despacho.Cells[_COL_RUTA,stg_despacho.Row];
      lbl_fecha.Caption := FormatDateTime('YYYY-MM-DD' ,StrToDateTime(stg_despacho.Cells[_COL_FECHA,stg_despacho.Row]));
      lbl_destino.Caption := 'Destino : ' + stg_despacho.Cells[_COL_DESTINO,stg_despacho.Row];
      ls_char := stg_despacho.Cells[_COL_HORA,stg_despacho.Row][1];
      case ls_char of
          'E' : begin
                  for I := 2 to length(stg_despacho.Cells[_COL_HORA,stg_despacho.Row]) do
                      ls_str := ls_str + stg_despacho.Cells[_COL_HORA,stg_despacho.Row][I];
                end;
          else
              ls_str := stg_despacho.Cells[_COL_HORA,stg_despacho.Row];
      end;
      lbl_hora.Caption := ls_str;
end;


procedure Tfrm_guias_servicio.borraFolioSalida;
var
    lq_salida : TSQLQuery;
begin
    lq_salida := TSQLQuery.Create(nil);
    lq_salida.SQLConnection := DM.Conecta;
    lq_salida.SQL.Clear;
    lq_salida.SQL.Add('DELETE FROM PDV_T_FOLIO_SALIDA');
    lq_salida.SQL.Add('WHERE folio = :gli_folio AND proveedor = :gli_provedor and tipo_cuota = :gli_cuota AND trabid = :gs_trabid AND consecutivo = :gli_consecutivo');
    lq_salida.Params[0].AsInteger := gli_folio;
    lq_salida.Params[1].AsInteger := gli_provedor;
    lq_salida.Params[2].AsInteger := gli_cuota;
    lq_salida.Params[3].AsString  := gs_trabid;
    lq_salida.Params[4].AsInteger := gli_consecutivo;
    lq_salida.ExecSQL;
    lq_salida.Free;
end;

function Tfrm_guias_servicio.buscaCorrida(corrida: string) : Boolean;
var
    li_row, li_col : integer;
    lb_out : Boolean;
begin
    lb_out := False;
    for li_row := 0 to stg_despacho.RowCount - 1 do begin
        if stg_despacho.Cells[6, li_row] = corrida then begin
            stg_despacho.Row := li_row;
            lb_out := True;
            Break;
        end;
    end;
    Result := lb_out;
end;

procedure Tfrm_guias_servicio.Cerrar1Click(Sender: TObject);
var
    li_total, li_num : integer;
    hora : string;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio') then begin
        Mensaje('No se puede "Cerar" en una corrida de vacio, solo se puede despachar',1);
        Exit;
    end;

    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada') then begin
        Mensaje('No se puede "Abrir" en una corrida de Despachad, se ha emitido una guia de viaje',1);
        Exit;
    end;

    if ((stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Abierta') or
         (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada') or
         (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada')) then begin
        if Application.MessageBox(PChar(format(_MSG_CERRAR_CORRIDA,
              [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR)
          = IDYES then begin
            li_total :=  existeVentaDeCorrida( StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]),
                                    StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]),
                                    stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],0);
            if li_total > 0 then begin
               mensaje(PWideChar(format(_MSG_ERROR_EXISTE_VENTA_CORRIDA,[li_total,
                                        stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])),1);
               exit;
            end;
          splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ', la_datos,li_num);
          if li_num = 0 then
              hora := la_datos[0]
          else
              hora := la_datos[1];
          if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,
              ['C',stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                  formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                  hora,
                  stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
              if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada')then begin
                   gpo_tarjeta.Visible := False;
              end;

              Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
              stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Cerrada';
              stg_despacho.SetFocus;
              Panel3.Visible := False;
              insertaEvento(gs_trabid,gs_terminal,'Cierre de la corrida ' +
                            stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row]+' '+
                            stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]+' '+
                            stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]);
        end;
    end else begin
               Mensaje('No puede cerrar una corrida con estatus "Cerrada" ',1);
    end;
    lq_qry.Free;
    lq_qry := nil;
end;

procedure Tfrm_guias_servicio.cmb_operador1KeyPress(Sender: TObject;
  var Key: Char);
var
    la_datos : gga_parameters;
    li_num, li_tmp  : integer;
begin
    if Key = #13 then begin
        splitLine(cmb_operador1.Text,' ',la_datos,li_num);
        if length(la_datos[0]) <> 0 then begin
            ac155Execute(Sender);
            stg_despacho.SetFocus;
        end;
    end;
end;

procedure Tfrm_guias_servicio.cmb_proveedorKeyPress(Sender: TObject; var Key: Char);
var
    li_idx_table : integer;
    lq_coutas : TSQLQuery;
begin
    if key = #13 then begin
        li_idx_table := StrToInt(cmb_proveedor.CurrentID);
        lq_coutas := TSQLQuery.Create(nil);
        lq_coutas.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(_OLLIN_CUOTAS,[intToStr(li_idx_table)]), lq_coutas, _LOCAL) then begin
            cmb_cuota.Clear;
            LlenarComboBox(lq_coutas,cmb_cuota,False);
            cmb_cuota.ItemIndex := -1;
            cmb_cuota.SetFocus;
        end;
        lq_coutas.Free;
    end;

end;

procedure Tfrm_guias_servicio.cmb_proveedorSelect(Sender: TObject);
var
    li_idx_table : integer;
    lq_coutas : TSQLQuery;
begin
        li_idx_table := StrToInt(cmb_proveedor.CurrentID);
        lq_coutas := TSQLQuery.Create(nil);
        lq_coutas.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(_OLLIN_CUOTAS,[intToStr(li_idx_table)]), lq_coutas, _LOCAL) then begin
            cmb_cuota.Clear;
            LlenarComboBox(lq_coutas,cmb_cuota,False);
            cmb_cuota.ItemIndex := -1;
            if cmb_cuota.Enabled then
                cmb_cuota.SetFocus;
        end;
        lq_coutas.Free;
end;


procedure Tfrm_guias_servicio.CodigoBarras1Click(Sender: TObject);
var
    lq_qry, lq_consulta : TSQLQuery;
    ls_qry, ls_corrida, ls_detalle, ls_terminal, ls_code : string;
    ga_corrida, ga_valores : gga_parameters;
    li_num : integer;
begin//genera el codigo de barras para envio de whatsapp
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_GUIA_NOW, lq_qry, _LOCAL) then begin
        if formatDateTime('YYYY-MM-DD', lq_qry['FECHA']) <> formatdatetime('YYYY-MM-DD', StrToDate(stg_despacho.Cells[_COL_FECHA, stg_despacho.Row])) then begin
            Mensaje('Solo se permite una fecha igual a la actual', 2);
            exit;
        end;
    end;
    splitLine(stg_despacho.Cells[_COL_HORA, stg_despacho.Row],' ',ga_corrida, li_num);
    if ga_corrida[0] <> 'E' then begin
      Mensaje('Unicamente en corrídas extras se genera código de barras para su replicación',2);
      Exit;
    end;

    if EjecutaSQL(Format(_CODE_BARS_LINEA,['%PDV_T_CORRIDA(%','%'+stg_despacho.Cells[_COL_CORRIDA, stg_despacho.Row]+'%']), lq_qry, _LOCAL) then begin
        while not lq_qry.Eof do begin
          ls_terminal := lq_qry['ID_TERMINAL'];
          if (ls_terminal <> '1730') and (gs_terminal <> ls_terminal)then begin
              splitLine(lq_qry['SENTENCIA'],',',ga_corrida, li_num);
              splitLine(ga_corrida[10],':',ga_corrida, li_num);
              ga_corrida[0] := StringReplace(ga_corrida[0],'''','',[rfReplaceAll, rfIgnoreCase]);
              ga_corrida[1] := StringReplace(ga_corrida[1],'''','',[rfReplaceAll, rfIgnoreCase]);
              ls_code := forza_der(stg_despacho.Cells[_COL_CORRIDA, stg_despacho.Row], 6) + ga_corrida[0]+ga_corrida[1];
              ls_qry := Format(_CODIGO_BARS,[stg_despacho.Cells[_COL_CORRIDA, stg_despacho.Row],
                                                 formatdatetime('YYYY-MM-DD', StrToDate(stg_despacho.Cells[_COL_FECHA, stg_despacho.Row]) ) ]);
              lq_consulta := TSQLQuery.Create(nil);
              lq_consulta.SQLConnection := DM.Conecta;
              if EjecutaSQL(ls_qry, lq_consulta, _LOCAL) then begin
                ls_code := ls_code + forza_der(lq_consulta['ID_TIPO_AUTOBUS'], 2) +
                                     forza_der(lq_consulta['TIPOSERVICIO'], 2) +
                                     forza_der(lq_consulta['ID_RUTA'], 4);
              end;
              if EjecutaSQL(Format(_CODE_BARS_DETALLE,['%PDV_T_CORRIDA_D(%', '%'+stg_despacho.Cells[_COL_CORRIDA, stg_despacho.Row]+'%',
                                                     ls_terminal]), lq_consulta, _LOCAL) then begin
                  if not VarIsNull(lq_consulta['SENTENCIA']) then begin
                      splitLine(lq_consulta['SENTENCIA'],',',ga_corrida, li_num);
                      splitLine(ga_corrida[11],':',ga_valores, li_num);
                      ga_valores[0] := StringReplace(ga_valores[0],'''','',[rfReplaceAll, rfIgnoreCase]);
                      ga_valores[1] := StringReplace(ga_valores[1],'''','',[rfReplaceAll, rfIgnoreCase]);
                      ga_corrida[12] := StringReplace(ga_corrida[12],' ','',[rfReplaceAll, rfIgnoreCase]);
                      ls_code := ls_code + ga_valores[0]+ga_valores[1]+ga_corrida[12];

                      ls_OPOS := inicializarImpresora_OPOS;
                      ls_OPOS := ls_OPOS + textoAlineado_OPOS('Codigo barras para la terminal ' + ls_terminal, 'c');
                      ls_OPOS := ls_OPOS + codigoDeBarrasUniDimensional_OPOS( ls_code );
                      ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(0);
                      ls_OPOS := ls_OPOS + corte_OPOS;
                      escribirAImpresora(gs_impresora_general, ls_OPOS);
                  end;
              end;
              lq_consulta.Free;
              lq_consulta := nil;

          end;
          lq_qry.Next;
        end;

    end;

{  if EjecutaSQL(ls_qry, lq_qry, _LOCAL) then begin
        ls_OPOS := inicializarImpresora_OPOS;
        ls_OPOS := ls_OPOS + codigoDeBarrasUniDimensional_OPOS(forza_der(lq_qry['ID_CORRIDA'], 6)+
                                                               forza_der(lq_qry['ID_RUTA'], 4)+
                                                               forza_der(lq_qry['TIPOSERVICIO'], 2)+
                                                               forza_der(lq_qry['ID_TIPO_AUTOBUS'], 2)+
                                                               forza_der('123456', 6)
                                                              );
        ls_OPOS := ls_OPOS + SaltosDeLinea_OPOS(0);
        ls_OPOS := ls_OPOS + corte_OPOS;
        escribirAImpresora(gs_impresora_general, ls_OPOS);
    end;}
    lq_qry.Free;
    lq_qry := nil;
end;


procedure Tfrm_guias_servicio.FormActivate(Sender: TObject);
begin
    if gi_conexion_server = 1 then begin
{        pingHilo := TPingServer.Create(true);
        pingHilo.memo  := mem_conectado;
        pingHilo.image := img_central;
        pingHilo.Priority := tpNormal;
        pingHilo.FreeOnTerminate := true;
        pingHilo.Resume;}
    end;
end;



procedure Tfrm_guias_servicio.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    li_tarjeta_viaje := 0;
    Timer.Enabled := False;
    Tping.Enabled := False;
    gi_proveedor := 0;
    gi_cemos     := 0;
    if Assigned(pingHilo) then begin
        TerminateThread(pingHilo.Handle,0);
        Tping.Enabled := False;
    end;
end;

procedure Tfrm_guias_servicio.FormCreate(Sender: TObject);
begin
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

procedure Tfrm_guias_servicio.FormShow(Sender: TObject);
var
    lq_qry : TSQLQuery;
    li_ctrl : Integer;
    lb_ejecuta : Boolean;
    ls_estatus, ls_hora, ls_qhora, ls_qminuto, hora_salida, value : string;
    la_datos: gga_parameters;
    li_num : integer;
    li_hora, li_minuto : integer;
    frm_barras : Tfrm_lector;
begin
    if (VarIsNull(gs_terminal) or (length(gs_terminal) = 0)) then
        LecturaIni();

    lb_ejecuta := true;
    li_tarjeta_viaje := 1;
    gi_proveedor := getparametroProveedor();
    gi_lector    := getParametroLector();

//habilitamos el timer para efectuar el ping
    Tping.Interval := gi_tiempo_ping;
    Tping.Enabled := True;

    if gi_proveedor = 1 then
        llenarProveedor();

    gi_cemos := getParametroCemos();

    if gi_cemos = 0 then begin
        lbl_cemos_tipo.Visible := False;
        lbl_folio_cemo.Visible := False;
        cmb_cemos.Visible := False;
        edt_folio_cemos.Visible := False;
    end else begin
        lbl_cemos_tipo.Visible := True;
        lbl_folio_cemo.Visible := True;
        cmb_cemos.Visible := True;
        edt_folio_cemos.Visible := True;
    end;


    titulosCorridaGrid(stg_despacho);
    stg_despacho.Cells[_COL_STATUS,0] := 'Estatus';
    stg_despacho.ColWidths[_COL_STATUS] := 100;
    stg_despacho.ColWidths[_COL_TARIFA] := 0;
    if VarIsNull(gs_terminal) then begin
        LecturaIni();
        muestraEstatus(gs_terminal,stg_despacho);
    end;

    muestraEstatus(gs_terminal,stg_despacho);
    Timer.Enabled := True;
    //si tenemos una predespachada visualizamos la opcion para despacharla
    if gi_lector = 1 then begin
///mostramos la pantalla para solicitar el ingreso por codigo de barras
      pnl_lector.Visible := True;
      edt_barras.SetFocus;
    end;
    if gi_lector = 0 then begin
        if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Predespachada'  then begin
             lq_qry := TSQLQuery.Create(nil);
              lq_qry.SQLConnection := DM.Conecta;
            edt_total_pax.Text :=  IntToStr(total_pasajeros_corrida(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                     formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])) ));
            pintaBusCorrida(stg_despacho.Row);
            if lb_ejecuta then begin
                if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Predespachada' then begin
                     lq_qry := TSQLQuery.Create(nil);
                     lq_qry.SQLConnection := CONEXION_VTA;
                     //VALIDAMOS
                      splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ',la_datos, li_num);
                      if li_num = 0 then // 0
                        hora_salida := la_datos[0]
                      else
                        hora_salida := la_datos[1];
                      ls_hora := 'SELECT (HOUR(HORA))AS HORA, (MINUTE(HORA) + (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 9)) AS MINUTO '+
                                 'FROM PDV_T_CORRIDA_D '+
                                 'WHERE FECHA = ''%s'' AND ID_CORRIDA = ''%s'' AND HORA = CAST(''%s'' AS TIME)';
                      if EjecutaSQL(format(ls_hora,[formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                   stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                     hora_salida
                                              ]),lq_qry,_LOCAL) then begin
                            if lq_qry['MINUTO'] >= 60 then begin
                                li_minuto := lq_qry['MINUTO'] mod 60;//obtenemos los minutos restantes
                                if lq_qry['HORA'] = '23' then
                                  li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
                                else begin
                                      li_hora := lq_qry['HORA'] + 1;
                                end;
                            end else begin
                                li_minuto := lq_qry['MINUTO'];
                                if lq_qry['HORA'] = '23' then
                                    li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
                                else
                                li_hora := lq_qry['HORA'];
                            end;
                           if li_hora < 10 then
                                ls_qhora := '0' + IntToStr(li_hora)
                           else ls_qhora := IntToStr(li_hora);
                           if li_minuto < 10 then
                                ls_qminuto := '0' + IntToStr(li_minuto)
                           else ls_qminuto := IntToStr(li_minuto);
                           ls_hora := ls_qhora + ':' + ls_qminuto;
                      end;
                      ls_hora := 'SELECT CAST('''+ ls_hora +''' AS TIME) > (DATE_FORMAT(current_timestamp(),''%T''))AS AHORA';
                      if EjecutaSQL(ls_hora,lq_qry,_LOCAL) then
                            gpo_tarjeta.Visible := True;
                            asignaDatosPanel();

                            gpo_tarjeta.Visible := True;
                            if gi_proveedor = 1 then
                               cmb_proveedor.SetFocus;

                            Panel3.Visible  := True;
                            if EjecutaSQL(_GUIA_AUTOBUS,lq_qry,_LOCAL) then
                                LlenarComboTarjeta(lq_qry,cmb_autobus);
                            if EjecutaSQL(_GUIA_OPERADOR,lq_qry,_LOCAL) then
                                LlenarComboTarjeta(lq_qry,cmb_operador1);
        //mostramos los datos en el grid
                            if EjecutaSQL(format(_GUAI_DETALLE_PASAJERO,[
                                                  formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                  stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
                            if ejecutaSQL(format(_GUIA_TOTAL_DESTINO,[
                                                  formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                  stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then begin
                                stg_detalle_ocupantes.ColWidths[0] := 200;
                                with lq_qry do begin
                                    First;
                                    li_num := 0;
                                    while not EoF do begin
                                        stg_detalle_ocupantes.Cells[0,li_num] := lq_qry['DESCRIPCION'];
                                        stg_detalle_ocupantes.Cells[1,li_num] := lq_qry['TOTAL'];
                                        inc(li_num);
                                        next;
                                    end;
                                    stg_detalle_ocupantes.RowCount := li_num;
                                end;
                            end;
                            visualizaProveedor();//error trafico
                            if gi_lector = 0 then begin
                              if gi_proveedor = 1 then
                                  cmb_proveedor.SetFocus
                              else cmb_autobus.SetFocus;
                            end;
                end else begin
                            gpo_tarjeta.Visible := False;
                            Panel3.Visible := False;
                end;
            end;
        end;
    end;//fin gi_lector
end;



procedure Tfrm_guias_servicio.habilitaPanelCuotas;
begin
    cmb_proveedor.Enabled := true;
    cmb_cuota.Enabled := true;
    edt_folio.Enabled := true;
    cmb_cemos.Enabled := true;
    edt_folio_cemos.Enabled := true;
    edt_boletera.Enabled    := true;
end;

procedure Tfrm_guias_servicio.Imprime1Click(Sender: TObject);
var
    lq_qry : TSQLQuery;
    li_guia, li_num : Integer;
    ls_hora : string;
    la_datos : gga_parameters;
begin
    lq_qry := TSQLQuery.Create(nil);
    try
          lq_qry.SQLConnection := DM.Conecta;
          if EjecutaSQL(Format(_GUIA_ID_GUIA,[stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                              stg_despacho.Cells[_COL_FECHA,stg_despacho.Row],
                                              gs_terminal,
                                              StrToInt(stg_despacho.Cells[_COL_RUTA,stg_despacho.Row]) ]),lq_qry,_LOCAL) then begin
              li_guia := lq_qry['ID_GUIA'];
              splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row],' ',la_datos,li_num);
              if li_num = 0 then// 0
                 ls_hora :=  la_datos[0]
              else ls_hora :=  la_datos[1];

              generaGuiaViaje(IntToStr(li_guia), stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
              stg_despacho.Cells[_COL_FECHA,stg_despacho.Row],ls_hora,0,gs_terminal,gs_trabid);
          end;
    finally
      lq_qry.Destroy;
    end;
end;


procedure Tfrm_guias_servicio.Insert_folio_salida;
var
    lq_salida : TSQLQuery;
begin
    if gli_folio > 0 then begin
        lq_salida := TSQLQuery.Create(nil);
        lq_salida.SQLConnection := DM.Conecta;
        lq_salida.SQL.Clear;
        lq_salida.SQL.Add('INSERT INTO PDV_T_FOLIO_SALIDA(FOLIO, PROVEEDOR, TIPO_CUOTA, TRABID, CONSECUTIVO, FECHA)');
        lq_salida.SQL.Add('VALUES(:gli_folio, :gli_provedor, :gli_cuota, :gs_trabid, :gli_consecutivo, NOW())');
        lq_salida.Params[0].AsInteger := gli_folio;
        lq_salida.Params[1].AsInteger := gli_provedor;
        lq_salida.Params[2].AsInteger := gli_cuota;
        lq_salida.Params[3].AsString  := gs_trabid;
        lq_salida.Params[4].AsInteger := gli_consecutivo;
        lq_salida.ExecSQL();
        lq_salida.Free;
    end;
end;

procedure Tfrm_guias_servicio.Insert_Incidencia(ls_idx : string);
var
    lq_incidencia : TSQLQuery;
begin
    lq_incidencia := TSQLQuery.Create(nil);
    lq_incidencia.SQLConnection := DM.Conecta;
    lq_incidencia.SQL.Clear;
    lq_incidencia.SQL.Add('INSERT INTO PDV_T_INICIDENCIA_SALIDA(ID_fECHA, NO_GUIA, QUIEN, FOLIO_ASIGNADO, FOLIO_CONSECUTIVO)');
    lq_incidencia.SQL.Add('VALUES(NOW(), :ls_idx, :gs_trabid, :gli_folio_cuota ,:gli_consecutivo)');
    lq_incidencia.Params[0].AsString  := ls_idx;
    lq_incidencia.Params[1].AsString  := gs_trabid;
    lq_incidencia.Params[2].AsInteger := gli_folio_cuota;
    lq_incidencia.Params[3].AsInteger := gli_consecutivo;
    lq_incidencia.ExecSQL();
    lq_incidencia.Free;
end;

procedure Tfrm_guias_servicio.Insert_Salida_Control;
var
    lq_salida : TSQLQuery;
begin
    if gli_folio > 0 then begin
        lq_salida := TSQLQuery.Create(nil);
        lq_salida.SQLConnection := DM.Conecta;
        try
            lq_salida.SQL.Clear;
            lq_salida.SQL.Add('INSERT INTO PDV_T_SALIDA_CONTROL(FOLIO, PROVEEDOR, TIPO_CUOTA, INICIAL, CANTIDAD, CONSECUTIVO, ASIGNADO)');
            lq_salida.SQL.Add('VALUES(:gli_folio, :gli_provedor, :gli_cuota, :gli_inicial, :gli_cantidad , :gli_folio_cuota, :gli_consecutivo )');
            lq_salida.Params[0].AsInteger := gli_folio;
            lq_salida.Params[1].AsInteger := gli_provedor;
            lq_salida.Params[2].AsInteger := gli_cuota;
            lq_salida.Params[3].AsInteger := gli_inicial;
            lq_salida.Params[4].AsInteger := gli_cantidad;
            lq_salida.Params[5].AsInteger := gli_folio_cuota;
            lq_salida.Params[6].AsInteger := gli_consecutivo;
            lq_salida.ExecSQL();
        except

        end;
        lq_salida.Free;
    end;
end;

function Tfrm_guias_servicio.getFolioConsult: Boolean;
var
    lq_salida : TSQLQuery;
begin
    lq_salida := TSQLQuery.Create(nil);
    lq_salida.SQLConnection := DM.Conecta;
    lq_salida.SQL.Clear;
    lq_salida.SQL.Add('SELECT COUNT(*)AS total');
    lq_salida.SQL.Add('FROM  PDV_T_FOLIO_SALIDA');
    lq_salida.SQL.Add('WHERE folio = :gli_folio AND proveedor = :gli_provedor and tipo_cuota = :gli_cuota AND trabid = :gs_trabid AND consecutivo = :gli_consecutivo');
    lq_salida.Params[0].AsInteger := gli_folio;
    lq_salida.Params[1].AsInteger := gli_provedor;
    lq_salida.Params[2].AsInteger := gli_cuota;
    lq_salida.Params[3].AsString  := gs_trabid;
    lq_salida.Params[4].AsInteger := gli_consecutivo;
    lq_salida.Open;
    if lq_salida['total'] = 0 then
        Result := False;
    if lq_salida['total'] = 1 then
        Result := True;
    lq_salida.Free;
end;



procedure Tfrm_guias_servicio.llenarProveedor;
var
   lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_OLLIN_PROVEEDOR, lq_qry, _LOCAL) then begin
        LlenarComboBox(lq_qry,cmb_proveedor,false);
    end;
    lq_qry.free;
end;


procedure Tfrm_guias_servicio.pintaBusCorrida(li_indx: Integer);
var
    li_num   : integer;
    la_datos : gga_parameters;
    ls_hora  : String;
begin
    Image.Visible := true;
    splitLine(stg_despacho.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos,li_num);
    if li_num = 0 then
      ls_hora := la_datos[0]
    else
      ls_hora := la_datos[1];
    limpiar_La_labels(la_labels);
    muestraAsientosArreglo(la_labels,StrToInt(stg_despacho.Cols[_COL_AUTOBUS].Strings[li_indx]), pnlBUS);
    obtenImagenBus(Image, stg_despacho.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
    asientosOcupados(la_labels,StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[li_indx]),
                     StrToTime(ls_hora), stg_despacho.Cols[_COL_CORRIDA].Strings[li_indx]);
end;

procedure Tfrm_guias_servicio.predespacharCorrida();
var
    hora : String;
    li_num  : integer;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
    lb_ejecuta : Boolean;
    ls_estatus, ls_hora, ls_qhora, ls_qminuto, hora_salida : string;
    li_hora, li_minuto : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    visualizaProveedor();
    splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ', la_datos,li_num);
    if li_num = 0 then
      hora := la_datos[0]
    else
      hora := la_datos[1];
    if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,['P',stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                            formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                            hora, stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
      if gi_lector = 0 then
          Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);

      stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Predespachada';
    splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ',la_datos, li_num);

    if li_num = 0 then hora_salida := la_datos[0] else hora_salida := la_datos[1];

    ls_hora := 'SELECT (HOUR(HORA))AS HORA, (MINUTE(HORA) + (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 9)) AS MINUTO '+
               'FROM PDV_T_CORRIDA_D WHERE FECHA = ''%s'' AND ID_CORRIDA = ''%s'' AND HORA = CAST(''%s'' AS TIME)';

    if EjecutaSQL(format(ls_hora,[formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                 stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                   hora_salida
                            ]),lq_qry,_LOCAL) then begin
          if lq_qry['MINUTO'] >= 60 then begin
              li_minuto := lq_qry['MINUTO'] mod 60;//obtenemos los minutos restantes
              if lq_qry['HORA'] = '23' then
                li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
              else begin
                    li_hora := lq_qry['HORA'] + 1;
              end;
          end else begin
              li_minuto := lq_qry['MINUTO'];
              if lq_qry['HORA'] = '23' then
                  li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
              else
              li_hora := lq_qry['HORA'];
          end;
         if li_hora < 10 then ls_qhora := '0' + IntToStr(li_hora)
         else ls_qhora := IntToStr(li_hora);

         if li_minuto < 10 then ls_qminuto := '0' + IntToStr(li_minuto)
         else ls_qminuto := IntToStr(li_minuto);

         ls_hora := ls_qhora + ':' + ls_qminuto;
    end;
    ls_hora := 'SELECT CAST('''+ ls_hora +''' AS TIME) > (DATE_FORMAT(current_timestamp(),''%T''))AS AHORA';
    if EjecutaSQL(ls_hora,lq_qry,_LOCAL) then
          asignaDatosPanel();
          gpo_tarjeta.Visible := True;
          if gi_proveedor = 1 then
             cmb_proveedor.SetFocus;
          Panel3.Visible  := True;
          if EjecutaSQL(_GUIA_AUTOBUS,lq_qry,_LOCAL) then
              LlenarComboTarjeta(lq_qry,cmb_autobus);
          if EjecutaSQL(_GUIA_OPERADOR,lq_qry,_LOCAL) then
              LlenarComboTarjeta(lq_qry,cmb_operador1);
          cmb_operador1.Enabled := True;
          cmb_autobus.Enabled   := True;
          if EjecutaSQL(format(_GUIA_BUS_OPERADOR,[stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                  formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                  stg_despacho.Cols[_COL_DESTINO].Strings[stg_despacho.Row]
                                                  ]), lq_qry, _LOCAL) then begin
              try
                if not VarIsNull(lq_qry['NOBUS']) then begin
                  cmb_autobus.SetID(lq_qry['NOBUS']);
                  cmb_operador1.SetID(lq_qry['OPERADOR']);
                  cmb_operador1.Enabled := False;
                  cmb_autobus.Enabled   := False;
                end;
              except
                    cmb_autobus.ItemIndex   := -1;
                    cmb_operador1.ItemIndex := -1;
              end;

          end;

          if EjecutaSQL(format(_GUAI_DETALLE_PASAJERO,[
                                formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
          if ejecutaSQL(format(_GUIA_TOTAL_DESTINO,[
                                formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then begin
                                stg_detalle_ocupantes.ColWidths[0] := 200;
              with lq_qry do begin
                  First;
                  li_num := 0;
                  while not EoF do begin
                      stg_detalle_ocupantes.Cells[0,li_num] := lq_qry['DESCRIPCION'];
                      stg_detalle_ocupantes.Cells[1,li_num] := lq_qry['TOTAL'];
                      inc(li_num);
                      next;
                  end;
                  stg_detalle_ocupantes.RowCount := li_num;
              end;
          visualizaProveedor();//error trafico
          if gi_proveedor = 1 then
              cmb_proveedor.SetFocus
          else begin
                if cmb_autobus.Enabled = true then
                    cmb_autobus.SetFocus;
          end;
    end;
    lq_qry.Free;
    lq_qry := nil;
end;


procedure Tfrm_guias_servicio.Predespacharcorrida1Click(Sender: TObject);
begin
    edt_boletera.Text := '0';
    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio') then begin
        Mensaje('No se puede "Predespachar" en una corrida de vacio, solo se puede Despachar',1);
        Exit;
    end;

    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada') then begin
        Mensaje('No se puede "Abrir" en una corrida de Despachad, se ha emitido una guia de viaje',1);
        Exit;
    end;

    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] <> 'Predespachada') then begin

          if Application.MessageBox(PChar(format(_MSG_PRESDESPACHAR_CORRIDA,
                                [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR)
                                = IDYES then begin
                predespacharCorrida();
                habilitaPanelCuotas();
                if gi_lector = 1 then begin
                    pnl_lector.Visible := False;
                    gpo_tarjeta.Visible := True;
                    cmb_autobus.SetFocus;
                end;
          end else begin
        end;
    end else begin
        Mensaje('No se puede Predespachar una corrida con estatus "Predespachada" ',1);
    end;
end;

procedure Tfrm_guias_servicio.DeshabilitaPanelCuotas;
begin
    cmb_proveedor.Enabled := true;
    cmb_cuota.Enabled := False;
    edt_folio.Enabled := False;
    cmb_cemos.Enabled := False;
    edt_folio_cemos.Enabled := False;
    edt_boletera.Enabled    := False;
end;

procedure Tfrm_guias_servicio.DespacharClick(Sender: TObject);
var
    li_num : integer;
    hora   : string;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
    li_ctrl : Integer;
    lb_ejecuta : Boolean;
    ls_estatus, ls_hora, ls_qhora, ls_qminuto, hora_salida, ls_status : string;
    li_hora, li_minuto : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada') or
       (stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio') then begin
          if Application.MessageBox(PChar(format(_MSG_DESPACHAR_CORRIDA,
            [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR) = IDYES then begin
            visualizaProveedor();
            splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ', la_datos,li_num);
            if li_num = 0 then
                hora := la_datos[0]
            else
                hora := la_datos[1];
            if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Vacio' then
                ls_status := 'V'
            else
                ls_status := 'P';
            if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,[ls_status,stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                      formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                      hora, stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
                Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
                gpo_tarjeta.Visible := True;

                if ls_status = 'V' then
                    stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Vacio'
                else
                    stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Predespachada';
                splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ',la_datos, li_num);
                if li_num = 0 then // 0
                  hora_salida := la_datos[0]
                else
                  hora_salida := la_datos[1];
                ls_hora := 'SELECT (HOUR(HORA))AS HORA, (MINUTE(HORA) + (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 9)) AS MINUTO '+
                           'FROM PDV_T_CORRIDA_D '+
                           'WHERE FECHA = ''%s'' AND ID_CORRIDA = ''%s'' AND HORA = CAST(''%s'' AS TIME)';
                if EjecutaSQL(format(ls_hora,[formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                             stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                               hora_salida
                                        ]),lq_qry,_LOCAL) then begin
                      if lq_qry['MINUTO'] >= 60 then begin
                          li_minuto := lq_qry['MINUTO'] mod 60;//obtenemos los minutos restantes
                          if lq_qry['HORA'] = '23' then
                            li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
                          else begin
                                li_hora := lq_qry['HORA'] + 1;
                          end;
                      end else begin
                                  li_hora := lq_qry['HORA'];
                                  li_minuto := lq_qry['MINUTO'];
                      end;

                     if li_hora < 10 then
                          ls_qhora := '0' + IntToStr(li_hora)
                     else ls_qhora := IntToStr(li_hora);
                     if li_minuto < 10 then
                          ls_qminuto := '0' + IntToStr(li_minuto)
                     else ls_qminuto := IntToStr(li_minuto);
                     ls_hora := ls_qhora + ':' + ls_qminuto;
                end;
                ls_hora := 'SELECT CAST('''+ ls_hora +''' AS TIME) > (DATE_FORMAT(current_timestamp(),''%T''))AS AHORA';
                asignaDatosPanel();
                gpo_tarjeta.Visible := True;

                if EjecutaSQL(_GUIA_AUTOBUS,lq_qry,_LOCAL) then
                    LlenarComboTarjeta(lq_qry,cmb_autobus);

                if EjecutaSQL(_GUIA_OPERADOR,lq_qry,_LOCAL) then
                    LlenarComboTarjeta(lq_qry,cmb_operador1);
                visualizaProveedor();
                if ls_status = 'V' then begin
                    DeshabilitaPanelCuotas();
                end;
                if (gi_proveedor = 1) and (ls_status <> 'V')then
                    cmb_proveedor.SetFocus
                else
                    cmb_autobus.SetFocus;
                Panel3.Visible := False;
              insertaEvento(gs_trabid,gs_terminal,'Despacha la corrida ' +
                            stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row]+' '+
                            stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]+' '+
                            stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]);
            end;
    end else begin
        Mensaje('No se puede despachar una corrida sino esta con estatus "Presdespachada" ',1);
    end;
    lq_qry.Free;
    lq_qry := nil;
end;


procedure Tfrm_guias_servicio.edt_barrasChange(Sender: TObject);
var
    ls_cadena : string;
    li_ctrl   : integer;
begin
    ls_cadena := edt_barras.Text;
    li_ctrl := Length(ls_cadena);
end;

procedure Tfrm_guias_servicio.edt_barrasKeyPress(Sender: TObject; var Key: Char);
var
    ls_cadena : string;
    li_ctrl    : integer;
    ls_corrida, ls_operador, ls_bus : String;
    lc_char : Char;
begin
    if Ord( Key ) = 13  then begin
        lst_mensaje.Clear;
        ls_cadena := edt_barras.Text;
        li_ctrl := Length(ls_cadena);
        if li_ctrl = 20 then begin
            li_ctrl := 21;
            ls_cadena := ' ' + ls_cadena;
        end;
        if li_ctrl >= 21 then begin
            lc_char := '''';
            ls_corrida := quitaEspacios(separaCadena(ls_cadena, 10) );
            ls_operador := quitaEspacios( remplazaChar(separaCadena(ls_cadena, 7) , lc_char) );
            ls_bus := quitaEspacios(ls_cadena);
            if buscaCorrida(ls_corrida) then begin
               pnl_lector.Visible := False;
               predespacharCorrida();
               cmb_autobus.ItemIndex := cmb_autobus.IDs.IndexOf(ls_bus);
               cmb_operador1.ItemIndex := cmb_operador1.IDs.IndexOf(ls_operador);
               cmb_operador1.Enabled := False;
               cmb_autobus.Enabled   := False;
               edt_boletera.SetFocus;
            end else begin
//                Mensaje('No se encuentra, elija manualmente para predespacharla o intentar nuevamente',2);
                lst_mensaje.Items.Add('No se encuentra, ');
                lst_mensaje.Items.Add('elija manualmente para');
                lst_mensaje.Items.Add('predespacharla o intentar nuevamente');
                lst_mensaje.Color := clMenu;
                edt_barras.Clear;
                edt_barras.SetFocus;
            end;
        end else begin
            ShowMessage('Repita la instruccion ' + IntToStr(li_ctrl));
            edt_barras.Clear;
        end;
    end;
end;

procedure Tfrm_guias_servicio.edt_boleteraChange(Sender: TObject);
var
  ls_input: string;
  li_ctrl_input: Integer;
begin
  ls_input := trim(edt_boletera.Text);
  for li_ctrl_input := 1 to length(ls_input)  do begin
    if not(ls_input[li_ctrl_input] in ['0' .. '9']) then begin
      edt_boletera.Clear;
      edt_boletera.SetFocus;
    end;
  end;
end;

procedure Tfrm_guias_servicio.edt_folioChange(Sender: TObject);
var
    ls_efectivo, ls_input, ls_output: string;
    lc_char, lc_new: CHAR;
    li_idx, li_ctrl: Integer;
begin
    ls_input := '';
    ls_efectivo := edt_folio.Text;
    for li_idx := 1 to length(ls_efectivo) do begin
        lc_char := ls_efectivo[li_idx];
        if ls_efectivo[1] = '0' then begin
          edt_folio.Clear;
          edt_folio.SetFocus;
          exit;
        end else
              ls_input := ls_input + lc_char;
        if not(lc_char in _CARACTERES_VALIDOS_EFECTIVO) then begin
            for li_ctrl := 1 to length(ls_input) - 1 do begin
              lc_new := ls_input[li_ctrl];
              ls_output := ls_output + lc_new;
            end;
            edt_folio.Text := ls_output;
            edt_folio.SelStart := length(ls_output);
        end;
    end;
end;


procedure Tfrm_guias_servicio.edt_folio_cemosChange(Sender: TObject);
var
    ls_efectivo, ls_input, ls_output: string;
    lc_char, lc_new: CHAR;
    li_idx, li_ctrl: Integer;
begin
    ls_input := '';
    ls_efectivo := edt_folio_cemos.Text;
    for li_idx := 1 to length(ls_efectivo) do begin
        lc_char := ls_efectivo[li_idx];
        if ls_efectivo[1] = '0' then begin
          edt_folio_cemos.Clear;
          edt_folio_cemos.SetFocus;
          exit;
        end else
              ls_input := ls_input + lc_char;
        if not(lc_char in _CARACTERES_VALIDOS_EFECTIVO) then begin
            for li_ctrl := 1 to length(ls_input) - 1 do begin
              lc_new := ls_input[li_ctrl];
              ls_output := ls_output + lc_new;
            end;
            edt_folio_cemos.Text := ls_output;
            edt_folio_cemos.SelStart := length(ls_output);
        end;
    end;
end;

procedure Tfrm_guias_servicio.Reimprime1Click(Sender: TObject);
var
    la_datos : gga_parameters;
    li_num   : integer;
    ls_hora  : String;
    lq_qry : TSQLQuery;
begin
    if(stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada') then begin
        splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row],' ',la_datos,li_num);
        if li_num = 0 then
           ls_hora :=  la_datos[0]
        else ls_hora :=  la_datos[1];
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(_GUIA_REIMPRESION,[stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                      formatDateTime('YYYY-MM-DD',
                                      StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]))]),lq_qry,_LOCAL) then begin
             li_existe_tabla := 1;
             generaGuiaViaje(lq_qry['ID_GUIA'],lq_qry['ID_CORRIDA'],
                      formatDateTime('YYYY-MM-DD', StrToDate(lq_qry['FECHA'])),ls_hora,1,gs_terminal,gs_trabid);
        end;
        lq_qry.Free;
        lq_qry := nil;
    end else begin
           Mensaje('Solo las corridas Despachadas',1);
    end;
end;

procedure Tfrm_guias_servicio.SpeedButton3Click(Sender: TObject);
begin
    pnl_lector.Visible  := False;
{    if gi_proveedor = 1 then
        cmb_proveedor.SetFocus
    else cmb_autobus.SetFocus;}
end;

procedure Tfrm_guias_servicio.stg_despachoKeyPress(Sender: TObject;
  var Key: Char);
var
    li_num : integer;
    hora   : string;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
begin
{    if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Abierta' then begin
        gpo_tarjeta.Visible := true;
    end; }
{    if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Abierta' then begin
        if not AccesoPermitido(153,False) then
            Exit;
        if Application.MessageBox(PChar(format(_MSG_PRESDESPACHAR_CORRIDA,
              [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR)
          = IDYES then begin
          splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ', la_datos,li_num);
          if li_num = 0 then
              hora := la_datos[0]
          else
              hora := la_datos[1];
          lq_qry := TSQLQuery.Create(nil);
          lq_qry.SQLConnection := CONEXION_VTA;
          if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,
              ['P',stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                  formatDateTime('YYYY-MM-DD',
                        StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                  hora,
                  stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then begin
              Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
              stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Predespachada';
              stg_despacho.SetFocus;
          end;
          lq_qry.Free;
          lq_qry := nil;
        end;
    end;}
end;


procedure Tfrm_guias_servicio.stg_despachoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    li_ctrl : Integer;
    lb_ejecuta : Boolean;
    ls_estatus, ls_hora, ls_qhora, ls_qminuto, hora_salida : string;
    lq_qry : TSQLQuery;
    la_datos: gga_parameters;
    li_num : integer;
    li_hora, li_minuto : integer;
begin
    edt_boletera.Clear;
    lb_ejecuta := false;
    ls_estatus := stg_despacho.Cells[_COL_STATUS,stg_despacho.Row];
    for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do begin
        if Key = _TECLAS_ARRAY[li_ctrl] then begin
            lb_ejecuta := true;
        end;
    end;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONEXION_VTA;
    ///si no tiene fecha mandar mensaje de que no existen corridas
    if length(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]) > 0 then begin

        edt_total_pax.Text :=  IntToStr(total_pasajeros_corrida(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                 formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])) ));
        pintaBusCorrida(stg_despacho.Row);
    end;
    if ls_estatus = 'Abierta' then begin
        if gi_lector = 1 then begin
           gpo_tarjeta.Visible := False;
           pnl_lector.Visible  := True;
           edt_barras.Clear;
           edt_barras.SetFocus;
        end;

    end;

    if lb_ejecuta then begin
        if ls_estatus = 'Predespachada' then begin
             //VALIDAMOS
              if gi_lector = 1 then begin
                  pnl_lector.Visible := False;
                  gpo_tarjeta.Visible := True;
                  cmb_autobus.SetFocus;
              end;

              splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ',la_datos, li_num);
              if li_num = 0 then // 0
                hora_salida := la_datos[0]
              else
                hora_salida := la_datos[1];
              ls_hora := 'SELECT (HOUR(HORA))AS HORA, (MINUTE(HORA) + (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 9)) AS MINUTO '+
                         'FROM PDV_T_CORRIDA_D '+
                         'WHERE FECHA = ''%s'' AND ID_CORRIDA = ''%s'' AND HORA = CAST(''%s'' AS TIME)';
              if EjecutaSQL(format(ls_hora,[formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                           stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                             hora_salida
                                      ]),lq_qry,_LOCAL) then begin
                    if lq_qry['MINUTO'] >= 60 then begin
                        li_minuto := lq_qry['MINUTO'] mod 60;//obtenemos los minutos restantes
                        if lq_qry['HORA'] = '23' then
                          li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
                        else begin
                              li_hora := lq_qry['HORA'] + 1;
                        end;
                    end else begin
                        li_minuto := lq_qry['MINUTO'];
                        if lq_qry['HORA'] = '23' then
                            li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
                        else
                        li_hora := lq_qry['HORA'];
                    end;
                   if li_hora < 10 then
                        ls_qhora := '0' + IntToStr(li_hora)
                   else ls_qhora := IntToStr(li_hora);
                   if li_minuto < 10 then
                        ls_qminuto := '0' + IntToStr(li_minuto)
                   else ls_qminuto := IntToStr(li_minuto);
                   ls_hora := ls_qhora + ':' + ls_qminuto;
              end;
              ls_hora := 'SELECT CAST('''+ ls_hora +''' AS TIME) > (DATE_FORMAT(current_timestamp(),''%T''))AS AHORA';
              if EjecutaSQL(ls_hora,lq_qry,_LOCAL) then
                  if lq_qry['AHORA'] = 0 then begin
                    asignaDatosPanel();
                    gpo_tarjeta.Visible := True;
                    Panel3.Visible  := True;

                    if EjecutaSQL(_GUIA_AUTOBUS,lq_qry,_LOCAL) then
                        LlenarComboTarjeta(lq_qry,cmb_autobus);
                    if EjecutaSQL(_GUIA_OPERADOR,lq_qry,_LOCAL) then
                        LlenarComboTarjeta(lq_qry,cmb_operador1);
//mostramos los datos en el grid
                    cmb_autobus.Enabled := True;
                    cmb_autobus.Enabled := True;
                    if gi_proveedor = 0 then begin
                        cmb_proveedor.Visible := False;
                        cmb_cuota.Visible := False;
                        edt_folio.Visible := False;
                        lbl_proveedor.Visible := false;
                        lbl_cuota.Visible := False;
                        lbl_folio.Visible := False;
                    end else begin
                        cmb_proveedor.Visible := true;
                        cmb_cuota.Visible := true;
                        edt_folio.Visible := true;
                        lbl_proveedor.Visible := true;
                        lbl_cuota.Visible := true;
                        lbl_folio.Visible := true;
                    end;
                    if gi_cemos = 0 then begin
                        cmb_cemos.Visible := False;
                        edt_folio.Visible := False;
                        lbl_cemos_tipo.Visible := False;
                        lbl_cemos_tipo.Visible := False;
                    end else begin
                        cmb_cemos.Visible := true;
                        edt_folio.Visible := true;
                        lbl_cemos_tipo.Visible := true;
                        lbl_cemos_tipo.Visible := true;
                    end;

                    if EjecutaSQL(format(_GUIA_BUS_OPERADOR,[stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                            formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                            stg_despacho.Cols[_COL_DESTINO].Strings[stg_despacho.Row]
                                                            ]), lq_qry, _LOCAL) then begin
                          if not (VarIsNull(lq_qry['NOBUS'])) then begin
//                            cmb_autobus.Enabled := False;
//                            cmb_operador1.Enabled := False;
                            cmb_autobus.SetID(lq_qry['NOBUS']);
                            cmb_operador1.SetID(lq_qry['OPERADOR']);
                          end else begin
                            cmb_autobus.ItemIndex   := -1;
                            cmb_operador1.ItemIndex := -1;
                            cmb_operador1.Enabled := true;
                            cmb_autobus.Enabled := true;
                          end;

                    end;
                    if EjecutaSQL(format(_GUAI_DETALLE_PASAJERO,[
                                          formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                          stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
                    if ejecutaSQL(format(_GUIA_TOTAL_DESTINO,[
                                          formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                          stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then begin
                        stg_detalle_ocupantes.ColWidths[0] := 200;
                        with lq_qry do begin
                            First;
                            li_num := 0;
                            while not EoF do begin
                                stg_detalle_ocupantes.Cells[0,li_num] := lq_qry['DESCRIPCION'];
                                stg_detalle_ocupantes.Cells[1,li_num] := lq_qry['TOTAL'];
                                inc(li_num);
                                next;
                            end;
                            stg_detalle_ocupantes.RowCount := li_num;
                        end;
                    end;
                    visualizaProveedor();
                    if gi_proveedor = 1 then
                        cmb_proveedor.SetFocus
                    else cmb_autobus.SetFocus;
              end;
        end else begin
                    gpo_tarjeta.Visible := False;
                    Panel3.Visible := False;
                    if ls_estatus = 'Abierta' then begin  exit;
//buscamos en la base el parametro
                        if EjecutaSQL('SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 13',lq_qry,_LOCAL) then
                          if VarIsNull(lq_qry['VALOR']) then
                              gi_parametro_13 := 0
                          else
                              gi_parametro_13 := lq_qry['VALOR'];

                        if gi_parametro_13 = 1 then begin
                            splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ',la_datos, li_num);
                            if li_num = 0 then // 0
                              hora_salida := la_datos[0]
                            else
                              hora_salida := la_datos[1];
                            ls_hora := 'SELECT (HOUR(HORA))AS HORA, (MINUTE(HORA) + (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 9)) AS MINUTO '+
                                       'FROM PDV_T_CORRIDA_D '+
                                       'WHERE FECHA = ''%s'' AND ID_CORRIDA = ''%s'' AND HORA = CAST(''%s'' AS TIME)';
                            if EjecutaSQL(format(ls_hora,[formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                         stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                           hora_salida
                                                    ]),lq_qry,_LOCAL) then begin
                                  if lq_qry['MINUTO'] >= 60 then begin
                                      li_minuto := lq_qry['MINUTO'] mod 60;//obtenemos los minutos restantes
                                      if lq_qry['HORA'] = '23' then
                                        li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
                                      else begin
                                            li_hora := lq_qry['HORA'] + 1;
                                      end;
                                  end else begin
                                      li_minuto := lq_qry['MINUTO'];
                                      if lq_qry['HORA'] = '23' then
                                          li_hora := 0 //si son las 23 incrementamos la hora a las 24 horas
                                      else
                                      li_hora := lq_qry['HORA'];
                                  end;
                                 if li_hora < 10 then
                                      ls_qhora := '0' + IntToStr(li_hora)
                                 else ls_qhora := IntToStr(li_hora);
                                 if li_minuto < 10 then
                                      ls_qminuto := '0' + IntToStr(li_minuto)
                                 else ls_qminuto := IntToStr(li_minuto);
                                 ls_hora := ls_qhora + ':' + ls_qminuto;
                            end;
                            ls_hora := 'SELECT CAST('''+ ls_hora +''' AS TIME) > (DATE_FORMAT(current_timestamp(),''%T''))AS AHORA';
                            if EjecutaSQL(ls_hora,lq_qry,_LOCAL) then
//                                if lq_qry['AHORA'] = 0 then begin
                                  asignaDatosPanel();
                                  SpeedButton1.Visible := true;
                                  SpeedButton2.Visible := True;
                                  gpo_tarjeta.Visible := True;
                                  if gi_proveedor = 1 then
                                      cmb_proveedor.SetFocus;
                                  Panel3.Visible  := True;
                                  if EjecutaSQL(_GUIA_AUTOBUS,lq_qry,_LOCAL) then
                                      LlenarComboTarjeta(lq_qry,cmb_autobus);
                                  if EjecutaSQL(_GUIA_OPERADOR,lq_qry,_LOCAL) then
                                      LlenarComboTarjeta(lq_qry,cmb_operador1);
              //mostramos los datos en el grid
                                  if EjecutaSQL(format(_GUAI_DETALLE_PASAJERO,[
                                                        formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                        stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
                                  if ejecutaSQL(format(_GUIA_TOTAL_DESTINO,[
                                                        formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                        stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then begin
                                      stg_detalle_ocupantes.ColWidths[0] := 200;
                                      with lq_qry do begin
                                          First;
                                          li_num := 0;
                                          while not EoF do begin
                                              stg_detalle_ocupantes.Cells[0,li_num] := lq_qry['DESCRIPCION'];
                                              stg_detalle_ocupantes.Cells[1,li_num] := lq_qry['TOTAL'];
                                              inc(li_num);
                                              next;
                                          end;
                                          stg_detalle_ocupantes.RowCount := li_num;
                                      end;
                                  end;
                            visualizaProveedor();
                            if gi_proveedor = 1 then
                                cmb_proveedor.SetFocus
                            else cmb_autobus.SetFocus;
                        end;
                        if gi_parametro_13 = 0 then begin
                            gpo_tarjeta.Visible := False;
                            SpeedButton1.Visible := True;
                            SpeedButton2.Visible := False;
                        end;
                    end;
        end;
    end;
    lq_qry.Free;
    lq_qry := nil;
end;


procedure Tfrm_guias_servicio.stg_despachoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    Col, fila : Integer;
    lw : word;
begin
    if Button = mbRight then begin
        stg_despacho.MouseToCell(X,Y,Col,fila);
        stg_despacho.Col := Col;
        stg_despacho.Row := fila;
    end;
    if Button  = mbLeft then begin
        lw := 33;
        stg_despachoKeyUp(Sender,lw, Shift);
    end;
    edt_total_pax.Text :=  IntToStr(total_pasajeros_corrida(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                             formatDateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])) ));
end;

procedure Tfrm_guias_servicio.TimerTimer(Sender: TObject);
var
    li_col : integer;
begin
    li_col := stg_despacho.Row;
    LimpiaSagTodo(stg_despacho);
    titulosCorridaGrid(stg_despacho);
    stg_despacho.Cells[_COL_STATUS,0] := 'Estatus';
    stg_despacho.ColWidths[_COL_STATUS] := 100;
    stg_despacho.ColWidths[_COL_TARIFA] := 0;
    if VarIsNull(gs_terminal) then begin
        LecturaIni();
        muestraEstatus(gs_terminal,stg_despacho);
    end;

    muestraEstatus(gs_terminal,stg_despacho);
    stg_despacho.Row := li_col;
end;

procedure Tfrm_guias_servicio.TpingTimer(Sender: TObject);
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

procedure Tfrm_guias_servicio.Update_SALIDA_CONTROL;
var
    lq_SALIDA : TSQLQuery;
begin
    lq_SALIDA := TSQLQuery.Create(nil);
    lq_SALIDA.SQLConnection := DM.Conecta;
    try
        lq_SALIDA.SQL.Clear;
        lq_SALIDA.SQL.Add('UPDATE PDV_T_SALIDA_CONTROL SET CONSECUTIVO = :gli_folio_cuota, ASIGNADO = :gli_folio_cuota');
        lq_SALIDA.SQL.Add('WHERE FOLIO = :gli_folio AND PROVEEDOR = :gli_provedor AND TIPO_CUOTA = :gli_cuota ');
        lq_SALIDA.SQL.Add('AND INICIAL = :gli_inicial AND CANTIDAD = :gli_cantidad');
        lq_SALIDA.Params[0].AsInteger := gli_folio_cuota;
        lq_SALIDA.Params[1].AsInteger := gli_folio_cuota;
        lq_SALIDA.Params[2].AsInteger := gli_folio;
        lq_SALIDA.Params[3].AsInteger := gli_provedor;
        lq_SALIDA.Params[4].AsInteger := gli_cuota;
        lq_SALIDA.Params[5].AsInteger := gli_inicial;
        lq_SALIDA.Params[6].AsInteger := gli_cantidad;
        lq_SALIDA.ExecSQL();
    except

    end;
    lq_SALIDA.Free;
end;

function Tfrm_guias_servicio.validainputCombo(tipo : String): Boolean;
label
     GotoLabel;
var
    la_ok : Boolean;
    li_tmp : integer;
begin
    la_ok := False;
    gi_proveedor := 0 ; //getparametroProveedor();
    if tipo <> 'Vacio' then begin
        if gi_proveedor = 1 then begin//validamos los nuevos combos
            if cmb_proveedor.ItemIndex = - 1 then begin
                cmb_proveedor.ItemIndex := -1;
                Mensaje('Seleccione el proveedor correspondiente',1);
                cmb_proveedor.SetFocus;
                la_ok := True;
                Goto GotoLabel;
            end;
            if cmb_cuota.ItemIndex = - 1 then begin
                cmb_cuota.ItemIndex := -1;
                Mensaje('Seleccion la cuota correspondiente',1);
                cmb_cuota.SetFocus;
                la_ok := True;
                Goto GotoLabel;
            end;
            if length(edt_folio.Text) = 0 then begin
                edt_folio.SetFocus;
                Mensaje('Ingrese el numero de folio',1);
                la_ok := True;
                Goto GotoLabel;
            end;
        end;
        if gi_cemos = 1 then begin
            if cmb_cemos.ItemIndex = 3 then begin
                if length(edt_folio_cemos.Text) = 0 then begin
                    Mensaje('Se necesita ingresar el folio CEMO',1);
                    edt_folio_cemos.SetFocus;
                    la_ok := True;
                    Goto GotoLabel;
                end;
            end;
        end;
    end;
    if length(cmb_autobus.Text) = 0 then begin
        Mensaje('Seleccione un autobus para la guia',0);
        cmb_autobus.SetFocus;
        la_ok := True;
        Goto GotoLabel;
    end else begin
       li_tmp := cmb_autobus.IDs.IndexOf(UpperCase(cmb_autobus.Text));
        if cmb_autobus.ItemIndex < 0 then
          if li_tmp >= 0 then
            cmb_autobus.ItemIndex := cmb_autobus.IDs.IndexOf(UpperCase(cmb_autobus.Text))
          else
            cmb_autobus.Text := '';
        if Length(cmb_autobus.Text) = 0 then begin
            Mensaje('Asigne autobus valido',0);
            cmb_autobus.SetFocus;
            la_ok := True;
        end;
    end;

    if Length(cmb_operador1.Text) = 0 then begin
        Mensaje('Asigne un operador para la guia',0);
        cmb_operador1.SetFocus;
        la_ok := True;
        Goto GotoLabel;
    end else begin
         li_tmp := cmb_operador1.IDs.IndexOf(UpperCase(cmb_operador1.Text));
          if cmb_operador1.ItemIndex < 0 then
            if li_tmp >= 0 then
              cmb_operador1.ItemIndex := cmb_operador1.IDs.IndexOf
                (UpperCase(cmb_autobus.Text))
            else
              cmb_operador1.Text := '';
          if Length(cmb_operador1.Text) = 0 then begin
              Mensaje('Asigne operador valido',0);
              cmb_operador1.SetFocus;
              la_ok := True;
          end;
    end;
    GotoLabel:
    Result := la_ok;
end;

procedure Tfrm_guias_servicio.visualizaProveedor();
begin
    gi_proveedor := 0; getparametroProveedor();
    if gi_proveedor = 1 then begin //valdiamos la peticion del proveedor
        lbl_folio.Visible := true;
        lbl_proveedor.Visible := true;
        lbl_cuota.Visible := true;
        cmb_proveedor.Visible := true;
        cmb_cuota.Visible := true;
        edt_folio.Visible := true;
        llenarProveedor();
    end else begin
        lbl_folio.Visible := false;
        lbl_proveedor.Visible := false;
        lbl_cuota.Visible := false;
        cmb_proveedor.Visible := false;
        cmb_cuota.Visible := false;
        edt_folio.Visible := false;
    end;
end;

end.
