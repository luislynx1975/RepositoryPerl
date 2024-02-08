unit frm_venta_anticipada;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, ExtCtrls, StdCtrls, lsCombobox, FMTBcd, System.Actions, Vcl.Grids,
  Vcl.ComCtrls, Data.SqlExpr,  lsNumericEdit;

type
  Tfrm_vta_anticipada = class(TForm)
    Panel1: TPanel;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    GroupBox1: TGroupBox;
    ls_origen: TlsComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ls_Origen_vta: TlsComboBox;
    StatusBar1: TStatusBar;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label4: TLabel;
    ls_servicio: TlsComboBox;
    Label7: TLabel;
    lbl_servicio: TLabel;
    StatusBar2: TStatusBar;
    lbl_fecha: TLabel;
    lbl_server: TLabel;
    edt_tarifa: TEdit;
    ls_destino_vta: TlsComboBox;
    grb_grid: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    stg_visor: TStringGrid;
    edt_cuantos: TEdit;
    edt_tipo: TEdit;
    mem_mensaje: TMemo;
    procedure FormShow(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure ls_origen_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ls_destino_vtaClick(Sender: TObject);
    procedure ls_servicioClick(Sender: TObject);
    procedure edt_cuantosKeyPress(Sender: TObject; var Key: Char);
    procedure edt_cuantosChange(Sender: TObject);
    procedure edt_tipoKeyPress(Sender: TObject; var Key: Char);
    procedure edt_tipoChange(Sender: TObject);
    procedure ls_servicioEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ls_destino_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure ls_servicioExit(Sender: TObject);
    procedure edt_tipoEnter(Sender: TObject);
  private
    { Private declarations }
    function validaEntrada():boolean;
    procedure tituloGrid();
  public
    { Public declarations }
  end;

var
  frm_vta_anticipada: Tfrm_vta_anticipada;

implementation

uses DMdb, comun, U_venta, Frm_vta_pagos, frm_pago_nueva, u_comun_venta;

{$R *.dfm}
var
    li_venta_anticipada : integer;
    lq_qry : TSQLQuery;
    li_ruta : integer;
    gi_maximo_pasajeros : integer;
    gi_maximo_menor_permitidos : integer;
    gi_ruta  : integer;
    gi_total_menores : integer;
    asientos_pago: array_asientos;
    gi_descuentos : integer;


procedure Tfrm_vta_anticipada.Action1Execute(Sender: TObject);
begin
    Close;
end;


procedure Tfrm_vta_anticipada.edt_cuantosChange(Sender: TObject);
var
    li_ctrl, li_lon, li_maximo : integer;
    ls_input : String;
    lc_char : Char;
begin
    ls_input := edt_cuantos.Text;
    if Length(edt_cuantos.Text) > 0 then begin
      if ls_input[1] = '0' then begin
          edt_cuantos.clear;
          exit;
      end;
      li_maximo := StrToInt(ls_input);
      if li_maximo > gi_maximo_pasajeros then begin
          ShowMessage('Debe de ingresar un numero permitido de pasajeros');
          edt_cuantos.Clear;
          exit;
      end;

    end;
end;


procedure Tfrm_vta_anticipada.edt_tipoChange(Sender: TObject);
var
  ls_input, ls_totalTipos : String;
  li_ctrl, li_menores, li_totalPasajeros : integer;
begin
    ls_input := edt_tipo.Text;
    if ((length(edt_cuantos.Text) = 0 ) and (length(edt_cuantos.Text) > 0))then begin
      ShowMessage('Para ingresar el numero de menores ingrese el total de pasajeros');
      edt_tipo.Text := '0';
      edt_cuantos.SetFocus;
      exit;
    end;

    if length(ls_input) > 0 then begin
      if ls_input[1] = '0' then
          edt_tipo.Clear;

      for li_ctrl := 1 to length(ls_input) do begin
         if (ls_input[li_ctrl] in ['0'..'9']) then
            ls_totalTipos := ls_totalTipos + ls_input[li_ctrl];
      end;


      if Length(edt_cuantos.Text) > 0 then begin
          li_totalPasajeros := StrToInt(edt_cuantos.Text);
      end else begin
          li_totalPasajeros := 0;
      end;
      gi_descuentos := 0;
      try
        li_menores := StrToInt(ls_totalTipos);
      except
         ShowMessage('Ingrese el numero total de descuentos');
         li_menores := 0;
         edt_tipo.Clear;
      end;
      gi_descuentos := li_menores;
      if li_totalPasajeros = 0 then begin
          ShowMessage('Ingrese el total de pasajeros para realizar la compra');
          edt_cuantos.SetFocus;
          exit;
      end;
      if gi_maximo_menor_permitidos < li_menores then begin
          ShowMessage('El numero de menores es mayor, al permitido por corrida, Menor :'+ IntToStr(gi_maximo_menor_permitidos));
          gi_descuentos := 0;
          edt_tipo.Clear;
          edt_tipo.SetFocus;
      end;
    end;
end;


procedure Tfrm_vta_anticipada.edt_tipoEnter(Sender: TObject);
begin
    mem_mensaje.Lines.Add('Ingrese el numero de pasajeros con descuento, solo aplica en menores');
end;

procedure Tfrm_vta_anticipada.edt_cuantosKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not(Key in ['0'..'9',#8, #13]) then begin
    Key:=#0;
  end;
  if key = #13 then
    edt_tipo.SetFocus;
end;



procedure Tfrm_vta_anticipada.edt_tipoKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0'..'9',#8, #13,'m','M']) then begin
    Key:=#0;
  end;
end;

procedure Tfrm_vta_anticipada.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    li_ctrl_asiento := 1;
    li_vta_anticipada_pago := 1;
end;

procedure Tfrm_vta_anticipada.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    li_total_pasajeros : integer;
    li_ctrl, li_descuento : integer;
    frm : Tfrm_nueva_pagoF;
    ls_codigo, ls_corrida : String;

begin
    if length(ls_destino_vta.Text) = 0 then begin
      ls_destino_vta.SetFocus;
      exit;
    end;
    if Key = VK_RETURN then begin
        if ls_destino_vta.ItemIndex = -1 then begin
          ls_destino_vta.SetFocus;
          exit;
        end;
        if ls_servicio.ItemIndex = -1 then begin
          ls_servicio.SetFocus;
          exit;
        end;
        try
            li_total_pasajeros := StrToInt(edt_cuantos.Text);
        except
            ShowMessage('Es necesario ingresar el total de pasajeros a comprar!');
            edt_cuantos.SetFocus;
            edt_cuantos.Text := '0';
            exit;
        end;
        if Application.MessageBox(PChar('Desea comprar los boletos?'),
                    'Atención', MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1) = IDYES then begin
//            gb_boleto_abierto := true;
            li_total_pasajeros := StrToInt(edt_cuantos.Text);
            li_ctrl_asiento := li_total_pasajeros + 1;
            gi_idx_asientos := li_total_pasajeros;
//            ls_corrida := getCodeBoletoAbierto();//// regresamos una caden ade 8 caracteres como codigo de la corrida
//            ls_codigo := getCodeBoletoAbierto();
            for li_ctrl := 1 to li_total_pasajeros  do begin
                asientos_pago[li_ctrl].corrida := ls_corrida;
                asientos_pago[li_ctrl].fecha_hora := FormatDateTime('YYYY-MM-DD', Now);
                asientos_pago[li_ctrl].asiento    := 0;
                asientos_pago[li_ctrl].empleado   := gs_trabid;
                asientos_pago[li_ctrl].origen     := ls_Origen_vta.CurrentID;
                asientos_pago[li_ctrl].destino    := ls_destino_vta.CurrentID;
                asientos_pago[li_ctrl].status     := 'V';
                if li_ctrl <= gi_descuentos  then begin
                  asientos_pago[li_ctrl].precio     :=  StrToFloat(formatFloat('##0.00', StrToFloat(edt_tarifa.Text) / 2));
                  asientos_pago[li_ctrl].idOcupante  := 5;
                  asientos_pago[li_ctrl].Ocupante   := 'M';
                  asientos_pago[li_ctrl].tipo_tarifa := 'M';
                  asientos_pago[li_ctrl].descuento  := 50;
                end else begin
                  asientos_pago[li_ctrl].idOcupante  := 1;
                  asientos_pago[li_ctrl].precio := StrToFloat(formatFloat('##0.00', StrToFloat( edt_tarifa.Text)));
                  asientos_pago[li_ctrl].Ocupante   := 'A';
                  asientos_pago[li_ctrl].tipo_tarifa := 'A';
                  asientos_pago[li_ctrl].descuento  := 0;
                end;
                asientos_pago[li_ctrl].precio_original := StrToFloat(edt_tarifa.Text);
                asientos_pago[li_ctrl].servicio   := StrToInt(ls_servicio.CurrentID);
                asientos_pago[li_ctrl].forma_pago := 1;

                asientos_pago[li_ctrl].taquilla    := gi_taquilla_store;
                asientos_pago[li_ctrl].nombre      := gs_terminal + '-' + ls_codigo;
                asientos_pago[li_ctrl].abrePago    := 'EFE';
                asientos_pago[li_ctrl].ruta        := gi_ruta;
                asientos_pago[li_ctrl].pago_efectivo := 1;
            end;
            frm := Tfrm_nueva_pagoF.Create(nil);
            frm.vendidos := asientos_pago;
            frm.abierto  := 1;
            MostrarForma(frm);
            Close;
        end;
    end;
end;

procedure Tfrm_vta_anticipada.FormShow(Sender: TObject);
begin
    li_ctrl_asiento := 1;
    li_vta_anticipada_pago := 1;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_VTA_TERMINALES,lq_qry,_LOCAL) then begin
        LlenarComboBox(lq_qry,ls_origen,True);
        LlenarComboBox(lq_qry,ls_origen_vta,True);
        llenarTerminales(lq_qry);
        if EjecutaSQL(FORMAT(_VTA_BOLETO_A_DESTINO,[gs_terminal] ),lq_qry,_LOCAL) then
            LlenarComboBox(lq_qry,ls_destino_vta,True);

    if EjecutaSQL(_VTA_TIPO_SERVICIO, lq_qry, _LOCAL) then
      LlenarComboBox(lq_qry, ls_servicio,True);
        ls_Origen.ItemIndex := ls_Origen_vta.IDs.IndexOf(gs_terminal);
        ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(gs_terminal);
        ls_destino_vta.ItemIndex := -1;
        ls_destino_vta.SetFocus;
        li_venta_anticipada := 0;
        lbl_server.Caption :=  copy(Ahora(),1,10);
    end;
{    if EjecutaSQL(_VTA_MAXIMO_PASAJERO, lq_qry, _LOCAL) then
      gi_maximo_pasajeros := lq_qry['valor']
    else
      gi_maximo_pasajeros := 20;}


    tituloGrid;
end;


procedure Tfrm_vta_anticipada.ls_destino_vtaClick(Sender: TObject);
var
    ls_origen, ls_destino : string;
    lq_qry : TSQLQuery;
begin
    ls_origen := gs_terminal;
    ls_destino := ls_destino_vta.CurrentID;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_VTA_BOLETO_A_SERIVICO, [ls_origen, ls_destino]),lq_qry, _LOCAL) then begin
        ls_servicio.Clear;
        with lq_qry do begin
            First;
            while not EoF do begin
                ls_servicio.Add(lq_qry.Fields[0].AsString+'-'+lq_qry.Fields[1].AsString+'_'+lq_qry.Fields[2].AsString,lq_qry.Fields[0].AsString);
                Next;
            end;
        end;
    end;
    lq_qry.Free;
    lq_qry := nil;
