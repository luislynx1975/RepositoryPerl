object Frm_Corrida_Ocupada: TFrm_Corrida_Ocupada
  Left = 486
  Top = 465
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Corrida Ocupada'
  ClientHeight = 120
  ClientWidth = 468
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  TextHeight = 13
  object lbl1: TLabel
    Left = 24
    Top = 32
    Width = 31
    Height = 15
    Caption = '.-------'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Button1: TButton
    Left = 8
    Top = 80
    Width = 75
    Height = 25
    Caption = 'Cerrar'
    TabOrder = 0
    Visible = False
    OnClick = Button1Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 101
    Width = 468
    Height = 19
    Panels = <
      item
        Text = 'Esc - Salir'
        Width = 50
      end>
    ExplicitTop = 111
    ExplicitWidth = 478
  end
  object Timer1: TTimer
    Interval = 10000
    OnTimer = Timer1Timer
    Left = 416
    Top = 64
  end
end
