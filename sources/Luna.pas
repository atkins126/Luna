{==============================================================================
        .
     .--:         :
    ----        :---:
  .-----         .-.
 .------          .
 -------.
.--------               :
.---------             .:.
 ----------:            .
 :-----------:
  --------------:.         .:.
   :------------------------
    .---------------------.
       :---------------:.
          ..:::::::..
              ...
     _
    | |    _  _  _ _   __ _
    | |__ | || || ' \ / _` |
    |____| \_,_||_||_|\__,_|
         Game Toolkit™

Copyright © 2022 tinyBigGAMES™ LLC
All Rights Reserved.

Website: https://tinybiggames.com
Email  : support@tinybiggames.com

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software in
   a product, an acknowledgment in the product documentation would be
   appreciated but is not required.

2. Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.

3. Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.

4. Neither the name of the copyright holder nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

5. All video, audio, graphics and other content accessed through the
   software in this distro is the property of the applicable content owner
   and may be protected by applicable copyright law. This License gives
   Customer no rights to such content, and Company disclaims any liability
   for misuse of content.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
============================================================================= }

unit Luna;

{$WARN SYMBOL_DEPRECATED OFF}
{$WARN SYMBOL_PLATFORM OFF}

{$WARN UNIT_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

{$MINENUMSIZE 4}
{$ALIGN ON}

{$Z4}
{$A8}

{$INLINE AUTO}

{$IFNDEF WIN64}
  {$MESSAGE Error 'Unsupported platform'}
{$ENDIF}

interface

uses
  System.Generics.Collections,
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  System.Math,
  System.JSON,
  System.Net.HttpClient,
  System.NetEncoding,
  System.Net.URLClient,
  WinApi.Windows,
  WinApi.ShellAPI;

{$I Deps.Intf.inc}
//===========================================================================
// insert code below
//===========================================================================
const
  LuVERSION_MAJOR = '0';
  LuVERSION_MINOR = '1';
  LuVERSION_PATCH = '0';
  LuVERSION       = LuVERSION_MAJOR + '.' + LuVERSION_MINOR + '.' + LuVERSION_PATCH;

type

  { TLuPoint }
  TLuPoint = record
    X,Y: Single;
    class operator Implicit(aValue: TLuPoint): SDL_Point;
    class operator Implicit(aValue: TLuPoint): SDL_FPoint;
    class operator Implicit(aValue: SDL_Point): TLuPoint;
    class operator Implicit(aValue: SDL_FPoint): TLuPoint;
    class operator Initialize(out aDest: TLuPoint);
  end;

  { TLuVector }
  TLuVector = record
    X,Y,Z,W: Single;
    class operator Initialize(out aDest: TLuVector);
  end;

  { TLuRect }
  TLuRect = record
    X,Y,Width,Height: Single;
    class operator Implicit(aValue: TLuRect): SDL_Rect;
    class operator Implicit(aValue: TLuRect): SDL_FRect;
    class operator Implicit(aValue: SDL_Rect): TLuRect;
    class operator Implicit(aValue: SDL_FRect): TLuRect;
    class operator Initialize(out aDest: TLuRect);
  end;

  { TLuBaseObjectList }
  TLuBaseObjectList = class;

  { TLuObjectAttributeSet }
  TLuObjectAttributeSet = set of Byte;

  { TLuBaseObject }
  TLuBaseObject = class
  protected
    FOwner: TLuBaseObjectList;
    FPrev: TLuBaseObject;
    FNext: TLuBaseObject;
    FAttributes: TLuObjectAttributeSet;
    function GetAttribute(aIndex: Byte): Boolean;
    procedure SetAttribute(aIndex: Byte; aValue: Boolean);
    function GetAttributes: TLuObjectAttributeSet;
    procedure SetAttributes(aValue: TLuObjectAttributeSet);
  public
    property Owner: TLuBaseObjectList read FOwner write FOwner;
    property Prev: TLuBaseObject read FPrev write FPrev;
    property Next: TLuBaseObject read FNext write FNext;
    property Attribute[aIndex: Byte]: Boolean read GetAttribute write SetAttribute;
    property Attributes: TLuObjectAttributeSet read GetAttributes  write SetAttributes;
    constructor Create; virtual;
    destructor Destroy; override;
    function AttributesAreSet(aAttrs: TLuObjectAttributeSet): Boolean;
  end;

  { TLuBaseObjectList }
  TLuBaseObjectList = class
  protected
    FHead: TLuBaseObject;
    FTail: TLuBaseObject;
    FCount: Integer;
  public
    property Count: Integer read FCount;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Add(aObject: TLuBaseObject);
    procedure Remove(aObject: TLuBaseObject; aDispose: Boolean);
    procedure Clean; virtual;
    procedure Clear(aAttrs: TLuObjectAttributeSet);
  end;

  { TLuCloudDb }
  TLuCloudDb = class(TLuBaseObject)
  protected const
    cURL = '/?apikey=%s&keyspace=%s&query=%s';
    cTest = 1;
  protected
    FUrl: string;
    FApiKey: string;
    FDatabase: string;
    FResponseText: string;
    FLastError: string;
    FHttp: THTTPClient;
    FSQL: TStringList;
    FPrepairedSQL: string;
    FJSON: TJSONObject;
    FDataset: TJSONArray;
    FMacros: TDictionary<string, string>;
    FParams: TDictionary<string, string>;
    procedure SetMacroValue(const aName, aValue: string);
    procedure SetParamValue(const aName, aValue: string);
    procedure Prepair;
    function  GetQueryURL(const aSQL: string): string;
    function  GetPrepairedSQL: string;
    function  GetResponseText: string;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Setup(const aURL, aApiKey, aDatabase: string);
    procedure ClearSQLText;
    procedure AddSQLText(const aText: string; const aArgs: array of const);
    function  GetSQLText: string;
    procedure SetSQLText(const aText: string);
    function  GetMacro(const aName: string): string;
    procedure SetMacro(const aName, aValue: string);
    function  GetParam(const aName: string): string;
    procedure SetParam(const aName, aValue: string);
    function  RecordCount: Integer;
    function  GetField(const aIndex: Cardinal; const aName: string): string;
    function  Execute: Boolean;
    function  ExecuteSQL(const aSQL: string): Boolean;
    function  GetLastError: string;
  end;

  { TLuGame }
  TLuGame = class
  protected
    FMarshaller: TMarshaller;
    FMasterObjectList: TLuBaseObjectList;
    FOrgName: string;
    FAppName: string;
  public
    { Properties }
    property MasterObjectList: TLuBaseObjectList read FMasterObjectList;

    { Construct/Destruct }
    constructor Create; virtual;
    destructor Destroy; override;

    { Callbacks }
    function  OnStartup: Boolean; virtual;
    procedure OnShutdown; virtual;
    procedure OnRun; virtual;

    { Utils }
    procedure ShellOpen(const aFilename: string);
    function  GetVersionInfo(aInstance: THandle; aIdent: string): string; overload;
    function  GetVersionInfo(const aFilename: string; aIdent: string): string; overload;
    procedure FreeNilObject(const [ref] aObject: TObject);
    function  UnitToScalarValue(const aValue, aMaxValue: Double): Double;
    function  HttpGet(const aURL: string; aStatus: PString=nil): string;

    { Console }
    function  HasConsoleOutput: Boolean;
    function  HasConsoleOnStartup: Boolean;
    procedure WaitForAnyKey;
    procedure Pause(const aMsg: string='');
    procedure Print(const aMsg: string); overload;
    procedure Print(const aMsg: string; const aArgs: array of const); overload;
    procedure PrintLn; overload;
    procedure PrintLn(const aMsg: string); overload;
    procedure PrintLn(const aMsg: string; const aArgs: array of const); overload;

    { Prefs }
    function  GetOrgName: string;
    procedure SetOrgName(const aOrgName: string);
    function  GetAppName: string;
    procedure SetAppName(const aAppName: string);
    function  GetPrefsPath: string;
    procedure GotoPrefsPath;
  end;

  { TLuGameClass }
  TLuGameClass = class of TLuGame;

{ Variables }
var
  Game: TLuGame = nil;

{ Routines }
procedure LuRunGame(const aGame: TLuGameClass);

implementation

{ Routines }
procedure LuRunGame(const aGame: TLuGameClass);
var
  LGame: TLuGame;
  LMarshaller: TMarshaller;
  LMsg: string;
begin
  try
    LGame := Game;
    try
      Game := aGame.Create;
      try
        try
          if not Game.OnStartup then Exit;
          Game.OnRun;
        finally
          Game.OnShutdown;
        end;
      finally
        Game.Free;
      end;
    finally
      Game := LGame;
    end;
  except
    on E: Exception do
    begin
      LMsg := Format('%s: %s', [E.ClassName, E.Message]);
      SDL_ShowSimpleMessageBox(SDL_MESSAGEBOX_ERROR, 'Fatal Error', LMarshaller.AsUtf8(LMsg).ToPointer, nil);
    end;
  end;
end;

{ TLuPoint }
class operator TLuPoint.Implicit(aValue: TLuPoint): SDL_Point;
begin
  Result.x := Round(aValue.X);
  Result.y := Round(aValue.Y);
end;

class operator TLuPoint.Implicit(aValue: TLuPoint): SDL_FPoint;
begin
  Result.x := aValue.X;
  Result.y := aValue.Y;
end;

class operator TLuPoint.Implicit(aValue: SDL_Point): TLuPoint;
begin
  Result.X := aValue.x;
  Result.Y := aValue.y;
end;

class operator TLuPoint.Implicit(aValue: SDL_FPoint): TLuPoint;
begin
  Result.X := aValue.x;
  Result.Y := aValue.y;
end;

class operator TLuPoint.Initialize(out aDest: TLuPoint);
begin
  aDest.X := 0;
  aDest.Y := 0;
end;

{ TLuVector }
class operator TLuVector.Initialize(out aDest: TLuVector);
begin
  aDest.X := 0;
  aDest.Y := 0;
  aDest.Z := 0;
  aDest.W := 0;
end;

{ TLuRect }
class operator TLuRect.Implicit(aValue: TLuRect): SDL_Rect;
begin
  Result.x := Round(aValue.X);
  Result.y := Round(aValue.Y);
  Result.w := Round(aValue.Width);
  Result.h := Round(aValue.Height);
end;

class operator TLuRect.Implicit(aValue: TLuRect): SDL_FRect;
begin
  Result.x := aValue.X;
  Result.y := aValue.Y;
  Result.w := aValue.Width;
  Result.h := aValue.Height;
end;

class operator TLuRect.Implicit(aValue: SDL_Rect): TLuRect;
begin
  Result.X := aValue.x;
  Result.Y := aValue.y;
  Result.Width := aValue.w;
  Result.Height := aValue.h;
end;

class operator TLuRect.Implicit(aValue: SDL_FRect): TLuRect;
begin
  Result.X := aValue.x;
  Result.Y := aValue.y;
  Result.Width := aValue.w;
  Result.Height := aValue.h;
end;

class operator TLuRect.Initialize(out aDest: TLuRect);
begin
  aDest.X := 0;
  aDest.Y := 0;
  aDest.Width := 0;
  aDest.Height := 0;
end;

{ TBaseObject }
function TLuBaseObject.GetAttribute(aIndex: Byte): Boolean;
begin
  Result := Boolean(aIndex in FAttributes);
end;

procedure TLuBaseObject.SetAttribute(aIndex: Byte; aValue: Boolean);
begin
  if aValue then
    Include(FAttributes, aIndex)
  else
    Exclude(FAttributes, aIndex);
end;

function TLuBaseObject.GetAttributes: TLuObjectAttributeSet;
begin
  Result := FAttributes;
end;

procedure TLuBaseObject.SetAttributes(aValue: TLuObjectAttributeSet);
begin
  FAttributes := aValue;
end;

constructor TLuBaseObject.Create;
begin
  inherited;
  FOwner := nil;
  FPrev := nil;
  FNext := nil;
  FAttributes := [];
  Game.MasterObjectList.Add(Self);
end;

destructor TLuBaseObject.Destroy;
begin
  Game.MasterObjectList.Remove(Self, False);
  inherited;
end;

function TLuBaseObject.AttributesAreSet(aAttrs: TLuObjectAttributeSet): Boolean;
var
  LAttr: Byte;
begin
  Result := False;
  for LAttr in aAttrs do
  begin
    if LAttr in FAttributes then
    begin
      Result := True;
      Break;
    end;
  end;
end;

{ TBaseObjectList }
constructor TLuBaseObjectList.Create;
begin
  inherited;
  FHead := nil;
  FTail := nil;
  FCount := 0;
end;

destructor TLuBaseObjectList.Destroy;
begin
  Clean;
  inherited;
end;

procedure TLuBaseObjectList.Add(aObject: TLuBaseObject);
begin
  if not Assigned(aObject) then Exit;

  // check if already on this list
  if aObject.FOwner = Self then Exit;

  // remove if on another list
  if Assigned(aObject.FOwner) then
  begin
    aObject.FOwner.Remove(aObject, False);
  end;

  aObject.Prev := FTail;
  aObject.Next := nil;
  aObject.FOwner := Self;

  if FHead = nil then
    begin
      FHead := aObject;
      FTail := aObject;
    end
  else
    begin
      FTail.Next := aObject;
      FTail := aObject;
    end;

  Inc(FCount);
end;

procedure TLuBaseObjectList.Remove(aObject: TLuBaseObject; aDispose: Boolean);
var
  LFlag: Boolean;
begin
  if not Assigned(aObject) then Exit;

  // check if aObject is on this list
  if aObject.Owner <> Self then Exit;

  LFlag := False;

  if aObject.Next <> nil then
  begin
    aObject.Next.Prev := aObject.Prev;
    LFlag := True;
  end;

  if aObject.Prev <> nil then
  begin
    aObject.Prev.Next := aObject.Next;
    LFlag := True;
  end;

  if FTail = aObject then
  begin
    FTail := FTail.Prev;
    LFlag := True;
  end;

  if FHead = aObject then
  begin
    FHead := FHead.Next;
    LFlag := True;
  end;

  if LFlag = True then
  begin
    aObject.FOwner := nil;
    Dec(FCount);
    if aDispose then
    begin
      aObject.Free;
    end;
  end;
end;

procedure TLuBaseObjectList.Clean;
var
  LPrev: TLuBaseObject;
  LNext: TLuBaseObject;
begin
  // get pointer to head
  LPrev := FHead;

  // exit if list is empty
  if LPrev = nil then
    Exit;

  repeat
    // save pointer to next object
    LNext := LPrev.Next;

    Remove(LPrev, True);

    // get pointer to next object
    LPrev := LNext;

  until LPrev = nil;
end;

procedure TLuBaseObjectList.Clear(aAttrs: TLuObjectAttributeSet);
var
  LPrev: TLuBaseObject;
  LNext: TLuBaseObject;
  LNoAttrs: Boolean;
begin
  // get pointer to head
  LPrev := FHead;

  // exit if list is empty
  if LPrev = nil then Exit;

  // check if we should check for attrs
  LNoAttrs := Boolean(aAttrs = []);

  repeat
    // save pointer to next object
    LNext := LPrev.Next;

    if LNoAttrs then
      begin
        Remove(LPrev, True);
      end
    else
      begin
        if LPrev.AttributesAreSet(aAttrs) then
        begin
          Remove(LPrev, True);
        end;
      end;

    // get pointer to next object
    LPrev := LNext;

  until LPrev = nil;
end;

{ TLuCloudDb }
procedure TLuCloudDb.SetMacroValue(const aName, aValue: string);
begin
  FPrepairedSQL := FPrepairedSQL.Replace('&'+aName, aValue);
end;

procedure TLuCloudDb.SetParamValue(const aName, aValue: string);
begin
  FPrepairedSQL := FPrepairedSQL.Replace(':'+aName, ''''+aValue+'''');
end;

procedure TLuCloudDb.Prepair;
var
  LKey: string;
begin
  FPrepairedSQL := FSQL.Text;

  // substitue macros
  for LKey in FMacros.Keys do
  begin
    SetMacroValue(LKey, FMacros.Items[LKey]);
  end;

  // substitue field params
  for LKey in FParams.Keys do
  begin
    SetParamValue(LKey, FParams.Items[LKey]);
  end;

end;

constructor  TLuCloudDb.Create;
begin
  inherited;
  FSQL := TStringList.Create;
  FHttp := THTTPClient.Create;
  FMacros := TDictionary<string, string>.Create;
  FParams := TDictionary<string, string>.Create;
end;

destructor TLuCloudDb.Destroy;
begin
  if Assigned(FJson) then Game.FreeNilObject(FJson);
  Game.FreeNilObject(FParams);
  Game.FreeNilObject(FMacros);
  Game.FreeNilObject(FHttp);
  Game.FreeNilObject(FSQL);
  inherited;
end;

procedure TLuCloudDb.Setup(const aURL, aApiKey, aDatabase: string);
begin
  FUrl := aURL + cURL;
  FApiKey := aApiKey;
  FDatabase := aDatabase;
end;

procedure TLuCloudDb.ClearSQLText;
begin
  FSQL.Clear;
end;

procedure TLuCloudDb.AddSQLText(const aText: string; const aArgs: array of const);
begin
  FSQL.Add(Format(aText, aArgs));
end;

function  TLuCloudDb.GetSQLText: string;
begin
  Result := FSQL.Text;
end;

procedure TLuCloudDb.SetSQLText(const aText: string);
begin
  FSQL.Text := aText;
end;

function  TLuCloudDb.GetMacro(const aName: string): string;
begin
  FMacros.TryGetValue(aName, Result);
end;

procedure TLuCloudDb.SetMacro(const aName, aValue: string);
begin
  FMacros.AddOrSetValue(aName, aValue);
end;

function  TLuCloudDb.GetParam(const aName: string): string;
begin
  FParams.TryGetValue(aName, Result);
end;

procedure TLuCloudDb.SetParam(const aName, aValue: string);
begin
  FParams.AddOrSetValue(aName, aValue);
end;

function  TLuCloudDb.RecordCount: Integer;
begin
  Result := 0;
  if not Assigned(FDataset) then Exit;
  Result := FDataset.Count;
end;

function  TLuCloudDb.GetField(const aIndex: Cardinal; const aName: string): string;
begin
  Result := '';
  if not Assigned(FDataset) then Exit;
  if aIndex > Cardinal(FDataset.Count-1) then Exit;
  Result := FDataset.Items[aIndex].GetValue<string>(aName);
end;

function  TLuCloudDb.GetQueryURL(const aSQL: string): string;
begin
  Result := Format(FUrl, [FApiKey, FDatabase, aSQL]);
end;

function  TLuCloudDb.GetPrepairedSQL: string;
begin
  Result := FPrepairedSQL;
end;

function TLuCloudDb.Execute: Boolean;
begin
  Prepair;
  Result := ExecuteSQL(FPrepairedSQL);
end;

function  TLuCloudDb.ExecuteSQL(const aSQL: string): Boolean;
var
  LResponse: IHTTPResponse;
begin
  Result := False;
  LResponse := FHttp.Get(GetQueryURL(aSQL));
  FResponseText := LResponse.ContentAsString;
  if Assigned(FJson) then
  begin
    Game.FreeNilObject(FJson);
    FDataset := nil;
  end;
  FJson := TJSONObject.ParseJSONValue(FResponseText) as TJSONObject;
  FLastError := FJson.GetValue('response').Value;
  Result := Boolean(FLastError.IsEmpty or SameText(FLastError, 'true'));
  if FLastError.IsEmpty then
  begin
    if Assigned(FDataset) then Game.FreeNilObject(FDataset);
    FJson.TryGetValue('response', FDataset);
  end;
  if not Assigned(FDataset) then
    Game.FreeNilObject(FJson);
end;

function TLuCloudDb.GetLastError: string;
begin
  Result := FLastError;
end;

function TLuCloudDb.GetResponseText: string;
begin
  Result:= FResponseText;
end;

{ TLuGame }
constructor TLuGame.Create;
begin
  inherited;

  FOrgName := 'tinyBigGAMES';
  FAppName := 'LunaGameToolkit';

  // init master object list
  FMasterObjectList := TLuBaseObjectList.Create;
end;

destructor TLuGame.Destroy;
begin
  // free master object list
  FreeNilObject(FMasterObjectList);

  inherited;
end;

function  TLuGame.OnStartup: Boolean;
begin
  Result := True;
end;

procedure TLuGame.OnShutdown;
begin
  // clean master list
  FMasterObjectList.Clean;
end;

procedure TLuGame.OnRun;
begin
end;

function  TLuGame.HasConsoleOutput: Boolean;
var
  LStdout: THandle;
begin
  Result := False;
  LStdout := GetStdHandle(STD_OUTPUT_HANDLE);
  if LStdout = Invalid_Handle_Value then Exit;
  Result := Boolean(LStdout <> 0);
end;

function  TLuGame.HasConsoleOnStartup: Boolean;
var
  LConsoleHWnd: THandle;
  LProcessId: DWORD;
begin
  LConsoleHWnd := GetConsoleWindow;
  if LConsoleHWnd <> 0 then
    begin
      GetWindowThreadProcessId(LConsoleHWnd, LProcessId);
      Result := GetCurrentProcessId <> LProcessId;
    end
  else
    Result := False;
end;

procedure TLuGame.WaitForAnyKey;
var
  LInputRec: TInputRecord;
  LNumRead: Cardinal;
  LOldMode: DWORD;
  LStdIn: THandle;
begin
  LStdIn := GetStdHandle(STD_INPUT_HANDLE);
  GetConsoleMode(LStdIn, LOldMode);
  SetConsoleMode(LStdIn, 0);
  repeat
    ReadConsoleInput(LStdIn, LInputRec, 1, LNumRead);
  until (LInputRec.EventType and KEY_EVENT <> 0) and LInputRec.Event.KeyEvent.bKeyDown;
  SetConsoleMode(LStdIn, LOldMode);
end;

procedure TLuGame.Pause(const aMsg: string);
begin
  if HasConsoleOutput and (not HasConsoleOnStartup) then
  begin
    WriteLn;
    if aMsg.IsEmpty then
      Write('Press any key to continue... ')
    else
      Write(aMsg);
    WaitForAnyKey;
    WriteLn;
  end;
end;

procedure TLuGame.Print(const aMsg: string);
begin
  Print(aMsg, []);
end;

procedure TLuGame.Print(const aMsg: string; const aArgs: array of const);
begin
  if not HasConsoleOutput then Exit;
  Write(Format(aMsg, aArgs));
end;

procedure TLuGame.PrintLn;
begin
  PrintLn('', []);
end;

procedure TLuGame.PrintLn(const aMsg: string);
begin
  PrintLn(aMsg, []);
end;

procedure TLuGame.PrintLn(const aMsg: string; const aArgs: array of const);
begin
  if not HasConsoleOutput then Exit;
  WriteLn(Format(aMsg, aArgs));
end;

{ Utils }
procedure TLuGame.ShellOpen(const aFilename: string);
begin
  if aFilename.IsEmpty then Exit;
  ShellExecute(0, 'OPEN', PChar(aFilename), '', '', SW_SHOWNORMAL);
end;

function  TLuGame.GetVersionInfo(aInstance: THandle; aIdent: string): string;
type
  TLang = packed record
    Lng, Page: WORD;
  end;
  TLangs = array [0 .. 10000] of TLang;
  PLangs = ^TLangs;
var
  BLngs: PLangs;
  BLngsCnt: Cardinal;
  BLangId: String;
  RM: TMemoryStream;
  RS: TResourceStream;
  BP: PChar;
  BL: Cardinal;
  BId: String;

begin
  // Assume error
  Result := '';

  RM := TMemoryStream.Create;
  try
    // Load the version resource into memory
    RS := TResourceStream.CreateFromID(aInstance, 1, RT_VERSION);
    try
      RM.CopyFrom(RS, RS.Size);
    finally
      FreeNilObject(RS);
    end;

    // Extract the translations list
    if not VerQueryValue(RM.Memory, '\\VarFileInfo\\Translation', Pointer(BLngs), BL) then
      Exit; // Failed to parse the translations table
    BLngsCnt := BL div sizeof(TLang);
    if BLngsCnt <= 0 then
      Exit; // No translations available

    // Use the first translation from the table (in most cases will be OK)
    with BLngs[0] do
      BLangId := IntToHex(Lng, 4) + IntToHex(Page, 4);

    // Extract field by parameter
    BId := '\\StringFileInfo\\' + BLangId + '\\' + aIdent;
    if not VerQueryValue(RM.Memory, PChar(BId), Pointer(BP), BL) then
      exit; // No such field

    // Prepare result
    Result := BP;
  finally
    FreeNilObject(RM);
  end;
end;

function  TLuGame.GetVersionInfo(const aFilename: string; aIdent: string): string;
begin
  Result := GetVersionInfo(GetModuleHandle(PChar(aFilename)), aIdent);
end;

procedure TLuGame.FreeNilObject(const [ref] aObject: TObject);
var
  LObject: TObject;
begin
  if not Assigned(aObject) then Exit;
  LObject := aObject;
  TObject(Pointer(@aObject)^) := nil;
  LObject.Free;
end;

function TLuGame.UnitToScalarValue(const aValue, aMaxValue: Double): Double;
var
  LGain: Double;
  LFactor: Double;
  LVolume: Double;
begin
  LGain := (EnsureRange(aValue, 0.0, 1.0) * 50) - 50;
  LFactor := Power(10, LGain * 0.05);
  LVolume := EnsureRange(aMaxValue * LFactor, 0, aMaxValue);
  Result := LVolume;
end;

function TLuGame.HttpGet(const aURL: string; aStatus: PString=nil): string;
var
  LHttp: THTTPClient;
  LResponse: IHTTPResponse;
begin
  LHttp := THTTPClient.Create;
  try
    LResponse := LHttp.Get(aURL);
    Result := LResponse.ContentAsString;
    if Assigned(aStatus) then
      aStatus^ := LResponse.StatusText;
  finally
    FreeNilObject(LHttp);
  end;
end;

{ Prefs }
function  TLuGame.GetOrgName: string;
begin
  Result := FOrgName;
end;

procedure TLuGame.SetOrgName(const aOrgName: string);
begin
  FOrgName := aOrgName;
end;

function  TLuGame.GetAppName: string;
begin
  Result := FAppName;
end;

procedure TLuGame.SetAppName(const aAppName: string);
begin
  FAppName := aAppName;
end;

function  TLuGame.GetPrefsPath: string;
begin
  Result := string(SDL_GetPrefPath(FMarshaller.AsUtf8(FOrgName).ToPointer, FMarshaller.AsUtf8(FAppName).ToPointer));
end;

procedure TLuGame.GotoPrefsPath;
begin
  ShellOpen(GetPrefsPath);
end;

//===========================================================================
// insert code above
//===========================================================================
{$I Deps.Impl.inc}

initialization
begin
  ReportMemoryLeaksOnShutdown := True;
  LoadDLL;
end;

finalization
begin
  UnloadDLL;
end;

end.
