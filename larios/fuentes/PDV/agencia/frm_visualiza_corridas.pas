unit frm_visualiza_corridas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ExtCtrls, PlatformDefaultStyleActnCtrls,
  ActnList, ActnMan, Data.SqlExpr,
  ToolWin, ActnCtrls, ActnMenus, lsCombobox, Grids, System.Actions;

Const
    _TERMINALES = 'SELECT T.ID_TERMINAL,CT.DESCRIPCION '+
                  'FROM PDV_C_TERMINAL T INNER JOIN T_C_TERMINAL CT ON T.ID_TERMINAL = CT.ID_TERMINAL ';
    _AGENCIAS   = 'SELECT ID_AGENCIA, NOMBRE FROM PDV_C_AGENCIA';
    _SERVICIOS  = 'SELECT TIPOSERVICIO, DESCRIPCION FROM SERVICIOS';
    _GRID       = 'SELECT DISTINCT(ID_CORRIDA), R.ORIGEN, R.DESTINO, S.DESCRIPCION '+
                  'FROM T_C_RUTA R INNER JOIN T_C_RUTA_D D ON R.ID_RUTA = D.ID_RUTA '+
                  ' INNER JOIN PDV_C_ITINERARIO I ON I.ID_RUTA = R.ID_RUTA '+
                  ' INNER JOIN SERVICIOS S ON S.TIPOSERVICIO =  I.TIPOSERVICIO '+
                  'WHERE ORIGEN = ''%s'' AND DESTINO = ''%s'' AND I.TIPOSERVICIO = %s ';
    _BORRA_RELACION = 'DELETE FROM PDV_C_AGENCIA_CORRIDA WHERE ID_CORRIDA = ''%s'' AND ID_AGENCIA = ''%s'' ';
    _OBTIENE_RELACION = 'SELECT DISTINCT(A.ID_CORRIDA),ID_AGENCIA '+
                        'FROM PDV_C_ITINERARIO I INNER JOIN PDV_C_AGENCIA_CORRIDA A ON I.ID_CORRIDA = A.ID_CORRIDA '+
                        'WHERE TIPOSERVICIO = %s AND ID_AGENCIA = ''%s'' ';

    _GUARDA_RELACION = 'INSERT INTO PDV_C_AGENCIA_CORRIDA VALUES(''%s'',''%s'')';
type
  Tfrm_agencia_corrida = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    ls_agencia: TlsComboBox;
    ls_destino: TlsComboBox;
    Label2: TLabel;
    Label3: TLabel;
    ls_servicio: TlsComboBox;
    Button1: TButton;
    Panel3: TPanel;
    StringGrid1: TStringGrid;
    CheckBox1: TCheckBox;
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    Action2: TAction;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Action2Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
     procedure addTituloCheckbox;
    procedure ChkTituloClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frm_agencia_corrida: Tfrm_agencia_corrida;

implementation

uses DMdb, comun, u_main;

{$R *.dfm}

var
    li_row : integer;
    li_consulta : integer;


procedure Tfrm_agencia_corrida.Action1Execute(Sender: TObject);
var
    li_ctrl : integer;
    lq_qry, lq_qryD : TSQLQuery;
begin
    if ls_agencia.ItemIndex = -1 then begin
        Mensaje('Seleccione una agencia',1);
        ls_agencia.SetFocus;
        exit;
    end;

    if li_consulta = 0 then begin
      Mensaje('Consulte las corridas para la asignacion',2);
      ls_destino.SetFocus;
      exit;
    end;

    lq_qry := TSQLQuery.Create(nil);
    lq_qryD := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    lq_qryD.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_OBTIENE_RELACION,[ls_servicio.CurrentID,
                            ls_agencia.CurrentID]),lq_qry,_LOCAL) then begin
        with lq_qry do begin
          First;
          while not EoF do begin
              if EjecutaSQL(format(_BORRA_RELACION,[lq_qry['ID_CORRIDA'],lq_qry['ID_AGENCIA']]),lq_qryD,_LOCAL) then
                  ;
              next;
          end;
        end;
    end;
    for li_ctrl := 1 to StringGrid1.RowCount do begin
        if StringGrid1.Cells[4,li_ctrl] = 'Asignada' then begin
            if EjecutaSQL(format(_GUARDA_RELACION,[ls_agencia.CurrentID,
                            StringGrid1.Cells[0,li_ctrl]]),lq_qry,_LOCAL) then
              ;
        end;
    end;
    lq_qry.Destroy;
    lq_qryD.Destroy;
    Mensaje('Se han asignado las corridas a la agencia',2);
    for li_ctrl := 1 to StringGrid1.RowCount do begin
        StringGrid1.Cells[0,li_ctrl] := '';
        StringGrid1.Cells[1,li_ctrl] := '';
        StringGrid1.Cells[2,li_ctrl] := '';
        StringGrid1.Cells[3,li_ctrl] := '';
        StringGrid1.Cells[4,li_ctrl] := '';
    end;
    FormShow(Sender);
    StringGrid1.RowCount := 2;
    StringGrid1.FixedRows := 1;
end;

