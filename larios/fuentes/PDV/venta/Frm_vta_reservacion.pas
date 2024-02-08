unit Frm_vta_reservacion;

interface
{$WARNINGS OFF}
{$HINTS OFF}
uses
  Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, Mask, lsCombobox, Frm_vta_main, U_venta,
  comun, DrawAsiento, frm_mensaje_corrida, ActnList, StdActns, ToolWin, ActnMan,
  System.SysUtils, Data.SqlExpr,
  ActnCtrls, ActnMenus, XPStyleActnCtrls, DateUtils, System.Actions;

type
  TFrm_reservacion = class(TForm)
    Panel1: TPanel;
    pnl_base: TPanel;
    Grp_busqueda: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    pnl_corridas: TPanel;
    Grp_corrida: TGroupBox;
    grp_reserva: TGroupBox;
    ls_servicio: TlsComboBox;
    Label7: TLabel;
    ls_Desde_vta: TlsComboBox;
    Ed_Hora: TEdit;
    Label6: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    ls_Origen_vta: TlsComboBox;
    medt_fecha: TMaskEdit;
    Label2: TLabel;
    ls_Origen_: TlsComboBox;
    Label1: TLabel;
    stg_ocupantes: TStringGrid;
    stg_detalle: TStringGrid;
    stg_corrida: TStringGrid;
    lbl_cuantos: TLabel;
    edt_cuantos: TEdit;
    Label3: TLabel;
    edt_nombre: TEdit;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action1: TAction;
    pnl_autobus: TPanel;
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
    Label8: TLabel;
    edt_corrida: TEdit;
    Splitter1: TSplitter;
    timer_pintabus: TTimer;
    procedure medt_fechaKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure ls_Desde_vtaExit(Sender: TObject);
    procedure ls_Origen_vtaExit(Sender: TObject);
    procedure stg_corridaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure stg_corridaKeyPress(Sender: TObject; var Key: Char);
    procedure edt_cuantosChange(Sender: TObject);
    procedure edt_cuantosExit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edt_nombreKeyPress(Sender: TObject; var Key: Char);
    procedure Action1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ls_Origen_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure medt_fechaExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ls_Desde_vtaKeyPress(Sender: TObject; var Key: Char);
    procedure stg_corridaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure edt_corridaChange(Sender: TObject);
    procedure timer_pintabusTimer(Sender: TObject);
    procedure edt_nombreEnter(Sender: TObject);
    procedure edt_cuantosEnter(Sender: TObject);
    procedure medt_fechaEnter(Sender: TObject);
    procedure edt_nombreChange(Sender: TObject);
    procedure stg_corridaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    function valida_Busqueda_reservacion : Boolean;
    procedure consigueCorridas;
    procedure pintaBusCorrida(li_indx : Integer);
    procedure datos();
    procedure enabledInput();
    procedure DisabledInput();
  public
    { Public declarations }
  end;

var
  Frm_reservacion: TFrm_reservacion;
  frm_venta      : TFrm_venta_principal;
  la_labels: labels_asientos;
  li_corrida_selecciona : integer;
  gs_descripcion_lugar : String;


implementation

uses DMdb, ThreadDetalleRuta, TLiberaAsientosRuta;

{$R *.dfm}
var
    lsOrigen, lsDestino, ls_hora : string;
    AsientoFree : TDibujaAsiento;
    li_ultima_corrida_procesada : Integer;
    reserva_arrelgo : array_reservaciones;
    lb_opcion: Boolean;


procedure TFrm_reservacion.Action1Execute(Sender: TObject);
begin
    Close;
end;

procedure TFrm_reservacion.consigueCorridas;
var
    li_idx, li_num : Integer;
    ls_char : Char;
  li_ctrl_asiento: string;
begin
    if not valida_Busqueda_reservacion then
        exit;
    if length(ls_Origen_vta.Text) <> 0 then
        lsOrigen := ls_Origen_vta.IDs[ls_Origen_vta.Items.IndexOf(ls_Origen_vta.Text)]
    else lsOrigen := '';
    if length(ls_Desde_vta.Text) <> 0 then begin
        lsDestino := ls_Desde_vta.IDs[ls_Desde_vta.Items.IndexOf(ls_Desde_vta.Text)];
    end else begin
          lsDestino := '';
    end;
    gs_patron_terminal := lsOrigen;
    if (length(Ed_Hora.Text) > 0) or (ls_servicio.ItemIndex >= 0) then
          corridasParametros(lsOrigen, lsDestino, medt_fecha.Text, Ed_Hora.Text, ls_servicio.CurrentID, 1, stg_corrida,edt_corrida.Text) // mostramos la corrida
    else begin
          corridasParametros(lsOrigen, lsDestino, medt_fecha.Text, '', '', 0, stg_corrida,''); // mostramos la corrida
          stg_corrida.SetFocus;
    end;
    if gi_select_corrida = 0 then begin
      Mensaje(format(_MSG_NO_HAY_CORRIDAS, [medt_fecha.Text]), 0);
      medt_fecha.SetFocus;
      exit;
    end;
    pintaBusCorrida(gi_select_corrida);
    stg_corrida.Row := gi_select_corrida;
