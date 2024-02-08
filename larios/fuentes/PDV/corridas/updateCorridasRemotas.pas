unit updateCorridasRemotas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, lsCombobox, Vcl.ExtCtrls,
  Vcl.Grids, Data.SqlExpr, System.Actions, Vcl.ActnList, Vcl.ComCtrls, Vcl.Menus;

type
  Tfrm_updateCorridas = class(TForm)
    grp_corridas_remotas: TGroupBox;
    stg_corrida: TStringGrid;
    Panel1: TPanel;
    Label1: TLabel;
    cmb_terminal: TlsComboBox;
    Button1: TButton;
    Button2: TButton;
    ActionList1: TActionList;
    acConecta: TAction;
    acSalir: TAction;
    dtp_calendario: TDateTimePicker;
    Button3: TButton;
    acConsultar: TAction;
    lbl_conectado: TLabel;
    StatusBar1: TStatusBar;
    acAbrir: TAction;
    acCerrar: TAction;
    PopupMenu1: TPopupMenu;
    Abrir1: TMenuItem;
    Cerrar1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure acConectaExecute(Sender: TObject);
    procedure acSalirExecute(Sender: TObject);
    procedure acConsultarExecute(Sender: TObject);
    procedure Abrir1Click(Sender: TObject);
    procedure acCerrarExecute(Sender: TObject);
  private
    { Private declarations }
    procedure Titles;
  public
    { Public declarations }
  end;

var
  frm_updateCorridas: Tfrm_updateCorridas;

implementation

{$R *.dfm}

uses uQuerysNuevos, comun, DMdb, u_comun_venta, U_venta;

procedure Tfrm_updateCorridas.Abrir1Click(Sender: TObject);
var
    qry : TSQLQuery;
    lcEstado : char;
    lsTerminal : String;
begin
    lcEstado := 'A';
    lsTerminal := cmb_terminal.CurrentID;
    qry := TSQLQuery.Create(nil);
    qry.SQLConnection := CONEXION_REMOTO;
    qry.SQL.Clear;
    qry.SQL.Add(_UPDATE_CORRIDA_NEWD);
    qry.Params[0].AsString := lcEstado;
    qry.Params[1].AsString := stg_corrida.Cells[_COL_CORRIDA, stg_corrida.Row];
    qry.Params[2].AsString := FormatDateTime('YYYY-MM-DD', dtp_calendario.Date);
    qry.Params[3].AsString := lsTerminal;
    qry.ExecSQL();
    stg_corrida.Cells[_COL_STATUS, stg_corrida.Row] :=  'Abierta';
    qry.free;
end;

procedure Tfrm_updateCorridas.acCerrarExecute(Sender: TObject);
var
    qry : TSQLQuery;
    lcEstado : char;
    lsTerminal : String;
begin
    lcEstado := 'C';
    lsTerminal := cmb_terminal.CurrentID;
    qry := TSQLQuery.Create(nil);
    qry.SQLConnection := CONEXION_REMOTO;
    qry.SQL.Clear;
    qry.SQL.Add(_UPDATE_CORRIDA_NEWD);
    qry.Params[0].AsString := lcEstado;
    qry.Params[1].AsString := stg_corrida.Cells[_COL_CORRIDA, stg_corrida.Row];
    qry.Params[2].AsString := FormatDateTime('YYYY-MM-DD', dtp_calendario.Date);
    qry.Params[3].AsString := lsTerminal;
    qry.ExecSQL();
    stg_corrida.Cells[_COL_STATUS, stg_corrida.Row] :=  'Cerrada';
    qry.free;
end;

procedure Tfrm_updateCorridas.acConectaExecute(Sender: TObject);
var
    ls_terminal : string;
    query : TSQLQuery;
begin//conectamos con el servidor
    if cmb_terminal.ItemIndex = -1 then begin
        ShowMessage('Seleccione la terminal al que se quiere conectar');
        exit;
    end;
    ls_terminal := cmb_terminal.CurrentID;
    CONEXION_REMOTO := conexionServidorRemoto(ls_terminal);
    if CONEXION_REMOTO.Connected then begin
        ShowMessage('Ahora esta conectado a : ' + cmb_terminal.Text);
        grp_corridas_remotas.Enabled := True;
        StatusBar1.Panels[2].Text := cmb_terminal.Text;
        lbl_conectado.Caption := 'Conectado a : ' + cmb_terminal.Text;
        LimpiaSag(stg_corrida);
        Titles;
    end;

