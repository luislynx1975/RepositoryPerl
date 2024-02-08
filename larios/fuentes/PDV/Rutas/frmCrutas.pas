unit frmCrutas;
{
Autor: Gilberto Almanza Maldonado
Fecha: 25 de Noviembre
Descripcion: forma para administrar las Rutas
}

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Grids, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  ActnList,  XPStyleActnCtrls, DB, ImgList, System.ImageList, System.Actions,
  Data.SqlExpr;


Const
  _AVISO_INFO_INCONSISTENTE = 'Ocurrio un error: Existen ciudades no continuas. '+ char(13) +
                              'O existen ciudades que se tocan mas de una ocasion.'+ char(13)+
                              '¿Desea continuar? ';
  _AVISO_INFO_INCORRECTA= 'Los tramos no son continuos, imposible continuar.';
  _TODO_OK = 1;
  _NO_OK   = 0;
  _PASA_CON_AUTORIZACION = 2;
  _TRAMO_INICIAL= 'El primer tramo debe iniciar en el punto origen.';
  _CONTINUIDAD_TRAMOS= 'El siguiente tramo debe iniciar con el fin del anterior.';
  _ELIMINAR_TODOS_TRAMOS= '¿Desea realmente eliminar TODOS los tramos de la ruta?';
  _ELIMINAR_ALGUNOS_TRAMOS='¿Desea eliminar los tramos a partir del registro seleccionado?';
  _ACTUALIZACION_RUTA ='El numero de Ruta existe ¿Desea  actualizar los datos de la ruta %s?';
  _AGREGA_RUTA_EXISTENTE = 'El numero de Ruta existe ¿Desea insertar los datos de la ruta %s?';
  _PREGUNTA_ELIMINA_RUTA = '¿Realmente desea eliminar la información mostrada en pantalla de la ruta  %s '+char(13)+
                           'Origen %s y Destino %s?';
  _GUARGAR_TRAMOS = 'Se guardarán los tramos capturados/modificados para la ruta numero %s.'+Char(13)+
                    '¿Desea continuar?';
  _ERROR_GUARDAR_TRAMOS = 'Ocurrio un error al guardar los tramos de la ruta %s intente nuevamente.';
  _FALTA_CIUDAD = 'Falta ciudad para continuar.';
type
  _CIUDADES = record
     ciudad: string;
     pasos: integer;
  end;

  TfrmRutas = class(TForm)
    Panel1: TPanel;
    panelRuta: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cbOrigen: TComboBox;
    cbDestino: TComboBox;
    edKilometros: TEdit;
    edMinutos: TEdit;
    edIdRuta: TEdit;
    ActionManager1: TActionManager;
    Action1: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    act129: TAction;
    act132: TAction;
    act131: TAction;
    act133: TAction;
    Refrescar: TAction;
    act125: TAction;
    panelTramos: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    cbOrigenTramo: TComboBox;
    cbDestinoTramo: TComboBox;
    btnAgrega: TButton;
    btnBorrarTramos: TButton;
    btnGuardar: TButton;
    panelRutas: TPanel;
    sagRutas: TStringGrid;
    act141: TAction;
    act135: TAction;
    act130: TAction;
    act136: TAction;
    sagTramos: TStringGrid;
    act137: TAction;
    Label10: TLabel;
    lblEstado: TLabel;
    img_iconos: TImageList;
    procedure Action1Execute(Sender: TObject);
    procedure act125Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sagRutasSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sagTramosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure act129Execute(Sender: TObject);
    procedure act133Execute(Sender: TObject);
    procedure edIdRutaKeyPress(Sender: TObject; var Key: Char);
    procedure act131Execute(Sender: TObject);
    procedure RefrescarExecute(Sender: TObject);
    procedure act132Execute(Sender: TObject);
    procedure act130Execute(Sender: TObject);
    procedure act136Execute(Sender: TObject);
    procedure act135Execute(Sender: TObject);
    procedure cbDestinoTramoKeyPress(Sender: TObject; var Key: Char);
    procedure act141Execute(Sender: TObject);
    procedure act137Execute(Sender: TObject);

  private
    { Private declarations }
    Query, QueryRutas : TSQLQuery;

    Querys: TSQLQuery;
    Procedure CargaRutas;
    Procedure CargaRutaD(IdRuta: String);
    procedure CargaCiudades;
    procedure PasaSiguiente;
    Function  ExisteRuta(Origen: String; Destino:String):Integer;
    Function  RegresaUltimoTramo: String;
    Function  ExisteTramo(Origen, Destino: String): Integer;
    procedure AgregaTramo(idTramo: Integer);
    Function  BuscaRutaSag(idRuta: String): Boolean;
    Procedure CargaTramos(idRuta: String);
    Function  RevisaCiudades(sag: TStringGrid):byte;
    Procedure LimpiaSag(sag: TStringGrid);
    Procedure EliminaTramos;
    Procedure CargaRutaXid(IdRuta: String);
    procedure LimpiaForma;
    Function  RegresaTramos(idRuta: String): String;
    function RegresaRuta(origen, destino, kilometros, minutos: string): string;
  public
    { Public declarations }
    sagRutasMio: TStringGrid;
    sagTramosMio: TStringGrid;
    EsRefresh: Boolean;
  end;


var
  frmRutas: TfrmRutas;
  ciudades: Array of _CIUDADES;
  cbCiudadesMio: TComboBox;
  renglon, columna: Integer;
  repetidos: TStringList;
  renglonTramos, columnaTramos : Integer;
  esNuevaRuta: Boolean;
  sqlReplica: String;
implementation

uses frmCtramos,  DMdb, frmMbusquedas, comunii, comun;

{$R *.dfm}

procedure TfrmRutas.Action1Execute(Sender: TObject);
begin
   Close;
end;

{procedimiento que prepara la forma para agregar una  ruta}
procedure TfrmRutas.act129Execute(Sender: TObject);
begin
   if not AccesoPermitido(TAction(Sender).Tag,_RECUERDA_TAGS) then
        Exit;
   edIdRuta.Text:=_AUTOMATICO;
   cbOrigen.ItemIndex:=  -1;
   cbDestino.ItemIndex:= -1;
   edKilometros.Text:='';
   edMinutos.Text:='';
   cbOrigenTramo.ItemIndex:= -1;
   cbDestinoTramo.ItemIndex:=-1;
   LimpiaSag(sagTramos);
   sagTramos.RowCount:=1;
   LimpiaSag(sagTramosMio);
   panelRuta.Enabled := True; // Habilito la seccion de Rutas para realizar la captura de datos
   PanelRutas.Enabled:= False; // deshabilito el panel para que no haya errores de captura
   lblEstado.Caption:='Agregando Ruta...';
   cbOrigen.SetFocus;
   esNuevaRuta:= True;
