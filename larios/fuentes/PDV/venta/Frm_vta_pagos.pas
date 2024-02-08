unit Frm_vta_pagos;

interface

{$HINTS OFF}
{$WARNINGS OFF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, U_venta, lsCombobox, Data.SqlExpr,
  frm_usuario_boletos, ComCtrls, u_cobro_banamex;

Const
  _CARACTERES_VALIDOS_PAGOS: SET OF CHAR = ['A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
    'W', 'X', 'Y', 'Z', #08, #13, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
    'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  _CARACTERES_VALIDOS_EFECTIVO: SET OF CHAR = ['0', '1', '2', '3', '4', '5',
    '6', '7', '8', '9', '.'];

type
  Tfrm_forma_pago = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    stg_formas_pago: TStringGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edt_total: TEdit;
    edt_cambio: TEdit;
    Bevel1: TBevel;
    Label3: TLabel;
    stg_pago_detalle: TStringGrid;
    stb_forma_pago: TStatusBar;
    edt_recibido: TEdit;
    Label4: TLabel;
    edt_total_efectivo: TEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure stg_pago_detalleSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edt_recibidoChange(Sender: TObject);
  private
    { Private declarations }
    asientos: array_asientos;
    procedure titles();
    procedure setAsientosVendidos(const Value: array_asientos);
    procedure titlesDetallePago();
    procedure detalleBoletosComprados();
    procedure llenarComboDescuentos(combo: TlsComboBox);
    procedure CombosChange(Sender: TObject);
    procedure ComboBoxEnter(Sender: TObject);
    procedure ComboBoxMouseEnter(Sender: TObject);
    procedure ComboExit(Sender: TObject);
    procedure ComboBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CombosKeyPress(Sender: TObject; var Key: CHAR);
    procedure DespliegaEfectivo();
  public
    { Public declarations }
    property vendidos: array_asientos write setAsientosVendidos;
    property lugares: array_asientos read asientos;
  end;

var
  frm_forma_pago: Tfrm_forma_pago;
  gls_cadena_combo: String;

implementation

uses comun, DMdb, Asiento, frm_nombre, frm_tarjeta_catalogo;
{$R *.dfm}

var
  lb_boleto_impreso: Boolean;
  // combo : array[1..30]of TlsComboBox;
  combo: array [1 .. 50] of TlsComboBox;
  lq_query: TSQLQuery;
  li_combo: Integer;
  li_idx_combo: Integer;
  li_row_elegida: Integer;
  ls_abreviacion: string;
  li_combo_ok: Integer;
  li_total_primero: Integer;

procedure Tfrm_forma_pago.ComboBoxEnter(Sender: TObject);
var
  li_tmp: Integer;
begin
  for li_tmp := 1 to li_ctrl_asiento - 1 do
  begin
    if ActiveControl = combo[li_tmp] then
    begin
      li_idx_combo := li_tmp;
      Break;
    end;
  end;
end;

procedure Tfrm_forma_pago.ComboBoxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  li_ctrl: Integer;
  lb_ejecuta: Boolean;
  tecla: CHAR;
begin
  // ShowMessage( 'keypress keyup');
  lb_ejecuta := false;
  for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do
  begin
    if Key = _TECLAS_ARRAY[li_ctrl] then
    begin
      lb_ejecuta := True;
    end;
  end;
  if lb_ejecuta then
  begin
    tecla := #13;
    CombosKeyPress(Sender, tecla);
  end;
  { else
    ShowMessage('false') }
end;

procedure Tfrm_forma_pago.ComboExit(Sender: TObject);
var
  Key: CHAR;
begin
  Key := #13;
  CombosKeyPress(Sender, Key);
end;

procedure Tfrm_forma_pago.ComboBoxMouseEnter(Sender: TObject);
var
  Key: CHAR;
begin
  Key := #13;
  CombosKeyPress(Sender, Key);
end;

procedure Tfrm_forma_pago.CombosChange(Sender: TObject);
var
  Key: CHAR;
begin
  Key := #13;
  CombosKeyPress(Sender, Key);
end;

procedure Tfrm_forma_pago.CombosKeyPress(Sender: TObject; var Key: CHAR);
var
  li_tmp, li_idx, li_ctrl_combo, li_descuento, li_tag_idx,
    li_catch_error: Integer;
  li_factor, ld_total: Double;
  ls_ids, ls_idx_box: String;
  lq_query: TSQLQuery;
begin
  if not(Key in _CARACTERES_VALIDOS_PAGOS) then
    Key := #0
  else
    gls_cadena_combo := combo[li_idx_combo].Text;
  if Key = #13 then
  begin

    li_tmp := combo[li_idx_combo].IDs.IndexOf(UpperCase(gls_cadena_combo));

    if combo[li_idx_combo].ItemIndex <= 0 then
      if li_tmp >= 0 then
        combo[li_idx_combo].ItemIndex := combo[li_idx_combo].IDs.IndexOf
          (UpperCase(combo[li_idx_combo].Text))
      else
      begin
        combo[li_idx_combo].ItemIndex := 0;
        // exit;
      end;

    try
      li_tag_idx := combo[li_idx_combo].Tag;
      lq_query := TSQLQuery.Create(nil);
      lq_query.SQLConnection := DM.Conecta;
      li_catch_error := 0;
      if EjecutaSQL(format(_VTA_FORMA_PAGO_DESCRIPCION, [gls_cadena_combo]),
        lq_query, _LOCAL) then
      begin
        if VarIsNull(lq_query['ABREVIACION']) then
        begin
          if EjecutaSQL(format(_VTA_FORMA_PAGO_ABREVIACION,
              [gls_cadena_combo]), lq_query, _LOCAL) then
          begin
            if not VarIsNull(lq_query['ABREVIACION']) then
            begin
              combo[li_idx_combo].ItemIndex := combo[li_idx_combo].IDs.IndexOf
                (UpperCase(lq_query['ABREVIACION']))
            end
            else
            begin
              combo[li_idx_combo].ItemIndex := 0;
              li_catch_error := 1;
            end; // fin ifelse
          end
          else
            combo[li_idx_combo].ItemIndex := combo[li_idx_combo].IDs.IndexOf
              (UpperCase(lq_query['ABREVIACION']))
        end;
        if li_catch_error = 1 then
          if EjecutaSQL(format(_VTA_FORMA_PAGO_ABREVIACION, ['EFE']), lq_query,
            _LOCAL) then
          end;
        asientos[li_tag_idx].forma_pago := lq_query['ID_FORMA_PAGO'];
        asientos[li_tag_idx].abrePago := lq_query['ABREVIACION'];
        asientos[li_tag_idx].pago_efectivo := lq_query['SUMA_EFECTIVO_COBRO'];
        ls_ids := asientos[li_tag_idx].abrePago;

        if (stg_pago_detalle.Cells[_GRID_TIPO, li_idx_combo] <> 'Adulto') and
          (lq_query['CANCELABLE'] = 'F') then
        begin
          mensaje('No se pueden aplicar dos descuentos', 0);
          combo[li_idx_combo].ItemIndex := 0;
          if EjecutaSQL(format(_VTA_FORMA_PAGO_DESCRIPCION,
              [combo[li_idx_combo].Text]), lq_query, _LOCAL) then
          begin
            asientos[li_tag_idx].forma_pago := lq_query['ID_FORMA_PAGO'];
            asientos[li_tag_idx].abrePago := lq_query['ABREVIACION'];
            asientos[li_tag_idx].pago_efectivo := lq_query['SUMA_EFECTIVO_COBRO'];
            ls_ids := asientos[li_tag_idx].abrePago;
            for li_idx := 1 to stg_formas_pago.RowCount - 1 do
            begin // buscamos en la columna donde tenemos la abreviacion
              ls_abreviacion := stg_formas_pago.Cells[_VTA_COL_FORMA_ID,
                li_idx];
              ld_total := 0;
              for li_ctrl_combo := 1 to li_ctrl_asiento - 1 do
              begin
                if ls_abreviacion = asientos[li_ctrl_combo].abrePago then
                begin
                  ld_total := ld_total + asientos[li_ctrl_combo].precio;
                end;
              end;
              stg_formas_pago.Cells[1, li_idx] := format('%0.2f', [ld_total]);
            end;
          end;
          exit;
        end;

        finally
          lq_query.Destroy;
        end;
        for li_idx := 1 to stg_formas_pago.RowCount - 1 do
        begin
          if ls_ids = stg_formas_pago.Cells[_VTA_COL_FORMA_ID, li_idx] then
          begin
            li_descuento := StrToInt(stg_formas_pago.Cells[_VTA_COL_FORMA_ID + 1, li_idx]);
            Break;
          end;
        end;
        if (li_descuento > 0) then
        begin
          asientos[li_tag_idx].precio :=
            (
            (asientos[li_tag_idx].precio_original * li_descuento)
              / 100);
        end;
        if li_descuento = 100 then
        begin
          asientos[li_tag_idx].precio := 0;
        end;
        if li_descuento = 0 then
        begin
          asientos[li_tag_idx].precio := asientos[li_tag_idx].precio_original;
        end;

        stg_pago_detalle.Cells[_GRID_PRECIO, li_tag_idx] := floatToStr
          (asientos[li_tag_idx].precio);
        for li_idx := 1 to stg_formas_pago.RowCount - 1 do
        begin // buscamos en la columna donde tenemos la abreviacion
          ls_abreviacion := stg_formas_pago.Cells[_VTA_COL_FORMA_ID, li_idx];
          ld_total := 0;
          for li_ctrl_combo := 1 to li_ctrl_asiento - 1 do
          begin
            if ls_abreviacion = asientos[li_ctrl_combo].abrePago then
            begin
              ld_total := ld_total + asientos[li_ctrl_combo].precio;
            end;
          end;
          stg_formas_pago.Cells[1, li_idx] := format('%0.2f', [ld_total]);
          if length(edt_recibido.Text) = 0 then
          begin
            mensaje('Ingrese la cantidad recibida', 0);
            edt_recibido.SetFocus;
            exit;
          end;
        end;
        DespliegaEfectivo();
      end;
    end;

    procedure Tfrm_forma_pago.DespliegaEfectivo;
    var
      li_ctrl_idx: Integer;
      lf_total_efectivo, lf_cambio: Double;
    begin
      lf_total_efectivo := 0;
      for li_ctrl_idx := 0 to li_ctrl_asiento - 1 do
      begin
        if asientos[li_ctrl_idx].pago_efectivo = 1 then
          lf_total_efectivo := lf_total_efectivo + asientos[li_ctrl_idx].precio;
      end;
      edt_total_efectivo.Text := format('%0.2f', [lf_total_efectivo]);
      lf_cambio := StrToFloat(edt_recibido.Text) - StrToFloat
        (edt_total_efectivo.Text);
      edt_cambio.Text := format('%0.2f', [lf_cambio]);
      edt_recibido.Text := format('%0.2f', [StrToFloat(edt_recibido.Text)]);
    end;

    { @Procedure detalleBoletosComprados
      @Descripcion cargamos la informacion en el grid y creamos los lscombobox en tiempo
      de ejecucion y agregados en la columna del grid de forma de pago }
    procedure Tfrm_forma_pago.detalleBoletosComprados;
    var
      li_ctrl_interno: Integer;
    begin
      // combo := nil;
      // SetLength(combo, li_ctrl_asiento);
      stg_pago_detalle.RowCount := li_ctrl_asiento;
      li_combo_ok := 0;
      for li_ctrl_interno := 1 to li_ctrl_asiento - 1 do
      begin
        stg_pago_detalle.Cells[_GRID_ASIENTO, li_ctrl_interno] := IntToStr(asientos[li_ctrl_interno].Asiento);
        stg_pago_detalle.Cells[_GRID_TIPO,li_ctrl_interno] := asientos[li_ctrl_interno].Ocupante;
        stg_pago_detalle.Cells[_GRID_PRECIO, li_ctrl_interno] := floatToStr(asientos[li_ctrl_interno].precio);
        stg_pago_detalle.Cells[_GRID_ORI_DES,li_ctrl_interno] := asientos[li_ctrl_interno].origen + '-' + asientos[li_ctrl_interno].destino;
        stg_pago_detalle.Cells[_GRID_PRECIO_FIJO, li_ctrl_interno] := floatToStr(asientos[li_ctrl_interno].precio);
        stg_pago_detalle.Cells[_GRID_FECHA_CORRIDA, li_ctrl_interno] := copy(asientos[li_ctrl_interno].fecha_hora, 1, 10);
        stg_pago_detalle.Cells[_GRID_FECHA_HORA, li_ctrl_interno] := copy(asientos[li_ctrl_interno].fecha_hora, 12, 5);
        combo[li_ctrl_interno] := TlsComboBox.Create(Self);
        combo[li_ctrl_interno].Width := stg_pago_detalle.ColWidths[_GRID_PAGO];
        combo[li_ctrl_interno].Height := stg_pago_detalle.RowHeights[_GRID_PAGO];
        combo[li_ctrl_interno].Parent := stg_pago_detalle;
        combo[li_ctrl_interno].BoundsRect := stg_pago_detalle.CellRect(_GRID_PAGO, li_ctrl_interno);
        combo[li_ctrl_interno].Name := 'cb_descuento' + IntToStr(li_ctrl_interno);
        combo[li_ctrl_interno].CharCase := ecUpperCase;
        combo[li_ctrl_interno].AutoComplete := True;
        combo[li_ctrl_interno].ForceIndexOnExit := false;
        combo[li_ctrl_interno].Complete := false;
        combo[li_ctrl_interno].Tag := li_ctrl_interno;
        // combo[li_ctrl_interno].Style := csSimple;
        combo[li_ctrl_interno].Style := csDropDownList;
        combo[li_ctrl_interno].OnChange := CombosChange;
        combo[li_ctrl_interno].OnEnter := ComboBoxEnter;
        combo[li_ctrl_interno].OnExit := ComboExit;
        combo[li_ctrl_interno].OnMouseEnter := ComboBoxMouseEnter;
        combo[li_ctrl_interno].OnKeyUp := ComboBoxKeyUp;
        combo[li_ctrl_interno].OnKeyPress := CombosKeyPress;
        llenarComboDescuentos(combo[li_ctrl_interno]);
        combo[li_ctrl_interno].ItemIndex := 0;
        inc(li_combo_ok);
      end;
      if li_combo_ok > 0 then
        combo[1].SetFocus; // redireccionarlos correctamente
      lq_query.Free;
    end;

    { @Procedure edt_recibidoChange
      @Params Sender : TObject
      @Descripcion Validamos los datos de entrada solo permite valores numericos }
    procedure Tfrm_forma_pago.edt_recibidoChange(Sender: TObject);
    var
      ls_efectivo, ls_input, ls_output: string;
      lc_char, lc_new: CHAR;
      li_idx, li_ctrl: Integer;
    begin
      ls_input := '';
      ls_efectivo := edt_recibido.Text;
      for li_idx := 1 to length(ls_efectivo) do begin
        lc_char := ls_efectivo[li_idx];
        if ls_efectivo[1] = '0' then begin
          edt_recibido.Clear;
          edt_recibido.SetFocus;
          exit;
        end
        else
          ls_input := ls_input + lc_char;
        if not(lc_char in _CARACTERES_VALIDOS_EFECTIVO) then begin
          for li_ctrl := 1 to length(ls_input) - 1 do begin
            lc_new := ls_input[li_ctrl];
            ls_output := ls_output + lc_new;
          end;
          edt_recibido.Text := ls_output;
          edt_recibido.SelStart := length(ls_output);
        end;
      end;
    end;

    procedure Tfrm_forma_pago.FormActivate(Sender: TObject);
    begin
//      stb_forma_pago.Panels[0].Text := 'F4 Otro boleto para venta';
      stb_forma_pago.Panels[1].Text := 'F5 Cancelar';
      stb_forma_pago.Panels[2].Text := 'F9 Detallado individual al pago';
      stb_forma_pago.Panels[3].Text := 'F10 Imprime';
      stb_forma_pago.Panels[4].Text := 'F12 Nombre Pasajero';
      gi_usuario_ocupado := 1;
    end;

    procedure Tfrm_forma_pago.FormClose(Sender: TObject;
      var Action: TCloseAction);
    begin
      formPago := 0;
      gi_usuario_ocupado := 0; // para no cerrar la ventana con el idle
      gb_forma_pago := false;
      gs_nombre_pax := '';
    end;



    procedure Tfrm_forma_pago.FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    var
      li_ctrl_pagos, li_ctrl_interno, li_idx: Integer;
      li_pagos: Double;
      frm: Tfrm_nombre_boleto;
      la_datos: gga_parameters;
      li_num: Integer;
      ls_hora, ls_analiza, ls_apartada: string;
      frm_name : TFrm_credencial;
      vTarjeta_fisica, lb_existe : Boolean;
      frm_catalogo : Tfrm_catalogo_pago;
    begin
      if (Key = VK_F4) and (ssAlt in Shift) then
        Key := 0;

      if Key = VK_RETURN then begin
        li_pagos := 0;
        li_total_primero := 0;
        for li_ctrl_pagos := 1 to stg_formas_pago.RowCount - 1 do begin
          if length(stg_formas_pago.Cells[_VTA_CANTIDAD_PAGAR, li_ctrl_pagos])
            > 0 then
            li_pagos := li_pagos + StrToFloat
              (stg_formas_pago.Cells[_VTA_CANTIDAD_PAGAR, li_ctrl_pagos]);
        end;
        try
          DespliegaEfectivo();
        except
        end;
        try
          if (length(edt_recibido.Text) = 0) then begin
            mensaje('Indique la cantidad recibida', 0);
            edt_recibido.SetFocus;
            exit;
          end;
          if StrToFloat(edt_recibido.Text) < StrToFloat(edt_total_efectivo.Text) then begin
            mensaje('La cantidad recibida es menor al monto total', 0);
            edt_cambio.Clear;
            edt_total_efectivo.Clear;
            edt_recibido.Clear;
            edt_recibido.SetFocus;
            exit;
          end;
          if li_total_primero = 1 then
            edt_total.Text := format('%0.2f', [li_pagos]);
        except
          edt_recibido.SetFocus;
        end;
        exit;
      end;

      if Key = VK_F4 then begin
        gi_seleccion := _VENTA_ELIGE_OTRA;
        gi_otro_boleto := 1;
        asientos_regreso := asientos;
        Close;
      end;

      if ((Key = VK_F9) and (gb_forma_pago = false)) then  begin // muestra las formas de pago
        // validas si tenemos mas de dos asientos desplega la informacion
        if ((length(edt_recibido.Text) = 0) and
            (stg_pago_detalle.visible = false)) then
        begin
          mensaje('Cantidad por cobrar', 0);
          exit;
        end;
        // la cantidad deve ser mayor al total
        if StrToFloat(edt_recibido.Text) < StrToFloat(edt_total.Text) then
        begin
          mensaje('La cantidad recibida deve ser mayor o igual al total', 0);
          edt_recibido.Clear;
          edt_recibido.SetFocus;
          exit;
        end;

        stg_formas_pago.Enabled := false;
        stg_pago_detalle.visible := True;
        titlesDetallePago();
        detalleBoletosComprados();
        gb_forma_pago := True;
      end;

      if Key = VK_F10 then begin
        if FileExists(_BOLETOS) then
          DeleteFile(_BOLETOS);

        // Salez Venta de reservaciones

         if gs_tarjeta_fisica = '1' then
           vTarjeta_fisica := True
         else
           vTarjeta_fisica := False;
         if existenPagosConBanamex(asientos, gi_idx_asientos) then
           if not cobrarConBanamex(asientos, gi_idx_asientos,  vTarjeta_fisica, dm.Conecta) then Begin
             showmessage('No fue posible cobrar con Banamex PinPad.' + #10#13 + #10#13 + gs_pinpad_banamex_error);
             exit;
           end;
///validamos si tiene venta con ixe
        lb_existe := False;
        for li_idx := 1 to li_ctrl_asiento do begin
            if asientos[li_idx].forma_pago = 2 then begin
                lb_existe := True;
            end;
        end;

        if lb_existe then begin
             try
                frm_catalogo := Tfrm_catalogo_pago.Create(nil);
                frm_catalogo_pago.ShowModal;
                for li_idx := 0 to gi_idx_asientos do
                    if asientos[li_idx].forma_pago = 2 then
                       asientos[li_idx].tipo_tarjeta := gs_tarjeta_CD;
             finally
                frm_catalogo.Free;
                frm := nil;
             end;
        end;

        ImprimeBoletos(asientos, li_ctrl_asiento); // guardar la informacion en la tabla de boleto
        li_f4 := 1;
        Close;
        li_ctrl_asiento := 1; // EN LA PANTALLA DE LA VENTA en la parte de la busqueda
        gi_seleccion := _VENTA_INICIO;
        formPago := 0;
        FormActivate(Sender);
        gi_vta_pie := 0;
        li_impresion_boleto := 1;
        BorraArregloAsientos(asientos);
        asientos_regreso := asientos;
        gi_arreglo := 1; // reiniciamos el contador para el recalculo
      end;

      if Key = VK_F12 then begin
        frm_name := TFrm_credencial.Create(nil);
        gs_nombre_pax := '';// aqui va la nueva forma para el ingreso del nombre y dato de la identificacion
        MostrarForma(frm_name);
      end; // para solicitar el nombre del la persona para imprimirlo en los boletos

      // f11
      if (Key = _KEY_INGRESA_DATOS) and (gi_cuales = 2) then
      begin
        frm := Tfrm_nombre_boleto.Create(nil);
        frm.nombres := asientos;
        MostrarForma(frm);
      end;
      if Key = VK_F5 then begin// borramos la referencia en la tabla pdv_t_corrida_d  asientos,li_ctrl_asiento);
        for li_ctrl_interno := 1 to gi_arreglo do begin
          splitLine(asientos[li_ctrl_interno].fecha_hora, ' ', la_datos, li_num);
          if li_num = 0 then ls_hora := la_datos[1]
          else ls_hora := la_datos[li_num];
          ls_analiza := la_datos[0];
          if (ls_analiza[5] = '/') or (ls_analiza[5] = '-') then
            la_datos[0] := copy(ls_analiza, 9, 2) + '/' + copy(ls_analiza, 6,2) + '/' + copy(ls_analiza, 1, 4);
          gd_fecha_apartada := StrToDate(la_datos[0]);
          apartaCorrida(asientos[li_ctrl_interno].corrida, gd_fecha_apartada, ls_hora, asientos[li_ctrl_interno].origen, gs_trabid,
                        asientos[li_ctrl_interno].ruta);
        end;// recorremos el arreglo y borramos lo que contega este
        BorraAsiento(asientos, gi_arreglo);
        BorraArregloAsientos(asientos);
        asientos_regreso := asientos;
        li_ctrl_asiento := 1;
        gi_seleccion := _VENTA_CANCELADA;
        gi_vta_pie := 0;
        gi_arreglo := 1;
        Close;
      end;
    end;


    procedure Tfrm_forma_pago.FormShow(Sender: TObject);
    var
      li_ctrl_cell: Integer;
      lr_total, lr_efectivo: Real;
    begin
      gs_nombre_pax := '';
      li_total_primero := 1;
      gb_forma_pago := false;
      lb_boleto_impreso := false;
      titles();
      stg_formas_pago.Row := 1;
      stg_formas_pago.Col := 1;
      stg_formas_pago.SetFocus;
      stg_formas_pago.EditorMode := True;
      lq_query := TSQLQuery.Create(Self);
      gds_formas_pago := TDualStrings.Create;
      gds_tabla_forma_pago := TDualStrings.Create;
      lq_query.SQLConnection := CONEXION_VTA;
      lr_total := calcula(asientos, li_ctrl_asiento);
      apartaCorrida(gs_corrida_apartada, gd_fecha_apartada, gs_hora_apartada,gs_terminal_apartada, gs_trabid, gi_ruta_apartada);
      if EjecutaSQL(_VTA_FORMAS_PAGO, lq_query, _LOCAL) then begin
        li_ctrl_cell := 1;
        lq_query.First;
        while not lq_query.Eof do begin
          gds_formas_pago.Add(lq_query['ABREVIACION'], lq_query['DESCUENTO']);
          gds_tabla_forma_pago.Add(lq_query['ABREVIACION'],
            lq_query['DESCRIPCION']);
          stg_formas_pago.Cells[0, li_ctrl_cell] := lq_query['DESCRIPCION'];
          stg_formas_pago.Cells[1, li_ctrl_cell] := format('%0.2f', [lr_total]);
          if lq_query['ABREVIACION'] = 'EFE' then
          begin
            lr_efectivo := lr_total;
            lr_total := 0;
          end;

          stg_formas_pago.Cells[_VTA_COL_FORMA_ID, li_ctrl_cell] := lq_query['ABREVIACION'];
          stg_formas_pago.Cells[_VTA_COL_FORMA_ID + 1,li_ctrl_cell] := lq_query['DESCUENTO'];
          inc(li_ctrl_cell);
          lq_query.Next;
        end;
      end;
      edt_total.Text := format('%0.2f', [lr_efectivo]); // total
      stg_formas_pago.RowCount := li_ctrl_cell;
      edt_total_efectivo.Text := format('%0.2f', [lr_efectivo]);
      edt_cambio.Text := '0';
      edt_recibido.Text := format('%0.2f', [lr_efectivo]);
      edt_recibido.SelStart := length(edt_recibido.Text);
      edt_recibido.SetFocus;
    end;




    { @procedure llenarComboDescuentos
      @Descripcion cargamos los combobox con la clave y la descripion }
    procedure Tfrm_forma_pago.llenarComboDescuentos(combo: TlsComboBox);
    begin
      with lq_query do
      begin
        First;
        while not Eof do
        begin
          combo.Add(lq_query.Fields[2].AsString, lq_query.Fields[1].AsString);
          Next;
        end; // fin
      end; // fin
    end;


    procedure Tfrm_forma_pago.setAsientosVendidos(const Value: array_asientos);
    begin
      asientos := Value;
    end;


    { @procedure stg_pago_detalleSelectCell
      @Descripcion Posicionamos en la columna solo de edicion }
    procedure Tfrm_forma_pago.stg_pago_detalleSelectCell(Sender: TObject;
      ACol, ARow: Integer; var CanSelect: Boolean);
    begin
      li_combo := stg_pago_detalle.Row;

      if (ACol = _GRID_PAGO) then
        stg_pago_detalle.Options := stg_pago_detalle.Options + [goEditing]
      else
        stg_pago_detalle.Options := stg_pago_detalle.Options - [goEditing]
    end;

    { @proceudrre titles
      @descripcion colocamos etiquetas en los encabezados del grid }
    procedure Tfrm_forma_pago.titles;
    begin
      stg_formas_pago.Cells[0, 0] := 'Formas de Pago';
      stg_formas_pago.Cells[1, 0] := 'Cantidad';
      stg_formas_pago.Cells[2, 0] := 'Numero de Documento';
      stg_formas_pago.Cells[3, 0] := 'Autorizacion';
      stg_formas_pago.ColWidths[_VTA_COL_FORMA_ID] := 0;
      stg_formas_pago.ColWidths[_VTA_COL_FORMA_ID + 1] := 0;
    end;

    { @proceudrre titlesDetallePago
      @descripcion colocamos etiquetas en los encabezados del grid }
    procedure Tfrm_forma_pago.titlesDetallePago;
    begin
      stg_pago_detalle.Cells[0, 0] := 'Asiento';
      stg_pago_detalle.Cells[1, 0] := 'Tipo';
      stg_pago_detalle.Cells[2, 0] := 'Precio';
      stg_pago_detalle.Cells[3, 0] := 'Origen - Destino';
      stg_pago_detalle.Cells[4, 0] := 'Pago';
      stg_pago_detalle.ColWidths[5] := 0;
      stg_pago_detalle.Cells[6, 0] := 'Fecha';
      stg_pago_detalle.Cells[7, 0] := 'Hora';
    end;

end.
