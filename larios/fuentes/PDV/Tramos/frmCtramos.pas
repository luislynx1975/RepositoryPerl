unit frmCtramos;
{
Autor: Gilberto Almanza Maldonado
Descripcion: Catalogo de Tramos.
Jueves, 10 de Septiembre de 2009.
}

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls,  ActnList,     SqlExpr,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, XPStyleActnCtrls, ImgList,
  System.ImageList, System.Actions;

type
  TfrmTramos = class(TForm)
    Panel1: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edIdTramo: TEdit;
    cbOrigen: TComboBox;
    cbDestino: TComboBox;
    edKilometros: TEdit;
    edMinutos: TEdit;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action1: TAction;
    act140: TAction;
    act134: TAction;
    act142: TAction;
    act139: TAction;
    panelDatos: TPanel;
    sagDatos: TStringGrid;
    F5: TAction;
    img_iconos: TImageList;

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sagDatosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Action1Execute(Sender: TObject);
    procedure act140Execute(Sender: TObject);
    procedure act139Execute(Sender: TObject);
    procedure edIdTramoKeyPress(Sender: TObject; var Key: Char);
    Function ExisteTramo(Origen:String ; Destino : String): Integer;
    procedure act142Execute(Sender: TObject);
    procedure F5Execute(Sender: TObject);
    procedure act134Execute(Sender: TObject);
    procedure cbOrigenKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
    Query : TSQLQuery;
    procedure CargaTramos;
    procedure CargaTramo(Renglon: Integer);
    procedure CargaCiudades;
    procedure PasaSiguiente;
    Procedure BuscaTramo(idTramo: String);
    function regresaTramo(origen, destino: String): String ;

  public
    { Public declarations }
  end;

var
  frmTramos: TfrmTramos;
  cbCiudadesMio: TComboBox;
  Columna, Renglon: Integer;
  sqlReplica: String;

implementation

uses comun, DMdb, frmMbusquedas, comunii;

{$R *.dfm}

procedure TfrmTramos.Action1Execute(Sender: TObject);
begin
   Close;
end;

{Procedimiento que permite Guardar la captura como un tramo nuevo
o bien la captura cuando realizamos cambios en un tramo existente}
procedure TfrmTramos.act140Execute(Sender: TObject);
var msg : String;
    idRuta : Integer;
    aux: String;
begin
   if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   if ((cbOrigen.ItemIndex = cbDestino.ItemIndex) or
        (cbOrigen.ItemIndex < 0) or
        (cbDestino.ItemIndex < 0) or
        (Trim(edKilometros.Text)='') or
        (Trim(edMinutos.Text)='') ) then
   begin
     ShowMessage(_INFORMACION_INSUFICIENTE);
     Exit;
   end;
   // obtengo el numero de tramo si existe , -1 si no existe
   idRuta:= existeTramo(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)],
                        cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]);
   // si es ruta es de  nueva creacion y ya existen los tramos
   // o si los tramos ya existen y las rutas visualizada y buscada son distintas
    if ( ((Trim(edIdTramo.Text) = _AUTOMATICO) and (idRuta <> -1) ) or
         ((idRuta <> -1) and  (strToInt(Trim(edIdTramo.Text)) <> idRuta)))then
    begin
      ShowMessage(_INFORMACION_EXISTENTE + ' ('+intToStr(idRuta)+')');
      Exit;
    end;
    // si la ruta es de nueva creacion y los tramos no existen
    if  ((Trim(edIdTramo.Text) = _AUTOMATICO) and (idRuta = -1)) then
    begin
        sql:='INSERT INTO T_C_TRAMO(ID_TRAMO, ORIGEN, DESTINO, KM, MINUTOS) '+
             'SELECT ifnull(Max(ID_TRAMO)+1, 1), '+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
             QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
             Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
             ' FROM T_C_TRAMO; ';
        sqlReplica:='INSERT INTO T_C_TRAMO(ID_TRAMO, ORIGEN, DESTINO, KM, MINUTOS) '+
             'values (%s, '+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
             QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
             Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
             '); ';
        msg:=_AGREGAR_INFORMACION
    end
    //cuando existe el idTramo pero los tramos no se modificaron o
    //cuando el idTramo no existe Y el IdTramo no sea nuevo
    else if  ((strToInt(Trim(edIdTramo.Text)) = idRuta) or
             ((idRuta=-1) and (Trim(edIdTramo.Text) <> _AUTOMATICO))) then
    begin
        sql:= 'UPDATE T_C_TRAMO SET '+
               ' ORIGEN='+
               QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
               ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ' , MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_TRAMO='+ Trim(edIdTramo.Text)+';';
         sqlReplica:='UPDATE T_C_TRAMO SET '+
              ' ORIGEN= '+
              QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
              ', DESTINO= '+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_TRAMO='+ Trim(edIdTramo.Text)+';';
        msg:=_ACTUALIZAR_INFORMACION;
    end;
    if MessageDlg(msg,mtConfirmation, mbOKCancel,0) = mrOK then
       if EjecutaSQL(sql,Query,_LOCAL) then
       begin
           aux:= regresaTramo( QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) ,
                         QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]));
           comunii.replicarTodos(Format(sqlReplica,[aux]));
           ShowMessage(_OPERACION_SATISFACTORIA);
       end;
    if comunii.tipoVentanaTramos = _TIPO_PRE_LLENADO THEN
    begin
       comunii.banderaInsertaTramos:= False;
       CLOSE;
    end;
    panelDatos.Enabled:= True;
    F5Execute(self);
