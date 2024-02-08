unit frm_periodo_vacacional;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ToolWin, ActnMan, ActnCtrls, ActnMenus, ActnList,
  PlatformDefaultStyleActnCtrls, FMTBcd, System.Actions, Data.SqlExpr;

type
  Tfrm_vacacional = class(TForm)
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtp_inicio: TDateTimePicker;
    dtp_fin: TDateTimePicker;
    dtp_hora_inicio: TDateTimePicker;
    dtp_hora_fin: TDateTimePicker;
    StatusBar1: TStatusBar;
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_vacacional: Tfrm_vacacional;

implementation

uses DMdb, comun, u_main;

var
    lq_qry : TSQLQuery;
    ld_fecha_inicio : TDate;
{$R *.dfm}

procedure Tfrm_vacacional.Action1Execute(Sender: TObject);
var
    ls_fecha_inicio, ls_fecha_fin : string;
begin
    if not AccesoPermitido(187,false) then
        exit;

    ls_fecha_inicio := DateToStr(dtp_inicio.Date)+ ' '+ TimeToStr(dtp_hora_inicio.Time);
    ls_fecha_fin := DateToStr(dtp_fin.Date)+ ' '+ TimeToStr(dtp_hora_fin.Time);
    if StrToDateTime(ls_fecha_inicio) > StrToDateTime(ls_fecha_fin) then begin
       dtp_inicio.Date := ld_fecha_inicio;
       Mensaje(_MSG_PERIODO_ERROR,1);
       exit;
    end;

    if EjecutaSQL(Format(_PERIODO_VACACIONAL_UPDATE,[
                       FormatDateTime('YYYY-MM-DD HH:MM',StrToDateTime(ls_fecha_inicio)),
                       FormatDateTime('YYYY-MM-DD HH:MM',StrToDateTime(ls_fecha_fin)) ]),lq_qry,_TODOS) then begin
        Mensaje(format(_MSG_PERIODO_VACACIONAL,[ls_fecha_inicio,ls_fecha_fin]),2);
        close;
    end;

end;

procedure Tfrm_vacacional.Action2Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_vacacional.FormShow(Sender: TObject);
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_PERIODO_VACACIONAL,lq_qry,_LOCAL) then begin
        if not VarIsNull(lq_qry['FECHA_INICIO']) then begin
            dtp_inicio.Date := lq_qry['FECHA_INICIO'];
            ld_fecha_inicio := lq_qry['FECHA_INICIO'];
            dtp_fin.Date    := lq_qry['FECHA_FIN'];
            dtp_hora_inicio.Time := lq_qry['HORA_INICIO'];
            dtp_hora_fin.Time := lq_qry['HORA_FIN'];
        end;
    end;
end;

end.
