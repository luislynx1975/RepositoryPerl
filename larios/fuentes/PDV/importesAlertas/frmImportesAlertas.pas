unit frmImportesAlertas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, ExtCtrls, Grids, StdCtrls,
  lsCombobox;

type
  TfrmImportes = class(TForm)
    Panel1: TPanel;
    sagImportes: TStringGrid;
    Label1: TLabel;
    taquillas: TlsComboBox;
    btnGuardar: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure taquillasChange(Sender: TObject);

    const
    _TODAS = '0';
    _LUNES     =  'LUNES';
    _MARTES    =  'MARTES';
    _MIERCOLES =  'MIERCOLES';
    _JUEVES    =  'JUEVES';
    _VIERNES   =  'VIERNES';
    _SABADO    =  'SABADO';
    _DOMINGO   =  'DOMINGO';
    _PREGUNTA_GUARDAR = '¿Desea guardar los importes en la taquilla indicada?';
  private
    { Private declarations }
    procedure pintaEncabezadoDias(sag: TStringGrid);
    procedure limpiaImportes(sag: TStringGrid);
    procedure cargaTaquillas(lscbTaquillas: TlsComboBox);
    function  guardarImportes(sag : TStringGrid; taquilla: String): boolean;
    function ImportesCorrectos(sag: TStringGrid): boolean;
    procedure cargaImportes(sag: TStringGrid; taquilla: String);
  public
    { Public declarations }
  end;

var
  frmImportes: TfrmImportes;


implementation

{$R *.dfm}

uses  funciones,  DMdb, comun;

{ TfrmImportes }



procedure TfrmImportes.btnGuardarClick(Sender: TObject);
var i: integer;
begin

  if(not ImportesCorrectos(sagImportes)) then
  begin
    Showmessage('Revise los importes antes de continuar.');
    exit();
  end;
  if MessageDlg(_PREGUNTA_GUARDAR, mtConfirmation,mbYesNo,0) = mrNo then
     Exit;
  if taquillas.CurrentID = _TODAS then
   begin
     for i := 1 to taquillas.Items.Count-1 do
       guardarImportes(sagImportes, intToStr(i));
     showMessage('Importes guardados correctamente para todas las taquillas.');
     exit();
   end;
   guardarImportes(sagImportes, taquillas.CurrentID);
   showMessage('Importes guardados correctamente para la taquilla '+ taquillas.CurrentID);
end;

procedure TfrmImportes.Button1Click(Sender: TObject);
begin
   if taquillas.ItemIndex>0 then
     cargaImportes(sagImportes,taquillas.CurrentID)
   else
     limpiaImportes(sagImportes);
end;

procedure TfrmImportes.Button2Click(Sender: TObject);
begin
   close;
end;

procedure TfrmImportes.cargaImportes(sag: TStringGrid; taquilla: String);
var
 i: integer;
begin
   sql:= 'SELECT DIA, IMPORTE FROM PDV_C_IMPORTE_ALERTA WHERE ID_TAQUILLA='+ taquilla;
   try
     EjecutaSQL(sql, dm.Query, _LOCAL);
     for i := 0 to 6 do
     begin
        if (upperCase(dm.Query.FieldByName('DIA').AsString)= _LUNES) then
           sag.Cells[0,1]:= dm.Query.FieldByName('IMPORTE').AsString;
        if (upperCase(dm.Query.FieldByName('DIA').AsString)= _MARTES) then
           sag.Cells[1,1]:= dm.Query.FieldByName('IMPORTE').AsString;
        if (upperCase(dm.Query.FieldByName('DIA').AsString)= _MIERCOLES) then
           sag.Cells[2,1]:= dm.Query.FieldByName('IMPORTE').AsString;
        if (upperCase(dm.Query.FieldByName('DIA').AsString)= _JUEVES) then
           sag.Cells[3,1]:= dm.Query.FieldByName('IMPORTE').AsString;
        if (upperCase(dm.Query.FieldByName('DIA').AsString)= _VIERNES) then
           sag.Cells[4,1]:= dm.Query.FieldByName('IMPORTE').AsString;
        if (upperCase(dm.Query.FieldByName('DIA').AsString)= _SABADO) then
           sag.Cells[5,1]:= dm.Query.FieldByName('IMPORTE').AsString;
        if (upperCase(dm.Query.FieldByName('DIA').AsString)= _DOMINGO) then
           sag.Cells[6,1]:= dm.Query.FieldByName('IMPORTE').AsString;
        dm.Query.Next;
     end;

   finally
     dm.Query.Close;
   end;