end;

{Procedimiento que realiza la eliminacion del tramo que actualmente
esta visualizado en pantalla}
procedure TfrmTramos.act134Execute(Sender: TObject);
begin
   if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   if edIdTRamo.Text = _AUTOMATICO then exit;
   sql:='DELETE FROM T_C_TRAMO WHERE ID_TRAMO='+ Trim(edIdTramo.Text)+';';
   if MessageDlg(_PREGUNTA_ELIMINA + ' ('+edIdTramo.Text+')',
                 mtWarning,mbOKCancel,0) = mrOK then
       if EjecutaSQL(sql,Query,_LOCAL) then
       begin
           comunii.replicarTodos(sql);
           F5Execute(self);
           ShowMessage(_OPERACION_SATISFACTORIA);
       end;
   CargaTramos;
end;

{Procedimiento que muestra la forma de busqueda para el tema TRAMOS
}
procedure TfrmTramos.act142Execute(Sender: TObject);
begin
  //if not AccesoPermitido(TAction(Sender).Tag,_RECUERDA_TAGS) then
  //      Exit;
  comun.tipoBusqueda := 100; // Busqueda de Tramos
  try
     frmBusqueda := TfrmBusqueda.Create(Self);
     frmBusqueda.ShowModal;
  finally
     frmBusqueda.Free;
     frmBusqueda := nil;
  end;
  if edIdTramo.Text = _AUTOMATICO then
      // no hace nada =)
   else
     BuscaTramo(Trim(edIdTramo.Text));
   
end;
{Procedimiento que prepara la forma para agregar un tramo}
procedure TfrmTramos.act139Execute(Sender: TObject);
begin
   if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   edIdTramo.Text:=_AUTOMATICO;
   panelDatos.Enabled:= False;
   cbOrigen.ItemIndex:= -1;
   cbDestino.ItemIndex:= -1;
   edKilometros.Text:= '';
   edMinutos.Text:='';
   cbOrigen.SetFocus;
end;

{procedimiento para cargar desde la base todos los tramos y limpiar la forma}
procedure TfrmTramos.F5Execute(Sender: TObject);
begin
   CargaTramos;
   edIdTramo.Text:=_AUTOMATICO;
   cbOrigen.ItemIndex := -1;
   cbDestino.ItemIndex := -1;
   edKilometros.Text:='';
   edMinutos.Text:= '';
   sagDatos.Enabled:= True;
end;

{Procedimiento BuscaTramo
Parametro: idTramo de tipo String
Este procedimiento realiza la busqueda de un Tramo y muestra los
datos en el formulario}
procedure TfrmTramos.BuscaTramo(idTramo: String);
begin
    SQL:= 'SELECT  ORIGEN, DESTINO, KM as KMS, MINUTOS From T_C_TRAMO'+
          ' WHERE ID_TRAMO='+ idTramo;
    if EjecutaSQL(sql,Query,_LOCAL) then
    begin
        if Query.Eof then
        begin
          ShowMessage(_INFORMACION_NO_EXISTE);
          edIdTramo.Text:= _AUTOMATICO;
        end
        else
        begin
           edKilometros.Text:= Query.FieldByName('Kms').AsString;
           edMinutos.Text   := Query.FieldByName('Minutos').AsString;
           cbOrigen.ItemIndex:= cbCiudadesMio.Items.IndexOf(Query.FieldByName('Origen').AsString);
           cbDestino.ItemIndex:= cbCiudadesMio.Items.IndexOf(Query.FieldByName('Destino').AsString);
        end;
        Query.Close;
    end;
end;
{Procedimiento que permite realizar la carga de las ciudades almacenadas en la tabla
T_C_TERMINAL en los combos de Origen y Destino de la forma}
Procedure TfrmTramos.CargaCiudades;
begin
   sql:='Select ID_TERMINAL, DESCRIPCION From T_C_TERMINAL WHERE FECHA_BAJA IS NULL;';
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage(_ERR_SQL);
      Exit;
   end;
   cbOrigen.Clear;
   cbDestino.Clear;
   cbCiudadesMio.Clear;
   while not Query.Eof do
   begin
     cbCiudadesMio.Items.Add(Query.FieldByName('ID_TERMINAL').AsString);
     cbOrigen.Items.Add (Query.FieldByName('ID_TERMINAL').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString);
     cbDestino.Items.Add(Query.FieldByName('ID_TERMINAL').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString);
     Query.Next;
   end;
   Query.Close;

