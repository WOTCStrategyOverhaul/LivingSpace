class LSHelpers extends Object abstract config(LivingSpace);

var config int STARTING_CREW_LIMIT;

var config name FACILITY_HOLDS_ENGINEER;
var config name FACILITY_HOLDS_SCIENTIST;

// How many missions to wait before showing the warning again
var config(UI) int CREW_WARNING_GAP;

static function int GetCurrentCrewSize ()
{
	local XComGameState_HeadquartersXcom XComHQ;
	local int Result;
		
	XComHQ = `XCOMHQ;

	Result = GetNumberOfHumanSoldiers();

	if (!XComHQ.HasFacilityByName(default.FACILITY_HOLDS_SCIENTIST))
	{
		Result += XComHQ.GetNumberOfScientists();
	}
	
	if (!XComHQ.HasFacilityByName(default.FACILITY_HOLDS_ENGINEER))
	{
		Result += XComHQ.GetNumberOfEngineers();
	}

	return Result;
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
