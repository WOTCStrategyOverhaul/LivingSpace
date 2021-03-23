class LivingSpace_MCMScreenListener extends UIScreenListener;

event OnInit(UIScreen Screen)
{
	local LivingSpace_MCMScreen MCMScreen;

	if (ScreenClass==none)
	{
		if (MCM_API(Screen) != none)
			ScreenClass=Screen.Class;
		else return;
	}

	MCMScreen = new class'LivingSpace_MCMScreen';
	MCMScreen.OnInit(Screen);
}

defaultproperties
{
    ScreenClass = none;
}
