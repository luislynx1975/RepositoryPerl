object frm_precorte: Tfrm_precorte
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 
    'Pantalla para la captura de importe "Efectivo, IXE, Banamex" y t' +
    'otal de descuentos'
  ClientHeight = 780
  ClientWidth = 746
  Color = clScrollBar
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object lbl23: TLabel
    Left = 282
    Top = 34
    Width = 3
    Height = 13
    Caption = '.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Panel1: TPanel
    Left = 7
    Top = 28
    Width = 273
    Height = 46
    BevelInner = bvLowered
    TabOrder = 0
    object lbl_fecha: TLabel
      Left = 24
      Top = 5
      Width = 36
      Height = 13
      Caption = 'Fecha :'
    end
    object Label1: TLabel
      Left = 25
      Top = 25
      Width = 35
      Height = 13
      Caption = 'Turno :'
    end
    object cmb_turno: TlsComboBox
      Left = 66
      Top = 22
      Width = 145
      Height = 21
      AutoComplete = False
      Style = csDropDownList
      TabOrder = 0
      OnClick = cmb_turnoClick
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 234
    Width = 717
    Height = 208
    Caption = 'Pases y descuentos'
    TabOrder = 3
    object Label7: TLabel
      Left = 132
      Top = 8
      Width = 195
      Height = 13
      Caption = 'No. DE CORTESIA AEROMEXICO (APA) :'
    end
    object Label8: TLabel
      Left = 3
      Top = 29
      Width = 324
      Height = 13
      Caption = 'No. DE ORDEN PASAJE AL 100% (ORD1 "RTP, agencias de viaje") :'
    end
    object Label9: TLabel
      Left = 12
      Top = 51
      Width = 315
      Height = 13
      Caption = 'No. DE ORDEN PASAJE al 50% (ORD5 "PASES DE TRANSLADO") :'
    end
    object Label10: TLabel
      Left = 31
      Top = 73
      Width = 296
      Height = 13
      Caption = 'No. DE 1 (ORDENES DE SERVICIO) 2(PASAJEROS)(SEDENA) :'
    end
    object Label11: TLabel
      Left = 34
      Top = 95
      Width = 293
      Height = 13
      Caption = 'No. DE BOLETOS TICKET BUS (TB1 "CANJE DE TICKETBUS") :'
    end
    object Label12: TLabel
      Left = 32
      Top = 117
      Width = 295
      Height = 13
      Caption = 'No. DE FAM 1 (DESCUENTOS OTORGADOS) 2 (PASAJEROS) :'
    end
    object Label21: TLabel
      Left = 395
      Top = 73
      Width = 6
      Height = 13
      Caption = '2'
    end
    object Label22: TLabel
      Left = 398
      Top = 117
      Width = 6
      Height = 13
      Caption = '2'
    end
    object Label23: TLabel
      Left = 168
      Top = 140
      Width = 159
      Height = 13
      Caption = 'PASE DE TRANSLADO PULLMAN :'
    end
    object Label24: TLabel
      Left = 231
      Top = 163
      Width = 96
      Height = 13
      Caption = 'Agencia al (100%) :'
    end
    object Label25: TLabel
      Left = 472
      Top = 140
      Width = 111
      Height = 13
      Caption = 'PASE TRASLADO TCC :'
    end
    object Label26: TLabel
      Left = 248
      Top = 185
      Width = 79
      Height = 13
      Caption = 'Promocion rollo :'
    end
    object edt_APA: TEdit
      Left = 327
      Top = 4
      Width = 121
      Height = 21
      TabOrder = 0
      Text = '0'
      OnChange = edt_APAChange
      OnEnter = edt_APAEnter
      OnExit = edt_APAExit
      OnKeyPress = edt_APAKeyPress
    end
    object edt_100: TEdit
      Left = 327
      Top = 26
      Width = 121
      Height = 21
      TabOrder = 1
      Text = '0'
      OnChange = edt_100Change
      OnEnter = edt_100Enter
      OnExit = edt_100Exit
      OnKeyPress = edt_100KeyPress
    end
    object edt_50: TEdit
      Left = 327
      Top = 48
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0'
      OnChange = edt_50Change
      OnEnter = edt_50Enter
      OnExit = edt_50Exit
      OnKeyPress = edt_50KeyPress
    end
    object edt_sedena1: TEdit
      Left = 327
      Top = 70
      Width = 42
      Height = 21
      TabOrder = 3
      Text = '0'
      OnChange = edt_sedena1Change
      OnEnter = edt_sedena1Enter
      OnExit = edt_sedena1Exit
      OnKeyPress = edt_sedena1KeyPress
    end
    object edt_TB1: TEdit
      Left = 328
      Top = 92
      Width = 121
      Height = 21
      TabOrder = 5
      Text = '0'
      OnChange = edt_TB1Change
      OnEnter = edt_TB1Enter
      OnExit = edt_TB1Exit
      OnKeyPress = edt_TB1KeyPress
    end
    object edt_FAM1: TEdit
      Left = 327
      Top = 114
      Width = 41
      Height = 21
      TabOrder = 6
      Text = '0'
      OnChange = edt_FAM1Change
      OnEnter = edt_FAM1Enter
      OnExit = edt_FAM1Exit
      OnKeyPress = edt_FAM1KeyPress
    end
    object edt_sedena2: TEdit
      Left = 405
      Top = 70
      Width = 43
      Height = 21
      TabOrder = 4
      Text = '0'
      OnChange = edt_sedena2Change
      OnEnter = edt_sedena2Enter
      OnExit = edt_sedena2Exit
      OnKeyPress = edt_sedena2KeyPress
    end
    object edt_FAM2: TEdit
      Left = 409
      Top = 114
      Width = 40
      Height = 21
      TabOrder = 7
      Text = '0'
      OnChange = edt_FAM2Change
      OnEnter = edt_FAM2Enter
      OnExit = edt_FAM2Exit
      OnKeyPress = edt_FAM2KeyPress
    end
    object edt_pases: TEdit
      Left = 327
      Top = 137
      Width = 41
      Height = 21
      TabOrder = 8
      Text = '0'
      OnChange = edt_pasesChange
      OnEnter = edt_pasesEnter
      OnExit = edt_pasesExit
      OnKeyPress = edt_pasesKeyPress
    end
    object edt_agen: TEdit
      Left = 327
      Top = 160
      Width = 121
      Height = 21
      TabOrder = 10
      Text = '0'
      OnChange = edt_agenChange
      OnEnter = edt_agenEnter
      OnExit = edt_agenExit
      OnKeyPress = edt_agenKeyPress
    end
    object edt_tccPases: TEdit
      Left = 588
      Top = 137
      Width = 65
      Height = 21
      TabOrder = 9
      Text = '0'
      OnChange = edt_tccPasesChange
      OnEnter = edt_tccPasesEnter
      OnExit = edt_tccPasesExit
      OnKeyPress = edt_tccPasesKeyPress
    end
    object edt_rollo: TEdit
      Left = 328
      Top = 182
      Width = 121
      Height = 21
      TabOrder = 11
      Text = '0'
      OnChange = edt_rolloChange
      OnEnter = edt_rolloEnter
      OnExit = edt_rolloExit
      OnKeyPress = edt_rolloKeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 5
    Top = 76
    Width = 278
    Height = 158
    Caption = 'Importes y conteo de boletos'
    TabOrder = 1
    object Label2: TLabel
      Left = 37
      Top = 17
      Width = 108
      Height = 13
      Caption = 'Fondo Inicial Importe :'
    end
    object Label3: TLabel
      Left = 12
      Top = 40
      Width = 133
      Height = 13
      Caption = 'No. de Boletos cancelados :'
    end
    object Label4: TLabel
      Left = 33
      Top = 62
      Width = 112
      Height = 13
      Caption = 'Recolecciones Boletos :'
    end
    object Label5: TLabel
      Left = 21
      Top = 84
      Width = 124
      Height = 13
      Caption = 'Recolecciones Importe  1:'
    end
    object Label6: TLabel
      Left = 2
      Top = 106
      Width = 143
      Height = 13
      Caption = 'Total Efectivo Importe 2 :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label20: TLabel
      Left = 13
      Top = 126
      Width = 132
      Height = 26
      Caption = 'VENTA TOTAL EFECTIVO (IMPORTE 1 + 2) :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object edt_fondo: TEdit
      Left = 151
      Top = 14
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 0
      Text = '0'
    end
    object edt_cancelados: TEdit
      Left = 151
      Top = 37
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = '0'
    end
    object edt_recoboletos: TEdit
      Left = 151
      Top = 59
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = '0'
    end
    object edt_recoimporte: TEdit
      Left = 151
      Top = 81
      Width = 121
      Height = 21
      Enabled = False
      TabOrder = 3
      Text = '0'
    end
    object edt_ttlefectivo: TEdit
      Left = 151
      Top = 126
      Width = 122
      Height = 27
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      Text = '0'
    end
    object num_imp_2: TlsNumericEdit
      Left = 151
      Top = 103
      Width = 121
      Height = 21
      TabOrder = 5
      Text = '0'
      OnChange = lsNumericEdit1Change
      OnEnter = lsNumericEdit1Enter
      OnExit = lsNumericEdit1Exit
      OnKeyPress = lsNumericEdit1KeyPress
      AceptNegative = False
      Decimals = 2
      DisplayFormat = Normal
    end
  end
  object GroupBox3: TGroupBox
    Left = 288
    Top = 76
    Width = 437
    Height = 158
    Caption = 'Registro de venta por terminal :'
    TabOrder = 2
    object Label19: TLabel
      Left = 11
      Top = 122
      Width = 190
      Height = 32
      Caption = 'VENTA CON APROBACION BANCARIA (IMPORTE A + B) :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object GroupBox4: TGroupBox
      Left = 4
      Top = 21
      Width = 218
      Height = 98
      Caption = 'VENTA CON TERMINAL IXE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label13: TLabel
        Left = 58
        Top = 24
        Width = 52
        Height = 13
        Caption = 'BOLETOS :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label14: TLabel
        Left = 42
        Top = 49
        Width = 68
        Height = 13
        Caption = 'No. TICKETS :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label15: TLabel
        Left = 3
        Top = 74
        Width = 107
        Height = 13
        Caption = 'TOTAL IMPORTE A :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edt_boletoIXE: TEdit
        Left = 111
        Top = 21
        Width = 102
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = edt_boletoIXEChange
        OnKeyPress = edt_boletoIXEKeyPress
      end
      object edt_ticketIXE: TEdit
        Left = 112
        Top = 48
        Width = 102
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = edt_ticketIXEChange
        OnKeyPress = edt_ticketIXEKeyPress
      end
      object Num_edt_ixe: TlsNumericEdit
        Left = 112
        Top = 74
        Width = 102
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = Num_edt_ixeChange
        OnEnter = Num_edt_ixeEnter
        OnExit = Num_edt_ixeExit
        OnKeyPress = Num_edt_ixeKeyPress
        AceptNegative = False
        Decimals = 2
        DisplayFormat = Normal
      end
    end
    object GroupBox5: TGroupBox
      Left = 222
      Top = 21
      Width = 213
      Height = 98
      Caption = 'VENTA CON TERMINAL BANAMEX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object Label16: TLabel
        Left = 56
        Top = 24
        Width = 52
        Height = 13
        Caption = 'BOLETOS :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label17: TLabel
        Left = 40
        Top = 49
        Width = 68
        Height = 13
        Caption = 'No. TICKETS :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label18: TLabel
        Left = 2
        Top = 74
        Width = 106
        Height = 13
        Caption = 'TOTAL IMPORTE B :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Num_edt_ban: TlsNumericEdit
        Left = 109
        Top = 71
        Width = 102
        Height = 21
        TabOrder = 2
        Text = '0'
        OnChange = Num_edt_banChange
        OnEnter = Num_edt_banEnter
        OnExit = Num_edt_banExit
        OnKeyPress = Num_edt_banKeyPress
        AceptNegative = False
        Decimals = 2
        DisplayFormat = Normal
      end
      object edt_ticketBana: TEdit
        Left = 109
        Top = 46
        Width = 102
        Height = 21
        TabOrder = 1
        Text = '0'
        OnChange = edt_ticketBanaChange
        OnKeyPress = edt_ticketBanaKeyPress
      end
      object edt_bol_ban: TEdit
        Left = 109
        Top = 21
        Width = 102
        Height = 21
        TabOrder = 0
        Text = '0'
        OnChange = edt_bol_banChange
        OnKeyPress = edt_bol_banKeyPress
      end
    end
    object edt_total_banco: TEdit
      Left = 207
      Top = 123
      Width = 225
      Height = 27
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      Text = '0'
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 746
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
    ExplicitWidth = 742
  end
  object stg_folios: TStringGrid
    Left = 56
    Top = 446
    Width = 562
    Height = 304
    Color = cl3DLight
    DefaultRowHeight = 19
    FixedColor = clGray
    FixedCols = 0
    RowCount = 30
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 4
    OnKeyDown = stg_foliosKeyDown
    OnKeyPress = stg_foliosKeyPress
    OnSelectCell = stg_foliosSelectCell
    OnSetEditText = stg_foliosSetEditText
    ColWidths = (
      98
      108
      111
      107
      108)
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 761
    Width = 746
    Height = 19
    Panels = <>
    ExplicitTop = 760
    ExplicitWidth = 742
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = acGuardar
            Caption = '&Guardar'
            ImageIndex = 17
            ShortCut = 16455
          end
          item
            Action = acSalir
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionMainMenuBar1
      end>
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 592
    Top = 32
    StyleName = 'Platform Default'
    object acGuardar: TAction
      Caption = 'Guardar'
      ImageIndex = 17
      ShortCut = 16455
      OnExecute = acGuardarExecute
    end
    object acSalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = acSalirExecute
    end
  end
end
