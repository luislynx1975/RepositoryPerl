object frm_updateCorridas: Tfrm_updateCorridas
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Modificacion de coprridas remotas '
  ClientHeight = 464
  ClientWidth = 830
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object grp_corridas_remotas: TGroupBox
    Left = 0
    Top = 89
    Width = 830
    Height = 375
    Align = alClient
    Caption = 'Datos para la conexion remota :'
    Color = clBtnShadow
    Enabled = False
    ParentBackground = False
    ParentColor = False
    PopupMenu = PopupMenu1
    TabOrder = 0
    ExplicitWidth = 826
    ExplicitHeight = 374
    object stg_corrida: TStringGrid
      Left = 48
      Top = 88
      Width = 697
      Height = 259
      ColCount = 14
      DefaultColWidth = 90
      DefaultRowHeight = 20
      FixedCols = 0
      RowCount = 2
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Times New Roman'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
      ParentFont = False
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
    object dtp_calendario: TDateTimePicker
      Left = 48
      Top = 40
      Width = 186
      Height = 23
      Date = 44896.000000000000000000
      Time = 0.688867152777675100
      TabOrder = 1
    end
    object Button3: TButton
      Left = 264
      Top = 40
      Width = 75
      Height = 25
      Action = acConsultar
      TabOrder = 2
    end
    object StatusBar1: TStatusBar
      Left = 2
      Top = 354
      Width = 826
      Height = 19
      Panels = <
        item
          Width = 450
        end
        item
          Text = 'Conectado :'
          Width = 80
        end
        item
          Width = 50
        end>
      ExplicitTop = 353
      ExplicitWidth = 822
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 830
    Height = 89
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 826
    object Label1: TLabel
      Left = 88
      Top = 49
      Width = 51
      Height = 15
      Caption = 'Terminal :'
    end
    object lbl_conectado: TLabel
      Left = 88
      Top = 11
      Width = 4
      Height = 21
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Segoe UI Semibold'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cmb_terminal: TlsComboBox
      Left = 160
      Top = 46
      Width = 289
      Height = 23
      TabOrder = 0
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object Button1: TButton
      Left = 480
      Top = 35
      Width = 80
      Height = 40
      Action = acConecta
      TabOrder = 1
    end
    object Button2: TButton
      Left = 576
      Top = 35
      Width = 80
      Height = 40
      Action = acSalir
      TabOrder = 2
    end
  end
  object ActionList1: TActionList
    Left = 336
    Top = 273
    object acConecta: TAction
      Caption = 'Conecta :'
      OnExecute = acConectaExecute
    end
    object acSalir: TAction
      Caption = 'Salir'
      OnExecute = acSalirExecute
    end
    object acConsultar: TAction
      Caption = 'Consultar'
      OnExecute = acConsultarExecute
    end
    object acAbrir: TAction
      Caption = 'Abrir'
    end
    object acCerrar: TAction
      Caption = 'Cerrar'
      OnExecute = acCerrarExecute
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 456
    Top = 313
    object Abrir1: TMenuItem
      Caption = 'Abrir'
      OnClick = Abrir1Click
    end
    object Cerrar1: TMenuItem
      Caption = 'Cerrar'
      OnClick = acCerrarExecute
    end
  end
end
