unit uCortes;
{Autor: Gilberto Almanza Maldonado
Fecha: Viernes, 23 de Julio de 2010.
Unidad que contiene las funciones, procedimientos  y constantes
que ocupa el modulo de cortes.}
interface
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids, Aligrid,
   XPStyleActnCtrls, ActnList,  SqlExpr,  ActnMan,  DB, ImgList, Buttons, comun, comunii;

var
  NombreCajero, idCajero, idPromotor, NombreEmpleado: String;
  FechaIniciaCorte, FechaTerminaCorte: TDateTime;
  FondoInicial: Double;
  corte: String;
  QueryL, Query2, QueryFormasPago, QueryOcupantes, QueryFechas: TSQLQuery;
  Venta, Cancelaciones, VentaNeta: Double;
  Vendidos, Cancelados, VendidosNetos : Integer;
  Lfechas: TstringList;
function EncabezadoCorteFinTurno(var Archivo: TextFile): Boolean;
function EncabezadoCorteFinDia(var Archivo: TextFile; fecha: TDateTime; Terminal: String): Boolean;
Procedure EncabezadoCorteTipoServicio(var Archivo: TextFile; fechaInicial, fechaFinal: TdateTime; Terminal : String);
procedure DesgloceFechasFinTurno(var Archivo: TextFile);
function DetalleDocumentosCorteFinDia(var Archivo: TextFile; terminal : String; fecha: TDateTime): Boolean;
procedure VentaNetaFinDeTurno(var Archivo: TextFile);
function DetalleCortesFinDeDia(var Archivo: textFile; terminal: String; fecha: TDateTime): Boolean;
procedure DetalleCortesTipoServicio(var Archivo: textFile; terminal: String; fechaI, fechaF: TDateTime);
function InicializaDatos(promotor :String; corte:string): Boolean;
function DesgloceBoletosCorteFinTurno(var Archivo: TextFile): Boolean;
function DetalleVentaCorteFinTurno(var Archivo: TextFile): Boolean;
function TotalBoletosCorteFinTurno(var Archivo: TextFile): Boolean;
function DetalleEntregaCorteFinTurno(var Archivo: TextFile;  sag1,sag2: TStringAlignGrid): Boolean;
function CortesPendientes(Terminal: String; fechaI, fechaF: TDateTime): Integer;
function LlenaMatrizGeneral(miFecha: String; miBoletos: Integer; miMonto: Double): Boolean;
procedure LimpiarObjetosLista(lista: TstringList);
function creaQuerysDetalles: Boolean;
procedure destruyeQuerysDetalle;

Procedure FinalizaDatos;
Procedure CreaQuery;

implementation

uses DMdb, frmCorte, frmCorteTipoServicio;
{Esta funcion permite crear y escribir el encabezado de los cortes de fin
de turno de cada promotor, cuando se imprime.}
function EncabezadoCorteFinTurno(var Archivo: TextFile): Boolean;

begin
   WriteLn(Archivo,'GRUPO PULLMAN DE MORELOS');
   WriteLn(Archivo, comun.gs_terminal);
   // estos datos se toman de la tabla y no se "recalculan"
   WriteLn(Archivo,' ');
   WriteLn(Archivo,'INFORME DE CORTE DE CAJA');
   WriteLn(Archivo,' ');
   WriteLn(Archivo,'EMPLEADO       : ' +  idPromotor + '-' + NombreEmpleado );
   WriteLn(Archivo,'FOLIO DE CORTE : ' +  corte);
   WriteLn(Archivo,' ');
   WriteLn(Archivo,'INICIO DE LABORES : ' + FormatDateTime('dd/mm/yyyy hh:nn:ss ', FechaIniciaCorte) );
   WriteLn(Archivo,'FECHA DEL CORTE   : ' + FormatDateTime('dd/mm/yyyy hh:nn:ss ', FechaTERMINACorte) );
   WriteLn(Archivo,' ');
   sql:='SELECT NOMBRE FROM PDV_C_USUARIO WHERE TRAB_ID = ' +
        QuotedStr(idCajero);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
     NombreCajero:= QueryL.FieldByName('NOMBRE').AsString;

   WriteLn(Archivo,'FONDO INICIAL   : $'+  Format(_FORMATO_CANTIDADES_CORTES,[FondoInicial])   +
                   '         CAJERO : ' + idCajero +' - '+ NombreCajero);
   WriteLn(Archivo,'');
   WriteLn(Archivo,'');
end;

function InicializaDatos(promotor :String; corte:string): Boolean;
begin {Funcion que establece valores iniciales antes de imprimir un corte
y ocuparan algunas funciones como: Encabezado, Desgloce Boletos, Pie de Reporte}
   CreaQuery;
   sql:='SELECT NOMBRE FROM PDV_C_USUARIO WHERE TRAB_ID=' +
        QuotedStr(promotor);
   idPromotor:= promotor;
   If EjecutaSQL(sql,QueryL,_LOCAL) then
      NombreEmpleado:= QueryL.FieldByName('NOMBRE').AsString;

   SQL:= 'SELECT * FROM PDV_T_CORTE WHERE ID_CORTE = ' + corte +
         ' AND ID_TERMINAL=' +   QuotedStr(gs_terminal) ;
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
        FechaIniciaCorte := QueryL.FieldByName('FECHA_INICIO').AsDateTime;
        FechaTerminaCorte:= QueryL.FieldByName('FECHA_FIN').AsDateTime;
        FondoInicial:=      QueryL.FieldByName('FONDO_INICIAL').AsFloat;
        idCajero    :=      QueryL.FieldByName('ID_CAJERO').AsString;
   end;
   uCortes.corte := corte;

end;

