unit frm_reimpresion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls, ActnList, PlatformDefaultStyleActnCtrls, ActnMan,
  ToolWin, ActnCtrls, ActnMenus, StdCtrls, Mask, DateUtils, DB, System.Actions,
  Vcl.ComCtrls, lsCombobox, Data.SqlExpr;

type
  Tfrm_reimprimeguia = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    Panel1: TPanel;
    Panel2: TPanel;
    stg_despacho: TStringGrid;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    medt_fecha: TMaskEdit;
    StatusBar1: TStatusBar;
    GroupBox2: TGroupBox;
    acReimprime: TAction;
    cmb_autobus: TlsComboBox;
    cmb_operador1: TlsComboBox;
    Label1: TLabel;
    Label3: TLabel;
    ActionMainMenuBar2: TActionMainMenuBar;
    edt_boletera: TEdit;
    Label4: TLabel;
    stg_datosGuia: TStringGrid;
    procedure Action1Execute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure medt_fechaEnter(Sender: TObject);
    procedure medt_fechaExit(Sender: TObject);
    procedure stg_despachoKeyPress(Sender: TObject; var Key: Char);
    procedure acReimprimeExecute(Sender: TObject);
    procedure edt_boleteraChange(Sender: TObject);
    procedure stg_despachoSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure stg_despachoKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    procedure preimprime();
  public
    { Public declarations }
  end;

var
  frm_reimprimeguia: Tfrm_reimprimeguia;

implementation

uses u_guias, DMdb, U_venta, comun, u_main;

{$R *.dfm}

var
   li_GUIA, li_NO_BUS, li_TIPOSERVICIO : integer;
   ls_OPERADOR, ls_tipoCorrida : string;

procedure Tfrm_reimprimeguia.acReimprimeExecute(Sender: TObject);
var
    li_num, I : integer;
    la_datos : gga_parameters;
    lq_qry : TSQLQuery;
    ls_hora, ls_qry, ls_idx, ls_servicio, ls_str : String;
    ls_char : char;
    lc_ingreso : Currency;

