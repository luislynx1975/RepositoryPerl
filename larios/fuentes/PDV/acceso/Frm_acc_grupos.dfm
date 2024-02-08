object Frm_grupos: TFrm_grupos
  Left = 413
  Top = 243
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Registro de grupos'
  ClientHeight = 321
  ClientWidth = 337
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 40
    Width = 337
    Height = 113
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 347
    object Label1: TLabel
      Left = 35
      Top = 36
      Width = 62
      Height = 13
      Caption = 'Descripcion :'
    end
    object Label2: TLabel
      Left = 24
      Top = 67
      Width = 75
      Height = 13
      Caption = 'Fecha de Baja :'
      Visible = False
    end
    object lb_cve: TLabel
      Left = 90
      Top = 8
      Width = 3
      Height = 13
      Caption = '.'
    end
    object ed_descripcion: TEdit
      Left = 102
      Top = 32
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object Dtp_fecha: TDateTimePicker
      Left = 103
      Top = 61
      Width = 113
      Height = 21
      Date = 40077.000000000000000000
      Format = 'yyyy/MM/dd'
      Time = 0.486079201400571000
      TabOrder = 1
      Visible = False
    end
  end
  object CoolBar1: TCoolBar
    Left = 0
    Top = 0
    Width = 337
    Height = 40
    AutoSize = True
    Bands = <
      item
        Control = ToolBar1
        ImageIndex = -1
        MinHeight = 36
        Width = 345
      end>
    ShowText = False
    ExplicitWidth = 347
    object ToolBar1: TToolBar
      Left = 11
      Top = 0
      Width = 332
      Height = 36
      AutoSize = True
      ButtonHeight = 36
      ButtonWidth = 53
      Caption = 'ToolBar1'
      Images = DM.img_iconos
      ShowCaptions = True
      TabOrder = 0
      object Tbtn_nuevo: TToolButton
        Left = 0
        Top = 0
        Action = ac101
      end
      object Tbtn_guardar: TToolButton
        Left = 53
        Top = 0
        Action = ac101a
        Enabled = False
      end
      object Tbtn_update: TToolButton
        Left = 106
        Top = 0
        Action = ac102
        Enabled = False
      end
      object tbtn_baja: TToolButton
        Left = 159
        Top = 0
        Action = ac151
        Enabled = False
      end
      object ToolButton4: TToolButton
        Left = 212
        Top = 0
        Action = ac99
      end
    end
  end
  object Stg_grupos: TStringGrid
    Left = 0
    Top = 153
    Width = 337
    Height = 172
    Align = alTop
    ColCount = 2
    FixedCols = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ParentFont = False
    TabOrder = 2
    OnSelectCell = Stg_gruposSelectCell
    ExplicitWidth = 347
    ColWidths = (
      64
      236)
  end
  object ActionList1: TActionList
    Images = DM.img_iconos
    Left = 280
    Top = 80
    object ac101: TAction
      Tag = 101
      Caption = 'Nuevo'
      Hint = 'Nuevo'
      ImageIndex = 16
      OnExecute = ac101Execute
    end
    object ac101a: TAction
      Tag = 101
      Caption = 'Guardar'
      Hint = 'Guardar'
      ImageIndex = 17
      OnExecute = ac101aExecute
    end
    object ac102: TAction
      Tag = 102
      Caption = 'Actualizar'
      Hint = 'Actualiza'
      ImageIndex = 22
      OnExecute = ac102Execute
    end
    object ac99: TAction
      Tag = 99
      Caption = 'Salir'
      Hint = 'Cerrar'
      ImageIndex = 18
      OnExecute = ac99Execute
    end
    object ac151: TAction
      Caption = 'Baja'
      ImageIndex = 15
      OnExecute = ac151Execute
    end
  end
end
