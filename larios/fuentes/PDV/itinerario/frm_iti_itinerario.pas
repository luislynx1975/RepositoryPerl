unit frm_iti_itinerario;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsNumericEdit, ExtCtrls, lsCombobox, DB,
  Grids, ComCtrls, FMTBcd, Buttons, ActnList, Data.SqlExpr,
  PlatformDefaultStyleActnCtrls, ActnMan, comun, ToolWin, ActnCtrls,
  System.Actions;

type
  TFrm_itinerario = class(TForm)
    GroupBox1: TGroupBox;
    cbDomingo: TCheckBox;
    cbLunes: TCheckBox;
    cbMartes: TCheckBox;
    cbMiercoles: TCheckBox;
    cbJueves: TCheckBox;
    cbViernes: TCheckBox;
    cbSabado: TCheckBox;
    GroupBox2: TGroupBox;
    lsCbx_bus: TlsComboBox;
    Label1: TLabel;
    lsCbx_servicio: TlsComboBox;
    Servicio: TLabel;
    lsCbx_ruta: TlsComboBox;
    Label2: TLabel;
    Label5: TLabel;
    dtpHoraSalida: TDateTimePicker;
    ActionManager1: TActionManager;
    acSalir: TAction;
    acEntreSemana: TAction;
    acFinDeSemana: TAction;
    acDiario: TAction;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    sgOcupantes: TStringGrid;
    sgTerminales: TStringGrid;
    acNueva: TAction;
    acGuardar: TAction;
    acActualizar: TAction;
    sgMaximos: TStringGrid;
    gbBusqueda: TGroupBox;
    lscbServicios: TlsComboBox;
    lscbRuta: TlsComboBox;
    chbServicio: TCheckBox;
    chbRuta: TCheckBox;
    chbCorrida: TCheckBox;
    edCorrida: TEdit;
    acBusqueda: TAction;
    cbOrigen: TlsComboBox;
    chbOrigen: TCheckBox;
    cbDestino: TlsComboBox;
    chbDestino: TCheckBox;
    sgResultado: TStringGrid;
    ActionToolBar1: TActionToolBar;
    acLocalizar: TAction;
    BitBtn6: TBitBtn;
    acEliminarCorrida: TAction;
    BitBtn7: TBitBtn;
    acMostrarDetalle: TAction;
    BitBtn8: TBitBtn;
    lID_corrida: TLabel;
    acModificar: TAction;
    pRuta: TPanel;
    lbDetalle: TLabel;
    lblCreadoPor: TLabel;
    sagDias: TStringGrid;
    btnEstablecerDias: TBitBtn;
    Label3: TLabel;
    cmb_iva: TlsComboBox;
    procedure FormShow(Sender: TObject);
    procedure lsCbx_rutaClick(Sender: TObject);
    procedure acSalirExecute(Sender: TObject);
    procedure acEntreSemanaExecute(Sender: TObject);
    procedure acFinDeSemanaExecute(Sender: TObject);
    procedure acDiarioExecute(Sender: TObject);
    procedure sgOcupantesKeyPress(Sender: TObject; var Key: Char);
    procedure dtpHoraSalidaChange(Sender: TObject);
    procedure sgTerminalesKeyPress(Sender: TObject; var Key: Char);
    procedure sgTerminalesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure acGuardarExecute(Sender: TObject);
    procedure lsCbx_busClick(Sender: TObject);
    procedure sgOcupantesExit(Sender: TObject);
    procedure sgTerminalesExit(Sender: TObject);
    procedure acBusquedaExecute(Sender: TObject);
    procedure acLocalizarExecute(Sender: TObject);
    procedure acEliminarCorridaExecute(Sender: TObject);
    procedure acMostrarDetalleExecute(Sender: TObject);
    procedure acModificarExecute(Sender: TObject);
    procedure acNuevaExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbDomingoClick(Sender: TObject);
    procedure btnEstablecerDiasClick(Sender: TObject);
  private
    lq_query : TSQLQuery;
    dsTerminales,
    dsCupoBuses,
    dsOcupantes : TDualStrings;
    gId_Corrida : String;
    gRow : Integer;

    maximoPie,
    maximoOcupantesActual : Integer;
    ssql : String;
    terminalesAutomatizadas : TStrings;

    Procedure cargarOcupantes;
    Procedure cargarDetalleRuta(id_ruta : Integer);
    Procedure rectifica(row : Integer);
    function guardarCorrida(hora: TTime;  id_tipo_autobus, tiposervicio,
               id_ruta: Integer; Creado_Por: String; iva_corrida : integer): String;

    Function modificarCorrida(hora : TTime; lunes, martes, miercoles, jueves,
             viernes, sabado, domingo : Char; id_tipo_autobus, tiposervicio,
             id_ruta: integer; id_corrida : String) :  Integer;
    Function validarBusqueda : Boolean;
    Function cargarCorrida(id_corrida : String) : Boolean;
    Function cargarGenerales(id_corrida : String) : Boolean;
    Function cargarCupos(id_corrida : String) : Boolean;
    Function cargarMaximos(id_corrida : String) : Boolean;
    function validarDatos: Boolean;
    function validarHorarios: Boolean;
    Function valorDe(checkBox : TCheckBox) : Char;  overload;
    Function valorDe(valor : Char) : Boolean; overload;
    Function existeCorrida(hora: TTime; id_tipo_autobus, tiposervicio, id_ruta : Integer; id_corrida : String) : String;
    Procedure llenarBuses;
    Procedure copiarMaximos(nuevos : Boolean );
    Procedure llenarConCeros(grid : TStringGrid );
    Procedure llenarSinDias(grid: TStringGrid);
    Function validarDias : Boolean;
    Function validarCupos : Boolean;
    Function obtenerMaximoPie : Integer;
    Function validarMaximos : Boolean;
    Procedure cargarTerminales;
    Procedure cargarTodasLasTerminalesAutomatizadas;
    Procedure replicarTodos(sentencia : String);
    Procedure pintaDetalleCompletoRuta(id_ruta : String );
    Procedure CopiarDias(nuevos: Boolean);
    procedure limpiaDatos();
  public
    { Public declarations }
  end;

