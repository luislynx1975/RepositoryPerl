object Frm_ocupante: TFrm_ocupante
  Left = 460
  Top = 243
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Registro de Ocupantes'
  ClientHeight = 368
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 73
    Top = 67
    Width = 62
    Height = 13
    Caption = 'Descripcion :'
  end
  object Label2: TLabel
    Left = 75
    Top = 94
    Width = 60
    Height = 13
    Caption = 'Fecha Baja :'
  end
  object Label3: TLabel
    Left = 73
    Top = 120
    Width = 62
    Height = 13
    Caption = 'Abreviacion :'
  end
  object Descuento: TLabel
    Left = 82
    Top = 148
    Width = 52
    Height = 13
    Caption = 'Descuento'
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 475
    Height = 40
    AutoSize = True
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 36
        Width = 483
      end>
    ExplicitWidth = 485
    object ToolBar1: TToolBar
      Left = 11
      Top = 0
      Width = 470
      Height = 36
      AutoSize = True
      ButtonHeight = 36
      ButtonWidth = 50
      Caption = 'ToolBar1'
      Images = DM.img_iconos
      ShowCaptions = True
      TabOrder = 0
      object Tbtn_nuevo: TToolButton
        Left = 0
        Top = 0
        Action = ac121
      end
      object Tbtn_guardar: TToolButton
        Left = 50
        Top = 0
        Action = ac121a
        Enabled = False
      end
      object Tbtn_update: TToolButton
        Left = 100
        Top = 0
        Action = ac122
        Enabled = False
      end
      object ToolButton5: TToolButton
        Left = 150
        Top = 0
        Action = ac99
      end
    end
  end
  object Ed_descrip: TEdit
    Left = 136
    Top = 64
    Width = 121
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 1
  end
  object Ed_abrevia: TEdit
    Left = 136
    Top = 116
    Width = 121
    Height = 21
    CharCase = ecUpperCase
    TabOrder = 3
    OnChange = Ed_abreviaChange
  end
  object Panel1: TPanel
    Left = 0
    Top = 166
    Width = 475
    Height = 202
    Align = alBottom
    TabOrder = 5
    ExplicitTop = 176
    ExplicitWidth = 485
    object stg_ocupantes: TStringGrid
      Left = 1
      Top = 1
      Width = 483
      Height = 200
      Align = alClient
      FixedCols = 0
      RowCount = 2
      TabOrder = 0
      OnSelectCell = stg_ocupantesSelectCell
      ColWidths = (
        77
        172
        76
        64
        64)
    end
  end
  object Dt_picker: TDateTimePicker
    Left = 136
    Top = 90
    Width = 186
    Height = 21
    Date = 40100.000000000000000000
    Time = 0.704858912038616800
    TabOrder = 2
  end
  object ed_descuento: TEdit
    Left = 136
    Top = 144
    Width = 121
    Height = 21
    TabOrder = 4
    OnChange = ed_descuentoChange
  end
  object ActionList1: TActionList
    Images = DM.img_iconos
    Left = 312
    Top = 8
    object ac121: TAction
      Tag = 121
      Caption = 'Nuevo'
      ImageIndex = 16
      OnExecute = ac121Execute
    end
    object ac121a: TAction
      Tag = 99
      Caption = 'Guardar'
      ImageIndex = 17
      OnExecute = ac121aExecute
    end
    object ac122: TAction
      Tag = 122
      Caption = 'Modificar'
      ImageIndex = 22
      OnExecute = ac122Execute
    end
    object ac123: TAction
      Tag = 123
      Caption = 'Borrar'
      ImageIndex = 34
      OnExecute = ac123Execute
    end
    object ac99: TAction
      Tag = 99
      Caption = 'Salir'
      ImageIndex = 15
      OnExecute = ac99Execute
    end
  end
end
