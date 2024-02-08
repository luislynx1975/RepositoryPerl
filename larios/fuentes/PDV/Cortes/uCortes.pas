unit uCortes;
{
Autor: Gilberto Almanza Maldonado
Fecha: Viernes, 23 de Julio de 2010.
Unidad que contiene las funciones, procedimientos  y constantes
que ocupa el modulo de cortes.

25 de Septiembre de 2018.
- Se agrega al código por solicitud del depto. de Finanzas que la impresión del
corte sea únicamente una hoja. Con el control de folios al final de la misma.
- Se agrega una forma (frmAsignacionFondo) por solicitud del área de Finanzas,
para fincar fondo a los promotores en el área de caja, el módulo abre un corte
nuevo para el promotor en cuestión. El módulo permite imprimir el recibo.


}
interface
{$HINTS OFF}
{$WARNINGS OFF}
uses Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ComCtrls, ExtCtrls, Grids, Aligrid,
  XPStyleActnCtrls, ActnList,  ActnMan,  DB, ImgList, Buttons, comun, comunii,
  Printers, Data.SqlExpr;

var
  NombreCajero, idCajero, idPromotor, NombreEmpleado, idTaquilla: String;
  FechaIniciaCorte, FechaTerminaCorte: TDateTime;
  FondoInicial: Double;
  corte: String;
  QueryL, Query2, QueryFormasPago, QueryOcupantes, QueryFechas, QueryServicios, QueryDesglose: TSQLQuery;
  Venta, Cancelaciones, VentaNeta: Double;
  Vendidos, Cancelados, VendidosNetos : Integer;
  Lfechas: TstringList;
  LServicios:   TstringList;
  tipoImpresora: String;
  ArchivoOpos: String;
  _Subtotal, _Total, _IvaCobrado: Real;
  _QUERY_DESGLOCE_FECHAS_FIN_TURNO : String;
  RazonSocial: String;

const
  _ITHACA = 'Ithaca';
  _PREDETERMINADA = 'Predeterminada';
  _TOSHIBA_MINI   = 'ToshibaMini';


function EncabezadoCorteFinTurno(var Archivo: TextFile): Boolean;
function EncabezadoCorteFinTurnoOPOS(var Archivo : String): Boolean;

function DetalleEntregaCorteFinTurno(var Archivo: TextFile;  sag1,sag2: TStringGrid): Boolean;
procedure DetalleEntregaCorteFinTurnoOPOS(var Archivo: String;  sag1,sag2: TStringGrid);

function  TotalBoletosCorteFinTurno(var Archivo: TextFile): Boolean;
procedure TotalBoletosCorteFinTurnoOPOS(var Archivo: String);

function DetalleVentaCorteFinTurno(var Archivo: TextFile): Boolean;
procedure DetalleVentaCorteFinTurnoOPOS(var Archivo: String);

procedure DesgloceFechasFinTurno(var Archivo: TextFile);
procedure DesgloceFechasFinTurnoOPOS(var Archivo: String);

procedure VentaNetaFinDeTurno (var Archivo: TextFile);
procedure VentaNetaFinDeTurnoOPOS(var Archivo: String);


Procedure AsignaQueryDesgloceFechas;
Procedure AsignaQueryDesgloceTotal;
procedure AsignaQueryVentaFinTurnoPasajeros;
procedure AsignaQueryVentaFinTurnoFormaPago;

function EncabezadoCorteFinDia(var Archivo: TextFile; fecha: TDateTime; Terminal: String): Boolean;
Procedure EncabezadoCorteFinDiaOPOS(var Archivo: String; fecha: TDateTime; Terminal: String);

Procedure EncabezadoCorteTipoServicio(var Archivo: TextFile; fechaInicial, fechaFinal: TdateTime; Terminal : String);
Procedure EncabezadoCorteTipoServicioOPOS(var Archivo: String; fechaInicial, fechaFinal: TdateTime; Terminal : String);

function DetalleDocumentosCorteFinDia(var Archivo: TextFile; terminal : String; fecha: TDateTime): Boolean;
procedure DetalleDocumentosCorteFinDiaOPOS(var Archivo: String; terminal : String; fecha: TDateTime);



function  DetalleCortesFinDeDia(var Archivo: textFile; terminal: String; fecha: TDateTime): Boolean;
Procedure DetalleCortesFinDeDiaOPOS(var Archivo: String; terminal: String; fecha: TDateTime);


procedure SumaFinalDelDia(var Archivo: textFile; terminal: String; fecha: TDateTime);

procedure SumaFinalDelDiaOPOS(var Archivo: string; terminal: String; fecha: TDateTime);



procedure DetalleCortesTipoServicio(var Archivo: textFile; terminal: String; fechaI, fechaF: TDateTime);
procedure DetalleCortesTipoServicioOPOS(var Archivo: String; terminal: String; fechaI, fechaF: TDateTime);


function InicializaDatos(promotor :String; corte:string): Boolean;
function DesgloceBoletosCorteFinTurno(var Archivo: TextFile): Boolean;

function ImprimeCodigoDocumento: Boolean;
function RegresaCodigoDocumento: String;


function CortesPendientes(Terminal: String; fechaI, fechaF: TDateTime): Integer;
function LlenaMatrizGeneral(miFecha: String; miBoletos: Integer; miMonto: Double): Boolean;
function LlenaMatrizServicios(servicio: String; efectivo: double; ixe: double; banamex: double): Boolean;
procedure LimpiarObjetosLista(lista: TstringList);
function creaQuerysDetalles: Boolean;
procedure destruyeQuerysDetalle;

Procedure FinalizaDatos;
Procedure CreaQuery;

function DetalleDocumentosEfectivoPredeterminada(var Archivo: TextFile; IdCorte: Integer; Empleado: String): Boolean;
function RegresaDatoPreCorte(registro: string; id_corte: integer; trab_id: string): Variant;
function RevisaFoliosCorte(idCorte, promotor: String): Boolean;
function RegresaImpresoraVenta(corte: Integer): Integer;

function RegresaEmpleadoCorte( idEmpleado: String): String;
procedure CargaRazonSocial(terminal:String);

function EmpleadosPendientes(Terminal: String; FechaI, FechaF: TDateTime): String;

function controlBoletosAutomatizados(var Archivo: Textfile; idCorte: Integer;  Empleado: String): Boolean;

implementation

uses DMdb, frmCorte, frmCorteTipoServicio, u_impresion;

function RegresaImpresoraVenta(corte: Integer): Integer;
VAR
   TAQUILLA: INTEGER;
   IP: STRING;
   qry : TSQLQuery;
begin
  qry := TSQLQuery.Create(nil);
  qry.SQLConnection := DM.Conecta;
  sql:='SELECT ID_TAQUILLA FROM PDV_T_CORTE WHERE ID_CORTE= ' + IntToStr(corte) +
       ' AND ID_TERMINAL = ' + QuotedStr(comun.gs_terminal);
   If EjecutaSQL(sql,qry,_LOCAL) then
   begin
     TAQUILLA := qry.FieldByName('ID_TAQUILLA').AsInteger;
     sql:= 'SELECT IP, IMP_BOLETO FROM PDV_C_TAQUILLA WHERE ID_TAQUILLA = '+  INTTOSTR(TAQUILLA) +
           ' AND  ID_TERMINAL = ' + QuotedStr(comun.gs_terminal) ;
     If EjecutaSQL(sql,qry,_LOCAL) then
     BEGIN
       IP:=  qry.FieldByName('IP').AsString;
       RESULT:= qry.FieldByName('IMP_BOLETO').AsInteger;
     END;
   end;
   qry.Free;
   qry := nil;
end;

{Esta funcion permite crear y escribir el encabezado de los cortes de fin
de turno de cada promotor, cuando se imprime.}
function EncabezadoCorteFinTurno(var Archivo: TextFile): Boolean;

begin
       cargaRazonSocial(gs_terminal);
       WriteLn(Archivo,RazonSocial);
       // estos datos se toman de la tabla y no se "recalculan"
       WriteLn(Archivo,'CORTE DE FIN DE TURNO, '+comun.gs_terminal);
       WriteLn(Archivo,'EMPLEADO       : ' +  idPromotor + '-' + NombreEmpleado +
                       ' FOLIO CORTE : ' +  corte  + ' TAQUILLA: ' + idTaquilla);
       WriteLn(Archivo,'INICIO DE LABORES : ' + FormatDateTime('dd/mm/yyyy hh:nn:ss ', FechaIniciaCorte) +
                       '  FECHA DEL CORTE : ' + FormatDateTime('dd/mm/yyyy hh:nn:ss ', FechaTERMINACorte) );
       sql:='SELECT NOMBRE FROM PDV_C_USUARIO WHERE TRAB_ID = ' +
            QuotedStr(idCajero);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
         NombreCajero:= QueryL.FieldByName('NOMBRE').AsString;
               WriteLn(Archivo,'FONDO FIJO   : $'+  Format(_FORMATO_CANTIDADES_CORTES,[FondoInicial])   +
                       '         CAJERO : ' + idCajero +' - '+ NombreCajero);
end;

function EncabezadoCorteFinTurnoOPOS(var Archivo : String): Boolean;
begin
       Archivo:='';
       cargaRazonSocial(gs_terminal);
       Archivo:= Archivo + TextoAlineado_OPOS(RazonSocial, 'c');
       Archivo:= Archivo + TextoAlineado_OPOS(comun.gs_terminal, 'c');
       // estos datos se toman de la tabla y no se "recalculan"
       Archivo:= Archivo + TextoAlineado_OPOS('CORTE DE FIN DE TURNO', 'c');
       Archivo:= Archivo + TextoAlineado_OPOS('EMPLEADO:'+idPromotor + '-' + NombreEmpleado,'i' );
       Archivo:= Archivo + TextoAlineado_OPOS('FOLIO DE CORTE : ' +  corte, 'c');
       Archivo:= Archivo + TextoAlineado_OPOS('NO. TAQUILLA : ' +  idTaquilla, 'c');
       Archivo:= Archivo + TextoAlineado_OPOS('INICIO DE LABORES: '+ FormatDateTime('dd/mm/yyyy hh:nn:ss ', FechaIniciaCorte),'i');
       Archivo:= Archivo + TextoAlineado_OPOS('FECHA DEL CORTE  : '+ FormatDateTime('dd/mm/yyyy hh:nn:ss ', FechaTERMINACorte),'i');
       sql:='SELECT NOMBRE FROM PDV_C_USUARIO WHERE TRAB_ID = ' +
            QuotedStr(idCajero);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
         NombreCajero:= QueryL.FieldByName('NOMBRE').AsString;

       Archivo:= Archivo + TextoAlineado_OPOS('FONDO INICIAL: $'+  Format(_FORMATO_CANTIDADES_CORTES,[FondoInicial]), 'i');
       Archivo:= Archivo + TextoAlineado_OPOS('CAJERO:' + idCajero + ' ' +NombreCajero ,'i');

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
        idTaquilla  :=      QueryL.FieldByName('ID_TAQUILLA').AsString;
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
         ' AND BOL.ID_TERMINAL =' + QuotedStr(gs_terminal)  +
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
        ' AND BOL.ID_TERMINAL =' + QuotedStr(gs_terminal)  +
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
                         Forza_Izq(FORMATDATETIME('DD/MM/YY HH:NN:SS',QueryL.fieldByName('FECHA_HORA_CANCELADO').AsDateTime), 20) +
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
         WriteLn(Archivo,Forza_Izq(FORMATDATETIME('DD/MM/YY HH:NN:SS',QueryL.fieldByName('FECHA_HORA').AsDateTime), 20) +
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
    _Subtotal     :=0;
    _Total        :=0;
    _IvaCobrado   :=0;
    WriteLn(Archivo,'');
           // asigno el query a la variable SQL para obtener la venta de fin de turno del corte 
           // agrupado por Tipos de Pasajeros.
           AsignaQueryVentaFinTurnoPasajeros;
           If EjecutaSQL(sql,QueryL,_LOCAL) then
           begin // 1.- DESGLOSE IF
              IF not QueryL.Eof THEN
              begin
                    WriteLn(Archivo,'VENTAS CON DESGLOSE POR TIPO DE OCUPANTES.');
                    WriteLn(Archivo,Forza_Izq('OCUPANTE', 20) +
                                    Forza_DER('CANTIDAD', 10) +
                                    Forza_DER('% IVA', 7)      +
                                    Forza_DER('IVA COBRADO', 15)      +
                                    Forza_DER('SUBTOTAL', 15)       +
                                    Forza_DER('TOTAL', 15)      );
              end;
              while not QueryL.Eof  do
              begin   // 2.- DESGLOCE -while
                 WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 20) +
                                 Forza_DER(QueryL.fieldByName('CANTIDAD').AsString, 10) +
                                 Forza_DER(FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IVA').AsFloat]), 7) +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPUESTO').AsFloat]), 15) +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('INGRESO').AsFloat]), 15) +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 15)  );
                 _IvaCobrado:= _IvaCobrado+  QueryL.fieldByName('IMPUESTO').AsFloat;
                 _SubTotal  := _SubTotal  +  QueryL.fieldByName('INGRESO').AsFloat;
                 _Total     := _Total     +  QueryL.fieldByName('MONTO').AsFloat;
                 QueryL.Next;
              end; // 2.- DESGLOCE    -while
           end; // 1.- IF EJECUTASQL
           WriteLn(Archivo,Forza_Izq('', 20) +Forza_Izq('', 10) +Forza_Izq('', 7) +
            Forza_DER('--------------', 15) +
            Forza_DER('--------------', 15) +
            Forza_DER('--------------', 15)      );
           WriteLn(Archivo,Forza_Izq('', 20) +Forza_Izq('', 10) +Forza_Izq('', 7) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_IvaCobrado]), 15) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_SubTotal]), 15) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_Total]), 15)      );
           // VENTAS POR CADA UNA DE LAS FORMAS DE PAGO
           _Subtotal     :=0;
           _Total        :=0;
           _IvaCobrado   :=0;
           // asigno el query a la variable SQL para obtener la venta de fin de turno del corte 
           // agrupado por Formas de Pasajeros
           AsignaQueryVentaFinTurnoFormaPago;
           //showmessage(sql);
           If EjecutaSQL(sql,QueryL,_LOCAL) then
           begin // 1.- DESGLOCE IF
              IF not QueryL.Eof THEN
              begin
                   WriteLn(Archivo,'VENTAS CON DESGLOSE POR FORMA DE PAGO.');
                   WriteLn(Archivo,Forza_Izq('FORMA DE PAGO', 20) +
                                   Forza_DER('CANTIDAD', 10) +
                                   Forza_DER('% IVA', 7) +
                                   Forza_DER('IVA COBRADO', 15) +
                                   Forza_DER('SUBTOTAL', 15) +
                                   Forza_DER('TOTAL', 15) );
              end; // END DEL IF
              while not QueryL.Eof  do
              begin   // 2.- DESGLOCE -while
                 WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 20) +
                                 Forza_DER(QueryL.fieldByName('CANTIDAD').AsString, 10) +
                                 Forza_DER(FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IVA').AsFloat]), 7) +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPUESTO').AsFloat]), 15) +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('INGRESO').AsFloat]), 15)  +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 15) );
                 _IvaCobrado:= _IvaCobrado+  QueryL.fieldByName('IMPUESTO').AsFloat;
                 _SubTotal  := _SubTotal  +  QueryL.fieldByName('INGRESO').AsFloat;
                 _Total     := _Total     +  QueryL.fieldByName('MONTO').AsFloat;
                 QueryL.Next;
              end; // 2.- DESGLOCE    -while
           end; // 1.- IF WHILE
            WriteLn(Archivo,Forza_Izq('', 20) +Forza_Izq('', 10) +Forza_Izq('', 7) +
            Forza_DER('--------------', 15) +
            Forza_DER('--------------', 15) +
            Forza_DER('--------------', 15)      );
            WriteLn(Archivo,Forza_Izq('', 20) +Forza_Izq('', 10) +Forza_Izq('', 7) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_IvaCobrado]), 15) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_SubTotal]), 15) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_Total]), 15)      );
