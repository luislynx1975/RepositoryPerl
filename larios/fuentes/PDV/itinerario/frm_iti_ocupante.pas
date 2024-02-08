unit frm_iti_ocupante;

interface
{$WARNINGS OFF}
{$HINTS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ToolWin, Grids, ExtCtrls, StdCtrls,
   DB, Data.SqlExpr, System.Actions;

Const
  _CARACTERES_VALIDOS_EFECTIVO : SET OF CHAR = ['0','1','2','3','4','5','6','7','8','9'];

type
  TFrm_ocupante = class(TForm)
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    Tbtn_nuevo: TToolButton;
    Tbtn_guardar: TToolButton;
    Tbtn_update: TToolButton;
    ToolButton5: TToolButton;
    ac121: TAction;
    ac121a: TAction;
    ac122: TAction;
    ac123: TAction;
    ac99: TAction;
    Ed_descrip: TEdit;
    Ed_abrevia: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    stg_ocupantes: TStringGrid;
    Dt_picker: TDateTimePicker;
    Descuento: TLabel;
    ed_descuento: TEdit;
    procedure ac121Execute(Sender: TObject);
    procedure ac121aExecute(Sender: TObject);
    procedure ac122Execute(Sender: TObject);
    procedure ac123Execute(Sender: TObject);
    procedure ac99Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure stg_ocupantesSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure Ed_abreviaChange(Sender: TObject);
    procedure ed_descuentoChange(Sender: TObject);
  private
    { Private declarations }
    procedure Titulos();
    function valida() : Boolean;
    procedure desabilita();
    procedure habilita();
  public
    { Public declarations }
  end;

var
  Frm_ocupante: TFrm_ocupante;

implementation

uses DMdb, comun, u_main;

{$R *.dfm}
var
    lq_query : TSQLQuery;
    li_cve : Integer;

procedure TFrm_ocupante.ac121Execute(Sender: TObject);
begin
    Tbtn_guardar.Enabled := true;
    Tbtn_update.Enabled := false;
    habilita();
    Dt_picker.Enabled := False;
    Ed_descrip.Clear;
    Ed_abrevia.Clear;
    ed_descuento.Clear;
    Dt_picker.Date := now();
    Ed_descrip.SetFocus();
end;


procedure TFrm_ocupante.ac121aExecute(Sender: TObject);
begin
    if not valida then
        exit;
    if not AccesoPermitido(121,false)then
        exit;
    if Application.MessageBox(PChar(Format(_AGREGAR_INFORMACION,[ 'Del ocupante '])),
                'Atención', _CONFIRMAR) = IDYES then
        if EjecutaSQL(Format(_ITI_INSERT_OCUPAN,
                            [getMaxTable('ID_OCUPANTE','PDV_C_OCUPANTE'),
                            ''''+Ed_descrip.Text+'''',
                            ''''+Ed_abrevia.Text+'''', ed_descuento.Text]),
                      lq_query,_LOCAL)then begin
          Mensaje(_OPERACION_SATISFACTORIA,0);
          if EjecutaSQL(_ITI_OCUPANTES_ALL,lq_query,_LOCAL)then
             LlenarStringGridAll(lq_query,stg_ocupantes);
        end;
    Ed_descrip.Clear;
    Ed_abrevia.Clear;
    ed_descuento.Clear;
    desabilita;
    Dt_picker.Date := now();
    Tbtn_guardar.Enabled := false;
end;


procedure TFrm_ocupante.ac122Execute(Sender: TObject);
begin
    if not valida then
        exit;
    if not AccesoPermitido(121,false)then
        exit;
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_INFORMACION,[ 'Del ocupante '])),
                'Atención', _CONFIRMAR) = IDYES then
        if EjecutaSQL(Format(_ITI_UPDATE_OCUPAN,[''''+Ed_descrip.Text+'''',
                     ''''+FormatDateTime('YYYY/MM/DD',Dt_picker.Date)+'''',
                     ''''+Ed_abrevia.Text+'''', StrToInt(ed_descuento.Text),li_cve]),lq_query,_LOCAL) then
            Mensaje(_OPERACION_SATISFACTORIA,0);
            
        Ed_descrip.Clear;
        Ed_abrevia.Clear;
        ed_descuento.Clear;
        Dt_picker.Date := now();
        Tbtn_guardar.Enabled := false;
        Tbtn_update.Enabled := False;
    FormShow(Sender);
end;

procedure TFrm_ocupante.ac123Execute(Sender: TObject);
begin
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_INFORMACION,[ 'Del ocupante '])),
                'Atención', _CONFIRMAR) = IDYES then
      if EjecutaSQL(Format(_ITI_DELETE_OCUPAN,[li_cve]),lq_query,_LOCAL)then
        Mensaje(_OPERACION_SATISFACTORIA,0);

      Ed_descrip.Clear;
      Ed_abrevia.Clear;
      ed_descuento.Clear;
      Dt_picker.Date := now();
      Tbtn_guardar.Enabled := false;
      Tbtn_update.Enabled := False;
    FormShow(Sender);
