unit scramble;

interface

uses
  SysUtils;
  
function ScrambleFile(Source : PChar ; Destination : PChar) : boolean; stdcall; export;
function UnscrambleFile(Source : PChar ; Destination : PChar) : boolean; stdcall; export;

implementation

{$R scramble.RES}

uses
  U_Scramble;

//------------------------------------------------------------------------------

//---ScrambleFile---
//Permet de scrambler un binaire.
function ScrambleFile(Source : PChar ; Destination : PChar) : boolean; stdcall; export;
begin
  Result := False;
  if FileAccessError(Source) then Exit;
  if FileExists(Destination) then Exit;

  RunAndWait(GetScrambleBinary + ' "' + Source + '" "' + Destination);
  Result := FileExists(Destination);
end;

//------------------------------------------------------------------------------

//---UnscrambleFile---
//Permet d'unscrambler un fichier.
function UnscrambleFile(Source : PChar ; Destination : PChar) : boolean; stdcall; export;
begin
  Result := False;
  if FileAccessError(Source) then Exit;
  if FileExists(Destination) then Exit;

  RunAndWait(GetScrambleBinary + ' -d "' + Source + '" "' + Destination);
  Result := FileExists(Destination);
end;

end.
