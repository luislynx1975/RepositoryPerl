unit frm_cancela_reservacion_new;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, StdCtrls, Mask, ComCtrls, Grids, System.Actions, Data.SqlExpr;

type
  Tfrm_cancela_new = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    GroupBox1: TGroupBox;
    medt_fecha: TMaskEdit;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
    procedure Action1Execute(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure titulo();
    procedure stg_corridaKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_cancela_new: Tfrm_cancela_new;

implementation

uses DMdb, comun, U_venta, u_comun_venta, TLiberaAsientosRuta;

var
    ls_fecha : string;
    lq_query : TSQLQuery;

{$R *.dfm}

procedure Tfrm_cancela_new.Action1Execute(Sender: TObject);
begin
    Close();
end;

procedure Tfrm_cancela_new.FormActivate(Sender: TObject);
begin
      medt_fecha.SelStart := 0;
end;

procedure Tfrm_cancela_new.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    lq_query.Free;
    lq_query := nil;
end;

procedure Tfrm_cancela_new.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_F1 then begin
        titulo();
        muestraReservaciones(stg_corrida,gs_terminal,medt_fecha.Text);
        ls_fecha := FormatDateTime('YYYY-MM-DD',StrToDate(medt_fecha.Text))
    end;

    if Key = VK_F3 then begin
        medt_fecha.SetFocus;
        LimpiaSag(stg_corrida);
    end;
end;

procedure Tfrm_cancela_new.FormShow(Sender: TObject);
begin
    lq_query := TSQLQuery.Create(self);
    lq_query.SQLConnection := DM.Conecta;
    medt_fecha.text := FechaServer();
    titulo();
end;

procedure Tfrm_cancela_new.stg_corridaKeyPress(Sender: TObject; var Key: Char);
var
    la_asientos : gga_parameters;
    li_num, li_ctrl : integer;
    ls_asientos : string;
    sentencia   : String;
    hilo_libera : Libera_Asientos;
begin
    if Key = #13 then begin
        if Length(stg_corrida.Cols[0].Strings[stg_corrida.Row]) > 1 then begin
        If MessageDlg('Se cancelaran la reservacion de :'+#10#13 +
                      stg_corrida.Cols[0].Strings[stg_corrida.Row], mtWarning, [mbYes, mbNo], 0) = mrYes then begin
            If MessageDlg('Esta seguro de eliminar la cancelacion'+#10#13 +
                      stg_corrida.Cols[0].Strings[stg_corrida.Row], mtWarning, [mbYes, mbNo], 1) = mrYes then begin
                splitLine(Trim(stg_corrida.Cols[1].Strings[stg_corrida.Row]),' ',la_asientos,li_num);
                if li_num > 0 then begin
                    for li_ctrl := 0 to li_num do begin
    //                    if li_ctrl > 0 then
                            ls_asientos := ls_asientos + la_asientos[li_ctrl] + ',';
                    end;
                    ls_asientos := Copy(ls_asientos,1,length(ls_asientos) - 1);
                end else
                    ls_asientos := la_asientos[0];
                //borramos los asientos reservados
                sentencia := format(_VTA_BORRA_RESERVADOS,[stg_corrida.Cols[_COL_CORRIDA - 4].Strings[stg_corrida.Row],
                                                            FormatDateTime('YYYY-MM-DD',StrToDateTime(medt_fecha.Text)) + ' 00:00',
                                                            stg_corrida.Cols[0].Strings[stg_corrida.Row],
                                                            ls_asientos]);
                if EjecutaSQL(sentencia,lq_query,_LOCAL) then begin
                    hilo_libera := Libera_Asientos.Create(true);
                    hilo_libera.server := dm.Conecta;
                    hilo_libera.sentenciaSQL := sentencia;
                    hilo_libera.ruta   := StrToInt(stg_corrida.Cols[7].Strings[stg_corrida.Row]);
                    hilo_libera.origen := gs_terminal;
                    hilo_libera.destino := stg_corrida.Cols[6].Strings[stg_corrida.Row];
                    hilo_libera.Priority := tpNormal;
                    hilo_libera.FreeOnTerminate := True;
                    hilo_libera.start;
                    titulo();
                    limpiaStringGrid(stg_corrida);
                    titulo();
                    muestraReservaciones(stg_corrida,gs_terminal,medt_fecha.Text);
                end;
            end;
        end;//fin dialog
        end;
    end;
end;

procedure Tfrm_cancela_new.titulo;
begin
    stg_corrida.Cells[0,0] := 'Reservado a';
    stg_corrida.Cells[1,0] := 'Asientos';
    stg_corrida.Cells[2,0] := 'Corrida';
    stg_corrida.Cells[5,0] := 'Status';
    stg_corrida.ColWidths[0] := 200;
    stg_corrida.ColWidths[1] := 300;
    stg_corrida.ColWidths[3] := 0;
    stg_corrida.ColWidths[4] := 0;
    stg_corrida.ColWidths[6] := 0;
    stg_corrida.ColWidths[7] := 0;
end;

end.
