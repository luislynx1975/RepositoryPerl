object frm_cancela_new: Tfrm_cancela_new
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Cancelacion de reservaciones'
  ClientHeight = 496
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 929
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 27
    Width = 177
    Height = 450
    Align = alLeft
    TabOrder = 1
    ExplicitTop = 25
    ExplicitHeight = 453
    object Label1: TLabel
      Left = 8
      Top = 39
      Width = 36
      Height = 13
      Caption = 'Fecha :'
    end
    object medt_fecha: TMaskEdit
      Left = 50
      Top = 36
      Width = 120
      Height = 21
      EditMask = '!99/99/9999;1;_'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      MaxLength = 10
      ParentFont = False
      TabOrder = 0
      Text = '  /  /    '
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 477
    Width = 929
    Height = 19
    Panels = <
      item
        Text = 'F1 -  Busca reservacion'
        Width = 200
      end
      item
        Text = 'F3 - Regresa a fecha'
        Width = 50
      end>
    ExplicitTop = 478
    ExplicitWidth = 933
  end
  object grp_corridas: TGroupBox
    Left = 177
    Top = 27
    Width = 752
    Height = 450
    Align = alClient
    Caption = 'Corridas'
    TabOrder = 3
    ExplicitTop = 25
    ExplicitWidth = 756
    ExplicitHeight = 453
    object stg_corrida: TStringGrid
      Left = 2
      Top = 15
      Width = 752
      Height = 436
      Align = alClient
      ColCount = 8
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentFont = False
      TabOrder = 0
      OnKeyPress = stg_corridaKeyPress
      ColWidths = (
        93
        111
        127
        130
        106
        64
        64
        64)
    end
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
    Left = 48
    Top = 248
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
