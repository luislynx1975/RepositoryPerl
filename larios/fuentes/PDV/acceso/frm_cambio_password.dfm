object Frm_contrasena: TFrm_contrasena
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Cambio de password'
  ClientHeight = 215
  ClientWidth = 413
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  PrintScale = poNone
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 413
    Height = 188
    Align = alClient
    AutoSize = True
    BorderStyle = bsSingle
    TabOrder = 0
    ExplicitTop = 29
    ExplicitWidth = 417
    ExplicitHeight = 187
    object Label1: TLabel
      Left = 24
      Top = 8
      Width = 43
      Height = 13
      Caption = 'Usuario :'
    end
    object lbl_passd: TLabeledEdit
      Left = 88
      Top = 56
      Width = 121
      Height = 21
      EditLabel.Width = 87
      EditLabel.Height = 13
      EditLabel.Caption = 'Password anterior'
      PasswordChar = '*'
      TabOrder = 1
      Text = ''
    end
    object lbledt_password1: TLabeledEdit
      Left = 88
      Top = 107
      Width = 121
      Height = 21
      EditLabel.Width = 80
      EditLabel.Height = 13
      EditLabel.Caption = 'Nuevo Password'
      PasswordChar = '*'
      TabOrder = 2
      Text = ''
    end
    object lbledt_password2: TLabeledEdit
      Left = 88
      Top = 150
      Width = 121
      Height = 21
      EditLabel.Width = 136
      EditLabel.Height = 13
      EditLabel.Caption = 'Confirme el nuevo password'
      PasswordChar = '*'
      TabOrder = 3
      Text = ''
    end
    object ls_empleado: TlsComboBox
      Left = 88
      Top = 5
      Width = 313
      Height = 21
      TabOrder = 0
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 413
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
            Action = acGuardar
            Caption = 'A&ctualizar'
            ImageIndex = 17
            ShortCut = 16455
          end
          item
            Action = acSalir
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 320
    Top = 56
    StyleName = 'Platform Default'
    object acGuardar: TAction
      Caption = 'Actualizar'
      ImageIndex = 17
      ShortCut = 16455
      OnExecute = acGuardarExecute
    end
    object acSalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = acSalirExecute
    end
  end
end
