unit frmFaltantesYSobrantes;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, lsCombobox, Grids, Data.SqlExpr,
  Db;

  const
  _SIN_ELECCION_REPORTE= 'Debe de elegir un reporte.';
type
    _CIUDADES = record
       ciudad: string;
       nombre: string;
  end;
type
    _EMPLEADOS = record
        clave: String;
        nombre: string;
 end;
 type
 TMonto = class
     descripcion: String;
     monto : double;
     procedure CreateObject(Odescripcion: String; Omonto: Double);
  end;

type
  TfrmFaltantesSobrantes = class(TForm)
    Panel1: TPanel;
    finicial: TDateTimePicker;
    ffinal: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    rgOpcionesReporte: TRadioGroup;
    Label3: TLabel;
    lscbOpcionReporte: TlsComboBox;
    Label4: TLabel;
    lscbSubOpcionReporte: TlsComboBox;
    btnGeneraReporte: TButton;
    btnExportar: TButton;
    sagDatosReporte: TStringGrid;
    procedure rgOpcionesReporteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnGeneraReporteClick(Sender: TObject);
    procedure btnExportarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  LFaltantesSobrantes: TStringList;
    { Private declarations }
    function LlenaCiudades  : Boolean; // llena el arreglo
    function LlenaComisiones: Boolean; // llena el arreglo
    function CargaCiudades  : Boolean; // carga el lsComboBox
    function CargaComisiones: Boolean; // carga el lsComboBox
    function LlenaEmpleados : Boolean; // llena el arreglo
    function CargaEmpleados : Boolean; // carga el lsComboBox
    function regresaTerminales: String; // regresa las terminales del arreglo
    function regresaComisiones: String; // regresa las comisiones del arreglo
    function SumaCantidades(Descripcion : String; Cantidad: Double) : Boolean;
    procedure LimpiarObjetosLista(lista: TstringList);

  public
    { Public declarations }
  end;

var
  Query : TSQLQuery;
  frmFaltantesSobrantes: TfrmFaltantesSobrantes;
  terminales: Array of _CIUDADES;
  comisiones: Array of _CIUDADES;
  empleados : Array of _EMPLEADOS;
  _Montos   : TMonto;

implementation

uses DMdb, comun, comunii;

{$R *.dfm}

procedure TfrmFaltantesSobrantes.rgOpcionesReporteClick(Sender: TObject);
begin
case rgOpcionesReporte.ItemIndex of
0  : begin
          label3.Visible:= True;
          label3.Caption:= 'Elige Terminal:';
          lscbOpcionReporte.Visible:= True;
          CargaCiudades;
          label4.Visible:= True;
          label4.Caption:= 'Elige Empleado:' ;
          // cargar empleados de esa terminal
          lscbSubOpcionReporte.Visible:= True;
          lscbSubOpcionReporte.ItemIndex:= -1;
     end;
1  : begin
          label3.Visible:= True;
          label3.Caption:= 'Elige Comision:';
          lscbOpcionReporte.Visible:= True;
          CargaComisiones;
          label4.Visible:= True;
          label4.Caption:= 'Elige Empleado:' ;
          // cargar empleados de esa comision
          lscbSubOpcionReporte.Visible:= True;
          lscbSubOpcionReporte.ItemIndex:= -1;
     end;
2  : begin
          label3.Visible:= False;
          label3.Caption:= '';
          lscbOpcionReporte.Visible:= False;
          label4.Visible:= True;
          label4.Caption:= 'Elige Empleado:';
          lscbSubOpcionReporte.Visible:= True;
          lscbSubOpcionReporte.ItemIndex:= -1;
     end;
3  : begin
          label3.Visible:= False;
          label3.Caption:= '';
          lscbOpcionReporte.Visible:= False;
          label4.Visible:= True;
          label4.Caption:= 'Elige Empleado:';
          lscbSubOpcionReporte.Visible:= True;
          lscbSubOpcionReporte.ItemIndex:= -1;
     end;
4  : begin
          label3.Visible:= False;
          label3.Caption:= '';
          lscbOpcionReporte.Visible:= False;
          label4.Visible:= False;
          label4.Caption:= '';
          lscbSubOpcionReporte.Visible:= False;
     end;
else ;
end;

