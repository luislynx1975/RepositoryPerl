unit Asiento;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    windows, Classes, DB, SysUtils, Grids, Forms,Dialogs, ActnList, lsCombobox,
    ExtCtrls, Graphics, StdCtrls, Controls, Data.SqlExpr;
type
    a_etiqueta = array  of Tlabel;
    a_sgdatas  = array[0..4] of String;

    TAsiento = class(TObject)
        panel : TPanel;
        query : TSQLQuery;
        Nobus : Integer;
        NoAsientos : Integer;
        stGrid : TStringGrid;
        image  : TImage;
        li_ctrl : Integer;
        Puntos  : TPoint;
        labels  : a_etiqueta;
        li_opcion  : Integer;
    private
        procedure setNoBus(Const Value : integer);
        procedure setGrid(Const Value : TStringGrid);
        procedure setNoSeat(Const Value : integer);


        procedure setNoAsiento();
        procedure ImageClick(Sender: TObject);
        procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        procedure drawLabel(li_ctrl : Integer; sg :TStringGrid; P : TPoint);
        function getSeatsAdd: Integer;

        procedure ControlMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure ControlMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
        procedure ControlMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
        procedure upGrid(x , y : integer; name : String);
        procedure setDataSgrid(p: TPoint; sg: TStringGrid; li_ctrl: integer);

    public
        property AutobusNum : Integer write setNoBus;
        property AsientoNum : Integer write setNoSeat;
        property Grid       : TStringGrid write setGrid;
        property CtrlSeat   : Integer read getSeatsAdd;

        constructor create(panel : TPanel; qry : TSQLQuery);
        destructor Destroy; override;

        procedure getImagenDLL(ls_name : String);
        procedure clearLabels();
        procedure SaveAsientosBus();
    end;

implementation

uses comun, DMdb, u_autobus;

var
    inReposition : boolean;
    oldPos: TPoint;

{ TAsiento }


procedure TAsiento.clearLabels;
var
    li_idx : Integer;
begin
      for li_idx := low(labels) to high(labels) do begin
        labels[li_idx].Free;
      end;
      image.Free;
end;


procedure TAsiento.ControlMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    inReposition:=True;
    SetCapture(TWinControl(panel).Handle);
    GetCursorPos(oldPos);
end;


procedure TAsiento.ControlMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
const
  minWidth = 20;
  minHeight = 20;
var
  newPos: TPoint;
  frmPoint : TPoint;
begin
  if inReposition then
  begin
    with TWinControl(Sender) do
    begin
      GetCursorPos(newPos);
      if ssShift in Shift then
      begin //resize
        Screen.Cursor := crSizeNWSE;
        frmPoint := ScreenToClient(Mouse.CursorPos);
        if frmPoint.X > minWidth then Width := frmPoint.X;
        if frmPoint.Y > minHeight then Height := frmPoint.Y;
      end
      else //move
      begin
        Screen.Cursor := crSize;
        Left := Left - oldPos.X + newPos.X;
        Top := Top - oldPos.Y + newPos.Y;
        upGrid(left,top,Name);
        oldPos := newPos;
      end;
    end;
  end;
end;


procedure TAsiento.ControlMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if inReposition then
  begin
    Screen.Cursor := crDefault;
    ReleaseCapture;
    inReposition := False;
  end;
end; (*ControlMouseUp*)



constructor TAsiento.create(panel : TPanel; qry: TSQLQuery);
begin
    Self.panel := panel;
    Self.query := qry;
    li_ctrl := 1;
    li_opcion := 1;
end;


destructor TAsiento.Destroy;
begin
  Nobus := 0;
  inherited destroy;
end;



