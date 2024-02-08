object ModificacionRemotaGuias: TModificacionRemotaGuias
  Left = 0
  Top = 0
  BorderIcons = [biMinimize]
  BorderStyle = bsSingle
  Caption = 'Modificaci'#243'n Remota de Gu'#237'as'
  ClientHeight = 229
  ClientWidth = 418
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
  object lbl1: TLabel
    Left = 12
    Top = 6
    Width = 185
    Height = 13
    Caption = 'Servidor de la gu'#237'a remota a modificar:'
  end
  object lblConectado: TLabel
    Left = 4
    Top = 28
    Width = 414
    Height = 29
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    WordWrap = True
  end
  object lbl3: TLabel
    Left = 12
    Top = 94
    Width = 80
    Height = 13
    Caption = 'N'#250'mero de Gu'#237'a:'
  end
  object lbl5: TLabel
    Left = 12
    Top = 65
    Width = 82
    Height = 13
    Caption = 'Fecha de la gu'#237'a:'
  end
  object lbl6: TLabel
    Left = 12
    Top = 184
    Width = 50
    Height = 13
    Caption = 'Operador:'
  end
  object lbl7: TLabel
    Left = 236
    Top = 68
    Width = 44
    Height = 13
    Caption = 'Boletera:'
  end
  object lbl2: TLabel
    Left = 236
    Top = 95
    Width = 44
    Height = 13
    Caption = 'Autobus:'
  end
  object lbl4: TLabel
    Left = 12
    Top = 120
    Width = 94
    Height = 13
    Caption = 'N'#250'mero de Corrida:'
  end
  object lblCorrida: TLabel
    Left = 112
    Top = 120
    Width = 117
    Height = 22
    Alignment = taCenter
    AutoSize = False
    Caption = '0'
  end
  object lbl8: TLabel
    Left = 236
    Top = 120
    Width = 32
    Height = 13
    Caption = 'Emiti'#243':'
  end
  object lblEmitio: TLabel
    Left = 301
    Top = 120
    Width = 117
    Height = 19
    Alignment = taCenter
    AutoSize = False
    Caption = '000000'
  end
  object lbl9: TLabel
    Left = 12
    Top = 152
    Width = 39
    Height = 13
    Caption = 'Horario:'
  end
  object lblHora: TLabel
    Left = 112
    Top = 152
    Width = 117
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '00:00'
  end
  object lscbServidores: TlsComboBox
    Left = 199
    Top = 6
    Width = 219
    Height = 21
    AutoComplete = False
    TabOrder = 0
    Complete = True
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object edtGuia: TEdit
    Left = 108
    Top = 91
    Width = 99
    Height = 21
    MaxLength = 15
    TabOrder = 2
  end
  object dtpFechaGuia: TDateTimePicker
    Left = 108
    Top = 65
    Width = 121
    Height = 21
    Date = 42523.000000000000000000
    Time = 0.535440590283542400
    TabOrder = 1
  end
  object edtBoletera: TEdit
    Left = 300
    Top = 65
    Width = 121
    Height = 21
    TabOrder = 4
  end
  object btn2: TButton
    Left = 207
    Top = 91
    Width = 22
    Height = 21
    Caption = '...'
    TabOrder = 3
    OnClick = btn2Click
  end
  object edtAutobus: TEdit
    Left = 301
    Top = 92
    Width = 121
    Height = 21
    TabOrder = 5
  end
  object btnActualizar: TButton
    Left = 299
    Top = 207
    Width = 121
    Height = 25
    Caption = 'Actualizar datos'
    TabOrder = 9
    OnClick = btnActualizarClick
  end
  object btnLimpiar: TButton
    Left = 174
    Top = 207
    Width = 121
    Height = 25
    Caption = 'Limpiar'
    TabOrder = 8
    OnClick = btnLimpiarClick
  end
  object lscbOperador: TlsComboBox
    Left = 108
    Top = 181
    Width = 310
    Height = 21
    TabOrder = 6
    Complete = False
    ForceIndexOnExit = True
    MinLengthComplete = 0
  end
  object btn1: TButton
    Left = 50
    Top = 207
    Width = 121
    Height = 25
    Caption = '&Cerrar'
    TabOrder = 7
    OnClick = btn1Click
  end
end
