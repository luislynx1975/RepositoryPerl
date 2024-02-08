object Frm_permisos_grps: TFrm_permisos_grps
  Left = 340
  Top = 201
  BorderIcons = []
  Caption = 'Permisos '
  ClientHeight = 440
  ClientWidth = 671
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
  object Pc_pagina: TPageControl
    Left = 0
    Top = 72
    Width = 671
    Height = 349
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 0
    OnChange = Pc_paginaChange
    ExplicitWidth = 667
    ExplicitHeight = 348
    object TabSheet1: TTabSheet
      Caption = 'Sistema'
      object lbAcceso: TLabel
        Left = 105
        Top = 16
        Width = 36
        Height = 13
        Caption = 'Acceso'
      end
      object lbAltas: TLabel
        Left = 184
        Top = 16
        Width = 23
        Height = 13
        Caption = 'Altas'
      end
      object LbUpdate: TLabel
        Left = 232
        Top = 16
        Width = 43
        Height = 13
        Caption = 'Modificar'
      end
      object Label54: TLabel
        Left = 312
        Top = 16
        Width = 26
        Height = 13
        Caption = 'Bajas'
        OnClick = Label54Click
      end
      object Label57: TLabel
        Left = 352
        Top = 16
        Width = 82
        Height = 13
        Caption = 'Acceso Reportes'
        OnClick = Label54Click
      end
      object Label58: TLabel
        Left = 449
        Top = 17
        Width = 92
        Height = 13
        Caption = 'Descarga Reportes'
        OnClick = Label54Click
      end
      object cb100: TCheckBox
        Tag = 100
        Left = 32
        Top = 40
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Grupos :'
        TabOrder = 0
      end
      object cb103: TCheckBox
        Tag = 103
        Left = 32
        Top = 67
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Permisos :'
        TabOrder = 1
      end
      object cb105: TCheckBox
        Tag = 105
        Left = 32
        Top = 92
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Usuarios :'
        TabOrder = 2
      end
      object cb101: TCheckBox
        Tag = 101
        Left = 187
        Top = 40
        Width = 17
        Height = 17
        TabOrder = 3
      end
      object cb102: TCheckBox
        Tag = 102
        Left = 242
        Top = 40
        Width = 25
        Height = 17
        TabOrder = 4
      end
      object cb104: TCheckBox
        Tag = 104
        Left = 242
        Top = 66
        Width = 25
        Height = 17
        TabOrder = 5
      end
      object cb106: TCheckBox
        Tag = 106
        Left = 187
        Top = 92
        Width = 19
        Height = 17
        TabOrder = 6
      end
      object cb107: TCheckBox
        Tag = 107
        Left = 242
        Top = 91
        Width = 30
        Height = 17
        TabOrder = 7
      end
      object cb200: TCheckBox
        Tag = 200
        Left = 32
        Top = 115
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        BiDiMode = bdLeftToRight
        Caption = 'Taquillas :'
        ParentBiDiMode = False
        TabOrder = 8
      end
      object cb201: TCheckBox
        Tag = 201
        Left = 187
        Top = 115
        Width = 19
        Height = 17
        TabOrder = 9
      end
      object cb202: TCheckBox
        Tag = 202
        Left = 242
        Top = 114
        Width = 25
        Height = 17
        TabOrder = 10
      end
      object cb204: TCheckBox
        Tag = 204
        Left = 24
        Top = 137
        Width = 105
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Elimina Usuarios :'
        TabOrder = 11
      end
      object cb150: TCheckBox
        Tag = 150
        Left = 320
        Top = 157
        Width = 17
        Height = 17
        TabOrder = 12
      end
      object cb216: TCheckBox
        Tag = 216
        Left = 362
        Top = 65
        Width = 25
        Height = 17
        TabOrder = 13
      end
      object cb217: TCheckBox
        Tag = 217
        Left = 459
        Top = 66
        Width = 25
        Height = 17
        TabOrder = 14
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Catalogos'
      ImageIndex = 1
      object Label1: TLabel
        Left = 112
        Top = 24
        Width = 36
        Height = 13
        Caption = 'Acceso'
      end
      object Label2: TLabel
        Left = 192
        Top = 24
        Width = 23
        Height = 13
        Caption = 'Altas'
      end
      object Label3: TLabel
        Left = 248
        Top = 24
        Width = 43
        Height = 13
        Caption = 'Modificar'
      end
      object Label4: TLabel
        Left = 328
        Top = 24
        Width = 26
        Height = 13
        Caption = 'Bajas'
      end
      object Label45: TLabel
        Left = 392
        Top = 24
        Width = 35
        Height = 13
        Caption = 'Asignar'
      end
      object cb108: TCheckBox
        Tag = 108
        Left = 65
        Top = 56
        Width = 72
        Height = 17
        Alignment = taLeftJustify
        BiDiMode = bdLeftToRight
        Caption = 'Autobus :'
        ParentBiDiMode = False
        TabOrder = 0
      end
      object cb109: TCheckBox
        Tag = 109
        Left = 264
        Top = 56
        Width = 17
        Height = 17
        TabOrder = 1
      end
      object cb112: TCheckBox
        Tag = 112
        Left = 40
        Top = 84
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Configuracion :'
        TabOrder = 2
      end
      object cb113: TCheckBox
        Tag = 113
        Left = 200
        Top = 84
        Width = 17
        Height = 17
        TabOrder = 3
      end
      object cb114: TCheckBox
        Tag = 114
        Left = 264
        Top = 84
        Width = 25
        Height = 17
        TabOrder = 4
      end
      object cb115: TCheckBox
        Tag = 115
        Left = 336
        Top = 84
        Width = 17
        Height = 17
        TabOrder = 5
      end
      object cb120: TCheckBox
        Tag = 120
        Left = 58
        Top = 112
        Width = 79
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Ocupante :'
        TabOrder = 6
      end
      object cb121: TCheckBox
        Tag = 121
        Left = 202
        Top = 112
        Width = 23
        Height = 17
        TabOrder = 7
      end
      object cb122: TCheckBox
        Tag = 122
        Left = 265
        Top = 112
        Width = 41
        Height = 17
        TabOrder = 8
      end
      object cb123: TCheckBox
        Tag = 123
        Left = 336
        Top = 112
        Width = 25
        Height = 17
        TabOrder = 9
      end
      object cb187: TCheckBox
        Tag = 187
        Left = 15
        Top = 138
        Width = 399
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Periodo vacacional :'
        TabOrder = 10
      end
      object cb195: TCheckBox
        Tag = 195
        Left = 58
        Top = 161
        Width = 70
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Agencia :'
        TabOrder = 11
      end
      object cb196: TCheckBox
        Tag = 196
        Left = 202
        Top = 165
        Width = 23
        Height = 17
        TabOrder = 12
      end
      object cb197: TCheckBox
        Tag = 197
        Left = 336
        Top = 165
        Width = 97
        Height = 17
        TabOrder = 13
      end
      object cb218: TCheckBox
        Tag = 218
        Left = 19
        Top = 225
        Width = 109
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Importe de Alertas: '
        TabOrder = 14
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Venta'
      ImageIndex = 2
      object Label6: TLabel
        Left = 80
        Top = 24
        Width = 36
        Height = 13
        Caption = 'Acceso'
      end
      object Label7: TLabel
        Left = 131
        Top = 24
        Width = 46
        Height = 13
        Caption = 'Asignarse'
      end
      object Label12: TLabel
        Left = 192
        Top = 24
        Width = 38
        Height = 13
        Caption = 'Finalizar'
      end
      object Label15: TLabel
        Left = 344
        Top = 24
        Width = 32
        Height = 13
        Caption = 'Liberar'
      end
      object Label17: TLabel
        Left = 408
        Top = 24
        Width = 42
        Height = 13
        Caption = 'Registrar'
      end
      object Label49: TLabel
        Left = 264
        Top = 24
        Width = 34
        Height = 13
        Caption = 'Vender'
      end
      object Label50: TLabel
        Left = 480
        Top = 24
        Width = 35
        Height = 13
        Caption = 'Imprimir'
      end
      object cb110: TCheckBox
        Tag = 110
        Left = 8
        Top = 56
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Venta :'
        TabOrder = 0
      end
      object cb111: TCheckBox
        Tag = 111
        Left = 146
        Top = 56
        Width = 17
        Height = 17
        TabOrder = 1
      end
      object cb116: TCheckBox
        Tag = 116
        Left = 205
        Top = 56
        Width = 25
        Height = 17
        TabOrder = 2
      end
      object cb158: TCheckBox
        Tag = 158
        Left = 8
        Top = 79
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Libera corrida :'
        TabOrder = 3
      end
      object cb159: TCheckBox
        Tag = 159
        Left = 353
        Top = 79
        Width = 97
        Height = 17
        TabOrder = 4
      end
      object cb179: TCheckBox
        Tag = 179
        Left = 8
        Top = 107
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Recoleccion :'
        TabOrder = 5
      end
      object cb180: TCheckBox
        Tag = 180
        Left = 423
        Top = 107
        Width = 18
        Height = 17
        TabOrder = 6
      end
      object cb188: TCheckBox
        Tag = 188
        Left = 8
        Top = 131
        Width = 281
        Height = 19
        Alignment = taLeftJustify
        Caption = 'Boleto Abierto :'
        TabOrder = 7
      end
      object cb189: TCheckBox
        Tag = 189
        Left = 491
        Top = 132
        Width = 25
        Height = 15
        TabOrder = 8
      end
      object GroupBox6: TGroupBox
        Left = 3
        Top = 224
        Width = 576
        Height = 102
        Caption = 'Reservaciones'
        TabOrder = 9
        object Label51: TLabel
          Left = 80
          Top = 37
          Width = 36
          Height = 13
          Caption = 'Acceso'
        end
        object Label52: TLabel
          Left = 141
          Top = 37
          Width = 28
          Height = 13
          Caption = 'Venta'
        end
        object Label53: TLabel
          Left = 192
          Top = 37
          Width = 59
          Height = 13
          Caption = 'Cancelacion'
        end
        object cb191: TCheckBox
          Tag = 191
          Left = 8
          Top = 56
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Reservaciones'
          TabOrder = 0
        end
        object cb192: TCheckBox
          Tag = 192
          Left = 146
          Top = 56
          Width = 23
          Height = 17
          TabOrder = 1
        end
        object cb193: TCheckBox
          Tag = 193
          Left = 205
          Top = 56
          Width = 22
          Height = 17
          TabOrder = 2
        end
      end
      object cb194: TCheckBox
        Tag = 194
        Left = 8
        Top = 156
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Bitacora boletos:'
        TabOrder = 10
      end
      object cb219: TCheckBox
        Tag = 219
        Left = 8
        Top = 185
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Viaje grupal'
        TabOrder = 11
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Servicios'
      ImageIndex = 3
      object Label8: TLabel
        Left = 96
        Top = 24
        Width = 36
        Height = 13
        Caption = 'Acceso'
      end
      object Label9: TLabel
        Left = 149
        Top = 24
        Width = 52
        Height = 13
        Caption = 'Despachar'
      end
      object Label10: TLabel
        Left = 225
        Top = 24
        Width = 56
        Height = 13
        Caption = 'Abrir corrida'
      end
      object Label11: TLabel
        Left = 317
        Top = 24
        Width = 35
        Height = 13
        Caption = 'Imprimir'
      end
      object Label55: TLabel
        Left = 392
        Top = 24
        Width = 26
        Height = 13
        Caption = 'Local'
      end
      object Label56: TLabel
        Left = 455
        Top = 24
        Width = 37
        Height = 13
        Caption = 'Remoto'
      end
      object cb154: TCheckBox
        Tag = 154
        Left = 15
        Top = 57
        Width = 106
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Guias'
        TabOrder = 0
      end
      object cb155: TCheckBox
        Tag = 155
        Left = 168
        Top = 57
        Width = 17
        Height = 17
        TabOrder = 1
      end
      object cb157: TCheckBox
        Tag = 157
        Left = 248
        Top = 57
        Width = 17
        Height = 17
        TabOrder = 2
      end
      object cb156: TCheckBox
        Tag = 156
        Left = 328
        Top = 57
        Width = 24
        Height = 17
        TabOrder = 3
      end
      object cb205: TCheckBox
        Tag = 205
        Left = 15
        Top = 88
        Width = 106
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Aparta Asientos :'
        TabOrder = 4
      end
      object cb206: TCheckBox
        Tag = 206
        Left = 24
        Top = 120
        Width = 394
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Guia de vacio :'
        TabOrder = 5
      end
      object cb207: TCheckBox
        Tag = 207
        Left = 470
        Top = 120
        Width = 13
        Height = 17
        TabOrder = 6
      end
      object cb208: TCheckBox
        Tag = 208
        Left = 32
        Top = 150
        Width = 89
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Guia Remota'
        TabOrder = 7
      end
      object cb209: TCheckBox
        Tag = 209
        Left = 470
        Top = 143
        Width = 13
        Height = 17
        Alignment = taLeftJustify
        TabOrder = 8
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Rutas y Tarifas'
      ImageIndex = 4
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 663
        Height = 165
        Align = alTop
        Caption = 'Rutas'
        TabOrder = 0
        object Label21: TLabel
          Left = 112
          Top = 12
          Width = 36
          Height = 13
          Caption = 'Acceso'
        end
        object Label22: TLabel
          Left = 171
          Top = 12
          Width = 18
          Height = 13
          Caption = 'Alta'
        end
        object Label23: TLabel
          Left = 219
          Top = 12
          Width = 40
          Height = 13
          Caption = 'Modifica'
        end
        object Label24: TLabel
          Left = 289
          Top = 12
          Width = 33
          Height = 13
          Caption = 'Elimina'
        end
        object Label25: TLabel
          Left = 353
          Top = 12
          Width = 30
          Height = 13
          Caption = 'Busca'
        end
        object Label26: TLabel
          Left = 417
          Top = 12
          Width = 37
          Height = 13
          Caption = 'Agregar'
        end
        object cb126: TCheckBox
          Tag = 126
          Left = 43
          Top = 31
          Width = 91
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Ruta :'
          TabOrder = 0
        end
        object cb129: TCheckBox
          Tag = 129
          Left = 172
          Top = 31
          Width = 18
          Height = 17
          TabOrder = 1
        end
        object cb130: TCheckBox
          Tag = 130
          Left = 233
          Top = 31
          Width = 17
          Height = 17
          TabOrder = 2
        end
        object cb132: TCheckBox
          Tag = 132
          Left = 297
          Top = 31
          Width = 25
          Height = 17
          TabOrder = 3
        end
        object cb133: TCheckBox
          Tag = 133
          Left = 361
          Top = 31
          Width = 16
          Height = 17
          TabOrder = 4
        end
        object cb136: TCheckBox
          Tag = 136
          Left = 3
          Top = 56
          Width = 244
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Tramos (De ruta):'
          TabOrder = 5
        end
        object CheckBox2: TCheckBox
          Left = 3
          Top = 79
          Width = 442
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Agregar Tramo(Ruta) :'
          TabOrder = 6
        end
        object CheckBox3: TCheckBox
          Left = 4
          Top = 103
          Width = 308
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Elimina Tramo (Ruta) :'
          TabOrder = 7
        end
        object CheckBox4: TCheckBox
          Left = 3
          Top = 126
          Width = 442
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Guardar Tramos (Ruta) :'
          TabOrder = 8
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 165
        Width = 663
        Height = 60
        Align = alClient
        Caption = 'Tramos'
        TabOrder = 1
        object Label27: TLabel
          Left = 113
          Top = 7
          Width = 36
          Height = 13
          Caption = 'Acceso'
        end
        object Label28: TLabel
          Left = 168
          Top = 7
          Width = 38
          Height = 13
          Caption = 'Guardar'
        end
        object Label30: TLabel
          Left = 225
          Top = 7
          Width = 33
          Height = 13
          Caption = 'Elimina'
        end
        object Label31: TLabel
          Left = 293
          Top = 7
          Width = 30
          Height = 13
          Caption = 'Busca'
        end
        object Label32: TLabel
          Left = 352
          Top = 7
          Width = 37
          Height = 13
          Caption = 'Agregar'
        end
        object cb125: TCheckBox
          Tag = 125
          Left = 58
          Top = 26
          Width = 81
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Tramo :'
          TabOrder = 0
        end
        object cb134: TCheckBox
          Tag = 134
          Left = 233
          Top = 26
          Width = 15
          Height = 17
          TabOrder = 1
        end
        object cb142: TCheckBox
          Tag = 142
          Left = 300
          Top = 26
          Width = 17
          Height = 17
          TabOrder = 2
        end
        object cb140: TCheckBox
          Tag = 140
          Left = 177
          Top = 26
          Width = 17
          Height = 17
          TabOrder = 3
        end
        object cb139: TCheckBox
          Tag = 139
          Left = 361
          Top = 26
          Width = 16
          Height = 17
          TabOrder = 4
        end
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 225
        Width = 663
        Height = 96
        Align = alBottom
        Caption = 'Tarifas'
        TabOrder = 2
        object Label29: TLabel
          Left = 168
          Top = 7
          Width = 32
          Height = 13
          Caption = 'Nueva'
        end
        object Label33: TLabel
          Left = 113
          Top = 7
          Width = 36
          Height = 13
          Caption = 'Acceso'
        end
        object cb127: TCheckBox
          Tag = 127
          Left = 42
          Top = 27
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Tarifas :'
          TabOrder = 0
        end
        object cb190: TCheckBox
          Tag = 190
          Left = 177
          Top = 27
          Width = 17
          Height = 17
          TabOrder = 1
        end
      end
    end
    object TabSheet6: TTabSheet
      Caption = 'Cancelaciones'
      ImageIndex = 5
      object Label13: TLabel
        Left = 120
        Top = 16
        Width = 36
        Height = 13
        Caption = 'Acceso'
      end
      object Label16: TLabel
        Left = 200
        Top = 16
        Width = 38
        Height = 13
        Caption = 'Autoriza'
      end
      object cb168: TCheckBox
        Tag = 168
        Left = 46
        Top = 48
        Width = 97
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Cancelacion :'
        TabOrder = 0
      end
      object cb169: TCheckBox
        Tag = 169
        Left = 213
        Top = 48
        Width = 12
        Height = 17
        TabOrder = 1
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Corridas e Itinerario'
      ImageIndex = 6
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 663
        Height = 105
        Align = alTop
        Caption = 'Itinerario'
        TabOrder = 0
        object Label35: TLabel
          Left = 105
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Acceso'
        end
        object Label36: TLabel
          Left = 166
          Top = 24
          Width = 42
          Height = 13
          Caption = 'Localizar'
        end
        object Label37: TLabel
          Left = 240
          Top = 24
          Width = 32
          Height = 13
          Caption = 'Nuevo'
        end
        object Label38: TLabel
          Left = 306
          Top = 24
          Width = 43
          Height = 13
          Caption = 'Modificar'
        end
        object Label39: TLabel
          Left = 376
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Eliminar'
        end
        object cb128: TCheckBox
          Tag = 128
          Left = 16
          Top = 56
          Width = 113
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Itinerario :'
          TabOrder = 0
        end
        object cb170: TCheckBox
          Tag = 170
          Left = 182
          Top = 56
          Width = 17
          Height = 17
          TabOrder = 1
        end
        object cb171: TCheckBox
          Tag = 171
          Left = 248
          Top = 56
          Width = 24
          Height = 17
          TabOrder = 2
        end
        object cb172: TCheckBox
          Tag = 172
          Left = 314
          Top = 56
          Width = 23
          Height = 17
          TabOrder = 3
        end
        object cb173: TCheckBox
          Tag = 173
          Left = 387
          Top = 56
          Width = 18
          Height = 17
          TabOrder = 4
        end
      end
      object GroupBox5: TGroupBox
        Left = 0
        Top = 105
        Width = 663
        Height = 176
        Align = alTop
        Caption = 'Corridas'
        TabOrder = 1
        object Label40: TLabel
          Left = 79
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Acceso'
        end
        object Label41: TLabel
          Left = 129
          Top = 24
          Width = 38
          Height = 13
          Caption = 'Generar'
        end
        object Label42: TLabel
          Left = 180
          Top = 24
          Width = 43
          Height = 13
          Caption = 'Modificar'
        end
        object Label43: TLabel
          Left = 236
          Top = 24
          Width = 36
          Height = 13
          Caption = 'Eliminar'
        end
        object Label44: TLabel
          Left = 281
          Top = 24
          Width = 37
          Height = 13
          Caption = 'Agrupar'
        end
        object Label46: TLabel
          Left = 334
          Top = 24
          Width = 21
          Height = 13
          Caption = 'Abrir'
        end
        object Label47: TLabel
          Left = 379
          Top = 24
          Width = 28
          Height = 13
          Caption = 'Cerrar'
        end
        object Label14: TLabel
          Left = 425
          Top = 24
          Width = 71
          Height = 13
          Caption = 'Presdespachar'
        end
        object Label48: TLabel
          Left = 506
          Top = 25
          Width = 52
          Height = 13
          Caption = 'Despachar'
        end
        object Label34: TLabel
          Left = 583
          Top = 25
          Width = 35
          Height = 13
          Caption = 'Asignar'
        end
        object cb174: TCheckBox
          Tag = 174
          Left = 6
          Top = 48
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Corrida:'
          TabOrder = 0
        end
        object cb175: TCheckBox
          Tag = 175
          Left = 141
          Top = 48
          Width = 17
          Height = 17
          TabOrder = 1
        end
        object cb176: TCheckBox
          Tag = 176
          Left = 6
          Top = 71
          Width = 97
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Extras :'
          TabOrder = 2
        end
        object cb177: TCheckBox
          Tag = 177
          Left = 141
          Top = 71
          Width = 17
          Height = 17
          TabOrder = 3
        end
        object cb178: TCheckBox
          Tag = 178
          Left = 6
          Top = 96
          Width = 197
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Cupos Corrida:'
          TabOrder = 4
        end
        object cb181: TCheckBox
          Tag = 181
          Left = 244
          Top = 48
          Width = 15
          Height = 17
          TabOrder = 5
        end
        object cb182: TCheckBox
          Tag = 182
          Left = 295
          Top = 48
          Width = 15
          Height = 17
          TabOrder = 6
        end
        object cb183: TCheckBox
          Tag = 183
          Left = 338
          Top = 48
          Width = 33
          Height = 17
          TabOrder = 7
        end
        object cb153: TCheckBox
          Tag = 153
          Left = 453
          Top = 45
          Width = 17
          Height = 23
          TabOrder = 8
        end
        object cb185: TCheckBox
          Tag = 185
          Left = 526
          Top = 48
          Width = 33
          Height = 17
          TabOrder = 9
        end
        object cb184: TCheckBox
          Tag = 184
          Left = 386
          Top = 48
          Width = 21
          Height = 17
          TabOrder = 10
        end
        object cb198: TCheckBox
          Tag = 198
          Left = 33
          Top = 119
          Width = 70
          Height = 17
          Alignment = taLeftJustify
          Caption = 'Agencia :'
          TabOrder = 11
        end
      end
    end
    object TabSheet8: TTabSheet
      Caption = 'Cortes'
      ImageIndex = 7
      object Label18: TLabel
        Left = 118
        Top = 47
        Width = 36
        Height = 13
        Caption = 'Acceso'
      end
      object Label19: TLabel
        Left = 184
        Top = 47
        Width = 42
        Height = 13
        Caption = 'Procesar'
      end
      object Label20: TLabel
        Left = 248
        Top = 46
        Width = 45
        Height = 13
        Caption = 'Impresi'#243'n'
      end
      object cb161: TCheckBox
        Tag = 161
        Left = 23
        Top = 72
        Width = 120
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Corte fin turno :'
        TabOrder = 0
      end
      object cb144: TCheckBox
        Tag = 144
        Left = 194
        Top = 72
        Width = 18
        Height = 17
        TabOrder = 1
      end
      object cb162: TCheckBox
        Tag = 162
        Left = 23
        Top = 96
        Width = 120
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Corte dias pasados :'
        TabOrder = 2
      end
      object cb145: TCheckBox
        Tag = 145
        Left = 263
        Top = 96
        Width = 17
        Height = 17
        TabOrder = 3
      end
      object cb163: TCheckBox
        Tag = 163
        Left = 76
        Top = 124
        Width = 67
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Arqueo :'
        TabOrder = 4
      end
      object cb152: TCheckBox
        Tag = 152
        Left = 194
        Top = 124
        Width = 18
        Height = 17
        TabOrder = 5
      end
      object cb147: TCheckBox
        Tag = 147
        Left = 8
        Top = 151
        Width = 199
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Corte por tipo servicio :'
        TabOrder = 6
      end
      object cb146: TCheckBox
        Tag = 146
        Left = 23
        Top = 177
        Width = 184
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Corte de fin de turno:'
        TabOrder = 7
      end
      object cb164: TCheckBox
        Tag = 164
        Left = 17
        Top = 203
        Width = 128
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Faltantes y sobrantes :'
        TabOrder = 8
      end
      object cb186: TCheckBox
        Tag = 186
        Left = 3
        Top = 233
        Width = 142
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Administracion de cortes:'
        TabOrder = 9
      end
      object cb214: TCheckBox
        Tag = 214
        Left = 3
        Top = 256
        Width = 142
        Height = 17
        Alignment = taLeftJustify
        Caption = 'Fondo Inicial'
        TabOrder = 10
      end
      object cb215: TCheckBox
        Tag = 215
        Left = 194
        Top = 256
        Width = 17
        Height = 17
        TabOrder = 11
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 27
    Width = 671
    Height = 45
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 667
    object Label5: TLabel
      Left = 50
      Top = 18
      Width = 35
      Height = 13
      Caption = 'Grupo :'
    end
    object lsCombo_grupos: TlsComboBox
      Left = 91
      Top = 10
      Width = 406
      Height = 21
      CharCase = ecUpperCase
      TabOrder = 0
      OnClick = lsCombo_gruposClick
      Complete = False
      ForceIndexOnExit = True
      MinLengthComplete = 0
    end
  end
  object ActionMainMenuBar1: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 671
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
    ExplicitWidth = 667
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 421
    Width = 671
    Height = 19
    Panels = <>
    ExplicitTop = 420
    ExplicitWidth = 667
  end
  object SimpleDataSet1: TSimpleDataSet
    Aggregates = <>
    DataSet.MaxBlobSize = -1
    DataSet.Params = <>
    Params = <>
    Left = 424
    Top = 24
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = ac104
                Caption = '&Actualizar'
                ImageIndex = 25
                ShortCut = 16449
              end
              item
                Action = ac99
                Caption = '&Salir'
                ImageIndex = 15
                ShortCut = 16467
              end>
            Caption = '&Sistema'
          end>
        ActionBar = ActionMainMenuBar1
      end>
    Images = DM.img_iconos
    Left = 376
    Top = 24
    StyleName = 'Platform Default'
    object ac104: TAction
      Tag = 104
      Category = 'Sistema'
      Caption = 'Actualizar'
      ImageIndex = 25
      ShortCut = 16449
      OnExecute = ac104Execute
    end
    object ac99: TAction
      Tag = 99
      Category = 'Sistema'
      Caption = 'Salir'
      ImageIndex = 15
      ShortCut = 16467
      OnExecute = ac99Execute
    end
  end
end