end;

{procedimiento que elimina la ruta mostrada en el formulario}
procedure TfrmRutas.act132Execute(Sender: TObject);
begin
   if not AccesoPermitido(TAction(Sender).Tag, _NO_RECUERDA_TAGS) then
        Exit;
   if edIdRuta.Text = _AUTOMATICO then exit;
   if MessageDlg(Format(_PREGUNTA_ELIMINA_RUTA,[EdIdRuta.Text, cbOrigen.text, cbDestino.Text]) +
                 char(13) +  'Pasos : ' + RegresaTramos(EdIdRuta.Text)  ,
                 mtWarning,mbOKCancel,0) = mrCancel then
       Exit;
   sql:='DELETE FROM T_C_RUTA   WHERE ID_RUTA= '+ EdIdRuta.Text+';';
   if  EjecutaSQL(sql, Query,_LOCAL) then
   BEGIN
        comunii.replicarTodos(sql);
        SQL:='DELETE FROM T_C_RUTA_D WHERE ID_RUTA= '+ EdIdRuta.Text+';';
        if  EjecutaSQL(sql, Query,_LOCAL) then
        begin
           comunii.replicarTodos(sql);
           LimpiaForma;
           ShowMessage(_OPERACION_SATISFACTORIA);
        end;
   END;
   esRefresh:= True;
   CargaRutas;
   LimpiaSag(sagTramos);
   esRefresh:= False;
end;

{procedimiento que Guarda una ruta, evaluando si la ruta existe, si existiera
si desea agregar una nueva ruta con el mismo rigen-destino pero con pasos
diferentes, si es totalmente nueva, etc}

procedure TfrmRutas.act131Execute(Sender: TObject);
var idRuta: Integer;
    msg , AUX: String;
begin
  if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
  if ((cbOrigen.ItemIndex = cbDestino.ItemIndex) or
        (cbOrigen.ItemIndex < 0) or
        (cbDestino.ItemIndex < 0) or
        (Trim(edKilometros.Text)='') or
        (Trim(edMinutos.Text)='') or
        (panelRuta.Enabled = False)) then
   begin
     ShowMessage(_INFORMACION_INSUFICIENTE);
     Exit;
   end;
   idRuta:= ExisteRuta(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)],
                        cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]);

   // el -1 me indica que la ruta NO EXISTE
   // el -2 me indica que el origen y destino para esa ruta no es UNICO
   // el -3 me indica que el origen destino no existe pero la ruta ya estaba creada

   // si la ruta es nueva completamente y la estoy recien capturando, el
   // query sera INSERT
   if  ((Trim(edIdRuta.Text) = _AUTOMATICO) and (idRuta = -1)) then
    begin
        Sql:='INSERT INTO T_C_RUTA(ID_RUTA, ORIGEN, DESTINO, KM, MINUTOS) '+
             'SELECT ifnull(Max(ID_RUTA)+1, 1), '+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
             QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
             Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
             ' FROM T_C_RUTA; ';
        sqlReplica:= 'INSERT INTO T_C_RUTA(ID_RUTA, ORIGEN, DESTINO, KM, MINUTOS) '+
             'values (%s, '+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
             QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
             Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
             ') ';
        msg:=_AGREGAR_INFORMACION;
        //Falta Agregar el detalle de los tramos de esta ruta...
    end;
    // si la ruta NO ES NUEVA, ESTA UNA SOLA VEZ ... Y
    // la busqueda es igual a la que se esta mostrando en pantalla
    if ((idRuta <> -1) and (idRuta <> -2) and
        (idRuta = StrToInt(Trim(edIdRuta.Text)))
        ) then
    begin
        Sql:='UPDATE T_C_RUTA SET ORIGEN='+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
             ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_RUTA='+ intToStr(IdRuta)+';';
        sqlReplica:= 'UPDATE T_C_RUTA SET ORIGEN='+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
             ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_RUTA='+ intToStr(IdRuta)+';';
        msg:=_ACTUALIZAR_INFORMACION;
        //Falta modificar los tramos si hubo cambios
    end;
    // si la ruta existe Y los tramos modificados no existen y solo se requiere hacer modificacion
    if (idRuta = -3) then
    begin
        Sql:='UPDATE T_C_RUTA SET ORIGEN='+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
             ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_RUTA='+ Trim(edIdRuta.Text)+';';
        sqlReplica:= 'UPDATE T_C_RUTA SET ORIGEN='+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
             ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_RUTA='+ Trim(edIdRuta.Text) +';';
        msg:=_ACTUALIZAR_INFORMACION;
        //Falta modificar los tramos si hubo cambios
    end;

    // si la ruta NO ES NUEVA y existe mas DE UNA VEZ
    if ((Trim(edIdRuta.Text) <> _AUTOMATICO) and  (idRuta = -2)) then
    begin
        if MessageDlg(Format(_ACTUALIZACION_RUTA,[Trim(edIdRuta.Text)] ),mtWarning,mbOKCancel,0) = mrCancel then
           Exit;
        Sql:='UPDATE T_C_RUTA SET ORIGEN='+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
             ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_RUTA='+ Trim(edIdRuta.Text)+';';
        sqlReplica:= 'UPDATE T_C_RUTA SET ORIGEN='+
             QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
             ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
             ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
             ' WHERE ID_RUTA='+ Trim(edIdRuta.Text)+';';
        msg:=_ACTUALIZAR_INFORMACION;
        //Falta modificar los tramos si hubo cambios
    end;
    // si la ruta no es nueva pero la estoy capturando como si lo fuera...
    // y solo hay UNA SOLA RUTA CON ESE ORIGEN-DESTINO
    if ((Trim(edIdRuta.Text) = _AUTOMATICO) and (idRuta <> -1)
        and (idRuta <> -2) ) then
    begin
       if MessageDlg(Format(_AGREGA_RUTA_EXISTENTE,[cbOrigen.Text+'-'+cbdestino.Text] ),mtWarning,mbOKCancel,0) = mrOk then
       begin
           Sql:='INSERT INTO T_C_RUTA(ID_RUTA, ORIGEN, DESTINO, KM, MINUTOS) '+
                'SELECT ifnull(Max(ID_RUTA)+1, 1), '+
                QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
                QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
                Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
                ' FROM T_C_RUTA; ';
           sqlReplica:= 'INSERT INTO T_C_RUTA(ID_RUTA, ORIGEN, DESTINO, KM, MINUTOS) '+
                'values (%s, '+
                QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
                QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
                Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
                ' );';
           msg:=_AGREGAR_INFORMACION;
       end
       else
       begin
          if MessageDlg(Format(_ACTUALIZACION_RUTA,[IntToStr(IdRuta)] ),mtWarning,mbOKCancel,0) = mrCancel then
              Exit;
           Sql:='UPDATE T_C_RUTA SET ORIGEN='+
                QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
                ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
                ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
                ' WHERE ID_RUTA='+ intToStr(IdRuta)+';';
           SqlReplica:='UPDATE T_C_RUTA SET ORIGEN='+
                QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) +
                ', DESTINO='+ QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) +
                ', MINUTOS='+ Trim(edMinutos.Text) + ', KM='+ Trim(edKilometros.Text) +
                ' WHERE ID_RUTA='+ intToStr(IdRuta)+';';
           msg:=_ACTUALIZAR_INFORMACION;
           //Falta modificar los tramos si hubo cambios
        end;
       end;
   // si la ruta no es nueva pero la estoy capturando como si lo fuera... y hay mas una
   // ruta con los datos ORIGEN - DESTINO
    if ((Trim(edIdRuta.Text) = _AUTOMATICO) and (idRuta = -2) ) then
     if MessageDlg(Format(_AGREGA_RUTA_EXISTENTE,[cbOrigen.Text+'-'+cbdestino.Text] ),mtWarning,mbOKCancel,0) = mrOk then
     begin
          Sql:='INSERT INTO T_C_RUTA(ID_RUTA, ORIGEN, DESTINO, KM, MINUTOS) '+
               'SELECT ifnull(Max(ID_RUTA)+1, 1), '+
               QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
               QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
               Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
               ' FROM T_C_RUTA; ';
          SqlReplica:='INSERT INTO T_C_RUTA(ID_RUTA, ORIGEN, DESTINO, KM, MINUTOS) '+
               'VALUES( %s, '+
               QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]) + ',' +
               QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]) + ',' +
               Trim(edKilometros.Text) + ',' + Trim(edMinutos.Text) +
               '); ';
          msg:=_AGREGAR_INFORMACION;
     end
     else
        Exit;
     if MessageDlg(msg,mtConfirmation,mbOKCancel,0) = mrOK then
       if EjecutaSQL(sql,Query,_LOCAL) then
       begin
          AUX:= regresaRuta(QuotedStr(cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]),
                            QuotedStr(cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]),
                            Trim(edKilometros.Text),
                            Trim(edMinutos.Text));
          comunii.replicarTodos(Format(sqlReplica,[AUX]));
           sql:='SELECT ID_RUTA FROM T_C_RUTA WHERE ID_RUTA='+ AUX +';';
           if EjecutaSQL(sql,Query,_LOCAL) then
           BEGIN
               edIdRuta.Text:= Query.FieldByName('ID_RUTA').AsString;
               CargaRutaXid(Query.FieldByName('ID_RUTA').AsString);
               esRefresh:= True;
               CargaRutas;
               esRefresh:= False;
           END;
           ShowMessage(_OPERACION_SATISFACTORIA);
           esNuevaRuta := False;
           if sagTramos.RowCount= 1 then // and edIdRuta.Text = _AUTOMATICO then
              if MessageDlg(_AGREGAR_TRAMOS,mtWarning,mbOKCancel,0) = mrOK then
              begin
                Act136Execute(act136);
                exit;
              end;
           lblEstado.Caption:='';
           panelRutas.Enabled:= True;
           panelRuta.Enabled:= False;
       end;

