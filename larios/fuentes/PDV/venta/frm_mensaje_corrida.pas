unit frm_mensaje_corrida;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,  comun, DMdb, Data.SqlExpr, ComCtrls;

type
  TFrm_Corrida_Ocupada = class(TForm)
    Timer1: TTimer;
    lbl1: TLabel;
    Button1: TButton;
    StatusBar1: TStatusBar;
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    li_corrida : String;
    ls_terminal : string;
    ls_fecha   : string;
    ls_hora    : string;
    procedure setCorrida(const Value: String);
    procedure setTerminal(const Value: String);
    procedure setFechaCorrida(const Value: string);
    procedure setHoraCorrida(const Value: string);
  public
    { Public declarations }
    property corrida : String write setCorrida;
    property terminal : String write setTerminal;
    property fecha   : string  write setFechaCorrida;
    property hora    : string  write setHoraCorrida;
  end;

var
  Frm_Corrida_Ocupada: TFrm_Corrida_Ocupada;

implementation

uses u_comun_venta;

{$R *.dfm}


procedure TFrm_Corrida_Ocupada.Button1Click(Sender: TObject);
begin
    gi_usuario_ocupado := 0;
    gi_corrida_en_uso  := 1;
    Close();
end;


procedure TFrm_Corrida_Ocupada.FormActivate(Sender: TObject);
begin
    gi_usuario_ocupado := 1;
end;


procedure TFrm_Corrida_Ocupada.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = VK_F4) and (ssAlt in Shift) then Key := 0;
end;

procedure TFrm_Corrida_Ocupada.FormKeyPress(Sender: TObject; var Key: Char);
begin
    if Key = #27 then begin
        gi_usuario_ocupado := 0;
        gi_corrida_en_uso  := 1;
        Close();
    end;
end;


procedure TFrm_Corrida_Ocupada.FormShow(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
//hacemos la busqueda de la persona que esta ocupando la corrida
    lq_qry  := TSQLQuery.Create(nil);
    try
        lq_qry.SQLConnection := CONEXION_VTA;
        if EjecutaSQL(Format(_CORRIDA_OCUPADA_VENTA,[FormatDateTime('YYYY-MM-DD',StrToDate(ls_fecha)),ls_hora]),lq_qry,_LOCAL) then
            lbl1.Caption := Format(_MENSAJE_CORRIDA_OCUPADA,[lq_qry['TRAB_ID'], lq_qry['NOMBRE']]);
    finally
        lq_qry.Destroy;
    end;
end;

procedure TFrm_Corrida_Ocupada.setCorrida(const Value: String);
begin
    if Value <> '' then
        li_corrida := Value;
end;


procedure TFrm_Corrida_Ocupada.setFechaCorrida(const Value: string);
begin
    if Value <> '' then
        ls_fecha := Value;
end;

procedure TFrm_Corrida_Ocupada.setHoraCorrida(const Value: string);
begin
    if Value <> '' then
        ls_hora := Value;
end;

procedure TFrm_Corrida_Ocupada.setTerminal(const Value: String);
begin
    if Value <> '' then
        ls_terminal := Value;
end;

procedure TFrm_Corrida_Ocupada.Timer1Timer(Sender: TObject);
var
    ls_usuario : string;
begin
    ls_usuario := storeApartacorrida(li_corrida,StrToDate(ls_fecha),ls_terminal, gs_trabid);
    if ls_usuario <> gs_trabid then
        gi_usuario_ocupado := 0;
    if ls_usuario = gs_trabid then
        Close;
end;

end.
