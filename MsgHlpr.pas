unit MsgHlpr;

interface

uses
  Windows, Messages;

type
  TMessageHelper = record helper for TMessage
    function ToString: string;
  end;

  TMsgHelper = record helper for TMsg
    function ToString: string;
  end;

  function ToHex(AValue: Integer): string;
  function SCToString(SC: WParam): string;
  function HTToString(HT: Integer): string;
  function MsgToString(Msg: UINT): string;

  function IsControlNtf(Msg: UINT): Boolean;
  function IsControlMsg(Msg: UINT): Boolean;
  function IsKeyMsg(Msg: UINT): Boolean;
  function IsMouseMsg(Msg: UINT): Boolean;
  function IsInputMsg(Msg: UINT): Boolean;
  function IsPaintMsg(Msg: UINT): Boolean;
  function IsUserMsg(Msg: UINT): Boolean;

  function MsgType(Msg: UINT): string;

  function DescribeHandle(const Handle: HWND): string;
  function DescribeActivateApp(const Message: TWMActivateApp): string;
  function DescribeNCHitMessage(const Message: TWMNCHitMessage): string;
  function DescribeSyscommand(const Message: TWMSysCommand): string;
  function DescribeKeyMessage(const Message: TWMKey): string;
  function DescribeMouseMessage(const Message: TWMMouse): string;

implementation

uses
  SysUtils, Classes, Controls, Menus, Forms, TypInfo;

const
  MK_XBUTTON1 = $20;
  MK_XBUTTON2 = $40;
  XBUTTON1 = $00010000;
  XBUTTON2 = $00020000;

function Append(const Left, Delimiter, Right: string): string;
begin
  if Left = '' then
    Result := Right
  else if Right = '' then
    Result := Left
  else
    Result := Left + Delimiter + Right;
end;

function ToHex(AValue: Integer): string;
begin
  Result := '0x' + IntToHex(AValue, 8);
end;

function SCToString(SC: WParam): string;
begin
  case SC of
    SC_SIZE: Result := 'SC_SIZE';
    SC_MOVE: Result := 'SC_MOVE';
    SC_MINIMIZE: Result := 'SC_MINIMIZE';
    SC_MAXIMIZE: Result := 'SC_MAXIMIZE';
    SC_NEXTWINDOW: Result := 'SC_NEXTWINDOW';
    SC_PREVWINDOW: Result := 'SC_PREVWINDOW';
    SC_CLOSE: Result := 'SC_CLOSE';
    SC_VSCROLL: Result := 'SC_VSCROLL';
    SC_HSCROLL: Result := 'SC_HSCROLL';
    SC_MOUSEMENU: Result := 'SC_MOUSEMENU';
    SC_KEYMENU: Result := 'SC_KEYMENU';
    SC_ARRANGE: Result := 'SC_ARRANGE';
    SC_RESTORE: Result := 'SC_RESTORE';
    SC_TASKLIST: Result := 'SC_TASKLIST';
    SC_SCREENSAVE: Result := 'SC_SCREENSAVE';
    SC_HOTKEY: Result := 'SC_HOTKEY';
    SC_DEFAULT: Result := 'SC_DEFAULT';
    SC_MONITORPOWER: Result := 'SC_MONITORPOWER';
    SC_CONTEXTHELP: Result := 'SC_CONTEXTHELP';
    SC_SEPARATOR: Result := 'SC_SEPARATOR';
  else
    Result := ToHex(SC);
  end;
end;

function HTToString(HT: Integer): string;
begin
  case HT of
    HTERROR: Result := 'HTERROR';
    HTTRANSPARENT: Result := 'HTTRANSPARENT';
    HTNOWHERE: Result := 'HTNOWHERE';
    HTCLIENT: Result := 'HTCLIENT';
    HTCAPTION: Result := 'HTCAPTION';
    HTSYSMENU: Result := 'HTSYSMENU';
    //HTGROWBOX: Result := 'HTGROWBOX';
    HTSIZE: Result := 'HTSIZE';
    HTMENU: Result := 'HTMENU';
    HTHSCROLL: Result := 'HTHSCROLL';
    HTVSCROLL: Result := 'HTVSCROLL';
    HTMINBUTTON: Result := 'HTMINBUTTON';
    HTMAXBUTTON: Result := 'HTMAXBUTTON';
    HTLEFT: Result := 'HTLEFT';
    HTRIGHT: Result := 'HTRIGHT';
    HTTOP: Result := 'HTTOP';
    HTTOPLEFT: Result := 'HTTOPLEFT';
    HTTOPRIGHT: Result := 'HTTOPRIGHT';
    HTBOTTOM: Result := 'HTBOTTOM';
    HTBOTTOMLEFT: Result := 'HTBOTTOMLEFT';
    HTBOTTOMRIGHT: Result := 'HTBOTTOMRIGHT';
    HTBORDER: Result := 'HTBORDER';
    //HTREDUCE: Result := 'HTREDUCE';
    //HTZOOM: Result := 'HTZOOM';
    //HTSIZEFIRST: Result := 'HTSIZEFIRST';
    //HTSIZELAST: Result := 'HTSIZELAST';
    HTOBJECT: Result := 'HTOBJECT';
    HTCLOSE: Result := 'HTCLOSE';
    HTHELP: Result := 'HTHELP';
  else
    Result := ToHex(HT);
  end;
end;

