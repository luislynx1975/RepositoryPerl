unit frmMrecolecccion;

{Autor: Gilberto Almanza Maldonado
Fecha: Jueves, 8 de Julio de 2010.
Modulo que contiene permite realizar recolecciones apoyandese de la
Unidad: Urecoleccion.
Ultima Modificacion: 24-01-2011 GAM}

interface
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, PlatformDefaultStyleActnCtrls, ActnList, ActnMan, StdCtrls,
  ImgList, FMTBcd, DB, System.ImageList, System.Actions, Data.SqlExpr;


type
  TfrmRecoleccion = class(TForm)
    Panel1: TPanel;
    ActionManager1: TActionManager;
    Label1: TLabel;
    lblNombrePromotor: TLabel;
    Label2: TLabel;
    edtRecoleccion: TEdit;
    Button1: TButton;
    Button2: TButton;
    lblDatos: TLabel;
    Action1: TAction;
    Action2: TAction;
    ImageList1: TImageList;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtCajero: TEdit;
    procedure Action2Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure edtRecoleccionKeyPress(Sender: TObject; var Key: Char);
    procedure edtCajeroKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function esNumero(cadena : String) : Boolean;
  public
    { Public declarations }
  end;

var
  frmRecoleccion: TfrmRecoleccion;

implementation

uses comun, Urecoleccion, comunii, DMdb, U_venta, frm_registro_folios;

{$R *.dfm}

procedure TfrmRecoleccion.Action1Execute(Sender: TObject);
var Query: TSQLQuery;
    sp:    TSQLStoredProc;
    lf_folio : Tfrm_folio_registro;
