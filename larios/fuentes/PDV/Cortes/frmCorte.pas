unit frmCorte;
{
Autor: Gilberto Almanza Maldonado
Fecha: Jueves 26 de Noviembre 10:57 am
Descripcion: Forma que permite realizar las siguientes funciones:
      * Corte de Fin de Turno de promotores
      * Pre Corte para arqueo
      * Visualizacion de Cortes de dias Pasados
}
interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids, Data.SqlExpr,
  XPStyleActnCtrls, ActnList,   ActnMan,  DB, ImgList, Buttons,
  ShellAPI, System.ImageList, System.Actions;

Type
TServiciosGlobal = class
     servicio: String;
     efectivo: double;
     ixe  : double;
     banamex : double;
     procedure CreateObjectS(Oservicio: String; Oefectivo: double; Oixe : double; Obanamex: double);
  end;
TFechasGlobal = class
     fecha: String;
     boletos: integer;
     monto  : double;
     procedure CreateObject(Ofecha: String; Oboletos: Integer; Omonto : double);
  end;

  TfrmCortes = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    edEfectivo: TEdit;
    Label4: TLabel;
    edRecolecciones: TEdit;
    lblEfectivo: TLabel;
    lblRecolecciones: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    lscbEmpleado: TlsComboBox;
    dtpFechaCorte: TDateTimePicker;
    Label2: TLabel;
    ActionManager1: TActionManager;
    act144: TAction;
    act145: TAction;
    act146: TAction;
    act147: TAction;
    act148: TAction;
    Label5: TLabel;
    Label6: TLabel;
    lblCancelados: TLabel;
    edCancelados: TEdit;
    Label8: TLabel;
    lblRecolecciones2: TLabel;
    lblEfectivo2: TLabel;
    lblCancelados2: TLabel;
    act149: TAction;
    act152: TAction;
    imagenes: TImageList;
    btnProcesar: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    Action1: TAction;
    Label7: TLabel;
    edtNoRecos: TEdit;
    lblRecos: TLabel;
    lblRecos2: TLabel;
    BitBtn3: TBitBtn;
    actRefresh: TAction;
    lblIxes: TLabel;
    lblIxes2: TLabel;
    edIxes: TEdit;
    Label11: TLabel;
    lblBanamex: TLabel;
    lblBanamex2: TLabel;
    lbl3: TLabel;
    edtBanamex: TEdit;
    sagFormas: TStringGrid;
    sagDescuentos: TStringGrid;
    Action2: TAction;
    Action3: TAction;
    procedure FormShow(Sender: TObject);
    Procedure CargaEmpleados(Estatus: String; CondicionFecha: String);
    procedure act148Execute(Sender: TObject);
    procedure dtpFechaCorteKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lscbEmpleadoExit(Sender: TObject);
    procedure lscbEmpleadoKeyPress(Sender: TObject; var Key: Char);
    procedure CargaFormasPago(sagFormas: TStringGrid; Tipo: Char);
    procedure CargaDescuentos(sagDescuentos: TStringGrid; Tipo: Char);
    PROCEDURE LlenaGrid(sag: TStringGrid; Tipo: String; Folio: Integer; Terminal: String);
    PROCEDURE LlenaDinero(ed: TEdit;lbl, lbl2: TLabel;Tipo: String; Folio: Integer; Terminal: String);
    procedure LimpiaGrid(sag: TStringGrid);
    procedure sagFormasSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sagDescuentosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sagFormasKeyPress(Sender: TObject; var Key: Char);
    procedure edEfectivoKeyPress(Sender: TObject; var Key: Char);
    procedure act144Execute(Sender: TObject);
    function ActualizaCorteD(FolioCorte: Integer; Ciudad: String): Boolean;
    function RevisaEntrega(sag: TStringGrid; columna: integer): Boolean;
    Procedure LimpiaForma;
    procedure edCanceladosKeyPress(Sender: TObject; var Key: Char);
    procedure act145Execute(Sender: TObject);
    procedure act146Execute(Sender: TObject);
    Procedure CorteTipoServicio(fechaInicial, fechaFinal: TDateTime; Terminal: String);
    Procedure CargaEncabezados;
    procedure act147Execute(Sender: TObject);
    procedure llenaGridsCeros;
    procedure act149Execute(Sender: TObject);
    procedure act152Execute(Sender: TObject);
    procedure DeshacerCambios(corte, terminal: String);
    procedure Button1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ReplicaCorte(folio: string);
    procedure actRefreshExecute(Sender: TObject);
    Function PreLlenaCampos(Folio: Integer;  Trab_Id: String): Boolean;
    Function RegresaDescripcionFP(Forma: String): String;
    function RegresaDescripcionD(Forma: String): String;
    Function RegresaRenglon(Cadena: String; grid: TStringGrid): Integer;
    Function RemplazaDecimal(cadena : String) : String;

    function imprimeHojaDosCorte: Boolean;
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);

  private
    { Private declarations }
    const
        _CONFIRMAR = MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2;
    var
    Query, QueryD, Query2, QueryFormasPago, QueryOcupantes, QueryEntregado, QueryFechas : TSQLQuery;
    Querys: TSQLQuery;
    SProc: TSQLQuery;

    idsNombres, Folios, IdsOcupantes, IdsFormasPago:  TlsComboBox;
    Columna, Renglon: Integer;
    Lfechas: TstringList;
    taquillaCorteActual: Integer;
    imprimeHojaDos: Boolean;
  public
    { Public declarations }

  end;

var
  frmCortes: TfrmCortes;
  _fechas:   TFechasGlobal;
  _servicios: TServiciosGlobal;
  bandera: boolean; // permite saber si se ejecutaron todas las instrucciones del proceso del corte.


implementation

uses DMdb, frmCorteTipoServicio, comunii, comun, uCortes, frmCorteFinDeDia,
  u_impresion, frmAsignacionFondo;

{$R *.dfm}
{
Funcion:     CargaEmpleados
Parametros:  Estatus y ConficionFecha string ambas
Esta funcion realiza la carga de los empleados segun el  estatus enviado
en el parámetro Estatus, puede ser
_PROCESO_DE_CORTE, _STAND_BY y _FINALIZADO
y segun la CondicionFecha que puede ser
_EMPLEADOS_FILTRO que va de una fecha inicial a una fecha final
_EMPLEADOS_TODOS  que no ha sido procesado su corte.
}
procedure TfrmCortes.CargaEmpleados(Estatus: String; CondicionFecha: String);
begin
   sql:='SELECT C.ID_CORTE, U.NOMBRE, U.TRAB_ID , C.ID_CORTE, C.FECHA_INICIO '+
        ' FROM PDV_T_CORTE AS C JOIN PDV_C_USUARIO AS U ON (U.TRAB_ID = C.ID_EMPLEADO) '+
        ' WHERE C.ESTATUS IN ' + '(' + Estatus + ')' +
        ' AND ' +
        'C.ID_TERMINAL='+QuotedStr(gs_terminal)+' AND   '+ CondicionFecha;
  // ShowMEssage(sql);
  if not EjecutaSQL(sql,Query,_LOCAL) then
  begin
     ShowMessage('Error al cargar la lista de usuarios del dia: '+
                 VarToStr(FormatDateTime('dd/mm/yyyy',dtpFechaCorte.Date)));
     Exit;
  end;
  lscbEmpleado.Clear;
  Folios.Clear;
  idsNombres.Clear;
  while not Query.Eof do
  begin
     lscbEmpleado.Add(forza_izq(QUERY.FieldByName('ID_CORTE').AsString,10) +
                      forza_izq(query.FieldByName('NOMBRE').AsString,35)   +
                      forza_der(VarToStr(FormatDateTime('dd/mm/yyyy',query.FieldByName('FECHA_INICIO').AsDateTime)),10),
                      QUERY.FieldByName('ID_CORTE').AsString+ Query.fieldByName('TRAB_ID').AsString);
     //(Query.fieldByName('NOMBRE').AsString, Query.fieldByName('TRAB_ID').AsString);
     Folios.Add(QUERY.FieldByName('ID_CORTE').AsString + Query.fieldByName('TRAB_ID').AsString,
                Query.fieldByName('ID_CORTE').AsString);
     idsNombres.Add(Query.fieldByName('TRAB_ID').AsString, Query.fieldByName('ID_CORTE').AsString);
     Query.Next;
  end;
