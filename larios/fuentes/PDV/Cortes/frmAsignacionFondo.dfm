object frmAsignarFondo: TfrmAsignarFondo
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Asignaci'#243'n de Fondo'
  ClientHeight = 104
  ClientWidth = 431
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object lbl1: TLabel
    Left = 29
    Top = 8
    Width = 105
    Height = 13
    Caption = 'N'#250'mero de Empleado:'
  end
  object lbl2: TLabel
    Left = 8
    Top = 29
    Width = 409
    Height = 23
    Alignment = taCenter
    AutoSize = False
    WordWrap = True
  end
  object lbl3: TLabel
    Left = 18
    Top = 63
    Width = 44
    Height = 13
    Caption = 'Terminal:'
  end
  object lbl4: TLabel
    Left = 191
    Top = 60
    Width = 108
    Height = 13
    Caption = 'Importe de fondo Fijo:'
  end
  object edtTrabId: TEdit
    Left = 144
    Top = 3
    Width = 220
    Height = 21
    MaxLength = 15
    TabOrder = 0
    OnExit = edtTrabIdExit
    OnKeyPress = edtTrabIdKeyPress
  end
  object btn1: TButton
    Left = 368
    Top = 3
    Width = 23
    Height = 21
    Caption = '...'
    TabOrder = 1
    OnClick = btn1Click
  end
  object edtCiudad: TEdit
    Left = 67
    Top = 60
    Width = 121
    Height = 21
    CharCase = ecUpperCase
    Enabled = False
    TabOrder = 2
  end
  object edtFondoInicial: TEdit
    Left = 307
    Top = 57
    Width = 121
    Height = 21
    MaxLength = 4
    NumbersOnly = True
    TabOrder = 3
    Text = '0'
  end
  object btnCerrar: TButton
    Left = 352
    Top = 83
    Width = 75
    Height = 25
    Action = actCerrar
    TabOrder = 7
  end
  object btnLimpiar: TButton
    Left = 257
    Top = 83
    Width = 75
    Height = 25
    Action = actLimpiar
    TabOrder = 6
  end
  object btnAsignar: TButton
    Left = 159
    Top = 83
    Width = 75
    Height = 25
    Action = actAsignar
    TabOrder = 5
  end
  object btn2: TButton
    Left = 61
    Top = 83
    Width = 75
    Height = 25
    Caption = 'Imprimir'
    TabOrder = 4
    Visible = False
    OnClick = btn2Click
  end
  object lscbPromotores: TlsComboBox
    Left = 140
    Top = 2
    Width = 221
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnExit = lscbPromotoresExit
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object actmgr1: TActionManager
    Left = 16
    Top = 80
    StyleName = 'Platform Default'
    object actLimpiar: TAction
      Caption = '&Limpiar'
      OnExecute = actLimpiarExecute
    end
    object actAsignar: TAction
      Caption = '&Asignar'
      OnExecute = actAsignarExecute
    end
    object actCerrar: TAction
      Caption = '&Cerrar'
      OnExecute = actCerrarExecute
    end
  end
end
