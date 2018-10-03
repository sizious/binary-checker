program checker;

uses
  Forms,
  main in 'main.pas' {Main_Form},
  about in 'About.pas' {AboutBox},
  help in 'help.pas' {About_Form};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TAbout_Form, About_Form);
  Application.Run;
end.
