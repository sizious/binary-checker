unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, Buttons, ExtCtrls;

type
  TMain_Form = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    Edit2: TEdit;
    XPManifest: TXPManifest;
    Label2: TLabel;
    OpenDialog: TOpenDialog;
    Button3: TButton;
    Button4: TButton;
    sd: TSaveDialog;
    Shape1: TShape;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Bevel2: TBevel;
    Button5: TButton;
    Button6: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Main_Form: TMain_Form;

function IsFileScrambled(FileName : PChar) : boolean ; stdcall; external 'bincheck.dll';
function UnscrambleFile(Source, Destination : PChar) : boolean; stdcall; external 'bincheck.dll';
function ScrambleFile(Source, Destination : PChar) : boolean; stdcall; external 'bincheck.dll';

implementation

uses help;

{$R *.dfm}

function MsgBox(Handle : HWND ; Message, Caption : string ; Flags : integer) : integer;
begin
  Result := MessageBoxA(Handle, PChar(Message), PChar(Caption), Flags);
end;

procedure TMain_Form.Button1Click(Sender: TObject);
begin
  if OpenDialog.Execute = True then
  begin
    Edit1.Text := OpenDialog.FileName;
    Edit2.Text := '';
  end;
end;

procedure TMain_Form.Button2Click(Sender: TObject);
begin
  if not FileExists(Edit1.Text) then
  begin
    MsgBox(Handle, 'You forget a little thing, right ?', 'File not found', 48);
    Exit;
  end;

  if IsFileScrambled(PChar(Edit1.Text)) = True then
    Edit2.Text := 'SCRAMBLED !'
  else Edit2.Text := 'UNSCRAMBLED !';
end;

procedure TMain_Form.FormCreate(Sender: TObject);
begin
  Application.Title := Main_Form.Caption;
end;

procedure TMain_Form.Button3Click(Sender: TObject);
begin
  if not FileExists(Edit1.Text) then
  begin
    MsgBox(Handle, 'Do you think really the bin will be scrambled ? :P', 'File not found', 48);
    Exit;
  end;

  if sd.Execute = True then
    if ScrambleFile(PChar(Edit1.Text), PChar(sd.FileName)) = True then
      MsgBox(Handle, 'File "' + Edit1.Text + '" scrambled.', 'Information', 64)
    else MsgBox(Handle, 'Scramble operation failed !', 'This DLL is making me crazy :P', 48);
end;

procedure TMain_Form.Button4Click(Sender: TObject);
begin
  if not FileExists(Edit1.Text) then
  begin
    MsgBox(Handle, 'OK... please retry with a valid filename, huh ! :P', 'File not found', 48);
    Exit;
  end;

  if sd.Execute = True then
    if UnscrambleFile(PChar(Edit1.Text), PChar(sd.FileName)) = True then
      MsgBox(Handle, 'File "' + Edit1.Text + '" unscrambled.', 'Information', 64)
    else MsgBox(Handle, 'Unscramble operation failed !', 'Damn DLL! :P', 48);
end;

procedure TMain_Form.Button5Click(Sender: TObject);
begin
  Close;
end;

procedure TMain_Form.Button6Click(Sender: TObject);
begin
  About_Form.ShowModal;
end;

end.