end;


procedure TFrm_reservacion.datos;
var
    lq_terminals : TSQLQuery;
begin
    lq_terminals := TSQLQuery.Create(nil);
    lq_terminals.sqlConnection := DM.Conecta;

    if EjecutaSQL(format(_VTA_TERMINALES_ORIGEN,[gs_terminal]), lq_terminals, _LOCAL) then begin
      LlenarComboBox(lq_terminals, ls_Origen_, True);
      LlenarComboBox(lq_terminals, ls_Origen_vta, True);
    end;

    if EjecutaSQL(_VTA_TERMINALES,lq_terminals,_LOCAL) then begin
//      LlenarComboBox(lq_terminals,ls_Origen_,true);
//      LlenarComboBox(lq_terminals,ls_Origen_vta,true);
      LlenarComboBox(lq_terminals,ls_Desde_vta,true);
      llenarTerminales(lq_terminals);
      ls_Origen_.Text := gds_terminales.ValueOf(gs_terminal);
      ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(gs_terminal);
      medt_fecha.Text := FechaServer();
      if EjecutaSQL(format(_VTA_TIPO_SERVICIO,[gs_terminal]),lq_terminals,_LOCAL) then
          LlenarComboBox(lq_terminals,ls_servicio,true);
    end;
end;



{@Procedure edt_cuantosChange
@Params Sender: TObject
@Descripcion validamos la entrada solo sea numero}
procedure TFrm_reservacion.edt_corridaChange(Sender: TObject);
var
    ls_efectivo, ls_input, ls_output : string;
    lc_char, lc_new     : char;
    li_idx, li_ctrl      : integer;
begin
    ls_input := '';
    ls_efectivo := edt_corrida.text;
    for li_idx := 1 to length(ls_efectivo) do begin
         lc_char := UpCase(ls_efectivo[li_idx]);
         if  ls_efectivo[1] = '0' then begin
            edt_corrida.Clear;
            edt_corrida.SetFocus;
            exit;
         end else
              ls_input := ls_input + lc_char;
        if not (lc_char in _CARACTERES_VALIDOS_CORRIDA) then begin
            for li_ctrl := 1 to length(ls_input) -1 do begin
                lc_new := ls_input[li_ctrl];
                ls_output := ls_output + lc_new;
            end;
            edt_corrida.Text := ls_output;
            edt_corrida.SelStart := length(ls_output);
        end;
    end;
end;

procedure TFrm_reservacion.edt_cuantosChange(Sender: TObject);
var
    li_ctrl_input, li_ajusta : Integer;
    lc_char : Char;
    ls_input,ls_out, ls_anterior : String;
    lb_write : Boolean;
begin
    lb_write := False;
    li_ajusta := 0;
    ls_input := edt_cuantos.Text;
    for li_ctrl_input := 1 to length(ls_input) do begin
        lc_char := ls_input[li_ctrl_input];
          if not existe(lc_char) then begin
             lb_write := true;
             Break;
          end;//sustituir caracter , por space
          if lc_char = la_separador[1] then begin
              edt_cuantos.Text := reWrite(ls_input) + ' ';
          end;
          if li_ctrl_input > 1 then begin
              ls_anterior := ls_input[li_ctrl_input -1];
              if ((ls_input[li_ctrl_input - 1] = ' ') and (ls_input[li_ctrl_input] = '-')) or
                 ((ls_input[li_ctrl_input - 1] = '-') and (ls_input[li_ctrl_input] = ' '))then
                 li_ajusta := 1;
              if((ls_input[li_ctrl_input - 1] = ' ') and ((ls_input[li_ctrl_input] = ' '))) then
                  li_ajusta := 2;
              if((ls_input[li_ctrl_input - 1] = '-') and ((ls_input[li_ctrl_input] = '-'))) then
                  li_ajusta := 3;
          end;
    end;
    if lb_write then begin
          edt_cuantos.Text := reWrite(ls_input)
    end;
    for li_ctrl_input := 1 to length(ls_input) - 2 do begin
        ls_out := ls_out + ls_input[li_ctrl_input];
    end;
    case li_ajusta of
        1 : edt_cuantos.Text := ls_out + '-';//un espacio y un guion
        2 : edt_cuantos.Text := ls_out + ' ';//dos espacios
        3 : edt_cuantos.Text := ls_out + '-';//dos guiones
    end;
    edt_cuantos.SelStart := length(edt_cuantos.text);
