object frmModificaTarifa: TfrmModificaTarifa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = 'Modificacion de Tarifas'
  ClientHeight = 268
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 176
    Height = 16
    Caption = 'Fecha y Hora de aplicaci'#243'n:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 183
    Top = 118
    Width = 10
    Height = 19
    Caption = '$'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object Label3: TLabel
    Left = 271
    Top = 118
    Width = 19
    Height = 19
    Caption = '%'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object dtpFecha: TDateTimePicker
    Left = 3
    Top = 24
    Width = 173
    Height = 20
    Date = 40962.000000000000000000
    Time = 0.620522673612867900
    TabOrder = 0
  end
  object dtpHora: TDateTimePicker
    Left = 180
    Top = 23
    Width = 105
    Height = 21
    Date = 40962.000000000000000000
    Time = 0.041666666656965390
    Kind = dtkTime
    TabOrder = 1
  end
  object rgTipoIncremento: TRadioGroup
    Left = 2
    Top = 53
    Width = 174
    Height = 105
    Caption = 'Incremento Masivo en Tarifas'
    Items.Strings = (
      'Por Ruta'
      'Por Servicio'
      'General')
    TabOrder = 2
    OnClick = rgTipoIncrementoClick
  end
  object rgAumento: TRadioGroup
    Left = 182
    Top = 53
    Width = 105
    Height = 60
    Caption = 'Aumento:'
    Items.Strings = (
      'En pesos'
      'En porcentaje')
    TabOrder = 3
    OnClick = rgAumentoClick
  end
  object edtAumento: TEdit
    Left = 195
    Top = 116
    Width = 73
    Height = 21
    MaxLength = 2
    TabOrder = 4
  end
  object Button1: TButton
    Left = 235
    Top = 245
    Width = 52
    Height = 25
    Caption = 'Cerrar'
    TabOrder = 5
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 182
    Top = 245
    Width = 52
    Height = 25
    Caption = 'Aplicar'
    TabOrder = 6
    OnClick = Button2Click
  end
  object lscbTipoIncremento: TlsComboBox
    Left = 8
    Top = 161
    Width = 145
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 7
    Complete = False
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object rgRedondear: TRadioGroup
    Left = 182
    Top = 139
    Width = 105
    Height = 55
    Caption = 'Redondear'
    Columns = 2
    Items.Strings = (
      'Arriba'
      'Abajo')
    TabOrder = 8
  end
  object rgAux: TRadioGroup
    Left = 3
    Top = 185
    Width = 173
    Height = 55
    Caption = 'Auxiliar Masivo en Tarifas'
    Items.Strings = (
      'Por Ruta'
      'Por Servicio')
    TabOrder = 9
    OnClick = rgAuxClick
  end
  object lscbAux: TlsComboBox
    Left = 8
    Top = 246
    Width = 145
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 10
    Complete = False
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object RadioGroup1: TRadioGroup
    Left = 182
    Top = 195
    Width = 105
    Height = 47
    Caption = 'Impuesto IVA'
    TabOrder = 11
  end
  object cmb_imp_iva: TlsComboBox
    Left = 189
    Top = 215
    Width = 92
    Height = 21
    TabOrder = 12
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
end
