object frm_pass_nuevo: Tfrm_pass_nuevo
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Cambio de contrase'#241'a'
  ClientHeight = 201
  ClientWidth = 374
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 374
    Height = 174
    Align = alClient
    AutoSize = True
    BorderStyle = bsSingle
    TabOrder = 0
    ExplicitWidth = 416
    ExplicitHeight = 160
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object lbl_passd: TLabeledEdit
      Left = 65
      Top = 41
      Width = 121
      Height = 21
      EditLabel.Width = 87
      EditLabel.Height = 13
      EditLabel.Caption = 'Password anterior'
      PasswordChar = '*'
      TabOrder = 0
      Text = ''
      OnKeyDown = lbl_passdKeyDown
    end
    object lbledt_password1: TLabeledEdit
      Left = 65
      Top = 92
      Width = 121
      Height = 21
      EditLabel.Width = 80
      EditLabel.Height = 13
      EditLabel.Caption = 'Nuevo Password'
      PasswordChar = '*'
      TabOrder = 1
      Text = ''
      OnKeyDown = lbledt_password1KeyDown
    end
    object lbledt_password2: TLabeledEdit
      Left = 65
      Top = 135
      Width = 121
      Height = 21
      EditLabel.Width = 136
      EditLabel.Height = 13
      EditLabel.Caption = 'Confirme el nuevo password'
      PasswordChar = '*'
      TabOrder = 2
      Text = ''
      OnKeyDown = lbledt_password2KeyDown
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 374
    Height = 27
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = '&Actualizar'
            ImageIndex = 22
            ShortCut = 16449
          end
          item
            Action = Action2
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 296
    Top = 64
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Actualizar'
      ImageIndex = 22
      ShortCut = 16449
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action2Execute
    end
  end
end
