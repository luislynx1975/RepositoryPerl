object frmTerminales: TfrmTerminales
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Catalogo de Ciudades'
  ClientHeight = 246
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 3
    Top = 15
    Width = 123
    Height = 13
    Caption = 'Identificador de Terminal:'
  end
  object Label2: TLabel
    Left = 16
    Top = 39
    Width = 110
    Height = 13
    Caption = 'Nombre de la Terminal:'
  end
  object Label3: TLabel
    Left = 102
    Top = 65
    Width = 24
    Height = 13
    Caption = 'Tipo:'
  end
  object Label4: TLabel
    Left = 71
    Top = 117
    Width = 55
    Height = 13
    Caption = 'Ventanillas:'
  end
  object Label5: TLabel
    Left = 71
    Top = 90
    Width = 55
    Height = 13
    Caption = 'Tipo Venta:'
  end
  object lblBaja: TLabel
    Left = 0
    Top = 196
    Width = 282
    Height = 23
    Align = alBottom
    Alignment = taCenter
    Caption = 'CIUDAD CON ESTATUS BAJA'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    Visible = False
    ExplicitTop = 197
    ExplicitWidth = 241
  end
  object lbl1: TLabel
    Left = 85
    Top = 144
    Width = 45
    Height = 13
    Caption = 'Empresa:'
  end
  object Label6: TLabel
    Left = 44
    Top = 168
    Width = 86
    Height = 13
    Caption = 'Nombre al cliente:'
  end
  object edtIDterminal: TEdit
    Left = 132
    Top = 10
    Width = 146
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 6
    TabOrder = 0
    OnKeyPress = edtIDterminalKeyPress
  end
  object edtDescripcion: TEdit
    Left = 132
    Top = 36
    Width = 146
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 60
    TabOrder = 1
    OnKeyPress = edtDescripcionKeyPress
  end
  object cbTipo: TlsComboBox
    Left = 132
    Top = 62
    Width = 145
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 2
    OnKeyPress = edtDescripcionKeyPress
    Items.Strings = (
      'COMISION'
      'PASO'
      'TERMINAL')
    Complete = True
    ForceIndexOnExit = True
    IDs.Strings = (
      'C'
      'P'
      'T')
    MinLengthComplete = 0
  end
  object cbTipoVenta: TlsComboBox
    Left = 132
    Top = 87
    Width = 145
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 3
    OnKeyPress = edtDescripcionKeyPress
    Items.Strings = (
      'AUTOMATIZADO'
      'MANUAL')
    Complete = True
    ForceIndexOnExit = True
    IDs.Strings = (
      'A'
      'M')
    MinLengthComplete = 0
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 219
    Width = 282
    Height = 27
    UseSystemFont = False
    ActionManager = AM1
    Align = alBottom
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Spacing = 0
  end
  object edtVentanillas: TEdit
    Left = 132
    Top = 112
    Width = 128
    Height = 21
    TabOrder = 5
    Text = '0'
    OnKeyPress = edtDescripcionKeyPress
  end
  object UpDown1: TUpDown
    Left = 260
    Top = 112
    Width = 18
    Height = 21
    Associate = edtVentanillas
    TabOrder = 6
  end
  object lsEmpresa: TlsComboBox
    Left = 133
    Top = 139
    Width = 145
    Height = 21
    TabOrder = 7
    Items.Strings = (
      'PULLMAN'
      'TER')
    Complete = True
    ForceIndexOnExit = True
    IDs.Strings = (
      'PUL'
      'TER')
    MinLengthComplete = 0
  end
  object edtNombreCliente: TEdit
    Left = 133
    Top = 165
    Width = 145
    Height = 21
    MaxLength = 49
    TabOrder = 8
  end
  object AM1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = actLimpiar
            Caption = '&Limpiar'
          end
          item
            Action = Action1
            Caption = '&Guardar'
          end
          item
            Action = actSalir
            Caption = '&Salir'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 24
    Top = 72
    StyleName = 'Platform Default'
    object actSalir: TAction
      Caption = 'Salir'
      OnExecute = actSalirExecute
    end
    object Action1: TAction
      Caption = 'Guardar'
      OnExecute = Action1Execute
    end
    object actLimpiar: TAction
      Caption = 'Limpiar'
      OnExecute = actLimpiarExecute
    end
  end
end
