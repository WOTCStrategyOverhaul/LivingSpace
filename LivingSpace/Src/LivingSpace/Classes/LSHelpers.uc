class LSHelpers extends Object abstract config(LivingSpace);

var config int STARTING_CREW_LIMIT;

// How many missions to wait before showing the warning again
var config(UI) int CREW_WARNING_GAP;

static function int GetCurrentCrewSize ()
{
	local XComGameState_HeadquartersXcom XComHQ;
		
	XComHQ = `XCOMHQ;

	return GetNumberOfHumanSoldiers() + XComHQ.GetNumberOfScientists() + XComHQ.GetNumberOfEngineers();
}

static function int GetNumberOfHumanSoldiers ()
{
	local XComGameState_Unit Soldier;
	local int idx, iSoldiers;
	local XComGameState_HeadquartersXcom XComHQ;
		
	XComHQ = `XCOMHQ;

	iSoldiers = 0;
	for (idx = 0; idx < XComHQ.Crew.Length; idx++)
	{
		Soldier = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(XComHQ.Crew[idx].ObjectID));

		if (Soldier != none)
		{
			if (Soldier.IsSoldier() && !Soldier.IsRobotic() && !Soldier.IsDead())
			{
				iSoldiers++;
			}
		}
	}

	return iSoldiers;
}

static function TriggerCrewCountChangedEvent ()
{
	local XComGameState_LivingSpaceData LSData;
	local int CurrentCrewSize;

	LSData = `LSDATA;
	CurrentCrewSize = GetCurrentCrewSize();

	// If this is the player's first time seeing the crew count, don't trigger the event
	if (LSData.LastKnownCrewCount == -1)
	{
		LSData.LastKnownCrewCount = CurrentCrewSize;
	}
	else if (LSData.LastKnownCrewCount != CurrentCrewSize)
	{
		LSData.LastKnownCrewCount = CurrentCrewSize;
		`XEVENTMGR.TriggerEvent('CrewCountChanged');
	}
}
