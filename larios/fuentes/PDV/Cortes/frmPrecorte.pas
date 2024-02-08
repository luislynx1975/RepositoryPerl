unit frmPrecorte;

interface
{$WARNINGs OFF}
{$HINTS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, DB, lsCombobox, ExtCtrls, lsNumericEdit, Data.SqlExpr,
  ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, Grids, System.Actions, Vcl.ComCtrls;

type
  Tfrm_precorte = class(TForm)
    Panel1: TPanel;
    lbl_fecha: TLabel;
    Label1: TLabel;
    cmb_turno: TlsComboBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    edt_fondo: TEdit;
    Label3: TLabel;
    edt_cancelados: TEdit;
    Label4: TLabel;
    edt_recoboletos: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edt_recoimporte: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    edt_APA: TEdit;
    edt_100: TEdit;
    edt_50: TEdit;
    edt_sedena1: TEdit;
    edt_TB1: TEdit;
    Label12: TLabel;
    edt_FAM1: TEdit;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    edt_boletoIXE: TEdit;
    edt_ticketIXE: TEdit;
    Num_edt_ixe: TlsNumericEdit;
    GroupBox5: TGroupBox;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Num_edt_ban: TlsNumericEdit;
    edt_ticketBana: TEdit;
    edt_bol_ban: TEdit;
    ActionManager1: TActionManager;
    acGuardar: TAction;
    acSalir: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    Label19: TLabel;
    Label20: TLabel;
    edt_total_banco: TEdit;
    edt_ttlefectivo: TEdit;
    Label21: TLabel;
    Label22: TLabel;
    edt_sedena2: TEdit;
    edt_FAM2: TEdit;
    lbl23: TLabel;
    stg_folios: TStringGrid;
    Label23: TLabel;
    edt_pases: TEdit;
    Label24: TLabel;
    edt_agen: TEdit;
    num_imp_2: TlsNumericEdit;
    Label25: TLabel;
    edt_tccPases: TEdit;
    StatusBar1: TStatusBar;
    Label26: TLabel;
    edt_rollo: TEdit;
    procedure FormShow(Sender: TObject);
    procedure acSalirExecute(Sender: TObject);
    procedure edt_APAKeyPress(Sender: TObject; var Key: Char);
    procedure edt_100KeyPress(Sender: TObject; var Key: Char);
    procedure edt_50KeyPress(Sender: TObject; var Key: Char);
    procedure edt_sedena1KeyPress(Sender: TObject; var Key: Char);
    procedure edt_TB1KeyPress(Sender: TObject; var Key: Char);
    procedure num_imp_2_KeyPress(Sender: TObject; var Key: Char);
    procedure Num_edt_ixeKeyPress(Sender: TObject; var Key: Char);
    procedure Num_edt_banKeyPress(Sender: TObject; var Key: Char);
    procedure Num_edt_banChange(Sender: TObject);
    procedure Num_edt_ixeChange(Sender: TObject);
    procedure edt_bol_banKeyPress(Sender: TObject; var Key: Char);
    procedure edt_ticketBanaKeyPress(Sender: TObject; var Key: Char);
    procedure edt_boletoIXEKeyPress(Sender: TObject; var Key: Char);
    procedure edt_ticketIXEKeyPress(Sender: TObject; var Key: Char);
    procedure edt_sedena2KeyPress(Sender: TObject; var Key: Char);
    procedure edt_FAM2KeyPress(Sender: TObject; var Key: Char);
    procedure num_imp_2_Change(Sender: TObject);
    procedure num_imp_2_Exit(Sender: TObject);
    procedure Num_edt_ixeExit(Sender: TObject);
    procedure Num_edt_banExit(Sender: TObject);
    procedure acGuardarExecute(Sender: TObject);
    procedure edt_APAEnter(Sender: TObject);
    procedure edt_100Enter(Sender: TObject);
    procedure edt_50Enter(Sender: TObject);
    procedure edt_sedena1Enter(Sender: TObject);
    procedure edt_sedena2Enter(Sender: TObject);
    procedure edt_TB1Enter(Sender: TObject);
    procedure edt_FAM1Enter(Sender: TObject);
    procedure edt_FAM2Enter(Sender: TObject);
    procedure edt_FAM2Exit(Sender: TObject);
    procedure edt_FAM1Exit(Sender: TObject);
    procedure edt_TB1Exit(Sender: TObject);
    procedure edt_sedena2Exit(Sender: TObject);
    procedure edt_sedena1Exit(Sender: TObject);
    procedure edt_APAExit(Sender: TObject);
    procedure edt_100Exit(Sender: TObject);
    procedure edt_50Exit(Sender: TObject);
    procedure Num_edt_ixeEnter(Sender: TObject);
    procedure Num_edt_banEnter(Sender: TObject);
    procedure num_imp_2_Enter(Sender: TObject);
    procedure cmb_turnoClick(Sender: TObject);
    procedure stg_foliosKeyPress(Sender: TObject; var Key: Char);
    procedure stg_foliosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure stg_foliosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure edt_agenEnter(Sender: TObject);
    procedure edt_agenExit(Sender: TObject);
    procedure edt_agenKeyPress(Sender: TObject; var Key: Char);
    procedure num_imp_2Change(Sender: TObject);
    procedure num_imp_2Enter(Sender: TObject);
    procedure num_imp_2Exit(Sender: TObject);
    procedure num_imp_2KeyPress(Sender: TObject; var Key: Char);
    procedure lsNumericEdit1Enter(Sender: TObject);
    procedure lsNumericEdit1Exit(Sender: TObject);
    procedure lsNumericEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure lsNumericEdit1Change(Sender: TObject);
    procedure stg_foliosSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure edt_boletoIXEChange(Sender: TObject);
    procedure edt_ticketIXEChange(Sender: TObject);
    procedure edt_bol_banChange(Sender: TObject);
    procedure edt_ticketBanaChange(Sender: TObject);
    procedure edt_APAChange(Sender: TObject);
    procedure edt_100Change(Sender: TObject);
    procedure edt_50Change(Sender: TObject);
    procedure edt_sedena1Change(Sender: TObject);
    procedure edt_sedena2Change(Sender: TObject);
    procedure edt_TB1Change(Sender: TObject);
    procedure edt_FAM1Change(Sender: TObject);
    procedure edt_FAM2Change(Sender: TObject);
    procedure edt_pasesChange(Sender: TObject);
    procedure edt_agenChange(Sender: TObject);
    procedure edt_tccPasesChange(Sender: TObject);
    procedure edt_pasesEnter(Sender: TObject);
    procedure edt_pasesExit(Sender: TObject);
    procedure edt_FAM1KeyPress(Sender: TObject; var Key: Char);
    procedure edt_pasesKeyPress(Sender: TObject; var Key: Char);
    procedure edt_tccPasesEnter(Sender: TObject);
    procedure edt_tccPasesExit(Sender: TObject);
    procedure edt_tccPasesKeyPress(Sender: TObject; var Key: Char);
    procedure edt_rolloChange(Sender: TObject);
    procedure edt_rolloEnter(Sender: TObject);
    procedure edt_rolloExit(Sender: TObject);
    procedure edt_rolloKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    Fnum_corte : integer;
    FTrab_id   : string;
    procedure inicializar();
    procedure insertaRegistro();
    procedure obtenRegistroPCorte();
    procedure limpiaValores();
    function obtenrecoleccion() : String;
    function obtenFondo() : String;
    function bolCancelados() : String;
    function numRecoleccion() : String;
    function totalBanamexTickets() : Integer;
    function totalBanamexImporte() : Double;
    function boletosBanamex() : Integer;
    function validaDatosPrecorte() : Boolean;
    function validaRejilla() : Boolean;
    procedure ingresaFolio();
    procedure obtenFoliosREgistrados();
    procedure ceros(edits : TEdit);
  public
    { Public declarations }
    property Pcorte : integer write Fnum_corte;
    property Pcquien : string write FTrab_id;
  end;

var
  frm_precorte: Tfrm_precorte;

implementation

uses DMdb, comun;

{$R *.dfm}

var
    columna : integer;
    fila    : integer;
    MaxBloque : integer;
    a_folios : array[0..20] of integer;

procedure Tfrm_precorte.ingresaFolio;
var
    lq_qry  : TSQLQuery;
    li_ctrl : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_DELETE_FOLIOS,[IntToStr(Fnum_corte), FTrab_id]),lq_qry, _LOCAL) then
        ;

    if EjecutaSQL(Format(_DELETE_FOLIOS_GRAL,[IntToStr(Fnum_corte), FTrab_id]), lq_qry, _LOCAL) then
        ;

    for li_ctrl := 1 to stg_folios.RowCount - 1 do begin
        if length(stg_folios.Cells[0,li_ctrl]) > 0 then
            if EjecutaSQL(format(_INSERT_FOLIOS,[IntToStr(Fnum_corte), FTrab_id,
                          stg_folios.Cells[0,li_ctrl],stg_folios.Cells[1,li_ctrl]]),lq_qry, _LOCAL) then
                          ;
    end;

    for li_ctrl := 1 to stg_folios.RowCount - 1 do begin//recolecciones
        if length(stg_folios.Cells[2,li_ctrl]) > 0 then
            if EjecutaSQL(format(_INSERTA_RECO_FOLIO,[IntToStr(Fnum_corte), FTrab_id,
                                 stg_folios.Cells[2,li_ctrl],'R']),lq_qry, _LOCAL) then
                                 ;
    end;
    for li_ctrl := 1 to stg_folios.RowCount - 1 do begin//recolecciones
        if length(stg_folios.Cells[3,li_ctrl]) > 0 then
            if EjecutaSQL(format(_INSERTA_RECO_FOLIO,[IntToStr(Fnum_corte), FTrab_id,
                                 stg_folios.Cells[3,li_ctrl],'B']),lq_qry, _LOCAL) then
                                 ;
    end;
    for li_ctrl := 1 to stg_folios.RowCount - 1 do begin//recolecciones
        if length(stg_folios.Cells[4,li_ctrl]) > 0 then
            if EjecutaSQL(format(_INSERTA_RECO_FOLIO,[IntToStr(Fnum_corte), FTrab_id,
                                 stg_folios.Cells[4,li_ctrl],'C']),lq_qry, _LOCAL) then
                                 ;
    end;
    lq_qry.free;
    lq_qry := nil;