var
  Frm_itinerario: TFrm_itinerario;

implementation

uses DMdb,  u_autobus, U_itinerario, u_main;

{$R *.dfm}



procedure TFrm_itinerario.acGuardarExecute(Sender: TObject);
Var
 vCol, vRow : Integer;
 corrida_existente, nueva_corrida : String;
 _lunes, _martes, _miercoles, _jueves, _viernes, _sabado, _domingo : String;
 _bus, _servicio, _ruta: Integer;
begin
 if not AccesoPermitido(171, True) then
   exit;
 lsCbx_servicio.SetFocus;
 if NOT validarDatos then begin
   Application.MessageBox('Faltan datos, favor de verificarlos.','Atención', _ERROR);
   exit;
 end;

 corrida_existente := existeCorrida(dtpHoraSalida.Time, StrToInt(lsCbx_bus.CurrentID), StrToInt(lsCbx_servicio.CurrentID), StrToInt(lsCbx_ruta.CurrentID), _NUEVA) ;
 if corrida_existente <> '' then begin
   Application.MessageBox(PWideChar(format('La corrida ya existe con el identificador: %s',[corrida_existente])),'Atención', _ATENCION);
   exit;
 end;
  _lunes:=    valorDe(cbLunes);
  _martes:=   valorDe(cbMartes);
  _miercoles:=valorDe(cbMiercoles);
  _jueves:=   valorDe(cbJueves);
  _viernes:=  valorDe(cbViernes);
  _sabado:=   valorDe(cbSabado);
  _domingo:=  valorDe(cbDomingo);
  _bus:= StrToInt(lsCbx_bus.CurrentID);
  _servicio:= StrToInt(lsCbx_servicio.CurrentID);
  _ruta:= StrToInt(lsCbx_ruta.CurrentID);

 // guardar el master de la corrida PDV_C_ITINERARIO
 nueva_corrida := guardarCorrida(dtpHoraSalida.Time,
                                 _bus,
                                 _servicio,
                                 _ruta,
                                 comun.gs_trabid, StrToInt(cmb_iva.CurrentID));

 if nueva_corrida <> '' then Begin
   // Replico el Master de la corrida
   ssql := 'INSERT INTO PDV_C_ITINERARIO(ID_CORRIDA, HORA, ID_TIPO_AUTOBUS, TIPOSERVICIO, ID_RUTA, CREADO_POR,IVA) '+
           ' VALUES(' +
           QuotedStr(nueva_corrida)  + ', ' +
           QuotedStr(FormatDateTime('HH:nn', dtpHoraSalida.Time)) + ', ' +
           intToStr(_bus)  + ', ' +
           intToStr(_servicio)  + ', ' +
           intToStr(_ruta) + ','+
           QuotedStr(comun.gs_trabid)+
           cmb_iva.CurrentID+
           ');';
   replicarTodos(ssql);


   // Guardar el detalle
   for vRow := 1 to sgTerminales.RowCount - 1 do begin
     ssql := 'INSERT INTO PDV_C_ITINERARIO_D(ID_TERMINAL, ID_CORRIDA, HORA, CUPO, PIE, '+
             ' LUNES, MARTES, MIERCOLES, JUEVES, VIERNES, SABADO, DOMINGO ) VALUES('''+
             dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) + ''' ,  ''' + //id_terminal
             nueva_corrida + ''' , ''' +   // id_corrida
             sgTerminales.Cells[1,vRow] + ''' , ' +   // hora
             sgTerminales.Cells[2,vRow] + ' , ' +   // cupo
             sgTerminales.Cells[3,vRow] + ' , ' +  // pie
             QuotedStr(sagDias.Cells[1, vRow])   + ' , ' + //lunes
             QuotedStr(sagDias.Cells[2, vRow])  + ' , ' +
             QuotedStr(sagDias.Cells[3, vRow]) + ' , ' +
             QuotedStr(sagDias.Cells[4, vRow])  + ' , ' +
             QuotedStr(sagDias.Cells[5, vRow]) + ' , ' +
             QuotedStr(sagDias.Cells[6, vRow])  + ' , ' +
             QuotedStr(sagDias.Cells[0, vRow]) + ');';
     EjecutaSQL(ssql, lq_query, _LOCAL);
     replicarTodos(ssql);

   end;


   // Guardar el cupo por cada detalle
   for vRow := 1 to sgMaximos.RowCount - 1 do
     for vCol := 1 to sgMaximos.ColCount - 1 do Begin
       ssql := 'INSERT INTO PDV_C_ITINERARIO_OCUPANTE(ID_TERMINAL, ID_CORRIDA, ID_OCUPANTE, MAXIMO) VALUES(''' +
               dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) + ''', ''' + // id_terminal
               nueva_corrida + ''', ' + // id_corrida
               sgMaximos.Cells[vCol, 0] + ', ' + //id_ocupante
               sgMaximos.Cells[vCol, vRow] + ');'; //maximo
       EjecutaSQL(ssql, lq_query, _LOCAL);
       replicarTodos(ssql);

     End;
   Application.MessageBox(PWideChar(format('Nueva corrida dada de alta con el identificador: %s',[nueva_corrida])),'Atención', _OK);
   //LIMPIAMOS TODOS LOS CAMPOS
   limpiaDatos;
 End else
  Application.MessageBox(PWideChar(format('Error al insertar la nueva corrida.',[])),'Error', _ERROR);
end;


procedure TFrm_itinerario.acLocalizarExecute(Sender: TObject);
begin
 if not AccesoPermitido(170, True) then
   exit;
 gbBusqueda.Visible := not gbBusqueda.Visible;
 gbBusqueda.Align := alClient;
end;

procedure TFrm_itinerario.acModificarExecute(Sender: TObject);
Var
 vCol,
 vRow : Integer;
 nueva_corrida, 
 corrida_existente : String;
Begin
 if not AccesoPermitido(172, True) then
   exit;
lsCbx_servicio.SetFocus;
// Valido que los datos esten bien
 if NOT validarDatos then begin
   Application.MessageBox('Faltan datos, favor de verificarlos.','Atención', _ERROR);
   exit;
 end;

// Verificar que no exista pareviamente la corrida
 corrida_existente := existeCorrida(dtpHoraSalida.Time, StrToInt(lsCbx_bus.CurrentID), StrToInt(lsCbx_servicio.CurrentID), StrToInt(lsCbx_ruta.CurrentID), gId_Corrida) ;
 if corrida_existente <> '' then begin
   Application.MessageBox(PWideChar(format('La corrida ya existe con el identificador: %s',[corrida_existente])),'Atención', _ATENCION);
   exit;
 end;

 // modifico el master de la corrida PDV_C_ITINERARIO
 ssql := 'UPDATE PDV_C_ITINERARIO SET HORA = ' +
         QuotedStr(FormatDateTime('HH:nn', dtpHoraSalida.Time)) +
         ', ID_TIPO_AUTOBUS = ' +
         lsCbx_bus.CurrentID + ', TIPOSERVICIO = ' +
         lsCbx_servicio.CurrentID + ', ID_RUTA = ' +
         lsCbx_ruta.CurrentID + ' WHERE ID_CORRIDA = ''' +
         gID_Corrida + ''';';
 EjecutaSQL(ssql, lq_query, _LOCAL);
 replicarTodos(ssql);

 // Elimino el detalle
 ssql := 'DELETE FROM PDV_C_ITINERARIO_D WHERE ID_CORRIDA = ''' +
         gID_Corrida + ''';';
 EjecutaSQL(ssql, lq_query, _LOCAL);
 replicarTodos(ssql);

 // Elimino los ocupantes
 ssql := 'DELETE FROM PDV_C_ITINERARIO_OCUPANTE WHERE ID_CORRIDA = ''' +
         gID_Corrida + ''';';
 EjecutaSQL(ssql, lq_query, _LOCAL);
 replicarTodos(ssql);

 // Guardar el detalle
 for vRow := 1 to sgTerminales.RowCount - 1 do begin
     ssql := 'INSERT INTO PDV_C_ITINERARIO_D(ID_TERMINAL, ID_CORRIDA, HORA, CUPO, PIE, '+
             ' LUNES, MARTES, MIERCOLES, JUEVES, VIERNES, SABADO, DOMINGO ) VALUES('''+
             dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) + ''' ,  ''' + //id_terminal
             gId_Corrida + ''' , ''' +   // id_corrida
             sgTerminales.Cells[1,vRow] + ''' , ' +   // hora
             sgTerminales.Cells[2,vRow] + ' , ' +   // cupo
             sgTerminales.Cells[3,vRow] + ' , ' +  // pie
             QuotedStr(sagDias.Cells[1, vRow])   + ' , ' + //lunes
             QuotedStr(sagDias.Cells[2, vRow])  + ' , ' +
             QuotedStr(sagDias.Cells[3, vRow]) + ' , ' +
             QuotedStr(sagDias.Cells[4, vRow])  + ' , ' +
             QuotedStr(sagDias.Cells[5, vRow]) + ' , ' +
             QuotedStr(sagDias.Cells[6, vRow])  + ' , ' +
             QuotedStr(sagDias.Cells[0, vRow]) + ');';
     EjecutaSQL(ssql, lq_query, _LOCAL);
     replicarTodos(ssql);
   end;

 // Guardar el cupo por cada detalle
 for vRow := 1 to sgMaximos.RowCount - 1 do
   for vCol := 1 to sgMaximos.ColCount - 1 do Begin
     ssql := 'INSERT INTO PDV_C_ITINERARIO_OCUPANTE(ID_TERMINAL, ID_CORRIDA, ID_OCUPANTE, MAXIMO) VALUES(''' +
             dsTerminales.IDOf(sgMaximos.Cells[0, vRow]) + ''', ''' + // id_terminal
             gId_Corrida + ''', ' + // id_corrida
             sgMaximos.Cells[vCol, 0] + ', ' + //id_ocupante
             sgMaximos.Cells[vCol, vRow] + ');'; //maximo
     EjecutaSQL(ssql, lq_query, _LOCAL);
     replicarTodos(ssql);
   End;
 Application.MessageBox(PWideChar(format('Corrida %s actualizada.',[gID_Corrida])),'Atención', _OK)
end;


procedure TFrm_itinerario.acMostrarDetalleExecute(Sender: TObject);
var
 id_corrida : String;
begin
 if (Trim(sgResultado.Cells[0, sgResultado.Row]) = '') or (sgResultado.Row < 1) then Begin
   Application.MessageBox(PWideChar(format('Debe seleccionar una corrida.',[])),'Atención', _ATENCION);
   exit;
 End;

 id_corrida := sgResultado.Cells[0, sgResultado.Row];
 gbBusqueda.Visible := False;
 gId_Corrida := id_corrida;
 cargarCorrida(id_corrida);
end;

procedure TFrm_itinerario.acNuevaExecute(Sender: TObject);
var
 vRow : Integer;
begin
 gRow := -1;
 lID_corrida.Caption := '';
 acModificar.Enabled := False;
 lsCbx_servicio.ItemIndex := -1;
 lsCbx_bus.ItemIndex:= -1;
 lsCbx_ruta.ItemIndex := -1;
 LimpiaSag(sgTerminales);
 LimpiaSag(sgMaximos);
 for vRow := 1 to sgOcupantes.RowCount - 1 do
   sgOcupantes.Cells[1,vRow] := '0';
 cbDomingo.Checked := False;
 cbLunes.Checked := False;
 cbMartes.Checked := False;
 cbMiercoles.Checked := False;
 cbJueves.Checked := False;
 cbViernes.Checked := False;
 cbSabado.Checked := False;
 gbBusqueda.Visible := False;
end;

procedure TFrm_itinerario.acBusquedaExecute(Sender: TObject);
var
 primero : Boolean;
begin

 if NOT validarBusqueda then Begin
   Application.MessageBox('Faltan datos para realizar la búsqueda, favor de verificarlos.','Atención', _ATENCION);
   exit;
 End;

 primero := True;
 ssql := 'SELECT M.ID_CORRIDA, M.HORA, M.TIPOSERVICIO, S.ABREVIACION, M.ID_RUTA, ' +
         'R.ORIGEN, R.DESTINO FROM PDV_C_ITINERARIO AS M LEFT OUTER JOIN SERVICIOS ' +
         'AS S ON M.TIPOSERVICIO = S.TIPOSERVICIO LEFT OUTER JOIN T_C_RUTA AS R ON ' +
         'M.ID_RUTA = R.ID_RUTA WHERE ';


 if chbOrigen.Checked then begin
   ssql := ssql + 'R.ORIGEN = ''' + cbOrigen.CurrentID + ''' ';
   primero := false;
 end;

 if chbDestino.Checked then begin
   if NOT primero then
     ssql := ssql + ' AND ';
   ssql := ssql + 'R.DESTINO = ''' + cbDestino.CurrentID + ''' ';
   primero := false;
 end;

  if chbServicio.Checked then begin
   if NOT primero then
     ssql := ssql + ' AND ';
   ssql := ssql + 'M.TIPOSERVICIO = ' + lscbServicios.CurrentID + ' ';
   primero := false;
 end;

  if chbRuta.Checked then begin
   if NOT primero then
     ssql := ssql + ' AND ';
   ssql := ssql + 'M.ID_RUTA = ' + lscbRuta.CurrentID + ' ';
   primero := false;
 end;

  if chbCorrida.Checked then begin
   if NOT primero then
     ssql := ssql + ' AND ';
   ssql := ssql + 'M.ID_CORRIDA = ''' + edCorrida.Text + '''';
   primero := false;
 end;
 ssql := ssql + ' ORDER BY 2';

 if EjecutaSQL(ssql, lq_query, _LOCAL) then Begin
   DataSetToSag(lq_query, sgResultado);
   if registrosDe(lq_Query) > 0 then
     sgResultado.FixedRows := 1;
 End;
 lq_query.Close;
end;


procedure TFrm_itinerario.acDiarioExecute(Sender: TObject);
begin
 cbLunes.Checked := True;
 cbMartes.Checked := True;
 cbMiercoles.Checked := True;
 cbJueves.Checked := True;
 cbViernes.Checked := True;
 cbSabado.Checked := True;
 cbDomingo.Checked := True;
 CopiarDias(True);
end;



procedure TFrm_itinerario.acEliminarCorridaExecute(Sender: TObject);
var
 id_corrida : String;
begin
 if not AccesoPermitido(173, True) then
   exit;
 if (Trim(sgResultado.Cells[0, sgResultado.Row]) = '') or (sgResultado.Row < 1) then Begin
   Application.MessageBox(PWideChar(format('Debe seleccionar una corrida.',[])),'Atención', _ATENCION);
   exit;
 End;
 id_corrida := sgResultado.Cells[0, sgResultado.Row];

 If Application.MessageBox(PWideChar(Format('¿Verdaderamente desea eliminar la corrida : %s ?', [id_corrida])), 'Atención', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION) = IDYES then Begin
   // Borro los ocupantes
   ssql := 'DELETE FROM PDV_C_ITINERARIO_OCUPANTE WHERE ID_CORRIDA = ''' +
           id_corrida + ''';';
   EjecutaSQL(ssql, lq_query, _LOCAL);
   replicarTodos(ssql);

   // Borro el detalle
   ssql := 'DELETE FROM PDV_C_ITINERARIO_D WHERE ID_CORRIDA = '''  +
           id_corrida + ''';';
   EjecutaSQL(ssql, lq_query, _LOCAL);
   replicarTodos(ssql);

   // Borro el itinerario
   ssql := 'DELETE FROM PDV_C_ITINERARIO WHERE ID_CORRIDA = ''' +
           id_corrida + ''';';
   EjecutaSQL(ssql, lq_query, _LOCAL);
   replicarTodos(ssql);
   limpiaSag(sgResultado);
   Application.MessageBox(PWideChar(format('La corrida %s fue eliminada.',[id_corrida])),'Atención', _OK)
 End;
end;

procedure TFrm_itinerario.acEntreSemanaExecute(Sender: TObject);
begin
 cbLunes.Checked := True;
 cbMartes.Checked := True;
 cbMiercoles.Checked := True;
 cbJueves.Checked := True;
 cbViernes.Checked := True;
 cbSabado.Checked := False;
 cbDomingo.Checked := False;
 CopiarDias(True);
end;

procedure TFrm_itinerario.acFinDeSemanaExecute(Sender: TObject);
begin
 cbLunes.Checked := False;
 cbMartes.Checked := False;
 cbMiercoles.Checked := False;
 cbJueves.Checked := False;
 cbViernes.Checked := False;
 cbSabado.Checked := True;
 cbDomingo.Checked := True;
 CopiarDias(True);
end;

procedure TFrm_itinerario.acSalirExecute(Sender: TObject);
begin
 Close;
end;

procedure TFrm_itinerario.btnEstablecerDiasClick(Sender: TObject);
begin
   CopiarDias(True);
end;

function TFrm_itinerario.cargarGenerales(id_corrida: String): Boolean;
procedure asignarDias(terminal, domingo, lunes, martes, miercoles, jueves, viernes, sabado: String);
var
 vRow : Integer;
 fin : Boolean;
Begin
 fin := False;
 vRow := 1;
 while not fin do begin
   if terminal = sgTerminales.Cells[_COL_TERMINAL, vRow] then begin
     sagDias.Cells[0, vRow]:= domingo;
     sagDias.Cells[1, vRow]:= lunes;
     sagDias.Cells[2, vRow]:= martes;
     sagDias.Cells[3, vRow]:= miercoles;
     sagDias.Cells[4, vRow]:= jueves;
     sagDias.Cells[5, vRow]:= viernes;
     sagDias.Cells[6, vRow]:= sabado;
     fin := True;
   end;
   inc(vRow);
   if vRow > sgTerminales.RowCount then
     fin := True;
 end;

end;
VAR terminal, lunes, martes, miercoles ,jueves, viernes, sabado, domingo: String;

begin
 ssql := 'SELECT * FROM PDV_C_ITINERARIO WHERE ID_CORRIDA = ''' + id_corrida + '''';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then begin
   lsCbx_servicio.SetID(lq_query.FieldByName('TIPOSERVICIO').AsString);
   lsCbx_bus.SetID(lq_query.FieldByName('ID_TIPO_AUTOBUS').AsString);
   lsCbx_ruta.SetID(lq_query.FieldByName('ID_RUTA').AsString);
   dtpHoraSalida.Time  := lq_query.FieldByName('HORA').AsDateTime;
   lblCreadoPor.Caption:= 'Creada por : '+ lq_query.FieldByName('CREADO_POR').AsString;
 end;
 lq_query.Close;
 lsCbx_rutaClick(nil);
// ssql := 'SELECT * FROM PDV_C_ITINERARIO_D WHERE ID_CORRIDA = ''' + id_corrida + '''';
 ssql := 'SELECT T.DESCRIPCION as ID_TERMINAL, D.ID_CORRIDA, D.HORA, D.CUPO, D. PIE, '+
         ' D.LUNES, D.MARTES, D.MIERCOLES, D.JUEVES, D.VIERNES, D.SABADO, D.DOMINGO '+
         ' FROM PDV_C_ITINERARIO_D as D JOIN T_C_TERMINAL AS T ON D.ID_TERMINAL = T.ID_TERMINAL '+
         ' WHERE ID_CORRIDA = ''' + id_corrida + '''';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then begin
   maximoOcupantesActual := StrToInt(dsCupoBuses.Value[lsCbx_bus.ItemIndex]);
   if EjecutaSQL(ssql, lq_query, _LOCAL) then begin
   while not lq_query.Eof do Begin
     terminal := lq_query.FieldByName('ID_TERMINAL').AsString;
     lunes := lq_query.FieldByName('LUNES').AsString;
     martes := lq_query.FieldByName('MARTES').AsString;
     miercoles := lq_query.FieldByName('MIERCOLES').AsString;
     jueves := lq_query.FieldByName('JUEVES').AsString;
     viernes := lq_query.FieldByName('VIERNES').AsString;
     sabado := lq_query.FieldByName('SABADO').AsString;
     domingo := lq_query.FieldByName('DOMINGO').AsString;
     asignarDias(terminal, domingo, lunes, martes, miercoles, jueves, viernes, sabado);
     lq_query.Next;
   End;
 end;
   sgTerminales.Row :=1;
 end;
 lq_query.Close;
end;



function TFrm_itinerario.cargarCupos(id_corrida: String): Boolean;
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
         fin := True;
       end;
       inc(vRow);
       if vRow > sgTerminales.RowCount then
         fin := True;
     end;
    end;
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

function TFrm_itinerario.cargarMaximos(id_corrida: String): Boolean;
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
end;

function TFrm_itinerario.cargarCorrida(id_corrida: String): Boolean;
begin
 cargarGenerales(id_corrida);
 cargarCupos(id_corrida);
 cargarMaximos(id_corrida);
 lID_corrida.Caption := 'Corrida: ' + id_corrida;
 acModificar.Enabled := True;
end;


procedure TFrm_itinerario.cargarDetalleRuta(id_ruta : Integer);
var
 sp : TSQLStoredProc;
 n,vRow, li_contador : Integer;
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
   li_contador := 0;
   while not sp.Eof do begin
     if VarIsNull(sp['ORIGEN']) then
        inc(li_contador)
     else begin
       sgTerminales.Cells[_COL_TERMINAL,vRow] := sp['ORIGEN'];
       sgTerminales.Cells[_COL_CUPO,vRow] := IntToStr(maximoOcupantesActual);
       sgTerminales.Cells[_COL_PIE,vRow] := '0';
       sgTerminales.Cells[_COL_HORA,vRow] := '';
       sgMaximos.Cells[0,vRow] := sp['ORIGEN'];
       inc(vRow);
     end;
     sp.Next;
   end;
   sgTerminales.RowCount := vRow;
   sgMaximos.RowCount := vRow;
   if vRow >= 2 then
     sgTerminales.FixedRows := 1;
   if (li_contador > 1) and (vRow = 0) then
      Application.MessageBox(PWideChar(format('No existe una terminal en la base de datos.',[])),'Error', _ERROR)
 finally
   sp.Free;
 end;
end;



procedure TFrm_itinerario.cargarOcupantes;
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


procedure TFrm_itinerario.cargarTerminales;
begin
 ssql := 'SELECT ID_TERMINAL, DESCRIPCION  FROM T_C_TERMINAL WHERE FECHA_BAJA IS NULL;';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then
   while not lq_query.Eof do begin
     dsTerminales.Add(lq_query.FieldByName('ID_TERMINAL').AsString, lq_query.FieldByName('DESCRIPCION').AsString);
     lq_query.Next;
   end;
end;

procedure TFrm_itinerario.cargarTodasLasTerminalesAutomatizadas;
begin// Todas las terminales A y tipo T excepto donde estoy generando la corrida
 ssql := 'SELECT ID_TERMINAL FROM PDV_C_TERMINAL WHERE ESTATUS = ''A'' AND ' +
         ' ID_TERMINAL <> ''' +
         gs_terminal +
         ''' ORDER BY ID_TERMINAL;';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then Begin
   while not lq_query.Eof  do Begin
     terminalesAutomatizadas.Add(lq_query.FieldByName('ID_TERMINAL').AsString);
     lq_query.Next;
   End;
 End;
 lq_query.Close;
end;

procedure TFrm_itinerario.cbDomingoClick(Sender: TObject);
begin
  // CopiarDias(True);
end;

procedure TFrm_itinerario.CopiarDias(nuevos: Boolean);
var n: Integer;
begin
   //funcion que copia los dias que pasa una corrida POR TERMINAL
   if nuevos  then begin
      sagDias.Cells[0, sgTerminales.Row] := valorDe(cbDomingo);
      sagDias.Cells[1, sgTerminales.Row] := valorDe(cbLunes);
      sagDias.Cells[2, sgTerminales.Row] := valorDe(cbMartes);
      sagDias.Cells[3, sgTerminales.Row] := valorDe(cbMiercoles);
      sagDias.Cells[4, sgTerminales.Row] := valorDe(cbJueves);
      sagDias.Cells[5, sgTerminales.Row] := valorDe(cbViernes);
      sagDias.Cells[6, sgTerminales.Row] := valorDe(cbSabado);
   end else begin
      cbDomingo.Checked:=  valorDe(sagDias.Cells[0, gRow][1]);
      cbLunes.Checked  :=  valorDe(sagDias.Cells[1, gRow][1]);
      cbMartes.Checked :=  valorDe(sagDias.Cells[2, gRow][1]);
      cbMiercoles.Checked:=valorDe(sagDias.Cells[3, gRow][1]);
      cbJueves.Checked :=  valorDe(sagDias.Cells[4, gRow][1]);
      cbViernes.Checked:=  valorDe(sagDias.Cells[5, gRow][1]);
      cbSabado.Checked :=  valorDe(sagDias.Cells[6, gRow][1]);
   end;
end;

procedure TFrm_itinerario.copiarMaximos(nuevos: Boolean);
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

procedure TFrm_itinerario.dtpHoraSalidaChange(Sender: TObject);
begin
 sgTerminales.Cells[_COL_HORA,1] := FormatDateTime('HH:mm', dtpHoraSalida.Time);
end;

function TFrm_itinerario.existeCorrida(hora: TTime; id_tipo_autobus, tiposervicio,
  id_ruta: integer; id_corrida : String): String;
begin
 Result := '';
 sql := 'SELECT ID_CORRIDA FROM PDV_C_ITINERARIO WHERE HORA = ''' +
        FormatDateTime('HH:nn', hora)  + ''' AND ID_TIPO_AUTOBUS = ' +
        intToStr(id_tipo_autobus) + ' AND TIPOSERVICIO = '  + IntToStr(tiposervicio) +
        ' AND ID_RUTA = ' + IntToStr(id_ruta);
 if id_corrida <> _NUEVA then
   sql := sql + ' AND ID_CORRIDA <> ''' + id_corrida + ' ''';
 ssql := ssql + ' ORDER BY ID_CORRIDA DESC LIMIT 1;';

 if EjecutaSQL(sql, lq_query, _LOCAL) then begin
   if not lq_query.Eof then
     Result :=  lq_query.FieldByName('ID_CORRIDA').AsString;
   lq_query.Close;
 end;
