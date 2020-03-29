class X2StrategyElement_LSFacilityUpgrades extends X2StrategyElement_DefaultFacilityUpgrades config(LivingSpace);

var config int CREW_LIMIT_INCREASE_I;
var config int CREW_LIMIT_INCREASE_II;

var config int CrewSizeI_Power;
var config int CrewSizeI_UpkeepCost;
var config StrategyCost CrewSizeI_Cost;

var config int CrewSizeII_Power;
var config int CrewSizeII_UpkeepCost;
var config StrategyCost CrewSizeII_Cost;

static function array<X2DataTemplate> CreateTemplates ()
{
	local array<X2DataTemplate> Upgrades;

	Upgrades.AddItem(CreateLivingQuarters_CrewSizeI());
	Upgrades.AddItem(CreateLivingQuarters_CrewSizeII());
	
	return Upgrades;
}

static function X2DataTemplate CreateLivingQuarters_CrewSizeI ()
{
	local X2FacilityUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'LivingQuarters_CrewSizeI');
	Template.PointsToComplete = 0;
	Template.MaxBuild = 1;
	Template.strImage = "img:///UILibrary_StrategyImages.FacilityIcons.ChooseFacility_PowerConduitUpgrade";
	Template.OnUpgradeAddedFn = OnUpgradeAdded_IncreaseCrewSizeI;

	Template.iPower = default.CrewSizeI_Power;
	Template.UpkeepCost = default.CrewSizeI_UpkeepCost;
	Template.Cost = default.CrewSizeI_Cost;

	return Template;
}

static function X2DataTemplate CreateLivingQuarters_CrewSizeII ()
{
	local X2FacilityUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2FacilityUpgradeTemplate', Template, 'LivingQuarters_CrewSizeII');
	Template.PointsToComplete = 0;
	Template.MaxBuild = 1;
	Template.strImage = "img:///UILibrary_StrategyImages.FacilityIcons.ChooseFacility_EleriumConduitUpgrade";
	Template.OnUpgradeAddedFn = OnUpgradeAdded_IncreaseCrewSizeII;

	Template.iPower = default.CrewSizeII_Power;
	Template.UpkeepCost = default.CrewSizeII_UpkeepCost;
	Template.Cost = default.CrewSizeII_Cost;

	return Template;
}

static protected function OnUpgradeAdded_IncreaseCrewSizeI (XComGameState NewGameState, XComGameState_FacilityUpgrade Upgrade, XComGameState_FacilityXCom Facility)
{
	IncreaseCrewSize(NewGameState, default.CREW_LIMIT_INCREASE_I);
}

static protected function OnUpgradeAdded_IncreaseCrewSizeII (XComGameState NewGameState, XComGameState_FacilityUpgrade Upgrade, XComGameState_FacilityXCom Facility)
{
	IncreaseCrewSize(NewGameState, default.CREW_LIMIT_INCREASE_II);
}

static protected function IncreaseCrewSize (XComGameState NewGameState, int Amount)
{
	local XComGameState_LivingSpaceData LSData;

	LSData = XComGameState_LivingSpaceData(NewGameState.ModifyStateObject(class'XComGameState_LivingSpaceData', `LSDATA.ObjectID));
	LSData.CurrentCrewLimit += Amount;
}
