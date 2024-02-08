unit frm_pinpad_banamex_cancelar;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, comun, u_cobro_banamex, DMdb, Grids, StdCtrls, u_comun_venta,
  TLiberaAsientosRuta, ExtCtrls, Data.SqlExpr;

type
  Tpinpad_banamex_cancelar = class(TForm)
    sgBoletos: TStringGrid;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    lbBoletos: TLabel;
    lbTotal: TLabel;
    btnCancelarBoletos: TButton;
    btnSalir: TButton;
    Panel1: TPanel;
    procedure sgBoletosKeyPress(Sender: TObject; var Key: Char);
    procedure btnCancelarBoletosClick(Sender: TObject);
    procedure btnSalirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    id_pago : String;
    conexion : TSQLConnection;
    ls_promotor,
    ls_autoriza : string;
    Procedure recalcular;
  public
    Procedure inicializar(pago : String; servidor : TSQLConnection; promotor, autoriza : String);
    function realizarCancelacion(id_boleto : Integer; trab_id, id_terminal : string) : Boolean;
  end;

var
  pinpad_banamex_cancelar: Tpinpad_banamex_cancelar;

implementation

uses U_venta;

{$R *.dfm}

{ Tpinpad_banamex_cancelar }

procedure Tpinpad_banamex_cancelar.btnCancelarBoletosClick(Sender: TObject);
Var
 vRow, li_anio : Integer;
 ls_qry, ls_qry_server : String;
 lq_qry : TSQLQuery;
begin
 if lbBoletos.Caption = '0' then Begin
   ShowMessage('No se encuentra seleccionado para cancelar ning�n boleto.');
   exit;
 end;
 {
  2019-04-16
   Para que en lo que se est� procesando la operaci�n con la pinpad el usuario
   no pueda cambiar de SI a NO.
 }
 lq_qry := TSQLQuery.Create(nil);
 lq_qry.SQLConnection := DM.Conecta;
 sgBoletos.Enabled := False;
 if cancelarConBanamex(id_pago, gs_trabid, StrToFloat(lbTotal.Caption), StrToInt(lbBoletos.Caption), conexion) then begin
   for vRow := 1 to sgBoletos.RowCount -1 do begin
     if sgBoletos.Cells[_SAG_CANCELAR, vRow] = 'SI' then begin
       try
       realizarCancelacion(StrToInt(sgBoletos.Cells[_SAG_FOLIO, vRow]), sgBoletos.Cells[_SAG_PROMOTOR, vRow], sgBoletos.Cells[_SAG_CIUDAD, vRow]);
//       cancela corporativo y anualizada
       ls_qry := 'SELECT B.ID_TERMINAL, B.ORIGEN, B.NO_ASIENTO, B.DESTINO, B.ID_CORRIDA, '+
                 'YEAR(B.FECHA_HORA_BOLETO)AS ANIO, ID_BOLETO,  TRAB_ID, TC '+
                 'FROM PDV_T_BOLETO B '+
                 'WHERE ID_BOLETO = %s AND B.TRAB_ID = ''%s'' AND B.ID_TERMINAL = ''%s'' ';
       if EjecutaSQL(Format(ls_qry,[sgBoletos.Cells[_SAG_FOLIO, vRow],sgBoletos.Cells[_SAG_PROMOTOR, vRow],
                                       sgBoletos.Cells[_SAG_CIUDAD, vRow]]),lq_qry,_LOCAL) then begin
              li_anio := lq_qry['ANIO'];
              ls_qry_server := 'UPDATE PDV_T_BOLETO_'+ IntToStr(lq_qry['ANIO']) +' B SET B.ESTATUS = ''C'' '+
                               'WHERE ID_TERMINAL = ''%s'' AND B.TRAB_ID = ''%s'' AND ID_BOLETO = %s';
              ls_qry_server := Format(ls_qry_server,[lq_qry['ID_TERMINAL'], lq_qry['TRAB_ID'], lq_qry['ID_BOLETO']]);

              if EjecutaSQL(ls_qry_server, lq_qry, _SERVIDOR_CENTRAL) then//mandamos al servidor centrar para cancelar anualizada;
              //si el boleto que se cancela esta registrado local y si es remoto registramos en pdv_t_query
              ls_qry := 'UPDATE PDV_T_BOLETO B SET B.ESTATUS = ''C'' WHERE TC = ''%s'' AND  NO_ASIENTO = %s ';
              ls_qry := Format(ls_qry,[lq_qry['TC'], IntToStr(lq_qry['NO_ASIENTO']) ]);

              if lq_qry['ID_TERMINAL'] <> lq_qry['ORIGEN'] then begin
                 ls_qry := Format(_SERVER_QUERY_LOCAL ,[lq_qry['ORIGEN'], ls_qry ]);
                 if EjecutaSQL(ls_qry, lq_qry, _LOCAL) then//mandamos a la terminal para cancelar
                      ;
              end;
              ls_qry := StringReplace(ls_qry_server,'PDV_T_BOLETO_'+IntToStr(li_anio), 'PDV_T_BOLETO', [rfReplaceAll, rfIgnoreCase]);
              ls_qry := Format(_SERVER_QUERY_LOCAL ,['1730', ls_qry ]);
              if EjecutaSQL(ls_qry, lq_qry, _LOCAL) then//mandamos a la terminal para cancelar
                      ;
       end;//fin ejecutaSQL
       except
           ;
       end;
     end;//fin
   end;//fin for
 end;//fin if
 lq_qry.Free;
 lq_qry := nil;
 Close;
