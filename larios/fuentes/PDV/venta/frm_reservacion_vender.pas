unit frm_reservacion_vender;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, lsCombobox, U_venta, comun, DMdb, Grids,
  DrawAsiento, Frm_vta_pagos, u_main, ComCtrls, ActnList,DateUtils, Data.SqlExpr,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ActnMenus, Mask,
  System.Actions;

type
  Tfrm_reservados_vta = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Splitter1: TSplitter;
    pnl_corrida_bus: TPanel;
    pnl_main_corrida: TPanel;
    grp_corridas_reservados: TGroupBox;
    stg_corrida: TStringGrid;
    Splitter2: TSplitter;
    pnlBUS: TPanel;
    Image: TImage;
    grp_vta_reservados: TGroupBox;
    edt_lugares: TEdit;
    Label3: TLabel;
    StatusBar1: TStatusBar;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    Label139: TLabel;
    Label140: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Label145: TLabel;
    Label146: TLabel;
    Label147: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    Label150: TLabel;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    stg_names: TStringGrid;
    medt_fecha: TMaskEdit;
    edt_reservados: TEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stg_corridaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure stg_corridaKeyPress(Sender: TObject; var Key: Char);
    procedure edt_lugaresChange(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure medt_fechaKeyPress(Sender: TObject; var Key: Char);
    procedure medt_fechaExit(Sender: TObject);
    procedure stg_namesKeyPress(Sender: TObject; var Key: Char);
    procedure stg_corridaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edt_lugaresKeyPress(Sender: TObject; var Key: Char);
    procedure medt_fechaEnter(Sender: TObject);
  private
    { Private declarations }
    procedure Titles;
    procedure pintaBusCorrida(li_indx : Integer);
    procedure asignarseVenta;
  public
    { Public declarations }
  end;

var
  frm_reservados_vta: Tfrm_reservados_vta;

implementation

uses frm_mensaje_corrida, u_fondo_inicial_nuevo;

{$R *.dfm}

var
    lq_query : TSQLQuery;
    fecha    : String;
    nombre   : String;
    li_ultima_corrida_procesada : Integer;
    array_reservados : a_reservados;
    lb_write : Boolean;
    li_fila : integer;
    asientos_reservados : array_asientos;
    asientos_pago       : array_asientos;
    la_labels : labels_asientos;
    ls_origen : string;


procedure Tfrm_reservados_vta.Action1Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_reservados_vta.asignarseVenta;
var
    ls_ahora, ls_ip, ls_taquilla, ls_status, ls_ip_qry, ls_qry_fondo : string;
    lf_forma: Tfrm_fondo_nuevo;
begin
    ls_qry_fondo    := 'UPDATE PDV_T_CORTE SET FONDO_INICIAL = %s '+
                      ' WHERE ID_CORTE = %d AND ID_EMPLEADO = ''%s'' ';
    asignaVenta(gs_trabid, gs_terminal, StrToInt(gs_maquina));
    if gi_out_valida_asignarse = _E_ASIGNA_VTA_DUPLICADO then begin
        mensaje('El usuario se encuentra asignado en otra taquilla',1);
        gb_asignado := False;
        exit;
    end;
    if gi_out_valida_asignarse = _E_ASIGNA_PROCESO_CORTE then begin
        mensaje('El usuario se encuentra en proceso de corte',1);
        gb_asignado := False;
        exit;
    end;
    if gi_fondo_inicial_store = -1 then begin // solicitamos el fondo inicial
        lf_forma := Tfrm_fondo_nuevo.Create(nil);
        MostrarForma(lf_forma);
        if VarIsNull(gi_fondo_inicial_store)  then
            if EjecutaSQL(format(ls_qry_fondo, ['0', gi_corte_store, gs_trabid]), lq_query, _LOCAL) then ;
    end;

    if gi_fondo_inicial_store = -1 then begin // solicitamos el fondo inicial
      if EjecutaSQL(format(ls_qry_fondo, ['0', gi_corte_store,
          gs_trabid]), lq_query, _LOCAL) then ;
    end;
end;

procedure Tfrm_reservados_vta.edt_lugaresChange(Sender: TObject);
var
    li_ctrl_input, li_ajusta : Integer;
    lc_char : Char;
    ls_input,ls_out, ls_anterior : String;
begin
    lb_write := False;
    li_ajusta := 0;
    ls_input := edt_lugares.Text;
    for li_ctrl_input := 1 to length(ls_input) do begin
        lc_char := ls_input[li_ctrl_input];
          if not existe(lc_char) then begin
             lb_write := true;
             Break;
          end;//sustituir caracter , por space
          if lc_char = la_separador[1] then begin
              edt_lugares.Text := reWrite(ls_input) + ' ';
          end;
          if li_ctrl_input > 1 then begin
              ls_anterior := ls_input[li_ctrl_input -1];
              if ((ls_input[li_ctrl_input - 1] = ' ') and (ls_input[li_ctrl_input] = '-')) or
                 ((ls_input[li_ctrl_input - 1] = '-') and (ls_input[li_ctrl_input] = ' '))then
                 li_ajusta := 1;
              if ((ls_input[li_ctrl_input - 1] = '-') and (ls_input[li_ctrl_input] = '-')) then
                 li_ajusta := 2;
              if ((ls_input[li_ctrl_input - 1] = ' ') and (ls_input[li_ctrl_input] = ' ')) then
                 li_ajusta := 3;
          end;
    end;
    if lb_write then begin
          edt_lugares.Text := reWrite(ls_input)
    end;
    if li_ajusta = 1 then begin
        for li_ctrl_input := 1 to length(ls_input) - 2 do begin
            ls_out := ls_out + ls_input[li_ctrl_input];
        end;
        edt_lugares.Text := ls_out + '-';
    end;

    if li_ajusta = 2 then begin
        for li_ctrl_input := 1 to length(ls_input) - 2 do begin
            ls_out := ls_out + ls_input[li_ctrl_input];
        end;
        edt_lugares.Text := ls_out + '-';
    end;
    if li_ajusta = 3 then begin
        for li_ctrl_input := 1 to length(ls_input) - 2 do begin
            ls_out := ls_out + ls_input[li_ctrl_input];
        end;
        edt_lugares.Text := ls_out + ' ';
    end;

    edt_lugares.SelStart := length(edt_lugares.text);
end;


procedure Tfrm_reservados_vta.edt_lugaresKeyPress(Sender: TObject;
  var Key: Char);
var
    array_cuales : la_asientos;
    la_unicos, la_rangos : gga_parameters;
    li_num , li_ctrl, li_new_ctrl : Integer;
    lq_query : TSQLQuery;
    no_estan_reservados : la_asientos;
    la_datos : gga_parameters;
    ls_fechaInput, ls_quien_ocupa : string;
    lb_ok_asiento : Boolean;
    frm : Tfrm_forma_pago;
begin
    if ((Key = #13) and (length(edt_lugares.Text) > 0 )) then begin//analizamos la linea de datos de entrada
        lq_query := TSQLQuery.Create(nil);
        lq_query.SQLConnection := DM.Conecta;

        splitLine(edt_lugares.Text,' ',la_unicos,li_num);//analizamos la linea previamente separada
        gi_idx_asientos := 0;
        for li_ctrl := 0 to li_num do begin
            if not rangoAsientos(la_unicos[li_ctrl]) then begin //si no son por rango
                array_cuales[gi_idx_asientos] := StrToInt(la_unicos[li_ctrl]);
                inc(gi_idx_asientos);
            end else begin
                splitLine(la_unicos[li_ctrl],'-',la_rangos,li_num);
                for li_new_ctrl := StrToInt(la_rangos[0]) to StrToInt(la_rangos[1]) do begin
                    array_cuales[gi_idx_asientos] := li_new_ctrl;
                    inc(gi_idx_asientos);//para el procedimiento
                end;
            end;
        end;
        lb_ok_asiento := true;
        splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_fila],' ',la_datos,li_num);
        ls_fechaInput :=  Copy(stg_corrida.Cols[_COL_FECHA].Strings[li_fila],7,4) + '-' +
                                           Copy(stg_corrida.Cols[_COL_FECHA].Strings[li_fila],4,2) + '-' +
                                           Copy(stg_corrida.Cols[_COL_FECHA].Strings[li_fila],1,2) + ' ';
        if li_num = 0 then// 0
           ls_fechaInput :=  ls_fechaInput+  la_datos[0]
        else ls_fechaInput :=  ls_fechaInput+  la_datos[1];

        //recorremos el arreglo para checar si tenemos unos fuera de los reservados para la venta
        for li_ctrl := 0 to gi_idx_asientos - 1 do begin//CORRIDA,FECHA - HORA,ASIENTO
            if EjecutaSQL(Format(_VTA_BUSCA_ASIENTO_RESERVA,[stg_corrida.Cols[_COL_CORRIDA].Strings[li_fila],
                                 ls_fechaInput, array_cuales[li_ctrl],
                                 stg_names.Cols[0].Strings[stg_names.Row]
                                 ]), lq_query,_LOCAL) then begin
                if(lq_query['TOTAL'] > 0 ) then begin //ahora verificamos si esta disponible
                     if EjecutaSQL(Format(_VTA_BUSCA_DISPONIBLE_RESERVA,[ls_fechaInput,
                                                                         stg_corrida.Cols[_COL_CORRIDA].Strings[li_fila],
                                                                         array_cuales[li_ctrl]]),lq_query,_LOCAL) then begin
                        if lq_query['TOTAL'] > 0 then begin
                          Mensaje('El lugar se encuentra ocupado :' + IntToStr(array_cuales[li_ctrl]) ,1);
                          edt_lugares.Clear;
                          edt_lugares.SetFocus;
                          lb_ok_asiento := False;
                          exit;
                        end;//fin total
                    end;//fin verifica      _VTA_BUSCA_RESERVADO_APARTADO
                    if EjecutaSQL(Format(_VTA_BUSCA_RESERVADO_APARTADO,[ls_fechaInput,
                                                                       stg_corrida.Cols[_COL_CORRIDA].Strings[li_fila],
                                                                       array_cuales[li_ctrl]]),lq_query,_LOCAL) then begin
                       if lq_query['TOTAL'] > 0 then begin
                          Mensaje('El asiento :'+IntToStr(array_cuales[li_ctrl]) +' tiene status de Apartado,'
                                  +#10#13+ ' no se puede efecutar la venta',1);
                          edt_lugares.Clear;
                          edt_lugares.Text := edt_reservados.Text;
                          lb_ok_asiento := False;
                          exit;
                       end;
                   end;
                end else begin
                          Mensaje('Los lugares elegidos no son los reservados',1);
                          lb_ok_asiento := true;
                          exit;
                end;
            end;//fin ejecuta
        end;//fin for
        //creamos el record de asientos para la inserccion
        if lb_ok_asiento then begin
            if EjecutaSQL(Format(_VTA_BUSCA_ORIDES_RESERVADA,[stg_corrida.Cols[_COL_CORRIDA].Strings[li_fila],
                                                              ls_fechaInput]),
            lq_query,_LOCAL) then
            li_opcion_fecha_string := 0;

            li_ctrl_asiento := 1;
            gi_arreglo := 1;
            gs_nombre_pax := '';
            gs_nombre_pax := quiapo(stg_names.Cols[0].Strings[stg_names.Row]);
            procesoVentaCuales(array_cuales, gi_idx_asientos, stg_corrida.Cols[_COL_CORRIDA].Strings[li_fila],
                               ls_fechaInput, lq_query['ORIGEN'], lq_query['DESTINO'],
                               gs_trabid, stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[stg_corrida.Row],
                               StrToFloat(stg_corrida.Cols[_COL_TARIFA].Strings[stg_corrida.Row]),
                               //tarifaCorrida(stg_corrida, gs_terminal),
                               asientos_reservados, StrToInt(gs_maquina),
                               StrToFloat(stg_corrida.Cols[_COL_IVA].Strings[stg_corrida.Row]));
            for li_ctrl := 1 to gi_idx_asientos  do
                asientos_reservados[li_ctrl].ruta := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
            li_actualiza_ruta := 1;
//si el vaor del li_existe_reservacion es 1 entonces guardalo en arreglo para eliminarno con opcion
            frm := Tfrm_forma_pago.Create(self);
            frm.vendidos := asientos_reservados;
            gs_hora_apartada := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
            MostrarForma(frm);
//aparta
            if li_impresion_boleto = 1 then begin
                actualizaStatusAsiento(asientos_reservados,gi_idx_asientos,stg_names.Cols[0].Strings[stg_names.Row]);
                li_impresion_boleto := 0;
                FormShow(Sender);
            end;
            apartaCorrida(gi_corrida_reserva, StrToDate(gi_fecha_reserva),
                          split_Hora(gi_hora_reserva), gs_terminal, gs_trabid,
                          gi_ruta_reserva);
            asientos_reservados := asientos_regreso;
        end;//fin lb_ok_asiento
    end;//fin de Key = VK_RETURN
end;


procedure Tfrm_reservados_vta.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    gs_nombre_pax := '';
    gs_trabid     := '';
    Close;
end;


procedure Tfrm_reservados_vta.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
    array_cuales : la_asientos;
    la_unicos, la_rangos : gga_parameters;
    li_num , li_ctrl, li_new_ctrl : Integer;
    lq_query : TSQLQuery;
    no_estan_reservados : la_asientos;
    la_datos : gga_parameters;
    ls_fechaInput : string;
    lb_ok_asiento : Boolean;
    frm : Tfrm_forma_pago;
begin
      if (Key = VK_F5)then begin
          edt_reservados.Clear;
          edt_lugares.Clear;
          grp_vta_reservados.Visible := false;
          grp_corridas_reservados.Visible := true;
          limpiaStringGrid(stg_corrida);
          limpiaStringGrid(stg_names);
          limpiar_La_labels(la_labels);
          Titles;
          stg_corrida.Visible := false;
          Image.Visible := False;
          medt_fecha.SetFocus;
          try
          apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row], StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                        split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]), gs_terminal, gs_trabid,
                        StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
          except
          end;
      end;
