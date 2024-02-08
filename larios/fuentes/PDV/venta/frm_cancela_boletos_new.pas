unit frm_cancela_boletos_new;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, PlatformDefaultStyleActnCtrls, ActnMan, ToolWin, ActnCtrls,
  ActnMenus, StdCtrls, lsNumericEdit, lsCombobox, Mask,  ComCtrls,
  u_cobro_banamex, frm_pinpad_banamex_cancelar, System.Actions, Data.SqlExpr;

type
  Tfrm_cancelacion_boletos = class(TForm)
    ActionMainMenuBar1: TActionMainMenuBar;
    ActionManager1: TActionManager;
    Action1: TAction;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ls_Origen_vta: TlsComboBox;
    edtFolio: TlsNumericEdit;
    ls_Origen_: TlsComboBox;
    StatusBar1: TStatusBar;
    Button1: TButton;
    edt_trabid: TEdit;
    procedure Action1Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    FUserAsignado : String;
    FTaquillaAsignada : integer;
    procedure loadParametros();
    procedure datosCarga();
    function statusCorrida(BoletoId : integer; StrEmpleado : String; terminal : String) : string;

    function validaHoraCancelacion(BoletoId : integer; StrEmpleado : String) : integer;
    function validaHoraCancelaTerminalOtra(corrida_dia : string; fecha_dia : string; REMOTO : TSQLConnection) : integer;
    function validaEntrada() : boolean;
    function validaDatos: Boolean;
  public
    { Public declarations }
    property UserAsignado : string write FUserAsignado ;
    property taquilla : integer write FTaquillaAsignada ;
  end;

var
  frm_cancelacion_boletos: Tfrm_cancelacion_boletos;

implementation

uses DMdb, U_venta, comun, TLiberaAsientosRuta, u_comun_venta,
  frm_registro_folios;

{$R *.dfm}
var
    lq_query : TSQLQuery;
    la_parametros   : array[1..5]of integer;
    gs_descripcion_lugar: String;
    gi_remoto_cancelacion : integer;

procedure Tfrm_cancelacion_boletos.Action1Execute(Sender: TObject);
begin
    Close();
end;


procedure Tfrm_cancelacion_boletos.Button1Click(Sender: TObject);
var
    STORE : TSQLStoredProc;
    ls_promotor, ls_autoriza, ls_qry, ls_qry_server, ls_conv, sentencia : String;
    hilo_libera : Libera_Asientos;
    lq_qry, lq_remoto, lq_borrar : TSQLQuery;
    ls_origen_terminal, ls_origen, id_pago, ls_fecha, ls_corrida, ssql, ls_cve_boleto : String;
    CONEXION_REMOTO : TSQLConnection;
    qLocal : TSQLQuery;
    monto : Double;
    li_asiento, li_folioBoleto : integer;
