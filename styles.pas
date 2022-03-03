// ---------------------------------------------//
// ---------------------------------------------//
// --------------Hicham Laichi------------------//
// -------------Embarcadero MVP-----------------//
// ---------------27-02-2022--------------------//
// ---------------------------------------------//
// ---------------------------------------------//

unit styles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Themes,
  Vcl.styles, Inifiles, ShellAPI;

type
  TfrmVclStyles = class(TForm)
    stylesList: TListBox;
    addNew: TButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    browStyles: TOpenDialog;
    deleteStyle: TButton;
    procedure stylesListDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure deleteStyleClick(Sender: TObject);
    procedure addNewClick(Sender: TObject);
  private
    { Private declarations }
    SettingINI: TIniFile;
    procedure StylesListRefresh;
    procedure ReadStylesINI;
    procedure WriteStylesINI;
    procedure deleteStyleINI;
    procedure addNewStyle;
    procedure restartApp;
    procedure runStyle(const styleName: string);
  public
    { Public declarations }
  end;

var
  frmVclStyles: TfrmVclStyles;

implementation

{$R *.dfm}
{ TfrmVclStyles }

procedure TfrmVclStyles.ReadStylesINI;
var
  List: TStringList;
  i: integer;
  key: String;
  Value: String;
begin
  SettingINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    List := TStringList.Create;
    try
      stylesList.Items.Clear;
      SettingINI.ReadSectionValues('Styles', List);
      for i := 1 to List.Count - 1 do
      begin
        key := List.Names[i];
        Value := List.Values[key];
        var
        stylePath := ExtractFilePath(Application.ExeName) + 'styles\' +
          Value + '.vsf';
        if TStyleManager.IsValidStyle(stylePath) then
        begin
          TStyleManager.LoadFromFile(stylePath);
          StylesListRefresh;
        end;
      end;
    finally
      List.Free;
    end;
    if SettingINI.readString('DefaultStyle', 'CurrStyle', '') = 'Windows' then
      exit;
    if SettingINI.readString('DefaultStyle', 'CurrStyle', '') = '' then
      exit;
    TStyleManager.SetStyle(SettingINI.readString('DefaultStyle',
      'CurrStyle', ''));
  finally
    FreeAndNil(SettingINI);
  end;
end;

procedure TfrmVclStyles.WriteStylesINI;
var
  i: integer;
begin
  SettingINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    for i := 1 to stylesList.Count - 1 do
      SettingINI.DeleteKey('Styles', i.ToString);
    for i := 0 to stylesList.Count - 1 do
      SettingINI.WriteString('Styles', i.ToString,
        StringReplace(stylesList.Items[i], ' ', '', [rfReplaceAll]));
  finally
    FreeAndNil(SettingINI);
  end;
end;

procedure TfrmVclStyles.addNewClick(Sender: TObject);
begin
  addNewStyle;
end;

procedure TfrmVclStyles.addNewStyle;
var
  fileName: string;
begin
  browStyles.InitialDir := ExtractFilePath(Application.ExeName) + 'styles\';
  if browStyles.Execute then
  begin
    fileName := browStyles.fileName;
    if TStyleManager.IsValidStyle(fileName) then
    begin
      try
        TStyleManager.LoadFromFile(fileName);
        StylesListRefresh;
      except
        ShowMessage('This style already registered !');
      end;
    end
    else
      ShowMessage('The file is not a valid VCL Style !');
  end;
end;

procedure TfrmVclStyles.deleteStyleClick(Sender: TObject);
begin
  if stylesList.ItemIndex < 0 then
    exit;
  deleteStyleINI;
end;

procedure TfrmVclStyles.deleteStyleINI;
var
  i: integer;
begin
  SettingINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    if stylesList.Items[stylesList.ItemIndex] = SettingINI.readString
      ('DefaultStyle', 'CurrStyle', '') then
    begin
      ShowMessage('You can''t delete this style because it''s the default !');
      exit;
    end;
    if stylesList.ItemIndex = 0 then
    begin
      ShowMessage('You can''t delete the system style');
      exit;
    end;

    for i := 0 to stylesList.Count - 1 do
      SettingINI.DeleteKey('Styles', i.ToString);
    stylesList.Items.Delete(stylesList.ItemIndex);
    for i := 0 to stylesList.Count - 1 do
      SettingINI.WriteString('Styles', i.ToString,
        StringReplace(stylesList.Items[i], ' ', '', [rfReplaceAll]));

    restartApp;

  finally
    FreeAndNil(SettingINI);
  end;
end;

procedure TfrmVclStyles.restartApp;
begin
  ShellExecute(Handle, nil, PChar(Application.ExeName), nil, nil,
    SW_SHOWNORMAL);
  Application.Terminate;
end;

procedure TfrmVclStyles.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteStylesINI;
end;

procedure TfrmVclStyles.FormCreate(Sender: TObject);
begin
  ReadStylesINI;
end;

procedure TfrmVclStyles.stylesListDblClick(Sender: TObject);
begin
  runStyle(stylesList.Items[stylesList.ItemIndex]);
end;

procedure TfrmVclStyles.runStyle(const styleName: string);
begin
  if stylesList.ItemIndex < 0 then
    exit;
  TStyleManager.SetStyle(styleName);
  var
  SettingINI := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));
  try
    SettingINI.WriteString('DefaultStyle', 'CurrStyle',
      stylesList.Items[stylesList.ItemIndex]);
  finally
    FreeAndNil(SettingINI);
  end;
end;

procedure TfrmVclStyles.StylesListRefresh;
var
  styleName: string;
begin
  stylesList.Clear;
  for styleName in TStyleManager.StyleNames do
    stylesList.Items.Add(styleName);
  // stylesList.ItemIndex := stylesList.Count - 1;
end;

end.
