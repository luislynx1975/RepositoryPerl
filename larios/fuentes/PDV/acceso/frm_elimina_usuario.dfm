object frm_usuario_baja: Tfrm_usuario_baja
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Pantalla para eliminar usuarios'
  ClientHeight = 209
  ClientWidth = 488
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 41
    Width = 43
    Height = 13
    Caption = 'Usuario :'
  end
  object Label2: TLabel
    Left = 66
    Top = 86
    Width = 43
    Height = 13
    Caption = 'Estatus :'
  end
  object Label3: TLabel
    Left = 24
    Top = 108
    Width = 85
    Height = 13
    Caption = 'Apellido Paterno :'
  end
  object Label4: TLabel
    Left = 22
    Top = 129
    Width = 87
    Height = 13
    Caption = 'Apellido Materno :'
  end
  object Label5: TLabel
    Left = 52
    Top = 149
    Width = 57
    Height = 13
    Caption = 'Nombre(s) :'
  end
  object Label6: TLabel
    Left = 9
    Top = 64
    Width = 100
    Height = 13
    Caption = 'Clave del empleado :'
  end
  object cmb_users: TlsComboBox
    Left = 59
    Top = 38
    Width = 327
    Height = 21
    AutoDropDown = True
    DropDownCount = 12
    TabOrder = 0
    OnClick = cmb_usersClick
    Complete = False
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object edt_status: TEdit
    Left = 115
    Top = 83
    Width = 151
    Height = 21
    Enabled = False
    TabOrder = 1
  end
  object edt_paterno: TEdit
    Left = 115
    Top = 105
    Width = 151
    Height = 21
    Enabled = False
    TabOrder = 2
  end
  object edt_materno: TEdit
    Left = 115
    Top = 126
    Width = 151
    Height = 21
    Enabled = False
    TabOrder = 3
  end
  object edt_nombre: TEdit
    Left = 115
    Top = 148
    Width = 151
    Height = 21
    Enabled = False
    TabOrder = 4
  end
  object edt_trabid: TEdit
    Left = 115
    Top = 61
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 5
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 488
    Height = 27
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 190
    Width = 488
    Height = 19
    Panels = <>
    ExplicitTop = 200
    ExplicitWidth = 498
  end
  object cb_todas: TCheckBox
    Left = 62
    Top = 169
    Width = 66
    Height = 24
    Alignment = taLeftJustify
    Caption = 'Todas las bases :'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 8
    WordWrap = True
  end
  object cbEstatus: TCheckBox
    Left = 393
    Top = 38
    Width = 62
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Baja :'
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 9
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = '&Eliminar'
            ImageIndex = 14
          end
          item
            Action = Action2
            Caption = '&Salir'
            ImageIndex = 15
          end>
        ActionBar = ActionMainMenuBar1
      end>
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 341
    Top = 153
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Eliminar'
      ImageIndex = 14
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Salir'
      ImageIndex = 15
      OnExecute = Action2Execute
    end
  end
end
