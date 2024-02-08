object PasswordDlg: TPasswordDlg
  Left = 530
  Top = 279
  BorderIcons = []
  BorderStyle = bsDialog
  ClientHeight = 102
  ClientWidth = 320
  Color = clBtnFace
  ParentFont = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 43
    Width = 53
    Height = 15
    Caption = 'Password:'
  end
  object Label2: TLabel
    Left = 8
    Top = 10
    Width = 36
    Height = 15
    Caption = 'Login :'
  end
  object Password: TEdit
    Left = 96
    Top = 37
    Width = 217
    Height = 23
    PasswordChar = '*'
    TabOrder = 1
  end
  object OKBtn: TButton
    Left = 67
    Top = 67
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 177
    Top = 67
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = CancelBtnClick
  end
  object lsCombo_login: TlsComboBox
    Left = 96
    Top = 10
    Width = 217
    Height = 21
    AutoComplete = False
    Style = csSimple
    TabOrder = 0
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
end
