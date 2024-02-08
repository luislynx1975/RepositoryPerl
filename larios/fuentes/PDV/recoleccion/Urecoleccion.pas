unit Urecoleccion;
{Autor: Gilberto Almanza Maldonado
Fecha: Jueves, 8 de Julio de 2010.
Unidad que contiene las funciones, procedimientos  y constantes
que ocupa el modulo de recolecciones.}
interface


uses comun, IniFiles, SysUtils, Forms;
Const
    _ERROR_VALORES = 'Error al mostrar los datos, revise su configuracion Local.';
    _SQL_REGRESA_NOMBRE_PROMOTOR = 'SELECT U.NOMBRE '+
                                   ' FROM PDV_C_USUARIO as U JOIN PDV_T_CORTE AS C '+
                                   ' ON U.TRAB_ID = C.ID_EMPLEADO '+
                                   ' WHERE U.TRAB_ID= %s  '+
                                   ' AND C.ESTATUS <> ''F'';';
    _ERROR_PROMOTOR ='Error, no es posible recolectar.';
    _PROMOTOR_NO_ASIGNADO  = 'El promotor no esta asignado actualmente.';
    _RECOLECCION_EXITOSA   = 'La recoleccion se guardo exitosamente.';
    _ESTATUS_2_RECOLECCION = 'Existen mas de 1 corte para este empleado.';
    _ESTATUS_3_RECOLECCION = 'Fondos insuficientes para la recoleccion.';
    _ERROR_FORMATO_NUMERO  = 'El dato que ha introducido no es un numero correcto para efectuar una recolección.';
var MontoRecolecta: Real;
    MontoCajero   : Real;

function RegresaDatosLocales: String;
function RegresaNombrePromotor: String;

implementation

uses DMdb;

{Funcion que regresa la localidad (terminal) y el numero de taquilla como
una cadena}
function RegresaDatosLocales: String;
begin
  try
     result:= 'Terminal: '+ comun.gs_terminal + ', Taquilla Numero: ' + comun.gs_maquina+'.';
  except
     result:= _ERROR_VALORES;
  end;

end;


function RegresaNombrePromotor: String;
begin

   try
      if COMUN.EjecutaSQL(Format(_SQL_REGRESA_NOMBRE_PROMOTOR,[QuotedStr(comun.gs_trabid)]), dm.Query, _LOCAL) then
           result:= dm.Query.FieldByName('NOMBRE').AsString;
      if dm.Query.IsEmpty  then
           result:= _PROMOTOR_NO_ASIGNADO;
   except
         result:= _ERROR_PROMOTOR;
   end;


end;
end.
