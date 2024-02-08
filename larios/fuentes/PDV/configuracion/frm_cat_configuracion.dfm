object frm_cat_config: Tfrm_cat_config
  Left = 420
  Top = 307
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Pantalla para la configuracion de parametros'
  ClientHeight = 306
  ClientWidth = 446
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 13
  object Label1: TLabel
    Left = 32
    Top = 56
    Width = 62
    Height = 13
    Caption = 'Descripcion :'
  end
  object Label2: TLabel
    Left = 56
    Top = 80
    Width = 30
    Height = 13
    Caption = 'Valor :'
  end
  object ed_descrip: TEdit
    Left = 104
    Top = 56
    Width = 217
    Height = 21
    TabOrder = 0
  end
  object ed_valor: TEdit
    Left = 104
    Top = 80
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 114
    Width = 446
    Height = 192
    Align = alBottom
    Caption = 'Parametros existentes'
    TabOrder = 2
    ExplicitTop = 106
    ExplicitWidth = 444
    object stg_config: TStringGrid
      Left = 2
      Top = 40
      Width = 446
      Height = 150
      Align = alBottom
      ColCount = 3
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      OnSelectCell = stg_configSelectCell
      ExplicitWidth = 440
      ColWidths = (
        64
        264
        68)
    end
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 446
    Height = 40
    AutoSize = True
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 36
        Width = 448
      end>
    ExplicitWidth = 444
    object ToolBar1: TToolBar
      Left = 11
      Top = 0
      Width = 435
      Height = 36
      AutoSize = True
      ButtonHeight = 36
      ButtonWidth = 53
      Caption = 'ToolBar1'
      Images = DM.img_iconos
      ShowCaptions = True
      TabOrder = 0
      object tbnt_update: TToolButton
        Left = 0
        Top = 0
        Action = ac114
      end
      object ToolButton5: TToolButton
        Left = 59
        Top = 0
        Action = ac99
      end
    end
  end
  object ActionList1: TActionList
    Images = DM.img_iconos
    Left = 288
    Top = 128
    object ac99: TAction
      Tag = 99
      Caption = 'Salir'
      Hint = 'Salir'
      ImageIndex = 15
      OnExecute = ac99Execute
    end
    object ac113: TAction
      Tag = 113
      Caption = 'Nuevo'
      ImageIndex = 16
      OnExecute = ac113Execute
    end
    object ac113a: TAction
      Tag = 113
      Caption = 'Guardar'
      Hint = 'Guardar'
      ImageIndex = 17
      OnExecute = ac113aExecute
    end
    object ac114: TAction
      Tag = 114
      Caption = 'Actualizar'
      ImageIndex = 22
      OnExecute = ac114Execute
    end
    object ac115: TAction
      Tag = 115
      Caption = 'Eliminar'
      ImageIndex = 52
      OnExecute = ac115Execute
    end
  end
end
