unit f_MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, cxDBData, Vcl.StdCtrls, Vcl.Grids,
  cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, Vcl.ExtCtrls, Vcl.ComCtrls,

  // Midas
  Datasnap.DBClient, Data.DB,

  // Firedac
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageBin;

type
  TfrmMainForm = class(TForm)
    tblTestData: TcxGridDBTableView;
    lvlTestData: TcxGridLevel;
    grdTestData: TcxGrid;
    btnRunTest: TButton;
    tmrSystem: TTimer;
    Label1: TLabel;
    pnlMemUsed: TPanel;
    pnlStartingMem: TPanel;
    Label2: TLabel;
    cdsTest: TClientDataSet;
    dsTest: TDataSource;
    cdsTestFIRSTNAME: TStringField;
    cdsTestLASTNAME: TStringField;
    cdsTestADDRESS1: TStringField;
    cdsTestADDRESS2: TStringField;
    cdsTestCITY: TStringField;
    cdsTestSTATE: TStringField;
    cdsTestZIP: TIntegerField;
    cdsTestRECORDDATE: TDateField;
    tblTestDataFIRSTNAME: TcxGridDBColumn;
    tblTestDataLASTNAME: TcxGridDBColumn;
    tblTestDataADDRESS1: TcxGridDBColumn;
    tblTestDataADDRESS2: TcxGridDBColumn;
    tblTestDataCITY: TcxGridDBColumn;
    tblTestDataSTATE: TcxGridDBColumn;
    tblTestDataZIP: TcxGridDBColumn;
    tblTestDataRECORDDATE: TcxGridDBColumn;
    edtMaxRecords: TLabeledEdit;
    chkJumpToFirstAfterTest: TCheckBox;
    memLog: TMemo;
    rbShowInBytes: TRadioButton;
    rbShowInKB: TRadioButton;
    fdsTest: TFDMemTable;
    GroupBox1: TGroupBox;
    rbMidas: TRadioButton;
    rbFireDac: TRadioButton;
    fdsTestFIRSTNAME: TStringField;
    fdsTestLASTNAME: TStringField;
    fdsTestADDRESS1: TStringField;
    fdsTestADDRESS2: TStringField;
    fdsTestCITY: TStringField;
    fdsTestSTATE: TStringField;
    fdsTestZIP: TIntegerField;
    fdsTestRECORDDATE: TDateField;
    btnReset: TButton;
    edtTestCount: TLabeledEdit;
    btnAutoTest: TButton;
    memLeakStatus: TStatusBar;
    chkShowDataInGrid: TCheckBox;
    GroupBox2: TGroupBox;
    chkDeleteRandomRecords: TCheckBox;
    edtRandomDeleteCount: TLabeledEdit;
    GroupBox3: TGroupBox;
    edtRandomEditCount: TLabeledEdit;
    chkEditRandomRecords: TCheckBox;
    procedure btnRunTestClick(Sender: TObject);
    procedure tmrSystemTimer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnAutoTestClick(Sender: TObject);
    procedure fdsTestAfterPost(DataSet: TDataSet);
    procedure cdsTestAfterPost(DataSet: TDataSet);
    procedure fdsTestAfterClose(DataSet: TDataSet);
    procedure cdsTestAfterClose(DataSet: TDataSet);
    procedure chkDeleteRandomRecordsClick(Sender: TObject);
    procedure chkEditRandomRecordsClick(Sender: TObject);
  private
    FHasInited :Boolean;
    FStartMem:Cardinal;
    FEndMem : Cardinal;
    FCurrentMem:Cardinal;
    FPrevMem:Cardinal;

    // Test FDMemTable
    procedure TestFireDac;

    // Test TClientDataset
    procedure TestMidas;
  public
    { Public declarations }
  end;

var
  frmMainForm: TfrmMainForm;

implementation

uses System.Math, Winapi.PsAPI;

{$R *.dfm}


