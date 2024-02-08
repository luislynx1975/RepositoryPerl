unit frmCTarifas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, lsCombobox, Grids, Aligrid, SqlExpr,
  PlatformDefaultStyleActnCtrls, ActnList, ActnMan, ImgList;

type
  TfrmCTarifa = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    FI: TDateTimePicker;
    FF: TDateTimePicker;
    lscbServicio: TlsComboBox;
    sagInfo: TStringAlignGrid;
    Label1: TLabel;
    Label2: TLabel;
    lscbOrigen: TlsComboBox;
    lscbDestino: TlsComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button1: TButton;
    Button2: TButton;
    ActionManager1: TActionManager;
    acBuscar: TAction;
    sb: TStatusBar;
    Action1: TAction;
    img_iconos: TImageList;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure acBuscarExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCTarifa: TfrmCTarifa;

implementation

uses uTarifas, DMdb , comun;

{$R *.dfm}

procedure TfrmCTarifa.acBuscarExecute(Sender: TObject);
begin
    LimpiaSag(sagInfo);
    sb.Panels[0].Text:= '';
    if FI.Date > FF.Date then
    begin
      ShowMessage(uTarifas._FECHAS_ERROR);
      Exit;
    end;
    // PRIMERO EVALUO LAS OPCIONES QUE TENGO CON DATOS
    // si ningun filtro tiene datos
    if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex < 0) and (lscbServicio.ItemIndex<0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
    // si el destino existe pero no el origen NI tampoco el Servicio
    if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex >= 0) and (lscbServicio.ItemIndex<0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
    // si el origen existe pero no el destino NI tampoco el Servicio
    if ((lscbOrigen.ItemIndex >=  0) and (lscbDestino.ItemIndex < 0) and (lscbServicio.ItemIndex<0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' AND T.ORIGEN='+ QuotedStr(lscbOrigen.CurrentID) +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
    // si el origen existe y el destino tambien pero no el servicio
    if ((lscbOrigen.ItemIndex >=  0) and (lscbDestino.ItemIndex >= 0) and (lscbServicio.ItemIndex<0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' AND T.ORIGEN='+ QuotedStr(lscbOrigen.CurrentID) +
            ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
    /////
    // si el destino existe pero no el origen y si el Servicio
    if ((lscbOrigen.ItemIndex < 0) and (lscbDestino.ItemIndex >= 0) and (lscbServicio.ItemIndex>=0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
            ' AND S.TIPOSERVICIO='+ lscbServicio.CurrentID +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
    // si el origen existe pero no el destino y si el Servicio
    if ((lscbOrigen.ItemIndex >=  0) and (lscbDestino.ItemIndex < 0) and (lscbServicio.ItemIndex>=0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' AND T.ORIGEN='+ QuotedStr(lscbOrigen.CurrentID) +
            ' AND S.TIPOSERVICIO='+ lscbServicio.CurrentID +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
    // si el origen existe y el destino tambien y si el servicio
    if ((lscbOrigen.ItemIndex >=  0) and (lscbDestino.ItemIndex >= 0) and (lscbServicio.ItemIndex>=0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' AND T.ORIGEN='+ QuotedStr(lscbOrigen.CurrentID) +
            ' AND T.DESTINO='+ QuotedStr(lscbDestino.CurrentID) +
            ' AND S.TIPOSERVICIO='+ lscbServicio.CurrentID +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
     // si el origen no existe y el destino tampoco y si el servicio
    if ((lscbOrigen.ItemIndex <  0) and (lscbDestino.ItemIndex < 0) and (lscbServicio.ItemIndex>=0)) then
    begin
      SQL:= 'SELECT  FECHA_HORA_APLICA, T.ORIGEN, T.DESTINO,  S.DESCRIPCION, TD.MONTO '+
            ' FROM PDV_C_TARIFA_D AS TD JOIN PDV_C_TARIFA AS TA ON (TD.ID_TARIFA= TA.ID_TARIFA) '+
            ' JOIN SERVICIOS AS S ON (S.TIPOSERVICIO = TA.ID_SERVICIO) '+
            ' JOIN T_C_TRAMO AS T ON (T.ID_TRAMO = TA.ID_TRAMO) '+
            ' WHERE  FECHA_HORA_APLICA BETWEEN '+ QuotedStr(FormatDateTime('yyyy/mm/dd 00:00:00',FI.Date)) +
            ' AND ' + QuotedStr(FormatDateTime('yyyy/mm/dd 23:59:59',FF.Date)) +
            ' AND S.TIPOSERVICIO='+ lscbServicio.CurrentID +
            ' ORDER BY T.ORIGEN, T.DESTINO, FECHA_HORA_APLICA; ';
    end;
    ///
   EjecutaSQL(Sql, QueryT,_LOCAL);
   DataSetToSag(QueryT,sagInfo);
   sb.Panels[0].Text:= intToStr(sagInfo.RowCount-1)+ ' registros.';
end;

procedure TfrmCTarifa.Action1Execute(Sender: TObject);
begin
   Close;
end;

procedure TfrmCTarifa.Button1Click(Sender: TObject);
begin

   acBuscarExecute(Sender);
end;

procedure TfrmCTarifa.Button2Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmCTarifa.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   uTarifas.QueryT.Free;
end;

procedure TfrmCTarifa.FormCreate(Sender: TObject);
begin
   uTarifas.QueryT:= TSQLQuery.Create(Self);
   uTarifas.QueryT.SQLConnection:= dm.Conecta;

   CargaCiudad(lscbOrigen);
   CargaCiudad(lscbDestino);
   CargaServicio(lscbServicio);
   FI.Date:= now;
   FF.Date:= now;
end;

end.
