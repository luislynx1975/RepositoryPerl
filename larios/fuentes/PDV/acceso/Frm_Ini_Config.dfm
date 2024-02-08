object Frm_Ini: TFrm_Ini
  Left = 268
  Top = 243
  BorderIcons = []
  Caption = 'Configuracion de acceso a la Base Datos'
  ClientHeight = 206
  ClientWidth = 512
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 45
    Width = 265
    Height = 142
    Align = alLeft
    Caption = 'Datos Locales del cliente :'
    TabOrder = 0
    ExplicitHeight = 151
    object Label1: TLabel
      Left = 67
      Top = 24
      Width = 45
      Height = 13
      Caption = 'IP Local :'
    end
    object Label2: TLabel
      Left = 63
      Top = 48
      Width = 52
      Height = 13
      Caption = 'Localidad :'
    end
    object Label3: TLabel
      Left = 21
      Top = 73
      Width = 94
      Height = 13
      Caption = 'Numero de Equipo :'
    end
    object Label9: TLabel
      Left = 40
      Top = 119
      Width = 75
      Height = 13
      Caption = 'Clave Agencia :'
    end
    object Edit_iplocal: TEdit
      Left = 118
      Top = 18
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 0
    end
    object Edit_localidad: TEdit
      Left = 118
      Top = 43
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
    end
    object Edit_NoClient: TEdit
      Left = 119
      Top = 69
      Width = 121
      Height = 21
      TabOrder = 2
    end
    object ch_agencia: TCheckBox
      Left = 66
      Top = 96
      Width = 67
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Agencia :'
      TabOrder = 3
    end
    object edt_agencia: TEdit
      Left = 121
      Top = 116
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 4
    end
  end
  object GroupBox2: TGroupBox
    Left = 264
    Top = 45
    Width = 248
    Height = 142
    Align = alRight
    Caption = 'Datos del servidor :'
    TabOrder = 1
    ExplicitLeft = 270
    ExplicitHeight = 151
    object Label4: TLabel
      Left = 25
      Top = 20
      Width = 76
      Height = 13
      Caption = 'Base de Datos :'
    end
    object Label5: TLabel
      Left = 40
      Top = 52
      Width = 60
      Height = 13
      Caption = 'Usuario DB :'
    end
    object Label6: TLabel
      Left = 30
      Top = 83
      Width = 70
      Height = 13
      Caption = 'Password DB :'
    end
    object Label7: TLabel
      Left = 51
      Top = 114
      Width = 50
      Height = 13
      Caption = 'IP Server :'
    end
    object Edit_dbase: TEdit
      Left = 104
      Top = 16
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      PasswordChar = '*'
      TabOrder = 0
      Text = 'CORPORATIVO'
    end
    object Edit_user: TEdit
      Left = 105
      Top = 43
      Width = 121
      Height = 21
      Enabled = False
      PasswordChar = '*'
      TabOrder = 1
      Text = 'usuariosDB'
    end
    object Edit_pass: TEdit
      Left = 104
      Top = 80
      Width = 121
      Height = 21
      Enabled = False
      PasswordChar = '*'
      TabOrder = 2
      Text = 'PasswordDB'
    end
    object Edit_Server: TEdit
      Left = 104
      Top = 110
      Width = 121
      Height = 21
      TabOrder = 3
    end
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 512
    Height = 45
    AutoSize = True
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 41
        Width = 516
      end>
    ShowText = False
    ExplicitWidth = 518
    object ToolBar1: TToolBar
      Left = 11
      Top = 0
      Width = 503
      Height = 41
      ButtonHeight = 36
      ButtonWidth = 45
      Caption = 'ToolBar1'
      Images = DM.img_iconos
      ShowCaptions = True
      TabOrder = 0
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Action = ac99
      end
      object ToolButton2: TToolButton
        Left = 45
        Top = 0
        Action = ac999
      end
    end
  end
  object lsStatusBar1: TlsStatusBar
    Left = 0
    Top = 187
    Width = 512
    Height = 19
    Panels = <>
    ExplicitTop = 196
    ExplicitWidth = 518
  end
  object ActionList1: TActionList
    Images = DM.img_iconos
    Left = 248
    Top = 64
    object ac99: TAction
      Tag = 99
      Caption = 'Guardar'
      Hint = 'Guardar'
      ImageIndex = 17
      ShortCut = 16455
      OnExecute = ac99Execute
    end
    object ac999: TAction
      Tag = 99
      Caption = 'Salir'
      Hint = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = ac999Execute
    end
  end
end
