unit U_acceso;

interface
{$warnings off}
uses comun, IniFiles, SysUtils, Forms;
Const
    _ERROR_INI_VALORES = 'No tenemos acceso al server de datos';
    _ERROR_GS_BASEDATO = 'Problemas para accesar a la base de datos';



    procedure LeerFileIni();
    procedure LecturaIni();

implementation

uses U_venta, Frm_Ini_Config;

function BaseNADec(num : string; n : byte) : integer;
var
i : integer;
aux : string;
begin
    aux:='0123456789ABCDEFGHIO';
    result:=0;
    for i:=1 to length(num) do
        result := result * n + pos(upcase(num[i]),aux) - 1;
end;

function HexToString(Data : String) : string;
var
    datos : array[1.._LONGITUD] of string;
    li_ctl, li_mod : integer;
    c : char;
    s : String;
    f,li_arr : integer;
    v : word;
begin
    li_arr := 1;
    for li_ctl := 1 to length(Data) do begin
        c := Data[li_ctl];
        li_mod := li_ctl mod 2;
        if li_mod = 0 then begin //agregamos un dato al arreglo
               datos[li_arr] := s + c;
               s := '';
               inc(li_arr);
        end else begin
                s := s + c;
        end;
    end;
    s := '';
    for li_ctl := 1 to li_arr - 1 do begin
        v := Ord(_PASSWORD[li_ctl]);
        f := BaseNADec(datos[li_ctl],16);
        s := s + Chr(f-v);
    end;
    Result := s;
end;


procedure LeerFileIni();
var
   lfile_ini  : TIniFile;
   ls_NameIni : String;
   frm_ini : TFrm_Ini;
begin
      ls_NameIni := ExtractFilePath(Application.ExeName);
      ls_NameIni := ls_NameIni + 'begin.ini';
      li_ctrl_conectando := 0;
//      gs_provider := 'MySql';
      if FileExists(ls_NameIni) then begin
        try
          lfile_ini  := TIniFile.Create(ls_NameIni);
          gs_local    := HexToString(lfile_ini.ReadString('CompanyInfo','ip','localhost'));
          gs_terminal := HexToString(lfile_ini.ReadString('CompanyInfo','terminal','Mex'));
          gs_maquina  := HexToString(lfile_ini.ReadString('CompanyInfo','Maquina','1'));
          gs_server   := lfile_ini.ReadString('ServerLocal','server','localhost');
          gs_dbName   := HexToString(lfile_ini.ReadString('ServerLocal','DbName','pullman'));
          gs_user     := HexToString(lfile_ini.ReadString('ServerLocal','user','pullman'));
          gs_password := HexToString(lfile_ini.ReadString('ServerLocal','acceso','pullman'));
          gs_agencia  := HexToString(lfile_ini.ReadString('ServerLocal','agencia','pullman'));
          gs_agencia_clave  := HexToString(lfile_ini.ReadString('ServerLocal','nombre','pullman'));
          li_ctrl_conectando := 1;
        finally
          lfile_ini.Free;//liberamos el archivo
        end;//presentar la pantalla para la configuracion del usuario
      end else begin
          if li_ctrl_conectando = 0 then begin
              try
                  frm_ini := TFrm_Ini.Create(nil);
                  frm_ini.ShowModal();
                  lfile_ini  := TIniFile.Create(ls_NameIni);
                  gs_local    := HexToString(lfile_ini.ReadString('CompanyInfo','ip','localhost'));
                  gs_terminal := HexToString(lfile_ini.ReadString('CompanyInfo','terminal','Mex'));
                  gs_maquina  := HexToString(lfile_ini.ReadString('CompanyInfo','Maquina','1'));
                  gs_server   := lfile_ini.ReadString('ServerLocal','server','localhost');
                  gs_dbName   := HexToString(lfile_ini.ReadString('ServerLocal','DbName','pullman'));
                  gs_user     := HexToString(lfile_ini.ReadString('ServerLocal','user','pullman'));
                  gs_password := HexToString(lfile_ini.ReadString('ServerLocal','acceso','pullman'));
                  gs_agencia  := HexToString(lfile_ini.ReadString('ServerLocal','agencia','pullman'));
                  gs_agencia_clave  := HexToString(lfile_ini.ReadString('ServerLocal','nombre','pullman'));
                  li_ctrl_conectando := 1;
              finally
                  lfile_ini.Free;
                  frm_ini.Free;
                  frm_ini := nil;
              end;
          end;//fin if
      end;
end;


procedure LecturaIni();
var
   lfile_ini  : TIniFile;
   ls_NameIni : String;
begin
      ls_NameIni := ExtractFilePath(Application.ExeName);
      ls_NameIni := ls_NameIni + 'begin.ini';
      if FileExists(ls_NameIni) then begin
        try
          lfile_ini  := TIniFile.Create(ls_NameIni);
          gs_local    := HexToString(lfile_ini.ReadString('CompanyInfo','ip','localhost'));
          gs_terminal := HexToString(lfile_ini.ReadString('CompanyInfo','terminal','Mex'));
          gs_maquina  := HexToString(lfile_ini.ReadString('CompanyInfo','Maquina','1'));
          gs_server   := lfile_ini.ReadString('ServerLocal','server','localhost');
          gs_dbName   := HexToString(lfile_ini.ReadString('ServerLocal','DbName','pullman'));
          gs_user     := HexToString(lfile_ini.ReadString('ServerLocal','user','pullman'));
          gs_password := HexToString(lfile_ini.ReadString('ServerLocal','acceso','pullman'));
          gs_agencia  := HexToString(lfile_ini.ReadString('ServerLocal','agencia','pullman'));
          gs_agencia_clave  := HexToString(lfile_ini.ReadString('ServerLocal','nombre','pullman'));
        finally
          lfile_ini.Free;
        end;
      end;
end;

end.
