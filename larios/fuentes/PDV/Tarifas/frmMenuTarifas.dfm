object frmMenuTarifa: TfrmMenuTarifa
  Left = 0
  Top = 0
  Anchors = []
  BorderIcons = []
  Caption = 'Tarifas'
  ClientHeight = 174
  ClientWidth = 124
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object btnConsultas: TBitBtn
    Tag = 127
    Left = 15
    Top = 4
    Width = 86
    Height = 32
    Caption = 'Consultar Tarifas'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
    WordWrap = True
    OnClick = btnConsultasClick
  end
  object btnAlta: TBitBtn
    Tag = 190
    Left = 15
    Top = 36
    Width = 86
    Height = 32
    Caption = 'Alta Tarifas'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 1
    WordWrap = True
    OnClick = btnAltaClick
  end
  object BitBtn3: TBitBtn
    Left = 15
    Top = 137
    Width = 86
    Height = 32
    Caption = '&Cerrar'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 2
    OnClick = BitBtn3Click
  end
  object btnImportar: TBitBtn
    Tag = 190
    Left = 15
    Top = 70
    Width = 86
    Height = 32
    Caption = 'Importar Tarifas'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    WordWrap = True
    OnClick = btnImportarClick
  end
  object BitBtn1: TBitBtn
    Tag = 190
    Left = 15
    Top = 103
    Width = 86
    Height = 32
    Caption = 'Modificacion Masiva Tarifas'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 4
    WordWrap = True
    OnClick = BitBtn1Click
  end
end