end;
{Procedimiento para mostrar el formulario para la busqueda de Rutas}
procedure TfrmRutas.act133Execute(Sender: TObject);
begin
  if not AccesoPermitido(TAction(Sender).Tag,_RECUERDA_TAGS) then
        Exit;
  comun.tipoBusqueda := 200; // Busqueda de Tramos
  edIdRuta.Text:=_AUTOMATICO;
  cbOrigen.ItemIndex:= -1;
  cbDestino.ItemIndex:= -1;
  edKilometros.Text:='';
  edMinutos.Text:='';
  LimpiaSag(sagTramos);
  LimpiaSag(SagTramosMio);
  try
     frmBusqueda := TfrmBusqueda.Create(Self);
     frmBusqueda.ShowModal;
  finally
     frmBusqueda.Free;
     frmBusqueda := nil;
  end;

  if edIdRuta.Text = _AUTOMATICO then
      // no hace nada =)
   else
     CargaRutaXid(Trim(edIdRuta.Text));
end;

procedure TfrmRutas.RefrescarExecute(Sender: TObject);
begin
 EsRefresh:= True;
 LimpiaForma;
 PanelRuta.Enabled:= False;
 PanelTramos.Enabled:=False;
 PanelRutas.Enabled:=True;
 lblEstado.Caption:='';
 LimpiaSag(sagTramos);
 LimpiaSag(SagTramosMio);
 CargaRutas;
 EsRefresh:= False;
end;

{Acceso al catalogo de tramos}
procedure TfrmRutas.act125Execute(Sender: TObject);
begin
 if not AccesoPermitido(TAction(Sender).Tag, _NO_RECUERDA_TAGS) then
        Exit;
   try
        comunii.tipoVentanaTramos:= comunii._TIPO_VACIO;
        frmTramos := TfrmTramos.Create(Self);
        frmTramos.ShowModal;
   finally
        frmTramos.Free;
       frmTramos := nil;
   end;
end;


