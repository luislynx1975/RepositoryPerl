object moduloCortes: TmoduloCortes
  OldCreateOrder = False
  Height = 150
  Width = 215
  object ConexionRave: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    DataSet = Query1
    Left = 24
    Top = 16
  end
  object Query1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = DM.Conecta
    Left = 96
    Top = 24
  end
end
