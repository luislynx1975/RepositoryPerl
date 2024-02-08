object frm_pago_boleto: Tfrm_pago_boleto
  Left = 927
  Top = 140
  BorderIcons = []
  ClientHeight = 307
  ClientWidth = 211
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poDesigned
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 211
    Height = 307
    Align = alClient
    Caption = 'Formas de pago'
    TabOrder = 0
    ExplicitWidth = 215
    ExplicitHeight = 308
    object stg_formas: TStringGrid
      Left = 2
      Top = 15
      Width = 211
      Height = 291
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      TabOrder = 0
      OnSelectCell = stg_formasSelectCell
      ColWidths = (
        131
        64)
    end
  end
end
