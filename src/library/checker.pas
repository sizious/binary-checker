unit checker;

interface

uses
  Windows, SysUtils, Classes;

function IsFileScrambled(FileName : PChar) : boolean ; stdcall ; export;

implementation

{$R datalist.RES}

uses
  u_checker;

//------------------------------------------------------------------------------

function IsFileScrambled(FileName : PChar) : boolean;
var
  FS      : TFileStream;
  FileBuf : PChar;

begin
  FS := TFileStream.Create(PChar(FileName), fmOpenRead);
  try
    FS.Seek(0, soFromBeginning);

    //Cr�ation du tableau dynamique PChar contenant le fichier
    GetMem(FileBuf, FS.Size);
    FS.ReadBuffer(FileBuf^, FS.Size); //Remplissage du tableau dynamique.

    //Acceder au contenu du tableau : ShowMessage(FileBuf^);
    //for i := 0 to FS.Size - 1 do
    //  showmessage(filebuf[i]);

    //Explication du NOT :
    //Pour savoir si le BIN est unscrambled, on va rechercher les donn�es
    //qui sont dans le fichier en ressource.

    //Le probl�me, c'est que la fonction s'appelle IsFileScrambled.
    //En gros, �a veut dire que si la fonction trouve la chaine dans le fichier,
    //elle va renvoyer TRUE. Ca voudra dire que le fichier est unscrambled.
    //or la question est : IsFileSCRAMBLED! ca veut dire qu'il faut inverser
    //la r�ponse de la fonction.

    //En d'autres termes :
    // SCRAMBLED   : chaine non trouv�e [SeekUnscrambledInfo : FALSE]
    // UNSCRAMBLED : chaine trouv�e.    [SeekUnscrambledInfo : TRUE]
    Result := not SeekUnscrambleInfo(FileBuf, FS.Size);

    FreeMem(FileBuf);
  finally
    FS.Free;
  end;
end;


end.