end;

procedure TFrm_itinerario.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 gds_actions.ID.Clear;
 gds_actions.Value.Clear;
 lq_query.Close;
 lq_query.Free;
 dsOcupantes.Free;
 dsCupoBuses.Free;
 dsTerminales.Free;
 terminalesAutomatizadas.Free;
end;

procedure TFrm_itinerario.FormShow(Sender: TObject);
var
 inicio : TDateTime;
begin
 gds_actions.ID.Clear;
 gds_actions.Value.Clear;
 terminalesAutomatizadas := TStringList.Create;
 inicio := now;
 maximoOcupantesActual := 0;
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
 dsTerminales := TDualStrings.Create;
 cargarTerminales;
 if EjecutaSQL(_SER_SERVICIO_ALL,lq_query,_LOCAL)then Begin
   LlenarComboBox(lq_query,lsCbx_servicio, True);
   LlenarComboBox(lq_query,lsCbServicios, True);
 End;
 if EjecutaSQL(_ITI_SELECT_RUTA,lq_query,_LOCAL)then Begin
   LlenarComboBox(lq_query,lsCbx_ruta,False);
   LlenarComboBox(lq_query,lsCbRuta,false);
 End;
 if EjecutaSQL(_QUERY_TERMINALES,lq_query,_LOCAL)then Begin
   LlenarComboBox(lq_query,cbOrigen, True);
   LlenarComboBox(lq_query,cbDestino,True);
 End;
 if EjecutaSQL(_QUERY_IVAS, lq_query, _LOCAL) then
    LlenarComboBox(lq_query,cmb_iva,false);

 gRow := -1;
 lID_corrida.Caption := '';
 maximoPie := obtenerMaximoPie;
 cargarTodasLasTerminalesAutomatizadas;
 dtpHoraSalida.Time := StrToTime(FormatDateTime('HH:nn', now)); // Para que no tenga segundos la hora.

 Caption := Caption + '    Cargado en (min:seg.mili) :' + FormatDateTime('nn:ss.zzz', now - inicio)
