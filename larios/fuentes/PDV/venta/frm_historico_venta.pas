unit frm_historico_venta;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, ComCtrls, ExtCtrls, Grids, StdCtrls, Mask, lsCombobox, Data.SqlExpr,
  System.Actions, Vcl.Menus;

type
  Tfrm_historico = class(TForm)
    Panel1: TPanel;
    Gr_Corridas: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    ls_Origen_vta: TlsComboBox;
    ls_Origen: TlsComboBox;
    medt_fecha: TMaskEdit;
    GroupBox3: TGroupBox;
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
    grp_asientos: TGroupBox;
    grp_cuales: TGroupBox;
    lbledt_cuales: TLabeledEdit;
    stg_listaOcupantes: TStringGrid;
    lbledt_tipo: TLabeledEdit;
    lblEdt_cuantos: TLabeledEdit;
    StatusBar1: TStatusBar;
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    stg_detalle_ocupantes: TStringGrid;
    PopupMenu1: TPopupMenu;
    Action2: TAction;
    Guardar1: TMenuItem;
    stg_reporte: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stg_corridaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
  private
    { Private declarations }
    procedure Titles();
    procedure llenamosDatosInicio();
    procedure consigueCorridas();
    procedure pintaBusCorrida(li_indx: Integer);
    procedure limpiaGrid();
  public
    { Public declarations }
  end;

var
  frm_historico: Tfrm_historico;

implementation

uses DMdb, u_comun_venta, comun, u_guias;

{$R *.dfm}
var
  ga_labels: ga_labels_asientos;

procedure Tfrm_historico.Action1Execute(Sender: TObject);
begin
    limpiar_La_labels(ga_labels); // limpiamos las etiquetas
    Close;
end;

procedure Tfrm_historico.Action2Execute(Sender: TObject);
var
    lq_Query : TSQLQuery;
    li_idx : integer;
    ls_qry : STring;
begin
    lq_Query := TSQLQuery.Create(nil);
    lq_Query.SQLConnection := DM.Conecta;
    stg_reporte.RowCount := stg_corrida.RowCount;
    for li_idx := 1 to stg_corrida.RowCount -1 do begin
        ls_qry := format('_VTA_HISTORICO_POR_CORRIDA', [
                    FormatDateTime('YYYY-MM-DD', StrToDateTime(stg_corrida.Cells[_COL_FECHA, li_idx])),
                                                      gs_terminal,
                                                      stg_corrida.Cells[_COL_CORRIDA, li_idx]] );
        lq_Query.SQL.Clear;
        lq_Query.sql.Add(ls_qry);
        lq_Query.Open;
        stg_reporte.Cells[0, li_idx] := stg_corrida.Cells[_COL_FECHA, li_idx];
        stg_reporte.Cells[1, li_idx] := stg_corrida.Cells[_COL_CORRIDA, li_idx];
        stg_reporte.Cells[2, li_idx] := stg_corrida.Cells[_COL_HORA, li_idx];
        stg_reporte.Cells[3, li_idx] := lq_Query['DESTINO'];
        stg_reporte.Cells[4, li_idx] := IntToStr(lq_Query['OCUPADOS']);
        stg_reporte.Cells[5, li_idx] := IntToStr(lq_Query['PIE']);
        stg_reporte.Cells[6, li_idx] := IntToStr(lq_Query['CANCELADOS']);

    end;
    lq_Query.Free;
//    ExcelMigrar(stg_reporte);
end;

procedure Tfrm_historico.consigueCorridas;
var
    lsOrigen, lsDestino: string;
begin
    if length(ls_Origen_vta.Text) <> 0 then
        lsOrigen := ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf
          (ls_Origen_vta.Text)];
    corridasHistoricoVenta(lsOrigen, lsDestino, medt_fecha.Text, '', '', 0, stg_corrida, ''); // mostramos la corrida
    stg_corrida.Enabled := True;
    stg_corrida.SetFocus;
end;

procedure Tfrm_historico.FormCreate(Sender: TObject);
begin
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

procedure Tfrm_historico.FormKeyUp(Sender: TObject; var Key: Word;
                                   Shift: TShiftState);
var
    la_datos : gga_parameters;
    li_num   : integer;
