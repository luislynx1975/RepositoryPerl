unit u_vigencia_abierto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, Menus, System.Actions, Data.SqlExpr;

type
  Tfrm_vigencia_abierto = class(TForm)
    edt_codigo: TEdit;
    Label1: TLabel;
    Button1: TButton;
    ActionList1: TActionList;
    acImprime: TAction;
    MainMenu1: TMainMenu;
    Sistema1: TMenuItem;
    Salir1: TMenuItem;
    Action1: TAction;
    procedure acImprimeExecute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_vigencia_abierto: Tfrm_vigencia_abierto;

implementation

uses DMdb, comun, u_comun_venta;

{$R *.dfm}

procedure Tfrm_vigencia_abierto.acImprimeExecute(Sender: TObject);
var
    lq_qry    : TSQLQuery;
    ls_codigo : String;
    ga_datos : gga_parameters;
    li_num   : integer;
begin
    if Length(edt_codigo.Text) = 0 then begin
        ShowMessage('Ingrese el codigo para actualizar la vigencia');
        exit;
    end;
    ls_codigo := edt_codigo.Text;

    splitLine(ls_codigo,'-',ga_datos, li_num);
    if li_num <> 1 then begin
        ShowMessage('No tiene el formato correcto para actualizar la vigencia');
        exit;
    end;

    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(FORMAT(_CODIGO_BOLETO_VIGENCIA, [ga_datos[1]] ), lq_qry, _local) then begin
       if lq_qry['TOTAL'] = 0 then begin
          ShowMessage('Este boleto ya se realizo la impresion de boletos');
          edt_codigo.Clear;
          edt_codigo.SetFocus;
          exit;
       end;
    end;

    if EjecutaSQL(FORMAT(_ABIERTO_BUSCA_CODIGO, [ga_datos[1]] ), lq_qry, _local) then begin
       ls_codigo := getCodeBoletoAbierto();
       if EjecutaSQL(FORMAT(_ABIERTO_UPDATE_CODIGO, [ls_codigo, ls_codigo, gs_trabid, ga_datos[1]] ), lq_qry, _local) then begin
           if EjecutaSQL(format(_ABIERTO_PROMOCION_BOLETO, [ls_codigo] ), lq_qry, _LOCAL) then begin
              if gs_impresora_boleto = _IMP_TOSHIBA_TEC then //impresora TEC Toshiba
                  imprimeVigenciaSX4(lq_qry);
              if gs_impresora_boleto = _IMP_IMPRESORA_OPOS then //impresora Toshiba miniprinter
                  imprimeVigenciaNuevaTermica(lq_qry);
 //revisar nada mas esta consulta
              if EjecutaSQL(Format(_ABIERTO_CORRIDA_UPDATE,[ls_codigo, ga_datos[1]]), lq_qry, _LOCAL) then
                  ;

              edt_codigo.Clear;
           end else begin
              ShowMessage('Verifique el codigo o intente nuevamente');
              edt_codigo.Clear;
              edt_codigo.SetFocus;
           end;
       end;
    end else begin
        ShowMessage('No existe el codigo ingresado');
        exit;
    end;
    lq_qry.Free;
    Close
end;


procedure Tfrm_vigencia_abierto.Action1Execute(Sender: TObject);
begin
  Close;
end;

end.