end;

function TfrmFaltantesSobrantes.SumaCantidades(Descripcion: String;
  Cantidad: Double): Boolean;
var indice: Integer;
    existe: Boolean;
begin
   indice:= LFaltantesSobrantes.IndexOf(Descripcion);
   if indice >= 0 then
    begin
      TMonto(LFaltantesSobrantes.Objects[indice]).monto:=
           TMonto(LFaltantesSobrantes.Objects[indice]).monto + Cantidad;
   end
   else
   begin
      _Montos:= TMonto.Create;
      _Montos.CreateObject(Descripcion, Cantidad);
      LFaltantesSobrantes.AddObject(Descripcion, _Montos);
   end;
end;

procedure TfrmFaltantesSobrantes.FormCreate(Sender: TObject);
begin
   gds_actions.ID.Clear;
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   // llenar ciudades
   llenaCiudades;
   // llenar comisiones
   llenaComisiones;
   // llena el arreglo de empleados
   llenaEmpleados;
   // carga el lscbSubOpcionReporte
   cargaEmpleados;
end;

procedure TfrmFaltantesSobrantes.FormShow(Sender: TObject);
begin
   gds_actions.clear;
   finicial.Date:= Now;
   ffinal.Date  := Now;
end;

function TfrmFaltantesSobrantes.LlenaCiudades: Boolean;
var i, totalCds: integer;
begin
// funcion que realiza el llenado de las ciudades en un arreglo para despues
// vaciarlo en un comboBox cuando sea elegido por el usuario para el reporte
   sql:= 'SELECT ID_TERMINAL, DESCRIPCION AS CIUDAD  '+
         ' FROM T_C_TERMINAL '+
         ' WHERE TIPO = '+quotedStr(_CIUDAD_TERMINAL)+
         ' AND FECHA_BAJA IS NULL;';
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage('Error al cargar las terminales.');
      Exit;
   end;
   totalCds:= registrosDe(query);
   SetLength(terminales, totalCds);
   for i:=0 to totalCds-1 do
   begin
     terminales[i].ciudad:= Query.FieldByName('ID_TERMINAL').AsString;
     terminales[i].nombre:= Query.FieldByName('ID_TERMINAL').AsString + ' ' +Query.FieldByName('CIUDAD').AsString;
     query.Next;
   end;



end;

function TfrmFaltantesSobrantes.LlenaComisiones: Boolean;
var i, totalCds: integer;
begin
// funcion que realiza el llenado de las comisiones en un arreglo para despues
// vaciarlo en un comboBox cuando sea elegido por el usuario para el reporte
   sql:= 'SELECT ID_TERMINAL, DESCRIPCION AS CIUDAD '+
         ' FROM T_C_TERMINAL '+
         ' WHERE TIPO = '+quotedStr(_CIUDAD_COMISION)+
         ' AND FECHA_BAJA IS NULL;';
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage('Error al cargar las comisiones.');
      Exit;
   end;
   totalCds:= registrosDe(query);
   SetLength(comisiones, totalCds);
   for i:=0 to totalCds-1 do
   begin
     comisiones[i].ciudad:= Query.FieldByName('ID_TERMINAL').AsString;
     comisiones[i].nombre:= Query.FieldByName('ID_TERMINAL').AsString + ' ' + Query.FieldByName('CIUDAD').AsString;
     query.Next;
   end;

end;

function TfrmFaltantesSobrantes.LlenaEmpleados: Boolean;
var i, totalEmps: integer;
begin
// funcion que realiza el llenado de los empleados en un arreglo para despues
// vaciarlo en un comboBox cuando sea elegido por el usuario para el reporte
   sql:= 'SELECT TRAB_ID AS CLAVE, NOMBRE '+
         ' FROM PDV_C_USUARIO P'+
         ' WHERE ID_GRUPO IN ('+ _EMPLEADOS_VENTA +')';
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage('Error al cargar los empleados.');
      Exit;
   end;
   totalEmps:= registrosDe(query);
   SetLength(empleados, totalEmps);
   for i:=0 to totalEmps-1 do
   begin
     empleados[i].clave:= Query.FieldByName('CLAVE').AsString;
     empleados[i].nombre:= Query.FieldByName('NOMBRE').AsString;
     query.Next;
   end;