end;



procedure Tfrm_precorte.acGuardarExecute(Sender: TObject);
var
    ls_qry : string;
    lq_qry : TSQLQuery;
begin
    cmb_turno.SetFocus;
    if not validaDatosPrecorte then begin
        exit;
    end;
    if Application.MessageBox(PWideChar('¿Desea guardar los datos capturados' + #13#10 +
                                        'para ser usados en el corte?'),  'Atención',
          MB_YESNO + MB_DEFBUTTON1 + MB_ICONQUESTION) = IDYES then  begin
        lq_qry := TSQLQuery.Create(nil);
        lq_qry.SQLConnection := DM.Conecta;
        ingresaFolio();
        ls_qry := Format(_UPDATE_PRECORTE,[
                          RemplazaDecimal(edt_fondo.Text), //BOL_CANCELADOS = %s,   edt_cancelados
                          RemplazaDecimal(edt_cancelados.Text),//BOL_CANCELADOS = %s,   edt_cancelados
                          RemplazaDecimal(edt_recoboletos.Text),//NO_RECOLECCION = %s,   edt_recoboletos
                          RemplazaDecimal(edt_recoimporte.Text),//TOTAL_RECOL = %s,       edt_recoimporte
                          RemplazaDecimal(num_imp_2.Text),//TOTAL_EFECTIVO = %s     num_imp_2
                          RemplazaDecimal(edt_APA.Text),//APA = %s               edt_APA
                          RemplazaDecimal(edt_100.Text),//ORD100 = %s            edt_100
                          RemplazaDecimal(edt_50.Text),//ORD50 = %s             edt_50
                          RemplazaDecimal(edt_sedena1.Text),//SEDENA = %s            edt_sedena1
                          RemplazaDecimal(edt_sedena2.Text),//SEDENA2 = %s           edt_sedena2
                          RemplazaDecimal(edt_TB1.Text),//TICKETBUS = %s      edt_TB1
                          RemplazaDecimal(edt_FAM1.Text),//FAM = %s            edt_FAM1
                          RemplazaDecimal(edt_FAM2.Text),//FAM2 = %s           edt_FAM2
                          RemplazaDecimal(edt_boletoIXE.Text),//IXE_BOLETOS = %s    edt_boletoIXE
                          RemplazaDecimal(edt_ticketIXE.Text),//IXE_TICKETS = %s   edt_ticketIXE
                          RemplazaDecimal(Num_edt_ixe.Text),//IXE_IMPORTE = %s    Num_edt_ixe
                          RemplazaDecimal(edt_bol_ban.Text),   //BAN_BOLETOS = %s    edt_bol_ban
                          RemplazaDecimal(edt_ticketBana.Text),     //BAN_TICKETS = %s    edt_ticketBana
                          RemplazaDecimal(Num_edt_ban.Text),      //BAN_IMPORTE = %s    Num_edt_ban
                          cmb_turno.CurrentID,     //TURNO = ''%s''      cmb_turno
                          RemplazaDecimal(edt_tccPases.text),  //PAS_TRAS = %s       edt_pases
                          RemplazaDecimal(edt_agen.text),      //AGE_NCIA = %s       edt_agen
                          RemplazaDecimal(edt_rollo.text),     //PRO_ROLLO = %s     edt_rollo
                          RemplazaDecimal(edt_tccPases.text),     //PAS_TCC = %s       edt_tccPases
                          IntToStr(Fnum_corte),                //ID_CORTE = %s
                          FTrab_id  ]);                        //TRAB_ID = ''%s''
        if EjecutaSQL(ls_qry, lq_qry, _LOCAL) then begin
            Mensaje('Se han registrado los datos correctamente,'+#13#10+
                    'estos pueden ser modificados mientras que el corte'+#13#10+
                    'no este finalizado.',2);
            limpiaValores();
            FormShow(Sender);
        end;
        lq_qry.Free;
        lq_qry := nil;
        Close;
    end;
