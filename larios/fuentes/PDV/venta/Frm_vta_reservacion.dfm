object Frm_reservacion: TFrm_reservacion
  Left = 236
  Top = 130
  BorderIcons = []
  Caption = 'Pantalla para el registro de reservaciones'
  ClientHeight = 658
  ClientWidth = 992
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 204
    Height = 631
    Align = alLeft
    TabOrder = 0
    object Grp_busqueda: TGroupBox
      Left = 1
      Top = 1
      Width = 202
      Height = 181
      Align = alTop
      Caption = 'Buscar corrida'
      Color = clSilver
      ParentBackground = False
      ParentColor = False
      TabOrder = 0
      object Label7: TLabel
        Left = 3
        Top = 131
        Width = 44
        Height = 13
        Caption = 'Servicio :'
      end
      object Label6: TLabel
        Left = 3
        Top = 109
        Width = 30
        Height = 13
        Caption = 'Hora :'
      end
      object Label5: TLabel
        Left = 3
        Top = 86
        Width = 43
        Height = 13
        Caption = 'Destino :'
      end
      object Label4: TLabel
        Left = 3
        Top = 64
        Width = 39
        Height = 13
        Caption = 'Origen :'
      end
      object Label2: TLabel
        Left = 3
        Top = 41
        Width = 36
        Height = 13
        Caption = 'Fecha :'
      end
      object Label1: TLabel
        Left = 3
        Top = 22
        Width = 75
        Height = 13
        Caption = 'Ciudad Origen :'
      end
      object Label8: TLabel
        Left = 3
        Top = 155
        Width = 42
        Height = 13
        Caption = 'Corrida :'
      end
      object ls_servicio: TlsComboBox
        Left = 45
        Top = 128
        Width = 150
        Height = 21
        Style = csSimple
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 5
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ls_Desde_vta: TlsComboBox
        Left = 45
        Top = 83
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
      object Ed_Hora: TEdit
        Left = 45
        Top = 105
        Width = 122
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 4
      end
      object ls_Origen_vta: TlsComboBox
        Left = 45
        Top = 61
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
        OnExit = ls_Origen_vtaExit
        OnKeyPress = ls_Origen_vtaKeyPress
        Complete = False
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object medt_fecha: TMaskEdit
        Left = 45
        Top = 38
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
        OnExit = medt_fechaExit
        OnKeyPress = medt_fechaKeyPress
      end
      object ls_Origen_: TlsComboBox
        Left = 81
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
      object edt_corrida: TEdit
        Left = 45
        Top = 152
        Width = 121
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 6
        OnChange = edt_corridaChange
      end
    end
    object GroupBox2: TGroupBox
      Left = 1
      Top = 182
      Width = 202
      Height = 198
      Align = alTop
      Caption = 'Disponibilidad'
      Color = clSilver
      ParentBackground = False
      ParentColor = False
      TabOrder = 1
      object stg_ocupantes: TStringGrid
        Left = 2
        Top = 15
        Width = 198
        Height = 181
        Align = alClient
        Color = clScrollBar
        ColCount = 2
        DefaultRowHeight = 18
        Enabled = False
        FixedCols = 0
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          121
          64)
      end
    end
    object GroupBox3: TGroupBox
      Left = 1
      Top = 380
      Width = 202
      Height = 250
      Align = alClient
      Caption = 'Detalle de ruta'
      Color = clSilver
      ParentBackground = False
      ParentColor = False
      TabOrder = 2
      object stg_detalle: TStringGrid
        Left = 2
        Top = 15
        Width = 198
        Height = 234
        Align = alClient
        ColCount = 2
        DefaultRowHeight = 18
        Enabled = False
        FixedCols = 0
        RowCount = 2
        FixedRows = 0
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
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
  end
  object pnl_base: TPanel
    Left = 204
    Top = 27
    Width = 788
    Height = 631
    Align = alClient
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 33
      Top = 680
      Width = 878
      Height = 7
      Align = alNone
    end
    object pnl_corridas: TPanel
      Left = 1
      Top = 1
      Width = 790
      Height = 408
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 786
      object grp_reserva: TGroupBox
        Left = 1
        Top = 1
        Width = 788
        Height = 406
        Align = alClient
        Caption = 'Asientos a reservar'
        Color = clSilver
        ParentBackground = False
        ParentColor = False
        TabOrder = 1
        Visible = False
        ExplicitWidth = 784
        object lbl_cuantos: TLabel
          Left = 72
          Top = 92
          Width = 114
          Height = 13
          Caption = 'Asientos a reservar:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label3: TLabel
          Left = 41
          Top = 143
          Width = 150
          Height = 13
          Caption = 'Nombre de la reservacion :'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edt_cuantos: TEdit
          Left = 195
          Top = 89
          Width = 136
          Height = 21
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          OnChange = edt_cuantosChange
          OnEnter = edt_cuantosEnter
          OnExit = edt_cuantosExit
        end
        object edt_nombre: TEdit
          Left = 195
          Top = 136
          Width = 321
          Height = 21
          CharCase = ecUpperCase
          Color = clBtnFace
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          OnChange = edt_nombreChange
          OnEnter = edt_nombreEnter
          OnKeyPress = edt_nombreKeyPress
        end
      end
      object Grp_corrida: TGroupBox
        Left = 1
        Top = 1
        Width = 788
        Height = 406
        Align = alClient
        Caption = 'Corridas'
        TabOrder = 0
        ExplicitWidth = 784
        object stg_corrida: TStringGrid
          Left = 2
          Top = 15
          Width = 784
          Height = 389
          Align = alClient
          ColCount = 14
          DefaultRowHeight = 20
          FixedCols = 0
          RowCount = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColMoving, goRowSelect]
          ParentFont = False
          TabOrder = 0
          OnDrawCell = stg_corridaDrawCell
          OnKeyPress = stg_corridaKeyPress
          OnKeyUp = stg_corridaKeyUp
          OnMouseDown = stg_corridaMouseDown
          ExplicitWidth = 780
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
    object pnl_autobus: TPanel
      Left = 2
      Top = 411
      Width = 878
      Height = 240
      BorderStyle = bsSingle
      Color = clSilver
      ParentBackground = False
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
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 992
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
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end
      item
      end>
    Images = DM.img_iconos
    Left = 304
    Top = 56
    StyleName = 'XP Style'
    object Action1: TAction
      Category = 'Sistema'
      Caption = '&Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action1Execute
    end
  end
  object timer_pintabus: TTimer
    Enabled = False
    OnTimer = timer_pintabusTimer
    Left = 448
    Top = 48
  end
end