begin////////////////////
    if not validaEntrada then exit;
    if not AccesoPermitido(168,False) then Exit;
    if FUserAsignado <> gs_trabid then begin //si el usuario es diferente al de la venta
        Mensaje('Error en la asignacion no esta asignado a la venta',1);
        gs_trabid := ls_promotor_asignado;
        exit;
    end;
    ls_promotor:= gs_trabid;
    if not AccesoPermitido(169,False) then exit;
    ls_autoriza := gs_trabid;
    STORE := TSQLStoredProc.Create(nil);


    if gs_terminal = ls_Origen_vta.CurrentID then begin
          lq_qry := TSQLQuery.Create(nil);
          lq_qry.SQLConnection := DM.Conecta;
          try
            if not sePuedeCancelar(edt_trabid.Text, gs_terminal,  Trunc(edtFolio.Value), CONEXION_VTA) then Begin
              Mensaje('El boleto ya est� cancelado o no existe.', 2);
              exit;
            end;//verificamos el tiempo maximo para ejecutar la cancelacion del boleto
            if statusCorrida(StrToInt(edtFolio.Text), edt_trabid.Text, ls_Origen_vta.CurrentID) <> 'A' then begin
                mensaje('La corrida debe de estar abierta para cancelar el boleto',2 );
                exit;
            end;

            if validaHoraCancelacion(StrToInt(edtFolio.Text), edt_trabid.Text) = 1 then begin
                mensaje('Tiempo permitido para cancelar el boleto es de '+#10#13+
                        IntToStr(la_parametros[5]) + ' minutos, antes de la hora de salida',2 );

                exit;
            end;
          except
          end;
          ls_qry := 'SELECT B.ID_TERMINAL, B.ORIGEN, B.NO_ASIENTO, B.DESTINO, B.ID_CORRIDA, '+
                    'YEAR(B.FECHA_HORA_BOLETO)AS ANIO, ID_BOLETO,  TRAB_ID, TC '+
                    'FROM PDV_T_BOLETO B '+
                    'WHERE ID_BOLETO = %s AND B.TRAB_ID = ''%s'' AND B.ID_TERMINAL = ''%s'' ';
          if EjecutaSQL(Format(ls_qry,[edtFolio.Text,edt_trabid.Text,ls_Origen_vta.CurrentID]),lq_qry,_LOCAL) then begin
              ls_qry_server := 'UPDATE PDV_T_BOLETO_'+ IntToStr(lq_qry['ANIO']) +' B SET B.ESTATUS = ''C'' '+
                               'WHERE ID_TERMINAL = ''%s'' AND B.TRAB_ID = ''%s'' AND ID_BOLETO = %s';
              ls_qry_server := Format(ls_qry_server,[lq_qry['ID_TERMINAL'], lq_qry['TRAB_ID'], lq_qry['ID_BOLETO']]);

              if EjecutaSQL(ls_qry_server, lq_qry, _SERVIDOR_CENTRAL) then//mandamos al servidor centrar para cancelar anualizada
                      ;
              //si el boleto que se cancela esta registrado local y si es remoto registramos en pdv_t_query
              if lq_qry['ID_TERMINAL'] <> lq_qry['ORIGEN'] then begin

                 ls_qry := 'UPDATE PDV_T_BOLETO B SET B.ESTATUS = ''C'' WHERE TC = ''%s'' AND  NO_ASIENTO = %s ';
                 ls_qry := Format(ls_qry,[lq_qry['TC'], IntToStr(lq_qry['NO_ASIENTO']) ]);

                 ls_qry := Format(_SERVER_QUERY_LOCAL ,[lq_qry['ORIGEN'], ls_qry ]);
                 if EjecutaSQL(ls_qry, lq_qry, _LOCAL) then//mandamos a la terminal para cancelar
                      ;
                 if EjecutaSQL(ls_qry, lq_qry, _SERVIDOR_CENTRAL) then//mandamos a la terminal para cancelar
                      ;
              end;//fin origen y terminal
          end;//fin ejecutaSQL
          lq_qry.Free;
          // Salez, Cancelaci�n local
          id_pago := idPagoPinPadBanamex(edt_trabid.Text, Trunc(edtFolio.Value), CONEXION_VTA);

          if id_pago <> '' then Begin // ver si fue pagada con pinpadBanamex
            if boletosRelacionadosPinPadBanamex(id_pago, CONEXION_VTA) = 1 then Begin  // Cancelaci�n de un s�lo boletos
              //* obtengo la tarifa del boleto a cancelar
              monto := precioDe(edt_trabid.Text, gs_terminal, Trunc(edtFolio.Value), CONEXION_VTA);
              if not cancelarConBanamex(id_pago, gs_trabid, monto, 1, CONEXION_VTA) then
                exit;
            End else Begin //cancelacion multiple
              pinpad_banamex_cancelar.inicializar(id_pago, CONEXION_VTA , ls_promotor, ls_autoriza);
              pinpad_banamex_cancelar.ShowModal;
              exit; //Porque la cancelaci�n se hace en el modulo nuevo
            End;
          End; // Si fue pagada con pinpadBanamex
        //* Salez Termina
          // Si se modifica este parte del sistema se debe de modificar tambi�n
          // pinpad_banamex_cancelar.realizarCancelacion
          STORE.SQLConnection := DM.Conecta;
          STORE.close;
          STORE.StoredProcName := 'PDV_STORE_CANCELA_BOLETO';
          STORE.Params.ParamByName('IN_FOLIO').AsInteger := StrToInt(edtFolio.Text);
          STORE.Params.ParamByName('IN_TRABID').AsString := edt_trabid.Text;
          STORE.Params.ParamByName('IN_TERMINAL').AsString := ls_Origen_vta.CurrentID;
          STORE.Params.ParamByName('IN_TAQUILLA').AsInteger := gi_taquilla_store;
          STORE.Params.ParamByName('IN_TRABVTA').AsString  := ls_promotor;
          STORE.Params.ParamByName('IN_AUTORIZA').AsString := ls_autoriza;
          STORE.Open;
          if STORE['OUT_BOLETO'] = 0 then begin
              mensaje('No existe el registro del boleto verifiquelo o ha sido cancelado',1);
              edt_trabid.Clear;
              edtfolio.Text := '0';
              exit;
          end else begin//se encontro el dato
                    lq_qry := TSQLQuery.Create(nil);
                    lq_qry.SQLConnection := DM.Conecta;
                    ls_qry := 'SELECT MENSAJE_CANCELACION FROM PDV_C_FORMA_PAGO WHERE ID_FORMA_PAGO = '+
                                intToStr(STORE['OUT_FORMA'])+' AND CANCELABLE = ''T''  ';
                    ls_conv := FloatToStr(STORE['OUT_TARIFA']);
                    if EjecutaSQL(ls_qry,lq_qry,_LOCAL) then begin
                         mensaje(lq_qry['MENSAJE_CANCELACION']+#10#13+ 'por el BOLETO : ' +
                                        edtFolio.Text +
                             ' la cantidad de : $' + ls_conv,2 );
                     end else begin
                         mensaje('El Boleto ha sido cancelado',2);
                     end;
                     //FOLIOS CANCELACION
                     insertaEvento(gs_trabId,gs_terminal,'Cancela boleto : '+ edtFolio.Text + ' promotor :' +
                                   ls_promotor+ ' autoriza :'+ls_autoriza);
                     sentencia := 'DELETE FROM PDV_T_ASIENTO WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s''  '+
                                 'AND NO_ASIENTO = %s' ;
                     sentencia := format(sentencia,[STORE['OUT_CORRIDA'], formatDateTime('YYYY-MM-DD', STORE['OUT_FECHA']),
                                  STORE['OUT_ASIENTO'] ]);
                     hilo_libera := Libera_Asientos.Create(true);
                     hilo_libera.server := DM.Conecta;
                     hilo_libera.sentenciaSQL := sentencia;
                     hilo_libera.ruta   := STORE['OUT_RUTA'];
                     hilo_libera.origen := ls_Origen_vta.CurrentID;
                     hilo_libera.destino := STORE['OUT_DESTINO'];
                     hilo_libera.Priority := tpHighest;
                     hilo_libera.FreeOnTerminate := True;
                     hilo_libera.start;
                     sentencia := 'UPDATE PDV_T_BOLETO SET ESTATUS = ''C''  WHERE ID_BOLETO = '+edtFolio.Text+
                                  ' AND TRAB_ID = "'+ edt_trabid.Text  +'" AND ID_TERMINAL = "'+ gs_terminal+'"';
                     if EjecutaSQL(sentencia, lq_qry, _SERVIDOR_CENTRAL) then
                          ;
                     edt_trabid.Clear;
                     edtfolio.Text := '0';
                     edt_trabid.SetFocus;
                     lq_qry.Free;
          end;//fin
    end else begin//NO SE CANCELA DE FORMA REMOTA SOLO EL BOLETO QUE SE VEND�O FORANEO EN LA SERVIDOR LOCAL

        ls_origen_terminal := ls_Origen_vta.CurrentId;
        if ls_Origen_vta.CurrentId <> gs_terminal then begin