end;


procedure Tfrm_precorte.acSalirExecute(Sender: TObject);
begin
    Close;
end;


procedure Tfrm_precorte.FormShow(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
    inicializar();
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_OBTEN_PRECORTE,[FTrab_id, IntToStr(Fnum_corte)]),lq_qry,_LOCAL) then
         if VarIsNull(lq_qry['ID_CORTE']) then begin
             insertaRegistro();
         end else begin
             obtenRegistroPCorte();
             obtenFoliosREgistrados();
         end;
    if EjecutaSQL(format(_OBTEN_PROMOTOR, [FTrab_id]),lq_qry, _LOCAL) then
        lbl23.Caption := 'Clave : '+lq_qry['TRAB_ID'] + #10#13+ 'Nombre : '+ lq_qry['PROMOTOR'];
    lq_qry.Free;
    lbl_fecha.Caption := lbl_fecha.Caption + copy(Ahora(),1,10);
    MaxBloque := getBoletaje();
    fila := 1;
end;


procedure Tfrm_precorte.obtenRegistroPCorte;
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;//FONDO_INICIAL, BOL_CANCELADOS,NO_RECOLECCION, TURNO
    if EjecutaSQL(Format(_OBTEN_PRECORTE,[FTrab_id, IntToStr(Fnum_corte)]),lq_qry,_LOCAL) then begin
        edt_fondo.Text := RemplazaDecimal(FormatFloat('###########0.00',StrToFloat(lq_qry['FONDO_INICIAL'])));
        edt_cancelados.Text := IntToStr(lq_qry['BOL_CANCELADOS']); // lq_qry['FONDO_INICIAL']);
        edt_recoboletos.Text := IntToStr(lq_qry['NO_RECOLECCION']);
        edt_recoimporte.Text := RemplazaDecimal(FormatFloat('############0.00',StrToFloat(lq_qry['TOTAL_RECOL'])));
        num_imp_2.Text := RemplazaDecimal(FormatFloat('############0.00',StrToFloat(lq_qry['TOTAL_EFECTIVO'])));
        edt_APA.Text   := lq_qry['APA'];
        edt_100.Text   := lq_qry['ORD100'];
        edt_50.Text    := lq_qry['ORD50'];
        edt_sedena1.Text := lq_qry['SEDENA'];
        edt_sedena2.Text := lq_qry['SEDENA2'];
        edt_TB1.Text   := lq_qry['TICKETBUS'];
        edt_FAM1.Text  := lq_qry['FAM'];
        edt_FAM2.Text  := lq_qry['FAM2'];
        edt_pases.Text := lq_qry['PAS_TRAS'];
        edt_boletoIXE.Text := lq_qry['IXE_BOLETOS'];
        edt_ticketIXE.Text := lq_qry['IXE_TICKETS'];
        Num_edt_ixe.Text   := lq_qry['IXE_IMPORTE'];
        Num_edt_ixe.Value  := lq_qry['IXE_IMPORTE'];

        edt_bol_ban.Text := lq_qry['BAN_BOLETOS'];
        edt_ticketBana.Text := lq_qry['BAN_TICKETS'];
        Num_edt_ban.Text := lq_qry['BAN_IMPORTE'];
        Num_edt_ban.Value := lq_qry['BAN_IMPORTE'];
        edt_agen.Text     := lq_qry['AGE_NCIA'];
        edt_tccPases.Text := lq_qry['PAS_TCC'];
        edt_rollo.Text := lq_qry['PRO_ROLLO'];

        if VarIsNull(lq_qry['TURNO']) then
            cmb_turno.ItemIndex := -1
        else
            cmb_turno.ItemIndex := cmb_turno.IDs.IndexOf(lq_qry['TURNO']);
    end;
    lq_qry.Free;
end;


procedure Tfrm_precorte.stg_foliosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    li_folio, li_folio_final, li_ctrl, li_idx, li_fol, li_folios : integer;
    a_folios : array[0..50]of integer;
    lb_out : Boolean;