procedure TAsiento.drawLabel(li_ctrl: Integer; sg: TStringGrid; P: TPoint);
begin
    if li_ctrl <= NoAsientos  then begin
      labels[li_ctrl - 1] := TLabel.Create(panel);
      labels[li_ctrl - 1].Font.Size := 20;
      labels[li_ctrl - 1].Transparent := True;
      labels[li_ctrl - 1].Caption := IntToStr(li_ctrl);
      labels[li_ctrl - 1].Top  := p.y - (labels[li_ctrl - 1].Height div 2);
      labels[li_ctrl - 1].Left := p.x - (labels[li_ctrl - 1].Width div 2);
      labels[li_ctrl - 1].Visible := True;
      labels[li_ctrl - 1].Name    := 'lbls'+IntToStr(li_ctrl );
      labels[li_ctrl - 1].Parent := panel;
      if li_opcion = 1 then begin
        labels[li_ctrl - 1].OnMouseDown := ControlMouseDown;
        labels[li_ctrl - 1].OnMouseMove := ControlMouseMove;
        labels[li_ctrl - 1].OnMouseUp   := ControlMouseUp;
      end;
      setDataSgrid(p,stGrid,li_ctrl - 1);
    end;
end;

procedure TAsiento.getImagenDLL(ls_name: String);
var
    h      : THandle;
    bitmap : TBitmap;
begin
    h     := LoadLibrary(_LIBRARYNAME);
    if h <> 0 then begin
      try
          bitmap := TBitmap.Create;
          image := TImage.Create(Panel);
          bitmap.LoadFromResourceName(h,ls_name);
          image.Width  := bitmap.Width;
          image.Height := bitmap.Height;
          image.Canvas.Draw(0,0,bitmap);
          image.AutoSize := True;
          image.Visible := true;
          image.OnClick := ImageClick;
          image.OnMouseMove := ImageMouseMove;
          image.Parent := Panel;
          setNoAsiento;
          li_ctrl := 1;
      finally
          bitmap.Free;
      end;
    end;
end;


function TAsiento.getSeatsAdd: Integer;
begin
    result := li_ctrl;
end;

procedure TAsiento.ImageClick(Sender: TObject);
begin
    Application.ProcessMessages;
    with Sender as TImage do begin
        drawLabel(li_ctrl,stGrid,Puntos);
        inc(li_ctrl);
    end;
end;

procedure TAsiento.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
    Puntos.X := X;
    Puntos.Y := Y;
end;


procedure TAsiento.SaveAsientosBus;
var
    li_col, li_row : Integer;
    sg_data : a_sgdatas;
    query : TSQLQuery;
begin
    query := TSQLQuery.Create(nil);
    query.SQLConnection := DM.Conecta;
    if EjecutaSQL(Format(_BUS_ELIMINA_SEATS,[IntToStr(Nobus)]),query,_LOCAL)then begin
      for li_row := 0 to stGrid.RowCount - 1 do begin
        for li_col := 0 to stGrid.ColCount - 1 do
            sg_data[li_col] := stGrid.Cells[li_col,li_row];
        if EjecutaSQL(Format(_BUS_SALVA_SEATS,[IntToStr(Nobus),sg_data[0],sg_data[1],sg_data[2]]),
                      query,_LOCAL)then
      end;
    end;
    query.Free;
end;



procedure TAsiento.setDataSgrid(p: TPoint; sg: TStringGrid;
  li_ctrl: integer);
begin
    stGrid.Cells[0,li_ctrl] := IntToStr(li_ctrl + 1);
    stGrid.Cells[1,li_ctrl] := IntToStr(p.X);
    stGrid.Cells[2,li_ctrl] := IntToStr(p.Y);
    stGrid.RowCount := li_ctrl + 1;
end;

procedure TAsiento.setGrid(const Value: TStringGrid);
begin
    stGrid := Value;
end;


procedure TAsiento.setNoAsiento();
begin
    labels := nil;
    SetLength(labels,NoAsientos);
end;


procedure TAsiento.setNoBus(const Value: integer);
begin
    Nobus := Value;
end;


procedure TAsiento.setNoSeat(const Value: integer);
begin
    NoAsientos := Value;
end;


procedure TAsiento.upGrid(x, y: integer; name: String);
var
    x1 : integer;
begin
    x1 := StrToInt(copy(name,5,length(name))) + 1; //indice del grid
    stGrid.Cells[1,x1 - 2] := IntToStr(X);
    stGrid.Cells[2,x1 - 2] := IntToStr(Y);
end;

end.

