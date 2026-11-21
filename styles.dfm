object frmVclStyles: TfrmVclStyles
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'VCL Styles Architecture & Demo'
  ClientHeight = 425
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 256
    Top = 16
    Width = 140
    Height = 15
    Caption = 'Preview Active Components:'
  end
  object addNew: TButton
    Left = 16
    Top = 10
    Width = 105
    Height = 26
    Caption = '+ Add Style'
    TabOrder = 0
    OnClick = addNewClick
  end
  object deleteStyle: TButton
    Left = 127
    Top = 10
    Width = 105
    Height = 26
    Caption = '✕ Delete Style'
    TabOrder = 1
    OnClick = deleteStyleClick
  end
  object edtFilter: TEdit
    Left = 16
    Top = 42
    Width = 216
    Height = 23
    Hint = 'Search styles...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    TextHint = '🔍 Search styles...'
    OnChange = edtFilterChange
  end
  object stylesList: TListBox
    Left = 16
    Top = 71
    Width = 216
    Height = 342
    ItemHeight = 15
    Sorted = True
    TabOrder = 3
    OnDblClick = stylesListDblClick
    OnKeyPress = stylesListKeyPress
  end
  object ComboBox1: TComboBox
    Left = 256
    Top = 40
    Width = 200
    Height = 23
    ItemIndex = 0
    TabOrder = 4
    Text = 'Delphi VCL Style ComboBox'
    Items.Strings = (
      'Delphi VCL Style ComboBox'
      'Option A (Fluent Design)'
      'Option B (Dark Theme)')
  end
  object CheckBox1: TCheckBox
    Left = 256
    Top = 75
    Width = 120
    Height = 17
    Caption = 'Smooth Transition'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object CheckBox2: TCheckBox
    Left = 256
    Top = 98
    Width = 120
    Height = 17
    Caption = 'Auto Save Setting'
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object RadioButton1: TRadioButton
    Left = 256
    Top = 124
    Width = 120
    Height = 17
    Caption = 'Active Selection'
    Checked = True
    TabStop = True
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 256
    Top = 152
    Width = 200
    Height = 130
    Caption = 'Input Fields'
    TabOrder = 8
    object Edit1: TEdit
      Left = 16
      Top = 26
      Width = 168
      Height = 23
      TabOrder = 0
      Text = 'Single-line text'
    end
    object Edit2: TEdit
      Left = 16
      Top = 58
      Width = 168
      Height = 23
      TabOrder = 1
      Text = 'Another themed input'
    end
    object Edit3: TEdit
      Left = 16
      Top = 90
      Width = 168
      Height = 23
      TabOrder = 2
      Text = 'Read-only value'
      ReadOnly = True
    end
  end
  object RadioGroup1: TRadioGroup
    Left = 256
    Top = 292
    Width = 200
    Height = 120
    Caption = 'Theme Mode Options'
    ItemIndex = 0
    Items.Strings = (
      'Light Palette'
      'Dark Palette'
      'High Contrast')
    TabOrder = 9
  end
  object browStyles: TOpenDialog
    Filter = 'VCL Style Files (*.vsf)|*.vsf|All Files (*.*)|*.*'
    Title = 'Select VCL Style File'
    Left = 416
    Top = 8
  end
end
