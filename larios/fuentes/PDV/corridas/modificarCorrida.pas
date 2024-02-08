unit modificarCorrida;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, lsCombobox, Grids, comun, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, System.Actions,
  Data.SqlExpr;

type
  TfrmModificarCorrida = class(TForm)
    GroupBox3: TGroupBox;
    sgTerminales: TStringGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Servicio: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    lsCbx_bus: TlsComboBox;
    GroupBox4: TGroupBox;
    sgOcupantes: TStringGrid;
    Label3: TLabel;
    acSalir: TAction;
    ActionToolBar1: TActionToolBar;
    ActionManager: TActionManager;
    acModificar: TAction;
    lbServicio: TLabel;
    lbRuta: TLabel;
    lbHoraSalida: TLabel;
    lbFechaSalida: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lsCbx_busClick(Sender: TObject);
    procedure sgTerminalesKeyPress(Sender: TObject; var Key: Char);
    procedure sgTerminalesExit(Sender: TObject);
    procedure sgOcupantesKeyPress(Sender: TObject; var Key: Char);
    procedure acSalirExecute(Sender: TObject);
    procedure acModificarExecute(Sender: TObject);
  private
    id_corrida : String;
    fecha_corrida : TDate;

    lq_query : TSQLQuery;
    dsCupoBuses,
    dsOcupantes : TDualStrings;
    ssql : String;
    gRow,
    maximoPie,
    maximoOcupantesActual : Integer;



    Procedure llenarBuses;
    Procedure cargarOcupantes;
    Procedure cargarOcupantesDe(id_corrida : String);
    Procedure cargarDetalleRuta(id_corrida : String);
    Procedure llenarConCeros(grid : TStringGrid );
    Procedure rectifica(row : Integer);
    Function validarDatos : Boolean;
    Function validarHorarios : Boolean;
    Function validarCupos : Boolean;
    Function obtenerMaximoPie : Integer;
    Function validarMaximos : Boolean;
    Procedure ubicarCorrida;
    Procedure actualizarDatosModificados;
  public
    Procedure valoresDeInicio(corrida : String; fecha : TDate);
  end;

var
  frmExtras: TfrmModificarCorrida;


implementation

uses U_itinerario, DMdb, Frm_vta_main;

{$R *.dfm}

{ TfrmModificarCorrida }

procedure TfrmModificarCorrida.acSalirExecute(Sender: TObject);
begin
 Close;
end;


procedure TfrmModificarCorrida.actualizarDatosModificados;
begin
 ssql := 'SELECT  NOMBRE_IMAGEN FROM PDV_C_TIPO_AUTOBUS WHERE ID_TIPO_AUTOBUS = ' +
         lsCbx_bus.CurrentID + ';';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then
   gs_NombreImagenBusModificado := lq_query.FieldByName('NOMBRE_IMAGEN').AsString;
 lq_query.Close;
 gs_TipoBusModificado := lsCbx_bus.CurrentID;
 gs_NoAsientosBusModificado := IntToStr(maximoOcupantesActual);
end;

