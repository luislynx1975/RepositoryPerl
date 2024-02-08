object frm_vigencia_abierto: Tfrm_vigencia_abierto
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Extension de vigencia '
  ClientHeight = 142
  ClientWidth = 448
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  Position = poScreenCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 48
    Top = 59
    Width = 40
    Height = 13
    Caption = 'Codigo :'
  end
  object edt_codigo: TEdit
    Left = 94
    Top = 56
    Width = 313
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object Button1: TButton
    Left = 186
    Top = 100
    Width = 75
    Height = 25
    Action = acImprime
    TabOrder = 1
  end
  object ActionList1: TActionList
    Left = 336
    Top = 24
    object acImprime: TAction
      Caption = 'Imprime'
      OnExecute = acImprimeExecute
    end
    object Action1: TAction
      Caption = 'Salir'
      OnExecute = Action1Execute
    end
  end
  object MainMenu1: TMainMenu
    Left = 184
    Top = 24
    object Sistema1: TMenuItem
      Caption = 'Sistema'
      object Salir1: TMenuItem
        Action = Action1
        ShortCut = 16467
      end
    end
  end
end
