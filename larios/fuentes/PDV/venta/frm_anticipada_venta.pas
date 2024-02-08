unit frm_anticipada_venta;

interface
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, lsCombobox, ExtCtrls, FMTBcd, Data.SqlExpr, Grids,
  ComCtrls, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin,
  ActnCtrls, ActnMenus, System.Actions;

type
  Tfrm_anticipa_vender = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Gr_Corridas: TGroupBox;
    StatusBar1: TStatusBar;
    Splitter1: TSplitter;
    Panel3: TPanel;
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
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
    ActionManager1: TActionManager;
    Action1: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    Label1: TLabel;
    ls_canje: TlsComboBox;
    ac_buscar: TAction;
    ac_buscarCodigo: TAction;
    GroupBox1: TGroupBox;
    ls_Origen_vta: TlsComboBox;
    ls_Destino_vta: TlsComboBox;
    ls_servicio: TlsComboBox;
    medt_fecha: TMaskEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    stg_ocupantes: TStringGrid;
    TRefrescaCorrida: TTimer;
    grp_cuales: TGroupBox;
    lbledt_cuales: TLabeledEdit;
    lbledt_tipo: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure ac_buscarCodigoExecute(Sender: TObject);
    procedure ls_canjeClick(Sender: TObject);
    procedure ls_canjeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure medt_fechaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure stg_corridaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure stg_corridaKeyPress(Sender: TObject; var Key: Char);
    procedure TRefrescaCorridaTimer(Sender: TObject);
    procedure lbledt_cualesChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
    procedure titles;
    procedure pintaBusCorrida(li_indx: Integer);
    function totalLugares(textoEdit : string): integer;
  public
    { Public declarations }
  end;

var
  frm_anticipa_vender: Tfrm_anticipa_vender;

implementation

uses DMdb, comun, U_venta, u_comun_venta, frm_mensaje_corrida,
  frm_imprime_abierto;


{$R *.dfm}

var
  ga_labels: ga_labels_asientos;
  li_adultos, li_menores, gli_asientos_maximo, gi_servicio_venta, gli_total_boletos_vendidos : integer;
  ga_asientos_cuales : ga_asientos;
  asientos_abierto: array_asientos;
  gi_ruta : integer;
  ls_codigo : String;




procedure Tfrm_anticipa_vender.Action1Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_anticipa_vender.ac_buscarCodigoExecute(Sender: TObject);
begin
    ls_codigo := ls_canje.CurrentID;

end;

procedure Tfrm_anticipa_vender.FormCreate(Sender: TObject);
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


procedure Tfrm_anticipa_vender.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    la_datos : gga_parameters;
    li_num   : integer;
    ls_hora  : String;
    lugares : PDV_Asientos;
    forma   : Tfrm_print_abierto;
begin
  if (Key = VK_RETURN) and (length(lbledt_cuales.Text) > 0) then begin
      if gli_asientos_maximo <> gli_total_boletos_vendidos then begin
          ShowMessage('El numero de lugares no corresponden a el numero de boletos vendidos');
          lbledt_cuales.Text := '';
          lbledt_cuales.SetFocus;
          exit;
      end;

      splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row], ' ', la_datos,li_num);
      if la_datos[0] = 'E' then gs_imprime_extra := ' Extra'
      else gs_imprime_extra := '';
      if li_num = 0 then ls_hora := la_datos[0]
      else ls_hora := la_datos[1];
      for li_num := 0 to gli_asientos_maximo - 1 do begin
        lugares.asiento := ga_asientos_cuales[li_num];
        lugares.corrida := stg_corrida.Cells[_COL_CORRIDA, stg_corrida.Row];
        lugares.empleado := gs_trabid;
        lugares.origen   := ls_Origen_vta.CurrentID;
        lugares.destino  := ls_Destino_vta.CurrentID;
        lugares.status   := 'V';
        lugares.fecha_hora := stg_corrida.Cells[_COL_FECHA, stg_corrida.Row] + ' ' + ls_hora;
        estatus_ASIENTO(lugares,'N');
      end;
      pintaBusCorrida(stg_corrida.Row);
      try
        forma := Tfrm_print_abierto.Create(nil);
        forma.codigo := ls_canje.CurrentID;
        forma.hora   := ls_hora;
//        forma.ruta   := gi_ruta;
        forma.asientos := ga_asientos_cuales;
        forma.fecha  := FormatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cells[_COL_FECHA, stg_corrida.Row]));
        forma.corrida := stg_corrida.Cells[_COL_CORRIDA, stg_corrida.Row];
        forma.ShowModal;
        lbledt_cuales.Clear;
        lbledt_tipo.Clear;
        grp_cuales.Visible := False;
        grp_corridas.Visible := True;
        LimpiaSagTodo(stg_ocupantes);
      finally
        forma.Free;
        forma := nil;
        Close;
      end;
  end;

  if Key = VK_F4 then
      Close;

  if Key = VK_F5 then begin
      grp_cuales.Visible := False;
      grp_corridas.Visible := true;
      lbledt_cuales.Clear;
      lbledt_tipo.Clear;
      medt_fecha.Clear;
      LimpiaSagTodo(stg_ocupantes);
      FormShow(Sender);
      ls_canje.ItemIndex := -1;
      ls_canje.SetFocus;
      Image.Visible := False;
  end;
