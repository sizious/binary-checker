unit u_scramble;

interface

uses
  Windows, SysUtils, Classes;

function FileAccessError(FileName : PChar) : boolean;
function RunAndWait(FileName : string) : boolean;
procedure ExtractScrambleBinary;
procedure DeleteScrambleBinary;
function GetScrambleBinary : string;

implementation

const
  SCRAMBLE_APP : string = 'SCRAMBLE.EXE';
  SCRAMBLE_RES : string = 'SCRAMBLE';
  SCRAMBLE_DIR : string = 'BINCHECK_DLL';

//------------------------------------------------------------------------------

//---FileAccessError---
//Permet de savoir si le fichier existe et qu'il n'est pas utilisé.
function FileAccessError(FileName : PChar) : boolean;
var
  F : File;

begin
  Result := True;
  if not FileExists(FileName) then Exit;

  AssignFile(F, PChar(FileName));
  FileMode := fmOpenRead; //on s'en fout de l'écriture (contrairement à la v1.4 lol!)
  //on LIT le fichier uniquement ! pas besoin de toucher ReadOnly !
  try
    Reset(F);
    CloseFile(F);
  except
    //un problème !
    Exit;
  end;

  Result := False;
end;

//------------------------------------------------------------------------------

//---ExtractFile---
//Permet d'extraire un fichier d'une ressource.
function ExtractFile(Ressource : PChar ; ToFile : PChar) : boolean;
var
 RS : TResourceStream;
 FS : TFileStream;
 
begin
  if FileExists(ToFile) then DeleteFile(ToFile);

  FS := TFileStream.Create(PChar(ToFile), fmCreate);
  try

    RS := TResourceStream.Create(hInstance, Ressource, RT_RCDATA);
    try
      FS.CopyFrom(RS, 0);

      Result := True;
    finally
      RS.Free;
    end;
    
    Result := True;
  finally
    FS.Free;
  end;
end;

//------------------------------------------------------------------------------

//---GetRealPath---
//Corriger les erreurs de paths.
function GetRealPath(Path : string) : string;
var
  i : integer;
  LastCharWasSeparator : Boolean;

begin
  Result := '';
  LastCharWasSeparator := False;

  Path := Path + '\';

  for i := 1 to Length(Path) do
  begin
    if Path[i] = '\' then
    begin
      if not LastCharWasSeparator then
      begin
        Result := Result + Path[i];
        LastCharWasSeparator := True;
      end
    end
    else
    begin
       LastCharWasSeparator := False;
       Result := Result + Path[i];
    end;
  end;
end;

//------------------------------------------------------------------------------

//---GetTempDir---
//Avoir le dossier temps de Windows.
function GetTempDir: string;
var
  Dossier : array[0..MAX_PATH] of Char;

begin
  Result := '';
  if GetTempPath(SizeOf(Dossier), Dossier) <> 0 then Result := StrPas(Dossier);
  Result := GetRealPath(Result);
end;

//------------------------------------------------------------------------------

//---RunAndWait---
//Lancer un programme et attendre la fin de son processus.
function RunAndWait(FileName : string) : boolean;
var
  StartInfo : TStartupInfo;
  ProcessInformation : TProcessInformation;
  
begin
  Result := True;
  ZeroMemory(@StartInfo, SizeOf(StartInfo)); // remplie de 0 StartInfo

  with StartInfo do
  begin
    CB := SizeOf(StartInfo);
    wShowWindow := SW_HIDE;
    lpReserved := nil;
    lpDesktop := nil;
    lpTitle := nil;
    dwFlags := STARTF_USESHOWWINDOW;
    cbReserved2 := 0;
    lpReserved2 := nil;
  end;

  if CreateProcess(nil, PChar(FileName), nil, nil, True, 0, nil, nil, StartInfo,
    ProcessInformation)
  then WaitForSingleObject(ProcessInformation.hProcess, INFINITE)
  // WaitForSingleObject attend que l'application désignée par le handle
  //ProcessInformation.hProcess soit terminée
  else Result := False;
end;

//------------------------------------------------------------------------------

//---GetScrambleBinary---
//Permet d'avoir le chemin complet vers le programme qui permet de scrambler un bin.
//Généralement c'est SCRAMBLE.EXE
function GetScrambleBinary : string;
begin
  Result := GetRealPath(GetTempDir + SCRAMBLE_DIR) + SCRAMBLE_APP;
end;

//------------------------------------------------------------------------------

//---ExtractScrambleBinary---
//Extraire le fichier SCRAMBLE.EXE dans un dossier, tout ça dans le dossier Temp
//de Windows.
procedure ExtractScrambleBinary;
var
  ScrambleBin,
  ScrambleDir : string;

begin
  ScrambleBin := GetScrambleBinary;
  ScrambleDir := ExtractFilePath(ScrambleBin);

  if not DirectoryExists(ScrambleDir) then
    ForceDirectories(ScrambleDir);

  ExtractFile(PChar(SCRAMBLE_RES), PChar(ScrambleBin));
end;

//------------------------------------------------------------------------------

//---ExtractScrambleBinary---
//Effacer le fichier SCRAMBLE.EXE + le dossier associé du dossier Temp de Windows.
procedure DeleteScrambleBinary;
var
  ScrambleBin,
  ScrambleDir : string;

begin
  ScrambleBin := GetScrambleBinary;
  ScrambleDir := ExtractFilePath(ScrambleBin);

  if DirectoryExists(ScrambleDir) then
  begin
    if FileExists(ScrambleBin) then
      DeleteFile(ScrambleBin);

    RemoveDir(ScrambleDir);
  end;
end;

//------------------------------------------------------------------------------

initialization
  ExtractScrambleBinary; //extraction au démarrage

finalization
  DeleteScrambleBinary; //on sort, on efface scramble.exe + le dossier

end.