end;


function TFrm_itinerario.guardarCorrida(hora: TTime;  id_tipo_autobus, tiposervicio,
  id_ruta: Integer; Creado_Por: String; iva_corrida : integer): String;
var
 sp : TSQLStoredProc;
begin
 sp := TSQLStoredProc.Create(Self);
 Result := '';
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_NUEVO_ITINERARIO';
   sp.Params.ParamByName('_HORA').AsTime := hora;
   sp.Params.ParamByName('_ID_TIPO_AUTOBUS').AsInteger := id_tipo_autobus;
   sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := tiposervicio;
   sp.Params.ParamByName('_ID_RUTA').AsInteger := id_ruta;
   sp.Params.ParamByName('_CREADO_POR').AsString := Creado_Por;
   sp.Params.ParamByName('_IVA').AsInteger  := iva_corrida;
   sp.Open;
   sp.First;
   Result := sp.FieldByName('NUEVA_CORRIDA').AsString;
   sp.Close;
 finally
   sp.Free;
 end;
end;

procedure TFrm_itinerario.limpiaDatos;

begin
    lsCbx_bus.ItemIndex      := -1;
    lsCbx_servicio.ItemIndex := -1;
    lsCbx_ruta.ItemIndex     := -1;
    lscbServicios.ItemIndex  := -1;
    lscbRuta.ItemIndex       := -1;
    cmb_iva.ItemIndex        := -1;
    LimpiaSagTodo(sgOcupantes);
    LimpiaSagTodo(sgTerminales);
    LimpiaSagTodo(sgMaximos);
    LimpiaSagTodo(sgResultado);
    cbDomingo.Checked := False;
    cbLunes.Checked   := False;
    cbMartes.Checked  := False;
    cbMiercoles.Checked := False;
    cbJueves.Checked  := False;
    cbViernes.Checked := False;
    cbSabado.Checked  := False;