function MsgToString(Msg: UINT): string;
begin
  case Msg of
    // Windows Message IDs (Messages.pas)
    WM_NULL: Result := 'WM_NULL';
    WM_CREATE: Result := 'WM_CREATE';
    WM_DESTROY: Result := 'WM_DESTROY';
    WM_MOVE: Result := 'WM_MOVE';
    WM_SIZE: Result := 'WM_SIZE';
    WM_ACTIVATE: Result := 'WM_ACTIVATE';
    WM_SETFOCUS: Result := 'WM_SETFOCUS';
    WM_KILLFOCUS: Result := 'WM_KILLFOCUS';
    WM_ENABLE: Result := 'WM_ENABLE';
    WM_SETREDRAW: Result := 'WM_SETREDRAW';
    WM_SETTEXT: Result := 'WM_SETTEXT';
    WM_GETTEXT: Result := 'WM_GETTEXT';
    WM_GETTEXTLENGTH: Result := 'WM_GETTEXTLENGTH';
    WM_PAINT: Result := 'WM_PAINT';
    WM_CLOSE: Result := 'WM_CLOSE';
    WM_QUERYENDSESSION: Result := 'WM_QUERYENDSESSION';
    WM_QUIT: Result := 'WM_QUIT';
    WM_QUERYOPEN: Result := 'WM_QUERYOPEN';
    WM_ERASEBKGND: Result := 'WM_ERASEBKGND';
    WM_SYSCOLORCHANGE: Result := 'WM_SYSCOLORCHANGE';
    WM_ENDSESSION: Result := 'WM_ENDSESSION';
    WM_SYSTEMERROR: Result := 'WM_SYSTEMERROR';
    WM_SHOWWINDOW: Result := 'WM_SHOWWINDOW';
    WM_CTLCOLOR: Result := 'WM_CTLCOLOR';
    WM_SETTINGCHANGE: Result := 'WM_SETTINGCHANGE';
    WM_DEVMODECHANGE: Result := 'WM_DEVMODECHANGE';
    WM_ACTIVATEAPP: Result := 'WM_ACTIVATEAPP';
    WM_FONTCHANGE: Result := 'WM_FONTCHANGE';
    WM_TIMECHANGE: Result := 'WM_TIMECHANGE';
    WM_CANCELMODE: Result := 'WM_CANCELMODE';
    WM_SETCURSOR: Result := 'WM_SETCURSOR';
    WM_MOUSEACTIVATE: Result := 'WM_MOUSEACTIVATE';
    WM_CHILDACTIVATE: Result := 'WM_CHILDACTIVATE';
    WM_QUEUESYNC: Result := 'WM_QUEUESYNC';
    WM_GETMINMAXINFO: Result := 'WM_GETMINMAXINFO';
    WM_PAINTICON: Result := 'WM_PAINTICON';
    WM_ICONERASEBKGND: Result := 'WM_ICONERASEBKGND';
    WM_NEXTDLGCTL: Result := 'WM_NEXTDLGCTL';
    WM_SPOOLERSTATUS: Result := 'WM_SPOOLERSTATUS';
    WM_DRAWITEM: Result := 'WM_DRAWITEM';
    WM_MEASUREITEM: Result := 'WM_MEASUREITEM';
    WM_DELETEITEM: Result := 'WM_DELETEITEM';
    WM_VKEYTOITEM: Result := 'WM_VKEYTOITEM';
    WM_CHARTOITEM: Result := 'WM_CHARTOITEM';
    WM_SETFONT: Result := 'WM_SETFONT';
    WM_GETFONT: Result := 'WM_GETFONT';
    WM_SETHOTKEY: Result := 'WM_SETHOTKEY';
    WM_GETHOTKEY: Result := 'WM_GETHOTKEY';
    WM_QUERYDRAGICON: Result := 'WM_QUERYDRAGICON';
    WM_COMPAREITEM: Result := 'WM_COMPAREITEM';
    WM_GETOBJECT: Result := 'WM_GETOBJECT';
    WM_COMPACTING: Result := 'WM_COMPACTING';
    WM_COMMNOTIFY: Result := 'WM_COMMNOTIFY';
    WM_WINDOWPOSCHANGING: Result := 'WM_WINDOWPOSCHANGING';
    WM_WINDOWPOSCHANGED: Result := 'WM_WINDOWPOSCHANGED';
    WM_POWER: Result := 'WM_POWER';
    //WM_COPYGLOBALDATA: Result := 'WM_COPYGLOBALDATA';
    $0049: Result := 'WM_COPYGLOBALDATA';
    WM_COPYDATA: Result := 'WM_COPYDATA';
    WM_CANCELJOURNAL: Result := 'WM_CANCELJOURNAL';
    WM_NOTIFY: Result := 'WM_NOTIFY';
    WM_INPUTLANGCHANGEREQUEST: Result := 'WM_INPUTLANGCHANGEREQUEST';
    WM_INPUTLANGCHANGE: Result := 'WM_INPUTLANGCHANGE';
    WM_TCARD: Result := 'WM_TCARD';
    WM_HELP: Result := 'WM_HELP';
    WM_USERCHANGED: Result := 'WM_USERCHANGED';
    WM_NOTIFYFORMAT: Result := 'WM_NOTIFYFORMAT';
    WM_CONTEXTMENU: Result := 'WM_CONTEXTMENU';
    WM_STYLECHANGING: Result := 'WM_STYLECHANGING';
    WM_STYLECHANGED: Result := 'WM_STYLECHANGED';
    WM_DISPLAYCHANGE: Result := 'WM_DISPLAYCHANGE';
    WM_GETICON: Result := 'WM_GETICON';
    WM_SETICON: Result := 'WM_SETICON';
    WM_NCCREATE: Result := 'WM_NCCREATE';
    WM_NCDESTROY: Result := 'WM_NCDESTROY';
    WM_NCCALCSIZE: Result := 'WM_NCCALCSIZE';
    WM_NCHITTEST: Result := 'WM_NCHITTEST';
    WM_NCPAINT: Result := 'WM_NCPAINT';
    WM_NCACTIVATE: Result := 'WM_NCACTIVATE';
    WM_GETDLGCODE: Result := 'WM_GETDLGCODE';
    WM_NCMOUSEMOVE: Result := 'WM_NCMOUSEMOVE';
    WM_NCLBUTTONDOWN: Result := 'WM_NCLBUTTONDOWN';
    WM_NCLBUTTONUP: Result := 'WM_NCLBUTTONUP';
    WM_NCLBUTTONDBLCLK: Result := 'WM_NCLBUTTONDBLCLK';
    WM_NCRBUTTONDOWN: Result := 'WM_NCRBUTTONDOWN';
    WM_NCRBUTTONUP: Result := 'WM_NCRBUTTONUP';
    WM_NCRBUTTONDBLCLK: Result := 'WM_NCRBUTTONDBLCLK';
    WM_NCMBUTTONDOWN: Result := 'WM_NCMBUTTONDOWN';
    WM_NCMBUTTONUP: Result := 'WM_NCMBUTTONUP';
    WM_NCMBUTTONDBLCLK: Result := 'WM_NCMBUTTONDBLCLK';
    WM_NCXBUTTONDOWN: Result := 'WM_NCXBUTTONDOWN';
    WM_NCXBUTTONUP: Result := 'WM_NCXBUTTONUP';
    WM_NCXBUTTONDBLCLK: Result := 'WM_NCXBUTTONDBLCLK';
    WM_INPUT_DEVICE_CHANGE: Result := 'WM_INPUT_DEVICE_CHANGE';
    WM_INPUT: Result := 'WM_INPUT';
    //WM_KEYFIRST: Result := 'WM_KEYFIRST';
    WM_KEYDOWN: Result := 'WM_KEYDOWN';
    WM_KEYUP: Result := 'WM_KEYUP';
    WM_CHAR: Result := 'WM_CHAR';
    WM_DEADCHAR: Result := 'WM_DEADCHAR';
    WM_SYSKEYDOWN: Result := 'WM_SYSKEYDOWN';
    WM_SYSKEYUP: Result := 'WM_SYSKEYUP';
    WM_SYSCHAR: Result := 'WM_SYSCHAR';
    WM_SYSDEADCHAR: Result := 'WM_SYSDEADCHAR';
    WM_UNICHAR: Result := 'WM_UNICHAR';
    //WM_KEYLAST: Result := 'WM_KEYLAST';
    WM_INITDIALOG: Result := 'WM_INITDIALOG';
    WM_COMMAND: Result := 'WM_COMMAND';
    WM_SYSCOMMAND: Result := 'WM_SYSCOMMAND';
    WM_TIMER: Result := 'WM_TIMER';
    WM_HSCROLL: Result := 'WM_HSCROLL';
    WM_VSCROLL: Result := 'WM_VSCROLL';
    WM_INITMENU: Result := 'WM_INITMENU';
    WM_INITMENUPOPUP: Result := 'WM_INITMENUPOPUP';
    WM_GESTURE: Result := 'WM_GESTURE';
    WM_GESTURENOTIFY: Result := 'WM_GESTURENOTIFY';
    WM_MENUSELECT: Result := 'WM_MENUSELECT';
    WM_MENUCHAR: Result := 'WM_MENUCHAR';
    WM_ENTERIDLE: Result := 'WM_ENTERIDLE';
    WM_MENURBUTTONUP: Result := 'WM_MENURBUTTONUP';
    WM_MENUDRAG: Result := 'WM_MENUDRAG';
    WM_MENUGETOBJECT: Result := 'WM_MENUGETOBJECT';
    WM_UNINITMENUPOPUP: Result := 'WM_UNINITMENUPOPUP';
    WM_MENUCOMMAND: Result := 'WM_MENUCOMMAND';
    WM_CHANGEUISTATE: Result := 'WM_CHANGEUISTATE';
    WM_UPDATEUISTATE: Result := 'WM_UPDATEUISTATE';
    WM_QUERYUISTATE: Result := 'WM_QUERYUISTATE';
    WM_CTLCOLORMSGBOX: Result := 'WM_CTLCOLORMSGBOX';
    WM_CTLCOLOREDIT: Result := 'WM_CTLCOLOREDIT';
    WM_CTLCOLORLISTBOX: Result := 'WM_CTLCOLORLISTBOX';
    WM_CTLCOLORBTN: Result := 'WM_CTLCOLORBTN';
    WM_CTLCOLORDLG: Result := 'WM_CTLCOLORDLG';
    WM_CTLCOLORSCROLLBAR: Result := 'WM_CTLCOLORSCROLLBAR';
    WM_CTLCOLORSTATIC: Result := 'WM_CTLCOLORSTATIC';
    //WM_MOUSEFIRST: Result := 'WM_MOUSEFIRST';
    WM_MOUSEMOVE: Result := 'WM_MOUSEMOVE';
    WM_LBUTTONDOWN: Result := 'WM_LBUTTONDOWN';
    WM_LBUTTONUP: Result := 'WM_LBUTTONUP';
    WM_LBUTTONDBLCLK: Result := 'WM_LBUTTONDBLCLK';
    WM_RBUTTONDOWN: Result := 'WM_RBUTTONDOWN';
    WM_RBUTTONUP: Result := 'WM_RBUTTONUP';
    WM_RBUTTONDBLCLK: Result := 'WM_RBUTTONDBLCLK';
    WM_MBUTTONDOWN: Result := 'WM_MBUTTONDOWN';
    WM_MBUTTONUP: Result := 'WM_MBUTTONUP';
    WM_MBUTTONDBLCLK: Result := 'WM_MBUTTONDBLCLK';
    WM_MOUSEWHEEL: Result := 'WM_MOUSEWHEEL';
    WM_XBUTTONDOWN: Result := 'WM_XBUTTONDOWN';
    WM_XBUTTONUP: Result := 'WM_XBUTTONUP';
    WM_XBUTTONDBLCLK: Result := 'WM_XBUTTONDBLCLK';
    WM_MOUSEHWHEEL: Result := 'WM_MOUSEHWHEEL';
    //WM_MOUSELAST: Result := 'WM_MOUSELAST';
    WM_PARENTNOTIFY: Result := 'WM_PARENTNOTIFY';
    WM_ENTERMENULOOP: Result := 'WM_ENTERMENULOOP';
    WM_EXITMENULOOP: Result := 'WM_EXITMENULOOP';
    WM_NEXTMENU: Result := 'WM_NEXTMENU';
    WM_SIZING: Result := 'WM_SIZING';
    WM_CAPTURECHANGED: Result := 'WM_CAPTURECHANGED';
    WM_MOVING: Result := 'WM_MOVING';
    WM_POWERBROADCAST: Result := 'WM_POWERBROADCAST';
    WM_DEVICECHANGE: Result := 'WM_DEVICECHANGE';
    WM_IME_STARTCOMPOSITION: Result := 'WM_IME_STARTCOMPOSITION';
    WM_IME_ENDCOMPOSITION: Result := 'WM_IME_ENDCOMPOSITION';
    WM_IME_COMPOSITION: Result := 'WM_IME_COMPOSITION';
    //WM_IME_KEYLAST: Result := 'WM_IME_KEYLAST';
    WM_IME_SETCONTEXT: Result := 'WM_IME_SETCONTEXT';
    WM_IME_NOTIFY: Result := 'WM_IME_NOTIFY';
    WM_IME_CONTROL: Result := 'WM_IME_CONTROL';
    WM_IME_COMPOSITIONFULL: Result := 'WM_IME_COMPOSITIONFULL';
    WM_IME_SELECT: Result := 'WM_IME_SELECT';
    WM_IME_CHAR: Result := 'WM_IME_CHAR';
    WM_IME_REQUEST: Result := 'WM_IME_REQUEST';
    WM_IME_KEYDOWN: Result := 'WM_IME_KEYDOWN';
    WM_IME_KEYUP: Result := 'WM_IME_KEYUP';
    WM_MDICREATE: Result := 'WM_MDICREATE';
    WM_MDIDESTROY: Result := 'WM_MDIDESTROY';
    WM_MDIACTIVATE: Result := 'WM_MDIACTIVATE';
    WM_MDIRESTORE: Result := 'WM_MDIRESTORE';
    WM_MDINEXT: Result := 'WM_MDINEXT';
    WM_MDIMAXIMIZE: Result := 'WM_MDIMAXIMIZE';
    WM_MDITILE: Result := 'WM_MDITILE';
    WM_MDICASCADE: Result := 'WM_MDICASCADE';
    WM_MDIICONARRANGE: Result := 'WM_MDIICONARRANGE';
    WM_MDIGETACTIVE: Result := 'WM_MDIGETACTIVE';
    WM_MDISETMENU: Result := 'WM_MDISETMENU';
    WM_ENTERSIZEMOVE: Result := 'WM_ENTERSIZEMOVE';
    WM_EXITSIZEMOVE: Result := 'WM_EXITSIZEMOVE';
    WM_DROPFILES: Result := 'WM_DROPFILES';
    WM_MDIREFRESHMENU: Result := 'WM_MDIREFRESHMENU';
    WM_TOUCH: Result := 'WM_TOUCH';
    WM_MOUSEHOVER: Result := 'WM_MOUSEHOVER';
    WM_MOUSELEAVE: Result := 'WM_MOUSELEAVE';
    WM_NCMOUSEHOVER: Result := 'WM_NCMOUSEHOVER';
    WM_NCMOUSELEAVE: Result := 'WM_NCMOUSELEAVE';
    WM_WTSSESSION_CHANGE: Result := 'WM_WTSSESSION_CHANGE';
    //WM_TABLET_FIRST: Result := 'WM_TABLET_FIRST';
    //WM_TABLET_LAST: Result := 'WM_TABLET_LAST';
    WM_CUT: Result := 'WM_CUT';
    WM_COPY: Result := 'WM_COPY';
    WM_PASTE: Result := 'WM_PASTE';
    WM_CLEAR: Result := 'WM_CLEAR';
    WM_UNDO: Result := 'WM_UNDO';
    WM_RENDERFORMAT: Result := 'WM_RENDERFORMAT';
    WM_RENDERALLFORMATS: Result := 'WM_RENDERALLFORMATS';
    WM_DESTROYCLIPBOARD: Result := 'WM_DESTROYCLIPBOARD';
    WM_DRAWCLIPBOARD: Result := 'WM_DRAWCLIPBOARD';
    WM_PAINTCLIPBOARD: Result := 'WM_PAINTCLIPBOARD';
    WM_VSCROLLCLIPBOARD: Result := 'WM_VSCROLLCLIPBOARD';
    WM_SIZECLIPBOARD: Result := 'WM_SIZECLIPBOARD';
    WM_ASKCBFORMATNAME: Result := 'WM_ASKCBFORMATNAME';
    WM_CHANGECBCHAIN: Result := 'WM_CHANGECBCHAIN';
    WM_HSCROLLCLIPBOARD: Result := 'WM_HSCROLLCLIPBOARD';
    WM_QUERYNEWPALETTE: Result := 'WM_QUERYNEWPALETTE';
    WM_PALETTEISCHANGING: Result := 'WM_PALETTEISCHANGING';
    WM_PALETTECHANGED: Result := 'WM_PALETTECHANGED';
    WM_HOTKEY: Result := 'WM_HOTKEY';
    WM_PRINT: Result := 'WM_PRINT';
    WM_PRINTCLIENT: Result := 'WM_PRINTCLIENT';
    WM_APPCOMMAND: Result := 'WM_APPCOMMAND';
    WM_THEMECHANGED: Result := 'WM_THEMECHANGED';
    WM_CLIPBOARDUPDATE: Result := 'WM_CLIPBOARDUPDATE';
    WM_HANDHELDFIRST: Result := 'WM_HANDHELDFIRST';
    WM_HANDHELDLAST: Result := 'WM_HANDHELDLAST';
    WM_PENWINFIRST: Result := 'WM_PENWINFIRST';
    WM_PENWINLAST: Result := 'WM_PENWINLAST';
    WM_COALESCE_FIRST: Result := 'WM_COALESCE_FIRST';
    WM_COALESCE_LAST: Result := 'WM_COALESCE_LAST';
    //WM_DDE_FIRST: Result := 'WM_DDE_FIRST';
    WM_DDE_INITIATE: Result := 'WM_DDE_INITIATE';
    WM_DDE_TERMINATE: Result := 'WM_DDE_TERMINATE';
    WM_DDE_ADVISE: Result := 'WM_DDE_ADVISE';
    WM_DDE_UNADVISE: Result := 'WM_DDE_UNADVISE';
    WM_DDE_ACK: Result := 'WM_DDE_ACK';
    WM_DDE_DATA: Result := 'WM_DDE_DATA';
    WM_DDE_REQUEST: Result := 'WM_DDE_REQUEST';
    WM_DDE_POKE: Result := 'WM_DDE_POKE';
    WM_DDE_EXECUTE: Result := 'WM_DDE_EXECUTE';
    //WM_DDE_LAST: Result := 'WM_DDE_LAST';
    WM_DWMCOMPOSITIONCHANGED: Result := 'WM_DWMCOMPOSITIONCHANGED';
    WM_DWMNCRENDERINGCHANGED: Result := 'WM_DWMNCRENDERINGCHANGED';
    WM_DWMCOLORIZATIONCOLORCHANGED: Result := 'WM_DWMCOLORIZATIONCOLORCHANGED';
    WM_DWMWINDOWMAXIMIZEDCHANGE: Result := 'WM_DWMWINDOWMAXIMIZEDCHANGE';
    WM_DWMSENDICONICTHUMBNAIL: Result := 'WM_DWMSENDICONICTHUMBNAIL';
    WM_DWMSENDICONICLIVEPREVIEWBITMAP: Result := 'WM_DWMSENDICONICLIVEPREVIEWBITMAP';
    WM_GETTITLEBARINFOEX: Result := 'WM_GETTITLEBARINFOEX';
    WM_TABLET_DEFBASE: Result := 'WM_TABLET_DEFBASE';
    //WM_TABLET_MAXOFFSET: Result := 'WM_TABLET_MAXOFFSET';
    WM_TABLET_ADDED: Result := 'WM_TABLET_ADDED';
    WM_TABLET_DELETED: Result := 'WM_TABLET_DELETED';
    WM_TABLET_FLICK: Result := 'WM_TABLET_FLICK';
    WM_TABLET_QUERYSYSTEMGESTURESTATUS: Result := 'WM_TABLET_QUERYSYSTEMGESTURESTATUS';
    WM_APP: Result := 'WM_APP';

    // VCL control message IDs (Controls.pas)
    CM_ACTIVATE: Result := 'CM_ACTIVATE';
    CM_DEACTIVATE: Result := 'CM_DEACTIVATE';
    CM_GOTFOCUS: Result := 'CM_GOTFOCUS';
    CM_LOSTFOCUS: Result := 'CM_LOSTFOCUS';
    CM_CANCELMODE: Result := 'CM_CANCELMODE';
    CM_DIALOGKEY: Result := 'CM_DIALOGKEY';
    CM_DIALOGCHAR: Result := 'CM_DIALOGCHAR';
    CM_FOCUSCHANGED: Result := 'CM_FOCUSCHANGED';
    CM_PARENTFONTCHANGED: Result := 'CM_PARENTFONTCHANGED';
    CM_PARENTCOLORCHANGED: Result := 'CM_PARENTCOLORCHANGED';
    CM_HITTEST: Result := 'CM_HITTEST';
    CM_VISIBLECHANGED: Result := 'CM_VISIBLECHANGED';
    CM_ENABLEDCHANGED: Result := 'CM_ENABLEDCHANGED';
    CM_COLORCHANGED: Result := 'CM_COLORCHANGED';
    CM_FONTCHANGED: Result := 'CM_FONTCHANGED';
    CM_CURSORCHANGED: Result := 'CM_CURSORCHANGED';
    CM_CTL3DCHANGED: Result := 'CM_CTL3DCHANGED';
    CM_PARENTCTL3DCHANGED: Result := 'CM_PARENTCTL3DCHANGED';
    CM_TEXTCHANGED: Result := 'CM_TEXTCHANGED';
    CM_MOUSEENTER: Result := 'CM_MOUSEENTER';
    CM_MOUSELEAVE: Result := 'CM_MOUSELEAVE';
    CM_MENUCHANGED: Result := 'CM_MENUCHANGED';
    CM_APPKEYDOWN: Result := 'CM_APPKEYDOWN';
    CM_APPSYSCOMMAND: Result := 'CM_APPSYSCOMMAND';
    CM_BUTTONPRESSED: Result := 'CM_BUTTONPRESSED';
    CM_SHOWINGCHANGED: Result := 'CM_SHOWINGCHANGED';
    CM_ENTER: Result := 'CM_ENTER';
    CM_EXIT: Result := 'CM_EXIT';
    CM_DESIGNHITTEST: Result := 'CM_DESIGNHITTEST';
    CM_ICONCHANGED: Result := 'CM_ICONCHANGED';
    CM_WANTSPECIALKEY: Result := 'CM_WANTSPECIALKEY';
    CM_INVOKEHELP: Result := 'CM_INVOKEHELP';
    CM_WINDOWHOOK: Result := 'CM_WINDOWHOOK';
    CM_RELEASE: Result := 'CM_RELEASE';
    CM_SHOWHINTCHANGED: Result := 'CM_SHOWHINTCHANGED';
    CM_PARENTSHOWHINTCHANGED: Result := 'CM_PARENTSHOWHINTCHANGED';
    CM_SYSCOLORCHANGE: Result := 'CM_SYSCOLORCHANGE';
    CM_WININICHANGE: Result := 'CM_WININICHANGE';
    CM_FONTCHANGE: Result := 'CM_FONTCHANGE';
    CM_TIMECHANGE: Result := 'CM_TIMECHANGE';
    CM_TABSTOPCHANGED: Result := 'CM_TABSTOPCHANGED';
    CM_UIACTIVATE: Result := 'CM_UIACTIVATE';
    CM_UIDEACTIVATE: Result := 'CM_UIDEACTIVATE';
    CM_DOCWINDOWACTIVATE: Result := 'CM_DOCWINDOWACTIVATE';
    CM_CONTROLLISTCHANGE: Result := 'CM_CONTROLLISTCHANGE';
    CM_GETDATALINK: Result := 'CM_GETDATALINK';
    CM_CHILDKEY: Result := 'CM_CHILDKEY';
    CM_DRAG: Result := 'CM_DRAG';
    CM_HINTSHOW: Result := 'CM_HINTSHOW';
    CM_DIALOGHANDLE: Result := 'CM_DIALOGHANDLE';
    CM_ISTOOLCONTROL: Result := 'CM_ISTOOLCONTROL';
    CM_RECREATEWND: Result := 'CM_RECREATEWND';
    CM_INVALIDATE: Result := 'CM_INVALIDATE';
    CM_SYSFONTCHANGED: Result := 'CM_SYSFONTCHANGED';
    CM_CONTROLCHANGE: Result := 'CM_CONTROLCHANGE';
    CM_CHANGED: Result := 'CM_CHANGED';
    CM_DOCKCLIENT: Result := 'CM_DOCKCLIENT';
    CM_UNDOCKCLIENT: Result := 'CM_UNDOCKCLIENT';
    CM_FLOAT: Result := 'CM_FLOAT';
    CM_BORDERCHANGED: Result := 'CM_BORDERCHANGED';
    CM_BIDIMODECHANGED: Result := 'CM_BIDIMODECHANGED';
    CM_PARENTBIDIMODECHANGED: Result := 'CM_PARENTBIDIMODECHANGED';
    CM_ALLCHILDRENFLIPPED: Result := 'CM_ALLCHILDRENFLIPPED';
    CM_ACTIONUPDATE: Result := 'CM_ACTIONUPDATE';
    CM_ACTIONEXECUTE: Result := 'CM_ACTIONEXECUTE';
    CM_HINTSHOWPAUSE: Result := 'CM_HINTSHOWPAUSE';
    CM_DOCKNOTIFICATION: Result := 'CM_DOCKNOTIFICATION';
    CM_MOUSEWHEEL: Result := 'CM_MOUSEWHEEL';
    CM_ISSHORTCUT: Result := 'CM_ISSHORTCUT';
    CM_UPDATEACTIONS: Result := 'CM_UPDATEACTIONS';
    CM_INVALIDATEDOCKHOST: Result := 'CM_INVALIDATEDOCKHOST';
    CM_SETACTIVECONTROL: Result := 'CM_SETACTIVECONTROL';
    CM_POPUPHWNDDESTROY: Result := 'CM_POPUPHWNDDESTROY';
    CM_CREATEPOPUP: Result := 'CM_CREATEPOPUP';
    CM_DESTROYHANDLE: Result := 'CM_DESTROYHANDLE';
    CM_MOUSEACTIVATE: Result := 'CM_MOUSEACTIVATE';
    CM_CONTROLLISTCHANGING: Result := 'CM_CONTROLLISTCHANGING';
    CM_BUFFEREDPRINTCLIENT: Result := 'CM_BUFFEREDPRINTCLIENT';
    CM_UNTHEMECONTROL: Result := 'CM_UNTHEMECONTROL';
    CM_DOUBLEBUFFEREDCHANGED: Result := 'CM_DOUBLEBUFFEREDCHANGED';
    CM_PARENTDOUBLEBUFFEREDCHANGED: Result := 'CM_PARENTDOUBLEBUFFEREDCHANGED';
    //CM_STYLECHANGED: Result := 'CM_STYLECHANGED';
    CM_THEMECHANGED: Result := 'CM_STYLECHANGED';
    CM_GESTURE: Result := 'CM_GESTURE';
    CM_CUSTOMGESTURESCHANGED: Result := 'CM_CUSTOMGESTURESCHANGED';
    CM_GESTUREMANAGERCHANGED: Result := 'CM_GESTUREMANAGERCHANGED';
    CM_STANDARDGESTURESCHANGED: Result := 'CM_STANDARDGESTURESCHANGED';
    CM_INPUTLANGCHANGE: Result := 'CM_INPUTLANGCHANGE';
    CM_TABLETOPTIONSCHANGED: Result := 'CM_TABLETOPTIONSCHANGED';
    CM_PARENTTABLETOPTIONSCHANGED: Result := 'CM_PARENTTABLETOPTIONSCHANGED';
    //CM_CUSTOMSTYLECHANGED: Result := 'CM_CUSTOMSTYLECHANGED';
    CM_BASE + 89: Result := 'CM_CUSTOMSTYLECHANGED';

    // VCL control notification IDs (Controls.pas)
    CN_CHARTOITEM: Result := 'CN_CHARTOITEM';
    CN_COMMAND: Result := 'CN_COMMAND';
    CN_COMPAREITEM: Result := 'CN_COMPAREITEM';
    CN_CTLCOLORBTN: Result := 'CN_CTLCOLORBTN';
    CN_CTLCOLORDLG: Result := 'CN_CTLCOLORDLG';
    CN_CTLCOLOREDIT: Result := 'CN_CTLCOLOREDIT';
    CN_CTLCOLORLISTBOX: Result := 'CN_CTLCOLORLISTBOX';
    CN_CTLCOLORMSGBOX: Result := 'CN_CTLCOLORMSGBOX';
    CN_CTLCOLORSCROLLBAR: Result := 'CN_CTLCOLORSCROLLBAR';
    CN_CTLCOLORSTATIC: Result := 'CN_CTLCOLORSTATIC';
    CN_DELETEITEM: Result := 'CN_DELETEITEM';
    CN_DRAWITEM: Result := 'CN_DRAWITEM';
    CN_HSCROLL: Result := 'CN_HSCROLL';
    CN_MEASUREITEM: Result := 'CN_MEASUREITEM';
    CN_PARENTNOTIFY: Result := 'CN_PARENTNOTIFY';
    CN_VKEYTOITEM: Result := 'CN_VKEYTOITEM';
    CN_VSCROLL: Result := 'CN_VSCROLL';
    CN_KEYDOWN: Result := 'CN_KEYDOWN';
    CN_KEYUP: Result := 'CN_KEYUP';
    CN_CHAR: Result := 'CN_CHAR';
    CN_SYSKEYDOWN: Result := 'CN_SYSKEYDOWN';
    CN_SYSCHAR: Result := 'CN_SYSCHAR';
    CN_NOTIFY: Result := 'CN_NOTIFY';
  else
    Result := ToHex(Msg);
  end;
