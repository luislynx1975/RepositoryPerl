unit u_pax_corrida;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, DB, Data.SqlExpr;

type
  Tfrm_pax_fik = class(TForm)
    Panel1: TPanel;
    MonthCalendar1: TMonthCalendar;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_pax_fik: Tfrm_pax_fik;

implementation

uses DMdb, comun;

{$R *.dfm}

procedure Tfrm_pax_fik.Button1Click(Sender: TObject);
var
    ls_qry,ls_name, ls_fecha,ls_tarifa : String;
    lq_qry : TSQLQuery;
    lt_dia : TDateTime;
    F : TextFile;
begin
    ls_qry := 'SELECT B.FECHA, B.ID_CORRIDA, B.ORIGEN, B.DESTINO, (C.HORA)AS HORA, '+
              '(COUNT(B.ID_CORRIDA))AS PAX, (SUM(TARIFA))AS TARIFA, '+
              '(SELECT KM FROM T_C_RUTA R WHERE R.ID_RUTA = B.ID_RUTA)AS KM, '+
              '(SUM(TARIFA) /(SELECT KM FROM T_C_RUTA R WHERE R.ID_RUTA = B.ID_RUTA))AS FIK, G.NO_BUS '+
              'FROM PDV_T_BOLETO B INNER JOIN PDV_T_CORRIDA C ON  C.ID_CORRIDA = B.ID_CORRIDA AND '+
              'B.FECHA = C.FECHA '+
              'INNER JOIN PDV_T_GUIA G ON C.ID_CORRIDA = G.ID_CORRIDA AND C.FECHA = G.FECHA '+
              'WHERE B.FECHA = ''%s'' AND '+
              'B.TRAB_ID NOT IN (SELECT TRAB_ID FROM PDV_C_USUARIO WHERE FECHA_BAJA IS NOT NULL) AND '+
              'B.ESTATUS = ''V'' '+
              'GROUP BY B.ID_CORRIDA, B.ORIGEN, B.DESTINO, C.HORA ORDER BY HORA';
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    lt_dia := MonthCalendar1.Date;
    ls_fecha := FormatDateTime('YYYY-MM-DD',MonthCalendar1.Date);
    ls_name := ExtractFilePath(Application.ExeName);
    ls_name := ls_name + ls_fecha + 'Corrida.csv';
    if  FileExists(ls_name) then begin //se crea
        DeleteFile(ls_name)
    end;
    AssignFile(F,ls_name);
    Rewrite(F);
    if EjecutaSQL(Format(ls_qry,[ls_fecha, ls_fecha]),lq_qry,_LOCAL) then begin
        with lq_qry do begin
            First;
            Writeln(F,'FECHA,ID_CORRIDA,ORIGEN,DESTINO,HORA,PAX,INGRESo,KM,FIK,NO.BUS');
            while not Eof do begin
              ls_tarifa := FloatToStr(lq_qry['TARIFA']);
              Writeln(F,FormatDateTime('YYYY-MM-DD',lq_qry['FECHA'])+','+lq_qry['ID_CORRIDA']+','+
                        lq_qry['ORIGEN']+','+lq_qry['DESTINO']+','+lq_qry['HORA']+','+IntToStr(lq_qry['PAX'])+','+
                        FormatCurr('########.00', lq_qry['TARIFA'])+','+IntToStr(lq_qry['KM'])+','+
                        FormatFloat('###.00',lq_qry['FIK'])+','+IntToStr(lq_qry['NO_BUS']));
              next;
            end;//fin while
        end;//fin with
    end;
    CloseFile(F);
    lq_qry.Free;
end;

procedure Tfrm_pax_fik.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_pax_fik.FormShow(Sender: TObject);
begin
    MonthCalendar1.Date := Now();
end;

end.
