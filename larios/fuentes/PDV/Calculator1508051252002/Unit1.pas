unit Unit1;

interface
{$warnings off}
{$hints off}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, math, StdCtrls, ExtCtrls, jpeg;

CONST
  _CARACTERES_VALIDOS_EFECTIVO: SET OF CHAR = ['0', '1', '2', '3', '4', '5',
    '6', '7', '8', '9', '.','/','*','-','+'];

type
  Tfrm_calculadora = class(TForm)
    Label1: TLabel;
    BgImg: TImage;
    Img0: TImage;
    Img1: TImage;
    img4: TImage;
    img5: TImage;
    IMg2: TImage;
    img3: TImage;
    img6: TImage;
    img7: TImage;
    img8: TImage;
    img9: TImage;
    ImgPlus: TImage;
    ImgMin: TImage;
    ImgMult: TImage;
    ImgDiv: TImage;
    ImgEqual: TImage;
    ImgClose: TImage;
    ImgMinimize: TImage;
    PointImg: TImage;
    CImg: TImage;
    AcImg: TImage;
    Image1: TImage;
    edt_calcula: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnDivClick(Sender: TObject);
    Procedure Do_Operation;
    Procedure FindResult(Op:Byte);
    procedure Img0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Img0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Img0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImgMinimizeClick(Sender: TObject);
    procedure ImgCloseClick(Sender: TObject);
    procedure BgImgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure edt_calculaKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_calculadora: Tfrm_calculadora;
  numb1,numb2,result,mem1:Extended;
  Operation:byte; //1=addition, 2=subtr., 3=Multip., 4=div.
  comma,ok,Xy,Pressed:boolean;

implementation

uses Unit2;

{$R *.dfm}

Procedure Tfrm_calculadora.Do_Operation;
begin
     if operation=0 then begin
        numb1:=StrToFloat(Label1.Caption);
        edt_calcula.Text := Label1.Caption;
        edt_calcula.Clear;
     end
     else begin
          numb2:=StrToFloat(label1.caption);
          edt_calcula.Text := Label1.Caption;
          edt_calcula.Clear;
          FindResult(Operation);
     end;
     Ok:=True;
     Comma:=False;
end;





Procedure Tfrm_calculadora.FindResult(Op:byte);
begin
     case Op of
          1: Result:=(numb1+numb2);
          2: Result:=(numb1-numb2);
          3: Result:=(numb1*numb2);
          4: Result:=(numb1/numb2);
     else
         exit;
     end;
     numb1:=result;
     label1.Caption:=FloatToStr(result);
     edt_calcula.Text := Label1.Caption;
     edt_calcula.SetFocus;
     Operation:=0;
end;

procedure Tfrm_calculadora.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Close;
end;

procedure Tfrm_calculadora.FormCreate(Sender: TObject);
var i:byte;
    Rgn:Thandle;
begin
     Rgn:=CreateRoundRectRgn(0,0,BgImg.width,BgImg.Height,20,20);
     SetWindowRgn(handle,Rgn,true);
     DeleteObject(Rgn);
     Label1.Caption:='0';
     numb1:=0;
     numb2:=0;
     Mem1:=0;
     comma:=false;
     Xy:=False;
     Operation:=0;
     Result:=0;
     Pressed:=False;
{     for i:=0 to ComponentCount-1 do
         if (Components[i] is TImage) then
            if (TImage(Components[i]).Tag<1000) then
               TImage(Components[i]).Picture.Bitmap.LoadFromResourceID
               (hInstance,(TImage(Components[i]).Tag+1)*10);}
end;

procedure Tfrm_calculadora.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if Key = VK_ESCAPE then begin
      edt_calcula.Clear;
      Close;
    end;
end;

procedure Tfrm_calculadora.FormShow(Sender: TObject);
begin
    edt_calcula.Clear;
end;

procedure Tfrm_calculadora.BtnDivClick(Sender: TObject);
begin
     if Ok then exit;
     Do_Operation;
     Operation:=4;
end;


procedure Tfrm_calculadora.Img0MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if Button<>MBLeft then exit;
     TImage(sender).Picture.Bitmap.LoadFromResourceID(hInstance,(Timage(sender).Tag+1)*10+1);
     Pressed:=True;
end;

procedure Tfrm_calculadora.edt_calculaKeyUp(Sender: TObject; var Key: Word;
                                            Shift: TShiftState);
var
    ls_efectivo, ls_input, ls_output: string;
    lc_char, lc_new: CHAR;
    li_idx, li_ctrl: Integer;
