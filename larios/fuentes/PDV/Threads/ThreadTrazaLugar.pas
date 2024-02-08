unit ThreadTrazaLugar;

interface

uses
  Classes, ExtCtrls, Controls, StdCtrls;

type
  TrazaLugares = class(TThread)
  private
    { Private declarations }
  protected
    procedure Execute; override;
  public
    panel: tpanel;
    labels_asientos: array [1 .. 51] of ^Tlabel;
  end;

implementation

{
  Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

  Synchronize(UpdateCaption);

  and UpdateCaption could look like,

  procedure TrazaLugares.UpdateCaption;
  begin
  Form1.Caption := 'Updated in a thread';
  end;

  or

  Synchronize(
  procedure
  begin
  Form1.Caption := 'Updated in thread via an anonymous method'
  end
  )
  );

  where an anonymous method is passed.

  Similarly, the developer can call the Queue method with similar parameters as
  above, instead passing another TThread class as the first parameter, putting
  the calling thread in a queue with the other thread.

}

{ TrazaLugares }

procedure TrazaLugares.Execute;
begin
  { Place thread code here }
end;

end.
