object frmRutaRepetida: TfrmRutaRepetida
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Rutas Repetidas'
  ClientHeight = 209
  ClientWidth = 418
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
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 88
    Height = 13
    Caption = 'Origen de la Ruta:'
  end
  object Label2: TLabel
    Left = 16
    Top = 48
    Width = 92
    Height = 13
    Caption = 'Destino de la Ruta:'
  end
  object edtOrigen: TEdit
    Left = 120
    Top = 16
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtDestino: TEdit
    Left = 120
    Top = 45
    Width = 121
    Height = 21
    OEMConvert = True
    TabOrder = 1
  end
  object btnClose: TButton
    Left = 330
    Top = 11
    Width = 75
    Height = 25
    Caption = 'Cerrar'
    TabOrder = 2
    OnClick = btnCloseClick
  end
  object sagRutas: TStringGrid
    Left = 16
    Top = 72
    Width = 385
    Height = 121
    DefaultRowHeight = 18
    FixedCols = 0
    RowCount = 2
    TabOrder = 3
    ColWidths = (
      62
      75
      80
      76
      64)
  end
end