//tenemos el origen de venta de otra terminal esto es local
            CONEXION_REMOTO := conexionServidorRemoto(ls_origen_terminal);
            if CONEXION_REMOTO.Connected then begin//conectado al punto remoto
//traemos la fecha y corrida del boleto que se ha vendido
                lq_qry := TSQLQuery.Create(nil);
                lq_qry.SQLConnection := DM.Conecta;
                sentencia := 'SELECT FECHA, ID_CORRIDA, NO_ASIENTO FROM PDV_T_BOLETO WHERE ID_BOLETO = %s AND ID_TERMINAL = ''%s'' AND TRAB_ID =  ''%s'' ';
                if EjecutaSQL(Format(sentencia,[edtFolio.Text, gs_terminal, edt_trabid.Text ]),lq_qry, _LOCAL) then begin
                    ls_fecha :=  FormatDateTime('YYYY-MM-DD', lq_qry['FECHA']);
                    ls_corrida := lq_qry['ID_CORRIDA'];
                    li_asiento := lq_qry['NO_ASIENTO'];
                    ls_qry := 'SELECT  D.FECHA, D.HORA, NOW() AS AHORA, DATE_ADD(TIMESTAMP(D.FECHA, HORA) , '+
                              ' INTERVAL (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 23) MINUTE ) AS ARMADO, '+
                              'IF( (SELECT NOW()) < (DATE_ADD(TIMESTAMP(D.FECHA, HORA) ,INTERVAL '+
                              '(SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 23) MINUTE )) , 0,1)AS PERMITIDO, D.ESTATUS '+
                              'FROM PDV_T_CORRIDA_D D '+
                              'WHERE D.ID_CORRIDA = ''%s'' AND D.FECHA = ''%s'' ';
                    lq_remoto := TSQLQuery.Create(nil);
                    lq_remoto.SQLConnection := CONEXION_REMOTO;
                    if EjecutaSQL(Format(ls_qry,[ls_corrida, ls_fecha]),lq_remoto, _LOCAL) then begin
                        if lq_remoto['PERMITIDO'] = 1 then begin
                          mensaje('Tiempo estimado para cancelar el boleto es de '+#10#13+
                                  IntToStr(la_parametros[5]) + ' minutos, en la corrida',2 );
                          exit;
                        end;
                    end;
                    if not sePuedeCancelar(edt_trabid.Text, gs_terminal, StrToInt(edtFolio.Text), CONEXION_VTA) then begin
                        Mensaje('El boleto ya est� cancelado o no existe.', 2);
                        exit;
                    end;

                    if lq_remoto['ESTATUS'] <> 'A' then begin
                        Mensaje('El estatus de la corrida no permite cancelar el boleto.',1);
                        exit;
                    end;

                    // Salez, Cancelaci�n local
                    id_pago := idPagoPinPadBanamex(edt_trabid.Text, Trunc(edtFolio.Value), CONEXION_VTA);
                    if id_pago <> '' then Begin // ver si fue pagada con pinpadBanamex
                      if boletosRelacionadosPinPadBanamex(id_pago, CONEXION_VTA) = 1 then Begin  // Cancelaci�n de un s�lo boletos
                        //* obtengo la tarifa del boleto a cancelar
                        monto := precioDe(edt_trabid.Text, ls_Origen_vta.CurrentID, Trunc(edtFolio.Value), CONEXION_VTA);
                        if not cancelarConBanamex(id_pago, gs_trabid, monto, 1, CONEXION_VTA) then
                          exit;
                      End else Begin //cancelacion multiple
                        pinpad_banamex_cancelar.inicializar(id_pago, CONEXION_VTA , ls_promotor, ls_autoriza);
                        pinpad_banamex_cancelar.ShowModal;
                        exit; //Porque la cancelaci�n se hace en el modulo nuevo
                      End;
                    End; // Si fue pagada con pinpadBanamex