end;


procedure TFrm_reservacion.edt_cuantosEnter(Sender: TObject);
var
    li_ctrl : Integer;
    lq_qry : TSQLQuery;
    ls_corrida : string;
begin
   if li_memoria_cuales = 1 then begin//regreso del cuadro de texto tipo es necesario borrarlos
      lq_qry := TSQLQuery.Create(nil);
      lq_qry.SQLConnection := CONEXION_VTA;
       for li_ctrl := 1 to gi_idx_asientos do begin
           if EjecutaSQL(Format(_BORRA_RESERVADOS_RETURN,[
                          reserva_arrelgo[li_ctrl].corrida,
                          reserva_arrelgo[li_ctrl].fecha,
                          intToStr(reserva_arrelgo[li_ctrl].asiento)
                          ]),lq_qry,_LOCAL) then
       end;
       gi_idx_asientos := 0;
       edt_cuantos.Clear;
       edt_cuantos.SetFocus;
       li_memoria_cuales := 0;
       lq_qry.Free;
       lq_qry := nil;
   end;
    try
      pintaBusCorrida(stg_corrida.Row);
    except
    end;
    if length(edt_cuantos.Text) = 0 then begin
        gi_cuales := 1;
    end;
end;


procedure TFrm_reservacion.edt_cuantosExit(Sender: TObject);
var
    la_unicos, la_rangos : gga_parameters;
    li_ctrl, li_num, li_new_ctrl, li_numero_asientos, li_idx_valida : integer;
    array_cuales : la_asientos;
    ls_str_store : string;
    lb_asientos_ok : Boolean;
begin
    li_numero_asientos := StrToInt(stg_corrida.Cols[_COL_ASIENTOS].Strings[stg_corrida.Row]);
    splitLine(edt_cuantos.Text,' ',la_unicos,li_num);//analizamos la linea previamente separada
    gi_idx_asientos := 0;
    lb_asientos_ok := False;
    for li_ctrl := 0 to li_num do begin
        if not rangoAsientos(la_unicos[li_ctrl]) then begin //si no son por rango
            array_cuales[gi_idx_asientos] := StrToInt(la_unicos[li_ctrl]);
            inc(gi_idx_asientos);
        end else begin
            splitLine(la_unicos[li_ctrl],'-',la_rangos,li_num);
            for li_new_ctrl := 0 to li_num do begin
                if StrToInt(la_rangos[li_new_ctrl]) > li_numero_asientos then begin
                   lb_asientos_ok := True;
                   break;
                end;
            end;
            if not lb_asientos_ok then begin
                for li_new_ctrl := StrToInt(la_rangos[0]) to StrToInt(la_rangos[1]) do begin
                    array_cuales[gi_idx_asientos] := li_new_ctrl;
                    inc(gi_idx_asientos);//para el procedimiento
                end;
            end;
        end;
    end;

    if lb_asientos_ok then begin
        Mensaje(_MSG_MAYOR_ASIENTO_PERMITIDO, 0);
        edt_cuantos.Clear;
        edt_cuantos.SetFocus;
        exit;
    end; // valida que el numero de asiento sea permitido por el bus

    for li_idx_valida := 0 to high(array_cuales) do begin
      if array_cuales[li_idx_valida] > li_numero_asientos then begin
        lb_asientos_ok := True;
        Break;
      end;
    end; // validamos el arreglo

    if lb_asientos_ok then begin
        Mensaje(_MSG_ASIENTO_MAYOR_PERMITIDO, 0);
        edt_cuantos.Clear;
        edt_cuantos.SetFocus;
        exit;
    end; // valida que el numero de asiento sea permitido por el bus


    for li_ctrl := 0 to gi_idx_asientos - 1 do
        ls_str_store := ls_str_store + IntToStr(array_cuales[li_ctrl]) + ',';
    ls_str_store := Copy(ls_str_store,0,length(ls_str_store) - 1);
    //CHECAR LA DISPONIBILIDAD DE LOS ASIENTOS



    if verificaDisponibles(ls_str_store,
                        FormatDateTime('YYYY-MM-DD', StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]))
                      ,stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]) then begin
          Mensaje('Los lugares se encuentran ocupados',0);
          edt_cuantos.Clear;
          edt_cuantos.SetFocus;
          exit;
    end;

    if gi_idx_asientos > 0 then begin
      asignaReservados(gs_corrida_apartada,ls_Origen_vta.CurrentID, ls_Desde_vta.CurrentID,
                      ls_Origen_.CurrentID, array_cuales,DateToStr(gd_fecha_apartada),
                      gi_idx_asientos,reserva_arrelgo,gs_trabid,StrToInt(stg_corrida.Cells[_COL_RUTA,stg_corrida.Row]),
                      StrToInt(stg_corrida.Cells[_COL_TIPOSERVICIO,stg_corrida.Row]));
      asientosOcupados(la_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                      StrToTime(Ed_Hora.Text), stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]);
    end;