end;


procedure Tfrm_vta_anticipada.ls_destino_vtaKeyPress(Sender: TObject;
  var Key: Char);
var
    ls_origen, ls_destino : string;
    lq_qry : TSQLQuery;
begin
  if Key = #13 then begin
    ls_origen := gs_terminal;
    ls_destino := ls_destino_vta.CurrentID;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_VTA_BOLETO_A_SERIVICO, [ls_origen, ls_destino]),lq_qry, _LOCAL) then begin
        LlenarComboBox(lq_qry, ls_servicio, True);
    end;
    lq_qry.Free;
    lq_qry := nil;
  end;
end;


procedure Tfrm_vta_anticipada.ls_origen_vtaKeyPress(Sender: TObject;
  var Key: Char);
var
  ls_char: Char;
  ls_origen_terminal : string;
begin
  if Key = #13 then begin//verificamos la terminal si es identica a la del archivo ini
    ls_origen_terminal := ls_Origen_vta.CurrentID;
    if ls_origen_terminal <> gs_terminal then begin
        if not conexionAServidor(ls_origen_terminal) then begin
            ls_Origen_vta.ItemIndex := ls_Origen_vta  .IDs.IndexOf(UpperCase(gs_terminal));
        end;
    end else begin
        CONEXION_VTA := DM.Conecta;//switch la conexion
    end;
  end;
