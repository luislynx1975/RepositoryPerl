/////////////////////////////////////////////////////////////////////////////////
//                      Grupo Pullman de Morelos                               //
//                                                                             //
//  Sistema:     Sistema para la venta en taquillas                            //
//  Módulo:      Acceso                                                        //
//  Pantalla:    splash                                                        //
//  Descripción: Pantalla para la asignacion de permisos por grupo para la     //
//             asignacion de nuevos permisos los tags sigue seriados continuan //
//             sin existir algun dato repetido, esta inserta para dos formas   //
//             distintas para grupo y usuarios                                 //
//  Fecha:       21 de Septiembre 2009                                         //
//  Autor:       Jose Luis Larios Rodriguez                                    //
/////////////////////////////////////////////////////////////////////////////////

//ultimo cb -    123
unit Frm_grp_permiso;
interface
{$HINTS OFF}
{$WARNINGS OFF}
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ToolWin, StdCtrls, lsCombobox, ExtCtrls,
  DBClient, SimpleDS, ActnMan, ActnCtrls, ActnMenus, Data.SqlExpr,
  PlatformDefaultStyleActnCtrls, System.Actions, Data.DB;


type
  TFrm_permisos_grps = class(TForm)
    Pc_pagina: TPageControl;
    TabSheet1: TTabSheet;
    cb100: TCheckBox;
    lbAcceso: TLabel;
    cb103: TCheckBox;
    cb105: TCheckBox;
    lbAltas: TLabel;
    LbUpdate: TLabel;
    cb101: TCheckBox;
    cb102: TCheckBox;
    cb104: TCheckBox;
    cb106: TCheckBox;
    cb107: TCheckBox;
    Panel1: TPanel;
    lsCombo_grupos: TlsComboBox;
    Label5: TLabel;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cb108: TCheckBox;
    cb109: TCheckBox;
    TabSheet3: TTabSheet;
    cb110: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    cb111: TCheckBox;
    cb112: TCheckBox;
    cb113: TCheckBox;
    cb114: TCheckBox;
    cb115: TCheckBox;
    TabSheet4: TTabSheet;
    Label8: TLabel;
    Label9: TLabel;
    cb120: TCheckBox;
    cb121: TCheckBox;
    cb122: TCheckBox;
    cb123: TCheckBox;
    Label12: TLabel;
    cb116: TCheckBox;
    SimpleDataSet1: TSimpleDataSet;
    cb154: TCheckBox;
    cb155: TCheckBox;
    Label10: TLabel;
    cb157: TCheckBox;
    Label11: TLabel;
    cb156: TCheckBox;
    cb158: TCheckBox;
    Label15: TLabel;
    cb159: TCheckBox;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    cb168: TCheckBox;
    Label13: TLabel;
    Label16: TLabel;
    cb169: TCheckBox;
    TabSheet7: TTabSheet;
    cb179: TCheckBox;
    cb180: TCheckBox;
    Label17: TLabel;
    TabSheet8: TTabSheet;
    cb161: TCheckBox;
    Label18: TLabel;
    cb144: TCheckBox;
    Label19: TLabel;
    cb162: TCheckBox;
    Label20: TLabel;
    cb145: TCheckBox;
    cb163: TCheckBox;
    cb152: TCheckBox;
    cb147: TCheckBox;
    cb146: TCheckBox;
    cb164: TCheckBox;
    GroupBox1: TGroupBox;
    cb126: TCheckBox;
    Label21: TLabel;
    Label22: TLabel;
    cb129: TCheckBox;
    Label23: TLabel;
    cb130: TCheckBox;
    Label24: TLabel;
    cb132: TCheckBox;
    Label25: TLabel;
    cb133: TCheckBox;
    cb136: TCheckBox;
    CheckBox2: TCheckBox;
    Label26: TLabel;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    GroupBox2: TGroupBox;
    Label27: TLabel;
    Label28: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    cb125: TCheckBox;
    cb134: TCheckBox;
    cb142: TCheckBox;
    cb140: TCheckBox;
    cb139: TCheckBox;
    GroupBox3: TGroupBox;
    cb127: TCheckBox;
    Label29: TLabel;
    Label33: TLabel;
    cb190: TCheckBox;
    ActionManager1: TActionManager;
    ac99: TAction;
    ac104: TAction;
    ActionMainMenuBar1: TActionMainMenuBar;
    GroupBox4: TGroupBox;
    cb128: TCheckBox;
    Label35: TLabel;
    Label36: TLabel;
    cb170: TCheckBox;
    Label37: TLabel;
    cb171: TCheckBox;
    Label38: TLabel;
    cb172: TCheckBox;
    Label39: TLabel;
    cb173: TCheckBox;
    GroupBox5: TGroupBox;
    cb174: TCheckBox;
    Label40: TLabel;
    cb175: TCheckBox;
    Label41: TLabel;
    Label42: TLabel;
    cb176: TCheckBox;
    cb177: TCheckBox;
    cb178: TCheckBox;
    cb181: TCheckBox;
    Label43: TLabel;
    Label44: TLabel;
    cb182: TCheckBox;
    cb183: TCheckBox;
    Label46: TLabel;
    Label47: TLabel;
    cb153: TCheckBox;
    Label14: TLabel;
    Label48: TLabel;
    cb185: TCheckBox;
    cb184: TCheckBox;
    cb187: TCheckBox;
    Label45: TLabel;
    StatusBar1: TStatusBar;
    cb188: TCheckBox;
    Label49: TLabel;
    Label50: TLabel;
    cb189: TCheckBox;
    GroupBox6: TGroupBox;
    cb191: TCheckBox;
    Label51: TLabel;
    Label52: TLabel;
    cb192: TCheckBox;
    Label53: TLabel;
    cb193: TCheckBox;
    cb186: TCheckBox;
    cb194: TCheckBox;
    cb195: TCheckBox;
    cb196: TCheckBox;
    cb197: TCheckBox;
    cb198: TCheckBox;
    Label34: TLabel;
    cb200: TCheckBox;
    cb201: TCheckBox;
    cb202: TCheckBox;
    cb204: TCheckBox;
    cb205: TCheckBox;
    cb150: TCheckBox;
    Label54: TLabel;
    cb206: TCheckBox;
    Label55: TLabel;
    Label56: TLabel;
    cb207: TCheckBox;
    cb208: TCheckBox;
    cb209: TCheckBox;
    cb216: TCheckBox;
    Label57: TLabel;
    Label58: TLabel;
    cb217: TCheckBox;
    cb214: TCheckBox;
    cb215: TCheckBox;
    cb219: TCheckBox;
    cb218: TCheckBox;
    procedure ac99Execute(Sender: TObject);
    procedure ac104Execute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lsCombo_gruposClick(Sender: TObject);
    procedure Pc_paginaChange(Sender: TObject);
    procedure Frm_usuariosac107Execute(Sender: TObject);
    procedure Label54Click(Sender: TObject);
  private
    { Private declarations }
    FUserGroup : Integer;
    procedure checkBoxes(ids : Integer);
    procedure limpiarChecks();
    procedure getQuerys(lq_query: TSQLQuery);
    procedure insertbatch(tag : integer; lpi_grupo : integer);
  public
    { Public declarations }
     property UserGrupo : integer write FUserGroup;
  end;
