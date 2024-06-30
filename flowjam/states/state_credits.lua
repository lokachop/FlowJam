FlowJam = FlowJam or {}

local id, state = FlowJam.NewState()
STATE_CREDITS = id

local function setPalette()
	FLK3D.ResetPalette()
end

local function writeCredits()
	term.setBackgroundColor(colors.black)
	term.clear()

	local sw, sh = FlowJam.GetTermDimensions()
	local ypos = 1
	FlowJam.APrint("--==Aquatic Tide==--", sw * .5, ypos, colors.white, colors.black, TEXT_ALIGN_CENTER)
	ypos = ypos + 1


	local textNames = "A game by Lokachop & Lefton"
	local tWNames = #textNames
	term.setCursorPos(math.floor(sw * .5 - tWNames * .5), 2)
	term.write("A game by ")

	term.setTextColor(colors.lime)
	term.write("Lokachop")

	term.setTextColor(colors.white)
	term.write(" & ")

	term.setTextColor(colors.orange)
	term.write("Lefton")

	term.setTextColor(colors.white)
	ypos = ypos + 1

	FlowJam.APrint("Powered by a heavily edited version of FLK3D", sw * .5, ypos, colors.white, colors.black, TEXT_ALIGN_CENTER)
	ypos = ypos + 1
	ypos = ypos + 1
	ypos = ypos + 1

	FlowJam.APrint("--=Songs used=--", sw * .5, ypos, colors.white, colors.black, TEXT_ALIGN_CENTER)
	ypos = ypos + 1
	FlowJam.APrint("\"Over Under\" By Kevin MacLeod", sw * .5, ypos, colors.white, colors.black, TEXT_ALIGN_CENTER)
	ypos = ypos + 1
	FlowJam.APrint("\"Equatorial Complex\" By Kevin MacLeod", sw * .5, ypos, colors.white, colors.black, TEXT_ALIGN_CENTER)
	ypos = ypos + 1
	FlowJam.APrint("\"Space Jazz\" By Kevin MacLeod", sw * .5, ypos, colors.white, colors.black, TEXT_ALIGN_CENTER)
	ypos = ypos + 1
	ypos = ypos + 1
	ypos = ypos + 1
	ypos = ypos + 1


	FlowJam.APrint("Version v0.2PRE, still heavily unfinished", sw * .5, ypos, colors.white, colors.black, TEXT_ALIGN_CENTER)
	ypos = ypos + 1

	FlowJam.APrint("Press the W key to return to menu", sw * .5, sh - 2, colors.white, colors.black, TEXT_ALIGN_CENTER)
end


function state.onThink(dt)
	if LKHooks.IsKeyDown(keys.w) then
		FlowJam.SetState(STATE_MENU)
	end
end

function state.onRender()
end


function state.onEnter()
	setPalette()
	FLK3D.FOV = 60
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 256)

	FlowJam.SetSong("tuto1")
	writeCredits()
end

function state.onExit()
	FLK3D.FOV = 90
	FLK3D.BuildProjectionMatrix(FlowJam.ScrW() / FlowJam.ScrH(), 0.1, 64)
	FlowJam.ResetPalette()
end