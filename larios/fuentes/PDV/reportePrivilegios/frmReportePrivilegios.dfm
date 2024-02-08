object frmReportePrivilegio: TfrmReportePrivilegio
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Privilegios'
  ClientHeight = 346
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 457
    Height = 88
    Align = alTop
    TabOrder = 0
    object lbl1: TLabel
      Left = 8
      Top = 16
      Width = 75
      Height = 13
      Caption = 'Tipo de Objeto:'
    end
    object lscbObjeto: TlsComboBox
      Left = 88
      Top = 13
      Width = 304
      Height = 21
      AutoComplete = False
      TabOrder = 0
      OnChange = lscbObjetoChange
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object btn1: TButton
      Left = 361
      Top = 47
      Width = 75
      Height = 26
      Caption = '&Descargar'
      TabOrder = 1
      OnClick = btn1Click
    end
    object btn2: TButton
      Left = 280
      Top = 47
      Width = 75
      Height = 26
      Caption = '&Cerrar'
      TabOrder = 2
      OnClick = btn2Click
    end
    object btn3: TButton
      Left = 397
      Top = 12
      Width = 39
      Height = 23
      Caption = '&Ver'
      TabOrder = 3
      OnClick = btn3Click
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 88
    Width = 457
    Height = 258
    Align = alClient
    TabOrder = 1
    object sagPrivilegios: TStringGrid
      Left = 1
      Top = 1
      Width = 455
      Height = 256
      Align = alClient
      ColCount = 2
      DefaultColWidth = 60
      DefaultRowHeight = 18
      FixedCols = 0
      TabOrder = 0
      ColWidths = (
        60
        377)
    end
  end
  object sdSalvarArchivo: TSaveDialog
    Left = 40
    Top = 40
  end
end