procedure Tfrm_agencia_corrida.Action2Execute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_agencia_corrida.addTituloCheckbox;
var
    NewCheckBox: TCheckBox;
    Rect: TRect;
begin
      NewCheckBox := (StringGrid1.Objects[4,0] as TCheckBox);
      if NewCheckBox <> nil then begin// the object must exist to delete it...
          NewCheckBox.Visible := false;
          StringGrid1.Objects[4,0] := nil;
      end;
      NewCheckBox := TCheckBox.Create(Application);
      NewCheckBox.Width := 0;
      NewCheckBox.Visible := false;
      NewCheckBox.Caption := 'Todos';
      NewCheckBox.Color := clWhite;
      NewCheckBox.Tag := 0;
      NewCheckBox.OnClick := ChkTituloClick;
      NewCheckBox.Parent := Panel3;
      StringGrid1.Objects[4,0] := NewCheckBox;
//      StringGrid1.RowCount := 0;
      if NewCheckBox <> nil then begin
          Rect := StringGrid1.CellRect(4,0); // here, we get the cell rect for our contol...
          NewCheckBox.Left := StringGrid1.Left + Rect.Left+2;
          NewCheckBox.Top := StringGrid1.Top + Rect.Top+2;
          NewCheckBox.Width := Rect.Right - Rect.Left;
          NewCheckBox.Height := Rect.Bottom - Rect.Top;
          NewCheckBox.Visible := True;
      end;
end;

procedure Tfrm_agencia_corrida.Button1Click(Sender: TObject);
var
    lq_qry : TSQLQuery;
    li_ctrl : integer;
begin
    if  ls_destino.ItemIndex = -1 then begin
        Mensaje('Seleccione un destino',1);
        ls_destino.SetFocus;
        exit;
    end;
    if  ls_servicio.ItemIndex = -1 then begin
        Mensaje('Seleccione un servicio',1);
        ls_servicio.SetFocus;
        exit;
    end;

    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_GRID,[gs_terminal,ls_destino.CurrentID,
                                ls_servicio.CurrentID]),lq_qry,_LOCAL) then begin
        with lq_qry do begin
            First;
            li_ctrl := 1;
            while not EoF do begin
                StringGrid1.Cells[0,li_ctrl] := lq_qry['ID_CORRIDA'];
                StringGrid1.Cells[1,li_ctrl] := lq_qry['ORIGEN'];
                StringGrid1.Cells[2,li_ctrl] := lq_qry['DESTINO'];
                StringGrid1.Cells[3,li_ctrl] := lq_qry['DESCRIPCION'];
                StringGrid1.Cells[4,li_ctrl] := 'Desasignada';
                inc(li_ctrl);
                li_consulta := 1;
                Next;
            end;
            if li_ctrl = 1 then begin
                StringGrid1.RowCount := 2;
                StringGrid1.FixedRows := 1;
                li_consulta := 0;
            end else begin
                        StringGrid1.RowCount := li_ctrl;
                        StringGrid1.FixedRows := 1;
            end;
        end;
     end;
     lq_qry.Destroy;
end;


procedure Tfrm_agencia_corrida.ChkTituloClick(Sender: TObject);
var
    i : integer;
    NewCheckBox: TCheckBox;
begin
    NewCheckBox := (StringGrid1.Objects[4,0] as TCheckBox);
    if NewCheckBox <> nil then begin
      if NewCheckBox.Checked = False then begin
          for I := 1 to StringGrid1.RowCount do begin
              if StringGrid1.Cells[4,I] <> '' then
                  StringGrid1.Cells[4,I] := 'Desasignada';
          end;
      end else begin
          for I := 1 to StringGrid1.RowCount do begin
              if StringGrid1.Cells[4,I] <> '' then
                  StringGrid1.Cells[4,I] := 'Asignada';
          end;
      end;
    end;
end;


procedure Tfrm_agencia_corrida.FormShow(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_TERMINALES,lq_qry,_LOCAL) then
        LlenarComboBox(lq_qry,ls_destino,False);
    if EjecutaSQL(_AGENCIAS,lq_qry,_LOCAL) then
        LlenarComboBox(lq_qry,ls_agencia,False);
    if EjecutaSQL(_SERVICIOS,lq_qry,_LOCAL) then
        LlenarComboBox(lq_qry,ls_servicio,False);
    lq_qry.Destroy;
    StringGrid1.Cells[0,0] := 'Corrida';
    StringGrid1.Cells[1,0] := 'Origen';
    StringGrid1.Cells[2,0] := 'Destino';
    StringGrid1.Cells[3,0] := 'Servicio';
    addTituloCheckbox;
    ls_agencia.ItemIndex := -1;
    ls_destino.ItemIndex := -1;
    ls_servicio.ItemIndex := -1;
    li_consulta := 0;
end;

procedure Tfrm_agencia_corrida.StringGrid1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 Column, Row: Longint;
begin
   StringGrid1.MouseToCell(X, Y, Column, Row);
   if stringgrid1.Cells[4, Row] = '' then
      exit;
   if stringgrid1.Cells[4, Row] = 'Asignada' then
    stringgrid1.cells[4, Row]:= 'Desasignada'
   else
    stringgrid1.cells[4, Row]:= 'Asignada';
end;

end.
