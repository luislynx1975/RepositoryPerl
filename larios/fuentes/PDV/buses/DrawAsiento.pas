unit DrawAsiento;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    windows, Classes, DB, SysUtils, Grids, Forms,Dialogs, ActnList, lsCombobox,
    ExtCtrls, Graphics, StdCtrls, Controls, Data.SqlExpr, U_venta;

type
    a_etiqueta = array  of Tlabel;
    a_reservados = array[0..40]of Integer;
    TDibujaAsiento = class(TObject)
    private
      panel      : TPanel;
      img_pnl    : TImage;
      no_asiento : integer;
      query      : TSQLQuery;
      name_file  : string;
      a_labels   : a_etiqueta;
      li_Corrida    : String;
      ld_fecha      : TDate;
      lt_hora       : TTime;
      Punto         : TPoint;
      bus_id        : Integer;
      labelsColor : Array [0..4]of TColor;
      li_reservado : integer;
      li_borrar    : integer;
      labels : labels_asientos;
      procedure SetNoSeat(const Value: Integer);
      procedure setFileImg(const Value: String);
      procedure setCorrida(const Value: String);
      procedure setFecha(const Value: TDate);
      procedure setHora(const Value: TTime);
      procedure getAsientosXYBus();
      procedure TrazaEtiquetaInBus(texto : string; p : TPoint; icolor : Integer; li_ctrl : Integer);
      procedure EtiquetasInBus(texto : string; p : TPoint; icolor : Integer; li_ctrl : Integer);
      procedure setBusId(const Value: integer);
      procedure asientosOcupados();
      procedure asientosReservados(nombre, fecha : string);
      procedure setReservado(const Value: Integer);
      function getEtiquetas: labels_asientos;
      procedure setEtiquetas(const Value: labels_asientos);
    public
      property NumeroSeat : Integer write SetNoSeat;
      property ArchivoImg : String write  setFileImg;
      property Corrida : String write setCorrida;
      property fecha   : TDate  write setFecha;
      property id_bus  : integer write setBusId;
      property hora    : TTime write setHora;
      property Etiquetas_labels : labels_asientos read getEtiquetas write setEtiquetas;
      constructor Create(panel : TPanel; imagen : TImage);
      destructor destroy;
      procedure getImagenDraw();
      procedure getImagenReservados(pasajero, fecha : string; var reservados : a_reservados);
      procedure getBusImagenShow(nombre,corrida_cuando : String);
      procedure setNoAsiento();
      procedure setNewImagen();
      procedure asientosPasajeroReservados(usuario, fecha : string);

    end;
implementation

uses comun, DMdb;

var
    Store : TSQLStoredProc;
    reserva_array : a_reservados;

{ DibujaAsiento }




{@Procedure asientosOcupados
@Descripcion Visualizamos en el Label que asiento se esta ocupando en base al estatus
@            para visualizarlo}
procedure TDibujaAsiento.asientosOcupados;
var
    store : TSQLStoredProc;
    lc_tipo : Char;
    ls_hora : string;
begin
    ls_hora := FormatDateTime('YYYY-MM-DD',ld_fecha) +' '+ FormatDateTime('HH:nn:SS', lt_hora);
    Store := TSQLStoredProc.Create(nil);
    try
      Store.SQLConnection := CONEXION_VTA; //DM.Conecta;
      store.close;
      store.StoredProcName := 'PDV_STORE_ASIENTOS_DISPONIBLES';
      store.Params.ParamByName('IN_CORRIDA').AsString := li_Corrida;
      store.Params.ParamByName('FECHA_INPUT').AsString  := ls_hora;
      store.Params.ParamByName('IN_PIE').AsInteger := gi_vta_pie;
      store.Open;
      store.First;
      while not store.Eof do begin
           lc_tipo := Store.FieldByName('STATUS').AsString[1];
           case  lc_tipo of
              'V' : labels[StrToInt(store['NO_ASIENTO'])].Color := _ASIENTO_VENDIDO;
              'R' : labels[StrToInt(store['NO_ASIENTO'])].Color := _ASIENTO_RESERVADO;
              'A' : labels[StrToInt(store['NO_ASIENTO'])].Color := _ASIENTO_APARTADO;
           end;
          labels[StrToInt(store['NO_ASIENTO'])].Caption := store['TEXTO'];
          store.Next;
      end;
    finally
      store.Free;
      store := nil;
    end;
end;


procedure TDibujaAsiento.asientosPasajeroReservados(usuario, fecha : string);
var
    store : TSQLStoredProc;
    lc_tipo : char;
