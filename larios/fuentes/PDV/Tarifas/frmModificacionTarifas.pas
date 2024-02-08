unit frmModificacionTarifas;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, lsCombobox, Grids , Math,
  Data.SqlExpr;

type
  TfrmModificaTarifa = class(TForm)
    dtpFecha: TDateTimePicker;
    dtpHora: TDateTimePicker;
    Label1: TLabel;
    rgTipoIncremento: TRadioGroup;
    rgAumento: TRadioGroup;
    edtAumento: TEdit;
    Button1: TButton;
    Button2: TButton;
    lscbTipoIncremento: TlsComboBox;
    Label2: TLabel;
    Label3: TLabel;
    rgRedondear: TRadioGroup;
    rgAux: TRadioGroup;
    lscbAux: TlsComboBox;
    RadioGroup1: TRadioGroup;
    cmb_imp_iva: TlsComboBox;
    procedure Button1Click(Sender: TObject);
    procedure rgTipoIncrementoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure rgAumentoClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure rgAuxClick(Sender: TObject);
    function regresaNuevaTarifa(Monto: String): String;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  frmModificaTarifa: TfrmModificaTarifa;
  sagResultado: TStringGrid;
implementation

uses uTarifas, DMdb, comunii, comun, uImportarTarifas;

{$R *.dfm}

procedure TfrmModificaTarifa.Button1Click(Sender: TObject);
begin
   Close;
end;

procedure TfrmModificaTarifa.Button2Click(Sender: TObject);
var i : Integer;
    ld_iva : Real;
