unit frmAdministracionCortes;
{Autor: Gilberto Almanza Maldonado
Fecha: Jueves 22 de Julio de 2010, 11:17 hrs
Descripcion: Modulo que permite la administracion de los cortes que
             no han sido procesados aun, intependientemente la fecha.
}

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ActnList, PlatformDefaultStyleActnCtrls,
  ActnMan, System.Actions, Data.SqlExpr;

type
  TfrmAdministracionCorte = class(TForm)
    Label1: TLabel;
    lblTerminal: TLabel;
    lscbPromotores: TlsComboBox;
    Label2: TLabel;
    Button1: TButton;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Button2: TButton;
    procedure Action2Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function CargaPromotores(lscb: TlsComboBox): Boolean;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmAdministracionCorte: TfrmAdministracionCorte;
  Query: TSQLQuery;
implementation

uses comun, comunii, DMdb, Urecoleccion;

{$R *.dfm}

procedure TfrmAdministracionCorte.Action1Execute(Sender: TObject);
begin
  if lscbPromotores.ItemIndex < 0  then
  begin
    ShowMessage(comunii._FALTA_PROMOTOR);
    Exit;
  end;
  if MessageDlg(Format(_PREGUNTA_PRE_CORTAR,[lscbPromotores.CurrentId]), mtConfirmation,mbOKCancel,0) = mrOK then
  begin
     sql:='UPDATE PDV_T_CORTE '+
          ' SET ESTATUS='+ comunii._PROCESO_DE_CORTE+
          ' WHERE ID_TERMINAL='+ QuotedStr(gs_terminal) + ' AND ' +
          ' ID_CORTE ='+ lscbPromotores.CurrentID;
     if ejecutaSQL(sql,Query,_LOCAL) then
        ShowMEssage(comunii._OPERACION_SATISFACTORIA)
     else
        ShowMessage(Comunii._PROCESO_FALLO);
  end;
  cargaPromotores(lscbPromotores);
end;

procedure TfrmAdministracionCorte.Action2Execute(Sender: TObject);
begin
   Close;
end;

procedure TfrmAdministracionCorte.Button1Click(Sender: TObject);
begin
   cargaPromotores(lscbPromotores);
end;

function TfrmAdministracionCorte.CargaPromotores(lscb: TlsComboBox): Boolean;
begin
{funcion que llena un lscb con los promotores que no han sido procesados y
aun estan pendientes de procesar}
sql:='SELECT  U.NOMBRE, U.TRAB_ID , C.ID_CORTE, C.FECHA_INICIO '+
        ' FROM PDV_T_CORTE AS C JOIN PDV_C_USUARIO AS U ON (U.TRAB_ID = C.ID_EMPLEADO) '+
        ' WHERE C.ESTATUS IN ' + '(' + _NO_LISTO + ')' +
        ' AND ' +
        'C.ID_TERMINAL='+QuotedStr(gs_terminal)+';';
if not EjecutaSQL(sql,Query,_LOCAL) then
  begin
     ShowMessage('Error al cargar la lista de promotores no procesados.');
     Exit;
  end;
lscbPromotores.Clear;
while not Query.Eof do
begin
    lscb.Add(query.FieldByName('ID_CORTE').AsString + ' ' +
             query.FieldByName('NOMBRE').AsString + ' ' +
             VarToStr(FormatDateTime('dd/mm/yyyy',query.FieldByName('FECHA_INICIO').AsDateTime)),
             query.FieldByName('ID_CORTE').AsString);
    Query.Next;
end;

end;

procedure TfrmAdministracionCorte.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   {destruyo el componente Query cuando salgo de la forma}
  Query.Destroy;
end;

procedure TfrmAdministracionCorte.FormCreate(Sender: TObject);
begin
   {creo el componente query y le asigno la coneccion}
   Query := TSQLQuery.Create(self);
   Query.SQLConnection:= dm.Conecta;
end;

procedure TfrmAdministracionCorte.FormShow(Sender: TObject);
begin
   lblTerminal.Caption:=  urecoleccion.RegresaDatosLocales;
   if lblTerminal.Caption = urecoleccion._ERROR_VALORES then
   begin
      action1.Enabled:=False;
      exit;
   end;
   CargaPromotores(lscbPromotores);
end;

end.
