local myframe = CreateFrame("Frame")
local inviteTablePlayer
local inviteTableFriend
local safeInviteName = "SafeInvite: "

myframe:RegisterEvent("ADDON_LOADED")
myframe:SetScript(
	"OnEvent",
	function(_, event, ...)
		myframe[event](myframe, ...)
	end
)

SLASH_SAFEINVITE1, SLASH_SAFEINVITE2 = "/safeinvite", "/sinv"
SlashCmdList["SAFEINVITE"] = function(msg)
	if msg == "on" then
		print(safeInviteName .. "Addon will now hide 'Invite' from context menu's. Use /sinv off to show again.")
		safeinvite_status = true
		toggleInviteFromChatContext()
		toggleInviteFromTargetContext()
	elseif msg == "off" then
		print(safeInviteName .. "Addon is now disabled, to turn on, use /sinv on")
		safeinvite_status = false
		toggleInviteFromChatContext()
		toggleInviteFromTargetContext()
	else
		print(safeInviteName .. "Possible commands is:")
		print(safeInviteName .. "/sinv on - turns on removal of Invite from contexts")
		print(safeInviteName .. "/sinv off - turns off removal of Invite from contexts")
	end
end

function myframe:ADDON_LOADED(addonName)
	if addonName ~= "safeinvite" then
		return
	end
	if safeinvite_status == nil then
		print(safeInviteName .. "First load, enabling addon")
		safeinvite_status = true
	end
	if safeinvite_status == true then
		toggleInviteFromChatContext()
		toggleInviteFromTargetContext()
	end
end

function toggleInviteFromChatContext()
	if safeinvite_status then
		for i = 1, #UnitPopupMenus["FRIEND"] do
			if UnitPopupMenus["FRIEND"][i] == "INVITE" then
				safeinvite_inviteindex_FRIEND = i
				inviteTableFriend = UnitPopupMenus["FRIEND"][i]
				tremove(UnitPopupMenus["FRIEND"], i)
			end
		end
	else
		tinsert(UnitPopupMenus["FRIEND"], safeinvite_inviteindex_FRIEND, inviteTableFriend)
	end
end

function toggleInviteFromTargetContext()
	if safeinvite_status then
		for i = 1, #UnitPopupMenus["PLAYER"] do
			if UnitPopupMenus["PLAYER"][i] == "INVITE" then
				inviteTablePlayer = UnitPopupMenus["PLAYER"][i]
				safeinvite_inviteindex_PLAYER = i
				tremove(UnitPopupMenus["PLAYER"], i)
			end
		end
	else
		tinsert(UnitPopupMenus["PLAYER"], safeinvite_inviteindex_PLAYER, inviteTablePlayer)
	end
end
