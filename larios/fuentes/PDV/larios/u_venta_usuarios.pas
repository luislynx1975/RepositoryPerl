unit u_venta_usuarios;

interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
    StdCtrls, comun, SysUtils, Grids, DateUtils, ExtCtrls,
    Graphics, Variants,Classes;

Const
    _prc_sp = 43;

type
    array_usuarios = array[1..10000] of string;

implementation

uses DMdb;

end.