end;

procedure TFrm_ocupante.ac99Execute(Sender: TObject);
begin
    Close;
end;

procedure TFrm_ocupante.desabilita;
begin
    Ed_descrip.Enabled := False;
    Dt_picker.Enabled  := False;
    Ed_abrevia.Enabled := False;
    ed_descuento.Enabled := False;;
end;

procedure TFrm_ocupante.Titulos;
begin
    stg_ocupantes.Cells[0,0] := 'Clave';
    stg_ocupantes.Cells[1,0] := 'Descripcion';
    stg_ocupantes.Cells[2,0] := 'Fecha baja';
    stg_ocupantes.Cells[3,0] := 'Abreviacion';
    stg_ocupantes.Cells[4,0] := 'Descuento';
end;

procedure TFrm_ocupante.FormShow(Sender: TObject);
begin
    Titulos();
    desabilita();
    Dt_picker.Date := now();
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
    if EjecutaSQL(_ITI_OCUPANTES_ALL,lq_query,_LOCAL)then
       LlenarStringGridAll(lq_query,stg_ocupantes);
end;



procedure TFrm_ocupante.habilita;
begin
    Ed_descrip.Enabled := True;
    Dt_picker.Enabled  := True;
    Ed_abrevia.Enabled := True;
    ed_descuento.Enabled := true;
end;

function TFrm_ocupante.valida: Boolean;
var
    lb_opcion : Boolean;
begin
    lb_opcion := true;
    if Length(Ed_descrip.Text) = 0 then begin
       Mensaje(_INFORMACION_INSUFICIENTE,1);
       Ed_descrip.SetFocus;
       lb_opcion := false;
       exit;
    end;
    if Length(Ed_abrevia.Text) = 0 then begin
       Mensaje(_INFORMACION_INSUFICIENTE,1);
       Ed_abrevia.SetFocus;
       lb_opcion := false;
       exit;
    end;
    if ((Dt_picker.Date < Now) or (Dt_picker.Date = Now)) then begin
       Mensaje('Verificar la fecha es incorrecta ' + #10#13 + 'o es igual al actual',1);
       Dt_picker.SetFocus;
       lb_opcion := false;
       exit;
    end;
    if length(ed_descuento.Text) = 0 then begin
      Mensaje('Verifique el descuento antes de continuar ',1);
      ed_descuento.SetFocus;
      lb_opcion := False;
      exit;
    end;

    Result := lb_opcion;
end;



procedure TFrm_ocupante.stg_ocupantesSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if Length(stg_ocupantes.Cols[0].Strings[ARow]) = 0 then
        exit;
    li_cve := StrToInt(stg_ocupantes.Cols[0].Strings[ARow]);
    Ed_descrip.Text := (stg_ocupantes.Cols[1].Strings[ARow]);
    try
        Dt_picker.Date := StrToDate(stg_ocupantes.Cols[2].Strings[ARow]);
    except
        Dt_picker.Date := Now;
    end;
    Ed_abrevia.Text := (stg_ocupantes.Cols[3].Strings[ARow]);
    ed_descuento.Text := stg_ocupantes.Cols[4].Strings[ARow];
    habilita;
    Tbtn_guardar.Enabled := false;
    Tbtn_update.Enabled  := True;
end;

procedure TFrm_ocupante.Ed_abreviaChange(Sender: TObject);
begin
    if Length(Ed_abrevia.Text) > 3 then begin
        Mensaje(_LIMITE_EXCEDIDO,0);
        Ed_abrevia.Clear;
        Ed_abrevia.SetFocus;
    end;
end;

procedure TFrm_ocupante.ed_descuentoChange(Sender: TObject);
var
    ls_efectivo, ls_input, ls_output : string;
    lc_char, lc_new     : char;
    li_idx, li_ctrl      : integer;
begin
    ls_input := '';
    ls_efectivo := ed_descuento.text;
    for li_idx := 1 to length(ls_efectivo) do begin
         lc_char := ls_efectivo[li_idx];
         ls_input := ls_input + lc_char;
        if not (lc_char in _CARACTERES_VALIDOS_EFECTIVO) then begin
            for li_ctrl := 1 to length(ls_input) -1 do begin
                lc_new := ls_input[li_ctrl];
                ls_output := ls_output + lc_new;
            end;
            ed_descuento.Text := ls_output;
            ed_descuento.SelStart := length(ls_output);
        end;
    end;
end;

end.
