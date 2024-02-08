unit modulo;

interface

uses
  SysUtils, Classes, DB, ZAbstractRODataset, ZAbstractDataset, ZDataset,
  ZConnection, Dialogs;

Const
  _SERVERCENTRAL = '192.168.1.13';
  _DATABASECENTRAL = 'corporativo';
  _USER = 'venta';
  _PASSWORD = 'ventas';


  
type
  TDataModulo = class(TDataModule)
    ZConexion: TZConnection;
    ZQry: TZQuery;
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  DataModulo: TDataModulo;

implementation


{$R *.dfm}

end.
