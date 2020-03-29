class XComGameState_LivingSpaceData extends XComGameState_BaseObject;

var int CurrentCrewLimit;
var int MissionsSinceCrewOverflowShown;

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
	if (GetInfo(true) != none) return none;

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
	CurrentCrewLimit = class'X2Helper_Infiltration'.default.STARTING_CREW_LIMIT;
}

function InitExistingCampaign ()
{
	CurrentCrewLimit = class'X2Helper_Infiltration'.default.STARTING_CREW_LIMIT;
}
