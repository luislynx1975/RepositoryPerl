object Frm_usuarios: TFrm_usuarios
  Left = 287
  Top = 154
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Registro de usuarios'
  ClientHeight = 596
  ClientWidth = 384
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 27
    Width = 384
    Height = 68
    Align = alTop
    Caption = 'Empleado:'
    TabOrder = 0
    ExplicitTop = 29
    ExplicitWidth = 388
    object Label1: TLabel
      Left = 16
      Top = 19
      Width = 109
      Height = 13
      Caption = 'Nombre del empleado :'
    end
    object lsCombo_emp: TlsComboBox
      Left = 16
      Top = 40
      Width = 337
      Height = 21
      AutoComplete = False
      TabOrder = 0
      OnClick = lsCombo_empClick
      OnExit = lsCombo_empExit
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 95
    Width = 384
    Height = 58
    Align = alTop
    Caption = 'Grupo :'
    TabOrder = 1
    ExplicitTop = 97
    ExplicitWidth = 388
    object Label3: TLabel
      Left = 16
      Top = 15
      Width = 84
      Height = 13
      Caption = 'Nombre del grupo'
    end
    object lsCombo_grupo: TlsComboBox
      Left = 16
      Top = 32
      Width = 337
      Height = 21
      AutoComplete = False
      TabOrder = 0
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object GroupBox3: TGroupBox
    Left = 0
    Top = 153
    Width = 384
    Height = 186
    Align = alTop
    TabOrder = 2
    ExplicitTop = 152
    ExplicitWidth = 394
    object Label4: TLabel
      Left = 40
      Top = 93
      Width = 74
      Height = 13
      Caption = 'Fecha de baja :'
      Visible = False
    end
    object Ledit_login: TLabeledEdit
      Left = 40
      Top = 24
      Width = 121
      Height = 21
      EditLabel.Width = 32
      EditLabel.Height = 13
      EditLabel.Caption = 'Login :'
      Enabled = False
      TabOrder = 0
      Text = ''
    end
    object Ledit_pass: TLabeledEdit
      Left = 40
      Top = 65
      Width = 121
      Height = 21
      EditLabel.Width = 52
      EditLabel.Height = 13
      EditLabel.Caption = 'Password :'
      PasswordChar = '*'
      TabOrder = 1
      Text = ''
    end
    object Dtp_baja: TDateTimePicker
      Left = 40
      Top = 109
      Width = 186
      Height = 21
      Date = 44894.000000000000000000
      Time = 0.411930856476828900
      Enabled = False
      TabOrder = 2
      Visible = False
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 339
    Width = 384
    Height = 249
    Align = alTop
    Caption = 'Grupos'
    TabOrder = 3
    ExplicitTop = 338
    ExplicitWidth = 394
    object stg_usuarios: TStringGrid
      Left = 2
      Top = 15
      Width = 390
      Height = 232
      Align = alClient
      ColCount = 3
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      ScrollBars = ssVertical
      TabOrder = 0
      OnSelectCell = stg_usuariosSelectCell
      ColWidths = (
        87
        171
        114)
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 384
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
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = ac106
            Caption = '&Nuevo'
            ImageIndex = 16
            ShortCut = 16462
          end
          item
            Action = ac106a
            Caption = '&Guardar'
            ImageIndex = 17
            ShortCut = 16455
          end
          item
            Action = ac107
            Caption = '&Actualizar'
            ImageIndex = 22
            ShortCut = 16449
          end
          item
            Action = ac150
            Caption = '&Eliminar'
            ImageIndex = 18
            ShortCut = 16453
          end
          item
            Action = acsalir
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 336
    Top = 128
    StyleName = 'Platform Default'
    object ac106: TAction
      Tag = 106
      Caption = 'Nuevo'
      ImageIndex = 16
      ShortCut = 16462
      OnExecute = ac106Execute
    end
    object ac106a: TAction
      Caption = 'Guardar'
      Enabled = False
      ImageIndex = 17
      ShortCut = 16455
      OnExecute = ac106aExecute
    end
    object ac107: TAction
      Tag = 150
      Caption = 'Actualizar'
      Enabled = False
      ImageIndex = 22
      ShortCut = 16449
      OnExecute = ac107Execute
    end
    object ac150: TAction
      Caption = 'Eliminar'
      Enabled = False
      ImageIndex = 18
      ShortCut = 16453
      OnExecute = ac150Execute
    end
    object acsalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = acSalirExecute
    end
  end
end
