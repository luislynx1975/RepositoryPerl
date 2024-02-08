unit frmImportaTarifa;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, Aligrid, StdCtrls, ComCtrls, ExtDlgs, Data.SqlExpr;

type
  TimportaTarifas = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    dtpFecha: TDateTimePicker;
    dtpHora: TDateTimePicker;
    abrirArchivo: TOpenTextFileDialog;
    ProgressBar: TProgressBar;
    lblTotalRegs: TLabel;
    sagImportados: TStringGrid;
    lbl1: TLabel;
    edtImpuesto: TEdit;
    btn1: TButton;
    cbImpuesto: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    function RegresaIdTarifa(Tramo, Servicio: String): Integer;
    function RegresaIdTramo(Origen, Destino, KM, MINUTOS: String): Integer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtImpuestoKeyPress(Sender: TObject; var Key: Char);
    procedure btn1Click(Sender: TObject);
    procedure cbImpuestoClick(Sender: TObject);
  private
    { Private declarations }
    function grabaTarifa(idTarifa: Integer; FHAplica: TdAteTime;   Monto: Real; impuesto: real): Boolean;
    function existeIdTarifa(idTarifa_ : integer) : Boolean;
    function RevisaImpuestoGrid(grid: TStringGrid): Boolean;
  public
    { Public declarations }

  end;

var
  importaTarifas: TimportaTarifas;
  misTarifasInsertadas: TStringGrid;
implementation

uses comun, comunii, DMdb, uImportarTarifas;

{$R *.dfm}

