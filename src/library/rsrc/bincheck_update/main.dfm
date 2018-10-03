object Main_Form: TMain_Form
  Left = 306
  Top = 139
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Main_Form'
  ClientHeight = 449
  ClientWidth = 505
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lv: TListView
    Left = 8
    Top = 8
    Width = 489
    Height = 321
    Columns = <
      item
        AutoSize = True
        Caption = 'Bytes'
      end
      item
        AutoSize = True
        Caption = 'String'
      end>
    ColumnClick = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object eHex: TEdit
    Left = 8
    Top = 336
    Width = 409
    Height = 21
    TabOrder = 1
  end
  object bAdd: TButton
    Left = 424
    Top = 336
    Width = 75
    Height = 21
    Caption = '&Add'
    TabOrder = 2
    OnClick = bAddClick
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 360
    Width = 489
    Height = 81
    Caption = ' Characters translator : '
    TabOrder = 3
    object eHexTrans: TEdit
      Left = 8
      Top = 52
      Width = 401
      Height = 21
      Color = clBtnFace
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object eChars: TEdit
      Left = 8
      Top = 20
      Width = 401
      Height = 21
      TabOrder = 1
    end
    object bTrans: TButton
      Left = 416
      Top = 20
      Width = 65
      Height = 53
      Caption = '&Translate'
      TabOrder = 2
      OnClick = bTransClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 80
    Top = 40
    object File1: TMenuItem
      Caption = '&File'
      object Open1: TMenuItem
        Caption = '&Open'
        OnClick = Open1Click
      end
      object Exit1: TMenuItem
        Caption = '&Exit'
        OnClick = Exit1Click
      end
    end
  end
  object odTarget: TOpenDialog
    Left = 16
    Top = 40
  end
  object XPManifest: TXPManifest
    Left = 48
    Top = 40
  end
end
