unit Frm_cancela_boletos;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, lsCombobox, U_venta, Frm_vta_main,
  comun, Grids, ComCtrls, ActnList, StdActns, PlatformDefaultStyleActnCtrls,
  ActnMan, ToolWin, ActnCtrls, ActnMenus, lsNumericEdit, System.Actions,
  Data.SqlExpr;

type
  TFrm_cancelaciones = class(TForm)
    StatusBar1: TStatusBar;
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    acSalir: TAction;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edt_promotor: TEdit;
    ls_Origen_vta: TlsComboBox;
    edt_boleto: TlsNumericEdit;
    Button1: TButton;
    Action1: TAction;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acSalirExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FUserAsignado: string;
    FTaquillaAsignada: integer;
    function validaEntrada() : boolean;
  public
    { Public declarations }
    property UserAsignado : string write FUserAsignado ;
    property taquilla : integer write FTaquillaAsignada;
  end;

var
  Frm_cancelaciones: TFrm_cancelaciones;

implementation

uses DMdb, TLiberaAsientosRuta;

{$R *.dfm}



procedure TFrm_cancelaciones.acSalirExecute(Sender: TObject);
begin
    Close;
end;

procedure TFrm_cancelaciones.Action1Execute(Sender: TObject);
var
    STORE : TSQLStoredProc;
    ls_promotor, ls_autoriza : STring;
begin
////ejecutamos la cancelacion
    if not validaEntrada then begin //eliminamos el boleto
      if not AccesoPermitido(168,False) then
          Exit;
      ls_promotor:= gs_trabid;
      if FUserAsignado <> gs_trabid then begin //si el usuario es diferente al de la venta
          Mensaje('Error en la asignacion no esta asignado a la venta',1);
          gs_trabid := ls_promotor_asignado;
          exit;
      end;
      ls_autoriza := gs_trabid;
      if not AccesoPermitido(169,False) then
          exit;

      STORE := TSQLStoredProc.Create(nil);
      STORE.SQLConnection := DM.Conecta;
      STORE.close;
      STORE.StoredProcName := 'PDV_STORE_CANCELA_BOLETO';
      STORE.Params.ParamByName('IN_FOLIO').AsInteger := StrToInt(edt_boleto.Text);
      STORE.Params.ParamByName('IN_TRABID').AsString := edt_promotor.Text;
      STORE.Params.ParamByName('IN_TERMINAL').AsString := ls_Origen_vta.CurrentID;
      STORE.Params.ParamByName('IN_TAQUILLA').AsInteger := gi_taquilla_store;
      STORE.Params.ParamByName('IN_TRABVTA').AsString  := ls_promotor;
      STORE.Params.ParamByName('IN_AUTORIZA').AsString := ls_autoriza;
      STORE.Open;
      if STORE['OUT_RUTA'] = 0 then begin
          mensaje('No existe el registro del boleto verifiquelo o ha sido cancelado',1);
      end;

    end;
end;

procedure TFrm_cancelaciones.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
     Close();
end;

procedure TFrm_cancelaciones.FormShow(Sender: TObject);
var
    lq_terminals : TSQLQuery;
begin
  lq_terminals := TSQLQuery.Create(nil);
  lq_terminals.SQLConnection := DM.Conecta;
  if EjecutaSQL(format(_VTA_TERMINALES_ORIGEN, [gs_terminal]), lq_terminals, _LOCAL) then
    LlenarComboBox(lq_terminals, ls_Origen_vta, True);

  lq_terminals.destroy;
end;

function TFrm_cancelaciones.validaEntrada: boolean;
var
    out_bol : boolean;
begin
    out_bol := false;
    if length(edt_promotor.text) = 0 then begin
        mensaje('Ingrese la clave del promotor',1);
        edt_promotor.SetFocus;
        out_bol := true;
        exit;
    end;
    if length(edt_boleto.text) = 0 then begin
        mensaje('Ingrese el folio del boleto',1);
        edt_boleto.SetFocus;
        out_bol := true;
        exit;
    end;
    result := out_bol;
end;

end.
