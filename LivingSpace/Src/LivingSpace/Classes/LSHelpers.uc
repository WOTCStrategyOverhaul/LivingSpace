class LSHelpers extends Object abstract config(LivingSpace);

var config int STARTING_CREW_LIMIT;

var config array<name> FACILITY_HOLDS_ENGINEER;
var config array<name> FACILITY_HOLDS_SCIENTIST;

// How many missions to wait before showing the warning again
var config(UI) int CREW_WARNING_GAP;

static function int GetCurrentCrewSize ()
{
	local XComGameState_HeadquartersXcom XComHQ;
	local bool bHasSciFacility, bHasEngFacility;
	local int i, Result;
	
	XComHQ = `XCOMHQ;

	Result = GetNumberOfHumanSoldiers();
	
	bHasSciFacility = false;
	bHasEngFacility = false;
	
	//check for these facilities
	for (i = 0 ; i < default.FACILITY_HOLDS_SCIENTIST.length ; i++)
	{
		if (XComHQ.HasFacilityByName(default.FACILITY_HOLDS_SCIENTIST[i]))
		{
			bHasSciFacility = true;
			continue;
		}
	}
	
	//if HQ does not have a facility, add crew
	if (!bHasSciFacility)
	{
		Result += XComHQ.GetNumberOfScientists();
	}

	//check for these facilities
	for (i = 0 ; i < default.FACILITY_HOLDS_ENGINEER.length ; i++)
	{
		if (XComHQ.HasFacilityByName(default.FACILITY_HOLDS_ENGINEER[i]))
		{
			bHasEngFacility = true;
			continue;
		}
	}

	//if HQ does not have a facility, add crew
	if (!bHasEngFacility)
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
