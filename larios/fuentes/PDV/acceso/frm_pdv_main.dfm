object Frm_main: TFrm_main
  Left = 369
  Top = 201
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Sistema para el Punto De Venta  '
  ClientHeight = 399
  ClientWidth = 706
  Color = clSilver
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Position = poScreenCenter
  ShowHint = True
  Visible = True
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 13
  object lbl_Hora: TLabel
    Left = 571
    Top = 327
    Width = 3
    Height = 13
    Caption = '.'
  end
  object Ribbon1: TRibbon
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 700
    Height = 143
    ActionManager = com
    ScreenTips = ScreenTipsManager1
    ApplicationMenu.Menu = RibbonApplicationMenuBar1
    QuickAccessToolbar.ShowMinimize = False
    QuickAccessToolbar.ShowMoreCommands = False
    QuickAccessToolbar.ShowPosition = False
    ShowHelpButton = False
    Tabs = <
      item
        Caption = 'Venta'
        Page = RibbonPage1
      end
      item
        Caption = 'Permisos'
        Page = RibbonPage2
      end
      item
        Caption = 'Corridas'
        Page = RibbonPage3
      end
      item
        Caption = 'Catalogos'
        Page = RibbonPage4
      end
      item
        Caption = 'Trafico'
        Page = RibbonPage5
      end
      item
        Caption = 'Cortes'
        Page = RibbonPage6
      end>
    TabIndex = 5
    ExplicitWidth = 696
    DesignSize = (
      700
      143)
    StyleName = 'Ribbon - Luna'
    object RibbonApplicationMenuBar1: TRibbonApplicationMenuBar
      ActionManager = com
      OptionItems = <>
      RecentItems = <>
    end
    object RibbonPage1: TRibbonPage
      Left = 0
      Top = 50
      Width = 699
      Height = 93
      Caption = 'Venta'
      Index = 0
      object RibbonGroup3: TRibbonGroup
        Left = 4
        Top = 3
        Width = 154
        Height = 86
        ActionManager = com
        Caption = 'Venta '
        GroupIndex = 0
      end
      object RibbonGroup8: TRibbonGroup
        Left = 160
        Top = 3
        Width = 169
        Height = 86
        ActionManager = com
        Caption = 'Reservacion'
        GroupIndex = 1
      end
      object RibbonGroup9: TRibbonGroup
        Left = 331
        Top = 3
        Width = 79
        Height = 86
        ActionManager = com
        Caption = 'Cancelaciones'
        GroupIndex = 2
      end
    end
    object RibbonPage2: TRibbonPage
      AlignWithMargins = True
      Left = 0
      Top = 50
      Width = 699
      Height = 93
      Caption = 'Permisos'
      Index = 1
      ExplicitWidth = 695
      object RibbonGroup1: TRibbonGroup
        Left = 4
        Top = 3
        Width = 257
        Height = 86
        ActionManager = com
        Caption = 'Permisos'
        GroupIndex = 0
      end
      object RibbonGroup2: TRibbonGroup
        Left = 263
        Top = 3
        Width = 232
        Height = 86
        ActionManager = com
        Caption = 'Creacion'
        GroupIndex = 1
      end
      object RibbonGroup10: TRibbonGroup
        Left = 497
        Top = 3
        Width = 68
        Height = 86
        ActionManager = com
        Caption = 'Password'
        GroupIndex = 2
      end
    end
    object RibbonPage3: TRibbonPage
      Left = 0
      Top = 50
      Width = 699
      Height = 93
      Caption = 'Corridas'
      Index = 2
      ExplicitWidth = 695
      object RibbonGroup4: TRibbonGroup
        Left = 4
        Top = 3
        Width = 292
        Height = 86
        ActionManager = com
        Caption = 'Corridas'
        GroupIndex = 0
      end
      object RibbonGroup5: TRibbonGroup
        Left = 298
        Top = 3
        Width = 65
        Height = 86
        ActionManager = com
        Caption = 'Itinerario'
        GroupIndex = 1
      end
    end
    object RibbonPage4: TRibbonPage
      Left = 0
      Top = 50
      Width = 699
      Height = 93
      Caption = 'Catalogos'
      Index = 3
      ExplicitWidth = 695
      object RibbonGroup6: TRibbonGroup
        Left = 4
        Top = 3
        Width = 369
        Height = 86
        ActionManager = com
        Caption = 'Catalogos'
        GroupIndex = 0
      end
      object RibbonGroup12: TRibbonGroup
        Left = 375
        Top = 3
        Width = 154
        Height = 86
        ActionManager = com
        Caption = 'Rutas'
        GroupIndex = 1
      end
    end
    object RibbonPage5: TRibbonPage
      Left = 0
      Top = 50
      Width = 699
      Height = 93
      Caption = 'Trafico'
      Index = 4
      ExplicitWidth = 695
      object RibbonGroup14: TRibbonGroup
        Left = 4
        Top = 3
        Width = 85
        Height = 86
        ActionManager = com
        Caption = 'Remotas'
        GroupIndex = 1
      end
      object RibbonGroup7: TRibbonGroup
        Left = 91
        Top = 3
        Width = 57
        Height = 86
        ActionManager = com
        Caption = 'Trafico'
        GroupIndex = 1
      end
    end
    object RibbonPage6: TRibbonPage
      Left = 0
      Top = 50
      Width = 699
      Height = 93
      ParentCustomHint = False
      BiDiMode = bdLeftToRight
      Caption = 'Cortes'
      Index = 5
      ParentBiDiMode = False
      ExplicitWidth = 695
      object RibbonGroup11: TRibbonGroup
        AlignWithMargins = True
        Left = 4
        Top = 3
        Width = 337
        Height = 86
        ActionManager = com
        Caption = 'Cortes'
        GroupAlign = gaHorizontal
        GroupIndex = 0
      end
      object RibbonGroup13: TRibbonGroup
        Left = 343
        Top = 3
        Width = 134
        Height = 86
        ActionManager = com
        Caption = 'Reportes'
        GroupIndex = 1
      end
      object RibbonGroup15: TRibbonGroup
        Left = 479
        Top = 3
        Width = 102
        Height = 86
        ActionManager = com
        Caption = 'Fondo Inicial'
        GroupIndex = 2
      end
    end
  end
  object com: TActionManager
    ActionBars = <
      item
        Items = <
          item
            ChangesAllowed = [caModify]
            Items = <
              item
                Action = ac99
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end
              item
                Caption = '-'
              end
              item
                Action = acApagar
                Caption = '&Apagar'
                ImageIndex = 52
              end>
            Caption = '&ActionClientItem0'
            CommandStyle = csMenu
            KeyTip = 'F'
            UsageCount = -1
            CommandProperties.Width = -1
            CommandProperties.Font.Charset = DEFAULT_CHARSET
            CommandProperties.Font.Color = clWindowText
            CommandProperties.Font.Height = -11
            CommandProperties.Font.Name = 'Tahoma'
            CommandProperties.Font.Style = []
            CommandProperties.Height = 0
          end>
        ActionBar = RibbonApplicationMenuBar1
        AutoSize = False
      end
      item
        Items = <
          item
            Action = ac106
            Caption = 'U&suarios'
            ShortCut = 16469
          end
          item
            Action = ac105
            Caption = '&Usuario'
            ShortCut = 16450
          end
          item
            Action = ac103
            Caption = 'G&rupo'
            ShortCut = 16449
          end
          item
            Action = ac100
            Caption = '&Grupos'
            ShortCut = 16455
          end>
      end
      item
        Items = <
          item
            Action = ac106
            Caption = 'U&suarios'
            ShortCut = 16469
          end
          item
            Action = ac105
            Caption = '&Usuario'
            ShortCut = 16450
          end
          item
            Action = ac103
            Caption = 'G&rupo'
            ShortCut = 16449
          end
          item
            Action = ac100
            Caption = '&Grupos'
            ShortCut = 16455
          end>
      end
      item
      end
      item
        Items = <
          item
            Action = acExtras
            Caption = '&Genera Corrida Extra'
            ImageIndex = 10
            ShortCut = 16453
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = acGenerarcorridas
            Caption = 'G&enera Corridas'
            ImageIndex = 9
            ShortCut = 16451
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = Action3
            Caption = 'E&status Corrida'
            ImageIndex = 22
            ShortCut = 16452
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = Action12
            Caption = 'C&orridas Remotas'
            ImageIndex = 10
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = acBars
            Caption = '&Codigo Barras'
            ImageIndex = 23
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup4
      end
      item
        Items = <
          item
            Action = acItinerario
            Caption = '&Itinerario'
            ImageIndex = 26
            ShortCut = 16457
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup5
      end
      item
      end
      item
        Items = <
          item
            Action = ac105
            Caption = '&Usuario'
            ShortCut = 16450
          end
          item
            Action = ac103
            Caption = '&Grupo'
            ShortCut = 16449
          end>
      end
      item
        Items = <
          item
            Action = ac106
            Caption = '&Usuarios'
            ShortCut = 16469
          end
          item
            Action = ac100
            Caption = '&Grupos'
            ShortCut = 16455
          end>
      end
      item
        Items = <
          item
            Action = ac105
            Caption = '&Usuario'
            ImageIndex = 13
            ShortCut = 16450
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac200
            Caption = '&Taquilla'
            ImageIndex = 39
            ShortCut = 49236
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act216
            Caption = '&Reporte Usuarios'
            ImageIndex = 33
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = Action11
            Caption = 'R&eporte Grupos'
            ImageIndex = 27
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac103
            Caption = '&Grupo'
            ImageIndex = 11
            ShortCut = 16449
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup1
      end
      item
        Items = <
          item
            Action = ac100
            Caption = '&Grupos'
            ImageIndex = 12
            ShortCut = 16455
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = Action7
            Caption = 'U&suarios Externos'
            ImageIndex = 14
            ShortCut = 16469
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac203
            Caption = 'S&tatus empleados'
            ImageIndex = 14
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac106
            Caption = '&Usuarios'
            ImageIndex = 14
            ShortCut = 16469
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup2
      end
      item
        Items = <
          item
            Action = ac120
            Caption = '&Ocupantes'
            ImageIndex = 8
            ShortCut = 16463
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac112
            Caption = '&Configuracion'
            ImageIndex = 7
            ShortCut = 16455
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac108
            Caption = '&Autobus'
            ImageIndex = 6
            ShortCut = 16454
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act127
            Caption = '&Tarifas'
            ImageIndex = 42
            ShortCut = 16468
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act219
            Caption = '&Importe Alertas'
            ImageIndex = 42
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = acVacacional
            Caption = '&Periodo Vacacional'
            ImageIndex = 49
            ShortCut = 16458
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup6
      end
      item
        Items = <
          item
            Action = actarjetaViaje
            Caption = '&Tarjeta de viaje'
            ImageIndex = 19
          end>
      end
      item
        Items = <
          item
            Action = Action6
            Caption = '&Venta'
            ImageIndex = 0
            ShortCut = 16470
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = Action5
            Caption = '&Historico'
            ImageIndex = 51
            ShortCut = 16456
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac158
            Caption = '&Liberar corrida'
            ImageIndex = 1
            ShortCut = 16460
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup3
      end
      item
        Items = <
          item
            Action = Action1
            Caption = '&Venta de reservaciones'
            ImageIndex = 3
            ShortCut = 16466
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = Action2
            Caption = '&Reservaciones'
            ImageIndex = 2
            ShortCut = 16467
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup8
      end
      item
        Items = <
          item
            Action = acCnlReservacion
            Caption = '&Cancela Reservacion'
            ImageIndex = 4
            ShortCut = 16451
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup9
      end
      item
        Items = <
          item
            Action = acCnlReservacion
            Caption = '&Cancela Reservacion'
            ImageIndex = 4
            ShortCut = 16451
          end
          item
            Action = ac108
            Caption = '&Autobus'
            ImageIndex = 6
            ShortCut = 16454
          end
          item
            Action = Action2
            Caption = '&Reservaciones'
            ImageIndex = 3
            ShortCut = 16467
          end
          item
            Action = acBoleto
            Caption = '&Boleto'
            ImageIndex = 5
          end
          item
            Action = ac112
            Caption = 'C&onfiguracion'
            ImageIndex = 7
            ShortCut = 16455
          end
          item
            Action = Action1
            Caption = 'V&enta de reservaciones'
            ImageIndex = 2
            ShortCut = 16466
          end
          item
            Action = ac120
            Caption = 'Oc&upantes'
            ImageIndex = 8
            ShortCut = 16463
          end
          item
            Action = ac100
            Caption = 'Grupo&s'
            ImageIndex = 12
            ShortCut = 16455
          end
          item
            Action = acGenerarcorridas
            Caption = '&Genera Corridas'
            ImageIndex = 9
            ShortCut = 16451
          end
          item
            Action = acExtras
            Caption = 'Ge&nera Corrida Extra'
            ImageIndex = 10
            ShortCut = 16453
          end
          item
            Action = ac103
            Caption = 'Gru&po'
            ImageIndex = 11
            ShortCut = 16449
          end>
      end
      item
      end
      item
        Items = <
          item
            Action = ac106
            Caption = 'U&suarios'
            ImageIndex = 14
            ShortCut = 16469
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = ac99
            Caption = 'S&alir'
            ImageIndex = 15
            ShortCut = 16467
          end
          item
            Action = actarjetaViaje
            Caption = '&Tarjeta de viaje'
            ImageIndex = 19
          end
          item
            Action = ac105
            Caption = '&Usuario'
            ImageIndex = 13
            ShortCut = 16450
          end>
      end
      item
        Items = <
          item
            Action = act162
            Caption = 'D&ias Pasados'
            ImageIndex = 38
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act186
            Caption = 'A&dministracion'
            ImageIndex = 47
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act147
            Caption = '&Tipo de Servicio'
            ImageIndex = 51
            CommandProperties.ButtonSize = bsLarge
          end
          item
            BackgroundLayout = blLeftBanner
            Action = act163
            Caption = '&Arqueo'
            ImageIndex = 36
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act146
            Caption = 'Fi&n de Dia'
            ImageIndex = 50
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act161
            Caption = '&Fin de turno'
            ImageIndex = 37
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup11
      end
      item
        Items = <
          item
            Action = act195
            Caption = '&Ciudades'
            ImageIndex = 28
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act125
            Caption = '&Tramos'
            ImageIndex = 29
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act126
            Caption = '&Rutas'
            ImageIndex = 30
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup12
      end
      item
        Items = <
          item
            Action = acPrecorte
            Caption = '&Pre-Corte'
            ImageIndex = 22
            ShortCut = 123
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act164
            Caption = '&Faltantes y Sobrantes'
            ImageIndex = 41
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup13
      end
      item
      end
      item
        Items = <
          item
            Action = Action4
            Caption = '&Cambiar password'
            ImageIndex = 48
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup10
      end
      item
        Items = <
          item
            Action = Act208
            Caption = '&Modificacion Gu'#237'as'
            ImageIndex = 16
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup14
      end
      item
        Items = <
          item
            Action = actarjetaViaje
            Caption = '&Tarjeta de viaje'
            ImageIndex = 19
          end>
      end
      item
        Items = <
          item
            Action = actarjetaViaje
            Caption = '&Tarjeta de viaje'
            ImageIndex = 19
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup7
      end
      item
        Items = <
          item
            Action = act214
            Caption = '&Fondo Caja'
            ImageIndex = 0
            CommandProperties.ButtonSize = bsLarge
          end
          item
            Action = act214_
            Caption = 'F&ondo Venta'
            ImageIndex = 0
            CommandProperties.ButtonSize = bsLarge
          end>
        ActionBar = RibbonGroup15
      end>
    LargeImages = DM.img_icons_large
    Images = DM.img_iconos
    Left = 132
    Top = 272
    StyleName = 'Ribbon - Luna'
    object ac99: TAction
      Tag = 99
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = ac99Execute
    end
    object ac100: TAction
      Tag = 100
      Category = 'Permisos'
      Caption = 'Grupos'
      ImageIndex = 12
      ShortCut = 16455
      OnExecute = ac100Execute
    end
    object ac103: TAction
      Tag = 103
      Category = 'Crear'
      Caption = 'Grupo'
      ImageIndex = 11
      ShortCut = 16449
      OnExecute = ac103Execute
    end
    object ac105: TAction
      Tag = 105
      Category = 'Crear'
      Caption = 'Usuario'
      ImageIndex = 13
      ShortCut = 16450
      OnExecute = ac105Execute
    end
    object ac106: TAction
      Tag = 106
      Category = 'Permisos'
      Caption = 'Usuarios'
      ImageIndex = 14
      ShortCut = 16469
      OnExecute = ac106Execute
    end
    object ac108: TAction
      Tag = 108
      Category = 'Catalogos'
      Caption = 'Autobus'
      ImageIndex = 6
      ShortCut = 16454
      OnExecute = ac108Execute
    end
    object ac112: TAction
      Tag = 112
      Category = 'Catalogos'
      Caption = 'Configuracion'
      ImageIndex = 7
      ShortCut = 16455
      OnExecute = ac112Execute
    end
    object ac116: TAction
      Tag = 116
      Caption = 'Itinerario'
    end
    object ac120: TAction
      Tag = 120
      Category = 'Catalogos'
      Caption = 'Ocupantes'
      ImageIndex = 8
      ShortCut = 16463
      OnExecute = ac120Execute
    end
    object ac158: TAction
      Tag = 158
      Category = 'Venta'
      Caption = 'Liberar corrida'
      Hint = 
        'Liberar corrida|Liberar una corrdia que por error esta bloqueada' +
        ' para su venta por alg'#250'n usuario.'
      ImageIndex = 1
      ShortCut = 16460
      OnExecute = ac158Execute
    end
    object acGenerarcorridas: TAction
      Category = 'Corridas'
      Caption = 'Genera Corridas'
      ImageIndex = 9
      ShortCut = 16451
      OnExecute = acGenerarcorridasExecute
    end
    object acItinerario: TAction
      Category = 'Itinerario'
      Caption = 'Itinerario'
      ImageIndex = 26
      ShortCut = 16457
      OnExecute = acItinerarioExecute
    end
    object acExtras: TAction
      Category = 'Corridas'
      Caption = 'Genera Corrida Extra'
      ImageIndex = 10
      ShortCut = 16453
      OnExecute = acExtrasExecute
    end
    object actarjetaViaje: TAction
      Category = 'Trafico'
      Caption = 'Tarjeta de viaje'
      ImageIndex = 19
      OnExecute = actarjetaViajeExecute
    end
    object Action1: TAction
      Category = 'Reservacion'
      Caption = 'Venta de reservaciones'
      ImageIndex = 3
      ShortCut = 16466
      OnExecute = Action1Execute
    end
    object Action2: TAction
      Category = 'Reservacion'
      Caption = 'Reservaciones'
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = Action2Execute
    end
    object acBoleto: TAction
      Category = 'Cancelaciones'
      Caption = 'Boleto'
      ImageIndex = 5
      OnExecute = acBoletoExecute
    end
    object acCnlReservacion: TAction
      Category = 'Cancelaciones'
      Caption = 'Cancela Reservacion'
      ImageIndex = 4
      ShortCut = 16451
      OnExecute = acCnlReservacionExecute
    end
    object act161: TAction
      Tag = 161
      Category = 'Cortes'
      Caption = 'Fin de turno'
      ImageIndex = 37
      OnExecute = act161Execute
    end
    object act162: TAction
      Tag = 162
      Category = 'Cortes'
      Caption = 'Dias Pasados'
      ImageIndex = 38
      OnExecute = act162Execute
    end
    object act163: TAction
      Tag = 163
      Category = 'Cortes'
      Caption = 'Arqueo'
      ImageIndex = 36
      OnExecute = act163Execute
    end
    object act126: TAction
      Tag = 126
      Category = 'Rutas'
      Caption = 'Rutas'
      ImageIndex = 30
      OnExecute = act126Execute
    end
    object act125: TAction
      Tag = 125
      Category = 'Rutas'
      Caption = 'Tramos'
      ImageIndex = 29
      OnExecute = act125Execute
    end
    object act164: TAction
      Tag = 164
      Category = 'Reportes'
      Caption = 'Faltantes y Sobrantes'
      ImageIndex = 41
      OnExecute = act164Execute
    end
    object act127: TAction
      Tag = 127
      Category = 'Catalogos'
      Caption = 'Tarifas'
      ImageIndex = 42
      ShortCut = 16468
      OnExecute = act127Execute
    end
    object Action3: TAction
      Category = 'Corridas'
      Caption = 'Estatus Corrida'
      ImageIndex = 22
      ShortCut = 16452
      OnExecute = Action3Execute
    end
    object acVacacional: TAction
      Category = 'Catalogos'
      Caption = 'Periodo Vacacional'
      ImageIndex = 49
      ShortCut = 16458
      OnExecute = acVacacionalExecute
    end
    object act186: TAction
      Tag = 186
      Category = 'Cortes'
      Caption = 'Administracion'
      ImageIndex = 47
      OnExecute = act186Execute
    end
    object Action4: TAction
      Category = 'Password'
      Caption = 'Cambiar password'
      ImageIndex = 48
      OnExecute = Action4Execute
    end
    object act146: TAction
      Tag = 146
      Category = 'Cortes'
      Caption = 'Fin de Dia'
      ImageIndex = 50
      OnExecute = act146Execute
    end
    object act147: TAction
      Tag = 147
      Category = 'Cortes'
      Caption = 'Tipo de Servicio'
      ImageIndex = 51
      OnExecute = act147Execute
    end
    object Action5: TAction
      Category = 'Venta'
      Caption = 'Historico'
      ImageIndex = 51
      ShortCut = 16456
      OnExecute = Action5Execute
    end
    object Action6: TAction
      Category = 'Venta'
      Caption = 'Venta'
      ImageIndex = 0
      ShortCut = 16470
      OnExecute = Action6Execute
    end
    object acApagar: TAction
      Category = 'Sistema'
      Caption = 'Apagar'
      ImageIndex = 52
    end
    object Action7: TAction
      Category = 'Permisos'
      Caption = 'Usuarios Externos'
      ShortCut = 16469
      OnExecute = Action7Execute
    end
    object Action8: TAction
      Category = 'Catalogos'
      Caption = 'Agencia'
      OnExecute = Action8Execute
    end
    object Action9: TAction
      Category = 'Corridas'
      Caption = 'Agencia '
      OnExecute = Action9Execute
    end
    object Action10: TAction
      Category = 'Catalogos'
      Caption = 'Terminal Agencia'
    end
    object act195: TAction
      Tag = 195
      Category = 'Rutas'
      Caption = 'Ciudades'
      ImageIndex = 28
      OnExecute = act195Execute
    end
    object ac200: TAction
      Tag = 200
      Category = 'Permisos'
      Caption = 'Taquilla'
      ImageIndex = 39
      ShortCut = 49236
      OnExecute = ac200Execute
    end
    object ac203: TAction
      Tag = 203
      Category = 'Crear'
      Caption = 'Status empleados'
      ImageIndex = 14
      OnExecute = ac203Execute
    end
    object acPrecorte: TAction
      Category = 'Cortes'
      Caption = 'Pre-Corte'
      ImageIndex = 22
      ShortCut = 123
      OnExecute = acPrecorteExecute
    end
    object Act208: TAction
      Tag = 208
      Category = 'Trafico'
      Caption = 'Modificacion Gu'#237'as'
      ImageIndex = 16
      OnExecute = Act208Execute
    end
    object acBars: TAction
      Category = 'Corridas'
      Caption = 'Codigo Barras'
      ImageIndex = 23
      OnExecute = acBarsExecute
    end
    object act214: TAction
      Tag = 214
      Category = 'Fondo'
      Caption = 'Fondo Caja'
      ImageIndex = 0
      OnExecute = act214Execute
    end
    object act214_: TAction
      Tag = 214
      Category = 'Fondo'
      Caption = 'Fondo Venta'
      ImageIndex = 0
      OnExecute = act214_Execute
    end
    object act216: TAction
      Tag = 216
      Category = 'Reportes'
      Caption = 'Reporte Usuarios'
      ImageIndex = 33
      OnExecute = act216Execute
    end
    object Action11: TAction
      Category = 'Reportes'
      Caption = 'Reporte Grupos'
      ImageIndex = 27
      OnExecute = Action11Execute
    end
    object act219: TAction
      Tag = 219
      Category = 'Catalogos'
      Caption = 'Importe Alertas'
      ImageIndex = 42
      OnExecute = act219Execute
    end
    object Action12: TAction
      Category = 'Corridas'
      Caption = 'Corridas Remotas'
      ImageIndex = 10
      OnExecute = Action12Execute
    end
  end
  object ScreenTipsManager1: TScreenTipsManager
    FooterImage.Data = {
      07544269746D61709E020000424D9E0200000000000036000000280000000E00
      00000E000000010018000000000068020000C40E0000C40E0000000000000000
      0000FF0099FF0099FF0099B8B8B8DADADABDAFAAC7ACA2C9AEA3C1B3ADE7E7E7
      CFCFCFFF0099FF0099FF00990000FF0099FF0099C7C7C7BDA49BA65336B85029
      BC532AC1572BC55A2CB86039CBB0A4D9D9D9FF0099FF00990000FF0099C7C7C7
      9D6B5CAE4927B24C28BC6241DCBCAFDDAF9CC2582BC5592CC4592BB37E68D9D9
      D9FF00990000C7C7C7B9A099A84426AC4727B14B28C18E7CCFCFCFE3E3E3BF55
      2AC0562BC0562BBE552AC8AEA4CFCFCF0000DCDCDCA4543AA84627AA4626AE49
      27B25231B5826FC4836BBA522ABB532ABB532ABA5229AA5636E7E7E70000BEB1
      ADB0502FB65631A84426AB4727AD5B3FA8A8A8AB9188B64F29B75029B64F29B5
      4E29B34D28BFB1AC0000C2ABA3B35633BD6138B85932A84426AB4727A2A2A2A7
      A7A7AE5C3FB24C28B24C28B14B28AF4A27C4ABA20000C8B2AAB55B37BD643BC2
      693CBE6338AF4E2CA66855A8A8A8A9A3A1B3684EAD4827AC4827AB4726C2A9A1
      0000CFC6C2B96744BC673EC06A3EC26B3EC46C3DBF6538BF907CC7C7C7CFC2BE
      AA4727AE4B29AC4929BCAFAB0000EBEBEBC89780BB6A42BE6C41C98B6ADCC1B2
      CF9474DBBAA9E8E8E8EEEEEEC06137BA5932A6553BDBDBDB0000B8B8B8EBE3E0
      C2805DBB6F45CA8F6FF4F4F4F5F5F5F5F5F5F6F6F6E5C9BCBB5E37B25230C0A7
      A0C7C7C70000FF0099CECECEDBCAC1C2835FBE7952D8AE96E9D1C4EEDACFD9AA
      93BF6C47B45936A37465C7C7C7FF00990000FF0099FF0099DCDCDCEBE4E1C9A0
      87BC7751B96F46BA6C44B96740B06B4DC1AAA2C7C7C7FF0099FF00990000FF00
      99FF0099FF0099D6D6D6ECECECD3CCC8D1BFB5CEBBB2C9BFBADEDEDEB8B8B8FF
      0099FF0099FF00990000}
    GradientEndColor = clYellow
    LinkedActionLists = <
      item
        ActionList = com
        Caption = 'ActionManager1'
      end>
    Options = [soShowHeader]
    ScreenTips = <
      item
        Action = ac158
        Description.Strings = (
          
            'Liberacion de corridas, cuando se bloquean las corridas durante ' +
            'la venta ')
        Header = 'Liberar corrida'
        ShowFooter = False
      end
      item
        Action = ac99
        Description.Strings = (
          'Salir del sistema')
        Header = 'Salir'
        ShowFooter = False
      end
      item
        Action = ac100
        Description.Strings = (
          'Creacion, modificacion y dar de baja a grupos'
          '')
        Header = 'Grupos'
        ShowFooter = False
      end
      item
        Action = ac103
        Description.Strings = (
          'Asignar o actualizacion de permisos  por usuario')
        Header = 'Grupo'
        ShowFooter = False
      end
      item
        Action = ac105
        Description.Strings = (
          'Asignacion o actualizacion de permisos por grupo')
        Header = 'Usuario'
        ShowFooter = False
      end
      item
        Action = ac106
        Description.Strings = (
          'Creacion, modificacion y dar de baja a usuarios')
        Header = 'Usuarios'
        ShowFooter = False
      end
      item
        Action = ac108
        Header = 'Autobus'
      end
      item
        Action = ac112
        Header = 'Configuracion'
      end
      item
        Action = ac116
        Header = 'Itinerario'
      end
      item
        Action = ac120
        Header = 'Ocupantes'
      end
      item
        Action = acGenerarcorridas
        Header = 'Generar corridas'
      end
      item
        Action = acItinerario
        Header = 'Itinerario'
      end
      item
        Action = acExtras
        Header = 'Extras'
      end
      item
        Action = actarjetaViaje
        Header = 'Tarjeta de viaje'
      end
      item
        Action = Action1
        Description.Strings = (
          'Venta de boletos por reservacion telefonica')
        Header = 'Reservaciones'
        ShowFooter = False
      end
      item
        Action = Action2
        Description.Strings = (
          
            'Reservacion de boletos por llamada telefonica, estos pueden ser ' +
            'autoliberables')
        Header = 'Venta Reservaciones'
        ShowFooter = False
      end
      item
        Action = acBoleto
        Description.Strings = (
          
            'Cancelacion de boletos, para hacer la cancelacion es necesario h' +
            'aber registrado un boleto en la venta')
        Header = 'Boleto'
        ShowFooter = False
      end
      item
        Action = acCnlReservacion
        Description.Strings = (
          'Cancela boletos reservados y estos son liberados para la venta')
        Header = 'Cancela Reservacion'
        ShowFooter = False
      end
      item
        Action = act161
        Header = 'Fin de turno'
      end
      item
        Action = act162
        Header = 'Dias Pasados'
      end
      item
        Action = act163
        Header = 'Auditoria'
      end
      item
        Action = act126
        Header = 'Rutas'
      end
      item
        Action = act125
        Header = 'Tramos'
      end
      item
        Action = act164
        Header = 'Faltantes y Sobrantes'
      end
      item
        Action = act127
        Header = 'Tarifas'
      end
      item
        Action = Action3
        Header = 'Estatus Corrida'
      end
      item
        Action = acVacacional
        Header = 'Periodo Vacacional'
      end
      item
        Action = act186
        Header = 'Administracion'
      end>
    Left = 64
    Top = 184
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 176
    Top = 184
  end
end
