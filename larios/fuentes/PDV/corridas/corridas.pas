unit corridas;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, lsCombobox,  ToolWin, ActnMan, ActnCtrls,
  ActnList, PlatformDefaultStyleActnCtrls, ExtCtrls, XPMan, System.Actions,
  Data.SqlExpr;

type
  TfrmCorridas = class(TForm)
    GroupBox1: TGroupBox;
    dtpFechaInicio: TDateTimePicker;
    dtpFechaFin: TDateTimePicker;
    cbxCorrida: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    cbCorridas: TlsComboBox;
    cbxServicio: TCheckBox;
    cbServicios: TlsComboBox;
    ActionManager: TActionManager;
    acSalir: TAction;
    ActionToolBar1: TActionToolBar;
    acGenerar: TAction;
    pEstatus: TPanel;
    acUltimaCorrida: TAction;
    acHayVentaPara: TAction;
    acEliminarCorridas: TAction;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acSalirExecute(Sender: TObject);
    procedure acGenerarExecute(Sender: TObject);
    procedure excluyentes(Sender: TObject);
    procedure acUltimaCorridaExecute(Sender: TObject);
    procedure acHayVentaParaExecute(Sender: TObject);
    procedure acEliminarCorridasExecute(Sender: TObject);
  private
    lq_query : TSQLQuery;
    actualizandoCheckBoxes : Boolean;
    fechaUltimaCorrida : TDate;
    Procedure inicializar;
    Procedure cargarCorridasDe(id_terminal : String);
    Function validarCriteriosDeBusqueda : Boolean;
    Function corridasHasta : TDate;
    Function hayVenta : Integer;
  public
    { Public declarations }
  end;

var
  frmCorridas: TfrmCorridas;


CONST
 _SER_SERVICIO_ALL  = 'SELECT TIPOSERVICIO, ABREVIACION FROM SERVICIOS WHERE TIPOSERVICIO > 0 AND FECHA_BAJA IS NULL ORDER BY 1;';
 _ULTIMA_CORRIDA_GENERADA = 'SELECT MAX(FECHA) AS FECHA FROM PDV_T_CORRIDA;';
 _ERROR = MB_ICONERROR;
 _ATENCION = MB_ICONWARNING;
 _OK = MB_ICONASTERISK;

implementation

uses comun, DMdb;

{$R *.dfm}

{ TfrmCorridas }

procedure TfrmCorridas.acEliminarCorridasExecute(Sender: TObject);
var
 sp : TSQLStoredProc;
 inicio : TDateTime;
 total : Integer;
begin
 if not AccesoPermitido(181, True) then
   exit;
 if not validarCriteriosDeBusqueda then
   exit;

 total := hayVenta;
 if total > 0 then Begin
   Application.MessageBox(PWideChar(format('Hay %d asientos vendidos o reservados, así que no se pueden eliminar estas corridas.',[total])),'Atención', _ATENCION);
   exit;
 End;

 If Application.MessageBox(PWideChar(Format('¿Verdaderamente desea eliminar estas corridas?', [])), 'Atención', MB_YESNO + MB_DEFBUTTON2 + MB_ICONQUESTION) <> IDYES then
   exit;

 // Borro las corridas
 sp := TSQLStoredProc.Create(Self);
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_BORRAR_CORRIDAS';
   sp.Params.ParamByName('_FECHA_INICIO').AsDate := dtpFechaInicio.Date;
   sp.Params.ParamByName('_FECHA_FIN').AsDate := dtpFechaFin.Date;
   sp.Params.ParamByName('_ID_CORRIDA').AsString := '';
   sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := 0;
   sp.Params.ParamByName('_ID_TERMINAL').AsString := gs_terminal;
   if cbxCorrida.Checked then
     sp.Params.ParamByName('_ID_CORRIDA').AsString := cbCorridas.CurrentID
   else if cbxServicio.Checked then
     sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := StrToInt(cbServicios.CurrentID);
   sp.ExecProc;
   Application.MessageBox(PWideChar(Format('Corridas eliminadas.', [])), 'Atención',_ATENCION);
 finally
   sp.Free;
 end;
end;

procedure TfrmCorridas.acGenerarExecute(Sender: TObject);
var
 sp : TSQLStoredProc;
 inicio : TDateTime;
 total : Integer;
