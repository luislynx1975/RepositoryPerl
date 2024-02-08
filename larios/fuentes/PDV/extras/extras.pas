unit extras;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, lsCombobox, Grids, comun, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ExtCtrls,
  System.Actions, Data.SqlExpr;

type
  TfrmExtras = class(TForm)
    GroupBox3: TGroupBox;
    sgTerminales: TStringGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Servicio: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    lsCbx_bus: TlsComboBox;
    lsCbx_servicio: TlsComboBox;
    lsCbx_ruta: TlsComboBox;
    dtpHoraSalida: TDateTimePicker;
    sgMaximos: TStringGrid;
    GroupBox4: TGroupBox;
    sgOcupantes: TStringGrid;
    Label3: TLabel;
    dtpFechaSalida: TDateTimePicker;
    acSalir: TAction;
    acGuardar: TAction;
    ActionToolBar1: TActionToolBar;
    ActionManager: TActionManager;
    pRuta: TPanel;
    lbDetalle: TLabel;
    chkCorridaDeVacio: TCheckBox;
    mem_conexion: TMemo;
    chk_web: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lsCbx_rutaClick(Sender: TObject);
    procedure lsCbx_busClick(Sender: TObject);
    procedure dtpHoraSalidaChange(Sender: TObject);
    procedure sgTerminalesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgTerminalesKeyPress(Sender: TObject; var Key: Char);
    procedure sgTerminalesExit(Sender: TObject);
    procedure sgOcupantesExit(Sender: TObject);
    procedure sgOcupantesKeyPress(Sender: TObject; var Key: Char);
    procedure acSalirExecute(Sender: TObject);
    procedure acGuardarExecute(Sender: TObject);
    procedure chkCorridaDeVacioClick(Sender: TObject);
    procedure dtpFechaSalidaChange(Sender: TObject);
  private
    lq_query : TSQLQuery;
    dsTerminales,
    dsCupoBuses,
    dsOcupantes : TDualStrings;
    ssql : String;
    gRow,
    maximoPie,
    maximoOcupantesActual : Integer;
    terminalesAutomatizadas : TStrings;

    Procedure llenarBuses;
    Procedure cargarOcupantes;
    Procedure cargarDetalleRuta(id_ruta : Integer);
    Procedure llenarConCeros(grid : TStringGrid );
    Procedure rectifica(row : Integer);
    Procedure copiarMaximos(nuevos: Boolean);
    Function validarDatos : Boolean;
    Function validarHorarios : Boolean;
    Function guardarCorrida(sterminal : String; fecha : TDate; hora: TTime; id_tipo_autobus, tiposervicio,
             id_ruta: Integer): String;
    function buscarCorridaExiste(sterminal : string; fecha : TDate; hora : TTime) : boolean;
    Procedure cargarTerminalesAutomatizadasPara(id_ruta : integer);
    Function esAutomatizada(terminal : String) : Boolean;
    Function validarCupos : Boolean;
    Function obtenerMaximoPie : Integer;
    Function validarMaximos : Boolean;
    Procedure cargarTerminales;
    Procedure pintaDetalleCompletoRuta(id_ruta : String );
    Function cargarCorrida(id_corrida : String) : Boolean;
    Function cargarCupos(id_corrida : String) : Boolean;
    Function cargarMaximos(id_corrida : String) : Boolean;
    function getPermisoCorridaVacio() : integer;
    procedure limpiaTerminales();

    ////////////
  public
    { Public declarations }
  end;

var
  frmExtras: TfrmExtras;


implementation

uses U_itinerario, DMdb, u_main, u_ping;

var
    gli_opcion_remota : integer;
    gli_guiaV_anterior : integer;
    chks : array[0..50] of TCheckBox;
    li_chks : integer;
{$R *.dfm}

{ TfrmExtras }

procedure TfrmExtras.acGuardarExecute(Sender: TObject);
Var
 n, m, vCol, vRow, vNum, vAuto : Integer;
 sentencia, nueva_corrida, estatus, ls_msg_conexion : String;
 ga_datos : gga_parameters;
 li_visibleWeb : integer;
begin
  if mem_conexion.Visible then begin
      mem_conexion.Clear;
      mem_conexion.Visible := false;
  end;

  if not AccesoPermitido(177, True) then
   exit;