end;

function IsControlNtf(Msg: UINT): Boolean;
begin
  Result := Msg >= CN_BASE;
end;

function IsControlMsg(Msg: UINT): Boolean;
begin
  Result := Msg >= CM_BASE;
end;

function IsKeyMsg(Msg: UINT): Boolean;
begin
  Result := (Msg >= WM_KEYFIRST)
    and (Msg <= WM_KEYLAST);
end;

function IsMouseMsg(Msg: UINT): Boolean;
begin
  Result := (Msg >= WM_MOUSEFIRST)
    and (Msg <= WM_MOUSELAST);
end;

function IsInputMsg(Msg: UINT): Boolean;
begin
  Result := IsMouseMsg(Msg) or IsKeyMsg(Msg);
end;

function IsPaintMsg(Msg: UINT): Boolean;
begin
  case Msg of
    WM_PAINT, WM_NCPAINT:
      Result := True;
  else
    Result := False;
  end;
end;

function IsUserMsg(Msg: UINT): Boolean;
begin
  Result := Msg >= WM_USER;
  // and Msg < CM_BASE?
end;

function MsgType(Msg: UINT): string;
begin
  if IsKeyMsg(Msg) then
    Result := 'Key message'
  else if IsMouseMsg(Msg) then
    Result := 'Mouse message'
  else if IsControlNtf(Msg) then
    Result := 'Control notification'
  else if IsControlMsg(Msg) then
    Result := 'Control message'
  else if IsUserMsg(Msg) then
    Result := 'User message'
  else
    Result := 'Window message';