end;

procedure DetalleVentaCorteFinTurnoOPOS(var Archivo: String);
begin
        // asigno el query a la variable SQL para obtener la venta de fin de turno del corte
           // agrupado por Tipos de Pasajeros.
           AsignaQueryVentaFinTurnoPasajeros;
           If EjecutaSQL(sql,QueryL,_LOCAL) then
           begin // 1.- DESGLOCE IF
              IF not QueryL.Eof THEN
              begin
                    Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('OCUPANTES', 10) ,  'i' );
              end;
              _Subtotal     :=0;
              _Total        :=0;
              _IvaCobrado   :=0;
              while not QueryL.Eof  do
              begin   // 2.- DESGLOCE -while
                 Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 12) +
                                 Forza_DER('BOL: '+  QueryL.fieldByName('CANTIDAD').AsString, 10) +
                                 Forza_DER('% IVA: '+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IVA').AsFloat]), 15),'i' );

                 Archivo:= Archivo + textoAlineado_OPOS('IVA COBRADO $'+Forza_Izq(FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPUESTO').AsFloat]), 12) +
                                     Forza_Izq('SUBTOTAL $'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('INGRESO').AsFloat]), 20) ,'i');
                 Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('TOTAL: $'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 20),'i' );
                 _IvaCobrado:= _IvaCobrado+  QueryL.fieldByName('IMPUESTO').AsFloat;
                 _SubTotal  := _SubTotal  +  QueryL.fieldByName('INGRESO').AsFloat;
                 _Total     := _Total     +  QueryL.fieldByName('MONTO').AsFloat;
                 QueryL.Next;
              end; // 2.- DESGLOCE    -while
           end; // 1.- IF EJECUTASQL
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('-----------------------------------', 40),'i');
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('IVA COBRADO OCUPANTES $'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[_IvaCobrado]), 40),'i');
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('SUB TOTAL OCUPANTES $'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[_SubTotal]), 40),'i');
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('TOTAL OCUPANTES  $'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[_Total]), 40),'i');
           // asigno el query a la variable SQL para obtener la venta de fin de turno del corte 
           // agrupado por Formas de Pasajeros
           AsignaQueryVentaFinTurnoFormaPago;
           If EjecutaSQL(sql,QueryL,_LOCAL) then
           begin // 1.- DESGLOCE IF
              IF not QueryL.Eof THEN
              begin
                   Archivo:= Archivo + textoAlineado_OPOS('FORMAS DE PAGO.','c');
                 //Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('FORMA DE PAGO', 20) ,'i' );
                  {                 Forza_DER('CANTIDAD', 10) +
                                   Forza_DER('MONTO', 12),'i' );}
              end; // END DEL IF
               venta        :=0;
               cancelaciones:=0;
               vendidos     :=0;
               cancelados   :=0;
               _Subtotal     :=0;
               _Total        :=0;
               _IvaCobrado   :=0;
              while not QueryL.Eof  do
              begin   // 2.- DESGLOCE -while
                 Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 11) +
                                 Forza_DER('BOL: '+QueryL.fieldByName('CANTIDAD').AsString, 10) +
                                 Forza_DER('% IVA: '+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IVA').AsFloat]), 15),'i' );

                  Archivo:= Archivo + textoAlineado_OPOS('IVA COBRADO $'+Forza_Izq(FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPUESTO').AsFloat]), 12) +
                                     Forza_Izq('SUBTOTAL $'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('INGRESO').AsFloat]), 20) ,'i');
                 Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('TOTAL: $'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 20),'i' );
                 _IvaCobrado:= _IvaCobrado+  QueryL.fieldByName('IMPUESTO').AsFloat;
                 _SubTotal  := _SubTotal  +  QueryL.fieldByName('INGRESO').AsFloat;
                 _Total     := _Total     +  QueryL.fieldByName('MONTO').AsFloat;
                 QueryL.Next;
              end; // 2.- DESGLOCE    -while
           end; // 1.- IF WHILE
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('-----------------------------------', 40),'i');
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('IVA COBRADO FORMAS PAGO $'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[_IvaCobrado]), 40),'i');
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('SUB TOTAL FORMAS PAGO $'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[_SubTotal]), 40),'i');
           Archivo:= Archivo + textoAlineado_OPOS(Forza_Izq('TOTAL FORMAS DE PAGO $'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[_Total]), 40),'i');
           Archivo:= Archivo + saltosDeLinea_OPOS(1)
end;

Function TotalBoletosCorteFinTurno(var Archivo : TextFile): Boolean;
VAR sp : TSQLStoredProc;
begin
  // vendidos - cancelados
  sp   := TSQLStoredProc.Create(nil);
  sp.SQLConnection   := dm.Conecta;
  try
     sp.SQLConnection := DM.Conecta;
     sp.close;
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
end;

procedure TotalBoletosCorteFinTurnoOPOS(var Archivo: String);
VAR sp : TSQLStoredProc;
begin
   // vendidos - cancelados
  sp   := TSQLStoredProc.Create(nil);
  sp.SQLConnection   := dm.Conecta;
  try
     sp.SQLConnection := DM.Conecta;
     sp.close;
     sp.StoredProcName:= 'PDV_TOTAL_BOLETOS_CORTE';
     sp.params.ParamByName('_EMPLEADO').AsString  :=  idPromotor;
     sp.params.ParamByName('FI').AsDateTime:= FechaIniciaCorte;
     sp.params.ParamByName('FF').asDateTime:= FechaTerminaCorte;
     sp.params.ParamByName('_TERMINAL').AsString:=  gs_terminal;
     sp.Open;
     Archivo:= Archivo + TextoAlineado_OPOS('Total de Boletos: ' + IntToStr(sp.FieldByName('TOTAL').AsInteger), 'c');
  finally
     sp.Free;
  end;
end;


{Funcion que realiza la escritura del detalle de las entregas del promotor
y realiza una comparativa con lo que el sistema tiene registrado durante
su venta.}
function DetalleEntregaCorteFinTurno(var Archivo: TextFile; sag1,sag2: TStringGrid): Boolean;
var renglon : integer;
begin
       WriteLn(Archivo,'FORMAS DE PAGO');
       WriteLn(Archivo,FORZA_DER('CONCEPTO', 20) +
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
       WriteLn(Archivo,'DESCUENTOS ');
     //  WriteLn(Archivo,FORZA_DER(sag2.Cells[0,0], 20) +
     //                  FORZA_DER(sag2.Cells[1,0], 15) +
     //                  FORZA_DER(sag2.Cells[2,0], 15) +
     //                  FORZA_DER(sag2.Cells[3,0], 15) +
     //                  FORZA_DER(sag2.Cells[4,0], 15) );
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
       sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
             '  FROM PDV_CORTE_D '+
             ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
             ' AND TIPO='+QUOTEDSTR(_TIPO_EFECTIVO);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          WriteLn(Archivo,'EFECTIVO');
       //   WriteLn(Archivo,FORZA_DER('', 20) +
       //                FORZA_DER('ENTREGA', 15) +
       //                FORZA_DER('MERCURIO', 15) +
       //                FORZA_DER('SOBRANTE', 15) +
       //                FORZA_DER('FALTANTE', 15) );
          WriteLn(Archivo,FORZA_DER('EFECTIVO', 20) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 15));
          sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
             '  FROM PDV_CORTE_D '+
             ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+ QuotedStr(gs_terminal) +
             ' AND TIPO='+QUOTEDSTR(_TIPO_FONDO_INICIAL);
          If EjecutaSQL(sql,QueryL,_LOCAL) then
          begin
         //    WriteLn(Archivo,FORZA_DER('FONDO FIJO', 20) +
         //                 Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
         //                 Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
         //                 Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 15) +
         //                 Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 15));
          end;

       end;
       sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
             '  FROM PDV_CORTE_D '+
             ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
             ' AND TIPO='+QUOTEDSTR(_TIPO_IMPORTE_IXES);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          WriteLn(Archivo,'IMPORTE IXE');
        //  WriteLn(Archivo,FORZA_DER('', 20) +
        //               FORZA_DER('ENTREGA', 15) +
        //               FORZA_DER('MERCURIO', 15) +
        //               FORZA_DER('SOBRANTE', 15) +
        //               FORZA_DER('FALTANTE', 15) );
          WriteLn(Archivo,FORZA_DER('IMPORTE DE IXES', 20) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 15));
       end;

       sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
             '  FROM PDV_CORTE_D '+
             ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
             ' AND TIPO='+QUOTEDSTR(_TIPO_IMPORTE_BANAMEX);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          WriteLn(Archivo,'IMPORTE BANAMEX ');
      //    WriteLn(Archivo,FORZA_DER('', 20) +
      //                 FORZA_DER('ENTREGA', 15) +
      //                 FORZA_DER('MERCURIO', 15) +
      //                 FORZA_DER('SOBRANTE', 15) +
      //                 FORZA_DER('FALTANTE', 15) );
          WriteLn(Archivo,FORZA_DER('IMPORTE BANAMEX', 20) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 15));
       end;
       SQL:='SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE '+
            '  FROM PDV_CORTE_D '+
            ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
            ' AND TIPO='+QUOTEDSTR(_TIPO_RECOLECCIONES);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          WriteLn(Archivo,'RECOLECCIONES');
      //    WriteLn(Archivo,FORZA_DER('', 20) +
      //                 FORZA_DER('ENTREGA', 15) +
      //                 FORZA_DER('MERCURIO', 15) +
      //                 FORZA_DER('SOBRANTE', 15) +
      //                 FORZA_DER('FALTANTE', 15) );
          WriteLn(Archivo,FORZA_DER('EFECTIVO', 20) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                          fORZA_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]),15) +
                          fORZA_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]),15));
       end;
       SQL:='SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  '+
            '  FROM PDV_CORTE_D '+
            ' WHERE ID_CORTE='+ Corte+ ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
            ' AND TIPO='+QUOTEDSTR(_TIPO_CANCELADOS);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          WriteLn(Archivo,'CANCELADOS ');
    //      WriteLn(Archivo,FORZA_DER('', 20) +
    //                   FORZA_DER('ENTREGA', 15) +
    //                   FORZA_DER('MERCURIO', 15) +
    //                   FORZA_DER('SOBRANTE', 15) +
    //                   FORZA_DER('FALTANTE', 15) );
          WriteLn(Archivo,FORZA_DER('BOLETOS', 20) +
                          Forza_DER(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 15) +
                          Forza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 15) +
                          FORza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]),15) +
                          forza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]),15));
       end;
end;


procedure DetalleEntregaCorteFinTurnoOPOS(var Archivo: String;  sag1,sag2: TStringGrid);
var renglon : integer;
begin
       Archivo:= Archivo + TextoAlineado_OPOS('FORMAS DE PAGO ', 'c');
//       saltosDeLinea_OPOS(1);
       Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER(sag1.Cells[0,0], 5) +
                       FORZA_DER(sag1.Cells[1,0], 10) +
                       FORZA_DER(sag1.Cells[2,0], 10) +
                       FORZA_DER('SOB', 8) +
                       FORZA_DER('FAL', 8), 'i' );
       if sag1.RowCount=1 then
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('SIN FORMAS DE PAGO', 20) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 10) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 10) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 8) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 8), 'i' );
       for renglon:=1 to sag1.RowCount -1 do
       Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER(sag1.Cells[0,renglon], 10) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[1,renglon])]), 7) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[2,renglon])]), 7) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[3,renglon])]), 7) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag1.Cells[4,renglon])]), 7) ,'i' );
