unit help;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, ShellApi;

type
  TAbout_Form = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label10: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label5MouseEnter(Sender: TObject);
    procedure Label5MouseLeave(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label5MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label5MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  About_Form: TAbout_Form;

implementation

uses about;

{$R *.dfm}

procedure TAbout_Form.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TAbout_Form.Button2Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TAbout_Form.Label5MouseEnter(Sender: TObject);
begin
  label5.Font.Style := [fsUnderline];
  label5.Cursor := crHandPoint;
end;

procedure TAbout_Form.Label5MouseLeave(Sender: TObject);
begin
  label5.Font.Style := [];
  label5.Cursor := crDefault;
end;

procedure TAbout_Form.Label5Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.consolevision.com/members/fackue/',
    '', '', SW_SHOWNORMAL);
end;

procedure TAbout_Form.Label5MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  label5.Font.Color := clRed;
end;

procedure TAbout_Form.Label5MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  label5.Font.Color := clBlue;
end;

end.
