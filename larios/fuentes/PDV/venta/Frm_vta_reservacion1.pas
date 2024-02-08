unit Frm_vta_reservacion1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  PlatformDefaultStyleActnCtrls, ComCtrls, ExtCtrls, Grids, StdCtrls, Mask,
  lsCombobox, SqlExpr;

type
  Tfrm_vta_reserva = class(TForm)
    ActionManager1: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    Action1: TAction;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Gr_Corridas: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ls_Origen_vta: TlsComboBox;
    ls_Desde_vta: TlsComboBox;
    ls_Origen: TlsComboBox;
    ls_servicio: TlsComboBox;
    medt_fecha: TMaskEdit;
    Ed_Hora: TEdit;
    GroupBox2: TGroupBox;
    stg_detalle: TStringGrid;
    GroupBox3: TGroupBox;
    stg_ocupantes: TStringGrid;
    Panel2: TPanel;
    Splitter2: TSplitter;
    pnlBUS: TPanel;
    Image: TImage;
    Label125: TLabel;
    Label150: TLabel;
    Label149: TLabel;
    Label148: TLabel;
    Label147: TLabel;
    Label146: TLabel;
    Label145: TLabel;
    Label144: TLabel;
    Label143: TLabel;
    Label142: TLabel;
    Label141: TLabel;
    Label140: TLabel;
    Label139: TLabel;
    Label138: TLabel;
    Label137: TLabel;
    Label136: TLabel;
    Label135: TLabel;
    Label134: TLabel;
    Label133: TLabel;
    Label132: TLabel;
    Label131: TLabel;
    Label130: TLabel;
    Label129: TLabel;
    Label128: TLabel;
    Label127: TLabel;
    Label126: TLabel;
    Label124: TLabel;
    Label123: TLabel;
    Label122: TLabel;
    Label121: TLabel;
    Label120: TLabel;
    Label119: TLabel;
    Label118: TLabel;
    Label117: TLabel;
    Label116: TLabel;
    Label115: TLabel;
    Label114: TLabel;
    Label113: TLabel;
    Label112: TLabel;
    Label111: TLabel;
    Label110: TLabel;
    Label109: TLabel;
    Label108: TLabel;
    Label107: TLabel;
    Label106: TLabel;
    Label105: TLabel;
    Label104: TLabel;
    Label103: TLabel;
    Label102: TLabel;
    Label101: TLabel;
    Label100: TLabel;
    pnl_main: TPanel;
    grp_asientos: TGroupBox;
    grp_cuales: TGroupBox;
    lbledt_cuales: TLabeledEdit;
    stg_listaOcupantes: TStringGrid;
    lbledt_tipo: TLabeledEdit;
    lblEdt_cuantos: TLabeledEdit;
    StatusBar1: TStatusBar;
    grp_corridas: TGroupBox;
    stg_corrida: TStringGrid;
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_vta_reserva: Tfrm_vta_reserva;

implementation

uses DMdb, U_venta;

var
    la_labels: labels_asientos;
    lq_query: TSQLQuery;
{$R *.dfm}

procedure Tfrm_vta_reserva.Action1Execute(Sender: TObject);
begin
    Close;
end;

end.
