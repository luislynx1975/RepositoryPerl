object frm_nombre_boleto: Tfrm_nombre_boleto
  Left = 441
  Top = 372
  Caption = 'Captura de Nombre del boleto'
  ClientHeight = 286
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  OnActivate = FormActivate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 596
    Height = 267
    Align = alClient
    TabOrder = 0
    object stg_nombre_boleto: TStringGrid
      Left = 1
      Top = 1
      Width = 594
      Height = 265
      Align = alClient
      FixedCols = 0
      RowCount = 2
      TabOrder = 0
      OnKeyUp = stg_nombre_boletoKeyUp
      OnSelectCell = stg_nombre_boletoSelectCell
      ColWidths = (
        91
        171
        135
        119
        64)
    end
  end
  object st_statuspnl: TStatusBar
    Left = 0
    Top = 267
    Width = 596
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
end