end;



procedure TFrm_itinerario.llenarBuses;
begin
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

procedure TFrm_itinerario.llenarConCeros(grid: TStringGrid);
var
 vRow,
 vCol : Integer;
begin
 for vRow := 1 to grid.RowCount - 1 do
   for vCol := 1 to grid.ColCount - 1 do
     grid.Cells[vCol, vRow] := '0';
end;

procedure TFrm_itinerario.llenarSinDias(grid: TStringGrid);
var
  I: Integer;
  X: Integer;
begin
   // pone en Falso toda la semana de los dias
   for I := 0 to grid.ColCount do
      for X := 0 to grid.RowCount do
        grid.Cells[i,x]:='F';
end;

procedure TFrm_itinerario.lsCbx_busClick(Sender: TObject);
begin
 if lsCbx_bus.ItemIndex >= 0  then
   maximoOcupantesActual := StrToInt(dsCupoBuses.Value[lsCbx_bus.ItemIndex])
end;

procedure TFrm_itinerario.lsCbx_rutaClick(Sender: TObject);
begin
 if lsCbx_ruta.ItemIndex >= 0 then Begin
   cargarDetalleRuta(StrToInt(lsCbx_ruta.CurrentID));
   llenarConCeros(sgMaximos);
   llenarSinDias(sagDias);
   dtpHoraSalidaChange(Sender);
   pintaDetalleCompletoRuta(lsCbx_ruta.CurrentID);
   sagDias.RowCount:= sgTerminales.RowCount;

 End;