begin
     if Application.MessageBox(PChar(format(_MSG_IMPRIME_GUIA,
                [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR) = IDYES then begin
                  lq_qry := TSQLQuery.Create(nil);
                  lq_qry.SQLConnection := DM.Conecta;
                  if (li_GUIA = 0) and (li_NO_BUS = 0) and (li_TIPOSERVICIO = 0) then begin
                        ls_idx := inttoStr(getMaxTable('ID_GUIA','PDV_T_GUIA'));
                        if EjecutaSQL(FORMAT(_GUIA_SERVICIOID,[stg_despacho.Cells[_COL_SERVICIO,stg_despacho.Row]]),lq_qry,_LOCAL) then
                            ls_servicio := lq_qry['TIPOSERVICIO'];
                        if Length(edt_boletera.Text) = 0 then
                          edt_boletera.Text := '0';
                       if EjecutaSQL(Format(_GUIA_EXISTENTE,[stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                              formatdateTime('YYYY-MM-DD',StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row] ) ),
                                              gs_terminal ] ), lq_qry, _LOCAL) then
                          if not VarIsNull(lq_qry['ID_GUIA']) then begin

                              li_existe_tabla := 1;
                              if EjecutaSQL(format(_GUIA_EXISTENTE,[stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                                                    formatdateTime('YYYY-MM-DD', StrToDate(stg_despacho.Cells[_COL_FECHA, stg_despacho.Row])),
                                                                    gs_terminal]),lq_qry,_LOCAL) then begin
                                  ls_idx := lq_qry['ID_GUIA'];
                                  if EjecutaSQL(format(_GUIA_BORRAR_EXISTENTE,[ls_idx]),lq_qry, _LOCAL) then
                                      ;
                              end;
                        end else begin
                              li_existe_tabla := 0;
                        end;
                  if EjecutaSQL(format(_AUTOBUS_CORRIDA_MASTER,[
                                cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                FormatDateTime('YYYY-MM-DD',StrToDate(medt_fecha.Text)) ]),lq_qry,_LOCAL) then
                                ;
                  if EjecutaSQL(format(_AUTOBUS_CORRIDA_MASTER,[
                                cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                FormatDateTime('YYYY-MM-DD',StrToDate(medt_fecha.Text)) ]),lq_qry,_SERVIDOR_CENTRAL) then
                                ;

                        EjecutaSQL(Format(_GUIA_DE_VIAJE_BORRAR,[ls_idx, gs_terminal]),lq_qry, _SERVIDOR_CENTRAL);
                        Sleep(100);
                        ls_char := stg_despacho.Cells[_COL_HORA,stg_despacho.Row][1];
                        case ls_char of
                            'E' : begin
                                    for I := 2 to length(stg_despacho.Cells[_COL_HORA,stg_despacho.Row]) do
                                        ls_str := ls_str + stg_despacho.Cells[_COL_HORA,stg_despacho.Row][I];
                                  end;
                            else
                                ls_str := stg_despacho.Cells[_COL_HORA,stg_despacho.Row];
                        end;
                        if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Predespachada' then ls_tipoCorrida := 'D';
                        if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Despachada' then ls_tipoCorrida := 'D';
                        if stg_despacho.Cells[_COL_STATUS,stg_despacho.Row] = 'Vacio' then ls_tipoCorrida := 'V';

                        ls_qry := Format(_GUIA_DE_VIAJE,[ls_idx,///1
                                              gs_terminal,//2
                                              formatdateTime('YYYY-MM-DD', StrToDate(stg_despacho.Cells[_COL_FECHA, stg_despacho.Row])),//3
                                              stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],//4
                                              stg_despacho.Cells[_COL_DESTINO,stg_despacho.Row],//5
                                              cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],//6
                                              FloatToStr(lc_ingreso),//7
                                              cmb_operador1.IDs[cmb_operador1.Items.IndexOf(cmb_operador1.Text)]//8
                                              ,gs_trabid,//9
                                              ls_servicio,//10   BUS
                                              stg_despacho.Cells[_COL_RUTA,stg_despacho.Row],//11
                                              '0',//12
                                              '0',//13
                                              '0',//14
                                              'Sin selección',//15
                                              '0',//16
                                              edt_boletera.Text,
                                              ls_str,//17
                                              ls_tipoCorrida
                                               ]
                                               );
                        EjecutaSQL(ls_qry,lq_qry,_LOCAL);
                        EjecutaSQL(ls_qry,lq_qry,_SERVIDOR_CENTRAL);
                  end;

                  splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row],' ',la_datos,li_num);
                  if li_num = 0 then
                     ls_hora :=  la_datos[0]
                  else ls_hora :=  la_datos[1];

                  if EjecutaSQL(format(_GUIA_CLAVE_SELECCION_REIMPRESION,[stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                          formatdateTime('YYYY-MM-DD', StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]))
                                                                         ]), lq_qry, _LOCAL) then
                      li_guia := StrToInt(lq_qry['ID_GUIA']);

                  if EjecutaSQL(format(_GUIA_INGRESO_BOLETO,[stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                                            formatdateTime('YYYY-MM-DD', StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                            gs_terminal]),lq_qry,_LOCAL) then
                      lc_ingreso := lq_qry['INGRESO'];
                  if Length(edt_boletera.Text) = 0 then
                      edt_boletera.Text := '0';

                  if EjecutaSQL(format(_AUTOBUS_CORRIDA_MASTER,[
                                cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                FormatDateTime('YYYY-MM-DD',StrToDate(medt_fecha.Text)) ]),lq_qry,_LOCAL) then
                                ;
                  if EjecutaSQL(format(_AUTOBUS_CORRIDA_MASTER,[
                                cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                stg_despacho.Cells[_COL_CORRIDA,stg_despacho.Row],
                                FormatDateTime('YYYY-MM-DD',StrToDate(medt_fecha.Text)) ]),lq_qry,_SERVIDOR_CENTRAL) then
                                ;
                  ls_qry := Format(_GUIA_UPDATE_REIMPRESION,[cmb_autobus.IDs[cmb_autobus.Items.IndexOf(cmb_autobus.Text)],
                                                                cmb_operador1.IDs[cmb_operador1.Items.IndexOf(cmb_operador1.Text)],
                                                                gs_trabid,
                                                                stg_despacho.Cols[_COL_DESTINO].Strings[stg_despacho.Row], FloatToStr(lc_ingreso),
                                                                edt_boletera.Text,
                                                                IntToStr(li_guia),
                                                                formatdateTime('YYYY-MM-DD', StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row])),
                                                                stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                                gs_terminal
                                                                ]);
                  EjecutaSQL(ls_qry, lq_qry, _SERVIDOR_CENTRAL);
                  EjecutaSQL(ls_qry, lq_qry, _SERVIDOR_CENTRAL);
                  if EjecutaSQL(ls_qry,lq_qry,_LOCAL) then begin
                        if EjecutaSQL(ls_qry, lq_qry, _SERVIDOR_CENTRAL) then
                            ;
                        if EjecutaSQL(Format(_GUIA_REIMPRESION,[stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                                      formatDateTime('YYYY-MM-DD',
                                                      StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]))]),lq_qry,_LOCAL) then begin
                             li_existe_tabla := 1;
                             generaGuiaViaje(lq_qry['ID_GUIA'],lq_qry['ID_CORRIDA'],
                                      formatDateTime('YYYY-MM-DD', StrToDate(lq_qry['FECHA'])),ls_hora,li_existe_tabla,
                                      gs_terminal,gs_trabid);
                        end;
                  end;
                  cmb_autobus.ItemIndex := -1;
                  cmb_operador1.ItemIndex := -1;
                  edt_boletera.Clear;
                  GroupBox2.Visible := False;
                  lq_qry.Free;
                  lq_qry := nil;
     end;