//       saltosDeLinea_OPOS(1);
       Archivo:= Archivo + TextoAlineado_OPOS('D E S C U E N T O S ', 'c');
//       saltosDeLinea_OPOS(1);
       Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('DESC', 5) +
                       FORZA_DER(sag2.Cells[1,0], 10) +
                       FORZA_DER(sag2.Cells[2,0], 10) +
                       FORZA_DER('SOB', 8) +
                       FORZA_DER('FAL', 8),'i' );
       if sag2.RowCount=1 then
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('SIN DESCUENTOS', 20) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 10) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 10) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 8) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat('0')]), 8) ,'i');
       for renglon:=1 to sag2.RowCount -1 do
       Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER(sag2.Cells[0,renglon], 10) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[1,renglon])]), 7) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[2,renglon])]), 7) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[3,renglon])]), 7) +
                       FORZA_DER(Format(_FORMATO_CANTIDADES_CORTES,[StrToFloat(sag2.Cells[4,renglon])]), 7), 'i' );

//       saltosDeLinea_OPOS(1);
       sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
             '  FROM PDV_CORTE_D '+
             ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
             ' AND TIPO='+QUOTEDSTR(_TIPO_EFECTIVO);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          Archivo:= Archivo + TextoAlineado_OPOS('E F E C T I V O  ','c');
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('', 5) +
                       FORZA_DER('ENTREGA', 9) +
                       FORZA_DER('MERCURIO', 9) +
                       FORZA_DER('SOBRANTE', 9) +
                       FORZA_DER('FALTANTE', 9),'i' );
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('', 1) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 10),'i');
//          saltosDeLinea_OPOS(1);
       end;
       sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
             '  FROM PDV_CORTE_D '+
             ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
             ' AND TIPO='+QUOTEDSTR(_TIPO_IMPORTE_IXES);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          Archivo:= Archivo + TextoAlineado_OPOS('I M P O R T E    I X E ','c');
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('', 5) +
                       FORZA_DER('ENTREGA', 9) +
                       FORZA_DER('MERCURIO', 9) +
                       FORZA_DER('SOBRANTE', 9) +
                       FORZA_DER('FALTANTE', 9),'i' );
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('',1 ) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 10),'i');
//          saltosDeLinea_OPOS(1);
       end;

       sql:= 'SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  ' +
             '  FROM PDV_CORTE_D '+
             ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
             ' AND TIPO='+QUOTEDSTR(_TIPO_IMPORTE_BANAMEX);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          Archivo:= Archivo + TextoAlineado_OPOS('I M P O R T E  B A N A M E X ','c');
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('', 5) +
                       FORZA_DER('ENTREGA', 9) +
                       FORZA_DER('MERCURIO', 9) +
                       FORZA_DER('SOBRANTE', 9) +
                       FORZA_DER('FALTANTE', 9),'i' );
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('',1 ) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]), 10),'i');
       end;


       SQL:='SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE '+
            '  FROM PDV_CORTE_D '+
            ' WHERE ID_CORTE='+ corte + ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
            ' AND TIPO='+QUOTEDSTR(_TIPO_RECOLECCIONES);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          Archivo:= Archivo + TextoAlineado_OPOS('R E C  O L E C C I O N E S','c');
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('', 1) +
                       FORZA_DER('ENTREGA', 9) +
                       FORZA_DER('MERCURIO', 9) +
                       FORZA_DER('SOBRANTE', 9) +
                       FORZA_DER('FALTANTE', 9),'i' );
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('',1) +
                          Forza_DER('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 10) +
                          Forza_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 10) +
                          fORZA_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]),10) +
                          fORZA_der('$'+Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]),10),'i');
       end;
       SQL:='SELECT ENTREGA, SISTEMA,  IF(ENTREGA>SISTEMA,ENTREGA-SISTEMA,0) AS SOBRANTE, '+
             ' IF(ENTREGA<SISTEMA,ENTREGA-SISTEMA,0) AS FALTANTE  '+
            '  FROM PDV_CORTE_D '+
            ' WHERE ID_CORTE='+ Corte+ ' AND ID_TERMINAL='+
             QuotedStr(gs_terminal) +
            ' AND TIPO='+QUOTEDSTR(_TIPO_CANCELADOS);
       If EjecutaSQL(sql,QueryL,_LOCAL) then
       begin
          Archivo:= Archivo + TextoAlineado_OPOS('C A N C E L A D O S ','c');
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('', 5) +
                       FORZA_DER('ENTREGA', 9) +
                       FORZA_DER('MERCURIO', 9) +
                       FORZA_DER('SOBRANTE', 9) +
                       FORZA_DER('FALTANTE', 9),'i' );
          Archivo:= Archivo + TextoAlineado_OPOS(FORZA_DER('', 1) +
                          Forza_DER(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('ENTREGA').asFloat]), 7) +
                          Forza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SISTEMA').asFloat]), 7) +
                          FORza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('SOBRANTE').asFloat]),7) +
                          forza_der(Format(_FORMATO_CANTIDADES_CORTES, [QueryL.fieldByName('FALTANTE').asFloat]),7),'i');
       end;
end;// FIN DE LA IMPRESION OPOS



{Procedimiento que establece a nulo o ceros los valores utilizados en esta unidad}
Procedure FinalizaDatos;
begin
   QueryL.Destroy;
   QueryServicios.Destroy;
   QueryDesglose.Destroy;
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
   cargaRazonSocial(gs_terminal);
   WriteLn(Archivo,RazonSocial);
   WriteLn(Archivo,'TOTAL DE CORTES DE CAJA DEL DIA: '+ FormatDateTime('dd/mm/yyyy',fecha));
   WriteLn(Archivo,'FECHA DEL CORTE: '+ FormatDateTime('dd/mm/yyyy HH:NN',NOW() ));
   WriteLn(Archivo,'REPORTE EMITIDO EN '+ Terminal);
   WriteLn(Archivo,'CORTE DE FIN DE DIA');
   WriteLn(Archivo,'');
   //CreaQuery;
end;

Procedure EncabezadoCorteFinDiaOPOS(var Archivo: String; fecha: TDateTime; Terminal: String);
begin
   {Esta funcion coloca el encabezado al Archivo de Corte de fin de Dia.}
   cargaRazonSocial(gs_terminal);
   Archivo := Archivo + textoAlineado_OPOS(RazonSocial, 'c');
   Archivo := Archivo + textoAlineado_OPOS('TOTAL DE CORTES DE CAJA DEL DIA: '+ FormatDateTime('dd/mm/yyyy',fecha),'c');
   Archivo := Archivo + textoAlineado_OPOS('FECHA DEL CORTE: '+ FormatDateTime('dd/mm/yyyy HH:NN',NOW() ), 'c');
   Archivo := Archivo + textoAlineado_OPOS('REPORTE EMITIDO EN '+ Terminal, 'c');
   Archivo := Archivo + textoAlineado_OPOS('CORTE DE FIN DE DIA','c');
   Archivo := Archivo + saltosDeLinea_OPOS(1);
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
  QueryServicios := TSQLQuery.Create(nil);
  QueryServicios.SQLConnection:= dm.Conecta;
  QueryDesglose := TSQLQuery.Create(nil);
  QueryDesglose.SQLConnection:= dm.Conecta;
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
   //ShowMEssage(Sql);
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

procedure DetalleDocumentosCorteFinDiaOPOS(var Archivo: String; terminal : String; fecha: TDateTime);
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
      exit;
   end;
   queryL.First;
   Archivo := Archivo + textoAlineado_OPOS('OCUPANTES','c');
   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('ENTREGA', 8)+
                    Forza_Izq('SISTEMA', 8) +
                    Forza_Izq('OCUPANTE', 10)+
                    Forza_DER('SOBRANTE', 9)+
                    Forza_DER('FALTANTE', 9),'i');

   totalEntrega:=0;
   totalSistema:=0;
   TotalSobrante:=0;
   TotalFaltante:=0;
   WHILe NOT QueryL.Eof do
   begin
       Archivo := Archivo + textoAlineado_OPOS(Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('ENTREGA').asInteger]), 8)+
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SISTEMA').asInteger]), 8)+
                       Forza_Izq(QueryL.FieldByName('DESCRIPCION').AsString, 10)+
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SOBRANTE').asInteger]), 9)+
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('FALTANTE').asInteger]), 9) ,'i');
       totalEntrega := totalEntrega + QueryL.FieldByName('ENTREGA').asInteger;
       totalSistema := totalSistema + QueryL.FieldByName('SISTEMA').asInteger;
       totalSobrante:= totalSobrante+ QueryL.FieldByName('SOBRANTE').asInteger;
       totalFaltante:= totalFaltante+ QueryL.FieldByName('FALTANTE').asInteger;
       QueryL.Next;
   end; // end del while
   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('--------', 8)+
                       Forza_Izq('--------', 8) +
                       Forza_Izq(' ', 10)        +
                       Forza_Der('--------', 9) +
                       Forza_Der('--------', 9), 'i');

   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalEntrega]), 8) +
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalSistema]), 8)+
                       Forza_Izq('', 10) +
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalSobrante]), 9) +
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalFaltante]), 9),'i');


   Archivo := Archivo + textoAlineado_OPOS('FORMAS DE PAGO','c');
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
      exit;
   end;
   queryL.First;
   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('ENTREGA', 8) +
                    Forza_Izq('SISTEMA', 8) +
                    Forza_Izq('FORMA', 10) +
                    Forza_DER('SOBRANTE', 9) +
                    Forza_DER('FALTANTE', 9),'i');

   totalEntrega:=0;
   totalSistema:=0;
   TotalSobrante:=0;
   TotalFaltante:=0;
   WHILe NOT QueryL.Eof do
   begin
       Archivo := Archivo + textoAlineado_OPOS(Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('ENTREGA').asInteger]), 8) +
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SISTEMA').asInteger]), 8) +
                       Forza_Izq(QueryL.FieldByName('DESCRIPCION').AsString, 10) +
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('SOBRANTE').asInteger]), 9) +
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[QueryL.FieldByName('FALTANTE').asInteger]), 9),'i');
       totalEntrega := totalEntrega + QueryL.FieldByName('ENTREGA').asInteger;
       totalSistema := totalSistema + QueryL.FieldByName('SISTEMA').asInteger;
       totalSobrante:= totalSobrante+ QueryL.FieldByName('SOBRANTE').asInteger;
       totalFaltante:= totalFaltante+ QueryL.FieldByName('FALTANTE').asInteger;
       QueryL.Next;
   end; // end del while
   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('--------', 8) +
                       Forza_Izq('--------', 8) +
                       Forza_Izq(' ', 10) +
                       Forza_Der('--------',9 ) +
                       Forza_Der('--------', 9),'i');

   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalEntrega]), 8) +
                       Forza_Izq(Format(_FORMATO_BOLETOS_CORTES,[TotalSistema]), 8) +
                       Forza_Izq('', 10) +
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalSobrante]), 9)+
                       Forza_Der(Format(_FORMATO_BOLETOS_CORTES,[TotalFaltante]), 9),'i');

end;









function DetalleCortesFinDeDia(Var Archivo: TextFile; terminal : String; Fecha: TDateTime): Boolean;

var
   granTotal, granTotalEntrega, granTotalSistema: Double;
   totalCuantos, totalIngresos, totalIvaCobrado, totalExentos: Double;
   totalSistema: Double ;
   Aux1, Aux2: Double;
   i: Integer;
   QuerySP:    TSQLStoredProc;
begin

   creaQuerysDetalles;
   granTotalSistema:= 0;
   granTotal:=0;
   totalIngresos:= 0;
   totalIvaCobrado:=0;
   {
   Obtengo TODOS los empleados asignados en esa terminal y esa fecha dada desde la hora 00:00:00 hasta las
   23:59:59
   }
   SQL:='SELECT    C.ID_CORTE AS FOLIO, C.ID_TAQUILLA,  C.ID_EMPLEADO, USU.NOMBRE AS EMPLEADO, C.FECHA_INICIO, C.FECHA_FIN '+
        ' FROM PDV_T_CORTE AS C JOIN PDV_C_USUARIO AS USU ON (USU.TRAB_ID= C.ID_EMPLEADO) '+
        ' WHERE  C.ID_TERMINAL='+ QuotedStr(Terminal) +
        ' AND  C.FECHA_INICIO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha))+
        ' ORDER BY 1 ';
   //SHOWMESSAGE(SQL);
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

   WriteLn(Archivo,'DETALLE DE CORTES ');
   QueryL.First;

   QuerySP   := TSQLStoredProc.Create(NIL);
   QuerySP.SQLConnection   := dm.Conecta;
   fecha := VarToDateTime( FormatDateTime('yyyy/mm/dd',fecha) );
  try
    QuerySP.SQLConnection := DM.Conecta;
    QuerySP.close;
    QuerySP.StoredProcName:= 'PDV_REPORTE_INGRESO_TIPOSERVICIO';
    QuerySP.params.ParamByName('_FECHA').AsDateTime  := fecha;
    QuerySP.params.ParamByName('_ID_TERMINAL').AsString  := terminal;
    QuerySP.Params.ParamByName('_ID_USUARIO').AsString := 'KLSJDFSKJ';
    QuerySP.Open;
    QuerySP.Close;
    /////
    ///
    QuerySP.SQLConnection := DM.Conecta;
    querySP.close;
    QuerySP.StoredProcName:= 'PDV_CORTE_DIA';
    QuerySP.params.ParamByName('_FECHA').AsDateTime  := fecha;
    QuerySP.params.ParamByName('_TERMINAL').AsString  := terminal;
    QuerySP.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 1646');
        QuerySP.Free;
     end;
   end;
  WriteLn(Archivo,Forza_Izq('TIPO  OCUPANTE',15) +
                  Forza_Izq('FORMA PAGO',15)    +
                  Forza_Izq('IVA COBRADO',15)      +
                  Forza_Izq('SUB TOTAL',15)        +
                  Forza_Izq('TOTAL',15)    +
                  Forza_Izq('% DE IVA',10) );
