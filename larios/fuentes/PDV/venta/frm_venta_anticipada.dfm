object frm_vta_anticipada: Tfrm_vta_anticipada
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Pantalla para la venta anticipada'
  ClientHeight = 463
  ClientWidth = 604
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 25
    Width = 620
    Height = 150
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = -1
      Top = 1
      Width = 283
      Height = 142
      Caption = 'Datos para la venta'
      TabOrder = 0
      object Label1: TLabel
        Left = 4
        Top = 18
        Width = 39
        Height = 13
        Caption = 'Origen :'
      end
      object Label2: TLabel
        Left = 23
        Top = 52
        Width = 39
        Height = 13
        Caption = 'Origen :'
      end
      object Label3: TLabel
        Left = 19
        Top = 79
        Width = 43
        Height = 13
        Caption = 'Destino :'
      end
      object Label7: TLabel
        Left = 17
        Top = 103
        Width = 47
        Height = 13
        Caption = 'Servicio : '
      end
      object ls_origen: TlsComboBox
        Left = 49
        Top = 17
        Width = 233
        Height = 19
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ls_Origen_vta: TlsComboBox
        Left = 66
        Top = 49
        Width = 210
        Height = 21
        CharCase = ecUpperCase
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        OnKeyPress = ls_origen_vtaKeyPress
        Complete = False
        ForceIndexOnExit = False
        MinLengthComplete = 0
      end
      object ls_servicio: TlsComboBox
        Left = 66
        Top = 103
        Width = 185
        Height = 21
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnClick = ls_servicioClick
        OnEnter = ls_servicioEnter
        OnExit = ls_servicioExit
        Complete = False
        ForceIndexOnExit = False
        MinLengthComplete = 0
      end
      object ls_destino_vta: TlsComboBox
        Left = 66
        Top = 78
        Width = 184
        Height = 19
        CharCase = ecUpperCase
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -9
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
        OnClick = ls_destino_vtaClick
        OnKeyPress = ls_destino_vtaKeyPress
        Complete = False
        ForceIndexOnExit = False
        MinLengthComplete = 0
      end
    end
    object GroupBox3: TGroupBox
      Left = 278
      Top = 5
      Width = 333
      Height = 142
      TabOrder = 1
      object GroupBox4: TGroupBox
        Left = 2
        Top = 15
        Width = 329
        Height = 118
        Align = alTop
        Caption = 'Datos del servicio y tarifa'
        TabOrder = 0
        object Label4: TLabel
          Left = 65
          Top = 76
          Width = 35
          Height = 13
          Caption = 'Tarifa :'
        end
        object lbl_servicio: TLabel
          Left = 53
          Top = 24
          Width = 44
          Height = 13
          Caption = 'Servicio :'
        end
        object lbl_fecha: TLabel
          Left = 33
          Top = 43
          Width = 67
          Height = 13
          Caption = 'Fecha venta :'
        end
        object lbl_server: TLabel
          Left = 105
          Top = 43
          Width = 4
          Height = 13
          Caption = '.'
        end
        object edt_tarifa: TEdit
          Left = 108
          Top = 73
          Width = 121
          Height = 21
          Alignment = taRightJustify
          Enabled = False
          TabOrder = 0
          Text = '0'
        end
      end
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 604
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
    Font.Height = -15
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
    ExplicitWidth = 600
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 444
    Width = 604
    Height = 19
    Panels = <
      item
        Text = 'F1 Buscar'
        Width = 50
      end>
    ExplicitTop = 443
    ExplicitWidth = 600
  end
  object StatusBar2: TStatusBar
    Left = 0
    Top = 425
    Width = 604
    Height = 19
    Panels = <>
    ExplicitTop = 424
    ExplicitWidth = 600
  end
  object grb_grid: TGroupBox
    Left = 0
    Top = 162
    Width = 604
    Height = 263
    Align = alBottom
    TabOrder = 4
    Visible = False
    ExplicitTop = 161
    ExplicitWidth = 600
    object Label5: TLabel
      Left = 88
      Top = 11
      Width = 77
      Height = 13
      Caption = 'Total de boletos'
    end
    object Label6: TLabel
      Left = 88
      Top = 67
      Width = 126
      Height = 13
      Caption = '# Pasajero con descuento'
    end
    object stg_visor: TStringGrid
      Left = 338
      Top = 40
      Width = 239
      Height = 145
      ColCount = 2
      Enabled = False
      FixedCols = 0
      TabOrder = 0
      ColWidths = (
        84
        145)
    end
    object edt_cuantos: TEdit
      Left = 88
      Top = 27
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 1
      OnChange = edt_cuantosChange
      OnKeyPress = edt_cuantosKeyPress
    end
    object edt_tipo: TEdit
      Left = 88
      Top = 86
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 2
      OnChange = edt_tipoChange
      OnEnter = edt_tipoEnter
      OnKeyPress = edt_tipoKeyPress
    end
    object mem_mensaje: TMemo
      Left = 36
      Top = 113
      Width = 294
      Height = 136
      Color = clMenu
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -17
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action2
                Caption = '&Vender'
                ImageIndex = 0
                ShortCut = 16470
              end
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
    Left = 536
    StyleName = 'Platform Default'
    object Action2: TAction
      Category = 'Sistema'
      Caption = 'Vender'
      ImageIndex = 0
      ShortCut = 16470
    end
    object Action1: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action1Execute
    end
  end
end