end;


procedure Tfrm_reimprimeguia.Action1Execute(Sender: TObject);
begin
    Close;
end;


procedure Tfrm_reimprimeguia.edt_boleteraChange(Sender: TObject);
var
  ls_input: string;
  li_ctrl_input: Integer;
begin
  ls_input := trim(edt_boletera.Text);
  for li_ctrl_input := 1 to length(ls_input)  do begin
    if not(ls_input[li_ctrl_input] in ['0' .. '9']) then begin
      edt_boletera.Clear;
      edt_boletera.SetFocus;
    end;
  end;
end;

procedure Tfrm_reimprimeguia.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
///////////
    if Key = VK_F1 then begin
        carga_reimpresion(FormatDateTime('YYYY-MM-DD',StrToDate(medt_fecha.Text)),gs_terminal ,stg_despacho);
        stg_despacho.SetFocus;
    end;
    if key = VK_F3 then begin
        GroupBox2.Visible := False;
        LimpiaSag(stg_despacho);
        titulosCorridaGrid(stg_despacho);
        medt_fecha.SetFocus;
    end;
end;


procedure Tfrm_reimprimeguia.FormShow(Sender: TObject);
var
    lq_qry : TSQLQuery;
begin
    medt_fecha.Text := FechaServer();
    medt_fecha.SelStart := 0;
    titulosCorridaGrid(stg_despacho);
    stg_despacho.Cells[_COL_TARIFA, 0] := 'Status';
    stg_despacho.ColWidths[_COL_TARIFA] := 170;
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := DM.Conecta;
    if EjecutaSQL(_GUIA_AUTOBUS,lq_qry,_LOCAL) then
        LlenarComboTarjeta(lq_qry,cmb_autobus);

    if EjecutaSQL(_GUIA_OPERADOR,lq_qry,_LOCAL) then
        LlenarComboTarjeta(lq_qry,cmb_operador1);
    lq_qry.Free;
    lq_qry := nil;
    stg_datosGuia.ColWidths[0] := 100;
    stg_datosGuia.ColWidths[1] := 100;
    stg_datosGuia.Cells[0,0] := 'Autobus';
    stg_datosGuia.Cells[0,1] := 'Operador';
end;

procedure Tfrm_reimprimeguia.medt_fechaEnter(Sender: TObject);
begin
    medt_fecha.SelStart := 0;
end;