end;


procedure Tfrm_reservados_vta.FormShow(Sender: TObject);
begin
    medt_fecha.Text := FechaServer();
    grp_vta_reservados.Visible := False;
    grp_corridas_reservados.Visible := true;
    llenarArregloCaracteres();
    Titles;
    limpiar_La_labels(la_labels);
    gb_asignado := false;
    medt_fecha.SelStart := 0;
    medt_fecha.SetFocus;
    keybd_event(VK_LEFT,1,0,0);
    li_impresion_boleto := 0;

    edt_lugares.Clear;
    grp_vta_reservados.Visible := false;
    grp_corridas_reservados.Visible := true;
    limpiaStringGrid(stg_corrida);
    limpiaStringGrid(stg_names);
    limpiar_La_labels(la_labels);
    Titles;
    stg_corrida.Visible := false;
    Image.Visible := False;
    CONEXION_VTA :=  DM.Conecta;
    medt_fecha.SelStart := 0;
end;


procedure Tfrm_reservados_vta.medt_fechaEnter(Sender: TObject);
begin
    medt_fecha.SelStart := 0;
end;

procedure Tfrm_reservados_vta.medt_fechaExit(Sender: TObject);
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


procedure Tfrm_reservados_vta.medt_fechaKeyPress(Sender: TObject;
  var Key: Char);
