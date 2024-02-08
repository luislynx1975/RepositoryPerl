unit uServicioTerminal;

interface
uses
   System.SysUtils, System.Json, REST.Client, REST.Response.Adapter,
   REST.Authenticator.Basic, REST.Types;


const
 _ACCEPT = 'application/json, text/plain; q=0.9, text/html;q=0.8,';
 _ACCEPTCHARSET = 'utf-8, *;q=0.8';
 _CONTENTTYPE = 'application/json';
 _NOMBRE = 'body';
 _BODY_TCS = '{"ID_EMPRESA": %S, "NO_ECONOMICO": "%S", "ID_TIPO_VEHICULO": %S, "F_EGRESO": "%S", '+
             ' "ID_EMPRESA_DESPACHO": %S, "ID_TIPO_DESPACHO": %S, "ID_DESTINO": %S, "TOKEN": "%S"}';


 //
 //---INICIO
 _BASE_URL = 'http://catcs.dnsalias.net:1906/tds_test/';//prueba
 _NOMBRE_SERVICIO = 'despacho_ws_v1_1.php';//prueba
 _USUARIO_TCS = 'TDSdespacho';
 _PASSWORD_TCS = 'desp4ch0';


//ultimo modificacion productivo
{ _BASE_URL = 'http://catcs.dnsalias.net:1906/tds/ws/';//productivo
 _NOMBRE_SERVICIO = 'despacho_ws.php';//productivo
 _USUARIO_TCS = 'TDSdespacho';
 _PASSWORD_TCS = 'desp4ch0';}



 function consumirServicio(id_empresa, id_tipo_vehiculo, id_empresa_despacho, id_tipo_despacho, id_destino : Integer;
                           no_economico : string; egreso: TDateTime; var cadena_json : string;
                           token : string; CodeStatus : integer): String;

var
  gls_jsonString : String;

implementation


function consumirServicio(id_empresa, id_tipo_vehiculo, id_empresa_despacho, id_tipo_despacho, id_destino : Integer;
                          no_economico : string; egreso: TDateTime; var cadena_json : string;
                          token : string; CodeStatus : integer): String;
var
 RESTClient: TRESTClient;
 RESTRequest: TRESTRequest;
 RESTResponse: TRESTResponse;
 HTTPBasicAuthenticator: THTTPBasicAuthenticator;
 ls_cadena : string;
begin
   try
     RESTClient := TRESTClient.Create(nil);
     RESTRequest := TRESTRequest.Create(nil);
     RESTResponse := TRESTResponse.Create(nil);
     HTTPBasicAuthenticator := THTTPBasicAuthenticator.Create(nil);
     RESTClient.BaseURL := _BASE_URL + _NOMBRE_SERVICIO;
     RESTClient.Accept := _ACCEPT;
     RESTClient.AcceptCharset  := _ACCEPTCHARSET;
     RESTClient.Authenticator := HTTPBasicAuthenticator;
     RESTRequest.Client := RESTClient;
     RESTRequest.Method := rmPOST;
     RESTRequest.Response := RESTResponse;
     cadena_json := Format(_BODY_TCS,[id_empresa.ToString, no_economico, id_tipo_vehiculo.ToString,
                                 FormatDateTime('YYYY-MM-DD HH:NN:SS', egreso),
                                 id_empresa_despacho.ToString, id_tipo_despacho.ToString, id_destino.ToString, token]);

     RESTRequest.Params.AddItem(_NOMBRE, Format(_BODY_TCS,[id_empresa.ToString, no_economico, id_tipo_vehiculo.ToString,
                                 FormatDateTime('YYYY-MM-DD HH:NN:SS', egreso),
                                 id_empresa_despacho.ToString, id_tipo_despacho.ToString, id_destino.ToString, token]),
                                 TRESTRequestParameterKind.pkREQUESTBODY,[poDoNotEncode],TRESTContentType.ctAPPLICATION_JSON);
     RESTRequest.SynchronizedEvents := False;
     RESTResponse.ContentType := _CONTENTTYPE;
     HTTPBasicAuthenticator.Username := _USUARIO_TCS;
     HTTPBasicAuthenticator.Password := _PASSWORD_TCS;
     RESTRequest.Execute;
     ls_cadena := RESTResponse.JSONText;
     Result := RESTResponse.JSONValue.ToString;
   except on E: Exception do
     Result := TJSONObject.Create(TJSONPair.Create('Error', e.Message)).ToString;
   end;
end;


end.
