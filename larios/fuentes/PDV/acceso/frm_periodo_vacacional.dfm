object frm_vacacional: Tfrm_vacacional
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Registro del periodo vacacional'
  ClientHeight = 171
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 13
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 394
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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 27
    Width = 394
    Height = 125
    Align = alClient
    TabOrder = 1
    ExplicitTop = 25
    ExplicitWidth = 404
    ExplicitHeight = 137
    object Label1: TLabel
      Left = 32
      Top = 22
      Width = 32
      Height = 13
      Caption = 'Inicio :'
    end
    object Label2: TLabel
      Left = 41
      Top = 48
      Width = 21
      Height = 13
      Caption = 'Fin :'
    end
    object dtp_inicio: TDateTimePicker
      Left = 70
      Top = 19
      Width = 136
      Height = 21
      BiDiMode = bdRightToLeft
      CalAlignment = dtaRight
      Date = 40382.000000000000000000
      Time = 0.582971875002840500
      ParentBiDiMode = False
      TabOrder = 0
    end
    object dtp_fin: TDateTimePicker
      Left = 70
      Top = 46
      Width = 136
      Height = 21
      Date = 40382.000000000000000000
      Time = 0.583194629631179900
      TabOrder = 1
    end
    object dtp_hora_inicio: TDateTimePicker
      Left = 212
      Top = 19
      Width = 69
      Height = 21
      Date = 40382.000000000000000000
      Format = 'HH:mm'
      Time = 0.603540821757633200
      DateMode = dmUpDown
      TabOrder = 2
    end
    object dtp_hora_fin: TDateTimePicker
      Left = 212
      Top = 46
      Width = 69
      Height = 21
      Date = 40382.000000000000000000
      Format = 'HH:mm'
      Time = 0.605096157407388100
      DateMode = dmUpDown
      TabOrder = 3
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 152
    Width = 394
    Height = 19
    Panels = <
      item
        Text = 'Seleccione la fecha y hora para el perido vacacional'
        Width = 50
      end>
    ExplicitTop = 162
    ExplicitWidth = 404
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = Action1
                Caption = '&Guardar'
                ImageIndex = 17
                ShortCut = 16455
              end
              item
                Action = Action2
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 104
    Top = 112
    StyleName = 'Platform Default'
    object Action1: TAction
      Category = 'Sistema'
      Caption = 'Guardar'
      ImageIndex = 17
      ShortCut = 16455
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = Action2Execute
    end
  end
end
