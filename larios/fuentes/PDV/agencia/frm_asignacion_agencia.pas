unit frm_asignacion_agencia;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, Grids, DB, ActnList, Data.SqlExpr,
  PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls, ActnMenus,
  System.Actions;

Const
    _AGENCIA_TERMINAL_GET = 'SELECT ID_AGENCIA, ID_TERMINAL FROM PDV_C_AGENCIA_TERMINAL ORDER BY 1';
    _AGENCIA_TODAS = 'SELECT ID_AGENCIA,NOMBRE FROM PDV_C_AGENCIA ORDER BY 1';
    _TERMINAL_TODAS = 'SELECT T.ID_TERMINAL, CT.DESCRIPCION '+
                      'FROM PDV_C_TERMINAL T INNER JOIN T_C_TERMINAL CT ON T.ID_TERMINAL = CT.ID_TERMINAL '+
                      'UNION '+
                      'SELECT ID_TERMINAL, DESCRIPCION '+
                      'FROM T_C_TERMINAL '+
                      'WHERE ID_TERMINAL = ''%s'' '+
                      'ORDER BY 1 ';
//                      'WHERE T.ID_TERMINAL <> ''%s'' ';
    _RELACION_T_A   = 'SELECT A.NOMBRE, T.DESCRIPCION, AT.ID_AGENCIA, AT.ID_TERMINAL '+
                      'FROM PDV_C_AGENCIA_TERMINAL AT INNER JOIN PDV_C_AGENCIA A ON AT.ID_AGENCIA = A.ID_AGENCIA '+
                      ' INNER JOIN T_C_TERMINAL T ON T.ID_TERMINAL = AT.ID_TERMINAL ORDER BY 3';
    _AGREGA_RELACION = 'INSERT INTO PDV_C_AGENCIA_TERMINAL VALUES(''%s'',''%s'')';


type
  Tfrm_relacion_terminal = class(TForm)
    stg_agencia_terminal: TStringGrid;
    ls_agencia: TlsComboBox;
    ls_terminal: TlsComboBox;
    Label1: TLabel;
    Label2: TLabel;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    procedure FormShow(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
    procedure titulos();
  public
    { Public declarations }
  end;

var
  frm_relacion_terminal: Tfrm_relacion_terminal;

implementation

uses DMdb, comun, frm_pdv_main, u_main;

{$R *.dfm}

procedure Tfrm_relacion_terminal.Action1Execute(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
    if ls_agencia.ItemIndex = -1 then begin
        Mensaje('Seleccione la agencia',1);
        ls_agencia.SetFocus;
        exit;
    end;
    if ls_terminal.ItemIndex = -1 then begin
        Mensaje('Seleccione la terminal',1);
        ls_terminal.SetFocus;
        Exit;
    end;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_AGREGA_RELACION,[ls_agencia.CurrentID,ls_terminal.CurrentID]),
                        lq_qry,_TODOS) then
        FormShow(Sender);
    lq_qry.Destroy;
end;

procedure Tfrm_relacion_terminal.Action2Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_relacion_terminal.FormShow(Sender: TObject);

var
    lq_qry : TSQLQuery;
begin
    titulos();
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_AGENCIA_TERMINAL_GET,lq_qry,_LOCAL) then
        LlenarStringGridAll(lq_qry,stg_agencia_terminal);

    if EjecutaSQL(_AGENCIA_TODAS,lq_qry,_LOCAL) then
        LlenarComboBox(lq_qry,ls_agencia,FALSE);

    if EjecutaSQL(Format(_TERMINAL_TODAS,[gs_Terminal]),lq_qry,_LOCAL) then
        LlenarComboBox(lq_qry,ls_terminal,False);

    if EjecutaSQL(_RELACION_T_A,lq_qry,_LOCAL) then
        LlenarStringGridAll(lq_qry,stg_agencia_terminal);
    lq_qry.Destroy;
    ls_agencia.ItemIndex := -1;
    ls_terminal.ItemIndex := -1;

end;

procedure Tfrm_relacion_terminal.titulos;
begin
    stg_agencia_terminal.Cells[0,0] := 'Agencia';
    stg_agencia_terminal.Cells[1,0] := 'Terminal';
    stg_agencia_terminal.ColWidths[2] := 0;
    stg_agencia_terminal.ColWidths[3] := 0;
end;

end.
