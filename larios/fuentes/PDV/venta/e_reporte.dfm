object Frm_reporte: TFrm_reporte
  Left = 0
  Top = 0
  Caption = 'Frm_reporte'
  ClientHeight = 191
  ClientWidth = 215
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object MonthCalendar1: TMonthCalendar
    Left = 0
    Top = 0
    Width = 225
    Height = 160
    Date = 40599.000000000000000000
    TabOrder = 0
  end
  object Button1: TButton
    Left = 24
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Procesar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Salir'
    TabOrder = 2
    OnClick = Button2Click
  end
end
