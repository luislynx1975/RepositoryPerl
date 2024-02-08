unit frmAsignacionFondo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, PlatformDefaultStyleActnCtrls, ActnMan,
  ShellAPI, lsCombobox, System.Actions, data.SqlExpr;

type
  TfrmAsignarFondo = class(TForm)
    lbl1: TLabel;
    edtTrabId: TEdit;
    lbl2: TLabel;
    btn1: TButton;
    lbl3: TLabel;
    edtCiudad: TEdit;
    lbl4: TLabel;
    edtFondoInicial: TEdit;
    btnCerrar: TButton;
    btnLimpiar: TButton;
    btnAsignar: TButton;
    actmgr1: TActionManager;
    actLimpiar: TAction;
    actAsignar: TAction;
    actCerrar: TAction;
    btn2: TButton;
    lscbPromotores: TlsComboBox;
    procedure actCerrarExecute(Sender: TObject);
    procedure actAsignarExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure actLimpiarExecute(Sender: TObject);
    procedure imprimirFondoCaja(idCorte: String);
    procedure edtTrabIdExit(Sender: TObject);
    procedure edtTrabIdKeyPress(Sender: TObject; var Key: Char);
    procedure btn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lscbPromotoresExit(Sender: TObject);
    function esNumero(cadena: String): Boolean;

  private
    { Private declarations }
    var
    Query : TSQLQuery;
    montoFondo : Double;
    confirmacion : Boolean;

  public
    { Public declarations }
    var
       tipoFormulario: byte;
  end;

var
  frmAsignarFondo: TfrmAsignarFondo;

implementation

uses comun, comunii, DMdb;

{$R *.dfm}

procedure TfrmAsignarFondo.actAsignarExecute(Sender: TObject);
var corte: _corte;
     aux , idCorte: integer;
    store : TSQLStoredProc;
