object dmConexion: TdmConexion
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 255
  Width = 391
  object qAtable: TFDQuery
    Connection = Conn
    SQL.Strings = (
      'SELECT * FROM :pcatalog')
    Left = 52
    Top = 77
    ParamData = <
      item
        Name = 'PCATALOG'
        ParamType = ptInput
      end>
  end
  object Conn: TFDConnection
    Params.Strings = (
      'Database='
      'ConnectionDef=FFacLite')
    LoginPrompt = False
    Left = 57
    Top = 16
  end
end