// Valido que los datos esten bien
  lsCbx_servicio.SetFocus;
  if not validarDatos then begin
    Application.MessageBox('Faltan datos, favor de verificarlos.','Atención', _ERROR);
    exit;
  end;
 splitLine(lsCbx_ruta.Text,'-',ga_datos, vNum);
 if gs_terminal = ga_datos[0] then begin
    if gi_genera_hora_igual = 1 then begin
      if buscarCorridaExiste(gs_terminal, dtpFechaSalida.Date, dtpHoraSalida.Time ) then begin
          Application.MessageBox('No se puede genera una corrida extra, ya existe con esos parametros','Atención', _ERROR);
          dtpHoraSalida.SetFocus;
          exit;
      end;
    end;
    nueva_corrida := guardarCorrida(gs_terminal, dtpFechaSalida.Date, dtpHoraSalida.Time, StrToInt(lsCbx_bus.CurrentID),
                                    StrToInt(lsCbx_servicio.CurrentID), StrToInt(lsCbx_ruta.CurrentID));
    vAuto := 0;
 end else begin
     nueva_corrida := guardarCorrida(ga_datos[0]+'-'+gs_terminal, dtpFechaSalida.Date, dtpHoraSalida.Time, StrToInt(lsCbx_bus.CurrentID),
                       StrToInt(lsCbx_servicio.CurrentID), StrToInt(lsCbx_ruta.CurrentID));
     vAuto := 1;
 end;

 if nueva_corrida <> '' then Begin
   cargarTerminalesAutomatizadasPara(StrToInt(lsCbx_ruta.CurrentID));
   for m := 1 to sgTerminales.RowCount do begin
      if sgTerminales.Cells[_COL_CHKC, m] = 'N' then begin
        ssql := 'SELECT ID_TERMINAL FROM T_C_TERMINAL WHERE DESCRIPCION = TRIM(''' + sgTerminales.Cells[_COL_TERMINAL, m]+ ''')';
        lq_query.SQL.Clear;
        lq_query.SQL.Add(ssql);
        lq_query.Open;
        if not lq_query.IsEmpty then begin
           for n := 0 to  terminalesAutomatizadas.Count - 1 do Begin
                if lq_query['ID_TERMINAL'] = terminalesAutomatizadas[n] then begin
                    terminalesAutomatizadas.Delete(n);
                    Break;
                end;
           End;
        end;
      end;
   end;
   // Subir los querys del master de la corrida para que se actualicen a las terminales automatizadas.
   ssql := 'INSERT INTO PDV_T_CORRIDA(ID_CORRIDA, FECHA, HORA, ID_TIPO_AUTOBUS, TIPOSERVICIO, ID_RUTA, NO_BUS, TIPO_CORRIDA, CREADO_POR) VALUES(''' +
           nueva_corrida +
           ''', ''' +
           FormatDateTime('YYYY-MM-DD', dtpFechaSalida.Date) +
           ''', ''' +
           FormatDateTime('HH:nn', dtpHoraSalida.Time) +
           ''', ' +
           lsCbx_bus.CurrentID +
           ', ' +
           lsCbx_servicio.CurrentID +
           ', ' +
           lsCbx_ruta.CurrentID +
           ', NULL, ''E'', ''' +
           gs_trabid  + ''');';
   //replicamos a la terminal remota el encabezado
   if (vAuto = 1) and (chkCorridaDeVacio.Checked) then begin

       sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                    'SELECT NOW(), ''' +
                    ga_datos[0] +
                    ''', :ssql';
       lq_query.SQL.Clear;
       lq_query.SQL.Add(sentencia);
       lq_query.Params[0].AsString := ssql;
       lq_query.ExecSQL;
       insertaEvento(gs_trabid,gs_terminal, sentencia);
   end;

   ls_msg_conexion := '';
   for n := 0 to  terminalesAutomatizadas.Count - 1 do Begin
       lq_query.SQL.Clear;
       sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                    'SELECT NOW(), ''' +
                    terminalesAutomatizadas[n] +
                    ''', :ssql';
       lq_query.SQL.Add(sentencia);
       lq_query.Params[0].AsString := ssql;
       lq_query.ExecSQL;
       if terminalesAutomatizadas[n] <> '1730' then
           if length(Ping(terminalesAutomatizadas[n])) > 0 then begin
              ls_msg_conexion := ls_msg_conexion + 'No existe conexión con: ' + terminalesAutomatizadas[n] + ' mandar código de barras vía Whatsapp'+ #10#13;
          end;
   end;

   // Guardar el detalle tanto en la corrida local como en todas las remotas automatizadas

   if chkCorridaDeVacio.Checked then
     estatus := 'V' // Vacio
   else
     estatus := 'A'; // Abierta

   vRow := 1;

   sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                'SELECT NOW(), ''1730'', :ssql';
   lq_query.SQL.Clear;
   lq_query.SQL.Add(sentencia);
   lq_query.Params[0].AsString := ssql;
   lq_query.ExecSQL;

   if chk_web.Checked then
      li_visibleWeb := 1
   else
      li_visibleWeb := 0;

   ssql := 'INSERT INTO PDV_T_CORRIDA_D(ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, ID_RUTA, VENDIBLE_ONLINE, TRAB_ID) VALUES(''' +
           nueva_corrida  + ''', ''' + // id_corrida
           FormatDateTime('YYYY-MM-DD', dtpFechaSalida.Date) + ''', ''' +  // Fecha
           dsTerminales.IDOf(sgMaximos.Cells[0, vRow])  + ''', ''' + // id_terminal
           sgTerminales.Cells[1,vRow] + ''', ' + // hora
           sgTerminales.Cells[2,vRow]  + ', ' + // cupo
           sgTerminales.Cells[3,vRow]  + ', ''' + // pie
           estatus + ''', ' +   // Estatus
           lsCbx_ruta.CurrentID + ',' +// Ruta
           IntToStr(li_visibleWeb) +
           ', NULL);';

   if EjecutaSQL(ssql, lq_query, _LOCAL) then
      ;

   sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                'SELECT NOW(), ''1730'', :ssql';
   lq_query.SQL.Clear;
   lq_query.SQL.Add(sentencia);
   lq_query.Params[0].AsString := ssql;
   lq_query.ExecSQL;

   if (vAuto = 1) and (chkCorridaDeVacio.Checked) then begin//replicamos a la terminal remota el detalle
     lq_query.SQL.Clear;
     sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                  'SELECT NOW(), ''' +
                  ga_datos[0] +
                  ''', :ssql';
     lq_query.SQL.Add(sentencia);
     lq_query.Params[0].AsString := ssql;
     lq_query.ExecSQL;

     sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                  'SELECT NOW(), ''1730'', :ssql';
     lq_query.SQL.Clear;
     lq_query.SQL.Add(sentencia);
     lq_query.Params[0].AsString := ssql;
     lq_query.ExecSQL;
   end;

   for vRow := 2 to sgTerminales.RowCount - 1 do
     if esAutomatizada(dsTerminales.IDOf(sgMaximos.Cells[0, vRow])) then begin
        if sgTerminales.Cells[_COL_CHKC, vRow] = 'S' then begin
           ssql := 'INSERT INTO PDV_T_CORRIDA_D(ID_CORRIDA, FECHA, ID_TERMINAL, HORA, CUPO, PIE, ESTATUS, ID_RUTA, VENDIBLE_ONLINE, TRAB_ID) VALUES(''' +
                   nueva_corrida  + ''', ''' + // id_corrida
                   FormatDateTime('YYYY-MM-DD', dtpFechaSalida.Date) + ''', ''' +  // Fecha
                   dsTerminales.IDOf(sgMaximos.Cells[0, vRow])  + ''', ''' + // id_terminal
                   sgTerminales.Cells[1,vRow] + ''', ' + // hora
                   sgTerminales.Cells[2,vRow]  + ', ' + // cupo
                   sgTerminales.Cells[3,vRow]  + ', ''' + // pie
                   estatus + ''', ' +   // Estatus
                   lsCbx_ruta.CurrentID + ',' +// Ruta
                   IntToStr(li_visibleWeb) +
                   ', NULL);';

           lq_query.SQL.Clear;
           sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                        'SELECT NOW(), ''' +
                        dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) +
                        ''', :sql';

           lq_query.SQL.Add(sentencia);
           lq_query.Params[0].AsString := ssql;
           lq_query.ExecSQL;
           EjecutaSQL(ssql, lq_query, _SERVIDOR_CENTRAL);
        end;//fin S
     end;

     // Guardo el detalle de los ocupantes de la local y las remotas
     vRow := 1;
     for vCol := 1 to sgMaximos.ColCount - 1 do begin
        if sgTerminales.Cells[_COL_CHKC, vRow] = 'S' then begin
           ssql := 'INSERT INTO PDV_T_CORRIDA_OCUPANTE(ID_OCUPANTE, MAXIMO, ID_CORRIDA, FECHA, ID_TERMINAL) VALUES(' +
                   sgMaximos.Cells[vCol, 0] + ', ' +  // id_ocupante
                   sgMaximos.Cells[vCol, vRow] + ', ''' +  // maximos
                   nueva_corrida + ''', ''' + // id_corrida
                   FormatDateTime('YYYY-MM-DD', dtpFechaSalida.Date) + ''', ''' +  // Fecha
                   dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) + ''');'; // id_terminal
           EjecutaSQL(ssql, lq_query, _LOCAL);
        end;///fin S
     end;

   for vRow := 2 to sgMaximos.RowCount - 1 do
     for vCol := 1 to sgMaximos.ColCount - 1 do
       if esAutomatizada(dsTerminales.IDOf(sgMaximos.Cells[0, vRow])) then begin
          if sgTerminales.Cells[_COL_CHKC, vRow] = 'S' then begin
             ssql := 'INSERT INTO PDV_T_CORRIDA_OCUPANTE(ID_OCUPANTE, MAXIMO, ID_CORRIDA, FECHA, ID_TERMINAL) VALUES(' +
                     sgMaximos.Cells[vCol, 0] + ', ' +  // id_ocupante
                     sgMaximos.Cells[vCol, vRow] + ', ''' +  // maximos
                     nueva_corrida + ''', ''' + // id_corrida
                     FormatDateTime('YYYY-MM-DD', dtpFechaSalida.Date) + ''', ''' +  // Fecha
                     dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) + ''');'; // id_terminal
             lq_query.SQL.Clear;
             sentencia := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                          'SELECT NOW(), ''' +
                          dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) +
                          ''', :sql';
             lq_query.SQL.Add(sentencia);
             lq_query.Params[0].AsString := ssql;
             lq_query.ExecSQL;
          end;//fin S
       end;
       Application.MessageBox(PWideChar(format('Nueva corrida dada de alta con el identificador: %s',[nueva_corrida])),'Atención', _OK);
       lsCbx_servicio.ItemIndex := -1;
       lsCbx_bus.ItemIndex := -1;
    //UnChecked y regresa a normal
    ///limpiar el detalle de la ruta
    ///  sgTerminales limpiarlo
        chkCorridaDeVacioClick(Sender);
        lbDetalle.Caption := '';
        if length(ls_msg_conexion) > 0 then begin
            mem_conexion.Visible := True;
            mem_conexion.Lines.Add(ls_msg_conexion);
        end;
        limpiaTerminales();
        chk_web.Checked := true;

 end else
  Application.MessageBox(PWideChar(format('Error al insertar la nueva corrida.',[])),'Error', _ERROR);
end;

procedure TfrmExtras.acSalirExecute(Sender: TObject);
begin
   Close;
end;

function TfrmExtras.buscarCorridaExiste(sterminal: string; fecha: TDate;
                                        hora: TTime): boolean;
var
    lq_qry : TSQLQuery;
    lb_ok  : Boolean;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add('SELECT ID_CORRIDA ');
    lq_qry.SQL.Add('FROM PDV_T_CORRIDA_D D');
    lq_qry.SQL.Add('WHERE D.ID_TERMINAL = :sterminal AND D.FECHA = :fecha AND D.HORA = :hora');
    lq_qry.Params[0].AsString := sterminal;
    lq_qry.Params[1].AsDate := fecha;
    lq_qry.Params[2].AsTime := hora;
    lq_qry.Open;
    if not lq_qry.IsEmpty then
        lb_ok := True
    else
        lb_ok := False;
    Result := lb_ok;
end;

function TfrmExtras.cargarCorrida(id_corrida: String): Boolean;
begin
 cargarCupos(id_corrida);
 gRow := 1;
 cargarMaximos(id_corrida);
end;

function TfrmExtras.cargarCupos(id_corrida: String): Boolean;

Procedure asignar(terminal : String; hora : TTime; cupo, pie : String);
var
 vRow : Integer;
 fin : Boolean;
Begin
 fin := False;
 vRow := 1;
 while not fin do begin
   if terminal = sgTerminales.Cells[_COL_TERMINAL, vRow] then begin
     sgTerminales.Cells[_COL_HORA, vRow] := FormatDateTime('HH:nn', hora);
     sgTerminales.Cells[_COL_CUPO, vRow] := cupo;
     sgTerminales.Cells[_COL_PIE, vRow] := pie;
     sgTerminales.Cells[_COL_CHKC, vRow] := 'S';
     fin := True;
   end;
   inc(vRow);
   if vRow > sgTerminales.RowCount then
     fin := True;
 end;
End;

var
  hora : TTime;
  terminal,
  cupo,
  pie : String;
begin
 ssql := 'SELECT T.DESCRIPCION, D.HORA, D.CUPO, D.PIE FROM PDV_C_ITINERARIO_D ' +
         'AS D LEFT OUTER JOIN T_C_TERMINAL AS T ON D.ID_TERMINAL = T.ID_TERMINAL ' +
         'WHERE D.ID_CORRIDA = ''' + id_corrida + '''';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then begin
   while not lq_query.Eof do Begin
     terminal := lq_query.FieldByName('DESCRIPCION').AsString;
     hora := lq_query.FieldByName('HORA').AsDateTime;
     cupo := lq_query.FieldByName('CUPO').AsString;
     pie := lq_query.FieldByName('PIE').AsString;
     asignar(terminal, hora, cupo, pie);
     lq_query.Next;
   End;
 end;
 lq_query.Close;
end;


procedure TfrmExtras.cargarDetalleRuta(id_ruta: Integer);
var
 sp : TSQLStoredProc;
 n,
 vRow, li_contador : Integer;
begin
 sp := TSQLStoredProc.Create(Self);
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_DETALLE_RUTA';
   sp.Params.ParamByName('_ID_RUTA').AsInteger := id_ruta;
   sp.Open;
   sp.First;
   vRow := 1;
   while not sp.Eof do begin
     if VarIsNull(sp['ORIGEN']) then
       inc(li_contador)
//       Application.MessageBox(PWideChar(format('No existe una terminal en la base de datos.',[])),'Error', _ERROR)
     else begin
       sgTerminales.Cells[_COL_TERMINAL,vRow] := sp['ORIGEN'];
       sgTerminales.Cells[_COL_CUPO,vRow] := IntToStr(maximoOcupantesActual);
       sgTerminales.Cells[_COL_PIE,vRow] := '0';
       sgTerminales.Cells[_COL_HORA,vRow] := '';
       sgTerminales.Cells[_COL_CHKC,vRow] := 'S';
       sgMaximos.Cells[0,vRow] := sp['ORIGEN'];
//checkBox en el grid
       inc(vRow);
     end;
     sp.Next;
   end;
   sgTerminales.RowCount := vRow;
   sgMaximos.RowCount := vRow;
   if vRow >= 2 then
     sgTerminales.FixedRows := 1;
   if (li_contador > 0) and (vRow = 1) then
        Application.MessageBox(PWideChar(format('No existe una terminal en la base de datos.',[])),'Error', _ERROR);
 finally
   sp.Free;
 end;
end;



function TfrmExtras.cargarMaximos(id_corrida: String): Boolean;
Function colDe(valor : String) : Integer;
var
 vCol : Integer;
Begin
 vCol := 1;
 while vCol <= sgMaximos.ColCount -1 do Begin
   if sgMaximos.Cells[vCol,0] = valor then Begin
     result := vCol;
     vCol := sgMaximos.ColCount;
   End;
   inc(vCol);
 End;
End;


Function rowDe(valor : String) : Integer;
 Var
  vRow : Integer;
 Begin
  vRow := 1;
  while vRow <= sgMaximos.RowCount -1 do Begin
    if sgMaximos.Cells[0, vRow] = valor then Begin
      result := vRow;
      vRow :=  sgMaximos.RowCount;
    End;
    Inc(vRow);
  End;
 End;

begin
 result := False;
 ssql := 'SELECT T.DESCRIPCION, O.ID_OCUPANTE, O.MAXIMO FROM PDV_C_ITINERARIO_OCUPANTE AS O ' +
         'LEFT JOIN T_C_TERMINAL AS T ON O.ID_TERMINAL = T.ID_TERMINAL WHERE O.ID_CORRIDA = ''' + id_corrida + '''';

 if EjecutaSQL(ssql, lq_query, _LOCAL) then begin
   while not lq_query.Eof do Begin
     sgMaximos.Cells[colDe(lq_query.FieldByName('ID_OCUPANTE').AsString),
                     rowDe(lq_query.FieldByName('DESCRIPCION').AsString)] :=
                     lq_query.FieldByName('MAXIMO').AsString;
     lq_query.Next;
   End;
 end;
 lq_query.Close;
 copiarMaximos(False);
end;

procedure TfrmExtras.cargarOcupantes;
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
     sgMaximos.Cells[vRow, 0] := lq_query.FieldByName('ID_OCUPANTE').AsString;

     inc(vRow);
     lq_query.Next;
   end;
   sgOcupantes.RowCount := vRow;
   sgMaximos.ColCount := vRow;

 end;
 lq_query.close;

end;

procedure TfrmExtras.cargarTerminales;
begin
 ssql := 'SELECT ID_TERMINAL, DESCRIPCION  FROM T_C_TERMINAL WHERE FECHA_BAJA IS NULL;';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then
   while not lq_query.Eof do begin
     dsTerminales.Add(lq_query.FieldByName('ID_TERMINAL').AsString, lq_query.FieldByName('DESCRIPCION').AsString);
     lq_query.Next;
   end;
end;

procedure TfrmExtras.cargarTerminalesAutomatizadasPara(id_ruta: integer);
begin
terminalesAutomatizadas.Clear;
 ssql := 'SELECT T.DESTINO FROM T_C_RUTA_D AS R JOIN T_C_TRAMO AS T ON ' +
         'R.ID_TRAMO = T.ID_TRAMO WHERE R.ID_RUTA = '  +
         IntToStr(id_ruta) +
         ' AND T.DESTINO IN (SELECT ID_TERMINAL FROM PDV_C_TERMINAL WHERE ' +
         'ESTATUS = ''A'' AND TIPO = ''T'') AND R.ORDEN >= (SELECT D.ORDEN ' +
         'FROM T_C_RUTA_D D INNER JOIN  T_C_TRAMO T ON T.ID_TRAMO = D.ID_TRAMO ' +
         'WHERE ID_RUTA = ' +
         IntToStr(id_ruta) +
         ' AND T.ORIGEN =''' +
         gs_terminal +
         ''') UNION ALL SELECT ID_TERMINAL AS DESTINO FROM PDV_C_TERMINAL WHERE TIPO = ''S''';

 if EjecutaSQL(ssql, lq_query, _LOCAL) then Begin
   while not lq_query.Eof  do Begin
     terminalesAutomatizadas.Add(lq_query.FieldByName('DESTINO').AsString);

     lq_query.Next;
   End;
 End;
 lq_query.Close;