begin
   if not esNumero(edtFondoInicial.Text)  then
   begin
         showMessage('El dato que ha introducido no es un numero correcto.');
         edtFondoInicial.SetFocus;
         exit;
   end;
   if ((self.montoFondo = 0) and (not self.confirmacion)) then
   begin
      self.montoFondo   := strToFloat(edtFondoInicial.Text);
      self.confirmacion := true;
      self.lbl4.Caption := 'Confirmar monto: ';
      self.edtFondoInicial.Text := '';
      self.edtFondoInicial.SetFocus;
      exit;
   end;

   if (self.montoFondo <> strToFloat(edtFondoInicial.Text)) then
   begin
     ShowMessage('Se digitaron montos diferentes, vuelve a intentarlo.');
     self.montoFondo   :=  0;
     self.confirmacion := false;
     edtFondoInicial.Text :='';
     self.lbl4.Caption := 'Importe de fondo Fijo: ';
     edtFondoInicial.SetFocus;
     exit;
   end;


   if not AccesoPermitido(215, _NO_RECUERDA_TAGS) then
        Exit;
   // debo validar algunas cuestion antes de fincar el fondo inicial
   // en un nuevo registro de corte al promotor.
   // revisar que todos los cambpos estén llenos en la forma
   case tipoFormulario of
     _TIPO_FONDO_PRE:
     begin
        if Trim(edtTrabId.Text) = '' then
        begin
           ShowMessage('Digite un número de empleado antes de continuar.');
           Exit;
        end;
        // revisar si el promotor tiene algun corte activo
        corte:= comunii.existeCorteAbierto(trim(edtTrabId.Text));
        if (corte.idCorte>0) then
        begin
          ShowMessage('El usuario '+ corte.idEmpleado + ' está asignado en la taquilla '+
                      IntToStr(corte.idTaquilla) + ' con fecha de asignacion: '+
                      formatDateTime('dd/mm/yyyy',corte.FechaInicio) + ' en terminal '+
                      corte.idTerminal );
          exit;
        end;
        // revisar si el usuario esta activo
        if (comunii.regresaStatusUsuario(trim(edtTrabId.Text)) = _ESTATUS_USUARIO_BAJA ) then
        begin
          ShowMessage('El usuario está registrado como baja en el sistema actualmente, consulte con RRHH');
          exit;
        end;
        // revisar si el usuario podrá posteriormente asignarse a la venta.
        if (not comunii.privilegioUsuario(trim(edtTrabId.Text),_PRIVILEGIO_VENTA )) then
        begin
           ShowMessage('El usuario no puede realizar venta, consulte con RRHH');
           exit;
        end;
     end;
     _TIPO_FONDO_POST:
     begin
         // revisar la lista que tenga elegido un empleado
         corte:= regresaDatosCorte(lscbPromotores.CurrentID);
         if lscbPromotores.ItemIndex<0 then
         begin
            ShowMessage('Elegir un empleado antes de continuar.');
            Exit;
         end;
     end;
   end;
   if edtFondoInicial.text = '' then
   begin
      ShowMessage('Digite el importe del fondo fijo, verifiquelo antes de continuar.');
      exit;
   end;
   aux:= StrToInt(edtFondoInicial.Text);
   if(aux <=0) then
   begin
     ShowMessage('El fondo fijo debe ser mayor a 0, verifiquelo antes de continuar.');
     exit;
   end;

   if (Trim(edtCiudad.Text) = '') then
   begin
     ShowMessage('Verifique la ciudad antes de continuar.');
     exit;
   end;

   store := TSQLStoredProc.Create(nil);
   store.SQLConnection := DM.Conecta;
   case tipoFormulario of
     _TIPO_FONDO_PRE:
     begin
        try
             store.close;
             store.StoredProcName := 'PDV_SP_REGISTRA_CORTE_CAJA';
             store.Params.ParamByName('_ID_TERMINAL').AsString := Trim(edtCiudad.Text);
             store.Params.ParamByName('_ID_TAQUILLA').AsInteger := 0; // strToInt(lsTaquillas.Text);  // SE DEJA UN 0 PARA QUE LARIOS LO CAMBIE POSTERIORMENTE
             store.Params.ParamByName('_ID_EMPLEADO').AsString := Trim(edtTrabId.Text);
             store.Params.ParamByName('_FONDO_INICIAL').AsFloat := StrToFloat(edtFondoInicial.Text);
             store.Open;
             idCorte:= store['ID_CORTE'];
        finally
           store.Free;
           store := nil;
        end;
     end;
     _TIPO_FONDO_POST:
     begin
        // hacer un update al corte elegido del promotor de ventas
        try
             store.StoredProcName := 'PDV_SP_FINCA_FONDO_CORTE';
             store.Params.ParamByName('_ID_CORTE').AsInteger := corte.idCorte;
             store.Params.ParamByName('_ID_TAQUILLA').AsInteger := corte.idTaquilla;
             store.Params.ParamByName('_FONDO').AsFloat := StrToFloat(edtFondoInicial.Text);
             store.Open;
             idCorte:= store['ID_CORTE'];
        finally
           store.Free;
           store := nil;
        end;
     end;
   end;

   ShowMessage('Se ha fincado un fondo fijo al usuario. ' + IntToStr(idCorte));
   self.montoFondo   :=  0;
   self.confirmacion := false;
   //imprimir  datos del fondo inicial de morralla a promotores
   imprimirFondoCaja(IntToStr(idCorte));
   cargaPromotores(lscbPromotores);
   actLimpiarExecute(Sender);
end;

procedure TfrmAsignarFondo.actCerrarExecute(Sender: TObject);
begin
   close;
end;

procedure TfrmAsignarFondo.actLimpiarExecute(Sender: TObject);
begin
   edtFondoInicial.Text:= '';
   edtTrabId.Text      := '';
   lbl2.Caption        := '';
   edtTrabId.Enabled   := true;
   case tipoFormulario of
      _TIPO_FONDO_PRE:
      begin
         edtTrabId.SetFocus;
      end;
      _TIPO_FONDO_POST:
      begin
         lscbPromotores.ItemIndex := -1;
         lscbPromotores.SetFocus;
      end;
   end;


end;

