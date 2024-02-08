object frm_nueva_pagoF: Tfrm_nueva_pagoF
  Left = 353
  Top = 31
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'VK_F10'
  ClientHeight = 752
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnActivate = FormActivate
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 685
    Height = 714
    Align = alClient
    TabOrder = 0
    object lbl_totalBoletos: TLabel
      Left = 17
      Top = 183
      Width = 87
      Height = 13
      Caption = 'Total de boletos : '
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 233
      Height = 160
      BiDiMode = bdLeftToRight
      Caption = 'Totales'
      ParentBiDiMode = False
      TabOrder = 1
      object Label1: TLabel
        Left = 4
        Top = 18
        Width = 72
        Height = 15
        Caption = 'T  O  T  A  L  :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 18
        Top = 97
        Width = 88
        Height = 15
        Caption = 'Efectivo cambio :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Bevel1: TBevel
        Left = 6
        Top = 52
        Width = 209
        Height = 0
      end
      object Label3: TLabel
        Left = 10
        Top = 130
        Width = 96
        Height = 15
        Caption = 'Efectivo Recibido :'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Times New Roman'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 23
        Top = 64
        Width = 83
        Height = 13
        Caption = 'Efectivo Total :'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edt_total: TEdit
        Left = 108
        Top = 16
        Width = 121
        Height = 21
        Alignment = taRightJustify
        Enabled = False
        TabOrder = 0
      end
      object edt_cambio: TEdit
        Left = 108
        Top = 91
        Width = 121
        Height = 27
        Alignment = taRightJustify
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clRed
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object edt_recibido: TEdit
        Left = 110
        Top = 124
        Width = 121
        Height = 22
        Alignment = taRightJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnChange = edt_recibidoChange
      end
      object edt_total_efectivo: TEdit
        Left = 109
        Top = 58
        Width = 121
        Height = 22
        Alignment = taRightJustify
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
    object GroupBox1: TGroupBox
      Left = 235
      Top = 5
      Width = 462
      Height = 180
      TabOrder = 0
      object stg_formas_pago: TStringGrid
        Left = 2
        Top = 15
        Width = 458
        Height = 163
        Align = alClient
        ColCount = 6
        DefaultRowHeight = 20
        FixedCols = 0
        RowCount = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goAlwaysShowEditor]
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          157
          85
          107
          95
          63
          64)
      end
    end
    object stg_pago_detalle: TStringGrid
      Left = 96
      Top = 189
      Width = 601
      Height = 523
      ColCount = 8
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      TabOrder = 2
      Visible = False
      ColWidths = (
        64
        63
        68
        96
        140
        50
        64
        64)
    end
  end
  object stb_forma_pago: TStatusBar
    Left = 0
    Top = 733
    Width = 685
    Height = 19
    Panels = <
      item
        Width = 0
      end
      item
        Width = 200
      end
      item
        Width = 100
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object stb_panelUno: TStatusBar
    Left = 0
    Top = 714
    Width = 685
    Height = 19
    Panels = <
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 180
      end
      item
        Width = 100
      end>
  end
end