end;


function TFrm_itinerario.modificarCorrida(hora : TTime; lunes, martes, miercoles, jueves,
             viernes, sabado, domingo : Char; id_tipo_autobus, tiposervicio,
             id_ruta: integer; id_corrida : String) :  Integer;
var
 sp : TSQLStoredProc;
begin
 sp := TSQLStoredProc.Create(Self);
 Result := -1;
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_MODIFICAR_ITINERARIO';
   sp.Params.ParamByName('_HORA').AsTime := hora;
   sp.Params.ParamByName('_LUNES').AsString := lunes;
   sp.Params.ParamByName('_MARTES').AsString := martes;
   sp.Params.ParamByName('_MIERCOLES').AsString := miercoles;
   sp.Params.ParamByName('_JUEVES').AsString := jueves;
   sp.Params.ParamByName('_VIERNES').AsString := viernes;
   sp.Params.ParamByName('_SABADO').AsString := sabado;
   sp.Params.ParamByName('_DOMINGO').AsString := domingo;
   sp.Params.ParamByName('_ID_TIPO_AUTOBUS').AsInteger := id_tipo_autobus;
   sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := tiposervicio;
   sp.Params.ParamByName('_ID_RUTA').AsInteger := id_ruta;
   sp.Params.ParamByName('_ID_CORRIDA').AsString := id_corrida;
   sp.ExecProc;
   result := 1;
 finally
   sp.Free;
 end;
