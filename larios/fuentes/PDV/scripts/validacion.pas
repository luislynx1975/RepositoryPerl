//////AQUI ESTA///////////
procedure TFrmVentaBoletos.CalcularLugares(CadenaExt : String);
var
  Cadena      : String;
  Contador    : integer;
  NumCaracter : Integer;
  VarDepura   : Variant;
  Longitud    : Integer;
  NumRenglon  : Integer;
  NumTempIni  : Integer;
  CodeError   : Integer;
  VarLugares  : Variant;
  NumLugar    : Integer;
  ContRango   : Integer;

begin
   Cadena := Trim(CadenaExt);
   if cadena[length(Cadena)] in ['-',' '] then cadena[length(Cadena)] := ',';
   if cadena[length(Cadena)] <> ',' then cadena := cadena + ',';
   Edit1.Text := Cadena ;
   //Voy a buscar cuantos caracteres validos existen
   for contador := 1 to length(Cadena) do
   if cadena[contador] in[',','-',' '] then
    begin
      NumCaracter :=  NumCaracter + 1;
    end;

   //Voy  a Crear el arreglo de los caracteres
   VarDepura := VarArrayCreate([1, NumCaracter,1,7], varVariant);

       //Voy a efectuar la descomposicion de la cadena
   Longitud := length(Cadena);
   NumCaracter := 0;
   for Contador := 1 to Longitud do
   begin
    if cadena[contador] in[',','-',' '] then
    begin
       NumRenglon := NumRenglon + 1;
        //Voy a guardar la posicion de la cadena
       VarDepura[NumRenglon, 1]  := NumRenglon;      //Valor Renglon
       VarDepura[NumRenglon, 2]  := Cadena[Contador];     //Simbolo
       VarDepura[NumRenglon, 3]  := contador;      //Pos Simbolo
       VarDepura[NumRenglon, 4]  := False;  //Lugar Validado
       if NumRenglon = 1 then
         val(ObtieneLugarInicial(Edit1.Text,1,VarDepura[Numrenglon  , 3]),NumTempIni,CodeError)
       else
         Val(ObtieneLugarInicial(Edit1.Text,VarDepura[Numrenglon -1 , 3],VarDepura[Numrenglon , 3]),NumTempIni,CodeError);
       if codeError<> 0 then NumTempIni := 0;
       VarDepura[Numrenglon , 5] := NumTempIni;
       VarDepura[Numrenglon , 6] := NumTempIni;
    end;
    end;

    //Voy a barrer el registro para obtener los grupos
    for NumRenglon :=  1 to  VarArrayHighBound(VarDepura,1) do
    begin
      if VarDepura[Numrenglon  , 2] = '-' then
      begin
            VarDepura[Numrenglon  , 6] := VarDepura[Numrenglon  +1  , 6];
      end;
    end;
    //Voy a barrer el registro para obtener las tarifas
    for NumRenglon :=  1 to  VarArrayHighBound(VarDepura,1) do
    begin
       if NumRenglon = 1 then
         VarDepura[Numrenglon , 7] :=  ObtieneCodTarifa(Edit1.Text,1,VarDepura[Numrenglon  , 3])
       else
         VarDepura[Numrenglon , 7] :=  ObtieneCodTarifa(Edit1.Text,VarDepura[Numrenglon -1 , 3],VarDepura[Numrenglon , 3])
    end;
    //Ahora voy a validar los grupos especiales de tarigas
    for NumRenglon :=  2 to  VarArrayHighBound(VarDepura,1) do
    begin
         if VarDepura[Numrenglon , 7] <> ' ' then //si tiene una tarifa en particular
         begin
           if VarDepura[Numrenglon-1 , 2] = '-' then
              VarDepura[Numrenglon -1 , 7] :=  VarDepura[Numrenglon , 7];
         end;
    end;
     StringGrid10.RowCount := VarArrayHighBound(VarDepura,1);

     //Aqui voy a presentra los datros en el Grid
     For NumRenglon  := 1 to VarArrayHighBound(VarDepura,1) do
     begin
        StringGrid10.Cells[0,NumRenglon-1] := VarDepura[NumRenglon,1];
        StringGrid10.Cells[1,NumRenglon-1] := VarDepura[NumRenglon,2];
        StringGrid10.Cells[2,NumRenglon-1] := VarDepura[NumRenglon,3];
        StringGrid10.Cells[3,NumRenglon-1] := VarDepura[NumRenglon,4];
        StringGrid10.Cells[4,NumRenglon-1] := VarDepura[NumRenglon,5];
        StringGrid10.Cells[5,NumRenglon-1] := VarDepura[NumRenglon,6];
        StringGrid10.Cells[6,NumRenglon-1] := VarDepura[NumRenglon,7];
     end;
    //Truco barato Voy a crear un arreglo virtual de 1000 Lugares
     //showmessage(inttostr(VarArrayHighBound(varDepura,1)));
     VarLugares := VarArrayCreate([1, 1000,1,3], varVariant);
     for contador := 1 to 1000 do
     begin
        VarLugares[contador,1] := 0;
        VarLugares[contador,2] := False;
        VarLugares[contador,3] := 'N';
     end;
     //Este arreglo va a reccorrer todos los
     for contador := 1 to VarArrayHighBound(varDepura,1) do
     begin
      if (VarDepura[Contador,5]>0) then
      begin
           for contrango := VarDepura[contador,5] to VarDepura[contador,6] do
           begin
                VarLugares[contrango,1] := contrango;
                VarLugares[contrango,2] := True;
                VarLugares[contrango,3] := VarDepura[contador,7];
           end;
      end;
     end;
     //ahora voy a presentar en el segundo grid el listado de los lugares solicitados
     Longitud := 0;
     for contador := 1 to VarArrayHighBound(VarLugares,1) do
     begin
         if VarLugares[Contador,2] = True then
         begin
             Longitud := Longitud + 1;
             StringGrid20.RowCount := Longitud;
             StringGrid20.Cells[0,Longitud-1] := VarLugares[Contador,1];
             StringGrid20.Cells[1,Longitud-1] := VarLugares[Contador,3];
             //LineLugares.Add(VarLugares[Contador,1]);
         end;
     end;


end;