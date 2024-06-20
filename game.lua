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


require("flk3d.flk3d")
local dataPath = shell.resolve("./data/")
FLK3D.SetDataPath(dataPath)

require("lkhooks.lkhooks")
require("flowjam.flowjam")

FlowJam.SetState(STATE_MENU)





--[[
LKHooks.Add("Think", "Movement", function(dt)
	mouseThink()
end)
]]--

--[[
LKHooks.Add("Render", "TestRender", function()
	FLK3D.PushUniverse(univ)
	FLK3D.PushRenderTarget(rt)
		FLK3D.ClearHalfed(COLOR_BACKGROUND, true)
		--FLK3D.ClearDepth()
		FLK3D.RenderActiveUniverse()
		FLK3D.RenderRTToScreen()
	FLK3D.PopRenderTarget()
	FLK3D.PopUniverse()
end)
]]--

LKHooks.Add("Think", "ProgramThink", function(dt)
	FlowJam.StateThink(dt)
end)

LKHooks.Add("Render", "ProgramRender", function(dt)
	FlowJam.StateRender()
end)

LKHooks.BeginProgram()