end;

function DescribeHandle(const Handle: HWND): string;
var
  C: TComponent;
begin
  C := FindControl(Handle);
  if Assigned(C) then
  begin
    Result := C.Name;
    while Assigned(C.Owner) do
    begin
      C := C.Owner;
      if C.Name <> '' then
        Result := C.Name + '.' + Result;
    end;
  end else
    Result := ToHex(Handle);
end;

function DescribeActivateApp(const Message: TWMActivateApp): string;
begin
  if Message.Active then
    Result := 'Activate (switch from ThreadId: %s)'
  else
    Result := 'Deactivate (switch to ThreadId: %s)';
  Result := Format(Result, [ToHex(Message.ThreadId)]);
end;

function DescribeNCHitMessage(const Message: TWMNCHitMessage): string;
var
  HitTest: Integer;
begin
  Result := '';
  case Message.Msg of
    WM_NCXBUTTONDOWN, WM_NCXBUTTONUP, WM_NCXBUTTONDBLCLK:
    begin
      if TMessage(Message).WParam and XBUTTON1 <> 0 then
        Result := 'X1';
      if TMessage(Message).WParam and XBUTTON2 <> 0 then
        Result := Append(Result, ',', 'X2');
      HitTest := TMessage(Message).WParamLo;
    end;
  else
    HitTest := Message.HitTest;
    case Message.Msg of
      WM_NCLBUTTONDOWN, WM_NCLBUTTONUP, WM_NCLBUTTONDBLCLK:
        Result := 'L';
      WM_NCRBUTTONDOWN, WM_NCRBUTTONUP, WM_NCRBUTTONDBLCLK:
        Result := 'R';
      WM_NCMBUTTONDOWN, WM_NCMBUTTONUP, WM_NCMBUTTONDBLCLK:
        Result := 'M';
    end;
  end;
  if Result <> '' then
    Result := '[' + Result + ']';
  Result := Append(Result, ' ', HTToString(HitTest));
  Result := Append(Result, ' ', Format('[%d,%d]', [Message.XCursor, Message.YCursor]));
