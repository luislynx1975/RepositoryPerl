unit frm_ultimaventa;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, Grids, Data.SqlExpr, System.Actions;

type
  Tfrm_venta_ultima = class(TForm)
    stg_corrida: TStringGrid;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    procedure Action1Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure titulo();
    procedure leerArchivo();
  public
    { Public declarations }
    cve_Empleado : String;
  end;

var
  frm_venta_ultima: Tfrm_venta_ultima;

implementation

uses DMdb, comun;

{$R *.dfm}

{ Tfrm_venta_ultima }

procedure Tfrm_venta_ultima.Action1Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_venta_ultima.FormShow(Sender: TObject);
begin
    Self.Caption := 'Registro de los 45 ultimos boletos para :' + cve_Empleado;
    titulo;
    leerArchivo;
end;

procedure Tfrm_venta_ultima.leerArchivo;
var
    ls_name, text, ls_str : string;
    li_idx, li_num  : integer;
    F       : TextFile;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
{    ls_str := 'SELECT B.ID_CORRIDA,B.ORIGEN,B.DESTINO,B.NO_ASIENTO,B.TARIFA,B.FECHA, '+
              '  C.HORA, S.DESCRIPCION,(CONCAT(B.ID_BOLETO,".",B.TRAB_ID))AS BOLETO,B.NOMBRE_PASAJERO, P.ABREVIACION '+
              'FROM PDV_T_BOLETO B INNER JOIN PDV_T_CORRIDA C ON B.ID_CORRIDA = C.ID_CORRIDA AND C.FECHA = B.FECHA '+
              ' INNER JOIN PDV_C_FORMA_PAGO P ON P.ID_FORMA_PAGO = B.ID_FORMA_PAGO '+
              ' INNER JOIN SERVICIOS S ON S.TIPOSERVICIO = C.TIPOSERVICIO '+
              'WHERE B.TRAB_ID = '''+cve_empleado+''' AND B.ESTATUS = ''V'' ORDER BY ID_BOLETO DESC LIMIT 45 ';}
    ls_str := 'SELECT ID_CORRIDA, ORIGEN, DESTINO, NO_ASIENTO, TARIFA, FECHA, ID_BOLETO, FECHA_HORA_BOLETO '+
              'FROM PDV_T_BOLETO '+
              'WHERE TRAB_ID = '''+cve_empleado+'''   AND ESTATUS = ''V'' ORDER BY ID_BOLETO DESC LIMIT 45';
    if EjecutaSQL(ls_str,lq_qry,_LOCAL) then begin
        with lq_qry do begin
            First;
            li_idx := 1;
            while not EoF do begin
                stg_corrida.Cells[0,li_idx] := lq_qry['ID_CORRIDA'];
                stg_corrida.Cells[1,li_idx] := FormatDateTime('YYYY-MM-DD HH:MM',lq_qry['FECHA_HORA_BOLETO']);
                stg_corrida.Cells[2,li_idx] := IntToStr(lq_qry['NO_ASIENTO']);
                stg_corrida.Cells[3,li_idx] := lq_qry['ID_BOLETO'];
                stg_corrida.Cells[4,li_idx] := lq_qry['ORIGEN'];
                stg_corrida.Cells[5,li_idx] := lq_qry['DESTINO'];
                stg_corrida.Cells[6,li_idx] := lq_Qry['FECHA'];
                stg_corrida.Cells[7,li_idx] := FloatToStr(lq_qry['TARIFA']);
                inc(li_idx);
                Next;
            end;
        end;
    end;
    lq_qry.Free;
    lq_qry := nil;
    stg_corrida.RowCount := li_idx;
end;


procedure Tfrm_venta_ultima.titulo;
begin
    stg_corrida.Cells[0,0] := 'Corrida';
    stg_corrida.Cells[1,0] := 'Fecha Boleto';
    stg_corrida.Cells[2,0] := 'Asiento';
    stg_corrida.Cells[3,0] := 'Bol. Empleado';
    stg_corrida.Cells[4,0] := 'Origen';
    stg_corrida.Cells[5,0] := 'Destino';
    stg_corrida.Cells[6,0] := 'Fecha';
    stg_corrida.Cells[7,0] := 'Precio';
end;

end.