{Esta funcion me permite realizar el desgloce de de boletos de un corte especifico
indicando
Boletos Vendidos
Boletos Cancelados
Recolecciones Realizadas
Total de Boletos Vendidos ***
}
function DesgloceBoletosCorteFinTurno(var Archivo:TextFile): Boolean;
begin
   sql:= 'SELECT  ID_BOLETO, ID_TERMINAL, TRAB_ID AS EMPLEADO, ESTATUS_PROCESADO, ORIGEN, DESTINO, TARIFA, '+
         ' OCU.ABREVIACION AS OCUPANTE, PAGO.ABREVIACION AS PAGO , ID_TAQUILLA, ' +
         ' FECHA_HORA_BOLETO, ID_CORRIDA, FECHA AS FECHA_BOLETO, NO_ASIENTO '+
         ' FROM PDV_T_BOLETO AS BOL  LEFT JOIN PDV_C_OCUPANTE AS OCU ON (BOL.ID_OCUPANTE = OCU.ID_OCUPANTE) '+
         ' LEFT JOIN PDV_C_FORMA_PAGO AS PAGO ON (PAGO.ID_FORMA_PAGO = BOL.ID_FORMA_PAGO) '+
         ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
         ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
         ' AND TRAB_ID = '+  QuotedStr(idPromotor) +
         // SE OMITE EL  AND ESTATUS='+QuotedStr(_ESTATUS_VENDIDO) PARA QUE APAREZCAN LOS CANCELADOS
         ' ORDER BY FECHA_HORA_BOLETO';

   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- desgloce    - if
      if not QueryL.Eof then
      begin
         WriteLn(Archivo,'DESGLOCE DE BOLETOS ('+ intToStr(registrosDe(QueryL))+ ') registros.');
         WriteLn(Archivo,Forza_Izq('FECHA', 7) + Forza_Izq('BOLETO',7)   + Forza_Izq('ID',3) +
                         Forza_Izq('CORR',8)+ Forza_Izq('ORI',5)      + Forza_Izq('DES',5) +
                         Forza_Izq('LUGAR',6)  + Forza_Izq('TIPO',5) + Forza_Izq('PAGO',5) +
                         Forza_Izq('TARIFA',7) + Forza_Izq('FECHA VENTA',18));
      end;
      while not QueryL.Eof  do
      begin // 2.- desgloce    - while
         WriteLn(Archivo,Forza_Izq(FORMATDATETIME('DD/MM/YY',QueryL.fieldByName('FECHA_BOLETO').AsDateTime), 9) +
                         Forza_Izq(QueryL.fieldByName('ID_BOLETO').AsString, 6) +
                         Forza_Izq(QueryL.fieldByName('ESTATUS_PROCESADO').AsString, 3) +
                         Forza_Izq(QueryL.fieldByName('ID_CORRIDA').AsString, 7) +
                         Forza_Izq(QueryL.fieldByName('ORIGEN').AsString, 5) +
                         Forza_Izq(QueryL.fieldByName('DESTINO').AsString, 5) +
                         Forza_Izq(QueryL.fieldByName('NO_ASIENTO').AsString, 4 )+
                         Forza_Izq(QueryL.fieldByName('OCUPANTE').AsString, 4) +
                         Forza_IZQ(QueryL.fieldByName('PAGO').AsString, 5) +
                         Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('TARIFA').AsFloat]), 8) + espacios(1)+
                         Forza_Izq(FORMATDATETIME('DD/MM/YY HH:NN:SS',QueryL.fieldByName('FECHA_HORA_BOLETO').AsDateTime), 18)
                         );
         QueryL.Next;
      end; // 2.- desgloce    - while
      WriteLn(Archivo,'');
   end; // 1.- desgloce if
   sql:='SELECT  CANC.*, OCU.ABREVIACION AS DESCUENTO, PAGO.ABREVIACION AS PAGO, BOL.NO_ASIENTO, BOL.TARIFA'+
        ' FROM PDV_T_BOLETO AS BOL  LEFT JOIN PDV_C_OCUPANTE AS OCU ON (BOL.ID_OCUPANTE = OCU.ID_OCUPANTE) '+
        ' LEFT JOIN PDV_C_FORMA_PAGO AS PAGO ON (PAGO.ID_FORMA_PAGO = BOL.ID_FORMA_PAGO) '+
        ' JOIN PDV_T_BOLETO_CANCELADO AS CANC ON (CANC.ID_BOLETO = BOL.ID_BOLETO) '+
        ' WHERE FECHA_HORA_CANCELADO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
        ' AND CANC.TRAB_ID_CANCELADO = '+  QuotedStr(idPromotor) +
        ' AND CANC.TRAB_ID = BOL.TRAB_ID'+ ';';
  // SHOWmeSSAGE(sql);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- cancelados
      if not QueryL.Eof then
      BEGIN
         WriteLn(Archivo,'DESGLOCE DE BOLETOS CANCELADOS ('+ intToStr(registrosDe(QueryL))+ ') BOLETOS.');
         WriteLn(Archivo,Forza_Izq('BOL',10) +
                         Forza_Izq('ASIENTO',7) +
                         Forza_Izq('TERM',5) +
                         Forza_Izq('AUTORIZA',9) +
                         Forza_Izq('TAQUILLA', 5) +
                         Forza_Izq('TRAB', 12) +
                         Forza_Izq('FECHA HORA CANCELADO', 20) +
                         Forza_Izq('DESCUENTO', 5) +
                         Forza_Izq('PAGO',5) +
                         Forza_Izq('TARIFA',7) );
      END;
      while not QueryL.Eof  do
      begin // 2.- cancelados
         WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('ID_BOLETO').AsString, 6) +
                         Forza_Izq(QueryL.fieldByName('NO_ASIENTO').AsString, 3) +
                         Forza_Izq(QueryL.fieldByName('ID_TERMINAL').AsString, 5) +
                         Forza_Izq(QueryL.fieldByName('TRAB_ID_CANCELADO').AsString, 9) +
                         Forza_Izq(QueryL.fieldByName('ID_TAQUILLA').AsString, 5) +
                         Forza_Izq(QueryL.fieldByName('TRAB_ID').AsString, 12) +
                         Forza_Izq(QueryL.fieldByName('FECHA_HORA_CANCELADO').AsString, 20) +
                         Forza_Izq(QueryL.fieldByName('DESCUENTO').AsString, 5) +
                         Forza_Izq(QueryL.fieldByName('PAGO').AsString, 5) +
                         Forza_Izq('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('TARIFA').AsFloat]), 7) );
         QueryL.Next;
      end; //2.- cancelados - while
      WriteLn(Archivo,'');
   end; // 1.- cancelados - if
   sql:= 'SELECT RECO.FECHA_HORA,  USU.NOMBRE AS CAJERO, RECO.IMPORTE, RECO.ID_TAQUILLA '+
         ' FROM PDV_T_RECOLECCION AS RECO JOIN PDV_C_USUARIO AS USU ON (USU.TRAB_ID= RECO.ID_EMPLEADO_REALIZA) '+
         ' WHERE FECHA_HORA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
         ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
         ' AND ID_EMPLEADO = '+  QuotedStr(idPromotor)+
         ' AND RECO.ID_CORTE='+ corte +
         ' AND RECO.ID_TERMINAL =' + QuotedStr(gs_terminal);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- recolecciones  /f
      if not QueryL.Eof then
      begin
         WriteLn(Archivo,'DESGLOCE DE RECOLECCIONES  ('+ intToStr(registrosDe(QueryL))+ ') BOLETOS.');
         WriteLn(Archivo,Forza_Izq('FECHA / HORA', 20) +
                         Forza_DER('CAJERO', 40) +
                         Forza_Der('IMPORTE', 15) +
                         Forza_Der('TAQUILLA', 5) );
      end;
      while not QueryL.Eof  do
      begin   // 2.- recolecciones -while
         WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('FECHA_HORA').AsString, 20) +
                         Forza_DER(QueryL.fieldByName('CAJERO').AsString, 40) +
                         Forza_Der('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPORTE').AsFloat]), 15) +
                         Forza_Der(QueryL.fieldByName('ID_TAQUILLA').AsString, 5) );
         QueryL.Next;
      end; // 2.- recolecciones    -while
   end; // 1.- recolecciones -if
   WriteLn(Archivo,'');
end;

function DetalleVentaCorteFinTurno(var Archivo: TextFile): Boolean;
begin {Funcion que Imprime el detalle de la venta por
Tipos de Ocupantes
Formas de Pago
Ventas Netas Totales
Ventas por fecha
}
venta        :=0;
cancelaciones:=0;
vendidos     :=0;
cancelados   :=0;
// QueryL PARA OBTENER VENTAS X TIPO DE PASAJERO
   SQL:='SELECT OCU.DESCRIPCION , COALESCE(COUNT(*),0) AS ''CANTIDAD'', COALESCE(SUM(TARIFA),0)  AS ''MONTO'''+
        '  FROM PDV_T_BOLETO AS BOL RIGHT JOIN PDV_C_OCUPANTE AS OCU ON (OCU.ID_OCUPANTE = BOL.ID_OCUPANTE) '+
        ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
        ' AND BOL.TRAB_ID = '+  QuotedStr(idPromotor)  + ' AND BOL.ESTATUS_PROCESADO ='+ QuotedStr(_ESTATUS_VENDIDO) +
 //       ' AND BOL.ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
        ' group by BOL.ID_OCUPANTE ';
//   showmessage(sql);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- DESGLOCE IF
      IF not QueryL.Eof THEN
      begin
            WriteLn(Archivo,'VENTAS POR TIPO DE OCUPANTES.');
            WriteLn(Archivo,Forza_Izq('OCUPANTE', 30) +
                            Forza_DER('CANTIDAD', 10) +
                            Forza_DER('MONTO', 20) );
      end;
      while not QueryL.Eof  do
      begin   // 2.- DESGLOCE -while
         WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 30) +
                         Forza_DER(QueryL.fieldByName('CANTIDAD').AsString, 10) +
                         Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 20) );
         QueryL.Next;
      end; // 2.- DESGLOCE    -while
   end; // 1.- IF EJECUTASQL
   // VENTAS POR CADA UNA DE LAS FORMAS DE PAGO
   WriteLn(Archivo,'');
   SQL:='SELECT PAGO.DESCRIPCION, COALESCE(COUNT(*),0) AS ''CANTIDAD'', COALESCE(SUM(TARIFA),0)   AS ''MONTO'''+
        ' FROM PDV_T_BOLETO AS BOL RIGHT JOIN PDV_C_FORMA_PAGO AS PAGO ON (BOL.ID_FORMA_PAGO = PAGO.ID_FORMA_PAGO) '+
        ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
        ' AND BOL.TRAB_ID = '+  QuotedStr(idPromotor) + ' AND BOL.ESTATUS_PROCESADO ='+QuotedStr(_ESTATUS_VENDIDO) +
       // ' AND BOL.ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
        ' group by BOL.ID_FORMA_PAGO ';
   //showmessage(sql);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- DESGLOCE IF
      IF not QueryL.Eof THEN
      begin
           WriteLn(Archivo,'VENTAS POR FORMA DE PAGO.');
           WriteLn(Archivo,Forza_Izq('FORMA DE PAGO', 30) +
                           Forza_DER('CANTIDAD', 10) +
                           Forza_DER('MONTO', 20) );
      end; // END DEL IF
      while not QueryL.Eof  do
      begin   // 2.- DESGLOCE -while
         WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 30) +
                         Forza_DER(QueryL.fieldByName('CANTIDAD').AsString, 10) +
                         Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 20) );
         QueryL.Next;
      end; // 2.- DESGLOCE    -while
   end; // 1.- IF WHILE