end;

function DescribeSyscommand(const Message: TWMSysCommand): string;
begin
  case Message.CmdType of
    SC_HOTKEY:
      Result := ' ActivateWnd: ' + DescribeHandle(Message.ActivateWnd);
    SC_KEYMENU:
      Result := ' Key: ' + ToHex(Message.Key);
    SC_CLOSE, SC_HSCROLL, SC_MAXIMIZE, SC_MINIMIZE, SC_MOUSEMENU, SC_MOVE,
    SC_NEXTWINDOW, SC_PREVWINDOW, SC_RESTORE, SC_SCREENSAVE, SC_SIZE,
    SC_TASKLIST, SC_VSCROLL:
      Result := Format(' X,Y: %d,%d', [Message.XPos, Message.YPos]);
  else
    Result := '';
  end;

  Result := SCToString(Message.CmdType) + Result;
end;

function DescribeKeyMessage(const Message: TWMKey): string;
begin
  case Message.Msg of
    WM_CHAR:
      Result := Char(Message.CharCode)
  else
    Result := ShortCutToText(ShortCutFromMessage(Message));
  end;
end;

function DescribeMouseMessage(const Message: TWMMouse): string;
var
  Keys: Integer;
  WheelDelta: Integer;
  Shift: TShiftState;
  I: Byte absolute Shift;
  sKeys: string;
  sAdd: string;
