unit UMVCcontroller;

interface

uses
  System.JSON,
  MVCFramework,
  MVCFramework.Commons,
  MVCFramework.Serializer.Commons,
  MVCFramework.Logger,
  Web.HTTPApp,
  FireDAC.Comp.DataSet;

  // MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;


type
  {
  [MVCPath('/')]
  TApp1MainController = class(TMVCController)
  public
    [MVCPath('/apigopublic')]
    [MVCHTTPMethod([httpGET])]
    procedure PublicSection(ctx: TWebContext);
    [MVCPath('/')]
    [MVCHTTPMethod([httpGET])]
    procedure Index(ctx: TWebContext);
  end;
  }
  [MVCPath('/apigo')]
  TApiGoController = class(TMVCController)
  protected
    procedure OnBeforeAction(AContext: TWebContext; const AActionName: string;
      var AHandled: Boolean); override;

  private
    function GetDataSetAsJSON(DataSet: TFDDataSet): TJSONObject;

  public
    [MVCPath('/role1')]
    [MVCProduces('text/html')]
    [MVCHTTPMethod([httpGET])]
    procedure OnlyRole1(ctx: TWebContext);
    [MVCPath('/role1')]
    [MVCProduces('application/json')]
    [MVCHTTPMethod([httpGET])]
    procedure OnlyRole1EmittingJSON;
    [MVCPath('/role2')]
    [MVCProduces('text/html')]
    [MVCHTTPMethod([httpGET])]
    procedure OnlyRole2(ctx: TWebContext);

    //Sample CRUD Actions for a "Customer" entity
    [MVCPath('/($Atable)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetTable(Atable: String);

    [MVCPath('/($Atable)/($Aid)')]
    [MVCHTTPMethod([httpGET])]
    procedure GetTableItem(Atable: String; Aid: Integer);

    [MVCPath('/($Atable)')]
    [MVCHTTPMethod([httpPOST])]
    procedure CreateTableItem(Atable: String);

    [MVCPath('/($Atable)/($Aid)')]
    [MVCHTTPMethod([httpPUT])]
    procedure UpdateTableItem(Atable: String; Aid: Integer);

    [MVCPath('/($Atable)/($Aid)')]
    [MVCHTTPMethod([httpDELETE])]
    procedure DeleteTableItem(Atable: String; Aid: Integer);
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,
  System.Generics.Collections,
  UwmMain,
  UGlobal,
  MVCFramework.DataSet.Utils,

  Data.DB,
  Variants;

{ TApp1MainController }
{
procedure TApp1MainController.Index(ctx: TWebContext);
begin
  Redirect('/index.html');
end;

procedure TApp1MainController.PublicSection(ctx: TWebContext);
begin
  Render('This is a public section');
end;
}

{ TAdminController }

procedure TApiGoController.OnBeforeAction(AContext: TWebContext;
  const AActionName: string; var AHandled: Boolean);
begin
  inherited;
  // Assert(AContext.LoggedUser.CustomData['customkey1'] = 'customvalue1', 'customkey1 not valid');
  // Assert(AContext.LoggedUser.CustomData['customkey2'] = 'customvalue2', 'customkey2 not valid');
  AHandled := False;
end;

function TApiGoController.GetDataSetAsJSON(DataSet: TFDDataSet): TJSONObject;
var
  f: TField;
  o: TJSOnObject;
  a: TJSONArray;

begin
  a := TJSONArray.Create;
  DataSet.Active := True;
  DataSet.First;

  while not DataSet.EOF do
  begin
    o := TJSOnObject.Create;

    for f in DataSet.Fields do
      o.AddPair(f.FieldName, VarToStr(f.Value));

    a.AddElement(o);
    DataSet.Next;
  end;

  DataSet.Active := False;

  Result := TJSONObject.Create;
  // Result.AddPair(DataSet.Name, a);
  Result.AddPair('data', a);
end;

procedure TApiGoController.OnlyRole1(ctx: TWebContext);
var
  lPair: TPair<String, String>;
begin
  ContentType := TMVCMediaType.TEXT_PLAIN;
  ResponseStream.AppendLine('Hey! Hello ' + ctx.LoggedUser.UserName +
    ', now you are a logged user and this is a protected content!');
  ResponseStream.AppendLine('As logged user you have the following roles: ' +
    sLineBreak + string.Join(sLineBreak, Context.LoggedUser.Roles.ToArray));
  ResponseStream.AppendLine('You CustomClaims are: ' +
    sLineBreak);
  for lPair in Context.LoggedUser.CustomData do
  begin
    ResponseStream.AppendFormat('%s = %s' + sLineBreak, [lPair.Key, lPair.Value]);
  end;
  RenderResponseStream;
end;

procedure TApiGoController.OnlyRole1EmittingJSON;
var
  // lJObj: TJSONObject;
  // lJArr: TJSONArray;
  lQueryParams: TStrings;
  I: Integer;
  lPair: TPair<String, String>;
begin
  ContentType := TMVCMediaType.APPLICATION_JSON;
  {
  lJObj := TJSONObject.Create;
  lJObj.AddPair('message', 'This is protected content accessible only by user1');
  lJArr := TJSONArray.Create;
  lJObj.AddPair('querystringparameters', lJArr);
  }
  lQueryParams := Context.Request.QueryStringParams;
  for I := 0 to lQueryParams.Count - 1 do
  begin
    {
    lJArr.AddElement(TJSONObject.Create(TJSONPair.Create(
      lQueryParams.Names[I],
      lQueryParams.ValueFromIndex[I])));
    }
  end;
  {
  lJArr := TJSONArray.Create;
  lJObj.AddPair('customclaims', lJArr);
  for lPair in Context.LoggedUser.CustomData do
  begin
    lJArr.AddElement(TJSONObject.Create(TJSONPair.Create(lPair.Key, lPair.Value)));
  end;
  }
  // Render(lJObj);

end;

procedure TApiGoController.OnlyRole2(ctx: TWebContext);
begin
  ContentType := TMVCMediaType.TEXT_PLAIN;
  ResponseStream.AppendLine('Hey! Hello ' + ctx.LoggedUser.UserName +
    ', now you are a logged user and this is a protected content!');
  ResponseStream.AppendLine('As logged user you have the following roles: ' +
    sLineBreak + string.Join(sLineBreak, Context.LoggedUser.Roles.ToArray));
  RenderResponseStream;
end;


//Sample CRUD Actions for a "Customer" entity
// httpGET
procedure TApiGoController.GetTable(Atable: String);
var
  wm: TwmMain;
begin
  wm := GetCurrentWebModule as TwmMain;
  wm.qAtable.SQL.Text := 'SELECT * FROM '+Atable;
  wm.qAtable.Open;

  Render( GetDataSetAsJSON( wm.qAtable ).ToString );
end;

// httpGET
procedure TApiGoController.GetTableItem(Atable: String; Aid: Integer);
var
  wm: TwmMain;
begin
  wm := GetCurrentWebModule as TwmMain;
  wm.qAtable.SQL.Text := 'SELECT * FROM '+Atable+' WHERE id='+ Aid.ToString;;
  wm.qAtable.Open;

  Render( GetDataSetAsJSON( wm.qAtable ).ToString );
end;

// httpPOST
procedure TApiGoController.CreateTableItem(Atable: String);
var
  wm: TwmMain;
begin
  //todo: create a new
  wm := GetCurrentWebModule as TwmMain;

  wm.qAtable.Close;
  wm.qAtable.CachedUpdates := True;
  wm.qAtable.Open('SELECT * FROM '+ Atable);
  wm.qAtable.Insert;
  wm.qAtable.LoadFromJSONObjectString(Context.Request.Body);
  wm.qAtable.ApplyUpdates;

  ResponseStatus(HTTP_STATUS.OK, gmsg_insert_ok);
end;

// httpPUT
procedure TApiGoController.UpdateTableItem(Atable: String; Aid: Integer);
var
  wm: TwmMain;
begin
  //todo: update by id
  wm := GetCurrentWebModule as TwmMain;

  wm.qAtable.Close;
  wm.qAtable.CachedUpdates := True;
  wm.qAtable.SQL.Text := 'SELECT * FROM '+Atable+' WHERE id=:Aid';
  wm.qAtable.ParamByName('Aid').AsInteger := Aid;
  wm.qAtable.Open;

  if (wm.qAtable.IsEmpty) then
    ResponseStatus(HTTP_STATUS.NotFound, gmsg_err_no_fount)
  else begin
    wm.qAtable.Edit;
    wm.qAtable.LoadFromJSONObjectString(Context.Request.Body);
    wm.qAtable.ApplyUpdates;

    ResponseStatus(HTTP_STATUS.OK, gmsg_update_ok);
  end;

end;

// httpDELETE
procedure TApiGoController.DeleteTableItem(Atable: String; Aid: Integer);
var
  wm: TwmMain;
begin
  //todo: delete item by id
  wm := GetCurrentWebModule as TwmMain;

  wm.qAtable.Close;
  wm.qAtable.CachedUpdates := True;
  wm.qAtable.SQL.Text := 'SELECT * FROM '+Atable+' WHERE id=:Aid';
  wm.qAtable.ParamByName('Aid').AsInteger := Aid;
  wm.qAtable.Open;
  wm.qAtable.Delete;
  wm.qAtable.ApplyUpdates;

  ResponseStatus(HTTP_STATUS.OK, ' 123'); //' El elemento se ha borrado correctamente');
end;

end.
