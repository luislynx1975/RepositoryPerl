object frmAdministracionCorte: TfrmAdministracionCorte
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Administracion de Cortes'
  ClientHeight = 85
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 6
    Top = 8
    Width = 44
    Height = 13
    Caption = 'Terminal:'
  end
  object lblTerminal: TLabel
    Left = 62
    Top = 8
    Width = 50
    Height = 13
    Caption = 'TERMINAL'
  end
  object Label2: TLabel
    Left = 6
    Top = 35
    Width = 48
    Height = 13
    Caption = 'Promotor:'
  end
  object lscbPromotores: TlsComboBox
    Left = 62
    Top = 30
    Width = 289
    Height = 21
    TabOrder = 0
    Text = 'lscbPromotores'
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object Button1: TButton
    Left = 174
    Top = 61
    Width = 100
    Height = 25
    Action = Action1
    TabOrder = 1
  end
  object Button2: TButton
    Left = 278
    Top = 61
    Width = 75
    Height = 25
    Action = Action2
    TabOrder = 2
  end
  object ActionManager1: TActionManager
    Left = 78
    Top = 59
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Reinicializar Corte'
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Salir'
      OnExecute = Action2Execute
    end
  end
end