begin
  sKeys := '';
  sAdd := '';
  case Message.Msg of
    WM_MOUSEWHEEL:
      begin
        Keys := TWMMouseWheel(Message).Keys;
        if Keys and MK_XBUTTON1 <> 0 then
          sKeys := Append(sKeys, ',', 'X1');
        if Keys and MK_XBUTTON2 <> 0 then
          sKeys := Append(sKeys, ',', 'X2');
        WheelDelta := TWMMouseWheel(Message).WheelDelta;
      end;
    WM_MOUSEHWHEEL:
      begin
        Keys := 0;
        WheelDelta := TMSHMouseWheel(Message).WheelDelta;
      end;
  else
    Keys := Message.Keys;
    if Keys and XBUTTON1 <> 0 then
      sKeys := Append(sKeys, ',', 'X1');
    if Keys and XBUTTON2 <> 0 then
      sKeys := Append(sKeys, ',', 'X2');
    WheelDelta := 0;
  end;

  Shift := KeysToShiftState(Keys) + MouseOriginToShiftState;
  if Shift <> [] then
    sKeys := Append(sKeys, ', ', SetToString(PTypeInfo(TypeInfo(TShiftState)), I));
  if sKeys <> '' then
    sKeys := '[' + sKeys + '] ';
  if WheelDelta <> 0 then
    sAdd := Format('WD: %d ', [WheelDelta]);

  Result := Format('%s%s[%d,%d]', [sKeys, sAdd, Message.XPos, Message.YPos]);
