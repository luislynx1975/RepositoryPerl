object frmATarifas: TfrmATarifas
  Left = 0
  Top = 0
  Caption = 'Alta de Tarifas'
  ClientHeight = 294
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
    Height = 294
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 814
    ExplicitHeight = 304
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 208
      Height = 293
      Align = alLeft
      TabOrder = 0
      ExplicitHeight = 302
      object Label1: TLabel
        Left = 16
        Top = -1
        Width = 60
        Height = 13
        Caption = 'Fecha Aplica'
      end
      object Label2: TLabel
        Left = 16
        Top = 29
        Width = 54
        Height = 13
        Caption = 'Hora Aplica'
      end
      object Label3: TLabel
        Left = 16
        Top = 64
        Width = 32
        Height = 13
        Caption = 'Origen'
      end
      object Label4: TLabel
        Left = 16
        Top = 99
        Width = 36
        Height = 13
        Caption = 'Destino'
      end
      object Label5: TLabel
        Left = 16
        Top = 135
        Width = 112
        Height = 13
        Caption = 'Desde Tipo de Servicio:'
      end
      object Label6: TLabel
        Left = 16
        Top = 174
        Width = 110
        Height = 13
        Caption = 'Hasta Tipo de Servicio:'
      end
      object lbl1: TLabel
        Left = 17
        Top = 214
        Width = 87
        Height = 13
        Caption = 'Impuesto a tarifa:'
      end
      object FA: TDateTimePicker
        Left = 16
        Top = 12
        Width = 186
        Height = 21
        Date = 40402.000000000000000000
        Time = 0.662049467602628300
        TabOrder = 1
      end
      object HA: TDateTimePicker
        Left = 16
        Top = 44
        Width = 186
        Height = 21
        Date = 40402.000000000000000000
        Time = 40402.000000000000000000
        Kind = dtkTime
        TabOrder = 2
      end
      object lscbSInicial: TlsComboBox
        Left = 16
        Top = 150
        Width = 186
        Height = 21
        TabOrder = 5
        Text = 'lscbSInicial'
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object lscbOrigen: TlsComboBox
        Left = 16
        Top = 78
        Width = 186
        Height = 21
        AutoComplete = False
        TabOrder = 3
        Text = 'lscbOrigen'
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object lscbDestino: TlsComboBox
        Left = 16
        Top = 111
        Width = 186
        Height = 21
        AutoComplete = False
        TabOrder = 4
        Text = 'lscbDestino'
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object Button1: TButton
        Left = 16
        Top = 245
        Width = 60
        Height = 25
        Caption = '&Buscar'
        TabOrder = 8
        OnClick = Button1Click
      end
      object Button2: TButton
        Left = 138
        Top = 245
        Width = 60
        Height = 25
        Caption = '&Salir'
        TabOrder = 0
        OnClick = Button2Click
      end
      object lscbSFinal: TlsComboBox
        Left = 18
        Top = 188
        Width = 186
        Height = 21
        TabOrder = 6
        Text = 'lscbServicio'
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
      object btnGuardar: TButton
        Left = 77
        Top = 245
        Width = 60
        Height = 25
        Caption = '&Guardar'
        TabOrder = 9
        OnClick = btnGuardarClick
      end
      object sb: TStatusBar
        Left = 1
        Top = 272
        Width = 206
        Height = 19
        Panels = <
          item
            Width = 50
          end>
        ExplicitTop = 282
      end
      object edtImpuesto: TEdit
        Left = 110
        Top = 215
        Width = 92
        Height = 21
        TabOrder = 7
        OnKeyPress = edtImpuestoKeyPress
      end
    end
    object sagInfo: TStringGrid
      Left = 209
      Top = 1
      Width = 594
      Height = 292
      Align = alClient
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 3
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 1
      OnKeyPress = sagInfoKeyPress
      OnSelectCell = sagInfoSelectCell
      ExplicitWidth = 604
      ExplicitHeight = 302
      ColWidths = (
        127
        124
        187
        89
        64)
    end
  end
  object ActionManager1: TActionManager
    Left = 64
    Top = 128
    StyleName = 'Platform Default'
    object acBuscar: TAction
      Caption = '&Buscar'
      OnExecute = acBuscarExecute
    end
    object acGuardar: TAction
      Caption = '&Guardar'
    end
  end
end
