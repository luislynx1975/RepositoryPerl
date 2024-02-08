object frm_nueva_venta: Tfrm_nueva_venta
  Left = 305
  Top = 99
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Venta de boletos'
  ClientHeight = 701
  ClientWidth = 1030
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object Panel2: TPanel
    Left = 216
    Top = 27
    Width = 814
    Height = 655
    Align = alClient
    BorderStyle = bsSingle
    TabOrder = 1
    ExplicitWidth = 810
    ExplicitHeight = 654
    object Splitter2: TSplitter
      Left = 1
      Top = 403
      Width = 808
      Height = 8
      Cursor = crVSplit
      Align = alBottom
      Color = clInactiveCaptionText
      ParentColor = False
      ExplicitLeft = -2
      ExplicitTop = 390
      ExplicitWidth = 889
    end
    object pnl_main: TPanel
      Left = 1
      Top = 1
      Width = 808
      Height = 402
      Align = alClient
      ParentBackground = False
      TabOrder = 1
      ExplicitWidth = 804
      ExplicitHeight = 401
      object grp_asientos: TGroupBox
        Left = 1
        Top = 1
        Width = 806
        Height = 400
        Align = alClient
        TabOrder = 1
        Visible = False
        ExplicitWidth = 802
        ExplicitHeight = 399
        object grp_cuales: TGroupBox
          Left = 2
          Top = 15
          Width = 806
          Height = 354
          TabOrder = 1
          Visible = False
          object lbledt_cuales: TLabeledEdit
            Left = 79
            Top = 45
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
            OnChange = lbledt_cualesChange
            OnEnter = lbledt_cualesEnter
            OnExit = lbledt_cualesExit
            OnKeyPress = lbledt_cualesKeyPress
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
            OnChange = lbledt_tipoChange
            OnEnter = lbledt_tipoEnter
            OnKeyPress = lbledt_tipoKeyPress
            OnKeyUp = lbledt_tipoKeyUp
          end
        end
        object lblEdt_cuantos: TLabeledEdit
          Left = 81
          Top = 60
          Width = 313
          Height = 21
          EditLabel.Width = 47
          EditLabel.Height = 13
          EditLabel.Caption = 'Cuantos :'
          HideSelection = False
          TabOrder = 0
          Text = ''
          OnEnter = lblEdt_cuantosEnter
          OnExit = lblEdt_cuantosExit
          OnKeyPress = lblEdt_cuantosKeyPress
        end
        object StatusBar1: TStatusBar
          Left = 2
          Top = 379
          Width = 802
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
          ExplicitTop = 378
          ExplicitWidth = 798
        end
      end
      object grp_corridas: TGroupBox
        Left = 1
        Top = 1
        Width = 806
        Height = 400
        Align = alClient
        Caption = 'Corridas'
        TabOrder = 0
        ExplicitWidth = 802
        ExplicitHeight = 399
        object img_central: TImage
          Left = 734
          Top = 122
          Width = 78
          Height = 69
          Transparent = True
        end
        object stg_corrida: TStringGrid
          Left = 2
          Top = 9
          Width = 727
          Height = 396
          ColCount = 14
          DefaultRowHeight = 22
          FixedCols = 0
          RowCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ParentFont = False
          PopupMenu = PopupMenu
          TabOrder = 0
          OnKeyPress = stg_corridaKeyPress
          OnKeyUp = stg_corridaKeyUp
          OnMouseDown = stg_corridaMouseDown
          ColWidths = (
            93
            111
            168
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
    object pnlBUS: TPanel
      Left = 1
      Top = 411
      Width = 808
      Height = 239
      Align = alBottom
      BorderStyle = bsSingle
      TabOrder = 0
      ExplicitTop = 410
      ExplicitWidth = 804
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
  end
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 216
    Height = 655
    Align = alLeft
    BorderStyle = bsSingle
    TabOrder = 0
    ExplicitHeight = 654
    object Gr_Corridas: TGroupBox
      Left = 1
      Top = 1
      Width = 210
      Height = 200
      Align = alTop
      Caption = 'Datos Venta :'
      TabOrder = 0
      object Label1: TLabel
        Left = 3
        Top = 38
        Width = 75
        Height = 13
        Caption = 'Ciudad Origen :'
      end
      object Label2: TLabel
        Left = 3
        Top = 62
        Width = 36
        Height = 13
        Caption = 'Fecha :'
      end
      object Label4: TLabel
        Left = 3
        Top = 85
        Width = 39
        Height = 13
        Caption = 'Origen :'
      end
      object Label5: TLabel
        Left = 3
        Top = 110
        Width = 43
        Height = 13
        Caption = 'Destino :'
      end
      object Label6: TLabel
        Left = 3
        Top = 133
        Width = 30
        Height = 13
        Caption = 'Hora :'
      end
      object Label7: TLabel
        Left = 3
        Top = 156
        Width = 47
        Height = 13
        Caption = 'Servicio : '
      end
      object Label3: TLabel
        Left = 3
        Top = 179
        Width = 42
        Height = 13
        Caption = 'Corrida :'
      end
      object lbl_nombre: TLabel
        Left = 3
        Top = 13
        Width = 87
        Height = 13
        Caption = 'NO ASIGNADO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object ls_Desde_vta: TlsComboBox
        Left = 57
        Top = 107
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
        OnExit = ls_Desde_vtaExit
        OnKeyPress = ls_Desde_vtaKeyPress
        Complete = False
        ForceIndexOnExit = False
        MinLengthComplete = 0
      end
      object ls_Origen_vta: TlsComboBox
        Left = 57
        Top = 85
        Width = 152
        Height = 21
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnKeyPress = ls_Origen_vtaKeyPress
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ls_Origen_: TlsComboBox
        Left = 84
        Top = 32
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
        Top = 153
        Width = 152
        Height = 21
        CharCase = ecUpperCase
        DragMode = dmAutomatic
        DropDownCount = 10
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        OnExit = ls_servicioExit
        OnKeyPress = ls_servicioKeyPress
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object medt_fecha: TMaskEdit
        Left = 57
        Top = 59
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
        OnEnter = medt_fechaEnter
      end
      object Ed_Hora: TEdit
        Left = 57
        Top = 130
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
        Top = 175
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
      Top = 399
      Width = 210
      Height = 251
      Align = alClient
      Caption = 'Detalle Ruta'
      TabOrder = 1
      ExplicitHeight = 250
      object stg_detalle: TStringGrid
        Left = 2
        Top = 15
        Width = 206
        Height = 234
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 14
        Enabled = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -8
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitHeight = 233
        ColWidths = (
          51
          131)
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 201
      Width = 210
      Height = 198
      Align = alTop
      Caption = 'Disponibilidad '
      TabOrder = 2
      object stg_ocupantes: TStringGrid
        Left = 2
        Top = 15
        Width = 206
        Height = 181
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 13
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1030
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
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
    ExplicitWidth = 1026
  end
  object stb_venta: TStatusBar
    Left = 0
    Top = 682
    Width = 1030
    Height = 19
    Panels = <
      item
        Width = 70
      end
      item
        Width = 140
      end
      item
        Width = 140
      end
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
    ExplicitTop = 681
    ExplicitWidth = 1026
  end
  object mem_conectado: TMemo
    Left = 952
    Top = 226
    Width = 84
    Height = 89
    BorderStyle = bsNone
    Color = clMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 4
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action2
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end
          item
            Items = <
              item
                Action = ac111
                Caption = '&Asignarse'
                ImageIndex = 0
                ShortCut = 16449
              end
              item
                Action = ac116
                Caption = '&Desasignarse de la venta'
                ImageIndex = 31
                ShortCut = 16452
              end
              item
                Action = ac160
                Caption = '&Imprime Carga Inicial'
                ImageIndex = 5
                ShortCut = 16457
              end
              item
                Action = ac179
                Caption = '&Recoleccion'
                ImageIndex = 37
                ShortCut = 16466
              end
              item
                Action = acboleto
                Caption = '&Cancela Boleto'
                ImageIndex = 5
                ShortCut = 16450
              end
              item
                Action = acAnticipada
                Caption = '&Boleto abierto'
                ImageIndex = 44
                ShortCut = 16463
              end
              item
                Action = acimprimevta
                Caption = 'I&mprime Boleto Abierto'
                ImageIndex = 45
                ShortCut = 16461
              end
              item
                Action = Action1
                Caption = 'Cambi&o password'
                ImageIndex = 48
                ShortCut = 16464
              end
              item
                Action = acPrueba
                Caption = '&Prueba impresi'#243'n'
                ImageIndex = 5
              end
              item
                Action = acReimprimirVoucher
                Caption = 'R&eimprimir Voucher'
              end>
            Caption = '&Venta'
          end
          item
            Action = Action3
            Caption = '&Ultima Venta'
            ShortCut = 16469
          end
          item
            Items = <
              item
                Action = Action5
                Caption = 'C&alendario'
                ImageIndex = 9
                ShortCut = 16474
              end>
            Caption = 'U&tilerias'
          end
          item
            Items = <
              item
                Action = acReimprimirVoucher
                Caption = '&Reimprimir Voucher'
                ImageIndex = 27
              end
              item
                Action = acCorteBanamex
                Caption = '&Corte'
                ImageIndex = 33
              end>
            Caption = '&Banamex'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 272
    Top = 184
    StyleName = 'Platform Default'
    object Action2: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action2Execute
    end
    object ac111: TAction
      Category = 'Venta'
      Caption = 'Asignarse'
      ImageIndex = 0
      ShortCut = 16449
      OnExecute = ac111Execute
    end
    object ac116: TAction
      Category = 'Venta'
      Caption = 'Desasignarse de la venta'
      Enabled = False
      ImageIndex = 31
      ShortCut = 16452
      OnExecute = ac116Execute
    end
    object ac160: TAction
      Category = 'Venta'
      Caption = 'Imprime Carga Inicial'
      Enabled = False
      ImageIndex = 5
      ShortCut = 16457
      OnExecute = ac160Execute
    end
    object ac179: TAction
      Category = 'Venta'
      Caption = 'Recoleccion'
      Enabled = False
      ImageIndex = 37
      ShortCut = 16466
      OnExecute = ac179Execute
    end
    object acboleto: TAction
      Category = 'Venta'
      Caption = 'Cancela Boleto'
      Enabled = False
      ImageIndex = 5
      ShortCut = 16450
      OnExecute = acboletoExecute
    end
    object acAnticipada: TAction
      Category = 'Venta'
      Caption = 'Boleto abierto'
      Enabled = False
      ImageIndex = 44
      ShortCut = 16463
      OnExecute = acAnticipadaExecute
    end
    object acimprimevta: TAction
      Category = 'Venta'
      Caption = 'Imprime Boleto Abierto'
      Enabled = False
      ImageIndex = 45
      ShortCut = 16461
      OnExecute = acimprimevtaExecute
    end
    object Action1: TAction
      Category = 'Venta'
      Caption = 'Cambio password'
      ImageIndex = 48
      ShortCut = 16464
      OnExecute = Action1Execute
    end
    object acPrueba: TAction
      Category = 'Venta'
      Caption = 'Prueba impresi'#243'n'
      ImageIndex = 5
      OnExecute = acPruebaExecute
    end
    object Action3: TAction
      Caption = 'Ultima Venta'
      ShortCut = 16469
      OnExecute = Action3Execute
    end
    object Action4: TAction
      Category = 'Utilerias'
      Caption = 'Calculadora'
      ImageIndex = 26
      ShortCut = 16460
      OnExecute = Action4Execute
    end
    object Action5: TAction
      Category = 'Utilerias'
      Caption = 'Calendario'
      ImageIndex = 9
      ShortCut = 16474
      OnExecute = Action5Execute
    end
    object acReimprimirVoucher: TAction
      Category = 'Banamex'
      Caption = 'Reimprimir Voucher'
      ImageIndex = 27
      OnExecute = acReimprimirVoucherExecute
    end
    object acCancela: TAction
      Caption = 'Cancela Reservacion'
      ShortCut = 16472
      OnExecute = acCancelaExecute
    end
    object acCorteBanamex: TAction
      Category = 'Banamex'
      Caption = 'Corte'
      ImageIndex = 33
      OnExecute = acCorteBanamexExecute
    end
  end
  object TRefrescaCorrida: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TRefrescaCorridaTimer
    Left = 328
    Top = 272
  end
  object TimerAsignado: TTimer
    Enabled = False
    OnTimer = TimerAsignadoTimer
    Left = 632
    Top = 336
  end
  object timer_pintabus: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = timer_pintabusTimer
    Left = 528
    Top = 216
  end
  object PopupMenu: TPopupMenu
    Images = DM.img_iconos
    Left = 440
    Top = 192
    object Predespachar1: TMenuItem
      Caption = 'Predespachar'
      ImageIndex = 39
      ShortCut = 16464
      OnClick = Predespachar1Click
    end
    object Agrupar1: TMenuItem
      Caption = 'Agrupar'
      ImageIndex = 40
      ShortCut = 16455
      OnClick = Agrupar1Click
    end
    object Modificar1: TMenuItem
      Caption = 'Modificar cupos'
      ImageIndex = 22
      ShortCut = 16461
      OnClick = Modificar1Click
    end
    object Cerrarcorrida1: TMenuItem
      Caption = 'Cerrar corrida'
      ImageIndex = 46
      ShortCut = 16451
      OnClick = Cerrarcorrida1Click
    end
    object Apartaasientos1: TMenuItem
      Caption = 'Aparta asientos'
      ImageIndex = 16
      ShortCut = 16471
      OnClick = Apartaasientos1Click
    end
    object arjetadeviaje1: TMenuItem
      Caption = 'Tarjeta de viaje'
      ImageIndex = 44
      ShortCut = 16468
      OnClick = arjetadeviaje1Click
    end
    object VentaReservados1: TMenuItem
      Caption = 'Venta Reservados'
      ShortCut = 16459
      OnClick = VentaReservados1Click
    end
    object CancelaReservacion1: TMenuItem
      Caption = 'Cancela Reservacion'
      ShortCut = 16456
      OnClick = CancelaReservacion1Click
    end
    object LiberaCorrida1: TMenuItem
      Caption = 'Libera Corrida'
      ShortCut = 16460
      OnClick = LiberaCorrida1Click
    end
    object CorridaExtra1: TMenuItem
      Caption = 'Corrida Extra'
      ShortCut = 16453
      OnClick = CorridaExtra1Click
    end
    object CancelaReservacion2: TMenuItem
      Action = acCancela
    end
  end
  object timer_Hora: TTimer
    OnTimer = timer_HoraTimer
    Left = 688
    Top = 216
  end
  object Timer_guias: TTimer
    Enabled = False
    Left = 720
    Top = 112
  end
  object Tping: TTimer
    Enabled = False
    OnTimer = TpingTimer
    Left = 368
    Top = 160
  end
end