end;

function TFrm_itinerario.obtenerMaximoPie: Integer;
begin
 ssql := 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 10;';
 if EjecutaSQL(ssql, lq_query, _LOCAL) then
   result := lq_query.FieldByName('VALOR').AsInteger
 else
   result := 10;
 lq_query.Close;
end;

procedure TFrm_itinerario.pintaDetalleCompletoRuta(id_ruta: String);
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

procedure TFrm_itinerario.rectifica(row: Integer);
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

begin// Coloca los ":" en caso de que no se hayan puesto.
 if Length(sgTerminales.Cells[_COL_HORA,row]) = 4  then
   sgTerminales.Cells[_COL_HORA,row] := hora(copy(sgTerminales.Cells[_COL_HORA,row], 1, 2)) + ':' + minutos(copy(sgTerminales.Cells[_COL_HORA,row], 3, 2))
 else  if Length(sgTerminales.Cells[_COL_HORA,row]) = 5  then
   sgTerminales.Cells[_COL_HORA,row] := hora(copy(sgTerminales.Cells[_COL_HORA,row], 1, 2)) + ':' + minutos(copy(sgTerminales.Cells[_COL_HORA,row], 4, 2))
 else
   sgTerminales.Cells[_COL_HORA,row] := '';
end;

procedure TFrm_itinerario.replicarTodos(sentencia: String);
var
 n : Integer;
 sentenciaLocal : String;
