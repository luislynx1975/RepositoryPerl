unit frmCorteFinDeDia;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ShellApi, printers;

type
  TfrmCorteFinDia = class(TForm)
    Label1: TLabel;
    dtpFechaCorte: TDateTimePicker;
    btnAceptar: TButton;
    btnCancelar: TButton;
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAceptarClick(Sender: TObject);

  private
    { Private declarations }
    Procedure CorteFinDeDia(fecha: TDateTime; Terminal: String);
  public
    { Public declarations }
  end;

var
  frmCorteFinDia: TfrmCorteFinDia;

implementation

uses uCortes, comun, comunii, u_impresion ;

{$R *.dfm}

procedure TfrmCorteFinDia.btnAceptarClick(Sender: TObject);
begin
    archivoOpos:= '';
    CorteFinDeDia(dtpFechaCorte.date, gs_terminal);
end;

procedure TfrmCorteFinDia.btnCancelarClick(Sender: TObject);
begin
   Close;

end;

procedure TfrmCorteFinDia.CorteFinDeDia(fecha: TDateTime; Terminal: String);
VAR ARCHIVO: TEXTFILE;
    NOMBREARCHIVO: STRING;
    i: integer;
    ya : boolean;
begin
   { primero reviso que todos los promotores del dia elegido, esten cortados
     para esta terminal, de ser asi continuo con la operacion, de no estar
     todos cortados: notificar al cajero que hacen falta de Procesar algunos
     cortes.
   }
   Ucortes.CreaQuery;
   ya:= False;
   i:= Ucortes.CortesPendientes(gs_terminal, fecha,fecha);
   if i <> 0 then
   begin
     ShowMessage(VarToStr(Format(_CORTES_PENDIENTES,[i]))+ char(#13) +
                 EmpleadosPendientes(gs_terminal, fecha, fecha)    );
      Exit;
   end;

   NombreArchivo:= 'CorteFindeDia'+VarToStr(FormatDateTime('ddmmyyyy',fecha))+'.txt';
    try
    Assignfile(Archivo, NombreArchivo);
    if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
    begin
        deleteFile(NombreArchivo);
        rewrite(Archivo); // lo crea
    end
    else
        rewrite(Archivo);   // Lo abre

    if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS then
    BEGIN
       uCortes.EncabezadoCorteFinDiaOPOS(archivoOpos, fecha, gs_terminal);
       uCortes.DetalleDocumentosCorteFinDiaOPOS(archivoOpos,gs_terminal,fecha);
       uCortes.DetalleCortesFinDeDiaOPOS(archivoOpos,gs_terminal,fecha);
    END
    else  if gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER then
    BEGIN
       uCortes.EncabezadoCorteFinDia(Archivo, fecha, gs_terminal);
       uCortes.DetalleDocumentosCorteFinDia(Archivo,gs_terminal,fecha);
       uCortes.DetalleCortesFinDeDia(Archivo,gs_terminal,fecha);
    END;
  CloseFile(Archivo);
  repeat
   if gs_ImprimirAdicional = _IMP_DEFAUTL_PRINTER then
      begin
       if ShellExecute(self.Handle, 'print', Pchar(NombreArchivo) ,nil, nil, SW_SHOWNORMAL) <= 32 then
           Application.MessageBox('No se pudo ejecutar la aplicación', 'Error', MB_ICONEXCLAMATION);
      end
      else if gs_ImprimirAdicional = _IMP_IMPRESORA_OPOS then
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
     showMessage('ERROR: Ocurrio un error inesperado al imprimir el corte de Fin de Dia, avise al administrador del sistema.');
  end;

  end; {end del try}


end;

procedure TfrmCorteFinDia.FormShow(Sender: TObject);
begin
  inicializaImpresionVars(); // OBTENGO LA IMPRESORA DONDE IMPRIMIRE LOS CORTES  EN gs_ImprimirAdicional
  dtpFechaCorte.Date:= Now();

end;

end.