var
    ld_fecha : TDate;
    ga_datos : gga_parameters;
    li_num   : integer;

begin
    if Key = #13 then begin//cargamos los nombres de las reservaciones
      try
         ld_fecha := StrToDate(medt_fecha.Text);
      except
          on E:Exception do begin
              Mensaje('Ingrese una fecha valida',0);
              medt_fecha.Text := FechaServer();
              medt_fecha.SelStart := 0;
              medt_fecha.SetFocus;
              exit;
          end;
      end;

      splitLine(medt_fecha.Text, '/', ga_datos, li_num);
      li_num :=  StrToInt(Concat(ga_datos[2], ga_datos[1], ga_datos[0]) );

      if ( li_num < getFechaSistema()) then begin
          Mensaje('La fecha debe ser mayor o igual a la actual, verifiquelo!',2);
          medt_fecha.Text := FechaServer();
          medt_fecha.SelStart := 0;
          medt_fecha.SetFocus;
          exit;
      end;

      if asientoReservado(medt_fecha.Text,stg_names) = 1 then begin
          medt_fecha.Text := FechaServer();
          medt_fecha.SelStart := 0;
          medt_fecha.SetFocus;
          exit;
      end;
      stg_names.SetFocus;
    end;
end;

procedure Tfrm_reservados_vta.pintaBusCorrida(li_indx: Integer);
var
    la_datos : gga_parameters;
    li_num : Integer;
    ls_hora : String;