begin
    if columna = 0 then begin
      if Key = VK_RETURN then begin
          try
            li_folio  := StrToInt(stg_folios.Cells[0,fila]);
          except
             li_folio := 0;
          end;
          if li_folio = 0 then begin
              Mensaje('Ingresa el numero del folio inicial',2);
              exit;
          end;
          stg_folios.Col := 1;
          exit;
      end;
    end;

    if columna = 1 then begin
      if Key = VK_RETURN then begin
        try
          li_folio       := StrToInt(stg_folios.Cells[0,fila]);
          li_folio_final := StrToInt(stg_folios.Cells[1,fila]);
        except
           li_folio_final := 0;
        end;
        if li_folio > li_folio_final then begin
            Mensaje('Verifique el folio es menor al incial',2);
            stg_folios.Cells[1,fila] := '0';
            exit;

        end;

        if li_folio_final = 0 then begin
              Mensaje('Ingresa el numero del folio final',2);
              exit;
        end;
        if ( li_folio_final > (li_folio + MaxBloque) ) then begin
            Mensaje('el folio final es mayor al permitido verifiquelo',2);
            stg_folios.Cells[1,fila] := '0';
            exit;
        end;
        stg_folios.Col := 0;
        stg_folios.Row := fila + 1;
      end;
    end;

    if columna = 2 then begin
       if Key = VK_RETURN then begin//validamos el folio para la recoleccion
          li_idx := 0;
          for li_ctrl := 1 to stg_folios.RowCount - 1 do
            if Length( stg_folios.Cells[0,li_ctrl] ) > 0 then begin
              a_folios[li_idx] := StrToInt( stg_folios.Cells[0,li_ctrl] );
              inc( li_idx );
              a_folios[li_idx] := StrToInt( stg_folios.Cells[1,li_ctrl] );
              inc( li_idx );
            end;//fin if
            li_folios := StrToInt(stg_folios.Cells[2,fila]);
            for li_ctrl := 1 to stg_folios.RowCount - 1 do begin
                if length(stg_folios.Cells[0,li_ctrl]) > 0 then
                    if li_folios = StrToInt(stg_folios.Cells[0,li_ctrl]) then begin
                        Mensaje('Este folio ya esta registrado como inicial',2);
                        stg_folios.Cells[2,fila] := '0';
                        exit;
                    end;
                if length(stg_folios.Cells[1,li_ctrl]) > 0 then
                    if li_folios = StrToInt(stg_folios.Cells[1,li_ctrl]) then begin
                        Mensaje('Este folio ya esta registrado como final',2);
                        stg_folios.Cells[2,fila] := '0';
                        exit;
                    end;

                if length(stg_folios.Cells[2,li_ctrl]) > 0 then
                    if li_folios = StrToInt(stg_folios.Cells[2,li_ctrl]) then begin
                        if fila <> li_ctrl then begin
                            Mensaje('Este folio ya esta registrado como recoleccion',2);
                            stg_folios.Cells[2,fila] := '0';
                            exit;
                        end;
                    end;
                if length(stg_folios.Cells[3,li_ctrl]) > 0 then
                    if li_folios = StrToInt(stg_folios.Cells[3,li_ctrl]) then begin
                        Mensaje('Este folio ya esta registrado como blanco o otro',2);
                        stg_folios.Cells[2,fila] := '0';
                        exit;
                    end;
            end;

            if length(stg_folios.Cells[2,fila]) > 0 then begin
                lb_out := false;
                for li_fol := 0 to li_idx do begin
                    if  li_fol in [0,2,4,6,8,10,12,14,16,18,20] then
                      if ( li_folios > a_folios[li_fol] ) and
                         ( li_folios < a_folios[li_fol + 1 ] )then begin
                          stg_folios.Col := 2;
                          stg_folios.Row := fila + 1;
                          lb_out := True;
                      end;
                end;//fin for
            end;
            if lb_out = False then begin
              Mensaje('Verifique el folio de la recoleccion sea el correcto',2);
              stg_folios.Cells[2,fila] := '0';
            end;
       end;
    end;

    if columna = 3 then begin
       if Key = VK_RETURN then begin//validamos el folio para la recoleccion
          li_idx := 0;
          for li_ctrl := 1 to stg_folios.RowCount - 1 do
            if Length( stg_folios.Cells[0,li_ctrl] ) > 0 then begin
              a_folios[li_idx] := StrToInt( stg_folios.Cells[0,li_ctrl] );
              inc( li_idx );
              a_folios[li_idx] := StrToInt( stg_folios.Cells[1,li_ctrl] );
              inc( li_idx );
            end;//fin if
            li_folios := StrToInt(stg_folios.Cells[3,fila]);
            for li_ctrl := 1 to stg_folios.RowCount - 1 do begin
                if length(stg_folios.Cells[0,li_ctrl]) > 0 then
                    if li_folios = StrToInt(stg_folios.Cells[0,li_ctrl]) then begin
                        Mensaje('Este folio ya esta registrado como inicial',2);
                        stg_folios.Cells[3,fila] := '0';
                        exit;
                    end;
                if length(stg_folios.Cells[1,li_ctrl]) > 0 then
                    if li_folios = StrToInt(stg_folios.Cells[1,li_ctrl]) then begin
                        Mensaje('Este folio ya esta registrado como final',2);
                        stg_folios.Cells[3,fila] := '0';
                        exit;
                    end;

                if length(stg_folios.Cells[2,li_ctrl]) > 0 then
                    if li_folios = StrToInt(stg_folios.Cells[2,li_ctrl]) then begin
                       Mensaje('Este folio ya esta registrado como recoleccion',2);
                       stg_folios.Cells[3,fila] := '0';
                       exit;
                    end;
                if length(stg_folios.Cells[3,li_ctrl]) > 0 then
                    if fila <> li_ctrl then begin
                       if li_folios = StrToInt(stg_folios.Cells[3,li_ctrl]) then begin
                            Mensaje('Este folio ya esta registrado como blanco o otro',2);
                            stg_folios.Cells[3,fila] := '0';
                            exit;
                       end;
                    end;
            end;

            if length(stg_folios.Cells[3,fila]) > 0 then begin
                lb_out := false;
                for li_fol := 0 to li_idx do begin
                    if  li_fol in [0,2,4,6,8,10,12,14,16,18,20] then
                      if ( li_folios > a_folios[li_fol] ) and
                         ( li_folios < a_folios[li_fol + 1 ] )then begin
                          stg_folios.Col := 3;
                          stg_folios.Row := fila + 1;
                          lb_out := True;
                      end;
                end;//fin for
            end;
            if lb_out = False then begin
              Mensaje('Los folios no estan en el rango de folios pre-registrados',2);
              stg_folios.Cells[3,fila] := '0';
            end;
       end;
    end;

    if columna = 4 then begin
       if Key = VK_RETURN then begin//validamos el folio para la recoleccion
          stg_folios.Col := 4;
          stg_folios.Row := fila + 1;
       end;
    end;
end;



procedure Tfrm_precorte.stg_foliosKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
        Key := #0;
end;

procedure Tfrm_precorte.stg_foliosSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    columna := ACol;
    fila :=  ARow;
end;

procedure Tfrm_precorte.stg_foliosSetEditText(Sender: TObject; ACol,
              ARow: Integer; const Value: string);
var
    li_inicial, li_final : integer;
begin
    li_inicial := 0;
    li_final   := 0;
    if ACol = 0 then begin
        if Length(Value) > 7 then begin
            Mensaje('El valor es mayor al permitido verifiquelo', 1);
            stg_folios.Cells[0,ARow] := '';
            exit;
        end;
    end;

    if ACol = 1 then begin
        if Length(Value) > 7 then begin
            Mensaje('El valor es mayor al permitido verifiquelo', 1);
            stg_folios.Cells[1,ARow] := '';
            exit;
        end else begin
            try
                if Length(stg_folios.Cells[0, ARow]) > 0 then
                    li_inicial := StrToInt(stg_folios.Cells[0, ARow]) + MaxBloque;
                if StrToInt(stg_folios.Cells[0, ARow]) = 0 then begin
                    Mensaje('El folio inicial no debe de ser de valor cero, verifiquelo',1);
                    stg_folios.Cells[1,ARow] := '';
                    stg_folios.Cells[0,ARow] := '';
                    try
                        stg_folios.Col := 0;
                        stg_folios.Row := ARow;
                    except
                        stg_folios.Col := 0;
                    end;
                    PostMessage(stg_folios.Handle,WM_KEYDOWN,VK_F2,0);
                    exit;
                end;

                if Length(stg_folios.Cells[1, ARow]) > 0 then
                    li_final := StrToInt(stg_folios.Cells[1, ARow]);
                if li_final > li_inicial then begin
                    Mensaje('Verifique los folios es mayor al rango permitido',1);
                    stg_folios.Cells[1,ARow] := '';
                end;
            except
                 ShowMessage('No tiene carga incial para calcular la diferencia, '+#10#13 +
                             'verifique los datos ');
            end;
        end;
    end;

    if ACol = 2 then begin
        if Length(Value) > 7 then begin
            Mensaje('Verifique el folio que se esta ingresando',1);
            stg_folios.Cells[2,ARow] := '';
            exit;
        end;
    end;


    if ACol = 3 then begin
        if Length(Value) > 7 then begin
            Mensaje('Verifique el folio que se esta ingresando',1);
            stg_folios.Cells[3,ARow] := '';
            exit;
        end;
    end;

    if ACol = 4 then begin
        if Length(Value) > 7 then begin
            Mensaje('Verifique el folio que se esta ingresando',1);
            stg_folios.Cells[4,ARow] := '';
            exit;
        end;
    end;

