object frm_agencia_corrida: Tfrm_agencia_corrida
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Asignacion de corridas por agencia'
  ClientHeight = 528
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 478
    Height = 501
    Align = alClient
    TabOrder = 0
    ExplicitTop = 26
    ExplicitWidth = 488
    ExplicitHeight = 512
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 484
      Height = 129
      BevelOuter = bvLowered
      TabOrder = 0
      object Label1: TLabel
        Left = 21
        Top = 23
        Width = 45
        Height = 13
        Caption = 'Agencia :'
      end
      object Label2: TLabel
        Left = 23
        Top = 50
        Width = 43
        Height = 13
        Caption = 'Destino :'
      end
      object Label3: TLabel
        Left = 22
        Top = 77
        Width = 44
        Height = 13
        Caption = 'Servicio :'
      end
      object ls_agencia: TlsComboBox
        Left = 72
        Top = 20
        Width = 245
        Height = 21
        TabOrder = 0
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ls_destino: TlsComboBox
        Left = 72
        Top = 47
        Width = 245
        Height = 21
        TabOrder = 1
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object ls_servicio: TlsComboBox
        Left = 72
        Top = 74
        Width = 245
        Height = 21
        TabOrder = 2
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object Button1: TButton
        Left = 352
        Top = 23
        Width = 75
        Height = 25
        Caption = 'Consultar'
        TabOrder = 3
        OnClick = Button1Click
      end
      object CheckBox1: TCheckBox
        Left = 352
        Top = 112
        Width = 97
        Height = 17
        Caption = 'CheckBox1'
        TabOrder = 4
        Visible = False
      end
    end
    object Panel3: TPanel
      Left = 4
      Top = 135
      Width = 484
      Height = 378
      TabOrder = 1
      object StringGrid1: TStringGrid
        Left = 1
        Top = 1
        Width = 482
        Height = 376
        Align = alClient
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
        TabOrder = 0
        OnMouseUp = StringGrid1MouseUp
        ColWidths = (
          64
          64
          64
          154
          64)
      end
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 478
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
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = '&Guardar'
            ImageIndex = 17
            ShortCut = 16455
          end
          item
            Action = Action2
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionMainMenuBar1
      end>
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 240
    Top = 272
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Guardar'
      ImageIndex = 17
      ShortCut = 16455
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action2Execute
    end
  end
end