end;

procedure TfrmCortes.CargaEncabezados;
begin
   sagFormas.Cells[0,0]:='FORMA';
   sagFormas.Cells[1,0]:='ENTREGA';
   sagFormas.Cells[2,0]:='MERCURIO';
   sagFormas.Cells[3,0]:='SOBRANTE';
   sagFormas.Cells[4,0]:='FALTANTE';
   sagDescuentos.Cells[0,0]:='DESCUENTO';
   sagDescuentos.Cells[1,0]:='ENTREGA';
   sagDescuentos.Cells[2,0]:='MERCURIO';
   sagDescuentos.Cells[3,0]:='SOBRANTE';
   sagDescuentos.Cells[4,0]:='FALTANTE';

end;

procedure TfrmCortes.FormShow(Sender: TObject);
begin
  gds_actions.clear;
  bandera:= False;
  CargaEncabezados;

  case tipoCorte of
     _CORTE_FIN_DIA : begin
             dtpFechaCorte.Date:= fechaCorte;
             Self.Caption:= 'CORTES DE FIN DE TURNO =GPM=';
             dtpFechaCorte.Enabled:= False;
             CargaEmpleados(_PROCESO_DE_CORTE,_EMPLEADOS_TODOS);
             act145.Enabled:= False;   // imprimir
             act144.Enabled:= False;   // procesar
             act148.Enabled:= False;  // cambiar fecha
             act152.Enabled:= False; // Arqueo
         end;
     _CORTE_PASADO : begin
             act144.Enabled:=False;
             dtpFechaCorte.Date:= fechaCorte;
             Self.Caption:= 'CORTES DE FIN DE DIAS PASADOS =GPM=';
             dtpFechaCorte.Enabled:= False;
             act145.Enabled:= False;  // imprimir
             act144.Enabled:= False;  // procesar
             act152.Enabled:= False; // Arqueo
         end;
     _CORTE_AUDITORIA:
     begin
             Self.Caption:= 'ARQUEOS (informativo) =GPM=';
             dtpFechaCorte.Enabled:= False;
             act144.Enabled:= False;  // procesar
             act145.Enabled:= False;  // imprimir
             act146.Enabled:= False;  // corte de fin de dia
             act147.Enabled:= False;  // corte por tipo de servicio
             act148.Enabled:= False;  // cambiar fecha
             act152.Enabled:= True; // Arqueo
             CargaEmpleados(_NO_FINALIZADO, _EMPLEADOS_TODOS);
     end;
  else ;
  end;

end;

procedure TfrmCortes.act148Execute(Sender: TObject);
begin
//    if not AccesoPermitido(tAction(Sender).Tag) then
//      Exit;
    dtpFechacorte.Enabled:=  True;
    dtpFechaCorte.SetFocus;
end;

procedure TfrmCortes.dtpFechaCorteKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
   begin
       LimpiaForma;
       TDateTimePicker(Sender).Enabled := False;
       // SE CARGARAN LOS EMPLEADOS CON ESTATUS FINALIZADO, ES DECIR QUE YA HAYAN
       // PROCESADO SU CORTE PREVIAMENTE, INCLUSO SI FUERA EL DIA DE HOY.
       CargaEmpleados(_FINALIZADO,Format(_EMPLEADOS_FILTRO, [FormatDateTime('yyyy/mm/dd 00:00:01',Trunc(dtpFechaCorte.DateTime)),
                                    FormatDateTime('yyyy/mm/dd 23:59:59',Trunc(dtpFechaCorte.DateTime))]));
   end;
end;

procedure TfrmCortes.FormCreate(Sender: TObject);
begin
{creo mis objetos query en tiempo de ejecucion}
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   QueryD:= TSQLQuery.Create(SELF);
   QueryD.SQLConnection:= DM.Conecta;
   Query2:= TSQLQuery.Create(Self);
   Query2.SQLConnection:= dm.Conecta;
   QueryFormasPago:= TSQLQuery.Create(Self);
   QueryFormasPago.SQLConnection:= dm.Conecta;
   QueryOcupantes:= TSQLQuery.Create(Self);
   QueryOcupantes.SQLConnection:= dm.Conecta;
   QueryFechas:= TSQLQuery.Create(Self);
   QueryFechas.SQLConnection:= dm.Conecta;
   QueryEntregado:= TSQLQuery.Create(Self);
   QueryEntregado.SQLConnection:= dm.Conecta;
   Querys:= TSQLQuery.Create(Self);
   Querys.SQLConnection:= dm.Conecta;
   SProc:= TSQLQuery.Create(self);
   SProc.SQLConnection := dm.Conecta;
   idsOcupantes  := TlsComboBox.Create(Self);
   idsOcupantes.Parent := Self;
   idsOcupantes.Visible:= False;
   idsNombres  := TlsComboBox.Create(Self);
   idsNombres.Parent := Self;
   idsNombres.Visible:= False;
   idsFormasPago := TlsComboBox.Create(Self);
   idsFormasPago.Parent := Self;
   idsFormasPago.Visible:= False;
   Folios:= TlsComboBox.Create(Self);
   Folios.Parent := Self;
   Folios.Visible := False;
   inicializaImpresionVars(); // OBTENGO LA IMPRESORA DONDE IMPRIMIRE LOS CORTES  EN gs_ImprimirAdicional
   imprimeHojaDos := imprimeHojaDosCorte;
end;

procedure TfrmCortes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    gds_actions.clear;
end;

procedure TfrmCortes.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
{destruyo los querys creados al inicio cuando salgo de la forma}
  Query.Destroy;
  idsFormasPAgo.Destroy;
  idsOcupantes.Destroy;
  idsNombres.destroy;
  Folios.Destroy;
  Querys.Destroy;
  Query2.Destroy;
  QueryFormasPago.Destroy;
  QueryFechas.Destroy;
  QueryOcupantes.Destroy;
  QueryEntregado.Destroy;
  QueryD.Destroy;
