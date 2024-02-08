unit ThreadCorrida;

interface
{$warnings off}
{$hints off}
uses
  Classes, StdCtrls, DB, ActiveX, SysUtils, Grids, Data.SqlExpr,
  DrawAsiento, DateUtils, ExtCtrls;
Const
    _COL_HORA     = 0;
    _COL_DESTINO  = 1;
    _COL_SERVICIO = 2;
    _COL_FECHA    = 3;
    _COL_TRAMO    = 4;
    _COL_RUTA     = 5;
    _COL_CORRIDA  = 6;
    _COL_AUTOBUS  = 7;
    _COL_NAME_IMAGE = 8;
    _COL_ASIENTOS = 9;
    _COL_TIPOSERVICIO = 10;
    _COL_CUPO     = 11;
    _COL_PIE      = 12;
    _COL_TARIFA = 13;


type
  CorridaThread = class(TThread)
  private
    { Private declarations }
    procedure consultaCorridas();
    function  validaSiguienteFecha(fecha_consulta : TDate) : TDate;
    function comparaHoraCorrida(lps_hora, lps_store : String): Boolean;
    procedure llenarGridCorridas;
    procedure titlesCorrida;
  published

  protected
    procedure Execute; override;
  public
    { Public desclarations}
    server  : TSQLConnection;
    origen  : String;
    destino : String;
    fecha   : String;
    hora    : String;
    servicio : String;
    condicion : integer;
    grid     : TStringGrid;
    corrida  : String;
    panel    : TPanel;
    imagen   : TImage;
    function resultado : integer;
  end;

var
    ls_hora : String;
    li_indice : integer;
    store : TSQLStoredProc;
    i_numCorrida, i_select_corrida : integer;
    Asiento: TDibujaAsiento;

implementation

{ CorridaThread }

procedure CorridaThread.llenarGridCorridas;
var
    ld_tarifa : real;
    ls_fecha_hora : String;
begin
    Grid.Cells[_COL_HORA,li_indice] := ls_hora;
    Grid.Cells[_COL_DESTINO,li_indice] := Store.FieldByName('DESTINO').AsString;
    Grid.Cells[_COL_SERVICIO,li_indice] := Store.FieldByName('ABREVIA').AsString;
    Grid.Cells[_COL_FECHA,li_indice] := Store.FieldByName('FECHA').AsString;
    Grid.Cells[_COL_TRAMO,li_indice] := IntToStr(Store.FieldByName('ID_TRAMO').AsInteger);
    Grid.Cells[_COL_RUTA,li_indice] := IntToStr(Store.FieldByName('ID_RUTA').AsInteger);
    Grid.Cells[_COL_CORRIDA,li_indice] := Store.FieldByName('ID_CORRIDA').AsString;
    Grid.Cells[_COL_AUTOBUS,li_indice] := IntToStr(Store.FieldByName('ID_TIPO_AUTOBUS').AsInteger);
    Grid.Cells[_COL_NAME_IMAGE,li_indice] := Store.FieldByName('NOMBRE_IMAGEN').AsString;
    Grid.Cells[_COL_ASIENTOS,li_indice] := IntToStr(Store.FieldByName('ASIENTOS').AsInteger);
    Grid.Cells[_COL_TIPOSERVICIO,li_indice] := IntToStr(store.FieldByName('TIPOSERVICIO').AsInteger);
    Grid.Cells[_COL_TARIFA,li_indice] := '';
    inc(li_indice);
end;


function CorridaThread.resultado: integer;
begin
    Result := i_select_corrida;
end;

procedure CorridaThread.titlesCorrida;
begin
    grid.Cells[_COL_HORA, 0] := 'HORA';
    grid.Cells[_COL_DESTINO, 0] := 'DESTINO';
    grid.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
    grid.Cells[_COL_FECHA, 0] := 'FECHA';
    grid.Cells[_COL_RUTA, 0] := 'Ruta';
    grid.Cells[_COL_CORRIDA, 0] := 'Corrida';
    grid.Cells[_COL_TARIFA, 0] := 'Tarifa';
    grid.ColWidths[_COL_TRAMO] := 0;
    grid.ColWidths[_COL_AUTOBUS] := 0;
    grid.ColWidths[_COL_ASIENTOS] := 0;
    grid.ColWidths[_COL_NAME_IMAGE] := 0;
    grid.ColWidths[_COL_TIPOSERVICIO] := 0;
    grid.ColWidths[_COL_PIE] := 0;
    grid.ColWidths[_COL_CUPO] := 0;
    grid.ColWidths[_COL_TARIFA] := 0;
end;

function CorridaThread.comparaHoraCorrida(lps_hora, lps_store: String): Boolean;
var
    ldh_actual, ldh_base : TTime;
    li_compara : integer;
    lb_out : Boolean;
    lc_char : char;
