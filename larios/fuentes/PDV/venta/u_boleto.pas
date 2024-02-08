unit u_boleto;

interface
{$warnings off}
{$hints off}

uses
  SysUtils,  Classes,  windows,  messages,  Dialogs,  Variants, Forms;


Const
   _PUERTO_PARALELO = 'LPT';
   _PUERTO_SERIAL = 'COM';
   _LONGITUD_PUERTO = 4;

   _ERROR_NUMERO_PUERTO = -1;
   _ERROR_NOMBRE_PUERTO = -2;
   _ERROR_AL_MANDAR_AL_PUERTO = -4;
   _ERROR_BOLETO = -8;
   _OK = 0;

   ESC=CHR($1B);
   Inicializa=ESC+'@';

   function construirHeaderBoleto : WideString;
   function construirHeaderBoleto101 : WideString;
   function construirBoleto101 : WideString;
   function construirBoleto : WideString;
   function imprimirBoletoDatamax(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,
                                   r16,r17,r18,r19,puerto : WideString):Integer;
   function imprimirBoletoDatamax101(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,
                               r16,r17, r25,puerto : WideString):Integer;

   function Imprimir(Puerto:Integer;Texto:string):byte;

implementation

uses u_impresion, comun;

var
   renglon1,renglon2,renglon3,renglon4,renglon5,renglon6,
   renglon7,renglon8,renglon9,renglon10,renglon11,renglon12,
   renglon13,renglon14,renglon15,renglon16,renglon17,
   renglon18,renglon19, renglon25,PuertoStr : String;


function Imprimir(Puerto:Integer;Texto:string):byte;
const
    Status=#16#4#1;
    Causa= #16#4#2;
var Num:Byte;
    cont:Word;
    Mode:DCB;
    Tiempos:COMMTIMEOUTS;
    puertoHandle : THandle;
    ok : LongBool;

  dwValor: Cardinal;          // Tama&ntilde;o de la lectura
  Sta: COMSTAT;            // Estado o tama&ntilde;o del buffer de lectura
  HandlePuerto: THandle;   // Manejador para el puerto

    procedure PoneModo;
    begin
      GetCommState(Puerto, Mode);
      Mode.BaudRate := 256000;
      Mode.ByteSize := 8;
      Mode.Parity := EVENPARITY;
      Mode.StopBits := ONESTOPBIT;
      SetCommState(Puerto, Mode);
      GetCommTimeouts(Puerto, Tiempos);
      Tiempos.ReadIntervalTimeout := 300;
      Tiempos.ReadTotalTimeoutMultiplier:= 300;
      Tiempos.ReadTotalTimeoutConstant:= 300;
      SetCommTimeouts(Puerto, Tiempos);
      GetCommTimeouts(Puerto, Tiempos);
    end;

    // ESCRIBE CADENA Y DEVUELVE CARACTERES ENVIADOS
    function Escribe(Cad:string):Integer;
    begin
      cont:=0;
      repeat
        inc(cont);
        FileWrite(puerto,Cad[cont],1);
      until cont=Length(cad);
      Result:=cont;
    end;

 // CONTROLA SI HUBO ERROR Y DEVUELVE EL NUMERO DE ERROR
    function Controla:Integer;
    begin
      Escribe(Status);
      Num:=0;
      cont := FileRead(Puerto,Num,1);
      Result := Num and 8;
      if cont = 0 then Result:=99;
      if Result = 8 then begin
        Escribe(Causa);
        Num:=0;
        FileRead(Puerto,Num,1);
        Result := Num and 44;
      end;
    end;
begin
    case Puerto of
        1:Puerto:=FileOpen('COM1',fmOpenReadWrite);
        2:Puerto:=FileOpen('COM2',fmOpenReadWrite);
        3:Puerto:=FileOpen('COM3',fmOpenReadWrite);
        4:Puerto:=FileOpen('COM4',fmOpenReadWrite);
      end;
   if (INVALID_HANDLE_VALUE <> puertoHandle) then begin
//      PoneModo;
      Escribe(Texto);
//      Result:=Controla; ///Revisar esta funcion para cachar el error
      FileClose(Puerto);
   end;
end;