end;

procedure TfrmImportes.cargaTaquillas(lscbTaquillas: TlsComboBox);
var
 i: Integer;
 sql: String;
begin
  try
     sql:='SELECT VENTANILLAS FROM T_C_TERMINAL WHERE ID_TERMINAL='+
          quotedStr(comun.gs_terminal);
     EjecutaSQL(sql, dm.Query, _LOCAL);
     lscbTaquillas.Clear;
     lscbTaquillas.add('TODAS', '0');
     for i := 1 to dm.Query.FieldByName('VENTANILLAS').AsInteger do
     begin
       lscbTaquillas.Add( intToStr(i),intToStr(i) );
     end;
  finally
     dm.Query.Close;
  end;
  lscbTaquillas.SetID('0');
end;

procedure TfrmImportes.FormCreate(Sender: TObject);
begin
   pintaEncabezadoDias(sagImportes);
   cargaTaquillas(taquillas);
end;


function TfrmImportes.guardarImportes(sag: TStringGrid;
  taquilla: String ): boolean;
  var i: integer;
begin
   for i := 0 to 6 do
     begin
        try
            sql:='DELETE FROM PDV_C_IMPORTE_ALERTA WHERE DIA='+
                 QuotedStr(sag.Cells[i,0])+
                 ' AND ID_TAQUILLA = '+ taquilla+';';
            EjecutaSQL(sql, dm.Query, _LOCAL);
            sql:='INSERT INTO PDV_C_IMPORTE_ALERTA(DIA, ID_TAQUILLA, IMPORTE) '+
                 ' VALUES('+QuotedStr(sag.Cells[i,0])+','+ taquilla +','+ sag.Cells[i,1]+ ');';
            EjecutaSQL(sql, dm.Query, _LOCAL);
        except
         begin
            showMessage('Ocurrió un error al guardar los importes');
            dm.Query.Close;
         end;
        end;

     end;
     result:= true;
end;

function TfrmImportes.ImportesCorrectos(sag: TStringGrid): boolean;
var aux,i: integer;
begin
   result:= true;
   for I := 0 to 6 do
   try
     aux:= strToint(sag.cells[I,1]);
   except
   begin
     result:= false;
     exit();
   end;
   end;

end;

procedure TfrmImportes.limpiaImportes(sag: TStringGrid);
begin
   sag.Cells[0,1]:= '';
   sag.Cells[1,1]:= '';
   sag.Cells[2,1]:= '';
   sag.Cells[3,1]:= '';
   sag.Cells[4,1]:= '';
   sag.Cells[5,1]:= '';
   sag.Cells[6,1]:= '';

end;

procedure TfrmImportes.pintaEncabezadoDias(sag: TStringGrid);
begin
   sag.Cells[0,0]:= 'LUNES';
   sag.Cells[1,0]:= 'MARTES';
   sag.Cells[2,0]:= 'MIERCOLES';
   sag.Cells[3,0]:= 'JUEVES';
   sag.Cells[4,0]:= 'VIERNES';
   sag.Cells[5,0]:= 'SABADO';
   sag.Cells[6,0]:= 'DOMINGO';

end;

procedure TfrmImportes.taquillasChange(Sender: TObject);
begin
 limpiaImportes(sagImportes);
 if taquillas.ItemIndex>=0 then
    cargaImportes(sagImportes,taquillas.CurrentID);
end;

end.
