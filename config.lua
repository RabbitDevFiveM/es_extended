Config = {}
Config.Locale = 'en'

Config.Accounts = {
	bank = _U('account_bank'),
	black_money = _U('account_black_money'),
	money = _U('account_money')
}

Config.StartingAccountMoney = {bank = 50000}

Config.EnableSocietyPayouts = false -- Pay from the society account that the player is employed at? Requirement: esx_society
Config.EnableHud            = false -- Enable the default hud? Display current job and accounts (black, bank & cash)
Config.MaxWeight            = 24   -- The max inventory weight without backpack
Config.PaycheckInterval     = 7 * 60000 -- How often to recieve pay checks in milliseconds

Config.DrawDistance			= 30
Config.Draw3DDistance		= 5

Config.EnableDebug          = false