end;

procedure Tpinpad_banamex_cancelar.btnSalirClick(Sender: TObject);
begin
 close;
end;

procedure Tpinpad_banamex_cancelar.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
// conexion.Free;
end;

procedure Tpinpad_banamex_cancelar.inicializar(pago: String; servidor : TSQLConnection; promotor, autoriza : String);
var
 sp : TSQLStoredProc;
  vRow: Integer;
begin
 id_pago := pago;
 conexion := TSQLConnection.Create(nil);
 conexion := servidor;
 ls_promotor := promotor;
 ls_autoriza := autoriza;

 sp := TSQLStoredProc.Create(nil);
 try
   sp.SQLConnection := conexion;
   sp.close;
   sp.StoredProcName := 'PDV_PINPAD_BANAMEX_BOLETOS_CANCELABLES';

   sp.Params.ParamByName('_ID_PAGO').AsString := id_pago;
   sp.Open;
   sp.First;

   sgBoletos.ColCount := 7;
   sgBoletos.Cells[_SAG_CANCELAR,0] := 'CANCELAR';
   sgBoletos.Cells[_SAG_FOLIO,0] := 'Folio';
   sgBoletos.Cells[_SAG_PROMOTOR,0] := 'Promotor';
   sgBoletos.Cells[_SAG_CIUDAD,0] := 'Ciudad';
   sgBoletos.Cells[_SAG_ORIGEN,0] := 'Origen';
   sgBoletos.Cells[_SAG_DESTINO,0] := 'Destino';
   sgBoletos.Cells[_SAG_TARIFA,0] := 'Tarifa';
   sgBoletos.RowCount := 2;
   vRow := 1;
   sgBoletos.Cells[_SAG_CANCELAR,vRow] := '';
   sgBoletos.Cells[_SAG_FOLIO,vRow] := '';
   sgBoletos.Cells[_SAG_PROMOTOR,vRow] := '';
   sgBoletos.Cells[_SAG_CIUDAD,vRow] := '';
   sgBoletos.Cells[_SAG_ORIGEN,vRow] := '';
   sgBoletos.Cells[_SAG_DESTINO,vRow] := '';
   sgBoletos.Cells[_SAG_TARIFA,vRow] := '';
   while not sp.Eof do Begin
     sgBoletos.Cells[_SAG_CANCELAR,vRow] := 'SI';
     sgBoletos.Cells[_SAG_FOLIO,vRow] := sp.FieldByName('ID_BOLETO').AsString;
     sgBoletos.Cells[_SAG_PROMOTOR,vRow] := sp.FieldByName('TRAB_ID').AsString;
     sgBoletos.Cells[_SAG_CIUDAD,vRow] := sp.FieldByName('ID_TERMINAL').AsString;
     sgBoletos.Cells[_SAG_ORIGEN,vRow] := sp.FieldByName('ORIGEN').AsString;
     sgBoletos.Cells[_SAG_DESTINO,vRow] := sp.FieldByName('DESTINO').AsString;
     sgBoletos.Cells[_SAG_TARIFA,vRow] := sp.FieldByName('TARIFA').AsString;

     sp.Next;
     inc(vRow);
     sgBoletos.RowCount := sgBoletos.RowCount +1;

   End;
   sgBoletos.RowCount := sgBoletos.RowCount -1;
   sgBoletos.FixedCols := 0;
   if sgBoletos.RowCount > 1 then
     sgBoletos.FixedRows := 1;
   recalcular;

   sp.Close;
 finally
   sp.Free;
 end;


