object Form5: TForm5
  Left = 0
  Top = 0
  Caption = 'Form5'
  ClientHeight = 586
  ClientWidth = 647
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 435
    Width = 647
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitLeft = -16
    ExplicitTop = 302
    ExplicitWidth = 513
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 289
    Width = 647
    Height = 3
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -8
    ExplicitTop = 302
    ExplicitWidth = 513
  end
  object mToken: TMemo
    Left = 0
    Top = 137
    Width = 647
    Height = 152
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    ExplicitLeft = 1
    ExplicitTop = 139
  end
  object mBody: TMemo
    Left = 0
    Top = 292
    Width = 647
    Height = 143
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    ExplicitTop = 190
    ExplicitHeight = 119
  end
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 647
    Height = 96
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 268
      Top = 44
      Width = 36
      Height = 13
      Caption = 'Method'
    end
    object Label2: TLabel
      Left = 52
      Top = 14
      Width = 22
      Height = 13
      Caption = 'User'
    end
    object Label3: TLabel
      Left = 258
      Top = 14
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object Label4: TLabel
      Left = 29
      Top = 44
      Width = 45
      Height = 13
      Caption = 'Resource'
    end
    object btnGet: TButton
      AlignWithMargins = True
      Left = 447
      Top = 11
      Width = 114
      Height = 38
      Caption = 'Send request'
      TabOrder = 0
      OnClick = btnGetClick
    end
    object Panel2: TPanel
      Left = 1
      Top = 72
      Width = 645
      Height = 23
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object chkRememberMe: TCheckBox
        AlignWithMargins = True
        Left = 4
        Top = 3
        Width = 165
        Height = 17
        Margins.Left = 4
        Align = alLeft
        Caption = 'Remember me for longer time'
        TabOrder = 0
        ExplicitHeight = 29
      end
    end
    object cmbMethod: TComboBox
      Left = 312
      Top = 41
      Width = 120
      Height = 21
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 2
      Text = 'GET'
      Items.Strings = (
        'GET'
        'POST'
        'PUT'
        'DELETE')
    end
    object edResource: TEdit
      Left = 80
      Top = 41
      Width = 169
      Height = 21
      TabOrder = 3
      Text = 'familias'
    end
    object edUsuario: TEdit
      Left = 80
      Top = 11
      Width = 120
      Height = 21
      TabOrder = 4
      Text = 'user1'
    end
    object edPassword: TEdit
      Left = 312
      Top = 11
      Width = 120
      Height = 21
      TabOrder = 5
      Text = 'user1'
    end
  end
  object mResponse: TMemo
    Left = 0
    Top = 438
    Width = 647
    Height = 148
    Align = alBottom
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    ExplicitTop = 312
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 647
    Height = 41
    ButtonHeight = 35
    Caption = 'ToolBar1'
    TabOrder = 4
    object btnLoginJsonObject: TButton
      AlignWithMargins = True
      Left = 0
      Top = 0
      Width = 120
      Height = 35
      Align = alLeft
      Caption = 'Login (mode 2)'
      TabOrder = 0
      OnClick = btnLoginJsonObjectClick
    end
    object btnLOGIN: TButton
      AlignWithMargins = True
      Left = 120
      Top = 0
      Width = 120
      Height = 35
      Align = alLeft
      Caption = 'Login (mode 1)'
      TabOrder = 1
      OnClick = btnLOGINClick
    end
    object btnLoginWithException: TButton
      AlignWithMargins = True
      Left = 240
      Top = 0
      Width = 120
      Height = 35
      Caption = 'Custom Exception in OnAuthenticate'
      TabOrder = 2
      WordWrap = True
      OnClick = btnLoginWithExceptionClick
    end
  end
end
