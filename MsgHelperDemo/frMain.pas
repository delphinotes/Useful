unit frMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, AppEvnts, StdCtrls, ExtCtrls;

type
  TfrmMain = class(TForm)
    ApplicationEvents1: TApplicationEvents;
    Memo1: TMemo;
    Panel1: TPanel;
    chkPause: TCheckBox;
    chkApplicationOnMessage: TCheckBox;
    chkMainFormHook: TCheckBox;
    btnClear: TButton;
    LabeledEdit1: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure btnClearClick(Sender: TObject);
  private
    procedure Log(const S: string);
    procedure LogMessage(const Prefix: string; Message: TMessage); overload;
    procedure LogMessage(const Prefix: string; Msg: TMsg); overload;
    function MainFormHook(var Message: TMessage): Boolean;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses
  MsgHlpr;

procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Application.HookMainWindow(MainFormHook);
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  Application.UnhookMainWindow(MainFormHook);
end;

function TfrmMain.MainFormHook(var Message: TMessage): Boolean;
begin
  Result := False;
  if not chkMainFormHook.Checked then
    Exit;
  LogMessage('H', Message);
end;

procedure TfrmMain.ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
begin
  Handled := False;
  if not chkApplicationOnMessage.Checked then
    Exit;
  if Msg.message = $118 then    // skip edit cursor update message
    Exit;
  LogMessage('A', Msg);
end;

procedure TfrmMain.Log(const S: string);
begin
  if chkPause.Checked then
    Exit;
  Memo1.Lines.Add(S);
end;

procedure TfrmMain.LogMessage(const Prefix: string; Message: TMessage);
begin
  Log(Prefix + ': ' + Message.ToString);
end;

procedure TfrmMain.LogMessage(const Prefix: string; Msg: TMsg);
begin
  Log(Prefix + ': ' + Msg.ToString);
end;



end.
