﻿{==============================================================================
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

unit uentity_collision;

interface

uses
  System.SysUtils,
  Luna,
  uCommon;

type

  TExample = class(TBaseTemplate)
  protected
    FBoss: TLuEntity;
    FFigure: TLuEntity;
    FHitPos: TLuVector;
    FCollide: Boolean;
  public
    procedure OnRun; override;
    procedure OnSettings; override;
    procedure OnApplySettings; override;
    procedure OnUnapplySettings; override;
    procedure OnStartup; override;
    procedure OnShutdown; override;
    procedure OnReady(const aReady: Boolean); override;
    procedure OnClearWindow; override;
    procedure OnUpdate(const aDeltaTime: Double); override;
    procedure OnFixedUpdate(const aFixedUpdateSpeed: Single); override;
    procedure OnRender; override;
    procedure OnRenderHud; override;
    procedure OnShowWindow; override;
    procedure OnSpeechWord(const aWord, aText: string); override;
    procedure OnVideoStatus(const aStatus: TLuVideoStatus; const aFilename: string); override;
    procedure OnBuildArchiveProgress(const aFilename: string; aProgress: Cardinal; const aNewFile: Boolean); override;
  end;

implementation

procedure TExample.OnRun;
begin
  inherited;
end;

procedure TExample.OnSettings;
begin
  inherited;

  Settings.WindowTitle := Settings.WindowTitle + 'Entity Collision [intermediate]';

end;

procedure TExample.OnApplySettings;
begin
  inherited;
end;

procedure TExample.OnUnapplySettings;
begin
  inherited;
end;

procedure TExample.OnStartup;
begin
  inherited;

  Sprite.LoadPage(Archive, 'arc/images/boss.png', nil);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(0, 0, 0, 0, 128, 128);
  Sprite.AddImageFromGrid(0, 0, 1, 0, 128, 128);
  Sprite.AddImageFromGrid(0, 0, 0, 1, 128, 128);

  Sprite.LoadPage(Archive, 'arc/images/figure.png', nil);
  Sprite.AddGroup;
  Sprite.AddImageFromGrid(1, 1, 0, 0, 128, 128);


  FBoss := TLuEntity.Create;
  FBoss.Init(Sprite, 0);
  FBoss.SetFrameFPS(14);
  FBoss.SetPosAbs(Settings.WindowWidth/2, (Settings.WindowHeight/2)-128);
  FBoss.TracePolyPoint(6, 12, 70, nil);
  FBoss.SetRenderPolyPoint(True);

  FFigure := TLuEntity.Create;
  FFigure.Init(Sprite, 1);
  FFigure.SetFrameFPS(14);
  FFigure.SetPosAbs(Settings.WindowWidth/2, Settings.WindowHeight/2);
  FFigure.TracePolyPoint(6, 12, 70, nil);
  FFigure.SetRenderPolyPoint(True);
end;

procedure TExample.OnShutdown;
begin
  FreeNilObject(FFigure);
  FreeNilObject(FBoss);

  inherited;
end;

procedure TExample.OnReady(const aReady: Boolean);
begin
  inherited;

end;

procedure TExample.OnClearWindow;
begin
  inherited;
end;

procedure TExample.OnUpdate(const aDeltaTime: Double);
begin
  inherited;

  FBoss.NextFrame;
  FBoss.ThrustToPos(30*50, 14*50, MousePos.X, MousePos.Y, 128, 32, 5*50, cLuEPSILON, aDeltaTime);
  if FBoss.CollidePolyPoint(FFigure, FHitPos) then
    FCollide := True
  else
    FCollide := False;

  FFigure.NextFrame;
  FHitPos.Z :=  FHitPos.Z + (30.0 * aDeltaTime);
  Math.ClipValuef(FHitPos.Z, 0, 359, True);
  FFigure.RotateAbs(FHitPos.Z);
end;

procedure TExample.OnFixedUpdate(const aFixedUpdateSpeed: Single);
begin
  inherited;
end;

procedure TExample.OnRender;
begin
  inherited;

  FFigure.Render(0, 0);
  FBoss.Render(0, 0);
  if FCollide then
    Window.DrawFilledRect(FHitPos.X, FHitPos.Y, 10, 10, cLuRed);
end;

procedure TExample.OnRenderHud;
begin
  inherited;
end;

procedure TExample.OnShowWindow;
begin
  inherited;
end;

procedure TExample.OnSpeechWord(const aWord, aText: string);
begin
  inherited;
end;

procedure TExample.OnVideoStatus(const aStatus: TLuVideoStatus; const aFilename: string);
begin
  inherited;
end;

procedure TExample.OnBuildArchiveProgress(const aFilename: string; aProgress: Cardinal; const aNewFile: Boolean);
begin
  inherited;
end;

end.