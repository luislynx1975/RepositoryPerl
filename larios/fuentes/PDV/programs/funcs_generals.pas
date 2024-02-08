unit funcs_generals;

interface

uses
    SysUtils, Dialogs;


Const
  _LOGlinux = 'corporativo_Log.txt';
  procedure errorLogLINUX(error, sql : String); stdcall;
  function  accesoPermitido(): Boolean;
  procedure desconectar;


var
    lb_correcto : Boolean;

implementation

uses modulo;

procedure desconectar;
begin
    DataModulo.ZConexion.Connected := False;
end;


procedure errorLogLINUX(error, sql : String); stdcall;
Var
 archivo : TextFile;
Begin
 try
   AssignFile(archivo,_LOGlinux);
   if FileExists(_LOGlinux) then
     Append(archivo)
   else
     rewrite(archivo);
   Writeln(archivo,'//------------------------------------------------------------');
   Writeln(archivo,FormatDateTime('"Fecha : "dd/mm/yyyy hh":"nn ',now));
   Writeln(archivo,format('Error : %s',[error]));
   Writeln(archivo,format('SQL   : %s',[sql]));
   closeFile(archivo);
 except
 end;
end;


function accesoPermitido(): boolean;
begin
    try
        DataModulo.ZConexion.HostName           := _SERVERCENTRAL;
        DataModulo.ZConexion.Catalog            := _DATABASECENTRAL;
        DataModulo.ZConexion.Database           := _DATABASECENTRAL;
        DataModulo.ZConexion.user               := _USER;
        DataModulo.ZConexion.Password           := _PASSWORD;
        DataModulo.ZConexion.Protocol           := 'mysql-5';
        DataModulo.ZConexion.Connected          := True;
        DataModulo.ZQry.Connection              := DataModulo.ZConexion;
        lb_correcto := true;
    except
        on e:Exception do begin
             errorLogLINUX('Error en la conexion del server central',e.Message);
             ShowMessage('No existe conexion con el '+#10#13+
             'servidor central, reportelo al depto. de sistemas');
             lb_correcto := false;
        end;
    end;
    Result := lb_correcto;
end;

end.
