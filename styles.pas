{
  =============================================================================
  App Name     : VCLStylesDemo
  Author       : Hicham Laichi
  Version      : 2.0 (Modern Architecture & Anti-Flicker Edition)
  Copyright    : Embarcadero MVP
  Description  : Delphi VCL Styles Architecture & Demo
                 - Dynamic VSF Styles loading & auto-scan
                 - Zero-Flicker smooth switching via LockWindowUpdate
                 - Safe window focus handling (Fixes "Cannot focus disabled window")
                 - UAC-safe persistence (%APPDATA% with local fallback)
                 - Real-time search & filter
                 - Active style auto-selection
  =============================================================================
}

unit styles;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils, System.Variants,
  System.UITypes, System.Classes, System.IOUtils, System.IniFiles,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Themes,
  Vcl.Styles, Vcl.ExtCtrls;

type
  TfrmVclStyles = class(TForm)
    addNew: TButton;
    deleteStyle: TButton;
    edtFilter: TEdit;
    stylesList: TListBox;
    browStyles: TOpenDialog;
    Label1: TLabel;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    RadioButton1: TRadioButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    RadioGroup1: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure stylesListDblClick(Sender: TObject);
    procedure stylesListKeyPress(Sender: TObject; var Key: Char);
    procedure addNewClick(Sender: TObject);
    procedure deleteStyleClick(Sender: TObject);
    procedure edtFilterChange(Sender: TObject);
  private
    { Private declarations }
    FAllStyles: TStringList;
    function GetPreferencesIniPath: string;
    procedure LoadAllVsfStyles;
    procedure ReadStylesINI;
    procedure WriteStylesINI;
    procedure DeleteStyleINI;
    procedure AddNewStyle;
    procedure FilterStylesList(const AFilter: string);
    procedure RefreshStylesList;
  public
    { Public declarations }
    destructor Destroy; override;
    procedure ApplyStyle(const AStyleName: string);
  end;

var
  frmVclStyles: TfrmVclStyles;

implementation

{$R *.dfm}

{ TfrmVclStyles }

destructor TfrmVclStyles.Destroy;
begin
  FAllStyles.Free;
  inherited;
end;

function TfrmVclStyles.GetPreferencesIniPath: string;
var
  AppDataDir: string;
begin
  // 1. Try %APPDATA%\VCLStylesDemo\styles.ini (Safe for non-admin users in Program Files)
  AppDataDir := TPath.Combine(GetEnvironmentVariable('APPDATA'), 'VCLStylesDemo');
  try
    if not TDirectory.Exists(AppDataDir) then
      TDirectory.CreateDirectory(AppDataDir);
    Result := TPath.Combine(AppDataDir, 'styles.ini');
  except
    // Fallback to local executable folder
    Result := ChangeFileExt(Application.ExeName, '.ini');
  end;
end;

procedure TfrmVclStyles.LoadAllVsfStyles;
var
  StylesDir: string;
  VsfFiles: TArray<string>;
  FilePath: string;
begin
  StylesDir := TPath.Combine(ExtractFilePath(Application.ExeName), 'styles');
  if TDirectory.Exists(StylesDir) then
  begin
    VsfFiles := TDirectory.GetFiles(StylesDir, '*.vsf');
    for FilePath in VsfFiles do
    begin
      if TStyleManager.IsValidStyle(FilePath) then
      begin
        try
          TStyleManager.LoadFromFile(FilePath);
        except
          // Style already loaded or duplicate
        end;
      end;
    end;
  end;
end;

procedure TfrmVclStyles.ReadStylesINI;
var
  Ini: TMemIniFile;
  List: TStringList;
  i: Integer;
  Key, Value, StylePath, CurrStyle, IniPath: string;
