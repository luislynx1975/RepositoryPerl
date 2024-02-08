object Frm_corrida_agrupa: TFrm_corrida_agrupa
  Left = 0
  Top = 0
  Caption = 'Corrida disponible para agrupar'
  ClientHeight = 463
  ClientWidth = 482
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object grp_corridas: TGroupBox
    Left = 0
    Top = 115
    Width = 482
    Height = 348
    Align = alClient
    Caption = 'Corridas disponibles para agrupar'
    TabOrder = 0
    ExplicitTop = 113
    ExplicitWidth = 492
    ExplicitHeight = 360
    object stg_corrida: TStringGrid
      Left = 2
      Top = 15
      Width = 488
      Height = 324
      Align = alClient
      ColCount = 11
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentFont = False
      TabOrder = 0
      OnKeyPress = stg_corridaKeyPress
      OnMouseDown = stg_corridaMouseDown
      ColWidths = (
        93
        111
        127
        130
        106
        64
        64
        64
        64
        64
        64)
    end
    object StatusBar1: TStatusBar
      Left = 2
      Top = 339
      Width = 488
      Height = 19
      Panels = <
        item
          Text = 'Seleccione la corrida agrupar y presione la tecla "Enter"'
          Width = 50
        end>
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 27
    Width = 482
    Height = 88
    Align = alTop
    Caption = 'Corrida origen para agrupar'
    TabOrder = 1
    ExplicitTop = 25
    ExplicitWidth = 492
    object stg_origen_agrupa: TStringGrid
      Left = 2
      Top = 15
      Width = 488
      Height = 71
      Align = alClient
      ColCount = 11
      DefaultRowHeight = 20
      Enabled = False
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ParentFont = False
      TabOrder = 0
      ColWidths = (
        93
        111
        127
        130
        106
        64
        64
        64
        64
        64
        64)
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 482
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
            Items = <
              item
                Action = ac99
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 240
    Top = 240
    StyleName = 'Platform Default'
    object ac99: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = ac99Execute
    end
  end
end