end;

{Procedimiento que carga los datos de un tramo seleccionado en el sag de tramos
Parametro: Renglon.
}
procedure TfrmTramos.CargaTramo(Renglon: Integer);
begin
   edIdTramo.Text:= sagDatos.Cells[0,renglon];
   cbDestino.ItemIndex:= cbCiudadesMio.Items.IndexOf(sagDatos.cells[2,renglon]);
   edKilometros.Text:=sagDatos.Cells[3,renglon];
   edMinutos.Text:= sagDatos.Cells[4,renglon];
   cbOrigen.ItemIndex:= cbCiudadesMio.Items.IndexOf(sagDatos.cells[1,renglon]);
end;

{Procedimiento que carga todos los tramos desde la base de datos en el grid}
procedure TfrmTramos.CargaTramos;
begin
    // LLENO EL GRID PARA MOSTRAR AL USUARIO
    SQL:= 'Select ID_TRAMO as TRAMO, ORIGEN, DESTINO, KM as KMS, MINUTOS From T_C_TRAMO ORDER BY 1 ASC;';
    if not EjecutaSQL(sql,Query,_LOCAL) then
    begin
      ShowMessage(_ERR_SQL);
      Exit;
    end;
    LimpiaSag(sagDatos);
    DataSetToSag(Query,sagDatos);
end;

{Procedimiento que permite capturar solo numeros y si es el ultimo cuadro de texto
pregunta si desea guardar la informacion}
procedure TfrmTramos.edIdTramoKeyPress(Sender: TObject; var Key: Char);
begin
   if (not(Key in ['0'..'9','.',#8, #13]))  then
      Key:= Char(0);
   if Key = #13 then
   begin
       if (TEdit(Sender).Tag = 1) then   act140Execute(act140);
       PasaSiguiente;
       exit;
   end;
end;

{Funcion ExisteTramo
Parametros Origen y Destino de tipo String
Resultado: Entero que es el numero de tramo en caso de existir o -1
en caso de que no exista el tramo}
function TfrmTramos.ExisteTramo(Origen:String ; Destino: String): Integer;
begin
  Result:= -1; // si no existe regreso -1
  SQL:='SELECT ID_TRAMO FROM T_C_TRAMO WHERE ORIGEN='+
     QuotedStr(Origen)  +  ' AND DESTINO='+  QuotedStr(Destino);
  if EjecutaSQL(sql,Query,_LOCAL) then
  begin
      if not Query.Eof then
      begin
        cbOrigen.SetFocus;
        Result:= Query.FieldByName('id_tramo').AsInteger;
        //  si existe regreso el numero de tramo.
      end;
      Query.Close;
  end;
end;

procedure TfrmTramos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   gds_actions.clear;
   cbCiudadesMio.Free;
   Query.Destroy;
   comunii.terminalesAutomatizadas.Free;
end;

procedure TfrmTramos.FormCreate(Sender: TObject);
begin
   cbCiudadesMio := TComboBox.Create(Self);
   cbCiudadesMio.Parent:= Self;
   cbCiudadesMio.Visible:= False;
   comunii.terminalesAutomatizadas:=  TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;

end;

procedure TfrmTramos.FormShow(Sender: TObject);
begin
   gds_actions.clear;
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   CargaTramos;
   CargaCiudades;
   edIdTramo.Text:= _AUTOMATICO;
   if comunii.tipoVentanaTramos= _TIPO_PRE_LLENADO then // llenar los datos
   begin
       cbOrigen.ItemIndex:=  cbCiudadesMio.Items.IndexOf(Origen);
       cbDestino.ItemIndex:= cbCiudadesMio.Items.IndexOf(Destino);
       edKilometros.SetFocus;
   end;
end;


{ Procedimiento que mueve el foco al siguiente control }
procedure TfrmTramos.PasaSiguiente;
begin
    Perform(WM_NEXTDLGCTL, 0, 0);   { mueve el foco al siguiente control }
end;

function TfrmTramos.regresaTramo(origen, destino: String): String;
begin
    SQL:= 'Select ID_TRAMO FROM T_C_TRAMO WHERE ORIGEN='+ ORIGEN+
          ' AND DESTINO = '+ DESTINO +';';
    if  EjecutaSQL(sql,Query,_LOCAL) then
       if not query.IsEmpty then
          result:= Query.FieldByName('ID_TRAMO').AsString
       else
          result:= ''
    else
        result:= '';

end;

{Cada que selecciono un renglon del grid de los tramos cargo los datos de ese
tramo especifico}
procedure TfrmTramos.sagDatosSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  CargaTramo(ARow);
end;

procedure TfrmTramos.cbOrigenKeyPress(Sender: TObject; var Key: Char);
begin
   if key= #13 then
      PasaSiguiente;
end;

end.
