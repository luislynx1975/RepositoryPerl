object frmModificarCorrida: TfrmModificarCorrida
  Left = 195
  Top = 55
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Modificar corrida'
  ClientHeight = 419
  ClientWidth = 530
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
  object GroupBox3: TGroupBox
    Left = 2
    Top = 199
    Width = 337
    Height = 225
    Caption = ' Terminales '
    TabOrder = 0
    object sgTerminales: TStringGrid
      Left = 2
      Top = 15
      Width = 333
      Height = 208
      Align = alClient
      ColCount = 4
      DefaultRowHeight = 18
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnExit = sgTerminalesExit
      OnKeyPress = sgTerminalesKeyPress
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 32
    Width = 313
    Height = 153
    Caption = ' Generales '
    TabOrder = 1
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
      Width = 44
      Height = 13
      Caption = 'Servicio :'
    end
    object Label2: TLabel
      Left = 25
      Top = 76
      Width = 30
      Height = 13
      Caption = 'Ruta :'
    end
    object Label5: TLabel
      Left = 25
      Top = 102
      Width = 61
      Height = 13
      Caption = 'Hora Salida :'
    end
    object Label3: TLabel
      Left = 24
      Top = 128
      Width = 67
      Height = 13
      Caption = 'Fecha Salida :'
    end
    object lbServicio: TLabel
      Left = 92
      Top = 22
      Width = 45
      Height = 13
      Caption = 'lbServicio'
    end
    object lbRuta: TLabel
      Left = 92
      Top = 76
      Width = 31
      Height = 13
      Caption = 'lbRuta'
    end
    object lbHoraSalida: TLabel
      Left = 92
      Top = 102
      Width = 59
      Height = 13
      Caption = 'lbHoraSalida'
    end
    object lbFechaSalida: TLabel
      Left = 92
      Top = 128
      Width = 65
      Height = 13
      Caption = 'lbFechaSalida'
    end
    object lsCbx_bus: TlsComboBox
      Left = 92
      Top = 41
      Width = 201
      Height = 21
      TabOrder = 0
      OnClick = lsCbx_busClick
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 345
    Top = 201
    Width = 185
    Height = 223
    Caption = ' Ocupantes '
    TabOrder = 2
    object sgOcupantes: TStringGrid
      Left = 2
      Top = 15
      Width = 181
      Height = 206
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 18
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnKeyPress = sgOcupantesKeyPress
      RowHeights = (
        18
        18)
    end
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 530
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
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = acModificar
            Caption = '&Modificar'
            ImageIndex = 22
            ShortCut = 16461
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
    Left = 360
    Top = 112
    StyleName = 'Platform Default'
    object acSalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = acSalirExecute
    end
    object acModificar: TAction
      Caption = 'Modificar'
      ImageIndex = 22
      ShortCut = 16461
      OnExecute = acModificarExecute
    end
  end
end
