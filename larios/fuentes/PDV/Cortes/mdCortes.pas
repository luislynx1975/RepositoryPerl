unit mdCortes;

interface

uses
  SysUtils, Classes, RpDefine, RpCon, RpConDS, FMTBcd, DB, SqlExpr;

type
  TmoduloCortes = class(TDataModule)
    ConexionRave: TRvDataSetConnection;
    Query1: TSQLQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  moduloCortes: TmoduloCortes;

implementation

uses DMdb;

{$R *.dfm}

end.
