object frm_pax_fik: Tfrm_pax_fik
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Reporte pasejeros'
  ClientHeight = 192
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 225
    Height = 192
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 235
    ExplicitHeight = 202
    object MonthCalendar1: TMonthCalendar
      Left = 0
      Top = 0
      Width = 225
      Height = 160
      Date = 40599.000000000000000000
      TabOrder = 0
    end
    object Button1: TButton
      Left = 32
      Top = 166
      Width = 75
      Height = 25
      Caption = 'Procesar'
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 120
      Top = 166
      Width = 75
      Height = 25
      Caption = 'Salir'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
end
