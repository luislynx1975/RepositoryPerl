object frm_catalogo_pago: Tfrm_catalogo_pago
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'CREDITO / DEBITO'
  ClientHeight = 127
  ClientWidth = 437
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 2
    Top = 8
    Width = 437
    Height = 23
    Caption = 'Seleccione si la tarjeta es CREDITO o DEBITO'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 77
    Width = 45
    Height = 13
    Caption = 'Tarjeta  :'
  end
  object Label3: TLabel
    Left = 96
    Top = 37
    Width = 250
    Height = 19
    Caption = 'Solo aplica a pagos con tarjeta  IXE'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object cmb_tarjetas: TlsComboBox
    Left = 72
    Top = 74
    Width = 305
    Height = 21
    TabOrder = 0
    OnKeyPress = cmb_tarjetasKeyPress
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object Button1: TButton
    Left = 168
    Top = 100
    Width = 75
    Height = 25
    Caption = 'Aceptar'
    TabOrder = 1
    OnClick = Button1Click
  end
end