begin
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos,li_num);

    if li_num = 0 then
      ls_hora := la_datos[0]
    else
      ls_hora := la_datos[1];
//    tarifaGridLlena(stg_corrida,stg_names.Cols[1].Strings[stg_names.Row]);
    obtenImagenBus(Image,stg_corrida.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
    muestraAsientosArreglo(la_labels, StrToInt(stg_corrida.Cols[_COL_AUTOBUS].Strings[li_indx]), pnlBUS);
    asientosOcupados(la_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),
                    StrToTime(ls_hora), stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
    stg_corrida.SetFocus;
end;



procedure Tfrm_reservados_vta.stg_corridaKeyPress(Sender: TObject;
                var Key: Char);
var
    lstr_fecha, ls_quien_ocupa : string;
    frm_ocupada : TFrm_Corrida_Ocupada;
    li_idx : integer;
    lq_query : TSQLQuery;
begin
    if Key = #13 then begin
        if not gb_asignado then begin
            if not AccesoPermitido(192,False) then
                exit
            else begin
                gb_asignado := true;
                asignarseVenta();
            end;
        end;

        if not gb_asignado then
            exit;
        ls_quien_ocupa := storeApartacorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                            StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                                            gs_terminal, gs_trabid);

        gi_ruta_reserva := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
        gi_corrida_reserva := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
        gi_fecha_reserva := stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row];
        gi_hora_reserva := stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row];

        if ls_quien_ocupa <> gs_trabid then begin
          frm_Ocupada := TFrm_Corrida_Ocupada.Create(Self);
          frm_Ocupada.corrida := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
          frm_Ocupada.fecha := stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row];
          frm_Ocupada.hora := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
          MostrarForma(frm_Ocupada);
          pintaBusCorrida(stg_corrida.Row);
