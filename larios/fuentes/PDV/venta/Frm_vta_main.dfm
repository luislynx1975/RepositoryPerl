object Frm_venta_principal: TFrm_venta_principal
  Left = 295
  Top = 82
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Pantalla para la venta de boletos'
  ClientHeight = 707
  ClientWidth = 1022
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 216
    Top = 25
    Height = 663
    Color = clInactiveCaptionText
    ParentColor = False
    ExplicitLeft = 273
    ExplicitHeight = 710
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 216
    Height = 663
    Align = alLeft
    BorderStyle = bsSingle
    TabOrder = 0
    object Gr_Corridas: TGroupBox
      Left = 1
      Top = 1
      Width = 210
      Height = 208
      Align = alTop
      Caption = 'Datos Venta :'
      TabOrder = 0
      object Label1: TLabel
        Left = 3
        Top = 47
        Width = 73
        Height = 13
        Caption = 'Ciudad Origen :'
      end
      object Label2: TLabel
        Left = 3
        Top = 71
        Width = 36
        Height = 13
        Caption = 'Fecha :'
      end
      object Label4: TLabel
        Left = 3
        Top = 94
        Width = 37
        Height = 13
        Caption = 'Origen :'
      end
      object Label5: TLabel
        Left = 3
        Top = 119
        Width = 42
        Height = 13
        Caption = 'Destino :'
      end
      object Label6: TLabel
        Left = 3
        Top = 142
        Width = 29
        Height = 13
        Caption = 'Hora :'
      end
      object Label7: TLabel
        Left = 3
        Top = 165
        Width = 47
        Height = 13
        Caption = 'Servicio : '
      end
      object Label3: TLabel
        Left = 3
        Top = 188
        Width = 39
        Height = 13
        Caption = 'Corrida :'
      end
      object lbl_nombre: TLabel
        Left = 3
        Top = 16
        Width = 89
        Height = 20
        Caption = 'lbl_nombre'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ls_Desde_vta: TlsComboBox
        Left = 57
        Top = 116
        Width = 152
        Height = 21
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        Complete = False
        ForceIndexOnExit = False
        MinLengthComplete = 0
      end
      object ls_Origen_vta: TlsComboBox
        Left = 57
        Top = 92
        Width = 152
        Height = 21
        CharCase = ecUpperCase
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
        Top = 41
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
        Left = 57
        Top = 162
        Width = 152
        Height = 21
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object medt_fecha: TMaskEdit
        Left = 57
        Top = 68
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
      object Ed_Hora: TEdit
        Left = 57
        Top = 139
        Width = 58
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object edt_corrida: TEdit
        Left = 57
        Top = 184
        Width = 121
        Height = 21
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 384
      Width = 210
      Height = 274
      Align = alClient
      Caption = 'Detalle Ruta'
      TabOrder = 1
      object stg_detalle: TStringGrid
        Left = 2
        Top = 15
        Width = 206
        Height = 257
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 18
        Enabled = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ColWidths = (
          51
          131)
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 209
      Width = 210
      Height = 175
      Align = alTop
      Caption = 'Disponibilidad '
      TabOrder = 2
      object stg_ocupantes: TStringGrid
        Left = 2
        Top = 15
        Width = 206
        Height = 158
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 19
        Enabled = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 219
    Top = 25
    Width = 803
    Height = 663
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 1
    object Splitter2: TSplitter
      Left = 1
      Top = 411
      Width = 797
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
      Top = 419
      Width = 797
      Height = 239
      Align = alBottom
      BorderStyle = bsSingle
      TabOrder = 0
      object Image: TImage
        Left = 0
        Top = 0
        Width = 105
        Height = 105
      end
      object Label125: TLabel
        Left = 800
        Top = 324
        Width = 44
        Height = 13
        Caption = 'Label125'
      end
      object Label150: TLabel
        Left = 796
        Top = 310
        Width = 44
        Height = 13
        Caption = 'Label150'
      end
      object Label149: TLabel
        Left = 812
        Top = 321
        Width = 44
        Height = 13
        Caption = 'Label149'
      end
      object Label148: TLabel
        Left = 796
        Top = 313
        Width = 44
        Height = 13
        Caption = 'Label148'
      end
      object Label147: TLabel
        Left = 796
        Top = 297
        Width = 44
        Height = 13
        Caption = 'Label147'
      end
      object Label146: TLabel
        Left = 796
        Top = 283
        Width = 44
        Height = 13
        Caption = 'Label146'
      end
      object Label145: TLabel
        Left = 796
        Top = 268
        Width = 44
        Height = 13
        Caption = 'Label145'
      end
      object Label144: TLabel
        Left = 796
        Top = 253
        Width = 44
        Height = 13
        Caption = 'Label144'
      end
      object Label143: TLabel
        Left = 796
        Top = 237
        Width = 44
        Height = 13
        Caption = 'Label143'
      end
      object Label142: TLabel
        Left = 796
        Top = 223
        Width = 44
        Height = 13
        Caption = 'Label142'
      end
      object Label141: TLabel
        Left = 796
        Top = 208
        Width = 44
        Height = 13
        Caption = 'Label141'
      end
      object Label140: TLabel
        Left = 796
        Top = 191
        Width = 44
        Height = 13
        Caption = 'Label140'
      end
      object Label139: TLabel
        Left = 796
        Top = 176
        Width = 44
        Height = 13
        Caption = 'Label139'
      end
      object Label138: TLabel
        Left = 796
        Top = 161
        Width = 44
        Height = 13
        Caption = 'Label138'
      end
      object Label137: TLabel
        Left = 796
        Top = 146
        Width = 44
        Height = 13
        Caption = 'Label137'
      end
      object Label136: TLabel
        Left = 796
        Top = 131
        Width = 44
        Height = 13
        Caption = 'Label136'
      end
      object Label135: TLabel
        Left = 796
        Top = 117
        Width = 44
        Height = 13
        Caption = 'Label135'
      end
      object Label134: TLabel
        Left = 796
        Top = 102
        Width = 44
        Height = 13
        Caption = 'Label134'
      end
      object Label133: TLabel
        Left = 796
        Top = 87
        Width = 44
        Height = 13
        Caption = 'Label133'
      end
      object Label132: TLabel
        Left = 812
        Top = 67
        Width = 44
        Height = 13
        Caption = 'Label132'
      end
      object Label131: TLabel
        Left = 796
        Top = 61
        Width = 44
        Height = 13
        Caption = 'Label131'
      end
      object Label130: TLabel
        Left = 796
        Top = 28
        Width = 44
        Height = 13
        Caption = 'Label130'
      end
      object Label129: TLabel
        Left = 796
        Top = 37
        Width = 44
        Height = 13
        Caption = 'Label129'
      end
      object Label128: TLabel
        Left = 796
        Top = 22
        Width = 44
        Height = 13
        Caption = 'Label128'
      end
      object Label127: TLabel
        Left = 796
        Top = 9
        Width = 44
        Height = 13
        Caption = 'Label127'
      end
      object Label126: TLabel
        Left = 796
        Top = -2
        Width = 44
        Height = 13
        Caption = 'Label126'
      end
      object Label124: TLabel
        Left = 792
        Top = 331
        Width = 44
        Height = 13
        Caption = 'Label124'
      end
      object Label123: TLabel
        Left = 800
        Top = 312
        Width = 44
        Height = 13
        Caption = 'Label123'
      end
      object Label122: TLabel
        Left = 800
        Top = 298
        Width = 44
        Height = 13
        Caption = 'Label122'
      end
      object Label121: TLabel
        Left = 800
        Top = 284
        Width = 44
        Height = 13
        Caption = 'Label121'
      end
      object Label120: TLabel
        Left = 800
        Top = 272
        Width = 44
        Height = 13
        Caption = 'Label120'
      end
      object Label119: TLabel
        Left = 800
        Top = 259
        Width = 44
        Height = 13
        Caption = 'Label119'
      end
      object Label118: TLabel
        Left = 800
        Top = 246
        Width = 44
        Height = 13
        Caption = 'Label118'
      end
      object Label117: TLabel
        Left = 800
        Top = 232
        Width = 44
        Height = 13
        Caption = 'Label117'
      end
      object Label116: TLabel
        Left = 800
        Top = 219
        Width = 44
        Height = 13
        Caption = 'Label116'
      end
      object Label115: TLabel
        Left = 800
        Top = 206
        Width = 44
        Height = 13
        Caption = 'Label115'
      end
      object Label114: TLabel
        Left = 800
        Top = 193
        Width = 44
        Height = 13
        Caption = 'Label114'
      end
      object Label113: TLabel
        Left = 800
        Top = 180
        Width = 44
        Height = 13
        Caption = 'Label113'
      end
      object Label112: TLabel
        Left = 800
        Top = 166
        Width = 44
        Height = 13
        Caption = 'Label112'
      end
      object Label111: TLabel
        Left = 800
        Top = 153
        Width = 44
        Height = 13
        Caption = 'Label111'
      end
      object Label110: TLabel
        Left = 800
        Top = 139
        Width = 44
        Height = 13
        Caption = 'Label110'
      end
      object Label109: TLabel
        Left = 800
        Top = 125
        Width = 44
        Height = 13
        Caption = 'Label109'
      end
      object Label108: TLabel
        Left = 800
        Top = 110
        Width = 44
        Height = 13
        Caption = 'Label108'
      end
      object Label107: TLabel
        Left = 800
        Top = 95
        Width = 44
        Height = 13
        Caption = 'Label107'
      end
      object Label106: TLabel
        Left = 800
        Top = 79
        Width = 44
        Height = 13
        Caption = 'Label106'
      end
      object Label105: TLabel
        Left = 800
        Top = 63
        Width = 44
        Height = 13
        Caption = 'Label105'
      end
      object Label104: TLabel
        Left = 800
        Top = 46
        Width = 44
        Height = 13
        Caption = 'Label104'
      end
      object Label103: TLabel
        Left = 800
        Top = 30
        Width = 44
        Height = 13
        Caption = 'Label103'
      end
      object Label102: TLabel
        Left = 800
        Top = 17
        Width = 44
        Height = 13
        Caption = 'Label102'
      end
      object Label101: TLabel
        Left = 800
        Top = 3
        Width = 44
        Height = 13
        Caption = 'Label101'
      end
      object Label100: TLabel
        Left = 784
        Top = -2
        Width = 44
        Height = 13
        Caption = 'Label100'
      end
    end
    object pnl_main: TPanel
      Left = 1
      Top = 1
      Width = 797
      Height = 410
      Align = alClient
      ParentBackground = False
      TabOrder = 1
      object grp_corridas: TGroupBox
        Left = 1
        Top = 1
        Width = 795
        Height = 408
        Align = alClient
        Caption = 'Corridas'
        TabOrder = 0
        object stg_corrida: TStringGrid
          Left = 2
          Top = 15
          Width = 791
          Height = 391
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
          PopupMenu = PopupMenu
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
            64
            64
            64
            64)
        end
      end
      object grp_asientos: TGroupBox
        Left = 1
        Top = 1
        Width = 795
        Height = 408
        Align = alClient
        TabOrder = 1
        Visible = False
        object grp_cuales: TGroupBox
          Left = 2
          Top = 15
          Width = 791
          Height = 372
          Align = alClient
          TabOrder = 1
          Visible = False
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
          Left = 94
          Top = 61
          Width = 313
          Height = 21
          EditLabel.Width = 45
          EditLabel.Height = 13
          EditLabel.Caption = 'Cuantos :'
          HideSelection = False
          TabOrder = 0
        end
        object StatusBar1: TStatusBar
          Left = 2
          Top = 387
          Width = 791
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
        end
      end
    end
  end
  object stb_venta: TStatusBar
    Left = 0
    Top = 688
    Width = 1022
    Height = 19
    Panels = <
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 50
      end>
  end
  object ActionMainMenuBar3: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1022
    Height = 25
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar3'
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object TimerAsignado: TTimer
    Enabled = False
    Left = 632
    Top = 336
  end
  object PopupMenu: TPopupMenu
    Images = DM.img_iconos
    Left = 440
    Top = 192
    object Predespachar1: TMenuItem
      Caption = 'Predespachar'
      ImageIndex = 39
      ShortCut = 16464
    end
    object Agrupar1: TMenuItem
      Caption = 'Agrupar'
      ImageIndex = 40
      ShortCut = 16455
    end
    object Modificar1: TMenuItem
      Caption = 'Modificar cupos'
      ImageIndex = 22
      ShortCut = 16461
    end
    object Cerrarcorrida1: TMenuItem
      Caption = 'Cerrar corrida'
      ImageIndex = 46
      ShortCut = 16451
    end
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
            Caption = 'S&istema'
          end
          item
            Caption = '-'
          end
          item
            Items = <
              item
                Action = ac111
                Caption = '&Asignarse a la venta'
                ImageIndex = 32
                ShortCut = 16449
              end
              item
                Action = ac116
                Caption = '&Desasignarse a la venta'
                ImageIndex = 31
                ShortCut = 16452
              end
              item
                Action = ac160
                Caption = '&Imprime carga inicial'
                ImageIndex = 33
                ShortCut = 16457
              end
              item
                Visible = False
                Action = acInicial
                ImageIndex = 35
                ShortCut = 16454
              end
              item
                Action = ac179
                Caption = '&Recoleccion'
                ImageIndex = 34
                ShortCut = 16466
              end
              item
                Action = acboleto
                Caption = '&Cancelar boleto'
                ImageIndex = 5
                ShortCut = 16450
              end
              item
                Action = acAnticipada
                Caption = '&Boleto abierto'
                ImageIndex = 44
                ShortCut = 16470
              end
              item
                Action = acimprimevta
                Caption = 'I&mprime boleto abierto'
                ImageIndex = 45
                ShortCut = 16456
              end
              item
                Action = Action1
                Caption = 'Cambiar &Password'
                ImageIndex = 48
                ShortCut = 16464
              end
              item
                Action = acPrueba
                Caption = 'Pr&ueba Impresi'#243'n'
                ImageIndex = 27
              end>
            Caption = '&Venta'
          end
          item
            Action = Action2
            Caption = '&Ultima venta'
            ShortCut = 16469
          end>
        ActionBar = ActionMainMenuBar3
      end
      item
        Items = <
          item
            Action = ac99
            Caption = '&Salir'
            ImageIndex = 21
            ShortCut = 16467
          end>
      end
      item
      end>
    Images = DM.img_iconos
    Left = 852
    Top = 96
    StyleName = 'XP Style'
    object ac111: TAction
      Tag = 111
      Category = 'Venta'
      Caption = 'Asignarse a la venta'
      Enabled = False
      ImageIndex = 32
      ShortCut = 16449
    end
    object ac116: TAction
      Tag = 116
      Category = 'Venta'
      Caption = 'Desasignarse a la venta'
      Enabled = False
      ImageIndex = 31
      ShortCut = 16452
    end
    object ac99: TAction
      Tag = 99
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
    end
    object ac160: TAction
      Category = 'Venta'
      Caption = 'Imprime carga inicial'
      Enabled = False
      ImageIndex = 33
      ShortCut = 16457
    end
    object acInicial: TAction
      Category = 'Venta'
      Caption = 'Fondo inicial'
      Enabled = False
      ImageIndex = 35
      ShortCut = 16454
      Visible = False
    end
    object ac179: TAction
      Tag = 179
      Category = 'Venta'
      Caption = 'Recoleccion'
      Enabled = False
      ImageIndex = 34
      ShortCut = 16466
    end
    object acboleto: TAction
      Category = 'Venta'
      Caption = 'Cancelar boleto'
      Enabled = False
      ImageIndex = 5
      ShortCut = 16451
    end
    object acAnticipada: TAction
      Category = 'Venta'
      Caption = 'Boleto abierto'
      Enabled = False
      ImageIndex = 44
      ShortCut = 16470
    end
    object acimprimevta: TAction
      Category = 'Venta'
      Caption = 'Imprime boleto abierto'
      Enabled = False
      ImageIndex = 45
      ShortCut = 16456
    end
    object Action1: TAction
      Category = 'Venta'
      Caption = 'Cambiar Password'
      ImageIndex = 48
      ShortCut = 16464
    end
    object Action2: TAction
      Caption = 'Ultima venta'
      ShortCut = 16469
    end
    object acPrueba: TAction
      Category = 'Venta'
      Caption = 'Prueba Impresi'#243'n'
      ImageIndex = 27
    end
  end
  object timer_pintabus: TTimer
    Enabled = False
    Interval = 5000
    Left = 880
    Top = 328
  end
  object TRefrescaCorrida: TTimer
    Enabled = False
    Interval = 10000
    Left = 760
    Top = 248
  end
end