begin
    if (Key = VK_F1) or (Key = 13 )  then begin
        splitLine(ls_Origen_vta.Text, '-', la_datos, li_num);
        if la_datos[1] = ls_Origen.Text then begin
          consigueCorridas();
          pintaBusCorrida(stg_corrida.Row);
        end;
    end;
    if Key = VK_F3 then begin
      medt_fecha.SetFocus;
      medt_fecha.SelStart := 0;
      exit;
    end;
end;

procedure Tfrm_historico.FormShow(Sender: TObject);
begin
    CONEXION_VTA := DM.Conecta;
    llenaPosicionLugares();
    llenarArregloCaracteres();//llenamso caracteres en los arreglos
    Titles();//titulos del grid
    llenamosDatosInicio();//llenamos datos inciales
    limpiar_La_labels(ga_labels);
    llenaOcupantesSAdulto();
    medt_fecha.SelStart := 0;
end;


procedure Tfrm_historico.limpiaGrid;
var
    li_ctrl : integer;
begin
    for li_ctrl := 0 to stg_detalle_ocupantes.RowCount do begin
        stg_detalle_ocupantes.Cells[0,li_ctrl] := '';
        stg_detalle_ocupantes.Cells[1,li_ctrl] := '';
    end;
end;

procedure Tfrm_historico.llenamosDatosInicio;
var
  lq_terminals: TSQLQuery;
begin
  lq_terminals := TSQLQuery.Create(nil);
  lq_terminals.SQLConnection := DM.Conecta;
  if EjecutaSQL(_VTA_TERMINALES, lq_terminals, _LOCAL) then begin
    LlenarComboBox(lq_terminals, ls_Origen, True);
    LlenarComboBox(lq_terminals, ls_Origen_vta, True);
    llenarTerminales(lq_terminals);
    ls_Origen.Text := gds_terminales.ValueOf(gs_terminal);
    /// la terminal actual
    ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(gs_terminal);
    medt_fecha.Text := FechaServer();
  end;
  lq_terminals.Free;
  lq_terminals := nil;
end;

procedure Tfrm_historico.pintaBusCorrida(li_indx: Integer);
var
    li_num : integer;
    la_datos : gga_parameters;
    ls_hora : String;
    lq_qry : TSQLQuery;
begin
  if length(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]) = 0 then
  begin
    Mensaje(_MSG_DATOS_CORRIDA, 0);
    exit;
  end;
  Image.Visible := True;
  splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos, li_num);
  if li_num = 0 then
    ls_hora := la_datos[0]
  else ls_hora := la_datos[1];
  limpiar_La_labels(ga_labels);
//  showDetalleRuta(StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]), stg_detalle);
  obtenImagenBus(Image, stg_corrida.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
  muestraAsientosArreglo(ga_labels,StrToInt(stg_corrida.Cols[_COL_AUTOBUS].Strings[li_indx]), pnlBUS);
//  asientosOcupados(ga_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),StrToTime(ls_hora), stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
  ventaHistorica(ga_labels, StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),
                 stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
  lq_qry := TSQLQuery.Create(nil);
  lq_qry.SQLConnection := DM.Conecta;
  if ejecutaSQL(format(_GUIA_TOTAL_DESTINO,[
                        formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                        stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]]),lq_qry,_LOCAL) then begin
      limpiaGrid();
      stg_detalle_ocupantes.ColWidths[0] := 130;
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
  lq_qry.Destroy;
end;


procedure Tfrm_historico.stg_corridaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  li_ctrl: Integer;
  lb_ejecuta: Boolean;
  li_fila: Integer;
begin
  for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do begin
    if Key = _TECLAS_ARRAY[li_ctrl] then begin
      lb_ejecuta := True;
    end;
  end;
  if lb_ejecuta then begin
    pintaBusCorrida(stg_corrida.Row);
  end;
end;

procedure Tfrm_historico.Titles;
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
//  stg_ocupantes.ColWidths[0] := 160;
//  stg_ocupantes.ColWidths[1] := 30;
  stg_reporte.Cells[0, 0] := 'Fecha';
  stg_reporte.Cells[1, 0] := 'Corrida';
  stg_reporte.Cells[2, 0] := 'Hora';
  stg_reporte.Cells[3, 0] := 'Destino';
  stg_reporte.Cells[4, 0] := 'Ocupados';
  stg_reporte.Cells[5, 0] := 'Pie';
  stg_reporte.Cells[6, 0] := 'Cancelados';

end;

end.
