unit e_reporte;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Data.SqlExpr;

type
  TFrm_reporte = class(TForm)
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
  Frm_reporte: TFrm_reporte;

implementation

uses comun, DMdb;

{$R *.dfm}

procedure TFrm_reporte.Button1Click(Sender: TObject);
var
    ld_dia : TDate;
    ls_qry, ls_fecha, ls_name, ls_tarifa : string;
    lq_qry : TSQLQuery;
    F : TextFile;
begin
    ls_qry := 'SELECT B.FECHA, ID_BOLETO, B.ID_CORRIDA, B.ESTATUS, ORIGEN,DESTINO, NO_ASIENTO, P.ABREVIACION, '+
              'TARIFA, FECHA_HORA_BOLETO, D.HORA, B.TRAB_ID, ID_TAQUILLA, TIPOSERVICIO '+
              'FROM PDV_T_BOLETO B INNER JOIN PDV_C_FORMA_PAGO P ON B.ID_FORMA_PAGO = P.ID_FORMA_PAGO '+
              '     INNER JOIN PDV_T_CORRIDA_D D ON D.ID_CORRIDA = B.ID_CORRIDA AND D.FECHA = B.FECHA '+
              'WHERE CAST(FECHA_HORA_BOLETO AS DATE)= ''%s'' AND B.TRAB_ID NOT IN '+
              ' (SELECT TRAB_ID FROM PDV_C_USUARIO WHERE FECHA_BAJA IS NOT NULL AND '+
              'FECHA_BAJA < ''%s'' ORDER BY FECHA_BAJA) ';

    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    ld_dia := MonthCalendar1.Date;
    ls_fecha := FormatDateTime('YYYY-MM-DD',MonthCalendar1.Date);
    ls_name := ExtractFilePath(Application.ExeName);
    ls_name := ls_name + ls_fecha + '.csv';
    if  FileExists(ls_name) then begin //se crea
        DeleteFile(ls_name)
    end;
    AssignFile(F,ls_name);
    Rewrite(F);
    if EjecutaSQL(Format(ls_qry,[ls_fecha, ls_fecha]),lq_qry,_LOCAL) then begin
        with lq_qry do begin
            First;
            Writeln(F,'FECHA,ID_BOLETO,ID_CORRIDA,ESTATUS,ORIGEN,DESTINO,NO_ASIENTO,P.ABREVIACION,TARIFA,FECHA_HORA_BOLETO,HORA,TRABID,ID_TAQUILLA,TIPOSERVICIO');
            while  not EoF do begin
                  ls_tarifa := FloatToStr(lq_qry['TARIFA']);
                  Writeln(F,FormatDateTime('YYYY-MM-DD',lq_qry['FECHA'])+','+IntToStr(lq_qry['ID_BOLETO'])+','+lq_qry['ID_CORRIDA']+','+ lq_qry['ESTATUS']+','+
                            lq_qry['ORIGEN']+','+lq_qry['DESTINO']+','+IntToStr(lq_qry['NO_ASIENTO'])+','+
                            lq_qry['ABREVIACION']+','+ls_tarifa+','+
                            FormatDateTime('YYYY-MM-DD',lq_qry['FECHA_HORA_BOLETO'])+','+
                            FormatDateTime('HH:MM',lq_qry['HORA'])+','+lq_qry['TRAB_ID']+','+ IntToStr(lq_qry['ID_TAQUILLA'])+','+
                            IntToStr(lq_qry['TIPOSERVICIO']));
                  Next;
            end;
        end;
    end;
    CloseFile(F);
    lq_qry.Free;
    lq_qry := nil;
end;

procedure TFrm_reporte.Button2Click(Sender: TObject);
begin
    Close;
end;

procedure TFrm_reporte.FormShow(Sender: TObject);
begin
    MonthCalendar1.Date := Now();
end;

end.
