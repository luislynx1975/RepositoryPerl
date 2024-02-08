object frm_folio_registro: Tfrm_folio_registro
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Registro de folios '
  ClientHeight = 528
  ClientWidth = 288
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 13
  object stg_folio: TStringGrid
    Left = 0
    Top = 176
    Width = 288
    Height = 352
    Align = alBottom
    ColCount = 1
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PopupMenu = ppMenu
    TabOrder = 1
    ExplicitTop = 186
    ExplicitWidth = 298
    ColWidths = (
      277)
  end
  object pnl_datos: TPanel
    Left = 0
    Top = 0
    Width = 288
    Height = 185
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 0
    ExplicitWidth = 298
    object Label1: TLabel
      Left = 20
      Top = 88
      Width = 82
      Height = 13
      Caption = 'N'#250'mero de folio :'
    end
    object Label2: TLabel
      Left = 20
      Top = 115
      Width = 82
      Height = 13
      Caption = 'N'#250'mero de folio :'
    end
    object Label3: TLabel
      Left = 8
      Top = 26
      Width = 31
      Height = 13
      Caption = 'Label3'
    end
    object lbl_folio: TLabel
      Left = 221
      Top = 88
      Width = 4
      Height = 13
      Caption = '.'
    end
    object lbl_nota: TLabel
      Left = 220
      Top = 69
      Width = 3
      Height = 13
    end
    object Button1: TButton
      Left = 86
      Top = 139
      Width = 75
      Height = 25
      Action = ac_guardar
      TabOrder = 2
    end
    object ned_folio_inicial: TEdit
      Left = 116
      Top = 85
      Width = 98
      Height = 21
      TabOrder = 0
      OnKeyPress = ned_folio_inicialKeyPress
    end
    object ned_folio_final: TEdit
      Left = 116
      Top = 112
      Width = 98
      Height = 21
      TabOrder = 1
    end
    object Button2: TButton
      Left = 167
      Top = 139
      Width = 75
      Height = 25
      Action = acsalir
      TabOrder = 3
    end
  end
  object ActionManager1: TActionManager
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 48
    Top = 8
    StyleName = 'Platform Default'
    object ac_guardar: TAction
      Caption = 'Guardar'
      ImageIndex = 17
      OnExecute = ac_guardarExecute
    end
    object acsalir: TAction
      Caption = 'Salir'
      ImageIndex = 15
      Visible = False
      OnExecute = acsalirExecute
    end
    object acEliminarFolio: TAction
      Caption = 'Elimina Folio'
      ImageIndex = 5
      OnExecute = acEliminarFolioExecute
    end
  end
  object ppMenu: TPopupMenu
    Left = 144
    Top = 272
    object EliminaFolio1: TMenuItem
      Action = acEliminarFolio
    end
  end
end