end;

procedure Tfrm_anticipa_vender.FormShow(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
    gli_total_boletos_vendidos := 0;
    limpiar_La_labels(ga_labels); // limpiamos las etiquetas
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
{    if EjecutaSQL(_CODIGO_BOLETO_ABIERTO, lq_qry, _LOCAL) then begin
       with lq_qry do begin
          First;
          while not Eof do begin
              ls_canje.Add(gs_terminal + '-'+ lq_qry['CODIGO_BOLETO'], lq_qry['CODIGO_BOLETO']);
              Next;
          end;
       end;
    end; }
    if EjecutaSQL(format(_VTA_TERMINALES_ORIGEN, [gs_terminal, gs_terminal]),lq_qry, _LOCAL) then begin
      LlenarComboBox(lq_qry, ls_Origen_vta, False);
      LlenarComboBox(lq_qry, ls_Destino_vta, False);
    end;
    if EjecutaSQL(format(_VTA_TIPO_SERVICIO,[gs_terminal]), lq_qry, _LOCAL) then
      LlenarComboBox(lq_qry, ls_servicio, False);

    titles();

    lq_qry.Free;
end;


procedure Tfrm_anticipa_vender.lbledt_cualesChange(Sender: TObject);
var
  li_ctrl_input, li_ajusta, li_maximo_asientos: Integer;
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
      if ((ls_input[li_ctrl_input - 1] = ' ') and (ls_input[li_ctrl_input] = '-')) or
        ((ls_input[li_ctrl_input - 1] = '-') and  (ls_input[li_ctrl_input] = ' ')) or
        ((ls_input[li_ctrl_input - 1] = ' ') and  (ls_input[li_ctrl_input] = ' ')) then
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
  if Length(lbledt_cuales.text) > 0 then begin
      li_maximo_asientos := totalLugares(lbledt_cuales.Text);
      gli_asientos_maximo := li_maximo_asientos;
      if li_maximo_asientos > (li_adultos + li_menores)  then begin
          ShowMessage('La eleccion es mayor a la permitida tiene un total de : ' + IntToStr(li_adultos + li_menores) + ' adquiridos' );
          lbledt_cuales.Clear;
          lbledt_cuales.SetFocus;
      end;
  end;
end;


procedure Tfrm_anticipa_vender.ls_canjeClick(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
    ls_codigo := ls_canje.CurrentID;
    try
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
{        if EjecutaSQL(format(_DESTALLA_B_ABIERTO,[ls_codigo]), lq_qry, _LOCAL) then begin
            ls_Origen_vta.ItemIndex :=  ls_Origen_vta.IDs.IndexOf(lq_qry['ORIGEN']);
            medt_fecha.SetFocus;
        end;}
    except

    end;
    lq_qry.Free;
end;

procedure Tfrm_anticipa_vender.ls_canjeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    ls_codigo : String;
    lq_qry : TSQLQuery;
    li_idx : integer;

begin
{    gi_servicio_venta := 0;
    if Key = 13 then begin
        ls_codigo := ls_canje.IDs[ls_canje.Items.IndexOf(ls_canje.Text)];
        gli_total_boletos_vendidos := 0;
        try
            lq_qry := TSQLQuery.Create(nil);
            lq_qry.SQLConnection := DM.Conecta;
            if EjecutaSQL(format(_DESTALLA_B_ABIERTO,[ls_codigo]), lq_qry, _LOCAL) then begin
                ls_Origen_vta.ItemIndex  := ls_Origen_vta.IDs.IndexOf(lq_qry['ORIGEN']);
                ls_Destino_vta.ItemIndex := ls_Destino_vta.IDs.IndexOf(lq_qry['DESTINO']);
                ls_servicio.ItemIndex    := ls_servicio.IDs.IndexOf(lq_qry['TIPOSERVICIO']);
                gi_servicio_venta := lq_qry['TIPOSERVICIO'];
            end;
            if EjecutaSQL(FORMAT(_GROUP_BOLETO_ABIERTO,[ls_codigo]), lq_qry, _LOCAL) then begin
              with lq_qry do begin
                First;
                li_idx := 1;
                while not Eof do begin
                  stg_ocupantes.Cells[0, li_idx] := lq_qry['DESCRIPCION'];
                  stg_ocupantes.Cells[1, li_idx] := IntToStr(lq_qry['CUANTOS']);
                  gli_total_boletos_vendidos := lq_qry['CUANTOS'];
                  inc(li_idx);
                  if lq_qry['DESCRIPCION'] = 'ADULTO' then begin
                      li_adultos := lq_qry['CUANTOS'];

                  end;
                  if lq_qry['DESCRIPCION'] = 'MENOR' then begin
                      li_menores := lq_qry['CUANTOS'];
                  end;
                  next;
                end;
                gli_total_boletos_vendidos := li_adultos + li_menores;
              end;
            end;
        except
              ;
        end;
        lq_qry.Free;
        lq_qry := nil;
    end;
    medt_fecha.Text := FechaServer();
    if gi_servicio_venta > 0 then
        medt_fecha.SetFocus;   }
end;

procedure Tfrm_anticipa_vender.medt_fechaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = 13 then begin
      corridasParametrosVenta(ls_Origen_vta.CurrentID, ls_Destino_vta.CurrentID, medt_fecha.text, '',
                             IntToStr( gi_servicio_venta ), 1,stg_corrida, ''); // mostramos la corrida
      stg_corrida.SetFocus;
      pintaBusCorrida(stg_corrida.Row);
    end;
end;

procedure Tfrm_anticipa_vender.pintaBusCorrida(li_indx: Integer);
var
  la_datos: gga_parameters;
  li_num: Integer;
  ls_hora : string;
begin
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos,li_num);
    if la_datos[0] = 'E' then gs_imprime_extra := ' Extra'
    else gs_imprime_extra := '';
    if li_num = 0 then ls_hora := la_datos[0]
    else ls_hora := la_datos[1];
    Image.Visible := True;
    obtenImagenBus(Image, stg_corrida.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
    muestraAsientosArreglo(ga_labels,StrToInt(stg_corrida.Cols[_COL_AUTOBUS].Strings[li_indx]), pnlBUS);
    asientosOcupados(ga_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),
                     StrToTime(ls_hora),stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
end;

procedure Tfrm_anticipa_vender.stg_corridaKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
    pintaBusCorrida(stg_corrida.Row);
end;


procedure Tfrm_anticipa_vender.stg_corridaKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_quien_ocupa, ls_tipo_ocupante: string;

  frm_Ocupada: TFrm_Corrida_Ocupada;
begin
  if Key = #13 then begin
{      if estatus_corrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                     stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row], gs_terminal) <> 'A' then begin
          Mensaje('El estatus de la corrida no se encuentra abierta para la venta',1);
          exit;
      end;}
      if StrToFloat(stg_corrida.Cells[_COL_TARIFA, stg_corrida.Row]) = 0 then begin
        Mensaje('Verifique la tarifa de la corrida, con el supervisor', 2);
        exit;
      end;
      gi_cupo_ruta := StrToInt(stg_corrida.Cols[_COL_ASIENTOS].Strings[stg_corrida.Row]);//CUPO POR LA RUTA ES LA PERMITIDA INCIALMENTE
      gi_ocupados := cupoCorridaVigente(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                        formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                                        split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]),CONEXION_VTA);
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
      gi_ruta := StrToInt(stg_corrida.Cells[_COL_RUTA, stg_corrida.Row]);
      lbledt_cuales.Clear;
      lbledt_tipo.Clear;
      lbledt_tipo.Enabled := False;
      grp_corridas.Visible := False;
      grp_cuales.Visible := True;
      ls_tipo_ocupante := '';
      if li_adultos > 0  then
         ls_tipo_ocupante := IntToStr(li_adultos)+'A';
      if li_menores > 0 then
         ls_tipo_ocupante := ls_tipo_ocupante + ' ' + IntToStr(li_menores) + 'M';
      lbledt_tipo.Text := ls_tipo_ocupante;
      lbledt_cuales.SetFocus;

  end;
