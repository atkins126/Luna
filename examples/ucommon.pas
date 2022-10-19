unit ucommon;

interface

uses
  System.SysUtils,
  Luna;

const
  cArchivePassword = '6aace89f6ed348bd836360345eeb5ad9';
  cArchiveFilename = 'Data.arc';
  cWindowTitle     = 'Luna Game Toolkit - ';

type

  { TBaseTemplate }
  TBaseTemplate = class(TLuGame)
  protected
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

procedure TBaseTemplate.OnRun;
begin
  inherited;
end;

procedure TBaseTemplate.OnSettings;
begin
  inherited;

  Settings.ArchivePassword := cArchivePassword;
  Settings.ArchiveFilename := cArchiveFilename;

  Settings.WindowTitle := cWindowTitle;

end;

procedure TBaseTemplate.OnApplySettings;
begin
  inherited;
end;

procedure TBaseTemplate.OnUnapplySettings;
begin
  inherited;
end;

procedure TBaseTemplate.OnStartup;
begin
  inherited;
end;

procedure TBaseTemplate.OnShutdown;
begin
  inherited;
end;

procedure TBaseTemplate.OnReady(const aReady: Boolean);
begin
  inherited;
end;

procedure TBaseTemplate.OnClearWindow;
begin
  inherited;
end;

procedure TBaseTemplate.OnUpdate(const aDeltaTime: Double);
begin
  inherited;
end;

procedure TBaseTemplate.OnFixedUpdate(const aFixedUpdateSpeed: Single);
begin
  inherited;
end;

procedure TBaseTemplate.OnRender;
begin
  inherited;
end;

procedure TBaseTemplate.OnRenderHud;
begin
  inherited;
end;

procedure TBaseTemplate.OnShowWindow;
begin
  inherited;
end;

procedure TBaseTemplate.OnSpeechWord(const aWord, aText: string);
begin
  inherited;
end;

procedure TBaseTemplate.OnVideoStatus(const aStatus: TLuVideoStatus; const aFilename: string);
begin
  inherited;
end;

procedure TBaseTemplate.OnBuildArchiveProgress(const aFilename: string; aProgress: Cardinal; const aNewFile: Boolean);
begin
  inherited;
end;

end.
