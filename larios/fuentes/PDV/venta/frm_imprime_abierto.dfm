object frm_print_abierto: Tfrm_print_abierto
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'frm_print_abierto'
  ClientHeight = 432
  ClientWidth = 805
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  TextHeight = 13
  object stg_detalle: TStringGrid
    Left = 8
    Top = 12
    Width = 809
    Height = 345
    ColCount = 7
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    TabOrder = 0
    OnSelectCell = stg_detalleSelectCell
    ColWidths = (
      64
      64
      64
      64
      64
      75
      394)
  end
  object Button1: TButton
    Left = 328
    Top = 371
    Width = 137
    Height = 49
    Caption = 'Imprime'
    TabOrder = 1
    OnClick = Button1Click
  end
end