end;


procedure Tfrm_vta_anticipada.ls_servicioClick(Sender: TObject);
var
    lq_qry : TSQLQuery;
    ls_origen, ls_destino, lss_servicio, ls_corrida, ls_fecha : String;
    ga_datos  : gga_parameters;
    li_num : integer;
begin//MOSTRAMOS LA TARIFA ACTUAL
    ls_origen := gs_terminal;
    ls_destino := ls_destino_vta.CurrentID;
    lss_servicio := ls_servicio.CurrentID;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    gi_maximo_menor_permitidos := 0;
    if EjecutaSQL(format(_VTA_TARIFA, [ls_origen, ls_destino, lss_servicio]),lq_qry,_LOCAL) then begin
        edt_tarifa.Text := FormatFloat('#########.00',lq_qry['MONTO']);
{        if EjecutaSQL(format(_VTA_OCUPANTE_CORRIDA,[ls_origen, ls_destino, lss_servicio]), lq_qry, _LOCAL) then begin
            grb_grid.Visible := True;
            ls_corrida := lq_qry['ID_CORRIDA'];
            ls_fecha   := FormatDateTime('YYYY-MM-DD',lq_qry['FECHA']);

            if EjecutaSQL(FORMAT(_VTA_MENOR_CORRIDA_A,[ls_corrida, ls_fecha]),lq_qry, _local) then
                gi_maximo_menor_permitidos := lq_qry['MAXIMO'];
        end;}
    end;
    splitLine(ls_servicio.Text,'_',ga_datos,li_num);
    try
        gi_ruta := StrToInt(ga_datos[1]);
    except
    end;
    lq_qry.Free;