QuerySP.First;
  while not QuerySP.Eof do
  begin


    begin
       WriteLn(Archivo,''+  Forza_Izq(QuerySP.FieldByName('OCUPANTE').AsString,15) +
                            Forza_Izq(QuerySP.FieldByName('PAGO').AsString,15)     +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('IVA_COBRADO').AsFloat]) , 15) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('SUB_TOTAL').AsFloat])   , 15) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('TOTAL').AsFloat])   , 15) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('IVA').AsFloat])   , 10)      );

       GranTotal      := GranTotal + QuerySP.FieldByName('TOTAL').AsFloat;

       if QuerySP.FieldByName('IVA').AsInteger = 0 then
       begin
         totalExentos:= totalExentos +  QuerySP.FieldByName('SUB_TOTAL').AsFloat;
       end
       else
       begin
          totalIngresos  := totalIngresos   + QuerySP.FieldByName('SUB_TOTAL').AsFloat;
          totalIvaCobrado:= totalIvaCobrado + QuerySP.FieldByName('IVA_COBRADO').AsFloat;
       end;


       QuerySP.Next;

    end;

  end;
  WriteLn(Archivo, '');
  WriteLn(Archivo,''+  Forza_Izq('',15) +
                            Forza_Izq('',5)     +
                            Forza_Der('' , 5) +
                            Forza_Der(''  , 5) +
                            Forza_Der('Ingresos Exentos:' , 50) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalExentos])   , 10)      );
  WriteLn(Archivo, '');
  WriteLn(Archivo,''+  Forza_Izq('',15) +
                            Forza_Izq('',5)     +
                            Forza_Der('' , 5) +
                            Forza_Der(''  , 5) +
                            Forza_Der('Ingresos Gravados:' , 50) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIngresos])   , 10)      );
  WriteLn(Archivo,''+  Forza_Izq('',15) +
                            Forza_Izq('',5)     +
                            Forza_Der('' , 5) +
                            Forza_Der(''  , 5) +
                            Forza_Der('Iva Cobrado:' , 50) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIvaCobrado])   , 10)      );

   destruyeQuerysDetalle;
   SumaFinalDelDia(Archivo, terminal, fecha);


end;

Procedure DetalleCortesFinDeDiaOPOS(var Archivo: String; terminal: String; fecha: TDateTime);
var
   granTotalEntrega, granTotalSistema, granTotal, totalIngresos, totalIvaCobrado: Double;
   totalCuantos, totalExentos: Double;
   totalSistema: Double ;
   Aux1, Aux2: Double;
   QuerySP:  TSQLStoredProc;
   i: Integer;
begin
  {
   Obtengo TODOS los empleados asignados en esa terminal y esa fecha dada desde la hora 00:00:00 hasta las
   23:59:59
   }
   creaQuerysDetalles;
   granTotalSistema:= 0;
   granTotal:=0;
   totalIngresos:= 0;
   totalIvaCobrado:=0;
   {
   Obtengo TODOS los empleados asignados en esa terminal y esa fecha dada desde la hora 00:00:00 hasta las
   23:59:59
   }
   SQL:='SELECT    C.ID_CORTE AS FOLIO, C.ID_TAQUILLA,  C.ID_EMPLEADO, USU.NOMBRE AS EMPLEADO, C.FECHA_INICIO, C.FECHA_FIN '+
        ' FROM PDV_T_CORTE AS C JOIN PDV_C_USUARIO AS USU ON (USU.TRAB_ID= C.ID_EMPLEADO) '+
        ' WHERE  C.ID_TERMINAL='+ QuotedStr(Terminal) +
        ' AND  C.FECHA_INICIO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha))+
        ' ORDER BY 1 ';
   //SHOWMESSAGE(SQL);
   if EjecutaSQL(sql,QueryL,_LOCAL) then
   BEGIN
   Archivo := Archivo + textoAlineado_OPOS('CORTES ','c');
   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('FOLIO', 9) +
            //       Forza_Izq('TAQ', 5) +
                   Forza_Izq('CLAVE', 10) +
                   Forza_Izq('EMPLEADO', 20),'i');
   Archivo := Archivo + textoAlineado_OPOS('','c');
   QueryL.First;
   totalSistema:=0;
   END;
   WHILE NOT QueryL.Eof do
   begin
       Archivo := Archivo + textoAlineado_OPOS(Forza_Izq(QueryL.FieldByName('FOLIO').AsString, 9) +
                   //    Forza_Izq(QueryL.FieldByName('ID_TAQUILLA').AsString, 5)                        +
                       Forza_Izq(uppercase(QueryL.FieldByName('ID_EMPLEADO').AsString), 10)             +
                       Forza_Der(QueryL.FieldByName('EMPLEADO').AsString, 20),'i');
       QueryL.Next;
   end; // end del while
   // termina segunda seccion
   { VOY A OBTENER EL DETALLE PARA TODOS Y CADA UNO DE LOS EMPLEADOS QUE FUERON
    ASIGNADOS EN EL DIA DADO.
    PRIMERO TOMO EL FOLIO DEL CORTE CON SUS RESPECTIVAS FECHAS DE ASIGNACION
    Y FECHA EN QUE SE PROCESO SU CORTE, ASI COMO LA TAQUILLA
    }
   // saco todas las formas de pago  existentes

   Archivo := Archivo + textoAlineado_OPOS('DETALLE DE CORTES ','c');
   QueryL.First;

   QuerySP   := TSQLStoredProc.Create(NIL);
   QuerySP.SQLConnection   := dm.Conecta;
   fecha := VarToDateTime( FormatDateTime('yyyy/mm/dd',fecha) );
  try
    QuerySP.SQLConnection := DM.Conecta;
    QuerySP.close;
    QuerySP.StoredProcName:= 'PDV_REPORTE_INGRESO_TIPOSERVICIO';
    QuerySP.params.ParamByName('_FECHA').AsDateTime  := fecha;
    QuerySP.params.ParamByName('_ID_TERMINAL').AsString  := terminal;
    QuerySP.Params.ParamByName('_ID_USUARIO').AsString := 'KLSJDFSKJ';
    QuerySP.Open;
    QuerySP.Close;
    /////
    ///
    QuerySP.SQLConnection := DM.Conecta;
    QuerySP.close;
    QuerySP.StoredProcName:= 'PDV_CORTE_DIA';
    QuerySP.params.ParamByName('_FECHA').AsDateTime  := fecha;
    QuerySP.params.ParamByName('_TERMINAL').AsString  := terminal;
    QuerySP.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 1646');
        QuerySP.Free;
     end;
   end;
  Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('OCUPANTE',10) +
                  Forza_Izq('PAGO',5)    +
                  Forza_Izq('IVA ',10)      +
                  Forza_Izq('SUB TOTAL',10) ,'d' );
QuerySP.First;
  while not QuerySP.Eof do
  begin


    begin
       Archivo := Archivo + textoAlineado_OPOS(Forza_Izq(QuerySP.FieldByName('OCUPANTE').AsString,10) +
                            Forza_Izq(QuerySP.FieldByName('PAGO').AsString,5)     +
                            Forza_Izq(Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('IVA_COBRADO').AsFloat]) , 10) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('SUB_TOTAL').AsFloat])   , 10) , 'd');
       Archivo := Archivo + textoAlineado_OPOS('TOTAL $' +Forza_iZQ(Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('TOTAL').AsFloat])   , 15) +
                            Forza_Der('% DE IVA ' +Format(_FORMATO_CANTIDADES_CORTES,[QuerySP.FieldByName('IVA').AsFloat])   ,10) ,'d'     );

       GranTotal      := GranTotal + QuerySP.FieldByName('TOTAL').AsFloat;

       if QuerySP.FieldByName('IVA').AsInteger = 0 then
       begin
         totalExentos:= totalExentos +  QuerySP.FieldByName('SUB_TOTAL').AsFloat;
       end
       else
       begin
          totalIngresos  := totalIngresos   + QuerySP.FieldByName('SUB_TOTAL').AsFloat;
          totalIvaCobrado:= totalIvaCobrado + QuerySP.FieldByName('IVA_COBRADO').AsFloat;
       end;


       QuerySP.Next;

    end;

  end;
  Archivo := Archivo + saltosDeLinea_OPOS(2);
 Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('',5) +
                            Forza_Der('Ingresos Exentos: $' , 20) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalExentos])   , 10)    ,'d'  );
  Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('',5) +
                            Forza_Der('Ingresos Gravados: $' , 20) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIngresos])   , 10) , 'd'     );
  Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('',5) +
                            Forza_Der('Iva Cobrado: $' , 20) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIvaCobrado])   , 10)  ,'d'   );

 //  queryL.CleanupInstance;
//   queryL.Close;
   SumaFinalDelDiaOPOS(Archivo, terminal, fecha);
   destruyeQuerysDetalle;
   Archivo := Archivo + saltosDeLinea_OPOS(5);
   Archivo := Archivo + corte_OPOS;

end;
// fin de DetalleCortesFinDeDiaI




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
    Lservicios:= TStringList.Create;
end;

procedure destruyeQuerysDetalle;
begin
    Query2.Destroy;
    QueryFormasPago.Destroy;
    QueryOcupantes.Destroy;
    QueryFechas.Destroy;
    LFechas.Destroy;
     Lservicios.Destroy;
end;
Procedure EncabezadoCorteTipoServicio(var Archivo: TextFile; fechaInicial, fechaFinal: TdateTime; Terminal : String);
begin
   cargaRazonSocial(gs_terminal);
   WriteLn(Archivo,RazonSocial);
   WriteLn(Archivo,'');
   WriteLn(Archivo,'REPORTE DE CORTES POR TIPO DE SERVICIO');
   WriteLn(Archivo,'FECHA DEL CORTE: '+ FormatDateTime('dd/mm/yyyy HH:NN',NOW() ));
   WriteLn(Archivo,'REPORTE EMITIDO EN '+ TERMINAL);
   WriteLn(Archivo,'DESDE '+ FormatDateTime('DD/MM/YYYY ',fechaInicial) +
                   ' HASTA ' + FormatDateTime('DD/MM/YYYY ',fechaFinal));
   WriteLn(Archivo,'');

end;


Procedure EncabezadoCorteTipoServicioOPOS(var Archivo: String; fechaInicial, fechaFinal: TdateTime; Terminal : String);
begin
   cargaRazonSocial(gs_terminal);
   Archivo := Archivo + textoAlineado_OPOS(RazonSocial,'c');
   Archivo := Archivo + textoAlineado_OPOS('REPORTE DE CORTES POR TIPO DE SERVICIO','c');
   Archivo := Archivo + textoAlineado_OPOS('FECHA DEL CORTE: '+ FormatDateTime('dd/mm/yyyy HH:NN',NOW() ), 'c');
   Archivo := Archivo + textoAlineado_OPOS('REPORTE EMITIDO EN '+ TERMINAL, 'c');
   Archivo := Archivo + textoAlineado_OPOS('DESDE '+ FormatDateTime('DD/MM/YYYY ',fechaInicial), 'c');
   Archivo := Archivo + textoAlineado_OPOS('HASTA ' + FormatDateTime('DD/MM/YYYY ',fechaFinal), 'c');
   Archivo := Archivo + textoAlineado_OPOS('','c');

end;

procedure DetalleCortesTipoServicio(var Archivo: textFile; terminal: String; fechaI, fechaF: TDateTime);
var
   GranTotal: Double;
   granTotalEfectivo: double;
   granTotalIxe: double;
   totalExento, totalIvaCobrado, totalIngresoG: double;
   granTotalBanamex: Double;
   totalPromotorEfectivo, totalPromotorIxe, totalPromotorBanamex: Double;
   i, corteAnterior: Integer;
   QueryL, QueryQ:    TSQLStoredProc;
//   spD:   TSQLStoredProc;
BEGIN
// Obtengo TODOS los empleados asignados en esa terminal y esas fechas dadas desde la fecha inicial 00:00:00 hasta
// fecha final 23:59:59
   creaQuerysDetalles;
   QueryL   := TSQLStoredProc.Create(NIL);
   QueryL.SQLConnection   := dm.Conecta;
   fechaI := VarToDateTime( FormatDateTime('yyyy/mm/dd',fechaI) );
  try
    QueryL.SQLConnection := DM.Conecta;
    QueryL.Close;
    QueryL.StoredProcName:= 'PDV_CORTE_SERVICIO';
    QueryL.params.ParamByName('_FECHA').AsDateTime  := fechaI;
    QueryL.params.ParamByName('_TERMINAL').AsString  := terminal;
