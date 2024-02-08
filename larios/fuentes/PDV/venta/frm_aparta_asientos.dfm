object frm_aparta_lugares: Tfrm_aparta_lugares
  Left = 495
  Top = 411
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Pantalla para apartar asientos'
  ClientHeight = 235
  ClientWidth = 464
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 27
    Width = 464
    Height = 104
    Align = alTop
    Caption = 'Datos de la corrida'
    TabOrder = 0
    ExplicitTop = 25
    ExplicitWidth = 472
    object stg_corrida: TStringGrid
      Left = 2
      Top = 15
      Width = 468
      Height = 87
      Align = alClient
      ColCount = 14
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      ScrollBars = ssNone
      TabOrder = 0
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 464
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
  object GroupBox2: TGroupBox
    Left = 0
    Top = 130
    Width = 464
    Height = 105
    Align = alBottom
    Caption = 'Reservacion no liberables'
    TabOrder = 2
    ExplicitTop = 132
    ExplicitWidth = 472
    object Label1: TLabel
      Left = 8
      Top = 31
      Width = 87
      Height = 13
      Caption = 'Asientos apartar :'
    end
    object lbledt_cuales: TEdit
      Left = 101
      Top = 28
      Width = 121
      Height = 21
      TabOrder = 0
      OnChange = lbledt_cualesChange
      OnKeyPress = lbledt_cualesKeyPress
    end
  end
  object lsComboBox1: TlsComboBox
    Left = 228
    Top = 160
    Width = 145
    Height = 21
    TabOrder = 3
    Visible = False
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action1
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 232
    Top = 48
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action1Execute
    end
  end
end
