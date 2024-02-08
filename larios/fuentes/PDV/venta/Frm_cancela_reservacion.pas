unit Frm_cancela_reservacion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, lsCombobox, Grids, comun, U_venta, Data.SqlExpr,
  DrawAsiento, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin,
  ActnCtrls, ActnMenus, ComCtrls, System.Actions;

type
  TFrm_reserva_cancela = class(TForm)
    pnl_corrida_bus: TPanel;
    Splitter2: TSplitter;
    pnl_main_corrida: TPanel;
    grp_vta_reservados: TGroupBox;
    Label3: TLabel;
    edt_lugares: TEdit;
    grp_corridas_reservados: TGroupBox;
    stg_corrida: TStringGrid;
    stg_reservados: TStringGrid;
    Timer1: TTimer;
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
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    StatusBar1: TStatusBar;
    procedure FormShow(Sender: TObject);
    procedure stg_reservadosKeyPress(Sender: TObject; var Key: Char);
    procedure stg_reservadosKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure stg_corridaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure stg_corridaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure Titles;
    procedure verPasajeReservado(li_corrida : String; ls_fecha, ls_hora : string);
    procedure pintaBusCorrida(li_indx : Integer);
  public
    { Public declarations }
  end;

var
  Frm_reserva_cancela: TFrm_reserva_cancela;

implementation

uses DMdb, TLiberaAsientosRuta;

{$R *.dfm}
var
    lq_query                    : TSQLQuery;
    li_ultima_corrida_procesada : Integer;
    AsientoFree                 : TDibujaAsiento;
    li_pasajero                 : Integer;
    ls_fecha                    : string;
    la_labels                   : labels_asientos;


procedure TFrm_reserva_cancela.verPasajeReservado(li_corrida: String; ls_fecha,ls_hora: string);
var
    li_idx : Integer;
    ls_nombre, ls_asientos : string;
begin
    if EjecutaSQL(format(_VTA_RESERVA_ASIENTOS_PASAJERO,[li_corrida,
                           FormatDateTime('YYYY-MM-DD',StrToDateTime(ls_fecha)),ls_hora]),lq_query,_LOCAL) then begin
        with lq_query do begin
            First;
            li_idx := 1;
            while not EoF do begin
                  if ls_nombre <> lq_query['NOMBRE_PASAJERO'] then begin
                      if VarIsNull(lq_query['NOMBRE_PASAJERO']) then begin
                           ls_nombre := '';
                      end else ls_nombre := lq_query['NOMBRE_PASAJERO'];
                      stg_reservados.Cells[0,li_idx] := ls_nombre;
                      stg_reservados.Cells[2,li_idx] := lq_query['ID_CORRIDA'];
                      stg_reservados.Cells[3,li_idx] := FormatDateTime('YYYY-MM-DD',lq_query['FECHA_HORA_CORRIDA']);
                      stg_reservados.Cells[4,li_idx] := FormatDateTime('HH:nn:SS',lq_query['FECHA_HORA_CORRIDA']);
                      if lq_query['STATUS'] = 'R' then
                          stg_reservados.Cells[5,li_idx] := 'Reservado';
                      ls_asientos := '';
                      inc(li_idx);
                  end;
                  ls_asientos := ls_asientos + ' ' + IntToStr(lq_query['No_ASIENTO']);
                  stg_reservados.Cells[1,li_idx - 1] := ls_asientos;
                next;
            end;//fin while
            stg_reservados.RowCount := li_idx;
        end;//fin with
    end;//fin ejecutaSQL
end;



procedure TFrm_reserva_cancela.Action1Execute(Sender: TObject);
begin
    Close;
end;

procedure TFrm_reserva_cancela.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
{    if AsientoFree <> nil then
        AsientoFree.destroy; }
    Close;
end;

procedure TFrm_reserva_cancela.FormCreate(Sender: TObject);
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

procedure TFrm_reserva_cancela.FormShow(Sender: TObject);
var
    li_idx,li_num : Integer;
    la_datos : gga_parameters;
    ls_fecha : String;