end;


Function TotalBoletosCorteFinTurno(var Archivo : TextFile): Boolean;
VAR sp : TSQLStoredProc;
begin
  // vendidos - cancelados
  WriteLn(Archivo,'');
  sp   := TSQLStoredProc.Create(nil);
  sp.SQLConnection   := dm.Conecta;
  try
     sp.SQLConnection := DM.Conecta;
     sp.Close;
     sp.StoredProcName:= 'PDV_TOTAL_BOLETOS_CORTE';
     sp.params.ParamByName('_EMPLEADO').AsString  :=  idPromotor;
     sp.params.ParamByName('FI').AsDateTime:= FechaIniciaCorte;
     sp.params.ParamByName('FF').asDateTime:= FechaTerminaCorte;
     sp.params.ParamByName('_TERMINAL').AsString:=  gs_terminal;
     sp.Open;
     WriteLn(Archivo,'Total de Boletos: '+ IntToStr(sp.FieldByName('TOTAL').AsInteger));
  finally
     sp.Free;
  end;

  WriteLn(Archivo,'');
end;

{Funcion que realiza la escritura del detalle de las entregas del promotor
y realiza una comparativa con lo que el sistema tiene registrado durante
su venta.}
function DetalleEntregaCorteFinTurno(var Archivo: TextFile; sag1,sag2: TStringAlignGrid): Boolean;
var renglon : integer;
begin
   WriteLn(Archivo,'F O R M A S     D E     P A G O ');
   WriteLn(Archivo,' ');
   WriteLn(Archivo,FORZA_DER(sag1.Cells[0,0], 20) +
                   FORZA_DER(sag1.Cells[1,0], 15) +
                   FORZA_DER(sag1.Cells[2,0], 15) +
                   FORZA_DER(sag1.Cells[3,0], 15) +
                   FORZA_DER(sag1.Cells[4,0], 15) );
   if sag1.RowCount=1 then
      WriteLn(Archivo,FORZA_DER('SIN FORMAS DE PAGO', 20) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) );
   for renglon:=1 to sag1.RowCount -1 do
   WriteLn(Archivo,FORZA_DER(sag1.Cells[0,renglon], 20) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[1,renglon])]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[2,renglon])]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[3,renglon])]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[4,renglon])]), 15)  );
   WriteLn(Archivo,' ');
   WriteLn(Archivo,'D  E  S  C  U  E  N  T  O  S ');
   WriteLn(Archivo,' ');
   WriteLn(Archivo,FORZA_DER(sag2.Cells[0,0], 20) +
                   FORZA_DER(sag2.Cells[1,0], 15) +
                   FORZA_DER(sag2.Cells[2,0], 15) +
                   FORZA_DER(sag2.Cells[3,0], 15) +
                   FORZA_DER(sag2.Cells[4,0], 15) );
   if sag2.RowCount=1 then
      WriteLn(Archivo,FORZA_DER('SIN DESCUENTOS', 20) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 15) );
   for renglon:=1 to sag2.RowCount -1 do
   WriteLn(Archivo,FORZA_DER(sag2.Cells[0,renglon], 20) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[1,renglon])]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[2,renglon])]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[3,renglon])]), 15) +
                   FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[4,renglon])]), 15) );

   WriteLn(Archivo,' ');
   sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
         ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
         '  FROM PDV_CORTE_D '+
         ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
         QuotedStr(gs_terminal) +
         ' AND TIPO='+QUOTEDSTR(_TIPO_EFECTIVO);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
      WriteLn(Archivo,'E F E C T I V O  ');
      WriteLn(Archivo,FORZA_DER('', 20) +
                   FORZA_DER('ENTREGA', 15) +
                   FORZA_DER('MERCURIO', 15) +
                   FORZA_DER('SOBRANTE', 15) +
                   FORZA_DER('FALTANTE', 15) );
      WriteLn(Archivo,FORZA_DER('EFECTIVO', 20) +
                      Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                      Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                      Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 15) +
                      Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 15));
      WriteLn(Archivo,' ');
   end;
   sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
         ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
         '  FROM PDV_CORTE_D '+
         ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
         QuotedStr(gs_terminal) +
         ' AND TIPO='+QUOTEDSTR(_TIPO_IMPORTE_IXES);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
      WriteLn(Archivo,'I M P O R T E    I X E ');
      WriteLn(Archivo,FORZA_DER('', 20) +
                   FORZA_DER('ENTREGA', 15) +
                   FORZA_DER('MERCURIO', 15) +
                   FORZA_DER('SOBRANTE', 15) +
                   FORZA_DER('FALTANTE', 15) );
      WriteLn(Archivo,FORZA_DER('IMPORTE DE IXES', 20) +
                      Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                      Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                      Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 15) +
                      Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 15));
      WriteLn(Archivo,' ');
   end;


   SQL:='SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
         ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE '+
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
         QuotedStr(gs_terminal) +
        ' AND TIPO='+QUOTEDSTR(_TIPO_RECOLECCIONES);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
      WriteLn(Archivo,'R E C  O L E C C I O N E S');
      WriteLn(Archivo,FORZA_DER('', 20) +
                   FORZA_DER('ENTREGA', 15) +
                   FORZA_DER('MERCURIO', 15) +
                   FORZA_DER('SOBRANTE', 15) +
                   FORZA_DER('FALTANTE', 15) );
      WriteLn(Archivo,FORZA_DER('EFECTIVO', 20) +
                      Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                      Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                      fORZA_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]),15) +
                      fORZA_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]),15));
      WriteLn(Archivo,' ');
   end;
   SQL:='SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
         ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  '+
        '  FROM PDV_CORTE_D '+
        ' WHERE ID_CORTE='+ Corte+ ' AND ID_TERMINAL='+
         QuotedStr(gs_terminal) +
        ' AND TIPO='+QUOTEDSTR(_TIPO_CANCELADOS);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
      WriteLn(Archivo,'C A N C E L A D O S ');
      WriteLn(Archivo,FORZA_DER('', 20) +
                   FORZA_DER('ENTREGA', 15) +
                   FORZA_DER('MERCURIO', 15) +
                   FORZA_DER('SOBRANTE', 15) +
                   FORZA_DER('FALTANTE', 15) );
      WriteLn(Archivo,FORZA_DER('BOLETOS', 20) +
                      Forza_DER(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                      Forza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                      FORza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]),15) +
                      forza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]),15));
      WriteLn(Archivo,' ');
   end;
  WriteLn(Archivo,' ');
end;

{Procedimiento que establece a nulo o ceros los valores utilizados en esta unidad}
Procedure FinalizaDatos;
begin
   QueryL.Destroy;
   idPromotor       := '';
   NombreEmpleado   := '';
   FechaIniciaCorte := Now();
   FechaTerminaCorte:= Now();
   FondoInicial     :=  -1;
   idCajero         := '';
   uCortes.corte    := '';
end;

function EncabezadoCorteFinDia(var Archivo: TextFile; fecha: TDateTime; Terminal: String): Boolean;
begin
  {Esta funcion coloca el encabezado al Archivo de Corte de fin de Dia.}
   WriteLn(Archivo,'GRUPO PULLMAN DE MORELOS');
   WriteLn(Archivo,'TOTAL DE CORTES DE CAJA DEL DIA: '+ FormatDateTime('dd/mm/yyyy',fecha));
   WriteLn(Archivo,'FECHA DEL CORTE: '+ FormatDateTime('dd/mm/yyyy HH:NN',NOW() ));
   WriteLn(Archivo,'REPORTE EMITIDO EN '+ Terminal);
   WriteLn(Archivo,'CORTE DE FIN DE DIA');
   WriteLn(Archivo,'');
   //CreaQuery;
end;


function CortesPendientes(Terminal: String; fechaI, fechaF: TDateTime): Integer;
begin
{regresa el numero de cortes pendientes por procesar}
sql:='SELECT  ID_CORTE  FROM  PDV_T_CORTE ' +
        ' WHERE ID_TERMINAL='+ QuotedStr(Terminal) +
        ' AND FECHA_INICIO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fechaI))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fechaF))+
        ' AND FECHA_FIN IS NULL AND ESTATUS <> '+ _FINALIZADO;
   if EjecutaSQL(sql,QueryL,_LOCAL) then
      if not QueryL.Eof then
      begin
         result:= registrosDe(QueryL);
         Exit;
      end;
   result:= 0;

end;

procedure CreaQuery;
begin
  QueryL := TSQLQuery.Create(nil);
  QueryL.SQLConnection:= dm.Conecta;
