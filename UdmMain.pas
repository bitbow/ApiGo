unit UdmMain;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.ConsoleUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.VCLUI.Wait;

type
  TdmConexion = class(TDataModule)
    qAtable: TFDQuery;
    Conn: TFDConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConexion: TdmConexion;

implementation

uses
  UGlobal, UUtils;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure TdmConexion.DataModuleCreate(Sender: TObject);
begin
  // SQlite/MSSQL
  gDBDriverID  := rIni('Database','DriverID');

  if gDBDriverID='SQLite' then
  begin
    gDBDatabase := rIni('Database','Database');

    Conn.Params.Values['DriverID'] := gDBDriverID;
    Conn.Params.Values['Database'] := gDBDatabase;
  end
  else if gDBDriverID='MSSQL' then
  begin
    gDBDatabase := rIni('Database','Database');
    gDBServer   := rIni('Database','Server');
    gDBUserName := rIni('Database','UserName');
    gDBPassword := rIni('Database','Password');

    Conn.Params.Values['DriverID'] := gDBDriverID;
    Conn.Params.Values['Database'] := gDBDatabase;
    Conn.Params.Values['Server']   := gDBServer;
    Conn.Params.Values['User_Name']:= gDBUserName;
    Conn.Params.Values['Password'] := gDBPassword;
  end;
end;

end.
