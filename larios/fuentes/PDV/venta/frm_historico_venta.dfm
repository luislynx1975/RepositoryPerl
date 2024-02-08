object frm_historico: Tfrm_historico
  Left = 234
  Top = 84
  Caption = 'Registro historico de venta'
  ClientHeight = 711
  ClientWidth = 1012
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 216
    Height = 684
    Align = alLeft
    BorderStyle = bsSingle
    TabOrder = 0
    ExplicitTop = 29
    ExplicitHeight = 674
    object Gr_Corridas: TGroupBox
      Left = 1
      Top = 1
      Width = 210
      Height = 104
      Align = alTop
      Caption = 'Datos Venta :'
      TabOrder = 0
      object Label1: TLabel
        Left = 3
        Top = 22
        Width = 75
        Height = 13
        Caption = 'Ciudad Origen :'
      end
      object Label2: TLabel
        Left = 3
        Top = 46
        Width = 36
        Height = 13
        Caption = 'Fecha :'
      end
      object Label4: TLabel
        Left = 3
        Top = 69
        Width = 39
        Height = 13
        Caption = 'Origen :'
      end
      object ls_Origen_vta: TlsComboBox
        Left = 57
        Top = 67
        Width = 152
        Height = 21
        Style = csSimple
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ls_Origen: TlsComboBox
        Left = 79
        Top = 16
        Width = 114
        Height = 21
        Style = csSimple
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object medt_fecha: TMaskEdit
        Left = 57
        Top = 43
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
        TabOrder = 1
        Text = '  /  /    '
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 105
      Width = 210
      Height = 574
      Align = alClient
      Caption = 'Ocupacion :'
      TabOrder = 1
      ExplicitHeight = 564
      object stg_detalle_ocupantes: TStringGrid
        Left = 2
        Top = 15
        Width = 206
        Height = 556
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 19
        Enabled = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        TabOrder = 0
        ExplicitHeight = 547
        ColWidths = (
          64
          65)
        RowHeights = (
          19
          19)
      end
    end
  end
  object Panel2: TPanel
    Left = 216
    Top = 27
    Width = 796
    Height = 684
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 1
    ExplicitTop = 29
    ExplicitWidth = 794
    ExplicitHeight = 674
    object Splitter2: TSplitter
      Left = 1
      Top = 431
      Width = 794
      Height = 8
      Cursor = crVSplit
      Align = alBottom
      Color = clInactiveCaptionText
      ParentColor = False
      ExplicitLeft = -2
      ExplicitTop = 390
      ExplicitWidth = 889
    end
    object pnlBUS: TPanel
      Left = 1
      Top = 439
      Width = 794
      Height = 239
      Align = alBottom
      BorderStyle = bsSingle
      TabOrder = 0
      ExplicitTop = 430
      ExplicitWidth = 788
      object Image: TImage
        Left = 0
        Top = 0
        Width = 105
        Height = 105
      end
      object Label125: TLabel
        Left = 800
        Top = 324
        Width = 43
        Height = 13
        Caption = 'Label125'
      end
      object Label150: TLabel
        Left = 796
        Top = 310
        Width = 43
        Height = 13
        Caption = 'Label150'
      end
      object Label149: TLabel
        Left = 812
        Top = 321
        Width = 43
        Height = 13
        Caption = 'Label149'
      end
      object Label148: TLabel
        Left = 796
        Top = 313
        Width = 43
        Height = 13
        Caption = 'Label148'
      end
      object Label147: TLabel
        Left = 796
        Top = 297
        Width = 43
        Height = 13
        Caption = 'Label147'
      end
      object Label146: TLabel
        Left = 796
        Top = 283
        Width = 43
        Height = 13
        Caption = 'Label146'
      end
      object Label145: TLabel
        Left = 796
        Top = 268
        Width = 43
        Height = 13
        Caption = 'Label145'
      end
      object Label144: TLabel
        Left = 796
        Top = 253
        Width = 43
        Height = 13
        Caption = 'Label144'
      end
      object Label143: TLabel
        Left = 796
        Top = 237
        Width = 43
        Height = 13
        Caption = 'Label143'
      end
      object Label142: TLabel
        Left = 796
        Top = 223
        Width = 43
        Height = 13
        Caption = 'Label142'
      end
      object Label141: TLabel
        Left = 796
        Top = 208
        Width = 43
        Height = 13
        Caption = 'Label141'
      end
      object Label140: TLabel
        Left = 796
        Top = 191
        Width = 43
        Height = 13
        Caption = 'Label140'
      end
      object Label139: TLabel
        Left = 796
        Top = 176
        Width = 43
        Height = 13
        Caption = 'Label139'
      end
      object Label138: TLabel
        Left = 796
        Top = 161
        Width = 43
        Height = 13
        Caption = 'Label138'
      end
      object Label137: TLabel
        Left = 796
        Top = 146
        Width = 43
        Height = 13
        Caption = 'Label137'
      end
      object Label136: TLabel
        Left = 796
        Top = 131
        Width = 43
        Height = 13
        Caption = 'Label136'
      end
      object Label135: TLabel
        Left = 796
        Top = 117
        Width = 43
        Height = 13
        Caption = 'Label135'
      end
      object Label134: TLabel
        Left = 796
        Top = 102
        Width = 43
        Height = 13
        Caption = 'Label134'
      end
      object Label133: TLabel
        Left = 796
        Top = 87
        Width = 43
        Height = 13
        Caption = 'Label133'
      end
      object Label132: TLabel
        Left = 812
        Top = 67
        Width = 43
        Height = 13
        Caption = 'Label132'
      end
      object Label131: TLabel
        Left = 796
        Top = 61
        Width = 43
        Height = 13
        Caption = 'Label131'
      end
      object Label130: TLabel
        Left = 796
        Top = 28
        Width = 43
        Height = 13
        Caption = 'Label130'
      end
      object Label129: TLabel
        Left = 796
        Top = 37
        Width = 43
        Height = 13
        Caption = 'Label129'
      end
      object Label128: TLabel
        Left = 796
        Top = 22
        Width = 43
        Height = 13
        Caption = 'Label128'
      end
      object Label127: TLabel
        Left = 796
        Top = 9
        Width = 43
        Height = 13
        Caption = 'Label127'
      end
      object Label126: TLabel
        Left = 796
        Top = -2
        Width = 43
        Height = 13
        Caption = 'Label126'
      end
      object Label124: TLabel
        Left = 792
        Top = 331
        Width = 43
        Height = 13
        Caption = 'Label124'
      end
      object Label123: TLabel
        Left = 800
        Top = 312
        Width = 43
        Height = 13
        Caption = 'Label123'
      end
      object Label122: TLabel
        Left = 800
        Top = 298
        Width = 43
        Height = 13
        Caption = 'Label122'
      end
      object Label121: TLabel
        Left = 800
        Top = 284
        Width = 43
        Height = 13
        Caption = 'Label121'
      end
      object Label120: TLabel
        Left = 800
        Top = 272
        Width = 43
        Height = 13
        Caption = 'Label120'
      end
      object Label119: TLabel
        Left = 800
        Top = 259
        Width = 43
        Height = 13
        Caption = 'Label119'
      end
      object Label118: TLabel
        Left = 800
        Top = 246
        Width = 43
        Height = 13
        Caption = 'Label118'
      end
      object Label117: TLabel
        Left = 800
        Top = 232
        Width = 43
        Height = 13
        Caption = 'Label117'
      end
      object Label116: TLabel
        Left = 800
        Top = 219
        Width = 43
        Height = 13
        Caption = 'Label116'
      end
      object Label115: TLabel
        Left = 800
        Top = 206
        Width = 43
        Height = 13
        Caption = 'Label115'
      end
      object Label114: TLabel
        Left = 800
        Top = 193
        Width = 43
        Height = 13
        Caption = 'Label114'
      end
      object Label113: TLabel
        Left = 800
        Top = 180
        Width = 43
        Height = 13
        Caption = 'Label113'
      end
      object Label112: TLabel
        Left = 800
        Top = 166
        Width = 43
        Height = 13
        Caption = 'Label112'
      end
      object Label111: TLabel
        Left = 800
        Top = 153
        Width = 43
        Height = 13
        Caption = 'Label111'
      end
      object Label110: TLabel
        Left = 800
        Top = 139
        Width = 43
        Height = 13
        Caption = 'Label110'
      end
      object Label109: TLabel
        Left = 800
        Top = 125
        Width = 43
        Height = 13
        Caption = 'Label109'
      end
      object Label108: TLabel
        Left = 800
        Top = 110
        Width = 43
        Height = 13
        Caption = 'Label108'
      end
      object Label107: TLabel
        Left = 800
        Top = 95
        Width = 43
        Height = 13
        Caption = 'Label107'
      end
      object Label106: TLabel
        Left = 800
        Top = 79
        Width = 43
        Height = 13
        Caption = 'Label106'
      end
      object Label105: TLabel
        Left = 800
        Top = 63
        Width = 43
        Height = 13
        Caption = 'Label105'
      end
      object Label104: TLabel
        Left = 800
        Top = 46
        Width = 43
        Height = 13
        Caption = 'Label104'
      end
      object Label103: TLabel
        Left = 800
        Top = 30
        Width = 43
        Height = 13
        Caption = 'Label103'
      end
      object Label102: TLabel
        Left = 800
        Top = 17
        Width = 43
        Height = 13
        Caption = 'Label102'
      end
      object Label101: TLabel
        Left = 800
        Top = 3
        Width = 43
        Height = 13
        Caption = 'Label101'
      end
      object Label100: TLabel
        Left = 791
        Top = -2
        Width = 43
        Height = 13
        Caption = 'Label100'
      end
    end
    object pnl_main: TPanel
      Left = 1
      Top = 1
      Width = 794
      Height = 430
      Align = alClient
      ParentBackground = False
      TabOrder = 1
      ExplicitWidth = 788
      ExplicitHeight = 421
      object grp_asientos: TGroupBox
        Left = 1
        Top = 1
        Width = 792
        Height = 428
        Align = alClient
        TabOrder = 1
        Visible = False
        ExplicitWidth = 786
        ExplicitHeight = 419
        object grp_cuales: TGroupBox
          Left = 2
          Top = 15
          Width = 788
          Height = 392
          Align = alClient
          TabOrder = 1
          Visible = False
          ExplicitWidth = 782
          ExplicitHeight = 383
          object lbledt_cuales: TLabeledEdit
            Left = 79
            Top = 46
            Width = 209
            Height = 21
            EditLabel.Width = 32
            EditLabel.Height = 13
            EditLabel.BiDiMode = bdLeftToRight
            EditLabel.Caption = 'Cuales'
            EditLabel.ParentBiDiMode = False
            EditLabel.Transparent = True
            TabOrder = 0
            Text = ''
          end
          object stg_listaOcupantes: TStringGrid
            Left = 294
            Top = 22
            Width = 176
            Height = 267
            ColCount = 2
            DefaultRowHeight = 16
            Enabled = False
            FixedCols = 0
            RowCount = 2
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            ScrollBars = ssVertical
            TabOrder = 2
            ColWidths = (
              53
              84)
          end
          object lbledt_tipo: TLabeledEdit
            Left = 79
            Top = 90
            Width = 209
            Height = 21
            BiDiMode = bdLeftToRight
            CharCase = ecUpperCase
            EditLabel.Width = 27
            EditLabel.Height = 13
            EditLabel.BiDiMode = bdLeftToRight
            EditLabel.Caption = 'Tipo :'
            EditLabel.ParentBiDiMode = False
            ParentBiDiMode = False
            TabOrder = 1
            Text = ''
          end
        end
        object lblEdt_cuantos: TLabeledEdit
          Left = 88
          Top = 62
          Width = 313
          Height = 21
          EditLabel.Width = 47
          EditLabel.Height = 13
          EditLabel.Caption = 'Cuantos :'
          HideSelection = False
          TabOrder = 0
          Text = ''
        end
        object StatusBar1: TStatusBar
          Left = 2
          Top = 407
          Width = 788
          Height = 19
          Panels = <
            item
              Text = 'F5 - Regresar'
              Width = 100
            end
            item
              Text = 'F7 - Cuantos'
              Width = 100
            end
            item
              Text = 'F8 - Cuales'
              Width = 50
            end>
          ExplicitTop = 398
          ExplicitWidth = 782
        end
      end
      object grp_corridas: TGroupBox
        Left = 1
        Top = 1
        Width = 792
        Height = 428
        Align = alClient
        Caption = 'Corridas'
        TabOrder = 0
        ExplicitWidth = 786
        ExplicitHeight = 419
        object stg_corrida: TStringGrid
          Left = 2
          Top = 15
          Width = 788
          Height = 411
          Align = alClient
          ColCount = 14
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
          PopupMenu = PopupMenu1
          TabOrder = 0
          OnKeyUp = stg_corridaKeyUp
          ExplicitWidth = 782
          ExplicitHeight = 402
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
        object stg_reporte: TStringGrid
          Left = 24
          Top = 208
          Width = 545
          Height = 197
          ColCount = 7
          FixedCols = 0
          TabOrder = 1
          Visible = False
        end
      end
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1012
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
                Action = Action1
                Caption = '&Salir'
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 608
    Top = 208
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ShortCut = 16467
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Exportar'
      OnExecute = Action2Execute
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 514
    Top = 99
    object Guardar1: TMenuItem
      Action = Action2
    end
  end
end
