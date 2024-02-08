unit uLitteScreen;
interface
uses Controls, Windows, Vcl.Forms, Vcl.ExtCtrls, Vcl.Graphics;
type

LitteScreen = class
strict private
 class var FInstance : LitteScreen;
 constructor Create;
private
 fNumberOfMonitors : Integer;
 fCanPlay : Boolean;
 fBoundsRect : TRect;
 fScreen : TForm;
 fImage : TImage;
 procedure fillMonitor;
protected
  { protected declarations }
public
  procedure imageAssign(bitmapFile : String );
  destructor Destroy;
  class function GetInstance : LitteScreen;
published
  property canPlay : boolean read fCanPlay;
end;
implementation
constructor LitteScreen.Create;
begin
 inherited Create;
 fScreen := TForm.Create(nil);
 fScreen.Color := clBlack;
 fImage := TImage.Create(fScreen);
 fImage.Parent := fScreen;
 fImage.Stretch := True;
 fImage.Align := alClient;
 fNumberOfMonitors := Screen.MonitorCount;
 fCanPlay := fNumberOfMonitors >= 2;
 if canPlay then begin
   fillMonitor;
   fScreen.Show;
   fScreen.BoundsRect := fBoundsRect;
   fScreen.BorderStyle := bsNone;
   fScreen.WindowState := TWindowState.wsMaximized;
 end else begin
   fBoundsRect.Left := 10;
   fBoundsRect.Top := 10;
 end;
end;
destructor LitteScreen.Destroy;
begin
 fImage.DisposeOf;
 fScreen.DisposeOf;
 inherited;
end;
procedure LitteScreen.fillMonitor;
begin
 fBoundsRect := Screen.Monitors[1].BoundsRect;
end;
class function LitteScreen.GetInstance: LitteScreen;
begin
 if FInstance = nil then
   FInstance := LitteScreen.Create;
 Result := FInstance;
end;
procedure LitteScreen.imageAssign(bitmapFile: String);
begin
 fImage.Picture.LoadFromFile(bitmapFile);
 fScreen.Repaint;
end;
end.
