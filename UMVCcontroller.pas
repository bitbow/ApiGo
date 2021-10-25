unit UMVCcontroller;

interface

uses
  MVCFramework, MVCFramework.Commons, MVCFramework.Serializer.Commons;

type

  [MVCPath('/apigo')]
  TApiGoController = class(TMVCController)
  public
    [MVCPath]
    [MVCHTTPMethod([httpGET])]
    procedure Index;
  protected
    procedure OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean); override;
    procedure OnAfterAction(Context: TWebContext; const AActionName: string); override;

  public
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
  System.SysUtils, MVCFramework.Logger, System.StrUtils, UdmMain, UGlobal, MVCFramework.DataSet.Utils;

procedure TApiGoController.Index;
begin
  //use Context property to access to the HTTP request and response
  Render(gName+' '+gVerName);
end;

procedure TApiGoController.OnAfterAction(Context: TWebContext; const AActionName: string);
begin
  { Executed after each action }
  inherited;
end;

procedure TApiGoController.OnBeforeAction(Context: TWebContext; const AActionName: string; var Handled: Boolean);
begin
  { Executed before each action
    if handled is true (or an exception is raised) the actual
    action will not be called }
  inherited;
end;

//Sample CRUD Actions for a "Customer" entity
// httpGET
procedure TApiGoController.GetTable(Atable: String);
begin
  //todo: render a list of customers
  dmConexion.qAtable.Open('SELECT * FROM '+ Atable);
  Render(dmConexion.qAtable, False);
end;

// httpGET
procedure TApiGoController.GetTableItem(Atable: String; Aid: Integer);
begin
  //todo: render the customer by id
  dmConexion.qAtable.Open('SELECT * FROM '+Atable+' WHERE id=?', [Aid]);
  Render(dmConexion.qAtable, False);
end;

// httpPOST
procedure TApiGoController.CreateTableItem(Atable: String);
begin
  //todo: create a new customer
  dmConexion.qAtable.Close;
  dmConexion.qAtable.CachedUpdates := True;
  dmConexion.qAtable.Open('SELECT * FROM '+ Atable);
  dmConexion.qAtable.Insert;
  dmConexion.qAtable.LoadFromJSONObjectString(Context.Request.Body);
  dmConexion.qAtable.ApplyUpdates;

  Render(gmsg_insert_ok);
  // Render('Insertado correctamente el id = ' + dmConexion.qAtable.FieldByName('Id').AsString);
end;

// httpPUT
procedure TApiGoController.UpdateTableItem(Atable: String; Aid: Integer);
begin
  //todo: update customer by id
  dmConexion.qAtable.Close;
  dmConexion.qAtable.CachedUpdates := True;
  dmConexion.qAtable.SQL.Text := 'SELECT * FROM '+Atable+' WHERE id=:Aid';
  dmConexion.qAtable.ParamByName('Aid').AsInteger := Aid;
  dmConexion.qAtable.Open;

  if (dmConexion.qAtable.IsEmpty) then
    Render(gmsg_err_no_fount)
    // ResponseStatus(HTTP_STATUS.NotFound, ' El elemento no se ha encontrado')
  else begin
    dmConexion.qAtable.Edit;
    dmConexion.qAtable.LoadFromJSONObjectString(Context.Request.Body);
    dmConexion.qAtable.ApplyUpdates;

    Render(gmsg_update_ok);
    // Render('Se ha actualizado el elemento con Id = '+IntToStr(Aid));
  end;
end;

// httpDELETE
procedure TApiGoController.DeleteTableItem(Atable: String; Aid: Integer);
begin
  //todo: delete item by id
  dmConexion.qAtable.Close;
  dmConexion.qAtable.CachedUpdates := True;
  dmConexion.qAtable.SQL.Text := 'SELECT * FROM '+Atable+' WHERE id=:Aid';
  dmConexion.qAtable.ParamByName('Aid').AsInteger := Aid;
  dmConexion.qAtable.Open;
  dmConexion.qAtable.Delete;
  dmConexion.qAtable.ApplyUpdates;

  Render(gmsg_delete_ok);
  // ResponseStatus(HTTP_STATUS.OK, ' El elemento se ha borrado correctamente');
end;

end.
