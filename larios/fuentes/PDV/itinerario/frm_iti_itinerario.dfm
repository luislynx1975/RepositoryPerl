object Frm_itinerario: TFrm_itinerario
  Left = 211
  Top = 162
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Definicion de Itinerarios (Betto)'
  ClientHeight = 417
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object sgMaximos: TStringGrid
    Left = 471
    Top = 71
    Width = 48
    Height = 38
    TabOrder = 4
    Visible = False
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object gbBusqueda: TGroupBox
    Left = 0
    Top = 32
    Width = 535
    Height = 390
    Caption = ' Criterios de b'#250'squeda '
    TabOrder = 5
    Visible = False
    object lscbServicios: TlsComboBox
      Left = 79
      Top = 77
      Width = 201
      Height = 21
      AutoComplete = False
      TabOrder = 0
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object lscbRuta: TlsComboBox
      Left = 79
      Top = 104
      Width = 145
      Height = 21
      AutoComplete = False
      TabOrder = 1
      OnClick = lsCbx_rutaClick
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object chbServicio: TCheckBox
      Left = 16
      Top = 81
      Width = 58
      Height = 17
      Caption = 'Servicio'
      TabOrder = 2
    end
    object chbRuta: TCheckBox
      Left = 16
      Top = 108
      Width = 47
      Height = 17
      Caption = 'Ruta'
      TabOrder = 3
    end
    object chbCorrida: TCheckBox
      Left = 16
      Top = 135
      Width = 54
      Height = 17
      Caption = 'Corrida'
      TabOrder = 4
    end
    object edCorrida: TEdit
      Left = 80
      Top = 131
      Width = 121
      Height = 21
      TabOrder = 5
    end
    object cbOrigen: TlsComboBox
      Left = 79
      Top = 25
      Width = 202
      Height = 21
      AutoComplete = False
      TabOrder = 6
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object chbOrigen: TCheckBox
      Left = 16
      Top = 27
      Width = 53
      Height = 17
      Caption = 'Origen'
      TabOrder = 7
    end
    object cbDestino: TlsComboBox
      Left = 79
      Top = 52
      Width = 202
      Height = 21
      AutoComplete = False
      TabOrder = 8
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object chbDestino: TCheckBox
      Left = 16
      Top = 56
      Width = 56
      Height = 17
      Caption = 'Destino'
      TabOrder = 9
    end
    object sgResultado: TStringGrid
      Left = 2
      Top = 161
      Width = 531
      Height = 227
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      DefaultRowHeight = 18
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 10
      ColWidths = (
        64
        73
        70
        95
        70)
    end
    object BitBtn6: TBitBtn
      Left = 352
      Top = 22
      Width = 113
      Height = 25
      Action = acBusqueda
      Caption = 'Buscar'
      TabOrder = 11
    end
    object BitBtn7: TBitBtn
      Left = 352
      Top = 69
      Width = 113
      Height = 25
      Action = acEliminarCorrida
      Caption = 'Eliminar corrida'
      TabOrder = 12
    end
    object BitBtn8: TBitBtn
      Left = 352
      Top = 129
      Width = 112
      Height = 25
      Action = acMostrarDetalle
      Caption = 'Mostrar detalle'
      TabOrder = 13
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 32
    Width = 313
    Height = 153
    Caption = ' Generales '
    TabOrder = 1
    object Label1: TLabel
      Left = 25
      Top = 49
      Width = 45
      Height = 13
      Caption = 'Autobus :'
    end
    object Servicio: TLabel
      Left = 25
      Top = 22
      Width = 38
      Height = 13
      Caption = 'Servicio'
    end
    object Label2: TLabel
      Left = 25
      Top = 76
      Width = 29
      Height = 13
      Caption = 'Ruta :'
    end
    object Label5: TLabel
      Left = 25
      Top = 102
      Width = 61
      Height = 13
      Caption = 'Hora Salida :'
    end
    object lID_corrida: TLabel
      Left = 25
      Top = 128
      Width = 36
      Height = 13
      Caption = '            '
    end
    object lblCreadoPor: TLabel
      Left = 290
      Top = 128
      Width = 3
      Height = 13
      Alignment = taRightJustify
    end
    object Label3: TLabel
      Left = 25
      Top = 125
      Width = 41
      Height = 13
      Caption = 'I . V . A :'
    end
    object lsCbx_bus: TlsComboBox
      Left = 92
      Top = 41
      Width = 201
      Height = 21
      AutoComplete = False
      TabOrder = 1
      OnClick = lsCbx_busClick
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object lsCbx_servicio: TlsComboBox
      Left = 92
      Top = 14
      Width = 201
      Height = 21
      AutoComplete = False
      TabOrder = 0
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object lsCbx_ruta: TlsComboBox
      Left = 92
      Top = 68
      Width = 145
      Height = 21
      AutoComplete = False
      TabOrder = 2
      OnClick = lsCbx_rutaClick
      OnExit = lsCbx_rutaClick
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object dtpHoraSalida: TDateTimePicker
      Left = 92
      Top = 94
      Width = 52
      Height = 21
      Date = 40101.000000000000000000
      Format = 'HH:mm'
      Time = 0.931944444440887300
      Kind = dtkTime
      TabOrder = 3
      OnChange = dtpHoraSalidaChange
    end
    object cmb_iva: TlsComboBox
      Left = 91
      Top = 120
      Width = 73
      Height = 21
      TabOrder = 4
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object GroupBox1: TGroupBox
    Left = 319
    Top = 32
    Width = 209
    Height = 153
    Caption = 'Dias de la semana'
    TabOrder = 0
    object cbDomingo: TCheckBox
      Left = 16
      Top = 16
      Width = 77
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Domingo :'
      TabOrder = 0
      OnClick = cbDomingoClick
    end
    object cbLunes: TCheckBox
      Left = 16
      Top = 34
      Width = 77
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Lunes :'
      TabOrder = 1
      OnClick = cbDomingoClick
    end
    object cbMartes: TCheckBox
      Left = 16
      Top = 53
      Width = 77
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Martes :'
      TabOrder = 2
      OnClick = cbDomingoClick
    end
    object cbMiercoles: TCheckBox
      Left = 16
      Top = 71
      Width = 77
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Miercoles :'
      TabOrder = 3
      OnClick = cbDomingoClick
    end
    object cbJueves: TCheckBox
      Left = 16
      Top = 90
      Width = 77
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Jueves :'
      TabOrder = 4
      OnClick = cbDomingoClick
    end
    object cbViernes: TCheckBox
      Left = 16
      Top = 109
      Width = 77
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Viernes :'
      TabOrder = 5
      OnClick = cbDomingoClick
    end
    object cbSabado: TCheckBox
      Left = 16
      Top = 128
      Width = 77
      Height = 17
      Alignment = taLeftJustify
      Caption = 'Sabado :'
      TabOrder = 6
      OnClick = cbDomingoClick
    end
    object BitBtn2: TBitBtn
      Left = 106
      Top = 17
      Width = 80
      Height = 25
      Action = acDiario
      Caption = 'Diario'
      TabOrder = 7
    end
    object BitBtn3: TBitBtn
      Left = 106
      Top = 52
      Width = 80
      Height = 25
      Action = acEntreSemana
      Caption = 'Entre semana'
      TabOrder = 8
    end
    object BitBtn4: TBitBtn
      Left = 106
      Top = 83
      Width = 80
      Height = 25
      Action = acFinDeSemana
      Caption = 'Fin de semana'
      TabOrder = 9
    end
    object btnEstablecerDias: TBitBtn
      Left = 106
      Top = 118
      Width = 80
      Height = 25
      Caption = 'Establecer dias'
      TabOrder = 10
      OnClick = btnEstablecerDiasClick
    end
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 528
    Height = 26
    ActionManager = ActionManager1
    Caption = 'ActionToolBar1'
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
    ParentFont = False
    Spacing = 0
  end
  object GroupBox3: TGroupBox
    Left = 2
    Top = 199
    Width = 337
    Height = 225
    Caption = ' Terminales '
    TabOrder = 2
    object sgTerminales: TStringGrid
      Left = 2
      Top = 45
      Width = 333
      Height = 178
      Align = alClient
      ColCount = 4
      DefaultRowHeight = 18
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnExit = sgTerminalesExit
      OnKeyPress = sgTerminalesKeyPress
      OnSelectCell = sgTerminalesSelectCell
      ColWidths = (
        64
        64
        64
        64)
    end
    object pRuta: TPanel
      Left = 2
      Top = 15
      Width = 333
      Height = 30
      Align = alTop
      TabOrder = 1
      object lbDetalle: TLabel
        Left = 1
        Top = 3
        Width = 330
        Height = 25
        Alignment = taCenter
        AutoSize = False
        WordWrap = True
      end
    end
  end
  object GroupBox4: TGroupBox
    Left = 345
    Top = 201
    Width = 185
    Height = 223
    Caption = ' Ocupantes '
    TabOrder = 3
    object sgOcupantes: TStringGrid
      Left = 2
      Top = 15
      Width = 181
      Height = 206
      Align = alClient
      ColCount = 2
      DefaultRowHeight = 18
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      TabOrder = 0
      OnExit = sgOcupantesExit
      OnKeyPress = sgOcupantesKeyPress
      RowHeights = (
        18
        18)
    end
  end
  object sagDias: TStringGrid
    Left = 224
    Top = 136
    Width = 49
    Height = 38
    ColCount = 7
    FixedCols = 0
    TabOrder = 7
    Visible = False
    ColWidths = (
      29
      20
      25
      25
      25
      27
      21)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = acLocalizar
            Caption = '&Localizar'
            ImageIndex = 20
          end
          item
            Action = acNueva
            Caption = '&Nueva'
            ImageIndex = 16
          end
          item
            Action = acModificar
            Caption = '&Modificar'
            ImageIndex = 22
          end
          item
            Action = acGuardar
            Caption = '&Guardar'
            ImageIndex = 17
          end
          item
            Action = acSalir
            Caption = '&Salir'
            ImageIndex = 15
          end>
        ActionBar = ActionToolBar1
      end>
    Images = DM.img_iconos
    Left = 272
    Top = 136
    StyleName = 'Platform Default'
    object acSalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      OnExecute = acSalirExecute
    end
    object acEntreSemana: TAction
      Caption = 'Entre semana'
      OnExecute = acEntreSemanaExecute
    end
    object acFinDeSemana: TAction
      Caption = 'Fin de semana'
      OnExecute = acFinDeSemanaExecute
    end
    object acDiario: TAction
      Caption = 'Diario'
      OnExecute = acDiarioExecute
    end
    object acNueva: TAction
      Caption = 'Nueva'
      ImageIndex = 16
      OnExecute = acNuevaExecute
    end
    object acGuardar: TAction
      Caption = 'Guardar'
      ImageIndex = 17
      OnExecute = acGuardarExecute
    end
    object acActualizar: TAction
      Caption = 'Actualizar'
      ImageIndex = 0
    end
    object acBusqueda: TAction
      Caption = 'Buscar'
      ImageIndex = 21
      OnExecute = acBusquedaExecute
    end
    object acLocalizar: TAction
      Caption = 'Localizar'
      ImageIndex = 20
      OnExecute = acLocalizarExecute
    end
    object acEliminarCorrida: TAction
      Caption = 'Eliminar corrida'
      ImageIndex = 18
      OnExecute = acEliminarCorridaExecute
    end
    object acMostrarDetalle: TAction
      Caption = 'Mostrar detalle'
      ImageIndex = 23
      OnExecute = acMostrarDetalleExecute
    end
    object acModificar: TAction
      Caption = 'Modificar'
      Enabled = False
      ImageIndex = 22
      OnExecute = acModificarExecute
    end
  end
end
