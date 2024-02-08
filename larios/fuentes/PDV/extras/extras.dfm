object frmExtras: TfrmExtras
  Left = 195
  Top = 55
  BorderStyle = bsDialog
  Caption = 'Extras'
  ClientHeight = 450
  ClientWidth = 526
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object GroupBox2: TGroupBox
    Left = 0
    Top = 32
    Width = 523
    Height = 191
    Caption = ' Generales '
    TabOrder = 0
    object Label1: TLabel
      Left = 25
      Top = 49
      Width = 47
      Height = 13
      Caption = 'Autobus :'
    end
    object Servicio: TLabel
      Left = 25
      Top = 22
      Width = 37
      Height = 13
      Caption = 'Servicio'
    end
    object Label2: TLabel
      Left = 25
      Top = 75
      Width = 30
      Height = 13
      Caption = 'Ruta :'
    end
    object Label5: TLabel
      Left = 25
      Top = 103
      Width = 61
      Height = 13
      Caption = 'Hora Salida :'
    end
    object Label3: TLabel
      Left = 24
      Top = 130
      Width = 67
      Height = 13
      Caption = 'Fecha Salida :'
    end
    object lsCbx_bus: TlsComboBox
      Left = 107
      Top = 41
      Width = 361
      Height = 21
      AutoComplete = False
      TabOrder = 1
      OnClick = lsCbx_busClick
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object lsCbx_servicio: TlsComboBox
      Left = 107
      Top = 14
      Width = 201
      Height = 21
      AutoComplete = False
      TabOrder = 0
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object lsCbx_ruta: TlsComboBox
      Left = 107
      Top = 67
      Width = 145
      Height = 21
      AutoComplete = False
      TabOrder = 2
      OnClick = lsCbx_rutaClick
      OnExit = lsCbx_rutaClick
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object dtpHoraSalida: TDateTimePicker
      Left = 107
      Top = 95
      Width = 52
      Height = 21
      Date = 40101.000000000000000000
      Format = 'HH:mm'
      Time = 40101.000000000000000000
      Kind = dtkTime
      TabOrder = 3
      OnChange = dtpHoraSalidaChange
    end
    object dtpFechaSalida: TDateTimePicker
      Left = 107
      Top = 122
      Width = 97
      Height = 21
      Date = 40351.000000000000000000
      Format = 'dd/MM/yyyy'
      Time = 40351.000000000000000000
      TabOrder = 4
      OnChange = dtpFechaSalidaChange
    end
    object chkCorridaDeVacio: TCheckBox
      Left = 267
      Top = 69
      Width = 108
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Corrida de Vacio :'
      TabOrder = 5
      Visible = False
      OnClick = chkCorridaDeVacioClick
    end
    object mem_conexion: TMemo
      Left = 224
      Top = 94
      Width = 250
      Height = 89
      TabOrder = 6
      Visible = False
    end
    object chk_web: TCheckBox
      Left = 392
      Top = 69
      Width = 97
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Visible en WEB'
      Checked = True
      State = cbChecked
      TabOrder = 7
    end
  end
  object GroupBox3: TGroupBox
    Left = 2
    Top = 229
    Width = 337
    Height = 225
    Caption = ' Terminales '
    TabOrder = 1
    object sgTerminales: TStringGrid
      Left = 2
      Top = 45
      Width = 333
      Height = 178
      Align = alClient
      DefaultRowHeight = 18
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnExit = sgTerminalesExit
      OnKeyPress = sgTerminalesKeyPress
      OnSelectCell = sgTerminalesSelectCell
      ColWidths = (
        64
        64
        64
        64
        42)
    end
    object pRuta: TPanel
      Left = 2
      Top = 15
      Width = 333
      Height = 30
      Align = alTop
      TabOrder = 1
      object lbDetalle: TLabel
        Left = 5
        Top = -1
        Width = 330
        Height = 25
        Alignment = taCenter
        AutoSize = False
        WordWrap = True
      end
    end
  end
  object sgMaximos: TStringGrid
    Left = 458
    Top = 159
    Width = 70
    Height = 62
    TabOrder = 3
    Visible = False
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object GroupBox4: TGroupBox
    Left = 345
    Top = 227
    Width = 185
    Height = 225
    Caption = ' Ocupantes '
    TabOrder = 2
    object sgOcupantes: TStringGrid
      Left = 2
      Top = 15
      Width = 181
      Height = 208
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 18
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnExit = sgOcupantesExit
      OnKeyPress = sgOcupantesKeyPress
      RowHeights = (
        18
        18)
    end
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 526
    Height = 26
    ActionManager = ActionManager
    Caption = 'ActionToolBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Spacing = 0
    ExplicitWidth = 522
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = acGuardar
            ImageIndex = 17
            ShortCut = 16455
          end
          item
            Action = acSalir
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionToolBar1
      end>
    Images = DM.img_iconos
    Left = 424
    Top = 40
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