end;


procedure TFrm_reservacion.edt_nombreChange(Sender: TObject);
var
  ls_efectivo, ls_input, ls_output: string;
  lc_char, lc_new: Char;
  li_idx, li_ctrl: Integer;
begin
  ls_input := '';
  ls_efectivo := edt_nombre.Text;
  for li_idx := 1 to length(ls_efectivo) do
  begin
    lc_char := ls_efectivo[li_idx];
    if ls_efectivo[1] = ' ' then
    begin
      edt_nombre.Clear;
      edt_nombre.SetFocus;
      exit;
    end
    else
      ls_input := ls_input + lc_char;
    if not(lc_char in _CARACTERES_VALIDOS) then
    begin
      for li_ctrl := 1 to length(ls_input) - 1 do
      begin
        lc_new := ls_input[li_ctrl];
        ls_output := ls_output + lc_new;
      end;
      edt_nombre.Text := ls_output;
      edt_nombre.SelStart := length(ls_output);
    end;
  end;
end;

procedure TFrm_reservacion.edt_nombreEnter(Sender: TObject);
begin
    if gi_idx_asientos = 0 then begin
        Mensaje('Es necesario ingresar los lugares a reservar',1);
        edt_cuantos.Clear;
        edt_cuantos.SetFocus;
        exit;
    end else begin
                li_memoria_cuales := 1;
    end;
end;

procedure TFrm_reservacion.edt_nombreKeyPress(Sender: TObject; var Key: Char);
var
    li_ctrl_reservado,li_ctrl : Integer;
    lc_char, ls_status : char;
    hilo_libera : Libera_Asientos;
    sentencia : string;
begin
    if Key = #13 then begin//validar longitud
        if Length(edt_nombre.Text) = 0 then begin
            Mensaje(Format('Ingrese el nombre de la reservacion',[_NOMBRE_RESERVADO]),1);
            edt_nombre.SelStart := Length(edt_nombre.Text);
            exit;
        end;

        if Length(edt_nombre.Text) > _NOMBRE_RESERVADO then begin
            Mensaje(Format(_VTA_NOMBRE_MAYOR_AL_PERMITIDO,[_NOMBRE_RESERVADO]),1);
            edt_nombre.SelStart := Length(edt_nombre.Text);
            exit;
        end;
        lc_char := edt_nombre.Text[1];
        if lc_char = ' ' then begin
          Mensaje('Ingrese un nombre para la reservacion',1);
          edt_nombre.Clear;
          edt_nombre.SetFocus;
          exit;
        end;
        If MessageDlg('Es autoliberable por el sistema', mtInformation, [mbYes, mbNo], 0) = mrYes Then  begin
          //ponemos el estatus en R
            liberaReservacion(reserva_arrelgo, UpperCase(edt_nombre.Text),gi_idx_asientos, gs_terminal);
            ls_status := 'R';
        end else begin
          //ponemos el estatus en A
            NoliberaReservacion(reserva_arrelgo,UpperCase(edt_nombre.Text),gi_idx_asientos, gs_terminal);
            ls_status := 'A';
        end;
        asientosOcupados(la_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]),
                        StrToTime(Ed_Hora.Text), stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]);
        apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row], gd_fecha_apartada, gs_hora_apartada,
                      gs_terminal, gs_trabid,StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
        for li_ctrl := 1 to gi_idx_asientos do begin
            sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR_RESERVA,[reserva_arrelgo[li_ctrl].corrida,
                                copy(reserva_arrelgo[li_ctrl].fecha,1,10)+' 00:00',
                                intToStr(reserva_arrelgo[li_ctrl].asiento),
                                edt_nombre.Text, gs_terminal,
                                gs_trabid, reserva_arrelgo[li_ctrl].origen,
                                reserva_arrelgo[li_ctrl].Destino, ls_status, Ahora() ]);
            hilo_libera := Libera_Asientos.Create(true);
            hilo_libera.server := CONEXION_VTA;
            hilo_libera.sentenciaSQL := sentencia;
            hilo_libera.ruta   := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
            hilo_libera.origen := ls_Origen_vta.CurrentID;
            hilo_libera.destino := stg_corrida.Cols[_COL_DESTINO].Strings[stg_corrida.Row];
            hilo_libera.Priority := tpNormal;
            hilo_libera.FreeOnTerminate := True;
            hilo_libera.start;
        end;
        //limpiamos los datos y regresamos
        edt_cuantos.Clear;
        edt_nombre.Clear;
        grp_reserva.Visible := False;
        Grp_corrida.Visible := true;
        Grp_busqueda.SetFocus;
        ls_Desde_vta.ItemIndex := -1;
        Ed_Hora.Clear;
        ls_servicio.Text := '';
        edt_corrida.Clear;
        enabledInput;
        stg_corrida.SetFocus;
        for li_ctrl_reservado := 1 to gi_idx_asientos do begin
            reserva_arrelgo[li_ctrl_reservado].corrida := '';
            reserva_arrelgo[li_ctrl_reservado].fecha   := '';
            reserva_arrelgo[li_ctrl_reservado].asiento := 0;
            reserva_arrelgo[li_ctrl_reservado].pasajero := '';
            reserva_arrelgo[li_ctrl_reservado].terminal := '';
            reserva_arrelgo[li_ctrl_reservado].Trab_id  := '';
            reserva_arrelgo[li_ctrl_reservado].origen   := '';
            reserva_arrelgo[li_ctrl_reservado].Destino  := '';
            reserva_arrelgo[li_ctrl_reservado].Status   := '';
        end;
        gi_idx_asientos := 0;
    end;