begin
 for n := 0 to terminalesAutomatizadas.Count - 1 do begin
   lq_query.SQL.Clear;
   sentenciaLocal := 'INSERT INTO PDV_T_QUERY(FECHA_HORA, ID_TERMINAL, SENTENCIA) ' +
                     'SELECT NOW(), ''' +
                     terminalesAutomatizadas[n] +
                     ''', :sql';
     lq_query.SQL.Add(sentenciaLocal);
     lq_query.Params[0].AsString := sentencia;
     lq_query.ExecSQL;
 end;
end;

procedure TFrm_itinerario.sgOcupantesExit(Sender: TObject);
begin
  copiarMaximos(True);
end;

procedure TFrm_itinerario.sgOcupantesKeyPress(Sender: TObject; var Key: Char);
begin
 if not (key in _CARACTERES_VALIDOS_OCUPANTES) then
   Key := #0
end;

procedure TFrm_itinerario.sgTerminalesExit(Sender: TObject);
begin
 rectifica(sgTerminales.Row);
end;

procedure TFrm_itinerario.sgTerminalesKeyPress(Sender: TObject; var Key: Char);
begin
 // No dejo editar la primera hora.
 if (sgTerminales.Row = 1) and (sgTerminales.Col = 1) then
   key := #0
 else if not (key in _CARACTERES_VALIDOS_TERMINALES) then
   Key := #0;
end;

procedure TFrm_itinerario.sgTerminalesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
 // Si es una nueva celda rectifica la anterior.
 if (gRow <> ARow) then
   if gRow > 0 then
     rectifica(gRow);
 gRow := ARow;
 copiarMaximos(False);
 copiarDias(False);
 GroupBox1.Caption:= 'Dias de la semana de ' + sgTerminales.Cells[0,gRow];
 GroupBox4.Caption:= 'Ocupantes de ' + sgTerminales.Cells[0,gRow];
end;

function TFrm_itinerario.validarBusqueda: Boolean;
begin
 result := (chbOrigen.checked) or (chbDestino.checked) or
           (chbServicio.checked) or (chbRuta.checked) or
           (chbCorrida.checked);

 if (chbOrigen.checked) and (cbOrigen.ItemIndex < 0) then
   result := False
 else if (chbDestino.checked) and (cbDestino.ItemIndex < 0) then
   result := False
 else if (chbServicio.checked) and (lscbServicios.ItemIndex < 0) then
   result := False
 else if (chbRuta.checked) and (lscbRuta.ItemIndex < 0) then
   result := False
 else if (chbCorrida.checked) and (Trim(edCorrida.Text) = '') then
   result := False
end;

function TFrm_itinerario.validarCupos: Boolean;
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

function TFrm_itinerario.validarDatos: Boolean;
begin
 result := False;
 if (lsCbx_ruta.ItemIndex > -1) and (lsCbx_servicio.ItemIndex > -1) and (lsCbx_bus.ItemIndex > -1 )
    and (validarHorarios) and(validarDias) and (validarCupos) and (validarMaximos) and
    (cmb_iva.ItemIndex > -1) then
   result := True;
end;

function TFrm_itinerario.validarDias: Boolean;
begin
 result := cbDomingo.Checked or cbLunes.Checked or cbMartes.Checked or cbMiercoles.Checked or cbJueves.Checked or cbViernes.Checked or cbSabado.Checked;
 if not result then
   Application.MessageBox(PWideChar(format('Debe seleccionar al menos un día.',[])),'Atención', _ATENCION);
end;

function TFrm_itinerario.validarHorarios: Boolean;
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

function TFrm_itinerario.validarMaximos: Boolean;
var
 vRow, vCol, total : Integer;
begin
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

function TFrm_itinerario.valorDe(valor: Char): Boolean;
begin
if valor = 'T' then
  result := True
else
  result := False;
end;

function TFrm_itinerario.valorDe(checkBox: TCheckBox): Char;
begin
 if checkBox.Checked then
   result := 'T'
 else
   result := 'F';
end;

end.
