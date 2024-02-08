object frm_status_corrida: Tfrm_status_corrida
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Pantalla para actualizar corridas'
  ClientHeight = 551
  ClientWidth = 639
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
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 639
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
  object grp_corridas: TGroupBox
    Left = 0
    Top = 27
    Width = 639
    Height = 505
    Align = alClient
    TabOrder = 1
    ExplicitTop = 26
    ExplicitWidth = 649
    ExplicitHeight = 516
    object stg_despacho: TStringGrid
      Left = 2
      Top = 15
      Width = 645
      Height = 499
      Hint = 'Seleccion la corrida y elija la opcion del menu '
      Align = alClient
      ColCount = 14
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
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnKeyUp = stg_despachoKeyUp
      OnMouseDown = stg_despachoMouseDown
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
        64
        103
        64
        64)
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 532
    Width = 639
    Height = 19
    Panels = <
      item
        Text = 'Seleccione la corrida y elija la opcion del menu'
        Width = 50
      end>
    ExplicitTop = 542
    ExplicitWidth = 649
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = acSalir
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end
          item
            Action = acAbrir
            Caption = '&Abrir Corrida'
            ImageIndex = 43
          end
          item
            Action = acPredespachar
            Caption = '&Predespachar Corrida'
            ImageIndex = 47
          end
          item
            Action = acCerrar
            Caption = '&Cerrar Corrida'
            ImageIndex = 46
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 424
    Top = 104
    StyleName = 'Platform Default'
    object acSalir: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = acSalirExecute
    end
    object acCerrar: TAction
      Caption = 'Cerrar Corrida'
      Enabled = False
      ImageIndex = 46
      OnExecute = acCerrarExecute
    end
    object acAbrir: TAction
      Caption = 'Abrir Corrida'
      Enabled = False
      ImageIndex = 43
      OnExecute = acAbrirExecute
    end
    object acPredespachar: TAction
      Caption = 'Predespachar Corrida'
      Enabled = False
      ImageIndex = 47
      OnExecute = acPredespacharExecute
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = TimerTimer
    Left = 352
    Top = 224
  end
end