procedure TimportaTarifas.edtImpuestoKeyPress(Sender: TObject; var Key: Char);
begin
    if not (Key in ['0'..'9', #8, #13,'.']) then
          Key := _BLANCO;
end;

function TimportaTarifas.existeIdTarifa(idTarifa_ : integer): Boolean;
  var i: Integer;
begin
   //reviso que el id de tarifa a insertar NO ESTE en el Grid
   // de estar ya no vuelvo a insertar la tarifa ...
   result:= false; // no existe
   for i := 0  to misTarifasInsertadas.RowCount - 1 do
   begin
     if misTarifasInsertadas.Cells[0, i+1] = intToStr(idTarifa_) then
     begin
       result:= true; // existe
       exit;
     end;

   end;

end;

procedure TimportaTarifas.btn1Click(Sender: TObject);
begin
   Close;
end;

procedure TimportaTarifas.Button1Click(Sender: TObject);
var
   NombreArchivo: String;
   Archivo : TextFile;

   /////////////////////
  csv : TStringList;
  fila : TStringList;
  i, j : Integer;
begin
   progressBar.Position:=0;
   try
    csv := TStringList.Create;
		// cargar a partir del fichero csv
    abrirArchivo.Execute();
    NombreArchivo:= abrirArchivo.FileName;
		csv.LoadFromFile(NombreArchivo);
		fila := TStringList.Create;
    ProgressBar.Max := csv.Count -1;
    sagImportados.RowCount:= csv.Count;
    // recorrer las filas
		for i:= 0 to csv.Count -1 do
		begin
      fila.Delimiter:= ',';
			ProgressBar.Position := i;
			fila.CommaText := csv.Strings[i];
			// recorrer las columnas
			for j := 0 to fila.Count -1 do
			begin
        sagImportados.Cells[j,i] := fila[j];
			end;
		end;
		MessageDlg('Lectura Exitosa..', mtInformation, [mbOK], 0);

   Except
	    on E : Exception do
	    begin
         CloseFile(Archivo);
	    		MessageDlg('Ocurrio un Error: ' + E.Message, mtInformation, [mbOK], 0);
	    end;
   end;
   // liberar la memoria
   csv.Free;
   lblTotalRegs.Caption:= IntToStr(sagImportados.RowCount-1);
   ShowMessage('La columna número 7 debe contener la tarifa a dar de alta.'+char(13)+
               'La columna número 8 debe contener el impuesto a las tarifas.');
end;

procedure TimportaTarifas.Button2Click(Sender: TObject);
var i, c,d : Integer;
    idTarifa, idTramo: Integer;
    impuesto_iva: Real;
begin
   if sagImportados.RowCount < 2 then
   // SI SÓLO EXISTE EL ENCABEZADO Y UN RENGLÓN EN BLANCO . . .
   begin
     Showmessage('Favor de cargar las tarifas antes de importar.');
     Exit;
   end;
   // revisar que la fecha del combo no sea menor que hoy
   // si es menor, votar la importacion . . .
   progressBar.Position:=0;
   if not cbImpuesto.Checked then
   begin
        if (Trim(edtImpuesto.Text) = '' ) then
       begin
            ShowMEssage('Capture un valor del impuesto antes de continuar.');
            Exit;
       end;
       // asigno un valor (de usuario) al impuesto a mis tarifas
       impuesto_iva:= StrToFloat(edtImpuesto.Text);

       if (impuesto_iva < 0) then
       begin
            ShowMEssage('Modifique el valor del impuesto antes de continuar.');
            Exit;
       end;
   end;
   sql:='select now() as Fecha;';
   if not EjecutaSQL(sql,dm.Query,_LOCAL) then
   begin
     ShowMessage('Error al consultar el horario del servidor.');
     Exit;
   end;
   dtpFecha.Time:= dtpHora.Time;
   if dm.Query.FieldByName('Fecha').AsDateTime > dtpFecha.DateTime  then
   begin
      ShowMessage('La fecha y hora de aplicacion de las tarifas. Deben ser mayor a la fecha actual del servidor. ');
      Exit;
   end;
   ProgressBar.Max := sagImportados.RowCount -1;
   c:=0;        d:=0;
   // revisar que esten dados de alta todos los tramos ...
   // si no lo estan la funcion los genera y replica ...
   if MessageDlg(format(_PREGUNTA_ALTA_TARIFAS,[FormatDateTime('dd/mm/yyyy', dtpFecha.Date), FormatDateTime('hh:nn:ss ', dtpHora.Time)]),mtWarning,mbOKCancel,0) = mrCancel then Exit;
   for I := 1 to sagImportados.RowCount - 1 do
   begin
     ProgressBar.Position := i;
     if StrToFloat(sagImportados.Cells[6,I])<= 0 then
         c:= c + 1
     else
     begin
            {Columna 0 Identificador de la ruta
             Columna 1 Origen del Dato
             Columna 2 Origen                  ***
             Columna 3 Destino                 ***
             Columna 4 Servicio                ***
             Columna 5 Kilometros              ***
             Columna 6 Tarifa Actual           ***
             Columna 7 Tarifa Anterior
             Columna 8 Impuesto a la tarifa    ***
            }
            // envio Origen, Destino para saber el identificador de tramo
            // y envio los kilometrajes por si no está y tengo que insertarlo
           idTramo:= RegresaIdTramo(sagImportados.Cells[2, I],sagImportados.Cells[3,I],sagImportados.Cells[5,I],'0');
           if idTramo <> -1 then   // una vez que el tramo sea distinto de -1 (quiero decir, que exista)
               // envío el Id Tramo y el Tipo de Servicio para conocer un Identificador de Tarifa
               // y si no existe, generarla y regresar el Id Tarifa.
               idTarifa:= RegresaIdTarifa(intToStr(idTramo), sagImportados.Cells[4,I]);
           if idTarifa <> -1 then
           begin
               if not existeIdTarifa(idTarifa) then
               begin
                  // envío el Identificador de Tarifas y la Tarifa Nueva (columna 6) para insertarla ...
                  if cbImpuesto.Checked then
                     impuesto_iva:= StrToFloat(sagImportados.Cells[8,I])     // tomo el valor del grid
                  else
                     impuesto_iva:= StrToFloat(edtImpuesto.Text);        // tomo el valor que capturó el usuario

                  grabaTarifa(idTarifa,dtpFecha.DateTime, StrToFloat(sagImportados.Cells[6,I]), impuesto_iva )    // columna 6  (tarifa)
               end
               else
                  d:=d+1;
           end;
      end;
   end;
   ShowMessage('Importacion de tarifas realizada exitosamente.'+ #13 +
              intToStr(c) + ' registros con tarifa cero.'+ #13+
              intToStr(d) + ' registros duplicados.');
   misTarifasInsertadas.RowCount:=1;
end;

procedure TimportaTarifas.cbImpuestoClick(Sender: TObject);
begin
   if cbImpuesto.Checked then
   begin
     edtImpuesto.Text:= '0';
     edtImpuesto.Enabled:= False;
     if RevisaImpuestoGrid(sagImportados) then
     begin
       ShowMEssage('Se agregó impuesto con valor 0 en las tarifas con valor nulo.');
     end;
   end;
   if not cbImpuesto.Checked then
   begin
     edtImpuesto.Text:= '0';
     edtImpuesto.Enabled:= True;
   end;

end;

procedure TimportaTarifas.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   uImportarTarifas.QueryT.Free;

   comunii.terminalesAutomatizadas.Free;

   comunii.QueryReplica.Close;
   comunii.QueryReplica:= nil;

   misTarifasInsertadas.free;
end;

procedure TimportaTarifas.FormCreate(Sender: TObject);
begin
   comunii.QueryReplica := TSQLQuery.Create(nil);
   comunii.QueryReplica.SQLConnection := dm.Conecta;


   comunii.terminalesAutomatizadas:= TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;

   uImportarTarifas.QueryT:= TSQLQuery.Create(Self);
   uImportarTarifas.QueryT.SQLConnection:= dm.Conecta;

   
   misTarifasInsertadas:= TStringGrid.Create(self);
   misTarifasInsertadas.ColCount:= 2;
   // Columna 1 Id_Tarifa  Columna 2 Servicio
   misTarifasInsertadas.RowCount:= 1;
   // encabezados solamente
end;

procedure TimportaTarifas.FormShow(Sender: TObject);
begin
   dtpFecha.Date    := Now();
   dtpHora.Time     := Now();
end;

function TimportaTarifas.RegresaIdTarifa(Tramo, Servicio: String): Integer;
var replica: boolean;
   idTarifa: Integer;
{
  funcion que regresa el identidicador de tarifa de un tramo con un respectivo
  servicio.
  Si existe error al consultar, manda mensaje de error
  Si existe el identificador lo regresa y
  si no existe un identificador, lo da de alta, lo replica
  y porteriormente lo regresa...
}
begin
   result:=-1;
   replica:= False;
   sql:='SELECT ID_TARIFA FROM PDV_C_TARIFA WHERE ID_TRAMO='+ Tramo +
        ' AND ID_SERVICIO = '+ Servicio;
   if not EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
     ShowMessage('Error al consultar el identificador de Tarifa.');
     Exit;
   end;
   if QueryT.IsEmpty then
   begin
     sql:='INSERT INTO PDV_C_TARIFA(ID_TARIFA, ID_TRAMO, ID_SERVICIO) '+
          ' SELECT COALESCE(MAX(ID_TARIFA)+1,1), '+ Tramo + ','+ Servicio +
          ' FROM PDV_C_TARIFA;';
     if not EjecutaSQL(sql,QueryT,_LOCAL) then
     begin
        ShowMessage('Error al insertar el Identificador de Tarifa.');
        Exit
     end;
     replica:= True;
   end;
   sql:='SELECT ID_TARIFA FROM PDV_C_TARIFA WHERE ID_TRAMO='+ Tramo +
        ' AND ID_SERVICIO = '+ Servicio+';';
   if not EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
     ShowMessage('Error al consultar (2) el identificador de Tarifa.');
     Exit;
   end;
   idTarifa:= QueryT.FieldByName('ID_TARIFA').AsInteger;
   if replica then
   begin
     sql:='INSERT INTO PDV_C_TARIFA(ID_TARIFA, ID_TRAMO, ID_SERVICIO) '+
          ' VALUES('+ INTTOSTR(idTarifa) +', '+ Tramo + ','+ Servicio +');';
     uImportarTarifas.replicarTodosT(sql);
   end;
   result:= idTarifa;
end;

function TimportaTarifas.RegresaIdTramo(Origen, Destino, KM, MINUTOS:  String): Integer;
var replica: Boolean;
    idTramo: integer;
begin
   result:=-1;
   replica:= False;
   sql:='select ID_TRAMO from T_C_TRAMO '+
        ' WHERE ORIGEN='+QuotedStr(Origen)+
        ' AND DESTINO ='+QuotedStr(Destino)+';';
   if not EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
      ShowMessage('Error al leer el identificador de Tramo.');
      Exit;
   end;
   if QueryT.IsEmpty then
   begin
     sql:='INSERT INTO T_C_TRAMO(ID_TRAMO, KM, MINUTOS, ORIGEN, DESTINO) '  +
          ' SELECT COALESCE(MAX(ID_TRAMO)+1,1), '+ KM + ',' + MINUTOS + ',' +
          QuotedStr(Origen) + ',' + QuotedStr(Destino) +
          ' FROM T_C_TRAMO;';
     if not EjecutaSQL(sql,QueryT,_LOCAL) then
     begin
        ShowMessage('Error al insertar el Identificador de Tramo. '+ Origen + '-' + Destino);
        Exit
     end;
     replica:= True;
   end;
   sql:='select ID_TRAMO from T_C_TRAMO '+
        ' WHERE ORIGEN='+QuotedStr(Origen)+
        ' AND DESTINO ='+QuotedStr(Destino)+';';
   if not EjecutaSQL(sql,QueryT,_LOCAL) then
   begin
      ShowMessage('Error al leer el identificador de Tramo.');
      Exit;
   end;
   idTramo:= QueryT.FieldByName('ID_TRAMO').AsInteger;
   if replica then
   begin
     sql:='INSERT INTO T_C_TRAMO(ID_TRAMO, KM, MINUTOS, ORIGEN, DESTINO)  '+
          ' VALUES('+ INTTOSTR(idTramo) +', '+
          KM + ',' + MINUTOS + ',' +QuotedStr(Origen) + ',' + QuotedStr(Destino)+');';
     uImportarTarifas.replicarTodosT(sql);
   end;
   result:= idTramo;
end;

function TimportaTarifas.RevisaImpuestoGrid(grid: TStringGrid): Boolean;
var renglon: integer;
begin
    for renglon := 1 to grid.RowCount -1 do
      if Trim(grid.Cells[8,renglon]) = '' then
      begin
         grid.Cells[8,renglon] := '0';
         result:= False;
         //Exit;
      end;
  result:= True;

end;

function TimportaTarifas.grabaTarifa(idTarifa: Integer; FHAplica: TdAteTime;
  Monto: Real; impuesto: real): Boolean;
begin
     result:= False;
     // Elimino la/las tarifas que existan en la tabla con el mismo identificador de tarifa
     // y con la misma fecha y hora de aplicación, para evitar embiguedades y errores.

     sql:='DELETE FROM PDV_C_TARIFA_D WHERE  ID_TARIFA='+ iNTtOsTR(idTarifa)+
          ' AND FECHA_HORA_APLICA='+ QuotedStr(FormatDateTime('yyyy-mm-dd hh:NN',FHAplica))+';';
     if EjecutaSQL(SQL,QueryT,_LOCAL) then
     begin
        uImportarTarifas.replicarTodosT(sql);     // replico la eliminación
        // ahora inserto la misma tarifa, pero me estoy asegurando que no exista previamente :)

        sql:='INSERT INTO PDV_C_TARIFA_D(ID_TARIFA, MONTO, FECHA_HORA_APLICA, IMP_IVA ) '+
             ' VALUES('+ INTTOSTR(IDTARIFA)+ ',' + VARTOSTR(MONTO) + ',' + QuotedStr(FormatDateTime('yyyy-mm-dd hh:NN',FHAplica)) +
             ',' + varToStr(impuesto) + ');';
        if EjecutaSQL(sql,QueryT,_LOCAL) then
        begin
          uImportarTarifas.replicarTodosT(sql);    // replico la inserción
          result:= True;
          // agrego a mi Grid el Id de tarifa y su monto para evitar hacer mas de una vez lo mismo y
          // evitar lentitud en el módulo.
          misTarifasInsertadas.Cells[0,misTarifasInsertadas.RowCount-1] := IntToStr(idTarifa);
          misTarifasInsertadas.Cells[1,misTarifasInsertadas.RowCount-1] := FloatToStr(Monto);
          misTarifasInsertadas.RowCount := misTarifasInsertadas.RowCount + 1;
        end;
     end;

end;


end.
