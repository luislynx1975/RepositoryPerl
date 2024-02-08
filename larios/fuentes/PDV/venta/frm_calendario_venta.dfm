object frm_calendario: Tfrm_calendario
  Left = 453
  Top = 277
  AutoSize = True
  BorderIcons = []
  Caption = 'Calendario'
  ClientHeight = 182
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 0
    Width = 73
    Height = 16
    Caption = 'ESC : Cerrar'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object MonthCalendar1: TMonthCalendar
    Left = 0
    Top = 22
    Width = 225
    Height = 160
    AutoSize = True
    Date = 40561.812940173610000000
    TabOrder = 0
  end
end
