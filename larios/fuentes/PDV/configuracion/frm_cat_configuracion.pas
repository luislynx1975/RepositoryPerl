unit frm_cat_configuracion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, Grids, StdCtrls, ActnList, DB,
   lsCombobox,  Data.SqlExpr, System.Actions;


type
  Tfrm_cat_config = class(TForm)
    ed_descrip: TEdit;
    ed_valor: TEdit;
    GroupBox1: TGroupBox;
    stg_config: TStringGrid;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    tbnt_update: TToolButton;
    ToolButton5: TToolButton;
    ActionList1: TActionList;
    Label1: TLabel;
    Label2: TLabel;
    ac99: TAction;
    ac113: TAction;
    ac113a: TAction;
    ac114: TAction;
    ac115: TAction;
    procedure ac99Execute(Sender: TObject);
    procedure ac113Execute(Sender: TObject);
    procedure ac113aExecute(Sender: TObject);
    procedure ac114Execute(Sender: TObject);
    procedure ac115Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure stg_configSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure TitlesGrid();
  public
    { Public declarations }
  end;

var
  frm_cat_config: Tfrm_cat_config;

implementation

uses DMdb, comun, u_main;

{$R *.dfm}

Const
    _CONFIG_SELECT_ALL = 'SELECT ID_PARAMETRO,DESCRIPCION,VALOR FROM PDV_C_PARAMETRO ORDER BY 1';
    _CONFIG_INSERT_NEW = 'INSERT INTO PDV_C_PARAMETRO VALUES(%s,''%s'',%s);';
    _CONFIG_DELETE_DEL = 'DELETE FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = %s';
    _CONFIG_UPDATE_UPD = 'UPDATE PDV_C_PARAMETRO SET DESCRIPCION = ''%s'', valor = %s WHERE ID_PARAMETRO = %s';

var
    lq_query : TSQLQuery;
    li_cve   : Integer;

procedure Tfrm_cat_config.ac99Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_cat_config.ac113Execute(Sender: TObject);
begin
    tbnt_update.Enabled := false;
end;

procedure Tfrm_cat_config.ac113aExecute(Sender: TObject);
begin
     if not AccesoPermitido(113,False)then
      exit;
     if Application.MessageBox(PChar(Format(_AGREGAR_INFORMACION,[ ' Capturada '])),
                      'Atención', _CONFIRMAR) = IDYES then begin
         if EjecutaSQL(Format(_CONFIG_INSERT_NEW,[IntToStr(getMaxTable('ID_PARAMETRO','PDV_C_PARAMETRO')),
                       ed_descrip.Text,ed_valor.Text])    ,lq_query,_TODOS)then
     end;
     tbnt_update.Enabled := false;
     ed_descrip.Clear;
     ed_valor.Clear;
     FormShow(Sender);
end;

procedure Tfrm_cat_config.ac114Execute(Sender: TObject);
begin
    if not AccesoPermitido(114,False) then
        exit;
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_INFORMACION,[ 'De usuarios ingresados '])),
                    'Atención', _CONFIRMAR) = IDYES then begin
        if not EjecutaSQL(Format( _CONFIG_UPDATE_UPD,[ed_descrip.Text,ed_valor.Text,IntToStr(li_cve)]) ,
                      lq_query,_TODOS) then
              exit;
            tbnt_update.Enabled := false;
            FormShow(Sender);
            ed_descrip.Clear;
            ed_valor.Clear;
    end;

end;


procedure Tfrm_cat_config.ac115Execute(Sender: TObject);
begin
//
end;

procedure Tfrm_cat_config.FormShow(Sender: TObject);
begin
    tbnt_update.Enabled := false;
    ed_descrip.Clear;
    ed_valor.Clear;
    TitlesGrid();
    if not EjecutaSQL(_CONFIG_SELECT_ALL,lq_query,_LOCAL)then
      exit
    else
        LlenarStringGridAll(lq_query,stg_config);
end;


procedure Tfrm_cat_config.stg_configSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if Length(stg_config.Cols[0].Strings[ARow]) = 0 then
        exit;
    tbnt_update.Enabled := true;
    li_cve          := StrToInt(stg_config.Cols[0].Strings[ARow]);
    ed_descrip.Text := stg_config.Cols[1].Strings[ARow];
    ed_valor.Text   := stg_config.Cols[2].Strings[ARow];
end;

procedure Tfrm_cat_config.TitlesGrid;
begin
    stg_config.Cells[0,0] := 'Clave';
    stg_config.Cells[1,0] := 'Descripcion';
    stg_config.Cells[2,0] := 'Valor';
    stg_config.RowCount := 2;
end;

procedure Tfrm_cat_config.FormCreate(Sender: TObject);
begin
    lq_query := TSQLQuery.Create(nil);
    lq_query.SQLConnection := DM.Conecta;
end;

end.