// Uses windows API to get the WorkingSet mem from the exe process
// Found on Snipplr: https://snipplr.com/view/38214/get-process-memory-usage/
function GetCurrentProcessMemorySize(var nMemSize: Cardinal): Boolean;
var
  nWndHandle, nProcID, nTmpHandle: HWND;
  pPMC: PPROCESS_MEMORY_COUNTERS;
  pPMCSize: Cardinal;
begin
  nWndHandle := Application.Handle;
  if nWndHandle = 0 then
  begin
    Result := False;
    Exit;
  end;
  pPMCSize := SizeOf(PROCESS_MEMORY_COUNTERS);
  GetMem(pPMC, pPMCSize);
  pPMC^.cb := pPMCSize;

  GetWindowThreadProcessId(nWndHandle, @nProcID);
  nTmpHandle := OpenProcess(PROCESS_ALL_ACCESS, False, nProcID);
  if (GetProcessMemoryInfo(nTmpHandle, pPMC, pPMCSize)) then
    nMemSize := pPMC^.WorkingSetSize
  else
    nMemSize := 0;
  FreeMem(pPMC);
  CloseHandle(nTmpHandle);
  Result := True;
end;

// Generate random Alpha data
function RandomData(StringLength: Integer): string;
var
  str: string;
begin
  Randomize;
  //string with all possible chars
  str    := 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = StringLength)
end;

// Generate random Numeric data
function RandomNumericData(NumericLength: Integer): string;
var
  str: string;
begin
  Randomize;
  //string with all possible numbers
  str    := '0123456789';
  Result := '';
  repeat
    Result := Result + str[Random(Length(str)) + 1];
  until (Length(Result) = NumericLength)
end;

procedure TfrmMainForm.btnAutoTestClick(Sender: TObject);
var
  testIdx:Integer;
begin
  for testIdx := 1 to StrToInt(edtTestCount.Text) - 1 do
  begin
    btnRunTestClick(Sender);
    Application.ProcessMessages;
  end;
end;

procedure TfrmMainForm.btnResetClick(Sender: TObject);
begin
  if cdsTest.Active then
    cdsTest.Close;

  cdsTest.CreateDataSet;
  cdsTest.EmptyDataSet;

  if fdsTest.Active then
    fdsTest.Close;

  fdsTest.CreateDataSet;
  fdsTest.EmptyDataSet;
end;

procedure TfrmMainForm.btnRunTestClick(Sender: TObject);
begin
  if rbMidas.Checked then
    TestMidas
  else
    TestFireDac;

  // record mem state after test
  GetCurrentProcessMemorySize(FEndMem);
end;

procedure TfrmMainForm.TestFireDac;
var
   CurrentIdx:Integer;
   CurrentRec:Integer;

   procedure WriteRandomData;
   var
     recDate:TDateTime;
   begin
     fdsTest.FieldByName('FIRSTNAME').AsString := RandomData(RandomRange(5, fdsTest.FieldByName('FIRSTNAME').Size));
     fdsTest.FieldByName('LASTNAME').AsString := RandomData(RandomRange(5, fdsTest.FieldByName('LASTNAME').Size));
     fdsTest.FieldByName('ADDRESS1').AsString := RandomData(RandomRange(5, fdsTest.FieldByName('ADDRESS1').Size));
     fdsTest.FieldByName('ADDRESS2').AsString := RandomData(RandomRange(5, fdsTest.FieldByName('ADDRESS2').Size));
     fdsTest.FieldByName('CITY').AsString := RandomData(RandomRange(5, fdsTest.FieldByName('CITY').Size));
     fdsTest.FieldByName('STATE').AsString := UpperCase(RandomData(2));
     fdsTest.FieldByName('ZIP').AsString := RandomNumericData(5);

     //RECORD DATE
     recDate := EncodeDate(RandomRange(1980,2018), RandomRange(1,12), RandomRange(1,28));
     fdsTest.FieldByName('RECORDDATE').AsDateTime := recDate;
   end;

