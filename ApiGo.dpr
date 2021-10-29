program ApiGo;

{$APPTYPE CONSOLE}


uses
  System.SysUtils,
  Winapi.Windows,
  Winapi.ShellAPI,
  Web.WebReq,
  Web.WebBroker,
  IdHTTPWebBrokerBridge,
  MVCFramework.Commons,
  IdContext,
  UwmMain in 'UwmMain.pas' {wmMain: TWebModule},
  UMVCcontroller in 'UMVCcontroller.pas',
  AuthenticationU in 'AuthenticationU.pas',
  UUtils in 'Lib\UUtils.pas',
  UGlobal in 'UGlobal.pas';

{$R *.res}

type
  TWebBrokerBridgeAuthEvent = class
  public
    class procedure ServerParserAuthentication(AContext: TIdContext; const AAuthType, AAuthData: String; var VUsername,
    VPassword: String; var VHandled: Boolean);
  end;

procedure RunServer(APort: Integer);
var
  LServer: TIdHTTPWebBrokerBridge;
begin
  Writeln(Format('Starting HTTP Server or port %d', [APort]));
  LServer := TIdHTTPWebBrokerBridge.Create(nil);
  try
    LServer.OnParseAuthentication :=  TMVCParseAuthentication.OnParseAuthentication;
    LServer.DefaultPort := APort;
    LServer.Active := True;
    Writeln('Press RETURN to stop the server');
    // ShellExecute(0, 'open', PChar('http://localhost:' + IntToStr(APort)), nil, nil, SW_SHOW);
    ReadLn;
  finally
    LServer.Free;
  end;
end;

{ TWebBrokerBridgeAuthEvent }

class procedure TWebBrokerBridgeAuthEvent.ServerParserAuthentication(AContext: TIdContext; const AAuthType, AAuthData: String;
  var VUsername, VPassword: String; var VHandled: Boolean);
begin
  if SameText(AAuthType, 'bearer') then
    VHandled := True;
end;

begin
  ReportMemoryLeaksOnShutdown := True;
  try
    if WebRequestHandler <> nil then
      WebRequestHandler.WebModuleClass := WebModuleClass;
    WebRequestHandlerProc.MaxConnections := 1024;

    // dmConexion := TdmConexion.Create(nil);

    gServerPort := StrToIntDef(rIni('Configuration','ServerPort'),8080);

    RunServer(gServerPort);
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end

end.
