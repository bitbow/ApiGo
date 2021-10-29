unit UwmMain;

interface

uses
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  MVCFramework,
  MVCFramework.Commons, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client;
  
  {
  System.SysUtils,
  System.Classes,
  Web.HTTPApp,
  MVCFramework;  	
  }

type
  TwmMain = class(TWebModule)
    procedure WebModuleCreate(Sender: TObject);
    procedure WebModuleDestroy(Sender: TObject);

  private
    MVC: TMVCEngine;
  public
    { Public declarations }
    Conn: TFDConnection;
    qAtable: TFDQuery;
  end;

var
  WebModuleClass: TComponentClass = TwmMain;

implementation

{$R *.dfm}


uses
  UMVCcontroller,
  System.Generics.Collections,
  AuthenticationU,
  MVCFramework.Middleware.JWT,
  MVCFramework.Middleware.StaticFiles,
  MVCFramework.JWT,
  System.DateUtils,
  UGlobal, UUtils;

procedure TwmMain.WebModuleCreate(Sender: TObject);
var
  lClaimsSetup: TJWTClaimsSetup;
begin
  Conn:= TFDConnection.Create(Self);
  qAtable:= TFDQuery.Create(Self);

  qAtable.Connection := Conn;

  with Conn.Params do
  begin
    Clear;

    Add('DriverID=');
    Add('Database=');
    Add('Server=');
    Add('User_Name=');
    Add('Password=');

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

      Conn.Params.Clear;
      Conn.Params.Values['DriverID'] := gDBDriverID;
      Conn.Params.Values['Database'] := gDBDatabase;
      Conn.Params.Values['Server']   := gDBServer;
      Conn.Params.Values['User_Name']:= gDBUserName;
      Conn.Params.Values['Password'] := gDBPassword;
    end;

  end;


  lClaimsSetup := procedure(const JWT: TJWT)
    begin
      JWT.Claims.Issuer := 'Delphi MVC Framework JWT Middleware Sample';
      if TMVCWebRequest(JWT.Data).QueryStringParamExists('rememberme') then
      begin
        JWT.Claims.ExpirationTime := Now + (OneHour * 10); // valid for 10 hour
      end
      else
      begin
        JWT.Claims.ExpirationTime := Now + OneHour; // valid for 1 hour
      end;
      JWT.Claims.NotBefore := Now - OneMinute * 5; // valid since 5 minutes ago
      JWT.Claims.IssuedAt := Now;
      JWT.CustomClaims['mycustomvalue'] := 'hello there';
    end;

  MVC := TMVCEngine.Create(Self,
    procedure(Config: TMVCConfig)
    begin
      Config[TMVCConfigKey.SessionTimeout] := '30';
      Config[TMVCConfigKey.DefaultContentType] := 'text/html';
    end);
  MVC
    // .AddController(TApp1MainController)
    .AddController(TApiGoController)
    .AddMiddleware(
      TMVCJWTAuthenticationMiddleware.Create(
        TAuthenticationSample.Create,
        'mys3cr37',
        '/login',
        lClaimsSetup,
        [
          TJWTCheckableClaim.ExpirationTime,
          TJWTCheckableClaim.NotBefore,
          TJWTCheckableClaim.IssuedAt
        ], 300))
    .AddMiddleware(TMVCStaticFilesMiddleware.Create(
    '/static', { StaticFilesPath }
    '..\..\www' { DocumentRoot }
    ));
end;

procedure TwmMain.WebModuleDestroy(Sender: TObject);
begin
  Conn.Free;
  qAtable.Free;
end;

end.
