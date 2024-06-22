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