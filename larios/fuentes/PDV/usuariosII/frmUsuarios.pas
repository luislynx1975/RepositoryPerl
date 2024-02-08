unit frmUsuarios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, ActnList,SqlExpr,
  PlatformDefaultStyleActnCtrls, ActnMan, lsCombobox, ToolWin, ActnCtrls,
  ActnMenus, System.Actions;

type
  TfrmUsuario = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    edtTrabId: TEdit;
    edtNombre: TEdit;
    dtpPassword: TDateTimePicker;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Action4: TAction;
    Label6: TLabel;
    lscbPuestos: TlsComboBox;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action5: TAction;
    lblBaja: TLabel;
    Action6: TAction;
    Label3: TLabel;
    edtPaterno: TEdit;
    Label4: TLabel;
    edtMaterno: TEdit;
    Label7: TLabel;
    lscbServicios: TlsComboBox;
    cbTipoEmpleado: TCheckBox;
    actReplicar: TAction;
    procedure FormShow(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtTrabIdKeyPress(Sender: TObject; var Key: Char);
    procedure edtTrabIdExit(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action6Execute(Sender: TObject);
    procedure cbTipoEmpleadoClick(Sender: TObject);
    procedure actReplicarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure LimpiaDatos;

  public
    { Public declarations }
  end;

var
  frmUsuario: TfrmUsuario;

implementation

uses Uusuarios, DMdb, comunii, comun;

{$R *.dfm}

{ TfrmUsuario }

procedure TfrmUsuario.Action1Execute(Sender: TObject);
begin
  LimpiaDatos;
end;

procedure TfrmUsuario.Action2Execute(Sender: TObject);
VAR msj: String;
begin
   if not AccesoPermitido(107,True) then
        Exit;
   if ((Trim(edtNombre.Text) = '') or  (lscbPuestos.ItemIndex < 0) or (edtTrabId.Text = '')) then
   begin
     ShowMessage('Faltan datos requeridos...');
     Exit;
   end;
   if Application.MessageBox(PChar('¿Realmente desea guardar la información?'),
                    'Atención', _CONFIRMAR) = IDNO then
      exit;
      msj:='';
   if ExisteEmpleado(edtTrabId.Text, not cbTipoEmpleado.Checked) then
   begin
      if cbTipoEmpleado.Checked then
      begin
          if uUsuarios.ActualizaEmpleado(edtTrabId.Text,edtNombre.Text,edtPaterno.Text,
                               edtMaterno.Text, lscbPuestos.CurrentID, '0' ,
                               -1) then
            msj:= msj + 'Se actualizo el catalogo de Empleados correctamente.'+CHAR(13);
          if uUsuarios.ActualizaUsuario(edtTrabId.Text, edtNombre.Text + ' ' +
                               edtPaterno.Text +' ' + edtMaterno.Text, lscbPuestos.CurrentID) then
           msj:= msj + 'Se actualizo el catalogo de Usuarios correctamente.'+CHAR(13);
      end
      else
         if uusuarios.ActualizaEmpleado(edtTrabId.Text,edtNombre.Text,edtPaterno.Text,
                               edtMaterno.Text, '1253', intToStr(StrToInt(lscbServicios.CurrentID)+100) ,
                               strToInt(lscbServicios.CurrentID)) then
            msj:= msj + 'Se actualizo el catalogo de Empleados correctamente.'+CHAR(13)
   end
   else
      if cbTipoEmpleado.Checked then
      begin
        if  uUsuarios.InsertaUsuario(edtTrabId.Text, edtNombre.Text + ' ' + edtPaterno.Text +' ' + edtMaterno.Text ,lscbPuestos.CurrentID) then
             msj:= msj + 'Se inserto en el catalogo de Usuarios correctamente.'+CHAR(13);
        if Uusuarios.InsertaEmpleado(edtTrabId.Text,edtNombre.Text, edtPaterno.Text,
                                 edtMaterno.Text,lscbPuestos.CurrentID, intToStr(0) ,
                                 strToInt('0')) then
            msj:=  msj + 'Se inserto en el catalogo de Empleados correctamente.'+CHAR(13);
      end
      else
           if Uusuarios.InsertaEmpleado(edtTrabId.Text,edtNombre.Text, edtPaterno.Text,
                                 edtMaterno.Text,'1253', intToStr(strToInt(lscbPuestos.CurrentID) + 100) ,
                                 strToInt(lscbServicios.CurrentID)) then
               msj:= msj + 'Se inserto en el catalogo de Empleados correctamente.'+CHAR(13);
   if ExisteEmpleado(edtTrabId.Text, cbTipoEmpleado.Checked) then
         InsertaPrivilegios(edtTrabId.Text, lscbPuestos.CurrentID);
   ShowMessage(msj);
end;

procedure TfrmUsuario.Action3Execute(Sender: TObject);
begin
   if not AccesoPermitido(150,False) then  // baja del usuario
        Exit;                        // sea administrativo o sea conductor
   if edtTrabId.Text= ''  then
   BEGIN
     ShowMessage(uusuarios._OPERACION_INVALIDA);
     Exit;
   END;
   if Application.MessageBox(PChar('¿Realmente desea dar de baja el usuario?'),
                    'Atención', _CONFIRMAR) = IDYES then
   begin
      sql:='UPDATE PDV_C_USUARIO SET PASSWORD = '+ QuotedStr('MERCURIO')+
           ' , FECHA_BAJA= CURDATE() ' +
        ' WHERE TRAB_ID= '+ QuotedStr(edtTrabId.Text) ;
      if EjecutaSQL(sql,Query,_TODOS) then
          ShowMEssage(uusuarios._BAJA_USUARIO)
      else
          ShowMEssage(uusuarios._OPERACION_INVALIDA);
      sql:='UPDATE EMPLEADOS SET STATUS = '+ QuotedStr('BAJA')+
           ' WHERE TRAB_ID= '+ QuotedStr(edtTrabId.Text) ;
      EjecutaSQL(sql,Query,_TODOS);
   end;
end;

procedure TfrmUsuario.Action4Execute(Sender: TObject);
begin
   Close;
end;


procedure TfrmUsuario.Action5Execute(Sender: TObject);
begin
   if edtTrabId.Text= ''  then
   BEGIN
     ShowMessage(uusuarios._OPERACION_INVALIDA);
     Exit;
   END;
   if Application.MessageBox(PChar('¿Realmente desea establecer el password predefinido?'),
                    'Atención', _CONFIRMAR) = IDYES then
   begin
      sql:='UPDATE PDV_C_USUARIO SET PASSWORD = '+ QuotedStr('MERCURIO')+
           ' , FECHA_PASSWORD= CURDATE() ' +
        ' WHERE TRAB_ID= '+ QuotedStr(edtTrabId.Text) ;
      if EjecutaSQL(sql,Query,_TODOS) then
          ShowMEssage(uusuarios._ACTUALIZACION_PASSWORD_EXITOSA)
      else
          ShowMEssage(uusuarios._OPERACION_INVALIDA);
   end;
end;

procedure TfrmUsuario.Action6Execute(Sender: TObject);
begin
   if ((edtTrabId.Text= '') or (not lblBaja.Visible)) then
   BEGIN
     ShowMessage(uusuarios._OPERACION_INVALIDA);
     Exit;
   END;
   if Application.MessageBox(PChar('¿Realmente desea dar de baja el usuario?'),
                    'Atención', _CONFIRMAR) = IDYES then
   begin
      sql:='UPDATE PDV_C_USUARIO SET PASSWORD = '+ QuotedStr('MERCURIO')+
           ' , FECHA_BAJA= NULL  ' +
           ' , FECHA_PASSWORD= CURDATE() ' +
        ' WHERE TRAB_ID= '+ QuotedStr(edtTrabId.Text) ;
      if EjecutaSQL(sql,Query,_TODOS) then
          ShowMEssage(uusuarios._UPDATE_EXITOSO)
      else
          ShowMEssage(uusuarios._OPERACION_INVALIDA);
      sql:='UPDATE EMPLEADOS SET STATUS = '+ QuotedStr('ACTIVO')+
           ' WHERE TRAB_ID= '+ QuotedStr(edtTrabId.Text) ;
      EjecutaSQL(sql,Query,_TODOS);
   end;
end;

procedure TfrmUsuario.actReplicarExecute(Sender: TObject);
var msj: String;
begin
   if not AccesoPermitido(213,True) then
        Exit;
   if ((Trim(edtNombre.Text) = '') or  (lscbPuestos.ItemIndex < 0) or (edtTrabId.Text = '')) then
   begin
     ShowMessage('Faltan datos requeridos...');
     Exit;
   end;
   if Application.MessageBox(PChar('¿Realmente desea replicar la información?'),
                    'Atención', _CONFIRMAR) = IDNO then
      exit;
      msj:='Replicación finalizada';
   uUsuarios.replicaEmpleado(edtTrabId.Text);

   ShowMessage(msj);
end;

procedure TfrmUsuario.cbTipoEmpleadoClick(Sender: TObject);
begin
   if cbTipoEmpleado.Checked then
   begin
     cbTipoEmpleado.Caption:='Administrativo';
     lscbServicios.Enabled:= False;
   end
   else
   begin
     cbTipoEmpleado.Caption:='Conductor';
     lscbServicios.Enabled:= True;
   end;
   if Trim(edtTrabid.Text)='' then
     edtTrabId.SetFocus;
end;

procedure TfrmUsuario.edtTrabIdExit(Sender: TObject);
begin
   if Trim(edtTrabid.Text)<>'' then
       edtTrabId.Enabled := False;
   if  ExisteEmpleado(edtTrabId.Text, not cbTipoEmpleado.Checked) then
   begin
      edtNombre.Text    := query.FieldByName('NOMBRES').AsString;
      edtPaterno.Text   := query.FieldByName('PATERNO').AsString;
      edtMaterno.Text   := query.FieldByName('MATERNO').AsString;
      if  (cbTipoEmpleado.Checked) then
      begin
          dtpPassword.Date  := query.FieldByName('FECHA_PASSWORD').AsDateTime;
          lblBaja.Visible   := not query.FieldByName('FECHA_BAJA').IsNull;
          lscbPuestos.SetID(query.FieldByName('ID_GRUPO').AsString);
      end;
      cbTipoEmpleado.Checked:= True;
      if query.FieldByName('TIPO_EMPLEADO').AsInteger <> 0 then
      begin
         lscbServicios.Enabled := True;
         cbTipoEmpleado.Checked:= False;
         lscbServicios.SetID(query.FieldByName('ID_SERVICIO_ACTUAL').AsString);
         lblBaja.Visible   := (query.FieldByName('STATUS').AsString = 'BAJA');
      end;

   end;
end;

procedure TfrmUsuario.edtTrabIdKeyPress(Sender: TObject; var Key: Char);
begin
   if  Key = #13 then
     edtNombre.SetFocus;
end;

procedure TfrmUsuario.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   Query.Destroy;
   Query2.Destroy;
end;

procedure TfrmUsuario.FormCreate(Sender: TObject);
begin
   uusuarios.Query:= TSQLQuery.Create(Self);
   uusuarios.Query.SQLConnection:= dm.Conecta;

   uusuarios.Query2:= TSQLQuery.Create(Self);
   uusuarios.Query2.SQLConnection:= dm.Conecta;

   // lineas de codigo para que funcione la replicacion
   comunii.terminalesAutomatizadas:= TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;
   // gam 16-11-2022/12:38hrs

end;

procedure TfrmUsuario.FormShow(Sender: TObject);
begin
    LimpiaDatos;
    uusuarios.llenaPuestos(lscbPuestos);
    uusuarios.llenaServicios(lscbServicios);
    lscbServicios.Enabled := False;
end;

procedure TfrmUsuario.LimpiaDatos;
begin
    // limpiar todos los datos de la forma
    edtTrabId.Enabled:= True;
    lscbPuestos.ItemIndex:= -1;
    lscbServicios.ItemIndex := -1;
    edtTrabId.Text   := '';
    edtNombre.Text   := '';
    edtPaterno.Text  := '';
    edtMaterno.Text  := '';
    dtpPassword.Date := Now + 15;
    edtTrabId.SetFocus;
    lblBaja.Visible:= False;

end;

end.