begin
//  tarifaGridLlena(stg_corrida,ls_Origen_vta.CurrentID);
    limpiar_La_labels(la_labels); // limpiamos las etiquetas
    lq_query := TSQLQuery.Create(self);
    lq_query.SQLConnection := DM.Conecta;
    titulosCorridaGrid(stg_corrida);
    Titles;
    if EjecutaSQL('SELECT (CURRENT_DATE)AS FECHA',lq_query,_LOCAL) then
        ls_fecha := lq_query['FECHA'];

    cargarGridReservadoCorridaNew(ls_fecha,stg_corrida,li_idx);
    if li_idx = 2 then begin
        Mensaje('No existen reservaciones para cancelar',0);
        Timer1.Enabled := true;
        Close;
    end;
    //mostramos todas las corridas con reservacion y no esten despachadas MOSTRAMOS EL PRIMER RENGLON
    if ((li_idx > 1) and  (length(stg_corrida.Cols[0].Strings[1]) > 1)) then begin
        splitLine(stg_corrida.Cols[_COL_HORA].Strings[1],' ',la_datos,li_num);
        if li_num = 0 then// 0
            verPasajeReservado(stg_corrida.Cols[_COL_CORRIDA].Strings[1],
                                        stg_corrida.Cols[_COL_FECHA].Strings[1],
                                        la_datos[0])

        else  verPasajeReservado(stg_corrida.Cols[_COL_CORRIDA].Strings[1],
                                          stg_corrida.Cols[_COL_FECHA].Strings[1],
                                          la_datos[1]);
        pintaBusCorrida(gi_select_corrida);
        stg_corrida.SetFocus;
    end;//fin li_idx
end;



procedure TFrm_reserva_cancela.pintaBusCorrida(li_indx: Integer);
var
    la_datos : gga_parameters;
    li_num : Integer;
    ls_hora : String;
begin
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx], ' ', la_datos,
      li_num);
    if li_num = 0 then
      ls_hora := la_datos[0]
    else
      ls_hora := la_datos[1];

    obtenImagenBus(Image,stg_corrida.Cols[_COL_NAME_IMAGE].Strings[li_indx]);
    muestraAsientosArreglo(la_labels, StrToInt(stg_corrida.Cols[_COL_AUTOBUS].Strings[li_indx]), pnlBUS);
    asientosOcupados(la_labels,StrToDate(stg_corrida.Cols[_COL_FECHA].Strings[li_indx]),
                    StrToTime(ls_hora), stg_corrida.Cols[_COL_CORRIDA].Strings[li_indx]);
    splitLine(stg_corrida.Cols[_COL_HORA].Strings[li_indx],' ',la_datos,li_num);
    if li_num = 0 then begin
       ls_fecha :=  stg_corrida.Cols[_COL_FECHA].Strings[li_indx] + ' ' + la_datos[0];
    end else begin
          ls_fecha :=  stg_corrida.Cols[_COL_FECHA].Strings[li_indx] + ' ' + la_datos[1];
    end;
end;



procedure TFrm_reserva_cancela.stg_corridaKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  li_ctrl, li_num: Integer;
  la_datos : gga_parameters;
  lb_ejecuta: Boolean;
begin
  lb_ejecuta := false;
  for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do begin
    if Key = _TECLAS_ARRAY[li_ctrl] then begin
      lb_ejecuta := True;
    end;
  end;
  if lb_ejecuta then begin
    if li_ultima_corrida_procesada = stg_corrida.Row then
      exit;
    li_ultima_corrida_procesada := stg_corrida.Row;
    { si el utlimo teclñaso fue hace n tiemp thons exit
      if algo + n_tiempo < now then
      exit; }
    // validamos si tiene datos en la columna de corrida
    if length(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row]) > 0 then begin
        splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row],' ',la_datos,li_num);
        if li_num = 0 then// 0
            verPasajeReservado(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                        stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row],
                                        la_datos[0])

        else  verPasajeReservado(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                          stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row],
                                          la_datos[1]);
          pintaBusCorrida(stg_corrida.Row);
    end;
  end;
end;

procedure TFrm_reserva_cancela.stg_corridaMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  Col, fila, li_num: Integer;
  la_datos : gga_parameters;
begin
  if length(stg_corrida.Cols[_COL_CORRIDA].Strings[1]) = 0 then
      exit;
//actualizamos la imagen
  splitLine(stg_corrida.Cols[_COL_HORA].Strings[stg_corrida.Row],' ',la_datos,li_num);
  if li_num = 0 then// 0
    verPasajeReservado(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row],
                                la_datos[0])

  else  verPasajeReservado(stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                  stg_corrida.Cols[_COL_FECHA].Strings[stg_corrida.Row],
                                  la_datos[1]);

  pintaBusCorrida(stg_corrida.Row);
  if Button = mbRight then
  begin
    stg_corrida.MouseToCell(X, Y, Col, fila);
    stg_corrida.Col := Col;
    stg_corrida.Row := fila;
  end;
