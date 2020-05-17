class LSEventListener_UI extends X2EventListener config(UI);

var config int MaxOverCrewLimitTillRed;

var localized string strCrewSizeTitle;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateAvengerHUDListeners());

	return Templates;
}

///////////////////
/// Avenger HUD ///
///////////////////

static function CHEventListenerTemplate CreateAvengerHUDListeners()
{
	local CHEventListenerTemplate Template;

	`CREATE_X2TEMPLATE(class'CHEventListenerTemplate', Template, 'LivingSpace_UI_AvengerHUD');
	Template.AddCHEvent('UpdateResources', UpdateResources, ELD_Immediate, `LS_DEFAULT_EVENT_PRIORITY);
	Template.RegisterInStrategy = true;

	return Template;
}

static function EventListenerReturn UpdateResources (Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local int CurrentCrewSize, CurrentCrewLimit;
	local UIScreenStack ScreenStack;
	local UIAvengerHUD AvengerHUD;
	local UIScreen CurrentScreen;
	local EUIState MessageColor;

	AvengerHUD = `HQPRES.m_kAvengerHUD;
	ScreenStack = AvengerHUD.Movie.Pres.ScreenStack;
	CurrentScreen = ScreenStack.GetCurrentScreen();
	
	if (
		UIFacility_LivingQuarters(CurrentScreen) != none ||
		UIStrategyMap(CurrentScreen) != none ||
		UIFacilityGrid(CurrentScreen) != none ||
		UIRecruitSoldiers(CurrentScreen) != none ||
		(UIChooseUpgrade(CurrentScreen) != none && UIFacility_LivingQuarters(ScreenStack.GetFirstInstanceOf(class'UIFacility_LivingQuarters')) != none)
	)
	{
		CurrentCrewSize = class'LSHelpers'.static.GetCurrentCrewSize();
		CurrentCrewLimit = `LSDATA.CurrentCrewLimit;

		if (CurrentCrewSize <= CurrentCrewLimit)
		{
			MessageColor = eUIState_Cash;
		}
		else if (CurrentCrewSize <= CurrentCrewLimit + default.MaxOverCrewLimitTillRed)
		{
			MessageColor = eUIState_Warning;
		}
		else
		{
			MessageColor = eUIState_Bad;
		}

		class'LSHelpers'.static.TriggerCrewCountChangedEvent();
		
		AvengerHUD.AddResource(default.strCrewSizeTitle, class'UIUtilities_Text'.static.GetColoredText(CurrentCrewSize $ "/" $ CurrentCrewLimit, MessageColor));
		AvengerHUD.ShowResources();
	}

	return ELR_NoInterrupt;
}
