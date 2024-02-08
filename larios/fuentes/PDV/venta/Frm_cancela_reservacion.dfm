object Frm_reserva_cancela: TFrm_reserva_cancela
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Pantalla para la cancelacion de reservaciones'
  ClientHeight = 659
  ClientWidth = 861
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object pnl_corrida_bus: TPanel
    Left = 0
    Top = 27
    Width = 861
    Height = 613
    Align = alClient
    TabOrder = 0
    ExplicitTop = 25
    ExplicitWidth = 871
    ExplicitHeight = 625
    object Splitter2: TSplitter
      Left = 1
      Top = 321
      Width = 869
      Height = 8
      Cursor = crVSplit
      Align = alTop
      ExplicitLeft = 0
      ExplicitTop = 377
      ExplicitWidth = 888
    end
    object pnl_main_corrida: TPanel
      Left = 1
      Top = 1
      Width = 869
      Height = 320
      Align = alTop
      TabOrder = 0
      object grp_vta_reservados: TGroupBox
        Left = 1
        Top = 1
        Width = 867
        Height = 318
        Align = alClient
        Caption = 'Venta de Asientos reservados'
        TabOrder = 1
        object Label3: TLabel
          Left = 136
          Top = 83
          Width = 91
          Height = 13
          Caption = 'Asientos a vender:'
        end
        object edt_lugares: TEdit
          Left = 136
          Top = 102
          Width = 201
          Height = 21
          TabOrder = 0
        end
      end
      object grp_corridas_reservados: TGroupBox
        Left = 1
        Top = 1
        Width = 867
        Height = 318
        Align = alClient
        Caption = 'Corridas reservadas:'
        TabOrder = 0
        object stg_corrida: TStringGrid
          Left = 2
          Top = 15
          Width = 375
          Height = 301
          Align = alLeft
          ColCount = 14
          DefaultColWidth = 90
          DefaultRowHeight = 20
          FixedCols = 0
          RowCount = 2
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Times New Roman'
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ParentFont = False
          TabOrder = 0
          OnKeyUp = stg_corridaKeyUp
          OnMouseDown = stg_corridaMouseDown
          ColWidths = (
            90
            90
            90
            90
            90
            90
            90
            46
            90
            90
            90
            90
            90
            90)
        end
        object stg_reservados: TStringGrid
          Left = 377
          Top = 15
          Width = 488
          Height = 301
          Align = alClient
          ColCount = 6
          DefaultRowHeight = 20
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          TabOrder = 1
          OnKeyPress = stg_reservadosKeyPress
          OnKeyUp = stg_reservadosKeyUp
          ColWidths = (
            245
            110
            64
            64
            64
            64)
        end
      end
    end
    object pnlBUS: TPanel
      Left = 1
      Top = 329
      Width = 869
      Height = 295
      Align = alClient
      BorderStyle = bsSingle
      TabOrder = 1
      object Image: TImage
        Left = 0
        Top = 0
        Width = 105
        Height = 105
      end
      object Label125: TLabel
        Left = 1072
        Top = 322
        Width = 43
        Height = 13
        Caption = 'Label125'
      end
      object Label150: TLabel
        Left = 1068
        Top = 308
        Width = 43
        Height = 13
        Caption = 'Label150'
      end
      object Label149: TLabel
        Left = 1084
        Top = 319
        Width = 43
        Height = 13
        Caption = 'Label149'
      end
      object Label148: TLabel
        Left = 1068
        Top = 311
        Width = 43
        Height = 13
        Caption = 'Label148'
      end
      object Label147: TLabel
        Left = 1068
        Top = 295
        Width = 43
        Height = 13
        Caption = 'Label147'
      end
      object Label146: TLabel
        Left = 1068
        Top = 281
        Width = 43
        Height = 13
        Caption = 'Label146'
      end
      object Label145: TLabel
        Left = 1068
        Top = 266
        Width = 43
        Height = 13
        Caption = 'Label145'
      end
      object Label144: TLabel
        Left = 1068
        Top = 251
        Width = 43
        Height = 13
        Caption = 'Label144'
      end
      object Label143: TLabel
        Left = 1068
        Top = 235
        Width = 43
        Height = 13
        Caption = 'Label143'
      end
      object Label142: TLabel
        Left = 1068
        Top = 221
        Width = 43
        Height = 13
        Caption = 'Label142'
      end
      object Label141: TLabel
        Left = 1068
        Top = 206
        Width = 43
        Height = 13
        Caption = 'Label141'
      end
      object Label140: TLabel
        Left = 1068
        Top = 189
        Width = 43
        Height = 13
        Caption = 'Label140'
      end
      object Label139: TLabel
        Left = 1068
        Top = 174
        Width = 43
        Height = 13
        Caption = 'Label139'
      end
      object Label138: TLabel
        Left = 1068
        Top = 159
        Width = 43
        Height = 13
        Caption = 'Label138'
      end
      object Label137: TLabel
        Left = 1068
        Top = 144
        Width = 43
        Height = 13
        Caption = 'Label137'
      end
      object Label136: TLabel
        Left = 1068
        Top = 129
        Width = 43
        Height = 13
        Caption = 'Label136'
      end
      object Label135: TLabel
        Left = 1068
        Top = 115
        Width = 43
        Height = 13
        Caption = 'Label135'
      end
      object Label134: TLabel
        Left = 1068
        Top = 100
        Width = 43
        Height = 13
        Caption = 'Label134'
      end
      object Label133: TLabel
        Left = 1068
        Top = 85
        Width = 43
        Height = 13
        Caption = 'Label133'
      end
      object Label132: TLabel
        Left = 1084
        Top = 65
        Width = 43
        Height = 13
        Caption = 'Label132'
      end
      object Label131: TLabel
        Left = 1068
        Top = 59
        Width = 43
        Height = 13
        Caption = 'Label131'
      end
      object Label130: TLabel
        Left = 1068
        Top = 26
        Width = 43
        Height = 13
        Caption = 'Label130'
      end
      object Label129: TLabel
        Left = 1068
        Top = 35
        Width = 43
        Height = 13
        Caption = 'Label129'
      end
      object Label128: TLabel
        Left = 1068
        Top = 20
        Width = 43
        Height = 13
        Caption = 'Label128'
      end
      object Label127: TLabel
        Left = 1068
        Top = 7
        Width = 43
        Height = 13
        Caption = 'Label127'
      end
      object Label126: TLabel
        Left = 1068
        Top = -4
        Width = 43
        Height = 13
        Caption = 'Label126'
      end
      object Label124: TLabel
        Left = 1064
        Top = 329
        Width = 43
        Height = 13
        Caption = 'Label124'
      end
      object Label123: TLabel
        Left = 1072
        Top = 310
        Width = 43
        Height = 13
        Caption = 'Label123'
      end
      object Label122: TLabel
        Left = 1072
        Top = 296
        Width = 43
        Height = 13
        Caption = 'Label122'
      end
      object Label121: TLabel
        Left = 1072
        Top = 282
        Width = 43
        Height = 13
        Caption = 'Label121'
      end
      object Label120: TLabel
        Left = 1072
        Top = 270
        Width = 43
        Height = 13
        Caption = 'Label120'
      end
      object Label119: TLabel
        Left = 1072
        Top = 257
        Width = 43
        Height = 13
        Caption = 'Label119'
      end
      object Label118: TLabel
        Left = 1072
        Top = 244
        Width = 43
        Height = 13
        Caption = 'Label118'
      end
      object Label117: TLabel
        Left = 1072
        Top = 230
        Width = 43
        Height = 13
        Caption = 'Label117'
      end
      object Label116: TLabel
        Left = 1072
        Top = 217
        Width = 43
        Height = 13
        Caption = 'Label116'
      end
      object Label115: TLabel
        Left = 1072
        Top = 204
        Width = 43
        Height = 13
        Caption = 'Label115'
      end
      object Label114: TLabel
        Left = 1072
        Top = 191
        Width = 43
        Height = 13
        Caption = 'Label114'
      end
      object Label113: TLabel
        Left = 1072
        Top = 178
        Width = 43
        Height = 13
        Caption = 'Label113'
      end
      object Label112: TLabel
        Left = 1072
        Top = 164
        Width = 43
        Height = 13
        Caption = 'Label112'
      end
      object Label111: TLabel
        Left = 1072
        Top = 151
        Width = 43
        Height = 13
        Caption = 'Label111'
      end
      object Label110: TLabel
        Left = 1072
        Top = 137
        Width = 43
        Height = 13
        Caption = 'Label110'
      end
      object Label109: TLabel
        Left = 1072
        Top = 123
        Width = 43
        Height = 13
        Caption = 'Label109'
      end
      object Label108: TLabel
        Left = 1072
        Top = 108
        Width = 43
        Height = 13
        Caption = 'Label108'
      end
      object Label107: TLabel
        Left = 1072
        Top = 93
        Width = 43
        Height = 13
        Caption = 'Label107'
      end
      object Label106: TLabel
        Left = 1072
        Top = 77
        Width = 43
        Height = 13
        Caption = 'Label106'
      end
      object Label105: TLabel
        Left = 1072
        Top = 61
        Width = 43
        Height = 13
        Caption = 'Label105'
      end
      object Label104: TLabel
        Left = 1072
        Top = 44
        Width = 43
        Height = 13
        Caption = 'Label104'
      end
      object Label103: TLabel
        Left = 1072
        Top = 28
        Width = 43
        Height = 13
        Caption = 'Label103'
      end
      object Label102: TLabel
        Left = 1072
        Top = 15
        Width = 43
        Height = 13
        Caption = 'Label102'
      end
      object Label101: TLabel
        Left = 1072
        Top = 1
        Width = 43
        Height = 13
        Caption = 'Label101'
      end
      object Label100: TLabel
        Left = 1056
        Top = -4
        Width = 43
        Height = 13
        Caption = 'Label100'
      end
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 861
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 640
    Width = 861
    Height = 19
    Panels = <
      item
        Text = 
          'Seleccione la corrida de lado izquierdo , se mostrara las reserv' +
          'aciones del lado derecho'
        Width = 50
      end>
    ExplicitTop = 650
    ExplicitWidth = 871
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 1
    OnTimer = Timer1Timer
    Left = 544
    Top = 368
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
      end>
    Images = DM.img_iconos
    Left = 232
    Top = 136
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Sistema'
      Caption = '&Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action1Execute
    end
  end
end
