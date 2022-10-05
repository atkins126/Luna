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

unit uLuArc;

interface

uses
  System.SysUtils,
  Luna;

type
  { TLuArc }
  TLuArc = class(TLuGame)
  public
    procedure OnSetSettings; override;
    procedure OnRun; override;
  end;

implementation

uses
  System.IOUtils;

{ TLuArc }
procedure TLuArc.OnSetSettings;
begin
  inherited;

  // Gameloop
  Settings.StartGameLoop := False;

  // Logger
  Settings.LogToConsole := False;
end;

procedure TLuArc.OnRun;
var
  LPassword: string;
  LArchiveFilename: string;
  LDirectoryName: string;

  procedure Header;
  begin
    PrintLn('', []);
    PrintLn('LuArc™ v%s', [GetVersion]);
    PrintLn('Luna Game Toolkit™ Archive Utility', []);
    PrintLn('Copyright © 2022 tinyBigGAMES™ LLC', []);
    PrintLn('All Rights Reserved.', []);
  end;

  procedure Usage;
  begin
    PrintLn('', []);
    PrintLn('Usage: LuArc [password] archivename[.arc] directoryname', []);
    PrintLn('  password      - make archive password protected', []);
    PrintLn('  archivename   - zip archive name', []);
    PrintLn('  directoryname - directory to archive', []);
  end;

begin
  // init local vars
  LPassword := '';
  LArchiveFilename := '';
  LDirectoryName := '';

  // display header
  Header;

  // check for password, archive, directory
  if ParamCount = 3 then
    begin
      LPassword := ParamStr(1);
      LArchiveFilename := ParamStr(2);
      LDirectoryName := ParamStr(3);
      LPassword := LPassword.DeQuotedString;
      LArchiveFilename := LArchiveFilename.DeQuotedString;
      LDirectoryName := LDirectoryName.DeQuotedString;
    end
  // check for archive directory
  else if ParamCount = 2 then
    begin
      LArchiveFilename := ParamStr(1);
      LDirectoryName := ParamStr(2);
      LArchiveFilename := LArchiveFilename.DeQuotedString;
      LDirectoryName := LDirectoryName.DeQuotedString;
    end
  else
    begin
      // show usage
      Usage;
      Pause;
      Exit;
    end;

  // init archive filename
  if TPath.GetExtension(LArchiveFilename).IsEmpty then
    LArchiveFilename := TPath.ChangeExtension(LArchiveFilename, cLuArcExt);

  // check if directory exist
  if not TDirectory.Exists(LDirectoryName) then
    begin
      PrintLn;
      PrintLn('Directory was not found: ', [LDirectoryName]);
      Usage;
      Pause;
      Exit;
    end;

  // display params
  PrintLn;
  if LPassword = '' then
    PrintLn('Password : NONE')
  else
    PrintLn('Password : %s', [LPassword]);
  PrintLn('Archive  : %s', [LArchiveFilename]);
  PrintLn('Directory: %s', [LDirectoryName]);

  // try to build archive
  if BuildArchive(LPassword, LArchiveFilename, LDirectoryName) then
    PrintLn(cLuLF+'Success!')
  else
    PrintLn(cLuLF+'Failed!');
  Pause;
end;

end.
