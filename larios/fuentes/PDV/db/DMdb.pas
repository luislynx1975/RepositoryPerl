unit DMdb;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  SysUtils, Classes,  ImgList, Controls, DB, ExtCtrls,
  Dialogs, WideStrings, FMTBcd, SqlExpr, DBXMySql, Forms, Windows,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, System.ImageList;

type
  TDM = class(TDataModule)
    img_iconos: TImageList;
    Conecta: TSQLConnection;
    Query: TSQLQuery;
    Store: TSQLStoredProc;
    img_icons_large: TImageList;
    Conexion: TSQLConnection;
    IdTCPClient1: TIdTCPClient;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure conectandoServer();
    procedure desconectaServer();
  end;

var
  DM: TDM;
  imagenes_autobuses : array[1..20] of TImage;
implementation

uses comun;

var
    lb_conectado : boolean;

{$R *.dfm}

procedure TDM.conectandoServer;
begin
    gs_user     := 'venta';
    gs_password := chr(p(-18)) + chr(p(-45)) + chr(p(-30)) + chr(p(-8)) + chr(p(-44)) +
                   chr(p(-33)) + chr(p(-66)) + chr(p(5)) + chr(p(-58)) + chr(p(-24)) +
                   chr(p(-58)) + chr(p(-19)) + chr(p(-31)) + chr(p(-3)) + chr(p(20)) +
                   chr(p(17)) + chr(p(-1)) + chr(p(-46)) + chr(p(-66)) + chr(p(20)) +
                   chr(p(-2)) + chr(p(-6)) + chr(p(-45)) + chr(p(-3)) + chr(p(-29)) +
                   chr(p(2)) + chr(p(10)) + chr(p(-48)) + chr(p(-55)) + chr(p(-55)) +
                   chr(p(-44)) + chr(p(-10)) + chr(p(-45)) + chr(p(-14)) + chr(p(-37)) +
                   chr(p(-16));
//    gs_user     := 'root';
//    gs_password := '#R0j0N3no$';
//    gs_password := '';
    try
        Conecta.Params.Values['HOSTNAME']  := gs_server;
        Conecta.Params.Values['DATABASE']  := gs_dbName;
        Conecta.Params.Values['USER_NAME'] := gs_user;
        Conecta.Params.Values['PASSWORD']  := gs_password;
        Conecta.Connected := true;
        Query.SQLConnection := Conecta;
        lb_conectado := True;
        li_ctrl_conectando := 1;
    except
        on E : Exception do begin
          Mensaje('No existe conexion al servidor: de venta'+#10#13+'Reportelo al area del sistemas',0);
          lb_conectado := False;
          li_ctrl_conectando := 0;
          Application.Terminate;
        end;
    end;
end;


procedure TDM.desconectaServer;
begin
    try
       Conecta.Connected := False;
       Conecta.CloseDataSets;
    except
        on E : Exception do begin
          Mensaje('No puede desconectar al servidor: de venta'+#10#13+'Reportelo al area del sistemas',0);
          lb_conectado := False;
          Application.Terminate;
        end;
    end;
end;

end.
