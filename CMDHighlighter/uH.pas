unit uH;

interface

procedure Register;

implementation

uses
  Windows, SysUtils, Classes, ToolsAPI;

type
  TCMDHighlighter = class(TNotifierObject, IOTAWizard, IOTAHighlighter, IOTAHighlighterPreview)
  const
    atLabelDeclaration = ToolsApi.atPreproc;
    atA = ToolsApi.atPreproc;
    atLabel = ToolsApi.atIdentifier;
    atKeyWord = ToolsApi.atReservedWord;
    atRem = ToolsApi.atComment;
    atCommand = ToolsApi.atIdentifier;
    atVar = ToolsApi.atString;

    KeyWords1 = 'rem set if else exist errorlevel for in do break call copy chcp cd chdir choice cls country ctty date ' +
      'del erase dir echo exit goto loadfix loadhigh mkdir md move path pause prompt rename ren rmdir rd shift time ' +
      'type ver verify vol com con lpt nul defined not errorlevel cmdextversion';
    KeyWords2 = 'setlocal endlocal eql neq lss leq gtr geq';
  class var
    FKeyWords: TStringList;
  public
    // IOTAWizard
    function GetIDString: string;
    function GetName: string;
    function GetState: TWizardState;
    procedure Execute;

    // IOTAHighlighter
    procedure Tokenize(StartClass: TOTALineClass; LineBuf: POTAEdChar; LineBufLen: TOTALineSize;
      HighlightCodes: POTASyntaxCode);
    function TokenizeLineClass(StartClass: TOTALineClass; LineBuf: POTAEdChar; LineBufLen: TOTALineSize): TOTALineClass;

    // IOTAHighlighterPreview
    function GetDisplayName: string;
    function GetSampleText: string;
    function GetInvalidBreakpointLine: Integer;
    function GetCurrentInstructionLine: Integer;
    function GetValidBreakpointLine: Integer;
    function GetDisabledBreakpointLine: Integer;
    function GetErrorLine: Integer;
    function GetSampleSearchText: string;
    function GetBlockStartLine: Integer;
    function GetBlockStartCol: Integer;
    function GetBlockEndLine: Integer;
    function GetBlockEndCol: Integer;

    //
    constructor Create;
    class constructor Create;
    class destructor Destroy;
  end;

procedure Register;
begin
  RegisterPackageWizard(TCMDHighlighter.Create);
end;

{ TCMDHighlighter }

constructor TCMDHighlighter.Create;
begin
  inherited;
  (BorlandIDEServices as IOTAHighlightServices).AddHighlighter(Self);
end;

procedure TCMDHighlighter.Execute;
begin
end;

function TCMDHighlighter.GetIDString: string;
begin
  Result := 'DelphiNotes.Highlighter.CMD';
end;

function TCMDHighlighter.GetName: string;
begin
  Result := 'CMD/BAT Highlighter';
end;

function TCMDHighlighter.GetState: TWizardState;
begin
  Result := [wsEnabled];
end;

class constructor TCMDHighlighter.Create;
begin
  FKeyWords := TStringList.Create;
  FKeyWords.Delimiter := ' ';
  FKeyWords.DelimitedText := UpperCase(KeyWords1) + ' ' + UpperCase(KeyWords2);
  FKeyWords.Sorted := True;
end;

class destructor TCMDHighlighter.Destroy;
begin
  FreeAndNil(FKeyWords);
end;

procedure TCMDHighlighter.Tokenize(StartClass: TOTALineClass; LineBuf: POTAEdChar; LineBufLen: TOTALineSize;
  HighlightCodes: POTASyntaxCode);
