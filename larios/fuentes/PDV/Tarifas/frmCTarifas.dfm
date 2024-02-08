object frmCTarifa: TfrmCTarifa
  Left = 0
  Top = 0
  Caption = 'Consulta de Tarifas '
  ClientHeight = 252
  ClientWidth = 804
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poOwnerFormCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 804
    Height = 252
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 753
    ExplicitHeight = 262
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 208
      Height = 251
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 260
      object Label1: TLabel
        Left = 16
        Top = 3
        Width = 59
        Height = 13
        Caption = 'Fecha Inicial'
      end
      object Label2: TLabel
        Left = 16
        Top = 43
        Width = 58
        Height = 13
        Caption = 'Fecha Final:'
      end
      object Label3: TLabel
        Left = 16
        Top = 82
        Width = 32
        Height = 13
        Caption = 'Origen'
      end
      object Label4: TLabel
        Left = 16
        Top = 123
        Width = 36
        Height = 13
        Caption = 'Destino'
      end
      object Label5: TLabel
        Left = 16
        Top = 167
        Width = 79
        Height = 13
        Caption = 'Tipo de Servicio:'
      end
      object FI: TDateTimePicker
        Left = 16
        Top = 16
        Width = 186
        Height = 21
        Date = 40402.000000000000000000
        Time = 0.662049467602628300
        TabOrder = 0
      end
      object FF: TDateTimePicker
        Left = 16
        Top = 58
        Width = 186
        Height = 21
        Date = 40402.000000000000000000
        Time = 0.662897071757470300
        TabOrder = 1
      end
      object lscbServicio: TlsComboBox
        Left = 16
        Top = 185
        Width = 186
        Height = 21
        TabOrder = 4
        Text = 'lscbServicio'
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object lscbOrigen: TlsComboBox
        Left = 16
        Top = 99
        Width = 186
        Height = 21
        AutoComplete = False
        TabOrder = 2
        Text = 'lscbOrigen'
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object lscbDestino: TlsComboBox
        Left = 16
        Top = 140
        Width = 186
        Height = 21
        AutoComplete = False
        TabOrder = 3
        Text = 'lscbDestino'
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object Button1: TButton
        Left = 16
        Top = 213
        Width = 75
        Height = 24
        Caption = '&Buscar'
        TabOrder = 5
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 127
        Top = 213
        Width = 75
        Height = 24
        Caption = '&Salir'
        TabOrder = 6
        OnClick = Button2Click
      end
      object sb: TStatusBar
        Left = 1
        Top = 230
        Width = 206
        Height = 19
        Panels = <
          item
            Width = 50
          end>
        ExplicitTop = 240
      end
    end
    object sagInfo: TStringGrid
      Left = 209
      Top = 1
      Width = 594
      Height = 250
      Align = alClient
      ColCount = 6
      DefaultRowHeight = 18
      FixedCols = 0
      TabOrder = 1
      ExplicitWidth = 543
      ExplicitHeight = 260
      ColWidths = (
        214
        67
        64
        120
        64
        64)
    end
  end
  object ActionManager1: TActionManager
    Left = 312
    Top = 136
    StyleName = 'Platform Default'
    object acBuscar: TAction
      Caption = 'acBuscar'
      OnExecute = acBuscarExecute
    end
  end
end