procedure TfrmRutas.AgregaTramo(idTramo: Integer);
begin
   sagTramos.RowCount:=sagTramos.RowCount+1;
   sagTramosMio.RowCount:= sagTramosMio.RowCount+1;
   if sagTramos.RowCount = 2 then
   begin
     sagTRamos.ColCount:= 3;
     sagTramos.Cells[0,0] := 'Origen';
     sagTramos.Cells[1,0] := 'Destino';
     sagTramos.Cells[2,0] := 'Orden';
    // sagTramos.Cells[3,0] := 'Minutos';
     sagTramos.Cells[0,1] := cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbOrigenTramo.Text)] ;
     sagTramos.Cells[1,1] := cbCiudadesMio.Items[cbDestinoTramo.Items.IndexOf(cbDestinoTramo.Text)] ;
     sagTramos.Cells[2,1] := '0' ;
    // sagTramos.Cells[3,1] := edMinutosTramo.Text;
     sagTramos.RowCount:=sagTramos.RowCount+1;
     // ahora hago lo mismo para el sagMio
     sagTRamosMio.ColCount:= 5 ;
     sagTramosMio.Cells[0,0] := 'IdTramo';
     sagTramosMio.Cells[1,0] := 'Origen';
     sagTramosMio.Cells[2,0] := 'Destino';
   //  sagTramosMio.Cells[3,0] := 'Orden';
    // sagTramosMio.Cells[4,0] := 'MinutosDOrigen';
     sagTramosMio.Cells[0,1] := IntToStr(idTramo) ;    // IDENTIFICADOR DEL TRAMO
     sagTramosMio.Cells[1,1] := cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbOrigenTramo.Text)] ;
     sagTramosMio.Cells[2,1] := cbCiudadesMio.Items[cbDestinoTramo.Items.IndexOf(cbDestinoTramo.Text)] ;
    // sagTramosMio.Cells[4,1] := edMinutosTramo.Text; // MINUTOS DESDE EL ORIGEN
     sagTramosMio.RowCount:=sagTramosMio.RowCount+1;

     exit;
   end;
   sagTramos.Cells[0,sagTramos.RowCount-2] := cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbOrigenTramo.Text)] ;
   sagTramos.Cells[1,sagTRamos.RowCount-2] := cbCiudadesMio.Items[cbDestinoTramo.Items.IndexOf(cbDestinoTramo.Text)] ;
   sagTramos.Cells[2,sagTRamos.RowCount-2] := '0' ;
   //sagTramos.Cells[3,sagTRamos.RowCount-2] := edMinutosTramo.Text;
   // ahora lleno el sagMio
   sagTramosMio.Cells[0,sagTramos.RowCount-2] := IntToStr(idTramo) ;
   sagTramosMio.Cells[1,sagTRamos.RowCount-2] := cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbOrigenTramo.Text)] ;
   sagTramosMio.Cells[2,sagTRamos.RowCount-2] := cbCiudadesMio.Items[cbDestinoTramo.Items.IndexOf(cbDestinoTramo.Text)] ;
   //   sagTramosMio.Cells[4,sagTRamos.RowCount-2] := edMinutosTramo.Text;
   if sagTramos.RowCount>1 then
      sagTramos.FixedRows:= 1;
end;

function TfrmRutas.BuscaRutaSag(idRuta: String): Boolean;
var I: Integer;
begin
   result:= False;
   for I := 1 to sagRutasMio.RowCount  do
      if sagRutasMio.Cells[0,I] = idRuta then
      begin
        result:= true;
        exit;
      end;

end;
{procedimiento que carga las ruas de la tabla T_C_RUTA y las muestra en el grid}
procedure TfrmRutas.CargaRutas;
begin
 // Procedimiento que carga todas las rutas existentes
 //  ID_RUTA,'' - '',
 sql:= 'SELECT CONCAT(ORIGEN,'' - '',DESTINO, '' - '',ID_RUTA) AS RUTA, KM, MINUTOS FROM T_C_RUTA ORDER BY RUTA;';
 if EjecutaSQL(sql,QueryRutas,_LOCAL)then
 begin
//   showmessage(sql);
   LimpiaSag(sagRutas);
   // hay ocasiones que entre estas dos lineas se ejecuta otro query y cambia LO MOSTRADO
   DataSetToSag(QueryRutas,sagRutas);
 end;

 sql:= 'SELECT *, CONCAT(ORIGEN,'' - '',DESTINO, '' - '',ID_RUTA) AS RUTA FROM T_C_RUTA ORDER BY RUTA;';
 if EjecutaSQL(sql,QueryRutas,_LOCAL) then
 begin
//   showmessage(sql);
   LimpiaSag(sagRutasMio);
   DataSetToSag(QueryRutas,sagRutasMio);
 end;

end;

{procedimiento que carga kis tramos de una ruta enviada como parametro en el grid
que visualiza el usuario y en el grid que ocupa el sistema}

procedure TfrmRutas.CargaTramos(idRuta: String);
begin
  SQL:='SELECT T.ORIGEN, T.DESTINO, RD.ORDEN, RD.MIN_TOTAL_ORIGEN '+
      ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
      ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN';
 if EjecutaSQL(sql,Query,_LOCAL) then
 begin
   LimpiaSag(sagTramos);
   DataSetToSag(Query,sagTramos);

 end;
 SQL:='SELECT T.ID_TRAMO, T.ORIGEN, T.DESTINO, RD.ORDEN, RD.MIN_TOTAL_ORIGEN '+
      ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
      ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN';
 if EjecutaSQL(sql,Query,_LOCAL) then
 begin
   LimpiaSag(sagTramosMio);
   DataSetToSag(Query,sagTramosMio);
 end;
 if Query.Eof then     sagTRamosMio.RowCount:=1;

end;

