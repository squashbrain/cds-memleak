object frmMainForm: TfrmMainForm
  Left = 0
  Top = 0
  Caption = 'Memory Datasets - Mem leak test harness'
  ClientHeight = 575
  ClientWidth = 969
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 508
    Top = 73
    Width = 239
    Height = 23
    Caption = 'Current Memory Useage:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 579
    Top = 24
    Width = 168
    Height = 23
    Caption = 'Starting Memory:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
  end
  object grdTestData: TcxGrid
    Left = 8
    Top = 209
    Width = 953
    Height = 249
    TabOrder = 0
    object tblTestData: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = dsTest
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      object tblTestDataFIRSTNAME: TcxGridDBColumn
        Caption = 'First Name'
        DataBinding.FieldName = 'FIRSTNAME'
        Width = 120
      end
      object tblTestDataLASTNAME: TcxGridDBColumn
        Caption = 'Last Name'
        DataBinding.FieldName = 'LASTNAME'
        Width = 120
      end
      object tblTestDataADDRESS1: TcxGridDBColumn
        Caption = 'Address 1'
        DataBinding.FieldName = 'ADDRESS1'
        Width = 170
      end
      object tblTestDataADDRESS2: TcxGridDBColumn
        Caption = 'Address 2'
        DataBinding.FieldName = 'ADDRESS2'
        Width = 170
      end
      object tblTestDataCITY: TcxGridDBColumn
        Caption = 'City'
        DataBinding.FieldName = 'CITY'
        Width = 130
      end
      object tblTestDataSTATE: TcxGridDBColumn
        Caption = 'ST'
        DataBinding.FieldName = 'STATE'
        Width = 30
      end
      object tblTestDataZIP: TcxGridDBColumn
        Caption = 'Zip'
        DataBinding.FieldName = 'ZIP'
        Width = 70
      end
      object tblTestDataRECORDDATE: TcxGridDBColumn
        Caption = 'Date Added'
        DataBinding.FieldName = 'RECORDDATE'
        Width = 90
      end
    end
    object lvlTestData: TcxGridLevel
      GridView = tblTestData
    end
  end
  object btnRunTest: TButton
    Left = 719
    Top = 167
    Width = 105
    Height = 36
    Caption = 'Run Single Test'
    TabOrder = 1
    OnClick = btnRunTestClick
  end
  object pnlMemUsed: TPanel
    Left = 751
    Top = 55
    Width = 210
    Height = 41
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -19
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object pnlStartingMem: TPanel
    Left = 751
    Top = 8
    Width = 210
    Height = 41
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
  end
  object edtMaxRecords: TLabeledEdit
    Left = 8
    Top = 100
    Width = 121
    Height = 21
    EditLabel.Width = 62
    EditLabel.Height = 13
    EditLabel.Caption = 'Max Records'
    NumbersOnly = True
    TabOrder = 4
    Text = '1000'
  end
  object chkJumpToFirstAfterTest: TCheckBox
    Left = 8
    Top = 127
    Width = 201
    Height = 17
    Caption = 'Jump to first record after each test'
    TabOrder = 5
  end
  object memLog: TMemo
    Left = 0
    Top = 464
    Width = 969
    Height = 92
    Align = alBottom
    Color = cl3DDkShadow
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Lines.Strings = (
      'memLog')
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object rbShowInBytes: TRadioButton
    Left = 843
    Top = 102
    Width = 49
    Height = 17
    Caption = 'Bytes'
    Checked = True
    TabOrder = 7
    TabStop = True
  end
  object rbShowInKB: TRadioButton
    Left = 898
    Top = 102
    Width = 63
    Height = 17
    Caption = 'kilobytes'
    TabOrder = 8
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 193
    Height = 68
    Caption = 'Dataset Type'
    TabOrder = 9
    object rbMidas: TRadioButton
      Left = 18
      Top = 20
      Width = 143
      Height = 17
      Caption = 'TClientDataset - Midas'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object rbFireDac: TRadioButton
      Left = 18
      Top = 43
      Width = 143
      Height = 17
      Caption = 'FDMemTable - FireDAC'
      TabOrder = 1
    end
  end
  object btnReset: TButton
    Left = 600
    Top = 167
    Width = 105
    Height = 36
    Caption = 'Reset'
    TabOrder = 10
    OnClick = btnResetClick
  end
  object edtTestCount: TLabeledEdit
    Left = 914
    Top = 146
    Width = 45
    Height = 21
    EditLabel.Width = 53
    EditLabel.Height = 13
    EditLabel.Caption = 'Test Count'
    LabelPosition = lpLeft
    NumbersOnly = True
    TabOrder = 11
    Text = '1000'
  end
  object btnAutoTest: TButton
    Left = 856
    Top = 167
    Width = 105
    Height = 36
    Caption = 'Auto Test'
    TabOrder = 12
    OnClick = btnAutoTestClick
  end
  object memLeakStatus: TStatusBar
    Left = 0
    Top = 556
    Width = 969
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object chkShowDataInGrid: TCheckBox
    Left = 8
    Top = 186
    Width = 137
    Height = 17
    Caption = 'Show data in Grid'
    Checked = True
    State = cbChecked
    TabOrder = 14
  end
  object GroupBox2: TGroupBox
    Left = 215
    Top = 100
    Width = 178
    Height = 59
    TabOrder = 15
    object edtRandomDeleteCount: TLabeledEdit
      Left = 35
      Top = 28
      Width = 121
      Height = 21
      EditLabel.Width = 63
      EditLabel.Height = 13
      EditLabel.Caption = 'Delete Count'
      NumbersOnly = True
      TabOrder = 0
      Text = '50'
    end
  end
  object chkDeleteRandomRecords: TCheckBox
    Left = 221
    Top = 92
    Width = 137
    Height = 17
    Caption = 'Delete random records '
    TabOrder = 16
    OnClick = chkDeleteRandomRecordsClick
  end
  object GroupBox3: TGroupBox
    Left = 215
    Top = 17
    Width = 178
    Height = 59
    TabOrder = 17
    object edtRandomEditCount: TLabeledEdit
      Left = 33
      Top = 28
      Width = 121
      Height = 21
      EditLabel.Width = 50
      EditLabel.Height = 13
      EditLabel.Caption = 'Edit Count'
      NumbersOnly = True
      TabOrder = 0
      Text = '50'
    end
  end
  object chkEditRandomRecords: TCheckBox
    Left = 221
    Top = 9
    Width = 137
    Height = 17
    Caption = 'Edit random records '
    TabOrder = 18
    OnClick = chkEditRandomRecordsClick
  end
  object tmrSystem: TTimer
    Enabled = False
    Interval = 100
    OnTimer = tmrSystemTimer
    Left = 472
    Top = 24
  end
  object cdsTest: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterClose = cdsTestAfterClose
    AfterPost = cdsTestAfterPost
    Left = 256
    Top = 312
    object cdsTestFIRSTNAME: TStringField
      FieldName = 'FIRSTNAME'
      Size = 50
    end
    object cdsTestLASTNAME: TStringField
      FieldName = 'LASTNAME'
      Size = 50
    end
    object cdsTestADDRESS1: TStringField
      FieldName = 'ADDRESS1'
      Size = 120
    end
    object cdsTestADDRESS2: TStringField
      FieldName = 'ADDRESS2'
      Size = 120
    end
    object cdsTestCITY: TStringField
      FieldName = 'CITY'
      Size = 30
    end
    object cdsTestSTATE: TStringField
      FieldName = 'STATE'
      Size = 2
    end
    object cdsTestZIP: TIntegerField
      FieldName = 'ZIP'
    end
    object cdsTestRECORDDATE: TDateField
      FieldName = 'RECORDDATE'
    end
  end
  object dsTest: TDataSource
    DataSet = cdsTest
    Left = 232
    Top = 368
  end
  object fdsTest: TFDMemTable
    AfterClose = fdsTestAfterClose
    AfterPost = fdsTestAfterPost
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    FormatOptions.AssignedValues = [fvMaxBcdPrecision, fvMaxBcdScale]
    FormatOptions.MaxBcdPrecision = 2147483647
    FormatOptions.MaxBcdScale = 2147483647
    ResourceOptions.AssignedValues = [rvPersistent, rvSilentMode]
    ResourceOptions.Persistent = True
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvUpdateChngFields, uvUpdateMode, uvLockMode, uvLockWait, uvRefreshMode, uvCheckRequired, uvCheckReadOnly, uvCheckUpdatable]
    UpdateOptions.LockWait = True
    UpdateOptions.CheckRequired = False
    AutoCommitUpdates = False
    StoreDefs = True
    Left = 200
    Top = 312
    object fdsTestFIRSTNAME: TStringField
      FieldName = 'FIRSTNAME'
      Size = 50
    end
    object fdsTestLASTNAME: TStringField
      FieldName = 'LASTNAME'
      Size = 50
    end
    object fdsTestADDRESS1: TStringField
      FieldName = 'ADDRESS1'
      Size = 120
    end
    object fdsTestADDRESS2: TStringField
      FieldName = 'ADDRESS2'
      Size = 120
    end
    object fdsTestCITY: TStringField
      FieldName = 'CITY'
      Size = 30
    end
    object fdsTestSTATE: TStringField
      FieldName = 'STATE'
      Size = 2
    end
    object fdsTestZIP: TIntegerField
      FieldName = 'ZIP'
    end
    object fdsTestRECORDDATE: TDateField
      FieldName = 'RECORDDATE'
    end
  end
end
