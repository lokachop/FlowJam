if not term.isColor() then
	term.clear()

	local messages = {
		"This program can't run on this machine!",
		"Please use an advanced computer!"
	}

	local tW, tH = term.getSize()

	for k, v in ipairs(messages) do
		term.setCursorPos(math.floor(tW * .5) - math.floor(#v * .5), math.floor(tH * .5) + (k - 1))
		term.write(v)
	end

	term.setCursorPos(1, tH)
	return
end


local tW, tH = term.getSize()
print("Terminal size; ", tW, tH)
if tW > 51 or tH > 19 then
	term.clear()

	local messages = {
		"",
		"",
		"You are launching the game with too large",
		"of a resolution, which will cause the game",
		"to have poor performance and other issues.",
		"",
		"",
		"Are you sure you want to continue?",
	}

	local msgCount = #messages
	for i = 1, (tH - msgCount) - 3 do
		messages[#messages + 1] = ""
	end

	messages[#messages + 1] = "Y: Yes    N: No"
	messages[#messages + 1] = ""
	messages[#messages + 1] = ""

	-- pad messages so we can blit the :(
	local newMessages = {}
	for k, v in ipairs(messages) do
		local msgLen = #v
		local deltaFullWidth = tW - msgLen

		local deltaFullWidthH = deltaFullWidth * .5

		local padPrev = math.floor(deltaFullWidthH)
		local padPost = math.ceil(deltaFullWidthH)

		newMessages[#newMessages + 1] = string.rep(" ", padPrev) .. v .. string.rep(" ", padPost)
	end
	messages = newMessages

	term.setPaletteColor(colors.gray, 24 / 255, 24 / 255, 24 / 255)


	local blitterColours = {
		"fffffffff",
		"fff7f7fff",
		"fff7f7fff",
		"fff7f7fff",
		"fffffffff",
		"ff77777ff",
		"f7fffff7f",
	}

	local blitCount = #blitterColours
	for i = 1, (tH - blitCount) do
		blitterColours[#blitterColours + 1] = blitterColours[((i - 1) % blitCount) + 1]
	end

	-- pad the blitter bg
	local newBlitters = {}
	for k, v in ipairs(blitterColours) do
		local msgLen = #v
		local messagesCanFit = math.ceil(tW / msgLen)
		

		newBlitters[#newBlitters + 1] = string.sub(string.rep(v, messagesCanFit), 1, tW)
	end
	blitterColours = newBlitters




	for k, v in ipairs(messages) do
		local msgLen = #v

		term.setCursorPos(1 + math.floor(tW * .5) - math.floor(msgLen * .5), k)
		--term.write(blitterColours[k])
		term.blit(v, string.rep("0", msgLen), blitterColours[k])
	end

	term.setCursorPos(1, tH)

	local stopGame = false
	while true do
		local event, key = os.pullEvent("key")
		if key == keys.n then
			stopGame = true
			break
		end

		if key == keys.y then
			break
		end
	end

	if stopGame then
		term.clear()

		term.setPaletteColor(colors.gray, 76 / 255, 76 / 255, 76 / 255)
		return
	end
end

math.randomseed(os.time())



require("flk3d.flk3d")
local dataPath = shell.resolve("./data/")
FLK3D.SetDataPath(dataPath)

FLK3D.SetSunDir(Vector(1, 2, 5))

require("lkhooks.lkhooks")
require("flowjam.flowjam")

FlowJam.SetState(STATE_MENU)

LKHooks.Add("Think", "ProgramThink", function(dt)
	FlowJam.StateThink(dt)
end)

LKHooks.Add("Think", "SoundThink", function(dt)
	FlowJam.SoundThink(dt)
end)

LKHooks.Add("Render", "ProgramRender", function(dt)
	FlowJam.StateRender()
end)

LKHooks.BeginProgram()