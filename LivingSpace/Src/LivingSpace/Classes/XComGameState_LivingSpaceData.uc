class XComGameState_LivingSpaceData extends XComGameState_BaseObject;

var int CurrentCrewLimit;
var int MissionsSinceCrewOverflowShown;

///////////////////
/// Mod version ///
///////////////////

// Encoding scheme: 00000000
//                  0        - beta (0) or workshop (1)
//                   00      - release number (eg. beta **2**)
//                     00000 - patch number
//
// This allows to easy compare the saved version with integer comparison, eg.
// if (CurrentVersion > CIInfo.ModVersion) 
var int ModVersion;

const CURRENT_MOD_VERSION = 10000001; // 1.0 patch 1

/////////////////
/// Accessors ///
/////////////////

static function XComGameState_LivingSpaceData GetSingleton (optional bool AllowNull = false)
{
	return XComGameState_LivingSpaceData(`XCOMHISTORY.GetSingleGameStateObjectForClass(class'XComGameState_LivingSpaceData', AllowNull));
}

////////////////
/// Creation ///
////////////////

static function XComGameState_LivingSpaceData CreateSingleton (optional XComGameState NewGameState)
{
	local XComGameState_LivingSpaceData Data;

	// Do not create if already exists
	if (GetSingleton(true) != none) return none;

	if (NewGameState != none)
	{
		Data = XComGameState_LivingSpaceData(NewGameState.CreateNewStateObject(class'XComGameState_LivingSpaceData'));
		return Data;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Creating LS Data Singleton");
	Data = XComGameState_LivingSpaceData(NewGameState.CreateNewStateObject(class'XComGameState_LivingSpaceData'));
	`XCOMHISTORY.AddGameStateToHistory(NewGameState);

	return Data;
}

function InitNewCampaign ()
{
	CurrentCrewLimit = class'LSHelpers'.default.STARTING_CREW_LIMIT;
	ModVersion = CURRENT_MOD_VERSION;
}

function InitExistingCampaign ()
{
	CurrentCrewLimit = class'LSHelpers'.default.STARTING_CREW_LIMIT;
	ModVersion = CURRENT_MOD_VERSION;
}
