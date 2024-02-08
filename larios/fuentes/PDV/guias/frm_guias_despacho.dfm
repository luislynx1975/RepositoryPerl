object frm_guias_servicio: Tfrm_guias_servicio
  Left = 88
  Top = 29
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Guias de viaje'
  ClientHeight = 697
  ClientWidth = 1067
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object img_central: TImage
    Left = 860
    Top = 456
    Width = 142
    Height = 141
    Transparent = True
  end
  object pnl_lector: TPanel
    Left = 719
    Top = 22
    Width = 356
    Height = 270
    TabOrder = 7
    Visible = False
    object SpeedButton3: TSpeedButton
      Left = 207
      Top = 130
      Width = 87
      Height = 22
      Caption = 'Registro Manual'
      OnClick = SpeedButton3Click
    end
    object edt_barras: TEdit
      Left = 23
      Top = 31
      Width = 266
      Height = 21
      TabOrder = 0
      OnChange = edt_barrasChange
      OnKeyPress = edt_barrasKeyPress
    end
    object lst_mensaje: TListBox
      Left = 24
      Top = 63
      Width = 305
      Height = 48
      BorderStyle = bsNone
      Color = clMenu
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      TabOrder = 1
    end
    object Memo1: TMemo
      Left = 16
      Top = 180
      Width = 319
      Height = 46
      BorderStyle = bsNone
      Color = clMenu
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'Escanea el c'#243'digo de barras que '
        'viene impreso en la gu'#237'a de viaje.')
      ParentFont = False
      TabOrder = 2
    end
  end
  object gpo_tarjeta: TGroupBox
    Left = 721
    Top = 24
    Width = 354
    Height = 272
    Caption = 'Generar tarjeta de viaje'
    TabOrder = 1
    Visible = False
    object Label1: TLabel
      Left = 22
      Top = 151
      Width = 53
      Height = 13
      Caption = 'Operador :'
    end
    object Label3: TLabel
      Left = 28
      Top = 128
      Width = 47
      Height = 13
      Caption = 'Autobus :'
    end
    object Label5: TLabel
      Left = 237
      Top = 17
      Width = 30
      Height = 13
      Caption = 'Ruta :'
    end
    object Label6: TLabel
      Left = 2
      Top = 42
      Width = 76
      Height = 13
      Caption = 'Hora de Salida :'
    end
    object Label7: TLabel
      Left = 140
      Top = 30
      Width = 36
      Height = 13
      Caption = 'Fecha :'
    end
    object lbl_ruta: TLabel
      Left = 274
      Top = 16
      Width = 3
      Height = 13
    end
    object lbl_hora: TLabel
      Left = 82
      Top = 42
      Width = 3
      Height = 13
    end
    object lbl_fecha: TLabel
      Left = 183
      Top = 30
      Width = 3
      Height = 13
    end
    object lbl_terminal: TLabel
      Left = 1
      Top = 16
      Width = 77
      Height = 13
      Caption = 'Clave Terminal :'
    end
    object lbl_destino: TLabel
      Left = 2
      Top = 30
      Width = 43
      Height = 13
      Caption = 'Destino :'
    end
    object Label2: TLabel
      Left = 3
      Top = 246
      Width = 81
      Height = 13
      Caption = 'Total pasajeros :'
    end
    object lbl_proveedor: TLabel
      Left = 18
      Top = 59
      Width = 57
      Height = 13
      Caption = 'Proveedor :'
    end
    object lbl_cuota: TLabel
      Left = 39
      Top = 83
      Width = 36
      Height = 13
      Caption = 'Cuota :'
    end
    object lbl_folio: TLabel
      Left = 46
      Top = 106
      Width = 29
      Height = 13
      Caption = 'Folio :'
    end
    object lbl_cemos_tipo: TLabel
      Left = 16
      Top = 174
      Width = 59
      Height = 13
      Caption = 'Tipo CEMO :'
      Visible = False
    end
    object lbl_folio_cemo: TLabel
      Left = 14
      Top = 197
      Width = 61
      Height = 13
      Caption = 'Folio CEMO :'
      Visible = False
    end
    object Label4: TLabel
      Left = 5
      Top = 219
      Width = 72
      Height = 13
      Caption = 'Folio Boletera :'
    end
    object cmb_operador1: TlsComboBox
      Left = 78
      Top = 148
      Width = 236
      Height = 21
      TabOrder = 4
      OnKeyPress = cmb_operador1KeyPress
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object Panel2: TPanel
      Left = 172
      Top = 238
      Width = 127
      Height = 29
      TabOrder = 7
      object SpeedButton2: TSpeedButton
        Left = 1
        Top = 1
        Width = 125
        Height = 27
        Action = acGuadarGuia
        Align = alClient
        Visible = False
        ExplicitLeft = 20
        ExplicitTop = 4
        ExplicitWidth = 23
        ExplicitHeight = 22
      end
      object SpeedButton1: TSpeedButton
        Left = 1
        Top = 2
        Width = 125
        Height = 27
        Action = ac155
        Align = alCustom
      end
    end
    object edt_total_pax: TEdit
      Left = 87
      Top = 243
      Width = 69
      Height = 21
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
    end
    object cmb_proveedor: TlsComboBox
      Left = 77
      Top = 56
      Width = 273
      Height = 21
      AutoDropDown = True
      CharCase = ecUpperCase
      DropDownCount = 10
      TabOrder = 0
      OnKeyPress = cmb_proveedorKeyPress
      OnSelect = cmb_proveedorSelect
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object cmb_cuota: TlsComboBox
      Left = 78
      Top = 79
      Width = 235
      Height = 21
      AutoDropDown = True
      CharCase = ecUpperCase
      TabOrder = 1
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object edt_folio: TEdit
      Left = 78
      Top = 102
      Width = 121
      Height = 21
      TabOrder = 2
      OnChange = edt_folioChange
      OnExit = edt_folioExit
    end
    object cmb_cemos: TComboBox
      Left = 78
      Top = 171
      Width = 236
      Height = 21
      TabOrder = 5
      Visible = False
      Items.Strings = (
        'No aplica'
        'No laboro servicio medico'
        'Servicio medico suspendido'
        'Servicio medico CEMO')
    end
    object edt_folio_cemos: TEdit
      Left = 78
      Top = 194
      Width = 121
      Height = 21
      TabOrder = 6
      Visible = False
      OnChange = edt_folio_cemosChange
    end
    object cmb_autobus: TlsComboBox
      Left = 78
      Top = 125
      Width = 236
      Height = 21
      TabOrder = 3
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object edt_boletera: TEdit
      Left = 78
      Top = 217
      Width = 121
      Height = 21
      TabOrder = 9
      OnChange = edt_boleteraChange
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 678
    Width = 1067
    Height = 19
    Panels = <
      item
        Text = 
          'Seleccione la corrida en estatus "Abierta" y presione Enter para' +
          ' Predespacharla'
        Width = 200
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 713
    Height = 409
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 711
      Height = 407
      Align = alClient
      Caption = 'Corridas'
      TabOrder = 0
      object stg_despacho: TStringGrid
        Left = 2
        Top = 15
        Width = 707
        Height = 390
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
        PopupMenu = PopupMenu1
        TabOrder = 0
        OnKeyPress = stg_despachoKeyPress
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
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 1067
    Height = 27
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
    ExplicitWidth = 1063
  end
  object Panel3: TPanel
    Left = 721
    Top = 297
    Width = 356
    Height = 136
    TabOrder = 2
    Visible = False
    object stg_detalle_ocupantes: TStringGrid
      Left = 1
      Top = 1
      Width = 354
      Height = 134
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 15
      Enabled = False
      FixedCols = 0
      RowCount = 2
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      ParentFont = False
      TabOrder = 0
      ColWidths = (
        64
        65)
    end
  end
  object pnlBUS: TPanel
    Left = -1
    Top = 437
    Width = 797
    Height = 239
    BorderStyle = bsSingle
    TabOrder = 3
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
      Left = 794
      Top = -2
      Width = 43
      Height = 13
      Caption = 'Label100'
    end
  end
  object mem_conectado: TMemo
    Left = 802
    Top = 603
    Width = 261
    Height = 68
    BorderStyle = bsNone
    Color = clMenu
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
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
                Action = ac99
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end
          item
            Action = ac156
            Caption = '&Imprime'
            ShortCut = 16457
          end
          item
            Action = ac157
            Caption = '&Reserva asientos'
            ShortCut = 16466
          end>
        ActionBar = ActionMainMenuBar1
      end
      item
      end>
    Images = DM.img_iconos
    Left = 128
    Top = 192
    StyleName = 'Platform Default'
    object ac155: TAction
      Tag = 155
      Caption = 'Despacha'
      ImageIndex = 28
      OnExecute = ac155Execute
    end
    object ac156: TAction
      Tag = 156
      Caption = 'Imprime'
      ShortCut = 16457
      OnExecute = ac156Execute
    end
    object ac157: TAction
      Tag = 157
      Caption = 'Reserva asientos'
      ShortCut = 16466
      OnExecute = ac157Execute
    end
    object ac99: TAction
      Tag = 99
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = ac99Execute
    end
    object acGuadarGuia: TAction
      Caption = 'Guadar'
      ImageIndex = 17
      OnExecute = acGuadarGuiaExecute
    end
  end
  object SimpleDataSet1: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 320
    Top = 152
  end
  object Timer: TTimer
    Enabled = False
    Interval = 30000
    OnTimer = TimerTimer
    Left = 112
    Top = 128
  end
  object PopupMenu1: TPopupMenu
    Left = 424
    Top = 160
    object Abrir1: TMenuItem
      Caption = 'Abrir corrida'
      ShortCut = 16449
      OnClick = Abrir1Click
    end
    object Cerrar1: TMenuItem
      Caption = 'Cerrar corrida'
      ShortCut = 16451
      OnClick = Cerrar1Click
    end
    object Predespacharcorrida1: TMenuItem
      Caption = 'Predespachar corrida'
      ShortCut = 16464
      OnClick = Predespacharcorrida1Click
    end
    object Despachar: TMenuItem
      Caption = 'Despachar corrida'
      ShortCut = 16452
      OnClick = DespacharClick
    end
    object Reimprime1: TMenuItem
      Caption = 'Reimprime'
      ShortCut = 16466
      OnClick = Reimprime1Click
    end
    object ApartaAsientos1: TMenuItem
      Caption = 'Aparta Asientos'
      ShortCut = 16468
      OnClick = ApartaAsientos1Click
    end
    object CodigoBarras1: TMenuItem
      Caption = 'Codigo Barras'
      ShortCut = 16450
      OnClick = CodigoBarras1Click
    end
  end
  object Timer_guias: TTimer
    Enabled = False
    Left = 528
    Top = 168
  end
  object Tping: TTimer
    Enabled = False
    OnTimer = TpingTimer
    Left = 168
    Top = 304
  end
end