begin
  ld_iva := 0.0;
  sql:='select now() as Fecha;';
  if not EjecutaSQL(sql,dm.Query,_LOCAL) then
   begin
     ShowMessage('Error al consultar el horario del servidor.');
     Exit;
   end;
   dtpFecha.Time:= dtpHora.Time;
   if dm.Query.FieldByName('Fecha').AsDateTime > dtpFecha.DateTime  then
   begin
      ShowMessage('La fecha y hora de aplicacion de las tarifas. Deben ser mayor a la fecha actual del sistema. ');
      Exit;
   end;
 if rgTipoIncremento.ItemIndex < 0 then
 begin
   ShowMessage('Debes elegir un tipo de incremento masivo de tarifas antes de continuar.');
   Exit;
 end;
 if rgAumento.ItemIndex < 0 then
 begin
   ShowMessage('Debes elegir un tipo de incremento de tarifas antes de continuar.');
   Exit;
 end;
 if (rgTipoIncremento.ItemIndex >= 0)
    and (rgTipoIncremento.ItemIndex <> 2)
    and (lscbTipoIncremento.ItemIndex = -1) then
 begin
   ShowMessage('Elegir una ruta/servicio antes de continuar.');
   lscbTipoIncremento.SetFocus;
   Exit;
 end;
 if edtAumento.Text = '' then
 begin
   ShowMessage('Digite la informacion antes de continuar.');
   edtAumento.SetFocus;
   Exit;
 end;
 if rgRedondear.ItemIndex < 0 then
 begin
   ShowMessage('Elegir un tipo de redondeo antes de continuar.');
   Exit;
 end;
 case rgTipoIncremento.ItemIndex of
    0:begin  // RUTA
          if rgAux.ItemIndex = 0  then
          begin
            ShowMessage('Elige un Auxiliar distinto a cambio por Ruta.');
            Exit;
          end;
          if rgAux.ItemIndex = 1 then
          begin
             if lscbAux.ItemIndex = -1 then
             begin
               ShowMessage('Elige un servicio para complementar la operacion.');
               lscbAux.SetFocus;
               Exit;
             end;
             sql:='SELECT D.ID_TARIFA, (SELECT MONTO FROM PDV_C_TARIFA_D AS DD WHERE DD.ID_TARIFA = D.ID_TARIFA ' +
                  ' AND DD.FECHA_HORA_APLICA <= NOW() ORDER BY DD.FECHA_HORA_APLICA DESC LIMIT 1) AS MONTO, '+
                  ' MAX(D.FECHA_HORA_APLICA) '+
                  '  FROM PDV_C_TARIFA_D AS D'+
                  '  WHERE ID_TARIFA IN      '+
                  '  (                       '+
                  ' SELECT ID_TARIFA         '+
                  ' FROM PDV_C_TARIFA        '+
                  ' WHERE ID_TRAMO IN        '+
                  '  (                       '+
                  '   SELECT ID_TRAMO        '+
                  '    FROM T_C_TRAMO        '+
                  '    WHERE ID_TRAMO IN     '+
                  '     (                    '+
                  '      SELECT ID_TRAMO     '+
                  '    FROM T_C_RUTA_D       '+
                  '    WHERE ID_RUTA =       '+ lscbTipoIncremento.CurrentID +
                  '     )                    '+
                  ' ) AND ID_SERVICIO=       '+ lscbAux.CurrentID            +
                  ' )                        '+
                  '  AND FECHA_HORA_APLICA <= NOW() '+
                  ' GROUP BY D.ID_TARIFA;';
          end;
          if rgAux.ItemIndex = -1 then
          begin
            sql:='SELECT D.ID_TARIFA, (SELECT MONTO FROM PDV_C_TARIFA_D AS DD WHERE DD.ID_TARIFA = D.ID_TARIFA '+
                 ' AND DD.FECHA_HORA_APLICA <= NOW() ORDER BY DD.FECHA_HORA_APLICA DESC LIMIT 1) AS MONTO,     '+
                 ' MAX(D.FECHA_HORA_APLICA) '+
                 ' FROM PDV_C_TARIFA_D AS D '+
                 ' WHERE ID_TARIFA IN       '+
                 ' (                        '+
                 ' SELECT ID_TARIFA         '+
                 ' FROM PDV_C_TARIFA        '+
                 ' WHERE ID_TRAMO IN        '+
                 ' (                        '+
                 '    SELECT ID_TRAMO       '+
                 '   FROM T_C_TRAMO         '+
                 '    WHERE ID_TRAMO IN     '+
                 '     (                    '+
                 '      SELECT ID_TRAMO     '+
                 '      FROM T_C_RUTA_D     '+
                 '      WHERE ID_RUTA =     '+ lscbTipoIncremento.CurrentID +
                 '     )                    '+
                 ' )                        '+
                 ' )                        '+
                 ' AND FECHA_HORA_APLICA <= NOW()  '+
                 ' GROUP BY D.ID_TARIFA';
          end;
      end;
    1:begin     // SERVICIO
          if rgAux.ItemIndex = 0 then
          begin
            if lscbAux.ItemIndex = -1 then
            begin
               ShowMessage('Elige una ruta para complementar la operacion.');
               lscbAux.SetFocus;
               Exit;
            end;
            sql:='SELECT D.ID_TARIFA, (SELECT MONTO FROM PDV_C_TARIFA_D AS DD WHERE DD.ID_TARIFA = D.ID_TARIFA ' +
                  ' AND DD.FECHA_HORA_APLICA <= NOW() ORDER BY DD.FECHA_HORA_APLICA DESC LIMIT 1) AS MONTO, '+
                  ' MAX(D.FECHA_HORA_APLICA) '+
                  '  FROM PDV_C_TARIFA_D AS D'+
                  '  WHERE ID_TARIFA IN      '+
                  '  (                       '+
                  ' SELECT ID_TARIFA         '+
                  ' FROM PDV_C_TARIFA        '+
                  ' WHERE ID_TRAMO IN        '+
                  '  (                       '+
                  '   SELECT ID_TRAMO        '+
                  '    FROM T_C_TRAMO        '+
                  '    WHERE ID_TRAMO IN     '+
                  '     (                    '+
                  '      SELECT ID_TRAMO     '+
                  '    FROM T_C_RUTA_D       '+
                  '    WHERE ID_RUTA =       '+ lscbAux.CurrentID            +
                  '     )                    '+
                  ' ) AND ID_SERVICIO=       '+ lscbTipoIncremento.CurrentID +
                  ' )                        '+
                  '  AND FECHA_HORA_APLICA <= NOW() '+
                  ' GROUP BY D.ID_TARIFA;';
          end;
          if rgAux.ItemIndex = 1  then
          begin
            ShowMessage('Elige un Auxiliar distinto a cambio por Tipo de Servicio.');
            Exit;
          end;

          if rgAux.ItemIndex = -1 then
          begin
            sql:='SELECT D.ID_TARIFA, (SELECT MONTO FROM PDV_C_TARIFA_D AS DD WHERE DD.ID_TARIFA = D.ID_TARIFA ' +
                 ' AND DD.FECHA_HORA_APLICA <= NOW() ORDER BY DD.FECHA_HORA_APLICA DESC LIMIT 1) AS MONTO,     ' +
                 ' MAX(D.FECHA_HORA_APLICA) ' +
                 ' FROM PDV_C_TARIFA_D AS D ' +
                 ' WHERE ID_TARIFA IN       ' +
                 ' (                        ' +
                 ' SELECT ID_TARIFA         ' +
                 ' FROM PDV_C_TARIFA        ' +
                 ' WHERE ID_SERVICIO=       ' + lscbTipoIncremento.CurrentID +
                 ' )                        ' +
                 ' AND FECHA_HORA_APLICA <= NOW() '+
                 ' GROUP BY D.ID_TARIFA ;   ' ;
          end;

      end;


    2:
      begin
          sql:='SELECT D.ID_TARIFA, (SELECT MONTO FROM PDV_C_TARIFA_D AS DD WHERE DD.ID_TARIFA = D.ID_TARIFA '+
               ' AND DD.FECHA_HORA_APLICA <= NOW() ORDER BY DD.FECHA_HORA_APLICA DESC LIMIT 1) AS MONTO,     '+
               ' MAX(D.FECHA_HORA_APLICA) ' +
               ' FROM PDV_C_TARIFA_D AS D ' +
               ' WHERE  FECHA_HORA_APLICA <= NOW() '+
               ' GROUP BY D.ID_TARIFA;';
      end;
 end;
