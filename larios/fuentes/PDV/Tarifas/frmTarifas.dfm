object frmTarifa: TfrmTarifa
  Left = 247
  Top = 167
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Catalogo de Tarifas'
  ClientHeight = 493
  ClientWidth = 874
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 874
    Height = 493
    Align = alClient
    BevelInner = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 15
      Top = 38
      Width = 80
      Height = 13
      Caption = 'Tipo de Servicio:'
    end
    object Label2: TLabel
      Left = 15
      Top = 110
      Width = 67
      Height = 26
      Caption = 'Fecha / Hora Aplica:'
      WordWrap = True
    end
    object lblAyuda: TLabel
      Left = 9
      Top = 146
      Width = 117
      Height = 26
      Alignment = taCenter
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      WordWrap = True
    end
    object Label7: TLabel
      Left = 15
      Top = 64
      Width = 85
      Height = 39
      Caption = 'Tarifas a la Fecha Hora de Aplicacion:'
      WordWrap = True
    end
    object pcTarifas: TPageControl
      Left = 384
      Top = 25
      Width = 488
      Height = 466
      ActivePage = TabSheet3
      Align = alRight
      TabOrder = 4
      OnChange = pcTarifasChange
      object TabSheet1: TTabSheet
        Caption = 'Consulta Tarifas Ruta'
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object sagRutas: TStringAlignGrid
          Left = 3
          Top = 2
          Width = 137
          Height = 407
          ColCount = 1
          DefaultRowHeight = 18
          FixedCols = 0
          TabOrder = 0
          OnSelectCell = sagRutasSelectCell
          ColWidths = (
            131)
          Cells = (
            0
            0
            #21842#16724#0#27756)
          PropCell = (
            0
            0
            1
            2
            0)
          PropCol = ()
          PropRow = ()
          PropFixedCol = ()
          PropFixedRow = ()
        end
        object panelAgrega: TPanel
          Left = 146
          Top = 310
          Width = 306
          Height = 103
          BevelInner = bvLowered
          Enabled = False
          TabOrder = 1
          object Label3: TLabel
            Left = 12
            Top = 16
            Width = 34
            Height = 13
            Caption = 'Origen:'
          end
          object Label4: TLabel
            Left = 12
            Top = 47
            Width = 39
            Height = 13
            Caption = 'Destino:'
          end
          object Label5: TLabel
            Left = 12
            Top = 72
            Width = 30
            Height = 13
            Caption = 'Tarifa:'
          end
          object btnGuardar: TButton
            Tag = 160
            Left = 218
            Top = 11
            Width = 75
            Height = 25
            Caption = '&Guardar'
            ImageIndex = 3
            Images = ImageList1
            TabOrder = 0
            OnClick = btnGuardarClick
          end
          object btnCancelar: TButton
            Left = 218
            Top = 68
            Width = 75
            Height = 25
            Caption = '&Cancelar'
            ImageIndex = 2
            Images = ImageList1
            TabOrder = 1
            OnClick = btnCancelarClick
          end
          object edTarifaRutas: TEdit
            Left = 64
            Top = 72
            Width = 145
            Height = 21
            Enabled = False
            MaxLength = 5
            TabOrder = 2
            OnKeyPress = edTarifaRutasKeyPress
          end
          object lscbDestinoTarifaRutas: TlsComboBox
            Left = 63
            Top = 43
            Width = 150
            Height = 21
            Enabled = False
            TabOrder = 3
            Complete = True
            ForceIndexOnExit = True
            MinLengthComplete = 0
          end
          object lscbOrigenTarifaRutas: TlsComboBox
            Left = 63
            Top = 11
            Width = 150
            Height = 21
            Enabled = False
            TabOrder = 4
            Complete = True
            ForceIndexOnExit = True
            MinLengthComplete = 0
          end
        end
        object sbRutas: TStatusBar
          Left = 0
          Top = 419
          Width = 480
          Height = 19
          Panels = <
            item
              Width = 180
            end
            item
              Width = 50
            end>
        end
        object sagTramosRuta: TStringAlignGrid
          Left = 146
          Top = 3
          Width = 304
          Height = 306
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 2
          TabOrder = 3
          OnSelectCell = sagTramosRutaSelectCell
          ColWidths = (
            142
            128)
          Cells = (
            0
            0
            #21071#18249#20037#0#47152#6860
            1
            0
            #17732#21587#20041'O'#47152#6860#49972)
          PropCell = ()
          PropCol = ()
          PropRow = ()
          PropFixedCol = ()
          PropFixedRow = ()
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Consulta Tarifas Origen'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label11: TLabel
          Left = 5
          Top = 5
          Width = 65
          Height = 13
          Caption = 'Punto Origen:'
        end
        object PanelAgrega2: TPanel
          Left = 147
          Top = 301
          Width = 304
          Height = 116
          BevelInner = bvLowered
          Enabled = False
          TabOrder = 0
          object Label8: TLabel
            Left = 22
            Top = 15
            Width = 34
            Height = 13
            Caption = 'Origen:'
          end
          object Label9: TLabel
            Left = 15
            Top = 48
            Width = 39
            Height = 13
            Caption = 'Destino:'
          end
          object Label10: TLabel
            Left = 15
            Top = 86
            Width = 30
            Height = 13
            Caption = 'Tarifa:'
          end
          object btnGuarda2: TButton
            Tag = 160
            Left = 223
            Top = 16
            Width = 75
            Height = 25
            Caption = '&Guardar'
            ImageIndex = 3
            Images = ImageList1
            TabOrder = 0
            OnClick = btnGuarda2Click
          end
          object btnCancela2: TButton
            Left = 224
            Top = 79
            Width = 75
            Height = 25
            Caption = '&Cancelar'
            ImageIndex = 2
            Images = ImageList1
            TabOrder = 1
            OnClick = btnCancela2Click
          end
          object edTarifaOrigen: TEdit
            Left = 69
            Top = 80
            Width = 145
            Height = 21
            Enabled = False
            MaxLength = 5
            TabOrder = 2
            OnKeyPress = edTarifaOrigenKeyPress
          end
          object DestinoOrigen: TlsComboBox
            Left = 69
            Top = 48
            Width = 145
            Height = 21
            Enabled = False
            TabOrder = 3
            Complete = True
            ForceIndexOnExit = True
            MinLengthComplete = 0
          end
          object OrigenOrigen: TlsComboBox
            Left = 69
            Top = 16
            Width = 145
            Height = 21
            Enabled = False
            TabOrder = 4
            Complete = True
            ForceIndexOnExit = True
            MinLengthComplete = 0
          end
        end
        object sbRutasDesdeOrigen: TStatusBar
          Left = 0
          Top = 419
          Width = 480
          Height = 19
          Panels = <
            item
              Width = 180
            end
            item
              Width = 50
            end>
        end
        object lscbOrigen: TlsComboBox
          Left = 0
          Top = 30
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          TabOrder = 2
          OnChange = lscbOrigenChange
          Complete = False
          ForceIndexOnExit = True
          MinLengthComplete = 0
        end
        object sagTramosRutaDesdeOrigen: TStringAlignGrid
          Left = 147
          Top = 0
          Width = 302
          Height = 297
          ColCount = 2
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 2
          TabOrder = 3
          OnSelectCell = sagTramosRutaDesdeOrigenSelectCell
          ColWidths = (
            150
            128)
          Cells = (
            0
            0
            #21071#18249#20037#0#47152#6860
            1
            0
            #17732#21587#20041'O'#47152#6860#49972)
          PropCell = ()
          PropCol = ()
          PropRow = ()
          PropFixedCol = ()
          PropFixedRow = ()
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Agregar Tarifas Ruta'
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object sagRutasAgrega: TStringAlignGrid
          Left = 3
          Top = 2
          Width = 137
          Height = 407
          ColCount = 1
          DefaultRowHeight = 18
          FixedCols = 0
          TabOrder = 0
          OnSelectCell = sagRutasAgregaSelectCell
          ColWidths = (
            131)
          Cells = (
            0
            0
            #21842#16724#0#27756)
          PropCell = (
            0
            0
            1
            2
            0)
          PropCol = ()
          PropRow = ()
          PropFixedCol = ()
          PropFixedRow = ()
        end
        object sagTramosRutaAgrega: TStringAlignGrid
          Left = 147
          Top = 8
          Width = 303
          Height = 335
          ColCount = 3
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          TabOrder = 1
          OnKeyPress = sagTramosRutaAgregaKeyPress
          OnSelectCell = sagTramosRutaAgregaSelectCell
          ColWidths = (
            91
            90
            89)
          Cells = (
            0
            0
            #21071#18249#20037#0#47152#6860
            1
            0
            #17732#21587#20041'O'#47152#6860#49972
            2
            0
            #16724#18770#16710#0#47152#6860)
          PropCell = (
            0
            0
            1
            1
            0
            0
            1
            1
            1
            0
            1
            0
            1
            2
            0
            1
            1
            1
            1
            0
            2
            0
            1
            0
            0
            2
            1
            1
            1
            0)
          PropCol = ()
          PropRow = ()
          PropFixedCol = ()
          PropFixedRow = ()
        end
        object sbRutasAgrega: TStatusBar
          Left = 0
          Top = 419
          Width = 480
          Height = 19
          Panels = <
            item
              Width = 180
            end
            item
              Width = 50
            end>
        end
        object Panel2: TPanel
          Left = 147
          Top = 347
          Width = 302
          Height = 62
          BevelInner = bvLowered
          TabOrder = 3
          object Button1: TButton
            Tag = 160
            Left = 13
            Top = 17
            Width = 75
            Height = 25
            Caption = '&Guardar'
            ImageIndex = 3
            Images = ImageList1
            TabOrder = 0
            OnClick = Button1Click
          end
          object Button2: TButton
            Left = 208
            Top = 17
            Width = 75
            Height = 25
            Caption = '&Cancelar'
            ImageIndex = 2
            Images = ImageList1
            TabOrder = 1
            OnClick = Button2Click
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Agregar Tarifas Origen'
        ImageIndex = 2
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Label6: TLabel
          Left = 5
          Top = 5
          Width = 65
          Height = 13
          Caption = 'Punto Origen:'
        end
        object sagDestinosAgrega: TStringAlignGrid
          Left = 155
          Top = 7
          Width = 299
          Height = 335
          ColCount = 3
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 2
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
          TabOrder = 0
          OnKeyPress = sagTramosRutaAgregaKeyPress
          OnSelectCell = sagTramosRutaAgregaSelectCell
          ColWidths = (
            94
            87
            91)
          Cells = (
            0
            0
            #21071#18249#20037#0#47152#6860
            1
            0
            #17732#21587#20041'O'#47152#6860#49972
            2
            0
            #16724#18770#16710#0#47152#6860)
          PropCell = (
            0
            0
            1
            1
            0
            0
            1
            1
            1
            0
            1
            0
            1
            2
            0
            1
            1
            1
            1
            0
            2
            0
            1
            0
            0
            2
            1
            1
            1
            0)
          PropCol = ()
          PropRow = ()
          PropFixedCol = ()
          PropFixedRow = ()
        end
        object lscbPuntoOrigenAgrega: TlsComboBox
          Left = 0
          Top = 30
          Width = 138
          Height = 21
          CharCase = ecUpperCase
          TabOrder = 1
          OnChange = lscbPuntoOrigenAgregaChange
          Complete = False
          ForceIndexOnExit = True
          MinLengthComplete = 0
        end
        object PanelOrigen: TStatusBar
          Left = 0
          Top = 419
          Width = 480
          Height = 19
          Panels = <
            item
              Width = 180
            end
            item
              Width = 50
            end>
        end
        object Panel3: TPanel
          Left = 155
          Top = 347
          Width = 300
          Height = 62
          BevelInner = bvLowered
          TabOrder = 3
          object Button3: TButton
            Tag = 160
            Left = 13
            Top = 17
            Width = 75
            Height = 25
            Caption = '&Guardar'
            ImageIndex = 3
            Images = ImageList1
            TabOrder = 0
            OnClick = Button3Click
          end
          object Button4: TButton
            Left = 208
            Top = 17
            Width = 75
            Height = 25
            Caption = '&Cancelar'
            ImageIndex = 2
            Images = ImageList1
            TabOrder = 1
          end
        end
      end
    end
    object lscbServicios: TlsComboBox
      Left = 103
      Top = 38
      Width = 258
      Height = 21
      AutoComplete = False
      TabOrder = 0
      Complete = True
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
    object dtpFechaAplicacion: TDateTimePicker
      Left = 103
      Top = 113
      Width = 129
      Height = 21
      Date = 40091.510006990740000000
      Time = 40091.510006990740000000
      Enabled = False
      TabOrder = 1
    end
    object dtpHoraAplicacion: TDateTimePicker
      Left = 239
      Top = 113
      Width = 122
      Height = 21
      Date = 40091.000000000000000000
      Time = 40091.000000000000000000
      Enabled = False
      Kind = dtkTime
      TabOrder = 2
    end
    object ActionMainMenuBar1: TActionMainMenuBar
      Left = 2
      Top = 2
      Width = 870
      Height = 23
      UseSystemFont = False
      ActionManager = ActionManager1
      Caption = 'ActionMainMenuBar1'
      ColorMap.HighlightColor = clWhite
      ColorMap.BtnSelectedColor = clBtnFace
      ColorMap.UnusedColor = clWhite
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Spacing = 0
    end
    object cbFechaHora: TCheckBox
      Left = 129
      Top = 136
      Width = 235
      Height = 41
      Caption = 
        'Se ignorar'#225' la fecha y hora de aplicacion. Se mostrar'#225' la Cronol' +
        'ogicamente mayor.'
      Checked = True
      State = cbChecked
      TabOrder = 5
      WordWrap = True
      OnClick = cbFechaHoraClick
    end
    object dtpAldia: TDateTimePicker
      Left = 102
      Top = 74
      Width = 129
      Height = 21
      Date = 40091.510006990740000000
      Time = 40091.510006990740000000
      Enabled = False
      TabOrder = 6
    end
    object dtpAlaHora: TDateTimePicker
      Left = 238
      Top = 74
      Width = 122
      Height = 21
      Date = 40091.000000000000000000
      Time = 40091.000000000000000000
      Enabled = False
      Kind = dtkTime
      TabOrder = 7
    end
    object sagPasos: TStringAlignGrid
      Left = 14
      Top = 171
      Width = 356
      Height = 296
      ColCount = 2
      DefaultRowHeight = 18
      FixedCols = 0
      RowCount = 2
      TabOrder = 8
      OnSelectCell = sagTramosRutaDesdeOrigenSelectCell
      ColWidths = (
        150
        128)
      Cells = (
        0
        0
        #21071#18249#20037#0#47152#6860
        1
        0
        #17732#21587#20041'O'#47152#6860#49972)
      PropCell = ()
      PropCol = ()
      PropRow = ()
      PropFixedCol = ()
      PropFixedRow = ()
    end
    object progreso: TProgressBar
      Left = 13
      Top = 471
      Width = 360
      Height = 17
      TabOrder = 9
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action1
              end>
            Caption = '&Archivo'
          end
          item
            Items = <
              item
                Action = act143
                Caption = '&Buscar'
                ShortCut = 16450
              end>
            Caption = '&Tarifas'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 440
    Top = 112
    StyleName = 'XP Style'
    object Action1: TAction
      Category = '&Archivo'
      Caption = '&Salir'
      OnExecute = Action1Execute
    end
    object act143: TAction
      Tag = 143
      Category = '&Tarifas'
      Caption = 'Buscar'
      ShortCut = 16450
      OnExecute = act143Execute
    end
  end
  object ImageList1: TImageList
    Left = 440
    Top = 176
    Bitmap = {
      494C0101040005000C0010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B5DEBE005B916C0054996C005999
      6B0059996B004F9A6C0056996C0056996C0056996C0056996C0056996C005699
      6C005696680052946A005F947300C0E0C800FEFEFE00FFFFFF00FCFCFC00F2F2
      F200D2D2D200E9E9E900F8F8F800FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AAA3FF004E40DE003E1DF4004421
      FE004623FF003F23EB005136FC00462EEA003F31D6004637D900503EEF004629
      FA004C39EC004636DB006D60F100C3C0FF00FFF7FC00FFF9FF00FFEEF600FFF6
      F900FFFCF900FFFFF700FFFFF400FFFFF300FFFFF200FFFFF300FFFFF500FFFF
      F500FFEDEB00FFFBF800FFFDFB00FFFCF800479560008ADFAD008CDDB00093D6
      AF0096DCB4007ED5A9008ED9AB008ED9AB008ED9AB008ED9AB008ED9AB008ED9
      AB0091D9AB008ADAAB0090D8AD00679D7800FFFFFF00FFFFFF00F8F8F800E1E1
      E1005151510088888800E8E8E800FDFDFD00FFFFFF00FFFFFF00FFFFFF00FDFD
      FD00FEFEFE00FEFEFE00FFFFFF00FFFFFF00664FFF00270DD7002300E9002602
      E9002100DE002100DA002500E5002200E2001F01D0002004C9002A0DD4002000
      D6001F08C8002412C9003622D2007E71FF00FFF9FF00C59BA200AD6D73009654
      590079504E0070564F006E5A4F00625144006E5E5100604F4200432F24006849
      4000703B38005F2C2A0070555100FFF4F100469E62007FD7A10080C9A3009FD5
      B80097CDAF0086D1AB0080D1A20080D1A20081D1A20081D1A20080D1A20081D1
      A20085D0A4007CD1A4007ED2A20060A37600FEFEFE00FFFFFF00FAFAFA00ECEC
      EC00060606005D5D5D0091919100EDEDED00F7F7F700FFFFFF00FAFAFA00FFFF
      FF00FEFEFE00FDFDFD00FFFFFF00FFFFFF002009D7001A08CD003934CD006F73
      E9006871D9006B62F2002E14D6002100DA002200D000412DD3006D62E8006967
      DE00776FFF004237E7002714CF004938E000FFF8FF008E5A6100E697A000DF8F
      94006E35340076494500D4AAA300DAB3AA00E1BEB100E3C0B300845D54008151
      4B00944E4E00793738005E373500FFFDF900469A59007DC8940095C2A700ECFE
      F100F3FFF700A1CAAE0070C6960070C6960070C6960070C6960070C6960070C6
      960075C499006BC796006BC9920057A77200FDFDFD00FFFFFF00FCFCFC00F8F8
      F800DCDCDC0000000000505050009D9D9D00FFFFFF00FEFEFE00FFFFFF00FDFD
      FD00FEFEFE00FFFFFF00FFFFFF00FFFFFF002210E7001C0CD500514DD500C4C9
      FF00DEE9FF00DBDDFF005A47DC002F12CD003115CC00877EF700DEE2FF00E0E4
      FF00C3BDFF005245FF001A08C7004735E600FFF8FE00BB818600F8A3AB00D985
      8A00BB7D7D007B4B4500673C3300A47B7200FFE7DB00FFF2E600956A61006A34
      2D0083383600974D4D006D3D3B00FFFCF800469760006ABE84006FBF8A00D8FF
      E900D2E8DC00F2E6F20084CAA2005BB37E005EC588005FBE8B0068C195005FC1
      8B0065C28B0057BF82005CC684004FA56900FDFDFD00FEFEFE00FEFEFE00FFFF
      FF00E0E0E000CBCBCB00010101005F5F5F00D1D1D100EEEEEE00F9F9F900F5F5
      F500F9F9F900FCFCFC00FFFFFF00FFFFFF001100F2001602E7002109AF006650
      CE00F2E3FF00F1F3FF00BFB4FF00321DA8004432C500C5CBFF00EAFAFF00EAE9
      FF003C2FD900220DE6001804CF004230EF00FFF5F900B1767A00E3909800CE7F
      8200D29D9A007A564E00220600004D332700E8CEC000EBD0C2009C7C6F009061
      590088413E00853B3900622F2C00FFFCF70044985E0061B97D005EB87D0069AB
      8100E0FFF000F6FFFC00E2FFED0082B494006BB3850077BA930074B0910067AE
      830064B584005ABB820055BB7A004EA46800FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00E3E3E300B2B2B200000000007A7A7A00C4C4C400B0B0B000AEAE
      AE00D1D1D100F4F4F400FBFBFB00FFFFFF002011EE000B00D4002107D6001900
      BB00351BBB00F1E7FF00F3EBFF00D7D0FF00E2E1FF00ECF5FF00EAF1FF003727
      BA001E0AD5001200DE001C08D6004431F200FFFAFB009F6B6B00FFB8BD00FFBD
      C100BC7F7D0093615B0086574F0081534B008A5D520093665B008B5D5200A36A
      61009E514E00924846006F413A00FFFDF400419D62004EAF71004AB370003B9A
      5D006EC18A00B0F0C600FFFDFF00F4FFF700DBFFE600B0E3BE00AEDDBC00D8FF
      E700A9EABD0053A672004EAD70004CA06600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00F8F8F800FFFFFF00E3E3E300BDBDBD009393930059595900949494007979
      79006D6D6D00ADADAD00F3F3F300FEFEFE002515E5000E00D0001B08E1001000
      CE002A13D300E1D4FF00F3EBFF00F2F0FF00F4F9FF00EAEEFF00D8D6FF001F0A
      C5001903D8001300DB001F0CD5004331F000FFF6F100AF898500F7AAAD00FFAD
      B100EC969600EA929200E07E7E00F18B8C00DE7A7A00D2727200B7605C00A551
      4C00AA514D00A35A560078554B00FFFBEE003C955D0040A064003CA664003FA9
      66003BA25F0042A26200F2FFFA00B5E7C500469C60004AA566004DA46A0049A7
      660097D6AA0089D2A4004BA26A004D9C6300FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00F2F2F200FFFFFF00E5E5E5009B9B9B0080808000D2D2D200E6E6
      E600B2B2B20088888800C1C1C100FDFDFD002811E5001602D7001104E2001304
      E2002417E5007F71F400ECE3FF00F7F6FF00F9FEFF00ECEBFF00ACA1FF001C04
      DA001D04E2001600DB001E0BD2004130EC00FFFEF700B9949000FFBBBB00FFB7
      BA00B7646600B4626100B45A5A00A5484700A54748009A403F0092413E009241
      3C00B35C58009B554E00714E4400FFFFF400469A640063BC84004BAB6F0045AA
      6C0049AD6C0040A16100E2FFF30061A679003EAA61003DAE640040A966003FA9
      620055956B00C9FFE50054A872004F9B6500FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FAFAFA00EEEEEE00D5D5D500E9E9E900B9B9B900EBEB
      EB00DEDEDE00C8C8C80072727200EBEBEB00250EE6001A05DE000F00E0001304
      E1000800C3003E36A800CAC7FE00FAFCFF00F9FEFD00DEDBFF004F41AB002708
      DF002106E5001800DB001D0AD3004332EE00FFFBF500C4979300F7B1B200AF69
      6A00FFFBF800FFFDF700FFEDE600FFF1E700FFE6DF00F3D8CE00E8C9C000EFC1
      B9007D393400A6625D007B4E4300FFFDF000519D6D007AC998007BCC9D007BD0
      9E0068C08A0064BB8300CFF3E2005DA178004EBA72004CB7720050AF760057B2
      7A006AA78100CDFFEA0057A97500539B6600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FBFBFB00E6E6E600CFCFCF00DFDFDF00BEBEBE00E2E2
      E200ECECEC00D1D1D10093939300DADADA002111E0001301D6001B03E5002207
      E600250DCF009E9AF300EFF2FF00F4FCFF00F6FDFF00ECEEFF00887CD4002903
      D1002203E0001500DA001F09D4004732F200FFFBF700D39E9B00FFC0C200B775
      7600FFFDF800FFFFF800FBFAF000F9FFF400E7EBE000E9E7DC00E1D5CB00ECC8
      C0007A373400B26864008C554E00FFFDF2004B95610087D29F0089D3A90082D1
      A60085D5AA0083D7A700E8FFEE0088B89C0062B68C0059BD8D0052BB82005DBD
      81006CA98300D3FFEB0066B3870051A07400FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FDFDFD00EFEFEF00ABABAB00EFEFEF00BDBDBD00D6D6
      D600EAEAEA00D4D4D400A4A4A400EBEBEB001E19D8000E04CC001B00DD002400
      DE00320CCA00E7E7FF00ECF6FF00EDFBFF00E9F5FF00E7EFFF00F3EDFF003206
      C5002705DF002005E8001A03D1004D38F900FFEFEE00D8969700FFBEC300C174
      7800FFFAF900FFF9F400FFFFF900FFFFF900FFF9F200FFFCF600FAE2DC00FFD8
      D40093434200C7706E009D565200FFF5EF004D9664008DD5A70090D7AF008ED4
      AF008FD6AE008AD4AA00EAFFF500C1E8D200A7E3C50080C8A40079C79E0070BD
      91008DBF9F00C1F8D7007BC3990054A17500FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FEFEFE00FEFEFE00FFFFFF00FBFBFB00C3C3C300AAAAAA00ECECEC00C1C1
      C100F5F5F500CBCBCB00D1D1D100FCFCFC000908CE001209D5002900D3003E0C
      D6008961FD00F1F3FF00E8EDFF008586E0005D5CC400E4ECFF00F1F3FF009F79
      FF002404CD001500D900250DD7004730F000FFF8F800E9A6A900FFC5CA00CA7D
      8400FFFAFB00FFF2F100FFFCF900F6F7F300F7F6F200FFFAF500F5E1DC00FFE3
      E000A0505100C66E6E00A3595700FFF7F20052966D0097DAB3009DDCBC00A1DD
      BF009ED9BA00A5DCBB00BEDFD000EAFFF800D8ECDF00E4FAEE00C5E6D800C4F1
      E100E6FFF500ABD6BB009DDCB5005CA27900FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FEFEFE00F6F6F600C4C4C40084848400C4C4
      C400E6E6E600D4D4D400FFFFFF00FFFFFF00241DF0000E01D100300ED100764C
      FF00E5C4FF00E4E3FF00D2CEFF00362CB5001C10A6008F93E200EDECFF00EBCB
      FF007055FF00220AE200200ACE004934EE00FFF9F900DDA4A500FFB8BE00C286
      8C00FFFCFE00FBFFFE00EFFFFF00E8FFFF00EAFFFE00F1FFFE00F5F6F200FFED
      EB00945253009A4C4D008C4C4800FFF5F00055976E00AFEDC900A3DDC000ADE2
      C700AFE2C600B1E3C500AEDBC800B8DAC900D9EBDE00F6FFF900E9FFF500BEE2
      D600C1E5D400ACD9BE00ACE4C10066A37D00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FEFEFE00FAFAFA00EAEAEA00F6F6
      F600F1F1F100FFFFFF00FFFFFF00FFFFFF001907E6001705DC00402AE000967E
      FF00E0CDFF00CBC5FF007664FF00270DCB002409CB005E55D400B3AFFF00D9C6
      FF00A28BFF004B35FF002A17D2004837E600FFFDF900DBB5B500F8BEC300D39F
      A600FFF1F400FAF9FB00F8FFFF00E8F6F500EDF9F900F6FCFB00F9F5F400FCE3
      E1009A6061008F4D4E0095666200FFFDF5004F8D6500A9E6C000AAE3C400B3EB
      CE00B3ECCD00B3ECCB00AFE6CB00B3E6CB00BDE5CC00BDE1C900BCE3CD00B7E5
      CE00B2E2C800B9EECD00B4ECC900699F7C00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FAFAFA00FCFCFC00FBFBFB00FDFD
      FD00FFFFFF00FFFFFF00FFFFFF00FFFFFF00371DE5002E1ADE001B18CC001A1A
      D2000000BF00230AE6001500D7001C00D9002905D300260CCE003626E500160C
      D5002210D900220FD0001B0EB8004F41DF00F1F5EF00CBC0BC00EABFC200D8A4
      AB00DEB8BE00D4B3BA00CDA8B200C8A3AD00BD95A000BE979F00C8A3A700CEA1
      A400AD727600A87573009F8C8400F5F1E60094CFA30067A0790087C3A10080BC
      9D007EBE9B007CBF9A0076BC940076BD950070BC920078C5990077BF910079BA
      8D0073B991007DC1980067A27C00A3D2B200FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FCFCFC00FDFDFD00FCFCFC00FDFDFD00F6F6
      F600FFFFFF00FFFFFF00FFFFFF00FFFFFF00987EFF003A27E2001316CC000E13
      D4001C1DF1001600F4002400F3004015FF00320DD9003216E5001703D800160C
      E8001F0EDB002312CE005B4FF500B2A6FF00EFFFFB00F3F5EF00FFFAFE00FFF7
      FE00FFF3FC00FFF5FF00FFEEFD00FFF3FF00FFF3FF00FFEAF500FFEDF600FFF1
      F600FFF7FB00FFFBF800FCF5EC00F8FFF700424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
