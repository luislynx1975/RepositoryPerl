unit frmCTerminales;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  ActnList, PlatformDefaultStyleActnCtrls, ComCtrls;

type
  TfrmTerminales = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtIDterminal: TEdit;
    edtDescripcion: TEdit;
    cbTipo: TlsComboBox;
    cbTipoVenta: TlsComboBox;
    ActionMainMenuBar1: TActionMainMenuBar;
    AM1: TActionManager;
    actSalir: TAction;
    Action1: TAction;
    edtVentanillas: TEdit;
    UpDown1: TUpDown;
    lblBaja: TLabel;
    actLimpiar: TAction;
    procedure actSalirExecute(Sender: TObject);
    procedure PasaSiguiente;
    procedure edtIDterminalKeyPress(Sender: TObject; var Key: Char);
    procedure edtDescripcionKeyPress(Sender: TObject; var Key: Char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure actLimpiarExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTerminales: TfrmTerminales;

implementation

uses Uterminales, comunii;

{$R *.dfm}

procedure TfrmTerminales.Action1Execute(Sender: TObject);
begin
   if Trim(edtIDterminal.Text) <> '' then
      if uterminales.ExisteTerminal(Trim(edtIDterminal.Text)) then
         if uTerminales.ActualizaTerminal(Trim(edtIDterminal.Text),
         edtDescripcion.Text, cbTipo.CurrentID, edtVentanillas.Text, cbTipoVenta.CurrentID) then
            ShowMessage(_ACTUALIZACION_EXITOSA)
         else
            ShowMessage(_OPERACION_FALLIDA)
      else
         if uTerminales.InsertaTerminal(Trim(edtIDterminal.Text), edtDescripcion.Text, cbTipo.CurrentID, edtVentanillas.Text, cbTipoVenta.CurrentID ) then
            ShowMessage(_INSERCION_EXITOSA)
         else
            ShowMessage(_OPERACION_FALLIDA) ;


end;

procedure TfrmTerminales.actLimpiarExecute(Sender: TObject);
begin
    edtIDterminal.Text   := '';
    edtDescripcion.Text  := '';
    cbTipo.ItemIndex     := -1;
    cbTipoVenta.ItemIndex:= -1;
    edtVentanillas.Text  := '0';
    lblBaja.visible      := False;
    edtIDterminal.Enabled:= True;
    edtIDterminal.SetFocus;
end;

procedure TfrmTerminales.actSalirExecute(Sender: TObject);
begin
    Close;
end;

procedure TfrmTerminales.edtIDterminalKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
    begin
      if Trim(edtIDterminal.Text) <> '' then
      begin
         edtIDterminal.Enabled:= False;
         if uterminales.ExisteTerminal(Trim(edtIDterminal.Text)) then
         begin
           edtDescripcion.Text   :=   uTerminales.QueryTerminales.FieldByName('DESCRIPCION').Text;
           cbTipo.ItemIndex      := -1;
           cbTipo.SetID(uTerminales.QueryTerminales.FieldByName('TIPO').Text);
           cbTipoVenta.ItemIndex := -1;
           cbTipoVenta.SetID(uTerminales.QueryTerminales.FieldByName('AUTO').Text);
           edtVentanillas.Text:='0';
           edtVentanillas.Text:= uTerminales.QueryTerminales.FieldByName('VENTANILLAS').Text;
           lblBaja.Visible:= not uTerminales.QueryTerminales.FieldByName('FECHA_BAJA').IsNull;
         end;
      end;
         PasaSiguiente;
    end;

end;

procedure TfrmTerminales.edtDescripcionKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #13 then
      PasaSiguiente;
end;

procedure TfrmTerminales.FormActivate(Sender: TObject);
begin
   Uterminales.CreaQuerysT;
end;

procedure TfrmTerminales.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   Uterminales.DestruyeQuerysT;
   comunii.terminalesAutomatizadas.Free;
end;

procedure TfrmTerminales.FormCreate(Sender: TObject);
begin
  comunii.terminalesAutomatizadas:= TStringList.Create;
  comunii.cargarTodasLasTerminalesAutomatizadas;
end;

procedure TfrmTerminales.FormShow(Sender: TObject);
begin
   actLimpiarExecute(Self);
end;

procedure TfrmTerminales.PasaSiguiente;
begin
   Perform(WM_NEXTDLGCTL, 0, 0);   { mueve el foco al siguiente control }
end;

end.
