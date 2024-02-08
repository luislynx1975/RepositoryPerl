object frm_forma_pago: Tfrm_forma_pago
  Left = 397
  Top = 47
  BorderIcons = []
  Caption = 'Formas de pago'
  ClientHeight = 652
  ClientWidth = 690
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
    Width = 690
    Height = 633
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 700
    ExplicitHeight = 643
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
        Left = 107
        Top = 10
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
        Height = 22
        Alignment = taRightJustify
        Enabled = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
      end
      object edt_recibido: TEdit
        Left = 108
        Top = 124
        Width = 121
        Height = 22
        Alignment = taRightJustify
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 2
        OnChange = edt_recibidoChange
      end
      object edt_total_efectivo: TEdit
        Left = 108
        Top = 56
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
      Height = 196
      TabOrder = 0
      object stg_formas_pago: TStringGrid
        Left = 2
        Top = 15
        Width = 458
        Height = 179
        Align = alClient
        ColCount = 6
        DefaultRowHeight = 19
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goAlwaysShowEditor]
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
      Top = 202
      Width = 601
      Height = 437
      ColCount = 8
      DefaultRowHeight = 16
      FixedCols = 0
      RowCount = 2
      TabOrder = 2
      Visible = False
      OnSelectCell = stg_pago_detalleSelectCell
      ColWidths = (
        64
        63
        68
        96
        140
        5
        64
        64)
    end
  end
  object stb_forma_pago: TStatusBar
    Left = 0
    Top = 633
    Width = 690
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 100
      end
      item
        Width = 200
      end
      item
        Width = 100
      end
      item
        Width = 50
      end>
    ExplicitTop = 643
    ExplicitWidth = 700
  end
end
