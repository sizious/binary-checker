unit u_checker;

interface

uses
  Windows, SysUtils, Classes;

function SeekUnscrambleInfo(var FileBuf : PChar ; SizeBuf : integer) : boolean;

implementation

const
  RES_NAME      : PChar = 'DATALIST';
  STR_SEPARATOR : Byte = $0A;   //ATTENTION : LA CHAINE DE DETECTION NE POURRA
                                //PAS CONTENIR CE BYTE, SINON CA FAIT TOUT FOIRER!

//------------------------------------------------------------------------------

//---LoadSignsList---
//Charger la list des chaines de d�tection en m�moire (� partir de la ressource)
function LoadSignsList(Ressource : PChar ; var MS : TMemoryStream) : boolean;
var
 RS : TResourceStream;

begin
  Result := False;
  if not Assigned(MS) then Exit;

  RS := TResourceStream.Create(hInstance, Ressource, RT_RCDATA);
  try
    MS.CopyFrom(RS, 0);
    Result := True;
  finally
    RS.Free;
  end;
end;

//------------------------------------------------------------------------------

//---SearchSign---
//Permet de rechercher la signature en cours dans le fichier ouvert (FileBuf).
function SearchSign(var FileBuf : PChar ; SizeBuf : integer
  ; TargetSign : array of byte) : boolean;
var
  i, j      : integer;
  Searching : boolean;
  Buf       : Byte;

begin
  Result := False;
  Searching := False;

  j := 0;

  for i := 0 to SizeBuf - 1 do
  begin
    Buf := Ord(FileBuf[i]);
    
    //Ici nous v�rifions si j > High(TargetSign) + 1 pour savoir si nous avons
    //trouv� tous les caract�res dans l'ordre jusqu'au dernier.
    //On rajoute + 1 � High(TargetSign) parce que le tableau d�marre � 0.
    Result := j > (High(TargetSign) + 1);
    if Result then Exit;

    //La recherche est en cours (on a trouv� jusqu'a maintenant les bytes dans l'ordre)
    if Searching then
      begin
        //C'est toujours vrai ?
        //Pour le savoir nous allons regarder le caract�re en cours avec le tableau
        //GDFS_SIGN, � l'indice j, qui est incr�ment� � chaque bon byte (=caract�re)
        //trouv�. Si �a correspond, le test renvoie True, et Searching sera vrai.
        //Ca voudra dire que la recherche peut continuer (dans la limite fix�e au dessus,
        //�a voudrais dire qu'on a tout trouv�).

        //Searching := FileBuf[i] = TargetSign[j];
        Searching := Buf = TargetSign[j];
        Inc(j);
      end

    else

      //On d�marre la recherche
      //if FileBuf[i] = TargetSign[0] then
      if Buf = TargetSign[0] then
      begin
        //Le caract�re en cours est �gal au premier du tableau GDFS_SIGN :
        //On commence la recherche !
        Searching := True;
        j := 1;
      end;

  end;

end;

//------------------------------------------------------------------------------

//---SeekUnscrambleInfo---
//Permet d'extraire la liste � rechercher de la ressource.
//Lance le scan du bin.
function SeekUnscrambleInfo(var FileBuf : PChar ; SizeBuf : integer) : boolean;
var
  ReadBuf       : array[0..2047] of Byte;
  ExtractedSign : array of Byte;
  ReadByte      : Byte;
  Max, i, Lg, j : LongInt;
  List          : TMemoryStream;

begin
  Result := False;

  List := TMemoryStream.Create;
  try
    //charger la liste
    if not LoadSignsList(RES_NAME, List) then Exit;

    //On se repositionne au d�but
    List.Seek(0, soFromBeginning);

    //On va lire combien y'a de chaines de detection dans la ressource.
    List.Read(Max, SizeOf(Max)); //un longint sur 4 bytes (les 4 bytes du d�but).

    //On va boucler tant que c'est pas fini...
    for i := 0 to Max - 1 do
    begin

      //Lg contiendra la taille du tableau de byte ainsi lu.
      Lg := 0;
      //Tant qu'on est pas arriv� au bout du stream...
      while not (List.Position = List.Size) do
      begin
        //On va lire la chaine de d�tection et mettre le truc dans le buffer
        //ReadBuf, qui est au maximum de 2048 bytes. (la longueur est donc calcul�e
        //en m�me temps).
        List.Read(ReadByte, SizeOf(ReadByte));
        if ReadByte = STR_SEPARATOR then Break;
        ReadBuf[Lg] := ReadByte;
        Inc(Lg);
      end;

      //Si longueur inferieure � 0 ou �gale � 0 y'a un blem
      //On passe donc au suivant.
      if Lg <= 0 then Continue;

      //Sinon on va redimentionner le tableau ExtractedBuf, avec la vraie longueur.
      //C'est le vrai tableau qui va servir � la lecture du fichier.
      SetLength(ExtractedSign, Lg);

      //Ca y est nous avons dans ExtractedBuf la vraie chaine de d�tection.
      //Passons l� � la fonction qui va d�couvrir l'�tat
      for j := 0 to Lg - 1 do
        ExtractedSign[j] := ReadBuf[j];

      //Alors ?
      Result := SearchSign(FileBuf, SizeBuf, ExtractedSign);
      if Result then Exit; //TROUVE!!! On sort.
    end;

  finally
    List.Free;
  end;
end;

end.
