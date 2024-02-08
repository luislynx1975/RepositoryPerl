object Frm_cancelaciones: TFrm_cancelaciones
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Cancelaciones de boletos'
  ClientHeight = 247
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 228
    Width = 391
    Height = 19
    Panels = <>
    ExplicitTop = 238
    ExplicitWidth = 401
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 391
    Height = 27
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 391
    Height = 201
    Align = alClient
    TabOrder = 2
    object Label1: TLabel
      Left = 40
      Top = 40
      Width = 81
      Height = 13
      Caption = 'Clave promotor :'
    end
    object Label2: TLabel
      Left = 74
      Top = 71
      Width = 47
      Height = 13
      Caption = 'Terminal :'
    end
    object Label3: TLabel
      Left = 54
      Top = 101
      Width = 67
      Height = 13
      Caption = 'Clave boleto :'
    end
    object edt_promotor: TEdit
      Left = 144
      Top = 37
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object ls_Origen_vta: TlsComboBox
      Left = 144
      Top = 68
      Width = 241
      Height = 21
      CharCase = ecUpperCase
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -9
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object edt_boleto: TlsNumericEdit
      Left = 144
      Top = 98
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '0'
      AceptNegative = False
      Decimals = 0
      DisplayFormat = Normal
    end
    object Button1: TButton
      Left = 144
      Top = 144
      Width = 81
      Height = 25
      Action = Action1
      TabOrder = 3
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Caption = '&Sistema'
          end
          item
            Caption = 'S&istema'
          end>
      end
      item
        Items = <
          item
            Items = <
              item
                Action = acSalir
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 328
    Top = 40
    StyleName = 'Platform Default'
    object acSalir: TAction
      Category = 'Sistema'
      Caption = '&Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = acSalirExecute
    end
    object Action1: TAction
      Caption = 'Ejecutar'
      ImageIndex = 52
      ShortCut = 16453
      OnExecute = Action1Execute
    end
  end
end