function construirHeaderBoleto101 : WideString;
begin
    result := '{D1070,0700,1000|}'+
              '{C|}'+
              '{PC00;0690,0900,07,07,G,22,B|}'+
              '{PC01;0690,0870,07,07,G,22,B|}'+
              '{PC02;0690,0840,07,07,G,22,B|}'+
              '{PC03;0690,0810,07,07,G,22,B|}'+
              '{PC04;0690,0780,07,07,G,22,B|}'+
              '{PC05;0690,0750,07,07,G,22,B|}'+
              '{PC06;0690,0720,06,06,J,22,B|}'+//06,06,A
              '{PC07;0690,0690,06,06,J,22,B|}'+//06,06,A
              '{PC08;0690,0660,06,06,J,22,B|}'+//06,06,A
              '{PC09;0690,0630,06,06,J,22,B|}'+//07,07,J,22,B
              '{PC10;0690,0600,06,06,J,22,B|}'+
              '{PC11;0690,0570,06,06,J,22,B|}'+
              '{PC12;0690,0540,06,06,J,22,B|}'+
              '{PC13;0690,0510,07,07,H,22,B|}'+
              '{PC14;0690,0480,07,07,H,22,B|}'+
              '{PC15;0690,0450,07,07,H,22,B|}'+
              '{PC16;0690,0420,07,07,A,22,B|}'+//07,07,h
              '{PC17;0690,0390,07,07,H,22,B|}'+
              '{PC18;0690,0360,06,06,A,22,B|}'+
              '{PC19;0690,0330,05,05,G,22,B|}'+
              '{PC20;0690,0300,05,05,H,22,B|}'+
              '{PC21;0690,0240,05,05,H,22,B|}'+
              '{PC22;0690,0210,05,05,H,22,B|}'+
              '{PC23;0690,0180,05,05,H,22,B|}'+
              '{PC24;0690,0150,05,05,H,22,B|}'+
//              '{PC25;0220,0420,2,2,E,22,B|}';
              '{PC25;0220,0385,2,2,M,22,B|}';
end;


function construirBoleto101 : WideString;
begin
//              '{RV01;'+renglon1+'|}'+
    result := '{RC00;|}'+
              '{RC01;|}'+
              '{RC02;|}'+
              '{RC03;|}'+
              //'{RC04;30 dias para Facturar a partir de esta fecha|}'+
              '{RC04;|}'+
              '{RC05;|}'+
              '{RC06;'+renglon1+'|}'+
              '{RC07;'+renglon6+'|}'+
              '{RC08;'+renglon8+'|}'+
              '{RC09;'+renglon3+'|}'+
              '{RC10;'+renglon5+'|}'+
              '{RC11;'+renglon9+'|}'+
              '{RC12;'+renglon7+'|}'+
              '{RC13;|}'+
              '{RC14;'+renglon10+'|}'+
              '{RC15;'+renglon11+'|}'+
              '{RC16;|}'+
//              '{RC16;'+renglon3+'|}'+
              '{RC17;'+renglon12+'|}'+
              '{RC18;'+renglon4+'|}'+
              '{RC19;   '+renglon2+'|}'+
              '{RC20;'+renglon15+'|}'+
              '{RC21;'+renglon16+'|}'+
              '{RC22;'+renglon17+'|}'+
              '{RC23;'+renglon1+' '+renglon6+'|}'+
              '{RC24;'+renglon8+'|}'+
              '{RC25;'+renglon25+'|}'+
              '{XS;I,0001,0001CA001|}'+
              '{C|}';
end;