begin
 if not AccesoPermitido(175, True) then
   exit;
 if not validarCriteriosDeBusqueda then
   exit;

 total := hayVenta;
 if total > 0 then Begin
   Application.MessageBox(PWideChar(format('Hay %d asientos vendidos o reservados, así que no se pueden regenerar estas corridas.',[total])),'Atención', _ATENCION);
   exit;
 End;


 // Borro las corridas
 sp := TSQLStoredProc.Create(Self);
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_BORRAR_CORRIDAS';
   sp.Params.ParamByName('_FECHA_INICIO').AsDate := dtpFechaInicio.Date;
   sp.Params.ParamByName('_FECHA_FIN').AsDate := dtpFechaFin.Date;
   sp.Params.ParamByName('_ID_CORRIDA').AsString := '';
   sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := 0;
   sp.Params.ParamByName('_ID_TERMINAL').AsString   := gs_terminal;
   if cbxCorrida.Checked then
     sp.Params.ParamByName('_ID_CORRIDA').AsString := cbCorridas.CurrentID
   else if cbxServicio.Checked then
     sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := StrToInt(cbServicios.CurrentID);
   sp.ExecProc;
 finally
   sp.Free;
 end;

 // Genero las corridas;
 sp := TSQLStoredProc.Create(Self);
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_GENERAR_CORRIDAS';
   sp.Params.ParamByName('_ID_TERMINAL').AsString := gs_terminal;
   sp.Params.ParamByName('_FECHA_INICIO').AsDate := dtpFechaInicio.Date;
   sp.Params.ParamByName('_FECHA_FIN').AsDate := dtpFechaFin.Date;
   sp.Params.ParamByName('_ID_CORRIDA').AsString := '';
   sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := 0;
   if cbxCorrida.Checked then
     sp.Params.ParamByName('_ID_CORRIDA').AsString := cbCorridas.CurrentID
   else if cbxServicio.Checked then
     sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := StrToInt(cbServicios.CurrentID);
   pEstatus.Visible := True;
   pEstatus.Align := alClient;
   Refresh;
   try
     inicio := now;
     sp.ExecProc;
     Application.MessageBox(PWideChar(format('Corridas generadas satisfactoriamente en : %s min:seg:mili.',[FormatDateTime('nn:ss.zzz', now - inicio)])),'Atención', _OK)
   except on E: Exception do
     Application.MessageBox(PWideChar(format('Error al generar las corridas : %s %s ',[#10#13, e.Message])),'Error', _ERROR);
   end;
 finally
   pEstatus.Visible := False;
   sp.Free;
 end;
end;


procedure TfrmCorridas.acHayVentaParaExecute(Sender: TObject);
var
 total : Integer;
begin
 if not validarCriteriosDeBusqueda then
   exit;
 total := hayVenta;
 if total < 1 then
   Application.MessageBox(PWideChar(format('NO hay venta para los criterios de búsqueda dados.',[])),'Atención', _ATENCION)
 else
   Application.MessageBox(PWideChar(format('Hay %d asientos vendidos o reservados para los criterios de búsqueda dados.',[total])),'Atención', _ATENCION)
end;

procedure TfrmCorridas.acSalirExecute(Sender: TObject);
begin
 Close;
end;

procedure TfrmCorridas.acUltimaCorridaExecute(Sender: TObject);
begin
 if EjecutaSQL(_ULTIMA_CORRIDA_GENERADA, lq_query,_LOCAL) then
   if lq_query.Eof then
     Application.MessageBox(PWideChar(format('No existen corridas generadas.',[])),'Atención', _ATENCION)
   else
     Application.MessageBox(PWideChar(format('Corridas generadas hasta : %s (dia/mes/año))',[FormatDateTime('DD/MM/YYYY', lq_query.FieldByName('FECHA').AsDateTime)])),'Atención', _ATENCION);
   lq_query.Close;
end;

procedure TfrmCorridas.cargarCorridasDe(id_terminal : String);
var
 sp : TSQLStoredProc;
begin
 sp := TSQLStoredProc.Create(nil);
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_CORRIDAS_PARA';
   sp.Params.ParamByName('_ID_TERMINAL').AsString := id_terminal;
   sp.Open;
   sp.First;
   cbCorridas.Clear;
   while not sp.Eof do begin
      try
         cbCorridas.Add(sp['ID_CORRIDA'] + ' ' + FormatDateTime('HH:nn', sp['HORA'])  + ' (' +
                        sp['ORIGEN'] + '-' + sp['DESTINO'] + ') ' + sp['ABREVIACION']  , sp['ID_CORRIDA']);
      except
            ;
      end;
     sp.Next;
   end;
 finally
   sp.Free;
 end;
end;

function TfrmCorridas.corridasHasta: TDate;
begin
 if EjecutaSQL(_ULTIMA_CORRIDA_GENERADA, lq_query,_LOCAL) then
   if VarIsNull(lq_query.FieldByName('FECHA').AsVariant) then
     result := now()
   else
     result :=  lq_query.FieldByName('FECHA').AsDateTime;
   lq_query.Close;
end;

procedure TfrmCorridas.excluyentes(Sender: TObject);
begin
 if actualizandoCheckBoxes then
   exit;
 actualizandoCheckBoxes := True;
 if TCheckBox(Sender).Name = 'cbxCorrida' then
   cbxServicio.Checked := (not cbxCorrida.Checked) and cbxCorrida.Checked
 else
   cbxCorrida.Checked := (not cbxServicio.Checked) and cbxServicio.Checked;
 actualizandoCheckBoxes := False;
end;

procedure TfrmCorridas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 gds_actions.ID.Clear;
 gds_actions.Value.Clear;
 lq_query.Close;
 lq_query.Free;
end;

procedure TfrmCorridas.FormShow(Sender: TObject);
begin
 gds_actions.ID.Clear;
 gds_actions.Value.Clear;
 lq_query := TSQLQuery.Create(nil);
 lq_query.SQLConnection := DM.Conecta;
 inicializar;
end;

function TfrmCorridas.hayVenta : Integer;
var
 sp : TSQLStoredProc;
begin
 sp := TSQLStoredProc.Create(Self);
 try
   sp.SQLConnection := dm.Conecta;
   sp.close;
   sp.StoredProcName := 'PDV_HAY_VENTA_PARA';
   sp.Params.ParamByName('_FECHA_INICIO').AsDate := Trunc(dtpFechaInicio.Date);
   sp.Params.ParamByName('_FECHA_FIN').AsDate := Trunc(dtpFechaFin.Date);
   sp.Params.ParamByName('_ID_CORRIDA').AsString := '';
   sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := 0;
   sp.Params.ParamByName('_ID_TERMINAL').AsString := gs_terminal;
   if cbxCorrida.Checked then
     sp.Params.ParamByName('_ID_CORRIDA').AsString := cbCorridas.CurrentID
   else if cbxServicio.Checked then
     sp.Params.ParamByName('_TIPOSERVICIO').AsInteger := StrToInt(cbServicios.CurrentID);
   sp.Open;
   sp.First;
   Result := sp['TOTAL'];
 finally
   sp.Free;
 end;
end;

procedure TfrmCorridas.inicializar;
begin
 actualizandoCheckBoxes := False;
 cargarCorridasDe(gs_terminal);
 if EjecutaSQL(_SER_SERVICIO_ALL,lq_query,_LOCAL)then
   LlenarComboBox(lq_query, cbServicios, True);
 fechaUltimaCorrida :=  corridasHasta;
 dtpFechaInicio.Date := fechaUltimaCorrida + 1;
 dtpFechaFin.Date := fechaUltimaCorrida + 16;
end;

function TfrmCorridas.validarCriteriosDeBusqueda: Boolean;
begin
 fechaUltimaCorrida :=  corridasHasta;
 if dtpFechaInicio.Date > dtpFechaFin.Date then Begin
   Application.MessageBox(PWideChar(format('Existe un error en el rango de fechas.',[])),'Atención', _ATENCION);
   result := False;
{
 End else if dtpFechaInicio.Date <= fechaUltimaCorrida then Begin
   Application.MessageBox(PWideChar(format('Ya existen corridas para parte de este rango de fechas.',[])),'Atención', _ATENCION);
   result := False;
}
 End else if (cbxCorrida.Checked) and (cbCorridas.ItemIndex < 0) then begin
   Application.MessageBox(PWideChar(format('Existe un error al seleccionar la corrida.',[])),'Atención', _ATENCION);
   result := False;
 End else if (cbxServicio.Checked) and (cbServicios.ItemIndex < 0) then begin
   Application.MessageBox(PWideChar(format('Existe un error al seleccionar el servicio.',[])),'Atención', _ATENCION);
   result := False;
 end;
end;

end.