end;
{
Carga los datos de un corte dependiendo si la forma es
 _CORTE_FIN_DIA, carga los datos existentes para descuentos y formas de pago
 _CORTE_PASADO, carga los datos almacenados del corte del promotor
}
procedure TfrmCortes.lscbEmpleadoExit(Sender: TObject);
begin
   if lscbEmpleado.ItemIndex < 0 then Exit;
   LimpiaForma;
   CargaEncabezados;
   Folios.SetItem(lscbEmpleado.CurrentID);
   taquillaCorteActual:= RegresaImpresoraVenta(StrToInt(Folios.currentID));
   case tipoCorte of
     _CORTE_FIN_DIA : begin
             CargaDescuentos(sagDescuentos,_DATOS_LIMPIOS);
             CargaFormasPago(sagFormas,_DATOS_LIMPIOS);
             act144.Enabled:= True;
             //preparo los datos//
             Folios.SetItem(lscbEmpleado.CurrentID);
             idsNombres.ItemIndex:= lscbEmpleado.ItemIndex;
             // mando llamar al pre llenado de datos para que los muetsra y revise el cajero //
             PreLlenaCampos(StrToInt(Folios.currentID) , idsNombres.CurrentItem);
         end;
     _CORTE_PASADO : begin
             Folios.SetItem(lscbEmpleado.CurrentID);
             LlenaDinero(edRecolecciones,lblRecolecciones, lblRecolecciones2,_TIPO_RECOLECCIONES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edtNoRecos,lblRecos, lblRecos2,_TOTAL_RECOLECCIONES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edCancelados, lblCancelados,lblCancelados2, _TIPO_CANCELADOS,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edEfectivo,lblEfectivo,lblEfectivo2,_TIPO_EFECTIVO,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edIxes,lblIxes,lblIxes2,_TIPO_IMPORTE_IXES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edtBanamex, lblBanamex, lblBanamex2, _TIPO_IMPORTE_BANAMEX, sTRtOiNT(fOLIOS.CurrentID), QuotedStr(gs_terminal));
             LlenaGrid(sagFormas,_TIPO_FORMAS,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaGrid(sagDescuentos,_TIPO_DESCUENTO,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             act145.Enabled:= True;
             act144.Enabled:= False;
         end;
     _CORTE_AUDITORIA : begin
             CargaDescuentos(sagDescuentos,_DATOS_LIMPIOS);
             CargaFormasPago(sagFormas,_DATOS_LIMPIOS);
         end;

 else ;
 end;
end;

procedure TfrmCortes.lscbEmpleadoKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
      lscbEmpleadoExit(Sender);
end;

function TfrmCortes.PreLlenaCampos(Folio: Integer;  Trab_Id: String): Boolean;
begin
   sql:='SELECT IFNULL(FONDO_INICIAL, 0) AS FONDO_INICIAL, IFNULL(BOL_CANCELADOS,0) AS BOL_CANCELADOS,  '+
        ' IFNULL(NO_RECOLECCION,0) AS NO_RECOLECCION, IFNULL(TOTAL_RECOL,0) AS TOTAL_RECOL, '+
        ' IFNULL(TOTAL_EFECTIVO,0) AS TOTAL_EFECTIVO, IFNULL(APA,0) AS APA, ' +
        ' IFNULL(ORD100 ,0) AS ORD100, IFNULL(ORD50,0) AS ORD50, IFNULL(SEDENA,0) AS SEDENA, ' +
        ' IFNULL(TICKETBUS,0) AS TICKETBUS, IFNULL(FAM,0) AS FAM, ' +
        ' IFNULL(IXE_BOLETOS,0) AS IXE_BOLETOS, IFNULL(IXE_TICKETS,0) AS IXE_TICKETS, ' +
        ' IFNULL(IXE_IMPORTE,0) AS IXE_IMPORTE, IFNULL(BAN_BOLETOS,0) AS BAN_BOLETOS, ' +
        ' IFNULL(BAN_TICKETS,0) AS BAN_TICKETS, IFNULL(BAN_IMPORTE,0) AS BAN_IMPORTE, FECHA, ' +
        ' TURNO, IFNULL(SEDENA2,0) AS SEDENA2, IFNULL(FAM2,0) AS FAM2 , ' +
        ' IFNULL(PAS_TRAS,0) AS PAS_TRAS,  ' +
        ' IFNULL(AGE_NCIA,0) AS AGE_NCIA   ' +
        ' FROM PDV_T_PRECORTE WHERE ID_CORTE= '+ IntToStr(Folio)+
        ' AND TRAB_ID='+QuotedStr(Trab_id)+ ' ;';
   if not EjecutaSQL(sql, Query, _LOCAL) then
   begin
     ShowMessage(comunii._ERROR_PRE_LLENADO);
     Exit;
   end;
   // PRIMERO LLENO LA PARTE DE LOS CUADROS DE TEXTO//
   edEfectivo.Text     :=  FORMAT('%f', [Query.FieldByName('TOTAL_EFECTIVO').AsFloat]);
   edtNoRecos.Text     :=  FORMAT('%f', [Query.FieldByName('NO_RECOLECCION').AsFloat]);
   edRecolecciones.Text:=  FORMAT('%f', [Query.FieldByName('TOTAL_RECOL').AsFloat]);
   edCancelados.Text   :=  FORMAT('%f', [Query.FieldByName('BOL_CANCELADOS').AsFloat]);
   edIxes.Text         :=  FORMAT('%f', [Query.FieldByName('IXE_IMPORTE').AsFloat]);
   edtBanamex.Text     :=  FORMAT('%f', [Query.FieldByName('BAN_IMPORTE').AsFloat]);
   // DESPUES LLENO LOS GRIDS CON LA INFO DE FORMAS DE PAGO Y DESCUENTOS //
   // las constantes _CAMPO_FORMA_PAGO_ ALGO   son las abreviaciones de las //
   //  formas de pago en la tabla de PDV_C_FORMA_PAGO  //
   // Y EL CAMPO QUE VA EN EL    Query.FieldByName('CAMPO').AsFloat  ES EL NOBRE
   // DEL CAMPO DE LA TABLA DE LARIOS DEL PRECORTE.  PDV_T_PRECORTE
   sagFormas.cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_APA)), sagFormas)] :=
        FORMAT('%f', [Query.FieldByName('APA').AsFloat]);
   sagFormas.cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_IXES)), sagFormas)] :=
        FORMAT('%f', [Query.FieldByName('IXE_BOLETOS').AsFloat]);
   sagFormas.cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_BANAMEX)), sagFormas)] :=
        FORMAT('%f', [Query.FieldByName('BAN_BOLETOS').AsFloat]);
   sagFormas.cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_SEDENA)), sagFormas)] :=
        FORMAT('%f', [Query.FieldByName('SEDENA2').AsFloat]);
   sagFormas.cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_ORD50)), sagFormas)] :=
        FORMAT('%f', [Query.FieldByName('ORD50').AsFloat]);
   sagFormas.cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_ORD100)), sagFormas)] :=
        FORMAT('%f', [Query.FieldByName('ORD100').AsFloat]);
   sagFormas.Cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_PASE_TRASLADO)),sagFormas)]:=
        FORMAT('%f', [Query.FieldByName('PAS_TRAS').AsFloat]);
   sagFormas.Cells[1, RegresaRenglon((RegresaDescripcionFP(_CAMPO_FORMA_PAGO_AGENCIA)),sagFormas)]:=
        FORMAT('%f', [Query.FieldByName('AGE_NCIA').AsFloat]);

  // las constantes _CAMPO_DESCUENTO_ALGO   son las DESCRIPCIONES de los //
   //  DESCUENTOS en la tabla de PDV_C_OCUPANTE  //
   // Y EL CAMPO QUE VA EN EL    Query.FieldByName('CAMPO').AsFloat  ES LA
   // DESCRIPCION DEL CAMPO DE LA TABLA DE LARIOS DEL PRECORTE.  PDV_T_PRECORTE
   sagDescuentos.cells[1, RegresaRenglon((RegresaDescripcionD(_CAMPO_DESCUENTO_FAM)), sagDescuentos)] :=
        FORMAT('%f', [Query.FieldByName('FAM2').AsFloat]);
end;

// funcion que regresa la descripcion un una forma de pago enviada DE LA TABLA PDV_C_FORMA_PAGO
function TfrmCortes.RegresaDescripcionFP(Forma: String): String;
begin
   sql:='SELECT DESCRIPCION FROM PDV_C_FORMA_PAGO WHERE ABREVIACION = ' + QuotedStr(Forma);
   if not EjecutaSQL(sql, QueryFormasPago , _LOCAL) then
   begin
     ShowMessage(comunii._ERROR_CONSULTA_FORMA_PAGO);
     Exit;
   end;
   result:= QueryFormasPago.FieldByName('DESCRIPCION').AsString;
end;

// funcion que regresa la descripcion un DESCUENTO  enviado DE LA TABLA PDV_C_OCUPANTE
function TfrmCortes.RegresaDescripcionD(Forma: String): String;
begin
   sql:='SELECT DESCRIPCION FROM PDV_C_OCUPANTE WHERE ABREVIACION = ' + QuotedStr(Forma);
   if not EjecutaSQL(sql, QueryFormasPago , _LOCAL) then
   begin
     ShowMessage(comunii._ERROR_CONSULTA_DESCUENTO);
     Exit;
   end;
   result:= QueryFormasPago.FieldByName('DESCRIPCION').AsString;
end;

// fuincion que regrsa el renglon del campo enviado en el grid enviado
function TfrmCortes.RegresaRenglon(Cadena: String;
  grid: TStringGrid): Integer;
var i: Integer;
begin
    for i := 1 to grid.RowCount do
      begin
        if grid.Cells[0,i] = Cadena then
        begin
          result:= i;
          exit;
        end;
      end;
end;



function TfrmCortes.RemplazaDecimal(cadena: String): String;
var
    li_ctrl : integer;
    ls_cadena : string;
    lc_char    : Char;
begin
    for li_ctrl := 1 to length(cadena) do begin
        lc_char := cadena[li_ctrl];
        if lc_char = ',' then
          ls_cadena := ls_cadena + '.'
        else
          ls_cadena := ls_cadena + lc_char
    end;
    Result := ls_cadena;
end;


{funcion que permite el llenado de los descuentos tales como:
Menores
Adultos
Profesores
El tipo es:
    _DATOS_LIMPIOS    =  'L';
    _DATOS_GUARDADOS  =  'G';
}
procedure TfrmCortes.CargaDescuentos(sagDescuentos: TStringGrid;
  Tipo: Char);
