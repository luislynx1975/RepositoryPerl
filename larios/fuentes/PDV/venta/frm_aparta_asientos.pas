unit frm_aparta_asientos;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, StdCtrls, Grids, Data.SqlExpr, lsCombobox, System.Actions;

type
  Tfrm_aparta_lugares = class(TForm)
    GroupBox1: TGroupBox;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    stg_corrida: TStringGrid;
    GroupBox2: TGroupBox;
    lbledt_cuales: TEdit;
    Label1: TLabel;
    lsComboBox1: TlsComboBox;
    procedure Action1Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbledt_cualesChange(Sender: TObject);
    procedure lbledt_cualesKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    TraficoGrid : TStringGrid;
    li_row_corrida  : integer;
  end;

var
  frm_aparta_lugares: Tfrm_aparta_lugares;

implementation

uses DMdb, frm_anticipada_venta, U_venta, comun, TLiberaAsientosRuta;

{$R *.dfm}

procedure Tfrm_aparta_lugares.Action1Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_aparta_lugares.lbledt_cualesChange(Sender: TObject);
var
    li_ctrl_input, li_ajusta : Integer;
    lc_char : Char;
    ls_input,ls_out, ls_anterior : String;
    lb_write : Boolean;
begin
    lb_write := False;
    li_ajusta := 0;
    ls_input := lbledt_cuales.Text;
    for li_ctrl_input := 1 to length(ls_input) do begin
        lc_char := ls_input[li_ctrl_input];
          if not existe(lc_char) then begin
             lb_write := true;
             Break;
          end;//sustituir caracter , por space
          if lc_char = la_separador[1] then begin
              lbledt_cuales.Text := reWrite(ls_input) + ' ';
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
          lbledt_cuales.Text := reWrite(ls_input)
    end;
    for li_ctrl_input := 1 to length(ls_input) - 2 do begin
        ls_out := ls_out + ls_input[li_ctrl_input];
    end;
    case li_ajusta of
        1 : lbledt_cuales.Text := ls_out + '-';//un espacio y un guion
        2 : lbledt_cuales.Text := ls_out + ' ';//dos espacios
        3 : lbledt_cuales.Text := ls_out + '-';//dos guiones
    end;
    lbledt_cuales.SelStart := length(lbledt_cuales.text);
end;

procedure Tfrm_aparta_lugares.lbledt_cualesKeyPress(Sender: TObject;
  var Key: Char);
var
    la_unicos, la_rangos : gga_parameters;
    li_ctrl, li_num, li_new_ctrl : integer;
    array_cuales : la_asientos;
    ls_str_store, ls_status, sentencia : string;
    reserva_arrelgo : array_reservaciones;
    lq_qry : TSQLQuery;
    hilo_libera : Libera_Asientos;
begin
    if Key = #13 then begin
        splitLine(lbledt_cuales.Text,' ',la_unicos,li_num);//analizamos la linea previamente separada
        for li_ctrl := 0 to li_num do begin
            if la_unicos[li_ctrl] = '0' then begin
                Mensaje('No puede guardar el Numero de Asiento : 0, corrijalo',1);
                lbledt_cuales.Clear;
                lbledt_cuales.SetFocus;
                exit;
            end;
        end;

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
//validamos que no sea mayor a los que tengo en el bus
        for li_ctrl := 0 to 50 do begin
            if array_cuales[li_ctrl] > StrToInt(stg_corrida.Cells[_COL_ASIENTOS,stg_corrida.Row]) then begin
                Mensaje('El numero del asiento es mayor al permitido',1);
                lbledt_cuales.Clear;
                lbledt_cuales.SetFocus;
                exit;
            end;
        end;

        for li_ctrl := 0 to gi_idx_asientos - 1 do
            ls_str_store := ls_str_store + IntToStr(array_cuales[li_ctrl]) + ',';
        ls_str_store := Copy(ls_str_store,0,length(ls_str_store) - 1);
        //CHECAR LA DISPONIBILIDAD DE LOS ASIENTOS
        //li_opcion_fecha_string := 1;
        if verificaDisponibles(ls_str_store,stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]
                  ,stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]) then begin
              Mensaje('Los lugares se encuentran ocupados',0);
              lbledt_cuales.Clear;
              lbledt_cuales.SetFocus;
              exit;
        end;
        if gi_idx_asientos > 0 then begin
          gs_hora_apartada := split_Hora(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row]);
          asignaReservados(stg_corrida.Cols[_COL_CORRIDA].Strings[1],gs_terminal,
                          stg_corrida.Cols[_COL_DESTINO].Strings[1],
                          gs_terminal, array_cuales, stg_corrida.Cols[_COL_FECHA].Strings[1],
                          gi_idx_asientos,reserva_arrelgo,gs_trabid,0,0);
        end;
        if MessageDlg('Desea guardar la reservacion?', mtInformation, [mbYes, mbNo], 0) = mrYes Then  begin
            NoliberaReservacion(reserva_arrelgo,UpperCase('Quedado'),gi_idx_asientos, gs_terminal);
            ls_status := 'A';
