class X2DownloadableContentInfo_LivingSpace extends X2DownloadableContentInfo;

/////////////////
/// Templates ///
/////////////////

static event OnPostTemplatesCreated ()
{
	PatchLivingQuarters();
}

static protected function PatchLivingQuarters ()
{
	local X2StrategyElementTemplateManager TemplateManager;
	local X2FacilityTemplate FacilityTemplate;

	TemplateManager = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	FacilityTemplate = X2FacilityTemplate(TemplateManager.FindStrategyElementTemplate('LivingQuarters'));
	
	// add crew size limit upgrades
	FacilityTemplate.Upgrades.AddItem('LivingQuarters_CrewSizeI');
	FacilityTemplate.Upgrades.AddItem('LivingQuarters_CrewSizeII');
}

///////////////////////
/// Loaded/new game ///
///////////////////////

static event InstallNewCampaign (XComGameState StartState)
{
	class'XComGameState_LivingSpaceData'.static.CreateSingleton(StartState).InitNewCampaign();
}

static event OnLoadedSavedGame ()
{
	class'XComGameState_LivingSpaceData'.static.CreateSingleton().InitExistingCampaign();
}

static function OnLoadedSavedGameWithDLCExisting ()
{
	local XComGameState_LivingSpaceData LSData;
	local XComGameState NewGameState;

	LSData = `LSDATA;

	// Do nothing if we are adding the mod to an existing campaign (why is this called???) or if we already updated the state
	if (LSData == none || LSData.ModVersion >= class'XComGameState_LivingSpaceData'.const.CURRENT_MOD_VERSION) return;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("Updating LS state from" @ LSData.ModVersion @ "to" @ class'XComGameState_LivingSpaceData'.const.CURRENT_MOD_VERSION);

	// State fix-up changes go here
	`LS_Log("OnLoadedSavedGameWithDLCExisting running");

	// Save that the state was updated.
	// Do this last, so that the state update code can access the previous version
	LSData = XComGameState_LivingSpaceData(NewGameState.ModifyStateObject(class'XComGameState_LivingSpaceData', LSData.ObjectID));
	LSData.ModVersion = class'XComGameState_LivingSpaceData'.const.CURRENT_MOD_VERSION;

	`XCOMHISTORY.AddGameStateToHistory(NewGameState);
}

////////////////////////////
/// Mission start/finish ///
////////////////////////////

static event OnPostMission ()
{
	// Force refresh of will recovery projects length
	// This is done automatically for people returning from the mission,
	// but we also need to do the update for those sitting in the barracks
	// Example cases:
	// * Soldier(s) died - less crew, might put us under the cap
	// * VIP recruited - more crew, might put us over the cap
	`XCOMHQ.HandlePowerOrStaffingChange();
}

static event OnExitPostMissionSequence ()
{
	TriggerCrewOverLimitWarning();
}

static protected function TriggerCrewOverLimitWarning ()
{
	local XComGameState_LivingSpaceData LSData;
	local XComGameState NewGameState;
	local int CurrentCrewSize;
	local bool bShow;

	LSData = `LSDATA;
	CurrentCrewSize = class'LSHelpers'.static.GetCurrentCrewSize();

	if (CurrentCrewSize <= LSData.CurrentCrewLimit)
	{
		if (LSData.MissionsSinceCrewOverflowShown != 0)
		{
			NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LS: Clear MissionsSinceCrewOverflowShown");
			LSData = XComGameState_LivingSpaceData(NewGameState.ModifyStateObject(class'XComGameState_LivingSpaceData', LSData.ObjectID));
			LSData.MissionsSinceCrewOverflowShown = 0;
			`SubmitGameState(NewGameState);
		}

		return;
	}

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("LS: Process MissionsSinceCrewOverflowShown");
	LSData = XComGameState_LivingSpaceData(NewGameState.ModifyStateObject(class'XComGameState_LivingSpaceData', LSData.ObjectID));
	
	if (LSData.MissionsSinceCrewOverflowShown == 0)
	{
		LSData.MissionsSinceCrewOverflowShown++;
		bShow = true;
	}
	else if (LSData.MissionsSinceCrewOverflowShown > class'LSHelpers'.default.CREW_WARNING_GAP)
	{
		LSData.MissionsSinceCrewOverflowShown = 0;
		bShow = true;
	}
	else
	{
		LSData.MissionsSinceCrewOverflowShown++;
	}

	`SubmitGameState(NewGameState);

	if (bShow)
	{
		class'UIUtilities_LS'.static.ShowCrewOverflowPopup();
	}
}

//////////////////////////////////
/// Vanilla DLCInfo misc hooks ///
//////////////////////////////////

static function bool DisplayQueuedDynamicPopup (DynamicPropertySet PropertySet)
{
	if (PropertySet.PrimaryRoutingKey == 'UIAlert_LivingSpace')
	{
		CallUIAlert_LivingSpace(PropertySet);
		return true;
	}

	return false;
}

static protected function CallUIAlert_LivingSpace (const out DynamicPropertySet PropertySet)
{
	local XComPresentationLayerBase Pres;
	local UIAlert_LivingSpace Alert;

	Pres = `PRESBASE;

	Alert = Pres.Spawn(class'UIAlert_LivingSpace', Pres);
	Alert.DisplayPropertySet = PropertySet;
	Alert.eAlertName = PropertySet.SecondaryRoutingKey;

	Pres.ScreenStack.Push(Alert);
}

////////////////
/// COMMANDS ///
////////////////

exec function SetCurrentCrewLimit (int NewCurrentCrewLimit)
{
	local XComGameState_HeadquartersXCom XComHQ;
	local XComGameState_LivingSpaceData LSData;
	local XComGameState NewGameState;

	NewGameState = class'XComGameStateContext_ChangeContainer'.static.CreateChangeState("CHEAT: SetCurrentCrewLimit");

	LSData = XComGameState_LivingSpaceData(NewGameState.ModifyStateObject(class'XComGameState_LivingSpaceData', `LSDATA.ObjectID));
	LSData.CurrentCrewLimit = NewCurrentCrewLimit;
	
	// If we are in strategy, refresh the recovery project speed
	if (`HQPRES != none)
	{
		XComHQ = XComGameState_HeadquartersXCom(NewGameState.ModifyStateObject(class'XComGameState_HeadquartersXCom', `XCOMHQ.ObjectID));
		XComHQ.HandlePowerOrStaffingChange(NewGameState);
	}
	
	`SubmitGameState(NewGameState);
}

exec function ShowCrewOverflowAlert ()
{
	class'UIUtilities_LS'.static.ShowCrewOverflowPopup();
}