procedure TfrmRutas.edIdRutaKeyPress(Sender: TObject; var Key: Char);
begin
   //si no es un numero, no pinta nada
     if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
   // si es enter  y un edit especifico Guardo Ruta Y Pregunto si desea guardar Tramos
   if ((TEdit(Sender).Tag = 1)  and (key=#13)) then
   begin
       act131Execute(act131); // Guardar Ruta...
       exit;
   end;
   // Si es solo Enter paso al siguiente componente el foco
   if key=#13 then PasaSiguiente;
end;
{Funcion que determina si existe una ruta dependiendo de un Origen y un Destino
enviados como parametros y regresa el identificador de la ruta si es que existe.
Regresa un -1 si no existe,
regresa un -2 y visualiza todos los ids de las rutas que existen con esos datos}

function TfrmRutas.ExisteRuta(Origen, Destino: String): Integer;
var RutasRepetidas: String;
begin
  Result:= -1; // si no existe regreso -1
  sql:='SELECT ID_RUTA '+
       ' FROM T_C_RUTA WHERE ORIGEN='+
       QuotedStr(Origen)  +  ' AND DESTINO='+  QuotedStr(Destino)+';';
  if EjecutaSQL(sql,Query,_LOCAL) then
  begin
      if registrosDe(Query) > 1 then
      begin
         Result:=-2;
         //Regreso -2 si existe mas de una ruta con el mismo origen y destino
         RutasRepetidas:=' * ';
         query.First;
         while not Query.Eof do
         begin
             RutasRepetidas:= RutasRepetidas + Query.FieldByName('ID_RUTA').AsString + ' * ';
             Query.Next;
         end;
         IF EDIDRUTA.Text = _AUTOMATICO THEN
         ShowMessage('Existen ' + intToStr(registrosDe(Query)) + ' Rutas repetidas. '+char(13)+
                     RutasRepetidas  );
         Exit;
      end;
  end;


  SQL:='SELECT ID_RUTA FROM T_C_RUTA WHERE ORIGEN='+
     QuotedStr(Origen)  +  ' AND DESTINO='+  QuotedStr(Destino)+';';
  if EjecutaSQL(sql,Query,_LOCAL) then
  begin
      if not Query.Eof then
      begin
        cbOrigen.SetFocus;
        Result:= Query.FieldByName('id_ruta').AsInteger;
        //  si existe regreso el numero de tramo.
      end
      else
         if edIdRuta.Text <> _AUTOMATICO then
           result:= -3; // indica que el origen-destino no estan dados de alta y
                        // la ruta ya existe, solo sera modificacion.
  end;

end;

 {funcion que determina si existe un tramo mediante un origen y un destino que son
 enviados como parametros, la funcion regresa un -1 si no existe el tramo}
function TfrmRutas.ExisteTramo(Origen, Destino: String): Integer;
begin
  Result:= -1; // si no existe regreso -1
  SQL:='SELECT ID_TRAMO FROM T_C_TRAMO WHERE ORIGEN='+
     QuotedStr(Origen)  +  ' AND DESTINO='+  QuotedStr(Destino);
  if EjecutaSQL(sql,Query,_LOCAL) then
  begin
      if not Query.Eof then
      begin
        cbOrigenTramo.SetFocus;
        Result:= Query.FieldByName('id_tramo').AsInteger;
        //  si existe regreso el numero de tramo.
      end;
      Query.Close;
  end;
end;
{procedimiento que carga todas las terminales en los combos visibles en la
forma y los que usa el sistema no visibles}
procedure TfrmRutas.CargaCiudades;
begin
   sql:='Select ID_TERMINAL, DESCRIPCION From T_C_TERMINAL WHERE FECHA_BAJA IS NULL;';
   if not EjecutaSQL(sql,Query,_LOCAL) then
   begin
      ShowMessage(_ERR_SQL);
      Query.Close;
      Exit;
   end;
   cbOrigen.Clear;
   cbDestino.Clear;
   cbCiudadesMio.Clear;
   while not Query.Eof do
   begin
     cbCiudadesMio.Items.Add(Query.FieldByName('ID_TERMINAL').AsString);
     cbOrigen.Items.Add( Query.FieldByName('ID_TERMINAL').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString);
     cbDestino.Items.Add(Query.FieldByName('ID_TERMINAL').AsString + ' ' + Query.FieldByName('DESCRIPCION').AsString);
     cbOrigenTramo.Items.Add(Query.FieldByName('ID_TERMINAL').AsString + ' ' +Query.FieldByName('DESCRIPCION').AsString);
     cbDestinoTramo.Items.Add(Query.FieldByName('ID_TERMINAL').AsString + ' ' +Query.FieldByName('DESCRIPCION').AsString);
     Query.Next;
   end;

end;
{
Funcion que carga los datos de una ruta dada desde el Grid de datos
previamente cargados
}
procedure TfrmRutas.CargaRutaD(IdRuta: String);
begin
 //Procedimiento que carga el detalle de las rutas,
 // los tramos, el orden  y tiempo desde el punto origen
 SQL:='SELECT T.ORIGEN, T.DESTINO, RD.ORDEN '+  // , RD.MIN_TOTAL_ORIGEN '+
      ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
      ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN';
 if EjecutaSQL(sql,Query,_LOCAL) then
 begin
   edIdRuta.Text:=       sagRutasMio.cells[0,renglon]; // Tomo el ID_RUTA
   cbOrigen.ItemIndex:=  cbCiudadesMio.Items.IndexOf(sagRutasMio.cells[1,renglon]);
   cbDestino.ItemIndex:= cbCiudadesMio.Items.IndexOf(sagRutasMio.cells[2,renglon]);
   edKilometros.Text:=   sagRutasMio.cells[3,renglon]; // tomo el dato KM
   edMinutos.Text:=      sagRutasMio.cells[4,renglon]; // tomo el dato Minutos
   LimpiaSag(sagTramos);
   DataSetToSag(Query,sagTramos);
   if sagTramos.rowcount>1 then
      sagTramos.FixedRows:=1;
 end;

 SQL:='SELECT T.ID_TRAMO, T.ORIGEN, T.DESTINO, RD.ORDEN ' + //, RD.MIN_TOTAL_ORIGEN '+
      ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
      ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN';
 if EjecutaSQL(sql,Query,_LOCAL) then
 begin
   LimpiaSag(sagTramosMio);
   DataSetToSag(Query,sagTramosMio);
 end;

end;

procedure TfrmRutas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   gds_actions.clear;
   sagRutasMio.Free;
   sagTramosMio.Free;
   Query.Destroy;
   QueryRutas.Destroy;
   Querys.Destroy;
   repetidos.Destroy;
   comunii.terminalesAutomatizadas.Free;
end;

procedure TfrmRutas.FormCreate(Sender: TObject);
begin
   sagRutasMio:= TStringGrid.Create(Self);
   sagTramosMio:= TStringGrid.Create(Self);
   cbCiudadesMio:= TComboBox.Create(Self);
   cbCiudadesMio.Parent:= Self;
   cbCiudadesMio.Visible:= False;
   repetidos:= TStringList.Create;
   comunii.banderaInsertaTramos:= True;

   comunii.terminalesAutomatizadas:= TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;
end;

procedure TfrmRutas.FormShow(Sender: TObject);
begin
   gds_actions.clear;
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   QueryRutas:= TSQLQuery.Create(Self);
   QueryRutas.SQLConnection:= dm.Conecta;
   Querys:= TSQLQuery.Create(Self);
   Querys.SQLConnection:= dm.Conecta;
   CargaRutas;
   CargaCiudades;
   edIdRuta.Text:= _AUTOMATICO;
   PanelRuta.Enabled:= False;
   PanelTramos.enabled:= False;
   lblEstado.Caption:='';
   EsRefresh:= False;
   esNuevaRuta := False;
end;

procedure TfrmRutas.PasaSiguiente;
begin
  Perform(WM_NEXTDLGCTL, 0, 0);   { mueve el foco al siguiente control }
end;

function TfrmRutas.RegresaUltimoTramo: String;
begin
  // busca en el grid de tramos y regresa el destino del ultimo tramo
  if sagTRamos.RowCount = 1 then
     result:=''
  else
     result:= sagTramos.Cells[1,sagTramos.RowCount-2];
end;

procedure TfrmRutas.sagRutasSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if EsRefresh then Exit;
  //Hacer la busqueda del detalle de la ruta seleccionada.
  Renglon:= ARow;
  Columna:= Acol;
  IF Renglon = 0 then Exit;
//  ShowMessage(sagRutasMio.Cells[0,Renglon]);
  CargaRutaD(sagRutasMio.Cells[0,Renglon]);
  cbOrigenTramo.ItemIndex:= -1;
  cbDestinoTramo.ItemIndex:= -1;
  PanelRuta.Enabled:= False;
end;

procedure TfrmRutas.sagTramosSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
   renglonTramos:= aRow;
   columnaTramos:= aCol;
   if renglonTramos = 0 then Exit;
   cbOrigenTramo.ItemIndex:= cbCiudadesMio.Items.IndexOf(sagTramos.Cells[0,Arow]);
   cbDestinoTramo.ItemIndex:= cbCiudadesMio.Items.IndexOf(sagTramos.Cells[1,Arow]);

end;

{procedimiento que prepara la forma para Modificar los datos de una Ruta}
procedure TfrmRutas.act130Execute(Sender: TObject);
begin
   if ((cbOrigen.ItemIndex < 0) or
       (cbDestino.ItemIndex < 0)) then
   begin
     ShowMEssage(_FALTA_CIUDAD);
     Exit;
   end;

   if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   if Trim(edIdRuta.Text) = _AUTOMATICO then exit;
   panelRutas.Enabled:= False;
   panelRuta.Enabled:= True;
   lblEstado.Caption:='Modificando Ruta...';
   esNuevaRuta := False;
end;


{procedimiento que prepara la forma para Modificar los tramos de una Ruta}
procedure TfrmRutas.act136Execute(Sender: TObject);
begin
  if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
  if Trim(edIdRuta.Text) = _AUTOMATICO then Exit;
  panelRuta.Enabled:= False;
  panelRutas.Enabled:= False;
  panelTramos.Enabled:= True;
  lblEstado.Caption:='Modificando Tramos...';
  cbOrigenTramo.SetFocus;
end;

{Procedimiento que guarda los tramos que se han capturado para un ruta}
procedure TfrmRutas.act135Execute(Sender: TObject);
var I: Integer;
  msg, sqlAux: String;

begin
   if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   if ((cbCiudadesMio.Items[cbOrigen.Items.IndexOf(cbOrigen.Text)]<> sagTRamos.Cells[0,1])
      OR (cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)]<> sagTramos.Cells[1,sagTramos.RowCount-1 ] )
      OR (edIDRuta.Text = _AUTOMATICO) ) then Exit;
   if MessageDlg(Format(_GUARGAR_TRAMOS,[edIdRuta.Text]),mtWarning,mbOKCancel,0) <> mrOK then exit;
   case RevisaCiudades(sagTramos)  of
    _NO_OK :
    begin
        ShowMessage(_AVISO_INFO_INCORRECTA);
        Exit;
    end;
    _PASA_CON_AUTORIZACION :
        If MessageDlg(_AVISO_INFO_INCONSISTENTE+ char(13) +
                      repetidos.Text,mtError,mbOKCancel,0) <> mrOk then
           Exit;

    _TODO_OK: // Continuo ;
   else begin
       ShowMessage(_ERR_SQL);
       Exit;
   end;
   end;
   TRY
      sql := 'DELETE FROM  T_C_RUTA_D WHERE ID_RUTA='+ Trim(edIdRuta.Text)+'; ';
      if EjecutaSQL(sql,Querys,_LOCAL) then
         comunii.replicarTodos(sql);
      for I := 1 to sagTramos.RowCount - 1 do
      begin
        sql:= 'INSERT INTO T_C_RUTA_D(ID_RUTA, ID_TRAMO, ORDEN) '+
             ' VALUES( '+ Trim(edIdRuta.Text) +',' + sagTramosMio.Cells[0,I] + ',' +
             inttoStr(I) + // se quita el campo min_total_origen, deprecated, indica Luis Salez 28 de Mayo de 2010
             '); ' ;
        EjecutaSQL(sql,Querys,_LOCAL);
        comunii.replicarTodos(sql);
      end;
   EXCEPT
      sql := 'DELETE FROM  T_C_RUTA_D WHERE ID_RUTA='+ Trim(edIdRuta.Text)+'; ';
      EjecutaSQL(sql,Querys,_LOCAL);
      comunii.replicarTodos(sql);
      // ShowMessage(Format(_ERROR_GUARDAR_TRAMOS,[edIdRuta.Text]));
      Exit;
   end;
   if sagTramos.RowCount>1 then
      sagTramos.FixedRows:= 1;
   ShowMessage(_OPERACION_SATISFACTORIA);
   panelRuta.Enabled:= False;
   panelRutas.Enabled:= True;
   panelTramos.Enabled:= False;
   btnAgrega.Enabled:= True;
   lblEstado.Caption:='';
   sagTramos.Enabled:= True;
