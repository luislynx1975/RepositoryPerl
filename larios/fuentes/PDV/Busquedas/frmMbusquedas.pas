unit frmMbusquedas;
{
Autor: Gilberto Almanza Maldonado
Fecha: Miercoles 25 de Noviembre de 2009
Descripcion: Forma que facilita la busqueda de informacion por condiciones.
}

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,  db, ImgList, System.ImageList, Data.SqlExpr;


type
  TfrmBusqueda = class(TForm)
    Panel1: TPanel;
    btnCancelar: TButton;
    btnBuscar: TButton;
    rgTipoBusqueda: TRadioGroup;
    lblDatos: TLabel;
    edBusqueda: TEdit;
    ImageList1: TImageList;
    procedure btnCancelarClick(Sender: TObject);
    procedure rgTipoBusquedaClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnBuscarClick(Sender: TObject);
    procedure edBusquedaKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Query : TSQLQuery;
    { Private declarations }
  public
    { Public declarations }

  end;

var
  frmBusqueda: TfrmBusqueda;


implementation

uses  comun, DMdb, frmCrutas, frmCtramos,  comunii;

{$R *.dfm}

procedure TfrmBusqueda.btnCancelarClick(Sender: TObject);
begin
   Close;
end;
{Procedimiento que ejecuta la busqueda con la condicion y parametros elegidos
el rgTipoBusqueda puede ser:
   0: tipo identificador del sistema
   1: tipo Origen
   2: tipo Destino
y el tipoBusqueda de la unidad comun puede ser:
  100: busqueda para la forma de tramos
  200: busqueda para la forma de rutas
  300: busqueda para la forma de tarifas
}
procedure TfrmBusqueda.btnBuscarClick(Sender: TObject);
begin
   case rgTipoBusqueda.ItemIndex of
   0 : begin   //TIPO IDENTIFICADOR DEL SISTEMA
      case comun.tipoBusqueda of
       100 :
                    frmTramos.edIdTramo.Text:= edBusqueda.Text;
       200 :
                    frmRutas.edIdRuta.Text:= edBusqueda.Text;
       300 :  begin
                    //frmTarifas.idRutaTarifasBuscar:= StrToInt(edBusqueda.Text);
                   // frmTarifas.Busqueda:= 1;
              end;

       end; // end del case mas interno (TipoBusqueda)
      end; // end del begin de 0

   1 : begin       //TIPO ORIGEN
      case comun.tipoBusqueda of
       100 : begin
               SQL:= 'SELECT ID_TRAMO AS TRAMO, ORIGEN, DESTINO, KM as KMS, MINUTOS From T_C_TRAMO '+
                     ' WHERE ORIGEN LIKE ''%'+edBusqueda.Text+'%''';
               if EjecutaSQL(sql,Query,_LOCAL) then
                  DataSetToSag(Query, frmtramos.sagDatos);
             end; // end del Tipo de Busqueda = 100
       200 : begin
               sql:= 'SELECT CONCAT(ORIGEN,'' - '',DESTINO,'' - '',ID_RUTA) AS RUTA, KM, MINUTOS FROM T_C_RUTA '+
                     ' WHERE ORIGEN LIKE''%'+edBusqueda.Text+'%'''+
                     ' ORDER BY RUTA';
               if EjecutaSQL(sql,Query,_LOCAL) then
               begin
                 LimpiaSag(frmRutas.sagRutas);
                 DataSetToSag(Query,frmRutas.sagRutas);
               end;
               sql:= 'SELECT *, CONCAT(ORIGEN,'' - '',DESTINO, '' - '',ID_RUTA) AS RUTA FROM T_C_RUTA  '+
                     ' WHERE ORIGEN LIKE''%'+edBusqueda.Text+'%'''+
                     ' ORDER BY RUTA';
               if EjecutaSQL(sql,Query,_LOCAL) then
               begin
                   LimpiaSag(frmRutas.sagRutasMio);
                   DataSetToSag(Query,frmRutas.sagRutasMio);
               end;
             end; // end del Tipo de Busqueda = 200
       300 :   begin
                //      frmTarifas.CiudadOTarifasBuscar:= edBusqueda.Text;
                //      frmTarifas.Busqueda:= 2;
               end;

        //Tipo de Busqueda = 300
      End; // case
      end; // end del begin 1
   ////
    2 : begin // TIPO DESTINO
      case comun.tipoBusqueda of
       100 :begin
               SQL:= 'SELECT ID_TRAMO AS TRAMO, ORIGEN, DESTINO, KM as KMS, MINUTOS From T_C_TRAMO '+
                     ' WHERE DESTINO LIKE ''%'+edBusqueda.Text+'%''';
               if EjecutaSQL(sql,Query,_LOCAL) then
                  DataSetToSag(Query, frmtramos.sagDatos);
             end; // end del Tipo de Busqueda = 100
       200 : begin
               sql:= 'SELECT CONCAT(ORIGEN,'' - '',DESTINO,'' - '',ID_RUTA) AS RUTA, KM, MINUTOS FROM T_C_RUTA '+
                     ' WHERE DESTINO LIKE''%'+edBusqueda.Text+'%'''+
                     ' ORDER BY RUTA';
               if EjecutaSQL(sql,Query,_LOCAL) then
               begin
                 LimpiaSag(frmRutas.sagRutas);
                 DataSetToSag(Query,frmRutas.sagRutas);
               end;
               sql:= 'SELECT *, CONCAT(ORIGEN,'' - '',DESTINO, '' - '',ID_RUTA) AS RUTA FROM T_C_RUTA  '+
                     ' WHERE DESTINO LIKE''%'+edBusqueda.Text+'%'''+
                     ' ORDER BY RUTA';
               if EjecutaSQL(sql,Query,_LOCAL) then
               begin
                   LimpiaSag(frmRutas.sagRutasMio);
                   DataSetToSag(Query,frmRutas.sagRutasMio);
               end;
             end; // end del Tipo de Busqueda = 200
       300 :  begin
               //    frmTarifas.CiudadDTarifasBuscar:= edBusqueda.Text;
               //    frmTarifas.Busqueda:= 3;
              end;

        //Tipo de Busqueda = 300

      End; // case
      end; // end del begin 1


   end; // end del CASE PRINCIPAL
     Close;