begin
  if not esNumero(edtRecoleccion.Text) then begin
     Showmessage(_ERROR_FORMATO_NUMERO);
     edtRecoleccion.SetFocus;
     exit;
   end;
   if URecoleccion.MontoRecolecta = 0 then begin
      URecoleccion.MontoRecolecta:= strToFloat(edtRecoleccion.Text);
      edtRecoleccion.Text:='';
      Label2.Caption:= 'Confirma Monto Recolectar:';
      label2.Font.Color:= clRed;
      label2.Font.Style:= [fsBold];
      edtRecoleccion.SetFocus;
      Exit;
   end;
   if URecoleccion.MontoRecolecta <> 0 then
      if URecoleccion.MontoRecolecta <> strToFloat(edtRecoleccion.Text) then
      begin
         URecoleccion.MontoRecolecta:= 0.0;
         ShowMessage('Error de captura, intentelo nuevamente.');
         Label2.Caption:= 'Monto a Recolectar:';
         label2.Font.Color:= clBlack;
         label2.Font.Style:= [fsBold];
         edtRecoleccion.Text:='';
         edtRecoleccion.SetFocus;
         Exit;
      end;
   if URecoleccion.MontoCajero = 0 then begin
      URecoleccion.MontoCajero:= strToFloat(edtCajero.Text);
      edtCajero.Text:='';
      Label5.Caption:= 'Confirma Monto Recolectar:';
      label5.Font.Color:= clRed;
      label5.Font.Style:= [fsBold];
      edtCajero.SetFocus;
      Exit;
   end;
   if URecoleccion.MontoCajero <> 0 then
      if URecoleccion.MontoCajero <> strToFloat(edtCajero.Text) then begin
         URecoleccion.MontoCajero:= 0.0;
         ShowMessage('Error de captura, intentelo nuevamente.');
         Label5.Caption:= 'Monto a Recolectar:';
         label5.Font.Color:= clBlack;
         label5.Font.Style:= [fsBold];
         edtCajero.Text:='';
         edtCajero.SetFocus;
         Exit;
      end;
  if ((uRecoleccion.MontoRecolecta  <> 0) and
      (uRecoleccion.MontoCajero     <> 0) and
      (uRecoleccion.MontoRecolecta  <>
       uRecoleccion.MontoCajero)) then
  begin
          ShowMessage('Error de captura.'+ char(13)+
                      'Las cantidades del promotor y del cajero no coinciden.'+ char(13)+
                      'Intentelo nuevamente.');
          URecoleccion.MontoRecolecta:= 0.0;
          URecoleccion.MontoCajero   := 0.0;
          Label2.Caption:= 'Monto a Recolectar:';
          label5.Caption:= 'Monto a Recolectar:';
          label2.Font.Color:= clBlack;
          label2.Font.Style:= [fsBold];
          label5.Font.Color:= clBlack;
          label5.Font.Style:= [fsBold];
          edtRecoleccion.Text:='';
          edtCajero.Text:='0';
          edtRecoleccion.SetFocus;
          Exit;
  end;

  if not AccesoPermitido(180, _NO_RECUERDA_TAGS) then
  begin
          URecoleccion.MontoRecolecta:= 0.0;
          URecoleccion.MontoCajero   := 0.0;
          Label2.Caption:= 'Monto a Recolectar:';
          label5.Caption:= 'Monto a Recolectar:';
          label2.Font.Color:= clBlack;
          label2.Font.Style:= [fsBold];
          label5.Font.Color:= clBlack;
          label5.Font.Style:= [fsBold];
          edtRecoleccion.Text:='';
          edtCajero.Text:='0';
          edtRecoleccion.SetFocus;
          Exit;
  end;
  comunii.Recaudador := gs_trabId;
  Query:= TSQLQuery.Create(Self);
  Query.SQLConnection := dm.Conecta;
  sp   := TSQLStoredProc.Create(self);
  sp.SQLConnection   := dm.Conecta;
  try
     sp.SQLConnection := DM.Conecta;
     sp.close;
     sp.StoredProcName:= 'PDV_RECOLECTA';
     sp.params.ParamByName('_TERMINAL').AsString  :=  comun.gs_terminal;
     sp.params.ParamByName('_TAQUILLA').AsInteger := strToInt(comun.gs_maquina);
     sp.params.ParamByName('_EMPLEADO').AsString  :=  comunii.Recaudado;
     sp.params.ParamByName('_EMPLEADO_REALIZA').AsString:=  comunii.Recaudador;
     sp.params.ParamByName('_IMPORTE').AsFloat    :=   strToFloat(edtRecoleccion.Text);
     sp.Open;
     case sp.FieldByName('_ESTATUS').AsInteger of
        1: BEGIN
           ShowMessage(_RECOLECCION_EXITOSA);
           Label2.Caption:= 'Recoleccion Exitosa';
           label2.Font.Color:= clBlack;
           label2.Font.Style:= [fsBold];
           label5.Caption:= 'Monto a Recolectar:';
           label5.Font.Color:= clBlack;
           label5.Font.Style:= [fsBold];
           valoresIniciales();
           ImprimeCargaArqueo(gs_terminal,gs_maquina, comunii.Recaudado, comunii.Recaudador,edtRecoleccion.Text, lblNombrePromotor.Caption);
           insertaEvento(gs_trabId,gs_terminal,'Recoleccion en la taquilla : '+ gs_maquina);
        END;
        2: BEGIN ShowMessage(_ESTATUS_2_RECOLECCION); END;
        3: BEGIN ShowMessage(_ESTATUS_3_RECOLECCION); END;
     end;
  finally
     SP.Free;
     button1.Enabled:= False;
     Close;
  end;
end;


procedure TfrmRecoleccion.Action2Execute(Sender: TObject);
begin
   Close;
end;

procedure TfrmRecoleccion.edtCajeroKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
   if Key = #13 then
      if action1.Enabled then
          button1.SetFocus
      else
          button2.SetFocus;
end;

procedure TfrmRecoleccion.edtRecoleccionKeyPress(Sender: TObject;
  var Key: Char);
begin
   if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
   if Key = #13 then
      if action1.Enabled then
          button1.SetFocus
      else
          button2.SetFocus;
end;

function TfrmRecoleccion.esNumero(cadena: String): Boolean;
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

procedure TfrmRecoleccion.FormShow(Sender: TObject);
begin
   uRecoleccion.MontoRecolecta:= 0.0;
   uRecoleccion.MontoCajero   := 0.0;
   edtRecoleccion.Text:='0';
   edtCajero.Text     :='0';
   lblDatos.Caption:=           uRecoleccion.RegresaDatosLocales;
   lblNombrePromotor.Caption := uRecoleccion.RegresaNombrePromotor;
   if (lblNombrePromotor.Caption = Urecoleccion._ERROR_PROMOTOR) or
      (lblNombrePromotor.Caption = Urecoleccion._PROMOTOR_NO_ASIGNADO) then
          action1.Enabled:= False;
end;



end.