var renglon: Integer;
begin
 case Tipo of
   _DATOS_LIMPIOS : begin
       sql:= 'SELECT ID_OCUPANTE, DESCRIPCION, '' '' AS ENTREGA, '' '' AS MERCURIO '+
             ' , '' '' AS SOBRANTE, '' '' AS FALTANTE '+
             '  FROM PDV_C_OCUPANTE WHERE FECHA_BAJA IS NULL AND ID_OCUPANTE <> 1; ' ;
       if not EjecutaSQL(sql, Query, _LOCAL) then Exit;
       LimpiaGrid(sagDescuentos);
       idsOcupantes.Clear;
       sagDescuentos.RowCount := registrosDe(Query)+1;
       for renglon:=1 to registrosDe(Query)  do
       begin
           idsOcupantes.Add(Query.FieldByName('DESCRIPCION').AsString,
                            Query.FieldByName('ID_OCUPANTE').AsString );
           sagDescuentos.cells[0, renglon]:= Query.FieldByName('DESCRIPCION').AsString;
           sagDescuentos.cells[1, renglon]:= Query.FieldByName('ENTREGA').AsString;
           sagDescuentos.cells[2, renglon]:= Query.FieldByName('MERCURIO').AsString;
           Query.Next;
       end; // end del for que controla los renglones
   end;
   _DATOS_GUARDADOS: begin
   end;
 else ;
 end;

end;

{
Funcion que permite el llenado de las Formas de Pago, tales como:
OR1
OR5
SEDENA
El tipo es:
    _DATOS_LIMPIOS    =  'L';
    _DATOS_GUARDADOS  =  'G';
}
procedure TfrmCortes.CargaFormasPago(sagFormas: TStringGrid;
  Tipo: Char);
var renglon : integer;
begin
 case Tipo of
   _DATOS_LIMPIOS : begin
       sql:= 'SELECT ID_FORMA_PAGO, DESCRIPCION, '' '' AS ENTREGA, '' '' AS MERCURIO '+
             ' , '' '' AS SOBRANTE, '' '' AS FALTANTE '+
             '  FROM PDV_C_FORMA_PAGO WHERE FECHA_BAJA IS NULL AND ID_FORMA_PAGO <> 1; ' ;
       if not EjecutaSQL(sql, Query, _LOCAL) then Exit;
       LimpiaGrid(sagFormas);
       idsFormasPago.Clear;
       sagFormas.RowCount:= registrosDe(Query)+1;
       for renglon:=1 to registrosDe(Query)  do
        begin
           idsFormasPago.Add(Query.FieldByName('DESCRIPCION').AsString,
                            Query.FieldByName('ID_FORMA_PAGO').AsString );
           sagFormas.cells[0, renglon]:= Query.FieldByName('DESCRIPCION').AsString;
           sagFormas.cells[1, renglon]:= Query.FieldByName('ENTREGA').AsString;
           sagFormas.cells[2, renglon]:= Query.FieldByName('MERCURIO').AsString;
           Query.Next;
        end; // end del for que controla los renglones

   end;
   _DATOS_GUARDADOS: begin
   end;
 else ;
 end;
end;
{
Funcion:   LimpiaGrid
Parametros: sag
limpia todas las celdas del parametro recibido
}
procedure TfrmCortes.LimpiaGrid(sag: TStringGrid);
var x,i : Integer;
begin
   for x:= 1 to sag.RowCount do
      for i:= 0 to sag.ColCount do
         sag.Cells[i,x]:='';
end;
{
Funcion:  sagFormasSelectCell
Asigna el valor de ACol  a Columna y el valor de ARow a Renglon
en el sagFormas
}
procedure TfrmCortes.sagFormasSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
   Columna:= Acol;
   Renglon:= ARow;
end;


{
Funcion:  sagDescuentosSelectCell
Asigna el valor de ACol  a Columna y el valor de ARow a Renglon
en el sagDescuentos
}
procedure TfrmCortes.sagDescuentosSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
   Columna:= Acol;
   Renglon:= ARow;