end;

procedure TfrmRutas.cbDestinoTramoKeyPress(Sender: TObject; var Key: Char);
begin
  // Si es solo Enter paso al siguiente componente el foco
   if key=#13 then PasaSiguiente;
end;
{Funcion que determina si las ciudades que estan capturadas para una ruta:
son continuas,
si tocan mas de una ocasion un punto}
function TfrmRutas.RevisaCiudades(sag: TStringGrid): Byte;
var i,x, aux: Integer;
    bandera: boolean;
begin
// primero que todo reviso que todas las ciudades sean CONTINUAS
 for i:=2 to sag.RowCount -1 do
   if sag.Cells[0,i]<> sag.Cells[1,i-1] then
   begin
      result:=_NO_OK;
      exit;
   end;
   repetidos.Clear;
 // cuento cada una de las ciudades existentes como punto destino en el SAG
 // primero  voy a recorrer todas las ciudades destinos
 for i:=1 to sag.RowCount -1 do
 begin
   // si es la primer ciudad
   if i=1 then
   begin
      setlength(ciudades,1);
      ciudades[0].ciudad:=sag.Cells[1,i];
      ciudades[0].pasos:= 1;
   end;
   //si es a partir de la ciudad numero 2...
   if i>1 then
   //recorrere a partir de mi ciudad destino el arreglo de ciudades existentes
   for aux:= i to sag.RowCount-1  do
   begin
     bandera:=False;
     for x:=1 to length(ciudades) do
        if sag.Cells[1,aux] = ciudades[x-1].ciudad  then
        begin
          Ciudades[x-1].pasos:= Ciudades[x-1].pasos+1;
          bandera:= True;
          break;
        end;
     if bandera then break;
     setlength(ciudades,length(ciudades)+1);
     ciudades[length(ciudades)-1].ciudad:=sag.Cells[1,aux];
     ciudades[length(ciudades)-1].pasos:= 1;
     break;                      
   end; // fin del for que recorre la ciudad donde estoy pocisionado contra
   // todas las ciudades de mi arreglo
 end; // fin del for que recorre las ciudades destinos
   for i:=1 to length(ciudades) do
    if ciudades[i-1].pasos > 1 then
    begin
       repetidos.Add(ciudades[i-1].ciudad + ' es tocada: ' + intToStr(ciudades[i-1].pasos) + ' veces.');
       result:= _PASA_CON_AUTORIZACION;
       Exit;
    end;
 // cuento cada una de las ciudades existentes como punto origen en el SAG
 // primero  voy a recorrer todas las ciudades origen
    for i:=1 to sag.RowCount -1 do
    begin
   // si es la primer ciudad
    if i=1 then
    begin
      setlength(ciudades,1);
      ciudades[0].ciudad:=sag.Cells[0,i];
      ciudades[0].pasos:= 1;
    end;
    //si es a partir de la ciudad numero 2...
    if i>1 then
    //recorrere a partir de mi ciudad destino el arreglo de ciudades existentes
    for aux:= i to sag.RowCount-1  do
   begin
     bandera:=False;
     for x:=1 to length(ciudades) do
        if sag.Cells[0,aux] = ciudades[x-1].ciudad  then
        begin
          Ciudades[x-1].pasos:= Ciudades[x-1].pasos+1;
          bandera:= True;
          break;
        end;
     if bandera then break;
     setlength(ciudades,length(ciudades)+1);
     ciudades[length(ciudades)-1].ciudad:=sag.Cells[0,aux];
     ciudades[length(ciudades)-1].pasos:= 1;
     break;
   end; // fin del for que recorre la ciudad donde estoy pocisionado contra
   // todas las ciudades de mi arreglo
 end; // fin del for que recorre las ciudades destinos
   for i:=1 to length(ciudades) do
    if ciudades[i-1].pasos > 1 then
    begin
       repetidos.Add(ciudades[i-1].ciudad + ' es tocada: ' + intToStr(ciudades[i-1].pasos) + ' veces.');
       result:= _PASA_CON_AUTORIZACION;
       Exit;
    end;
   result:=_TODO_OK;