end;



function DetalleDocumentosCorteFinDia(var Archivo: TextFile; terminal : String; fecha: TDateTime): Boolean;
var
   totalSobrante, totalFaltante: INTEGER;
   totalEntrega, totalSistema: integer;
begin
  {funcion que imprime el detalle de los documentos entregados y no entregados por
  los promotores en un fecha especifica}
  {
    Obtengo el detalle de la tabla PDV_CORTE_D, sumando todos los registros de los
    cortes para un dia dado
   }      // comenzando por ocupantes
   SQL:='SELECT  SUM(ENTREGA) AS ENTREGA, SUM(SISTEMA) AS SISTEMA,  O.DESCRIPCION, '+
        ' IF(SUM(ENTREGA)> SUM(SISTEMA),SUM(ENTREGA)- SUM(SISTEMA),0) AS SOBRANTE, ' +
        ' IF(SUM(ENTREGA)< SUM(SISTEMA),SUM(SISTEMA)- SUM(ENTREGA),0) AS FALTANTE '  +
        ' FROM PDV_CORTE_D as CD LEFT JOIN PDV_C_OCUPANTE AS O ON (O.ID_OCUPANTE = CD.ID_OCUPANTE) ' +
        ' WHERE ID_TERMINAL='+ QuotedStr(Terminal) +' AND ID_CORTE IN ( '+
        ' SELECT  ID_CORTE '+
        ' FROM PDV_T_CORTE '+
        ' WHERE ID_TERMINAL='+QuotedStr(Terminal)+
        ' AND FECHA_INICIO BETWEEN '+QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha))+
        '     ) AND CD.ID_OCUPANTE  IS  NOT NULL ' +
        ' GROUP BY TIPO, O.DESCRIPCION ';
   if not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
      ShowMessage('Error al procesar el concentrado de  Ocupantes');
      CloseFile(Archivo);
      exit;
   end;
   queryL.First;
   WriteLn(Archivo, 'OCUPANTES');
   WriteLn(Archivo, Forza_Izq('ENTREGA', 15),
                    Forza_Izq('SISTEMA', 15),
                    Forza_Izq('DESCRIPCION', 20),
                    Forza_DER('SOBRANTE', 15),
                    Forza_DER('FALTANTE', 15));
   WriteLn(Archivo,'');
   totalEntrega:=0;
   totalSistema:=0;
   TotalSobrante:=0;
   TotalFaltante:=0;
   WHILe NOT QueryL.Eof do
   begin
       WriteLn(Archivo,Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('ENTREGA').asInteger]), 15),
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SISTEMA').asInteger]), 15),
                       Forza_Izq(QueryL.FieldByName('DESCRIPCION').AsString, 20),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SOBRANTE').asInteger]), 15),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('FALTANTE').asInteger]), 15));
       totalEntrega := totalEntrega + QueryL.FieldByName('ENTREGA').asInteger;
       totalSistema := totalSistema + QueryL.FieldByName('SISTEMA').asInteger;
       totalSobrante:= totalSobrante+ QueryL.FieldByName('SOBRANTE').asInteger;
       totalFaltante:= totalFaltante+ QueryL.FieldByName('FALTANTE').asInteger;
       QueryL.Next;
   end; // end del while
   WriteLn(Archivo,Forza_Izq('--------', 15),
                       Forza_Izq('--------', 15),
                       Forza_Izq(' ', 20),
                       Forza_Der('--------', 15),
                       Forza_Der('--------', 15));

   WriteLn(Archivo,Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalEntrega]), 15),
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalSistema]), 15),
                       Forza_Izq('', 20),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalSobrante]), 15),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalFaltante]), 15));

   WriteLn(Archivo,'');
   WriteLn(Archivo,'FORMAS DE PAGO');
        // continuo con formas de pago
   sql:='SELECT  SUM(ENTREGA) AS ENTREGA, SUM(SISTEMA) AS SISTEMA,  F.DESCRIPCION, '+
        ' IF(SUM(ENTREGA)> SUM(SISTEMA),SUM(ENTREGA)- SUM(SISTEMA),0) AS SOBRANTE, '+
        ' IF(SUM(ENTREGA)< SUM(SISTEMA),SUM(SISTEMA)- SUM(ENTREGA),0) AS FALTANTE '+
        ' FROM PDV_CORTE_D as CD LEFT JOIN PDV_C_FORMA_PAGO AS F ON (F.ID_FORMA_PAGO = CD.ID_FORMA_PAGO) '+
        ' WHERE ID_TERMINAL='+QuotedStr(Terminal) +' AND ID_CORTE IN ( '+
        ' SELECT  ID_CORTE '+
        ' FROM PDV_T_CORTE '+
        ' WHERE ID_TERMINAL='+QuotedStr(Terminal)+ ' AND FECHA_INICIO BETWEEN '+
        QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha))+
        ' ) AND CD.ID_FORMA_PAGO  IS  NOT NULL '+
        ' GROUP BY TIPO, F.DESCRIPCION ';
   //showmessage(sql);
   if not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
      ShowMessage('Error al procesar el concentrado de Formas de Pago');
      CloseFile(Archivo);
      exit;
   end;
   queryL.First;
   WriteLn(Archivo, Forza_Izq('ENTREGA', 15),
                    Forza_Izq('SISTEMA', 15),
                    Forza_Izq('DESCRIPCION', 20),
                    Forza_DER('SOBRANTE', 15),
                    Forza_DER('FALTANTE', 15));
   WriteLn(Archivo,'');
   totalEntrega:=0;
   totalSistema:=0;
   TotalSobrante:=0;
   TotalFaltante:=0;
   WHILe NOT QueryL.Eof do
   begin
       WriteLn(Archivo,Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('ENTREGA').asInteger]), 15),
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SISTEMA').asInteger]), 15),
                       Forza_Izq(QueryL.FieldByName('DESCRIPCION').AsString, 20),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SOBRANTE').asInteger]), 15),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('FALTANTE').asInteger]), 15));
       totalEntrega := totalEntrega + QueryL.FieldByName('ENTREGA').asInteger;
       totalSistema := totalSistema + QueryL.FieldByName('SISTEMA').asInteger;
       totalSobrante:= totalSobrante+ QueryL.FieldByName('SOBRANTE').asInteger;
       totalFaltante:= totalFaltante+ QueryL.FieldByName('FALTANTE').asInteger;
       QueryL.Next;
   end; // end del while
   WriteLn(Archivo,Forza_Izq('--------', 15),
                       Forza_Izq('--------', 15),
                       Forza_Izq(' ', 20),
                       Forza_Der('--------', 15),
                       Forza_Der('--------', 15));

   WriteLn(Archivo,Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalEntrega]), 15),
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalSistema]), 15),
                       Forza_Izq('', 20),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalSobrante]), 15),
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalFaltante]), 15));
   WriteLn(Archivo,'');

end;
function DetalleCortesFinDeDia(Var Archivo: TextFile; terminal : String; Fecha: TDateTime): Boolean;
var
   granTotalEntrega, granTotalSistema: Double;
   totalCuantos: Double;
   totalSistema: Double ;
   Aux1, Aux2: Double;
   i: Integer;