procedure TfrmModificarCorrida.cargarDetalleRuta(id_corrida : String);
begin
 ssql := 'SELECT C.HORA, T.DESCRIPCION, C.CUPO, C.PIE FROM PDV_T_CORRIDA_D AS C ' +
         'LEFT OUTER JOIN T_C_TERMINAL AS T ON C.ID_TERMINAL = T.ID_TERMINAL WHERE C.ID_CORRIDA = ''' +
         id_corrida +
         ''' AND C.FECHA = ''' +
         FormatDateTime('YYYY-MM-DD', fecha_corrida) +
         ''' AND C.ID_TERMINAL = ''' +
         gs_terminal + ''';';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then Begin
   sgTerminales.Cells[_COL_TERMINAL,1] := lq_query.FieldByName('DESCRIPCION').AsString;
   sgTerminales.Cells[_COL_HORA,1] := FormatDateTime('HH:nn', lq_query.FieldByName('HORA').AsDateTime);
   sgTerminales.Cells[_COL_CUPO,1] := lq_query.FieldByName('CUPO').AsString;
   sgTerminales.Cells[_COL_PIE,1] := lq_query.FieldByName('PIE').AsString;
   sgTerminales.RowCount := 2;
 End;
 lq_query.Close;

end;



procedure TfrmModificarCorrida.cargarOcupantes;
var
 vRow : Integer;
begin
 ssql := 'SELECT ID_OCUPANTE, DESCRIPCION FROM PDV_C_OCUPANTE WHERE FECHA_BAJA IS NULL AND ID_OCUPANTE > 1;';
 if EjecutaSQL(ssql,lq_query, _LOCAL) then begin

   sgOcupantes.Cells[0, 0] := 'Ocupante';
   sgOcupantes.ColWidths[0] := 80;
   sgOcupantes.Cells[1, 0] := 'Máximo';
   vRow := 1;

   while not lq_query.Eof do begin
     dsOcupantes.Add(lq_query.FieldByName('ID_OCUPANTE').AsString, lq_query.FieldByName('DESCRIPCION').AsString);
     sgOcupantes.Cells[0, vRow] := lq_query.FieldByName('DESCRIPCION').AsString;
     sgOcupantes.Cells[1, vRow] := '0';
     inc(vRow);
     lq_query.Next;
   end;
   sgOcupantes.RowCount := vRow;
 end;
 lq_query.close;

end;


procedure TfrmModificarCorrida.cargarOcupantesDe(id_corrida: String);

Function rowDe(valor : String) : Integer;
var
 vRow : Integer;
Begin
 result := -1;
 for vRow := 1 to sgOcupantes.RowCount - 1 do
   if sgOcupantes.Cells[0, vRow]  = valor then Begin
     result := vRow;
     exit;
   End;
End;

var
 vRow : Integer;

begin
 ssql := 'SELECT  ID_OCUPANTE, MAXIMO FROM PDV_T_CORRIDA_OCUPANTE AS C  WHERE ' +
         'C.ID_CORRIDA = ''' +
         id_corrida +
         ''' AND C.FECHA = ''' +
         FormatDateTime('YYYY-MM-DD',fecha_corrida) +
         ''' AND C.ID_TERMINAL = ''' +
         gs_terminal +
         ''';';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then
   while not lq_query.Eof  do Begin
     vRow :=  rowDe(dsOcupantes.ValueOf(lq_query.FieldByName('ID_OCUPANTE').AsString));
     if vRow > 0 then
       sgOcupantes.Cells[1,vRow] := lq_query.FieldByName('MAXIMO').AsString;
     lq_query.Next;
   End;
 lq_query.Close;
end;

procedure TfrmModificarCorrida.llenarBuses;
Begin
 lsCbx_bus.Clear;
 ssql := 'SELECT ID_TIPO_AUTOBUS,TIPO_AUTOBUS,ASIENTOS FROM PDV_C_TIPO_AUTOBUS ORDER BY ID_TIPO_AUTOBUS';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then begin
   while not lq_query.Eof do begin
     lsCbx_bus.Add(lq_query.FieldByName('TIPO_AUTOBUS').AsString, lq_query.FieldByName('ID_TIPO_AUTOBUS').AsString);
     dsCupoBuses.Add(lq_query.FieldByName('ID_TIPO_AUTOBUS').AsString, lq_query.FieldByName('ASIENTOS').AsString);
     lq_query.Next;
   end;
   lq_query.Close;
 end;


end;


procedure TfrmModificarCorrida.valoresDeInicio(corrida: String; fecha: TDate);
begin
 id_corrida := corrida;
 fecha_corrida := fecha
end;

procedure TfrmModificarCorrida.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 lsCbx_busClick(Sender);
 gds_actions.ID.Clear;
 gds_actions.Value.Clear;
 lq_query.Close;
 lq_query.Free;
 dsOcupantes.Free;
 dsCupoBuses.Free;
end;


procedure TfrmModificarCorrida.FormShow(Sender: TObject);
Begin
 gds_actions.ID.Clear;
 gds_actions.Value.Clear;
 sgTerminales.Cells[_COL_TERMINAL,0] := 'Terminales';
 sgTerminales.ColWidths[_COL_TERMINAL] := 190;
 sgTerminales.Cells[_COL_HORA,0] := 'H. salida';
 sgTerminales.ColWidths[_COL_HORA] := 50;
 sgTerminales.Cells[_COL_CUPO,0] := 'Cupo';
 sgTerminales.ColWidths[_COL_CUPO] := 30;
 sgTerminales.Cells[_COL_PIE,0] := 'Pie';
 sgTerminales.ColWidths[_COL_PIE] := 30;


 lq_query := TSQLQuery.Create(nil);
 lq_query.SQLConnection := DM.Conecta;

 dsCupoBuses := TDualStrings.Create;
 llenarBuses;
 dsOcupantes := TDualStrings.Create;
 cargarOcupantes;




 gRow := -1;
 maximoPie := obtenerMaximoPie;
 ubicarCorrida;


end;


procedure TfrmModificarCorrida.ubicarCorrida;
var
 id_ruta : Integer;
begin
 ssql := 'SELECT C.HORA, C.ID_TIPO_AUTOBUS, S.ABREVIACION, C.ID_RUTA, R.ORIGEN, R.DESTINO ' +
         'FROM PDV_T_CORRIDA AS C LEFT OUTER JOIN SERVICIOS AS S ON C.TIPOSERVICIO = S.TIPOSERVICIO ' +
         'LEFT OUTER JOIN T_C_RUTA AS R ON C.ID_RUTA = R.ID_RUTA WHERE C.ID_CORRIDA =  ''' +
         id_corrida + ''' AND FECHA = ''' +
         FormatDateTime('YYYY-MM-DD', fecha_corrida) + ''';';
 if ejecutaSQL(ssql, lq_query , _LOCAL) then begin
   lbHoraSalida.Caption := FormatDateTime('HH:nn', lq_query.FieldByName('HORA').AsDateTime);
   lbFechaSalida.Caption := FormatDateTime('DD/MM/YYYY', fecha_corrida);
   lbServicio.Caption := lq_query.FieldByName('ABREVIACION').AsString;
   lsCbx_bus.SetID(lq_query.FieldByName('ID_TIPO_AUTOBUS').AsString);
   lbRuta.Caption :=  lq_query.FieldByName('ID_RUTA').AsString + '  ' +
                      lq_query.FieldByName('ORIGEN').AsString + ' - ' +
                      lq_query.FieldByName('DESTINO').AsString;

   id_ruta := lq_query.FieldByName('ID_RUTA').AsInteger;
 end;
 lq_query.Close;



 maximoOcupantesActual  :=  StrToInt(dsCupoBuses.ValueOf(lsCbx_bus.CurrentID));
 cargarDetalleRuta(id_corrida);
 cargarOcupantesDe(id_corrida);




end;

procedure TfrmModificarCorrida.llenarConCeros(grid: TStringGrid);
var
 vRow,
 vCol : Integer;
begin
 for vRow := 1 to grid.RowCount - 1 do
   for vCol := 1 to grid.ColCount - 1 do
     grid.Cells[vCol, vRow] := '0';
end;


procedure TfrmModificarCorrida.lsCbx_busClick(Sender: TObject);
begin
 if lsCbx_bus.ItemIndex >= 0  then begin
   maximoOcupantesActual := StrToInt(dsCupoBuses.Value[lsCbx_bus.ItemIndex]);
   actualizarDatosModificados;
 end;
end;


function TfrmModificarCorrida.obtenerMaximoPie: Integer;
begin
 ssql := 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 10;';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then
   result := lq_query.FieldByName('VALOR').AsInteger
 else
   result := 10;
 lq_query.Close;
end;

procedure TfrmModificarCorrida.rectifica(row: Integer);
Function hora(valor : String) : String;
Begin
 if StrToInt(valor) > 23 then
   result := '00'
 else
   result := valor;
End;

Function minutos(valor : String) : String;
Begin
 if StrToInt(valor) > 59 then
   result := '00'
 else
   result := valor;
End;

begin
 // Coloca los ":" en caso de que no se hayan puesto.

 if Length(sgTerminales.Cells[_COL_HORA,row]) = 4  then
   sgTerminales.Cells[_COL_HORA,row] := hora(copy(sgTerminales.Cells[_COL_HORA,row], 1, 2)) + ':' + minutos(copy(sgTerminales.Cells[_COL_HORA,row], 3, 2))
 else  if Length(sgTerminales.Cells[_COL_HORA,row]) = 5  then
   sgTerminales.Cells[_COL_HORA,row] := hora(copy(sgTerminales.Cells[_COL_HORA,row], 1, 2)) + ':' + minutos(copy(sgTerminales.Cells[_COL_HORA,row], 4, 2))
 else
   sgTerminales.Cells[_COL_HORA,row] := '';



end;

procedure TfrmModificarCorrida.sgOcupantesKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in _CARACTERES_VALIDOS_OCUPANTES) then
   Key := #0
end;

procedure TfrmModificarCorrida.sgTerminalesExit(Sender: TObject);
begin
 rectifica(sgTerminales.Row);
end;

procedure TfrmModificarCorrida.sgTerminalesKeyPress(Sender: TObject; var Key: Char);
begin
 // No dejo editar la primera hora.
 if (sgTerminales.Row = 1) and (sgTerminales.Col = 1) then
   key := #0
 else if not (key in _CARACTERES_VALIDOS_TERMINALES) then
   Key := #0;

end;


function TfrmModificarCorrida.validarCupos: Boolean;
var
 vRow : Integer;
begin
 result := False;
 for vRow := 1 to sgTerminales.RowCount - 1 do Begin
   // Verifico que tengan algo
   if Trim(sgTerminales.Cells[_COL_CUPO, vRow]) = '' then Begin
     Application.MessageBox(PWideChar(format('Falta el dato del cupo para la terminal : %s.',[sgTerminales.Cells[_COL_TERMINAL,vRow]])),'Atención', _ATENCION);
     Exit;
   End;
   if Trim(sgTerminales.Cells[_COL_PIE, vRow]) = '' then Begin
     Application.MessageBox(PWideChar(format('Falta el dato del pie para la terminal : %s.',[sgTerminales.Cells[_COL_TERMINAL,vRow]])),'Atención', _ATENCION);
     Exit;
   End;
   // Verifico que no exedan el limite del bus

   try
     if StrToInt(Trim(sgTerminales.Cells[_COL_CUPO, vRow])) > maximoOcupantesActual then Begin
       Application.MessageBox(PWideChar(format('El dato de cupo para la terminal %s excede la capacidad permitida.',[sgTerminales.Cells[_COL_TERMINAL,vRow]])),'Atención', _ATENCION);
       Exit;
     End;
   except
     Application.MessageBox(PWideChar(format('El dato de cupo para la terminal %s excede la capacidad permitida.',[sgTerminales.Cells[_COL_TERMINAL,vRow]])),'Atención', _ATENCION);
     Exit;
   end;

   try
     if StrToInt(Trim(sgTerminales.Cells[_COL_PIE, vRow])) > maximoPie then Begin
       Application.MessageBox(PWideChar(format('El dato de pie para la terminal %s excede la capacidad permitida.',[sgTerminales.Cells[_COL_TERMINAL,vRow]])),'Atención', _ATENCION);
       Exit;
     End;
   except
     Application.MessageBox(PWideChar(format('El dato de pie para la terminal %s excede la capacidad permitida.',[sgTerminales.Cells[_COL_TERMINAL,vRow]])),'Atención', _ATENCION);
     Exit;
   end;
 End;
 result := True;
end;

function TfrmModificarCorrida.validarHorarios: Boolean;
var
 vRow : Integer;
 otroDia : Boolean;
begin
 result := False;
 otroDia := False;
 result := True;
 if sgTerminales.RowCount <= 2 then
   exit;
 try
   for vRow := 2 to sgTerminales.RowCount -1 do
     if StrToTime(sgTerminales.Cells[_COL_HORA , vRow]) <  StrToTime(sgTerminales.Cells[_COL_HORA, vRow-1]) then
       if not otroDia then
         otroDia := True
       else
         result := False
     else
       if StrToTime(sgTerminales.Cells[_COL_HORA , vRow]) =  StrToTime(sgTerminales.Cells[_COL_HORA, vRow-1]) then
         result := False;
 except
   result := False;
 end;

 if not result then
   Application.MessageBox('Existe un error en los horarios, favor de verificarlos.','Atención', _ATENCION);
end;

function TfrmModificarCorrida.validarMaximos: Boolean;
var
 total,
 vRow : Integer;
begin
 Result := false;
 total := 0;
 for vRow := 1 to sgOcupantes.RowCount - 1 do Begin
   try
     total := total + StrToInt(sgOcupantes.Cells[1, vRow]);
     if total > maximoOcupantesActual then Begin
       Application.MessageBox(PWideChar(format('Sobrepasa la capacidad de tipos de ocupantes para la terminal: %s.',[sgTerminales.Cells[_COL_TERMINAL, vRow]])),'Atención', _ATENCION);
       exit;
     end;
   except
     Application.MessageBox(PWideChar(format('Sobrepasa la capacidad de tipos de ocupantes para la terminal: %s.',[sgTerminales.Cells[_COL_TERMINAL, vRow]])),'Atención', _ATENCION);
     exit;
   End;
 End;
 result := True;
end;

function TfrmModificarCorrida.validarDatos: Boolean;
begin
 result := False;
 if  (lsCbx_bus.ItemIndex > -1 ) and (validarHorarios) and (validarCupos) and (validarMaximos) then
   result := True;
end;




procedure TfrmModificarCorrida.acModificarExecute(Sender: TObject);
var
 vRow : Integer;
begin
 if Not validarDatos then Begin
   Application.MessageBox('Faltan datos, favor de verificarlos.','Atención', _ERROR);
   exit;
 end;
 try
   // Actualizo el maestro
   ssql := 'UPDATE PDV_T_CORRIDA SET ID_TIPO_AUTOBUS = ' +
           lsCbx_bus.CurrentID +
           ' WHERE ID_CORRIDA = ''' +
           id_corrida +
           ''' AND FECHA = ''' +
           FormatDateTime('YYYY-MM-DD',fecha_corrida) +
           ''';';
   EjecutaSQL(ssql, lq_query, _LOCAL);

   // Actualizo el detalle
   ssql := 'UPDATE PDV_T_CORRIDA_D SET CUPO = ' +
           sgTerminales.Cells[_COL_CUPO,1] +
           ', PIE = ' +
           sgTerminales.Cells[_COL_PIE,1] +
           ' WHERE ID_CORRIDA = ''' +
           id_corrida +
           ''' AND FECHA = ''' +
           FormatDateTime('YYYY-MM-DD',fecha_corrida) +
           ''';';
   EjecutaSQL(ssql, lq_query, _LOCAL);

   // Actualizo el detalleOcupantes
    // Primero lo borro
   ssql := 'DELETE FROM PDV_T_CORRIDA_OCUPANTE WHERE ID_CORRIDA = ''' +
           id_corrida +
           ''' AND FECHA = ''' +
           FormatDateTime('YYYY-MM-DD',fecha_corrida) +
           ''' AND ID_TERMINAL = ''' +
           gs_terminal +
           ''';';
   EjecutaSQL(ssql, lq_query, _LOCAL);

   // ahora los inserto

   for vRow := 1 to sgOcupantes.RowCount - 1 do Begin
     ssql := 'INSERT INTO PDV_T_CORRIDA_OCUPANTE(ID_OCUPANTE, MAXIMO, ID_CORRIDA, ' +
             'FECHA, ID_TERMINAL) VALUES(' +
             dsOcupantes.IDOf(sgOcupantes.Cells[0,vRow]) +
             ', ' +
             sgOcupantes.Cells[1,vRow] +
             ', ''' +
             id_corrida +
             ''', ''' +
             FormatDateTime('YYYY-MM-DD',fecha_corrida) +
             ''', ''' +
             gs_terminal +
             ''');';
     EjecutaSQL(ssql, lq_query, _LOCAL);
   End;

   Application.MessageBox(PWideChar(format('Datoas actualizados correctamente.',[])),'Atención', _ATENCION);
 except
   Application.MessageBox('Error al realizar la actualización.','Error', _ERROR);

 end;



end;













end.
