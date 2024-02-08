object frm_anticipa_vender: Tfrm_anticipa_vender
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Asignacion de venta de boletos anticiapados'
  ClientHeight = 700
  ClientWidth = 1149
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 1149
    Height = 654
    Align = alClient
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 281
      Top = 1
      Height = 652
      ExplicitLeft = 584
      ExplicitTop = 304
      ExplicitHeight = 100
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 280
      Height = 652
      Align = alLeft
      TabOrder = 0
      object Gr_Corridas: TGroupBox
        Left = 1
        Top = 1
        Width = 278
        Height = 655
        Align = alTop
        TabOrder = 0
        object Label1: TLabel
          Left = 11
          Top = 27
          Width = 77
          Height = 13
          Caption = 'Codigo de canje'
        end
        object ls_canje: TlsComboBox
          Left = 11
          Top = 46
          Width = 206
          Height = 21
          AutoComplete = False
          AutoDropDown = True
          Style = csSimple
          CharCase = ecUpperCase
          TabOrder = 0
          OnClick = ls_canjeClick
          OnKeyDown = ls_canjeKeyDown
          Complete = True
          ForceIndexOnExit = True
          MinLengthComplete = 0
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 96
          Width = 266
          Height = 351
          Caption = 'Detalle de compra'
          TabOrder = 1
          object Label2: TLabel
            Left = 42
            Top = 26
            Width = 39
            Height = 13
            Caption = 'Origen :'
          end
          object Label3: TLabel
            Left = 38
            Top = 54
            Width = 43
            Height = 13
            Caption = 'Destino :'
          end
          object Label4: TLabel
            Left = 36
            Top = 82
            Width = 44
            Height = 13
            Caption = 'Servicio :'
          end
          object Label5: TLabel
            Left = 6
            Top = 109
            Width = 75
            Height = 13
            Caption = 'Fecha a viajar :'
          end
          object ls_Origen_vta: TlsComboBox
            Left = 87
            Top = 23
            Width = 170
            Height = 21
            Style = csSimple
            Enabled = False
            TabOrder = 0
            Complete = True
            ForceIndexOnExit = True
            MinLengthComplete = 0
          end
          object ls_Destino_vta: TlsComboBox
            Left = 87
            Top = 51
            Width = 170
            Height = 21
            Style = csSimple
            Enabled = False
            TabOrder = 1
            Complete = True
            ForceIndexOnExit = True
            MinLengthComplete = 0
          end
          object ls_servicio: TlsComboBox
            Left = 86
            Top = 79
            Width = 170
            Height = 21
            Style = csSimple
            Enabled = False
            TabOrder = 2
            Complete = True
            ForceIndexOnExit = True
            MinLengthComplete = 0
          end
          object medt_fecha: TMaskEdit
            Left = 87
            Top = 106
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
            TabOrder = 3
            Text = '  /  /    '
            OnKeyDown = medt_fechaKeyDown
          end
          object stg_ocupantes: TStringGrid
            Left = 3
            Top = 152
            Width = 253
            Height = 152
            ColCount = 2
            Enabled = False
            FixedCols = 0
            TabOrder = 4
            ColWidths = (
              139
              91)
          end
        end
      end
    end
    object Panel3: TPanel
      Left = 284
      Top = 1
      Width = 864
      Height = 652
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 886
      ExplicitHeight = 682
      object grp_corridas: TGroupBox
        Left = 1
        Top = 1
        Width = 884
        Height = 330
        Align = alClient
        Caption = 'Corridas'
        TabOrder = 0
        object stg_corrida: TStringGrid
          Left = 2
          Top = 15
          Width = 880
          Height = 313
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
          OnKeyDown = stg_corridaKeyDown
          OnKeyPress = stg_corridaKeyPress
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
      object grp_cuales: TGroupBox
        Left = 1
        Top = 1
        Width = 884
        Height = 330
        Align = alClient
        Caption = 'Asigna asientos a la venta anticipada'
        TabOrder = 2
        Visible = False
        object lbledt_cuales: TLabeledEdit
          Left = 96
          Top = 61
          Width = 153
          Height = 21
          EditLabel.Width = 39
          EditLabel.Height = 13
          EditLabel.Caption = 'Cuales :'
          TabOrder = 0
          Text = ''
          OnChange = lbledt_cualesChange
        end
        object lbledt_tipo: TLabeledEdit
          Left = 96
          Top = 106
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
      object pnlBUS: TPanel
        Left = 1
        Top = 331
        Width = 884
        Height = 350
        Align = alBottom
        BorderStyle = bsSingle
        TabOrder = 1
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
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 681
    Width = 1149
    Height = 19
    Panels = <
      item
        Text = 'F1 Buscar'
        Width = 100
      end
      item
        Text = 'F4 asignar corrida'
        Width = 200
      end>
    ExplicitTop = 709
    ExplicitWidth = 1171
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1149
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
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 424
    Top = 160
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action1Execute
    end
    object ac_buscar: TAction
      Category = 'Sistema'
      Caption = 'Buscar'
    end
    object ac_buscarCodigo: TAction
      Caption = 'ac_buscarCodigo'
      OnExecute = ac_buscarCodigoExecute
    end
  end
  object TRefrescaCorrida: TTimer
    Interval = 10000
    OnTimer = TRefrescaCorridaTimer
    Left = 544
    Top = 176
  end
end