end;


function Tfrm_precorte.validaRejilla: Boolean;
begin
//validar los datos de la columna 1 y 2
end;


function Tfrm_precorte.validaDatosPrecorte: Boolean;
var
    lb_ok : Boolean;
    li_ctrl, li_col : integer;
begin
    lb_ok := true;
    if cmb_turno.ItemIndex = -1 then begin
        Mensaje('Debe de seleccionar el turno al que pertenece',2);
        cmb_turno.SetFocus;
        lb_ok := False;
        exit;
    end;


    if (StrToInt(edt_boletoIXE.Text) > 0) or (StrToInt(edt_ticketIXE.Text) > 0) then begin
        if StrToInt(edt_ticketIXE.Text) = 0 then begin
            Mensaje('El valor debe ser mayor a 0',2);
            edt_ticketIXE.SetFocus;
            lb_ok := False;
            exit;
        end;
        if (StrToInt(edt_boletoIXE.Text) = 0) then begin
            Mensaje('El valor debe de ser mayor a 0',2);
            edt_boletoIXE.SetFocus;
            lb_ok := False;
            Exit;
        end;

        if Num_edt_ixe.Value = 0 then begin
            Mensaje('Verifique el importe debe ser mayor a 0',2);
            Num_edt_ixe.SetFocus;
            lb_ok := False;
            exit;
        end;
    end;

    if (StrToInt(edt_bol_ban.Text) > 0) or (StrToInt(edt_ticketBana.Text) > 0) then begin
        if StrToInt(edt_ticketBana.Text) = 0 then begin
            Mensaje('El valor debe de ser mayor a 0',2);
            edt_ticketBana.SetFocus;
            lb_ok := False;
            exit;
        end;
        if StrToInt(edt_bol_ban.Text) = 0 then begin
            Mensaje('El valor debe de ser mayor a 0',2);
            edt_bol_ban.SetFocus;
            lb_ok := False;
            Exit;
        end;
        if Num_edt_ban.Value = 0 then begin
            Mensaje('Verifique el importe debe ser mayor a 0',2);
            Num_edt_ban.SetFocus;
            lb_ok := False;
            exit;
        end;
    end;
    if(StrToInt(edt_ticketIXE.Text) > StrToInt(edt_boletoIXE.Text)) then begin
         Mensaje('El numero de tickets no debe de exceder el numero de boletos',2);
         edt_ticketIXE.SetFocus;
         lb_ok := False;
         Exit;
    end;

    if(StrToInt(edt_ticketBana.Text) > StrToInt(edt_bol_ban.Text)) then begin
         Mensaje('El numero de tickets no debe de exceder el numero de boletos',2);
         edt_ticketBana.SetFocus;
         lb_ok := False;
         Exit;
    end;

    for li_ctrl := 1 to stg_folios.RowCount - 1 do begin
        if Length(stg_folios.Cells[0,li_ctrl]) > 0 then
           if Length(stg_folios.Cells[1,li_ctrl]) = 0 then begin
              Mensaje('Rectifique los folios ingresados deben estar en pares',2);
              stg_folios.Cells[1,li_ctrl] := '0';
              lb_ok := False;
              break;
           end;
    end;

    for li_ctrl := 1 to stg_folios.RowCount - 1 do begin
        for li_col := 0 to stg_folios.ColCount - 1 do begin
            if Length(stg_folios.Cells[li_col,li_ctrl]) > 0 then
               try
                  if StrToInt(stg_folios.Cells[li_col,li_ctrl]) = 0 then
                      stg_folios.Cells[li_col,li_ctrl] := '';
               except
                      stg_folios.Cells[li_col,li_ctrl] := '';
               end;
        end;
    end;
    Result := lb_ok;
end;


procedure Tfrm_precorte.insertaRegistro;
var
    lq_query : TSQLQuery;
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_INSERTA_PRECORTE,
                          [IntToStr(Fnum_corte),
                          FTrab_id,
                          RemplazaDecimal(obtenFondo),
                          RemplazaDecimal(bolCancelados),
                          RemplazaDecimal(numRecoleccion),
                          RemplazaDecimal(obtenrecoleccion),
                          RemplazaDecimal(totalBanamexTickets.ToString),
                          RemplazaDecimal(totalBanamexImporte.ToString),
                          boletosBanamex.toString
                          ]),lq_query,_LOCAL) then
        ;
    lq_query.Free;
end;


procedure Tfrm_precorte.limpiaValores;
begin
    lbl_fecha.Caption := 'Fecha : ';
    edt_boletoIXE.Text := '0';
    edt_ticketIXE.Text := '0';
    num_imp_2.text := '0.00';
    edt_ttlefectivo.Text := '0';
    Num_edt_ixe.Value := 0;
    edt_bol_ban.Text := '0';
    edt_ticketBana.Text := '0';
    Num_edt_ban.Value := 0;
    edt_total_banco.Text := '0';
    edt_APA.Text := '0';
    edt_100.Text := '0';
    edt_50.Text  := '0';
    edt_sedena1.Text := '0';
    edt_sedena2.Text := '0';
    edt_TB1.Text := '0';
    edt_FAM1.Text := '0';
    edt_FAM2.Text := '0';
end;

procedure Tfrm_precorte.lsNumericEdit1Change(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
    if Length(num_imp_2.Text) > 0 then begin
      ld_impor1 := StrTofloat(edt_recoimporte.text);
      ld_impor2 := StrToFloat(num_imp_2.TEXT);
      edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));
    end else begin
        num_imp_2.Text := '0.00';
        num_imp_2.SelectAll;
    end;
end;

procedure Tfrm_precorte.lsNumericEdit1Enter(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
      ld_impor1 := StrTofloat(edt_recoimporte.text);
      ld_impor2 := StrToFloat(num_imp_2.TEXT);
//    ld_impor2 := num_imp_2.Value;
      edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));
