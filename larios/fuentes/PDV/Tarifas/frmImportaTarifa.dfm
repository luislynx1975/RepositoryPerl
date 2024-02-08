object importaTarifas: TimportaTarifas
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Importar Tarifas'
  ClientHeight = 566
  ClientWidth = 619
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 493
    Width = 619
    Height = 73
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 503
    ExplicitWidth = 629
    object lblTotalRegs: TLabel
      Left = 230
      Top = 28
      Width = 91
      Height = 13
      Caption = 'Total de Registros.'
    end
    object lbl1: TLabel
      Left = 162
      Top = 4
      Width = 48
      Height = 26
      Alignment = taCenter
      Caption = 'Impuesto (todas)'
      Visible = False
      WordWrap = True
    end
    object Button1: TButton
      Left = 385
      Top = 28
      Width = 80
      Height = 25
      Caption = 'Cargar Tarifas'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 466
      Top = 28
      Width = 75
      Height = 25
      Caption = 'Importar'
      TabOrder = 1
      OnClick = Button2Click
    end
    object dtpFecha: TDateTimePicker
      Left = 8
      Top = 5
      Width = 142
      Height = 21
      Date = 40946.000000000000000000
      Time = 0.456493414349097300
      TabOrder = 2
    end
    object dtpHora: TDateTimePicker
      Left = 8
      Top = 32
      Width = 142
      Height = 21
      Date = 40946.000000000000000000
      Time = 40946.000000000000000000
      Kind = dtkTime
      TabOrder = 3
    end
    object ProgressBar: TProgressBar
      Left = 228
      Top = 5
      Width = 390
      Height = 21
      TabOrder = 4
    end
    object edtImpuesto: TEdit
      Left = 157
      Top = 31
      Width = 66
      Height = 21
      MaxLength = 5
      TabOrder = 5
      Visible = False
      OnKeyPress = edtImpuestoKeyPress
    end
    object btn1: TButton
      Left = 541
      Top = 28
      Width = 75
      Height = 25
      Caption = 'Cerrar'
      TabOrder = 6
      OnClick = btn1Click
    end
    object cbImpuesto: TCheckBox
      Left = 232
      Top = 45
      Width = 151
      Height = 16
      Caption = 'Tomar impuesto de archivo'
      Checked = True
      State = cbChecked
      TabOrder = 7
      WordWrap = True
      OnClick = cbImpuestoClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 619
    Height = 493
    Align = alClient
    TabOrder = 1
    ExplicitWidth = 629
    ExplicitHeight = 503
    object sagImportados: TStringGrid
      Left = 1
      Top = 1
      Width = 627
      Height = 501
      Align = alClient
      ColCount = 9
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      TabOrder = 0
    end
  end
  object abrirArchivo: TOpenTextFileDialog
    DefaultExt = '.csv'
    Left = 184
    Top = 440
  end
end
