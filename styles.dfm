object frmVclStyles: TfrmVclStyles
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'VCL Styles'
  ClientHeight = 420
  ClientWidth = 459
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
    Top = 35
    Width = 34
    Height = 15
    Caption = 'Label1'
  end
  object stylesList: TListBox
    Left = 16
    Top = 39
    Width = 217
    Height = 370
    ItemHeight = 15
    TabOrder = 0
    OnDblClick = stylesListDblClick
  end
  object addNew: TButton
    Left = 16
    Top = 8
    Width = 106
    Height = 25
    Caption = 'Add Style'
    TabOrder = 1
    OnClick = addNewClick
  end
  object ComboBox1: TComboBox
    Left = 256
    Top = 56
    Width = 153
    Height = 23
    TabOrder = 2
    Text = 'ComboBox1'
  end
  object CheckBox1: TCheckBox
    Left = 256
    Top = 96
    Width = 97
    Height = 17
    Caption = 'CheckBox1'
    TabOrder = 3
  end
  object CheckBox2: TCheckBox
    Left = 256
    Top = 120
    Width = 97
    Height = 17
    Caption = 'CheckBox2'
    TabOrder = 4
  end
  object deleteStyle: TButton
    AlignWithMargins = True
    Left = 128
    Top = 8
    Width = 105
    Height = 25
    Caption = 'Delete Style'
    TabOrder = 5
    OnClick = deleteStyleClick
  end
  object RadioGroup1: TRadioGroup
    Left = 256
    Top = 317
    Width = 185
    Height = 92
    Caption = 'RadioGroup1'
    Items.Strings = (
      'Test1'
      'Test2')
    TabOrder = 6
  end
  object RadioButton1: TRadioButton
    Left = 280
    Top = 152
    Width = 113
    Height = 17
    Caption = 'RadioButton1'
    TabOrder = 7
  end
  object GroupBox1: TGroupBox
    Left = 256
    Top = 192
    Width = 185
    Height = 105
    Caption = 'GroupBox1'
    TabOrder = 8
    object Edit1: TEdit
      Left = 24
      Top = 32
      Width = 121
      Height = 23
      TabOrder = 0
      Text = 'Edit1'
    end
    object Edit2: TEdit
      Left = 24
      Top = 64
      Width = 121
      Height = 23
      TabOrder = 1
      Text = 'Edit2'
    end
    object Edit3: TEdit
      Left = 184
      Top = 96
      Width = 121
      Height = 23
      TabOrder = 2
      Text = 'Edit3'
    end
  end
  object browStyles: TOpenDialog
    Filter = 'style file|*.vsf'
    Left = 408
    Top = 8
  end
end
