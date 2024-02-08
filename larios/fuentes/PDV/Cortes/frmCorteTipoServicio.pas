unit frmCorteTipoServicio;
{
Autor: Gilberto Almanza Maldonado
Fecha: 22 de diciembre de 2009 10:00 hrs
Descripcion: Forma que permite la captura de una fecha inicial y una fecha
             final para realizar un corte por tipo de servicio.
}


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellApi, printers;

type
  TfrmCorteServicio = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    dtpFechaInicial: TDateTimePicker;
    dtpFechaFinal: TDateTimePicker;
    btnAceptar: TButton;
    btnCancelar: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dtpFechaInicialKeyPress(Sender: TObject; var Key: Char);
    procedure dtpFechaFinalKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCorteServicio: TfrmCorteServicio;

implementation

uses frmCorte, uCortes, comunii, comun, u_impresion ;

{$R *.dfm}

procedure TfrmCorteServicio.btnCancelarClick(Sender: TObject);
begin
   close;
end;

{boton que asigna los valores de fecha inicial y final
y despues cierra la forma}
procedure TfrmCorteServicio.btnAceptarClick(Sender: TObject);
var NombreArchivo: String;
    Archivo: TEXTFILE;
    i: Integer;
    FechaInicial, FechaFinal: TDateTime;
    ya: boolean;
begin
   {obtener la venta de todos los empleados asignados en una fecha dada
    y agruparlos por tipo de servicio.}
   { primero reviso que todos los promotores del dia elegido, esten cortados
     para esta terminal, de ser asi continuo con la operacion, de no estar
     todos cortados: notificar al cajero que hacen falta de Procesar algunos
     cortes.
   }
   ya:= False;
   FechaInicial:= dtpFechaInicial.DateTime;
   FechaFinal  := dtpFechaFinal.DateTime;
   Ucortes.CreaQuery;
   archivoOpos:= '';
   i:= Ucortes.CortesPendientes(gs_terminal, fechaInicial, fechaFinal);
   if i <> 0 then
   begin
      ShowMessage(VarToStr(Format(_CORTES_PENDIENTES,[i]))+ char(#13) +
                 EmpleadosPendientes(gs_terminal, fechaInicial, fechaFinal)    );
      Exit;
   end;
   archivoOpos:= '';
   NombreArchivo:= 'CorteServicio'+VarToStr(FormatDateTime('ddmmyyyy',fechaInicial))+'.txt';
   try
    Assignfile(Archivo, NombreArchivo);
    //System.IO.Path.GetTempPath +
    if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
    begin
        deleteFile(NombreArchivo);
        rewrite(Archivo); // lo crea
    end
    else
        rewrite(Archivo);   // Lo crea
   if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS  then
   BEGIN
      Ucortes.EncabezadoCorteTipoServicioOPOS(archivoOpos, fechaInicial,fechaFinal,gs_Terminal);
      UCortes.DetalleCortesTipoServicioOPOS(archivoOpos,gs_terminal,fechaInicial, fechaFinal);
   END
   else  if  gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER  then
   BEGIN
      Ucortes.EncabezadoCorteTipoServicio(Archivo, fechaInicial,fechaFinal,gs_Terminal);
      UCortes.DetalleCortesTipoServicio(Archivo,gs_terminal,fechaInicial, fechaFinal);
   END;
   CloseFile(Archivo);
   repeat
   if  gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER  then
      begin
       if ShellExecute(self.Handle, 'print', Pchar(NombreArchivo) ,nil, nil, SW_SHOWNORMAL) <= 32 then
           Application.MessageBox('No se pudo ejecutar la aplicación', 'Error', MB_ICONEXCLAMATION);
      end
      else if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS  then
      begin
            escribirAImpresora(gs_impresora_general, archivoOpos);
      end; // end del ELSE impresora OPOS


       if MessageDlg(_PREGUNTA_IMPRESION_CORRECTA, mtConfirmation,mbYesNo,0)  =  mrYes then
         ya:= true;
   until ya;
   ShowMessage(comunii._OPERACION_SATISFACTORIA);
   except
   begin
     CloseFile(Archivo);
     showMessage('ERROR: Ocurrio un error inesperado al imprimir el Corte por Tipo de Servicio, avise al administrador del sistema.');
   end; // end del EXCEPT
   end; {end del try}

end;

procedure TfrmCorteServicio.FormShow(Sender: TObject);
begin
   inicializaImpresionVars(); // OBTENGO LA IMPRESORA DONDE IMPRIMIRE LOS CORTES  EN gs_ImprimirAdicional
   dtpFechaInicial.Date:= now();
   dtpFechaFinal.Date  := now();
end;

procedure TfrmCorteServicio.dtpFechaInicialKeyPress(Sender: TObject;
  var Key: Char);
begin
  dtpfechaFinal.Date:= dtpFechaInicial.Date;
  IF KEY = #13 THEN
     DTPFECHAFINAL.SetFocus;
end;

procedure TfrmCorteServicio.dtpFechaFinalKeyPress(Sender: TObject;
  var Key: Char);
begin
     IF KEY = #13 THEN
     BTNACEPTAR.SetFocus;
end;

end.
