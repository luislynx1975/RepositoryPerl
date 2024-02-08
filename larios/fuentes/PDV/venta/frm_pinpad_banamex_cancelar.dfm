object pinpad_banamex_cancelar: Tpinpad_banamex_cancelar
  Left = 0
  Top = 0
  Caption = 'pinpad_banamex_cancelar'
  ClientHeight = 389
  ClientWidth = 708
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  TextHeight = 13
  object Label1: TLabel
    Left = 511
    Top = 31
    Width = 89
    Height = 46
    Caption = 'Boletos a cancelar : '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object Label2: TLabel
    Left = 511
    Top = 111
    Width = 143
    Height = 23
    Caption = 'Por  un total de :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lbBoletos: TLabel
    Left = 615
    Top = 25
    Width = 46
    Height = 52
    Caption = '88'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -43
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lbTotal: TLabel
    Left = 509
    Top = 151
    Width = 195
    Height = 52
    Alignment = taCenter
    AutoSize = False
    Caption = '99,999.99'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -43
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 505
    Height = 389
    Align = alLeft
    Caption = ' Boletos que se pagaron con tarjeta '
    TabOrder = 0
    ExplicitHeight = 390
    object sgBoletos: TStringGrid
      Left = 2
      Top = 49
      Width = 501
      Height = 339
      Align = alClient
      DefaultRowHeight = 18
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      OnKeyPress = sgBoletosKeyPress
      ExplicitLeft = 4
      ExplicitTop = 95
      ExplicitHeight = 373
      RowHeights = (
        18
        18
        18
        18
        18)
    end
    object Panel1: TPanel
      Left = 2
      Top = 15
      Width = 501
      Height = 34
      Align = alTop
      Caption = 
        'Seleccione con la BARRA ESPACIADORA los boletos que quiera cance' +
        'lar (SI/NO)'
      TabOrder = 1
    end
  end
  object btnCancelarBoletos: TButton
    Left = 546
    Top = 240
    Width = 115
    Height = 25
    Caption = 'Cancelar Boletos'
    TabOrder = 1
    OnClick = btnCancelarBoletosClick
  end
  object btnSalir: TButton
    Left = 568
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Salir'
    TabOrder = 2
    OnClick = btnSalirClick
  end
end
