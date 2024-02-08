object frmCRutasII: TfrmCRutasII
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Cat'#225'logo de Rutas'
  ClientHeight = 354
  ClientWidth = 281
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
    Width = 281
    Height = 300
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    BorderStyle = bsSingle
    TabOrder = 0
    object Paginas: TPageControl
      Left = 1
      Top = 1
      Width = 275
      Height = 294
      ActivePage = TabSheet1
      Align = alClient
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Ruta'
        object Label1: TLabel
          Left = 24
          Top = 16
          Width = 106
          Height = 13
          Caption = 'Identificador de Ruta:'
        end
        object Label2: TLabel
          Left = 24
          Top = 45
          Width = 77
          Height = 13
          Caption = 'Origen de Ruta:'
        end
        object Label3: TLabel
          Left = 24
          Top = 78
          Width = 81
          Height = 13
          Caption = 'Destino de Ruta:'
        end
        object lblRuta: TLabel
          Left = 24
          Top = 165
          Width = 231
          Height = 42
          Alignment = taCenter
          AutoSize = False
          Caption = 'R U T A'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -29
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
        end
        object Label5: TLabel
          Left = 24
          Top = 115
          Width = 23
          Height = 13
          Caption = 'Kms:'
        end
        object Label6: TLabel
          Left = 152
          Top = 116
          Width = 25
          Height = 13
          Caption = 'Mins:'
        end
        object edtIdRuta: TEdit
          Left = 136
          Top = 13
          Width = 119
          Height = 21
          CharCase = ecUpperCase
          Enabled = False
          NumbersOnly = True
          TabOrder = 0
          OnKeyPress = edtIdRutaKeyPress
        end
        object cbOrigen: TlsComboBox
          Left = 110
          Top = 45
          Width = 145
          Height = 21
          AutoComplete = False
          CharCase = ecUpperCase
          TabOrder = 1
          Text = 'CBORIGEN'
          OnExit = cbOrigenExit
          OnKeyPress = cbOrigenKeyPress
          Complete = True
          ForceIndexOnExit = True
          MinLengthComplete = 0
        end
        object cbDestino: TlsComboBox
          Left = 110
          Top = 77
          Width = 145
          Height = 21
          AutoComplete = False
          CharCase = ecUpperCase
          TabOrder = 2
          Text = 'CBDESTINO'
          OnExit = cbDestinoExit
          OnKeyPress = cbOrigenKeyPress
          Complete = True
          ForceIndexOnExit = True
          MinLengthComplete = 0
        end
        object edKilometros: TEdit
          Left = 67
          Top = 112
          Width = 71
          Height = 21
          TabOrder = 3
          OnKeyPress = cbOrigenKeyPress
        end
        object edMinutos: TEdit
          Left = 183
          Top = 112
          Width = 71
          Height = 21
          BiDiMode = bdLeftToRight
          ParentBiDiMode = False
          TabOrder = 4
          OnKeyPress = edMinutosKeyPress
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Tramos'
        ImageIndex = 1
        object Label4: TLabel
          Left = 184
          Top = 5
          Width = 61
          Height = 13
          Caption = 'Con destino:'
        end
        object lblOrigenTramo: TLabel
          Left = 11
          Top = 6
          Width = 3
          Height = 13
        end
        object Button1: TButton
          Left = 189
          Top = 114
          Width = 75
          Height = 25
          Caption = 'Limpiar Tramos'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          WordWrap = True
          OnClick = Button1Click
        end
        object cbTramos: TlsComboBox
          Left = 11
          Top = 25
          Width = 234
          Height = 21
          AutoComplete = False
          TabOrder = 1
          OnKeyPress = cbOrigenKeyPress
          Complete = True
          ForceIndexOnExit = True
          MinLengthComplete = 0
        end
        object btnAgregar: TButton
          Left = 189
          Top = 52
          Width = 75
          Height = 25
          Caption = 'Agregar Tramo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          OnClick = btnAgregarClick
        end
        object btnCatalogoTramos: TButton
          Left = 189
          Top = 83
          Width = 75
          Height = 25
          Caption = 'Insertar Tramo'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -9
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 3
          OnClick = btnCatalogoTramosClick
        end
        object sagTramos: TStringGrid
          Left = 7
          Top = 52
          Width = 176
          Height = 208
          ColCount = 3
          DefaultRowHeight = 18
          FixedCols = 0
          RowCount = 2
          TabOrder = 4
          OnDblClick = sagTramosDblClick
          ColWidths = (
            53
            44
            64)
        end
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 300
    Width = 281
    Height = 54
    Align = alClient
    TabOrder = 1
    object ActionMainMenuBar1: TActionMainMenuBar
      Left = 1
      Top = 1
      Width = 279
      Height = 30
      UseSystemFont = False
      ActionManager = AM1
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
  end
  object AM1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = actBuscar
            Caption = '&Buscar'
          end
          item
            Action = actGuardar
          end
          item
            Action = actLimpiar
            Caption = '&Limpiar'
          end
          item
            Action = actSalir
            Caption = '&Salir'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Left = 231
    Top = 263
    StyleName = 'Platform Default'
    object actSalir: TAction
      Caption = 'Salir'
      OnExecute = actSalirExecute
    end
    object actLimpiar: TAction
      Caption = 'Limpiar'
      OnExecute = actLimpiarExecute
    end
    object actGuardar: TAction
      Caption = 'Guardar'
      OnExecute = actGuardarExecute
    end
    object actBuscar: TAction
      Caption = 'Buscar'
      OnExecute = actBuscarExecute
    end
  end
end
