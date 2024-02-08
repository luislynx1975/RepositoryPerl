unit frm_imprime_abierto;

interface
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, Data.SqlExpr, u_comun_venta, StdCtrls;

type


  Tfrm_print_abierto = class(TForm)
    stg_detalle: TStringGrid;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure stg_detalleSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    code_tickets : String;
    date_travel  : string;
    idTravel     : string;
    timeTravel   : String;
    seats        : ga_asientos;
    procedure tituloGrid;
  public
    { Public declarations }
    property codigo : string write code_tickets;
    property fecha  : string write date_travel;
    property corrida : string write idTravel;
    property hora    : String write timeTravel;
    property asientos : ga_asientos write seats;
  end;

var
  frm_print_abierto: Tfrm_print_abierto;

implementation

uses DMdb, comun, u_gral_venta;

{$R *.dfm}

procedure Tfrm_print_abierto.Button1Click(Sender: TObject);
var
    li_idx, li_boleto, li_asiento  : integer;
    lq_qry : TSQLQuery;
    ls_terminal, ls_trabid, ls_nombre : string;
    STORE  : TSQLStoredProc;
begin
      lq_qry := TSQLQuery.Create(nil);
      lq_qry.SQLConnection := DM.Conecta;
      STORE := TSQLStoredProc.Create(nil);
      STORE.SQLConnection := DM.Conecta;
      for li_idx := 1 to stg_detalle.RowCount - 1 do begin
          li_Boleto   := StrToInt(stg_detalle.Cells[0, li_idx]);
          ls_terminal := stg_detalle.Cells[1, li_idx];
          ls_trabid   := stg_detalle.Cells[2, li_idx];
          li_asiento  := StrToInt(stg_detalle.Cells[5, li_idx]);
          ls_nombre   := stg_detalle.Cells[6, li_idx];
{          if EjecutaSQL(format(_ABIERTO_UPDATE_BOLETO,
                         [idTravel, date_travel, timeTravel, ls_nombre, li_asiento, li_boleto, ls_terminal, ls_trabid]), lq_qry, _LOCAL) then begin
          //actualizamos el asiento
          end;}
//          consultaBoleto(li_boleto, ls_terminal, ls_trabid, STORE);
//          if gs_impresora_boleto = _IMP_TOSHIBA_TEC then
//              imprimeBoleto101(STORE,'');

//          if gs_impresora_boleto = _IMP_IMPRESORA_OPOS then
//              imprimeBoletoTermica(STORE,'');

//          asignaBoletoAbierto(STORE);

//          asientoActualiza(idTravel, date_travel, ls_nombre, li_asiento);
//          asientoReplicaRuta(STORE);//replicamos el asiento en la ruta


      end;
      STORE.Free;
      STORE := nil;
      lq_qry.Free;
      lq_qry := nil;
      LimpiaSagTodo(stg_detalle);
      Close;
end;



procedure Tfrm_print_abierto.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    li_idx, li_boleto, li_asiento, li_idBoleto : integer;
    lq_qry : TSQLQuery;
    STORE  : TSQLStoredProc;
    ls_terminal, ls_trabid, ls_nombre : string;
begin
    if key = VK_F10 then begin
        lq_qry := TSQLQuery.Create(nil);
        STORE  := TSQLStoredProc.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        STORE.SQLConnection := DM.Conecta;
        for li_idx := 1 to stg_detalle.RowCount do begin
            li_idBoleto := StrToInt(stg_detalle.Cells[0, li_idx]);
            ls_terminal := stg_detalle.Cells[1, li_idx];
            ls_trabid   := stg_detalle.Cells[2, li_idx];
            li_asiento  := StrToInt(stg_detalle.Cells[5, li_idx]);
            ls_nombre   := stg_detalle.Cells[6, li_idx];
{            if EjecutaSQL(format(_ABIERTO_UPDATE_BOLETO,
                           [idTravel, date_travel, timeTravel, ls_nombre, li_asiento, li_boleto, ls_terminal, ls_trabid]), lq_qry, _LOCAL) then
                           ;
            if EjecutaSQL(format(_ABIERTO_UPDATE_BOLETO,
                           [idTravel, date_travel, timeTravel, ls_nombre, li_asiento, li_boleto, ls_terminal, ls_trabid]), lq_qry, _SERVIDOR_CENTRAL) then
                           ;  }

        end;
        STORE.Free;
        STORE := nil;
        lq_qry.Free;
        lq_qry := nil;
    end;
end;


procedure Tfrm_print_abierto.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if key = VK_F10 then begin
      ShowMessage('Forma');
    end;
end;

procedure Tfrm_print_abierto.FormShow(Sender: TObject);
var
  lq_qry : TSQLQuery;
  li_idx : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    tituloGrid();
    if EjecutaSQL(format('_ABIERTO_BOLETOS_IMPRIME',[code_tickets]),lq_qry, _LOCAL) then begin
        with lq_qry do begin
          First;
          li_idx := 1;
          while not Eof do begin
              stg_detalle.Cells[0, li_idx] := IntToStr(lq_qry['ID_BOLETO']);
              stg_detalle.Cells[1, li_idx] := lq_qry['ID_TERMINAL'];
              stg_detalle.Cells[2, li_idx] := lq_qry['TRAB_ID'];
              stg_detalle.Cells[3, li_idx] := FormatFloat('###,##.00',lq_qry['TARIFA']);
              stg_detalle.Cells[4, li_idx] := lq_qry['TIPO_TARIFA'];
              stg_detalle.Cells[5, li_idx] := IntToStr(seats[li_idx -1]);
              stg_detalle.Cells[6, li_idx] := lq_qry['NOMBRE_PASAJERO'];
              inc(li_idx);
              next;
          end;
        end;
    end;
    stg_detalle.RowCount := li_idx;
    lq_qry.Free;
    lq_qry := nil;
end;

procedure Tfrm_print_abierto.stg_detalleSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if ACol <> 6 then
        stg_detalle.Options := stg_detalle.Options - [goEditing]
    else
        stg_detalle.Options := stg_detalle.Options + [goEditing]
end;

procedure Tfrm_print_abierto.tituloGrid;
begin
    stg_detalle.Cells[0, 0] := 'Folio';
    stg_detalle.Cells[1, 0] := 'Terminal';
    stg_detalle.Cells[2, 0] := 'Trab_id';
    stg_detalle.Cells[3, 0] := 'Tarifa';
    stg_detalle.Cells[4, 0] := 'Ocupante';
    stg_detalle.Cells[5, 0] := 'Asiento';
    stg_detalle.Cells[6, 0] := 'Nombre pasajero';
end;

end.