// showmessage(sql);
 if MessageDlg(format(uImportarTarifas._PREGUNTA_ALTA_TARIFAS,
          [FormatDateTime('dd/mm/yyyy', dtpFecha.Date),
          FormatDateTime('hh:nn ', dtpHora.Time)]),mtWarning,mbOKCancel,0) =
          mrCancel then Exit;
 dtpFecha.Time := dtpHora.Time;
 if ejecutaSQL(sql, dm.Query, _LOCAL)  then begin
   if dm.Query.Eof  then begin
      begin
       ShowMessage('No existen registros para los parametros elegidos.');
       Exit;
     end;
   end;
   if cmb_imp_iva.ItemIndex = -1 then begin
        Mensaje('No se ha elegido el iva se asignara el valor  0',2);
        ld_iva := 0;
   end else begin
        ld_iva := StrToFloat(cmb_imp_iva.CurrentID);
   end;
//   if DataSetToSag(dm.Query, sagResultado) then begin//error nuevo
    if true then begin//se agrego

     for i  := 1 to sagResultado.RowCount - 1 do begin
           sql:='DELETE FROM PDV_C_TARIFA_D WHERE  ID_TARIFA='+ sagResultado.Cells[0,i]  +
                ' AND FECHA_HORA_APLICA='+ QuotedStr(FormatDateTime('yyyy/mm/dd hh:nn', dtpFecha.DateTime)) +';';
           if EjecutaSQL(SQL,dm.Query,_LOCAL) then begin
              uImportarTarifas.replicarTodosT(sql);
               sql:='INSERT INTO PDV_C_TARIFA_D(ID_TARIFA, MONTO, FECHA_HORA_APLICA, IMP_IVA) '+
                      ' VALUES( ' + sagResultado.Cells[0,i] +  ',' +
                      regresaNuevaTarifa(sagResultado.Cells[1,i])  +  ',' +
                      QuotedStr(FormatDateTime('yyyy/mm/dd hh:nn', dtpFecha.DateTime)) + ',' +
                      FloatToStr(ld_iva) + ');';
               if EjecutaSQL(sql,dm.Query,_LOCAL) then
                  uImportarTarifas.replicarTodosT(sql);
           end;
     end;
   end;
 end;