//    showMessage(vartoStr(fechaI));
    QueryL.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 2655');
        QueryL.Free;
     end;
   end;

  QueryL.First;
  totalExento:=0;
  totalIngresoG:=0;
  totalIvaCobrado:= 0 ;
  while not QueryL.Eof do
  begin
    corteAnterior:= QueryL.FieldByName('id_corte').AsInteger;
    WriteLn(Archivo,Forza_Izq('' ,30));
    WriteLn(Archivo,Forza_Izq('NUMERO DE CORTE: ' + QueryL.FieldByName('id_corte').AsString,30));
    WriteLn(Archivo,Forza_Izq('TIPO SERVICIO',15) +
                  Forza_Izq('IVA COBRADO',15)      +
                  Forza_Izq('SUB TOTAL',15)        +
                  Forza_Izq('FORMA DE PAGO',15)    +
                  Forza_Izq('% DE IVA',10) );
    while corteAnterior  =  QueryL.FieldByName('id_corte').AsInteger do
    begin
       WriteLn(Archivo,''+  Forza_Izq(QueryL.FieldByName('SERVICIO').AsString,15) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('IVA_COBRADO').AsFloat]) , 15) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('SUB_TOTAL').AsFloat])   , 15) +
                            Forza_Izq(QueryL.FieldByName('PAGO').AsString,15)                              +
                            Forza_Izq(QueryL.FieldByName('IVA').AsString, 10)  );
       QueryL.Next;

    end;

  end;
   queryL.CleanupInstance;
   queryL.Close;
  // IMPRIMIRE EL GLOBAL DE TIPO DE SERVICIO
   try
    QueryL.StoredProcName:= 'PDV_CORTE_GLOBAL_SERVICIO';
    QueryL.params.ParamByName('_FECHA').AsDateTime  := fechaI;
    QueryL.params.ParamByName('_TERMINAL').AsString  :=  terminal;


//    showMessage(vartoStr(fechaI));
    QueryL.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 2655');
        QueryL.Free;
     end;
   end;
  QueryL.First;
  WriteLn(Archivo,'RESUMEN GLOBAL POR TIPO DE SERVICIO' );
   WriteLn(Archivo,Forza_Izq('TIPO SERVICIO',15) +
                  Forza_Izq('FORMA PAGO',10)    +
                  Forza_Der('IVA COBRADO',15)      +
                  Forza_Der('SUB TOTAL',15)        +
                  Forza_Der('TOTAL',15)    +
                  Forza_Der('% DE IVA',10) );
  while not QueryL.Eof do
  begin
    WriteLn(Archivo,Forza_Izq('' ,30));
    WriteLn(Archivo,''+  Forza_Izq(QueryL.FieldByName('SERVICIO').AsString,15) +
                         Forza_Izq(QueryL.FieldByName('PAGO').AsString,10)                              +
                         Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('IVA_COBRADO').AsFloat]) , 15) +
                         Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('SUB_TOTAL').AsFloat])   , 15) +
                         Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('TOTAL').AsFloat])   , 15) +
                         Forza_Der(QueryL.FieldByName('IVA').AsString, 10)  );
    GranTotal:= GranTotal + QueryL.FieldByName('TOTAL').AsFloat;
    if QueryL.FieldByName('IVA').AsInteger = 0 then
    begin
       totalExento := totalExento + QueryL.FieldByName('SUB_TOTAL').AsFloat;
    end
    else
    begin
        totalIvaCobrado := totalIvaCobrado + QueryL.FieldByName('IVA_COBRADO').AsFloat;
        totalIngresoG   := totalIngresoG   + QueryL.FieldByName('SUB_TOTAL').AsFloat;
    end;
    QueryL.Next;

  end;
    WriteLn(Archivo, '');
  WriteLn(Archivo,''+  Forza_Izq('',15) +
                            Forza_Izq('',5)     +
                            Forza_Der('' , 5) +
                            Forza_Der(''  , 5) +
                            Forza_Der('Ingresos Exentos:' , 50) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalExento])   , 10)      );
  WriteLn(Archivo, '');
  WriteLn(Archivo,''+  Forza_Izq('',15) +
                            Forza_Izq('',5)     +
                            Forza_Der('' , 5) +
                            Forza_Der(''  , 5) +
                            Forza_Der('Ingresos Gravados:' , 50) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIngresoG])   , 10)      );
  WriteLn(Archivo,''+  Forza_Izq('',15) +
                            Forza_Izq('',5)     +
                            Forza_Der('' , 5) +
                            Forza_Der(''  , 5) +
                            Forza_Der('Iva Cobrado:' , 50) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIvaCobrado])   , 10)      );

   WriteLn(Archivo,Forza_Izq('' ,30));
   QueryL.Close;
   try
    QueryL.StoredProcName:= 'PDV_REPORTE_INGRESO_TIPOSERVICIO';   // PDV_REPORTE_INGRESO_TIPOSERVICIO
    QueryL.params.ParamByName('_FECHA').AsDateTime  := fechaI;
    QueryL.params.ParamByName('_ID_TERMINAL').AsString  :=  terminal;
    QueryL.params.ParamByName('_ID_USUARIO').AsString  :=  '3-018jkdf';
    QueryL.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 2691');
        QueryL.Free;
     end;
   end;
   WriteLn(Archivo,''+  Forza_Izq('SERVICIO',20) +
                         Forza_Izq('FORMA PAGO',10)                              +
                         Forza_Der('TOTAL EXENTO', 15) +
                         Forza_Der('SUBTOTAL_GRABADO'   , 20) +
                         Forza_Der('IVA'   , 10) );
  while not QueryL.Eof do
  begin
    WriteLn(Archivo,Forza_Izq('' ,30));
    WriteLn(Archivo,''+  Forza_Izq(QueryL.fields[0].AsString  , 20) + // FieldByName('SERVICIO').AsString,20) +
                         Forza_Izq(QueryL.fields[1].AsString ,10)                              +
                         Forza_Der(QueryL.fields[2].AsString , 15) +
                         Forza_Der(QueryL.fields[3].AsString , 15) +
                         Forza_Der(QueryL.fields[4].AsString , 10) );
    QueryL.Next;
  end;


END;

procedure DetalleCortesTipoServicioOPOS(var Archivo: String; terminal: String; fechaI, fechaF: TDateTime);
var
   GranTotal: Double;
   granTotalEfectivo, totalExento, totalIngresoG, totalIvaCobrado: double;
   granTotalIxe: double;
   granTotalBanamex : double;
   totalPromotorEfectivo, totalPromotorIxe, totalPromotorBanamex: Double;
   i, corteAnterior: Integer;
   QueryL, QueryQ:    TSQLStoredProc;
//   spD:   TSQLStoredProc;
BEGIN
// Obtengo TODOS los empleados asignados en esa terminal y esas fechas dadas desde la fecha inicial 00:00:00 hasta
// fecha final 23:59:59
   creaQuerysDetalles;
   QueryL   := TSQLStoredProc.Create(NIL);
   QueryL.SQLConnection   := dm.Conecta;
   fechaI := VarToDateTime( FormatDateTime('yyyy/mm/dd',fechaI) );
  try
    QueryL.SQLConnection := DM.Conecta;
    QueryL.close;
    QueryL.StoredProcName:= 'PDV_CORTE_SERVICIO';
    QueryL.params.ParamByName('_FECHA').AsDateTime  := fechaI;
    QueryL.params.ParamByName('_TERMINAL').AsString  := terminal;
    QueryL.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 2655');
        QueryL.Free;
     end;
   end;

  QueryL.First;
  totalExento:=0;
  totalIngresoG:=0;
  totalIvaCobrado:= 0 ;
  while not QueryL.Eof do
  begin
    corteAnterior:= QueryL.FieldByName('id_corte').AsInteger;
     Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('NUMERO DE CORTE: ' + QueryL.FieldByName('id_corte').AsString,30),'c');
     Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('SERVICIO',10) +
                  Forza_Izq('IVA COBRADO',15)      +
                  Forza_Izq('SUB TOTAL',15)        +
                  Forza_Izq('PAGO',3)    +
                  Forza_Der('%IVA',5), 'd' );
    while corteAnterior  =  QueryL.FieldByName('id_corte').AsInteger do
    begin
       Archivo := Archivo + textoAlineado_OPOS(Forza_Izq(QueryL.FieldByName('SERVICIO').AsString,10) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('IVA_COBRADO').AsFloat]) , 10) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('SUB_TOTAL').AsFloat])   , 15) +
                            Forza_Izq(QueryL.FieldByName('PAGO').AsString,3)                              +
                            Forza_Der(QueryL.FieldByName('IVA').AsString, 5) ,'d' );
       QueryL.Next;

    end;

  end;
   queryL.CleanupInstance;
   queryL.Close;
  // IMPRIMIRE EL GLOBAL DE TIPO DE SERVICIO
   try
    QueryL.StoredProcName:= 'PDV_CORTE_GLOBAL_SERVICIO';
    QueryL.params.ParamByName('_FECHA').AsDateTime  := fechaI;
    QueryL.params.ParamByName('_TERMINAL').AsString  :=  terminal;
    QueryL.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 2655');
        QueryL.Free;
     end;
   end;
  QueryL.First;
  Archivo := Archivo + textoAlineado_OPOS('RESUMEN GLOBAL POR TIPO DE SERVICIO' , 'c');
  while not QueryL.Eof do
  begin
    Archivo := Archivo + textoAlineado_OPOS('SERVICIO :'+ Forza_Izq(QueryL.FieldByName('SERVICIO').AsString,15) +
                         'F.PAGO ' + QueryL.FieldByName('PAGO').AsString ,'i');
    Archivo := Archivo + textoAlineado_OPOS('IVA COBRADO $'+Forza_Izq(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('IVA_COBRADO').AsFloat]) , 10) +
                         'SUBTOTAL: $'+ Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('SUB_TOTAL').AsFloat]), 10) ,'i');
    Archivo := Archivo + textoAlineado_OPOS('TOTAL $'+Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('TOTAL').AsFloat])   , 10) +
                         ' %IVA ' +Forza_Der(QueryL.FieldByName('IVA').AsString, 5) ,'i' );
    GranTotal:= GranTotal + QueryL.FieldByName('TOTAL').AsFloat;
    if QueryL.FieldByName('IVA').AsInteger = 0 then
    begin
       totalExento := totalExento + QueryL.FieldByName('SUB_TOTAL').AsFloat;
    end
    else
    begin
        totalIvaCobrado := totalIvaCobrado + QueryL.FieldByName('IVA_COBRADO').AsFloat;
        totalIngresoG   := totalIngresoG   + QueryL.FieldByName('SUB_TOTAL').AsFloat;
    end;
    QueryL.Next;

  end;
   Archivo:= Archivo + saltosDeLinea_OPOS(1);
   Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('',5) +
                            Forza_Der('Ingresos Exentos: $' , 20) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalExento])   , 10)  , 'i'    );
  Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('',5) +
                            Forza_Der('Ingresos Gravados: $' , 20) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIngresoG])   , 10)   , 'i'  );
  Archivo := Archivo + textoAlineado_OPOS(Forza_Izq('',5) +
                            Forza_Der('Iva Cobrado: $' , 20) +
                            Forza_Der(Format(_FORMATO_CANTIDADES_CORTES,[totalIvaCobrado])   , 10)  , 'i'    );
   Archivo:= Archivo + saltosDeLinea_OPOS(1);
   QueryL.Close;
   try
    QueryL.StoredProcName:= 'PDV_REPORTE_INGRESO_TIPOSERVICIO';   // PDV_REPORTE_INGRESO_TIPOSERVICIO
    QueryL.params.ParamByName('_FECHA').AsDateTime  := fechaI;
    QueryL.params.ParamByName('_ID_TERMINAL').AsString  :=  terminal;
    QueryL.params.ParamByName('_ID_USUARIO').AsString  :=  '3-018jkdf';
    QueryL.Open;
  except
     begin
        ShowMEssage('Ocurrio en error al procesar el corte por tipo de servicio. Linea: 2691');
        QueryL.Free;
     end;
   end;
   Archivo := Archivo + textoAlineado_OPOS(Forza_Der('EXENTO', 15) +
                         Forza_Der('SUBTOTAL GRAB'   , 15) +
                         Forza_Der('% IVA'   , 5) , 'I');
  while not QueryL.Eof do
  begin
    Archivo := Archivo + textoAlineado_OPOS(Forza_Der(QueryL.fields[0].AsString ,25) + '-'+
                         Forza_Izq(QueryL.fields[1].AsString ,15)   , 'I');

    Archivo := Archivo + textoAlineado_OPOS(Forza_Der(QueryL.fields[2].AsString  , 15) +
                         Forza_Der(QueryL.fields[3].AsString   , 15) +
                         Forza_Der(QueryL.fields[4].AsString    , 10) , 'I' );
    QueryL.Next;
  end;
  Archivo:= Archivo + saltosDeLinea_OPOS(5);
  Archivo:= Archivo + corte_OPOS;
END;


procedure DesgloceFechasFinTurno(var Archivo: TextFile);
begin
     // procedimiento que asigna el Query que obtiene el desgloce de Ingreso por Fecha en un corte
   AsignaQueryDesgloceFechas;
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- DESGLOCE IF
            if  not QueryL.Eof then
            begin
                WriteLn(Archivo,Forza_Izq('FECHA', 20) +
                                Forza_DER('BOLETOS', 10) +
                                Forza_DER('% IVA', 7) +
                                Forza_DER('IVA COBRADO', 15) +
                                Forza_DER('SUB TOTAL', 15) +
                                Forza_DER('TOTAL', 15) ); //+
                                // Forza_DER('%',10));
            end;
             _IvaCobrado:= 0;
             _SubTotal  := 0;
             _Total     := 0;
            while not QueryL.Eof  do
            begin   // 2.- DESGLOCE -while
               WriteLn(Archivo,Forza_Izq(QueryL.fieldByName('FECHA_').AsString, 20) +
                               Forza_DER(QueryL.fieldByName('TOTAL').AsString, 10) +
                               Forza_DER(FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IVA').AsFloat]), 7) +
                               Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPUESTO').AsFloat]), 15) +
                               Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('INGRESO').AsFloat]), 15) +
                               Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPORTE').AsFloat]), 15)); // +
