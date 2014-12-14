unit uVTVDisableAutoScroll;

interface

procedure Register;

implementation

uses
  System.TypInfo, VCL.Controls, VCL.Forms;

const
  AllowResetFonts = True;

function Append(const Left, Delim, Right: string): string;
begin
  if Left = '' then
    Result := Right
  else if Right = '' then
    Result := Left
  else
    Result := Left + Delim + Right;
end;

function IncludeS(var SetValue: string; const EnumValue: string): Boolean;
begin
  Result := Pos(EnumValue, SetValue) = 0;
  if Result then
    SetValue := Append(SetValue, ',', EnumValue);
end;

procedure PatchVST(Control: TControl);
const
  STreeOptions = 'TreeOptions';
  SAutoOptions = 'AutoOptions';
  SDisableAutoscrollOnFocus = 'toDisableAutoscrollOnFocus';
var
  o: TObject;
  s: string;
begin
  // simulate Control.TreeOptions.AutoOptions := Control.TreeOptions.AutoOptions + [toDisableAutoscrollOnFocus];
  o := GetObjectProp(Control, STreeOptions);
  s := GetSetProp(o, SAutoOptions);
  if IncludeS(s, SDisableAutoscrollOnFocus) then
    SetSetProp(o, SAutoOptions, s);
end;

procedure Register;
var
  F: TForm;
  C: TControl;
  I: Integer;
  J: Integer;
begin
  for I := 0 to Screen.CustomFormCount - 1 do
  begin
    F := TForm(Screen.CustomForms[I]);
    if AllowResetFonts then
      F.ParentFont := True;

    for J := 0 to F.ControlCount - 1 do
    begin
      C := F.Controls[J];
      if AllowResetFonts then
        TForm(C).ParentFont := True;
      if C.ClassNameIs('TVirtualStringTree') or C.ClassNameIs('TRefactoringTree') then
        PatchVST(Screen.CustomForms[I].Controls[J]);
    end;
  end;
end;

end.