end;
{procedimiento que limpia un sag enviado como parametro}
procedure TfrmRutas.LimpiaSag(sag: TStringGrid);
var col, ren: integer;
begin
   for col:=0 to sag.RowCount do
     for ren:= 0 to sag.RowCount do
        sag.Cells[col,ren]:='';
   sag.RowCount := 2;
end;
{funcion que elimina todos los tramos de una ruta}
procedure TfrmRutas.EliminaTramos;
begin
   if edIdRuta.Text = _AUTOMATICO then exit;
   sql:='DELETE FROM T_C_RUTA_D WHERE ID_RUTA = '+EdIdRuta.Text+';';
   if EjecutaSQL(sql,Query,_LOCAL) then
   begin
         replicarTodos(sql);
         CargaTramos(edIdRuta.Text);
         cbOrigenTramo.ItemIndex:=  -1;
         cbDestinoTramo.ItemIndex:= -1;
         ShowMessage(_OPERACION_SATISFACTORIA);
   end;
end;
{procedimiento para eliminar solo algunos tramos o todos los tramos de una ruta}
procedure TfrmRutas.act141Execute(Sender: TObject);
var renglon, columna: Integer;
begin

   if RenglonTramos = 0 then Exit;
   if Trim(edIdRuta.Text) = _AUTOMATICO then Exit;
   if not paneltramos.Enabled then exit;
   if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
        Exit;
   // Dar la opcion de Eliminar Todos los tramos o eliminar a partir del
   // registro donde esta pocisionado actualmente
   if MessageDlg(_ELIMINAR_TODOS_TRAMOS,mtWarning,mbOKCancel,0) = mrOK then
      EliminaTramos
   else if MessageDlg(_ELIMINAR_ALGUNOS_TRAMOS,mtWarning,mbOKCancel,0) = mrOK then
   //eliminare los tramos a partir del registro seleccionado
   begin
      if  renglonTramos >= 1 then
         for renglon:= renglonTramos+1 to sagTramos.RowCount -1 do
           for columna:= 0 to sagTramos.ColCount - 1 do
           begin
               sagTramos.Cells[columna,renglon]:='';
               sagTramosMio.Cells[columna,renglon]:='';
           end;
         sagTramos.RowCount:= renglonTramos+2;
         sagTramosMio.RowCount:= renglonTramos+2;
      //  No se eliminan los registros de la base x si queda inconclusa la operacion
   end;
   if regresaUltimoTramo <>   cbCiudadesMio.Items[cbDestino.Items.IndexOf(cbDestino.Text)] then
      btnAgrega.Enabled := True;
end;