end;


procedure TFrm_reservacion.enabledInput;
begin
    medt_fecha.Enabled := True;
    ls_Origen_vta.Enabled := True;
    ls_Desde_vta.Enabled  := True;
    Ed_Hora.Enabled := True;
    ls_servicio.Enabled := True;
    edt_corrida.Enabled := True;
end;


procedure TFrm_reservacion.DisabledInput;
begin
    medt_fecha.Enabled := False;
    ls_Origen_vta.Enabled := False;
    ls_Desde_vta.Enabled  := False;
    ls_servicio.Enabled := False;
    Ed_Hora.Enabled := False;
    edt_corrida.Enabled := False;
end;



procedure TFrm_reservacion.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    liberaReservacion(reserva_arrelgo, UpperCase(edt_nombre.Text),gi_idx_asientos, ls_Origen_vta.CurrentID );
    try
    apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row], gd_fecha_apartada, gs_hora_apartada,
                      gs_terminal, gs_trabid,StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
    except

    end;
    CONEXION_VTA := DM.Conecta;
    try
        if CONEXION_REMOTO <> nil then begin
            CONEXION_REMOTO.Destroy;
        end;
    except
        CONEXION_REMOTO := nil;
    end;
    gb_asignado := false;
    Close;
end;




procedure TFrm_reservacion.FormCreate(Sender: TObject);
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


procedure TFrm_reservacion.FormKeyDown(Sender: TObject; var Key: Word;
                                                   Shift: TShiftState);
var
    li_ctrl : integer;
    lq_qry  : TSQLQuery;
begin
    if (Key = VK_F1) and  (li_corrida_selecciona = 0) and (ls_Desde_vta.Enabled = True) then begin
        lb_opcion := false;
        consigueCorridas();
    end;

    if (Key = vk_f3) and (ls_Desde_vta.Enabled) then begin
        enabledInput;
        ls_Desde_vta.ItemIndex := -1;
        Ed_Hora.Clear;
        ls_servicio.ItemIndex  := -1;
        ls_Desde_vta.SetFocus;
        edt_corrida.Clear;
        exit;
    end;

    if (Key = vk_f5) and (ls_Desde_vta.Enabled = False) then begin
      apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                    gd_fecha_apartada, Ed_Hora.Text,
                    gs_terminal, gs_trabid,StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]));
        if gi_idx_asientos > 0 then begin
           lq_qry := TSQLQuery.Create(nil);
           lq_qry.SQLConnection := CONEXION_VTA;
           for li_ctrl := 1 to gi_idx_asientos do begin
               if EjecutaSQL(Format(_BORRA_RESERVADOS_RETURN,[reserva_arrelgo[li_ctrl].corrida,
                              reserva_arrelgo[li_ctrl].fecha,intToStr(reserva_arrelgo[li_ctrl].asiento)
                              ]),lq_qry,_LOCAL) then begin
                    reserva_arrelgo[li_ctrl].corrida := '';
                    reserva_arrelgo[li_ctrl].fecha   := '';
                    reserva_arrelgo[li_ctrl].asiento := 0;
                    reserva_arrelgo[li_ctrl].pasajero := '';
                    reserva_arrelgo[li_ctrl].terminal := '';
                    reserva_arrelgo[li_ctrl].Trab_id  := '';
                    reserva_arrelgo[li_ctrl].origen   := '';
                    reserva_arrelgo[li_ctrl].Destino  := '';
                    reserva_arrelgo[li_ctrl].Status   := '';
               end;
           end;
           lq_qry.Free;
           lq_qry := nil;
        end;
        enabledInput;
        grp_reserva.Visible := False;
        Grp_corrida.Visible := True;
        stg_corrida.SetFocus;
        pintaBusCorrida(stg_corrida.Row);
        exit;
    end;