end;

procedure Tfrm_precorte.lsNumericEdit1Exit(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
    ld_impor1 := StrTofloat(edt_recoimporte.text);
    ld_impor2 := StrToFloat(num_imp_2.TEXT);
//    ld_impor2 := num_imp_2.Value;
    edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));
end;

procedure Tfrm_precorte.lsNumericEdit1KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.num_imp_2Change(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
    ld_impor1 := StrTofloat(edt_recoimporte.text);
    ld_impor2 := StrToFloat(num_imp_2.TEXT);
    edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));
end;

procedure Tfrm_precorte.num_imp_2Enter(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
    ld_impor1 := StrTofloat(edt_recoimporte.text);
    ld_impor2 := StrToFloat(num_imp_2.TEXT);
//    ld_impor2 := num_imp_2.Value;
    edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));

end;

procedure Tfrm_precorte.num_imp_2Exit(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
    ld_impor1 := StrTofloat(edt_recoimporte.text);
    ld_impor2 := StrToFloat(num_imp_2.TEXT);
//    ld_impor2 := num_imp_2.Value;
    edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));
end;

procedure Tfrm_precorte.num_imp_2KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.num_imp_2_Change(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
//   if not (Key in ['0'..'9','.', #8, #13]) then
//           Key := #0;
    ld_impor1 := StrTofloat(edt_recoimporte.text);
    ld_impor2 := StrToFloat(num_imp_2.TEXT);
    edt_ttlefectivo.Text := FormatFloat('############0.00',(ld_impor1 + ld_impor2));
end;

procedure Tfrm_precorte.num_imp_2_Enter(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
    ld_impor1 := StrTofloat(edt_recoimporte.text);
    ld_impor2 := StrToFloat(num_imp_2.TEXT);
//    ld_impor2 := num_imp_2.Value;
    edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));
end;

procedure Tfrm_precorte.num_imp_2_Exit(Sender: TObject);
var
    ld_impor1, ld_impor2 : Double;
begin
    ld_impor1 := StrTofloat(edt_recoimporte.text);
    ld_impor2 := StrToFloat(num_imp_2.TEXT);
//    ld_impor2 := num_imp_2.Value;
    edt_ttlefectivo.Text := RemplazaDecimal( FormatFloat('############0.00',(ld_impor1 + ld_impor2)));
end;

procedure Tfrm_precorte.num_imp_2_KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.Num_edt_ixeChange(Sender: TObject);
var
    ld_ixe, ld_banamex : Double;
begin
    if Length(Num_edt_ban.Text) > 0 then begin
        ld_ixe := Num_edt_ixe.Value;
        ld_banamex := Num_edt_ban.Value;
        edt_total_banco.Text := RemplazaDecimal(FormatFloat('############0.00',(ld_ixe + ld_banamex)));
    end else begin
        Num_edt_ban.Text := '0';
        Num_edt_ban.SelectAll;
    end;
end;

procedure Tfrm_precorte.Num_edt_ixeEnter(Sender: TObject);
var
    ld_ixe, ld_banamex : Double;
begin
    ld_ixe := Num_edt_ixe.Value;
    ld_banamex := Num_edt_ban.Value;
    edt_total_banco.Text := RemplazaDecimal(FormatFloat('############0.00',(ld_ixe + ld_banamex)));
end;

procedure Tfrm_precorte.Num_edt_ixeExit(Sender: TObject);
var
    ld_ixe, ld_banamex : Double;
begin
    ld_ixe := Num_edt_ixe.Value;
    ld_banamex := Num_edt_ban.Value;
    edt_total_banco.Text := RemplazaDecimal(FormatFloat('############0.00',(ld_ixe + ld_banamex)));
end;

procedure Tfrm_precorte.Num_edt_ixeKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.Num_edt_banChange(Sender: TObject);
var
    ld_ixe, ld_banamex : Double;
begin
    if Length(Num_edt_ban.Text) > 0 then begin
        ld_ixe := Num_edt_ixe.Value;
        ld_banamex := Num_edt_ban.Value;
        edt_total_banco.Text := FormatFloat('############0.00',(ld_ixe + ld_banamex));
    end else begin
         Num_edt_ban.Text := '0.00';
         Num_edt_ban.SelectAll;
    end;
end;

procedure Tfrm_precorte.Num_edt_banEnter(Sender: TObject);
var
    ld_ixe, ld_banamex : Double;
begin
    ld_ixe := Num_edt_ixe.Value;
    ld_banamex := Num_edt_ban.Value;
    edt_total_banco.Text := FormatFloat('############0.00',(ld_ixe + ld_banamex));
end;

procedure Tfrm_precorte.Num_edt_banExit(Sender: TObject);
var
    ld_ixe, ld_banamex : Double;
begin
    ld_ixe := Num_edt_ixe.Value;
    ld_banamex := Num_edt_ban.Value;
    edt_total_banco.Text := FormatFloat('############0.00',(ld_ixe + ld_banamex));
end;

procedure Tfrm_precorte.Num_edt_banKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9','.', #8, #13]) then
           Key := #0;
end;

function Tfrm_precorte.totalBanamexImporte: Double;
var
    lqBNM : TSQLQuery;
begin
    lqBNM := TSQLQuery.Create(nil);
    lqBNM.SQLConnection := DM.Conecta;
    if ejecutaSQL(Format(_OBTEN_TOTAL_TARIFA_BMX,[FTrab_id, IntToStr(Fnum_corte)] ), lqBNM, _LOCAL ) then
        if VarIsNull(lqBNM['TOTAL']) then begin
            Result := 0.0;
            Num_edt_ban.Text := '0.00';
        end else begin
            Result := lqBNM['TOTAL'];
            Num_edt_ban.Text := FormatFloat('###,###.00', lqBNM['TOTAL'])
        end;
    lqBNM.Free;
end;

function Tfrm_precorte.totalBanamexTickets: integer;
var
    lqQry : TSQLQuery;
begin
    lqQry := TSQLQuery.Create(nil);
    lqQry.SQLConnection := DM.Conecta;
    if ejecutaSQL(Format(_OBTEN_TOTAL_TICKETS_BMX,[FTrab_id, IntToStr(Fnum_corte)] ), lqQry, _LOCAL) then begin
        if  VarIsNull(lqQry['TOTAL']) then begin
            Result := 0;
            edt_ticketBana.Text := '0';
        end else begin
            Result := lqQry['TOTAL'];
            edt_ticketBana.Text := IntToStr(lqQry['TOTAL']);
        end;
    end;
    lqQry.Free;
end;