//                               Forza_DER(QueryL.fieldByName('X').AsString, 10) );
                _IvaCobrado:= _IvaCobrado+  QueryL.fieldByName('IMPUESTO').AsFloat;
                _SubTotal  := _SubTotal  +  QueryL.fieldByName('INGRESO').AsFloat;
                _Total     := _Total     +  QueryL.fieldByName('IMPORTE').AsFloat;
               QueryL.Next;
            end; // 2.- DESGLOCE    -while
            WriteLn(Archivo,Forza_Izq('', 20) +Forza_Izq('', 10) +Forza_Izq('', 7) +
            Forza_DER('--------------', 15) +
            Forza_DER('--------------', 15) +
            Forza_DER('--------------', 15)      );
           WriteLn(Archivo,Forza_Izq('', 20) +Forza_Izq('', 10) +Forza_Izq('', 7) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_IvaCobrado]), 15) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_SubTotal]), 15) +
            Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[_Total]), 15)      );
         end; // 1.- IF DESGLOCE
   AsignaQueryDesgloceTotal;
   if  EjecutaSQL(sql,QueryDesglose,_LOCAL) then
   begin
     if QueryDesglose.FieldByName('IVA').AsInteger = 0 then 
     begin
         WriteLn(Archivo,'');
         WriteLn(Archivo,Forza_Izq('INGRESO EXENTO:', 20) + Forza_dER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryDesglose.FieldByName('IMPORTE').AsFloat]), 40)  );
         QueryDesglose.Next;
     end;
     if QueryDesglose.FieldByName('IVA').AsInteger <> 0 then
     begin
         WriteLn(Archivo,Forza_Izq('INGRESO GRAVADOS:', 20)+ Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryDesglose.FieldByName('INGRESO').AsFloat]), 40) );
         WriteLn(Archivo,Forza_Izq('IVA COBRADO:', 20) + Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryDesglose.FieldByName('IMPUESTO').AsFloat]), 40) );
         WriteLn(Archivo,'');
     end;
   end;

end;

procedure DesgloceFechasFinTurnoOPOS(var Archivo: String);
begin
     // DESGLOCE DE VENTAS REALIZADAS POR FECHA
   // procedimiento que asigna el Query que obtiene el desgloce de Ingreso por Fecha en un corte
   AsignaQueryDesgloceFechas;
   If EjecutaSQL(sql,QueryL,_LOCAL) then
   begin // 1.- DESGLOCE IF

            saltosDeLinea_OPOS(1);
            if  not QueryL.Eof then
            begin

               saltosDeLinea_OPOS(1);
            end;
            while not QueryL.Eof  do
            begin   // 2.- DESGLOCE -while
               Archivo:= Archivo + TextoAlineado_OPOS(Forza_Izq(QueryL.fieldByName('FECHA_').AsString, 12) +
                               Forza_Izq('BOL '+QueryL.fieldByName('TOTAL').AsString, 10) +
                               Forza_Izq('% IVA '+QueryL.fieldByName('IVA').AsString, 10) +
                               Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('IMPORTE').AsFloat]), 10) ,'i');
               Archivo:= Archivo + TextoAlineado_OPOS(Forza_Izq('IVA COBRADO $'+QueryL.fieldByName('IMPUESTO').AsString, 20) +
                               Forza_Izq('SUB TOTAL $'+QueryL.fieldByName('INGRESO').AsString, 20) , 'i');

               QueryL.Next;
            end; // 2.- DESGLOCE    -while
   end; // 1.- desgloce
   saltosDeLinea_OPOS(1);
end;

procedure VentaNetaFinDeTurno(var Archivo: TextFile);
begin
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
        ' AND BOL.TRAB_ID=CANC.TRAB_ID AND BOL.ID_TERMINAL = ' + QuotedStr(gs_terminal) +
//        ' AND BOL.ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
// NO LO COLOCO POR QUE ES LA VENTA GENERAL, TOTAL DE UN PROMOTOR, ES EL DEPOSITO QUE DEBE DE HABER EN EL BANCO POR ESE PROMOTOR
        ' group by 1';
           If EjecutaSQL(sql,QueryL,_LOCAL) then
           begin // 1.- DESGLOCE IF
              IF not QueryL.Eof THEN
              begin
                     WriteLn(Archivo,'');
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
          controlBoletosAutomatizados(Archivo, strToInt(Corte), idPromotor);
end;

procedure VentaNetaFinDeTurnoOPOS(var Archivo: String);
begin
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
        ' AND BOL.TRAB_ID=CANC.TRAB_ID AND BOL.ID_TERMINAL = ' + QuotedStr(gs_terminal) +
//        ' AND BOL.ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
// NO LO COLOCO POR QUE ES LA VENTA GENERAL, TOTAL DE UN PROMOTOR, ES EL DEPOSITO QUE DEBE DE HABER EN EL BANCO POR ESE PROMOTOR
        ' group by 1';
          If EjecutaSQL(sql,QueryL,_LOCAL) then
           begin // 1.- DESGLOCE IF
              IF not QueryL.Eof THEN
              begin
                     Archivo:= Archivo + TextoAlineado_OPOS('VENTAS NETAS DE FIN DE TURNO','c');
                     Archivo:= Archivo + TextoAlineado_OPOS(Forza_Izq('ESTATUS BOLETO', 20) +
                                     Forza_DER('CANTIDAD', 10) +
                                     Forza_DER('MONTO', 10),'i' );
              end;
              while not QueryL.Eof  do
              begin   // 2.- DESGLOCE -while
                 Archivo:= Archivo + TextoAlineado_OPOS(Forza_Izq(QueryL.fieldByName('DESCRIPCION').AsString, 20) +
                                 Forza_DER(QueryL.fieldByName('CANTIDAD').AsString, 10) +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.fieldByName('MONTO').AsFloat]), 10),'i' );
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
          Archivo:= Archivo + TextoAlineado_OPOS(Forza_Izq('', 20) +
                                 Forza_DER(' ', 10) +
                                 Forza_DER('----------', 10) ,'i');
          Archivo:= Archivo + TextoAlineado_OPOS(Forza_Izq('TOTALES NETOS', 20) +
                                 Forza_DER('', 10) +
                                 Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[VentaNeta]), 10) ,'i');
    Archivo:= Archivo + saltosDeLinea_OPOS(7);
    Archivo:= Archivo + corte_OPOS;

end;




function LlenaMatrizServicios(servicio: String; efectivo: double; ixe: double; banamex: double): Boolean;
var indice: Integer;
    existe: Boolean;
begin
  indice:= Lservicios.IndexOf(servicio);

    if indice >= 0 then
    begin
      TServiciosGlobal(Lservicios.Objects[indice]).servicio:= servicio;
      TServiciosGlobal(Lservicios.Objects[indice]).efectivo:=
                 TServiciosGlobal(Lservicios.Objects[indice]).efectivo + efectivo;
      TServiciosGlobal(Lservicios.Objects[indice]).ixe:=
                 TServiciosGlobal(Lservicios.Objects[indice]).ixe      + ixe;
      TServiciosGlobal(LServicios.Objects[indice]).banamex :=
                 TServiciosGlobal(LServicios.Objects[indice]).banamex  + banamex;
    end
    else
    begin
      _servicios:= TServiciosGlobal.Create;
      _servicios.CreateObjectS(servicio,efectivo, ixe, banamex);
      Lservicios.AddObject(servicio, _servicios);
    end;

end;
 {funcino que realiza el archivo del detalle de boletos y efectivo y lo imprimer en una
 impresora predeterminada en el equipo que se encuentra corriendo el ejecutable}
function DetalleDocumentosEfectivoPredeterminada(var Archivo: TextFile; IdCorte: Integer; Empleado: String): Boolean;
var auxReal     : real;
    AuxR1, AuxR2: real;
    auxInt, auxInt2, i , ocupados , cancelados, blancos, recolecciones : Integer;
begin
   if ImprimeCodigoDocumento then
   begin
       WriteLn(Archivo, RegresaCodigoDocumento );
   end;

   WriteLn(Archivo, Forza_Izq('CORTE DE DOCUMENTOS Y DETALLE EN EFECTIVO', 50));
   WriteLn(Archivo, comun.gs_terminal);
   WriteLn(Archivo, '' );
   WriteLn(Archivo, 'FECHA:    ' + FormatDateTime('dd/mm/yyyy',
                    VarToDateTime(RegresaDatoPreCorte('FECHA',idCorte,empleado))));
   WriteLn(Archivo, 'TURNO:    ' + UpperCase(RegresaDatoPreCorte('TURNO',idCorte,Empleado)));
   WriteLn(Archivo, '' );
   WriteLn(Archivo, 'CORTE FOLIO NUMERO:    ' + IntToStr(IdCorte));
   WriteLn(Archivo, '' );
   WriteLn(Archivo, 'PROMOTOR          :    ' + Empleado + ',  ' +RegresaEmpleadoCorte(Empleado));
   WriteLn(Archivo, '' );


   auxReal := RegresaDatoPreCorte('FONDO_INICIAL',idCorte,empleado) ;
   WriteLn(Archivo, Forza_Izq('FONDO INICIAL', 55) + Forza_Izq('IMPORTE:', 10) + Forza_Izq('', 15) +Forza_Der('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[auxReal]) ,15)) ;
   auxInt := RegresaDatoPreCorte('BOL_CANCELADOS',idCorte,empleado);
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Izq('NO. DE BOLETOS CANCELADOS: ',55) +Forza_Izq('', 10) + Forza_Der('' + intToStr(auxInt) ,15) +Forza_Der('', 15) );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('NO_RECOLECCION',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('RECOLECCIONES: ',55) + Forza_Izq('BOLETOS', 10) + Forza_Der('' + intToStr(auxInt) ,15) + Forza_Der('', 15) );
   auxReal := RegresaDatoPreCorte('TOTAL_RECOL',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('',55) + Forza_Izq('IMPORTE 1', 10)  + Forza_Izq('', 15) +  Forza_Der('$'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[auxReal]) ,15) );
   WriteLn(Archivo, '' );
   auxReal := RegresaDatoPreCorte('TOTAL_EFECTIVO',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('TOTAL EFECTIVO ',55) + Forza_Izq('IMPORTE 2', 10)  + Forza_Izq('', 15) + Forza_Der('$'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[auxReal]) ,15) );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('APA',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('NO. DE CORTESIAS AEROMEXICO (APA): ',55) + Forza_Izq('', 10) + Forza_Der('' + intToStr(auxInt) ,15) +Forza_Izq('', 15) );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('ORD100',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('NO. DE ORDEN PASAJE AL 100% (OR1, AGENCIAS DE VIAJE): ',55) + Forza_Izq('', 10) +  Forza_Der('' + intToStr(auxInt) ,15) +Forza_Izq('', 15)  );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('ORD50',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('NO. DE ORDEN PASAJE AL 50% (OR5, PASES DE TRASLADO): ',55) + Forza_Izq('', 10) + Forza_Der('' + intToStr(auxInt) ,15) + Forza_Izq('', 15)  );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('SEDENA2',idCorte,empleado);
   auxInt2 := RegresaDatoPreCorte('SEDENA',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('NO. DE 1 (ORDENES DE SERVICIO) 2 (PASAJEROS SEDENA):',55) + Forza_Izq('', 10)  + Forza_Der('('+ intToStr(auxInt2)+') ('+intToStr(auxInt)+')' ,15) + Forza_Izq('',15) );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('TICKETBUS',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('NO. DE BOLETOS TICKET BUS (TB1, CANGE DE TICKETBUS):',55) + Forza_Izq('', 10) + Forza_Der('' + intToStr(auxInt) ,15) + Forza_Izq('', 15) );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('FAM2',idCorte,empleado);
   auxReal:= RegresaDatoPreCorte('FAM',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('NO. DE FAM   1(DESCUENTOS OTORGADOS) 2 (PASAJEROS) :',55) + Forza_Izq('', 10) + Forza_Der('('+FloatToStr(auxReal)+')' + '('+intToStr(auxInt)+')' ,15) + Forza_Der('', 15)  );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('IXE_BOLETOS',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('VENTA CON TERMINAL IXE',55) + Forza_Izq('BOLETOS', 10)  + Forza_Der('' + intToStr(auxInt) ,15) + Forza_Der('', 15));
   auxInt := RegresaDatoPreCorte('IXE_TICKETS',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('',55) + Forza_Izq('TICKETS', 10)   + Forza_Der('' + intToStr(auxInt) ,15) + Forza_Izq('', 15) );
   auxReal:= RegresaDatoPreCorte('IXE_IMPORTE',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('',55) + Forza_Izq('IMPORTE A', 10) + Forza_Der('$'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[auxReal]) ,15) + Forza_Der('', 15)  );
   WriteLn(Archivo, '' );
   auxInt := RegresaDatoPreCorte('BAN_BOLETOS',idCorte,empleado);

   WriteLn(Archivo, Forza_Izq('VENTA CON TERMINAL BANAMEX',55) + Forza_Izq('BOLETOS', 10)  + Forza_Der('' + intToStr(auxInt) ,15) + Forza_Der('', 15)  );
   auxInt := RegresaDatoPreCorte('BAN_TICKETS',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('',55) + Forza_Izq('TICKETS', 10)  + Forza_Der('' + intToStr(auxInt) ,15) + Forza_Der('', 15));
   auxReal:= RegresaDatoPreCorte('BAN_IMPORTE',idCorte,empleado);
   WriteLn(Archivo, Forza_Izq('',55) + Forza_Izq('IMPORTE B', 10)  +  Forza_Der('$'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[auxReal]) ,15)  + Forza_Der('', 15));
   WriteLn(Archivo, '' );
   auxR1:=  RegresaDatoPreCorte('BAN_IMPORTE',idCorte,empleado);
   auxR2:=  RegresaDatoPreCorte('IXE_IMPORTE',idCorte,empleado);
   auxReal:= auxR1 + AuxR2;
   WriteLn(Archivo, Forza_Izq('VENTA CON APROBACION BANCARIA ( IMPORTE A + B)',55) + Forza_Izq('', 10)  +  Forza_Der('$'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[auxReal]) ,15) +  Forza_Der('', 15) );

   WriteLn(Archivo, '' );
   auxR1:=  RegresaDatoPreCorte('TOTAL_RECOL',idCorte,empleado);
   auxR2:=  RegresaDatoPreCorte('TOTAL_EFECTIVO',idCorte,empleado);
   auxReal:= auxR1 + AuxR2;
   WriteLn(Archivo, Forza_Izq('VENTA TOTAL EN EFECTIVO ( IMPORTE 1 + 2)',55) + Forza_Izq('', 10)  + Forza_Izq('', 15) +  Forza_Der('$'+ FORMAT(_FORMATO_CANTIDADES_CORTES,[auxReal]) ,15)  );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, 'CONTROL DE BOLETOS AUTOMATIZADOS' );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, 'BLOQUES' );
   WriteLn(Archivo, '' );
   SQL:= 'SELECT * FROM PDV_FOLIOS WHERE ID_CORTE= '+intToStr(idCorte)+' AND TRAB_ID='+QuotedStr(Empleado)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
       ShowMessage('Error al consultar los bloques del empleado.');
       Exit;
   end;
   if QueryL.Eof then
   begin
     WriteLn('SIN BLOQUES DE BOLETOS');
   end;
   ocupados :=0;
   WriteLn(Archivo, Forza_Izq('FOLIO INICIAL', 20) + Forza_Der('FOLIO FINAL', 20) + Forza_Izq('', 20) +Forza_Der('TOTAL FOLIOS',20) );
   while not QueryL.Eof do
   begin
         ocupados:= (QueryL.FieldByName('FOLIO_FINAL_B').AsInteger - QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger   - 1) + ocupados;
         WriteLn(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger), 20) +
                          Forza_Der(intToStr(QueryL.FieldByName('FOLIO_FINAL_B').AsInteger), 20)   +
                          Forza_Der('', 20) +
                          Forza_Der(intToStr(QueryL.FieldByName('FOLIO_FINAL_B').AsInteger -
                                             QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger   - 1 )   , 20)+
                          Forza_Der('', 20) );
         QueryL.Next;
   end;
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Boletos', 20) +
                          Forza_Der(IntToStr(ocupados)   , 20) );
   WriteLn(Archivo, '--------------------------------------------------------------------' );
   WriteLn(Archivo, 'CANCELADOS' );
   WriteLn(Archivo, '' );
   SQL:= 'SELECT * FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = '+intToStr(idCorte)+'  AND TIPO_FOLIO = '+ QuotedStr(COMUNII._FOLIOS_CANCELADOS)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
       ShowMessage('Error al consultar los folios cancelados.');
       Exit;
   end;
   if QueryL.Eof then
   begin
     WriteLn('SIN FOLIOS CANCELADOS');
   end;
   i:= 1;
   cancelados:= 0;
   while not QueryL.Eof do
   begin
         if i = 3 then
         begin
            WriteLn(Archivo,'');
            i:=1;
         end;
         Write(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO').AsInteger), 20)+
                        Forza_Der('', 20) );
         QueryL.Next;
         i:= i + 1 ;
         cancelados:= cancelados + 1;
   end;
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Cancelados', 20) +
                          Forza_Der(IntToStr(Cancelados)   , 20) );
   WriteLn(Archivo, '--------------------------------------------------------------------' );
   WriteLn(Archivo, 'EN BLANCO' );
   WriteLn(Archivo, '' );
   blancos := 0;
   SQL:= 'SELECT * FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = '+intToStr(idCorte)+'  AND TIPO_FOLIO = '+ QuotedStr(COMUNII._FOLIOS_EN_BLANCO)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
       ShowMessage('Error al consultar los folios en blanco.');
       Exit;
   end;
   i:= 1;
   if QueryL.Eof then
   begin
     WriteLn('SIN FOLIOS EN BLANCO');
   end;
   while not QueryL.Eof do
   begin
         if i = 3 then
         begin
            WriteLn(Archivo,'');
            i:=1;
         end;
         Write(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO').AsInteger), 20)+
                        Forza_Der('', 20) );
         QueryL.Next;
         Blancos := Blancos + 1;
         i:= i + 1 ;
   end;
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Blancos', 20) +
                          Forza_Der(IntToStr(Blancos), 20) );
   WriteLn(Archivo, '--------------------------------------------------------------------' );
   WriteLn(Archivo, 'RECOLECCIONES' );
   WriteLn(Archivo, '' );
   SQL:= 'SELECT * FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = '+intToStr(idCorte)+'  AND TIPO_FOLIO = '+ QuotedStr(COMUNII._FOLIOS_DE_RECOLECCION)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
    begin
        ShowMessage('Error al consultar los folios de recolecciones.');
        Exit;
    end;
    i:= 1;
    Recolecciones := 0;
    if QueryL.Eof then
   begin
     WriteLn('SIN FOLIOS DE RECOLECCION');
   end;
   while not QueryL.Eof do
   begin
         if i = 3 then
         begin
            WriteLn(Archivo,'');
            i:=1;
         end;
         Write(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO').AsInteger), 20)+
                        Forza_Der('', 20) );
         QueryL.Next;
         Recolecciones := Recolecciones + 1;
         i:= i + 1 ;
   end;
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Recolecciones', 20) +
                          Forza_Der(IntToStr(Recolecciones)   , 20) );
   WriteLn(Archivo, '--------------------------------------------------------------------' );
   WriteLn(Archivo, 'TOTAL DE BOLETOS FISICOS UTILIZADOS '+ intToStr(ocupados - (cancelados+blancos+recolecciones)) );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '' );
   WriteLn(Archivo, '________________________________                           _________________________________ ' );
   WriteLn(Archivo, 'Nombre Firma y Clave del Promotor                           Nombre Firma y Clave del Cajero ' );
   WriteLn(Archivo, '.' );