end;


procedure Tfrm_vta_anticipada.ls_servicioEnter(Sender: TObject);
begin
    if grb_grid.Visible = true then begin
        edt_cuantos.Clear;
        edt_tipo.Clear;
        grb_grid.Visible := False;
    end;
end;


procedure Tfrm_vta_anticipada.ls_servicioExit(Sender: TObject);
begin
    if (grb_grid.Visible = true) or (length(edt_cuantos.Text) > 0) then
        edt_cuantos.SetFocus;
end;


procedure Tfrm_vta_anticipada.tituloGrid;
begin
    stg_visor.Cells[0,0] := 'Abreviacion';
    stg_visor.Cells[1,0] := 'Descripcion';
    stg_visor.Cells[0,1] := 'A';
    stg_visor.Cells[1,1] := 'Adulto';
    stg_visor.Cells[0,2] := 'M';
    stg_visor.Cells[1,2] := 'Menor';
end;


function Tfrm_vta_anticipada.validaEntrada: boolean;
var
    lb_out : Boolean;
begin
    lb_out := False;
    if (Length(ls_Origen_vta.CurrentID) = 0) and (lb_out = False) then begin
        Mensaje('Seleccione el origen',1);
        ls_Origen_vta.Text := '';
        ls_Origen_vta.ItemIndex := -1;
        ls_Origen_vta.SetFocus;
        lb_out := True;
    end;
    if (Length(ls_destino_vta.CurrentID) = 0) and (lb_out = False) then begin
        Mensaje('Seleccione el destino',1);
        ls_destino_vta.ItemIndex := -1;
        ls_destino_vta.Text := '';
        ls_destino_vta.SetFocus;
        lb_out := True;
    end;
    if (Length(ls_servicio.CurrentID) = 0) and (lb_out = False) then begin
        Mensaje('Seleccione el servico',1);
        ls_servicio.ItemIndex := -1;
        ls_servicio.Text := '';
        ls_servicio.SetFocus;
        lb_out := True;
    end;
    Result := lb_out;
end;


end.
