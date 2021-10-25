unit uGlobal;

interface

var
  gServerPort: Integer;

  gDBDriverID: String;
  gDBDatabase: String;
  gDBServer: String;
  gDBUserName: String;
  gDBPassword: String;


const
   gName           = 'ApiGo';
   gVerName        = '1.0';

   // ApiGo msg
   gmsg_insert_ok = '{"err_id":0, "msg":"insert ok"}';
   gmsg_update_ok = '{"err_id":0, "msg":"update ok"}';
   gmsg_delete_ok = '{"err_id":0, "msg":"delete ok"}';

   // ApiGo msg errors
   gmsg_err_no_fount = '{"err_id":-1, "err_msg":"not fount"}';

implementation

initialization

end.