var
  Codes: PByte;

  function Skip(Start: Integer; const CharSet: TSysCharSet): Integer;
  begin
    for Result := Start to Pred(LineBufLen) do
      if not CharInSet(LineBuf[Result], CharSet) then
        Exit;
  end;

  function ScanTo(Start, Stop: Integer; const CharSet: TSysCharSet): Integer;
  begin
    for Result := Start to Stop do
      if CharInSet(LineBuf[Result], CharSet) then
        Exit;
    if CharInSet(#0, CharSet) then
      //Inc(Result)
    else
      Result := -1;
  end;

  procedure SkipSpaces(var Start: Integer);
  begin
    Start := Skip(Start, [#32, #9]);
  end;

  procedure MarkTo(Start, Stop: Integer; Flag: Byte);
  var
    i: Integer;
  begin
    for i := Start to Stop do
      Codes[i] := Flag;
  end;

  procedure Mark(Start, Count: Integer; Flag: Byte);
  begin
    MarkTo(Start, Start + Count - 1, Flag);
  end;

  procedure ScanForVar(Idx, Len: Integer);
  var
    SavePos: Integer;
    IsExclamation: Boolean;
    IsPercent: Boolean;
    i: Integer;
  begin
    IsExclamation := False;
    IsPercent := False;

    for i := Idx to Idx + Len - 1 do
      case LineBuf[i] of
        '%':
          begin
            IsPercent := not IsPercent;
            if IsPercent then
              SavePos := i
            else
              MarkTo(SavePos, i, atVar);
          end;
        '!':
          begin
            IsExclamation := not IsExclamation;
            if IsExclamation then
              SavePos := i
            else
              MarkTo(SavePos, i, atVar);
          end;
        '0'.. '9', '*':
          if IsPercent and (i - SavePos = 1) then
            MarkTo(SavePos, i, atVar);
      end
  end;

var
  Idx: Integer;
  l, k: Integer;
  Flag: Byte;
  LastIdx: Integer;
  LastWord: AnsiString;

begin
  Codes := PByte(HighlightCodes);
  FillChar(HighlightCodes^, LineBufLen, SyntaxOff);

  LastIdx := Pred(LineBufLen);
  Idx := 0;
  SkipSpaces(Idx);
  if Idx >= LastIdx then
    Exit;
  if LineBuf[Idx] = ':' then
  begin
    // this is a label declaration, which occupies the entire row
    Mark(Idx, LineBufLen - Idx, atLabelDeclaration);
    Exit;
  end;

  while Idx < LineBufLen do
  begin
    SkipSpaces(Idx);
    if Idx >= LastIdx then
      Exit;

    k := ScanTo(Idx, LastIdx, [#0, #9, #32, '=', '|', '&']);
    if k <= 0 then
      k := idx;
    l := k - Idx;
    if l > 0 then
    begin
      SetString(LastWord, PAnsiChar(Integer(LineBuf) + Idx), l);

      if LastWord[1] = '@' then
      begin
        Mark(Idx, 1, atA);
        Inc(Idx);
        Dec(l);
        Delete(LastWord, 1, 1);
      end;
    end;

    if l > 0 then
    begin
      LastWord := UpperCase(LastWord);
      if LastWord = 'REM' then
      begin
        // start comment from here to the end of line
        Mark(Idx, LineBufLen - Idx, atRem);
        Exit;
      end;

      Flag := SyntaxOff;
      if LastWord[1] = ':' then
        Flag := atLabel else
      if FKeyWords.IndexOf(LastWord) >= 0 then
        Flag := atKeyWord;
      Mark(Idx, l, Flag);

      ScanForVar(Idx, l);
    end;

    Idx := k + 1;
  end;
end;

function TCMDHighlighter.TokenizeLineClass(StartClass: TOTALineClass; LineBuf: POTAEdChar;
  LineBufLen: TOTALineSize): TOTALineClass;
begin
  Result := 0;
end;

function TCMDHighlighter.GetDisplayName: string;
begin
  Result := 'CMD/BAT';
end;

function TCMDHighlighter.GetSampleText: string;
var
  Strings: TStrings;
  Stream: TStream;
begin
  Strings := TStringList.Create;
  try
    Stream := TResourceStream.Create(HInstance, 'SAMPLE_CMD', RT_RCDATA);
    try
      Strings.LoadFromStream(Stream);
    finally
      Stream.Free;
    end;
    Result := Strings.Text;
  finally
    Strings.Free;
  end;
end;

function TCMDHighlighter.GetInvalidBreakpointLine: Integer;
begin
  Result := -1;
end;

function TCMDHighlighter.GetCurrentInstructionLine: Integer;
begin
  Result := -1;
end;

function TCMDHighlighter.GetValidBreakpointLine: Integer;
begin
  Result := -1;
end;

function TCMDHighlighter.GetDisabledBreakpointLine: Integer;
begin
  Result := -1;
end;

function TCMDHighlighter.GetErrorLine: Integer;
begin
  Result := -1;
end;

function TCMDHighlighter.GetSampleSearchText: string;
begin
  Result := 'Match';
end;

function TCMDHighlighter.GetBlockStartLine: Integer;
begin
  Result := 8;
end;

function TCMDHighlighter.GetBlockStartCol: Integer;
begin
  Result := 24;
end;

function TCMDHighlighter.GetBlockEndLine: Integer;
begin
  Result := 8;
end;

function TCMDHighlighter.GetBlockEndCol: Integer;
begin
  Result := 29;
end;

end.