{
Funcion que carga los datos desde la base de datos una ruta dada
}
procedure TfrmRutas.CargaRutaXid(IdRuta: String);
begin
 SQL:='SELECT ORIGEN, DESTINO, KM, MINUTOS '+
      ' FROM T_C_RUTA '+
      ' WHERE ID_RUTA='+IdRuta;
 if EjecutaSQL(sql,Query,_LOCAL) then
 IF NOT query.Eof then
 begin //*1*//
     edIdRuta.Text:= idRuta; // Tomo el ID_RUTA
     cbOrigen.ItemIndex:= cbCiudadesMio.Items.IndexOf(Query.FieldByName('Origen').AsString);
     cbDestino.ItemIndex:= cbCiudadesMio.Items.IndexOf(Query.FieldByName('Destino').AsString);
     edKilometros.Text:= Query.FieldByName('KM').AsString;
     edMinutos.Text:= Query.FieldByName('MINUTOS').AsString;
     //Procedimiento que carga el detalle de las rutas,
     // los tramos, el orden  y tiempo desde el punto origen
     SQL:='SELECT T.ORIGEN, T.DESTINO, RD.ORDEN '+ //, RD.MIN_TOTAL_ORIGEN
       ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
       ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN';
    if EjecutaSQL(sql,Query,_LOCAL) then
    begin
      LimpiaSag(sagTramos);
      DataSetToSag(Query,sagTramos);
    end;

    SQL:='SELECT T.ID_TRAMO, T.ORIGEN, T.DESTINO, RD.ORDEN '+ //, RD.MIN_TOTAL_ORIGEN
       ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
       ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN';
    if EjecutaSQL(sql,Query,_LOCAL) then
    begin
      LimpiaSag(sagTramosMio);
      DataSetToSag(Query,sagTramosMio);
    end;
    end
  else //*1*//    si esta vacio el recordSet...
  begin
    ShowMessage(_INFORMACION_NO_EXISTE);
    edIdRuta.Text:= _AUTOMATICO;
    Exit;
  end;


end;

procedure TfrmRutas.LimpiaForma;
begin
   cbOrigen.ItemIndex:= -1;
   cbDestino.ItemIndex:= -1;
   edKilometros.Text:= '';
   edMinutos.Text:='';
   edIdRuta.Text:= _AUTOMATICO;
   cbOrigenTramo.ItemIndex := -1;
   cbDestinoTramo.ItemIndex := -1;
end;

{procedimiento que permite agregar al GRID un tramo a una ruta}
procedure TfrmRutas.act137Execute(Sender: TObject);
var idTramo: Integer;
begin
   if comunii.banderaInsertaTramos  then
        if not AccesoPermitido(TAction(Sender).Tag, _RECUERDA_TAGS) then
               Exit;
   if ((cbOrigenTramo.ItemIndex < 0) or (cbDestino.ItemIndex < 0) or
        (cbOrigenTramo.ItemIndex=cbDestinoTramo.ItemIndex)  )then
   begin
     ShowMessage(_INFORMACION_INSUFICIENTE);
     Exit;
   end;
   idTramo:= ExisteTramo(cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbOrigenTramo.Text)],
                  cbCiudadesMio.Items[cbDestinoTramo.Items.IndexOf(cbDestinoTramo.Text)]);
   if idTramo = -1 then
   begin
     if MessageDlg(_INFORMACION_NO_EXISTE+ ' ¿Desea agregar el tramo?',mtWarning,mbOKCancel,0) = mrOK then
     begin
     if not AccesoPermitido(Taction(act125).Tag, _RECUERDA_TAGS) then
        Exit;
     try
       comunii.tipoVentanaTramos:= comunii._TIPO_PRE_LLENADO; // abrir el formulario con prellenado
       frmTramos := TfrmTramos.Create(Self);
       Origen:= cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbOrigenTramo.Text)];
       Destino:=cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbDestinoTramo.Text)];
       frmTramos.ShowModal;
     finally
       frmTramos.Free;
       frmTramos := nil;
      end; //fin del try
      act137Execute(act137); // volver a entrar aqui para que se inserte solito
     end; // fin del if _INFORMACION_NO_EXISTE
     Exit;
   end; // END DEL IDTRAMO = -1
  if sagTramos.RowCount=1 then // si  es el primer tramo...
     if cbOrigen.ItemIndex <> cbOrigenTramo.ItemIndex then
     begin
     ShowMEssage(_TRAMO_INICIAL);
     Exit;
     end;
  if sagTRamos.RowCount >= 2  then
    if RegresaUltimoTramo <> cbCiudadesMio.Items[cbOrigenTramo.Items.IndexOf(cbOrigenTramo.Text)]  then
    begin
       ShowMessage(_CONTINUIDAD_TRAMOS);
       Exit;
    end;
    AgregaTramo(idTramo);
    cbOrigenTramo.ItemIndex:= cbDestinoTramo.ItemIndex;
    cbDestinoTramo.SetFocus;
    if cbDestinoTramo.ItemIndex = cbDestino.ItemIndex then
    begin
       btnAgrega.Enabled:= False;
       sagTramos.RowCount:=sagTramos.RowCount-1;
    end;
    cbDestinoTramo.ItemIndex:=-1;
    sagTramos.Enabled:= False;
    comunii.banderaInsertaTramos:= True;
end;


function TfrmRutas.RegresaRuta(origen, destino, kilometros, minutos: String): String;
begin
   sql:='SELECT MAX(ID_RUTA) AS ID_RUTA '+
        ' FROM T_C_RUTA WHERE ORIGEN='+
       Origen  +  ' AND DESTINO='+  Destino+
       ' AND MINUTOS ='+MINUTOS+
       ' AND KM='+KILOMETROS+';';
     if  EjecutaSQL(sql,Query,_LOCAL) then
       if not query.IsEmpty then
          result:= Query.FieldByName('ID_RUTA').AsString
       else
          result:= ''
     else
        result:= '';


end;

function TfrmRutas.RegresaTramos(idRuta: String): String;
var Tramos: String;
begin

   sql:='SELECT T.DESTINO'+
        ' FROM T_C_RUTA_D AS RD JOIN T_C_TRAMO AS T ON (RD.ID_TRAMO = T.ID_TRAMO) '+
        ' WHERE RD.ID_RUTA='+IdRuta+ ' ORDER BY RD.ORDEN;';
    if EjecutaSQL(sql,Query,_LOCAL) then
       Tramos:='';
    if Query.eof then
       Tramos:='NO TIENE TRAMOS';
    Tramos:='-';
    while not Query.Eof do
    begin
      Tramos:= Tramos + Query.FieldByName('DESTINO').AsString + ' - ';
      Query.Next;
    end;
    result:= Tramos;

end;

end.
