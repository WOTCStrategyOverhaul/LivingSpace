class UIUtilities_LS extends Object abstract; 

static function BuildUIAlert_LivingSpace (
	out DynamicPropertySet PropertySet,
	Name AlertName,
	delegate<X2StrategyGameRulesetDataStructures.AlertCallback> CallbackFunction,
	Name EventToTrigger,
	string SoundToPlay,
	bool bImmediateDisplay = true
)
{
	class'X2StrategyGameRulesetDataStructures'.static.BuildDynamicPropertySet(PropertySet, 'UIAlert_LivingSpace', AlertName, CallbackFunction, bImmediateDisplay, true, true, false);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicNameProperty(PropertySet, 'EventToTrigger', EventToTrigger);
	class'X2StrategyGameRulesetDataStructures'.static.AddDynamicStringProperty(PropertySet, 'SoundToPlay', SoundToPlay);
}

static function ShowCrewOverflowPopup ()
{
	local XComHQPresentationLayer HQPres;
	local DynamicPropertySet PropertySet;

	HQPres = `HQPRES;

	BuildUIAlert_LivingSpace(PropertySet, 'eAlert_CrewOverflow', none, '', "Geoscape_DoomIncrease");
	HQPres.QueueDynamicPopup(PropertySet);
}