var
  Frm_permisos_grps: TFrm_permisos_grps;

implementation

uses DMdb, comun, u_main;

var
    lq_query : TSQLQuery;
    ls_qry   : String;
{$R *.dfm}

{@Procedure ac99Execute
 @Params Sender : TObject
 @Descripcion Cierra la forma}
procedure TFrm_permisos_grps.ac99Execute(Sender: TObject);
begin
    Close;
end;


{@Procedure ac104Execute
@Params Sender : TObject
@Descripcion guarda los permisos otorgados al grupo, estos son almacenados
@ en la base de datos }
procedure TFrm_permisos_grps.ac104Execute(Sender: TObject);
var
    li_idx : Integer;
    lb_ok  : Boolean;
    ls_qry : String;
    ls_cadena, ls_aquien : string;
begin
    if not AccesoPermitido(104,False) then
        exit;
    if Length(lsCombo_grupos.Text) = 0 then begin
        MessageDlg(_INFORMACION_INSUFICIENTE,mtError,[mbOK],0);
        lsCombo_grupos.SetFocus;
        exit;
    end;
    lb_ok := true;
    if FUserGroup = 0 then ls_cadena := 'De permisos al grupo';
    if FUserGroup = 1 then ls_cadena := 'De permisos al usuario';

    ls_aquien := lsCombo_grupos.CurrentID;
    if Application.MessageBox(PChar(Format(_ACTUALIZAR_DATO,[ls_cadena])),
                'Atención', _CONFIRMAR) = IDYES then begin
       if FUserGroup = 0 then begin//es para grupo
         if EjecutaSQL(Format(_qry_delete_grupoP,[lsCombo_grupos.CurrentID]),lq_query,_TODOS) then begin
            for li_idx := 0 to Self.ComponentCount - 1 do
               if ((Components[li_idx].Tag >= 100) and (copy(Components[li_idx].Name,1,2) = 'cb') and
                  (TCheckBox(FindComponent('cb'+IntToStr(Components[li_idx].Tag))).Checked = true)) then
                   if EjecutaSQL(Format(_qry_agrega_grupoP,[lsCombo_grupos.CurrentID,IntToStr(Components[li_idx].Tag)]),
                      lq_query,_TODOS) then begin//actualizar la tabla de pdv_c_privilegio_c_usuario
                      insertaEvento(gs_trabid,gs_terminal,'Inserta permiso :' + IntToStr(Components[li_idx].Tag) + ' user :' +
                                    lsCombo_grupos.CurrentID + ' Al grupo : '+ ls_aquien
                                   );
                      lb_ok := true;
                   end else lb_ok := False;
            end;//fin for
       end else begin
          if EjecutaSQL(format(_qry_priv_user_delete,[lsCombo_grupos.CurrentID]),lq_query,_TODOS)then
            for li_idx := 0 to Self.ComponentCount - 1 do
               if ((Components[li_idx].Tag >= 100) and (copy(Components[li_idx].Name,1,2) = 'cb') and
                  (TCheckBox(FindComponent('cb'+IntToStr(Components[li_idx].Tag))).Checked = true)) then begin
                  if EjecutaSQL(Format(_qry_priv_user_insert,[IntToStr(Components[li_idx].Tag),''''+
                                                              lsCombo_grupos.CurrentID +'''']), lq_query,_TODOS)then begin
                      insertaEvento(gs_trabid,gs_terminal,'Inserta permiso :' + IntToStr(Components[li_idx].Tag) + ' user :' +
                                    lsCombo_grupos.CurrentID + ' A quien : '+ ls_aquien
                                   );
                      lb_ok := true
                  end else lb_ok := false;
              end;//fin 'cb'
       end;
       if lb_ok then
         MessageDlg(_OPERACION_SATISFACTORIA,mtInformation,[mbOK],0);
       limpiarChecks();
       ListaFill();
    end;
end;

{@Procedure insertbatch
@Params tag : integer;
@Params lpi_grupo : integer
@Descripcion generamos un script para que sea ejecuta como transaccion para insertar}
procedure TFrm_permisos_grps.insertbatch( tag : integer; lpi_grupo : integer);
var
   lqp_qry1 : TSQLQuery;
   ls_qry   : String;
begin
    if EjecutaSQL(format(_qry_UserEqualsGroupUnique,[IntToStr(lpi_grupo)]),lq_query,_LOCAL)then
    with lq_query do begin
      First;
      ls_qry := 'START TRANSACTION WITH CONSISTENT SNAPSHOT; ';
      while not EoF do begin
          ls_qry := ls_qry +
                  Format(_qry_priv_user_insert,[IntToStr(Tag),lq_query['ID_EMPLEADO']]);
          next;
      end;
    end;
    lqp_qry1 := TSQLQuery.Create(nil);
    lqp_qry1.SQLConnection := DM.Conecta;
    if EjecutaSQL(ls_qry,lqp_qry1,_LOCAL)then

end;


procedure TFrm_permisos_grps.Label54Click(Sender: TObject);
begin

end;

{@Procedure getQuerys
@Params lq_query: TZReadOnlyQuery
@Descripcion generamos un script para que sea ejecuta como transaccion para borrar}
procedure TFrm_permisos_grps.getQuerys(lq_query: TSQLQuery);
var
    ls_out : WideString;
    ls_inp : WideString;
begin
     with lq_query do begin
        First;
        ls_out := 'START TRANSACTION WITH CONSISTENT SNAPSHOT; ';
        while not EoF do begin
            ls_out := ls_out + Format(_qry_userprivi_delete,[lq_query['ID_PRIVILEGIO'], lq_query['ID_EMPLEADO']]);
            next;
        end;
     end;
     if EjecutaSQL(ls_out,lq_query,_TODOS) then
end;


{@Procedure lsCombo_gruposClick
@Params Sender : TObject
@Descripcion Solicita la informacion de la base y es desplegada en un
@ lscombobox, el cual maneja la informacion por clave y valor, ademas
@ crea los componentes necesarios y FormClose son liberados}
procedure TFrm_permisos_grps.FormShow(Sender: TObject);
begin
    try
        lq_query := TSQLQuery.Create(Self);
        lq_query.SQLConnection := DM.Conecta;
        if FUserGroup = 0 then begin//selecciona el grupo
          if EjecutaSQL(_qry_grupos_select,lq_query,_LOCAL) then
            LlenarComboBox(lq_query,lsCombo_grupos,false);
          Label5.Caption := 'Grupo :';
          Frm_permisos_grps.Caption := Frm_permisos_grps.Caption + ' de grupos';
        end else begin
                  if EjecutaSQL(_qry_usuario_all,lq_query,_LOCAL)then begin
                      LlenarComboBox(lq_query,lsCombo_grupos,true);
                      Label5.Caption := 'Usuario :';
                     Frm_permisos_grps.Caption := Frm_permisos_grps.Caption + ' de usuarios';
                  end;
        end;
    except
        lq_query.Free;
        lq_query := nil;
    end;
end;


procedure TFrm_permisos_grps.Frm_usuariosac107Execute(Sender: TObject);
begin

end;

{@Procedure FormClose
@Params Sender : TObject
@Descripcion Cierra la forma y libera los componentes creados en la forma}
procedure TFrm_permisos_grps.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    lq_query.Free;
    lq_query := nil;
end;


{@Procedure lsCombo_gruposClick
@Params Sender : TObject
@Descripcion poner una marca en los checkbox los que tienen permiso
@ en su habilitacion}
procedure TFrm_permisos_grps.lsCombo_gruposClick(Sender: TObject);
var
    ls_name : String;
    li_idx  : Integer;
    ls_qry  : String;
begin
    if FUserGroup = 0 then ls_qry := Format(_qry_busca_grupoP,[lsCombo_grupos.CurrentID])
    else ls_qry := Format(_qry_busca_usuarioP,[lsCombo_grupos.CurrentID,lsCombo_grupos.CurrentID]);
      if EjecutaSQL(ls_qry,lq_query,_LOCAL) then begin
        limpiarChecks();
        with lq_query do begin
            First;
            while not EoF do begin
                ls_name := 'cb'+ IntToStr(lq_query.Fields[1].AsInteger);
                try
                  li_idx := 0;
                  checkBoxes(lq_query['ID_PRIVILEGIO']);
                except
                end;
                next;
            end;
        end;
      end;
end;


procedure TFrm_permisos_grps.Pc_paginaChange(Sender: TObject);
begin

end;

{@Procedure checkBoxes
@Params ids : Integer
@Descripcion Ponen el componente checkbox como habilitado}
procedure TFrm_permisos_grps.checkBoxes(ids : Integer);
begin
    try
        TCheckBox(FindComponent('cb'+IntToStr(ids))).Checked := true;
    except
    end;
end;


procedure TFrm_permisos_grps.limpiarChecks;
var
    li_idx : Integer;
begin
    for li_idx := 0 to Self.ComponentCount - 1 do begin
       if ((Components[li_idx].Tag >= 100) and (copy(Components[li_idx].Name,1,2) = 'cb') and
          (TCheckBox(FindComponent('cb'+IntToStr(Components[li_idx].Tag))).Checked = true)) then
            TCheckBox(FindComponent('cb'+IntToStr(Components[li_idx].Tag))).Checked := False;
    end;
end;



end.