end;


{@Procedure FormShow
@Params Sender : TObject
@Descripcion cargamos los datos desde la invocacion del que se muestra la forma}
procedure TFrm_reservacion.FormShow(Sender: TObject);
var
    li_ctrl_reservado : Integer;
begin
    CONEXION_VTA := DM.Conecta;
    llenarArregloCaracteres();
    titulosCorridaGrid(stg_corrida);
    datos();
    gi_idx_asientos := 0;
    medt_fecha.SetFocus;
    for li_ctrl_reservado := 1 to 40 do begin
        reserva_arrelgo[li_ctrl_reservado].corrida := '';
        reserva_arrelgo[li_ctrl_reservado].fecha   := '';
        reserva_arrelgo[li_ctrl_reservado].asiento := 0;
        reserva_arrelgo[li_ctrl_reservado].pasajero := '';
        reserva_arrelgo[li_ctrl_reservado].terminal := '';
        reserva_arrelgo[li_ctrl_reservado].Trab_id  := '';
        reserva_arrelgo[li_ctrl_reservado].origen   := '';
        reserva_arrelgo[li_ctrl_reservado].Destino  := '';
        reserva_arrelgo[li_ctrl_reservado].Status   := '';
    end;
    limpiar_La_labels(la_labels); // limpiamos las etiquetas
    if gi_operacion_remota = 1 then
        ls_Origen_vta.Enabled := true
    else
        ls_Origen_vta.Enabled := False;
end;


procedure TFrm_reservacion.ls_Desde_vtaExit(Sender: TObject);
var
    li_tmp : integer;
begin
    li_tmp := ls_Desde_vta.IDs.IndexOf(UpperCase(ls_Desde_vta.Text));

    if ls_Desde_vta.ItemIndex < 0 then
        if li_tmp >= 0 then
           ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(UpperCase(ls_Desde_vta.Text))
        else ls_Desde_vta.Text := '';
end;

procedure TFrm_reservacion.ls_Desde_vtaKeyPress(Sender: TObject; var Key: Char);
var
  ls_char: Char;
begin
  if Key = #13 then
  begin
    lb_opcion := false;
    consigueCorridas();
  end;
end;


procedure TFrm_reservacion.ls_Origen_vtaExit(Sender: TObject);
var
    li_tmp : integer;
begin
    li_tmp := ls_Origen_vta.IDs.IndexOf(UpperCase(ls_Origen_vta.Text));

    if ls_Origen_vta.ItemIndex < 0 then
        if li_tmp >= 0 then
           ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(UpperCase(ls_Origen_vta.Text))
        else ls_Origen_vta.Text := '';
end;

procedure TFrm_reservacion.ls_Origen_vtaKeyPress(Sender: TObject;
  var Key: Char);
Const
    _MSG_CONEXION_REMOTA = 'No se establecio conexion al server de %s ';
var
  ls_origen_terminal, ls_Origen: string;