function Tfrm_precorte.numRecoleccion: String;
var
    lq_qry : TSQLQuery;
    ls_total : String;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_OBTEN_TOTAL_RECOLECCION,[IntToStr(Fnum_corte), FTrab_id, gs_Terminal]),lq_qry,_LOCAL) then
        if VarIsNull(lq_qry['TOTAL']) then
            ls_total := '0'
        else
            ls_total := IntToStr(lq_qry['TOTAL']);
    lq_qry.Free;
    edt_recoboletos.Text := ls_total;
    Result := ls_total;
end;


function Tfrm_precorte.obtenrecoleccion: String;
var
    lq_qry : TSQLQuery;
    ls_out : String;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_OBTEN_RECOLECCION,[IntToStr(Fnum_corte), FTrab_id, gs_Terminal]),lq_qry,_LOCAL) then
        if VarIsNull(lq_qry['IMPORTE']) then
            ls_out := '0'
        else
            ls_out := FormatFloat('############0.00',lq_qry['IMPORTE']);
    lq_qry.Free;
    edt_recoimporte.Text := ls_out;
    Result := ls_out;
end;



function Tfrm_precorte.bolCancelados: String;
var
    lq_cance : TSQLQuery;
    ls_out : String;
begin
    lq_cance := TSQLQuery.Create(nil);
    lq_cance.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_OBTEN_BOLCANCE,[IntToStr(Fnum_corte), FTrab_id, gs_Terminal]),lq_cance,_LOCAL) then
        if VarIsNull(lq_cance['TOTAL']) then
            ls_out := '0'
        else
            ls_out := IntToStr(lq_cance['TOTAL']);
    lq_cance.Free;
    edt_cancelados.Text := ls_out;
    Result := ls_out;
end;

function Tfrm_precorte.boletosBanamex: Integer;
var
    lqBNM : TSQLQuery;
begin
    lqBNM := TSQLQuery.Create(nil);
    lqBNM.SQLConnection := DM.Conecta;
    if ejecutaSQL(Format(_OBTEN_TOTAL_BOLETOS_BMX,[FTrab_id, IntToStr(Fnum_corte)] ), lqBNM, _LOCAL ) then
        if VarIsNull(lqBNM['TOTAL']) then begin
            Result := 0;
            edt_bol_ban.Text := '0';
        end else begin
            Result := lqBNM['TOTAL'];
            edt_bol_ban.Text := IntToStr(lqBNM['TOTAL']);
        end;
    lqBNM.Free;
end;

procedure Tfrm_precorte.ceros(edits : TEdit);
begin
    if Length(edits.Text) = 0 then begin
        edits.Text := '0';
        edits.SelectAll;
    end;
end;

procedure Tfrm_precorte.cmb_turnoClick(Sender: TObject);
begin
    num_imp_2.SetFocus;
end;

procedure Tfrm_precorte.edt_100Change(Sender: TObject);
begin
    ceros(edt_100);
end;

procedure Tfrm_precorte.edt_100Enter(Sender: TObject);
begin
    if Length(edt_100.Text) = 0 then
        edt_100.Text := '0';
end;

procedure Tfrm_precorte.edt_100Exit(Sender: TObject);
begin
    if Length(edt_100.Text) = 0 then
        edt_100.Text := '0';
end;

procedure Tfrm_precorte.edt_100KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_50Change(Sender: TObject);
begin
    ceros(edt_50);
end;

procedure Tfrm_precorte.edt_50Enter(Sender: TObject);
begin
    if Length(edt_50.Text) = 0 then
        edt_50.Text := '0';
end;

procedure Tfrm_precorte.edt_50Exit(Sender: TObject);
begin
    if Length(edt_50.Text) = 0 then
        edt_50.Text := '0';
end;

procedure Tfrm_precorte.edt_50KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_agenChange(Sender: TObject);
begin
    ceros(edt_agen);
end;

procedure Tfrm_precorte.edt_agenEnter(Sender: TObject);
begin
    if Length(edt_agen.Text) = 0 then
        edt_agen.Text := '0';
end;

procedure Tfrm_precorte.edt_agenExit(Sender: TObject);
begin
    if Length(edt_agen.Text) = 0 then
        edt_agen.Text := '0';
end;

procedure Tfrm_precorte.edt_agenKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_APAChange(Sender: TObject);
begin
    ceros(edt_APA);
end;

procedure Tfrm_precorte.edt_APAEnter(Sender: TObject);
begin
    if Length(edt_APA.Text) = 0 then
        edt_APA.Text := '0';
end;

procedure Tfrm_precorte.edt_APAExit(Sender: TObject);
begin
    if Length(edt_APA.Text) = 0 then
        edt_APA.Text := '0';
end;

procedure Tfrm_precorte.edt_APAKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_boletoIXEChange(Sender: TObject);
begin
    if length(edt_boletoIXE.Text) = 0 then begin
        edt_boletoIXE.Text := '0';
        edt_boletoIXE.SelectAll;
    end;
end;

procedure Tfrm_precorte.edt_boletoIXEKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_bol_banChange(Sender: TObject);
begin
    if length(edt_bol_ban.Text) = 0 then begin
        edt_bol_ban.Text := '0';
        edt_bol_ban.SelectAll;
    end;
end;

procedure Tfrm_precorte.edt_bol_banKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_FAM1Change(Sender: TObject);
begin
    ceros(edt_FAM1);
end;

procedure Tfrm_precorte.edt_FAM1Enter(Sender: TObject);
begin
    if Length(edt_FAM1.Text) = 0 then
        edt_FAM1.Text := '0';
end;

procedure Tfrm_precorte.edt_FAM1Exit(Sender: TObject);
begin
    if Length(edt_FAM1.Text) = 0 then
        edt_FAM1.Text := '0';
end;

procedure Tfrm_precorte.edt_FAM1KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_FAM2Change(Sender: TObject);
begin
    ceros(edt_FAM2);
end;

procedure Tfrm_precorte.edt_FAM2Enter(Sender: TObject);
begin
    if Length(edt_FAM2.Text) = 0 then
        edt_FAM2.Text := '0';
end;

procedure Tfrm_precorte.edt_FAM2Exit(Sender: TObject);
begin
    if Length(edt_FAM2.Text) = 0 then
        edt_FAM2.Text := '0';
end;

procedure Tfrm_precorte.edt_FAM2KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_pasesChange(Sender: TObject);
begin
    ceros(edt_pases);
end;

procedure Tfrm_precorte.edt_pasesEnter(Sender: TObject);
begin
    if Length(edt_pases.Text) = 0 then
        edt_pases.Text := '0';
end;

procedure Tfrm_precorte.edt_pasesExit(Sender: TObject);
begin
    if Length(edt_pases.Text) = 0 then
        edt_pases.Text := '0';
end;

