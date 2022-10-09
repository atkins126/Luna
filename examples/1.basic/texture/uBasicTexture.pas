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

unit uBasicTexture;

interface

uses
  System.SysUtils,
  Luna;

type

  { TBasicTexture }
  TBasicTexture = class(TLuGame)
  protected
    FTexture: TLuTexture;
    FOrigin: TLuVector;
  public
    procedure OnSetSettings; override;
    function  OnStartup: Boolean; override;
    procedure OnShutdown; override;
    procedure OnRender; override;
  end;

implementation

{ TBasicTexture }
procedure TBasicTexture.OnSetSettings;
begin
  inherited;

  // Window
  Settings.WindowTitle := 'Luna Game Toolkit - Texture [Basic]';

  // Archive
  Settings.ArchivePassword := '6aace89f6ed348bd836360345eeb5ad9';
  Settings.ArchiveFilename := 'Data.arc';
end;

function  TBasicTexture.OnStartup: Boolean;
begin
  Result := False;

  if not inherited then Exit;

  // Create/Load texture
  FTexture := TLuTexture.Create;
  FTexture.Load(Archive, 'arc/images/Luna2.png', nil);

  // Init texture center origin
  FOrigin.Assign(0.5, 0.5);

  Result := True;
end;

procedure TBasicTexture.OnShutdown;
begin
  FreeNilObject(FTexture);

  inherited;
end;

procedure TBasicTexture.OnRender;
begin
  inherited;

  // Render textured centered on display using native PNG transparency
  FTexture.Render(nil, Settings.WindowWidth/2, Settings.WindowHeight/2, 1, 0,
    fmNone, @FOrigin, cLuWhite, bmAdd);
end;

end.
