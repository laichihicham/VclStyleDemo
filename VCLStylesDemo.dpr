program VCLStylesDemo;

uses
  Vcl.Forms,
  styles in 'styles.pas' {frmVclStyles},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := true;
  Application.CreateForm(TfrmVclStyles, frmVclStyles);
  Application.Run;
end.
