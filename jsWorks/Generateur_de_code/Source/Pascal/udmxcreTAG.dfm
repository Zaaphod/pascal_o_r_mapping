inherited dmxcreTag: TdmxcreTag

  Left = 382

  Top = 222

  Height = 242

  Width = 355

  object sqlq: TSQLQuery

    MaxBlobSize = -1

    Params = <>

    SQL.Strings = (

      'CREATE TABLE Tag'
      '  ('
      '  Numero          INTEGER AUTO_INCREMENT PRIMARY KEY,'
      '  `idType`        INTEGER   ,'
      '  `Name`          CHAR( 42)   )'
      '')

    SQLConnection = dmDatabase.sqlc

    Left = 16

    Top = 16

  end

end