begin
    if Key = #13 then begin //hacemos el swicht de la conexion
        ls_origen_terminal := ls_Origen_vta.CurrentID;
        if ls_origen_terminal <> gs_terminal then begin
            CONEXION_VTA := conexionServidorRemoto(ls_origen_terminal);
            if CONEXION_VTA.Connected then begin
                gs_descripcion_lugar := getDescripcionTerminal(ls_origen_terminal);
                LimpiaSag(stg_corrida);
                LimpiaSag(stg_detalle);
                LimpiaSag(stg_ocupantes);
                Label1.Caption := 'Conexion Remota :';
                ls_Origen_.Visible := false;
                Mensaje('Conectado a :'+gs_descripcion_lugar,2);
            end else begin
                        Mensaje(Format(_MSG_CONEXION_REMOTA,[gs_descripcion_lugar]), 2);
                        ls_Origen_vta.IDs.IndexOf(gs_terminal);
                        CONEXION_VTA := DM.Conecta; // se conecta al server local
                        gs_descripcion_lugar := getDescripcionTerminal(gs_terminal);
                        LimpiaSag(stg_corrida);
                        LimpiaSag(stg_detalle);
                        LimpiaSag(stg_ocupantes);
                        Mensaje('Conectado a :'+gs_descripcion_lugar,2);
                        try
                          if CONEXION_REMOTO.Connected then
                              CONEXION_REMOTO.Destroy;
                        except
                        end;
                        exit;
            end;
        end else begin //se reconecta localmente
                    CONEXION_VTA := DM.Conecta;
                    Label1.Caption := 'Ciudad Origen :';
                    ls_Origen_.Visible := true;
                    ls_Origen_vta.IDs.IndexOf(gs_terminal);
                    gs_descripcion_lugar := getDescripcionTerminal(gs_terminal);
                    LimpiaSag(stg_corrida);
                    LimpiaSag(stg_detalle);
                    LimpiaSag(stg_ocupantes);
                    Mensaje('Conectado a :'+gs_descripcion_lugar,2);
                    try
                       if CONEXION_REMOTO.Connected then
                          CONEXION_REMOTO.Destroy;
                    except
                    end;
        end;
        Image.Visible := False;
        limpiar_La_labels(la_labels);
        if not gb_asignado then
            exit;
    end;
end;



{@Procedure medt_fechaKeyPress
@Params Sender: TObject; var Key: Char
@Descripcion valida al presionar el enter y solicita las corridas y
@ asignas_ el valor a la fila en el grid}
procedure TFrm_reservacion.medt_fechaEnter(Sender: TObject);
begin
    medt_fecha.SelStart := 0;
end;

procedure TFrm_reservacion.medt_fechaExit(Sender: TObject);
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

procedure TFrm_reservacion.medt_fechaKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then begin
            consigueCorridas;
    end;
end;

{@Procedure pintaBusCorrida
@Params li_indx: Integer
@Descripcion Pinta la corrida disponible del autobus }
procedure TFrm_reservacion.pintaBusCorrida(li_indx: Integer);
var
    la_datos : gga_parameters;
    li_num : Integer;
    ls_fecha_ocupante : string;
    hilo_grid : DetalleRuta;
begin
    if length(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]) = 0 then
    begin
      Mensaje(_MSG_DATOS_CORRIDA, 0);
      exit;
    end;
//    tarifaGridLlena(stg_corrida,ls_Origen_vta.CurrentID);
    Image.Visible := True;
//@ mostramos los ocupantes para la corrida boleto y ocupante
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos,li_num);
    if li_num = 0 then Ed_Hora.Text := la_datos[0]
    else Ed_Hora.Text := la_datos[1];

    ls_fecha_ocupante := FormatDateTime('YYYY-MM-DD',strtoDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]));
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[li_indx]);
    ls_Desde_vta.ItemIndex := ls_Desde_vta.IDs.IndexOf(stg_corrida.Cols[_COL_DESTINO].Strings[li_indx]);
    ls_servicio.ItemIndex := ls_servicio.IDs.IndexOf(stg_corrida.Cols[_COL_TIPOSERVICIO].Strings[stg_corrida.Row]);
    edt_corrida.Text := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
    medt_fecha.Text := stg_corrida.Cols[_COL_FECHA].Strings[li_indx];
    limpiar_La_labels(la_labels);//@ limpiamos las etiquetas

    obtenImagenBus(Image,stg_corrida.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
    muestraAsientosArreglo(la_labels, StrToInt(stg_corrida.Cols[_COL_AUTOBUS].Strings[li_indx]), pnl_autobus);
    asientosOcupados(la_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),
                    StrToTime(Ed_Hora.Text), stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
    showDetalleRuta(StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]), stg_detalle);
    showOcupantes(ls_Origen_vta.CurrentID,
            stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx],
            StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]), stg_ocupantes);
    hilo_grid := DetalleRuta.Create(true);
    hilo_grid.server := CONEXION_VTA;
    hilo_grid.ruta   := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[li_indx]);
    hilo_grid.Grid_DetalleRuta := stg_detalle;
    hilo_grid.origen  := ls_Origen_vta.CurrentID;
    hilo_grid.corrida := stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx];
    hilo_grid.fecha   := stg_corrida.Cols[_COL_FECHA].Strings[li_indx];
    hilo_grid.Grid_Ocupantes := stg_ocupantes;
    hilo_grid.Grid_RTodas   := grid_rutas;
    hilo_grid.Priority  := tpHigher;
    hilo_grid.FreeOnTerminate := True;
    hilo_grid.start;
    stg_corrida.Enabled := true;
