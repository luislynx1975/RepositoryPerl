object frm_agencias: Tfrm_agencias
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'frm_agencias'
  ClientHeight = 296
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 543
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
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 543
    Height = 269
    Align = alClient
    TabOrder = 1
    ExplicitTop = 26
    ExplicitWidth = 553
    ExplicitHeight = 280
    object Label1: TLabel
      Left = 6
      Top = 43
      Width = 110
      Height = 13
      Caption = 'Nombre de la agencia :'
    end
    object Label2: TLabel
      Left = 45
      Top = 70
      Width = 71
      Height = 13
      Caption = 'Asiento inicial :'
    end
    object Label3: TLabel
      Left = 48
      Top = 97
      Width = 68
      Height = 13
      Caption = 'Asiento Final :'
    end
    object Label4: TLabel
      Left = 82
      Top = 17
      Width = 34
      Height = 13
      Caption = 'Clave :'
    end
    object edt_nombre: TEdit
      Left = 120
      Top = 40
      Width = 321
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 0
    end
    object ls_inicio: TlsComboBox
      Left = 120
      Top = 67
      Width = 145
      Height = 21
      Enabled = False
      TabOrder = 1
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object ls_final: TlsComboBox
      Left = 120
      Top = 94
      Width = 145
      Height = 21
      Enabled = False
      TabOrder = 2
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object stg_agencia: TStringGrid
      Left = 1
      Top = 148
      Width = 541
      Height = 120
      Align = alBottom
      ColCount = 4
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 3
      OnSelectCell = stg_agenciaSelectCell
      ExplicitTop = 159
      ExplicitWidth = 551
      ColWidths = (
        276
        91
        89
        64)
    end
    object edt_clave: TEdit
      Left = 120
      Top = 14
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      Enabled = False
      TabOrder = 4
    end
    object Button1: TButton
      Left = 447
      Top = 12
      Width = 92
      Height = 25
      Caption = 'Terminal-Agencia'
      TabOrder = 5
      OnClick = Button1Click
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = '&Nuevo'
            ImageIndex = 16
            ShortCut = 16462
          end
          item
            Action = acGuardar
            Caption = '&Guardar'
            ImageIndex = 17
            ShortCut = 16455
          end
          item
            Action = acEliminar
            Caption = '&Modificar'
            ImageIndex = 18
            ShortCut = 16450
          end
          item
            Action = Salir
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionMainMenuBar1
      end>
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 296
    Top = 32
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Nuevo'
      ImageIndex = 16
      ShortCut = 16462
      OnExecute = Action1Execute
    end
    object acGuardar: TAction
      Caption = 'Guardar'
      ImageIndex = 17
      ShortCut = 16455
      OnExecute = acGuardarExecute
    end
    object acEliminar: TAction
      Caption = 'Modificar'
      ImageIndex = 18
      ShortCut = 16450
      OnExecute = acEliminarExecute
    end
    object Salir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = SalirExecute
    end
  end
end
