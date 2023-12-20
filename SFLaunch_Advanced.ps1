param (
	[switch]$multiplayer = $false,
	[switch]$server = $false,
	[switch]$client = $false,
	[switch]$clienthost = $false,
	[switch]$vanilla = $false,
	[switch]$fallback = $false
)	
	
	# multiplayer for run two windows, server and client
	# server for run server
	# client for run client
	# clienthost run client and autostart game as server
	# vanilla this flag modified config dir. No configs changes
	# fallback same as vanilla, but with little modifications
		
# modified script
# original from https://docs.ficsit.app/satisfactory-modding/latest/Development/TestingResources.html#LaunchScript


##### EDITABLE VARS

$CommonArgs = "-log", "-offline", "-NoSteamClient", "-NoEpicPortal",  "-unattended", "-nothreadtimeout", "-nosplash", "-USEALLAVAILABLECORES", "-multihome=0.0.0.0", "-locallogtimes", "-EnableParallelCharacterMovementTickFunction", "-EnableParallelCharacterTickFunction", "-UseDynamicPhysicsScene", "-DisablePacketRouting", "-EpicApp=Satisfactory", "-EOSArtifactNameOverride=Satisfactory", "-EOSArtifactNameOverride=Satisfactory", "-ExecCmds=`"r.DFShadowQuality=0`"", "-Multiprocess"

$DefaultMapOptions = "DayLength=3600?NightLength=1?Visibility=SV_FriendsOnly?adminpassword=uselesspassword?bUseIpSockets=1?startloc=Grass Fields?advancedGameSettings=FG.GameRules.NoPower=AgAAAAQAAAABAAAA,FG.GameRules.StartingTier=DgAAAAQAAAAJAAAA,FG.GameRules.DisableArachnidCreatures=AgAAAAQAAAABAAAA,FG.GameRules.NoUnlockCost=AgAAAAQAAAABAAAA,FG.GameRules.NoFuel=AgAAAAQAAAABAAAA,FG.GameRules.SetGamePhase=DgAAAAQAAAAEAAAA,FG.GameRules.UnlockAllResearchSchematics=AgAAAAQAAAABAAAA,FG.GameRules.UnlockInstantAltRecipes=AgAAAAQAAAABAAAA,FG.PlayerRules.KeepInventory=DgAAAAQAAAACAAAA,FG.GameRules.UnlockAllResourceSinkSchematics=AgAAAAQAAAABAAAA,FG.PlayerRules.NoBuildCost=AgAAAAQAAAABAAAA,FG.PlayerRules.GodMode=AgAAAAQAAAABAAAA,FG.PlayerRules.FlightMode=AgAAAAQAAAABAAAA?SessionSettings=SML.ForceAllowCheats=AgAAAAQAAAABAAAA?listen"

##### CODE


if (!($server) -AND !($client) -AND !($clienthost)) {
	Write "no launuch options"
	Write "exiting..."
	return
}

if (($client) -AND ($clienthost)) {
	Write "only one client"
	Write "exiting..."
	return
}

if (($server) -AND ($clienthost)) {
	Write "only one server allowed"
	Write "exiting..."
	return
}

$settings = Get-Content -Path 'settings.ini' -Raw | ConvertFrom-StringData
$branch = $settings.branch
$uselesspassword = $settings.adminpassword
$DefaultMapOptions = $DefaultMapOptions.Replace('uselesspassword', $uselesspassword)

	
$GameDefaultMap = $settings.gamemap
#"/Game/FactoryGame/Map/GameLevel01/Persistent_Level.Persistent_Level"	
$MenuDefaultMap = $settings.menumap
#"/Game/FactoryGame/Map/MenuScenes/Map_Menu_Titan_Update8.Map_Menu_Titan_Update8"


if (!$branch) {
	Write "no branch in settings.ini"
	Write "exiting..."
	return
}

$SavesFolder = "C:\Users\$Env:UserName\AppData\Local\FactoryGame\Saved\SaveGames"
$STEAMID = Get-ChildItem -Path $SavesFolder\*7656* -Name
$SaveFolder = $SavesFolder + "\" + $STEAMID

# Configure these to match your system and preferences
$ConfigDir = "$PSScriptRoot\configs"

# local
$GameDir_EA = $PSScriptRoot
$GameDir_EXP = $GameDir_EA

# steam
#$GameDir_EA = "C:\Program Files (x86)\Steam\steamapps\common\Satisfactory"
#$GameDir_EXP = $GameDir_EA

if ($branch -eq "EA") {
	
	$GameDir = $GameDir_EA
	$ConfigBranch = "WindowsNoEditor"
	
} elseif ($branch -eq "EXP") {
	
	$GameDir = $GameDir_EXP
	$ConfigBranch = "Windows"
	
} else {
	Write "unknown branch: '$branch'"
	Write "exiting..."
	return
}

# vanilla
if ($vanilla) {
	$ConfigDir = "$ConfigDir\vanilla"
} elseif ($fallback) {
	$ConfigDir = "$ConfigDir\vanilla\fallback"
}

if (!(Test-Path "$ConfigDir\server\$ConfigBranch")) {
	New-Item -Path "$ConfigDir\server\$ConfigBranch" -ItemType Directory
	New-Item -Path "$ConfigDir\client\$ConfigBranch" -ItemType Directory
}

# server
$def_Engine1_Path = "$ConfigDir\server\$ConfigBranch\def_Engine.ini"
$Engine1_Path = "$ConfigDir\server\$ConfigBranch\Engine.ini"
$GameUserSettings1_Path = "$ConfigDir\server\$ConfigBranch\GameUserSettings.ini"
$Game1_Path = "$ConfigDir\server\$ConfigBranch\Game.ini"
$Input1_Path = "$ConfigDir\server\$ConfigBranch\Input.ini"
$Scalability1_Path = "$ConfigDir\server\$ConfigBranch\Scalability.ini"
$DeviceProfiles1_path = "$ConfigDir\server\$ConfigBranch\DeviceProfiles.ini"
$ApexDestruction1_Path = "$ConfigDir\server\$ConfigBranch\ApexDestruction.ini"
$Compat1_Path = "$ConfigDir\server\$ConfigBranch\Compat.ini"
$ControlRig1_Path = "$ConfigDir\server\$ConfigBranch\ControlRig.ini"
$EditorScriptingUtilities1_Path = "$ConfigDir\server\$ConfigBranch\EditorScriptingUtilities.ini"
$FullBodyIK1_Path = "$ConfigDir\server\$ConfigBranch\FullBodyIK.ini"
$Hardware1_Path = "$ConfigDir\server\$ConfigBranch\Hardware.ini"
$MotoSynth1_Path = "$ConfigDir\server\$ConfigBranch\MotoSynth.ini"
$Niagara1_Path = "$ConfigDir\server\$ConfigBranch\Niagara.ini"
$Paper2D1_Path = "$ConfigDir\server\$ConfigBranch\Paper2D.ini"
$PhysXVehicles1_Path = "$ConfigDir\server\$ConfigBranch\PhysXVehicles.ini"
$RuntimeOptions1_Path = "$ConfigDir\server\$ConfigBranch\RuntimeOptions.ini"
$Synthesis1_Path = "$ConfigDir\server\$ConfigBranch\Synthesis.ini"
$VariantManagerContent1_Path = "$ConfigDir\server\$ConfigBranch\VariantManagerContent.ini"
# more
$Bridge1_Path = "$ConfigDir\server\$ConfigBranch\Bridge.ini"
$ConcertSyncCore1_Path = "$ConfigDir\server\$ConfigBranch\ConcertSyncCore.ini"
$ConsoleVariables1_Path = "$ConfigDir\server\$ConfigBranch\ConsoleVariables.ini"
$DatasmithContent1_Path = "$ConfigDir\server\$ConfigBranch\DatasmithContent.ini"
$EnhancedInput1_Path = "$ConfigDir\server\$ConfigBranch\EnhancedInput.ini"
$GLTFExporter1_Path = "$ConfigDir\server\$ConfigBranch\GLTFExporter.ini"
$IKRig1_Path = "$ConfigDir\server\$ConfigBranch\IKRig.ini"
$InstallBundle1_Path = "$ConfigDir\server\$ConfigBranch\InstallBundle.ini"
$Metasound1_Path = "$ConfigDir\server\$ConfigBranch\Metasound.ini"
$ModelViewViewModel1_Path = "$ConfigDir\server\$ConfigBranch\ModelViewViewModel.ini"
$MovieRenderPipeline1_Path = "$ConfigDir\server\$ConfigBranch\MovieRenderPipeline.ini"
$OnlineIntegration1_Path = "$ConfigDir\server\$ConfigBranch\OnlineIntegration.ini"
$OnlineSubsystemEOS1_Path = "$ConfigDir\server\$ConfigBranch\OnlineSubsystemEOS.ini"
$TraceUtilities1_Path = "$ConfigDir\server\$ConfigBranch\TraceUtilities.ini"
$Wwise1_Path = "$ConfigDir\server\$ConfigBranch\Wwise.ini"
$SML1_Path = "$ConfigDir\server\$ConfigBranch\SML.ini"

# client
$def_Engine2_Path = "$ConfigDir\client\$ConfigBranch\def_Engine.ini"
$Engine2_Path = "$ConfigDir\client\$ConfigBranch\Engine.ini"
$GameUserSettings2_Path = "$ConfigDir\client\$ConfigBranch\GameUserSettings.ini"
$Game2_Path = "$ConfigDir\client\$ConfigBranch\Game.ini"
$Input2_Path = "$ConfigDir\client\$ConfigBranch\Input.ini"
$Scalability2_Path = "$ConfigDir\client\$ConfigBranch\Scalability.ini"
$DeviceProfiles2_path = "$ConfigDir\client\$ConfigBranch\DeviceProfiles.ini"
$ApexDestruction2_Path = "$ConfigDir\client\$ConfigBranch\ApexDestruction.ini"
$Compat2_Path = "$ConfigDir\client\$ConfigBranch\Compat.ini"
$ControlRig2_Path = "$ConfigDir\client\$ConfigBranch\ControlRig.ini"
$EditorScriptingUtilities2_Path = "$ConfigDir\client\$ConfigBranch\EditorScriptingUtilities.ini"
$FullBodyIK2_Path = "$ConfigDir\client\$ConfigBranch\FullBodyIK.ini"
$Hardware2_Path = "$ConfigDir\client\$ConfigBranch\Hardware.ini"
$MotoSynth2_Path = "$ConfigDir\client\$ConfigBranch\MotoSynth.ini"
$Niagara2_Path = "$ConfigDir\client\$ConfigBranch\Niagara.ini"
$Paper2D2_Path = "$ConfigDir\client\$ConfigBranch\Paper2D.ini"
$PhysXVehicles2_Path = "$ConfigDir\client\$ConfigBranch\PhysXVehicles.ini"
$RuntimeOptions2_Path = "$ConfigDir\client\$ConfigBranch\RuntimeOptions.ini"
$Synthesis2_Path = "$ConfigDir\client\$ConfigBranch\Synthesis.ini"
$VariantManagerContent2_Path = "$ConfigDir\client\$ConfigBranch\VariantManagerContent.ini"
# more
$Bridge2_Path = "$ConfigDir\client\$ConfigBranch\Bridge.ini"
$ConcertSyncCore2_Path = "$ConfigDir\client\$ConfigBranch\ConcertSyncCore.ini"
$ConsoleVariables2_Path = "$ConfigDir\client\$ConfigBranch\ConsoleVariables.ini"
$DatasmithContent2_Path = "$ConfigDir\client\$ConfigBranch\DatasmithContent.ini"
$EnhancedInput2_Path = "$ConfigDir\client\$ConfigBranch\EnhancedInput.ini"
$GLTFExporter2_Path = "$ConfigDir\client\$ConfigBranch\GLTFExporter.ini"
$IKRig2_Path = "$ConfigDir\client\$ConfigBranch\IKRig.ini"
$InstallBundle2_Path = "$ConfigDir\client\$ConfigBranch\InstallBundle.ini"
$Metasound2_Path = "$ConfigDir\client\$ConfigBranch\Metasound.ini"
$ModelViewViewModel2_Path = "$ConfigDir\client\$ConfigBranch\ModelViewViewModel.ini"
$MovieRenderPipeline2_Path = "$ConfigDir\client\$ConfigBranch\MovieRenderPipeline.ini"
$OnlineIntegration2_Path = "$ConfigDir\client\$ConfigBranch\OnlineIntegration.ini"
$OnlineSubsystemEOS2_Path = "$ConfigDir\client\$ConfigBranch\OnlineSubsystemEOS.ini"
$TraceUtilities2_Path = "$ConfigDir\client\$ConfigBranch\TraceUtilities.ini"
$Wwise2_Path = "$ConfigDir\client\$ConfigBranch\Wwise.ini"
$SML2_Path = "$ConfigDir\client\$ConfigBranch\SML.ini"

$Username1 = "$env:computername-Server"
$Username2 = "$env:computername-Client"

$MainIni1 = "-EngineINI=`"$Engine1_Path`"",  "-GameUserSettingsINI=`"$GameUserSettings1_Path`"", "-GameINI=`"$Game1_Path`"", "-InputINI=`"$Input1_Path`"", "-ScalabilityINI=`"$Scalability1_Path`"", "-DeviceProfilesINI=`"$DeviceProfiles1_Path`""
$OtherIni1 = "-ApexDestructionINI=`"$ApexDestruction1_Path`"", "-CompatINI=`"$Compat1_Path`"", "-ControlRigINI=`"$ControlRig1_Path`"", "-EditorScriptingUtilitiesINI=`"$EditorScriptingUtilities1_Path`"", "-FullBodyIKINI=`"$FullBodyIK1_Path`"", "-HardwareINI=`"$Hardware1_Path`"", "-MotoSynthINI=`"$MotoSynth1_Path`"", "-NiagaraINI=`"$Niagara1_Path`"", "-Paper2DINI=`"$Paper2D1_Path`"", "-PhysXVehiclesINI=`"$PhysXVehicles1_Path`"", "-RuntimeOptionsINI=`"$RuntimeOptions1_Path`"", "-SynthesisINI=`"$Synthesis1_Path`"", "-VariantManagerContentINI=`"$VariantManagerContent1_Path`""
$MoreIni1 = "-BridgeINI=`"$Bridge1_Path`"", "-ConcertSyncCoreINI=`"$ConcertSyncCore1_Path`"", "-ConsoleVariablesINI=`"$ConsoleVariables1_Path`"", "-DatasmithContentINI=`"$DatasmithContent1_Path`"", "-EnhancedInputINI=`"$EnhancedInput1_Path`"", "-GLTFExporterINI=`"$GLTFExporter1_Path`"", "-IKRigINI=`"$IKRig1_Path`"", "-InstallBundleINI=`"$InstallBundle1_Path`"", "-MetasoundINI=`"$Metasound1_Path`"", "-ModelViewViewModelINI=`"$ModelViewViewModel1_Path`"", "-MovieRenderPipelineINI=`"$MovieRenderPipeline1_Path`"", "-OnlineIntegrationINI=`"$OnlineIntegration1_Path`"", "-OnlineSubsystemEOSINI=`"$OnlineSubsystemEOS1_Path`"", "-TraceUtilitiesINI=`"$TraceUtilities1_Path`"", "-WwiseINI=`"$Wwise1_Path`"", "-SMLINI=`"$SML1_Path`""

$Args1 = "$CommonArgs", "-Username=`"$Username1`"", "$MainIni1", "$OtherIni1", "$MoreIni1", "-popupwindow", "-windowed", "-WinX=45", "-WinY=45", "-ResX=1280", "-ResY=720"

