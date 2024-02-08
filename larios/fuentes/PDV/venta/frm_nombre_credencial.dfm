object frm_entrada_boleto: Tfrm_entrada_boleto
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Registro de pasajero'
  ClientHeight = 198
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 80
    Top = 135
    Width = 97
    Height = 33
    Action = acCerrar
  end
  object edit_nombre: TLabeledEdit
    Left = 56
    Top = 48
    Width = 121
    Height = 21
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = 'Nombre:'
    TabOrder = 0
  end
  object edt_card: TLabeledEdit
    Left = 56
    Top = 100
    Width = 121
    Height = 21
    EditLabel.Width = 50
    EditLabel.Height = 13
    EditLabel.Caption = 'Credencial'
    TabOrder = 1
    OnKeyPress = edt_cardKeyPress
  end
  object ActionManager1: TActionManager
    Images = DM.img_iconos
    Left = 40
    Top = 8
    StyleName = 'Platform Default'
    object acCerrar: TAction
      Caption = 'Cerrar'
      ImageIndex = 15
      OnExecute = acCerrarExecute
    end
  end
end
