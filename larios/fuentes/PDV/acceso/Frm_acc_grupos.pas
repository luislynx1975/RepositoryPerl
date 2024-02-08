/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Acceso                                                        //
//  Pantalla:    Registro de grupos                                            //
//  Descripción: //
//  Fecha:       21 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
/////////////////////////////////////////////////////////////////////////////////

unit Frm_acc_grupos;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ToolWin, ActnList, Grids, System.Actions,
  Data.SqlExpr;

type
  TFrm_grupos = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ed_descripcion: TEdit;
    Label2: TLabel;
    Dtp_fecha: TDateTimePicker;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ActionList1: TActionList;
    ac101: TAction;
    ac101a: TAction;
    ac102: TAction;
    Tbtn_nuevo: TToolButton;
    Tbtn_guardar: TToolButton;
    Tbtn_update: TToolButton;
    ac99: TAction;
    ToolButton4: TToolButton;
    Stg_grupos: TStringGrid;
    lb_cve: TLabel;
    tbtn_baja: TToolButton;
    ac151: TAction;
    procedure ac101aExecute(Sender: TObject);
    procedure ac102Execute(Sender: TObject);
    procedure ac99Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Stg_gruposSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ac101Execute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ac151Execute(Sender: TObject);
  private
    { Private declarations }
    procedure TitulosGrid();
  public
    { Public declarations }
  end;

var
  Frm_grupos: TFrm_grupos;

implementation

uses DMdb, comun, u_main;

var
    ls_qry : String;
    lq_query : TSQLQuery;
    gi_ids   : integer;
    gs_desc  : String;
    gt_fecha : TDateTime;
    li_row   : integer;

{$R *.dfm}

procedure TFrm_grupos.ac101aExecute(Sender: TObject);
begin
    if not AccesoPermitido(101,False) then
        Exit;
    Tbtn_nuevo.Enabled   := true;
    Tbtn_guardar.Enabled := false;
    Tbtn_update.Enabled  := false;
    if Length(ed_descripcion.Text) = 0 then begin
        Mensaje(_INFORMACION_INSUFICIENTE,0);
        ed_descripcion.SetFocus;
        exit;
    end;
    ls_qry := _qry_grupos_insert +
              IntToStr(getMaxTable('ID_GRUPO','PDV_C_GRUPO_USUARIO')) +
                      ','''+ UpperCase(ed_descripcion.Text) + ''',NULL)';
    if not EjecutaSQL(ls_qry,lq_query,_TODOS) then
        Mensaje(_NO_GUARDO_DATO,0)
    else begin
        FormShow(Self);
        Tbtn_nuevo.Enabled  := true;
        Tbtn_update.Enabled := false;
        Tbtn_guardar.Enabled := false;
        ed_descripcion.Clear;
        lb_cve.Caption := '.';
    end;
end;



procedure TFrm_grupos.ac102Execute(Sender: TObject);
begin
    if not AccesoPermitido(102,False) then
      exit;
    Tbtn_update.Enabled := false;
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_DATO,[ 'De grupos ingresados '])),
                    'Atención', _CONFIRMAR) = IDYES then begin
        ls_qry := 'UPDATE PDV_C_GRUPO_USUARIO SET DESCRIPCION = '''+ ed_descripcion.Text + ''''+
                  ' WHERE ID_GRUPO = ' + IntToStr(gi_ids);
        if EjecutaSQL(ls_qry,lq_query,_TODOS) then begin
           Stg_grupos.Cells[1,li_row] := ed_descripcion.Text;
           Stg_grupos.Cells[2,li_row] := FormatDateTime('YYYY-MM-DD',Dtp_fecha.Date);
           Mensaje(_INFORMACION_UPDATE,0);
           Tbtn_nuevo.Enabled  := True;
           Tbtn_update.Enabled := false;
           Tbtn_guardar.Enabled := False;
           Tbtn_baja.enabled    := false;
           ed_descripcion.Clear;
           lb_cve.Caption := '.';
        end;
    end;
end;



procedure TFrm_grupos.ac151Execute(Sender: TObject);
begin
     if not AccesoPermitido(151,False) then
        exit;
    if Application.MessageBox(PChar(Format(_ELIMINAR_REGISTRO,[ ''])),
                    'Atención', _CONFIRMAR) = IDYES then begin
        if EjecutaSQL(format(_qry_baja_usuario,[IntToStr(gi_ids)]),lq_query,_TODOS) then begin
            Tbtn_nuevo.Enabled  := false;
            Tbtn_update.Enabled := false;
            Tbtn_guardar.Enabled := true;
            ed_descripcion.Clear;
            lb_cve.Caption := '.';
        end;
    end;
end;

procedure TFrm_grupos.ac99Execute(Sender: TObject);
begin
    Close();
end;



procedure TFrm_grupos.FormShow(Sender: TObject);
begin
    TitulosGrid();
    try
        lq_query := TSQLQuery.Create(nil);
        lq_query.SQLConnection := DM.Conecta;
        if EjecutaSQL(_qry_grupos_select,lq_query,_LOCAL) then
            LlenarStringGridAll(lq_query,Stg_grupos); //llenamos el grid
    except
        lq_query.Free;
    end;
end;



procedure TFrm_grupos.TitulosGrid;
begin
    Stg_grupos.Cells[0,0] := 'Clave';
    Stg_grupos.Cells[1,0] := 'Descripcion';
//    Stg_grupos.Cells[2,0] := 'Fecha Baja';
end;



procedure TFrm_grupos.Stg_gruposSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    li_row := ARow;
    if Length(Stg_grupos.Cols[0].Strings[ARow]) = 0 then
        exit;

    gi_ids   := StrToInt(Stg_grupos.Cols[0].Strings[ARow]);
    gs_desc  := Stg_grupos.Cols[1].Strings[ARow];

    lb_cve.Caption := 'Clave : ' + Stg_grupos.Cols[0].Strings[ARow];
    ed_descripcion.Text := Stg_grupos.Cols[1].Strings[ARow];
    try
{      gt_fecha := StrToDateTime(Stg_grupos.Cols[2].Strings[ARow]);
      Dtp_fecha.Date := gt_fecha;  }
      Tbtn_update.Enabled  := True;
      Tbtn_nuevo.Enabled   := True;
      tbtn_baja.Enabled    := true;
      Tbtn_guardar.Enabled := False;
    except
    end;
end;


procedure TFrm_grupos.ac101Execute(Sender: TObject);
begin///nuevo
      Tbtn_nuevo.Enabled  := false;
      Tbtn_update.Enabled := false;
      tbtn_baja.Enabled   := False;
      Tbtn_guardar.Enabled := true;
      ed_descripcion.Clear;
      lb_cve.Caption := '.';
end;



procedure TFrm_grupos.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    lq_query.Free;
end;

end.

