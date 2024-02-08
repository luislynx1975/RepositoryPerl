object Frm_reg_fondo_inicial: TFrm_reg_fondo_inicial
  Left = 527
  Top = 383
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = 'Registro del fondo inicial'
  ClientHeight = 155
  ClientWidth = 331
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 52
    Width = 67
    Height = 13
    Caption = 'Fondo Inicial :'
  end
  object msk_fondo: TMaskEdit
    Left = 112
    Top = 49
    Width = 156
    Height = 21
    TabOrder = 0
    Text = '0'
    OnChange = msk_fondoChange
    OnKeyPress = msk_fondoKeyPress
  end
  object Button1: TButton
    Left = 112
    Top = 83
    Width = 91
    Height = 25
    Caption = 'Continuar venta'
    TabOrder = 1
    OnClick = Button1Click
  end
  object lsStatusBar1: TlsStatusBar
    Left = 0
    Top = 136
    Width = 331
    Height = 19
    Panels = <
      item
        Text = 'Esc para salir'
        Width = 50
      end>
  end
  object Button2: TButton
    Left = 248
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Salir'
    TabOrder = 3
    OnClick = Button2Click
  end
end
