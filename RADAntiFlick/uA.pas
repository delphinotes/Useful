unit uA;

interface

procedure Register;

implementation

uses
//  dbg,
  Winapi.Windows,
  Winapi.Messages,
  Winapi.CommCtrl,
  Vcl.Forms,
  ToolsAPI;

type
  TRADAntiFlick = class(TNotifierObject, IOTAWizard)
  const
    SAppBuilder = 'AppBuilder';
    SIDString = 'DelphiNotes.RAD.AntiFlick';
    SName = 'RAD AntiFlick';
  private
    FMainWndHwnd: HWND;
    procedure HookMainWindow;
    procedure UnhookMainWindow;
  public
    constructor Create;
    destructor Destroy; override;

    {$region 'IOTAWizard'}
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;
    {$endregion}
  end;

procedure Register;
begin
  RegisterPackageWizard(TRADAntiFlick.Create);
end;

function SubClassProc(AHandle: HWND; AMessage: UINT; AWParam: WPARAM; ALParam: LPARAM; AIdSubclass: UINT_PTR; ARefData: DWORD_PTR): LRESULT; stdcall;
begin
  case AMessage of
    WM_WINDOWPOSCHANGED:
      if IsIconic(AHandle) then
      begin
//        dbgStr('Catched!');
        Result := 1;
        Exit;
      end;
    WM_DESTROY:
      TRADAntiFlick(ARefData).UnhookMainWindow;
  end;
  Result := DefSubclassProc(AHandle, AMessage, AWParam, ALParam);
end;

{ TRADAntiFlick }

constructor TRADAntiFlick.Create;
var
  i: Integer;
  ICC: TInitCommonControlsEx;
begin
  inherited;

  i := SizeOf(TInitCommonControlsEx);
  ZeroMemory(@ICC, i);
  ICC.dwSize := i;
  ICC.dwICC := 0;
  InitCommonControlsEx(ICC);

  HookMainWindow;
end;

destructor TRADAntiFlick.Destroy;
begin
  UnhookMainWindow;
  inherited;
end;

procedure TRADAntiFlick.HookMainWindow;
var
  i: Integer;
begin
  FMainWndHwnd := 0;

  for i := 0 to Screen.FormCount - 1 do
    if Screen.Forms[i].Name = SAppBuilder then
    begin
      FMainWndHwnd := Screen.Forms[i].Handle;
      Break;
    end;

  if FMainWndHwnd > 0 then
    SetWindowSubclass(FMainWndHwnd, SubClassProc, 1, NativeUInt(Self));
end;

procedure TRADAntiFlick.UnhookMainWindow;
begin
  if FMainWndHwnd > 0 then
    RemoveWindowSubclass(FMainWndHwnd, SubClassProc, 1);
  FMainWndHwnd := 0;
end;

{$region 'IOTAWizard'}
function TRADAntiFlick.GetIDString: string;
begin
  Result := SIDString;
end;

function TRADAntiFlick.GetName: string;
begin
  Result := SName;
end;

function TRADAntiFlick.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

procedure TRADAntiFlick.Execute;
begin
end;
{$endregion}

end.
