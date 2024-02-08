object frmImportes: TfrmImportes
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Detalle de Importes'
  ClientHeight = 102
  ClientWidth = 576
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 576
    Height = 102
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 40
      Height = 13
      Caption = 'Taquilla:'
    end
    object sagImportes: TStringGrid
      Left = 1
      Top = 39
      Width = 584
      Height = 72
      Align = alBottom
      Anchors = [akTop, akRight, akBottom]
      ColCount = 7
      DefaultColWidth = 60
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentFont = False
      TabOrder = 0
      ExplicitWidth = 574
      ExplicitHeight = 62
      ColWidths = (
        71
        73
        87
        78
        82
        84
        89)
    end
    object taquillas: TlsComboBox
      Left = 62
      Top = 13
      Width = 91
      Height = 21
      TabOrder = 1
      OnChange = taquillasChange
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object btnGuardar: TButton
      Left = 488
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Guardar'
      TabOrder = 2
      OnClick = BTNgUARDARClick
    end
    object Button1: TButton
      Left = 407
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Visualizar'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 322
      Top = 11
      Width = 75
      Height = 25
      Caption = '&Cerrar'
      TabOrder = 4
      OnClick = Button2Click
    end
  end
end
