object Frm_credencial: TFrm_credencial
  Left = 651
  Top = 378
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Registro de nombre del pasajero'
  ClientHeight = 141
  ClientWidth = 387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 40
    Width = 44
    Height = 13
    Caption = 'Nombre :'
  end
  object Label2: TLabel
    Left = 32
    Top = 72
    Width = 57
    Height = 13
    Caption = 'Credencial :'
  end
  object SpeedButton1: TSpeedButton
    Left = 136
    Top = 91
    Width = 89
    Height = 25
    Action = acCerrar
  end
  object Edit1: TEdit
    Left = 104
    Top = 37
    Width = 261
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 50
    TabOrder = 0
  end
  object Edit2: TEdit
    Left = 104
    Top = 64
    Width = 144
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 29
    TabOrder = 1
  end
  object ActionManager1: TActionManager
    Images = DM.img_iconos
    Left = 312
    Top = 72
    StyleName = 'Platform Default'
    object acCerrar: TAction
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = acCerrarExecute
    end
  end
end
