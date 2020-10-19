require "moonloader"
sampev = require("lib.samp.events")
samp = require "sampfuncs"

script_name("Ultimate Player Notifier")
script_author("Nisad Rahman")

dbloc = "moonloader/config/notifier.nisad"
notifytable = {}
notifydb = io.open(dbloc, "a+")
for name in notifydb:lines() do
	table.insert(notifytable, name:lower())
end
io.close(notifydb)

togglelist = true
toggleall = false

function main()
	while not isSampAvailable() do wait(50) end
	sampRegisterChatCommand("nothelp", nothelp)
	sampRegisterChatCommand("tognotify", tognotify)
	sampRegisterChatCommand("addnotify", addnotify)
	sampRegisterChatCommand("removenotify", removenotify)
	sampRegisterChatCommand("notifylist", notifylist)
	sampRegisterChatCommand("online", online)
end

function branding()
	wait(40000)
	sampAddChatMessage("Ultimate Player Notifier, use [/nothelp] to check commands", 0xFFFFFF)
	sampAddChatMessage("Contact with {e61920}Nisad Rahman {FFFFFF}if you see any bug", 0xFFFFFF)
end

function tognotify(arg)
	if(arg == "list") 
	then
		if(togglelist == true) then
			sampAddChatMessage("Turning {e61920}off {FFFFFF}list notifier temporarily", 0xFFFFFF)
			togglelist = false
		else
			sampAddChatMessage("Turning {34eb46}on {FFFFFF}list notifier", 0xFFFFFF)
			togglelist = true
		end
	elseif(arg == "all") then
		if(toggleall == true) then
			sampAddChatMessage("Turning {e61920}off {FFFFFF}all notifications", 0xFFFFFF)
			toggleall = false
		else
			sampAddChatMessage("Turning {34eb46}on {FFFFFF}all notifications", 0xFFFFFF)
			toggleall = true
		end
	else
		sampAddChatMessage("Wrong Input, available inputs: {34eb46}all, list {FFFFFF}", 0xFFFFFF)
	end
end

function sampev.onPlayerJoin(id, color, isNPC, nickname)
	if(toggleall) then
		sampAddChatMessage("{FFFFFF}{34eb46}" .. nickname .. " (" .. id .. ")" .. "{FFFFFF} is coming online!", 0xFFFFFF)
		return
	end
	if(toggle == false) then
		return
	end
	for k,n in pairs(notifytable) do
		if (nickname:lower() == n:lower()) then
			sampAddChatMessage("{FFFFFF}{34eb46}" .. nickname .. " (" .. id .. ")" .. "{FFFFFF} is coming online!", 0xFFFFFF)
			return
		end
	end
end

function sampev.onPlayerQuit(id, reason)
	if(toggle == false) then
		return
	end
	local name = sampGetPlayerNickname(id)
	if(toggleall) then
		sampAddChatMessage("{e61920}" .. name .. " {FFFFFF}has left the server (" .. reason .. ")",0xFFFFFF)
		return
	end
	for k,n in pairs(notifytable) do
		if (name:lower() == n:lower()) then
			sampAddChatMessage("{e61920}" .. name .. " {FFFFFF}has left the server (" .. reason .. ")",0xFFFFFF)
			return
		end
	end
end

function nothelp()
	sampAddChatMessage("---- Ultimate Player Notifier ----", 0xe61920)
	sampAddChatMessage("--- Developed By: Nisad Rahman ---", 0xe61920)
	sampAddChatMessage("                                      ", 0xe61920)
	
	sampAddChatMessage("{e61920}[/addnotify] {FFFFFF}to add",0xFFFFFF)
	sampAddChatMessage("{e61920}[/removenotify] {FFFFFF}to remove",0xFFFFFF)
	sampAddChatMessage("{e61920}[/notifylist] {FFFFFF}to check notify list",0xFFFFFF)
	sampAddChatMessage("{e61920}[/tognotify all/list] {FFFFFF}to toggle",0xFFFFFF)
end

function addnotify(name)
	if(name == "") then
		sampAddChatMessage("Example: /addnotify Nisad_Rahman",0xe61920)
		return
	end
	for k,n in pairs(notifytable) do
		if(n:lower() == name:lower()) then
			sampAddChatMessage("{e61920}" .. name .. "{FFFFFF} is already in your notify list!", 0xFFFFFF)
			return
		end
	end
	for k,n in pairs(notifytable) do
		if(n:lower() == name) then
			table.remove(notifytable,i)
			sampAddChatMessage("{e61920}" .. name .. "{{FFFFFF}}removed from your notify list!", 0xFFFFFF)
		end
	end
	notifydb = io.open(dbloc, "a+")
	io.output(notifydb)
	io.write(name .. "\n")
	io.close(notifydb)
	table.insert(notifytable, name:lower())
	sampAddChatMessage("{FFFFFF}You have added {e61920}" .. name .. "{FFFFFF} in your notify list",0xFFFFFF)
end

function removenotify(name)
	if(name == "") then
		sampAddChatMessage("Example: /removenotify Nisad_Rahman",0xe61920)
		return
	end
	i = 1
	for k,n in pairs(notifytable) do
		if(n:lower() == name) then
			table.remove(notifytable,i)
			sampAddChatMessage("{e61920}" .. name .. "{FFFFFF} is removed from your notify list!" , 0xFFFFFF)
		end
		i = i+1
	end
	
	
	notifydb = io.open(dbloc, "w")
	io.output(notifydb)
	for k,n in pairs(notifytable) do
		io.write(n .. "\n")
	end
	io.close(notifydb)
end


function notifylist()
	sampAddChatMessage(" ", 0xe61920)
	sampAddChatMessage("--- Notify List ---", 0xe61920)
	notifytable = {}
	notifydb = io.open(dbloc, "r")
	for name in notifydb:lines() do
		table.insert(notifytable, name:lower())
	end
	io.close(notifydb)
	i = 1
	for k,n in pairs(notifytable) do
		sampAddChatMessage("{e61920}" .. i .. ". {FFFFFF}" .. n)
		i = i + 1
	end
end

function online()
	sampAddChatMessage(" ", 0xe61920)
	sampAddChatMessage("--- Online List ---", 0xe61920)
	tempList = {}
	notifydb = io.open(dbloc, "r")
	for name in notifydb:lines() do
		table.insert(tempList, name:lower())
	end
	io.close(notifydb)
	maxPlayerOnline = sampGetMaxPlayerId(false)
	s = 1
	for i = 0, maxPlayerOnline do
		if sampIsPlayerConnected(i) then
			name = sampGetPlayerNickname(i)
			c = 1
			for k,n in pairs(tempList) do
				if(name:lower() == n:lower()) then
					sampAddChatMessage("{FFFFFF}" .. s .. ". {34eb46}" .. name .. " (" .. i .. ")")
					table.remove(tempList,c)
					s = s + 1
				end
				c = c + 1
			end
		end
	end
end
