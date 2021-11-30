local addonName = ...
local printPrefix = addonName..": "

local myframe = CreateFrame("Frame")
myframe:RegisterEvent("ADDON_LOADED")
myframe:SetScript(
	"OnEvent",
	function(_, event, ...)
		myframe[event](myframe, ...)
	end
)

local function toggleInviteOnContext()
	if safeinvite_enabled then
		for k, v in pairs({"PLAYER", "FRIEND"}) do
			local popupMenu = UnitPopupMenus[v]
			for i = 1, #popupMenu do
				if popupMenu[i] == "INVITE" then
					if v == "PLAYER" then
						safeinvite_table_PLAYER = popupMenu[i]
						safeinvite_inviteindex_PLAYER = i
					elseif v == "FRIEND" then
						safeinvite_table_FRIEND = popupMenu[i]
						safeinvite_inviteindex_FRIEND = i
					end
					tremove(popupMenu, i)
					break
				end
			end
		end
	else
		for k, v in pairs({"PLAYER", "FRIEND"}) do
			local popupMenu = UnitPopupMenus[v]
			if v == "PLAYER" and popupMenu[safeinvite_inviteindex_PLAYER] ~= "INVITE" then
				tinsert(popupMenu, safeinvite_inviteindex_PLAYER, safeinvite_table_PLAYER)
			elseif v == "FRIEND" and popupMenu[safeinvite_inviteindex_FRIEND] ~= "INVITE" then
				tinsert(popupMenu, safeinvite_inviteindex_FRIEND, safeinvite_table_FRIEND)
			end
		end
	end
end

SLASH_SAFEINVITE1, SLASH_SAFEINVITE2 = "/safeinvite", "/sinv"
SlashCmdList["SAFEINVITE"] = function(msg)
	if msg == "on" then
		print(printPrefix .. "Addon will now hide 'Invite' from context menu's. Use /sinv off to show again.")
		safeinvite_enabled = true
		toggleInviteOnContext()
	elseif msg == "off" then
		print(printPrefix .. "Addon is now disabled, to turn on, use /sinv on")
		safeinvite_enabled = false
		toggleInviteOnContext()
	else
		print(printPrefix .. "Possible commands is:")
		print(printPrefix .. "/sinv on - turns on removal of Invite from contexts")
		print(printPrefix .. "/sinv off - turns off removal of Invite from contexts")
	end
end

function myframe:ADDON_LOADED(name)
	if name ~= addonName then
		return
	end
	if safeinvite_enabled == nil then
		print(printPrefix .. "First load, enabling addon")
		safeinvite_enabled = true
	end
	if safeinvite_enabled == true then
		toggleInviteOnContext()
	end
end

