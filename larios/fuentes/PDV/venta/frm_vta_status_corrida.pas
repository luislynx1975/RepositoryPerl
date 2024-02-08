unit frm_vta_status_corrida;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, Grids, StdCtrls, ExtCtrls, ComCtrls, System.Actions, Data.SqlExpr;

type
  Tfrm_status_corrida = class(TForm)
    ActionManager1: TActionManager;
    acSalir: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    grp_corridas: TGroupBox;
    Timer: TTimer;
    StatusBar1: TStatusBar;
    stg_despacho: TStringGrid;
    acCerrar: TAction;
    acAbrir: TAction;
    acPredespachar: TAction;
    procedure acSalirExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerTimer(Sender: TObject);
    procedure stg_despachoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acAbrirExecute(Sender: TObject);
    procedure acPredespacharExecute(Sender: TObject);
    procedure stg_despachoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acCerrarExecute(Sender: TObject);
  private
    { Private declarations }
     procedure Titles();
     procedure abrirOpcion(li_opcion : Integer);
  public
    { Public declarations }
  end;

var
  frm_status_corrida: Tfrm_status_corrida;
  lq_qry : TSQLQuery;
  ls_fecha : String;

implementation

uses DMdb, comun, U_venta;

{$R *.dfm}


procedure Tfrm_status_corrida.acAbrirExecute(Sender: TObject);
var
    la_datos : gga_parameters;
    li_num   : integer;
    hora     : string;
begin
    if not AccesoPermitido(183,False) then
        Exit;

    if Application.MessageBox(PChar(format(_MSG_ABRIR_CORRIDA,
          [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR)
      = IDYES then begin
      splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row], ' ', la_datos,li_num);
      if li_num = 0 then
          hora := la_datos[0]
      else
          hora := la_datos[1];
      if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,
          ['A',stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
              ls_fecha,
              hora,
              stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
          Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
          stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Abierta';
          stg_despacho.SetFocus;
          acCerrar.Enabled := True;
          acPredespachar.Enabled := True;
          acAbrir.Enabled := False;
    end;
end;

procedure Tfrm_status_corrida.acCerrarExecute(Sender: TObject);
var
    li_total : integer;
    la_datos : gga_parameters;
    li_num   : integer;
    hora     : string;
begin
    if not AccesoPermitido(184,False) then
        exit;

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
              ls_fecha,
              hora,
              stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
          Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
          stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Cerrada';
          stg_despacho.SetFocus;
          acCerrar.Enabled := False;
          acPredespachar.Enabled := True;
          acAbrir.Enabled := True;
    end;
end;

procedure Tfrm_status_corrida.acPredespacharExecute(Sender: TObject);
var
    la_datos : gga_parameters;
    li_num   : integer;
    hora     : string;
begin
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
      if EjecutaSQL(Format(_STATUS_CORRIDA_VENTA,
          ['P',stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
              ls_fecha,
              hora,
              stg_despacho.Cols[_COL_RUTA].Strings[stg_despacho.Row]]),lq_qry,_LOCAL) then
          Mensaje(_MSG_CORRIDA_MENSAJE_ESTATUS,2);
          stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] := 'Predespachada';
          stg_despacho.SetFocus;
          acCerrar.Enabled := True;
          acPredespachar.Enabled := False;
          acAbrir.Enabled := True;
    end;
end;

procedure Tfrm_status_corrida.acSalirExecute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_status_corrida.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Timer.Enabled := False;
    lq_qry.Destroy;
end;

procedure Tfrm_status_corrida.FormShow(Sender: TObject);
begin
    li_tarjeta_viaje := 0;
    grp_corridas.Caption := 'Corridas '+ FechaServer;
    Titles();
    muestraEstatus(gs_terminal,stg_despacho);
    Timer.Enabled := True;
    if stg_despacho.RowCount = 2 then
        keybd_event(VK_ESCAPE,1,0,0);

    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONEXION_VTA;
    if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Abierta' then
        abrirOpcion(1);
    if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Cerrada' then
        abrirOpcion(2);
    if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada' then
        abrirOpcion(3);
end;


procedure Tfrm_status_corrida.abrirOpcion(li_opcion: Integer);
begin
    case li_opcion of
        1 : begin//si es abierta
                acAbrir.Enabled := False;
                acCerrar.Enabled := True;
                acPredespachar.Enabled := True;
            end;
        2 : begin //si es cerrada
                acCerrar.Enabled := False;
                acAbrir.Enabled := True;
                acPredespachar.Enabled := True;
            end;
        3 : begin //si es predespachada
            acPredespachar.Enabled := False;
            acAbrir.Enabled := True;
            acCerrar.Enabled := True;
            end;
        4 : begin //si es predespachada
            acPredespachar.Enabled := False;
            acAbrir.Enabled := True;
            acCerrar.Enabled := False;
            end;
    end;
end;

procedure Tfrm_status_corrida.stg_despachoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    li_ctrl : Integer;
    lb_ejecuta : Boolean;
    ls_estatus : string;
    lq_qry : TSQLQuery;
begin
    lb_ejecuta := false;
    ls_estatus := stg_despacho.Cells[_COL_STATUS,stg_despacho.Row];
    for li_ctrl := low(_TECLAS_ARRAY) to high(_TECLAS_ARRAY) do begin
        if Key = _TECLAS_ARRAY[li_ctrl] then begin
            lb_ejecuta := true;
        end;
    end;
    if lb_ejecuta then begin
        ls_fecha := formatDateTime('YYYY-MM-DD',
                    StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]));
        if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Abierta' then
            abrirOpcion(1);
        if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Cerrada' then
            abrirOpcion(2);
        if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada' then
            abrirOpcion(3);
        if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada' then
            abrirOpcion(4);
    end;
end;

procedure Tfrm_status_corrida.stg_despachoMouseDown(Sender: TObject;
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
    ls_fecha := formatDateTime('YYYY-MM-DD',
                StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]));
    if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Abierta' then
        abrirOpcion(1);
    if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Cerrada' then
        abrirOpcion(2);
    if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Predespachada' then
        abrirOpcion(3);
    if stg_despacho.Cols[_COL_STATUS].Strings[stg_despacho.Row] = 'Despachada' then
        abrirOpcion(4);
end;

procedure Tfrm_status_corrida.TimerTimer(Sender: TObject);
begin
    muestraEstatus(gs_terminal,stg_despacho);
end;

procedure Tfrm_status_corrida.Titles;
begin
    stg_despacho.Cells[_COL_HORA, 0] := 'HORA';
    stg_despacho.Cells[_COL_DESTINO, 0] := 'DESTINO';
    stg_despacho.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
    stg_despacho.Cells[_COL_FECHA, 0] := 'FECHA';
    stg_despacho.Cells[_COL_CORRIDA, 0] := 'Corrida';
    stg_despacho.Cells[_COL_STATUS,0] := 'Estatus';
    stg_despacho.ColWidths[_COL_TRAMO] := 0;
    stg_despacho.ColWidths[_COL_AUTOBUS] := 0;
    stg_despacho.ColWidths[_COL_ASIENTOS] := 0;
    stg_despacho.ColWidths[_COL_RUTA]  := 0;
    stg_despacho.ColWidths[_COL_NAME_IMAGE] := 0;
    stg_despacho.ColWidths[_COL_TIPOSERVICIO] := 0;
    stg_despacho.ColWidths[_COL_PIE] := 0;
    stg_despacho.ColWidths[_COL_TARIFA] := 0;
end;

end.