//    stg_corrida.SetFocus;
end;


procedure TFrm_reservacion.stg_corridaDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
//     DrawCell(Sender,ACol,ARow,Rect,State);
end;

procedure TFrm_reservacion.stg_corridaKeyPress(Sender: TObject; var Key: Char);
var
    ls_valida_corrida, ls_quien_ocupa : string;
    frm_Ocupada : TFrm_Corrida_Ocupada;
begin
    if Key = #13 then begin
        DisabledInput;
///  actualizamos la corrida con la clave del empleado PDV_T_CORRIDA_D
        gs_corrida_apartada := stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row];
        gd_fecha_apartada   := StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]);
        gs_hora_apartada    := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
//validamos si la corrida esta disponible si no esta muestra mensaje
        ls_valida_corrida := verificaCorridaDisponible(gs_corrida_apartada,gd_fecha_apartada,gs_hora_apartada,gs_terminal_apartada);
       ls_quien_ocupa := storeApartacorrida(gs_corrida_apartada,gd_fecha_apartada, gs_terminal_apartada, gs_trabid);
//mostramos la forma con el mensaje al cerrar continua con la venta
        if Length(ls_valida_corrida) > 0 then begin
          frm_Ocupada := TFrm_Corrida_Ocupada.Create(Self);
          try
              MostrarForma(frm_Ocupada);
          finally
            frm_Ocupada.Free;
            frm_Ocupada := nil;
          end;
        end;
        pintaBusCorrida(stg_corrida.Row);
        Grp_corrida.Visible := false;
        grp_reserva.Visible := True;
        edt_cuantos.Enabled := true;
        edt_cuantos.SetFocus;
    end;
end;


{@Procedure stg_corridaKeyUp
@Params Sender: TObject;
        var Key: Word;
        Shift: TShiftState
@Descripcion validamos las teclas que se presionen y mostramos el bus pintado}
procedure TFrm_reservacion.stg_corridaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  li_ctrl: Integer;
  lb_ejecuta: Boolean;
  li_fila  : integer;
begin
  timer_pintabus.Enabled := False;
  if (ord(key_sag_venta) = Key) and (Now <= tiempo_key + _TECLAS_EN_TU_TIEMPO) then begin
       tiempo_key := Now();
       timer_pintabus.Enabled := true;
       Exit;
  end
  else begin
        tiempo_key := Now();
  end;
  tiempo_key := Now();
  key_sag_venta := chr(key);
  lb_ejecuta := false;
  for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do begin
    if Key = _TECLAS_ARRAY[li_ctrl] then begin
      lb_ejecuta := True;
    end;
  end;
  if lb_ejecuta then begin
    if li_ultima_corrida_procesada = stg_corrida.Row then
      exit;

  // validamos si tiene datos en la columna de corrida
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) > 0 then begin
        pintaBusCorrida(stg_corrida.Row);
        li_ultima_corrida_procesada := stg_corrida.Row;
  end;
  end;
end;


procedure TFrm_reservacion.stg_corridaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, fila: Integer;
begin
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
      exit;
//actualizamos la imagen
  DisabledInput;
  pintaBusCorrida(stg_corrida.Row);
  if Button = mbRight then
  begin
    stg_corrida.MouseToCell(X, Y, Col, fila);
    stg_corrida.Col := Col;
    stg_corrida.Row := fila;
  end;
end;


procedure TFrm_reservacion.timer_pintabusTimer(Sender: TObject);
begin
    timer_pintabus.Enabled := False;
    if li_ultima_corrida_procesada <> stg_corrida.Row then begin
      pintaBusCorrida(stg_corrida.Row);
      li_ultima_corrida_procesada := stg_corrida.Row;
    end;
end;

{@Procedure valida_Busqueda_reservacion
@Descripcion Valida la busqueda en la reservacion}
function TFrm_reservacion.valida_Busqueda_reservacion: Boolean;
var
    lb_ok : Boolean;
begin
    lb_ok := true;
    if Length(medt_fecha.Text) = 0 then begin
        lb_ok := false;
        medt_fecha.SetFocus;
        exit;
    end;
    if Length(ls_Origen_vta.Text) = 0 then begin
      lb_ok := false;
      ls_Origen_vta.SetFocus;
      exit;
    end;
    Result := lb_ok;
end;

end.