begin
    case key of
      96  : li_ctrl := 0;
      97  : li_ctrl := 1;
      98  : li_ctrl := 2;
      99  : li_ctrl := 3;
      100 : li_ctrl := 4;
      101 : li_ctrl := 5;
      102 : li_ctrl := 6;
      103 : li_ctrl := 7;
      104 : li_ctrl := 8;
      105 : li_ctrl := 9;
      106 : li_ctrl := 3; ///
      107 : li_ctrl := 1;//
      109 : li_ctrl := 2;//
      111 : li_ctrl := 4;//
    end;
    case Key of
      96..105 : begin
                   if (Label1.Caption='0') then Label1.Caption:='';
                   if (Ok and not Comma) then begin
                      Label1.Caption:='';
                      Ok:=False;
                   end;
                   if Length(Label1.Caption)>=15 then exit;
                   Label1.Caption:=Label1.Caption+IntToStr(li_ctrl)
                end;
     106..109: begin  // opeartions +-*/
             if Ok then exit;
             Do_Operation;
             Operation := li_ctrl;
             end;
     111    : begin  // opeartions +-*/
                 if Ok then exit;
                 Do_Operation;
                 Operation := li_ctrl;
              end;
     13 : begin   // equal =
             if (numb1=0) or (Operation=0) and Not xy then exit;
             numb2:=StrToFloat(Label1.Caption);
             if Operation<>0 then FindResult(Operation)
             else if xy then begin
                  numb1:=Power(numb1,numb2);
                  Label1.Caption:=FloatToStr(numb1);
                  xy:=False;
             end;
             comma:=false;
             Numb1:=StrToFloat(Label1.caption);
             numb2:=0;
             Result:=0;
             edt_calcula.SelStart := Length(edt_calcula.Text);
          end;
      46 : begin
         if operation=0 then numb1:=0
         else numb2:=0;
         Label1.Caption:='0';
         edt_calcula.Clear;
      end;
    end;
end;



procedure Tfrm_calculadora.Img0MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,m:extended;
begin
     if (Button<>MBLeft) or not Pressed then exit;
     TImage(sender).Picture.Bitmap.LoadFromResourceID(hInstance,(Timage(sender).Tag+1)*10);
     case TImage(sender).Tag of
     0..9: begin // numbers 0..9
           if (Label1.Caption='0') then Label1.Caption:='';
           if (Ok and not Comma) then begin
              Label1.Caption:='';
              Ok:=False;
           end;
           if Length(Label1.Caption)>=15 then exit;
           Label1.Caption:=Label1.Caption+IntToStr(TImage(sender).Tag)
           end;
     10..13: begin  // opeartions +-*/
             if Ok then exit;
             Do_Operation;
             Operation:=TImage(sender).tag-9;
             end;
     14: begin   // equal =
         if (numb1=0) or (Operation=0) and Not xy then exit;
         numb2:=StrToFloat(Label1.Caption);
         if Operation<>0 then FindResult(Operation)
         else if xy then begin
              numb1:=Power(numb1,numb2);
              Label1.Caption:=FloatToStr(numb1);
              xy:=False;
         end;
         comma:=false;
         Numb1:=StrToFloat(Label1.caption);
         numb2:=0;
         Result:=0;
         end;
     15: begin // comma (point)
         if (Pos(',',Label1.Caption)>0) and (Operation=0)  then exit;
         if not ok then
            Label1.Caption:=Label1.Caption+','
         else
             Label1.Caption:='0,';
         comma:=True;
         end;
     24: begin // root
         if (label1.Caption='0') then exit
         else if (Copy(Label1.Caption,1,1)='-') then begin
              messagebox(handle,'Negative numbers are not allowed!','Negative Numbers',MB_Ok);
              exit;
         end;
         i:=StrToFloat(Label1.Caption);
         i:=sqrt(i);
         Label1.Caption:=FloatToStr(i);
         end;
     32: begin //C
         if operation=0 then numb1:=0
         else numb2:=0;
         Label1.Caption:='0';
         end;
     33: begin //AC
         numb1:=0;
         numb2:=0;
         Result:=0;
         Comma:=False;
         Ok:=False;
         Operation:=0;
         Label1.Caption:='0';
         end;
     36: begin // Integer value
         i:=strTofloat(label1.caption);
         i:=Int(i);
         Label1.caption:=FloatToStr(i);
         comma:=False;
         Ok:=False;
         end;
     end;
end;


procedure Tfrm_calculadora.Img0MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
     If Not (ssLeft in shift) then exit;
     if (x<=0) or (x>=(sender as TImage).width) or
        (y<=0) or (y>=(sender as TImage).Height) then begin
        TImage(sender).Picture.Bitmap.LoadFromResourceID
        (hInstance,(Timage(sender).Tag+1)*10);
        Pressed:=False;
     end
     else begin
         TImage(sender).Picture.Bitmap.LoadFromResourceID
         (hInstance,(Timage(sender).Tag+1)*10+1);
         Pressed:=True;
     end;
end;

procedure Tfrm_calculadora.ImgMinimizeClick(Sender: TObject);
begin
     Application.Minimize;
end;

procedure Tfrm_calculadora.ImgCloseClick(Sender: TObject);
begin
     Close;
end;

procedure Tfrm_calculadora.BgImgMouseDown(Sender: TObject; Button: TMouseButton;
                                          Shift: TShiftState; X, Y: Integer);
begin
     ReleaseCapture;
     frm_calculadora.Perform(Wm_SysCommand,$F012,0);
end;

procedure Tfrm_calculadora.Image1Click(Sender: TObject);
begin
     Form2.ShowModal;
end;

end.