//borramos remotamente el dato
                    li_folioBoleto := StrToInt(edtFolio.Text);
                    ls_cve_boleto  := edt_trabid.Text;
                    lq_borrar := TSQLQuery.create(nil);
                    lq_borrar.SQLConnection := CONEXION_REMOTO;
                    try
                        lq_borrar.SQL.Clear;
                        lq_borrar.SQL.Add('SELECT YEAR(FECHA_HORA_BOLETO)AS ANIO ');
                        lq_borrar.SQL.Add('FROM PDV_T_BOLETO ');
                        lq_borrar.SQL.Add('WHERE ID_BOLETO = :li_folioBoleto AND TRAB_ID = :ls_cve_boleto AND ID_TERMINAL = :gs_terminal');
                        lq_borrar.Params[0].AsInteger := li_folioBoleto;
                        lq_borrar.Params[1].AsString  := ls_cve_boleto;
                        lq_borrar.Params[2].AsString  := gs_terminal;
                        lq_borrar.ExecSQL();

                        ls_qry_server := 'UPDATE PDV_T_BOLETO_'+ IntToStr(lq_borrar['ANIO']) +' B SET B.ESTATUS = ''C'' '+
                                         'WHERE ID_TERMINAL = ''%s'' AND B.TRAB_ID = ''%s'' AND ID_BOLETO = %s';
                        ls_qry_server := Format(ls_qry_server,[gs_terminal, ls_cve_boleto, li_folioBoleto]);

                        if EjecutaSQL(ls_qry_server, lq_qry, _SERVIDOR_CENTRAL) then//mandamos al servidor centrar para cancelar anualizada
                            ;
                    except
                    end;
                    lq_borrar.SQL.Clear;
                    lq_borrar.SQL.Add('UPDATE PDV_T_BOLETO SET ESTATUS = ''C'' ');
                    lq_borrar.SQL.Add('WHERE ID_BOLETO = :li_folioBoleto AND TRAB_ID = :ls_cve_boleto AND ID_TERMINAL = :gs_terminal');
                    lq_borrar.Params[0].AsInteger := li_folioBoleto;
                    lq_borrar.Params[1].AsString  := ls_cve_boleto;
                    lq_borrar.Params[2].AsString  := gs_terminal;
                    lq_borrar.ExecSQL();

                    lq_borrar.SQLConnection := CONEXION_REMOTO;
                    lq_borrar.SQL.Clear;
                    lq_borrar.SQL.Add('DELETE A');
                    lq_borrar.SQL.Add('FROM PDV_T_BOLETO B INNER JOIN PDV_T_ASIENTO A ON B.ID_CORRIDA = A.ID_CORRIDA AND B.FECHA = CAST(A.FECHA_HORA_CORRIDA AS DATE)');
                    lq_borrar.SQL.Add('WHERE B.TRAB_ID = :ls_cve_boleto AND B.ID_BOLETO = :li_folioBoleto AND B.ID_TERMINAL = :gs_terminal AND B.ESTATUS = ''C'' ');
                    lq_borrar.Params[0].AsString := ls_cve_boleto;
                    lq_borrar.Params[1].AsInteger := li_folioBoleto;
                    lq_borrar.Params[2].AsString  := gs_terminal;
                    lq_borrar.ExecSQL();
                    lq_borrar.Free;
                    lq_borrar := nil;

                    STORE.SQLConnection := DM.Conecta;
                    STORE.close;
                    STORE.StoredProcName := 'PDV_STORE_CANCELA_BOLETO';
                    STORE.Params.ParamByName('IN_FOLIO').AsInteger := StrToInt(edtFolio.Text);
                    STORE.Params.ParamByName('IN_TRABID').AsString := edt_trabid.Text;
                    STORE.Params.ParamByName('IN_TERMINAL').AsString := gs_terminal;
                    STORE.Params.ParamByName('IN_TAQUILLA').AsInteger := gi_taquilla_store;
                    STORE.Params.ParamByName('IN_TRABVTA').AsString  := ls_promotor;
                    STORE.Params.ParamByName('IN_AUTORIZA').AsString := ls_autoriza;
                    STORE.Open;
                    if STORE['OUT_BOLETO'] <> 0 then begin
                        ls_qry := 'SELECT MENSAJE_CANCELACION FROM PDV_C_FORMA_PAGO WHERE ID_FORMA_PAGO = '+
                                  intToStr(STORE['OUT_FORMA'])+' AND CANCELABLE = ''T''  ';
                        ls_conv := FloatToStr(STORE['OUT_TARIFA']);
                        if EjecutaSQL(ls_qry,lq_qry,_LOCAL) then begin
                           mensaje(lq_qry['MENSAJE_CANCELACION']+#10#13+ 'por el BOLETO con folio : ' +
                                          edtFolio.Text +' regresa la cantidad de : $' + ls_conv,2 );
                        end else begin
                           mensaje('El Boleto ha sido cancelado',2);
                        end;
                        insertaEvento(gs_trabId,gs_terminal,'Cancela boleto : '+ edtFolio.Text + ' promotor :' +
                                     ls_promotor+ ' autoriza :'+ls_autoriza);
                        sentencia := 'DELETE FROM PDV_T_ASIENTO WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s''  '+
                                   'AND NO_ASIENTO = %s' ;
                        sentencia := format(sentencia,[STORE['OUT_CORRIDA'], formatDateTime('YYYY-MM-DD', STORE['OUT_FECHA']),
                                    STORE['OUT_ASIENTO'] ]);
                        hilo_libera := Libera_Asientos.Create(true);
                        hilo_libera.server := DM.Conecta;
                        hilo_libera.sentenciaSQL := sentencia;
                        hilo_libera.ruta   := STORE['OUT_RUTA'];
                        hilo_libera.origen := ls_Origen_vta.CurrentID;
                        hilo_libera.destino := STORE['OUT_DESTINO'];
                        hilo_libera.Priority := tpHighest;
                        hilo_libera.FreeOnTerminate := True;
                        hilo_libera.start;
                        sentencia := 'UPDATE PDV_T_BOLETO SET ESTATUS = ''C''  WHERE ID_BOLETO = '+edtFolio.Text+
                                     ' AND TRAB_ID = "'+ edt_trabid.Text  +'" AND ID_TERMINAL = "'+ ls_Origen_vta.CurrentID+'"';
                        if EjecutaSQL(sentencia, lq_qry, _SERVIDOR_CENTRAL) then
                          ;
                        sentencia := 'DELETE '+
                                     'FROM PDV_T_ASIENTO '+
                                     'WHERE ID_CORRIDA = ''%s'' AND CAST(FECHA_HORA_CORRIDA AS DATE) = ''%s'' AND NO_ASIENTO = %s' ;
                        if EjecutaSQL(Format(sentencia,[ls_corrida, ls_fecha, IntToStr(li_asiento)]),lq_qry, _TODOS) then
                            ;
                    end;