procedure Tfrm_precorte.edt_pasesKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_rolloChange(Sender: TObject);
begin
    ceros(edt_rollo);
end;

procedure Tfrm_precorte.edt_rolloEnter(Sender: TObject);
begin
    if Length(edt_rollo.Text) = 0 then
        edt_rollo.Text := '0';
end;

procedure Tfrm_precorte.edt_rolloExit(Sender: TObject);
begin
    if Length(edt_rollo.Text) = 0 then
        edt_rollo.Text := '0';
end;

procedure Tfrm_precorte.edt_rolloKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_sedena1Change(Sender: TObject);
begin
    ceros(edt_sedena1);
end;

procedure Tfrm_precorte.edt_sedena1Enter(Sender: TObject);
begin
    if Length(edt_sedena1.Text) = 0 then
        edt_sedena1.Text := '0';
end;

procedure Tfrm_precorte.edt_sedena1Exit(Sender: TObject);
begin
    if Length(edt_sedena1.Text) = 0 then
        edt_sedena1.Text := '0';
end;

procedure Tfrm_precorte.edt_sedena1KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_sedena2Change(Sender: TObject);
begin
    ceros(edt_sedena2);
end;

procedure Tfrm_precorte.edt_sedena2Enter(Sender: TObject);
begin
    if Length(edt_sedena2.Text) = 0 then
        edt_sedena2.Text := '0';
end;

procedure Tfrm_precorte.edt_sedena2Exit(Sender: TObject);
begin
    if Length(edt_sedena2.Text) = 0 then
        edt_sedena2.Text := '0';
end;

procedure Tfrm_precorte.edt_sedena2KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_TB1Change(Sender: TObject);
begin
    ceros(edt_TB1);
end;

procedure Tfrm_precorte.edt_TB1Enter(Sender: TObject);
begin
    if Length(edt_TB1.Text) = 0 then
        edt_TB1.Text := '0';
end;

procedure Tfrm_precorte.edt_TB1Exit(Sender: TObject);
begin
    if Length(edt_TB1.Text) = 0 then
        edt_TB1.Text := '0';
end;

procedure Tfrm_precorte.edt_TB1KeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_tccPasesChange(Sender: TObject);
begin
    ceros(edt_tccPases);
end;

procedure Tfrm_precorte.edt_tccPasesEnter(Sender: TObject);
begin
    if Length(edt_tccPases.Text) = 0 then
        edt_tccPases.Text := '0';
end;

procedure Tfrm_precorte.edt_tccPasesExit(Sender: TObject);
begin
    if Length(edt_tccPases.Text) = 0 then
        edt_tccPases.Text := '0';
end;

procedure Tfrm_precorte.edt_tccPasesKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_ticketBanaChange(Sender: TObject);
begin
    if Length(edt_ticketBana.Text) = 0 then begin
        edt_ticketBana.Text := '0';
        edt_ticketBana.SelectAll;
    end;
end;

procedure Tfrm_precorte.edt_ticketBanaKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.edt_ticketIXEChange(Sender: TObject);
begin
    if Length(edt_ticketIXE.Text) = 0 then begin
        edt_ticketIXE.Text := '0';
        edt_ticketIXE.SelectAll;
    end;
end;

procedure Tfrm_precorte.edt_ticketIXEKeyPress(Sender: TObject; var Key: Char);
begin
   if not (Key in ['0'..'9', #8, #13]) then
           Key := #0;
end;

procedure Tfrm_precorte.obtenFoliosREgistrados;
var
    lq_qry : TSQLQuery;
    li_ctrl : integer;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_OBTEN_FOLIOS_TABLA,[IntToStr(Fnum_corte), FTrab_id]), lq_qry, _LOCAL) then begin
        lq_qry.First;
        li_ctrl := 1;
        while not lq_qry.Eof do begin
            stg_folios.Cells[0,li_ctrl] := lq_qry['FOLIO_INICIAL_B'];
            stg_folios.Cells[1,li_ctrl] := lq_qry['FOLIO_FINAL_B'];
            inc(li_ctrl);
            lq_qry.Next;
        end;
    end;
    if EjecutaSQL(format(_OBTEN_RECOL_FOLIOS,[IntToStr(Fnum_corte), FTrab_id, 'R']),lq_qry, _LOCAL) then begin
        lq_qry.First;
        li_ctrl := 1;
        while not lq_qry.Eof do begin
            stg_folios.Cells[2,li_ctrl] := lq_qry['FOLIO'];
            inc(li_ctrl);
            lq_qry.Next;
        end;
    end;

    if EjecutaSQL(format(_OBTEN_RECOL_FOLIOS,[IntToStr(Fnum_corte), FTrab_id, 'B']),lq_qry, _LOCAL) then begin
        lq_qry.First;
        li_ctrl := 1;
        while not lq_qry.Eof do begin
            stg_folios.Cells[3,li_ctrl] := lq_qry['FOLIO'];
            inc(li_ctrl);
            lq_qry.Next;
        end;
    end;

    if EjecutaSQL(format(_OBTEN_RECOL_FOLIOS,[IntToStr(Fnum_corte), FTrab_id, 'C']),lq_qry, _LOCAL) then begin
        lq_qry.First;
        li_ctrl := 1;
        while not lq_qry.Eof do begin
            stg_folios.Cells[4,li_ctrl] := lq_qry['FOLIO'];
            inc(li_ctrl);
            lq_qry.Next;
        end;
    end;

    lq_qry.Free;
    lq_qry := nil;
end;

function Tfrm_precorte.obtenFondo: String;
var
    lq_qfondo : TSQLQuery;
    ls_fondo  : String;
begin
    lq_qfondo := TSQLQuery.Create(nil);
    lq_qfondo.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_OBTEN_FONDO,[FTrab_id, IntToStr(Fnum_corte), gs_terminal]),lq_qfondo,_LOCAL) then
        if VarIsNull(lq_qfondo['FONDO_INICIAL']) then
            ls_fondo := '0.00'
        else
            ls_fondo := FormatFloat('############0.00',lq_qfondo['FONDO_INICIAL']);
    lq_qfondo.Free;
    edt_fondo.Text := ls_fondo;
    Result := ls_fondo;
end;



procedure Tfrm_precorte.inicializar;
begin
    cmb_turno.Add('Matutino','Matutino');
    cmb_turno.Add('Vespertino','Vespertino');
    cmb_turno.Add('nocturno','Nocturno');
    stg_folios.Cells[0,0] := 'Carga Iniciales';
    stg_folios.Cells[1,0] := 'Carga Finales';
    stg_folios.Cells[2,0] := 'Recolecciones';
    stg_folios.Cells[3,0] := 'Blanco o otros';
    stg_folios.Cells[4,0] := 'Cancelados';
end;





end.