end;


function RegresaDatoPreCorte(registro: string; id_corte: integer; trab_id: string): Variant;
begin
  sql:='SELECT '+ registro + ' FROM PDV_T_PRECORTE WHERE ID_CORTE = ' + IntToStr(id_corte) + ' AND TRAB_ID= ' + QuotedStr(trab_id);
  If NOT EjecutaSQL(sql,QueryL,_LOCAL) then
  begin
    ShowMEssage(comunii._ERROR_PRE_LLENADO);
    Exit;
  end;
  if registro = 'FONDO_INICIAL' then
  begin
     result:= QueryL.FieldByName(registro).AsFloat;
     exit;
  end;

  result:= QueryL.FieldByName(registro).AsVariant;

end;

function RevisaFoliosCorte(idCorte, promotor: String): Boolean;
begin
  SQL:='SELECT ID_CORTE FROM PDV_T_PRECORTE WHERE ID_CORTE= '+ idCorte + ' AND TRAB_ID=' +  QuotedStr(promotor) ;
     If EjecutaSQL(sql,QueryL,_LOCAL) then
        if QueryL.Eof then
        BEGIN
           ShowMEssage(comunii._ERROR_BLOQUES_SIN_DATOS);
           result:= false; // regresa un False, quiere decir que hacen falta algun dato en los bloques registrados.
           exit;
        END;
  sql:= 'SELECT FOLIO_INICIAL_B FROM '+
        ' PDV_FOLIOS WHERE  '+
        ' (TRAB_ID='+ QuotedStr(promotor)+ ' AND ID_CORTE = ' + idCorte + ' AND FOLIO_FINAL_B IS NULL) OR '+
        ' (TRAB_ID='+ QuotedStr(promotor)+ ' AND ID_CORTE = ' + idCorte + ' AND FOLIO_FINAL_B  = 0 ) OR '+
        ' (TRAB_ID='+ QuotedStr(promotor)+ ' AND ID_CORTE = ' + idCorte + ' AND FOLIO_FINAL IS NULL);';
  If not EjecutaSQL(sql,QueryL,_LOCAL) then
  begin
    sHOWMESSAGE(COMUNII._ERROR_PRE_LLENADO);
    Exit;
  end;
  if not QueryL.Eof then
  begin
     ShowMEssage(comunii._ERROR_BLOQUES_SIN_DATOS);
     result:= false; // regresa un False, quiere decir que hacen falta algun dato en los bloques registrados.
     exit;
  end;
  sql:= 'SELECT TRAB_ID FROM '+
        ' PDV_FOLIOS WHERE   '+
        ' TRAB_ID='+ QuotedStr(promotor)+ ' AND ID_CORTE = ' + idCorte + ';';
  If not EjecutaSQL(sql,QueryL,_LOCAL) then
  begin
    sHOWMESSAGE(COMUNII._ERROR_PRE_LLENADO);
    result:= false; // regresa un False, quiere decir que hacen falta algun dato en los bloques registrados.
    Exit;
  end;
  if  QueryL.Eof then
  begin
     ShowMEssage(comunii._ERROR_BLOQUES_SIN_DATOS);
     result:= false; // regresa un False, quiere decir que hacen falta algun dato en los bloques registrados.
     exit;
  end;

  result:= True; // si regresa un True, que continue por que tiene todos los bloques completos los datos


end;

Procedure AsignaQueryDesgloceFechas;
begin
  sql:=   'SELECT DATE(FECHA_HORA_BOLETO) AS FECHA_, COUNT(*) as TOTAL, CASE WHEN IVA < 0 THEN 0 ELSE IVA END as IVA , '+
  //        ' COALESCE(SUM(TOTAL_IVA),0) AS IMPUESTO ,   COALESCE(SUM(TARIFA - TOTAL_IVA),0)  AS ''INGRESO'' , '+
          ' case when PDV_T_BOLETO.IVA > 0 THEN  COALESCE(SUM( TARIFA - (TARIFA /   (PDV_T_BOLETO.IVA/100 +1) )) , 0) ELSE 0  END AS ''IMPUESTO'' ,  '+
          ' case when PDV_T_BOLETO.IVA > 0 THEN  COALESCE(SUM( TARIFA /   (PDV_T_BOLETO.IVA/100 +1) ) , 0) ELSE COALESCE(SUM(TARIFA) ,0)  END AS ''INGRESO'' , '+
          '  SUM(TARIFA) as IMPORTE,  (count(*) / (select count(*)   FROM PDV_T_BOLETO  '+
          ' WHERE DATE(FECHA_HORA_BOLETO) BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
          ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
          ' AND ID_TERMINAL = '+QuotedStr(gs_terminal) + ' and trab_id='+ QuotedStr(idPromotor) +
          ' AND ESTATUS_PROCESADO='+QuotedStr(_ESTATUS_VENDIDO)+'))*100 as X '+
          ' FROM PDV_T_BOLETO '+
          ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
          ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
          ' AND TRAB_ID = '+  QuotedStr(idPromotor) +  ' and ID_TERMINAL = ' + QuotedStr(gs_terminal) +
          ' AND ESTATUS_PROCESADO=' + QuotedStr(_ESTATUS_VENDIDO) +
          ' GROUP BY FECHA_, PDV_T_BOLETO.IVA;';
        // ShowMessage(sql);
  
end;

procedure AsignaQueryVentaFinTurnoPasajeros;
begin
           // QueryL PARA OBTENER VENTAS X TIPO DE PASAJERO   PERO DESGLOSANDO LOS IMPORTES DEL IVA DONDE APLIQUE.
           // SI EXISTEN 2 IVAS (16 Y 15 %)  SE IMPRIMIRAN AMBOS
           SQL:='SELECT BOL.ID_OCUPANTE, OCU.DESCRIPCION , COALESCE(COUNT(*),0) AS ''CANTIDAD'', '+
                ' CASE WHEN BOL.IVA < 0 THEN 0 ELSE BOL.IVA END as IVA , '+
                ' case when BOL.IVA > 0 THEN  COALESCE(SUM( TARIFA - (TARIFA /   (BOL.IVA/100 +1) )) , 0) ELSE 0  END AS ''IMPUESTO'' ,  '+
                ' case when BOL.IVA > 0 THEN  COALESCE(SUM( TARIFA /   (BOL.IVA/100 +1) ) , 0) ELSE COALESCE(SUM(TARIFA) ,0)  END AS ''INGRESO'' , '+
                ' COALESCE(SUM(TARIFA),0)  AS ''MONTO'''+
                '  FROM PDV_T_BOLETO AS BOL RIGHT JOIN PDV_C_OCUPANTE AS OCU ON (OCU.ID_OCUPANTE = BOL.ID_OCUPANTE) '+
                ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
                ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
                ' AND BOL.TRAB_ID = '+  QuotedStr(idPromotor)  + ' AND BOL.ESTATUS_PROCESADO ='+ QuotedStr(_ESTATUS_VENDIDO) +
                ' AND BOL.ID_TERMINAL= '+ QuotedStr(gs_terminal)+
         //       ' AND BOL.ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
                ' group by BOL.ID_OCUPANTE, BOL.IVA; ';
          //ShowMessage(sql);
       
end;

procedure AsignaQueryVentaFinTurnoFormaPago;
begin
   // VENTAS POR CADA UNA DE LAS FORMAS DE PAGO   DESGLOSANDO LOS IMPUESTOS QUE EXISTAN
           SQL:='SELECT BOL.ID_FORMA_PAGO, PAGO.DESCRIPCION, COALESCE(COUNT(*),0) AS ''CANTIDAD'', CASE WHEN BOL.IVA < 0 THEN 0 ELSE BOL.IVA END as IVA , '+
