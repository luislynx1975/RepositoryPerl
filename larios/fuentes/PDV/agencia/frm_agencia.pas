unit frm_agencia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, lsCombobox, ExtCtrls, ActnList,DB, Data.SqlExpr,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ActnMenus,
  System.Actions;

type
  Tfrm_agencias = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    acGuardar: TAction;
    acEliminar: TAction;
    Salir: TAction;
    Panel1: TPanel;
    edt_nombre: TEdit;
    ls_inicio: TlsComboBox;
    ls_final: TlsComboBox;
    stg_agencia: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edt_clave: TEdit;
    Button1: TButton;
    procedure FormShow(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure stg_agenciaSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SalirExecute(Sender: TObject);
    procedure acEliminarExecute(Sender: TObject);
    procedure acGuardarExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure titulosGrid();
    procedure llenaCombos();
    procedure getAgencias();
  public
    { Public declarations }
  end;

var
  frm_agencias: Tfrm_agencias;

implementation

uses DMdb, comun, u_main, frm_asignacion_agencia;

{$R *.dfm}

{ Tfrm_agencias }

procedure Tfrm_agencias.acEliminarExecute(Sender: TObject);
Const
    ls_qry = 'UPDATE PDV_C_AGENCIA SET NOMBRE = ''%s'', ASIENTO_INICIAL = %s, ASIENTO_FINAL = %s '+
             'WHERE ID_AGENCIA = ''%s'' ';
var
    lq_qry : TSQLQuery;
begin
    if (Length(edt_nombre.Text) = 0)  then begin
        Mensaje('Error en el nombre',1);
        edt_nombre.SetFocus;
        exit;
    end;
    if ls_inicio.ItemIndex = -1 then begin
        Mensaje('Error en el numero de asiento',1);
        ls_inicio.SetFocus;
        exit;
    end;
    if ls_final.ItemIndex = -1 then begin
        Mensaje('Error en el numero de asiento',1);
        ls_final.SetFocus;
        exit;
    end;
    if  StrToInt(ls_inicio.CurrentID) > StrToInt(ls_final.CurrentID) then begin
        Mensaje('Error en el rango de asientos',1);
        ls_inicio.ItemIndex := -1;
        ls_final.ItemIndex  := -1;
        ls_inicio.SetFocus;
        exit;
    end;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(ls_qry,[edt_nombre.Text,ls_inicio.CurrentID,
                                 ls_final.CurrentID,edt_clave.Text]),lq_qry,_TODOS) then begin
        FormShow(Sender);
        Action1Execute(Sender);
        acGuardar.Enabled := False;
        edt_clave.Clear;
        edt_nombre.Enabled := False;
        edt_clave.Enabled  := False;
        ls_inicio.Enabled  := False;
        ls_final.Enabled   := False;
    end;
    lq_qry.Destroy;
end;


procedure Tfrm_agencias.acGuardarExecute(Sender: TObject);
Const
    ls_qry = 'INSERT INTO PDV_C_AGENCIA VALUES(''%s'',''%s'',%s,%s,NULL)';
var
    lq_qry : TSQLQuery;
begin///guardamos la nueva agencia
    if (Length(edt_nombre.Text) = 0)  then begin
        Mensaje('Error en el nombre',1);
        edt_nombre.SetFocus;
        exit;
    end;
    if ls_inicio.ItemIndex = -1 then begin
        Mensaje('Error en el numero de asiento',1);
        ls_inicio.SetFocus;
        exit;
    end;
    if ls_final.ItemIndex = -1 then begin
        Mensaje('Error en el numero de asiento',1);
        ls_final.SetFocus;
        exit;
    end;
    if  StrToInt(ls_inicio.CurrentID) > StrToInt(ls_final.CurrentID) then begin
        Mensaje('Error en el rango de asientos',1);
        ls_inicio.ItemIndex := -1;
        ls_final.ItemIndex  := -1;
        ls_inicio.SetFocus;
        exit;
    end;

    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(ls_qry,[UpperCase(edt_clave.Text), edt_nombre.Text,ls_inicio.CurrentID,
                                 ls_final.CurrentID]),lq_qry,_TODOS) then begin
        FormShow(Sender);
        Action1Execute(Sender);
    end;

end;

procedure Tfrm_agencias.Action1Execute(Sender: TObject);
begin
    edt_clave.Enabled  := True;
    edt_nombre.Enabled := True;
    ls_inicio.Enabled  := true;
    ls_final.Enabled   := True;
    acGuardar.Enabled  := True;
    acEliminar.Enabled := False;
    edt_nombre.Clear;
    ls_inicio.ItemIndex := -1;
    ls_final.ItemIndex  := -1;
    edt_clave.SetFocus;
end;

procedure Tfrm_agencias.Button1Click(Sender: TObject);
var
    lfr_forma : Tfrm_relacion_terminal;
begin
    lfr_forma := Tfrm_relacion_terminal.Create(self);
    MostrarForma(lfr_forma);
end;

procedure Tfrm_agencias.FormShow(Sender: TObject);
begin
    titulosGrid;
    llenaCombos();
    getAgencias();
    acGuardar.Enabled := False;
    acEliminar.Enabled := False;
end;

procedure Tfrm_agencias.getAgencias;
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_AGE_TODAS,lq_qry,_LOCAL) then
      LlenarStringGridAll(lq_qry,stg_agencia);
    lq_qry.Destroy;
end;

procedure Tfrm_agencias.llenaCombos;
var
    li_ctrl : Integer;
begin
    for li_ctrl := 1 to 45 do begin
        ls_inicio.Add(IntToStr(li_ctrl),IntToStr(li_ctrl));
        ls_final.Add(IntToStr(li_ctrl),IntToStr(li_ctrl));
    end;
end;


procedure Tfrm_agencias.SalirExecute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_agencias.stg_agenciaSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
//    edt_clave.Enabled  := true;
    edt_nombre.Enabled := true;
    ls_inicio.Enabled := true;
    ls_final.Enabled  := true;
    acGuardar.Enabled := False;
    acEliminar.Enabled := True;
    edt_nombre.SetFocus;
    edt_clave.Text := UpperCase(stg_agencia.Cols[3].Strings[ARow]);
    edt_nombre.Text := UpperCase(stg_agencia.Cols[0].Strings[ARow]);
    ls_inicio.SetID(stg_agencia.Cols[1].Strings[ARow]);
    ls_final.SetID(stg_agencia.Cols[2].Strings[ARow])
end;

procedure Tfrm_agencias.titulosGrid;
begin
    stg_agencia.Cells[0,0] := 'Nombre';
    stg_agencia.Cells[1,0] := 'Asiento Inicial';
    stg_agencia.Cells[2,0] := 'Asiento Final';
    stg_agencia.Cells[3,0] := 'Clave';
end;

end.