//borrar los asiento en todos los servidores
                    lq_remoto.Free;
                    lq_remoto := nil;
                    edt_trabid.Clear;
                    edtfolio.Text := '0';
                    edt_trabid.SetFocus;
                end;
                lq_qry.Free;
                lq_qry := nil;
            end;//fin conexion_remoto
        end;

    end;
end;








procedure Tfrm_cancelacion_boletos.datosCarga;
var
    lq_terminals : TSQLQuery;
begin
    lq_terminals := TSQLQuery.Create(nil);
    lq_terminals.SQLConnection := DM.Conecta;
    if EjecutaSQL(format(_VTA_TERMINALES_ORIGEN,[gs_terminal, gs_terminal, gs_terminal]), lq_terminals, _LOCAL) then begin
      LlenarComboBox(lq_terminals, ls_Origen_, True);
      LlenarComboBox(lq_terminals, ls_Origen_vta, True);
    end;
    if EjecutaSQL(_VTA_TERMINALES,lq_terminals,_LOCAL) then begin
      llenarTerminales(lq_terminals);
      ls_Origen_.Text := gds_terminales.ValueOf(gs_terminal);///la terminal actual
      ls_Origen_vta.ItemIndex := ls_Origen_vta.IDs.IndexOf(gs_terminal);
    end;