end;

procedure Tfrm_updateCorridas.acConsultarExecute(Sender: TObject);
var
    lsfechaInicio, lsfechaFin, ls_hora : String;
    qry : TSQLQuery;
    store : TSQLStoredProc;
    li_idx : integer;
    ls_char : char;
begin
    lsfechaInicio :=  FormatDateTime('DD/MM/YYYY',dtp_calendario.Date);
    qry :=TSQLQuery.create(nil);
    qry.SQLConnection := DM.Conecta;
    qry.sql.clear;
    qry.sql.add(_DIA_SIGUIENTE);
    qry.params[0].asString := FormatDateTime('YYYY-MM-DD',dtp_calendario.Date);
    qry.open;
    lsfechaFin := qry['fecha'];
    store := TSQLStoredProc.create(nil);
    store.SQLConnection := CONEXION_REMOTO; //DM.Conecta;
    store.StoredProcName := 'PDV_STORE_STATUS_CORRIDAS';
    store.Params.ParamByName('IN_ORIGEN').AsString := cmb_terminal.CurrentID;
    store.Open;
    store.first;
    li_idx := 1;
    while not store.eof do begin
       ls_char := Store.FieldByName('TIPO').AsString[1];
       case ls_char of
            'E' : ls_hora := 'E ' + FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
            else ls_hora := FormatDateTime('HH:nn',Store.FieldByName('HORA').AsDateTime);
       end;    
       llenarGridCorridas(ls_hora,store,li_idx,stg_corrida);
       if Store.FieldByName('ESTATUS').AsString = 'A' then
            stg_corrida.Cells[_COL_STATUS,li_idx - 1] :=  'Abierta';
       if Store.FieldByName('ESTATUS').AsString = 'C' then
            stg_corrida.Cells[_COL_STATUS,li_idx - 1] :=  'Cerrada';                                     
       if Store.FieldByName('ESTATUS').AsString = 'D' then
            stg_corrida.Cells[_COL_STATUS,li_idx - 1] :=  'Despachada';  
       if Store.FieldByName('ESTATUS').AsString = 'V' then
            stg_corrida.Cells[_COL_STATUS,li_idx - 1] :=  'Vacio';           
       store.next;
    end;
    stg_corrida.RowCount := li_idx;
    store.free;    
end;

procedure Tfrm_updateCorridas.acSalirExecute(Sender: TObject);
begin
    Close;
end;

procedure Tfrm_updateCorridas.FormShow(Sender: TObject);
var
    query : TSQLQuery;
    lsQry : string;
begin
    lsQry := Format(_LISTA_TERMINALES,[gs_terminal, gs_terminal]);
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    query.SQL.Clear;
    query.SQL.Add(lsQry);
    query.Open;
    with query do begin
      First;
      while not Eof do begin
        cmb_terminal.Add(query['DESCRIPCION'], query['ID_TERMINAL']);
        Next;
      end;
    end;
    query.Free;
    query := nil;
    dtp_calendario.Date := Now();
    Titles;
end;

procedure Tfrm_updateCorridas.Titles;
begin
  stg_corrida.Cells[_COL_HORA, 0] := 'HORA';
  stg_corrida.Cells[_COL_DESTINO, 0] := 'DESTINO';
  stg_corrida.Cells[_COL_SERVICIO, 0] := 'SERVICIO ';
  stg_corrida.Cells[_COL_FECHA, 0] := 'FECHA';
  stg_corrida.Cells[_COL_RUTA, 0] := 'Ruta';
  stg_corrida.Cells[_COL_CORRIDA, 0] := 'Corrida';
  stg_corrida.Cells[_COL_STATUS, 0] := 'Estatus';
  stg_corrida.ColWidths[_COL_TRAMO] := 0;
  stg_corrida.ColWidths[_COL_AUTOBUS] := 0;
  stg_corrida.ColWidths[_COL_ASIENTOS] := 0;
  stg_corrida.ColWidths[_COL_NAME_IMAGE] := 0;
  stg_corrida.ColWidths[_COL_TIPOSERVICIO] := 0;
  stg_corrida.ColWidths[_COL_PIE] := 0;
  stg_corrida.ColWidths[_col_TARIFA] := 0; 
end;

end.
