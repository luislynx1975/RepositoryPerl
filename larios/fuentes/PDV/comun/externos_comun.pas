unit externos_comun;

interface
uses
    Data.SqlExpr;
const
    _PARAMETROS_FILTER =  'SELECT VALOR FROM PDV_C_PARAMETRO WHERE ID_PARAMETRO = :id';




    function getParametroValue(id : integer) : integer;

implementation

uses DMdb;
function getParametroValue(id : integer) : integer;
var
    lq_qry : TSQLQuery;
begin
    lq_qry := TSQLQuery.Create(nil);
    lq_qry.SQLConnection := dm.Conecta;
    lq_qry.SQL.Clear;
    lq_qry.SQL.Add(_PARAMETROS_FILTER);
    lq_qry.Params[0].AsInteger := id;
    lq_qry.Open;
    Result := lq_qry['VALOR'];

    lq_qry.Free;
    lq_qry := nil;
end;

end.
