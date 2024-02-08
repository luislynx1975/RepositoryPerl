unit Frm_splash;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, U_acceso, Grids, StdCtrls, pngimage, lsUpdater, ShellApi,
  IniFiles, Data.SqlExpr;

type
  TFrm_ini_splash = class(TForm)
    TimerSplash: TTimer;
    stg_tarifas: TStringGrid;
    Image1: TImage;
    lbVersion: TLabel;
    lbFecha: TLabel;
    lsUpdater: TlsUpdater;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TimerSplashTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Execute;
  protected
    procedure WMNCHitTest(var Message: TWMNCHitTest); message WM_NCHITTEST;
  end;

var
  Frm_ini_splash: TFrm_ini_splash;

implementation

uses U_venta, DMdb, u_main, ThreadRutas, comun, Frm_vta_main, u_venta_usuarios,
  uLitteScreen;

{$R *.dfm}

procedure TFrm_ini_splash.Execute;
var
  BlendFunction: TBlendFunction;
  BitmapPos: TPoint;
  BitmapSize: TSize;
  exStyle: DWORD;
begin
 exStyle := GetWindowLongA(Handle, GWL_EXSTYLE);
 if (exStyle and WS_EX_LAYERED = 0) then
   SetWindowLong(Handle, GWL_EXSTYLE, exStyle or WS_EX_LAYERED);

 ClientWidth := image1.Picture.Bitmap.Width;
 ClientHeight := image1.Picture.Bitmap.Height;

 BitmapPos := Point(0, 0);
 BitmapSize.cx := image1.Picture.Bitmap.Width;
 BitmapSize.cy := image1.Picture.Bitmap.Height;

 BlendFunction.BlendOp := AC_SRC_OVER;
 BlendFunction.BlendFlags := 0;
 BlendFunction.SourceConstantAlpha := 255;
 BlendFunction.AlphaFormat := AC_SRC_ALPHA;

 UpdateLayeredWindow(Handle, 0, nil, @BitmapSize, image1.Picture.Bitmap.Canvas.Handle,
 @BitmapPos, 0, @BlendFunction, ULW_ALPHA);
 Show;
 TimerSplash.Enabled := True;
end;

procedure TFrm_ini_splash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFrm_ini_splash.FormShow(Sender: TObject);
var
     hilo_ruta  : TodasRutasDetalle;
     url, ruta,  updater, parametro, versi : String;
     n : Integer;
     Query : TSQLQuery;
     lfile_fileIni : TIniFile;
begin
    lbVersion.Caption := 'Versión: ' + FloatToStr(_VERSION);
    lbFecha.Caption := _FECHA_VERSION;
    Refresh;
    LeerFileIni();
    lsUpdater.CurrentVersion := _VERSION;

//     gs_server := '192.168.1.13';
{ Anulación de código 19-dic-2012 porque cuando se iba el enlace ya no entraba. Salez}
{    lsUpdater.HTTPDocument := 'http://'+gs_server+'/version.txt';
    ruta := ExtractFilePath(Application.ExeName);
    if not FileExists(ruta + 'updater.exe') then Begin
       ShowMessage('Existe un error en la instalación del sistema. ' + #13#10 + 'Falta el archivo updater.exe');
       Application.Terminate;
    end;
    try
     if (lsUpdater.IsThereANewVersion) then begin
       Refresh;
       TimerSplash.Enabled := False;
       ShowMessage('Existe una nueva versión, se procedera a su descarga.');
       url := lsUpdater.HTTPDocument;
       n := length(url);
       repeat
         dec(n);
       until  url[n] = '/';
       url := copy(url,1,n);
       updater := ruta + 'updater.exe';
//       parametro := url + UpperCase(ExtractFileName(Application.ExeName));
       parametro := url + (ExtractFileName(Application.ExeName));
       ShellExecute(Handle, 'open', PWideChar(updater), PWideChar(parametro), nil, 1);
       Application.Terminate;
     end;
    except
    end;}

    if li_ctrl_conectando = 1 then begin // se tiene creado el begin.ini
       DM.conectandoServer();//agregamos la taquilla con la ip
       CONEXION_VTA := DM.Conecta;
       llenaPosicionLugares();
       guardamosAutobus();
       agregaTaquillaIP();
       obtenPeriodoVacacional();
       guardarVersion( FloatToStr(_VERSION) );
       //VARIABLES PARA LA IMPRESION
       gs_impresora_boleto := impresionBoletos(gs_terminal,gs_local,gs_maquina);
       gs_ImprimirAdicional := impresionGuiasCortes(gs_terminal,gs_local,gs_maquina);
//       ShowMessage(IntToStr(gs_ImprimirAdicional));
       ListaFill();//checar por error
       AutobusesDuales();///buscamos los buses y se guardan en la variable dualstring
//       ga_servers := obtenerIpsServer();//cargamos las direcciones ips de los servers se quita larios
       Query := TSQLQuery.Create(nil);
       Query.SQLConnection := DM.Conecta;
       if EjecutaSQL(Format(_CONSIGE_TAQUILLA,[gs_local,gs_terminal]),Query, _LOCAL) then begin
           if StrToInt(Query['ID_TAQUILLA']) <> StrToInt(gs_maquina) then begin
              creaBeginFile(gs_local,gs_terminal,IntToStr(Query['ID_TAQUILLA']),
                            gs_server,gs_agencia,gs_agencia_clave);
              LeerFileIni();
           end;
       end;
       Query.Free;
    end;
    gi_Pantalla_duplex := getParametroTabla(61);

//    if gi_Pantalla_duplex = 1 then begin
        pantalla := LitteScreen.GetInstance;
        gi_imagen_servicio := 0;
        showPantallaImagen(gi_imagen_servicio);
//    end;
end;

procedure TFrm_ini_splash.TimerSplashTimer(Sender: TObject);
begin
  Close;
end;

procedure TFrm_ini_splash.WMNCHitTest(var Message: TWMNCHitTest);
begin
  Message.Result := HTCAPTION;
end;

end.
