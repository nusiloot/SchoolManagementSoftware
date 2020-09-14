; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Administraci�n de Colegios Pymesoft"
#define MyAppVerName "Administraci�n de Colegios Pymesoft v1.0.0"
#define MyAppPublisher "Pymesoft Argentina"
#define MyAppURL "http://www.pymesoft.com.ar"
#define MyAppExeName "Colegios.exe"

[Setup]
AppName={#MyAppName}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName}
DisableDirPage=yes
DefaultGroupName={#MyAppName}
OutputDir=C:\Users\netanel\Documents\GitHub\SchoolManagmentSoftware\dist
OutputBaseFilename=Instalar_Colegios_Pymesoft
SetupIconFile=Logo.ico
Compression=lzma
SolidCompression=yes

[Languages]
Name: Spanish; MessagesFile: compiler:Languages\Spanish.isl

[Tasks]
Name: desktopicon; Description: {cm:CreateDesktopIcon}; GroupDescription: {cm:AdditionalIcons}
Name: quicklaunchicon; Description: {cm:CreateQuickLaunchIcon}; GroupDescription: {cm:AdditionalIcons}

[Files]
Source: Colegios.exe; DestDir: {app}; Flags: ignoreversion; Components: Cliente; AfterInstall: SetFirewallException('Sistema de Colegios','Colegios.exe')
Source: base.db; DestDir: {app}; Flags: uninsneveruninstall onlyifdoesntexist; Components: Servidor; OnlyBelowVersion: 0,5.0.2194
Source: base.db; DestDir: {app}; Flags: uninsneveruninstall onlyifdoesntexist; Components: Servidor; MinVersion: 0,5.0.2195
Source: Logo.ico; DestDir: {app}; Flags: ignoreversion; Components: Cliente
Source: user.png; DestDir: {app}; Flags: ignoreversion; Components: Cliente
Source: password.png; DestDir: {app}; Flags: ignoreversion; Components: Cliente

; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: {group}\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Components: Cliente; Comment: Sistema de Administraci�n de Colegios Pymesoft
Name: {group}\{cm:ProgramOnTheWeb,{#MyAppName}}; Filename: {#MyAppURL}; Comment: Sitio web del Desarrollador
Name: {commondesktop}\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Tasks: desktopicon; Components: Cliente; Comment: Administraci�n de Colegios Pymesoft
Name: {userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}; Filename: {app}\{#MyAppExeName}; Tasks: quicklaunchicon; Components: Cliente; Comment: Administraci�n de Colegios Pymesoft

[Run]
Filename: {app}\{#MyAppExeName}; Description: {cm:LaunchProgram,{#MyAppName}}. No concluya la instalaci�n hasta que la misma finalice; Flags: nowait postinstall skipifsilent; Components: Cliente; WorkingDir: {app}; Tasks: ; Languages: 

[Components]
Name: Servidor; Description: Servidor del Sistema de Colegios; Types: Servidor Completa; Languages:
Name: Cliente; Description: Cliente del Sistema de Colegios; Types: Cliente Completa

[Types]
Name: Completa; Description: Instalaci�n completa (Cliente + Servidor)
Name: Cliente; Description: Cliente del Sistema de Colegios
Name: Servidor; Description: Servidor del Sistema de Colegios; Languages: 

[Code]
const
  NET_FW_SCOPE_ALL = 0;
  NET_FW_IP_VERSION_ANY = 2;
  
procedure SetFirewallException(AppName,FileName:string);
var
  FirewallObject: Variant;
  FirewallManager: Variant;
  FirewallProfile: Variant;
  server: string;
begin
  try
    FirewallObject := CreateOleObject('HNetCfg.FwAuthorizedApplication');
    FirewallObject.Name := AppName;
    FirewallObject.IpVersion := NET_FW_IP_VERSION_ANY;
    server := ExpandConstant('{app}')+'\'+FileName;
    FirewallObject.ProcessImageFileName := server;
    FirewallObject.RemoteAddresses := '*';
    FirewallObject.Scope := NET_FW_SCOPE_ALL;
    FirewallObject.Enabled := True;
    FirewallManager := CreateOleObject('HNetCfg.FwMgr');
    FirewallProfile := FirewallManager.LocalPolicy.CurrentProfile;
    FirewallProfile.AuthorizedApplications.Add(FirewallObject);
  except
  end;
end;

procedure RemoveFirewallException( FileName:string );
var
  FirewallManager: Variant;
  FirewallProfile: Variant;
  server : string;
begin
  try
    FirewallManager := CreateOleObject('HNetCfg.FwMgr');
    FirewallProfile := FirewallManager.LocalPolicy.CurrentProfile;
    server := ExpandConstant('{app}')+'\'+FileName;
    FireWallProfile.AuthorizedApplications.Remove(server);
  except
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  case CurUninstallStep of
    usPostUninstall:
      begin
        // ...insert code to perform post-uninstall tasks here...
        RemoveFirewallException('Colegios.exe');
      end;
  end;
end;