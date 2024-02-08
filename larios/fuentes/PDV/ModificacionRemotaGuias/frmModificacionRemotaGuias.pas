unit frmModificacionRemotaGuias;
{
Autor: Gilberto Almanza Maldonado
Fecha: Martes, 24 de Mayo de 2016. 16:00 hrs
Descripcion: Forma que permite realizar las siguientes funciones:
      * Modificar las guias de forma remota.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, lsCombobox, ExtCtrls, ComCtrls, Data.SqlExpr;

type
  TModificacionRemotaGuias = class(TForm)
    lbl1: TLabel;
    lscbServidores: TlsComboBox;
    lblConectado: TLabel;
    lbl3: TLabel;
    edtGuia: TEdit;
    lbl5: TLabel;
    dtpFechaGuia: TDateTimePicker;
    lbl6: TLabel;
    edtBoletera: TEdit;
    lbl7: TLabel;
    btn2: TButton;
    lbl2: TLabel;
    edtAutobus: TEdit;
    btnActualizar: TButton;
    btnLimpiar: TButton;
    lscbOperador: TlsComboBox;
    btn1: TButton;
    lbl4: TLabel;
    lblCorrida: TLabel;
    lbl8: TLabel;
    lblEmitio: TLabel;
    lbl9: TLabel;
    lblHora: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn2Click(Sender: TObject);
    procedure btnActualizarClick(Sender: TObject);
    procedure btnLimpiarClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    function ConectarCorporativo(): Boolean;
    function RevisaDatos(): Boolean;
    procedure LimpiarDatos;
    var
    Query , QueryRemoto: TSQLQuery;
    ConectaRemoto: TSQLConnection;
    const
    _CONECTADO = 'Conectado al servidor Corporativo.';
    _INTENTANDO_CONECTAR = 'Intentando conectar al Servidor Corporativo';
    _CORPORATIVO  = '1730';
  public
    { Public declarations }
  end;

var
  ModificacionRemotaGuias: TModificacionRemotaGuias;
  sql: String;
implementation

uses comunii, comun, DMdb, u_guias, modificarCorrida, uModificacionRemotaGuias;

{$R *.dfm}

procedure TModificacionRemotaGuias.btn1Click(Sender: TObject);
begin
   Close;
end;

procedure TModificacionRemotaGuias.btn2Click(Sender: TObject);
begin
   if(not RevisaDatos()) then
      exit;

   sql:= 'SELECT * FROM PDV_T_GUIA WHERE FECHA = '+ QuotedStr(FormatDateTime('yyyy-mm-dd',dtpFechaGuia.Date))+' AND ' +
         ' ID_TERMINAL = ' + QuotedStr(lscbServidores.CurrentID) + ' AND ID_GUIA = ' + QuotedStr(edtGuia.Text) + ';' ;
   if(EjecutaSQL(sql,QueryRemoto,_LOCAL))then
   begin
     if(QueryRemoto.IsEmpty)then
     begin
       ShowMEssage('No existe la información, cerciorese de que el servidor remoto'+ char(#13)  +
                   'y la guía digitada sean correctos.');
       LimpiarDatos;
       exit;
     end;
     lscbOperador.ItemIndex:= -1;
     lscbOperador.SetID(QueryRemoto.FieldByName('ID_OPERADOR').Text);
     edtBoletera.Text:= QueryRemoto.FieldByName('BOLETERA_FOLIO').AsString;
     edtAutobus.Text := QueryRemoto.FieldByName('NO_BUS').AsString;
     lblCorrida.Caption := QueryRemoto.FieldByName('ID_CORRIDA').AsString;
     lblEmitio.Caption  := QueryRemoto.FieldByName('TRAB_ID').AsString;
     sql:='SELECT (CAST(HORA AS TIME))AS SALIDA FROM PDV_T_CORRIDA_D '+
          ' WHERE ID_CORRIDA= '+ QuotedStr(lblCorrida.Caption) +
          ' AND ID_TERMINAL = '+  QuotedStr(lscbServidores.CurrentID)  +
          ' AND FECHA = '+ QuotedStr(FormatDateTime('yyyy-mm-dd',dtpFechaGuia.Date))+';';
     EjecutaSQL(sql,QueryRemoto,_LOCAL);
     lblHora.Caption    := VarToStr(FormatDateTime('HH:nn', QueryRemoto.FieldByName('SALIDA').AsDateTime));
     lscbServidores.Enabled:= false;
     edtGuia.Enabled:= false;
     dtpFechaGuia.Enabled := false;
   end
   ELSE
   begin
     ShowMEssage('No pudo ejecutarse la instrucción, asegurese de que exista conexión '+ char(#13)  +
                 'al servidor Corporativo y la guía digitada sea correcta.');
     LimpiarDatos;
     Exit;
   end;
end;

procedure TModificacionRemotaGuias.btnActualizarClick(Sender: TObject);
var sqlAux, sqlU, sqlI: String;
    vGuia: _Guia;
   miConexionTemporal: TSQLConnection;
begin
   if not AccesoPermitido(209, _NO_RECUERDA_TAGS) then
        Exit;
   miConexionTemporal:= TSQLConnection.Create(Self);
   miConexionTemporal:= dm.Conecta; // asigno la conexión de la terminal donde abrí el Mercurio
   DM.Conecta := ConectaRemoto; // asigno la conexión de Corporativo
   if(not RevisaDatos()) then
      exit;
   if(MessageDlg('¿Deseas actualizar los datos de la guia?', mtConfirmation,mbYesNo,0) = mrNo ) then
      exit;
      // llenar los datos del registro de la Guia
   vGuia.idGuia     := strToInt(Trim(edtGuia.Text));
   vGuia.Bus        := strToInt(Trim(edtAutobus.Text));
   vGuia.idCorrida  := lblCorrida.Caption;
   vGuia.idOperador := lscbOperador.CurrentID;
   vGuia.idTerminal := lscbServidores.CurrentID;
   vGuia.boletera   := StrToInt(Trim(edtBoletera.Text));
   vGuia.Fecha      := dtpFechaGuia.Date;
   uModificacionRemotaGuias.actualizaCorrida(vGuia,ConectaRemoto, QueryRemoto);

   // Realizar un Update a la tabla de PDV_T_GUIA para actualizar los siguientes datos:
   // Folio de Boletera, Número de Operador y/o Número de Autobus.
   sqlU:='UPDATE PDV_T_GUIA SET NO_BUS = '+ Trim(edtAutobus.Text)  + ' , ' +
        'ID_OPERADOR= ' + QuotedStr(lscbOperador.CurrentID) + ' , ' +
        'BOLETERA_FOLIO = ' + QuotedStr(edtBoletera.Text) +
        ' WHERE ID_TERMINAL = '+ QuotedStr(lscbServidores.CurrentID) + ' AND ID_GUIA = ' + Trim(edtGuia.Text) +
        ' AND FECHA= '+QuotedStr(FormatDateTime('yyyy-mm-dd',dtpFechaGuia.Date)) + ';';
   // ejecutar en CORPORTIVO y TERMINAL REMOTA
   if(EjecutaSQL(sqlU,QueryRemoto, _LOCAL))then
   begin
      comunii.replicaAterminal(ConectaRemoto,lscbServidores.CurrentID,sqlU);
      // Realizar un Insert en la tabla PDV_T_GUIA_H, que almacen el historial
      // de las actualizaciones de las guias. Se ocupan los siguientes datos
      // Id_guia, Id_Terminal, Folio, Operador, Bus, FechaHora, Terminal y Empleado que cambiaron datos

      sqlI:='INSERT INTO PDV_T_GUIA_H(ID_TERMINAL, ID_GUIA, BOLETERA_FOLIO, ID_OPERADOR, NO_BUS, FECHA_HORA, ID_TERMINAL_CAMBIO, TRAB_ID_CAMBIO  )'+
            ' VALUES('+ QuotedStr(lscbServidores.CurrentID)+ ','+
            Trim(edtGuia.Text) + ' , '+
            QuotedStr(edtBoletera.Text)  + ' , ' +
            QuotedStr(lscbOperador.CurrentID) + ' , ' +
            Trim(edtAutobus.Text)  + ' , ' +
            ' now() , +' +
            QuotedStr(gs_terminal) + ' , ' +
            QuotedStr(gs_trabid) +');';
       EjecutaSQL(sqlI,QueryRemoto, _LOCAL);
       comunii.replicaAterminal(ConectaRemoto,lscbServidores.CurrentID,sqlI);

       u_guias.generaGuiaViaje(
       Trim(edtGuia.Text),
       Trim(lblCorrida.Caption),
       VarToStr(FormatDateTime('YYYY-MM-DD',dtpFechaGuia.Date)),
       lblHora.Caption,
       1, // REIMPRESION
       lscbServidores.CurrentID,
       gs_trabid);
//       DM.desconectaServer;
//       DM.conectandoServer;
       DM.Conecta:= miConexionTemporal;
//       miConexionTemporal.Free;

       ShowMessage('La actualización de la guía se realizó correctamente, se agenda la replicación.');
   end;
end;

procedure TModificacionRemotaGuias.btnLimpiarClick(Sender: TObject);
begin
   LimpiarDatos;
end;

function TModificacionRemotaGuias.ConectarCorporativo: Boolean;
begin
  sql:='SELECT * FROM PDV_C_TERMINAL WHERE ID_TERMINAL = '+ QuotedStr(_CORPORATIVO);
  if(EjecutaSQL(sql,dm.Query,_LOCAL)) then
  begin
    lblConectado.Caption:= _INTENTANDO_CONECTAR;
    lblConectado.Font.Color:= clRed;
    lblConectado.Visible:= True;
  end
  Else
  begin
     lblConectado.Caption:= '';
     lblConectado.Font.Color:= clRed;
     lblConectado.Visible:= True;
     exit;
  end;
  try
{        ConectaRemoto.Params.Values['HOSTNAME']  := dm.Query.FieldByName('IPV4').AsString;;
        ConectaRemoto.Params.Values['DATABASE']  := dm.Query.FieldByName('BD_BASEDATOS').AsString;;
        ConectaRemoto.Params.Values['USER_NAME'] := dm.Query.FieldByName('BD_USUARIO').AsString;
        ConectaRemoto.Params.Values['PASSWORD']  := dm.Query.FieldByName('BD_PASSWORD').AsString;
        ConectaRemoto.VendorLib:= 'libmysql.dll';
        ConectaRemoto.LibraryName:= 'dbxmys.dll';
        ConectaRemoto.GetDriverFunc := 'getSQLDriverMYSQL';
        ConectaRemoto.ConnectionName := 'MySQLConnection';
        ConectaRemoto.DriverName:= 'MySQL';
        ConectaRemoto.KeepConnection:= True;
        ConectaRemoto.LoginPrompt:= False;
        ConectaRemoto.LoadParamsOnConnect:= false;
        ConectaRemoto.Connected := true;
        QueryRemoto.SQLConnection := ConectaRemoto;}
        lblConectado.Caption:= _CONECTADO   ;
        lblConectado.Font.Color:= clRed;
        lblConectado.Visible:= True;
  except
        on E : Exception do begin
          Mensaje('No existe conexion al servidor, Reportelo al area del sistemas',0);
          ErrorLog(E.Message,'No se puede conectar a el server.');//escribimos al archivo
          lblConectado.Caption:= '';
          lblConectado.Visible:= False;
        end;
  end;
end;

procedure TModificacionRemotaGuias.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   ConectaRemoto.Connected:= False;
end;

procedure TModificacionRemotaGuias.FormCreate(Sender: TObject);
begin
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   //*****************//
   ConectaRemoto:= TSQLConnection.Create(Self);
   QueryRemoto := TSQLQuery.Create(Self);
   QueryRemoto.SQLConnection:= Self.ConectaRemoto;
   cargaOperadores(lscbOperador);
   inicializaImpresionVars();
end;

procedure TModificacionRemotaGuias.FormShow(Sender: TObject);
var Empresa: String;
begin
   sql:= 'SELECT TOR.DESCRIPCION , TOR.ID_TERMINAL  '+
         ' FROM PDV_C_TERMINAL AS T JOIN T_C_TERMINAL AS TOR ON TOR.ID_TERMINAL= T.ID_TERMINAL '+
         ' WHERE T.ESTATUS = '+QuotedStr('A')+' AND TOR.EMPRESA = '+QuotedStr(comunii.EmpresaTerminal(gs_terminal))+
         ' UNION '+
         ' SELECT DESCRIPCION , ID_TERMINAL '+
         ' FROM  T_C_TERMINAL '+
         ' WHERE ID_TERMINAL = '+QuotedStr(gs_terminal)+
         ' ORDER BY 1 ASC;';
   if(EjecutaSQL(sql, Query, _LOCAL)) then
   begin
       while(not Query.Eof)do
       begin
         lscbServidores.Add(Query.FieldByName('ID_TERMINAL').AsString+'-'+Query.FieldByName('DESCRIPCION').AsString,
                            Query.FieldByName('ID_TERMINAL').AsString);
         Query.Next;
       end;
   end;
   ConectarCorporativo;
   dtpFechaGuia.Date:= Now() - 1;
end;

procedure TModificacionRemotaGuias.LimpiarDatos;
begin
   lscbServidores.Enabled:= true;
   edtGuia.Enabled:= true;
   dtpFechaGuia.Enabled := true;
   edtGuia.Text    := '';
   lscbOperador.ItemIndex:= -1;
   edtBoletera.Text:= '';
   edtAutobus.Text := '';
   dtpFechaGuia.Date:= now()-1;
   lscbServidores.ItemIndex := -1;
   lblCorrida.Caption := '0';
   lblEmitio.Caption  := '000000';
   lblHora.Caption    := '00:00:00';
end;

function TModificacionRemotaGuias.RevisaDatos: Boolean;
begin
   if(lscbServidores.ItemIndex = -1)then
   begin
     ShowMEssage('Debes elegir un servidor de la lista antes de continuar.');
     result:= false;
     Exit;
   end;
   if(Trim(edtGuia.Text)='')then
   begin
     ShowMEssage('Debes digitar un número de guía antes de continuar.');
     result:= false;
     Exit;
   end;
   result:= true;
end;

end.
