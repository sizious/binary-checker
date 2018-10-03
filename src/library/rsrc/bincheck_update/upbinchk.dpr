program upbinchk;

uses
  Forms,
  main in 'main.pas' {Main_Form},
  utils in 'utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMain_Form, Main_Form);
  Application.Run;
end.