end;

procedure TfrmFaltantesSobrantes.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    gds_actions.clear;
end;

procedure TfrmFaltantesSobrantes.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    Query.free;
end;

function TfrmFaltantesSobrantes.CargaCiudades: Boolean;
var i: Integer;
begin
  //
  lscbOpcionReporte.Clear;
  for i:=0 to length(terminales)-1 do
     lscbOpcionReporte.Add(terminales[i].nombre, terminales[i].ciudad);
end;

function TfrmFaltantesSobrantes.CargaComisiones: Boolean;
var i: Integer;
begin
  //
  lscbOpcionReporte.Clear;
  for i:=0 to length(comisiones)-1 do
     lscbOpcionReporte.Add(comisiones[i].nombre, comisiones[i].ciudad);
end;

function TfrmFaltantesSobrantes.CargaEmpleados: Boolean;
var i: Integer;
begin
  //
  lscbSubOpcionReporte.Clear;
  lscbSubOpcionReporte.Add('TODOS LOS EMPLEADOS','TODOS');
  for i:=1 to length(empleados)-1 do
     lscbSubOpcionReporte.Add(empleados[i].NOMBRE, empleados[i].CLAVE);

end;

procedure TfrmFaltantesSobrantes.btnGeneraReporteClick(Sender: TObject);
VAR AUX, fechas : STRING;
   NombreArchivo  : String;
   Archivo: TextFile;
begin
fechas:= ' AND FECHA_INICIO BETWEEN ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn',finicial.DateTime)) +
         ' AND ' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn',ffinal.DateTime)) ;
