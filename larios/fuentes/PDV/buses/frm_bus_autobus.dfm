object Frm_autobus: TFrm_autobus
  Left = 110
  Top = 208
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Distribucion de asientos en el autobus'
  ClientHeight = 461
  ClientWidth = 968
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 968
    Height = 321
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 978
  end
  object DrawGrid1: TStringGrid
    Left = 768
    Top = 336
    Width = 41
    Height = 46
    ColCount = 4
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    TabOrder = 0
    Visible = False
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 321
    Width = 968
    Height = 27
    UseSystemFont = False
    ActionManager = ActionManager1
    Caption = 'ActionMainMenuBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 7171437
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Spacing = 0
  end
  object lsStatusBar1: TlsStatusBar
    Left = 0
    Top = 442
    Width = 968
    Height = 19
    Panels = <>
    ExplicitTop = 452
    ExplicitWidth = 978
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 348
    Width = 968
    Height = 105
    Align = alTop
    Caption = 'Distribucion de asientos para el autobus'
    TabOrder = 4
    ExplicitLeft = 328
    ExplicitTop = 341
    ExplicitWidth = 361
    object Label1: TLabel
      Left = 296
      Top = 24
      Width = 486
      Height = 13
      Caption = 
        'Distribucion fisica de los asientos dentro del autobus, interfaz' +
        ' para el uso del departamento de Sistemas'
    end
    object Label2: TLabel
      Left = 296
      Top = 38
      Width = 534
      Height = 13
      Caption = 
        'Seleccione la imagen que se muestra en el combo box  y se visual' +
        'izara la imagen de autobus  en la parte superior'
    end
    object Label3: TLabel
      Left = 296
      Top = 50
      Width = 575
      Height = 13
      Caption = 
        'haga click en la sobre la imagen y aparecera una etiqueta con un' +
        ' numero en la imagen, seleccione la imagen ahora podra'
    end
    object Label4: TLabel
      Left = 296
      Top = 64
      Width = 285
      Height = 13
      Caption = 'distribuirlo en la imagen y es como se  visualizara en la venta'
    end
    object Label5: TLabel
      Left = 19
      Top = 83
      Width = 312
      Height = 20
      Caption = 'Uso exclusivo para el area de sistemas'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object GroupBox1: TGroupBox
      Left = 3
      Top = 16
      Width = 265
      Height = 57
      Caption = 'Autobus'
      TabOrder = 0
      object lsCombo_bus: TlsComboBox
        Left = 16
        Top = 24
        Width = 201
        Height = 21
        TabOrder = 0
        OnClick = lsCombo_busClick
        Complete = True
        ForceIndexOnExit = True
        MinLengthComplete = 0
      end
    end
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = ac109
            Caption = '&Modificar'
            ImageIndex = 22
            ShortCut = 16449
          end
          item
            Action = ac99
            Caption = '&Salir'
            ImageIndex = 15
            ShortCut = 16467
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 480
    Top = 232
    StyleName = 'Platform Default'
    object ac109: TAction
      Tag = 109
      Category = 'Sistema'
      Caption = 'Modificar'
      Hint = 'Actualiza la distribucion de asientos en el autobus'
      ImageIndex = 22
      ShortCut = 16449
      OnExecute = ac109Execute
    end
    object ac99: TAction
      Tag = 99
      Category = 'Sistema'
      Caption = 'Salir'
      Hint = 'Cerrar pantalla de autobuses'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = ac99Execute
    end
  end
end
