object frm_corrida_libera: Tfrm_corrida_libera
  Left = 326
  Top = 183
  BorderIcons = []
  Caption = 'Liberacion de corridas apartadas'
  ClientHeight = 508
  ClientWidth = 606
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
  object grp_corridas: TGroupBox
    Left = 0
    Top = 45
    Width = 606
    Height = 444
    Align = alClient
    Caption = 'Corrida a liberar'
    TabOrder = 0
    ExplicitWidth = 602
    ExplicitHeight = 443
    object stg_corrida: TStringGrid
      Left = 2
      Top = 15
      Width = 602
      Height = 427
      Hint = 'con boton derrecho del raton para liberar las corridas'
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
      PopupMenu = PopupMenu1
      ShowHint = True
      TabOrder = 0
      OnMouseDown = stg_corridaMouseDown
      ExplicitWidth = 598
      ExplicitHeight = 426
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
        64
        64
        64)
    end
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 606
    Height = 45
    AutoSize = True
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 41
        Width = 600
      end>
    ShowText = False
    ExplicitWidth = 602
    object ToolBar1: TToolBar
      Left = 11
      Top = 0
      Width = 591
      Height = 41
      ButtonHeight = 36
      ButtonWidth = 27
      Caption = 'ToolBar1'
      Images = DM.img_iconos
      ShowCaptions = True
      TabOrder = 0
      object ToolButton1: TToolButton
        Left = 0
        Top = 0
        Action = ac99
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 489
    Width = 606
    Height = 19
    Panels = <
      item
        Text = 'con boton derrecho del raton para liberar las corridas'
        Width = 50
      end>
    ExplicitTop = 488
    ExplicitWidth = 602
  end
  object PopupMenu1: TPopupMenu
    Left = 312
    Top = 256
    object Liberarcorrida1: TMenuItem
      Action = ac159
    end
    object Liberatodascorridas1: TMenuItem
      Caption = 'Libera todas corridas'
      OnClick = Liberatodascorridas1Click
    end
  end
  object ActionList1: TActionList
    Images = DM.img_iconos
    Left = 408
    Top = 176
    object ac159: TAction
      Tag = 159
      Caption = 'Liberar corrida'
      ImageIndex = 3
      OnExecute = ac159Execute
    end
    object ac99: TAction
      Tag = 99
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = ac99Execute
    end
  end
  object Timer: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerTimer
    Left = 104
    Top = 216
  end
end
