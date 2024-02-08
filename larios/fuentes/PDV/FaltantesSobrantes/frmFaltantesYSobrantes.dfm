object frmFaltantesSobrantes: TfrmFaltantesSobrantes
  Left = 474
  Top = 223
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Reporte de Faltantes y Sobrantes = GPM ='
  ClientHeight = 590
  ClientWidth = 540
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 540
    Height = 590
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 550
    ExplicitHeight = 600
    object Label1: TLabel
      Left = 2
      Top = 6
      Width = 63
      Height = 13
      Caption = 'Fecha Inicial:'
    end
    object Label2: TLabel
      Left = 290
      Top = 6
      Width = 58
      Height = 13
      Caption = 'Fecha Final:'
    end
    object Label3: TLabel
      Left = 3
      Top = 90
      Width = 93
      Height = 13
      Caption = 'Opcion de Reporte:'
    end
    object Label4: TLabel
      Left = 3
      Top = 117
      Width = 117
      Height = 13
      Caption = 'Sub Opcion del Reporte:'
      Visible = False
    end
    object finicial: TDateTimePicker
      Left = 86
      Top = 4
      Width = 186
      Height = 21
      Date = 40289.000000000000000000
      Time = 40289.000000000000000000
      TabOrder = 0
    end
    object ffinal: TDateTimePicker
      Left = 362
      Top = 6
      Width = 186
      Height = 21
      Date = 40289.000000000000000000
      Time = 0.999305555553291900
      TabOrder = 1
    end
    object rgOpcionesReporte: TRadioGroup
      Left = 2
      Top = 30
      Width = 545
      Height = 53
      Caption = 'Opciones de Reporte'
      Columns = 3
      Items.Strings = (
        'Por Terminal'
        'Por Comision'
        'Todas las Terminales'
        'Todas las Comisiones'
        'Todo')
      TabOrder = 2
      OnClick = rgOpcionesReporteClick
    end
    object lscbOpcionReporte: TlsComboBox
      Left = 126
      Top = 87
      Width = 315
      Height = 21
      AutoComplete = False
      TabOrder = 3
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object lscbSubOpcionReporte: TlsComboBox
      Left = 125
      Top = 114
      Width = 318
      Height = 21
      AutoComplete = False
      TabOrder = 4
      Visible = False
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object btnGeneraReporte: TButton
      Left = 458
      Top = 89
      Width = 88
      Height = 25
      Caption = 'Genera Reporte'
      TabOrder = 5
      OnClick = btnGeneraReporteClick
    end
    object btnExportar: TButton
      Left = 458
      Top = 114
      Width = 87
      Height = 25
      Caption = 'Exportar'
      TabOrder = 6
      OnClick = btnExportarClick
    end
    object sagDatosReporte: TStringGrid
      Left = 3
      Top = 168
      Width = 542
      Height = 447
      FixedCols = 0
      TabOrder = 7
      ColWidths = (
        64
        87
        82
        134
        157)
    end
  end
end