//          TRefrescaCorrida.Enabled := True;
          if gi_corrida_en_uso > 0 then begin // salimos
            stg_corrida.Row := stg_corrida.Row;
            stg_corrida.Enabled := True;
            stg_corrida.SetFocus;
            gi_corrida_en_uso := 0;
            pintaBusCorrida(stg_corrida.Row);
            exit;
          end;
        end;

        lstr_fecha :=  FormatDateTime('YYYY-MM-DD', StrToDate(medt_fecha.Text))+' '+split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
        if StrToFloat(stg_corrida.Cols[_COL_TARIFA].Strings[stg_corrida.Row]) = 0 then
        begin
              Mensaje(format(_MENSAJE_TARIFA_CERO, [stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                            stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row],
                            stg_corrida.Cols[_COL_SERVICIO].Strings[stg_corrida.Row]]), 0);
              FormShow(Sender);
              exit;
        end;//fin if
      lq_query := TSQLQuery.Create(nil);
      lq_query.SQLConnection := DM.Conecta;
      ls_asientos_reservados := '';
       if EjecutaSQL(Format(_VTA_BUSCA_ASIENTOS_CORRIDA,[stg_names.Cols[0].Strings[stg_names.Row],
                                                        formatDateTime('YYYY-MM-DD',StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row])),
                                                        stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]

                                                        ]),lq_query,_LOCAL) then begin
            with lq_query do begin
                First;
                while not Eof do begin
                    ls_asientos_reservados := ls_asientos_reservados + IntToStr(lq_query['NO_ASIENTO']) + ' ';
                    inc(li_idx);
                    Next;
                end;//fin
            end;//fin with
        end;///
        lq_query.Free;
        lq_query := nil;
        edt_reservados.Text := ls_asientos_reservados;
        edt_lugares.Text    := ls_asientos_reservados;
        grp_corridas_reservados.Visible := False;
        grp_vta_reservados.Visible := True;
        edt_lugares.SetFocus;
        li_fila := stg_corrida.Row;
    end;
