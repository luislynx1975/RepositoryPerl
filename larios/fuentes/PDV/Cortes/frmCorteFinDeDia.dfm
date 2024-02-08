object frmCorteFinDia: TfrmCorteFinDia
  Left = 0
  Top = 0
  Caption = 'Corte Fin Dia'
  ClientHeight = 80
  ClientWidth = 196
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 2
    Top = 2
    Width = 95
    Height = 16
    Caption = 'Fecha de Corte:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object dtpFechaCorte: TDateTimePicker
    Left = 5
    Top = 18
    Width = 186
    Height = 21
    Date = 40169.442952893520000000
    Time = 40169.442952893520000000
    TabOrder = 0
  end
  object btnAceptar: TButton
    Left = 51
    Top = 45
    Width = 69
    Height = 26
    Caption = '&Aceptar'
    TabOrder = 1
    OnClick = btnAceptarClick
  end
  object btnCancelar: TButton
    Left = 122
    Top = 45
    Width = 69
    Height = 26
    Caption = '&Cerrar'
    TabOrder = 2
    OnClick = btnCancelarClick
  end
end