begin
  try
    dsTest.DataSet := nil;

    // is Log changes checked
    fdsTest.LogChanges := False;

    if (fdsTest.RecordCount > 0) then
    begin

      // change random records
      if chkEditRandomRecords.Checked then
      begin
        fdsTest.First;
        for CurrentIdx := 1 to StrToInt(edtRandomEditCount.Text) do
        begin
          CurrentRec := RandomRange(1, fdsTest.RecordCount);
          while not fdsTest.Eof do
          begin
            if fdsTest.RecNo = CurrentRec then
            begin
              fdsTest.Edit;
              WriteRandomData;
              fdsTest.Post;
              Break;
            end;
            fdsTest.Next;
          end;
        end;
      end;

      // Delete random records
      fdsTest.First;
      for CurrentIdx := 1 to StrToInt(edtRandomDeleteCount.Text) do
      begin
        CurrentRec := RandomRange(1, fdsTest.RecordCount);
        while not fdsTest.Eof do
        begin
          if fdsTest.RecNo = CurrentRec then
          begin
            fdsTest.Delete;
            Break;
          end;
          fdsTest.Next;
        end;
      end;
    end;

    // add random data up to MaxRecord count
    if chkDeleteRandomRecords.Checked then
    begin
      if fdsTest.RecordCount < StrToInt(edtMaxRecords.Text) then
      begin
        for CurrentIdx := fdsTest.RecordCount to StrToInt(edtMaxRecords.Text) - 1 do
        begin
          fdsTest.Append;
          WriteRandomData;
          fdsTest.Post;
        end;
      end;
    end;

    // is Jump to first after test checked
    if chkJumpToFirstAfterTest.Checked then
      fdsTest.First;

    // reconnect grid after load
    if chkShowDataInGrid.Checked then
      dsTest.DataSet := fdsTest;
  except
    On E:Exception do
    begin
      memLog.Lines.Add('Unexpected error: '+E.Message);
    end;
  end;
end;

procedure TfrmMainForm.TestMidas;
var
   CurrentIdx:Integer;
   CurrentRec:Integer;

   procedure WriteRandomData;
   var
     recDate:TDateTime;
   begin
     cdsTest.FieldByName('FIRSTNAME').AsString := RandomData(RandomRange(5, cdsTest.FieldByName('FIRSTNAME').Size));
     cdsTest.FieldByName('LASTNAME').AsString := RandomData(RandomRange(5, cdsTest.FieldByName('LASTNAME').Size));
     cdsTest.FieldByName('ADDRESS1').AsString := RandomData(RandomRange(5, cdsTest.FieldByName('ADDRESS1').Size));
     cdsTest.FieldByName('ADDRESS2').AsString := RandomData(RandomRange(5, cdsTest.FieldByName('ADDRESS2').Size));
     cdsTest.FieldByName('CITY').AsString := RandomData(RandomRange(5, cdsTest.FieldByName('CITY').Size));
     cdsTest.FieldByName('STATE').AsString := UpperCase(RandomData(2));
     cdsTest.FieldByName('ZIP').AsString := RandomNumericData(5);

     //RECORD DATE
     recDate := EncodeDate(RandomRange(1980,2018), RandomRange(1,12), RandomRange(1,28));
     cdsTest.FieldByName('RECORDDATE').AsDateTime := recDate;
   end;

