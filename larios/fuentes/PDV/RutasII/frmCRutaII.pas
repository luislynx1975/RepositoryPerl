unit frmCRutaII;
{
Autor: Gilberto Almanza Maldonado
Fecha: 25 de Noviembre
Descripcion: forma para administrar las Rutas
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ActnList, PlatformDefaultStyleActnCtrls, ActnMan,
  ToolWin, ActnCtrls, ActnMenus, lsCombobox, Grids, ComCtrls, System.Actions;

const
  _ID_AUTOMATICO = 'Automatico';
  _CONFIRMAR_SI = MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON1;
  _CONFIRMAR_NO = MB_ICONQUESTION + MB_YESNO + MB_DEFBUTTON2;

type
  TfrmCRutasII = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    AM1: TActionManager;
    actSalir: TAction;
    actLimpiar: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    actGuardar: TAction;
    actBuscar: TAction;
    Paginas: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblRuta: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtIdRuta: TEdit;
    cbOrigen: TlsComboBox;
    cbDestino: TlsComboBox;
    edKilometros: TEdit;
    edMinutos: TEdit;
    TabSheet2: TTabSheet;
    Label4: TLabel;
    lblOrigenTramo: TLabel;
    Button1: TButton;
    cbTramos: TlsComboBox;
    btnAgregar: TButton;
    btnCatalogoTramos: TButton;
    sagTramos: TStringGrid;
    procedure actSalirExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbDestinoExit(Sender: TObject);
    procedure btnAgregarClick(Sender: TObject);
    procedure PasaSiguiente;
    procedure cbOrigenKeyPress(Sender: TObject; var Key: Char);
    procedure LimpiaSag(sag:TStringGrid);
    procedure sagTramosDblClick(Sender: TObject);
    procedure cbOrigenExit(Sender: TObject);
    procedure btnCatalogoTramosClick(Sender: TObject);
    procedure actGuardarExecute(Sender: TObject);
    Function InsertaRutaNueva: Boolean;
    Function ActualizaRuta: Boolean;
    procedure edMinutosKeyPress(Sender: TObject; var Key: Char);
    procedure actLimpiarExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure actBuscarExecute(Sender: TObject);
    procedure edtIdRutaKeyPress(Sender: TObject; var Key: Char);
    procedure CargaRuta(IdRuta : String);
    procedure RevisaRutas(Origen, Destino: String);
  private
    { Private declarations }
  public
    { Public declarations }
    sagTramosMio: TStringGrid;
    terminal_origen, terminal_destino: String;
  end;

var
  frmCRutasII: TfrmCRutasII;

implementation

uses uRutasII, comun, comunii, frmCtramos, frmRutasRepetidas;

{$R *.dfm}

procedure TfrmCRutasII.actBuscarExecute(Sender: TObject);
begin
    lblRuta.Caption:= ' R U T A ';
    cbOrigen.Enabled:=  False;
    cbDestino.Enabled:= False;
    cbOrigen.ItemIndex:=  -1;
    cbDestino.ItemIndex:= -1;
    lblOrigenTramo.Caption:= '';
    edKilometros.Text     := '';
    edMinutos.Text        := '';
    edtIdRuta.Text        := _ID_AUTOMATICO;
    LimpiaSag(sagTramos);
    LimpiaSag(sagTramosMio);
    Paginas.TabIndex:=0;
    edtIdRuta.Enabled:= True;
    edtIdRuta.SetFocus;
end;

procedure TfrmCRutasII.actGuardarExecute(Sender: TObject);
begin
  if ((cbOrigen.ItemIndex = cbDestino.ItemIndex) or
        (cbOrigen.ItemIndex < 0) or
        (cbDestino.ItemIndex < 0) or
        (Trim(edKilometros.Text)='') or
        (Trim(edMinutos.Text)='')  ) then
   begin
     ShowMessage(_INFORMACION_INSUFICIENTE);
     Exit;
   end;

   comunii.terminalesAutomatizadas:=  TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;

   if UpperCase(edtIdRuta.Text) = upperCase(_ID_AUTOMATICO) then
   begin
      if Application.MessageBox(_CONFIRMA_NUEVA_RUTA, _CONFIRMACION_USUARIO ,_CONFIRMAR_SI) = mrYes then
         if InsertaRutaNueva then ShowMessage(_OPERACION_SATISFACTORIA); // inserta una nueva ruta y la replica
   end
   else if UpperCase(edtIdRuta.Text) <> upperCase(_ID_AUTOMATICO) then
   begin
      sql:= format(_CONFIRMA_ACTUALIZA_RUTA,[edtIdRuta.Text]);
      if Application.MessageBox(Pchar(sql), _CONFIRMACION_USUARIO ,_CONFIRMAR_SI) = mrYes then
         if ActualizaRuta then ShowMessage(_OPERACION_SATISFACTORIA);  // actualiza una ruta y la replica
   end;
   comunii.terminalesAutomatizadas.Free;
end;

procedure TfrmCRutasII.actLimpiarExecute(Sender: TObject);
begin
    lblRuta.Caption:= ' R U T A ';
    cbOrigen.Enabled:=  True;
    cbDestino.Enabled:= True;
    cbOrigen.ItemIndex:=  -1;
    cbDestino.ItemIndex:= -1;
    lblOrigenTramo.Caption:= '';
    edKilometros.Text     := '';
    edMinutos.Text        := '';
    edtIdRuta.Text        := _ID_AUTOMATICO;
    LimpiaSag(sagTramos);
    LimpiaSag(sagTramosMio);
    btnAgregar.Enabled:= True;
    cbTramos.Enabled  := True;
    btnCatalogoTramos.Enabled:= True;
    LlenaTramosCon(uRutasII._CAMPO_ORIGEN, '', cbTramos);
    paginas.TabIndex:=0;
    cbOrigen.SetFocus;
end;

procedure TfrmCRutasII.actSalirExecute(Sender: TObject);
begin
   Close;
end;

function TfrmCRutasII.ActualizaRuta: Boolean;
var renglones, i: Integer;
begin
        result:= False;
        TRY
            Sql:=Format(_SQL_ACTUALIZA_RUTA,[QuotedStr(cbOrigen.CurrentID), QuotedStr(cbDestino.CurrentID), Trim(edMinutos.Text), Trim(edKilometros.Text),EdtIdRuta.Text  ]);
            if EjecutaSQL(sql, QueryRutas, _LOCAL) then
            begin
                sqlReplica := sql;
                comunii.replicarTodos(sqlReplica);
                sql := Format(_SQL_ELIMINA_RUTA_D,[edtIdRuta.Text]) ;
                if EjecutaSQL(sql,QueryRutas,_LOCAL) then
                begin
                    sqlReplica := sql;
                    comunii.replicarTodos(sqlReplica);
                end;
                if sagTramos.Cells[sagTramos.ColCount-1,sagTramos.RowCount-1] = '' then
                   renglones:= sagTramos.RowCount - 2
                else
                   renglones:= sagTramos.RowCount - 1;
                for I := 1 to renglones do
                begin
                  sql:= format(_SQL_INSERTA_RUTA_D,[Trim(edtIdRuta.Text) , sagTramosMio.Cells[0,I] , inttoStr(I) ]);
                  if EjecutaSQL(sql,QueryRutas,_LOCAL) then
                  begin
                    sqlReplica := sql;
                    comunii.replicarTodos(sqlReplica);
                  end;
                end;
            end;
        EXCEPT
            sql := Format(_SQL_ELIMINA_RUTA_D,[edtIdRuta.Text]) ;
            EjecutaSQL(sql,QueryRutas,_TODOS);
            comunii.terminalesAutomatizadas.Free;
            result:= False;
            Exit;
        END;
        result:= True;
end;

procedure TfrmCRutasII.btnAgregarClick(Sender: TObject);
begin
   if (cbTramos.itemIndex < 0) then
   begin
     ShowMessage(uRutasii._FALTA_TRAMO);
     Exit;
   end;
   lblOrigenTramo.Caption:= InsertaTramo(cbTramos.CurrentID, sagTramos, sagTramosMio);
   cbTramos.SetFocus;
   if terminal_destino = cbDestino.CurrentID  then
   begin
     btnAgregar.Enabled:= False;
     cbTramos.Enabled  := False;
     btnCatalogoTramos.Enabled:= False;
   end;

end;

procedure TfrmCRutasII.btnCatalogoTramosClick(Sender: TObject);
begin
   if not AccesoPermitido(125, _RECUERDA_TAGS) then
        Exit;
   try
        comunii.tipoVentanaTramos:= comunii._TIPO_PRE_LLENADO; // abrir el formulario con prellenado
        if ((terminal_origen = cbOrigen.CurrentID) and
             (sagTramos.RowCount = 2 )) then
            comunii.Origen:= terminal_origen
        else
            comunii.Origen:= terminal_destino;

        frmTramos := TfrmTramos.Create(Self);
        frmTramos.ShowModal;
        if ((terminal_origen = cbOrigen.CurrentID) and
             (sagTramos.RowCount = 2 )) then
            uRutasII.LlenaTramosCon(uRutasII._CAMPO_ORIGEN, terminal_origen, cbTramos)
        else
            uRutasII.LlenaTramosCon(uRutasII._CAMPO_ORIGEN, terminal_destino, cbTramos);
   finally
       frmTramos.Free;
       frmTramos := nil
   end;
end;

procedure TfrmCRutasII.Button1Click(Sender: TObject);
begin
   LimpiaSag(sagTramos);
   LimpiaSag(sagTramosMio);
   cbDestinoExit(Sender);
end;

procedure TfrmCRutasII.CargaRuta(IdRuta: String);
begin
   sql:= FORMAT(_SQL_SELECT_RUTA,[idRuta]);
   if EjecutaSQL(sql,QueryRutas,_LOCAL) then
   begin
      cbOrigen.SetID(queryRutas.FieldByName('ORIGEN').AsString);
      cbDestino.SetID(queryRutas.FieldByName('DESTINO').AsString);
      edKilometros.Text:= queryRutas.FieldByName('KM').AsString;
      edMinutos.Text   := queryRutas.FieldByName('MINUTOS').AsString;
   end;
   sql:= FORMAT(_SQL_SELECT_RUTA_D,[idRuta]);
   if EjecutaSQL(sql,QueryRutas,_LOCAL) then
   begin
      LimpiaSag(sagTramos);
      DataSetToSag(QueryRutas,sagTramos);
      sql:= FORMAT(_SQL_SELECT_RUTA_D_MIO,[idRuta]);
      if EjecutaSQL(sql,QueryRutas,_LOCAL) then
      begin
        LimpiaSag(sagTramosMio);
        DataSetToSag(QueryRutas,sagTramosMio);
      end;
   end;

end;

procedure TfrmCRutasII.cbDestinoExit(Sender: TObject);
begin
    if cbDestino.CurrentID = cbOrigen.CurrentID then
    begin
      ShowMessage(_ORIGEN_DESTINO_IGUALES);
      cbOrigen.SetFocus;
      Exit;
    end;

    if cbDestino.ItemIndex < 0 then
       cbdestino.SetFocus
    else
    begin
        lblRuta.Caption:= cbOrigen.CurrentID + ' - ' + cbDestino.CurrentID;
        cbOrigen.Enabled:=  False;
        cbDestino.Enabled:= False;
        lblOrigenTramo.Caption:= cbOrigen.CurrentItem;
        uRutasII.LlenaTramosCon(uRutasII._CAMPO_ORIGEN, cbOrigen.CurrentID, cbTramos);
        terminal_origen := cbOrigen.CurrentID;
        terminal_destino:= cbDestino.CurrentID;
        RevisaRutas(terminal_origen, terminal_destino);
    end;
end;

procedure TfrmCRutasII.cbOrigenExit(Sender: TObject);
begin
   if cbDestino.ItemIndex < 0 then
       cbdestino.SetFocus
end;

procedure TfrmCRutasII.cbOrigenKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
     PasaSiguiente;
end;

procedure TfrmCRutasII.edMinutosKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
    begin
     Paginas.TabIndex:=1;
     cbTramos.SetFocus;
    end;
end;

procedure TfrmCRutasII.edtIdRutaKeyPress(Sender: TObject; var Key: Char);
begin
   if Key = #13 then
      if Trim(edtIdRuta.Text) <> '' then
      begin
         CargaRuta(Trim(edtIdRuta.Text));
         LlenaTramosCon(uRutasII._CAMPO_ORIGEN, cbOrigen.CurrentID, cbTramos);
         // uRutasII.LlenaTramosCon(uRutasII._CAMPO_ORIGEN, terminal_origen, cbTramos)
         edtIdRuta.Enabled:= False;
      end;

end;

procedure TfrmCRutasII.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   uRutasII.DestruyeQuerysR;
   sagTramosMio.Free;

end;

procedure TfrmCRutasII.FormCreate(Sender: TObject);
begin
   uRutasII.CreaQuerysR;
   sagTramosMio:= TStringGrid.Create(Self);
end;

procedure TfrmCRutasII.FormShow(Sender: TObject);
begin
   LlenaCiudadesTodas(cbOrigen);
   LlenaCiudadesTodas(cbDestino);
   edtIdRuta.Text:= _ID_AUTOMATICO;
   SagTramosMio.ColCount:= sagTramos.ColCount;
   SagTramosMio.RowCount:= sagTramos.RowCount;
   Paginas.TabIndex:=0;
end;

function TfrmCRutasII.InsertaRutaNueva: Boolean;
var i: Integer;
    aux: String;
begin
   result:= False;
   TRY
      Sql:= Format(_SQL_INSERTA_RUTA, [QuotedStr(cbOrigen.CurrentID),QuotedStr(cbDestino.CurrentID),
                                       Trim(edKilometros.Text) , Trim(edMinutos.Text)]);
      if EjecutaSQL(sql, QueryRutas, _LOCAL) then
      BEGIN
        AUX := regresaRuta(QuotedStr(cbOrigen.CurrentID),
                                QuotedStr(cbDestino.CurrentID),
                                Trim(edKilometros.Text),
                                Trim(edMinutos.Text));
        edtIdRuta.Text:= AUX;
        sqlReplica :=  Format(_SQL_INSERTA_RUTA_VALUE, [AUX, QuotedStr(cbOrigen.CurrentID),QuotedStr(cbDestino.CurrentID), Trim(edKilometros.Text) , Trim(edMinutos.Text)]);
        comunii.replicarTodos(Format(sqlReplica,[AUX]));
      END;


      for I := 1 to sagTramos.RowCount - 2 do
      begin
          sql:= format(_SQL_INSERTA_RUTA_D,[Trim(edtIdRuta.Text) , sagTramosMio.Cells[0,I] , inttoStr(I) ]);
          if  EjecutaSQL(sql,QueryRutas,_LOCAL) then
              comunii.replicarTodos(sql);
      end;
   EXCEPT
      sql := Format(_SQL_ELIMINA_RUTA_D,[edtIdRuta.Text]) ;
      EjecutaSQL(sql,QueryRutas,_LOCAL);
      comunii.replicarTodos(sql);
      comunii.terminalesAutomatizadas.Free;
      result:= False;
      Exit;
   END;
   result:= True;
end;

procedure TfrmCRutasII.LimpiaSag(sag: TStringGrid);
var col, ren: Integer;
begin
   for col:=0 to sag.RowCount do
     for ren:= 0 to sag.RowCount do
        sag.Cells[col,ren]:='';
   sag.RowCount := 2;
   sag.Cells[0,0]:= _CAMPO_ORIGEN;
   sag.Cells[1,0]:= _CAMPO_DESTINO;
   sag.Cells[2,0]:= _ORDEN;
end;

procedure TfrmCRutasII.PasaSiguiente;
begin
    Perform(WM_NEXTDLGCTL, 0, 0);   { mueve el foco al siguiente control }
end;

procedure TfrmCRutasII.RevisaRutas(Origen, Destino: String);
begin
   sql:='SELECT * FROM T_C_RUTA WHERE ORIGEN='+QuotedStr(Origen)+
        ' AND DESTINO='+QuotedStr(Destino);
   EjecutaSQL(sql,QueryRutas,_LOCAL);
   if QueryRutas.IsEmpty then
      exit;
   comun.DataSetToSag(QueryRutas, frmRutaRepetida.sagRutas);
   frmRutaRepetida.edtOrigen.Text := Origen;
   frmRutaRepetida.edtDestino.Text:= Destino;
   frmRutaRepetida.showModal;


end;

procedure TfrmCRutasII.sagTramosDblClick(Sender: TObject);
var I: Integer;
begin
   SQL:='';
   for I := 0 to sagTramos.RowCount - 1 do
     SQL:= SQL +sagTramos.Cells[0, I] +  ' - ' +
                 sagTramos.Cells[1, I] +
                 '   ' +
                 sagTramosMio.Cells[0, I] + CHAR(13);
   ShowMessage(SQL);
end;

end.
