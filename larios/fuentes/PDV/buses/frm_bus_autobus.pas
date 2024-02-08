/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Comun                                                         //
//  Pantalla:    Frm_autobus                                                   //
//  Descripción: Pantalla para actualizacion de asientos en la distribucion de //
//               asientos en el autobus                                        //
//  Fecha:       05 de Octubre 2009                                            //
//  Autor:       Jose Luis Larios Rodriguez                                    //
/////////////////////////////////////////////////////////////////////////////////
unit frm_bus_autobus;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ToolWin, ExtCtrls, StdCtrls, lsCombobox, DB,
   Grids, Data.SqlExpr, ActnMan, ActnCtrls, ActnMenus,
  PlatformDefaultStyleActnCtrls, lsStatusBar, System.Actions;

type
  TFrm_autobus = class(TForm)
    DrawGrid1: TStringGrid;
    Panel1: TPanel;
    ActionManager1: TActionManager;
    ac109: TAction;
    ac99: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    lsStatusBar1: TlsStatusBar;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    lsCombo_bus: TlsComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    procedure ac99Execute(Sender: TObject);
    procedure ac109Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lsCombo_busClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_autobus: TFrm_autobus;

implementation

uses DMdb, comun, u_autobus, Asiento;

var
    lq_query_bus     : TSQLQuery;
    dds_autobus_type : TDualStrings;
    DibujaBus        : TAsiento;
    bus_id           : Integer;
    no_asientos      : Integer;

{$R *.dfm}

procedure TFrm_autobus.ac99Execute(Sender: TObject);
begin
     Close;
end;


{qProcedure ac109Execute
@Params Sender : TObject
@Descripicion Guarda las posiciones de los asientos de cada autobus}
procedure TFrm_autobus.ac109Execute(Sender: TObject);
begin
    if (DibujaBus.li_ctrl - 1) <  no_asientos then begin
        Mensaje('El numero de asientos asignados estan incompletos',0);
        Exit;
    end;

    if not AccesoPermitido(109,False) then
      exit;
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_AUTOBUS,[ 'De grupos ingresados '])),
                    'Atención', _CONFIRMAR) = IDYES then begin
    //Leer el grid
        try
          borrar(bus_id);
          add_asientos(DrawGrid1,bus_id);
          Mensaje(_OPERACION_SATISFACTORIA,0);
          DibujaBus.clearLabels;
    //      DibujaBus.Destroy;
        except
            Mensaje('Error',0);
        end;
    end;
end;


{@Procedure FormShow
@Params Sender : TObject
@Descripcion Despleagamos la informacion correpondiente al autobus}
procedure TFrm_autobus.FormShow(Sender: TObject);
{        lq_query := TZReadOnlyQuery.Create(nil);
        lq_query.SQLConnection := DM.Conecta;}
begin
    dds_autobus_type := TDualStrings.Create;
    try
      lq_query_bus := TSQLQuery.Create(Self);
      lq_query_bus.SQLConnection := DM.Conecta;
    except
      ShowMessage('No tenemos conexion ');
    end;

    if EjecutaSQL(_BUS_SELCCIONA_ALL,lq_query_bus,_LOCAL)then
        LlenarComboBox(lq_query_bus,lsCombo_bus,false);
    with lq_query_bus do begin
        First;
        while not EoF do begin
           dds_autobus_type.Add(IntToStr(lq_query_bus['ID_TIPO_AUTOBUS']),IntToStr(lq_query_bus['ID_TIPO_AUTOBUS'])+
                                '|'+lq_query_bus['TIPO_AUTOBUS']+
                                '|'+IntToStr(lq_query_bus['ASIENTOS'])+
                                '|'+lq_query_bus['NOMBRE_IMAGEN']);
           next;
        end;
    end;
    DibujaBus := TAsiento.create(Panel1,lq_query_bus);
end;



{@procedure FormClose
@params Sender : TObject
@Descripcion Cerramos todas las conexiones posibles y cerramos la ventana}
procedure TFrm_autobus.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Close;
end;


{@Procedure lsCombo_busClick
@Params Sender : TObject
@Descripcion selecciona la imagen y dezplega la imagen}
procedure TFrm_autobus.lsCombo_busClick(Sender: TObject);
var
    li_idx, li_num : Integer;
    la_datos : gga_parameters;
begin
    for li_idx := 0 to dds_autobus_type.Count do begin
        splitLine(dds_autobus_type.Value[li_idx],'|',la_datos,li_num);
        if(la_datos[0] = lsCombo_bus.CurrentID) then begin
            DibujaBus.stGrid := DrawGrid1;
            DibujaBus.AsientoNum := StrToInt(la_datos[2]) ;
            DibujaBus.AutobusNum := StrToInt(la_datos[0]);
            DibujaBus.getImagenDLL(la_datos[3]);
            bus_id := StrToInt(la_datos[0]);
            no_asientos := StrToInt(la_datos[2]);
            break;
        end;
    end;
end;

end.
