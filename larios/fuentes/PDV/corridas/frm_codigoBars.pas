unit frm_codigoBars;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  StdCtrls, Data.SqlExpr, System.Actions;

type
  Tfrm_bars = class(TForm)
    mem_bars: TMemo;
    ActionToolBar1: TActionToolBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    Label1: TLabel;
    lbl_mensaje: TLabel;
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure mem_barsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_bars: Tfrm_bars;

implementation

uses DMdb, comun, u_barsCode;

{$R *.dfm}

procedure Tfrm_bars.Action1Execute(Sender: TObject);
var
    ls_bars, ls_corrida, ls_hora,
    ls_autobus, ls_servicio, ls_ruta,
    ls_detalle, ls_cupo, ls_master,ls_fecha : string;
    lq_qry : TSQLQuery;
begin
    ls_bars := mem_bars.Text;
    if Length(ls_bars) <> 26 then begin
        Mensaje('No es un codigo valido',2);
        mem_bars.Clear;
        exit;
    end;
    ls_corrida := Copy(ls_bars,1,6);
    ls_hora    := Copy(ls_bars,7,3) + ':' + Copy(ls_bars,10,2);
    ls_autobus := Copy(ls_bars,13,2);
    ls_servicio := Copy(ls_bars,14,2);
    ls_ruta := Copy(ls_bars, 16,4);
    ls_detalle := Copy(ls_bars,21,2)+':'+Copy(ls_bars,23,2);
    ls_cupo := Copy(ls_bars,25,2);

    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    //verificamos que la corrida no exista
    if EjecutaSQL('SELECT CURRENT_DATE() AS AHORA',lq_qry,_LOCAL) then
          ls_fecha := FormatDateTime('YYYY-MM-DD',lq_qry['AHORA']);

    if EjecutaSQL(FORMAT(_CORRIDA_EXISTE,[ls_fecha, ls_corrida]), lq_qry, _LOCAL) then begin
        if lq_qry['TOTAL'] > 0 then begin
          ShowMessage('La corrida ya se encuentra regístra para la venta');
        end else begin
            ls_master := Format(_MASTER_CORRIDA,[ls_corrida, ls_fecha,ls_hora, ls_autobus, ls_servicio, ls_ruta]);
            ls_detalle := Format(_CORRIDA_DETALLE,[ls_corrida, ls_fecha, gs_terminal, ls_detalle, ls_cupo,ls_ruta]);
            if EjecutaSQL(ls_master,lq_qry, _LOCAL) then begin
                lbl_mensaje.Caption := 'Insertando corrida maestra';
                Sleep(2000);
            end;

            if EjecutaSQL(ls_detalle, lq_qry, _LOCAL) then begin
                lbl_mensaje.Caption := 'Insertando corrida detalle';
                Sleep(2000);
                lbl_mensaje.Caption := 'La corrida puede visualizarla en la venta del dia';
                Sleep(2000);
            end;
        end;//fin total
    end;//fin corrida existe
    lq_qry.Free;
    lq_qry := nil;
    if Application.MessageBox(PChar('Desea escanear otro codigo de barras'), 'Atención', _CONFIRMAR) = IDYES then begin
              lbl_mensaje.Caption := '';
              mem_bars.Clear;
              mem_bars.SetFocus;
    end else begin
              lbl_mensaje.Caption := '';
              mem_bars.Clear;
              Close;
    end;
//    ShowMessage(ls_corrida+'-'+ls_hora+'-'+ls_autobus+'-'+ls_servicio+'-'+ls_ruta+'-'+ls_detalle+'-'+ls_cupo);
end;

procedure Tfrm_bars.Action2Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_bars.mem_barsKeyDown(Sender: TObject; var Key: Word;
          Shift: TShiftState);
begin
    if Key = 13 then begin
        Action1Execute(Sender);
    end;
end;

end.