procedure Tfrm_reimprimeguia.medt_fechaExit(Sender: TObject);
var
  ls_fecha: string;
  li_num: Integer;
  la_fecha: gga_parameters;
  myYear, myMonth, myDay: Word;
begin
  splitLine(medt_fecha.Text, '/', la_fecha, li_num);
  ls_fecha := la_fecha[0];
  if ls_fecha[1] = '0' then
    li_num := StrToInt(Copy(ls_fecha, 2, 1));

  try
    if li_num > DaysInMonth(StrToDateTime(medt_fecha.Text)) then
    begin
      Mensaje('Error en la fecha', 0);
      exit;
    end;
  except
    medt_fecha.Text := FechaServer();
  end;
end;


procedure Tfrm_reimprimeguia.stg_despachoKeyPress(Sender: TObject;
  var Key: Char);
var
    lq_qry : TSQLQuery;
    li_num : integer;
    ls_hora : String;
    la_datos : gga_parameters;
begin
{    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := CONEXION_VTA;
    if Key = #13 then begin
        if Application.MessageBox(PChar(format(_MSG_IMPRIME_GUIA,
            [stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]])), 'Confirme', _CONFIRMAR)
              = IDYES then begin
              splitLine(stg_despacho.Cols[_COL_HORA].Strings[stg_despacho.Row],' ',la_datos,li_num);
              if li_num = 0 then
                 ls_hora :=  la_datos[0]
              else ls_hora :=  la_datos[1];
              if EjecutaSQL(Format(_GUIA_REIMPRESION,[stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                                            formatDateTime('YYYY-MM-DD',
                                            StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]))]),lq_qry,_LOCAL) then begin
                   li_existe_tabla := 1;
                   generaGuiaViaje(lq_qry['ID_GUIA'],lq_qry['ID_CORRIDA'],
                            formatDateTime('YYYY-MM-DD', StrToDate(lq_qry['FECHA'])),ls_hora,1,gs_terminal,gs_trabid);
              end;
        end;
    end;
    lq_qry.Free;
    lq_qry := nil;}
end;

procedure Tfrm_reimprimeguia.stg_despachoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    preimprime();
//    stg_despachoSelectCell(Sender, 0, stg_despacho.Row, );
end;

procedure Tfrm_reimprimeguia.stg_despachoSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if (stg_despacho.RowCount <= ARow) and (ARow > 0) then
      preimprime();
end;


procedure Tfrm_reimprimeguia.preimprime;
var
    lq_qry : TSQLQuery;
    ls_idx : string;
begin
    if length(stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row]) > 0 then begin
       lq_qry := TSQLQuery.Create(nil);
       lq_qry.SQLConnection := DM.Conecta;
       if EjecutaSQL(Format(_GUIA_UPDATE_REIMPRIME,[gs_terminal,
                        stg_despacho.Cols[_COL_DESTINO].Strings[stg_despacho.Row],
                        stg_despacho.Cols[_COL_CORRIDA].Strings[stg_despacho.Row],
                        formatdateTime('YYYY-MM-DD', StrToDate(stg_despacho.Cols[_COL_FECHA].Strings[stg_despacho.Row]))
                        ]),lq_qry,_LOCAL) then begin
           if VarIsNull(lq_qry['ID_GUIA']) then begin
               Mensaje('No se ha generado una guia de viaje, ingrese los datos y reimprima',2);
//generamos la guia nuevamente
               li_guia := 0;
               li_NO_BUS := 0;
               li_TIPOSERVICIO := 0;
               ls_operador := '';
               stg_datosGuia.Cells[1,0] := '';
               stg_datosGuia.Cells[1,1] := '';
           end else begin
               li_GUIA := lq_qry['ID_GUIA'];
               li_NO_BUS := lq_qry['NO_BUS'];
               li_TIPOSERVICIO := lq_qry['TIPOSERVICIO'];
               ls_OPERADOR := lq_qry['ID_OPERADOR'];
               stg_datosGuia.Cells[1,0] := lq_qry['NO_BUS'];
               stg_datosGuia.Cells[1,1] := lq_qry['ID_OPERADOR'];
           end;
       end;
       GroupBox2.Visible := True;

    end else
       GroupBox2.Visible := False


end;

end.
