fx_version "adamant"
game "gta5"

dependency 'vrp'

client_scripts {
	"client.lua",
	
	"gameplay/busted.lua",
	"gameplay/pickups.lua",
	
	"utils/ui.lua",
	"utils/functions.lua"
}
server_scripts{
	'@vrp/lib/utils.lua',
	"server.lua"
}

shared_script "houses.lua"