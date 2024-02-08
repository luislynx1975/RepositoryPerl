unit frmTarifas;
{
Autor: Gilberto Almanza Maldonado
Fecha: Miercoles 25 de Noviembre de 2009
Descripcion: Forma que facilita la busqueda de tarifas o bien la captura de
nuevas tarifas, por ruta y por destino.
Por Ruta: El sistema muestra todas las combinaciones posibles con los tramos
          existentes, por ejemplo si tenemos una ruta con Origen A y destino C
          con un paso B. las combinaciones serian:
          A-B
          A-C
          B-C
          la formula utilizada es
          (n (n+1))/ 2
          donde n es igual al numero de tramos que existen en la ruta, para este
          caso n=2, por lo tanto 2*3= 6/2 = 3
Por Origen: El sistema muestra las combinaciones con los tramos
          existentes, por ejemplo, si elegimos como origen la ciudad de Mexico
          el sistema mostrara todos los tramos existentes que tengan origen =
          Mexico, no importando el destino
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, lsCombobox, SqlExpr,
  ComCtrls, Grids, Aligrid, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  ActnList, XPStyleActnCtrls, Db, ImgList;

  Const
     _TOMA_FECHA_HORA=  'Se tomará la tarifa más reciente previa de acuerdo a Fecha y Hora.';
     _IGNORA_FECHA_HORA= 'Se ignorará la fecha y hora de aplicacion. Se mostrará la cronológicamente mayor.';
     _SIN_TARIFA=       'No existe una tarifa para este tramo, servicio, fecha y hora de aplicacion'+ Char(13) +
                        '¿Desea agregarlo?';
     _INSERCION_ID_TARIFA_OK = 'Se inserto el Identificador de tarifa correctamente.';
     _INSERCION_TARIFAS_OK = 'Se insertaron las Tarifas correctamente.';
     _ERROR_INSERCION_TARIFAS = 'No insertaron las Tarifas correctamente.'+ char(13)+
                                'Intentelo nuevamente.';
     _MENSAJE_TARIFAS_NULAS  = 'Existen tarifas nulas. '+ Char(13) +
                               '¿Deseas asignar un valor $0.00?';
     _ALTA_TARIFAS = '¿Desea dar de alta las tarifas capturadas, con fecha/hora de aplicacion: '+ Char(13) +
                     ' %s  ?';
     _OPERACION_CANCELADA ='Se canceló la operacion.';
     _ERROR_OPERACION_INTERNO= 'Existe un error de operacion interno.'+Char(13) +
                               'Por favor, cierre la forma e intentelo nuevamente.';
     _SIN_ID_TARIFA = 'No existe un identificador de Tarifa para este tramo: %s';
     _ORIGEN=   'ORIGEN';
     _DESTINO=  'DESTINO';

     
type
  TfrmTarifa = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    lscbServicios: TlsComboBox;
    dtpFechaAplicacion: TDateTimePicker;
    dtpHoraAplicacion: TDateTimePicker;
    Label2: TLabel;
    ActionManager1: TActionManager;
    Action1: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    act143: TAction;
    pcTarifas: TPageControl;
    TabSheet1: TTabSheet;
    sagRutas: TStringAlignGrid;
    panelAgrega: TPanel;
    TabSheet2: TTabSheet;
    sbRutas: TStatusBar;
    cbFechaHora: TCheckBox;
    lblAyuda: TLabel;
    sagRutasAgrega: TStringAlignGrid;
    sagTramosRutaAgrega: TStringAlignGrid;
    sbRutasAgrega: TStatusBar;
    btnGuardar: TButton;
    btnCancelar: TButton;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    TabSheet3: TTabSheet;
    sagDestinosAgrega: TStringAlignGrid;
    Label6: TLabel;
    lscbPuntoOrigenAgrega: TlsComboBox;
    PanelOrigen: TStatusBar;
    Panel3: TPanel;
    Button3: TButton;
    Button4: TButton;
    Label7: TLabel;
    dtpAldia: TDateTimePicker;
    dtpAlaHora: TDateTimePicker;
    TabSheet4: TTabSheet;
    PanelAgrega2: TPanel;
    btnGuarda2: TButton;
    btnCancela2: TButton;
    sbRutasDesdeOrigen: TStatusBar;
    Label11: TLabel;
    lscbOrigen: TlsComboBox;
    sagTramosRutaDesdeOrigen: TStringAlignGrid;
    sagTramosRuta: TStringAlignGrid;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edTarifaRutas: TEdit;
    lscbDestinoTarifaRutas: TlsComboBox;
    lscbOrigenTarifaRutas: TlsComboBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    edTarifaOrigen: TEdit;
    DestinoOrigen: TlsComboBox;
    OrigenOrigen: TlsComboBox;
    sagPasos: TStringAlignGrid;
    progreso: TProgressBar;
    ImageList1: TImageList;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sagRutasSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sagTramosRutaSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Action1Execute(Sender: TObject);
    procedure cbFechaHoraClick(Sender: TObject);
    procedure sagTramosRutaAgregaKeyPress(Sender: TObject; var Key: Char);
    procedure sagRutasAgregaSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure sagTramosRutaAgregaSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure pcTarifasChange(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure edTarifaRutasKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lscbPuntoOrigenAgregaChange(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure act143Execute(Sender: TObject);
    procedure lscbOrigenChange(Sender: TObject);
    procedure sagTramosRutaDesdeOrigenSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure btnGuarda2Click(Sender: TObject);
    procedure btnCancela2Click(Sender: TObject);
    procedure edTarifaOrigenKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Query :   TSQLQuery;
    QueryAux: TSQLQuery;
    QueryT:   TSQLQuery;
    procedure CargaTipoServicios;
    Procedure CargaRutas(sagVisible, sagMio: TStringAlignGrid; panel: TstatusBar);
    procedure CargaRutas_(sagVisible, sagMio: TstringAlignGrid; panel: TStatusBar; _ : String);
    procedure CargaRuta(sagVisible, sagMio: TstringAlignGrid; panel: TStatusBar; idRuta : String);
    procedure CargaTramosRuta(sagVisible, sagMio: TStringAlignGrid; panel: TstatusBar;idRuta: String);
    procedure CargaTerminales(combo: TlsComboBox);
    Function CargaTarifa(idTramo,idServicio: String; _edTarifa: TEdit; Panel: TPanel): double;
    function GuardaAltaTarifa(panel: TPanel; ed: TEdit): Boolean ;
    Function RevisaTarifasNulas(sag : TStringAlignGrid): Boolean;
    function AsignaCeroTarifasNulas(sag: TStringAlignGrid): Boolean;
    function AsignaCeroTarifasTodas(sag: TstringAlignGrid): Boolean;
    function GuardarTarifas(var sag, sagVisible: TstringAlignGrid; FechaHora: TDateTime): boolean;
    function RevisaIdTarifas(var sag: TstringAlignGrid): Byte;
    function CargaIdTarifas(var sag: TstringAlignGrid) : boolean;
    procedure AltaTarifas(var sag, sagVisible: TStringAlignGrid);
    procedure CargaDestinos(Origen: String; sagMio, sagVisible: TStringAlignGrid; panel: TStatusBar);
    PROCEDURE cargaDestinosTarifa(Origen: String; sagMio, sagVisible: TStringAlignGrid; panel: TStatusBar; idServicio: Integer);
    procedure LimpiaGrid(Grid: TstringAlignGrid);
    FUNCTION CargaTodoRuta(idRuta: String): STRING;
    function RegresaTramos(idRuta: String; Orden: Integer): String;
    function forza_izq(cadena:string;no:integer):string;
    function forza_der(cadena:string;no:integer):string;
    function espacios(no:integer):string;
    PROCEDURE CARGA_TERMINALES;
  public
    { Public declarations }
  end;

var
  frmTarifa: TfrmTarifa;
  sagRutasMio, sagRutasAgregaMio: TStringAlignGrid;
  sagTramosRutaMio, sagTramosRutaAgregaMio: TStringAlignGrid;
  sagTramosRutaDesdeOrigenMio, sagTramosRutaDesdeOrigenAgregaMio:   TStringAlignGrid;
  sagDestinosAgregaMio: TStringAlignGrid;
  renglonRuta: Integer;
  renglonTramo, ColumnaTramo: Integer;
  idRutaTarifasBuscar: Integer;
  // variables para ocupar en el modulo de Busqueda para cuando haya que buscar una
  // ciudad origen o destino.
  CiudadOTarifasBuscar: String;
  CiudadDTarifasBuscar: String;
  Busqueda: Byte;
implementation

uses comun, DMdb, frmMbusquedas, comunii;

{$R *.dfm}

{Procedimiento que almacena los tipos de servicio en el comboBoc lscbServicios}
procedure TfrmTarifa.CargaTipoServicios;
begin
   sql:='SELECT TIPOSERVICIO AS ID, ABREVIACION AS DESCRIPCION FROM SERVICIOS WHERE FECHA_BAJA IS NULL;';
   if  EjecutaSQL(sql,Query,_LOCAL) then
   begin
      lscbServicios.Clear;
      while not Query.Eof do
      begin
         lscbServicios.Add(Query.fieldByName('ID').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
         Query.Next;
      end;
   end;
end;

procedure TfrmTarifa.FormShow(Sender: TObject);
begin
   gds_actions.clear;
   sagRutasMio:= TStringAlignGrid.Create(Self);
   sagTramosRutaMio:= TStringAlignGrid.Create(Self);
   sagRutasAgregaMio:= TStringAlignGrid.Create(Self);
   sagTramosRutaAgregaMio:= TStringAlignGrid.Create(Self);
   sagDestinosAgregaMio:= TStringAlignGrid.Create(Self);
   sagTramosRutaDesdeOrigenMio:= TStringAlignGrid.Create(Self);
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   QueryAux:= TSQLQuery.Create(Self);
   QueryAux.SQLConnection:= dm.Conecta;

   QueryT:= TSQLQuery.Create(Self);
   QueryT.SQLConnection:= dm.Conecta;
   CargaTipoServicios;
   dtpFechaAplicacion.Date:= Now();
   dtpHoraAplicacion.Time:=  Now();
   CargaRutas(sagRutas,sagRutasMio,sbRutas);
   CargaRutas(sagRutasAgrega,sagRutasAgregaMio,sbRutasAgrega);
   CARGA_TERMINALES;


   pcTarifas.ActivePageIndex:=0;


end;

procedure TfrmTarifa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   gds_actions.clear;
   Query.Destroy;
   QueryT.Destroy;
   QueryAux.Destroy;
   sagRutasMio.Destroy;
   sagTramosRutaMio.Destroy;
   sagRutasAgregaMio.Destroy;
   sagTramosRutaAgregaMio.Destroy;
   sagDestinosAgregaMio.Destroy;
   sagTramosRutaDesdeOrigenMio.Destroy;
   comunii.terminalesAutomatizadas.Free;
end;

procedure TfrmTarifa.FormCreate(Sender: TObject);
begin
   comunii.terminalesAutomatizadas:= TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;
end;

{procedimiento que almacena los nombres de las terminales en el combo enviado
como parametro}
procedure TfrmTarifa.CargaTerminales(combo: TlsComboBox);
begin
  sql:='SELECT ID_TERMINAL AS ID, DESCRIPCION FROM T_C_TERMINAL WHERE FECHA_BAJA IS NULL;';
  if not EjecutaSQL(sql,Query,_LOCAL) then
  begin
      ShowMessage(_ERR_SQL);
      Exit;
  end;
  combo.Clear;
  while not Query.Eof do
  begin
     combo.Add(Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
     Query.Next;
  end;
  Query.Close;
end;
{procedimiento que almacena y muestra todas las tutas existentes en la tabla
T_C_RUTA en dos grids uno visible al usuario y otro para uso del sistema}
procedure TfrmTarifa.CargaRutas(sagVisible, sagMio: TStringAlignGrid; panel: TstatusBar);
var renglon: Integer;
begin
   sql:='select ID_RUTA as ID ,CONCAT(ORIGEN,'' - '',DESTINO) as RUTA, ORIGEN '+
        ' from T_C_RUTA;';
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage(_ERR_SQL);
      Exit;
   end;
   renglon:=1;
   sagVisible.RowCount:=   registrosDe(query)+1;
   sagMio.RowCount:=registrosDe(Query)+1;
   sagVisible.Cells[0,0]:='RUTAS';
   sagMio.Cells[0,0]:='RUTAS';
   while not query.Eof do
   begin
      sagVisible.Cells[0,renglon]:= Query.FieldByName('RUTA').AsString+
                                    Forza_Der('('+Query.FieldByName('ID').AsString+')',9);
      sagMio.Cells[0,renglon] := Query.FieldByName('ID').AsString;
     // aumento el campo ORIGEN para poder manipular una ruta DESDE su origen
      sagMio.Cells[1,renglon] := Query.FieldByName('ORIGEN').AsString;
      Query.Next;
      inc(renglon);
   end;
   panel.Panels[0].Text:='Rutas: '+ IntToStr(registrosDe(Query));
   panel.Panels[1].Text:= 'Tramos';
end;
 {procedimiento que  carga los tramos de una ruta y sus posibles combinaciones
 cuando se elige un renglon de las regillas de rutas}
procedure TfrmTarifa.sagRutasSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  renglonRuta:=Arow;
  cargaTramosRuta(sagTramosRuta, sagTramosRutaMio,sbRutas, sagRutasMio.Cells[0,renglonRuta]);
  //cARGAtODOrUTA(sagRutasMio.Cells[0,renglonRuta]);
  lscbOrigenTarifaRutas.ItemIndex:=  -1;
  lscbDestinoTarifaRutas.ItemIndex:= -1;
  edTarifaRutas.Clear;
end;

{Procedimiento que carga los pasos y todas las combinaciones almacenadas en la base de datos,
cuando se ha elegido una ruta}

procedure TfrmTarifa.CargaTramosRuta(sagVisible, sagMio: TStringAlignGrid; panel: TstatusBar;idRuta: String);
var renglon: Integer;
begin

   SQL:= CargaTodoRuta(IdRuta);
  // ShowMessage(Sql);
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage(_ERR_SQL);
      Exit;
   end;
   renglon:=1;
   sagVisible.RowCount:= registrosDe(query)+1;
   sagMio.RowCount:=     registrosDe(Query)+1;
   sagMio.ColCount:= 3;
   sagVisible.Cells[0,0]:= 'ORIGEN';
   sagVisible.Cells[1,0]:= 'DESTINO';
   Query.First;
   while not Query.Eof do
   begin
     sagVisible.Cells[0,renglon]:= Query.FieldByName('ORIGEN').AsString;
     sagVisible.Cells[1,renglon]:= Query.FieldByName('DESTINO').AsString;
     sagVisible.Cells[2,renglon]:= '';

     sagMio.Cells[0,renglon]:= Query.FieldByName('ORIGEN').AsString;
     sagMio.Cells[1,renglon]:= Query.FieldByName('DESTINO').AsString;
     sagMio.Cells[2,renglon]:= Query.FieldByName('ID_TRAMO').AsString;
     Query.Next;
     inc(renglon);
   end;
    // obtengo el total de los tramos por donde pasa la Ruta
   SQL:='SELECT T.ORIGEN, T.DESTINO, RD.ORDEN'+
      ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
      ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN;';
   if not EjecutaSQL(sql,QueryAux,_LOCAL) then
      ShowMessage(_ERR_SQL);
   DataSetToSag(QueryAux,sagPasos);
   panel.Panels[1].Text:= 'C: '+  IntToStr(registrosDe(Query)) + '   T:'+  IntToStr(registrosDe(QueryAux));
end;
 procedure TfrmTarifa.CARGA_TERMINALES;
begin
    sql:='SELECT ID_TERMINAL AS ID, DESCRIPCION FROM T_C_TERMINAL WHERE FECHA_BAJA IS NULL;';
  if not EjecutaSQL(sql,Query,_LOCAL) then
  begin
      ShowMessage(_ERR_SQL);
      Exit;
  end;
  lscbOrigenTarifaRutas.Clear;
  lscbDestinoTarifaRutas.Clear;
  OrigenOrigen.Clear;
  DestinoOrigen.Clear;
  lscbPuntoOrigenAgrega.Clear;
  lscbOrigen.Clear;
  while not Query.Eof do
  begin
     lscbOrigenTarifaRutas.Add(Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
     lscbDestinoTarifaRutas.Add(Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
     OrigenOrigen.Add(Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
     DestinoOrigen.Add(Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
     lscbPuntoOrigenAgrega.Add(Query.fieldByName('ID').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
     lscbOrigen.Add(           Query.fieldByName('ID').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString,
                           Query.fieldByName('ID').AsString);
     Query.Next;
  end;
  Query.Close;
end;

{procedimiento que carha los datos de la ruta en las listas desplegables para
 visualizar el nombre completo del origen y destino del tramo seleccionado}
procedure TfrmTarifa.sagTramosRutaSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
   renglonTramo:= Arow;
   if lscbServicios.ItemIndex <= 0 then Exit;
   lscbOrigenTarifaRutas.SetID(sagTramosRuta.Cells[0,Arow]);
   lscbDestinoTarifaRutas.SetID(sagTramosRuta.Cells[1,Arow]);
   edTarifaRutas.Text:= FormatFloat('#,##',(CargaTarifa(sagTramosRutaMio.Cells[2,renglonTramo],
                        lscbServicios.CurrentID, edTarifaRutas, panelAgrega)));

end;


procedure TfrmTarifa.Action1Execute(Sender: TObject);
begin
   Close;
end;
 {
 Funcion que carga la tarifa de un tramo, servicio y fecha hora seleccionado,
 dependiendo de cbFechaHora para tomar el mayor cronologicamente o bien para
 tomar el mas proximo a una fecha dada.
 }
function TfrmTarifa.CargaTarifa(idTramo, idServicio: String; _edTarifa: TEdit; Panel: TPanel): Double;
begin
   if ((Trim(idTramo)='') or (Trim(idServicio)='')) then Exit;
   if cbFechaHora.Checked then
        sql:='SELECT MONTO, FECHA_HORA_APLICA  FROM PDV_C_TARIFA_D WHERE ID_TARIFA =(SELECT ID_TARIFA '+
           ' FROM PDV_C_TARIFA WHERE ID_TRAMO= '+ idTramo +
           ' AND ID_SERVICIO='+ idServicio +')'+
           ' AND FECHA_HORA_APLICA = ( '+
           ' SELECT MAX(FECHA_HORA_APLICA) '+
           ' FROM PDV_C_TARIFA_D '+
           ' WHERE ID_TARIFA =(SELECT ID_TARIFA '+
           ' FROM PDV_C_TARIFA '+
           ' WHERE ID_TRAMO= '+idTramo+
           ' AND ID_SERVICIO='+idServicio+'));'
   else
   begin
        dtpAlDia.Time:= dtpAlaHora.Time;
        sql:='select MONTO, FECHA_HORA_APLICA FROM  PDV_C_TARIFA_D WHERE ID_TARIFA = '+
           ' (SELECT ID_TARIFA FROM PDV_C_TARIFA WHERE ID_TRAMO='+idTramo+
           ' AND ID_SERVICIO='+idServicio+') '+
           ' AND FECHA_HORA_APLICA = '+
           ' (SELECT MAX(FECHA_HORA_APLICA) ' +
           ' FROM PDV_C_TARIFA_D  WHERE FECHA_HORA_APLICA <= '+
             QuotedStr(FormatDateTime('yyyy/mm/dd hh:nn:ss',dtpAlDia.DateTime)) +
           ' AND ID_TARIFA=(SELECT ID_TARIFA FROM PDV_C_TARIFA '+
           ' WHERE ID_TRAMO='+idTramo+' AND ID_SERVICIO='+idServicio+') );';
   end;
   //showmessage(sql);
   If not EjecutaSQL(sql,QueryAux,_LOCAL) then exit;
   dtpFechaAplicacion.Date:= QueryAux.FieldByName('fecha_hora_aplica').AsDateTime;
   dtpHoraAplicacion.Time:=  QueryAux.FieldByName('fecha_hora_aplica').AsDateTime;
   result:= QueryAux.FieldByName('MONTO').AsFloat;
   if result = 0 then
      if MessageDlg(_SIN_TARIFA,mtWarning,mbOKCancel,0) = mrOK then
      begin
          //Obtener el ID_TARIFA
          sql:= 'SELECT ID_TARIFA FROM PDV_C_TARIFA '+
           ' WHERE ID_TRAMO='+idTramo+' AND ID_SERVICIO='+idServicio +';';
          If not EjecutaSQL(sql,QueryAux,_LOCAL) then exit;
          // si no existe un ID_TARIFA, insertarlo y reconocerlo
          if   QueryAux.FieldByName('ID_TARIFA').IsNull then
          begin
              sql:= 'INSERT INTO PDV_C_TARIFA(ID_TARIFA, ID_TRAMO, ID_SERVICIO ) '+
                    ' SELECT MAX(ID_TARIFA) + 1, '+ idTramo + ','+ idServicio +
                    ' FROM PDV_C_TARIFA; ';
              If  EjecutaSQL(sql,QueryAux,_LOCAL) then
              BEGIN
               //  ShowMessage(_INSERCION_ID_TARIFA_OK);
                 sql:= 'SELECT ID_TARIFA FROM PDV_C_TARIFA '+
                       ' WHERE ID_TRAMO='+idTramo+' AND ID_SERVICIO='+idServicio ;
                 If  EjecutaSQL(sql,QueryAux,_LOCAL) then
                 begin
                     sql:= 'INSERT INTO PDV_C_TARIFA(ID_TARIFA, ID_TRAMO, ID_SERVICIO ) '+
                    ' VALUES('+QueryAux.FieldByName('ID_TARIFA').assTRING+', '+ idTramo + ','+ idServicio +');';
                    comunii.replicarTodos(sql);
                    panel.Tag := QueryAux.FieldByName('ID_TARIFA').asInteger;
                 end;
              END;  // fin del INSERT
          end;     // FIN SI ID_TARIFA ES NULO
          panel.Tag := QueryAux.FieldByName('ID_TARIFA').asInteger;
          dtpFechaAplicacion.DateTime:= now;
          dtpHoraAplicacion.DateTime := now;
          panel.Enabled:=  True;
          _edTarifa.Enabled:=True;
          _edTarifa.SetFocus;
      end;  // fin del  mensaje para dar de alta la tarifa
end;

{procedimiento que alerta al usuario de la condicion de  busqueda con respecto
a la fecha hora de la tarifa}
procedure TfrmTarifa.cbFechaHoraClick(Sender: TObject);
begin
if pcTarifas.TabIndex in [2,3] then exit;
   if TcheckBox(Sender).Checked then
   begin
      TcheckBox(Sender).Caption:= _IGNORA_FECHA_HORA;
      lblAyuda.Caption:= '';
      dtpFechaAplicacion.Enabled:= False;
      dtpHoraAplicacion.Enabled := False;
      dtpalDia.Enabled  :=   False;
     dtpaLaHora.Enabled :=   False;
   end
   else
   begin
     TcheckBox(Sender).Caption:= _TOMA_FECHA_HORA;
     lblAyuda.Caption:= 'PRECAUCION';
     dtpalDia.Enabled:= True;
     dtpAlDia.Date:= now;
     dtpaLaHora.Enabled := True;
     dtpAlDia.Time:= StrToTime('00:00:00');
   end;
end;

procedure TfrmTarifa.sagTramosRutaAgregaKeyPress(Sender: TObject;
  var Key: Char);
begin
   if ColumnaTramo <> 2 then
      Key:= Char(0);
   if (not(Key in ['0'..'9','.',#8, #13]))  then
      Key:= Char(0);
end;

procedure TfrmTarifa.sagRutasAgregaSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  renglonRuta:=Arow;
  cargaTramosRuta(sagTramosRutaAgrega, sagTramosRutaAgregaMio,sbRutasAgrega, sagRutasAgregaMio.Cells[0,renglonRuta]);
end;

procedure TfrmTarifa.sagTramosRutaAgregaSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  renglonTramo:= Arow;
  ColumnaTramo:= Acol;
end;
{Cada vez que se cambia de pestaña el sistema activa/desactiva algunos controles
delformulario}
procedure TfrmTarifa.pcTarifasChange(Sender: TObject);
begin
   dtpFechaAplicacion.DateTime:= Now;
   dtpHoraAplicacion.DateTime := Now;
   lscbOrigenTarifaRutas.ItemIndex:= -1;
   lscbDestinoTarifaRutas.ItemIndex:=-1;
   OrigenOrigen.ItemIndex := -1;
   DestinoOrigen.ItemIndex:= -1;
   edTarifaOrigen.Text:= '';
   LimpiaGrid(sagPasos);
   edTarifaRutas.Text:=          '';
   case pcTarifas.ActivePageIndex of
   0 :
   begin
    //Consultador de tarifas de las rutas existentes
      dtpFechaAplicacion.enabled:= False;
      dtpHoraAplicacion.enabled:= False;
      LimpiaGrid(sagTramosRuta);
      LimpiaGrid(sagTramosRutaMio);
      sbRutas.Panels[1].Text:='';
   end;
   1 :
   begin
      dtpFechaAplicacion.enabled:= False;
      dtpHoraAplicacion.enabled:= False;
      LimpiaGrid(sagTramosRutaDesdeOrigen);
      LimpiaGrid(sagTramosRutaDesdeOrigenMio);
      sbRutasDesdeOrigen.Panels[1].Text:='';
   end;
   2 :
   begin
    // agregar tarifas de a las rutas existentes
      dtpFechaAplicacion.enabled:= True;
      dtpHoraAplicacion.enabled:= True;
      dtpAldia.Enabled  := False;
      dtpAlaHora.Enabled:= False;
      LimpiaGrid(sagTramosRutaAgrega);
      LimpiaGrid(sagTramosRutaAgregaMio);
      sbRutasAgrega.Panels[1].Text:='';
   end;
   3 :
   begin
   //agregar tarifas a a todos los destinos de un punto origen existente
      dtpFechaAplicacion.enabled:= True;
      dtpHoraAplicacion.enabled:= True;
      dtpAldia.Enabled  := False;
      dtpAlaHora.Enabled:= False;
      LimpiaGrid(sagDestinosAgrega);
      LimpiaGrid(sagDestinosAgregaMio);
      panelOrigen.Panels[1].Text:='';
   end;
   else ;
   end; // end del case

end;

procedure TfrmTarifa.btnCancelarClick(Sender: TObject);
begin
  panelAgrega.Enabled:=   False;
  edTarifaRutas.Text :='';
  edTarifaRutas.Enabled:= False;
end;
{Funcion que realiza el Alta de una tarifa, especificada por un tramo}

function TfrmTarifa.GuardaAltaTarifa(panel: TPanel; ed: TEdit): Boolean;
begin
   Result:= False;
   if panel.Tag = 0 then
   begin
     ShowMessage(format(_SIN_ID_TARIFA,[lscbOrigenTarifaRutas.CurrentItem + '-'+ lscbDestinoTarifaRutas.CurrentItem]));
     Exit;
   end;
   ////////////////
   sql:= 'DELETE FROM PDV_C_TARIFA_D WHERE ID_TARIFA= ' + IntToStr(panel.Tag) +
         ' AND MONTO = ' +  ed.Text +
         ' AND FECHA_HORA_APLICA = ' +
         QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn',dtpFechaAplicacion.DateTime))+';' ;
   QueryT.SQL.Clear;
   QueryT.SQL.Add(sql);
   QueryT.ExecSQL;
   comunii.replicarTodos(sql);
   ////////////////
   sql:='INSERT INTO PDV_C_TARIFA_D(ID_TARIFA, MONTO, FECHA_HORA_APLICA) '+
        ' VALUES('+ IntToStr(panel.Tag) + ',' + ed.Text + ',' +
        QuotedStr(FormatDateTime('yyyy-MM-dd hh:NN:ss',dtpFechaAplicacion.DateTime)) +
        ');';
   If  EjecutaSQL(sql,Query,_LOCAL) then
   begin
      comunii.replicarTodos(sql);
      Result:= True;
   end
   else
      Result:= False;
   panel.Enabled:=   False;
//   ed.Text :='';
   ed.Enabled:= False;
end;

procedure TfrmTarifa.btnGuardarClick(Sender: TObject);
begin
  if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   if GuardaAltaTarifa(panelAgrega,edTarifaRutas) then
      ShowMessage(_OPERACION_SATISFACTORIA);
end;

procedure TfrmTarifa.edTarifaRutasKeyPress(Sender: TObject; var Key: Char);
begin
if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
   if key = #13 then
      btnGuardarClick(btnGuardar);
end;

procedure TfrmTarifa.Button1Click(Sender: TObject);
var aux: byte;
begin
if not AccesoPermitido(TButton(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
  dtpFechaAplicacion.Time:= dtpHoraAplicacion.Time;
  if lscbServicios.ItemIndex <=0 then Exit;
  // Primero reviso que no haga falta ni una sola tarifa...
  if not RevisaTarifasNulas(sagTramosRutaAgrega) then
     if MessageDlg(_MENSAJE_TARIFAS_NULAS,mtWarning,mbOKCancel,0) = mrOK then
         if AsignaCeroTarifasNulas(sagTramosRutaAgrega) then
             AltaTarifas(sagTramosRutaAgregaMio, sagTramosRutaAgrega)
         else
             aux:=1
     else
        ShowMessage(_OPERACION_CANCELADA)
  else // se ejecuta si las tarifas estan capturadas todas
     AltaTarifas(sagTramosRutaAgregaMio, sagTramosRutaAgrega);
end;

 {
    Funcion que revisa cada renglon del SAG parametro para verificar que NO
    Existan tarifas nulas o en blanco.
    Regresa True cuando todas las tarifas tienen asignado un valor diferente
    de Nulo y False en la primer coincidencia de un valor Nulo.
  }
function TfrmTarifa.RevisaTarifasNulas(sag: TStringAlignGrid): Boolean;
var renglon: Integer;
begin

  for renglon := 1 to sag.RowCount -1 do
      if Trim(sag.Cells[2,renglon]) = '' then
      begin
         result:= False;
         Exit;
      end;
  result:= True;
end;

 {
  Funcion que asigna un valor 0.00 en las celdas que tengan un valor Nulo
  en el sag parametro. Regresa True cuando no existe ningun inconveniente
  y termina de asignar a todos los valores Nules
  }
function TfrmTarifa.AsignaCeroTarifasNulas(sag: TStringAlignGrid): Boolean;
var renglon: Integer;
begin

  try
    for renglon := 1 to sag.RowCount -1 do
      if Trim(sag.Cells[2,renglon]) = '' then
           sag.Cells[2,renglon]:='0.00';
  except
      result:= False;
      exit;
  end;
  result:= True;
end;

  {
  Funcion que asigna un valor 0.00 en los lugares
  en el sag parametro. Regresa True cuando no existe ningun inconveniente
  }

function TfrmTarifa.AsignaCeroTarifasTodas(sag: TstringAlignGrid): Boolean;
var renglon : Integer;
begin

  try
    for renglon := 1 to sag.RowCount-1 do
      if Trim(sag.Cells[2,renglon]) = '' then
           sag.Cells[2,renglon]:='0.00';
  except
      result:= False;
      exit;
  end;
  result:= True;
end;

procedure TfrmTarifa.Button2Click(Sender: TObject);
begin
  AsignaCeroTarifasTodas(sagTramosRutaAgrega);
end;

{Funcion que guarda todas las tarifas capturadas en un Grid}
function TfrmTarifa.GuardarTarifas(var sag, sagVisible: TstringAlignGrid; FechaHora: TDateTime): boolean;
VAR I: INTEGER;
begin
  if sag.RowCount <> sagVisible.RowCount then
  begin
    ShowMessage(_ERROR_OPERACION_INTERNO);
    result:= False;
    Exit;
  end;
  progreso.Max:= sag.RowCount -1;
  TRY
  //sql := 'START TRANSACTION WITH CONSISTENT SNAPSHOT; ' ;
     for i:=1 to sag.RowCount -1 do
     begin
       // PRIMERO ELIMINO EL REGISTRO SI EXISTE CON LA MISMA INFORMACION
       sql:=       'DELETE FROM PDV_C_TARIFA_D WHERE ID_TARIFA= ' + sag.Cells[3,i] +
                   ' AND MONTO = ' + sagVisible.Cells[2,i] +
                   ' AND FECHA_HORA_APLICA = ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn',FechaHora))+';' ;
       QueryT.SQL.Clear;
       QueryT.SQL.Add(sql);
       QueryT.ExecSQL;
       comunii.replicarTodos(sql);
       // DESPUES INSERTO DE FORMA UNICA EL REGISTRO
       sql:=       'INSERT INTO PDV_C_TARIFA_D(ID_TARIFA, MONTO, FECHA_HORA_APLICA) '+
                   ' VALUES( '+ sag.Cells[3,i] + ','+ sagVisible.Cells[2,i]+ ','+ QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn',FechaHora))+ ');';
       QueryT.SQL.Clear;
       QueryT.SQL.Add(sql);
       QueryT.ExecSQL;
       comunii.replicarTodos(sql);
       progreso.StepBy(1);
     end;
//   sql:= sql + 'COMMIT; ';
   //showMessage(sql);
     result:= True;
   EXCEPT
      ShowMessage(_ERROR_INSERCION_TARIFAS);
      result:= False;
      Exit;
      progreso.Position:=0;
   end;
   progreso.Position:=0;
end;
{Funcion que revisa si no existe un identificador de tarifas, lo inserta}
function TfrmTarifa.RevisaIdTarifas(var sag: TstringAlignGrid): Byte;
var i, totalInserciones: Integer;
begin
   totalInserciones:=0;
   progreso.Max:= sag.RowCount -1;
   for i:=1 to sag.RowCount -1 do
   begin
       progreso.StepBy(1);
       sql:='SELECT ID_TARIFA FROM PDV_C_TARIFA '+
             ' WHERE ID_TRAMO= ' + sag.Cells[2,i]  + ' AND ID_SERVICIO= '+ lscbServicios.CurrentID+';';
       if EjecutaSQL(sql,Query,_LOCAL) then
          if query.FieldByName('ID_TARIFA').IsNull then
          begin
             sql:='INSERT INTO PDV_C_TARIFA(ID_TARIFA, ID_TRAMO, ID_SERVICIO) ' +
                  ' SELECT  IFNULL(MAX(ID_TARIFA)+1, 1), ' +
                  sag.Cells[2,i] + ' , ' + lscbServicios.CurrentID+
                  ' FROM PDV_C_TARIFA;';
             if EjecutaSQL(sql,Query,_LOCAL) then
             begin
                replicarTodos(sql);
                inc(totalInserciones);
             end
             else
             begin
               result:=100;
               exit;
             end;
          end
       else
       begin // si no es nula la tarifa
          result:=0;
       end;
   end;
  result:= totalInserciones;
  progreso.Position:=0;

end;

function TfrmTarifa.CargaIdTarifas(var sag: TstringAlignGrid): boolean;
var i: Integer;
begin
    // ahora agregar los ids de tarifas en el sag Mio parametro
   sag.ColCount:= 4;
   progreso.Max:= sag.RowCount -1;
   for i:=1 to sag.RowCount -1 do
   begin
       progreso.StepBy(1);
       sql:='SELECT ID_TARIFA FROM PDV_C_TARIFA '+
             ' WHERE ID_TRAMO= '+ sag.Cells[2,i]  +' AND ID_SERVICIO= '+ lscbServicios.CurrentID;
       if EjecutaSQL(sql,Query,_LOCAL) then
          if not query.FieldByName('ID_TARIFA').IsNull then
          begin
             sag.Cells[3,i]:= query.FieldByName('ID_TARIFA').AsString;
             //showmessage(sag.Cells[0,i] + ' ' + sag.Cells[1,i] + ' ' +sag.Cells[2,i]+ ' ' +sag.Cells[3,i]);
          end
          else if query.FieldByName('ID_TARIFA').IsNull then
          begin
             ShowMEssage(_ERROR_INSERCION_TARIFAS);
             result:= False;
             exit;
          end;
   end;// fin del FOR
   result:= True;
   progreso.Position:=0;
end;

{Procedimiento que realiza el alta de tarifas}
procedure TfrmTarifa.AltaTarifas(var sag, sagVisible: TStringAlignGrid);
begin
    if MessageDlg(Format(_ALTA_TARIFAS,[FormatDateTime('dd/mm/yy hh:nn:ss',
            dtpFechaAplicacion.DateTime)]),mtWarning,mbOKCancel,0) <> mrOK then
   begin
      ShowMessage(_OPERACION_CANCELADA);
      exit;
   end;
   // BUSCAR QUE EXISTAN TODOS LOS IDS TARIFAS
   // QUE CONSTAN DE ID_TRAMO + ID_SERVICIO
   RevisaIdTarifas(sag);
   if RevisaIdTarifas(sag) = 0 then
   // Cargar las tarifas en el GridMio
      if CargaIdTarifas(sag) then
      // Guargar en la BD las tarifas en PDV_C_TARIFA_D
         if GuardarTarifas(sag,sagVisible, dtpFechaAplicacion.DateTime) then
           ShowMessage(_INSERCION_TARIFAS_OK)
         else
           ShowMessage(_ERROR_INSERCION_TARIFAS)
      else
          ShowMessage(_ERROR_INSERCION_TARIFAS)
   else
       ShowMessage(_ERROR_INSERCION_TARIFAS);


end;

procedure TfrmTarifa.lscbPuntoOrigenAgregaChange(Sender: TObject);
begin
   CargaDestinos(lscbPuntoOrigenAgrega.CurrentID,sagDestinosAgregaMio,sagDestinosAgrega,panelOrigen);
end;

{procedimiento que carga todos los tramos que tengan un origen enviado como
parametro y se muestran en el Grid.}
procedure TfrmTarifa.CargaDestinos(Origen: String; sagMio, sagVisible: TStringAlignGrid; panel: TStatusBar);
var renglon: Integer;
begin
    sql:='Select ID_TRAMO, KM, DESTINO '+
         ' From T_C_TRAMO '+
         ' WHERE ORIGEN ='+ QuotedStr(Origen)+
         ' ORDER BY DESTINO';
    if not EjecutaSQL(sql,Query,_LOCAL) then
       Exit;
    renglon:=1;
    sagVisible.RowCount:= registrosDe(Query)+1;
    sagMio.RowCount:=     registrosDe(Query)+1;
    sagMio.ColCount:= 3;
    sagVisible.Cells[0,0]:= 'KILOMETROS';
    sagVisible.Cells[1,0]:= 'DESTINO';
    while not Query.Eof do
    begin
      sagVisible.Cells[0,renglon]:= Query.FieldByName('KM').AsString;
      sagVisible.Cells[1,renglon]:= Query.FieldByName('DESTINO').AsString;
      sagVisible.Cells[2,renglon]:= '';

      sagMio.Cells[0,renglon]:= lscbPuntoOrigenAgrega.CurrentID;
      sagMio.Cells[1,renglon]:= Query.FieldByName('DESTINO').AsString;
      sagMio.Cells[2,renglon]:= Query.FieldByName('ID_TRAMO').AsString;
      Query.Next;
      inc(renglon);
    end;
    panel.Panels[1].Text:= 'Tramos: '+  IntToStr(registrosDe(Query));

end;

procedure TfrmTarifa.Button3Click(Sender: TObject);
var aux: Byte;
begin
 if not AccesoPermitido(TButton(Sender).Tag, _NO_RECUERDA_TAGS) then
        Exit;
  dtpFechaAplicacion.Time:= dtpHoraAplicacion.Time;
  if lscbServicios.ItemIndex <= 0 then Exit;
  // Primero reviso que no haga falta ni una sola tarifa...
  if not RevisaTarifasNulas(sagDestinosAgrega) then
     if MessageDlg(_MENSAJE_TARIFAS_NULAS,mtWarning,mbOKCancel,0) = mrOK then
         if AsignaCeroTarifasNulas(sagDestinosAgrega) then
             AltaTarifas(sagDestinosAgregaMio, sagDestinosAgrega)
         else
             aux:=1
     else
        ShowMessage(_OPERACION_CANCELADA)
  else // se ejecuta si las tarifas estan capturadas todas
     AltaTarifas(sagDestinosAgregaMio, sagDestinosAgrega);
end;
  {Procedimiento para mostrar el formulario de la busqueda}
procedure TfrmTarifa.act143Execute(Sender: TObject);
begin
  if not AccesoPermitido(TAction(sender).Tag, _RECUERDA_TAGS) then
        Exit;
  comun.tipoBusqueda := 300; // Busqueda de Tarifas
  busqueda:= 0;
  try
     frmBusqueda := TfrmBusqueda.Create(Self);
     frmBusqueda.ShowModal;
  finally
     frmBusqueda.Free;
     frmBusqueda := nil;
  end;
  case busqueda of
   1 :  // realizar la busqueda por numero de  ruta
   begin
       case pcTarifas.TabIndex of
        0 : CargaRuta(sagRutas,sagRutasMio,sbRutas,IntToStr(idRutaTarifasBuscar));
        1:  ShowMessage('Debes elegir un Origen de Ruta.');
        2 : CargaRuta(sagRutasAgrega,sagRutasAgregaMio,sbRutasAgrega,IntToStr(idRutaTarifasBuscar));
        3 : ShowMessage('Debes elegir un Origen de Ruta.');
       else ;
       end;

   end;
   2 :  // realizar la busqueda de las rutas con Origen = CiudadOTarifasBuscar
   begin
       case pcTarifas.TabIndex of
        0 : CargaRutas_(sagRutas,sagRutasMio,sbRutas,_ORIGEN);
        1:  ShowMessage('Debes elegir un Origen de Ruta.');
        2 : CargaRutas_(sagRutasAgrega,sagRutasAgregaMio,sbRutasAgrega,_ORIGEN);
        3 : ShowMessage('Debes elegir un Origen de Ruta.');
       else ;
       end;
   end;
   3 :  // realizar la busqueda de las rutas con Destino = CiudadDTarifasBuscar
   begin
       case pcTarifas.TabIndex of
        0 : CargaRutas_(sagRutas,sagRutasMio,sbRutas,_DESTINO);
        1:  ShowMessage('Debes elegir un Origen de Ruta.');
        2 : CargaRutas_(sagRutasAgrega,sagRutasAgregaMio,sbRutasAgrega,_DESTINO);
        3 : ShowMessage('Debes elegir un Origen de Ruta.');
       else ;
       end;
   end;

  else ;
  end;
  //
  idRutaTarifasBuscar:= 0 ;
  CiudadOTarifasBuscar:= '';
  CiudadDTarifasBuscar:= '';
end;

procedure TfrmTarifa.CargaRutas_(sagVisible, sagMio: TstringAlignGrid;
  panel: TStatusBar; _: String);
var Renglon: Integer;
begin
   if _ = _ORIGEN then
       sql:='select ID_RUTA as ID ,CONCAT(ORIGEN,'' - '',DESTINO) as RUTA from T_C_RUTA '+
            ' Where ORIGEN = '+ QuotedStr(CiudadOTarifasBuscar)
   else if _ = _DESTINO then
       sql:='select ID_RUTA as ID ,CONCAT(ORIGEN,'' - '',DESTINO) as RUTA from T_C_RUTA '+
            ' Where DESTINO = '+ QuotedStr(CiudadDTarifasBuscar);
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage(_ERR_SQL);
      Exit;
   end;
   renglon:=1;
   sagVisible.RowCount:=   registrosDe(Query)+1;
   sagMio.RowCount:= registrosDe(Query)+1;
   sagVisible.Cells[0,0]:='RUTAS';
   sagMio.Cells[0,0]:='RUTAS';
   while not query.Eof do
   begin
      sagVisible.Cells[0,renglon]:=    Query.FieldByName('RUTA').AsString+
                                           Forza_Der('('+Query.FieldByName('ID').AsString+')',9);

      sagMio.Cells[0,renglon] := Query.FieldByName('ID').AsString;
      Query.Next;
      inc(renglon);
   end;
   panel.Panels[0].Text:='Rutas: '+ IntToStr(registrosDe(Query));
   panel.Panels[1].Text:= 'Tramos';
end;

procedure TfrmTarifa.CargaRuta(sagVisible, sagMio: TstringAlignGrid;
  panel: TStatusBar; idRuta: String);
  var renglon : Integer;
begin
    sql:='select ID_RUTA as ID ,CONCAT(ORIGEN,'' - '',DESTINO) as RUTA from T_C_RUTA '+
            ' Where id_ruta = '+ idRuta ;
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage(_ERR_SQL);
      Exit;
   end;
   renglon:=1;
   sagVisible.RowCount:=   registrosDe(Query)+1;
   sagMio.RowCount:=       registrosDe(Query)+1;
   sagVisible.Cells[0,0]:='RUTAS';
   sagMio.Cells[0,0]:='RUTAS';
   while not query.Eof do
   begin
      sagVisible.Cells[0,renglon]:= Query.FieldByName('RUTA').AsString+
                                    Forza_Der('('+Query.FieldByName('ID').AsString+')',9);
      sagMio.Cells[0,renglon] := Query.FieldByName('ID').AsString;
      Query.Next;
      inc(renglon);
   end;
   panel.Panels[0].Text:='Rutas: '+ IntToStr(registrosDe(Query));
   panel.Panels[1].Text:= 'Tramos';
end;
{procedimiento para limpiar el grid que es pasado como parametro}
procedure TfrmTarifa.LimpiaGrid(Grid: TstringAlignGrid);
var x,i : Integer;
begin
   for x:= 1 to Grid.RowCount do
      for i:= 0 to Grid.ColCount do
         Grid.Cells[i,x]:='';
end;

procedure TfrmTarifa.lscbOrigenChange(Sender: TObject);
begin
  CargaDestinos(lscbOrigen.CurrentID,sagTramosRutaDesdeOrigenMio,
                sagTramosRutaDesdeOrigen,   sbRutasDesdeOrigen);
end;


procedure TfrmTarifa.cargaDestinosTarifa(Origen: String; sagMio,
  sagVisible: TStringAlignGrid; panel: TStatusBar; idServicio: Integer);
begin

   if cbFechaHora.Checked then
   sql:='Select TRA.KM, TRA.DESTINO, TAD.MONTO '+
        ' From T_C_TRAMO AS TRA '+
        ' LEFT JOIN PDV_C_TARIFA AS TAR ON (TAR.ID_TRAMO = TRA.ID_TRAMO) '+
        ' LEFT JOIN PDV_C_TARIFA_D AS TAD ON (TAD.ID_TARIFA= TAR.ID_TARIFA) '+
        ' WHERE TRA.ORIGEN = '+QuotedStr(Origen)+' AND TAR.ID_SERVICIO='+
        ' AND TAD.FECHA_HORA_APLICA ='+
        ' SELECT MAX(FECHA_HORA_APLICA) '+
        ' FROM PDV_C_TARIFA_D '+
        ' WHERE ID_TARIFA =(SELECT ID_TARIFA '+
        ' FROM PDV_C_TARIFA '+
        ' WHERE ID_TRAMO= '+
        ' AND ID_SERVICIO='+
        ' ORDER BY TRA.DESTINO ASC '
   else
   begin
        dtpAlDia.Time:= dtpAlaHora.Time;
   sql:='Select TRA.KM, TRA.DESTINO, TAD.MONTO '+
        ' From T_C_TRAMO AS TRA '+
        ' LEFT JOIN PDV_C_TARIFA AS TAR ON (TAR.ID_TRAMO = TRA.ID_TRAMO) '+
        ' LEFT JOIN PDV_C_TARIFA_D AS TAD ON (TAD.ID_TARIFA= TAR.ID_TARIFA) '+
        ' WHERE TRA.ORIGEN = '+QuotedStr(Origen)+' AND TAR.ID_SERVICIO='+
        ' AND TAD.FECHA_HORA_APLICA <= '+
             QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',dtpAlDia.DateTime))+
        ' SELECT MAX(FECHA_HORA_APLICA) '+
        ' FROM PDV_C_TARIFA_D '+
        ' WHERE ID_TARIFA =(SELECT ID_TARIFA '+
        ' FROM PDV_C_TARIFA '+
        ' WHERE ID_TRAMO= '+
        ' AND ID_SERVICIO='+
        ' ORDER BY TRA.DESTINO ASC   ';
  end;

end;

procedure TfrmTarifa.sagTramosRutaDesdeOrigenSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
   renglonTramo:= Arow;
   if lscbServicios.ItemIndex <=0 then Exit;
   OrigenOrigen.SetID(lscbOrigen.CurrentID);
   DestinoOrigen.SetID(sagTramosRutaDesdeOrigen.Cells[1,Arow]);
   edTarifaOrigen.Text:= FormatFloat('#,##',
                      (CargaTarifa(sagTramosRutaDesdeOrigenMio.Cells[2,renglonTramo],
                       lscbServicios.CurrentID, edTarifaOrigen, panelAgrega2)));
end;

procedure TfrmTarifa.btnGuarda2Click(Sender: TObject);
begin
  if not AccesoPermitido(TButton(Sender).Tag, _NO_RECUERDA_TAGS) then
        Exit;
   if GuardaAltaTarifa(panelAgrega2,edTarifaOrigen) then
      ShowMessage(_OPERACION_SATISFACTORIA);
end;

procedure TfrmTarifa.btnCancela2Click(Sender: TObject);
begin
   panelAgrega2.Enabled:=   False;
   edTarifaOrigen.Text :='';
   edTarifaOrigen.Enabled:= False;
end;

FUNCTION TfrmTarifa.CargaTodoRuta(idRuta: String): STRING;
begin
   SQL:='SELECT T.ID_TRAMO, T.ORIGEN, T.DESTINO, RD.ORDEN'+
      ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
      ' WHERE RD.ID_RUTA='+IdRuta;
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage(_ERR_SQL);
      Exit;
   end;
   SQL:='SELECT T.ID_TRAMO, T.ORIGEN, T.DESTINO'+
        ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
        ' WHERE RD.ID_RUTA='+IdRuta;
   while not Query.Eof do
   begin
     SQL:=SQL +      ' UNION '+
                     'select T.ID_TRAMO, T.ORIGEN, T.DESTINO '+
                     ' FROM T_C_TRAMO AS T '+
                     ' WHERE T.ORIGEN = '+qUOTEDsTR(Query.FieldByName('ORIGEN').AsString)+
                     ' AND T.DESTINO IN ( '+
                     '    SELECT T.DESTINO '+
                     '    FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
                     '    WHERE RD.ID_RUTA=' + idRuta +
                     '    AND ORDEN >='+Query.FieldByName('ORDEN').AsString+') ';
     Query.Next;
   end;
   SQL:= SQL + ' ORDER BY ORIGEN, DESTINO';
   RESULT:= SQL;
end;

function TfrmTarifa.RegresaTramos(idRuta: String; Orden: Integer): String;
begin
   if (Orden > 0) then
   begin
      RegresaTramos(idRuta,Orden-1);
   end
   else
   begin
      exit;
   end;
end;

function TfrmTarifa.forza_der(cadena:string;no:integer):string;
var
  temp : string;
begin
  temp := '';
  if length(cadena) <= no then
  begin
    temp := espacios(no - length(cadena)) + cadena;
  end
  else
    temp := copy(cadena,1,no);

  result := temp;
end;

function TfrmTarifa.espacios(no:integer):string;
var
  temp : string;
  x : integer;
begin
  temp := '';
  for x := 1 to no do
    temp := temp + ' ';

  result := temp;
end;

function TfrmTarifa.forza_izq(cadena:string;no:integer):string;
var
  temp : string;
begin
  temp := '';
  if length(cadena) <= no then
  begin
    temp := cadena + espacios(no - length(cadena));
  end
  else
    temp := copy(cadena,1,no);

  result := temp;
end;



procedure TfrmTarifa.edTarifaOrigenKeyPress(Sender: TObject;
  var Key: Char);
begin
if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
if key = #13 then
      btnGuarda2Click(btnGuarda2);
end;

end.