//                ' COALESCE(SUM(TOTAL_IVA),0)  AS ''IMPUESTO''  , COALESCE(SUM(TARIFA - TOTAL_IVA),0)  AS ''INGRESO'' ,  '+
                ' case when BOL.IVA > 0 THEN  COALESCE(SUM( TARIFA - (TARIFA /   (BOL.IVA/100 +1) )) , 0) ELSE 0  END AS ''IMPUESTO'' ,  '+
                ' case when BOL.IVA > 0 THEN  COALESCE(SUM( TARIFA /   (BOL.IVA/100 +1) ) , 0) ELSE COALESCE(SUM(TARIFA) ,0)  END AS ''INGRESO'' , '+
                ' COALESCE(SUM(TARIFA),0)   AS ''MONTO'''+
                ' FROM PDV_T_BOLETO AS BOL RIGHT JOIN PDV_C_FORMA_PAGO AS PAGO ON (BOL.ID_FORMA_PAGO = PAGO.ID_FORMA_PAGO) '+
                ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
                ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
                ' AND BOL.TRAB_ID = '+  QuotedStr(idPromotor) + ' AND BOL.ESTATUS_PROCESADO ='+QuotedStr(_ESTATUS_VENDIDO) +
                ' AND BOL.ID_TERMINAL= '+ QuotedStr(gs_terminal)+
               // ' AND BOL.ID_FORMA_PAGO IN  ( SELECT ID_FORMA_PAGO FROM PDV_C_FORMA_PAGO WHERE SUMA_EFECTIVO_COBRO  =1 )'+
                ' group by BOL.ID_FORMA_PAGO , BOL.IVA;';
                //ShowMEssage(sql);

end;

procedure AsignaQueryDesgloceTotal;
begin
  sql:=   'SELECT  COUNT(*) as TOTAL, CASE WHEN IVA < 0 THEN 0 ELSE IVA END as IVA , '+
          ' case when PDV_T_BOLETO.IVA > 0 THEN  COALESCE(SUM( TARIFA - (TARIFA /   (PDV_T_BOLETO.IVA/100 +1) )) , 0) ELSE 0  END AS ''IMPUESTO'' ,  '+
          ' case when PDV_T_BOLETO.IVA > 0 THEN  COALESCE(SUM( TARIFA /   (PDV_T_BOLETO.IVA/100 +1) ) , 0) ELSE COALESCE(SUM(TARIFA) ,0)  END AS ''INGRESO'' , '+
          '  SUM(TARIFA) as IMPORTE,  (count(*) / (select count(*)   FROM PDV_T_BOLETO  '+
          ' WHERE DATE(FECHA_HORA_BOLETO) BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
          ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
          ' AND ID_TERMINAL = '+QuotedStr(gs_terminal) + ' and trab_id='+ QuotedStr(idPromotor) +
          ' AND ESTATUS_PROCESADO='+QuotedStr(_ESTATUS_VENDIDO)+'))*100 as X '+
          ' FROM PDV_T_BOLETO '+
          ' WHERE FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss',FechaIniciaCorte))+
          ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:NN:ss ',FechaTerminaCorte)) +
          ' AND TRAB_ID = '+  QuotedStr(idPromotor) +  ' and ID_TERMINAL = ' + QuotedStr(gs_terminal) +
          ' AND ESTATUS_PROCESADO=' + QuotedStr(_ESTATUS_VENDIDO) +
          ' GROUP BY  PDV_T_BOLETO.IVA;';
  //ShowMessage(sql);
end;

function RegresaEmpleadoCorte(idEmpleado: String): String;
begin
 sql:='SELECT NOMBRE FROM PDV_C_USUARIO WHERE TRAB_ID= ' + QuotedStr(idEmpleado);
  If NOT EjecutaSQL(sql,QueryL,_LOCAL) then
  begin
    ShowMEssage(comunii._ERROR_PRE_LLENADO);
    Exit;
  end;
 result:= QueryL.FieldByName('NOMBRE').asString;
end;


function ImprimeCodigoDocumento: Boolean;
begin
  // Reviso si debo imprimir el Código de Documento para el detalle de Folios (Corte de Documentos y Detalle en Efectivo).
  // el parametro es el numero 100 de la tabla   PDV_C_PARAMETRO; 0 significa NO IMPRIME 1 significa SI IMPRIME ...
  result:= False;
  sql:='SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 100';
  If  EjecutaSQL(sql,QueryL,_LOCAL) then
  begin
   if QueryL.Fields[0].AsString = '1' then
   begin
     result:= True;
     Exit;
   end;
  end;

end;
function RegresaCodigoDocumento: String;
begin
 // Regreso numero de documento
  // el parametro es el numero 101 de la tabla   PDV_C_PARAMETRO;  el campo DESCRIPCION contiene el Codigo de Documento.
  sql:='SELECT DESCRIPCION FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 101';
  If  EjecutaSQL(sql,QueryL,_LOCAL) then
  begin
    result:= QueryL.Fields[0].AsString;
    Exit;
  end;
end;

procedure CargaRazonSocial(terminal:String);
begin
  sql:='SELECT NOMBRE_EMPRESA FROM PDV_C_GRUPO_SERVICIOS WHERE ID_TERMINAL= '+ QuotedStr(terminal);
  if EjecutaSQL(sql, QueryL, _LOCAL) then
  begin
     RazonSocial:= QueryL.FieldByName('NOMBRE_EMPRESA').AsString;
  end;
end;

procedure SumaFinalDelDia(var Archivo: textFile; terminal: String; fecha: TDateTime);
begin
   sql:='SELECT SUM(TARIFA) AS TOTAL FROM PDV_T_BOLETO '+
        ' WHERE  ID_TERMINAL='+ QuotedStr(Terminal) +
        ' AND  FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha)) +
        ' AND ESTATUS_PROCESADO IS NULL';
   if EjecutaSQL(sql, QueryL, _LOCAL) then
   BEGIN
      if QueryL.FieldByName('TOTAL').AsInteger > 0 then
      begin
          WriteLn(Archivo,'EXISTEN ' +
          Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('TOTAL').AsFloat]), 10) +
          ' PESOS EN BOLETOS FUERA DE UN CORTE.');
      end
      else
      begin
          WriteLn(Archivo,'TODOS LOS BOLETOS OK.');
      end;
   END;
end;

procedure SumaFinalDelDiaOPOS(var Archivo: string; terminal: String; fecha: TDateTime);

begin
   sql:='SELECT SUM(TARIFA) AS TOTAL FROM PDV_T_BOLETO '+
        ' WHERE  ID_TERMINAL='+ QuotedStr(Terminal) +
        ' AND  FECHA_HORA_BOLETO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fecha))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fecha)) +
        ' AND ESTATUS_PROCESADO IS NULL';
   if EjecutaSQL(sql, QueryL, _LOCAL) then
   BEGIN
      if QueryL.FieldByName('TOTAL').AsInteger > 0 then
      begin
          Archivo:= Archivo + textoAlineado_OPOS('EXISTEN ' +
          Forza_DER('$'+FORMAT(_FORMATO_CANTIDADES_CORTES,[QueryL.FieldByName('TOTAL').AsFloat]), 10) +
          ' EN BOLETOS FUERA DE UN CORTE.','c');

      end
      else
      begin
          Archivo:= Archivo + textoAlineado_OPOS('TODOS LOS BOLETOS OK.','c');
      end;
   END;
end;
function EmpleadosPendientes(Terminal: String; FechaI, FechaF: TDateTime): String;
var cadena: String;
begin
sql:='SELECT  ID_EMPLEADO  FROM  PDV_T_CORTE ' +
        ' WHERE ID_TERMINAL='+ QuotedStr(Terminal) +
        ' AND FECHA_INICIO BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',fechaI))+
        ' AND '+ QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59', fechaF))+
        ' AND FECHA_FIN IS NULL AND ESTATUS <> '+ _FINALIZADO;
cadena:='';
if EjecutaSQL(sql,QueryL,_LOCAL) then
      while not QueryL.Eof Do
      begin
         cadena:=    cadena + QueryL.FieldByName('ID_EMPLEADO').AsString + Char(#13);
         QueryL.Next;
      end;
result:= cadena;
end;

function controlBoletosAutomatizados(var Archivo: Textfile; idCorte: Integer;  Empleado: String): Boolean;
var auxReal     : real;
    AuxR1, AuxR2: real;
    auxInt, auxInt2, i , ocupados , cancelados, blancos, recolecciones : Integer;
begin
   WriteLn(Archivo, '' );
   WriteLn(Archivo, 'CONTROL DE BOLETOS AUTOMATIZADOS' );
   SQL:= 'SELECT * FROM PDV_FOLIOS WHERE ID_CORTE= '+intToStr(idCorte)+' AND TRAB_ID='+QuotedStr(Empleado)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
       ShowMessage('Error al consultar los bloques del empleado.');
       Exit;
   end;
   if QueryL.Eof then
   begin
     WriteLn('SIN BLOQUES DE BOLETOS');
   end;
   ocupados :=0;
   WriteLn(Archivo, Forza_Der('FOLIO INICIAL', 15) + Forza_Der('FOLIO FINAL', 15)  +Forza_Der('TOTAL FOLIOS',15)+
                    Forza_Der('FOLIO INICIAL', 15) + Forza_Der('FOLIO FINAL', 15)  +Forza_Der('TOTAL FOLIOS',15)  );
   while not QueryL.Eof do
   begin
         ocupados:= (QueryL.FieldByName('FOLIO_FINAL_B').AsInteger - QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger   - 1) + ocupados;
         Write(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger), 15) +
                          Forza_Der(intToStr(QueryL.FieldByName('FOLIO_FINAL_B').AsInteger), 15)   +
                          Forza_Der(intToStr(QueryL.FieldByName('FOLIO_FINAL_B').AsInteger -
                                             QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger   - 1 )   , 15) );
         QueryL.Next;
         if not queryL.Eof then
         begin
           ocupados:= (QueryL.FieldByName('FOLIO_FINAL_B').AsInteger - QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger   - 1) + ocupados;
           WriteLn(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger), 15) +
                            Forza_Der(intToStr(QueryL.FieldByName('FOLIO_FINAL_B').AsInteger), 15)   +
                            Forza_Der(intToStr(QueryL.FieldByName('FOLIO_FINAL_B').AsInteger -
                                               QueryL.FieldByName('FOLIO_INICIAL_B').AsInteger   - 1 )   , 15) );
           QueryL.Next;
         end else
         begin
           WriteLn(Archivo,'');
         end;
   end;

   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Boletos', 20) +
                          Forza_Der(IntToStr(ocupados)   , 20) );

   WriteLn(Archivo, 'CANCELADOS' );

   SQL:= 'SELECT * FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = '+intToStr(idCorte)+'  AND TIPO_FOLIO = '+ QuotedStr(COMUNII._FOLIOS_CANCELADOS)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
       ShowMessage('Error al consultar los folios cancelados.');
       Exit;
   end;
   if QueryL.Eof then
   begin
     WriteLn('SIN FOLIOS CANCELADOS');
   end;
   i:= 1;
   cancelados:= 0;
   while not QueryL.Eof do
   begin
         if i = 5 then
         begin
            WriteLn(Archivo,'');
            i:=1;
         end;
         Write(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO').AsInteger), 12)+
                        Forza_Der('', 12) );
         QueryL.Next;
         i:= i + 1 ;
         cancelados:= cancelados + 1;
   end;
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Cancelados', 20) +
                          Forza_Der(IntToStr(Cancelados)   , 20) );

   WriteLn(Archivo, 'EN BLANCO' );

   blancos := 0;
   SQL:= 'SELECT * FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = '+intToStr(idCorte)+'  AND TIPO_FOLIO = '+ QuotedStr(COMUNII._FOLIOS_EN_BLANCO)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
   begin
       ShowMessage('Error al consultar los folios en blanco.');
       Exit;
   end;
   i:= 1;
   if QueryL.Eof then
   begin
     WriteLn('SIN FOLIOS EN BLANCO');
   end;
   while not QueryL.Eof do
   begin
         if i = 5 then
         begin
            WriteLn(Archivo,'');
            i:=1;
         end;
         Write(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO').AsInteger), 12)+
                        Forza_Der('', 12) );
         QueryL.Next;
         Blancos := Blancos + 1;
         i:= i + 1 ;
   end;
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Blancos', 20) +
                          Forza_Der(IntToStr(Blancos), 20) );

   WriteLn(Archivo, 'RECOLECCIONES' );

   SQL:= 'SELECT * FROM PDV_FOLIOS_GENERAL WHERE ID_CORTE = '+intToStr(idCorte)+'  AND TIPO_FOLIO = '+ QuotedStr(COMUNII._FOLIOS_DE_RECOLECCION)+';';
   If not EjecutaSQL(sql,QueryL,_LOCAL) then
    begin
        ShowMessage('Error al consultar los folios de recolecciones.');
        Exit;
    end;
    i:= 1;
    Recolecciones := 0;
    if QueryL.Eof then
   begin
     WriteLn('SIN FOLIOS DE RECOLECCION');
   end;
   while not QueryL.Eof do
   begin
         if i = 5 then
         begin
            WriteLn(Archivo,'');
            i:=1;
         end;
         Write(Archivo, Forza_Der(intToStr(QueryL.FieldByName('FOLIO').AsInteger), 12)+
                        Forza_Der('', 12) );
         QueryL.Next;
         Recolecciones := Recolecciones + 1;
         i:= i + 1 ;
   end;
   WriteLn(Archivo, '' );
   WriteLn(Archivo, Forza_Der('',20)   +
                          Forza_Der('', 20) +
                          Forza_Der('', 20)+
                          Forza_Der('Total Recolecciones', 20) +
                          Forza_Der(IntToStr(Recolecciones)   , 20) );

   WriteLn(Archivo, '' );
   WriteLn(Archivo, '________________________________                           _________________________________ ' );
   WriteLn(Archivo, 'Nombre Firma y Clave del Promotor                           Nombre Firma y Clave del Cajero ' );
   WriteLn(Archivo, '.' );

end;


end.

