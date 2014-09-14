object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main Form'
  ClientHeight = 301
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 49
    Width = 562
    Height = 252
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 562
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object chkPause: TCheckBox
      Left = 8
      Top = 5
      Width = 97
      Height = 17
      Caption = '&Pause'
      TabOrder = 0
    end
    object chkApplicationOnMessage: TCheckBox
      Left = 99
      Top = 5
      Width = 166
      Height = 17
      Caption = '&A: ApplicationOnMessage'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object chkMainFormHook: TCheckBox
      Left = 99
      Top = 28
      Width = 134
      Height = 17
      Caption = '&H: MainFormHook'
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
    object btnClear: TButton
      Left = 8
      Top = 22
      Width = 75
      Height = 23
      Caption = '&Clear'
      TabOrder = 1
      OnClick = btnClearClick
    end
    object LabeledEdit1: TLabeledEdit
      Left = 276
      Top = 23
      Width = 121
      Height = 21
      EditLabel.Width = 46
      EditLabel.Height = 13
      EditLabel.Caption = 'Test edit:'
      TabOrder = 4
    end
  end
  object ApplicationEvents1: TApplicationEvents
    OnMessage = ApplicationEvents1Message
    Left = 48
    Top = 176
  end
end
