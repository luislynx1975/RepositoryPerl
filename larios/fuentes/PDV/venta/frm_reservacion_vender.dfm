object frm_reservados_vta: Tfrm_reservados_vta
  Left = 234
  Top = 105
  Hint = 'F1 = Busca, F5 = Cancelar'
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Venta de reservaciones'
  ClientHeight = 683
  ClientWidth = 1012
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 218
    Top = 27
    Width = 1
    Height = 637
    ExplicitLeft = 305
    ExplicitTop = 25
    ExplicitHeight = 683
  end
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 218
    Height = 637
    Align = alLeft
    TabOrder = 0
    ExplicitHeight = 636
    object Label4: TLabel
      Left = 10
      Top = 335
      Width = 173
      Height = 13
      Caption = 'A estatus de apartado no se puede '
    end
    object Label5: TLabel
      Left = 10
      Top = 354
      Width = 123
      Height = 13
      Caption = 'vender un lugar apartado'
    end
    object Label6: TLabel
      Left = 10
      Top = 433
      Width = 166
      Height = 13
      Caption = 'R estatus de un asiento reservado'
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 1
      Width = 250
      Height = 328
      Caption = 'Busqueda '
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 29
        Width = 106
        Height = 13
        Caption = 'Nombre Reservacion :'
      end
      object stg_names: TStringGrid
        Left = 3
        Top = 75
        Width = 245
        Height = 186
        Hint = 'Presione enter'
        ColCount = 2
        DefaultRowHeight = 19
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
        TabOrder = 1
        OnKeyPress = stg_namesKeyPress
        ColWidths = (
          145
          64)
      end
      object medt_fecha: TMaskEdit
        Left = 16
        Top = 48
        Width = 112
        Height = 21
        EditMask = '!99/99/9999;1;_'
        MaxLength = 10
        TabOrder = 0
        Text = '  /  /    '
        OnEnter = medt_fechaEnter
        OnKeyPress = medt_fechaKeyPress
      end
    end
  end
  object pnl_corrida_bus: TPanel
    Left = 219
    Top = 27
    Width = 793
    Height = 637
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 789
    ExplicitHeight = 636
    object Splitter2: TSplitter
      Left = 1
      Top = 321
      Width = 791
      Height = 8
      Cursor = crVSplit
      Align = alTop
      ExplicitLeft = 48
      ExplicitWidth = 897
    end
    object pnl_main_corrida: TPanel
      Left = 1
      Top = 1
      Width = 791
      Height = 320
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 787
      object grp_vta_reservados: TGroupBox
        Left = 1
        Top = 1
        Width = 789
        Height = 318
        Align = alClient
        Caption = 'Venta de Asientos reservados'
        TabOrder = 1
        ExplicitWidth = 785
        object Label3: TLabel
          Left = 56
          Top = 83
          Width = 91
          Height = 13
          Caption = 'Asientos a vender:'
        end
        object Label2: TLabel
          Left = 56
          Top = 28
          Width = 98
          Height = 13
          Caption = 'Asientos reservados'
        end
        object edt_lugares: TEdit
          Left = 56
          Top = 102
          Width = 201
          Height = 21
          TabOrder = 0
          OnKeyPress = edt_lugaresKeyPress
        end
        object edt_reservados: TEdit
          Left = 56
          Top = 47
          Width = 121
          Height = 21
          Enabled = False
          TabOrder = 1
        end
      end
      object grp_corridas_reservados: TGroupBox
        Left = 1
        Top = 1
        Width = 789
        Height = 318
        Align = alClient
        Caption = 'Corridas reservadas:'
        TabOrder = 0
        ExplicitWidth = 785
        object stg_corrida: TStringGrid
          Left = 2
          Top = 15
          Width = 785
          Height = 301
          Align = alClient
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
          Visible = False
          OnKeyPress = stg_corridaKeyPress
          OnKeyUp = stg_corridaKeyUp
          OnMouseDown = stg_corridaMouseDown
          ExplicitWidth = 781
        end
      end
    end
    object pnlBUS: TPanel
      Left = 1
      Top = 329
      Width = 791
      Height = 307
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 787
      ExplicitHeight = 306
      object Image: TImage
        Left = 0
        Top = 0
        Width = 105
        Height = 105
      end
      object Label100: TLabel
        Left = 768
        Top = 0
        Width = 43
        Height = 13
        Caption = 'Label100'
      end
      object Label101: TLabel
        Left = 768
        Top = 12
        Width = 43
        Height = 13
        Caption = 'Label101'
      end
      object Label102: TLabel
        Left = 768
        Top = 26
        Width = 43
        Height = 13
        Caption = 'Label102'
      end
      object Label103: TLabel
        Left = 768
        Top = 39
        Width = 43
        Height = 13
        Caption = 'Label103'
      end
      object Label104: TLabel
        Left = 768
        Top = 58
        Width = 43
        Height = 13
        Caption = 'Label104'
      end
      object Label105: TLabel
        Left = 768
        Top = 72
        Width = 43
        Height = 13
        Caption = 'Label105'
      end
      object Label106: TLabel
        Left = 768
        Top = 88
        Width = 43
        Height = 13
        Caption = 'Label106'
      end
      object Label107: TLabel
        Left = 768
        Top = 104
        Width = 43
        Height = 13
        Caption = 'Label107'
      end
      object Label108: TLabel
        Left = 768
        Top = 119
        Width = 43
        Height = 13
        Caption = 'Label108'
      end
      object Label109: TLabel
        Left = 768
        Top = 134
        Width = 43
        Height = 13
        Caption = 'Label109'
      end
      object Label110: TLabel
        Left = 768
        Top = 148
        Width = 43
        Height = 13
        Caption = 'Label110'
      end
      object Label111: TLabel
        Left = 768
        Top = 162
        Width = 43
        Height = 13
        Caption = 'Label111'
      end
      object Label112: TLabel
        Left = 768
        Top = 175
        Width = 43
        Height = 13
        Caption = 'Label112'
      end
      object Label113: TLabel
        Left = 768
        Top = 189
        Width = 43
        Height = 13
        Caption = 'Label113'
      end
      object Label114: TLabel
        Left = 768
        Top = 202
        Width = 43
        Height = 13
        Caption = 'Label114'
      end
      object Label115: TLabel
        Left = 768
        Top = 215
        Width = 43
        Height = 13
        Caption = 'Label115'
      end
      object Label116: TLabel
        Left = 768
        Top = 228
        Width = 43
        Height = 13
        Caption = 'Label116'
      end
      object Label117: TLabel
        Left = 768
        Top = 241
        Width = 43
        Height = 13
        Caption = 'Label117'
      end
      object Label118: TLabel
        Left = 768
        Top = 255
        Width = 43
        Height = 13
        Caption = 'Label118'
      end
      object Label119: TLabel
        Left = 768
        Top = 268
        Width = 43
        Height = 13
        Caption = 'Label119'
      end
      object Label120: TLabel
        Left = 768
        Top = 281
        Width = 43
        Height = 13
        Caption = 'Label120'
      end
      object Label121: TLabel
        Left = 768
        Top = 293
        Width = 43
        Height = 13
        Caption = 'Label121'
      end
      object Label122: TLabel
        Left = 768
        Top = 307
        Width = 43
        Height = 13
        Caption = 'Label122'
      end
      object Label123: TLabel
        Left = 768
        Top = 321
        Width = 43
        Height = 13
        Caption = 'Label123'
      end
      object Label124: TLabel
        Left = 768
        Top = 335
        Width = 43
        Height = 13
        Caption = 'Label124'
      end
      object Label125: TLabel
        Left = 768
        Top = 349
        Width = 43
        Height = 13
        Caption = 'Label125'
      end
      object Label126: TLabel
        Left = 836
        Top = 0
        Width = 43
        Height = 13
        Caption = 'Label126'
      end
      object Label127: TLabel
        Left = 836
        Top = 11
        Width = 43
        Height = 13
        Caption = 'Label127'
      end
      object Label128: TLabel
        Left = 836
        Top = 24
        Width = 43
        Height = 13
        Caption = 'Label128'
      end
      object Label129: TLabel
        Left = 836
        Top = 39
        Width = 43
        Height = 13
        Caption = 'Label129'
      end
      object Label130: TLabel
        Left = 836
        Top = 51
        Width = 43
        Height = 13
        Caption = 'Label130'
      end
      object Label131: TLabel
        Left = 835
        Top = 63
        Width = 43
        Height = 13
        Caption = 'Label131'
      end
      object Label132: TLabel
        Left = 835
        Top = 76
        Width = 43
        Height = 13
        Caption = 'Label132'
      end
      object Label133: TLabel
        Left = 835
        Top = 89
        Width = 43
        Height = 13
        Caption = 'Label133'
      end
      object Label134: TLabel
        Left = 835
        Top = 104
        Width = 43
        Height = 13
        Caption = 'Label134'
      end
      object Label135: TLabel
        Left = 835
        Top = 119
        Width = 43
        Height = 13
        Caption = 'Label135'
      end
      object Label136: TLabel
        Left = 835
        Top = 133
        Width = 43
        Height = 13
        Caption = 'Label136'
      end
      object Label137: TLabel
        Left = 835
        Top = 148
        Width = 43
        Height = 13
        Caption = 'Label137'
      end
      object Label138: TLabel
        Left = 835
        Top = 163
        Width = 43
        Height = 13
        Caption = 'Label138'
      end
      object Label139: TLabel
        Left = 835
        Top = 178
        Width = 43
        Height = 13
        Caption = 'Label139'
      end
      object Label140: TLabel
        Left = 835
        Top = 193
        Width = 43
        Height = 13
        Caption = 'Label140'
      end
      object Label141: TLabel
        Left = 835
        Top = 210
        Width = 43
        Height = 13
        Caption = 'Label141'
      end
      object Label142: TLabel
        Left = 835
        Top = 225
        Width = 43
        Height = 13
        Caption = 'Label142'
      end
      object Label143: TLabel
        Left = 835
        Top = 239
        Width = 43
        Height = 13
        Caption = 'Label143'
      end
      object Label144: TLabel
        Left = 835
        Top = 255
        Width = 43
        Height = 13
        Caption = 'Label144'
      end
      object Label145: TLabel
        Left = 835
        Top = 270
        Width = 43
        Height = 13
        Caption = 'Label145'
      end
      object Label146: TLabel
        Left = 835
        Top = 285
        Width = 43
        Height = 13
        Caption = 'Label146'
      end
      object Label147: TLabel
        Left = 835
        Top = 299
        Width = 43
        Height = 13
        Caption = 'Label147'
      end
      object Label148: TLabel
        Left = 835
        Top = 315
        Width = 43
        Height = 13
        Caption = 'Label148'
      end
      object Label149: TLabel
        Left = 834
        Top = 330
        Width = 43
        Height = 13
        Caption = 'Label149'
      end
      object Label150: TLabel
        Left = 832
        Top = 345
        Width = 43
        Height = 13
        Caption = 'Label150'
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 664
    Width = 1012
    Height = 19
    Panels = <
      item
        Text = 'Presione enter en la fecha a buscar '
        Width = 100
      end>
    ExplicitTop = 663
    ExplicitWidth = 1008
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
    ExplicitWidth = 1008
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
      end
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
    Left = 248
    Top = 40
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
