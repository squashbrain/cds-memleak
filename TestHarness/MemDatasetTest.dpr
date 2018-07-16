program MemDatasetTest;

uses
  Vcl.Forms,
  MidasLib,
  f_MainForm in 'f_MainForm.pas' {frmMainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
