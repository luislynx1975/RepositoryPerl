unit frmReportePrivilegios;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, lsCombobox, Grids, Aligrid;

type
  TfrmReportePrivilegio = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    lbl1: TLabel;
    lscbObjeto: TlsComboBox;
    sagPrivilegios: TStringGrid;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    sdSalvarArchivo: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure lscbObjetoChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  var
     tipoFormulario: byte; // 0 = usuarios 1 = grupos
  end;

var
  frmReportePrivilegio: TfrmReportePrivilegio;

implementation

uses comun, comunii, uReportePrivilegios;

{$R *.dfm}

procedure TfrmReportePrivilegio.btn1Click(Sender: TObject);
var
  Archivo: TextFile;
  NombreArchivo : String;
begin
   if lscbObjeto.ItemIndex < 0 then
   begin
     ShowMessage('Debe elegir un usuario/grupo.');
     Exit;
   end;

   if not AccesoPermitido(217, _NO_RECUERDA_TAGS) then
      exit;

   sdSalvarArchivo.InitialDir := GetCurrentDir;
   sdSalvarArchivo.Options    := [ofFileMustExist];
   sdSalvarArchivo.Filter     := 'Archivos CSV|*.txt';
   sdSalvarArchivo.FilterIndex:= 2;
   sdSalvarArchivo.FileName   := 'Privilegios-'+lscbObjeto.CurrentItem+'.csv';
   if sdSalvarArchivo.Execute then
     nombreArchivo:=  sdSalvarArchivo.FileName
   else
   begin
     ShowMessage('No se eligió un archivo');
     exit;
   end;
   try
     Assignfile(Archivo, NombreArchivo);
     if FileExists(NombreArchivo) then  // Verifica si existe el archivo....
     begin
         deleteFile(NombreArchivo);
         rewrite(Archivo); // lo crea
     end
     else
         rewrite(Archivo);   // Lo abre
     WriteLn(Archivo, self.Caption);
     WriteLn(Archivo,lbl1.Caption + ',' + lscbObjeto.CurrentItem);
     WriteLn(Archivo,'Privilegio, Descripcion');
     if uReportePrivilegios.descargaSagAArchivo(sagPrivilegios, Archivo) then
        ShowMessage('Descarga exitosa.')
     else
        ShowMessage('Error al descargar.');
     WriteLn(Archivo,'Fin del reporte.');
   finally
     CloseFile(Archivo);
   end;

end;

procedure TfrmReportePrivilegio.btn2Click(Sender: TObject);
begin
   close;
end;

procedure TfrmReportePrivilegio.btn3Click(Sender: TObject);
begin
   case tipoFormulario of
      0:
      begin
          UreportePrivilegios.cargaPrivilegiosUsuario(sagPrivilegios, lscbObjeto.CurrentID);
      end;
      1:
      begin
          uReportePrivilegios.cargaPrivilegiosGrupo(sagPrivilegios, lscbObjeto.CurrentID);
      end;
   end;
end;

procedure TfrmReportePrivilegio.FormShow(Sender: TObject);
begin
    case tipoFormulario of
      0:
      begin
          self.Caption:= self.Caption +  ' de Usuarios';
          lbl1.Caption:= 'Usuarios';
          UreportePrivilegios.cargaUsuarios(lscbObjeto);
      end;
      1:
      begin
          self.Caption:= self.Caption +  ' de Grupos';
          lbl1.Caption:= 'Grupos';
          uReportePrivilegios.cargaGrupos(lscbObjeto);
      end;
   end;
end;

procedure TfrmReportePrivilegio.lscbObjetoChange(Sender: TObject);
begin
   LimpiaSag(sagPrivilegios);
end;

end.