end;



procedure Tfrm_reservados_vta.stg_corridaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    li_ctrl : Integer;
    lb_ejecuta : Boolean;
begin
    lb_ejecuta := false;

    for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do begin
        if Key = _TECLAS_ARRAY[li_ctrl] then
            lb_ejecuta := true;
    end;
    if lb_ejecuta then begin
        li_ultima_corrida_procesada := stg_corrida.Row;
        pintaBusCorrida(stg_corrida.Row);
        li_fila := stg_corrida.Row;
    end;
end;



procedure Tfrm_reservados_vta.stg_corridaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, fila: Integer;
begin
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
      exit;
  pintaBusCorrida(stg_corrida.Row);
  if Button = mbRight then
  begin
    stg_corrida.MouseToCell(X, Y, Col, fila);
    stg_corrida.Col := Col;
    stg_corrida.Row := fila;
  end;
end;

procedure Tfrm_reservados_vta.stg_namesKeyPress(Sender: TObject; var Key: Char);
var
    li_ipunt : integer;
begin
      li_ipunt :=  asientoReservado(stg_names.Cols[0].Strings[stg_names.Row], medt_fecha.Text,stg_corrida);
      if li_ipunt > 1 then begin
          stg_corrida.Visible := true;
          stg_corrida.SetFocus;
          pintaBusCorrida(gi_select_corrida);
      end else begin
          Mensaje('No existe una reservacion',1);
          medt_fecha.Text := FechaServer();
          medt_fecha.SetFocus;
          exit;
      end;
end;


procedure Tfrm_reservados_vta.Titles;
begin
    stg_names.Cells[0,0] := 'Nombre';
    stg_names.Cells[1,0] := 'Origen';
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
end;



procedure Tfrm_reservados_vta.FormCreate(Sender: TObject);
begin
    lq_query := TSQLQuery.Create(Self);
    lq_query.SQLConnection := DM.Conecta;
    la_labels[1] := Addr(label100);
    la_labels[2] := Addr(label101);
    la_labels[3] := Addr(label102);
    la_labels[4] := Addr(label103);
    la_labels[5] := Addr(label104);
    la_labels[6] := Addr(label105);
    la_labels[7] := Addr(label106);
    la_labels[8] := Addr(label107);
    la_labels[9] := Addr(label108);
    la_labels[10] := Addr(label109);
    la_labels[11] := Addr(label110);
    la_labels[12] := Addr(label111);
    la_labels[13] := Addr(label112);
    la_labels[14] := Addr(label113);
    la_labels[15] := Addr(label114);
    la_labels[16] := Addr(label115);
    la_labels[17] := Addr(label116);
    la_labels[18] := Addr(label117);
    la_labels[19] := Addr(label118);
    la_labels[20] := Addr(label119);
    la_labels[21] := Addr(label120);
    la_labels[22] := Addr(label121);
    la_labels[23] := Addr(label122);
    la_labels[24] := Addr(label123);
    la_labels[25] := Addr(label124);
    la_labels[26] := Addr(label125);
    la_labels[27] := Addr(label126);
    la_labels[28] := Addr(label127);
    la_labels[29] := Addr(label128);
    la_labels[30] := Addr(label129);
    la_labels[31] := Addr(label130);
    la_labels[32] := Addr(label131);
    la_labels[33] := Addr(label132);
    la_labels[34] := Addr(label133);
    la_labels[35] := Addr(label134);
    la_labels[36] := Addr(label135);
    la_labels[37] := Addr(label136);
    la_labels[38] := Addr(label137);
    la_labels[39] := Addr(label138);
    la_labels[40] := Addr(label139);
    la_labels[41] := Addr(label140);
    la_labels[42] := Addr(label141);
    la_labels[43] := Addr(label142);
    la_labels[44] := Addr(label143);
    la_labels[45] := Addr(label144);
    la_labels[46] := Addr(label145);
    la_labels[47] := Addr(label146);
    la_labels[48] := Addr(label147);
    la_labels[49] := Addr(label148);
    la_labels[50] := Addr(label149);
    la_labels[51] := Addr(label150);
end;



end.