end;

procedure TFrm_reserva_cancela.stg_reservadosKeyPress(Sender: TObject;
  var Key: Char);
var
    la_asientos : gga_parameters;
    li_num, li_ctrl : integer;
    ls_asientos : string;
    sentencia   : String;
    hilo_libera : Libera_Asientos;
begin
    if Key = #13 then begin
//        if Length(stg_reservados.Cols[0].Strings[stg_reservados.Row]) > 1 then

        If MessageDlg('Se cancelaran las reservacion de :'+#10#13 +
                      stg_reservados.Cols[0].Strings[stg_reservados.Row], mtWarning, [mbYes, mbNo], 0) = mrYes then begin
            splitLine(Trim(stg_reservados.Cols[1].Strings[stg_reservados.Row]),' ',la_asientos,li_num);
            if li_num > 0 then begin
                for li_ctrl := 0 to li_num do begin
//                    if li_ctrl > 0 then
                        ls_asientos := ls_asientos + la_asientos[li_ctrl] + ',';
                end;
                ls_asientos := Copy(ls_asientos,1,length(ls_asientos) - 1);
            end else
                ls_asientos := la_asientos[0];
            //borramos los asientos reservados
            sentencia := format(_VTA_BORRA_RESERVADOS,[stg_corrida.Cols[_COL_CORRIDA].Strings[stg_corrida.Row],
                                                        FormatDateTime('YYYY-MM-DD',StrToDateTime(ls_fecha)) + ' 00:00',
                                                        stg_reservados.Cols[0].Strings[stg_reservados.Row],
                                                        ls_asientos]);
            if EjecutaSQL(sentencia,lq_query,_LOCAL) then
            begin
                hilo_libera := Libera_Asientos.Create(true);
                hilo_libera.server := dm.Conecta;
                hilo_libera.sentenciaSQL := sentencia;
                hilo_libera.ruta   := StrToInt(stg_corrida.Cols[_COL_RUTA].Strings[stg_corrida.Row]);
                hilo_libera.origen := gs_terminal;
                hilo_libera.destino := stg_corrida.Cols[_COL_DESTINO].Strings[stg_corrida.Row];
                hilo_libera.Priority := tpNormal;
                hilo_libera.FreeOnTerminate := True;
                hilo_libera.start;
                FormShow(Sender);
            end;

        end;//fin dialog
    end;
end;


procedure TFrm_reserva_cancela.stg_reservadosKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
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
        if li_ultima_corrida_procesada = stg_corrida.Row then
            exit;
        li_ultima_corrida_procesada := stg_corrida.Row;

        {si el utlimo teclñaso fue hace n tiemp thons exit
        if algo + n_tiempo < now then
          exit;}
        pintaBusCorrida(stg_corrida.Row);
    end;
end;

procedure TFrm_reserva_cancela.Timer1Timer(Sender: TObject);
begin
    Close;
end;

procedure TFrm_reserva_cancela.Titles;
begin
    stg_corrida.Cells[_COL_HORA,0] := 'HORA';
    stg_corrida.Cells[_COL_DESTINO,0] := 'DESTINO';
    stg_corrida.Cells[_COL_SERVICIO,0] := 'SERVICIO ';
    stg_corrida.Cells[_COL_FECHA,0] := 'FECHA';
    stg_corrida.Cells[_COL_TRAMO,0] := '';
    stg_corrida.ColWidths[_COL_TARIFA] := 0;
    stg_corrida.ColWidths[_COL_TRAMO] := 0;
    stg_corrida.ColWidths[_COL_RUTA] := 0;
    stg_corrida.ColWidths[_COL_CORRIDA] := 0;
    stg_corrida.ColWidths[_COL_AUTOBUS] := 0;
    stg_corrida.ColWidths[_COL_ASIENTOS] := 0;
    stg_corrida.ColWidths[_COL_NAME_IMAGE] := 0;
    stg_corrida.ColWidths[_COL_TIPOSERVICIO] := 0;

    stg_reservados.Cells[0,0] := 'Reservado a';
    stg_reservados.Cells[1,0] := 'Asientos';
    stg_reservados.Cells[2,0] := 'Corrida';
    stg_reservados.Cells[5,0] := 'Status';
    stg_reservados.ColWidths[3] := 0;
    stg_reservados.ColWidths[4] := 0;
end;


end.