end;

{Procedimiento que permite solo numeros cuando se busca por IDENTIFICADOR
DE SISTEMA}
procedure TfrmBusqueda.edBusquedaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then  btnBuscarClick(Sender);
  case rgTipoBusqueda.ItemIndex of
     0: begin
        if (not(Key in ['0'..'9','.',#8, #13]))  then
        Key:= Char(0);
     end;
  end;

end;
{
Captions del formulario dependiendo si se buscan TRAMOS 100, RUTAS 200 o bien
TARIFAS 300.
}
procedure TfrmBusqueda.FormShow(Sender: TObject);
begin
   Query:= TSQLQuery.Create(Self);
   Query.SQLConnection:= dm.Conecta;
   rgTipoBusquedaClick(Sender);
   case comun.tipoBusqueda of
    100 : begin // busqueda de TRAMOS
             self.Caption:= self.Caption + ' de Tramos';
             self.rgTipoBusqueda.Items.Strings[1]:='Terminal Origen';
             self.rgTipoBusqueda.Items.Add('Terminal Destino');
             self.rgTipoBusqueda.Columns:= 3;
          end;
    200 : begin // busqueda de RUTAS en formulario de RUTAS
             self.Caption:= self.Caption + ' de Rutas';
             self.rgTipoBusqueda.Items.Strings[1]:='Terminal Origen';
             self.rgTipoBusqueda.Items.Add('Terminal Destino');
             self.rgTipoBusqueda.Columns:= 3;
          end;
    300 : begin // busqueda de RUTAS en formulario TARIFAS
             self.Caption:= self.Caption + ' de Rutas (Tarifas)';
             self.rgTipoBusqueda.Items.Strings[1]:='Terminal Origen';
             self.rgTipoBusqueda.Items.Add('Terminal Destino');
             self.rgTipoBusqueda.Columns:= 3;
          end;

   else ;
   end;
    edBusqueda.SetFocus;
end;

{Ayuda para el usuario, dependiendo del tipo de busqueda, aparecera en
lblDatos}
procedure TfrmBusqueda.rgTipoBusquedaClick(Sender: TObject);
begin
    edBusqueda.Clear;
   case rgTipoBusqueda.ItemIndex of
      0: begin
          case comun.tipoBusqueda of
             100 : lblDatos.Caption:='Introduzca Tramo asignado por el sistema.';
             200 : lblDatos.Caption:='Introduzca Ruta asignada por el sistema.';
             300 : lblDatos.Caption:='Introduzca Ruta asignada por el sistema.';
          end;
         end;
      1: begin
          case comun.tipoBusqueda of
             100: lblDatos.Caption:='Introduzca Siglas de Ciudad Origen a Buscar.';
             200: lblDatos.Caption:='Introduzca Siglas de Ciudad Origen a Buscar.';
             300: lblDatos.Caption:='Introduzca Siglas de Ciudad Origen a Buscar.';
          end;
          end;
      2: begin // solo para el tipo de busqueda 200
          case comun.tipoBusqueda of
             100: lblDatos.Caption:='Introduzca Siglas de Ciudad Destino a Buscar.';
             200: lblDatos.Caption:='Introduzca Siglas de Ciudad Destino a Buscar.';
             300: lblDatos.Caption:='Introduzca Siglas de Ciudad Destino a Buscar.';
          end;
         end;
   end;
   edBusqueda.SetFocus;
end;

procedure TfrmBusqueda.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Query.Destroy; // destruyo mi quey
end;

end.