function construirHeaderBoleto : WideString;
begin
    result := '{D1450,0500,1430|}'+
              '{C|}'+
              '{PV00;0031,1389,0025,0034,B,33,B|}'+
              '{PV01;0090,1389,0025,0038,B,33,B|}'+
              '{PV02;0138,1389,0025,0034,B,33,B|}'+
              '{PV03;0179,1389,0025,0034,B,33,B|}'+
              '{PV04;0210,1389,0025,0034,B,33,B|}'+
              '{PV05;0264,1389,0038,0038,B,33,B|}'+
              '{PV06;0328,1389,0038,0038,B,33,B|}'+
              '{PV07;0392,1389,0038,0038,B,33,B|}'+
              '{PV08;0423,1389,0025,0025,B,33,B|}'+
              '{PV09;0464,1389,0025,0034,B,33,B|}'+
              '{PV10;0210,1100,0038,0025,B,33,B|}'+
              '{PV11;0264,0690,0038,0028,B,33,B|}'+
              '{PV12;0310,0690,0038,0028,B,33,B|}'+
              '{PV13;0340,0690,0038,0028,B,33,B|}'+//nuevo se recorren lo consecutivos
              '{PV14;0392,0690,0038,0034,B,33,B|}'+
              '{PV15;0464,0800,0025,0036,B,33,B|}'+
              '{PC016;0464,0258,05,05,H,22,B|}'+//posicion en las etiquetas verticales 248
              '{PC017;0464,0228,05,05,H,22,B|}'+//218
              '{PC018;0464,0198,05,05,H,22,B|}'+//188
              '{PC019;0464,0168,05,05,H,22,B|}'+//158
              '{PC020;0464,0160,05,05,H,22,B|}'
end;


function construirBoleto : WideString;
begin
    result := '{RV00;|}'+
              '{RV01;'+renglon1+'|}'+
              '{RV02;'+renglon2+'|}'+
              '{RV03;'+renglon3+'|}'+
              '{RV04;'+renglon4+'|}'+
              '{RV05;          '+renglon5+'|}'+
              '{RV06;              '+renglon6+'|}'+
              '{RV07;              '+renglon7+'|}'+
              '{RV08;'+renglon8+'|}'+
              '{RV09;'+renglon9+'|}'+
              '{RV10;'+renglon10+'|}'+
              '{RV11;  '+renglon11+'|}'+
              '{RV12;'+renglon12+'|}'+
              '{RV13;'+renglon13+'|}'+
              '{RV14;  '+renglon14+'|}'+
              '{RV15;'+renglon15+'|}'+
              '{RC016;'+renglon16+'|}'+
              '{RC017;'+renglon17+'|}'+
              '{RC018;'+renglon18+'|}'+
              '{RC019;'+renglon19+'|}'+//neuvp
              '{RC020;|}'+  //   '+renglon19+'|}'+
              '{XS;I,0001,0001CA001|}'+
              '{C|}';
end;



Function porParalelo(puerto : string; boleto : integer): Integer;
var
   f : Textfile;
Begin
   assignFile(f,puerto);
   try
     rewrite(f);
     if boleto = 0 then begin
         Writeln(f, construirHeaderBoleto+construirBoleto);
     end;
     if boleto = 1 then begin
         Writeln(f, construirHeaderBoleto101+construirBoleto101);
     end;
     CloseFile(f);
   except
     showMEssage('Ocurrio un error inesperado.');
     result := _ERROR_AL_MANDAR_AL_PUERTO;
     CloseFile(f);
     exit;
   end;
   result := _OK;
End;


Function imprimirBoletoDatamax(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,
                               r16,r17,r18,r19,puerto : WideString):Integer;
Begin
   renglon1 := r1;
   renglon2 := r2;
   renglon3 := r3;
   renglon4 := r4;
   renglon5 := r5;
   renglon6 := r6;
   renglon7 := r7;
   renglon8 := r8;
   renglon9 := r9;
   renglon10 := r10;
   renglon11 := r11;
   renglon12 := r12;
   renglon13 := r13;
   renglon14 := r14;
   renglon15 := r15;
   renglon16 := r16;
   renglon17 := r17;
   renglon18 := r18;
   renglon19 := r19;
   escribirAImpresora(gs_impresora_boletos, construirHeaderBoleto+construirBoleto );

End;

function imprimirBoletoDatamax101(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,
                               r16,r17, r25,puerto : WideString):Integer;
begin
   renglon1 := r1;
   renglon2 := r2;
   renglon3 := r3;
   renglon4 := r4;
   renglon5 := r5;
   renglon6 := r6;
   renglon7 := r7;
   renglon8 := r8;
   renglon9 := r9;
   renglon10 := r10;
   renglon11 := r11;
   renglon12 := r12;
   renglon13 := r13;
   renglon14 := r14;
   renglon15 := r15;
   renglon16 := r16;
   renglon17 := r17;
   renglon25 := r25;
   escribirAImpresora(gs_impresora_boletos, construirHeaderBoleto101+construirBoleto101 );
end;



end.