begin
  {
   Obtengo TODOS los empleados asignados en esa terminal y esa fecha dada desde la hora 00:00:00 hasta las
   23:59:59
   }
   creaQuerysDetalles;
   granTotalSistema:= 0;
   SQL:='SELECT    C.ID_CORTE AS FOLIO, C.ID_TAQUILLA,  C.ID_EMPLEADO, USU.NOMBRE AS EMPLEADO, C.FECHA_INICIO, C.FECHA_FIN '+
        ' FROM PDV_T_CORTE AS C JOIN PDV_C_USUARIO AS USU ON (USU.TRAB_ID= C.ID_EMPLEADO) '+
        ' WHERE  C.ID_TERMINAL='+ QuotedStr(Terminal) +
        ' AND  C.FECHA_INICIO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha))+
        ' ORDER BY 1 ';
   //   SHOWMESSAGE(SQL);
   if EjecutaSQL(sql,QueryL,_LOCAL) then
   BEGIN
   WriteLn(Archivo,'CORTES ');
   WriteLn(Archivo,Forza_Izq('FOLIO', 10),
                   Forza_Izq('ID TAQUILLA', 15),
                   Forza_Izq('ID EMPLEADO', 15),
                   Forza_Izq('EMPLEADO', 30));
   WriteLn(Archivo,'');
   QueryL.First;
   totalSistema:=0;
   END;
   WHILE NOT QueryL.Eof do
   begin
       WriteLn(Archivo,Forza_Izq(QueryL.FieldByName('FOLIO').AsString, 10),
                       Forza_Izq(QueryL.FieldByName('ID_TAQUILLA').AsString, 15),
                       Forza_Izq(uppercase(QueryL.FieldByName('ID_EMPLEADO').AsString), 15),
                       Forza_Izq(QueryL.FieldByName('EMPLEADO').AsString, 30));
       QueryL.Next;
   end; // end del while
   WriteLn(Archivo,'');
   // termina segunda seccion
   { VOY A OBTENER EL DETALLE PARA TODOS Y CADA UNO DE LOS EMPLEADOS QUE FUERON
    ASIGNADOS EN EL DIA DADO.
    PRIMERO TOMO EL FOLIO DEL CORTE CON SUS RESPECTIVAS FECHAS DE ASIGNACION
    Y FECHA EN QUE SE PROCESO SU CORTE, ASI COMO LA TAQUILLA
    }
   // saco todas las formas de pago  existentes
   sql:='Select ID_FORMA_PAGO, ABREVIACION, DESCRIPCION FROM PDV_C_FORMA_PAGO;';
   IF not EjecutaSQL(sql,QueryFormasPago,_LOCAL) then
   begin
      ShowMessage('Ocurrio un error al procesar el corte (PDV_C_FORMA_PAGO), avise al administrador del sistema.');
      CloseFile(Archivo);
      Exit;
   end;
   // saco todas los ocupantes existentes
   sql:='Select ID_OCUPANTE, ABREVIACION, DESCRIPCION FROM PDV_C_OCUPANTE;';
   IF not EjecutaSQL(sql,queryOcupantes,_LOCAL) then
   begin
      ShowMessage('Ocurrio un error al procesar el corte (PDV_C_OCUPANTE), avise al administrador del sistema.');
      CloseFile(Archivo);
      Exit;
   end;
   WriteLn(Archivo,'DETALLE DE CORTES ');
   QueryL.First;
   WriteLn(Archivo,'FORMAS DE PAGO ');
   granTotalSistema:= 0 ;
   while not QueryFormasPago.Eof do // GENERAL
   begin // mientras haya cortes de empleados
   // IMPRIMO EL DETALLE PARA CADA UNO DE LOS EMPLEADOS ASIGNADOS UN DIA DADO.
   // SECCION II
       totalSistema:=0;
       totalCuantos:=0;
       WHILE NOT QueryL.Eof DO
       BEGIN  // MIENTRAS HAYA empleados
       // TRAERME EL TOTAL DE LA FORMA DE PAGO Y CUANTO FUE POR ESAS FORMAS
          SQL:='select COUNT(*) AS TOTAL , COALESCE(SUM(TARIFA),0) AS MONTO '+
               ' from PDV_T_BOLETO '+
               ' WHERE FECHA_HORA_BOLETO BETWEEN '+
               QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_INICIO').AsDateTime))+
               ' AND '+QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_FIN').AsDateTime)) +
               ' AND ID_TERMINAL='+ QuotedStr(Terminal) +
               ' AND ID_FORMA_PAGO = '+ QueryFormasPago.FieldByName('ID_FORMA_PAGO').AsString +
               ' AND TRAB_ID = '+QuotedStr(QueryL.FieldByName('ID_EMPLEADO').AsString);
              // ' AND ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
               // se habilita la linea anterior para que muestre TODAS LAS ENTRADAS
           //    ' AND ESTATUS_PROCESADO = ' + QUOTEDSTR(_ESTATUS_VENDIDO);
          // SHOWMESSAGE(SQL);
          IF not EjecutaSQL(sql,QUERY2,_LOCAL) then
          begin
               ShowMessage('ERROR 1 :Ocurrio un error al procesar el corte, avise al administrador del sistema.');
               CloseFile(Archivo);  Exit;
          end;
          totalCuantos:= totalCuantos + Query2.FieldByName('TOTAL').AsFloat;
          totalSistema:= totalSistema + QUERY2.FieldByName('MONTO').AsFloat;
          granTotalSistema:= granTotalSistema + Query2.FieldByName('MONTO').AsFloat;
          QueryL.Next;
       end; // end del while de QueryFormasPago
       WriteLn(Archivo,Forza_Izq(Format(_FORMATO_CANTIDADES_CORTES,[totalCuantos]), 20) +
                       Forza_Izq(QueryFormasPago.FieldbYnAME('DESCRIPCION').AsString, 25),     // documentos o totales
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[totalSistema]), 20));
       totalSistema:=0;
       totalCuantos:=0;
       QueryL.First;
       QueryFormasPago.Next; // avanzo de forma de pago
       END;   // end del while del Query
       WriteLn(Archivo,Forza_Izq('-----', 20),
                       Forza_Izq('', 25),
                       Forza_Der('-----', 20));
       WriteLn(Archivo,Forza_Izq('', 20) +
                       Forza_Izq('', 25),     // documentos o totales
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[granTotalSistema]), 20));
       granTotalSistema:= 0;
       WriteLn(Archivo,'');
       WriteLn(Archivo,'TIPO DE OCUPANTES ');
       totalSistema:=0;
       WHILE NOT QueryOcupantes.Eof DO
       BEGIN  // MIENTRAS HAYA TIPOS DE OCUPANTES
          totalSistema:=0;
          totalCuantos:=0;
          WHILE NOT QueryL.Eof DO
          BEGIN  // MIENTRAS HAYA FORMAS DE PAGO
             SQL:='select COUNT(*) AS TOTAL , COALESCE(SUM(TARIFA),0) AS MONTO '+
                  ' from PDV_T_BOLETO '+
                  ' WHERE FECHA_HORA_BOLETO BETWEEN '+
                  QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_INICIO').AsDateTime))+
                  ' AND '+QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_FIN').AsDateTime)) +
                  ' AND ID_TERMINAL='+ QuotedStr(Terminal) +
                  ' AND ID_OCUPANTE = '+ QueryOcupantes.FieldByName('ID_OCUPANTE').AsString +
                  ' AND TRAB_ID = '+QuotedStr(QueryL.FieldByName('ID_EMPLEADO').AsString) ;
//                  ' AND ESTATUS_PROCESADO = ' + QUOTEDSTR(_ESTATUS_VENDIDO);
 //                 ' AND ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )';
             // se habilita la linea anterior para mostrar  TODO lo que entro por EFE y TARJETAS
          // SHOWMESSAGE(SQL);
          IF not EjecutaSQL(sql,QUERY2,_LOCAL) then
          begin
               ShowMessage('ERROR 1 :Ocurrio un error al procesar el corte, avise al administrador del sistema.');
               CloseFile(Archivo);
               Exit;
          end;
          QueryL.Next;
          totalCuantos:= totalCuantos + Query2.FieldByName('TOTAL').AsFloat;
          totalSistema:= totalSistema + QUERY2.FieldByName('MONTO').AsFloat;
          granTotalSistema := granTotalSistema + Query2.FieldByName('MONTO').AsFloat;
          END; // end del while de los empleados (Query)

          WriteLn(Archivo,Forza_Izq(Format(_FORMATO_CANTIDADES_CORTES,[totalCuantos]), 20), //cantidades
                       Forza_Izq(QueryOcupantes.FieldbYnAME('DESCRIPCION').AsString, 25),  // de que tipo es
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[totalSistema]), 20));   // cuanto debe entregar
          QUERYL.FIRST;
          QueryOcupantes.Next;  // avanzo Ocupante
       END;   // end del while del QueryFormasPago
        WriteLn(Archivo,Forza_Izq('-----', 20),
                       Forza_Izq('-----', 25),
                       Forza_Der('-----', 20));
        WriteLn(Archivo,Forza_Izq(' ', 20),
                       Forza_Izq(' ', 25),
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[granTotalSistema]), 20));
        Aux1:= granTotalSistema;
        WriteLn(Archivo,'');
        WriteLn(Archivo,'CANCELADOS ');
        WriteLn(Archivo,'FORMAS DE PAGO ');
       granTotalSistema:=0;
       QUERYL.First; // Avanzo de Empleado
       QueryOcupantes.First; // Regreso al primer registro de Ocupantes
       QueryFormasPago.First; // Regreso al primer registro de Formas de Pago
       /////////////////////////////////////////////////////
       while not QueryFormasPago.Eof do // GENERAL
       begin // mientras haya cortes de empleados
   // IMPRIMO EL DETALLE PARA CADA UNO DE LOS EMPLEADOS ASIGNADOS UN DIA DADO.
   // SECCION II
       totalSistema:=0;
       totalCuantos:=0;
       WHILE NOT QueryL.Eof DO
       BEGIN  // MIENTRAS HAYA empleados
       // TRAERME EL TOTAL DE LA FORMA DE PAGO Y CUANTO FUE POR ESAS FORMAS
          SQL:='select COUNT(*) AS TOTAL , COALESCE(SUM(B.TARIFA),0) AS MONTO '+
               ' from PDV_T_BOLETO_CANCELADO as C join PDV_T_BOLETO AS B ON (B.ID_BOLETO = C.ID_BOLETO '+
               ' and B.ID_TERMINAL = C.ID_TERMINAL) '+
               ' WHERE FECHA_HORA_CANCELADO BETWEEN '+
               QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_INICIO').AsDateTime))+
               ' AND '+QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_FIN').AsDateTime)) +
               ' AND C.ID_TERMINAL='+ QuotedStr(Terminal) +
               ' AND ID_FORMA_PAGO = '+ QueryFormasPago.FieldByName('ID_FORMA_PAGO').AsString +
               ' AND C.TRAB_ID = B.TRAB_ID ' +
               ' AND C.TRAB_ID_CANCELADO = '+QuotedStr(QueryL.FieldByName('ID_EMPLEADO').AsString);