case rgOpcionesReporte.ItemIndex of
0  : begin
          If ((lscbOpcionReporte.ItemIndex < 0) or
              (lscbSubOpcionReporte.ItemIndex < 0)) then
             Exit;
          // depende si se selecciona un empleado o se eligen todos los empleados
          if lscbsUBOpcionReporte.ItemIndex = 0 then
             aux:= ''
          else if lscbSUBOpcionReporte.ItemIndex > 0 then
             aux:= 'C.ID_EMPLEADO = ' + QUOTEDSTR(LSCBSUBOPCIONREPORTE.CurrentID) + ' AND ';
          // formas de pago
          SQL:='SELECT CU. NOMBRE, CD.ID_TERMINAL AS TERMINAL, FP.DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_FORMA_PAGO AS FP ON (FP.ID_FORMA_PAGO = CD.ID_FORMA_PAGO) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleados
               ' CD.ID_TERMINAL = '+ QuotedStr(lscbOpcionReporte.CurrentID)+ // solo una terminal
               ' AND CD.ENTREGA <> SISTEMA ' + fechas +
               ' UNION ' +
          // tipos de ocupantes
               'SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL, CO.DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE,  '+
                ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA,ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_OCUPANTE AS CO ON (CO.ID_OCUPANTE = CD.ID_OCUPANTE) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleados
               ' CD.ID_TERMINAL = '+ QuotedStr(lscbOpcionReporte.CurrentID)+    // solo una terminal
               ' AND CD.ENTREGA <> SISTEMA ' + fechas+
               ' UNION ' +
          // efectivo, recolecciones y cancelados
               ' SELECT CU.NOMBRE,  CD.ID_TERMINAL AS TERMINAL, CD.TIPO AS DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE, ' +
                ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, ' +
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON  (C.ID_TERMINAL = CD.ID_TERMINAL AND '+
               '  C.ID_CORTE = CD.ID_CORTE) '+
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +    // empleados
               ' CD.ID_TERMINAL = ' + QuotedStr(lscbOpcionReporte.CurrentID)+ // solo una terminal
               ' AND CD.ENTREGA <> SISTEMA  AND FECHA_INICIO '+   fechas +
               ' AND CD.TIPO IN ('+ QuotedStr(_TIPO_EFECTIVO) +
               ' , ' + QuotedStr(_TIPO_RECOLECCIONES) +
               ' , ' + QuotedStr(_TIPO_CANCELADOS) + ')'+
               ' ORDER BY 4,3;';

          end;
1  : begin
         If ((lscbOpcionReporte.ItemIndex < 0) or
              (lscbSubOpcionReporte.ItemIndex < 0)) then
             Exit;
         if lscbsUBOpcionReporte.ItemIndex = 0 then
             aux:= ''
          else if lscbSUBOpcionReporte.ItemIndex > 0 then
             aux:= ' C.ID_EMPLEADO = ' + QUOTEDSTR(LSCBSUBOPCIONREPORTE.CurrentID) + ' AND ';
          // formas de pago
          SQL:='SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL,  FP.DESCRIPCION , CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_FORMA_PAGO AS FP ON (FP.ID_FORMA_PAGO = CD.ID_FORMA_PAGO) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleados
               ' CD.ID_TERMINAL = '+ QuotedStr(lscbOpcionReporte.CurrentID)+ // solo una comision
               ' AND CD.ENTREGA <> SISTEMA ' + fechas +
               ' UNION ' +
          // tipos de ocupantes
               'SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL,  CO.DESCRIPCION , CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_OCUPANTE AS CO ON (CO.ID_OCUPANTE = CD.ID_OCUPANTE) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleados
               ' CD.ID_TERMINAL = '+ QuotedStr(lscbOpcionReporte.CurrentID)+    // solo una comision
               ' AND CD.ENTREGA <> SISTEMA ' + fechas+
               ' UNION ' +
          // efectivo, recolecciones y cancelados
               ' SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL, CD.TIPO AS DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE, ' +
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, ' +
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON  (C.ID_TERMINAL = CD.ID_TERMINAL AND '+
               '  C.ID_CORTE = CD.ID_CORTE) '+
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +    // empleados
               ' CD.ID_TERMINAL = ' + QuotedStr(lscbOpcionReporte.CurrentID)+ // solo una comision
               ' AND CD.ENTREGA <> SISTEMA  AND FECHA_INICIO '+   fechas +
               ' AND CD.TIPO IN ('+ QuotedStr(_TIPO_EFECTIVO) +
               ' , ' + QuotedStr(_TIPO_RECOLECCIONES) +
               ' , ' + QuotedStr(_TIPO_CANCELADOS) + ')'+
               ' ORDER BY 4,3;';
     end;
2  : begin
         If (lscbSubOpcionReporte.ItemIndex < 0) then
             Exit;
         if lscbsUBOpcionReporte.ItemIndex = 0 then
             aux:= ''
          else if lscbSUBOpcionReporte.ItemIndex > 0 then
             aux:= ' ID_EMPLEADO = ' + QUOTEDSTR(LSCBSUBOPCIONREPORTE.CurrentID) + ' AND';

          // formas de pago
          SQL:='SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL,  FP.DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, SISTEMA- ENTREGA,0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_FORMA_PAGO AS FP ON (FP.ID_FORMA_PAGO = CD.ID_FORMA_PAGO) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleado.s
               ' C.ID_TERMINAL IN ('+ regresaTerminales +')'+ // TODAS LAS TERMINALES
               ' AND CD.ENTREGA <> SISTEMA ' + fechas +
               ' UNION ' +
          // tipos de ocupantes
               'SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL, CO.DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, SISTEMA- ENTREGA,0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_OCUPANTE AS CO ON (CO.ID_OCUPANTE = CD.ID_OCUPANTE) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleado.s
               ' C.ID_TERMINAL IN ('+ regresaTerminales +')'+ // TODAS LAS TERMINALES
               ' AND CD.ENTREGA <> SISTEMA ' + fechas+
               ' UNION ' +
          // efectivo, recolecciones y cancelados
               ' SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL, CD.TIPO AS DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE, ' +
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, ' +
               ' IF(ENTREGA< SISTEMA, SISTEMA- ENTREGA,0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON  (C.ID_TERMINAL = CD.ID_TERMINAL AND '+
               '  C.ID_CORTE = CD.ID_CORTE) '+
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +    // empleado.s
               ' C.ID_TERMINAL IN ('+ regresaTerminales +')'+ // TODAS LAS TERMINALES
               ' AND CD.ENTREGA <> SISTEMA  AND FECHA_INICIO '+   fechas +
               ' AND CD.TIPO IN ('+ QuotedStr(_TIPO_EFECTIVO) +
               ' , ' + QuotedStr(_TIPO_RECOLECCIONES) +
               ' , ' + QuotedStr(_TIPO_CANCELADOS) + ')'+
               ' ORDER BY 4,3;';
     end;
3  : begin
         If (lscbSubOpcionReporte.ItemIndex < 0) then
             Exit;
         if lscbsUBOpcionReporte.ItemIndex = 0 then
             aux:= ''
          else if lscbSUBOpcionReporte.ItemIndex > 0 then
             aux:= ' ID_EMPLEADO = ' + QUOTEDSTR(LSCBSUBOPCIONREPORTE.CurrentID) + ' AND ';
          // formas de pago
          SQL:='SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL,   FP.DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_FORMA_PAGO AS FP ON (FP.ID_FORMA_PAGO = CD.ID_FORMA_PAGO) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleado.s
               ' C.ID_TERMINAL IN ('+ regresaComisiones +')'+ // TODAS LAS COMISIONES
               ' AND CD.ENTREGA <> SISTEMA ' + fechas +
               ' UNION ' +
          // tipos de ocupantes
               'SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL,  CO.DESCRIPCION,  CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_OCUPANTE AS CO ON (CO.ID_OCUPANTE = CD.ID_OCUPANTE) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +   // empleado.s
               ' C.ID_TERMINAL IN ('+ regresaComisiones +')'+ // TODAS LAS COMISIONES
               ' AND CD.ENTREGA <> SISTEMA ' + fechas+
               ' UNION ' +
          // efectivo, recolecciones y cancelados
               ' SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL, CD.TIPO AS DESCRIPCION, CD.ID_CORTE AS FOLIO_CORTE, ' +
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, ' +
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE  '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON  (C.ID_TERMINAL = CD.ID_TERMINAL AND '+
               '  C.ID_CORTE = CD.ID_CORTE) '+
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE '+ AUX +    // empleado.s
               ' C.ID_TERMINAL IN ('+ regresaComisiones +')'+ // TODAS LAS COMISIONES
               ' AND CD.ENTREGA <> SISTEMA  AND FECHA_INICIO '+   fechas +
               ' AND CD.TIPO IN ('+ QuotedStr(_TIPO_EFECTIVO) +
               ' , ' + QuotedStr(_TIPO_RECOLECCIONES) +
               ' , ' + QuotedStr(_TIPO_CANCELADOS) + ')'+
               ' ORDER BY 4,3;';

     end;
4  : begin
          // formas de pago
          SQL:='SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL, FP.DESCRIPCION , CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_FORMA_PAGO AS FP ON (FP.ID_FORMA_PAGO = CD.ID_FORMA_PAGO) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE  CD.ENTREGA <> SISTEMA ' + fechas +
               ' UNION ' +
          // tipos de ocupantes
               'SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL, CO.DESCRIPCION , CD.ID_CORTE AS FOLIO_CORTE,  '+
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, '+
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON '+
               ' (C.ID_TERMINAL = CD.ID_TERMINAL AND C.ID_CORTE = CD.ID_CORTE)' +
               ' JOIN PDV_C_OCUPANTE AS CO ON (CO.ID_OCUPANTE = CD.ID_OCUPANTE) ' +
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE  CD.ENTREGA <> SISTEMA ' + fechas+
               ' UNION ' +
          // efectivo, recolecciones y cancelados
               ' SELECT CU.NOMBRE, CD.ID_TERMINAL AS TERMINAL,CD.TIPO AS DESCRIPCION,  CD.ID_CORTE AS FOLIO_CORTE, ' +
               ' CD.ENTREGA, CD.SISTEMA AS MERCURIO,  '+
               ' IF(ENTREGA> SISTEMA, ENTREGA- SISTEMA,0) AS SOBRANTE, ' +
               ' IF(ENTREGA< SISTEMA, ABS(SISTEMA- ENTREGA),0) AS FALTANTE '+
               ' FROM PDV_CORTE_D AS CD JOIN PDV_T_CORTE AS C ON  (C.ID_TERMINAL = CD.ID_TERMINAL AND '+
               '  C.ID_CORTE = CD.ID_CORTE) '+
               ' JOIN PDV_C_USUARIO AS CU ON (CU.TRAB_ID = C.ID_EMPLEADO) ' +
               ' WHERE  CD.ENTREGA <> SISTEMA  AND FECHA_INICIO '+   fechas +
               ' AND CD.TIPO IN ('+ QuotedStr(_TIPO_EFECTIVO) +
               ' , ' + QuotedStr(_TIPO_RECOLECCIONES) +
               ' , ' + QuotedStr(_TIPO_CANCELADOS) + ')'+
               ' ORDER BY 4,3;';
     end;
else
    Showmessage(_SIN_ELECCION_REPORTE);
    exit;
end;
   IF EjecutaSQL(sql, Query, _LOCAL) then
   begin
      DataSetToSag(QUERY,sagDatosReporte);
   end;



end;

function TfrmFaltantesSobrantes.regresaComisiones: String;
var i: Integer;
begin
 //
 for i:=0 to length(comisiones)-1 do
     result:= result + QuotedStr(Comisiones[i].ciudad) + ',';
 result:= result + '''''';

end;

function TfrmFaltantesSobrantes.regresaTerminales: String;
var i: Integer;
begin
 //
 for i:=0 to length(terminales)-1 do
     result:= result + QuotedStr(Terminales[i].ciudad)+ ',';
  result:= result + '''''';
end;

procedure TfrmFaltantesSobrantes.btnExportarClick(Sender: TObject);
var i, x: Integer;
    NombreArchivo: String;
    ARchivo: TextFile;
begin
   LFaltantesSobrantes := TStringList.Create;
   NombreArchivo:='FaltantesSobrantes.'+  VarToStr(FormatDateTime('ddmmyyyy',finicial.Date)) +
                  VarToStr(FormatDateTime('ddmmyyyy',ffinal.Date))+ gs_terminal +
                  '.txt';
   try
      Assignfile(Archivo, NombreArchivo);
      //System.IO.Path.GetTempPath +
       if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
    begin
        deleteFile(NombreArchivo);
        rewrite(Archivo); // lo crea
    end
    else
        rewrite(Archivo);   // Lo crea
   // CODIGO ANTERIOR
   WriteLn(Archivo,'');
   WriteLn(Archivo,'Reporte de Faltantes y Sobrantes de Cortes Emitidos entre ');
   WriteLn(Archivo,VarToStr(FormatDateTime('dd/mm/yyyy',finicial.Date))+ ' al ' + VarToStr(FormatDateTime('dd/mm/yyyy',ffinal.Date)));
   WriteLn(Archivo,'Reporte Emitido en: '+ gs_terminal + ',  ' + VarToStr(FormatDateTime('dd/mm/yyyy hh:nn',now())));
   WriteLn(Archivo,'');     WriteLn(Archivo,'');
   Query.First;
   for i:=0 to sagDatosReporte.rowcount - 1 do
      begin
        for x:=0 to sagDatosReporte.ColCount - 1 do
        begin
          if x=0 then
             Write(Archivo, Forza_Izq(sagDatosReporte.Cells[x,i],45))
          else
          Write(Archivo, Forza_Izq(sagDatosReporte.Cells[x,i],15));
        end;
    WriteLn(Archivo,'');
    end;
      WriteLn(Archivo,'');   WriteLn(Archivo,'');
   except
      CloseFile(Archivo);
      showMEssage(_REPORTE_FALLO);
   end;
   LFaltantesSobrantes.Destroy;

end;

{ TMonto }

procedure TMonto.CreateObject(Odescripcion: String; Omonto: double);
begin
   descripcion:= Odescripcion;
   monto:= Omonto;
end;


procedure TfrmFaltantesSobrantes.LimpiarObjetosLista(lista: TstringList);
var indice: Integer;
begin
   for indice:= 0 to Lista.Count-1 do
    TObject(Lista.Objects[indice]).Free;
  Lista.Clear;
end;


 {

      for i:=0 to LFaltantesSobrantes.Count -1 do
         WriteLn(Archivo,Forza_Izq(TMonto(LFaltantesSobrantes.Objects[i]).descripcion,30) +
                         Forza_DER(varToStr(TMonto(LFaltantesSobrantes.Objects[i]).monto), 20));
      LimpiarObjetosLista(LFaltantesSobrantes);
      CloseFile(Archivo);
      ShowMessage(_REPORTE_EXISOTO);
   
}

end.
