object Frm_boleto_personalizado: TFrm_boleto_personalizado
  Left = 0
  Top = 0
  Caption = 'Boletos personalizados'
  ClientHeight = 243
  ClientWidth = 472
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 472
    Height = 243
    Align = alClient
    TabOrder = 0
    object stg_nombres: TStringGrid
      Left = 1
      Top = 1
      Width = 470
      Height = 175
      Align = alClient
      ColCount = 2
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goTabs]
      TabOrder = 0
      ColWidths = (
        239
        212)
    end
    object Panel2: TPanel
      Left = 1
      Top = 176
      Width = 470
      Height = 66
      Align = alBottom
      BevelKind = bkFlat
      TabOrder = 1
      object SpeedButton1: TSpeedButton
        Left = 176
        Top = 12
        Width = 97
        Height = 33
        Action = Salir
      end
    end
  end
  object ActionManager1: TActionManager
    LargeDisabledImages = DM.img_iconos
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 392
    Top = 192
    StyleName = 'Platform Default'
    object Salir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = SalirExecute
    end
  end
end
