program Trader;

uses
  Forms,
  fmMain in 'fmMain.pas' {FormMain},
  fmViewImage in 'fmViewImage.pas' {FormViewImage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormViewImage, FormViewImage);
  Application.Run;
end.
