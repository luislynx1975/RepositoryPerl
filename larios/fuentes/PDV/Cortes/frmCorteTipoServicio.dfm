object frmCorteServicio: TfrmCorteServicio
  Left = 454
  Top = 376
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Tipo de Servicio'
  ClientHeight = 121
  ClientWidth = 197
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 2
    Top = 2
    Width = 135
    Height = 16
    Caption = 'Fecha Inicial del Corte:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 2
    Top = 41
    Width = 130
    Height = 16
    Caption = 'Fecha Final del Corte:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object dtpFechaInicial: TDateTimePicker
    Left = 5
    Top = 18
    Width = 186
    Height = 21
    Date = 40169.000011574070000000
    Time = 40169.000011574070000000
    TabOrder = 0
    OnKeyPress = dtpFechaInicialKeyPress
  end
  object dtpFechaFinal: TDateTimePicker
    Left = 5
    Top = 63
    Width = 186
    Height = 21
    Date = 40169.999988425930000000
    Time = 40169.999988425930000000
    TabOrder = 1
    OnKeyPress = dtpFechaFinalKeyPress
  end
  object btnAceptar: TButton
    Left = 44
    Top = 87
    Width = 69
    Height = 26
    Caption = '&Aceptar'
    TabOrder = 2
    OnClick = btnAceptarClick
  end
  object btnCancelar: TButton
    Left = 119
    Top = 88
    Width = 69
    Height = 26
    Caption = '&Cerrar'
    TabOrder = 3
    OnClick = btnCancelarClick
  end
end
