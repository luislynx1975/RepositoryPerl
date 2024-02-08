object frm_cancelacion_boletos: Tfrm_cancelacion_boletos
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Cancelacion de boletos'
  ClientHeight = 235
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 407
    Height = 27
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 27
    Width = 407
    Height = 189
    Align = alClient
    TabOrder = 1
    ExplicitTop = 29
    ExplicitWidth = 405
    ExplicitHeight = 179
    object Label2: TLabel
      Left = 63
      Top = 49
      Width = 39
      Height = 13
      Caption = 'Origen :'
    end
    object Label3: TLabel
      Left = 24
      Top = 76
      Width = 81
      Height = 13
      Caption = 'Clave promotor :'
    end
    object Label4: TLabel
      Left = 63
      Top = 101
      Width = 29
      Height = 13
      Caption = 'Folio :'
    end
    object Label5: TLabel
      Left = 24
      Top = 24
      Width = 75
      Height = 13
      Caption = 'Ciudad Origen :'
    end
    object ls_Origen_vta: TlsComboBox
      Left = 120
      Top = 46
      Width = 273
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
    object edtFolio: TlsNumericEdit
      Left = 120
      Top = 98
      Width = 121
      Height = 21
      TabOrder = 3
      Text = '0'
      AceptNegative = False
      Decimals = 0
      DisplayFormat = Normal
    end
    object ls_Origen_: TlsComboBox
      Left = 105
      Top = 19
      Width = 145
      Height = 21
      Style = csSimple
      Enabled = False
      TabOrder = 0
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object Button1: TButton
      Left = 133
      Top = 130
      Width = 75
      Height = 25
      Caption = 'Ejecutar'
      TabOrder = 4
      OnClick = Button1Click
    end
    object edt_trabid: TEdit
      Left = 120
      Top = 73
      Width = 121
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 216
    Width = 407
    Height = 19
    Panels = <>
    ExplicitTop = 226
    ExplicitWidth = 417
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action1
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 424
    Top = 240
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action1Execute
    end
  end
end