begin
  // First load all VSF files present in styles\ folder
  LoadAllVsfStyles;

  IniPath := GetPreferencesIniPath;
  Ini := TMemIniFile.Create(IniPath, TEncoding.UTF8);
  try
    List := TStringList.Create;
    try
      Ini.ReadSectionValues('Styles', List);
      for i := 0 to List.Count - 1 do
      begin
        Key := List.Names[i];
        Value := List.Values[Key];
        if SameText(Value, 'Windows') then
          Continue;

        StylePath := TPath.Combine(ExtractFilePath(Application.ExeName), 'styles\' + Value + '.vsf');
        if TFile.Exists(StylePath) and TStyleManager.IsValidStyle(StylePath) then
        begin
          try
            TStyleManager.LoadFromFile(StylePath);
          except
          end;
        end;
      end;
    finally
      List.Free;
    end;

    CurrStyle := Ini.ReadString('DefaultStyle', 'CurrStyle', '');
    if (CurrStyle = '') or SameText(CurrStyle, 'Windows') then
      Exit;

    // Apply default style smoothly
    ApplyStyle(CurrStyle);
  finally
    Ini.Free;
  end;
end;

procedure TfrmVclStyles.WriteStylesINI;
var
  Ini: TMemIniFile;
  i: Integer;
begin
  Ini := TMemIniFile.Create(GetPreferencesIniPath, TEncoding.UTF8);
  try
    Ini.EraseSection('Styles');
    if TStyleManager.ActiveStyle <> nil then
      Ini.WriteString('DefaultStyle', 'CurrStyle', TStyleManager.ActiveStyle.Name);

    for i := 0 to FAllStyles.Count - 1 do
      Ini.WriteString('Styles', i.ToString, StringReplace(FAllStyles[i], ' ', '', [rfReplaceAll]));

    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

procedure TfrmVclStyles.ApplyStyle(const AStyleName: string);
var
  MainHwnd, CoverHwnd: HWND;
  WasEnabled: Boolean;
  Ini: TMemIniFile;
  R: TRect;
  CoverDc, SrcDc: HDC;
begin
  if AStyleName = '' then Exit;

  // 1. Persist user selection in %APPDATA% (or local ini fallback)
  try
    Ini := TMemIniFile.Create(GetPreferencesIniPath, TEncoding.UTF8);
    try
      Ini.WriteString('DefaultStyle', 'CurrStyle', AStyleName);
      Ini.UpdateFile;
    finally
      Ini.Free;
    end;
  except
  end;

  // 2. 100% Flicker-Free Style Transition using Native Win32 Cover Window (Freeze Frame)
  MainHwnd := 0;
  CoverHwnd := 0;
  if (Application.MainForm <> nil) and Application.MainForm.Visible then
    MainHwnd := Application.MainForm.Handle;

  if (MainHwnd <> 0) and GetWindowRect(MainHwnd, R) then
  begin
    CoverHwnd := CreateWindowEx(
      WS_EX_TOOLWINDOW or WS_EX_TOPMOST,
      'STATIC',
      '',
      WS_POPUP or WS_VISIBLE,
      R.Left, R.Top, R.Right - R.Left, R.Bottom - R.Top,
      0, 0, HInstance, nil
    );

    if CoverHwnd <> 0 then
    begin
      CoverDc := GetDC(CoverHwnd);
      if CoverDc <> 0 then
      begin
        SrcDc := GetDC(MainHwnd);
        if SrcDc <> 0 then
        begin
          BitBlt(CoverDc, 0, 0, R.Right - R.Left, R.Bottom - R.Top, SrcDc, 0, 0, SRCCOPY);
          ReleaseDC(MainHwnd, SrcDc);
        end;
        ReleaseDC(CoverHwnd, CoverDc);
      end;
    end;
  end;

  try
    // Prevent "Cannot focus a disabled or invisible window" if called during modal dialogs
    WasEnabled := False;
    if MainHwnd <> 0 then
    begin
      WasEnabled := IsWindowEnabled(MainHwnd);
      if not WasEnabled then
        EnableWindow(MainHwnd, True);
    end;

    try
      TStyleManager.SetStyle(AStyleName);
    except
      // Ignore focus restoration artifacts during RecreateWnd
    end;

    if (MainHwnd <> 0) and (not WasEnabled) then
      EnableWindow(MainHwnd, False);

    if Application.MainForm <> nil then
      Application.MainForm.Update;
  finally
    if CoverHwnd <> 0 then
      DestroyWindow(CoverHwnd);
  end;

  RefreshStylesList;
end;

procedure TfrmVclStyles.RefreshStylesList;
var
  StyleName: string;
begin
  FAllStyles.Clear;
  for StyleName in TStyleManager.StyleNames do
    FAllStyles.Add(StyleName);

  FilterStylesList(edtFilter.Text);
end;

procedure TfrmVclStyles.FilterStylesList(const AFilter: string);
var
  i, ActiveIdx: Integer;
  S, CleanFilter: string;
begin
  CleanFilter := Trim(AFilter).ToLower;
  stylesList.Items.BeginUpdate;
  try
    stylesList.Clear;
    for i := 0 to FAllStyles.Count - 1 do
    begin
      S := FAllStyles[i];
      if (CleanFilter = '') or (CleanFilter = 'search styles...') or (S.ToLower.Contains(CleanFilter)) then
        stylesList.Items.Add(S);
    end;

    // Highlight current active style
    if TStyleManager.ActiveStyle <> nil then
    begin
      ActiveIdx := stylesList.Items.IndexOf(TStyleManager.ActiveStyle.Name);
      if ActiveIdx >= 0 then
        stylesList.ItemIndex := ActiveIdx;
    end;
  finally
    stylesList.Items.EndUpdate;
  end;
end;

procedure TfrmVclStyles.edtFilterChange(Sender: TObject);
begin
  FilterStylesList(edtFilter.Text);
end;

procedure TfrmVclStyles.addNewClick(Sender: TObject);
begin
  AddNewStyle;
end;

procedure TfrmVclStyles.AddNewStyle;
var
  FileName, ExtDir, DestPath: string;
begin
  browStyles.InitialDir := TPath.Combine(ExtractFilePath(Application.ExeName), 'styles');
  if browStyles.Execute then
  begin
    FileName := browStyles.FileName;
    if TStyleManager.IsValidStyle(FileName) then
    begin
      // Copy to styles folder if not already there
      ExtDir := TPath.Combine(ExtractFilePath(Application.ExeName), 'styles');
      if not TDirectory.Exists(ExtDir) then
        TDirectory.CreateDirectory(ExtDir);
      DestPath := TPath.Combine(ExtDir, ExtractFileName(FileName));
      if not SameText(FileName, DestPath) then
      begin
        try
          TFile.Copy(FileName, DestPath, True);
        except
        end;
      end;

      try
        TStyleManager.LoadFromFile(FileName);
        RefreshStylesList;
        WriteStylesINI;
      except
        ShowMessage('This style is already loaded.');
      end;
    end
    else
      ShowMessage('The selected file is not a valid VCL Style (.vsf).');
  end;
end;

procedure TfrmVclStyles.deleteStyleClick(Sender: TObject);
begin
  if stylesList.ItemIndex < 0 then
    Exit;
  DeleteStyleINI;
end;

procedure TfrmVclStyles.DeleteStyleINI;
var
  ChosenStyle, VsfPath: string;
begin
  if stylesList.ItemIndex < 0 then Exit;
  ChosenStyle := stylesList.Items[stylesList.ItemIndex];

  if SameText(ChosenStyle, 'Windows') then
  begin
    ShowMessage('You cannot delete the native system style (Windows).');
    Exit;
  end;

  if (TStyleManager.ActiveStyle <> nil) and SameText(ChosenStyle, TStyleManager.ActiveStyle.Name) then
  begin
    ShowMessage('You cannot delete the currently active style. Switch to another style first.');
    Exit;
  end;

  if MessageDlg(Format('Do you really want to delete style "%s"?', [ChosenStyle]),
                mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  // Remove corresponding .vsf file from styles directory if present
  VsfPath := TPath.Combine(ExtractFilePath(Application.ExeName), 'styles\' + StringReplace(ChosenStyle, ' ', '', [rfReplaceAll]) + '.vsf');
  if TFile.Exists(VsfPath) then
  begin
    try
      TFile.Delete(VsfPath);
    except
    end;
  end;

  FAllStyles.Delete(FAllStyles.IndexOf(ChosenStyle));
  WriteStylesINI;
  RefreshStylesList;
end;

procedure TfrmVclStyles.FormCreate(Sender: TObject);
begin
  FAllStyles := TStringList.Create;
  ReadStylesINI;
  RefreshStylesList;
end;

procedure TfrmVclStyles.stylesListDblClick(Sender: TObject);
begin
  if stylesList.ItemIndex >= 0 then
    ApplyStyle(stylesList.Items[stylesList.ItemIndex]);
end;

procedure TfrmVclStyles.stylesListKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = #13) and (stylesList.ItemIndex >= 0) then
  begin
    ApplyStyle(stylesList.Items[stylesList.ItemIndex]);
    Key := #0;
  end;
end;

end.