begin
  try
    dsTest.DataSet := nil;

    // is Log changes checked
    cdsTest.LogChanges := False;

    if (cdsTest.RecordCount > 0) then
    begin
      if chkEditRandomRecords.Checked then
      begin
        // change random records
        cdsTest.First;
        for CurrentIdx := 1 to StrToInt(edtRandomEditCount.Text) do
        begin
          CurrentRec := RandomRange(1, cdsTest.RecordCount);
          while not cdsTest.Eof do
          begin
            if cdsTest.RecNo = CurrentRec then
            begin
              cdsTest.Edit;
              WriteRandomData;
              cdsTest.Post;
              Break;
            end;
            cdsTest.Next;
          end;
        end;
      end;

      // Delete random records
      if chkDeleteRandomRecords.Checked then
      begin
        cdsTest.First;
        for CurrentIdx := 1 to StrToInt(edtRandomDeleteCount.Text) do
        begin
          CurrentRec := RandomRange(1, cdsTest.RecordCount);
          while not cdsTest.Eof do
          begin
            if cdsTest.RecNo = CurrentRec then
            begin
              cdsTest.Delete;
              Break;
            end;
            cdsTest.Next;
          end;
        end;
      end;
    end;

    // add random data up to MaxRecord count
    if cdsTest.RecordCount < StrToInt(edtMaxRecords.Text) then
    begin
      for CurrentIdx := cdsTest.RecordCount to StrToInt(edtMaxRecords.Text) - 1 do
      begin
        cdsTest.Append;
        WriteRandomData;
        cdsTest.Post;
      end;
    end;

    // is Jump to first after test checked
    if chkJumpToFirstAfterTest.Checked then
      cdsTest.First;

    // reconnect grid after load
    if chkShowDataInGrid.Checked then
      dsTest.DataSet := cdsTest;
  except
    On E:Exception do
    begin
      memLog.Lines.Add('Unexpected error: '+E.Message);
    end;
  end;
end;

procedure TfrmMainForm.cdsTestAfterClose(DataSet: TDataSet);
begin
  memLeakStatus.SimpleText := 'Grid record count = 0';
end;

procedure TfrmMainForm.cdsTestAfterPost(DataSet: TDataSet);
begin
  memLeakStatus.SimpleText := 'Grid record count = ' + IntToStr(cdsTest.RecordCount);
end;

procedure TfrmMainForm.chkDeleteRandomRecordsClick(Sender: TObject);
begin
  edtRandomDeleteCount.Enabled := chkDeleteRandomRecords.Checked;
end;

procedure TfrmMainForm.chkEditRandomRecordsClick(Sender: TObject);
begin
  edtRandomEditCount.Enabled := chkEditRandomRecords.Checked;
end;

procedure TfrmMainForm.fdsTestAfterClose(DataSet: TDataSet);
begin
  memLeakStatus.SimpleText := 'Grid record count = 0';
end;

procedure TfrmMainForm.fdsTestAfterPost(DataSet: TDataSet);
begin
  memLeakStatus.SimpleText := 'Grid record count = ' + IntToStr(fdsTest.RecordCount);
end;

procedure TfrmMainForm.FormActivate(Sender: TObject);
begin
  if Not FHasInited then
  begin
    // init mem datasets
    cdsTest.CreateDataSet;
    cdsTest.EmptyDataSet;

    fdsTest.CreateDataSet;
    fdsTest.EmptyDataSet;

    //init mem vars
    GetCurrentProcessMemorySize(FStartMem);
    GetCurrentProcessMemorySize(FPrevMem);
    GetCurrentProcessMemorySize(FEndMem);

    memLog.Lines.Clear;
    tmrSystem.Enabled := True;

    chkDeleteRandomRecords.Checked := True;
    chkEditRandomRecords.Checked := True;

    FHasInited := True;
  end;
end;

procedure TfrmMainForm.FormCreate(Sender: TObject);
begin
  FHasInited := False;
end;

procedure TfrmMainForm.tmrSystemTimer(Sender: TObject);
begin
  // get current mem state
  GetCurrentProcessMemorySize(FCurrentMem);

  if rbShowInKB.Checked then
    pnlMemUsed.Caption := Format('%.0nk', [(FCurrentMem div 1024) * 1.0])
  else
    pnlMemUsed.Caption := Format('%.0n', [FCurrentMem * 1.0]);

  if rbShowInKB.Checked then
    pnlStartingMem.Caption := Format('%.0nk', [(FStartMem div 1024) * 1.0])
  else
    pnlStartingMem.Caption := Format('%.0n', [FStartMem * 1.0]);

  // save current for next timer iteration
  FPrevMem := FCurrentMem;
end;




end.