end;


procedure Tfrm_cancelacion_boletos.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    gs_trabid := FUserAsignado;//que viene de la venta
    CONEXION_VTA := CONEXION_ULTIMA;
end;


procedure Tfrm_cancelacion_boletos.FormShow(Sender: TObject);
begin
    CONEXION_VTA := DM.Conecta;
    loadParametros();
    datosCarga();
    if gi_operacion_remota = 1 then
//        ls_Origen_vta.Enabled := true
    else
        ls_Origen_vta.Enabled := False;
    gi_remoto_cancelacion := 0;
    edtFolio.clear;
end;


procedure Tfrm_cancelacion_boletos.loadParametros;
var
    li_ctrl : integer;
begin
    lq_query := TSQLQuery.Create(nil);
    try
      lq_query.SQLConnection := CONEXION_VTA;
      li_ctrl := 1;
      if EjecutaSQL(_VTA_T_PAGO_AL_100_TIEMPO,lq_query,_LOCAL) then begin
          la_parametros[li_ctrl] := lq_query['VALOR'];
          inc(li_ctrl);
      end;
      if EjecutaSQL(_VTA_T_MENOR_100_TIEMPO,lq_query,_LOCAL) then begin
          la_parametros[li_ctrl] := lq_query['VALOR'];
          inc(li_ctrl);
      end;
      if EjecutaSQL(_VTA_T_PAGO_AL_100_PORCENTAJE,lq_query,_LOCAL) then begin
          la_parametros[li_ctrl] := lq_query['VALOR'];
          inc(li_ctrl);
      end;
      if EjecutaSQL(_VTA_T_MENOR_100_PORCENTAJE,lq_query,_LOCAL) then begin
          la_parametros[li_ctrl] := lq_query['VALOR'];
          inc(li_ctrl);
      end;
      //ARREGLO 5 PARA EL TIEMPO DE CANCELACION
      if EjecutaSQL(_VTA_T_TIEMPO_A_CANCELAR,lq_query,_LOCAL) then begin
          la_parametros[li_ctrl] := lq_query['VALOR'];
          inc(li_ctrl);
      end;
    finally
      lq_query.Free;
      lq_query := nil;
    end;
