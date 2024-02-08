unit u_ping;

interface
uses
  Classes, StdCtrls, ExtCtrls, ActiveX, Graphics, System.Win.ComObj, SysUtils, Variants,
  DB, Data.SqlExpr;

  function GetStatusCodeStr(statusCode:integer) : string;
  function Ping(terminal : string): string;

Const
    Retries = 2;
    BufferSize = 32;

implementation

uses DMdb, comun;


function GetStatusCodeStr(statusCode: integer): string;
begin
  case statusCode of
    0     : Result:='Success';
    11001 : Result:='Buffer Too Small';
    11003 : Result:='Destination Host Unreachable';
    11002 : Result:='Destination Net Unreachable';
    11004 : Result:='Destination Protocol Unreachable';
    11005 : Result:='Destination Port Unreachable';
    11006 : Result:='No Resources';
    11007 : Result:='Bad Option';
    11008 : Result:='Hardware Error';
    11009 : Result:='Packet Too Big';
    11010 : Result:='Request Timed Out';
    11011 : Result:='Bad Request';
    11012 : Result:='Bad Route';
    11013 : Result:='TimeToLive Expired Transit';
    11014 : Result:='TimeToLive Expired Reassembly';
    11015 : Result:='Parameter Problem';
    11016 : Result:='Source Quench';
    11017 : Result:='Option Too Big';
    11018 : Result:='Bad Destination';
    11032 : Result:='Negotiating IPSEC';
    11050 : Result:='General Failure'
    else
    result:='Unknow';
  end;
end;

function Ping(terminal : string): string;
Const
  _QUERY = 'SELECT IPV4 FROM PDV_C_TERMINAL WHERE ID_TERMINAL = ''%s''';
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  i             : Integer;
  PacketsReceived : Integer;
  Minimum         : Integer;
  Maximum         : Integer;
  Average         : Integer;
  lq_qry          : TSQLQuery;
  ls_out, ls_ip : string;
begin
  ls_out := terminal;
  PacketsReceived:=0;
  Minimum        :=0;
  Maximum        :=0;
  Average        :=0;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  lq_qry := TSQLQuery.Create(nil);
  lq_qry.SQLConnection := DM.Conecta;


  for i := 0 to Retries-1 do begin
    if EjecutaSQL(format(_QUERY,[terminal]),lq_qry, _LOCAL) then
        ls_ip := lq_qry['IPV4'];

    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM Win32_PingStatus where Address=%s AND BufferSize=%d',
                                                  [QuotedStr(ls_ip),BufferSize]),'WQL',0);
    oEnum := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    if oEnum.Next(1, FWbemObject, iValue) = 0 then begin
      if FWbemObject.StatusCode = 0 then begin
        Inc(PacketsReceived);
        if FWbemObject.ResponseTime>Maximum then
            Maximum:=FWbemObject.ResponseTime;
        if Minimum = 0 then
            Minimum:=Maximum;
        if FWbemObject.ResponseTime<Minimum then
            Minimum:=FWbemObject.ResponseTime;
        Average:=Average+FWbemObject.ResponseTime;
      end
      else
    end;
    FWbemObject:=Unassigned;
    FWbemObjectSet:=Unassigned;
    Sleep(100);
    if PacketsReceived > Retries -1 then begin
        ls_out := '';
    end else begin
        ls_out := 'No hay conexion a la terminal : ' + terminal;
    end;
  end;
  lq_qry.Free;
  lq_qry := nil;
  Result := ls_out;
end;

end.
