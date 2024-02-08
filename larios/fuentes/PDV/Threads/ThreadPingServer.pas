unit ThreadPingServer;

interface

uses
  Classes, StdCtrls, ExtCtrls, ActiveX, Graphics, System.Win.ComObj, SysUtils, Variants;

Const
    Address = '192.168.1.13';
    Retries = 3;
    BufferSize = 32;
type
  TPingServer = class(TThread)
  private
    { Private declarations }
    function GetStatusCodeStr(statusCode:integer) : string;
    procedure Ping();
  protected
    procedure Execute; override;
  public
    memo  : TMemo;
    image : Timage;
  end;

implementation



{ TPingServer }



function TPingServer.GetStatusCodeStr(statusCode: integer): string;
begin
  case statusCode of
    0     : Result:='Success';
    11001 : Result:='Buffer Too Small';
    11002 : Result:='Destination Net Unreachable';
    11003 : Result:='Destination Host Unreachable';
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

procedure TPingServer.Ping();
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
begin;
  PacketsReceived:=0;
  Minimum        :=0;
  Maximum        :=0;
  Average        :=0;
  //Memo1.Lines.Add(Format('Pinging %s with %d bytes of data:',[Address,BufferSize]));
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost', 'root\CIMV2', '', '');
  for i := 0 to Retries-1 do
  begin
    FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM Win32_PingStatus where Address=%s AND BufferSize=%d',[QuotedStr(Address),BufferSize]),'WQL',0);
    oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
    if oEnum.Next(1, FWbemObject, iValue) = 0 then
    begin
      if FWbemObject.StatusCode=0 then
      begin

{        if FWbemObject.ResponseTime>0 then
          MEMO.Lines.Add(Format('Reply from %s: bytes=%s time=%sms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.ResponseTime,FWbemObject.TimeToLive]))
        else
          MEMO.Lines.Add(Format('Reply from %s: bytes=%s time=<1ms TTL=%s',[FWbemObject.ProtocolAddress,FWbemObject.ReplySize,FWbemObject.TimeToLive]));
}
        Inc(PacketsReceived);

        if FWbemObject.ResponseTime>Maximum then
        Maximum:=FWbemObject.ResponseTime;

        if Minimum=0 then
        Minimum:=Maximum;

        if FWbemObject.ResponseTime<Minimum then
        Minimum:=FWbemObject.ResponseTime;

        Average:=Average+FWbemObject.ResponseTime;
      end
      else
{      if not VarIsNull(FWbemObject.StatusCode) then
        Memo1.Lines.Add(Format('Reply from %s: %s',[FWbemObject.ProtocolAddress,GetStatusCodeStr(FWbemObject.StatusCode)]))
      else
        Memo1.Lines.Add(Format('Reply from %s: %s',[Address,'Error processing request']));}
    end;
    FWbemObject:=Unassigned;
    FWbemObjectSet:=Unassigned;
    Sleep(1000);
  end;

{  Writeln('');
  Writeln(Format('Ping statistics for %s:',[Address]));
  Writeln(Format('    Packets: Sent = %d, Received = %d, Lost = %d (%d%% loss),',[Retries,PacketsReceived,Retries-PacketsReceived,Round((Retries-PacketsReceived)*100/Retries)]));
  if PacketsReceived>0 then
  begin
   Writeln('Approximate round trip times in milli-seconds:');
   Writeln(Format('    Minimum = %dms, Maximum = %dms, Average = %dms',[Minimum,Maximum,Round(Average/PacketsReceived)]));
  end;}
  if PacketsReceived > Retries - 1 then begin
          IMAGE.Canvas.Brush.Color := clMenu;
          IMAGE.Canvas.Rectangle(0,0, IMAGE.Width, IMAGE.Height);
          IMAGE.Canvas.Brush.Color := clGreen;
          IMAGE.Canvas.Ellipse(0,0,IMAGE.Width, IMAGE.Height);
          MEMO.Lines.Clear;
          MEMO.Lines.Add('Conectado al Servidor Central');
  end else begin
          IMAGE.Canvas.Brush.Color := clMenu;
          IMAGE.Canvas.Rectangle(0,0, IMAGE.Width, IMAGE.Height);
          IMAGE.Canvas.Brush.Color := clRed;
          IMAGE.Canvas.Ellipse(0,0,IMAGE.Width, IMAGE.Height);
          MEMO.Lines.Clear;
          MEMO.Lines.Add('No Existe Conexion al Server Central');
  end;
end;

procedure TPingServer.Execute;
begin
  { Place thread code here }
    try
        CoInitialize(nil);
        try
//          Synchronize();// Ping() ;
            Synchronize(Ping);
        finally
          CoUninitialize;
        end;
    except on E: Exception do
    end;
end;

end.
