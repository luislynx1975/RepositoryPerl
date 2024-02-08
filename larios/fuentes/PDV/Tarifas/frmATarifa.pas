unit frmATarifa;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids,  StdCtrls, lsCombobox, ComCtrls, ExtCtrls,
  ActnList, PlatformDefaultStyleActnCtrls, ActnMan, System.Actions,
  Data.SqlExpr;

type
  TfrmATarifas = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    FA: TDateTimePicker;
    HA: TDateTimePicker;
    lscbSInicial: TlsComboBox;
    lscbOrigen: TlsComboBox;
    lscbDestino: TlsComboBox;
    Button1: TButton;
    Button2: TButton;
    Label6: TLabel;
    lscbSFinal: TlsComboBox;
    ActionManager1: TActionManager;
    acBuscar: TAction;
    acGuardar: TAction;
    btnGuardar: TButton;
    sb: TStatusBar;
    sagInfo: TStringGrid;
    lbl1: TLabel;
    edtImpuesto: TEdit;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure acBuscarExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    function AsignaCeros(grid: TStringGrid): Boolean;
    function RevisaTarifas(grid: TStringGrid): Boolean;
    function RegresaIdTarifa(Tramo, Servicio: String): Integer;
    function grabaTarifa(idTarifa: Integer; FHAplica: TdAteTime; Monto: Real; Impuesto : Real): Boolean;
    function GuardaTarifas(grid: TStringGrid): Boolean;
    procedure btnGuardarClick(Sender: TObject);
    procedure sagInfoSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sagInfoKeyPress(Sender: TObject; var Key: Char);
    procedure edtImpuestoKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmATarifas: TfrmATarifas;
  SQL2: String;
  sagMio: TStringGrid;
  FechaHoraAplicacion: TDateTime;
  columna, renglon: integer;
  impuesto: real;
//  QueryT:  TSQLQuery;
implementation

uses uTarifas, DMdb, comun, comunii;

{$R *.dfm}