end;


procedure Tfrm_anticipa_vender.TRefrescaCorridaTimer(Sender: TObject);
begin
  if (stg_corrida.Row > 1) and (tiempo_refresh_Grid() = 1) and
    (stg_corrida.Enabled = True) then begin
      pintaBusCorrida(stg_corrida.Row);
  end;
end;

procedure Tfrm_anticipa_vender.titles;
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
  stg_ocupantes.Cells[0, 0] := 'Descripcion';
  stg_ocupantes.Cells[1, 0] := 'Total';
end;

function Tfrm_anticipa_vender.totalLugares(textoEdit : string): integer;
var
    la_unicos, la_rangos : gga_parameters;
    li_num, li_ctrl, li_new_ctrl, li_asientos : integer;
    array_cuales: ga_asientos;
    lb_asientos_ok : Boolean;
begin
  splitLine(textoEdit, ' ', la_unicos, li_num);
  li_asientos := 0;
  lb_asientos_ok := False;
  for li_ctrl := 0 to li_num do begin
    if not rangoAsientos(la_unicos[li_ctrl]) then begin // si no son por rango
      if la_unicos[li_ctrl] = '' then
        exit;
      array_cuales[li_asientos] := StrToInt(la_unicos[li_ctrl]);
      inc(li_asientos);
    end else begin
      splitLine(la_unicos[li_ctrl], '-', la_rangos, li_num);
      if li_num > 0 then begin
        for li_new_ctrl := StrToInt(la_rangos[0]) to StrToInt(la_rangos[1]) do begin
          array_cuales[li_asientos] := li_new_ctrl;
          inc(li_asientos); // para el procedimiento
        end;
      end;
    end;
  end; // fin for
  if li_asientos > 0 then
      ga_asientos_cuales := array_cuales;
  result := li_asientos;
end;

end.