//        SHOWMESSAGE(SQL);
          IF not EjecutaSQL(sql,QUERY2,_LOCAL) then
          begin
               ShowMessage('ERROR 1 :Ocurrio un error al procesar el corte, avise al administrador del sistema.');
               CloseFile(Archivo);
               Exit;
          end;
          totalCuantos:= totalCuantos + Query2.FieldByName('TOTAL').AsFloat;
          totalSistema:= totalSistema + QUERY2.FieldByName('MONTO').AsFloat;
          granTotalSistema:= granTotalSistema + Query2.FieldByName('MONTO').AsFloat;
          QueryL.Next;
       end; // end del while de QueryFormasPago
       WriteLn(Archivo,Forza_Izq(Format(_FORMATO_CANTIDADES_CORTES,[totalCuantos]), 20) +
                       Forza_Izq(QueryFormasPago.FieldbYnAME('DESCRIPCION').AsString, 25),     // documentos o totales
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[totalSistema]), 20));
       totalSistema:=0;
       totalCuantos:=0;
       QueryL.First;
       QueryFormasPago.Next; // avanzo de forma de pago
       END;   // end del while del Query
       WriteLn(Archivo,Forza_Izq('', 20) +
                       Forza_Izq('', 25),     // documentos o totales
                       Forza_Der('-----', 20));
       WriteLn(Archivo,Forza_Izq('', 20) +
                       Forza_Izq('', 25),     // documentos o totales
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[granTotalSistema]), 20));
       WriteLn(Archivo,'');
       granTotalSistema:=0;
       WriteLn(Archivo,'TIPO DE OCUPANTES ');
       totalSistema:=0;
       QueryL.First;
       WHILE NOT QueryOcupantes.Eof DO
       BEGIN  // MIENTRAS HAYA TIPOS DE OCUPANTES
          totalSistema:=0;
          totalCuantos:=0;
          WHILE NOT QueryL.Eof DO
          BEGIN  // MIENTRAS HAYA FORMAS DE PAGO
             SQL:='select COUNT(*) AS TOTAL , COALESCE(SUM(B.TARIFA),0) AS MONTO '+
               ' from PDV_T_BOLETO_CANCELADO as C join PDV_T_BOLETO AS B ON (B.ID_BOLETO = C.ID_BOLETO '+
               ' AND B.ID_TERMINAL = C.ID_TERMINAL) '+
               ' WHERE FECHA_HORA_CANCELADO BETWEEN '+
               QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_INICIO').AsDateTime))+
               ' AND '+QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',QueryL.FieldByName('FECHA_FIN').AsDateTime)) +
               ' AND C.ID_TERMINAL='+ QuotedStr(Terminal) +
               ' AND B.ID_OCUPANTE = '+ QueryOCUPANTES.FieldByName('ID_OCUPANTE').AsString +
               ' AND C.TRAB_ID = B.TRAB_ID ' +
               ' AND C.TRAB_ID_CANCELADO = '+QuotedStr(QueryL.FieldByName('ID_EMPLEADO').AsString);

       //   SHOWMESSAGE(SQL);
          IF not EjecutaSQL(sql,QUERY2,_LOCAL) then
          begin
               ShowMessage('ERROR 1 :Ocurrio un error al procesar el corte, avise al administrador del sistema.');
               CloseFile(Archivo);
               Exit;
          end;
          QueryL.Next;
          totalCuantos:= totalCuantos + Query2.FieldByName('TOTAL').AsFloat;
          totalSistema:= totalSistema + QUERY2.FieldByName('MONTO').AsFloat;
          granTotalSistema:= granTotalSistema + query2.FieldByName('monto').AsFloat;
          END; // end del while de los empleados (Query)
          WriteLn(Archivo,Forza_Izq(Format(_FORMATO_CANTIDADES_CORTES,[totalCuantos]), 20), //cantidades
                       Forza_Izq(QueryOcupantes.FieldbYnAME('DESCRIPCION').AsString, 25),  // de que tipo es
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[totalSistema]), 20));   // cuanto debe entregar
          QUERYL.First;
          QueryOcupantes.Next;
       end;
       //////////////////////////////////////////////////
       WriteLn(Archivo,Forza_Izq('', 20) +
                       Forza_Izq('', 25),     // documentos o totales
                       Forza_Der('-----', 20));
       WriteLn(Archivo,Forza_Izq('', 20) +
                       Forza_Izq('', 25),     // documentos o totales
                       Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[granTotalSistema]), 20));
       Aux2:= granTotalSistema;
       WriteLn(Archivo,'');
       WriteLn(Archivo,'');
       WriteLn(Archivo,Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[Aux1]), 80));
       WriteLn(Archivo,Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[Aux2]), 80));
       WriteLn(Archivo,Forza_Der('----------',80));
       WriteLn(Archivo,Forza_Der(Format('$'+_FORMATO_CANTIDADES_CORTES,[Aux1-Aux2]), 80) );



   //end; // FIN DEL QUERY PRIMERO

   SQL:= 'SELECT ID_CORTE, FECHA_INICIO, FECHA_FIN, FONDO_INICIAL, ID_TAQUILLA, '+
         ' ID_EMPLEADO '      +
         ' FROM PDV_T_CORTE ' +
         ' WHERE FECHA_INICIO BETWEEN ' +
         QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha))+
        ' AND ID_TERMINAL='+ QuotedStr(Terminal);
       // ShowMessage(sql);
   WriteLn(Archivo,'VENTA DE BOLETOS POR FECHA');
   WriteLn(Archivo,'');
   WriteLn(Archivo,Forza_Izq('FECHA', 30) +
                   Forza_DER('TOTAL', 20) +
                   Forza_DER('IMPORTE', 20) );
   WriteLn(Archivo,'');
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   totalSistema:=0;
   begin // 1.- DESGLOCE IF  PARA LAS FECHAS
    while not QueryL.Eof do
    begin
        // PROCESO LA VENTA DE BOLETOS POR FECHA
       sql:='SELECT FECHA, COUNT(*) as TOTAL, SUM(TARIFA) as IMPORTE '+
        ' FROM PDV_T_BOLETO '+
        ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',
        QueryL.FieldByName('FECHA_INICIO').AsDateTime))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',QueryL.FieldByName('FECHA_FIN').AsDateTime)) +
        ' AND TRAB_ID = '+  QuotedStr(QueryL.FieldByName('ID_EMPLEADO').AsString) +
        ' AND ESTATUS_PROCESADO='+ qUOTEDStr(_ESTATUS_VENDIDO) +
//        ' AND ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
        ' GROUP BY FECHA';
       // ShowMessage(sql);
   If EjecutaSQL(sql,QueryFechas,_LOCAL) then
   begin // 1.- DESGLOCE IF
      QueryFechas.First;
      while not QueryFechas.Eof  do
      begin   // 2.- DESGLOCE -while