begin
    store := TSQLStoredProc.Create(nil);
    try
      store.SQLConnection := DM.Conecta;
      store.close;
      store.StoredProcName := 'PDV_STORE_ASIENTO_RESERVADO_PASAJERO';
      store.Params.ParamByName('IN_FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD HH:nn:SS', StrToDateTime(fecha));
      store.Params.ParamByName('IN_CORRIDA').AsString := li_Corrida;
      store.Params.ParamByName('IN_PASAJERO').AsString := usuario;
      store.Open;
      store.First;
      while not store.Eof do begin
         lc_tipo := store.FieldByName('TEXTO').AsString[1];
         if lc_tipo = 'R' then begin //labels_asientos

              labels[StrToInt(store['NO_ASIENTO']) - 1].Color := _ASIENTO_RESERVADO;
              labels[StrToInt(store['NO_ASIENTO']) - 1].Caption := store['TEXTO'];
         end;
         store.Next;
      end;//fin while
    finally
      store.Free;
    end;
end;



procedure TDibujaAsiento.asientosReservados(nombre, fecha: String);
var
    store : TSQLStoredProc;
    li_ctrl : Integer;
    lc_tipo : char;
begin
    store := TSQLStoredProc.Create(nil);
    try
      li_ctrl := 0;
      store.SQLConnection := DM.Conecta;
      store.close;
      store.StoredProcName := 'PDV_STORE_ASIENTOS_RESERVADOS';
      store.Params.ParamByName('IN_CORRIDA').AsString := li_Corrida;
      store.Params.ParamByName('FECHA_INPUT').AsString := FormatDateTime('YYYY-MM-DD', StrToDate(fecha));
      store.Params.ParamByName('PASAJERO').AsString    := nombre;
      store.Open;
      store.First;
      while not store.Eof do begin
           lc_tipo := Store.FieldByName('TEXTO').AsString[1];
           case  lc_tipo of
              'V' : labels[StrToInt(store['NO_ASIENTO'])].Color := _ASIENTO_VENDIDO;
              'R' : labels[StrToInt(store['NO_ASIENTO'])].Color := _ASIENTO_RESERVADO;
              'A' : labels[StrToInt(store['NO_ASIENTO'])].Color := _ASIENTO_APARTADO;
           end;
          if store.FieldByName('TEXTO').AsString[1] = 'R' then begin
              reserva_array[li_ctrl] := store['NO_ASIENTO'];
              inc(li_ctrl);
          end;
          labels[StrToInt(store['NO_ASIENTO'])].Caption := store['TEXTO'];
          Store.next;
      end;
    finally
        store.Free;
        store := nil;
    end;
end;


constructor TDibujaAsiento.Create(panel : TPanel; imagen : TImage);
begin
  inherited create;
  Self.panel := panel;
  img_pnl := imagen;
end;


destructor TDibujaAsiento.destroy;
var
    li_num, li_max : Integer;
begin
   Store.Free;
   Store := nil;
   no_asiento := 0;
   name_file  := '';
   li_Corrida := '';
   ld_fecha   := now();
   bus_id     := 0;
   a_labels := nil;
   inherited destroy;
end;

procedure TDibujaAsiento.EtiquetasInBus(texto: string; p: TPoint; icolor,
  li_ctrl: Integer);
begin
    labels[li_ctrl]^.Color := _ASIENTO_LIBRE;
    labels[li_ctrl]^.Font.Size := 10;
    labels[li_ctrl]^.Top   := p.Y;
    labels[li_ctrl]^.Left  := p.X;
    labels[li_ctrl]^.Caption := texto;
    labels[li_ctrl]^.Font.Style := [fsBold];
    labels[li_ctrl]^.WordWrap   := true;
    labels[li_ctrl]^.visible := True;
    labels[li_ctrl]^.Parent := panel;
end;

procedure TDibujaAsiento.TrazaEtiquetaInBus(texto: string; p: TPoint; icolor,
  li_ctrl: Integer);
begin
    a_labels[li_ctrl - 1] := TLabel.Create(panel);
    a_labels[li_ctrl - 1].Color := _ASIENTO_LIBRE;
    a_labels[li_ctrl - 1].Font.Size := 10;
    a_labels[li_ctrl - 1].Top := p.Y;
    a_labels[li_ctrl - 1].Left := p.X;
    a_labels[li_ctrl - 1].Caption := texto;
    a_labels[li_ctrl - 1].Font.Style := [fsBold];
    a_labels[li_ctrl - 1].WordWrap := true;
    try
      a_labels[li_ctrl - 1].Name    := 'lbls'+IntToStr(li_ctrl - 1);
    except
        on EComponentError do begin
          a_labels[li_ctrl - 1].Visible := True;
          a_labels[li_ctrl - 1].Parent  := panel;
        end
    end;
    a_labels[li_ctrl - 1].Visible := true;
    a_labels[li_ctrl - 1].Parent := panel;
    li_borrar := li_ctrl - 1;
end;



procedure TDibujaAsiento.getAsientosXYBus;
var
    Store : TSQLStoredProc;
