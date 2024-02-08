unit frm_registro_folios;

interface
{$WARNINGS OFF}
{$HINTS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsNumericEdit, Buttons, ActnList,
  PlatformDefaultStyleActnCtrls, ActnMan, lsCombobox, Grids,
  ExtCtrls, Menus, System.Actions, Data.SqlExpr;

type
  Tfrm_folio_registro = class(TForm)
    stg_folio: TStringGrid;
    pnl_datos: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbl_folio: TLabel;
    lbl_nota: TLabel;
    Button1: TButton;
    ned_folio_inicial: TEdit;
    ned_folio_final: TEdit;
    Button2: TButton;
    ActionManager1: TActionManager;
    ac_guardar: TAction;
    acsalir: TAction;
    ppMenu: TPopupMenu;
    acEliminarFolio: TAction;
    EliminaFolio1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure ac_guardarExecute(Sender: TObject);
    procedure ned_folio_finalKeyPress(Sender: TObject; var Key: Char);
    procedure ned_folio_inicialKeyPress(Sender: TObject; var Key: Char);
    procedure acsalirExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure acEliminarFolioExecute(Sender: TObject);
  private
    { Private declarations }
    InicialFinal : Integer;
    corte        : integer;
    trabid       : String;
    function validaDatos() : Boolean;
    function getIdenticos(cant_1, cant_2 : string) : boolean;
    function valoresIdenticos(folio, FolioNuevoI, FolioNuevoF : Integer): Boolean;

    function folio_Final : Boolean;
    procedure folio_procesar(status : string);
    function validaFolio(trabid : string; IN_corte, IN_folio : integer; tipo : char) : boolean;
    procedure titulos();
    function validaFolioRango(fol_bol: string; corte : integer): Boolean;
  public
    { Public declarations }
    property FInicialFin : integer write InicialFinal;
    property Fcorte      : integer write corte;
    property Ftrabid     : String write trabid;
  end;

var
  frm_folio_registro: Tfrm_folio_registro;

implementation

uses DMdb, comun, u_comun_venta;

{$R *.dfm}

procedure Tfrm_folio_registro.acEliminarFolioExecute(Sender: TObject);
var
    li_ctrl : integer;
    lq_qry : TSQLQuery;
begin
    corte := corteNumero(gs_trab_unico);
    if stg_folio.Row > 0 then begin
        if stg_folio.Cells[0,stg_folio.Row] <> '' then begin
          if EjecutaSQL(Format(_BORRA_FOLIO_BLANCO,[IntToStr(corte),gs_trab_unico,
                               stg_folio.Cells[0,stg_folio.Row]]),lq_qry,_LOCAL) then begin
             GridDeleteRow(stg_folio.Row, stg_folio);
             Mensaje('El folio ha sido eliminado',2);
          end;
        end;
    end;
end;


procedure Tfrm_folio_registro.acsalirExecute(Sender: TObject);
begin
    Close;
end;


procedure Tfrm_folio_registro.ac_guardarExecute(Sender: TObject);
var
    lq_qry : TSQLQuery;
    li_folio, li_folio_final : integer;
begin
    if not validaDatos then begin
        Exit;
    end;
    corte := corteNumero(gs_trab_unico);
    if InicialFinal = _FOL_CERO then begin//_INSERT_FOLIO_INICIAL
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        if EjecutaSQL(format(_INSERT_FOLIO_INICIAL,[IntToStr(corte), gs_trab_unico, ned_folio_inicial.Text]),lq_qry,_LOCAL) then
            Mensaje('Se ha registrado el folio inicial : '+ned_folio_inicial.Text,2);
        lq_qry.Free;
        lq_qry := nil;
        Close;
    end;

    if InicialFinal = _FOL_UNO then begin
        if not folio_Final then
          close
        else begin
                 ned_folio_inicial.Text := '0';
                 ned_folio_final.Text   := '0';
                 ned_folio_inicial.SetFocus;
        end;
    end;

    if InicialFinal = _FOL_DIEZ then begin
        if validaFolioRango(ned_folio_inicial.Text,corte) then begin
            if validaFolio(gs_trab_unico, corte, StrToInt(ned_folio_inicial.Text),'R') then begin
                Mensaje('No se puede registrar este folio ya se encuentra'+#10#13+
                        'registrado',2);
                ned_folio_inicial.Clear;
                ned_folio_final.Clear;
                exit;
            end;
            folio_procesar('R');
            Close;
        end else begin
                    Mensaje('El folio ingresado no corresponde a ningun'+#10#13+
                            'rango de folios registrados en folio inicial y final'+#10#13+
                            'verifique el folio ha registrar',2);
                            ned_folio_inicial.Text := '0';
                            ned_folio_final.Text   := '0';
                            ned_folio_inicial.SetFocus;
        end;
    end;

    if InicialFinal = _FOL_VEINTE then begin
        if validaFolio(gs_trab_unico, corte, StrToInt(ned_folio_inicial.Text),'C') then begin
            Mensaje('No se puede registrar este folio ya se encuentra'+#10#13+
                    'registrado',2);
            ned_folio_inicial.Clear;
            ned_folio_final.Clear;
            exit;
        end;
        folio_procesar('C');
        Close;
    end;

    if InicialFinal = _FOL_TREINTA then begin
        if validaFolioRango(ned_folio_inicial.Text,corte) then begin
            if validaFolio(gs_trab_unico, corte, StrToInt(ned_folio_inicial.Text),'B') then begin
                Mensaje('No se puede registrar este folio ya se encuentra'+#10#13+
                        'registrado',2);
                ned_folio_inicial.Clear;
                ned_folio_final.Clear;
                exit;
            end;
            folio_procesar('B');
            titulos();
            getBoletoBlancos(corte,trabid,stg_folio);
            ned_folio_inicial.SetFocus;
        end else begin
                    Mensaje('El folio ingresado no corresponde a ningun'+#10#13+
                            'rango de folios registrados previamente en '+#10#13+
                            'folio inicial y final verifique el folio ha registrar',2);
                            ned_folio_inicial.Text := '0';
                            ned_folio_final.Text   := '0';
                            ned_folio_inicial.SetFocus;
        end;
    end;
end;



function Tfrm_folio_registro.folio_Final : Boolean;
var
    lq_query : TSQLQuery;
    li_folio, li_folio_final : integer;
    lb_ok : Boolean;
begin
     lq_query := TSQLQuery.Create(nil);
     lq_query.SQLConnection := DM.Conecta;
     li_folio := StrToInt(lbl_folio.Caption) + getBoletaje();
     lb_ok := False;
     corte := corteNumero(gs_trab_unico);

     if valoresIdenticos(StrToInt(lbl_folio.Caption),StrToInt(ned_folio_inicial.Text),
                         StrToInt(ned_folio_final.Text)) then begin
         Mensaje('Los folios ingresados no debén de ser identico al '+#13#10+
                 'folio inicial, verifiquelos',1);
         ned_folio_inicial.Text := '0';
         ned_folio_final.Text   := '0';
         ned_folio_inicial.SetFocus;
         lb_ok := True;
         exit;
     end;

     if  StrToInt(ned_folio_inicial.Text) > li_folio then begin
         Mensaje('El numero de folio tiene un desfase ingrese el'+#13#10+
                 'folio correcto',1);
         ned_folio_inicial.Text := '0';
         ned_folio_final.Text   := '0';
         ned_folio_inicial.SetFocus;
         lb_ok := True;
         exit;
     end;

     if StrToInt(ned_folio_inicial.Text)  <= StrToInt(lbl_folio.Caption) then begin
        Mensaje('el folio es menor o igual al registrado',2);
         ned_folio_inicial.Text := '0';
         ned_folio_final.Text   := '0';
         ned_folio_inicial.SetFocus;
         lb_ok := True;
         exit;
     end;
//SELECT (MAX(SERIAL))AS SERIAL FROM PDV_FOLIOS WHERE ID_CORTE = %s AND TRAB_ID = ''%s'' ';
     if EjecutaSQL(Format(_OBTEN_SRIAL_CORTE, [IntToStr(corte), gs_trab_unico] ), lq_query,_LOCAL) then
        li_folio := lq_query['SERIAL'];
     if EjecutaSQL(Format(_UPDATE_FOLIO_FINAL,[ned_folio_inicial.Text,IntToStr(corte), gs_trab_unico,
                          IntToStr(li_folio)]),lq_query,_LOCAL) then begin
         Mensaje('Se ha registrado correctamente los folios del boletaje',2);
         lb_ok := False;
     end;
     lq_query.Free;
     Result := lb_ok;
end;




procedure Tfrm_folio_registro.folio_procesar(status: string);
var
    lq_query : TSQLQuery;
    lg_cdn_folio : string;
begin
    corte := corteNumero(gs_trab_unico);

    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    lg_cdn_folio := ned_folio_inicial.Text;
    try
        lq_query.SQL.Clear;
        lq_query.SQL.Add('INSERT INTO PDV_FOLIOS_GENERAL(ID_CORTE,TRAB_ID,FOLIO,FECHA_REGISTRO,TIPO_FOLIO)');
        lq_query.SQL.Add('VALUES(:idCorte, :idtrabid, :lg_cdn_folio, NOW(), :status )');
        lq_query.Params[0].AsInteger := corte;
        lq_query.Params[1].AsString  := gs_trab_unico;
        lq_query.Params[2].AsString := lg_cdn_folio;
        lq_query.Params[3].AsString :=  status;
        lq_query.ExecSQL();
    except
        on E : exception do begin
            ErrorLog('Error en insercion folio_procesar', 'INSERT INTO PDV_FOLIOS_GENERAL(ID_CORTE,TRAB_ID,FOLIO,FECHA_REGISTRO,TIPO_FOLIO) '+
                                    'VALUES(%s,''%s'',%s,NOW(),''%s'')');
            if EjecutaSQL(format(_INSERTA_RECO_FOLIO,[IntToStr(corte),gs_trab_unico,ned_folio_inicial.Text,status]),lq_query,_LOCAL) then begin
                ErrorLog('Reinsertando el query','INSERT INTO PDV_FOLIOS_GENERAL(ID_CORTE,TRAB_ID,FOLIO,FECHA_REGISTRO,TIPO_FOLIO) '+
                                    'VALUES(%s,''%s'',%s,NOW(),''%s'')');
            end;
        end;
    end;
    if (status = 'R') then Mensaje('Se ha registrado correctamente el Folio '+#10#13+'la recoleccion ',2);
    if (status = 'B') then Mensaje('Se ha registrado correctamente el Folio '+#10#13+'de los boletos en blanco y/u otros ',2);
    if (status = 'C') then Mensaje('Se ha registrado correctamente el Folio '+#10#13+'para el boleto cancelado',2);
    ned_folio_inicial.Text := '0';
    ned_folio_final.Text   := '0';
    lq_query.Free;
    lq_query := nil;
end;



procedure Tfrm_folio_registro.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    acsalir.Visible := False;
end;

procedure Tfrm_folio_registro.FormShow(Sender: TObject);
var
    lq_query : TSQLQuery;
begin
    corte := corteNumero(gs_trab_unico);

    stg_folio.Visible := False;
    Self.Height := 225;
    pnl_datos.Visible := True;
    if InicialFinal = _FOL_CERO then begin
        Label3.Caption := 'Registre el Folio Inicial del bloque, de la carga emitida'+#10#13+
                          'que se localiza en la parte de atras del boleto';
        lbl_nota.Caption := '';
        lbl_folio.Caption := '';
        ned_folio_inicial.Text  := '0';
        ned_folio_final.Text    := '0';
    end;

    if InicialFinal = _FOL_UNO then begin
        Label3.Caption := 'Registre el Folio Final del bloque, de la carga emitida'+#10#13+
                          'que se localiza en la parte de atras del boleto';
        lq_query := TSQLQuery.Create(nil);
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(Format(_FOLIO_INICIAL,[IntToStr(corte),gs_trab_unico]),lq_query,_LOCAL) then begin
            lbl_nota.Caption := 'Folio Inicial :';
            lbl_folio.Caption := lq_query['FOLIO_INICIAL_B'];
            ned_folio_inicial.Text := lq_query['FOLIO_INICIAL_B'];
            ned_folio_final.Text   := '0';
        end;
    end;
    if InicialFinal = _FOL_DIEZ then begin
        Label3.Caption := 'Registre el Folio de la recolección, que fue emitida'+#10#13+
                          'esta se localiza en la parte de atras de la recolección';
    end;
    if InicialFinal = _FOL_VEINTE then begin
        Label3.Caption := 'Registre el Folio de la cancelacion, este folio'+#10#13+
                          'se localiza en la parte del boleto';
    end;
    if InicialFinal = _FOL_TREINTA then begin
        Label3.Caption := 'Ingrese los folios de los boletos que serán tomados como'+#10#13+
                          'boletos blanco o boletos nulos en el sistema';
        lbl_folio.Caption := '';
        acsalir.Visible := True;
        stg_folio.Visible := True;
        Self.Height := 574;
        getBoletoBlancos(corte,trabid,stg_folio);
        titulos();
    end;
end;

function Tfrm_folio_registro.getIdenticos(cant_1, cant_2: string): boolean;
var
    li_ctrl : integer;
    lc_char : char;
    lb_out  : Boolean;
begin
    lb_out := True;
    if length(cant_1) > 0 then
      for li_ctrl := 0 to length(cant_1) do begin
          lc_char := cant_1[li_ctrl];
          if not (lc_char = cant_2[li_ctrl]) then begin
              lb_out := False;
              break;
          end else
                  lb_out := True;
      end;
    Result := lb_out;
end;


procedure Tfrm_folio_registro.ned_folio_finalKeyPress(Sender: TObject;
  var Key: Char);
begin
    if not (Key in ['0'..'9',#8, #13]) then
           Key := #0;
//    if Key = #13 then
//        ac_guardarExecute(Sender);
end;

procedure Tfrm_folio_registro.ned_folio_inicialKeyPress(Sender: TObject;
  var Key: Char);
begin
    if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;


procedure Tfrm_folio_registro.titulos;
begin
    stg_folio.Cells[0,0] := 'Folio';
    stg_folio.Cells[1,0] := 'Eliminar'
end;


function Tfrm_folio_registro.validaDatos: Boolean;
var
    lb_ok : Boolean;
begin
    lb_ok := True;
    if ned_folio_inicial.text = '0' then begin
        Mensaje('El valor es 0 verifique el folio',1);
        ned_folio_inicial.SetFocus;
        lb_ok := False;
        exit;
    end;

    if ned_folio_final.text = '0' then begin
        Mensaje('El valor es 0 verifique el folio',1);
        ned_folio_final.SetFocus;
        lb_ok := False;
        exit;
    end;

    if not getIdenticos(ned_folio_inicial.text,ned_folio_final.text) then begin
        Mensaje('Los folios no son identicos verifiquelos',1);
        ned_folio_inicial.Text  := '0';
        ned_folio_final.Text    := '0';
        ned_folio_inicial.SetFocus;
        lb_ok := False;
        exit;
    end;
    Result := lb_ok;
end;



function Tfrm_folio_registro.validaFolioRango(fol_bol: string; corte : integer): Boolean;
var
    lq_qry : TSQLQuery;
    lb_ok  : Boolean;
    li_valor, li_folio : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    lb_ok := False;
    corte := corteNumero(gs_trab_unico);

    if EjecutaSQL(Format(_OBTEN_SRIAL_CORTE, [IntToStr(corte), gs_trab_unico] ), lq_qry,_LOCAL) then
        li_folio := lq_qry['SERIAL'];
    if EjecutaSQL(Format(_VALIDO_FOLIO,[fol_bol,fol_bol,fol_bol, IntToStr(corte),gs_trab_unico,
                         IntToStr(li_folio), fol_bol ]),lq_qry,_LOCAL) then begin
        with lq_qry do begin
            First;
            if not lq_qry.IsEmpty then begin
               li_valor := lq_qry['VALIDO'] + lq_qry['MENOR'] + lq_qry['PERMITIDO'];
               if li_valor = 2 then
                 lb_ok := true
               else
                 lb_ok := False;
            end;//fin if
        end;//fin with
    end;
    Result := lb_ok;
end;

{'WHERE TRAB_ID = ''%s'' AND ID_CORTE = %s AND FOLIO = %s AND TIPO_FOLIO = ''%s'' ';}
function Tfrm_folio_registro.validaFolio(trabid : string; IN_corte, IN_folio : integer; tipo : char) : boolean;
var
    lq_query : TSQLQuery;
    lb_ok    : Boolean;
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_EXISTE_FOLIO_GENERAL,[trabid, intToStr(IN_corte), intToStr(IN_folio),tipo]),lq_query,_LOCAL) then
        if lq_query['TOTAL'] = 0 then
            lb_ok := false
        else
            lb_ok := true;
    Result := lb_ok;
end;

function Tfrm_folio_registro.valoresIdenticos(folio, FolioNuevoI,
          FolioNuevoF: Integer): Boolean;
var
    lb_ok : Boolean;
begin
    lb_ok := False;
    if (folio = FolioNuevoI) then begin
        lb_ok := true;
        exit;
    end;
    if (folio = FolioNuevoF) then begin
        lb_ok := True;
        Exit;
    end;
    Result := lb_ok;
end;

end.
