unit MainClientFormU;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  MVCFramework.Middleware.JWT,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.ToolWin, Vcl.ComCtrls;

type
  TForm5 = class(TForm)
    mToken: TMemo;
    mBody: TMemo;
    Panel1: TPanel;
    btnGet: TButton;
    btnLOGIN: TButton;
    Splitter1: TSplitter;
    mResponse: TMemo;
    Splitter2: TSplitter;
    btnLoginWithException: TButton;
    btnLoginJsonObject: TButton;
    Panel2: TPanel;
    chkRememberMe: TCheckBox;
    ToolBar1: TToolBar;
    cmbMethod: TComboBox;
    edResource: TEdit;
    Label1: TLabel;
    edUsuario: TEdit;
    edPassword: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btnGetClick(Sender: TObject);
    procedure btnLOGINClick(Sender: TObject);
    procedure btnLoginWithExceptionClick(Sender: TObject);
    procedure btnLoginJsonObjectClick(Sender: TObject);
  private
    FJWT: string;
    procedure SetJWT(const Value: string);
    property JWT: string read FJWT write SetJWT;
  public
    { Public declarations }
  end;

var
  Form5: TForm5;

implementation

{$R *.dfm}


uses
  MVCFramework.RESTClient.Intf,
  MVCFramework.RESTClient,
  MVCFramework.SystemJSONUtils,
  System.JSON;

procedure TForm5.btnGetClick(Sender: TObject);
var
  lClient: IMVCRESTClient;
  lResp: IMVCRESTResponse;
begin
  { Getting JSON response }
  lClient := TMVCRESTClient.New.BaseURL('localhost', 8090);
  lClient.ReadTimeOut(0);

  if not FJWT.IsEmpty then
    lClient.SetBearerAuthorization(FJWT);

  case cmbMethod.ItemIndex of
    // GET
    0: lResp := lClient.Get('/apigo/'+edResource.Text);
    // POST
    1: begin
         lClient.AddBody(mBody.Text);
         lResp := lClient.Post('/apigo/'+edResource.Text);
       end;
    // PUT
    2: begin
         lClient.AddBody(mBody.Text);
         lResp := lClient.Put('/apigo/'+edResource.Text);
       end;
    // DELETE
    3: lResp := lClient.Delete('/apigo/'+edResource.Text);
  end;

  mResponse.Lines.Text := lResp.Content;
end;

procedure TForm5.btnLOGINClick(Sender: TObject);
var
  lClient: IMVCRESTClient;
  lRest: IMVCRESTResponse;
  lJSON: TJSONObject;
  lSegment: string;
begin
  lSegment := '';
  if chkRememberMe.Checked then
  begin
    lSegment := '?rememberme=1';
  end;

  lClient := TMVCRESTClient.New.BaseURL('localhost', 8090);
  lClient.ReadTimeOut(0);
  lClient.SetBasicAuthorization(edUsuario.Text, edPassword.Text);
  lRest := lClient.Post('/login' + lSegment);

  if not lRest.Success then
  begin
    ShowMessage(
      'HTTP ERROR: ' + lRest.StatusCode.ToString + sLineBreak +
      'HTTP ERROR MESSAGE: ' + lRest.StatusText + sLineBreak +
      'ERROR MESSAGE: ' + lRest.Content);
    Exit;
  end;

  lJSON := TSystemJSON.StringAsJSONObject(lRest.Content);
  try
    JWT := lJSON.GetValue('token').Value;
  finally
    lJSON.Free;
  end;
end;

procedure TForm5.btnLoginJsonObjectClick(Sender: TObject);
var
  lClient: IMVCRESTClient;
  lRest: IMVCRESTResponse;
  lJSON: TJSONObject;
  lSegment: string;
begin
  lSegment := '';

  if chkRememberMe.Checked then
  begin
    lSegment := '?rememberme=1';
  end;

  lClient := TMVCRESTClient.New.BaseURL('localhost', 8090);
  lClient.ReadTimeOut(0);
  lRest := lClient.Post('/login' + lSegment, '{"jwtusername":"'+edUsuario.Text+'","jwtpassword":"'+edPassword.Text+'"}');

  if not lRest.Success then
  begin
    ShowMessage(
      'HTTP ERROR: ' + lRest.StatusCode.ToString + sLineBreak +
      'HTTP ERROR MESSAGE: ' + lRest.StatusText + sLineBreak +
      'ERROR MESSAGE: ' + lRest.Content);

    Exit;
  end;

  lJSON := TSystemJSON.StringAsJSONObject(lRest.Content);
  try
    JWT := lJSON.GetValue('token').Value;
  finally
    lJSON.Free;
  end;
end;

procedure TForm5.btnLoginWithExceptionClick(Sender: TObject);
var
  lClient: IMVCRESTClient;
  lRest: IMVCRESTResponse;
  lJSON: TJSONObject;
begin
  lClient := TMVCRESTClient.New.BaseURL('localhost', 8090);
  lClient.ReadTimeOut(0);
  lClient.SetBasicAuthorization('user_raise_exception', 'user_raise_exception');
  lRest := lClient.Post('/login');
  if not lRest.Success then
  begin
    ShowMessage(
      'HTTP ERROR: ' + lRest.StatusCode.ToString + sLineBreak +
      'HTTP ERROR MESSAGE: ' + lRest.StatusText + sLineBreak +
      'ERROR MESSAGE: ' + lRest.Content);
    Exit;
  end;

  lJSON := TSystemJSON.StringAsJSONObject(lRest.Content);
  try
    JWT := lJSON.GetValue('token').Value;
  finally
    lJSON.Free;
  end;
end;

procedure TForm5.SetJWT(const Value: string);
begin
  FJWT := Value;
  mToken.Lines.Text := Value;
end;

end.
