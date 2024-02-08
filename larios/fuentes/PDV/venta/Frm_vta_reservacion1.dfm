object frm_vta_reserva: Tfrm_vta_reserva
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'frm_vta_reserva'
  ClientHeight = 733
  ClientWidth = 1171
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 273
    Top = 25
    Height = 708
    Color = clInactiveCaptionText
    ParentColor = False
    ExplicitHeight = 710
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1171
    Height = 25
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.HighlightColor = clWhite
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMenuText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
    ExplicitLeft = 512
    ExplicitTop = 360
    ExplicitWidth = 150
    ExplicitHeight = 29
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 273
    Height = 708
    Align = alLeft
    BorderStyle = bsSingle
    Constraints.MinHeight = 683
    Constraints.MinWidth = 273
    TabOrder = 1
    ExplicitHeight = 683
    object Gr_Corridas: TGroupBox
      Left = 1
      Top = 1
      Width = 267
      Height = 160
      Align = alTop
      Caption = 'Datos Venta :'
      TabOrder = 0
      object Label1: TLabel
        Left = 3
        Top = 14
        Width = 75
        Height = 13
        Caption = 'Ciudad Origen :'
      end
      object Label2: TLabel
        Left = 40
        Top = 38
        Width = 36
        Height = 13
        Caption = 'Fecha :'
      end
      object Label4: TLabel
        Left = 39
        Top = 61
        Width = 39
        Height = 13
        Caption = 'Origen :'
      end
      object Label5: TLabel
        Left = 34
        Top = 86
        Width = 43
        Height = 13
        Caption = 'Destino :'
      end
      object Label6: TLabel
        Left = 46
        Top = 110
        Width = 30
        Height = 13
        Caption = 'Hora :'
      end
      object Label7: TLabel
        Left = 30
        Top = 132
        Width = 47
        Height = 13
        Caption = 'Servicio : '
      end
      object ls_Origen_vta: TlsComboBox
        Left = 82
        Top = 59
        Width = 185
        Height = 21
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ls_Desde_vta: TlsComboBox
        Left = 81
        Top = 83
        Width = 183
        Height = 21
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        Complete = False
        ForceIndexOnExit = False
        MinLengthComplete = 0
      end
      object ls_Origen: TlsComboBox
        Left = 79
        Top = 8
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
      object ls_servicio: TlsComboBox
        Left = 79
        Top = 129
        Width = 185
        Height = 21
        CharCase = ecUpperCase
        TabOrder = 5
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object medt_fecha: TMaskEdit
        Left = 82
        Top = 35
        Width = 120
        Height = 21
        EditMask = '!99/99/9999;1;_'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MaxLength = 10
        ParentFont = False
        TabOrder = 1
        Text = '  /  /    '
      end
      object Ed_Hora: TEdit
        Left = 79
        Top = 106
        Width = 58
        Height = 21
        TabOrder = 4
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 317
      Width = 267
      Height = 386
      Align = alClient
      Caption = 'Detalle Ruta'
      TabOrder = 1
      ExplicitHeight = 361
      object stg_detalle: TStringGrid
        Left = 2
        Top = 15
        Width = 263
        Height = 369
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 18
        Enabled = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitHeight = 344
        ColWidths = (
          51
          131)
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 161
      Width = 267
      Height = 156
      Align = alTop
      Caption = 'Disponibilidad '
      TabOrder = 2
      object stg_ocupantes: TStringGrid
        Left = 2
        Top = 15
        Width = 263
        Height = 139
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 18
        Enabled = False
        FixedCols = 0
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = []
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          121
          64)
      end
    end
  end
  object Panel2: TPanel
    Left = 276
    Top = 25
    Width = 895
    Height = 708
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 2
    ExplicitHeight = 683
    object Splitter2: TSplitter
      Left = 1
      Top = 345
      Width = 889
      Height = 8
      Cursor = crVSplit
      Align = alBottom
      Color = clInactiveCaptionText
      ParentColor = False
      ExplicitTop = 363
      ExplicitWidth = 768
    end
    object pnlBUS: TPanel
      Left = 1
      Top = 353
      Width = 889
      Height = 350
      Align = alBottom
      BorderStyle = bsSingle
      TabOrder = 0
      ExplicitTop = 328
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
        Left = 784
        Top = -2
        Width = 43
        Height = 13
        Caption = 'Label100'
      end
    end
    object pnl_main: TPanel
      Left = 1
      Top = 1
      Width = 889
      Height = 344
      Align = alClient
      ParentBackground = False
      TabOrder = 1
      ExplicitHeight = 319
      object grp_asientos: TGroupBox
        Left = 1
        Top = 1
        Width = 887
        Height = 342
        Align = alClient
        TabOrder = 1
        Visible = False
        ExplicitHeight = 317
        object grp_cuales: TGroupBox
          Left = 2
          Top = 15
          Width = 883
          Height = 306
          Align = alClient
          TabOrder = 1
          Visible = False
          ExplicitHeight = 281
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
          end
        end
        object lblEdt_cuantos: TLabeledEdit
          Left = 152
          Top = 34
          Width = 313
          Height = 21
          EditLabel.Width = 47
          EditLabel.Height = 13
          EditLabel.Caption = 'Cuantos :'
          HideSelection = False
          TabOrder = 0
        end
        object StatusBar1: TStatusBar
          Left = 2
          Top = 321
          Width = 883
          Height = 19
          Panels = <
            item
              Text = 'F5 - Cancelar'
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
          ExplicitTop = 296
        end
      end
      object grp_corridas: TGroupBox
        Left = 1
        Top = 1
        Width = 887
        Height = 342
        Align = alClient
        Caption = 'Corridas'
        TabOrder = 0
        ExplicitHeight = 317
        object stg_corrida: TStringGrid
          Left = 2
          Top = 15
          Width = 883
          Height = 325
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
          ExplicitHeight = 300
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
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 576
    Top = 360
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