end;


function Tfrm_cancelacion_boletos.statusCorrida(BoletoId : integer; StrEmpleado : String; terminal : String) : string;
var
    lq_qryStatus : TSQLQuery;
    ls_qrys : string;
    li_tiempo : integer;
    ga_datos :gga_parameters;
    lc_char : char;
begin
    lq_qryStatus := TSQLQuery.Create(nil);
    lq_qryStatus.SQLConnection := CONEXION_VTA;
    ls_qrys := 'SELECT D.ESTATUS '+
               'FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_BOLETO B ON D.ID_CORRIDA = B.ID_CORRIDA AND D.FECHA  = B.FECHA '+
               'WHERE B.ID_BOLETO = %s AND B.TRAB_ID = ''%s'' AND B.ID_TERMINAL = ''%s'' ';
    if EjecutaSQL(format(ls_qrys,[IntToStr(BoletoId),StrEmpleado, terminal]),lq_qryStatus,_LOCAL) then begin
        ls_qrys := lq_qryStatus['ESTATUS'];
    end;
    lq_qryStatus.Free;
    lq_qryStatus := nil;
    result := ls_qrys;
end;


function Tfrm_cancelacion_boletos.validaDatos: Boolean;
var
    lout : Boolean;
    fecha : TDate;
begin
    lout := True;

    if (Length(edt_trabid.Text) = 0) or (edt_trabid.Text = '') then begin
        Mensaje('Ingrese la clave del promotor',1);
        edt_trabid.SetFocus;
        lout := False;
        exit;
    end;

    if StrToInt(edtFolio.Text) = 0 then begin
        Mensaje('Ingrese el numero del asiento',1);
        edtFolio.SetFocus;
        lout := False;
        exit;
    end;

    Result := lout;
