object frm_taquilla: Tfrm_taquilla
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Configuracion Taquilla'
  ClientHeight = 401
  ClientWidth = 625
  Color = clBtnShadow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 78
    Top = 75
    Width = 47
    Height = 13
    Caption = 'Terminal :'
  end
  object Label2: TLabel
    Left = 68
    Top = 103
    Width = 57
    Height = 13
    Caption = 'ID Taquilla :'
  end
  object Label3: TLabel
    Left = 108
    Top = 48
    Width = 17
    Height = 13
    Caption = 'IP :'
  end
  object Label4: TLabel
    Left = 36
    Top = 131
    Width = 89
    Height = 13
    Caption = 'Impresora Boleto :'
  end
  object Label5: TLabel
    Left = 25
    Top = 161
    Width = 100
    Height = 13
    Caption = 'Impresora Opcional :'
  end
  object Label6: TLabel
    Left = 7
    Top = 188
    Width = 118
    Height = 13
    Caption = 'Tarjeta Fisica Banamex :'
  end
  object Label7: TLabel
    Left = 23
    Top = 214
    Width = 102
    Height = 13
    Caption = 'Apagado del equipo :'
  end
  object Label8: TLabel
    Left = 39
    Top = 236
    Width = 86
    Height = 26
    Caption = 'Emitir Carga Final al finalizar venta :'
    WordWrap = True
  end
  object Label9: TLabel
    Left = 34
    Top = 267
    Width = 91
    Height = 13
    Caption = 'Hora de Apagado :'
  end
  object Label11: TLabel
    Left = 29
    Top = 323
    Width = 96
    Height = 13
    Caption = 'Operacion Remota :'
  end
  object Label12: TLabel
    Left = 47
    Top = 350
    Width = 78
    Height = 13
    Caption = 'Boleto Tama'#241'o :'
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 625
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
    ExplicitWidth = 621
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 382
    Width = 625
    Height = 19
    Panels = <>
    ExplicitTop = 381
    ExplicitWidth = 621
  end
  object edt_terminal: TEdit
    Left = 133
    Top = 72
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 2
  end
  object edt_taquilla: TEdit
    Left = 133
    Top = 100
    Width = 121
    Height = 21
    TabOrder = 3
    OnKeyPress = edt_taquillaKeyPress
  end
  object cmb_ips: TlsComboBox
    Left = 131
    Top = 45
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 4
    OnClick = cmb_ipsClick
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cmb_imp_boleto: TlsComboBox
    Left = 133
    Top = 128
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 5
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cmb_imp_opcional: TlsComboBox
    Left = 133
    Top = 158
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 6
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cmb_tarjeta: TlsComboBox
    Left = 133
    Top = 185
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 7
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cmb_apagado: TlsComboBox
    Left = 133
    Top = 211
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 8
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cmb_carga: TlsComboBox
    Left = 133
    Top = 239
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 9
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object DTP_apagado: TDateTimePicker
    Left = 133
    Top = 265
    Width = 145
    Height = 21
    Date = 41369.000000000000000000
    Time = 0.416354166656674400
    DateFormat = dfLong
    Kind = dtkTime
    TabOrder = 10
  end
  object edt_iplocal: TEdit
    Left = 282
    Top = 45
    Width = 147
    Height = 21
    Enabled = False
    TabOrder = 11
  end
  object cbx_Remota: TlsComboBox
    Left = 133
    Top = 316
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 12
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cmb_tamano: TlsComboBox
    Left = 131
    Top = 343
    Width = 145
    Height = 21
    Style = csDropDownList
    TabOrder = 13
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object Cb_masiva: TCheckBox
    Left = 284
    Top = 75
    Width = 97
    Height = 17
    Alignment = taLeftJustify
    BiDiMode = bdLeftToRight
    Caption = 'Venta Masiva :'
    ParentBiDiMode = False
    TabOrder = 14
  end
  object cmb_name_printer: TlsComboBox
    Left = 284
    Top = 128
    Width = 323
    Height = 21
    Style = csDropDownList
    TabOrder = 15
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cmb_printer_gral: TlsComboBox
    Left = 284
    Top = 158
    Width = 323
    Height = 21
    Style = csDropDownList
    TabOrder = 16
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object cb_conexion: TCheckBox
    Left = 478
    Top = 74
    Width = 107
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Conexion Central :'
    TabOrder = 17
  end
  object chk_continuo: TCheckBox
    Left = 478
    Top = 189
    Width = 107
    Height = 17
    Alignment = taLeftJustify
    Caption = 'Papel continuo :'
    TabOrder = 18
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = '&Actualizar'
            ImageIndex = 22
          end
          item
            Action = acSalir
            Caption = '&Salir'
            ImageIndex = 15
          end>
        ActionBar = ActionMainMenuBar1
      end>
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 440
    Top = 272
    StyleName = 'Platform Default'
    object acSalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      OnExecute = acSalirExecute
    end
    object Action1: TAction
      Caption = 'Actualizar'
      ImageIndex = 22
      OnExecute = Action1Execute
    end
  end
end