begin
    Store := TSQLStoredProc.Create(nil);
    try
      Store.SQLConnection := CONEXION_VTA; //DM.Conecta;
      store.close;
      Store.StoredProcName := 'PDV_STORE_BUSCA_POR_AUTOBUS_XY';
      Store.Params.ParamByName('IN_ID_BUS').AsInteger := bus_id;
      Store.Open;
      store.First;
      while not Store.Eof do begin
          Punto.X := Store['X'];
          Punto.Y := Store['Y'];
          EtiquetasInBus(Store['Asiento'],Punto,_ASIENTO_LIBRE,Store['Asiento']);
//          TrazaEtiquetaInBus(Store['Asiento'],Punto,_ASIENTO_LIBRE,Store['Asiento']);
          Store.Next;
      end;
    finally
      Store.Free;
      Store := nil;
    end;
end;



procedure TDibujaAsiento.getBusImagenShow(nombre,corrida_cuando : String);
var
    h      : THandle;
    bitmap : TBitmap;
    li_ctrl : Integer;
begin
    for li_ctrl := 0 to high(reserva_array) do
      reserva_array[li_ctrl] := 0;
    h := LoadLibrary(_LIBRARYNAME);
    if h <> 0 then begin
      try
          bitmap := TBitmap.Create;
          bitmap.LoadFromResourceName(h,name_file);
          img_pnl.Width  := bitmap.Width;
          img_pnl.Height := bitmap.Height;
          img_pnl.Canvas.Draw(0,0,bitmap);
          img_pnl.AutoSize := True;
          img_pnl.Visible := true;
          img_pnl.Parent := Panel;
          setNoAsiento();//asignamos el tamaño al arreglo
          getAsientosXYBus();
          asientosPasajeroReservados(nombre,corrida_cuando);
      finally
          bitmap.Free;
      end;
    end;
end;


procedure TDibujaAsiento.getImagenDraw;
var
    h      : THandle;
    bitmap : TBitmap;
begin
    h := LoadLibrary(_LIBRARYNAME);
    if h <> 0 then begin
      try
          bitmap := TBitmap.Create;
          bitmap.LoadFromResourceName(h,name_file);
          img_pnl.Width  := bitmap.Width;
          img_pnl.Height := bitmap.Height;
          img_pnl.Canvas.Draw(0,0,bitmap);
          img_pnl.AutoSize := True;
          img_pnl.Visible := true;
          img_pnl.Parent := Panel;
//          setNoAsiento();//asignamos el tamaño al arreglo
//          getAsientosXYBus();//pedimos las coordenadas de los asientos
//          asientosOcupados();//si tiene asientos dibujalos en la imagen
      finally
          bitmap.Free;
      end;
    end;
end;



procedure TDibujaAsiento.getImagenReservados(pasajero, fecha : string; var reservados : a_reservados);
var
    h      : THandle;
    bitmap : TBitmap;
    li_ctrl : Integer;
begin
    for li_ctrl := 0 to high(reserva_array) do
      reserva_array[li_ctrl] := 0;
    h := LoadLibrary(_LIBRARYNAME);
    if h <> 0 then begin
      try
          bitmap := TBitmap.Create;
          bitmap.LoadFromResourceName(h,name_file);
          img_pnl.Width  := bitmap.Width;
          img_pnl.Height := bitmap.Height;
          img_pnl.Canvas.Draw(0,0,bitmap);
          img_pnl.AutoSize := True;
          img_pnl.Visible := true;
          img_pnl.Parent := Panel;
//          setNoAsiento();//asignamos el tamaño al arreglo
          getAsientosXYBus();
          asientosReservados(pasajero,fecha);
          reservados := reserva_array;
      finally
          bitmap.Free;
      end;
    end;
end;

function TDibujaAsiento.getEtiquetas: labels_asientos;
begin
    Result := labels;
end;

procedure TDibujaAsiento.setNewImagen();
begin
      asientosOcupados();
end;



procedure TDibujaAsiento.setBusId(const Value: integer);
begin
    if Value <> 0 then
        bus_id := Value;
end;

procedure TDibujaAsiento.setCorrida(const Value: String);
begin
    if Value <> '' then
        li_Corrida := Value;
end;

procedure TDibujaAsiento.setEtiquetas(const Value: labels_asientos);
begin
      labels := value;
end;

procedure TDibujaAsiento.setFecha(const Value: TDate);
begin
    if Value <> 0 then
        ld_fecha := Value;
end;

procedure TDibujaAsiento.setFileImg(const Value: String);
begin
    if Value <> '' then
        name_file := Value;
end;


procedure TDibujaAsiento.setHora(const Value: TTime);
begin
    if Value <> 0 then
        lt_hora := Value;
end;


procedure TDibujaAsiento.setNoAsiento;
begin
    a_labels := nil;
    SetLength(a_labels, no_asiento);
end;

procedure TDibujaAsiento.SetNoSeat(const Value: Integer);
begin
    if Value <> 0 then
        no_asiento := Value;
end;

procedure TDibujaAsiento.setReservado(const Value: Integer);
begin
    if Value <> 0 then
        li_reservado := Value;
end;


end.