//         sHOWmESSAGE(QueryFechas.FieldByName('FECHA').AsString);
         LlenaMatrizGeneral(FormatDateTime('DD/MM/YYYY',QueryFechas.FieldByName('FECHA').AsDateTime),
                            QueryFechas.fieldByName('TOTAL').asInteger,
                            QueryFechas.fieldByName('IMPORTE').AsFloat);
         totalSistema:= totalSistema + QueryFechas.fieldByName('IMPORTE').AsFloat;
         QueryFechas.Next;
      end; // 2.- DESGLOCE    -while
      QueryL.Next;
    end; // end del while

   end; // 1.- IF DESGLOCE
    for i:=0 to LFechas.Count -1 do
    WriteLn(Archivo,Forza_Izq(TFechasGlobal(LFechas.Objects[i]).fecha,30) +
                    Forza_DER(varToStr(TFechasGlobal(LFechas.Objects[i]).boletos), 20) +
                    Forza_DER(Format('$'+_FORMATO_CANTIDADES_CORTES,[TFechasGlobal(LFechas.Objects[i]).monto]), 20) );
    LimpiarObjetosLista(lFechas);
  end; // end del if para las fechas
  WriteLn(Archivo,Forza_Izq('',50)+
                  Forza_DER('___________', 20) );
  WriteLn(Archivo,Forza_Izq('',50)+
                  Forza_DER(Format('$'+_FORMATO_CANTIDADES_CORTES,[totalSistema]), 20) );
  destruyeQuerysDetalle;
end;

function LlenaMatrizGeneral(miFecha: String; miBoletos: Integer;
  miMonto: Double): Boolean;
var indice: Integer;
    existe: Boolean;
begin
  indice:= Lfechas.IndexOf(miFecha);

    if indice >= 0 then
    begin
      TFechasGlobal(Lfechas.Objects[indice]).boletos:=
           TFechasGlobal(Lfechas.Objects[indice]).boletos + miBoletos;
      TFechasGlobal(Lfechas.Objects[indice]).monto:=
           TFechasGlobal(Lfechas.Objects[indice]).monto + miMonto;
    end
    else
    begin
      _fechas:= TFechasGlobal.Create;
      _fechas.CreateObject(miFecha,miBoletos, miMonto);
      Lfechas.AddObject(miFecha, _fechas);
    end;
end;

procedure LimpiarObjetosLista(lista: TstringList);
var indice: Integer;
begin
   for indice:= 0 to Lista.Count-1 do
    TObject(Lista.Objects[indice]).Free;
  Lista.Clear;
end;


function creaQuerysDetalles: Boolean;
begin
    Query2:=                        TSQLQuery.Create(nil);
    Query2.SQLConnection:=          dm.Conecta;
    QueryFormasPago:=               TSQLQuery.Create(nil);
    QueryFormasPago.SQLConnection:= dm.Conecta;
    QueryOcupantes:=                TSQLQuery.Create(nil);
    QueryOcupantes.SQLConnection:=  dm.Conecta;
    QueryFechas:=                   TSQLQuery.Create(nil);
    QueryFechas.SQLConnection:=     dm.Conecta;
    Lfechas := TStringList.Create;
end;

procedure destruyeQuerysDetalle;
begin
    Query2.Destroy;
    QueryFormasPago.Destroy;
    QueryOcupantes.Destroy;
    QueryFechas.Destroy;
    LFechas.Destroy;
end;
Procedure EncabezadoCorteTipoServicio(var Archivo: TextFile; fechaInicial, fechaFinal: TdateTime; Terminal : String);
begin
   WriteLn(Archivo,'GRUPO PULLMAN DE MORELOS');
   WriteLn(Archivo,'');
   WriteLn(Archivo,'REPORTE DE CORTES POR TIPO DE SERVICIO');
   WriteLn(Archivo,'FECHA DEL CORTE: '+ FormatDateTime('dd/mm/yyyy HH:NN',NOW() ));
   WriteLn(Archivo,'REPORTE EMITIDO EN '+ TERMINAL);
   WriteLn(Archivo,'DESDE '+ FormatDateTime('DD/MM/YYYY ',fechaInicial) +
                   ' HASTA ' + FormatDateTime('DD/MM/YYYY ',fechaFinal));
   WriteLn(Archivo,'');

end;

procedure DetalleCortesTipoServicio(var Archivo: textFile; terminal: String; fechaI, fechaF: TDateTime);
var
   GranTotal: Double;
   i: Integer;
BEGIN
// Obtengo TODOS los empleados asignados en esa terminal y esas fechas dadas desde la fecha inicial 00:00:00 hasta
// fecha final 23:59:59
   creaQuerysDetalles;
   SQL:= 'SELECT ID_CORTE, FECHA_INICIO, FECHA_FIN, FONDO_INICIAL, ID_TAQUILLA, '+
         ' ID_EMPLEADO, USU.NOMBRE '      +
         ' FROM PDV_T_CORTE AS COR JOIN PDV_C_USUARIO as USU ON (COR.ID_EMPLEADO= USU.TRAB_ID) ' +
         ' WHERE FECHA_INICIO BETWEEN ' +
         QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fechaI))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fechaF))+
        ' AND ID_TERMINAL='+ QuotedStr(Terminal)+
        ' ORDER BY ID_CORTE ASC;';
   IF not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
      ShowMessage('Ocurrio un error al procesar el corte por tipo de servicio, avise al administrador del sistema.');
      Exit;
   end;
   WriteLn(Archivo,Forza_Izq('CORTE', 7) +
                   FORZA_IZQ('ID EMPLEADO',15)+
                   FORZA_IZQ('NOMBRE', 30)+
                   FORZA_IZQ('SERVICIO',20 )+
                   FORZA_IZQ('EFECTIVO', 20));
   while not QueryL.Eof do
   begin // begin del while QUERY
    // BOLETOS VENDIDOS
   // boletos vendidos ....
         sql:='SELECT   COALESCE(sum(BOL.TARIFA),0) as EFECTIVO, SER.DESCRIPCION '+
              ' from PDV_T_BOLETO AS BOL JOIN PDV_T_CORRIDA AS COR ON (COR.ID_CORRIDA = BOL.ID_CORRIDA AND '+
              ' COR.FECHA=BOL.FECHA) '+
              ' LEFT JOIN SERVICIOS AS SER ON (COR.TIPOSERVICIO= SER.TIPOSERVICIO) '+
              ' WHERE FECHA_HORA_BOLETO BETWEEN '+QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',
              QUERYL.FieldByName('FECHA_INICIO').AsDateTime))+
              ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',
              QUERYL.FieldByName('FECHA_FIN').AsDateTime))+' AND '+
              ' TRAB_ID='+QuotedStr(QueryL.FieldByName('ID_EMPLEADO').AsString)+
              ' and BOL.ID_TERMINAL = '+QuotedStr(Terminal)+
//              ' AND BOL.ESTATUS_PROCESADO='+ QuotedStr(_ESTATUS_VENDIDO)+
              ' GROUP BY DESCRIPCION ' +
              ' UNION '+
              ' SELECT  COALESCE(sum(BOL.TARIFA)*-1,0) as EFECTIVO, SER.DESCRIPCION '+
              ' from PDV_T_BOLETO AS BOL JOIN PDV_T_CORRIDA AS COR ON (COR.ID_CORRIDA = BOL.ID_CORRIDA AND '+
              ' COR.FECHA=BOL.FECHA) join PDV_T_BOLETO_CANCELADO AS CANC ON '+
              ' (CANC.ID_BOLETO = BOL.ID_BOLETO AND CANC.ID_TERMINAL=BOL.ID_TERMINAL) '+
              ' LEFT JOIN SERVICIOS AS SER ON (COR.TIPOSERVICIO= SER.TIPOSERVICIO) '+
              ' WHERE FECHA_HORA_CANCELADO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',
              QUERYL.FieldByName('FECHA_INICIO').AsDateTime))+
              ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd HH:NN:SS',
              QUERYL.FieldByName('FECHA_FIN').AsDateTime))+
              ' AND CANC.TRAB_ID_CANCELADO='+QuotedStr(QueryL.FieldByName('ID_EMPLEADO').AsString)+
              ' and BOL.ID_TERMINAL = ' +QuotedStr(Terminal)+  ' AND CANC.TRAB_ID = BOL.TRAB_ID  ' +
              ' GROUP BY DESCRIPCION;';
