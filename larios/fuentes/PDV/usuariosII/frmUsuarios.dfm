object frmUsuario: TfrmUsuario
  Left = 353
  Top = 319
  BorderIcons = []
  Caption = 'Usuarios'
  ClientHeight = 256
  ClientWidth = 439
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 439
    Height = 256
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 44
      Width = 105
      Height = 13
      Caption = 'Numero de Empleado:'
    end
    object Label2: TLabel
      Left = 16
      Top = 68
      Width = 97
      Height = 13
      Caption = 'Nombre del Usuario:'
    end
    object Label5: TLabel
      Left = 16
      Top = 156
      Width = 147
      Height = 13
      Caption = 'Fecha para cambiar Password:'
    end
    object Label6: TLabel
      Left = 16
      Top = 182
      Width = 103
      Height = 13
      Caption = 'Puesto del Empleado:'
    end
    object lblBaja: TLabel
      Left = 296
      Top = 36
      Width = 90
      Height = 25
      Caption = 'B  A  J  A'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label3: TLabel
      Left = 16
      Top = 95
      Width = 42
      Height = 13
      Caption = 'Paterno:'
    end
    object Label4: TLabel
      Left = 16
      Top = 121
      Width = 44
      Height = 13
      Caption = 'Materno:'
    end
    object Label7: TLabel
      Left = 16
      Top = 210
      Width = 79
      Height = 13
      Caption = 'Tipo de Servicio:'
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 437
      Height = 29
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 7
      object ActionMainMenuBar1: TActionMainMenuBar
        Left = 2
        Top = 2
        Width = 433
        Height = 30
        UseSystemFont = False
        ActionManager = ActionManager1
        Caption = 'ActionMainMenuBar1'
        Color = clMenuBar
        ColorMap.DisabledFontColor = 10461087
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
      object cbTipoEmpleado: TCheckBox
        Left = 288
        Top = 5
        Width = 141
        Height = 17
        Caption = 'Administrativo'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 1
        OnClick = cbTipoEmpleadoClick
      end
    end
    object edtTrabId: TEdit
      Left = 128
      Top = 41
      Width = 121
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 7
      TabOrder = 0
      OnExit = edtTrabIdExit
      OnKeyPress = edtTrabIdKeyPress
    end
    object edtNombre: TEdit
      Left = 128
      Top = 68
      Width = 301
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 40
      TabOrder = 1
    end
    object dtpPassword: TDateTimePicker
      Left = 245
      Top = 149
      Width = 185
      Height = 21
      Date = 40665.000000000000000000
      Time = 0.689136655091715500
      TabOrder = 4
    end
    object lscbPuestos: TlsComboBox
      Left = 128
      Top = 178
      Width = 301
      Height = 21
      TabOrder = 5
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object edtPaterno: TEdit
      Left = 129
      Top = 95
      Width = 301
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 40
      TabOrder = 2
    end
    object edtMaterno: TEdit
      Left = 128
      Top = 121
      Width = 301
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 40
      TabOrder = 3
    end
    object lscbServicios: TlsComboBox
      Left = 129
      Top = 207
      Width = 301
      Height = 21
      TabOrder = 6
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = '&Limpiar'
          end
          item
            Action = Action2
            Caption = '&Guardar'
          end
          item
            Action = Action3
            Caption = '&Baja'
          end
          item
            Action = Action5
            Caption = '&Contrase'#241'a'
          end
          item
            Action = Action6
            Caption = '&Activar'
          end
          item
            Action = Action4
            Caption = '&Salir'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 208
    Top = 64
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Limpiar'
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Guardar'
      OnExecute = Action2Execute
    end
    object Action3: TAction
      Caption = 'Baja'
      OnExecute = Action3Execute
    end
    object Action5: TAction
      Caption = 'Contrase'#241'a'
      Hint = 'Se reestablece la contrase'#241'a del usuario'
      OnExecute = Action5Execute
    end
    object Action6: TAction
      Caption = 'Activar'
      Hint = 'Cambia el estatus de baja del usuario'
      OnExecute = Action6Execute
    end
    object Action4: TAction
      Caption = 'Salir'
      OnExecute = Action4Execute
    end
    object actReplicar: TAction
      Caption = 'Replicar'
      ShortCut = 16466
      OnExecute = actReplicarExecute
    end
  end
end