end;


function Tfrm_cancelacion_boletos.validaEntrada: boolean;
var
    out_bol : boolean;
begin
    out_bol := true;
    if length(edt_trabid.text) = 0 then begin
        mensaje('Ingrese la clave del promotor',1);
        out_bol := false;
        edt_trabid.SetFocus;
        exit;
    end;
    if length(edtFolio .text) = 0 then begin
        mensaje('Ingrese el folio del boleto',1);
        out_bol := false;
        edtFolio.SetFocus;
        exit;
    end;
    result := out_bol;
end;



function Tfrm_cancelacion_boletos.validaHoraCancelacion(BoletoId: integer; StrEmpleado: String): Integer;
var
    lq_qryHora : TSQLQuery;
    ls_qrys : string;
    li_tiempo, li_permitido : integer;
    ga_datos :gga_parameters;
    lc_char : char;
begin
    lq_qryHora := TSQLQuery.Create(nil);
    lq_qryHora.SQLConnection := CONEXION_VTA;
    ls_qrys := 'SELECT D.FECHA, HORA, NOW() AS AHORA, '+
               'DATE_ADD(TIMESTAMP(D.FECHA, HORA) , INTERVAL (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 23) '+
			         'MINUTE ) AS ARMADO, '+
               'IF( (SELECT NOW()) < (DATE_ADD(TIMESTAMP(D.FECHA, HORA) ,INTERVAL '+
               '(SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 23) MINUTE )) , 0,1)AS PERMITIDO '+
               'FROM PDV_T_CORRIDA_D D INNER JOIN PDV_T_BOLETO B ON D.ID_CORRIDA = B.ID_CORRIDA AND D.FECHA  = B.FECHA '+
               'WHERE B.ID_BOLETO = %s AND B.TRAB_ID = ''%s'' AND D.ESTATUS = ''A'' ';
    if EjecutaSQL(format(ls_qrys,[IntToStr(BoletoId),StrEmpleado]),lq_qryHora,_LOCAL) then begin
        if VarIsNull(lq_qryHora['PERMITIDO']) then
            li_permitido := 0
        else
            li_permitido := lq_qryHora['PERMITIDO'];
    end;

    lq_qryHora.Free;
    lq_qryHora := nil;
    result := li_permitido;
end;


function Tfrm_cancelacion_boletos.validaHoraCancelaTerminalOtra(corrida_dia,
                                  fecha_dia: string; REMOTO: TSQLConnection): integer;
var
    lq_qry : TSQLQuery;
    ls_qry : String;
    li_permitido : integer;
begin
    if NOT REMOTO.Connected then begin
      ShowMessage('Error no se establecio el enlace reintentelo nuevamente');
      exit;
    end;

    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := REMOTO;
    ls_qry := 'SELECT  D.FECHA, D.HORA, NOW() AS AHORA, DATE_ADD(TIMESTAMP(D.FECHA, HORA) , '+
              ' INTERVAL (SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 23) MINUTE ) AS ARMADO, '+
              'IF( (SELECT NOW()) < (DATE_ADD(TIMESTAMP(D.FECHA, HORA) ,INTERVAL '+
              '(SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = 23) MINUTE )) , 0,1)AS PERMITIDO '+
              'FROM PDV_T_CORRIDA_D D '+
              'WHERE D.ID_CORRIDA = ''%s'' AND D.FECHA = ''%s'' ';
    ls_qry := Format(ls_qry,[corrida_dia, fecha_dia]);
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add(ls_qry);
    lq_qry.open;
    if not lq_qry.IsEmpty then begin
        li_permitido := lq_qry['PERMITIDO'];
    end;
    lq_qry.Free;
    lq_qry := nil;
    Result := li_permitido;
end;

end.