//Enviamos el hilo para la ruta
            sentencia := Format(_A_INSERTA_ASIENTO_RECEPTOR_RESERVA,[reserva_arrelgo[li_ctrl].corrida,
                                copy(reserva_arrelgo[li_ctrl].fecha,1,10)+' 00:00',
                                intToStr(reserva_arrelgo[li_ctrl].asiento),
                                'QUEDADO',
                                gs_terminal,
                                gs_trabid,
                                reserva_arrelgo[li_ctrl].origen,
                                reserva_arrelgo[li_ctrl].Destino,
                                ls_status,
                                Ahora()
                                ]);
            insertaEvento(gs_trabid,gs_terminal,'Asientos apartados ' +
                          stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]+' '+
                          stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row]+' '+
                          lbledt_cuales.Text);

            hilo_libera := Libera_Asientos.Create(true);
            hilo_libera.server := dm.Conecta;
            hilo_libera.sentenciaSQL := sentencia;
            hilo_libera.ruta   := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
            hilo_libera.origen := gs_terminal;
            hilo_libera.destino := stg_corrida.Cols[_COL_DESTINO].Strings[stg_corrida.Row];
            hilo_libera.Priority := tpNormal;
            hilo_libera.FreeOnTerminate := True;
            hilo_libera.start;
            Close;
        end else begin
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
                     lbledt_cuales.Clear;
                     lbledt_cuales.SetFocus;
                     lq_qry.Free;
                     lq_qry := nil;
                     Close;
        end;
    end;
end;

procedure Tfrm_aparta_lugares.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    apartaCorrida(stg_corrida.Cols[_COL_CORRIDA].Strings[1],
                StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[1]),
                stg_corrida.Cols[_COL_HORA].Strings[1],
                gs_terminal, gs_trabid, StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[1]));
end;

procedure Tfrm_aparta_lugares.FormShow(Sender: TObject);
var
    li_row : integer;
begin
    li_row := 1;
    titulosCorridaGrid(stg_corrida);
    stg_corrida.Cells[_COL_HORA,li_row] := TraficoGrid.Cols[_COL_HORA].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_DESTINO,li_row] := TraficoGrid.Cols[_COL_DESTINO].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_SERVICIO,li_row] := TraficoGrid.Cols[_COL_SERVICIO].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_FECHA,li_row] := TraficoGrid.Cols[_COL_FECHA].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_TRAMO,li_row] := TraficoGrid.Cols[_COL_TRAMO].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_RUTA,li_row] := TraficoGrid.Cols[_COL_RUTA].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_CORRIDA,li_row] := TraficoGrid.Cols[_COL_CORRIDA].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_AUTOBUS,li_row] := TraficoGrid.Cols[_COL_AUTOBUS].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_NAME_IMAGE,li_row] := TraficoGrid.Cols[_COL_NAME_IMAGE].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_ASIENTOS,li_row] := TraficoGrid.Cols[_COL_ASIENTOS].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_TIPOSERVICIO,li_row] := TraficoGrid.Cols[_COL_TIPOSERVICIO].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_CUPO,li_row] := TraficoGrid.Cols[_COL_CUPO].Strings[li_row_corrida];
    stg_corrida.Cells[_COL_PIE,li_row] := TraficoGrid.Cols[_COL_PIE].Strings[li_row_corrida];
    //gs_corrida_apartada,gd_fecha_apartada, gs_terminal_apartada, gs_trabid);
    lbledt_cuales.SetFocus;
    llenarArregloCaracteres;
end;

end.