procedure TfrmATarifas.acBuscarExecute(Sender: TObject);
begin
   fa.Time:= ha.Time;
   if FA.DateTime < now() then
    begin
      ShowMessage(uTarifas._FECHA_MAYOR_HOY);
      Exit;
    end;
   sql:='';
   SQL2:='';
   // cuando no se elije Origen ni Destino ni Servicio Inicial ni Final
   if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex<0) and
       (lscbSInicial.ItemIndex <0) and (lscbSFinal.ItemIndex <0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION, '''' AS TARIFA '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
   // cuando  se elije Origen ni Destino ni Servicio Inicial ni Final
   if ((lscbOrigen.ItemIndex >= 0) and (lscbDestino.ItemIndex<0) and
       (lscbSInicial.ItemIndex <0) and (lscbSFinal.ItemIndex <0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION , '''' AS TARIFA'+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN='+ QuotedStr(lscbOrigen.CurrentID) +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN='+ QuotedStr(lscbOrigen.CurrentID) +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
   // cuando  no se elije Origen si Destino ni Servicio Inicial ni Final
   if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex >= 0) and
       (lscbSInicial.ItemIndex <0) and (lscbSFinal.ItemIndex <0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION, '''' AS TARIFA '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
   // cuando  no se elije Origen NI Destino Si Servicio Inicial nO Final
   if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex < 0) and
       (lscbSInicial.ItemIndex >= 0) and (lscbSFinal.ItemIndex <0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION , '''' AS TARIFA '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND S.TIPOSERVICIO='+ lscbSInicial.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND S.TIPOSERVICIO='+ lscbSInicial.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
   // cuando  no se elije Origen NI Destino Si Servicio Inicial Si Servicio Final
   if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex < 0) and
       (lscbSInicial.ItemIndex >=0) and (lscbSFinal.ItemIndex >=0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION , '''' AS TARIFA '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
   // cuando   se elije si Origen si Destino no Servicio Inicial ni Final
   if ((lscbOrigen.ItemIndex >= 0) and (lscbDestino.ItemIndex >= 0) and
       (lscbSInicial.ItemIndex <0) and (lscbSFinal.ItemIndex <0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION , '''' AS TARIFA '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN=' + QuotedStr(lscboRIGEN.CurrentID) +
        ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN=' + QuotedStr(lscboRIGEN.CurrentID) +
        ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
    // cuando   se elije si Origen si Destino si Servicio Inicial si Final
   if ((lscbOrigen.ItemIndex >= 0) and (lscbDestino.ItemIndex >= 0) and
       (lscbSInicial.ItemIndex >= 0) and (lscbSFinal.ItemIndex >= 0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION , '''' AS TARIFA '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN=' + QuotedStr(lscboRIGEN.CurrentID) +
        ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
    sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN=' + QuotedStr(lscboRIGEN.CurrentID) +
        ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
    // cuando   se elije si Origen no Destino si Servicio Inicial si Final
   if ((lscbOrigen.ItemIndex >= 0) and (lscbDestino.ItemIndex < 0) and
       (lscbSInicial.ItemIndex >= 0) and (lscbSFinal.ItemIndex >= 0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION,  '''' AS TARIFA '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN=' + QuotedStr(lscboRIGEN.CurrentID) +
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.ORIGEN=' + QuotedStr(lscboRIGEN.CurrentID) +
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
   // cuando   se elije no Origen si Destino si Servicio Inicial si Final
   if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex >= 0) and
       (lscbSInicial.ItemIndex >= 0) and (lscbSFinal.ItemIndex >= 0) )  then
   begin
   sql:='SELECT T.ORIGEN, T.DESTINO, S.DESCRIPCION , '''' AS TARIFA'+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.DESTINO=' + QuotedStr(lscbDestino.CurrentID) +
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   sql2:='SELECT T.ID_TRAMO, S.TIPOSERVICIO '+
        ' FROM T_C_TRAMO AS T, SERVICIOS AS S '+
        ' WHERE  S.TIPOSERVICIO <>0 '+
        ' AND T.DESTINO=' + QuotedStr(lscbDestino.CurrentID) +
        ' AND S.TIPOSERVICIO BETWEEN '+ lscbSInicial.CurrentID + ' AND ' + lscbSFinal.CurrentID +
        ' ORDER BY T.ORIGEN, T.DESTINO, S.DESCRIPCION ;';
   end;
   if ((sql='') OR (SQL2= ''))  then
   begin
     showMessage('Revisar las opciones.');
     Exit;
   end;
   EjecutaSQL(Sql, QueryT,_LOCAL);
//   DataSetToSag(QueryT,sagInfo);//error nuevo
   EjecutaSQL(sql2, QueryT, _LOCAL);
//   DataSetToSag(QueryT,sagMio);//error nuevo
   sb.Panels[0].Text:= intToStr(sagInfo.RowCount-1) + ' registros.';
   IF (sagMio.RowCount <> sagInfo.RowCount) THEN
   begin
       ShowMessage(_ERROR_LLENADO);
       LimpiaSag(sagInfo);
       LimpiaSag(sagMio);
       Exit;
   end;

end;

function TfrmATarifas.AsignaCeros(grid: TStringGrid): Boolean;
var renglon: integer;
begin
try
    for renglon := 1 to grid.RowCount -1 do
      if Trim(grid.Cells[3,renglon]) = '' then
           grid.Cells[3,renglon]:='0.00';
  except
      result:= False;
      exit;
  end;
  result:= True;

end;

procedure TfrmATarifas.Button1Click(Sender: TObject);
begin
if lscbSFinal.ItemIndex < lscbSInicial.ItemIndex then
begin
   ShowMessage(_ERROR_SERVICIOS);
   Exit;
end;
   LimpiaSag(sagInfo);
   sb.Panels[0].Text:= '';
   acBuscarExecute(Sender);
end;

procedure TfrmATarifas.Button2Click(Sender: TObject);
begin
   close;
end;

procedure TfrmATarifas.edtImpuestoKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9', #8, #13,'.']) then
          Key := _BLANCO;
end;

procedure TfrmATarifas.btnGuardarClick(Sender: TObject);

begin
  FA.Time:= HA.Date;
  FechaHoraAplicacion:= FA.DateTime;
  if (Trim(edtImpuesto.Text) = '' ) then
   begin
        ShowMEssage('Capture un valor del impuesto antes de continuar.');
        Exit;
   end;
  impuesto:= StrToFloat(edtImpuesto.Text);
  if (impuesto < 0) then
   begin
        ShowMEssage('Modifique el valor del impuesto antes de continuar.');
        Exit;
   end;
   // revisa que todas las celdas de las tarifas NO CONTENGAN espacios en blancos
   if not revisaTarifas(sagInfo) then
      if MessageDlg(_MENSAJE_TARIFAS_NULAS,mtWarning,mbOKCancel,0) = mrOK then
      // asigna ceros a las tarifas que contienen espacios en blanco
          AsignaCeros(sagInfo);
   if MessageDlg(_PREGUNTA_ALTA_TARIFAS,mtWarning,mbOKCancel,0) = mrOK then
     GuardaTarifas(sagMio);


end;

procedure TfrmATarifas.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   uTarifas.QueryT.Free;
   sagMio.Free;
   comunii.terminalesAutomatizadas.Free;
end;

procedure TfrmATarifas.FormCreate(Sender: TObject);
begin
   comunii.terminalesAutomatizadas:= TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;
   uTarifas.QueryT:= TSQLQuery.Create(Self);
   uTarifas.QueryT.SQLConnection := dm.Conecta;
   sagMio:= TStringGrid.Create(self);
   CargaCiudad(lscbOrigen);
   CargaCiudad(lscbDestino);
   CargaServicio(lscbSInicial);
   CargaServicio(lscbSFinal);
   FA.MinDate:= NOW();
end;

function TfrmATarifas.grabaTarifa(idTarifa: Integer; FHAplica: TdAteTime;
  Monto: Real; Impuesto : Real): Boolean;
begin
     result:= False;
     // elimino las tarifas para evitar que se dupliquen
     sql:='DELETE FROM PDV_C_TARIFA_D WHERE  ID_TARIFA='+ iNTtOsTR(idTarifa)+
          ' AND FECHA_HORA_APLICA='+ QuotedStr(FormatDateTime('yyyy-mm-dd hh:NN:ss',FHAplica))+';';
     if EjecutaSQL(SQL,QueryT,_LOCAL) then
     begin
        comunii.replicarTodos(sql);
        // agrego la tarifa de forma única
        sql:='INSERT INTO PDV_C_TARIFA_D(ID_TARIFA, MONTO, FECHA_HORA_APLICA, IMP_IVA) '+
             ' VALUES('+ INTTOSTR(IDTARIFA)+ ',' + VARTOSTR(MONTO) + ',' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:NN:ss',FHAplica)) +
             ',' + varToStr(Impuesto) + ');';
        if EjecutaSQL(sql,QueryT,_LOCAL) then
        begin
          comunii.replicarTodos(sql);
          result:= True;
        end;
     end;

end;

function TfrmATarifas.GuardaTarifas(grid: TStringGrid): Boolean;
 var renglon: Integer;
     idTarifa: Integer;
begin
  for renglon := 1 to grid.RowCount -1 do
  begin
      idTarifa:= regresaIdTarifa(sagMio.Cells[0,renglon], sagMio.Cells[1,renglon]);
      if idTarifa <= 0  then
      begin
         showmessage('Existe un error en el identificador de tarifa, intentelo nuevamente.');
         Exit;
      end;
      GrabaTarifa(idTarifa,FechaHoraAplicacion,StrToFloat(sagInfo.Cells[3,renglon]), impuesto);
  end;
  result:= True;
end;

function TfrmATarifas.RegresaIdTarifa(Tramo, Servicio: String): Integer;
var replica: boolean;
begin
   result:=-1;
   sql:='SELECT ID_TARIFA FROM PDV_C_TARIFA WHERE ID_TRAMO='+ Tramo +
        ' AND ID_SERVICIO = '+ Servicio;
   if not EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
     ShowMessage('Error al consultar el identificador de Tarifa.');
     Exit;
   end;
   if QueryT.FieldByName('ID_TARIFA').IsNull then
   begin
     sql:='INSERT INTO PDV_C_TARIFA(ID_TARIFA, ID_TRAMO, ID_SERVICIO) '+
          ' SELECT COALESCE(MAX(ID_TARIFA)+1,1), '+ Tramo + ','+ Servicio +
          ' FROM PDV_C_TARIFA;';
     if not EjecutaSQL(sql,QueryT,_LOCAL) then
     begin
        ShowMessage('Error al insertar el Identificador de Tarifa.');
        Exit
     end;
     replica:= True;
   end;
   sql:='SELECT ID_TARIFA FROM PDV_C_TARIFA WHERE ID_TRAMO='+ Tramo +
        ' AND ID_SERVICIO = '+ Servicio+';';
   if not EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
     ShowMessage('Error al consultar el identificador de Tarifa.');
     Exit;
   end;
   if replica then
   begin
     sql:='INSERT INTO PDV_C_TARIFA(ID_TARIFA, ID_TRAMO, ID_SERVICIO) '+
          ' VALUES('+ INTTOSTR(QueryT.FieldByName('ID_TARIFA').AsInteger) +', '+ Tramo + ','+ Servicio +');';
     comunii.replicarTodos(sql);
   end;
   result:= QueryT.FieldByName('ID_TARIFA').AsInteger;
end;

function TfrmATarifas.RevisaTarifas(grid: TStringGrid): Boolean;
  var renglon: Integer;
begin

  for renglon := 1 to grid.RowCount -1 do
      if Trim(grid.Cells[3,renglon]) = '' then
      begin
         result:= False;
         Exit;
      end;
  result:= True;
end;

procedure TfrmATarifas.sagInfoKeyPress(Sender: TObject; var Key: Char);
begin
 //
 if columna <> 3 then
    Key:= _BLANCO;
 if (not(Key in ['0'..'9','.',#8, #13]))  then
      Key:= _BLANCO;

end;

procedure TfrmATarifas.sagInfoSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
      //ShowMEssage(sagInfo.Cells[0, arow]+' ' + sagInfo.Cells[1, arow]+ ' = ' +sagMio.Cells[0,arow]+ ' ' +sagMio.Cells[1,arow])
      columna:= Acol;
      renglon:= aRow;
end;

end.
