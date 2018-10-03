unit utils;

interface

uses
  Windows, SysUtils, Classes, ComCtrls;

function OpenList(const FileName : TFileName ; var Chrs, Bytes : TStringList) : boolean;
procedure LoadListView(LV : TListView ; var Chrs, Bytes : TStringList);

function NbSousChaine(substr: string; s: string): integer;
function GaucheNDroite(substr: string; s: string;n:integer): string;
function HexToInt(Number : string) : integer;

implementation

const
  STR_SEPARATOR : Byte = $0A;

//------------------------------------------------------------------------------

function droite(substr: string; s: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;

function GaucheNDroite(substr: string; s: string;n:integer): string;
var i:integer;
begin
  S:=S+substr;
  for i:=1 to n do
  begin
    S:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
  end;
  result:=copy(s, 1, pos(substr, s)-1);
end;

function NbSousChaine(substr: string; s: string): integer;
begin
  result:=0;
  while pos(substr,s)<>0 do
  begin
    S:=droite(substr,s);
    inc(result);
  end;
end;

//---HexToInt---
function HexToInt(Number : string) : integer;
begin
  Result := 0;
  if Length(Number) = 0 then Exit;
  
  Result := StrToInt('$' + Number);
end;

//------------------------------------------------------------------------------

function GetList(var MS : TMemoryStream ; var Chrs, Bytes : TStringList) : boolean;
var
  ReadBuf       : array[0..2047] of Byte;
  ExtractedBuf  : array of byte;
  ReadByte      : Byte;
  Max, i, Lg, j : LongInt;
  NewStr        : string;

begin
  Result := False;
  if not Assigned(Chrs) or not Assigned(Bytes) then Exit;

  //On se repositionne au début
  MS.Seek(0, soFromBeginning);

  //On va lire combien y'a de chaines de detection dans la ressource.
  MS.Read(Max, SizeOf(Max)); //un longint sur 4 bytes (les 4 bytes du début).

  //On va boucler tant que c'est pas fini...
  for i := 0 to Max - 1 do
  begin

    //Lg contiendra la taille du tableau de byte ainsi lu.
    Lg := 0;
    //Tant qu'on est pas arrivé au bout du stream...
    while not (MS.Position = MS.Size) do
    begin
      //On va lire la chaine de détection et mettre le truc dans le buffer
      //ReadBuf, qui est au maximum de 2048 bytes. (la longueur est donc calculée
      //en même temps).
      MS.Read(ReadByte, SizeOf(ReadByte));
      if ReadByte = STR_SEPARATOR then Break;
      ReadBuf[Lg] := ReadByte;
      Inc(Lg);
    end;
                  
    //Si longueur inferieure à 0 ou égale à 0 y'a un blem
    //On passe donc au suivant.
    if Lg <= 0 then Continue;

    //Sinon on va redimentionner le tableau ExtractedBuf, avec la vraie longueur.
    //C'est le vrai tableau qui va servir à la lecture du fichier.
    SetLength(ExtractedBuf, Lg);
                      
    //Ca y est nous avons dans ExtractedBuf la vraie chaine de détection.
    //Passons là à la fonction qui va découvrir l'état
    for j := 0 to Lg - 1 do
      ExtractedBuf[j] := ReadBuf[j];

    NewStr := '';
    for j := 0 to Lg - 1 do
      NewStr := NewStr + Chr(ExtractedBuf[j]);

    Chrs.Add(NewStr);

    NewStr := '';
    for j := 0 to Lg - 1 do
      NewStr := NewStr + IntToHex(Ord(ExtractedBuf[j]), 2) + ' ';

    Bytes.Add(NewStr);
  end;
end;

function OpenList(const FileName : TFileName ; var Chrs, Bytes : TStringList) : boolean;
var
  FS  : TFileStream;
  MS  : TMemoryStream;          

begin
  Result := False;
  if not Assigned(Chrs) or not Assigned(Bytes) then Exit;

  FS := TFileStream.Create(PChar(FileName), fmOpenRead);
  try

    MS := TMemoryStream.Create;
    try
      FS.Seek(0, soFromBeginning);

      //On copie tout le fichier dans le MemoryStream.
      //C'est bien plus rapide de traiter le fichier en mémoire que
      //directement le TFileStream !
      //Avant, c'était presque 5 secondes pour lire un fichier de 800KB.
      //Maintenant c'est immédiat.
      MS.LoadFromStream(FS);

      MS.Seek(0, soFromBeginning);

      Result := GetList(MS, Chrs, Bytes);
    finally
      MS.Free;
    end;

  finally
    FS.Free;
  end;
end;

procedure LoadListView(LV : TListView ; var Chrs, Bytes : TStringList);
var
  i : integer;

begin
  for i := 0 to Chrs.Count - 1 do
    with lv.Items.Add do
    begin
      Caption := Bytes[i];
      Subitems.Add(Chrs[i]);
    end;
end;

end.