end;
{
Funcion que permite no pintar caracteres amenos de que sea en la columna
numero 1 y siempre y cuando sean numeros
}
procedure TfrmCortes.sagFormasKeyPress(Sender: TObject; var Key: Char);
begin
  if tipoCorte in [_CORTE_FIN_DIA, _CORTE_PASADO] then key:= _BLANCO;
  if lscbEmpleado.ItemIndex < 0 then
      Key := _BLANCO;
  if Columna <> 1 then Key := _BLANCO;
  if not (Key in ['0'..'9', #8, #13]) then
    Key := _BLANCO;
end;

{
Funcion que solo acepta numeros para edEfectivo
}
procedure TfrmCortes.edEfectivoKeyPress(Sender: TObject; var Key: Char);
begin
   if lscbEmpleado.ItemIndex < 0 then
      Key := _BLANCO;

   if tipoCorte in [_CORTE_FIN_DIA, _CORTE_PASADO] then
      key:= _BLANCO;
   if not (Key in ['0'..'9', #8, #13,'.']) then
          Key := _BLANCO;
end;
{
funcion 
}
procedure TfrmCortes.act144Execute(Sender: TObject);
var Folio: Integer;
    IdCajero: String;
begin
   if lscbEmpleado.ItemIndex < 0 then
   begin
     ShowMEssage('Elije un promotor para continuar.');
     Exit;
   end;

   if ( not RevisaEntrega(sagFormas,1) ) or  (not RevisaEntrega(sagDescuentos,1)) or
      (TRIM(EdEfectivo.Text) = '')   or (TRIM(edRecolecciones.Text)= ''  ) or
      (trim(edCancelados.Text) = '')  then
      llenaGridsCeros;

   if not AccesoPermitido(tAction(Sender).Tag,_RECUERDA_TAGS) then
      Exit;
   Folios.SetItem(lscbEmpleado.CurrentID);
   Folio:= StrToInt(Folios.currentID);  // TOMAR EL FOLIO DEL CORTE
   {
   El Stored Procedure de PDV_PROCESA_CORTE   :
     cierra corte, toma fechas, inserta en tabla detalle Efectivo, Recolecciones,
     manda a llamar a los Stored Procedures de:
      PDV_PROCESA_CORTE_FORMAS_PAGO
      PDV_PROCESA_CORTE_DESCUENTOS
   Todo de acuerdo a lo que el sistema tiene registrado
   }
   UCortes.InicializaDatos(idsNombres.CurrentItem, idsNombres.CurrentiD);
   taquillaCorteActual := UCORTES.RegresaImpresoraVenta(Folio);
   if UCORTES.RegresaImpresoraVenta(Folio)  =  0 then
   BEGIN
      if not  RevisaFoliosCorte(idsNombres.CurrentiD ,idsNombres.CurrentItem) then
      begin
        Exit;
      end;
   END;

   uCortes.FinalizaDatos;
   IdCajero:= gs_trabid; // cajero
   SQL:='CALL PDV_PROCESA_CORTE('+ IntToStr(Folio) +  ',' + QuotedStr(gs_terminal)+ ','+ QuotedStr(IdCajero)+');';
   if MessageDlg(_PREGUNTA_PROCESO, mtConfirmation,mbYesNo,0) = mrYes then
      if  EjecutaSQL(SQL, Query, _LOCAL) then
             if ActualizaCorteD(Folio, gs_terminal) then  // actualizo la tabla con los datos introducidos por el cajero
             begin
                 Folios.SetItem(lscbEmpleado.CurrentID); // TOMO EL FOLIO DEL CORTE
                 LlenaDinero(edRecolecciones,lblRecolecciones,lblRecolecciones2,_TIPO_RECOLECCIONES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
                 LlenaDinero(edtNoRecos,lblRecos, lblRecos2,_TOTAL_RECOLECCIONES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
                 LlenaDinero(edCancelados, lblCancelados,lblCancelados2, _TIPO_CANCELADOS,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
                 LlenaDinero(edEfectivo,lblEfectivo,lblEfectivo2,_TIPO_EFECTIVO,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
                 LlenaDinero(edIxes,lblIxes,lblIxes2,_TIPO_IMPORTE_IXES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
                 LlenaDinero(edtBanamex, lblBanamex, lblBanamex2, _TIPO_IMPORTE_BANAMEX, sTRtOiNT(fOLIOS.CurrentID), QuotedStr(gs_terminal));
                 LlenaGrid(sagFormas,_TIPO_FORMAS,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
                 LlenaGrid(sagDescuentos,_TIPO_DESCUENTO,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
                 act145Execute(act145);
                 bandera:= False;
                 act144.Enabled:= False;
                 ReplicaCorte(varToStr(Folio));
             end
             ELSE
             begin
                 { El stored procedure, elimina los datos del precorte y abre nuevamente el corte para volver a ser procesado }
                 SQL:='CALL PDV_BORRA_CORTE('+ IntToStr(Folio) +  ',' + QuotedStr(gs_terminal)+');';
                 if  EjecutaSQL(SQL, Query, _LOCAL) then
                     ShowMessage('Ocurrio un error en el proceso de corte, intentelo nuevamente (1).');
             end
       ELSE
       begin
             { El stored procedure, elimina los datos del precorte y abre nuevamente el corte para volver a ser procesado }
             SQL:='CALL PDV_BORRA_CORTE('+ IntToStr(Folio) +  ',' + QuotedStr(gs_terminal)+');';
             if  EjecutaSQL(SQL, Query, _LOCAL) then
                 ShowMessage('Ocurrio un error en el proceso de corte, intentelo nuevamente (2).');
       end;
      limpiaForma;
      FormShow(Self);

end;
{
Funcion que permite la actualizacion de la entrega capturada por el cajero
en los registros previamente insertados para un folio de corte y una ciudad
determinados.
Se actualizan todos los rubros del corte.
}
procedure TfrmCortes.Action1Execute(Sender: TObject);
begin
   Close;
end;

procedure TfrmCortes.Action2Execute(Sender: TObject);
begin
  //  if not AccesoPermitido(214, _NO_RECUERDA_TAGS) then
  //      Exit;
   try
        frmAsignarFondo := TfrmAsignarFondo.Create(Self);
        frmAsignarFondo.tipoFormulario:= _TIPO_FONDO_PRE;
        frmAsignarFondo.ShowModal;
    finally
        frmAsignarFondo.Free;
        frmAsignarFondo := nil;
    end;
end;

procedure TfrmCortes.Action3Execute(Sender: TObject);
begin
 // if not AccesoPermitido(214, _NO_RECUERDA_TAGS) then
 //       Exit;
   try
        frmAsignarFondo := TfrmAsignarFondo.Create(Self);
        frmAsignarFondo.tipoFormulario:= _TIPO_FONDO_POST;
        frmAsignarFondo.ShowModal;
    finally
        frmAsignarFondo.Free;
        frmAsignarFondo := nil;
    end;
end;

procedure TfrmCortes.actRefreshExecute(Sender: TObject);
begin
    case tipoCorte of
     _CORTE_FIN_DIA : begin
            CargaEmpleados(_PROCESO_DE_CORTE,_EMPLEADOS_TODOS);
         end;
     _CORTE_PASADO : begin
         end;
     _CORTE_AUDITORIA:
     begin
            CargaEmpleados(_NO_FINALIZADO, _EMPLEADOS_TODOS);
     end;
  else ;
  end;
end;


Function TfrmCortes.ActualizaCorteD(FolioCorte: Integer; Ciudad: String): Boolean;
var i : integer;
begin
   bandera:= True;
   TRY
     // sql := 'START TRANSACTION WITH CONSISTENT SNAPSHOT; ' ;
     // actualizo el efectivo entregado
     sql:= 'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(EdEfectivo.Text) +
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) +
                  ' AND TIPO='+ QuotedStr(_TIPO_EFECTIVO)+';';
     Querys.SQL.Clear;
     Querys.SQL.Add(sql);
     Querys.ExecSQL;

     // actualizo las recolecciones entregadas
     sql:= 'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(edRecolecciones.Text) +
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) +
                  ' AND TIPO='+ QuotedStr(_TIPO_RECOLECCIONES)+';';
     Querys.SQL.Clear;
     Querys.SQL.Add(sql);
     Querys.ExecSQL;
     // actualizo los cancelados entregados
     sql:= 'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(edCancelados.Text) +
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) +
                  ' AND TIPO='+ QuotedStr(_TIPO_CANCELADOS)+';';
     Querys.SQL.Clear;
     Querys.SQL.Add(sql);
     Querys.ExecSQL;
     // actualizo EL TOTAL DE LAS RECOLECCIONES
     sql:= 'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(edtNoRecos.Text) +
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) +
                  ' AND TIPO='+ QuotedStr(_TOTAL_RECOLECCIONES)+';';
     Querys.SQL.Clear;
     Querys.SQL.Add(sql);
     Querys.ExecSQL;

     // actualizo EL IMPORTE DE IXES
     sql:= 'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(edIxes.Text) +
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) +
                  ' AND TIPO='+ QuotedStr(_TIPO_IMPORTE_IXES)+';';
     Querys.SQL.Clear;
     Querys.SQL.Add(sql);
     Querys.ExecSQL;

     // actualizo EL IMPORTE DE BANAMEX
     sql:= 'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(edtBanamex.Text) +
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) +
                  ' AND TIPO='+ QuotedStr(_TIPO_IMPORTE_BANAMEX)+';';
     Querys.SQL.Clear;
     Querys.SQL.Add(sql);
     Querys.ExecSQL;

     for i:=1 to sagDescuentos.RowCount -1 do
     begin
      idsOcupantes.SetItem(sagDescuentos.Cells[0,i]);  // me posiciono en el descuento correspondiente
      sql:=  'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(sagDescuentos.Cells[1,i])+
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) + ' AND ' +
                  ' ID_OCUPANTE=' + idsOcupantes.CurrentID+ ';';
      Querys.SQL.Clear;
      Querys.SQL.Add(sql);
      Querys.ExecSQL;
     end;
     for i:=1 to sagFormas.RowCount -1 do
     begin
      idsFormasPago.SetItem(sagFormas.Cells[0,i]);   // me posiciono en la forma de pago correspondiente
      sql:= 'UPDATE PDV_CORTE_D SET ENTREGA = '+ RemplazaDecimal(sagFormas.Cells[1,i])+
                  ' WHERE ID_TERMINAL='+  QuotedStr(Ciudad) + ' AND ' +
                  ' ID_CORTE= ' + IntToStr(FolioCorte) + ' AND ' +
                  ' ID_FORMA_PAGO=' + idsFormasPago.CurrentID+ ';';
      Querys.SQL.Clear;
      Querys.SQL.Add(sql);
      Querys.ExecSQL;
     end;
   sql:= 'DELETE FROM PDV_CORTE_D '+
               ' WHERE SISTEMA = 0 AND ENTREGA = 0 AND ID_CORTE =' + IntToStr(FolioCorte) +
               ' AND ID_TERMINAL= '+  QuotedStr(Ciudad) +
               ' AND TIPO NOT IN ('+ QuotedStr(_TIPO_EFECTIVO)+ ',' + QuotedStr(_TIPO_RECOLECCIONES) +');';
   Querys.SQL.Clear;
   Querys.SQL.Add(sql);
   Querys.ExecSQL;
   EXCEPT
       sql:= 'DELETE FROM PDV_CORTE_D '+
               ' WHERE ID_CORTE =' + IntToStr(FolioCorte) +
               ' AND ID_TERMINAL= '+  QuotedStr(Ciudad) + ';';
       Querys.SQL.Clear;
       Querys.SQL.Add(sql);
       Querys.ExecSQL;
       result:= False;
       Exit;
   END;
   Result:= True;
end;
{
Funcion que revisa que el sag enviado como parametros no tenga valores
'' y de ser asi regresa como resultado FALSE.
Si el resultado es TRUE es por que todos los valores esperados son
numericos.
}

procedure TfrmCortes.ReplicaCorte(folio: string);
var ocupante, forma_pago: string;
begin
   sql:= 'SELECT * FROM PDV_T_CORTE WHERE ID_CORTE='+ folio +
         ' AND ID_TERMINAL ='+ QuotedStr(gs_terminal)+';';
   if ejecutaSQL(sql,Query,_LOCAL) then
   begin

      SQL:='DELETE FROM PDV_T_CORTE WHERE ID_CORTE=' + folio +
            ' AND ID_TERMINAL ='+ QuotedStr(gs_terminal)+';';
      comunii.replicaCORPORATIVO(sql);
      SQL:='DELETE FROM PDV_CORTE_D WHERE ID_CORTE=' + folio +
            ' AND ID_TERMINAL ='+ QuotedStr(gs_terminal)+';';
      comunii.replicaCORPORATIVO(sql);

      sql:='INSERT INTO PDV_T_CORTE(ID_TERMINAL, ID_CORTE,ID_TAQUILLA, ID_EMPLEADO,' +
           ' FECHA_INICIO, FECHA_FIN, ESTATUS, FONDO_INICIAL, ID_CAJERO)'+
           ' VALUES('+QuotedStr(Query.FieldByName('ID_TERMINAL').AsString)+','+
                  Query.FieldByName('ID_CORTE').AsString+','+
                  Query.FieldByName('ID_TAQUILLA').AsString+','+
                  QuotedStr(Query.FieldByName('ID_EMPLEADO').AsString)+','+
                  QuotedStr(vartostr( FormatDateTime('yyyy-mm-dd hh:NN:ss',Query.FieldByName('FECHA_INICIO').AsDateTime)))+','+
                  QuotedStr(vartostr( FormatDateTime('yyyy-mm-dd hh:NN:ss',Query.FieldByName('FECHA_FIN').AsDateTime)))+','+
                  QuotedStr(Query.FieldByName('ESTATUS').AsString)+','+
                  Query.FieldByName('FONDO_INICIAL').AsString+','+
                  QuotedStr(Query.FieldByName('ID_CAJERO').AsString)+');';
      comunii.replicaCORPORATIVO(sql);
   end;
   sql:= 'SELECT * FROM PDV_CORTE_D WHERE ID_CORTE='+ folio +
         ' AND ID_TERMINAL =' +QuotedStr(gs_terminal)+';';
   if ejecutaSQL(sql,Query,_LOCAL) then
   begin
      while not Query.Eof do
      begin
          if Query.FieldByName('ID_OCUPANTE').IsNull then
            ocupante:= 'null'
          else
            ocupante:= Query.FieldByName('ID_OCUPANTE').AsString;
          if Query.FieldByName('ID_FORMA_PAGO').isnull then
             forma_pago:='null'
          else forma_pago:= Query.FieldByName('ID_FORMA_PAGO').AsString;
          sql:='INSERT INTO PDV_CORTE_D(ID_TERMINAL, ID_CORTE, ENTREGA, SISTEMA,'+
               ' TIPO, ID_OCUPANTE, ID_FORMA_PAGO) '+
               'VALUES('+QuotedStr(Query.FieldByName('ID_TERMINAL').AsString)+','+
                  Query.FieldByName('ID_CORTE').AsString+','+
                  Query.FieldByName('ENTREGA').AsString+','+
                  Query.FieldByName('SISTEMA').AsString+','+
                  QuotedStr(Query.FieldByName('TIPO').AsString)+','+
                  ocupante +','+
                  forma_pago+');';
           comunii.replicaCORPORATIVO(sql);
           QUERY.Next;
      end;

   end;



end;

function TfrmCortes.RevisaEntrega(sag: TStringGrid;
  columna: integer): Boolean;
var renglon: integer;
begin
   result:= True;
   for renglon:=1 to sag.RowCount-1 do
     if (Trim(sag.Cells[columna, renglon])='') then
         result:= False;
end;

{PROCEDIMIENTO QUE TOMA TIPOS DE FORMA Y DESCUENTOS DE UN CORTE  Y UNA TERMINAL
DADAS Y LOS MANDA AL GRID CORRESPONDIENTE.
}
procedure TfrmCortes.LlenaGrid(sag: TStringGrid; Tipo: String;
  Folio: Integer; Terminal: String);
begin
 IF TIPO = _TIPO_FORMAS THEN
   SQL:= 'SELECT F.DESCRIPCION AS FORMA, CD.ENTREGA, CD.SISTEMA AS MERCURIO, IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
         ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE '+
         ' FROM PDV_CORTE_D as CD JOIN PDV_C_FORMA_PAGO AS F ON (F.ID_FORMA_PAGO = CD.ID_FORMA_PAGO) '+
         ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal
ELSE IF TIPO = _TIPO_DESCUENTO THEN
   Sql:='SELECT O.DESCRIPCION AS DESCUENTO, CD.ENTREGA, CD.SISTEMA AS MERCURIO, IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
        ' IF(ENTREGA<SISTEMA,SISTEMA-ENTREGA,0) AS FALTANTE '+
        ' FROM PDV_CORTE_D as CD JOIN PDV_C_OCUPANTE AS O ON (O.ID_OCUPANTE = CD.ID_OCUPANTE) '+
        ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal;
If not EjecutaSQL(sql,Query,_LOCAL) then exit;
IF TIPO = _TIPO_FORMAS THEN
   comun.DataSetToSag(Query,sag)
ELSE IF TIPO = _TIPO_DESCUENTO THEN
   comun.DataSetToSag(Query,sag)
end;


{FORMA QUE REALIZA EL LLENADO DE DINERO CON RESPECTO A UN RUBRO DADO (TIPO)
RECOLECCION, CANCELADOS Y EFECTIVO
TOMA DE LA BASE LO ENTREGADO Y LO REQUERIDO CON RESPECTO A UN NUMERO DE CORTE
Y UNA TERMINAL.
SE COMPARA ENTREGA VS REQUERIDO POR EL SISTEMA,
SI SON IGUALES LAS CANTIDADES, TODO NORMAL
SI ENTREGA ES MAYOR QUE REQUERIDO, EXISTE SOBRANTE
SI ENTREGA ES MENOR QUE REQUERIDO, EXISTE FALTANTE
}
procedure TfrmCortes.LlenaDinero(ed: TEdit; lbl, lbl2: TLabel; Tipo: String; Folio: Integer;
  Terminal: String);
begin
 if TIPO = _TIPO_EFECTIVO then
   SQL:='SELECT ENTREGA, SISTEMA  ' +
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal +
        ' AND TIPO='+QUOTEDSTR(_TIPO_EFECTIVO)
 else if TIPO = _TIPO_RECOLECCIONES then
   SQL:='SELECT ENTREGA, SISTEMA '+
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal +
        ' AND TIPO='+QUOTEDSTR(_TIPO_RECOLECCIONES)
 else if TIPO = _TIPO_CANCELADOS then
   SQL:='SELECT ENTREGA, SISTEMA '+
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal +
        ' AND TIPO='+QUOTEDSTR(_TIPO_CANCELADOS)
   else if TIPO = _TOTAL_RECOLECCIONES then
   SQL:='SELECT ENTREGA, SISTEMA '+
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal +
        ' AND TIPO='+QUOTEDSTR(_TOTAL_RECOLECCIONES)
   else if TIPO = _TIPO_IMPORTE_IXES then
   SQL:='SELECT ENTREGA, SISTEMA '+
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal +
        ' AND TIPO='+QUOTEDSTR(_TIPO_IMPORTE_IXES)
   else if TIPO = _TIPO_IMPORTE_BANAMEX then
   SQL:='SELECT ENTREGA, SISTEMA '+
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ IntToStr(Folio)+ ' AND ID_TERMINAL='+Terminal +
        ' AND TIPO='+QUOTEDSTR(_TIPO_IMPORTE_BANAMEX);
 lbl2.Caption  := '';
 lbl.font.Color:= CLBlack;

 If not EjecutaSQL(sql,Query,_LOCAL) then exit;
 ed.Text:= FORMAT('%f', [Query.FieldByName('ENTREGA').AsFloat]);
 If query.FieldByName('SISTEMA').asFloat = Query.FieldByName('ENTREGA').AsFloat then
      lbl.Caption:= FORMATFLOAT('0,00',0.00)
 else If query.FieldByName('ENTREGA').AsFloat > Query.FieldByName('SISTEMA').AsFloat then
 begin
      lbl.font.Color:= clBlue;
      lbl.Caption   := Format('%f',[ABS(query.FieldByName('ENTREGA').AsFloat - Query.FieldByName('SISTEMA').AsFloat )]);
      lbl2.Caption := 'SOBRANTE';
 end
 else If query.FieldByName('ENTREGA').AsFloat < Query.FieldByName('SISTEMA').AsFloat then
 begin
      lbl.font.Color:= clRed;
      lbl.Caption   := Format('%f',[ABS(query.FieldByName('SISTEMA').AsFloat - Query.FieldByName('ENTREGA').AsFloat )]);
      lbl2.Caption  := 'FALTANTE';
 end;

end;
{
Procedimiento que limpia la forma de Cortes.
}
procedure TfrmCortes.LimpiaForma;
begin
   edEfectivo.Text           := '';
   edIxes.Text               := '';
   edtNoRecos.Text           := '';
   edRecolecciones.Text      := '';
   lblEfectivo.Caption       := '';
   lblRecolecciones.Caption  := '';
   lblrecos.Caption          := '';
   lblrecos2.Caption         := '';
   EdCancelados.Text         := '';
   lblCancelados.Caption     := '';
   lblEfectivo2.Caption      := '';
   lblRecolecciones2.Caption := '';
   lblCancelados2.Caption    := '';
   lblIxes.Caption           := '';
   lblIxes2.Caption          := '';
   edtBanamex.Text           := '';
   lblBanamex.Caption        := '';
   lblBanamex2.Caption       := '';
   LimpiaGrid(sagFormas);
   LimpiaGrid(sagDescuentos);
   lblEfectivo.Font.Color:= clBlack;
   lblRecolecciones.Font.Color:= clBlack;

end;


procedure TfrmCortes.edCanceladosKeyPress(Sender: TObject; var Key: Char);
begin
     if lscbEmpleado.ItemIndex < 0 then
        Key := _BLANCO;
     if tipoCorte in [_CORTE_FIN_DIA, _CORTE_PASADO] then
      key:= _BLANCO;
     // SE CANCELAN BOLETOS, NO PESOS
     if not (Key in ['0'..'9', #8, #13]) then
          Key := _BLANCO;
end;

{
Procedimiento que realiza la impresion de un corte
}
procedure TfrmCortes.act145Execute(Sender: TObject);
VAR NombreArchivo, NombreEmpleado, Folio: String;
    FechaIniciaCorte, FechaTerminaCorte: TDateTime;   // borrar al finalizar las funciones
    Archivo : TextFile;
    Renglon : Integer;
    ya : boolean;
begin
//   mdCortes.moduloCortes.Query1.sql.Add('Select * From PDV_T_CORTE WHERE ID_CORTE=9;');
   ya:= False;
   if not bandera then
   if not AccesoPermitido(tAction(Sender).Tag,_RECUERDA_TAGS) then
      Exit;
   if MessageDlg(_PREGUNTA_IMPRESION, mtConfirmation,mbYesNo,0) <> mrYes then EXIT;
   //Imprimir el Corte
   idsNombres.ItemIndex:= lscbEmpleado.ItemIndex;
   NombreArchivo:='Corte'+idsNombres.CurrentiD+gs_terminal+'.txt';
   try
    Assignfile(Archivo, NombreArchivo);
    if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
    begin
        deleteFile(NombreArchivo);
        rewrite(Archivo); // lo crea
    end
    else
        rewrite(Archivo);   // Lo abre
   archivoOpos:= '';

   uCortes.InicializaDatos(idsNombres.CurrentItem, idsNombres.CurrentiD);
   if gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER then
   BEGIN
      uCortes.EncabezadoCorteFinTurno(Archivo);
      uCortes.DetalleEntregaCorteFinTurno(Archivo, sagFormas, sagDescuentos);
   if Application.MessageBox(_PREGUNTA_DESGLOCE,'Confirmacion de Usuario',_CONFIRMAR) = mrYes then
             uCortes.DesgloceBoletosCorteFinTurno(Archivo);
      uCortes.TotalBoletosCorteFinTurno(Archivo);
      uCortes.DetalleVentaCorteFinTurno(Archivo);
      uCortes.DesgloceFechasFinTurno(Archivo);
      uCortes.VentaNetaFinDeTurno(Archivo);
   END;

   if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS then
   begin
       uCortes.EncabezadoCorteFinTurnoOPOS(archivoOpos);
       uCortes.DetalleEntregaCorteFinTurnoOPOS(archivoOpos, sagFormas, sagDescuentos);
       uCortes.TotalBoletosCorteFinTurnoOPOS(archivoOpos);
       uCortes.DetalleVentaCorteFinTurnoOPOS(archivoOpos);
       uCortes.DesgloceFechasFinTurnoOPOS(archivoOpos);
       uCortes.VentaNetaFinDeTurnoOPOS(archivoOpos)
   end;
   except
       CloseFile(Archivo);
       deleteFile(NombreArchivo);
       uCortes.FinalizaDatos;
       Exit;
   end;
   uCortes.FinalizaDatos;
   CloseFile(Archivo);
   repeat
      if gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER then
      begin
       if ShellExecute(self.Handle, 'print', Pchar(NombreArchivo) ,nil, nil, SW_SHOWNORMAL) <= 32 then
           Application.MessageBox('No se pudo ejecutar la aplicación', 'Error', MB_ICONEXCLAMATION);
      end
      else  if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS  then
      begin
            escribirAImpresora(gs_impresora_general, archivoOpos);;
      end; // end del ELSE impresora _ITHACA

       if MessageDlg(_PREGUNTA_IMPRESION_CORRECTA, mtConfirmation,mbYesNo,0)  =  mrYes then
          ya:= true;
   until ya;
   deleteFile(NombreArchivo);
   //ShowMessage(comunii._OPERACION_SATISFACTORIA);
   if tipoCorte = _CORTE_AUDITORIA then
      Exit;
   if not imprimeHojaDos then
      exit;
   if MessageDlg(comunii._PREGUNTA_IMPRESION_2, mtConfirmation,mbYesNo,0)  =  mrNo then
      Exit;
   // IMPRIMIR LA SEGUNDA HOJA QUE CONTENDRA
   // EL CORTE DE DOCUMENTOS Y DETALLE DE EFECTIVO Y YA NO SERA
   // LLENADA A MANO POR EL PROMOTOR, SI NO QUE EL SISTEMA LA
   // PROPORCIONARA DE LOS DATOS DEL PRECORTE.
   // if taquillaCorteActual <>  0 then EXIT;
   NombreArchivo:='Detalle'+idsNombres.CurrentiD + gs_terminal+'.txt';
   UCortes.InicializaDatos(idsNombres.CurrentItem, idsNombres.CurrentiD);
   try
    Assignfile(Archivo, NombreArchivo);
    if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
    begin
        deleteFile(NombreArchivo);
        rewrite(Archivo); // lo crea
    end
    else
        rewrite(Archivo);   // Lo abre
   archivoOpos:= ''; // para cuando tengo que imprimir en impresora Ithaca, blanqueo el string

   if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS then
       // uCortes.EncabezadoCorteFinTurnoI(archivoOpos)
   else  if gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER then
          uCortes.DetalleDocumentosEfectivoPredeterminada(Archivo, StrToInt(idsNombres.CurrentiD) , idsNombres.CurrentItem );
   except
       CloseFile(Archivo);
       deleteFile(NombreArchivo);
       uCortes.FinalizaDatos;
       Exit;
   end;
   uCortes.FinalizaDatos;
   CloseFile(Archivo);
   repeat
      if gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER then
      begin
       if ShellExecute(self.Handle, 'print', Pchar(NombreArchivo) ,nil, nil, SW_SHOWNORMAL) <= 32 then
           Application.MessageBox('No se pudo ejecutar la aplicación', 'Error', MB_ICONEXCLAMATION);
      end
      else  if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS then
      begin
            BREAK;
      end ; // end del ELSE impresora OPOS
       if MessageDlg(_PREGUNTA_IMPRESION_CORRECTA_2, mtConfirmation,mbYesNo,0)  =  mrYes then
          ya:= true;
   until ya;
   deleteFile(NombreArchivo);

end;
{procedimiento que manda llamar al procedimiento CorteFinDeDia}
procedure TfrmCortes.act146Execute(Sender: TObject);
begin
   // codigo para mandar a traer el corte de fin de dia
   if not AccesoPermitido(tAction(Sender).Tag,_RECUERDA_TAGS) then
      Exit;
   try
     frmCorteFinDia:= tfrmCorteFinDia.Create(Self);
     frmCorteFinDia.ShowModal;
   finally
     frmCorteFinDia.Free;
     frmCorteFinDia := nil;
   end;

end;

{ TFechasGlobal }

procedure TFechasGlobal.CreateObject(Ofecha: String; Oboletos: Integer;
  Omonto: double);
begin
   fecha:= Ofecha;
   boletos:= Oboletos;
   monto:= Omonto;
end;
procedure TServiciosGlobal.CreateObjectS(Oservicio: String; Oefectivo: double; Oixe : double; Obanamex: Double);
begin
   servicio:= Oservicio;
   efectivo:= Oefectivo;
   Ixe     := Oixe;
   banamex := Obanamex;
end;
{Procedimiento que muestra un formulario para solicitar las fechas
de un corte por tipo de servicio y finalmente ejecuta el corte.
}
procedure TfrmCortes.act147Execute(Sender: TObject);
begin
   // codigo para mandar traer el corte por tipo de Servicio
   if not AccesoPermitido(tAction(Sender).Tag, _RECUERDA_TAGS) then
      Exit;
   try
     frmCorteServicio:= tfrmCorteServicio.Create(Self);
     frmCorteServicio.ShowModal;
   finally
     frmCorteServicio.Free;
     frmCorteServicio := nil;
   end;

end;

{Procedimiento:  CorteTipoServicio
parametros: fechaInicial y fechaFinal de tipo FechaHora y terminal de tipo String
}
procedure TfrmCortes.CorteTipoServicio(fechaInicial, fechaFinal: TDateTime; Terminal: String);
BEGIN
 /// NENENENE
end;

procedure TfrmCortes.DeshacerCambios(corte, terminal: String);
begin
   SQL:='CALL PDV_CANCELA_PROCESO_CORTE('+ Corte +  ',' + QuotedStr(gs_terminal)+');';
   if EjecutaSQL(sql,Query,_LOCAL) then
   begin
     ShowMessage(_PROCESO_FALLO);

   end;


end;

{ Procedimiento que realiza el llenado en la columna 1
con ceros en las celdas que esten vacias
}
procedure TfrmCortes.llenaGridsCeros;
var i: integer;
begin
    if MessageDlg('¿Deseas llenar la informacion con 0.00 (ceros) ?', mtWarning,mbYesNo,0) = mrNo then Exit;
    if Trim(edEfectivo.Text) = '' then
       edEfectivo.Text:= '0';
    if Trim(edRecolecciones.Text) = '' then
       edRecolecciones.Text:= '0';
    if Trim(edCancelados.Text)= '' then
       edCancelados.Text:='0';
    if Trim(edtNoRecos.Text)= '' then
       edtNoRecos.Text:='0';
    if Trim(edIxes.Text)= '' then
       edIxes.Text:='0';
    if Trim(edtBanamex.Text)='' then
       edtBanamex.Text:='0';

    for i:= 1 to sagFormas.RowCount do
         if Trim(sagFormas.Cells[1,i])='' then
            sagFormas.Cells[1,i]:= '0';
    for i:= 1 to sagDescuentos.RowCount do
         if Trim(sagDescuentos.Cells[1,i])='' then
            sagDescuentos.Cells[1,i]:='0';
end;
{procedimiento que manda llamar al procedimiento llenaGridsCeros }
procedure TfrmCortes.act149Execute(Sender: TObject);
begin
    llenaGridsCeros;
end;




procedure TfrmCortes.Button1Click(Sender: TObject);
VAR NombreArchivo: String;
    Archivo : TextFile;
    Renglon : Integer;
begin
   NombreArchivo:='Decimales.txt';
   try
    Assignfile(Archivo, NombreArchivo);
    //System.IO.Path.GetTempPath +
    if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
        Append(Archivo)       // Lo crea
    else
        rewrite(Archivo);    // Lo abre para escritura
   WriteLn(Archivo,'GRUPO PULLMAN DE MORELOS');
   WriteLn(Archivo,'');
   WriteLn(Archivo,'POR ENTREGAR  : '+    Forza_Izq(Format('%.2n',['7895555.5878']),25)  +
                      'ENTREGADO     : '+ Forza_Izq(Format('%.3n',[7895.5878]),15) );
   WriteLn(Archivo,'POR ENTREGAR  : $'+    Forza_Izq(Format('%.4n',[85.8]),15) +
                      'ENTREGADO     : $'+ Forza_Izq(Format('%.5n',[1234569695.017855]),15) );
   CloseFile(Archivo);
   except
     showMessage('Ocurrio un error al imprimir el corte, avise al administrador del sistema.');
   end; {end del try}

end;

procedure TfrmCortes.act152Execute(Sender: TObject);
var Folio: Integer;
    IdCajero: String;
begin
   if lscbEmpleado.ItemIndex < 0 then
   begin
     ShowMEssage('Elije un promotor para continuar.');
     Exit;
   end;
   if ( not RevisaEntrega(sagFormas,1) ) or  (not RevisaEntrega(sagDescuentos,1)) or
      (TRIM(EdEfectivo.Text) = '')   or (TRIM(edRecolecciones.Text)= ''  ) or
      (trim(edCancelados.Text) = '')  then
       llenaGridsCeros;
   if not AccesoPermitido(tAction(Sender).Tag, _RECUERDA_TAGS) then
      Exit;
   Folios.SetItem(lscbEmpleado.CurrentID);
   Folio:= StrToInt(Folios.currentID);  // TOMAR EL FOLIO DEL CORTE
   {
   El Stored Procedure de PDV_PROCESA_CORTE   :
     cierra corte, toma fechas, inserta en tabla detalle Efectivo, Recolecciones,
     manda a llamar a los Stored Procedures de:
      PDV_PROCESA_CORTE_FORMAS_PAGO
      PDV_PROCESA_CORTE_DESCUENTOS
   Todo de acuerdo a lo que el sistema tiene registrado
   }
   IdCajero:= gs_trabid;
   SQL:='CALL PDV_AUDITA_CORTE('+ IntToStr(Folio) +  ',' + QuotedStr(gs_terminal)+ ','+ QuotedStr(IdCajero)+');';
   if MessageDlg(_PREGUNTA_PROCESO, mtConfirmation,mbOKCancel,0) = mrOK then
      if  EjecutaSQL(SQL, Query, _LOCAL) then
         if ActualizaCorteD(Folio, gs_terminal) then  // actualizo la tabla con los datos introducidos por el cajero
         begin
             Folios.SetItem(lscbEmpleado.CurrentID); // TOMO EL FOLIO DEL CORTE
             LlenaDinero(edRecolecciones,lblRecolecciones,lblRecolecciones2,_TIPO_RECOLECCIONES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edtNoRecos,lblRecos, lblRecos2,_TOTAL_RECOLECCIONES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edCancelados, lblCancelados,lblCancelados2, _TIPO_CANCELADOS,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edEfectivo,lblEfectivo,lblEfectivo2,_TIPO_EFECTIVO,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edIxes,lblIxes,lblIxes2,_TIPO_IMPORTE_IXES,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaDinero(edtBanamex, lblBanamex, lblBanamex2, _TIPO_IMPORTE_BANAMEX, sTRtOiNT(fOLIOS.CurrentID), QuotedStr(gs_terminal));
             LlenaGrid(sagFormas,_TIPO_FORMAS,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             LlenaGrid(sagDescuentos,_TIPO_DESCUENTO,StrToInt(Folios.currentID),QuotedStr(gs_terminal));
             { El stored procedure, elimina los datos del precorte y abre nuevamente el corte para continuar con la venta
             }
             act145Execute(Self);
             SQL:='CALL PDV_BORRA_CORTE('+ IntToStr(Folio) +  ',' + QuotedStr(gs_terminal)+');';
             // showMessage(sql);
             if  EjecutaSQL(SQL, Query, _LOCAL) then
                 ShowMessage(comunii._OPERACION_SATISFACTORIA);
         end
      ELSE
             ShowMessage('Ocurrio un error en el proceso, intentalo nuevamente.');
      

end;

function TfrmCortes.imprimeHojaDosCorte: Boolean;
begin
   sql:= 'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO=  34;';
   if not EjecutaSQL(sql, Query, _LOCAL) then
   begin
     result:= True;
     Exit;
   end;
   if Query.eof then
   begin
     result:= True;
     Exit;
   end;
   result:=  (Query.FieldByName('VALOR').AsFloat = 1);
end;


end.
