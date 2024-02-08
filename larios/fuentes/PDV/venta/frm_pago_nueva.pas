unit frm_pago_nueva;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, u_comun_venta, lsCombobox, Data.SqlExpr,
  ComCtrls, u_cobro_banamex;
Const
  _CARACTERES_VALIDOS_PAGOS: SET OF CHAR = ['A', 'B', 'C', 'D', 'E', 'F', 'G',
    'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
    'W', 'X', 'Y', 'Z', #08, #13, 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i',
    'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x',
    'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];


type
  Tfrm_nueva_pagoF = class(TForm)
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    edt_total: TEdit;
    edt_cambio: TEdit;
    edt_recibido: TEdit;
    edt_total_efectivo: TEdit;
    GroupBox1: TGroupBox;
    stg_formas_pago: TStringGrid;
    stg_pago_detalle: TStringGrid;
    stb_forma_pago: TStatusBar;
    lbl_totalBoletos: TLabel;
    stb_panelUno: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edt_recibidoChange(Sender: TObject);
  private
    { Private declarations }
    asientos: array_asientos;
    Boleto_Abieto : integer;
    procedure titles();
    procedure setAsientosVendidos(const Value: array_asientos);
    procedure titlesDetallePago;
    procedure detalleBoletosComprados(li_creados : integer);
    procedure CombosChange(Sender: TObject);
    procedure ComboBoxEnter(Sender: TObject);
    procedure ComboBoxMouseEnter(Sender: TObject);
    procedure ComboExit(Sender: TObject);
    procedure ComboBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CombosKeyPress(Sender: TObject; var Key: CHAR);
    procedure llenarComboDescuentos(combo: TlsComboBox);
    procedure DespliegaEfectivo();
  public
    { Public declarations }
    property vendidos: array_asientos write setAsientosVendidos;
    property lugares: array_asientos read asientos;
    property abierto : integer write Boleto_Abieto;
  end;

var
  frm_nueva_pagoF: Tfrm_nueva_pagoF;
    gi_venta_reservacion : integer;

implementation

uses  comun, DMdb, frm_nombre, frm_personalizacion_boletos, u_validaTarjeta,
  frm_tarjeta_catalogo;

{$R *.dfm}

var
    combo: array [1 .. 50] of TlsComboBox;
    lq_query: TSQLQuery;
    li_idx_combo: Integer;
    ls_abreviacion: string;
    gls_cadena_combo: String;
    li_total_primero: Integer;
    li_creates_box  : integer;
    gi_dto_aplicado : integer;

    gi_boletos_impresos : integer;

procedure Tfrm_nueva_pagoF.ComboBoxEnter(Sender: TObject);
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

procedure Tfrm_nueva_pagoF.ComboBoxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  li_ctrl: Integer;
  lb_ejecuta: Boolean;
  tecla: CHAR;
begin
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
end;

procedure Tfrm_nueva_pagoF.ComboBoxMouseEnter(Sender: TObject);
var
  Key: CHAR;
begin
      Key := #13;
      CombosKeyPress(Sender, Key);
end;

procedure Tfrm_nueva_pagoF.ComboExit(Sender: TObject);
var
  Key: CHAR;
begin
    Key := #13;
    CombosKeyPress(Sender, Key);
end;

procedure Tfrm_nueva_pagoF.CombosChange(Sender: TObject);
var
  Key: CHAR;
begin
    Key := #13;
    CombosKeyPress(Sender, Key);
end;

procedure Tfrm_nueva_pagoF.CombosKeyPress(Sender: TObject; var Key: CHAR);
var
  li_tmp, li_idx, li_ctrl_combo, li_descuento, li_tag_idx,
    li_catch_error: Integer;
  li_factor, ld_total, ld_precio: Double;
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
        combo[li_idx_combo].ItemIndex := combo[li_idx_combo].IDs.IndexOf(UpperCase(combo[li_idx_combo].Text))
      else
      begin
        combo[li_idx_combo].ItemIndex := 0;
        // exit;
      end;
    try
        li_tag_idx := combo[li_idx_combo].Tag;
        lq_query := TSQLQuery.Create(nil);
        lq_query.SQLConnection := CONEXION_VTA;
        li_catch_error := 0;
        if EjecutaSQL(format(_VTA_FORMA_PAGO_DESCRIPCION, [gls_cadena_combo]),lq_query, _LOCAL) then begin
          if VarIsNull(lq_query['ABREVIACION']) then begin
            if EjecutaSQL(format(_VTA_FORMA_PAGO_ABREVIACION,[gls_cadena_combo]), lq_query, _LOCAL) then begin
              if not VarIsNull(lq_query['ABREVIACION']) then begin
                combo[li_idx_combo].ItemIndex := combo[li_idx_combo].IDs.IndexOf(UpperCase(lq_query['ABREVIACION']))
              end else begin
                          combo[li_idx_combo].ItemIndex := 0;
                          li_catch_error := 1;
              end; // fin ifelse
            end else
              combo[li_idx_combo].ItemIndex := combo[li_idx_combo].IDs.IndexOf(UpperCase(lq_query['ABREVIACION']))
          end;
          if li_catch_error = 1 then
            if EjecutaSQL(format(_VTA_FORMA_PAGO_ABREVIACION, ['EFE']), lq_query,
              _LOCAL) then
            end;
          asientos[li_tag_idx].forma_pago := lq_query['ID_FORMA_PAGO'];
          asientos[li_tag_idx].abrePago := lq_query['ABREVIACION'];
          asientos[li_tag_idx].pago_efectivo := lq_query['SUMA_EFECTIVO_COBRO'];
          ls_ids := asientos[li_tag_idx].abrePago;

          if (stg_pago_detalle.Cells[_GRID_TIPO, li_idx_combo] <> 'Adulto') and (lq_query['CANCELABLE'] = 'F') then begin
            mensaje('No se pueden aplicar dos descuentos', 0);
            combo[li_idx_combo].ItemIndex := 0;
            if EjecutaSQL(format(_VTA_FORMA_PAGO_DESCRIPCION,[combo[li_idx_combo].Text]), lq_query, _LOCAL) then begin
              asientos[li_tag_idx].forma_pago := lq_query['ID_FORMA_PAGO'];
              asientos[li_tag_idx].abrePago := lq_query['ABREVIACION'];
              asientos[li_tag_idx].pago_efectivo := lq_query['SUMA_EFECTIVO_COBRO'];
              ls_ids := asientos[li_tag_idx].abrePago;
              for li_idx := 1 to stg_formas_pago.RowCount - 1 do begin // buscamos en la columna donde tenemos la abreviacion
                ls_abreviacion := stg_formas_pago.Cells[_VTA_COL_FORMA_ID,
                  li_idx];
                ld_total := 0;
                for li_ctrl_combo := 1 to li_ctrl_asiento - 1 do begin
                  if ls_abreviacion = asientos[li_ctrl_combo].abrePago then begin
                    ld_total := ld_total + asientos[li_ctrl_combo].precio;
                  end;
                end;
                stg_formas_pago.Cells[1, li_idx] := format('%0.2f', [ld_total]);
              end;
            end;
          end;
        finally
          lq_query.Destroy;
        end;

        for li_idx := 1 to stg_pago_detalle.RowCount - 1 do  begin
          if ls_ids = combo[li_idx_combo].CurrentID then begin

            li_descuento := StrToInt(stg_pago_detalle.Cells[_VTA_COL_FORMA_ID + 1, li_idx_combo]);
            if li_descuento = 0 then
                    li_descuento := StrToInt(gds_formas_pago.ValueOf(ls_ids));
            Break;
          end;
        end;
        if true then begin

//        if (gi_venta_grupal_dto = 0) or (gi_vta_dto_viaje_rdo = 0) then begin
        ///validar cuando se aplica descuento no entre a moverlo
            if  gi_dto_aplicado = 0 then begin
//                asientos[li_tag_idx].tarifa_real
                if (li_descuento > 0) then begin
                  asientos[li_tag_idx].precio := ((asientos[li_tag_idx].precio_original * li_descuento) / 100);
                  ld_precio := (asientos[li_tag_idx].tarifa_real -  ((asientos[li_tag_idx].tarifa_real * li_descuento) / 100) );
                  if ld_precio <> asientos[li_tag_idx].precio then
                      asientos[li_tag_idx].precio := (asientos[li_tag_idx].tarifa_real -  ((asientos[li_tag_idx].tarifa_real * li_descuento) / 100) );

                end;
                if li_descuento = 100 then asientos[li_tag_idx].precio := 0;
//larios checamos 12-11-2020
                if li_descuento = 0 then asientos[li_tag_idx].precio := asientos[li_tag_idx].precio_original;//cambio por precio_original
            end;
        end;

        if li_creates_box = 0 then
            stg_pago_detalle.Cells[_GRID_PRECIO, li_tag_idx] := formatfloat('###,##0.00',asientos[li_tag_idx].precio);
//SE AGREGO ESTA LINEA PARA LAS FORMAS DE PAGO
//        if li_descuento > 0 then
          stg_pago_detalle.Cells[_GRID_PRECIO, li_tag_idx] := formatfloat('###,##0.00',asientos[li_tag_idx].precio);

        for li_idx := 1 to stg_formas_pago.RowCount - 1 do begin // buscamos en la columna donde tenemos la abreviacion
          ls_abreviacion := stg_formas_pago.Cells[_VTA_COL_FORMA_ID, li_idx];
          ld_total := 0;
          for li_ctrl_combo := 1 to li_ctrl_asiento - 1 do begin
            if ls_abreviacion = asientos[li_ctrl_combo].abrePago then begin
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

procedure Tfrm_nueva_pagoF.DespliegaEfectivo;
var
  li_ctrl_idx: Integer;
  lf_total_efectivo, lf_total_pagar, lf_cambio, lf_recibido : Double;
begin
      lf_total_efectivo := 0;
      for li_ctrl_idx := 0 to li_ctrl_asiento - 1 do begin
        if asientos[li_ctrl_idx].pago_efectivo = 1 then begin
              lf_total_efectivo := lf_total_efectivo + asientos[li_ctrl_idx].precio;
        end;
        lf_total_pagar := lf_total_pagar + asientos[li_ctrl_idx].precio;

      end;

{      if lf_total_efectivo > 0 then
            edt_recibido.Text := format('%0.2f', [lf_total_efectivo]);}

//      edt_total.Text := format('%0.2f', [lf_total_efectivo]);
      edt_total.Text := format('%0.2f', [lf_total_pagar]);

      edt_total_efectivo.Text := format('%0.2f', [lf_total_efectivo]);
      lf_cambio := StrToFloat(edt_recibido.Text) - StrToFloat(edt_total_efectivo.Text);
      edt_cambio.Text := format('%0.2f', [lf_cambio]);
//      edt_recibido.Text := format('%0.2f', [StrToFloat(edt_recibido.Text)]);
end;

procedure Tfrm_nueva_pagoF.detalleBoletosComprados(li_creados : integer);
var
      li_ctrl_interno: Integer;
begin
      stg_pago_detalle.RowCount := gi_idx_asientos + 1;
      for li_ctrl_interno := 1 to gi_idx_asientos do begin
          stg_pago_detalle.Cells[_GRID_ASIENTO, li_ctrl_interno] := IntToStr(asientos[li_ctrl_interno].Asiento);
          stg_pago_detalle.Cells[_GRID_TIPO,li_ctrl_interno] := asientos[li_ctrl_interno].Ocupante;
          stg_pago_detalle.Cells[_GRID_PRECIO, li_ctrl_interno] := format('%0.2f',[asientos[li_ctrl_interno].precio]);
          stg_pago_detalle.Cells[_GRID_ORI_DES,li_ctrl_interno] := asientos[li_ctrl_interno].origen + '-' + asientos[li_ctrl_interno].destino;
          stg_pago_detalle.Cells[_GRID_PRECIO_FIJO, li_ctrl_interno] := floatToStr(asientos[li_ctrl_interno].descuento); //precio
          stg_pago_detalle.Cells[_GRID_FECHA_CORRIDA, li_ctrl_interno] := copy(asientos[li_ctrl_interno].fecha_hora, 1, 10);
          stg_pago_detalle.Cells[_GRID_FECHA_HORA, li_ctrl_interno] := copy(asientos[li_ctrl_interno].fecha_hora, 12, 5);
          if li_creados = 0 then  begin
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
              combo[li_ctrl_interno].Style := csDropDownList;
              combo[li_ctrl_interno].OnChange := CombosChange;
              combo[li_ctrl_interno].OnEnter := ComboBoxEnter;
              combo[li_ctrl_interno].OnExit := ComboExit;
              combo[li_ctrl_interno].OnMouseEnter := ComboBoxMouseEnter;
              combo[li_ctrl_interno].OnKeyUp := ComboBoxKeyUp;
              combo[li_ctrl_interno].OnKeyPress := CombosKeyPress;
              llenarComboDescuentos(combo[li_ctrl_interno]);
              combo[li_ctrl_interno].ItemIndex := 0;
          end else begin

          end;
      end;
      if li_ctrl_interno > 0 then
        combo[1].SetFocus; // redireccionarlos correctamente
end;


procedure Tfrm_nueva_pagoF.edt_recibidoChange(Sender: TObject);
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


procedure Tfrm_nueva_pagoF.FormActivate(Sender: TObject);
begin
      stb_forma_pago.Panels[0].Text := 'F5 Cancelar';
      stb_forma_pago.Panels[1].Text := 'F9 Detallado individual al pago';
      stb_forma_pago.Panels[2].Text := 'F10 Imprime';
      stb_forma_pago.Panels[3].Text := 'F11 (Pasajero) A detalle';
      stb_forma_pago.Panels[4].Text := 'F12 (Pasajero) Todos';

      stb_panelUno.Panels[0].Text := 'F4 Otra corrida';
      stb_panelUno.Panels[1].Text := 'F5 Cancelar venta';
      stb_panelUno.Panels[2].Text := 'F6 Descuento venta grupal';
      stb_panelUno.Panels[3].Text := 'F7 Descuento viaje redondo';
end;

procedure Tfrm_nueva_pagoF.FormClose(Sender: TObject; var Action: TCloseAction);
var
    li_clean : integer;
begin
    ShowCursor(True);
    gs_nombre_pax_nueva := '';
//    gi_venta_grupal_dto := 0; no esta
//    gi_vta_dto_viaje_rdo := 0;  no esta
    gi_dto_aplicado := 0;

    for li_clean := 1 to High(ga_boletos_nombres) do
         ga_boletos_nombres[li_clean] := '';
    li_creates_box := 0;
end;

procedure Tfrm_nueva_pagoF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    frm : TFrm_credencial;
    frm1 : TFrm_boleto_personalizado;
    li_ctrl_pagos, li_ctrl_interno, li_clean, li_idx_tarjeta, li_ctrl_banamex, li_control : Integer;
    li_pagos: Double;
    vTarjeta_fisica : Boolean;
    pago, textoCombo, strQuery : String;
    frm_catalogo : Tfrm_catalogo_pago;
    lq_qry : TSQLQuery;
begin
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

    if key = vk_f4 then begin
         FormActivate(Sender);
         gi_seleccion_venta := _VENTA_ELIGE_OTRA;
         asientos_regreso := asientos;
         li_memoria_cuales := 0;
         close;
    end;

    if key = VK_F5 then begin
         if gi_venta_grupal_dto = 1 then begin
           gi_venta_grupal_dto := 0;
           ShowMessage('Cancelando el descuento grupal....');
         end;
         BorraArregloAsientos(asientos);
         asientos_regreso := asientos;
         gi_idx_asientos := 1;
         gi_arreglo := 1;
         li_ctrl_asiento := 0;
         li_memoria_cuales := 0;
         FormActivate(Sender);
         gi_seleccion_venta := _VENTA_CANCELADA_NUEVA;
         Close;
    end;

    if Key = VK_F6 then begin
    //permisos de vanta de descuento por grupo
       if Boleto_Abieto = 1 then begin
         ShowMessage('No se puede aplicar el descuento grupal en boleto abierto');
         exit;
       end;
       if not AccesoPermitido(219,False) then
          exit;
        if verificaMismaCorrida(asientos) then begin //es la misma corrida
            if verificaSoloAdulto(asientos) then begin
                if minimoAdultoPermitidos(asientos) then begin
                    if gi_venta_grupal_dto = 0 then begin
                       gi_venta_grupal_dto := 1;
                       //se hace el calculo y se actualiza en arreglo
                       calculaDtoGrupal(asientos);
                       if li_creates_box = 1 then
                          detalleBoletosComprados(li_creates_box);
                       DespliegaEfectivo;
                       gi_dto_aplicado := 1;
                    end else begin
                      ShowMessage('Ya se aplico el descuento grupal a esta venta');
                    end;
                end else begin
                    ShowMessage('Para aplicar el descuento grupal, el minimo requerido es :' + IntToStr(parametroValor(41)));
                end;
            end else begin
                ShowMessage('El descuento grupal solo se aplica en ocupante de tipo "Adulto"');
            end;
        end else begin
                      ShowMessage('No es la misma corrida');
        end;
    end;

    if Key = VK_F7 then begin
        if Boleto_Abieto = 1 then begin
           ShowMessage('No se puede aplicar el descuento viaje redondo en boleto abierto');
           exit;
        end;
        if siEsViajeRedondo(asientos) then begin
            if igualIdeRegreso(asientos) then begin
                if verificaSoloAdulto(asientos) then begin
                    if gi_vta_dto_viaje_rdo = 0 then
                       gi_vta_dto_viaje_rdo := 1;
                       calculoDtoViajeRndo(asientos);
                       if li_creates_box = 1 then
                          detalleBoletosComprados(li_creates_box);
                       DespliegaEfectivo;
                       gi_dto_aplicado := 1;
                end else begin
                    ShowMessage('El descuento del viaje redondo es solo para "Adultos"');
                end;
            end else begin
                ShowMessage('El numero de boletos, no corresponden a la ida y al regreso');
            end;
        end else begin
              ShowMessage('No es un viaje redondo, para aplicar el descuento');
        end;//fin siEsViajeRedondo
    end;


    if Key = VK_F9 then begin//mostramos la forma de pago para detalle
         stg_formas_pago.Enabled := false;
         stg_pago_detalle.visible := True;
         titlesDetallePago();
         if li_creates_box = 0 then begin
            detalleBoletosComprados(li_creates_box);
            li_creates_box := 1;
         end else begin
           detalleBoletosComprados(li_creates_box);
         end;
         li_memoria_cuales := 0;
    end;

    if Key = VK_F10 then begin
{         if not (validaCamposarray(asientos, gi_idx_asientos)) then
              exit;}
         //* Salez
         if gs_tarjeta_fisica = '1' then
           vTarjeta_fisica := True
         else
           vTarjeta_fisica := False;
         ////Salez Banamex
         if existenPagosConBanamex(asientos, gi_idx_asientos) then
           if not cobrarConBanamex(asientos, gi_idx_asientos,  vTarjeta_fisica, dm.Conecta) then Begin
             showmessage('No fue posible cobrar con Banamex PinPad.' + #10#13 + #10#13 + gs_pinpad_banamex_error);
             exit;
           end;//Salez Banamex

         for li_control := 1 to gi_idx_asientos do begin

               try
                 if (length(combo[li_control].text) > 2) then begin
                       textoCombo := Trim(combo[li_control].Text);
                       strQuery :=  format(_VTA_FORMA_PAGO_DESCRIPCION, [textoCombo] );
                 end;
               except
                   on E: Exception do begin
//                       strQuery := Format(_VTA_FORMA_PAGO_ID_FORMA,['1']);
                   end;
               end;

              lq_qry := TSQLQuery.Create(nil);
              lq_qry.SQLConnection := CONEXION_VTA;
              strQuery := Format(_VTA_FORMA_PAGO_ABREVIACION, [ asientos[li_control].abrePago ]  );
              if EjecutaSQL(strQuery, lq_qry, _LOCAL) then begin
                  try
                    asientos[li_control].forma_pago := lq_qry['ID_FORMA_PAGO'];
                    asientos[li_control].abrePago := lq_qry['ABREVIACION'];
                  except
                    asientos[li_control].forma_pago := 1;
                    asientos[li_control].abrePago :=  'EFE';
                  end;
              end;
              lq_qry.Free;
           end;
         if (pagoConTarjetaCD(asientos, gi_idx_asientos) = true) then begin
         //mostramos la forma para que ingrese si es credito o debito cuando se cobra con ixe
             try
                frm_catalogo := Tfrm_catalogo_pago.Create(nil);
                frm_catalogo_pago.ShowModal;
                for li_idx_tarjeta := 0 to gi_idx_asientos do
                    if asientos[li_idx_tarjeta].forma_pago = 2 then
                       asientos[li_idx_tarjeta].tipo_tarjeta := gs_tarjeta_usuario;
             finally
                frm_catalogo.Free;
                frm := nil;
             end;
         end;
         BlockInput(true);
         ImprimeBoletos(asientos, gi_idx_asientos);
         BlockInput(False);
         if gi_venta_reservacion = 1 then
            gi_venta_reservacion := 2;

         BorraArregloLibera(asientos);
         FormActivate(Sender);
         asientos_regreso := asientos;
         gi_boletos_impresos := gi_idx_asientos;
         gi_idx_asientos := 1;
         gi_arreglo := 1;
         li_ctrl_asiento := 0;
         li_memoria_cuales := 0;
         gi_seleccion_venta := _VENTA_INICIO_NUEVA;
         Close;
    end;

    if key = VK_F11 then begin
        frm1 := TFrm_boleto_personalizado.Create(nil);
        frm1.numero := gi_idx_asientos;
        for li_clean := 1 to High(ga_boletos_nombres) do
            ga_boletos_nombres[li_clean] := '';
        MostrarForma(frm1);
        gi_impresion_personalizada := 1;
    end;
    if Key = VK_F12 then begin
           for li_clean := 1 to High(ga_boletos_nombres) do
                    ga_boletos_nombres[li_clean] := '';
           frm := TFrm_credencial.Create(nil);
           MostrarForma(frm);
           gi_impresion_personalizada := 0;
    end;
end;


procedure Tfrm_nueva_pagoF.FormShow(Sender: TObject);
var
    li_ctrl_cell: Integer;
    lr_total, lr_efectivo: Real;
begin
      ShowCursor(False);
      gi_dto_aplicado := 0;
      li_creates_box := 0;
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
      if EjecutaSQL(_VTA_FORMAS_PAGO, lq_query, _LOCAL) then begin
        li_ctrl_cell := 1;
        lq_query.First;
        while not lq_query.Eof do begin
          gds_formas_pago.Add(lq_query['ABREVIACION'], lq_query['DESCUENTO']);
          gds_tabla_forma_pago.Add(lq_query['ABREVIACION'],lq_query['DESCRIPCION']);
          stg_formas_pago.Cells[0, li_ctrl_cell] := lq_query['DESCRIPCION'];
          stg_formas_pago.Cells[1, li_ctrl_cell] := format('%0.2f', [lr_total]);
          if lq_query['ABREVIACION'] = 'EFE' then begin
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
      gs_nombre_pax_nueva := '';
//      gi_venta_grupal_dto := 0; //Para permitir el dto grupal  no esta
//      gi_vta_dto_viaje_rdo := 0;
      lbl_totalBoletos.caption := lbl_totalBoletos.caption + IntToStr(li_ctrl_asiento- 1);
      gls_cadena_combo := 'EFECTIVO';
end;





procedure Tfrm_nueva_pagoF.llenarComboDescuentos(combo: TlsComboBox);
var
    lq_forma : TSQLQuery;
begin
      lq_forma := TSQLQuery.Create(nil);
      lq_forma.SQLConnection := DM.Conecta;
      lq_forma.SQL.Clear;
      lq_forma.SQL.Add('SELECT ID_FORMA_PAGO, ABREVIACION, DESCRIPCION, DESCUENTO');
      lq_forma.SQL.Add('FROM PDV_C_FORMA_PAGO P WHERE FECHA_BAJA IS NULL ORDER BY ORDEN');
      lq_forma.Open();
      with lq_forma do begin
        First;
        while not Eof do begin
          combo.Add(lq_forma.Fields[2].AsString, lq_forma.Fields[1].AsString);
          Next;
        end; // fin
      end; // fin
      lq_forma.Free;
      lq_forma := nil;
end;

procedure Tfrm_nueva_pagoF.titlesDetallePago;
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



procedure Tfrm_nueva_pagoF.titles;
begin
      stg_formas_pago.Cells[0, 0] := 'Formas de Pago';
      stg_formas_pago.Cells[1, 0] := 'Cantidad';
      stg_formas_pago.Cells[2, 0] := 'Numero de Documento';
      stg_formas_pago.Cells[3, 0] := 'Autorizacion';
      stg_formas_pago.ColWidths[_VTA_COL_FORMA_ID] := 0;
      stg_formas_pago.ColWidths[_VTA_COL_FORMA_ID + 1] := 0;
end;


procedure Tfrm_nueva_pagoF.setAsientosVendidos(const Value: array_asientos);
begin
    asientos := Value;
end;


end.