procedure TfrmAsignarFondo.btn1Click(Sender: TObject);
var corte: _corte;
begin
   if Trim(Tedit(Sender).Text) = '' then
   begin
     ShowMessage('Digite un número de empleado antes de continuar.');
     Exit;
   end;
   // revisar si el usuario esta activo
   if (comunii.regresaStatusUsuario(trim(edtTrabId.Text)) = _ESTATUS_USUARIO_BAJA ) then
   begin
     ShowMessage('El usuario está registrado como baja en el sistema actualmente, consulte con RRHH');
     exit;
   end;
   // revisar si el usuario podrá posteriormente asignarse a la venta.
   if (not comunii.privilegioUsuario(trim(edtTrabId.Text),_PRIVILEGIO_VENTA )) then
   begin
      ShowMessage('El usuario no puede realizar venta, consulte con RRHH');
      exit;
   end;
   // revisar si el promotor tiene algun corte activo
   corte:= comunii.existeCorteAbierto(trim(edtTrabId.Text));
   if (corte.idCorte>0) then
   begin
     ShowMessage('El usuario '+ corte.idEmpleado + ' está asignado en la taquilla '+
                 IntToStr(corte.idTaquilla) + ' con fecha de asignacion: '+
                 formatDateTime('dd/mm/yyyy',corte.FechaInicio) + ' en terminal '+
                 corte.idTerminal );
     exit;
   end;
   lbl2.Caption      := regresaNombreUsuario(trim(edtTrabId.Text));
   edtTrabId.Enabled := false;
end;

procedure TfrmAsignarFondo.btn2Click(Sender: TObject);
begin
   imprimirFondoCaja('29090');
end;

procedure TfrmAsignarFondo.edtTrabIdExit(Sender: TObject);
begin
   if (Trim(edtTrabId.Text) <> '') then
       btn1Click(Sender);
end;

procedure TfrmAsignarFondo.edtTrabIdKeyPress(Sender: TObject; var Key: Char);
begin
 if Key=#13 then
    btn1Click(Sender);
end;

function TfrmAsignarFondo.esNumero(cadena: String): Boolean;
begin
  result:= True;
  try
     if strToFloat(cadena) = 0 then
        result:= False;
  except
     result:= False;
     exit;
  end;
end;

procedure TfrmAsignarFondo.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   Query.Destroy;
end;

procedure TfrmAsignarFondo.FormCreate(Sender: TObject);
begin
   edtCiudad.Text := gs_terminal;
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   self.montoFondo := 0 ;
   self.confirmacion := false;
end;

procedure TfrmAsignarFondo.FormShow(Sender: TObject);
begin
   case tipoFormulario of
      _TIPO_FONDO_PRE:
      begin
         edtTrabId.Visible:=true;
         lscbPromotores.Visible := false;
      end;
      _TIPO_FONDO_POST:
      begin
         edtTrabId.Visible:=false;
         lscbPromotores.Visible := true;
         cargaPromotores(lscbPromotores);
      end;
   end;

end;

procedure TfrmAsignarFondo.imprimirFondoCaja(idCorte: String);
var  Archivo : TextFile;
     ya : Boolean;
     NombreArchivo: String;
begin
   // aquí buscar los datos del corte, los datos fueron solicitados por
   // el área de Finanzas a Óscar Parrilla en Septiembre 2018, la mejora es
   // solicitada por ERamos.
   NombreArchivo:='FondoInicial'+idCorte+'.txt';
   try
    Assignfile(Archivo, NombreArchivo);
    if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
    begin
        deleteFile(NombreArchivo);
        rewrite(Archivo); // lo crea
    end
    else
        rewrite(Archivo);   // Lo abre
    imprimeFondoInicialCaja(Archivo,idCorte);
    CloseFile(Archivo);
    ya:= false;
        repeat
             if ShellExecute(frmAsignarFondo.Handle, 'print', Pchar(NombreArchivo) ,nil, nil, SW_SHOWNORMAL) <= 32 then
                 Application.MessageBox('No se pudo ejecutar la aplicación', 'Error', MB_ICONEXCLAMATION);
            if MessageDlg(_PREGUNTA_IMPRESION_CORRECTA_3, mtConfirmation,mbYesNo,0)  =  mrYes then
                ya:= true;
        until ya;
     deleteFile(NombreArchivo);
   except
       CloseFile(Archivo);
       deleteFile(NombreArchivo);
       Exit;
   end;
end;

procedure TfrmAsignarFondo.lscbPromotoresExit(Sender: TObject);
var
   corte: _corte;
begin
   if TlsComboBox(sender).ItemIndex >= 0 then
   begin
       corte:= regresaDatosCorte(lscbPromotores.CurrentID);
       if corte.idCorte=-1 then
       begin
         ShowMessage('Promotor no tiene asignado un corte.');
         Exit;
       end;
       edtFondoInicial.Text := FloatToStr(corte.Fondo);

   end;

end;

end.
