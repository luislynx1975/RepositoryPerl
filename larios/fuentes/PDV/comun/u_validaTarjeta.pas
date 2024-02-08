unit u_validaTarjeta;

interface

uses u_comun_venta;


function pagoConTarjetaCD(asientos : array_asientos; li_asientos_vendidos : integer) : Boolean;

implementation



function pagoConTarjetaCD(asientos : array_asientos; li_asientos_vendidos : integer) : Boolean;
var
    li_idx : integer;
    lb_existe : Boolean;
begin
    lb_existe := False;
    for li_idx := 1 to li_asientos_vendidos do
        if asientos[li_idx].forma_pago = 2 then begin
            lb_existe := True;
            break;
        end;
    Result := lb_existe;
end;

end.