end;

procedure TfrmExtras.chkCorridaDeVacioClick(Sender: TObject);
begin
    if chkCorridaDeVacio.Checked then begin
        if gli_opcion_remota = 0 then begin
            ShowMessage('Genera corridas de vacio de la terminal : '+ gs_terminal + ' hacia sus diferentes destinos');
            ssql := 'SELECT ID_RUTA,  CONCAT(ORIGEN , ''-'' , DESTINO, '' - '', ID_RUTA) ' +
                    'FROM T_C_RUTA WHERE ORIGEN = ''' +
                    gs_terminal + ''' ORDER BY 2;';

        end;
        if gli_opcion_remota = 1 then begin
            ShowMessage('Genera corridas de vacio desde cualquier terminal, hacia sus diferentes destinos');
            ssql := 'SELECT ID_RUTA,  CONCAT(ORIGEN , ''-'' , DESTINO, '' - '', ID_RUTA) ' +
                                         'FROM T_C_RUTA ORDER BY 2;';
        end;
        if EjecutaSQL(ssql,lq_query,_LOCAL)then Begin
           LlenarComboBox(lq_query,lsCbx_ruta, false);
           lsCbx_ruta.SetFocus;
           lbDetalle.Caption := '';
           limpiaTerminales();
        end;

        sgOcupantes.Enabled := False;
    end else begin
        ssql := 'SELECT ID_RUTA,  CONCAT(ORIGEN , ''-'' , DESTINO, '' - '', ID_RUTA) ' +
                'FROM T_C_RUTA WHERE ORIGEN = ''' +
                gs_terminal + ''' ORDER BY 2;';
        if EjecutaSQL(ssql,lq_query,_LOCAL)then Begin
           LlenarComboBox(lq_query,lsCbx_ruta, false);
           lsCbx_ruta.SetFocus;
           lbDetalle.Caption := '';
           limpiaTerminales();
        end;
        sgOcupantes.Enabled := True;
    end;
end;

procedure TfrmExtras.copiarMaximos(nuevos: Boolean);
var
 n : Integer;
begin
 if nuevos then begin
   for n := 1 to sgOcupantes.RowCount - 1 do begin
     sgMaximos.Cells[n, sgTerminales.Row] := sgOcupantes.Cells[1, n];
   end;
 end else begin
   for n := 1 to sgMaximos.ColCount - 1 do begin
     sgOcupantes.Cells[1,n] := sgMaximos.Cells[n, gRow];
   end;
  end;

end;

procedure TfrmExtras.dtpFechaSalidaChange(Sender: TObject);
var
    ld_fecha : TDate;
begin
    ld_fecha := dtpFechaSalida.Date;

    if chkCorridaDeVacio.Checked = False then begin
      if ld_fecha < now then begin
        ShowMessage('No se puede generar corridas extras para dias anteriores');
        dtpFechaSalida.Date := Now;
        dtpFechaSalida.SetFocus;
      end;
    end else begin
        if gli_guiaV_anterior = 0 then begin // puede hacer las corridas de dias anteriores
          ShowMessage('No se puede generar corridas de vacio para dias anteriores');
          dtpFechaSalida.Date := Now;
          dtpFechaSalida.SetFocus;
        end;

    end;
end;

procedure TfrmExtras.dtpHoraSalidaChange(Sender: TObject);
begin
 sgTerminales.Cells[_COL_HORA,1] := FormatDateTime('HH:mm', dtpHoraSalida.Time);
end;

function TfrmExtras.esAutomatizada(terminal: String): Boolean;
var
 n : Integer;
begin
 result := False;
 for n := 0 to terminalesAutomatizadas.Count - 1 do
   if terminalesAutomatizadas[n] = terminal then begin
     result := True;
     Break;
   end;
end;

procedure TfrmExtras.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 gds_actions.ID.Clear;
 gds_actions.Value.Clear;
 lq_query.Close;
 lq_query.Free;
 dsOcupantes.Free;
 dsCupoBuses.Free;
 terminalesAutomatizadas.Free;
 dsTerminales.Free;
end;

procedure TfrmExtras.FormShow(Sender: TObject);
Begin
   gds_actions.ID.Clear;
   gds_actions.Value.Clear;
   sgTerminales.Cells[_COL_TERMINAL,0] := 'Terminales';
   sgTerminales.ColWidths[_COL_TERMINAL] := 180;
   sgTerminales.Cells[_COL_HORA,0] := 'H. salida';
   sgTerminales.ColWidths[_COL_HORA] := 50;
   sgTerminales.Cells[_COL_CUPO,0] := 'Cupo';
   sgTerminales.ColWidths[_COL_CUPO] := 30;
   sgTerminales.Cells[_COL_PIE,0] := 'Pie';
   sgTerminales.ColWidths[_COL_PIE] := 25;
   sgTerminales.Cells[_COL_CHKC, 0] := 'Envía';
   sgTerminales.ColWidths[_COL_CHKC] := 35;

   lq_query := TSQLQuery.Create(nil);
   lq_query.SQLConnection := DM.Conecta;

   dsTerminales := TDualStrings.Create;
   cargarTerminales;

   dsCupoBuses := TDualStrings.Create;
   llenarBuses;
   dsOcupantes := TDualStrings.Create;
   cargarOcupantes;

   if EjecutaSQL(_QUERY_VACIO_CB, lq_query,_LOCAL) then begin
       if lq_query['VALOR'] = 1 then
           chkCorridaDeVacio.Visible := True
       else
           chkCorridaDeVacio.Visible := False
   end;

   if EjecutaSQL(Format(_SER_SERVICIO_EMPRESA,[gs_terminal]),lq_query,_LOCAL)then Begin
     LlenarComboBox(lq_query,lsCbx_servicio, True);
   End;

   ssql := 'SELECT ID_RUTA,  CONCAT(ORIGEN , ''-'' , DESTINO, '' - '', ID_RUTA) ' +
           'FROM T_C_RUTA WHERE ORIGEN = ''' +
           gs_terminal + ''' ORDER BY 2;';
   gli_opcion_remota := 0;
   if EjecutaSQL(Format(_qry_guias_remotas_vacio,[gs_trabid,gs_trabid]), lq_query, _LOCAL) then begin
      if VarIsNull(lq_query['ID_PRIVILEGIO']) then begin//local
              ;
      end else begin
//validar si tiene el parametro para las guias remotas
          if lq_query['ID_PRIVILEGIO'] = 207 then begin//remoto
              if EjecutaSQL(_qry_parametro_28, lq_query, _LOCAL) then begin
                  if lq_query['VALOR']  = 1 then begin
                     gli_opcion_remota := 1;
                  end;
              end;
          end;
      end;
   end;

   if EjecutaSQL(ssql,lq_query,_LOCAL)then Begin
     LlenarComboBox(lq_query,lsCbx_ruta, false);
   end;

   dtpFechaSalida.Date := now;

   dtpHoraSalida.Time :=  StrToTime(FormatDateTime('HH:nn', now()));
   maximoOcupantesActual := 0;
   gRow := -1;
   maximoPie := obtenerMaximoPie;
   terminalesAutomatizadas := TStringList.Create;
   lsCbx_servicio.SetFocus;
   gli_guiaV_anterior := getPermisoCorridaVacio();
end;

function TfrmExtras.getPermisoCorridaVacio(): integer;
var
    lq_qry : TSQLQuery;
    ls_sql : String;
    li_result : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    ls_sql := 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 29';
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add(ls_sql);
    lq_qry.Open;
    if not lq_qry.IsEmpty then
      li_result := lq_qry['VALOR']
    else
      li_result := 0;
    lq_qry.Free;
    lq_qry := nil;
    Result := li_result;
end;

function TfrmExtras.guardarCorrida(sterminal : String; fecha: TDate; hora: TTime; id_tipo_autobus,
  tiposervicio, id_ruta: Integer): String;
var
 sp : TSQLStoredProc;
begin
 sp := TSQLStoredProc.Create(Self);
 Result := '';
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_NUEVO_EXTRA';
   sp.Params.ParamByName('_ID_TERMINAL').AsString := sterminal;
   sp.Params.ParamByName('_FECHA').AsDate := fecha;
   sp.Params.ParamByName('_HORA').AsTime := hora;
   sp.Params.ParamByName('_ID_TIPO_AUTOBUS').AsInteger := id_tipo_autobus;
   sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := tiposervicio;
   sp.Params.ParamByName('_ID_RUTA').AsInteger := id_ruta;
   sp.Params.ParamByName('_CREADO_POR').AsString := gs_trabid;
   sp.Open;
   sp.First;
   Result := sp.FieldByName('NUEVA_CORRIDA').AsString;
   sp.Close;
 finally
   sp.Free;
 end;
end;


procedure TfrmExtras.limpiaTerminales;
var
    li_row, li_col : integer;
begin
    for li_row := 0  to sgTerminales.RowCount do begin
      for li_col := 0  to sgTerminales.ColCount do begin
          sgTerminales.Cells[li_col, li_row] := '';
      end;
    end;
end;

procedure TfrmExtras.llenarBuses;
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

procedure TfrmExtras.llenarConCeros(grid: TStringGrid);
var
 vRow,
 vCol : Integer;
begin
 for vRow := 1 to grid.RowCount - 1 do
   for vCol := 1 to grid.ColCount - 1 do
     grid.Cells[vCol, vRow] := '0';
end;

procedure TfrmExtras.lsCbx_busClick(Sender: TObject);
begin
 if lsCbx_bus.ItemIndex >= 0  then
   maximoOcupantesActual := StrToInt(dsCupoBuses.Value[lsCbx_bus.ItemIndex])
end;

procedure TfrmExtras.lsCbx_rutaClick(Sender: TObject);
var
 id_corrida : String;
begin
 if lsCbx_ruta.ItemIndex >= 0 then Begin
   cargarDetalleRuta(StrToInt(lsCbx_ruta.CurrentID));
   llenarConCeros(sgMaximos);
   dtpHoraSalidaChange(Sender);
   pintaDetalleCompletoRuta(lsCbx_ruta.CurrentID);
   if (lsCbx_servicio.ItemIndex > -1) and (lsCbx_bus.ItemIndex > -1)
   and (lsCbx_ruta.ItemIndex > -1) then begin
     ssql := 'SELECT ID_CORRIDA FROM PDV_C_ITINERARIO WHERE ID_RUTA = ''' +
             lsCbx_ruta.CurrentID +
             ''' AND TIPOSERVICIO = ' +
             lsCbx_servicio.CurrentID +
             ' AND ID_TIPO_AUTOBUS = ' +
             lsCbx_bus.CurrentID +
             ' LIMIT 1';
     if EjecutaSQL(ssql, lq_query, _LOCAL) then
       if not lq_query.Eof then begin
         id_corrida := lq_query.FieldByName('ID_CORRIDA').AsString;
         lq_query.Close;
         cargarCorrida(id_corrida);
       end else begin
         lq_query.Close;
         gRow := 1;
         copiarMaximos(False);
       end;
   end;
 End;
end;

function TfrmExtras.obtenerMaximoPie: Integer;
begin
 ssql := 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 10;';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then
   result := lq_query.FieldByName('VALOR').AsInteger
 else
   result := 10;
 lq_query.Close;
end;

procedure TfrmExtras.pintaDetalleCompletoRuta(id_ruta: String);
var
 sp : TSQLStoredProc;
 begin
 sp := TSQLStoredProc.Create(Self);
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_DETALLE_COMPLETO_RUTA';

   sp.Params.ParamByName('_ID_RUTA').AsInteger := StrToInt(id_ruta);
   sp.Open;
   sp.First;
   if not VarIsNull(sp['RESULTADO']) then
     lbDetalle.Caption := sp['RESULTADO']
   else
     Application.MessageBox(PWideChar(format('No existe una terminal en la base de datos.',[])),'Error', _ERROR);

   sp.Close;
 finally
   sp.Free;
 end;

end;

procedure TfrmExtras.rectifica(row: Integer);
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

   sgTerminales.Cells[_COL_CHKC, row] := UpperCase(sgTerminales.Cells[_COL_CHKC, row]);

end;


procedure TfrmExtras.sgOcupantesExit(Sender: TObject);
begin
 copiarMaximos(True);
end;

procedure TfrmExtras.sgOcupantesKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in _CARACTERES_VALIDOS_OCUPANTES) then
   Key := #0

end;

procedure TfrmExtras.sgTerminalesExit(Sender: TObject);
begin
 rectifica(sgTerminales.Row);
end;

procedure TfrmExtras.sgTerminalesKeyPress(Sender: TObject; var Key: Char);
begin
 // No dejo editar la primera hora.
 if (sgTerminales.Row = 1) and (sgTerminales.Col = 1) then
   key := #0
 else if not (key in _CARACTERES_VALIDOS_TERMINALES) then
   Key := #0;

end;

procedure TfrmExtras.sgTerminalesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 // Si es una nueva celda rectifica la anterior.
 if (gRow <> ARow) then
   if gRow > 0 then
     rectifica(gRow);
 gRow := ARow;
 copiarMaximos(False);
end;



function TfrmExtras.validarCupos: Boolean;
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

function TfrmExtras.validarDatos: Boolean;
begin
 result := False;
 if (lsCbx_ruta.ItemIndex > -1) and (lsCbx_servicio.ItemIndex > -1) and (lsCbx_bus.ItemIndex > -1 )
    and (validarHorarios) and (validarCupos) and (validarMaximos) then
   result := True;
end;



function TfrmExtras.validarHorarios: Boolean;
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

function TfrmExtras.validarMaximos: Boolean;
var
 vRow,
 vCol,
 total : Integer;
begin
 Result := false;
 Result := false;
 for vRow := 1 to sgMaximos.RowCount - 1 do Begin
   total := 0;
    try
     for vCol := 1 to sgMaximos.ColCount - 1 do
       total := total + StrToInt(sgMaximos.Cells[vCol, vRow]);
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

end.