end;

function Tpinpad_banamex_cancelar.realizarCancelacion(id_boleto : Integer; trab_id, id_terminal : string) : Boolean;
Var
 STORE : TSQLStoredProc;
 lq_qry : TSQLQuery;
 ls_qry,
 sentencia,
 ls_conv : string;
 hilo_libera : Libera_Asientos;
begin

 STORE := TSQLStoredProc.Create(nil);
 STORE.SQLConnection := conexion;
 STORE.close;
 STORE.StoredProcName := 'PDV_STORE_CANCELA_BOLETO';
 STORE.Params.ParamByName('IN_FOLIO').AsInteger := id_boleto;
 STORE.Params.ParamByName('IN_TRABID').AsString := trab_id;
 STORE.Params.ParamByName('IN_TERMINAL').AsString := id_terminal;
 STORE.Params.ParamByName('IN_TAQUILLA').AsInteger := gi_taquilla_store;
 STORE.Params.ParamByName('IN_TRABVTA').AsString  := ls_promotor;
 STORE.Params.ParamByName('IN_AUTORIZA').AsString := ls_autoriza;
 STORE.Open;
 if STORE['OUT_BOLETO'] = 0 then begin
   mensaje('No existe el registro del boleto verifiquelo o ha sido cancelado',1);
   //edt_trabid.Clear;
   //edtfolio.Text := '0';
   exit;
 end else begin//se encontro el dato
   lq_qry := TSQLQuery.Create(nil);
   lq_qry.SQLConnection := conexion;
   ls_qry := 'SELECT MENSAJE_CANCELACION FROM PDV_C_FORMA_PAGO WHERE ID_FORMA_PAGO = '+
             intToStr(STORE['OUT_FORMA'])+' AND CANCELABLE = ''T''  ';
   ls_conv := FloatToStr(STORE['OUT_TARIFA']);
   if EjecutaSQL(ls_qry,lq_qry,_LOCAL) then begin
     mensaje(lq_qry['MENSAJE_CANCELACION']+#10#13+ ' por el BOLETO : ' +
            IntToStr(id_boleto) +
            ' la cantidad de : $' + ls_conv,2);
   end else begin
     mensaje('El Boleto ha sido cancelado',2);
   end;


   sentencia := 'DELETE FROM PDV_T_ASIENTO WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s''  '+
                'AND NO_ASIENTO = %s' ;
   sentencia := format(sentencia,[STORE['OUT_CORRIDA'], formatDateTime('YYYY-MM-DD', STORE['OUT_FECHA']),
                STORE['OUT_ASIENTO'] ]);
   hilo_libera := Libera_Asientos.Create(true);
   hilo_libera.server := conexion;
   hilo_libera.sentenciaSQL := sentencia;
   hilo_libera.ruta   := STORE['OUT_RUTA'];
   hilo_libera.origen := id_terminal;
   hilo_libera.destino := STORE['OUT_DESTINO'];
   hilo_libera.Priority := tpHighest;
   hilo_libera.FreeOnTerminate := True;
   hilo_libera.start;
   lq_qry.Free;
   STORE.Free;
 end;//fin
end;

procedure Tpinpad_banamex_cancelar.recalcular;
var
  vRow: Integer;
  boletos : Integer;
  total : Double;
begin
 boletos := 0;
 total := 0.0;
 for vRow := 1 to sgBoletos.RowCount - 1 do
   if sgBoletos.Cells[_SAG_CANCELAR, vRow] = 'SI' then Begin
     Inc(boletos);
     total := total + StrToFloat(sgBoletos.Cells[_SAG_TARIFA, vRow]);
   End;
 lbBoletos.Caption := IntToStr(boletos);
 lbTotal.Caption := FloatToStr(total);
end;

procedure Tpinpad_banamex_cancelar.sgBoletosKeyPress(Sender: TObject;
  var Key: Char);
begin
 if sgBoletos.RowCount < 2 then
   exit;
 if Key = chr(32) then Begin //Barra espaciadora
   if sgBoletos.Cells[_SAG_CANCELAR, sgBoletos.Row] = 'SI' then
     sgBoletos.Cells[_SAG_CANCELAR, sgBoletos.Row] := 'NO'
   else
     sgBoletos.Cells[_SAG_CANCELAR, sgBoletos.Row] := 'SI';
   recalcular;
 End;
end;

end.