end;

{ TMessageHelper }

function TMessageHelper.ToString: string;
begin
  case Msg of
    WM_ENABLE:
      Result := BoolToStr(TWMEnable(Self).Enabled, True);
    WM_SYSCOMMAND:
      Result := DescribeSyscommand(TWMSysCommand(Self));
    WM_ACTIVATEAPP:
      Result := DescribeActivateApp(TWMActivateApp(Self));
    WM_NCMOUSEMOVE,
    WM_NCLBUTTONDOWN, WM_NCLBUTTONUP, WM_NCLBUTTONDBLCLK,
    WM_NCRBUTTONDOWN, WM_NCRBUTTONUP, WM_NCRBUTTONDBLCLK,
    WM_NCMBUTTONDOWN, WM_NCMBUTTONUP, WM_NCMBUTTONDBLCLK,
    WM_NCXBUTTONDOWN, WM_NCXBUTTONUP, WM_NCXBUTTONDBLCLK:
      Result := DescribeNCHitMessage(TWMNCHitMessage(Self));
    CM_APPKEYDOWN,
    WM_KEYFIRST .. WM_KEYLAST:
      Result := DescribeKeyMessage(TWMKey(Self));
    WM_MOUSEFIRST .. WM_MOUSELAST:
      Result := DescribeMouseMessage(TWMMouse(Self));
  else
    if WParam = 0 then
      Result := ''
    else
      Result := Format('WParam: %d', [WParam]);
    if LParam <> 0 then
      Result := Append(Result, ', ', Format('LParam: %d', [LParam]));
  end;

  //Result := Format('%s %s %s, Result: %d', [MsgType(Msg), MsgToString(Msg), Result, Self.Result]);
  Result := Append(MsgToString(Msg), ': ', Result);
end;

{ TMsgHelper }

function TMsgHelper.ToString: string;
var
  M: TMessage;
begin
  M.Msg := Self.message;
  M.WParam := Self.wParam;
  M.LParam := Self.lParam;
  M.Result := 0;

  Result := M.ToString + ' Target: ' + DescribeHandle(hwnd);
end;

end.
