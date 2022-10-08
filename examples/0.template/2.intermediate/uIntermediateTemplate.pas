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

unit uIntermediateTemplate;

interface

uses
  System.SysUtils,
  Luna;

type

  { TIntermediateTemplate }
  TIntermediateTemplate = class(TLuGame)
  protected
  public
    procedure OnSetSettings; override;
    function  OnStartup: Boolean; override;
    procedure OnShutdown; override;
    procedure OnReady(const aReady: Boolean); override;
    procedure OnClearWindow; override;
    procedure OnUpdate(const aDeltaTime: Double); override;
    procedure OnFixedUpdate(const aFixedUpdateSpeed: Single); override;
    procedure OnRender; override;
    procedure OnRenderHud; override;
    procedure OnShowWindow; override;
    procedure OnSpeechWord(const aWord, aText: string); override;
    procedure OnArchiveBuildProgress(const aFilename: string; const aProgress: Integer; const aNewFile: Boolean); override;
    procedure OnVideoStatus(const aStatus: Cardinal; const aFilename: string); override;
    procedure OnRun; override;
  end;

implementation

{ TIntermediateTemplate }
procedure TIntermediateTemplate.OnSetSettings;
begin
  inherited;

  // Window
  Settings.WindowTitle := 'Luna Game Toolkit - Intermediate Template';

  // Archive
  Settings.ArchivePassword := '6aace89f6ed348bd836360345eeb5ad9';
  Settings.ArchiveFilename := 'Data.arc';
end;

function  TIntermediateTemplate.OnStartup: Boolean;
begin
  Result := False;

  if not inherited then Exit;

  Result := True;
end;

procedure TIntermediateTemplate.OnShutdown;
begin
  inherited;
end;

procedure TIntermediateTemplate.OnReady(const aReady: Boolean);
begin
  inherited;
end;

procedure TIntermediateTemplate.OnClearWindow;
begin
  inherited;
end;

procedure TIntermediateTemplate.OnUpdate(const aDeltaTime: Double);
begin
  inherited;
end;

procedure TIntermediateTemplate.OnFixedUpdate(const aFixedUpdateSpeed: Single);
begin
  inherited;
end;

procedure TIntermediateTemplate.OnRender;
begin
  inherited;
end;

procedure TIntermediateTemplate.OnRenderHud;
begin
  inherited;
end;

procedure TIntermediateTemplate.OnShowWindow;
begin
  inherited;
end;

procedure TIntermediateTemplate.OnSpeechWord(const aWord, aText: string);
begin
  inherited;
end;

procedure TIntermediateTemplate.OnArchiveBuildProgress(const aFilename: string; const aProgress: Integer; const aNewFile: Boolean);
begin
  inherited;
end;

procedure TIntermediateTemplate.OnVideoStatus(const aStatus: Cardinal; const aFilename: string);
begin
  inherited;
end;

procedure TIntermediateTemplate.OnRun;
begin
  inherited;
end;

end.