//       ShowMessage(sql);
         IF not EjecutaSQL(sql,Query2,_LOCAL) then
         begin
           ShowMessage('Ocurrio un error al procesar el detalle del corte por tipo de servicio.'+ char(13)+
                       'Avise al administrador del sistema.');
           Exit;
         end; // FIN DEL IF DEL QUERY2
         WriteLn(Archivo,'');
         WriteLn(Archivo,FORZA_IZQ(QUERYL.FieldByName('ID_CORTE').AsString, 7) +
                         FORZA_IZQ(QUERYL.FieldByName('ID_EMPLEADO').ASSTring,10)   +
                         FORZA_IZQ(QUERYL.FieldByName('NOMBRE').AsString,30 )+
                         FORZA_IZQ(QUERY2.FieldByName('DESCRIPCION').AsString, 20)+
                         FORZA_DER(Format('$'+_FORMATO_CANTIDADES_CORTES,[QUERY2.FieldByName('EFECTIVO').asFloat]), 12));
         LlenaMatrizGeneral(Query2.FieldByName('DESCRIPCION').AsString,
                            Query2.fieldByName('EFECTIVO').AsInteger,
                            Query2.fieldByName('EFECTIVO').asfloat);
         QUERY2.Next;
         WHILE NOT QUERY2.Eof DO
         BEGIN
               WriteLn(Archivo,    ESPACIOS(7) +
                                   ESPACIOS(10)+
                                   ESPACIOS(30)+
                                   FORZA_IZQ(QUERY2.FieldByName('DESCRIPCION').AsString,20 )+
                                   FORZA_DER(Format('$'+_FORMATO_CANTIDADES_CORTES,[QUERY2.FieldByName('EFECTIVO').AsFloat]), 12));
               LlenaMatrizGeneral(Query2.FieldByName('DESCRIPCION').AsString,
                            Query2.fieldByName('EFECTIVO').AsInteger,
                            Query2.fieldByName('EFECTIVO').asfloat);
               QUERY2.Next;
         END;
         QUERYL.Next;
   end; // end del while   DEL QUERY
   WriteLn(Archivo,'');
   WriteLn(Archivo,'');
   WriteLn(Archivo,Forza_Izq('SERVICIO', 30) +
                   Forza_DER('EFECTIVO', 20) );
   granTotal:=0;
   for i:=0 to LFechas.Count -1 do
   BEGIN
            WriteLn(Archivo,Forza_Izq(TFechasGlobal(LFechas.Objects[i]).fecha,30) +
                        Forza_DER(Format('$'+_FORMATO_CANTIDADES_CORTES,[TFechasGlobal(LFechas.Objects[i]).monto]), 20) );
            granTotal:= granTotal + TFechasGlobal(LFechas.Objects[i]).monto;
   END;
   WriteLn(Archivo,Forza_Izq('', 30) +
                   Forza_DER('___________', 20) );
   WriteLn(Archivo,Forza_Izq('', 30) +
                   Forza_DER(Format('$'+_FORMATO_CANTIDADES_CORTES,[granTotal]), 20) );

   destruyeQuerysDetalle;
   LimpiarObjetosLista(lFechas);
END;

{


}

procedure DesgloceFechasFinTurno(var Archivo: TextFile);
begin
  // DESGLOCE DE VENTAS REALIZADAS POR FECHA

   sql:='SELECT FECHA, COUNT(*) as TOTAL, SUM(TARIFA) as IMPORTE, '+
        ' (count(*) / (select count(*) '+
        ' FROM PDV_T_BOLETO '+
        ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
        ' AND  ID_TERMINAL = '+QuotedStr(gs_terminal) + ' and trab_id='+ QuotedStr(idPromotor) +
        ' AND ESTATUS_PROCESADO='+QuotedStr(_ESTATUS_VENDIDO)+'))*100 as X '+
        ' FROM PDV_T_BOLETO '+
        ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
        ' AND TRAB_ID = '+  QuotedStr(idPromotor) +  ' and ID_TERMINAL = ' + QuotedStr(gs_terminal) +
        ' AND ESTATUS_PROCESADO='+QuotedStr(_ESTATUS_VENDIDO)+
     //   ' AND ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
     // se comenta esta linea por que Venegas comenta que debe reflejar lo vendido en efectivo, ixe y demas
        ' GROUP BY FECHA;';
//     ShowMessage(sql);
        //verificar si se deja asi o se le restan los cancelados
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- DESGLOCE IF
      WriteLn(Archivo,'');
      if  not QueryL.Eof then
      begin
          WriteLn(Archivo,Forza_Izq('FECHA', 20) +
                          Forza_DER('NO. BOLETOS', 20) +
                          Forza_DER('IMPORTE', 20) +
                          Forza_DER('%',10));
         WriteLn(Archivo,'');
      end;
      while not QueryL.Eof  do
      begin   // 2.- DESGLOCE -while
         WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('FECHA').AsString, 20) +
                         Forza_DER(QueryL.fieldByName('TOTAL').AsString, 20) +
                         Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPORTE').AsFloat]), 20) +
                         Forza_DER(QueryL.fieldByName('X').AsString, 10) );
         QueryL.Next;
      end; // 2.- DESGLOCE    -while
   end; // 1.- IF DESGLOCE
   WriteLn(Archivo,' ');

end;


procedure VentaNetaFinDeTurno(var Archivo: TextFile);
begin
  WriteLn(Archivo,'');
  WriteLn(Archivo,'');
  WriteLn(Archivo,'');
   // GLOBALIZADO GENERAL DE VENDIDOS Y CANCELADOS, LOS BUSCO EN PDV_T_BOLETO
   // Y EN PDV_T_BOLETO_CANCELADO LIGADO CON PDV_T_BOLETO
   SQL:='SELECT ''VENDIDOS''  AS DESCRIPCION, '+
        ' COALESCE(COUNT(*),0) AS ''CANTIDAD'', SUM(TARIFA) AS ''MONTO'''+
        ' FROM PDV_T_BOLETO '+
        ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
        ' AND TRAB_ID = '+  QuotedStr(idPromotor)  + // ' AND ESTATUS_PROCESADO = '+ QuotedStr(_ESTATUS_VENDIDO) +
        ' AND ID_TERMINAL=' + QuotedStr(gs_terminal) +
 //       ' AND ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
        ' UNION ' +
        ' SELECT ''CANCELADOS''  AS DESCRIPCION, '+
        ' COALESCE(COUNT(BOL.TARIFA),0) AS ''CANTIDAD'', COALESCE(SUM(BOL.TARIFA)) AS ''MONTO'''+
        ' FROM PDV_T_BOLETO as BOL JOIN PDV_T_BOLETO_CANCELADO AS CANC ON (BOL.ID_BOLETO = CANC.ID_BOLETO) ' +
        ' WHERE  CANC.TRAB_ID_CANCELADO = ' + QuotedStr(idPromotor)  +
        '  AND CANC.ID_TERMINAL= '+ QuotedStr(gs_terminal) + ' AND CANC.FECHA_HORA_CANCELADO BETWEEN ' +
        QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
        ' AND BOL.TRAB_ID=CANC.TRAB_ID ' +
//        ' AND BOL.ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
// NO LO COLOCO POR QUE ES LA VENTA GENERAL, TOTAL DE UN PROMOTOR, ES EL DEPOSITO QUE DEBE DE HABER EN EL BANCO POR ESE PROMOTOR
        ' group by 1';
//   showmessage(sql);
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- DESGLOCE IF
      IF not QueryL.Eof THEN
      begin
             WriteLn(Archivo,'VENTAS NETAS DE FIN DE TURNO');
             WriteLn(Archivo,'');

             WriteLn(Archivo,Forza_Izq('ESTATUS BOLETO', 30) +
                             Forza_DER('CANTIDAD', 10) +
                             Forza_DER('MONTO', 20) );
      end;
      while not QueryL.Eof  do
      begin   // 2.- DESGLOCE -while
         WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 30) +
                         Forza_DER(QueryL.fieldByName('CANTIDAD').AsString, 10) +
                         Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 20) );
         if QueryL.fieldByName('DESCRIPCION').AsString = 'VENDIDOS' then
         begin
            Venta    := QueryL.fieldByName('MONTO').AsFloat;
            Vendidos := QueryL.fieldByName('CANTIDAD').AsInteger;
         end
         else if QueryL.fieldByName('DESCRIPCION').AsString = 'CANCELADOS' then
         begin
            Cancelaciones:= QueryL.fieldByName('MONTO').AsFloat;
            Cancelados   := QueryL.fieldByName('CANTIDAD').AsInteger;
         end;
         QueryL.Next;
      end; // 2.- DESGLOCE    -while
   end; // 1.- IF DESGLOCE
  // ShowMessage(sql);
  VentaNeta     := 0;
  VendidosNetos := 0;
  VentaNeta     := Venta - Cancelaciones;
  VendidosNetos := Vendidos - Cancelados;
  if (ventaNeta < 0) OR (vendidosNetos < 0) then
  begin
        VentaNeta := 0;
        VendidosNetos:= 0;
  end;
  WriteLn(Archivo,Forza_Izq('', 30) +
                         Forza_DER(' ', 10) +
                         Forza_DER('----------', 20) );
  WriteLn(Archivo,Forza_Izq('TOTALES NETOS', 30) +
                         Forza_DER('', 10) +
                         Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[VentaNeta]), 20) );

   WriteLn(Archivo,'');

end;
end.
