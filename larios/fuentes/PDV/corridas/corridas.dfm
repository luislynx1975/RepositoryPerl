object frmCorridas: TfrmCorridas
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Corridas'
  ClientHeight = 151
  ClientWidth = 439
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
  object GroupBox1: TGroupBox
    Left = 38
    Top = 32
    Width = 397
    Height = 121
    Caption = ' Criterios para generar corridas '
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 27
      Width = 13
      Height = 13
      Caption = 'De'
    end
    object Label2: TLabel
      Left = 152
      Top = 27
      Width = 28
      Height = 13
      Caption = 'Hasta'
    end
    object dtpFechaInicio: TDateTimePicker
      Left = 35
      Top = 21
      Width = 94
      Height = 21
      Date = 40344.000000000000000000
      Time = 40344.000000000000000000
      TabOrder = 0
    end
    object dtpFechaFin: TDateTimePicker
      Left = 186
      Top = 19
      Width = 97
      Height = 21
      Date = 40344.000000000000000000
      Time = 40344.000000000000000000
      TabOrder = 1
    end
    object cbxCorrida: TCheckBox
      Left = 16
      Top = 48
      Width = 97
      Height = 17
      Caption = 'S'#243'lo la corrida:'
      TabOrder = 2
      OnClick = excluyentes
    end
    object cbCorridas: TlsComboBox
      Left = 119
      Top = 46
      Width = 233
      Height = 21
      AutoComplete = False
      TabOrder = 3
      Text = 'cbCorridas'
      OnClick = excluyentes
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object cbxServicio: TCheckBox
      Left = 16
      Top = 72
      Width = 97
      Height = 17
      Caption = 'S'#243'lo el servicio:'
      TabOrder = 4
      OnClick = excluyentes
    end
    object cbServicios: TlsComboBox
      Left = 119
      Top = 73
      Width = 233
      Height = 21
      AutoComplete = False
      TabOrder = 5
      Text = 'cbServicios'
      OnClick = excluyentes
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 439
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
    ExplicitWidth = 435
  end
  object pEstatus: TPanel
    Left = 314
    Top = 140
    Width = 193
    Height = 65
    Caption = 'P r o c e s a n d o . . .'
    TabOrder = 2
    Visible = False
  end
  object ActionManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = acSalir
            Caption = '&Salir'
            ImageIndex = 15
          end
          item
            Action = acUltimaCorrida
            Caption = '&Ultima corrida'
            ImageIndex = 24
          end
          item
            Action = acHayVentaPara
            ImageIndex = 24
          end
          item
            Action = acEliminarCorridas
            Caption = '&Eliminar corridas'
            ImageIndex = 18
          end>
        ActionBar = ActionToolBar1
      end>
    Images = DM.img_iconos
    Left = 320
    Top = 48
    StyleName = 'Platform Default'
    object acSalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      OnExecute = acSalirExecute
    end
    object acGenerar: TAction
      Caption = 'Generar'
      ImageIndex = 25
      OnExecute = acGenerarExecute
    end
    object acUltimaCorrida: TAction
      Caption = 'Ultima corrida'
      ImageIndex = 24
      OnExecute = acUltimaCorridaExecute
    end
    object acHayVentaPara: TAction
      Caption = 'Consultar &venta'
      ImageIndex = 24
      OnExecute = acHayVentaParaExecute
    end
    object acEliminarCorridas: TAction
      Caption = 'Eliminar corridas'
      ImageIndex = 18
      OnExecute = acEliminarCorridasExecute
    end
  end
end
