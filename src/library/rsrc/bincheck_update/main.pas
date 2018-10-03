unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ComCtrls, XPMan, Mask;

type
  TMain_Form = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    odTarget: TOpenDialog;
    lv: TListView;
    XPManifest: TXPManifest;
    eHex: TEdit;
    bAdd: TButton;
    GroupBox1: TGroupBox;
    eHexTrans: TEdit;
    eChars: TEdit;
    bTrans: TButton;
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure bTransClick(Sender: TObject);
    procedure bAddClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Main_Form: TMain_Form;

implementation

{$R *.dfm}

uses utils;

procedure TMain_Form.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMain_Form.Open1Click(Sender: TObject);
var
  Chrs, Bytes : TStringList;
  
begin
  with odTarget do
    if Execute then
    begin
      Chrs := TStringList.Create;
      try

        Bytes := TStringList.Create;
        try
          OpenList(FileName, Chrs, Bytes);
          LoadListView(lv, Chrs, Bytes);
        finally
          Bytes.Free;
        end;

      finally
        Chrs.Free;
      end;
    end;
end;


procedure TMain_Form.bTransClick(Sender: TObject);
var
  i   : integer;
  str : string;

begin
  eHexTrans.Clear;
  str := eChars.Text;

  for i := 1 to Length(str) do
    eHexTrans.Text := eHexTrans.Text + IntToHex(Ord(str[i]), 2) + ' ';
end;

procedure TMain_Form.bAddClick(Sender: TObject);
begin
  with lv.Items.Add do
  begin
    Caption := eHex.Text;
  end;
end;

end.
