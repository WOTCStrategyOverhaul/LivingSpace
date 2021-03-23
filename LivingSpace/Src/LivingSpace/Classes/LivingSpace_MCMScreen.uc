class LivingSpace_MCMScreen extends Object config(LivingSpace_NullConfig);

var config int VERSION_CFG;

var localized string ModName;
var localized string PageTitle;
var localized string UserInterfaceGroupHeader;

`include(LivingSpace\Src\ModConfigMenuAPI\MCM_API_Includes.uci)

`MCM_API_AutoCheckBoxVars(bShowCrewCountOnGeoscape);

`include(LivingSpace\Src\ModConfigMenuAPI\MCM_API_CfgHelpers.uci)

`MCM_API_AutoCheckBoxFns(bShowCrewCountOnGeoscape, 1);

event OnInit(UIScreen Screen)
{
	`MCM_API_Register(Screen, ClientModCallback);
}

simulated function ClientModCallback(MCM_API_Instance ConfigAPI, int GameMode)
{
	local MCM_API_SettingsPage Page;
	local MCM_API_SettingsGroup Group;

	LoadSavedSettings();
	Page = ConfigAPI.NewSettingsPage(ModName);
	Page.SetPageTitle(PageTitle);
	Page.SetSaveHandler(SaveButtonClicked);
	Page.EnableResetButton(ResetButtonClicked);

	Group = Page.AddGroup('UserInterfaceGroup', UserInterfaceGroupHeader);
	`MCM_API_AutoAddCheckBox(Group, bShowCrewCountOnGeoscape);

	Page.ShowSettings();
}

simulated function LoadSavedSettings()
{
	bShowCrewCountOnGeoscape = `GETMCMVAR(bShowCrewCountOnGeoscape);
}

simulated function ResetButtonClicked(MCM_API_SettingsPage Page)
{
	`MCM_API_AutoReset(bShowCrewCountOnGeoscape);
}


simulated function SaveButtonClicked(MCM_API_SettingsPage Page)
{
	VERSION_CFG = `MCM_CH_GetCompositeVersion();
	SaveConfig();
}


