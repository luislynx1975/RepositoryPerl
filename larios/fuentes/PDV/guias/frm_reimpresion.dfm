object frm_reimprimeguia: Tfrm_reimprimeguia
  Left = 187
  Top = 132
  BorderIcons = []
  Caption = 'Reimpresion de Guias despachadas'
  ClientHeight = 534
  ClientWidth = 1137
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1137
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
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 297
    Height = 488
    Align = alLeft
    TabOrder = 1
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 295
      Height = 83
      Align = alTop
      Caption = 'Datos reimpresion Guia'
      TabOrder = 0
      object Label2: TLabel
        Left = 6
        Top = 45
        Width = 36
        Height = 13
        Caption = 'Fecha :'
      end
      object medt_fecha: TMaskEdit
        Left = 60
        Top = 42
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
        OnEnter = medt_fechaEnter
        OnExit = medt_fechaExit
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 84
      Width = 295
      Height = 176
      Align = alTop
      Caption = 'Datos guia'
      TabOrder = 1
      Visible = False
      object Label1: TLabel
        Left = 29
        Top = 68
        Width = 47
        Height = 13
        Caption = 'Autobus :'
      end
      object Label3: TLabel
        Left = 21
        Top = 95
        Width = 54
        Height = 13
        Caption = 'Conductor:'
      end
      object Label4: TLabel
        Left = 5
        Top = 123
        Width = 72
        Height = 13
        Caption = 'Folio Boletera :'
      end
      object stg_datosGuia: TStringGrid
        Left = 2
        Top = 15
        Width = 291
        Height = 47
        Align = alTop
        Color = clCream
        ColCount = 2
        DefaultRowHeight = 19
        Enabled = False
        RowCount = 2
        FixedRows = 0
        TabOrder = 4
        ColWidths = (
          140
          121)
      end
      object cmb_autobus: TlsComboBox
        Left = 78
        Top = 65
        Width = 200
        Height = 21
        AutoDropDown = True
        TabOrder = 0
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object cmb_operador1: TlsComboBox
        Left = 78
        Top = 92
        Width = 215
        Height = 21
        AutoDropDown = True
        TabOrder = 1
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ActionMainMenuBar2: TActionMainMenuBar
        Left = 2
        Top = 147
        Width = 291
        Height = 27
        UseSystemFont = False
        ActionManager = ActionManager1
        Align = alBottom
        Caption = 'ActionMainMenuBar2'
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
      object edt_boletera: TEdit
        Left = 83
        Top = 119
        Width = 121
        Height = 21
        TabOrder = 2
        OnChange = edt_boleteraChange
      end
    end
  end
  object Panel2: TPanel
    Left = 297
    Top = 27
    Width = 840
    Height = 488
    Align = alClient
    TabOrder = 2
    ExplicitTop = 25
    ExplicitWidth = 850
    ExplicitHeight = 500
    object stg_despacho: TStringGrid
      Left = 1
      Top = 1
      Width = 848
      Height = 498
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
      TabOrder = 0
      OnKeyPress = stg_despachoKeyPress
      OnKeyUp = stg_despachoKeyUp
      OnSelectCell = stg_despachoSelectCell
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
    Top = 515
    Width = 1137
    Height = 19
    Panels = <
      item
        Text = 'F1 : Buscar por fecha'
        Width = 50
      end>
    ExplicitTop = 525
    ExplicitWidth = 1147
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
      end
      item
        Items = <
          item
            Action = acReimprime
            Caption = '&Reimprime'
            ImageIndex = 27
            ShortCut = 16457
          end>
        ActionBar = ActionMainMenuBar2
      end>
    Images = DM.img_iconos
    Left = 336
    Top = 104
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action1Execute
    end
    object acReimprime: TAction
      Caption = 'Reimprime'
      ImageIndex = 27
      ShortCut = 16457
      OnExecute = acReimprimeExecute
    end
  end
end