begin

    if lps_store[1] = 'E' then lps_store := Copy(lps_store,2,9);
    li_compara := CompareStr(lps_hora,lps_store);

    if lps_hora = lps_store then lb_out := true
    else lb_out := False;
    result := lb_out;
end;


procedure CorridaThread.consultaCorridas;
var
    li_idx: Integer;
    ls_muestra : string;
    ls_char : Char;
    lb_opcion  : Boolean;
    fecha_next : TDate;
    lf_moneda  : Real;
begin
    store := TSQLStoredProc.Create(nil);
    fecha_next := validaSiguienteFecha(StrToDate(fecha));
    try
        store.SQLConnection := server;
        store.Close;
        store.StoredProcName := 'PDV_STORE_MUESTRA_CORRIDAS';
        store.Params.ParamByName('IN_ORIGEN').AsString := Origen;
        store.Params.ParamByName('IN_DESTINO').AsString := Destino;
        store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD',StrToDate(fecha));
        store.Params.ParamByName('FECHA_SIGUIENTE').AsString := FormatDateTime('YYYY-MM-DD',fecha_next);
        store.Open;
        li_indice := 1;
        with store do begin
            First;
            while not EoF do begin
              ls_char := Store.FieldByName('TIPO').AsString[1];
              case ls_char of
                  'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
                  else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
              end;

              if ((Store['COMPARA'] = 1) and (lb_opcion = False)) then begin
                  i_select_corrida := li_indice;
                  lb_opcion := true;
              end;

              if condicion = 1 then begin
                  if ((length(hora) <> 0)  or (Length(servicio) <> 0 ) or (length(corrida) <> 0) )then begin
                      if (( comparaHoraCorrida(hora,FormatDateTime('HH:MM',Store.FieldByName('HORA').AsDateTime))) and
                          (servicio = store['ABREVIA']) and (store['ID_CORRIDA'] = corrida) and
                          (store['ID_CORRIDA'] = corrida) ) then
                              Synchronize(llenarGridCorridas);
                      if (( comparaHoraCorrida(hora,FormatDateTime('HH:MM',Store.FieldByName('HORA').AsDateTime))) and
                          (length(servicio) = 0) and (length(corrida) = 0) ) then
                              Synchronize(llenarGridCorridas);
                      if (( length(hora) = 0) and (length(corrida) = 0) and (servicio = store['TIPOSERVICIO'])  ) then
                              Synchronize(llenarGridCorridas);
                      if (( length(hora) = 0) and (length(servicio) = 0) and (store['ID_CORRIDA'] = corrida) ) then
                              Synchronize(llenarGridCorridas);
                  end;

              end else begin
                        Synchronize(llenarGridCorridas);
              end;
              inc(i_numCorrida);
              Next;
            end;//
        end;//fin with
        if li_idx = 1 then
           Inc(li_indice);
        if (i_select_corrida = 0) and (i_numCorrida > 0) then
            i_select_corrida := i_numCorrida;
        Grid.RowCount := li_indice;
        Grid.Row := i_select_corrida;
    finally
        store.Destroy;
    end;
    Asiento := TDibujaAsiento.Create(panel,imagen);
    Asiento.NumeroSeat := StrToInt(grid.Cols[_COL_ASIENTOS].Strings[grid.Row]);
    Asiento.ArchivoImg := grid.Cols[_COL_NAME_IMAGE].Strings[grid.Row];
    Asiento.corrida := grid.Cols[_COL_CORRIDA].Strings[grid.Row];
    Asiento.fecha := StrToDate(grid.Cols[_COL_FECHA].Strings[grid.Row]);
//    Asiento.hora := StrToTime(Ed_Hora.Text);
    Asiento.id_bus := StrToInt(grid.Cols[_COL_AUTOBUS].Strings[grid.Row]);
//    Asiento.Etiquetas_labels := labels;
    Asiento.getImagenDraw; // dibujamos el bus en el panel
    Asiento.setNewImagen();

end;


procedure CorridaThread.Execute;
begin
  { Place thread code here }
    CoInitialize(nil);
    titlesCorrida;
    Synchronize(consultaCorridas);
    CoUninitialize();
end;


function CorridaThread.validaSiguienteFecha(fecha_consulta: TDate): TDate;
var
    myYear, myMonth, myDay : Word;
begin
    DecodeDate(fecha_consulta,myYear,myMonth,myDay);
    inc(myDay);
    if myDay > DaysInMonth(fecha_consulta) then begin
        myDay := 1;
        inc(myMonth);
    end;

    if myMonth > 12 then begin
      myMonth := 1;
      myYear  := myYear + 1;
    end;
    Result := EncodeDate(myYear,myMonth,myDay);
end;

end.