end;

procedure TfrmModificaTarifa.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   uTarifas.QueryT.Free;
   sagResultado.Free;

   comunii.terminalesAutomatizadas.Free;
   comunii.QueryReplica.Close;
   comunii.QueryReplica:= nil;
end;

procedure TfrmModificaTarifa.FormCreate(Sender: TObject);
begin
   uTarifas.QueryT:= TSQLQuery.Create(Self);
   uTarifas.QueryT.SQLConnection := dm.Conecta;
   sagResultado:= TStringGrid.Create(self);

   comunii.terminalesAutomatizadas:= TStringList.Create;
   comunii.cargarTodasLasTerminalesAutomatizadas;

   comunii.QueryReplica := TSQLQuery.Create(nil);
   comunii.QueryReplica.SQLConnection := dm.Conecta;
   CargarIva(cmb_imp_iva);
end;


procedure TfrmModificaTarifa.FormShow(Sender: TObject);
begin
   dtpFecha.Date:= Now();
   dtpHora.Time := Now();
end;

procedure TfrmModificaTarifa.rgAuxClick(Sender: TObject);
begin
   case rgAux.ItemIndex of
        0: uTarifas.CargaRuta(lscbAux);
        1: uTarifas.CargaServicio(lscbAux);
        2: lscbAux.Clear;
   end;
end;

function TfrmModificaTarifa.regresaNuevaTarifa(Monto: String): String;
var MontoL, aux: Real;
begin
    MontoL:= StrToFloat(Monto);
    case rgAumento.ItemIndex of
      0:
      begin
         case  rgRedondear.ItemIndex  of
            0:
            begin
                result := FloatToStr(MontoL + strToFloat(edtAumento.Text));
                Exit;
            end;
            1:
            begin
                result := FloatToStr(MontoL - strToFloat(edtAumento.Text));
                Exit;
            end;
         end;

      end;
      1:
      begin
         case  rgRedondear.ItemIndex  of
            0: aux := (MontoL * StrToFloat(edtAumento.Text) / 100) + MontoL ;
            1: aux :=  MontoL - (MontoL * StrToFloat(edtAumento.Text) / 100)  ;
         end;
         if frac(aux) = 0.50 then
             result:= FloatToStr(aux);

         if frac(aux) > 0.50 then
             result := FloatToStr(ceil(aux));

         if frac(aux) < 0.50 then
             result:= FloatToStr(floor(aux));
         Exit;
      end;
    end;
end;

procedure TfrmModificaTarifa.rgAumentoClick(Sender: TObject);
begin
  case rgAumento.ItemIndex of
    0: begin
        label2.Visible:= True;
        label3.Visible:= False;
       end;
    1: begin
        label2.Visible:= False;
        label3.Visible:= True;
       end;
  end;
end;

procedure TfrmModificaTarifa.rgTipoIncrementoClick(Sender: TObject);
begin
   case rgTipoIncremento.ItemIndex of
        0: uTarifas.CargaRuta(lscbTipoIncremento);
        1: uTarifas.CargaServicio(lscbTipoIncremento);
        2: begin
            lscbTipoIncremento.Clear;
            rgAux.ItemIndex:= -1;
           end;
   end;
end;

end.
