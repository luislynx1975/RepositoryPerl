object frm_relacion_terminal: Tfrm_relacion_terminal
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'frm_relacion_terminal'
  ClientHeight = 421
  ClientWidth = 331
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
    Left = 26
    Top = 37
    Width = 45
    Height = 13
    Caption = 'Agencia :'
  end
  object Label2: TLabel
    Left = 24
    Top = 64
    Width = 47
    Height = 13
    Caption = 'Terminal :'
  end
  object stg_agencia_terminal: TStringGrid
    Left = 0
    Top = 78
    Width = 331
    Height = 343
    Align = alBottom
    ColCount = 4
    DefaultRowHeight = 20
    FixedCols = 0
    RowCount = 2
    TabOrder = 0
    ExplicitTop = 88
    ExplicitWidth = 341
    ColWidths = (
      165
      148
      64
      64)
  end
  object ls_agencia: TlsComboBox
    Left = 78
    Top = 34
    Width = 258
    Height = 21
    TabOrder = 1
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object ls_terminal: TlsComboBox
    Left = 78
    Top = 61
    Width = 258
    Height = 21
    TabOrder = 2
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 331
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
            Action = Action1
            Caption = '&Asignar'
            ImageIndex = 17
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
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 168
    Top = 192
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Asignar'
      ImageIndex = 17
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