$MainIni2 = "-EngineINI=`"$Engine2_Path`"", "-GameINI=`"$Game2_Path`"", "-ScalabilityINI=`"$Scalability2_Path`"", "-DeviceProfilesINI=`"$DeviceProfiles2_Path`""#,"-GameUserSettingsINI=`"$GameUserSettings2_Path`"", "-InputINI=`"$Input2_Path`""
$OtherIni2 = "-ApexDestructionINI=`"$ApexDestruction2_Path`"", "-CompatINI=`"$Compat2_Path`"", "-ControlRigINI=`"$ControlRig2_Path`"", "-EditorScriptingUtilitiesINI=`"$EditorScriptingUtilities2_Path`"", "-FullBodyIKINI=`"$FullBodyIK2_Path`"", "-HardwareINI=`"$Hardware2_Path`"", "-MotoSynthINI=`"$MotoSynth2_Path`"", "-NiagaraINI=`"$Niagara2_Path`"", "-Paper2DINI=`"$Paper2D2_Path`"", "-PhysXVehiclesINI=`"$PhysXVehicles2_Path`"", "-RuntimeOptionsINI=`"$RuntimeOptions2_Path`"", "-SynthesisINI=`"$Synthesis2_Path`"", "-VariantManagerContentINI=`"$VariantManagerContent2_Path`""
$MoreIni2 = "-BridgeINI=`"$Bridge2_Path`"", "-ConcertSyncCoreINI=`"$ConcertSyncCore2_Path`"", "-ConsoleVariablesINI=`"$ConsoleVariables2_Path`"", "-DatasmithContentINI=`"$DatasmithContent2_Path`"", "-EnhancedInputINI=`"$EnhancedInput2_Path`"", "-GLTFExporterINI=`"$GLTFExporter2_Path`"", "-IKRigINI=`"$IKRig2_Path`"", "-InstallBundleINI=`"$InstallBundle2_Path`"", "-MetasoundINI=`"$Metasound2_Path`"", "-ModelViewViewModelINI=`"$ModelViewViewModel2_Path`"", "-MovieRenderPipelineINI=`"$MovieRenderPipeline2_Path`"", "-OnlineIntegrationINI=`"$OnlineIntegration2_Path`"", "-OnlineSubsystemEOSINI=`"$OnlineSubsystemEOS2_Path`"", "-TraceUtilitiesINI=`"$TraceUtilities2_Path`"", "-WwiseINI=`"$Wwise2_Path`"", "-SMLINI=`"$SML2_Path`""
$Args2 = "$CommonArgs", "-Username=`"$Username2`"", "$MainIni2", "$OtherIni2", "$MoreIni2"#, "-popupwindow", "-windowed", "-WinX=180", "-WinY=90", "-ResX=1600", "-ResY=900"

	
$latestSaveFile = (Get-ChildItem $SaveFolder | sort LastWriteTime | select -last 1)
$latestSaveFileName = $latestSaveFile.Basename

if (($server) -OR ($clienthost)) {
	
	if ($server) {
		$def_path = $def_Engine1_Path
		$dst_path = $Engine1_Path
	}
	
	if ($clienthost) {
		$def_path = $def_Engine2_Path
		$dst_path = $Engine2_Path
	}
	if (Test-Path $def_path) {
		(Get-Content $def_path).Replace('LocalMapOptions=', "LocalMapOptions=??skipOnboarding?loadgame=" + $latestSaveFileName + "?allowPossessAny?sessionName=" + $latestSaveFileName + "?" + $DefaultMapOptions).Replace("GameDefaultMap=" + $MenuDefaultMap, "GameDefaultMap=" + $GameDefaultMap) | Set-Content $dst_path
	}

}

if ($client) {
		
	$def_path = $def_Engine2_Path
	$dst_path = $Engine2_Path
	
	if (Test-Path $def_path) {
		(Get-Content $def_path).Replace("GameDefaultMap=", "GameDefaultMap=" + $MenuDefaultMap) | Set-Content $dst_path
	}

}

function BGProcess(){
    Start-Process -NoNewWindow @args
}

if ($server) {
	BGProcess "$($GameDir)\FactoryGame.exe" $Args1
} else {
	BGProcess "$($GameDir)\FactoryGame.exe" $Args2
}
	

if ($multiplayer) {
	sleep -m 5000
} else {
	return
}

BGProcess "$($GameDir)\FactoryGame.exe" $Args2