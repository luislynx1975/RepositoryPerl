object frm_bars: Tfrm_bars
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Escanea codigo de barras'
  ClientHeight = 201
  ClientWidth = 447
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poMainFormCenter
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 43
    Width = 436
    Height = 21
    Caption = 'Escane'#233' el codigo de barras para generar la corrida'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_mensaje: TLabel
    Left = 13
    Top = 144
    Width = 4
    Height = 16
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object mem_bars: TMemo
    Left = 80
    Top = 70
    Width = 273
    Height = 57
    TabOrder = 0
    OnKeyDown = mem_barsKeyDown
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 447
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
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = '&Guardar'
            ImageIndex = 17
          end
          item
            Action = Action2
            Caption = '&Salir'
            ImageIndex = 15
          end>
        ActionBar = ActionToolBar1
      end>
    Images = DM.img_iconos
    Left = 384
    Top = 96
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = 'Guardar'
      ImageIndex = 17
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Caption = 'Salir'
      ImageIndex = 15
      OnExecute = Action2Execute
    end
  end
end
