object frmVclStyles: TfrmVclStyles
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'VCL Styles'
  ClientHeight = 308
  ClientWidth = 434
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
    Height = 250
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
  object browStyles: TOpenDialog
    Filter = 'style file|*.vsf'
    Left = 256
    Top = 144
  end
end
