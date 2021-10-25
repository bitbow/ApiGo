unit UUtils;

interface
uses
  SysUtils, INIFiles;

  function rIni( IniSection:String; IniName:String ): String;


implementation

function rIni( IniSection:String; IniName:String ): String;
var
  myINI: TINIFile;
  NameFile :String;
begin
  NameFile := copy(ExtractFileName(ParamStr(0)),1,Length(ExtractFileName(ParamStr(0)))-4) +'.ini';
  if FileExists( IncludeTrailingBackslash(GetCurrentDir) + NameFile) then
     begin
       myINI  := TINIFile.Create(IncludeTrailingBackslash(GetCurrentDir) + NameFile);
       Result := myINI.ReadString(IniSection, IniName, '0');
       myINI.Free;
     end else raise Exception.Create('Error : No existe el archivo '+ NameFile);
end;

end.
