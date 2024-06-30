FlowJam = FlowJam or {}

if periphemu then
	periphemu.create("left", "speaker")
end


local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

if not speaker then
	print("/!\\ No speaker found! /!\\")
	function FlowJam.SetSong(name) end
	function FlowJam.SoundThink(dt) end

	return
end


-- generates and returns the sound buffer to play
-- TODO: convert to store table of tables of ALL songs, so we only need to load once
local targetSampleRate = 44100


local buffSize = 128 * 1024
local decoder = dfpwm.make_decoder()


local songRegistry = {}
local function loadSong(name, path, sampleRate)
	local tW, tH = FlowJam.GetTermDimensions()

	print("-> songLoad \"" .. path .. "\"")
	print("step1")
	print("[                                ]")

	local realPath = FLK3D.DataPath .. "/" .. path

	local repTimes = targetSampleRate / (sampleRate or 8000)
	local repAccum = 0

	term.setCursorPos(1, tH - 2)
	term.write("LineParse")
	local listFull = {}
	for line in io.lines(realPath, buffSize) do
		term.setCursorPos(1, tH - 2)
		term.write("DecodeBlock")
		local dec = decoder(line)
		for i = 1, #dec do
			local deltaProg = (i / #dec)
			term.setCursorPos(2, tH - 1)
			term.write(string.rep(":", deltaProg * 32))


			for j = repAccum, repAccum + repTimes do
				listFull[#listFull + 1] = dec[i]
			end
			repAccum = repAccum + repTimes
		end

		term.setCursorPos(2, tH - 1)
		term.write(string.rep(" ", 32))
	end


	term.setCursorPos(1, tH - 2)
	term.write("ReSample      ")

	term.setCursorPos(2, tH - 1)
	term.write(string.rep(" ", 32))
	local blocks = {}
	for i = 1, #listFull, buffSize do
		local deltaProg = i / #listFull
		term.setCursorPos(2, tH - 1)
		term.write(string.rep(":", deltaProg * 32))

		local newBlock = {}

		for j = 1, buffSize do
			newBlock[#newBlock + 1] = listFull[j + i]
		end

		blocks[#blocks + 1] = newBlock
	end

	songRegistry[name] = {
		["path"] = path,
		["blockCount"] = #blocks,
		["blocks"] = blocks,
	}
	print("\n")
end

--loadSong("general1", "sound/general1.dfpwm", 11250)
--loadSong("menu1", "sound/songmenu.dfpwm", 8000)
--loadSong("tuto1", "sound/songtuto.dfpwm", 8000)



local nextPlay = 0
local activeSong = "none"
local currBlock = 0

local currSongBlocks = {}
local currSongBlockCount = 0
function FlowJam.SetSong(name)
	local data = songRegistry[name]
	if not data then
		return
	end

	currSongBlocks = data.blocks
	currSongBlockCount = data.blockCount
	currBlock = 0
	activeSong = name
	if speaker then
		speaker.stop()
	end
	nextPlay = 0
end




local function generateBuffer()
	currBlock = (currBlock % currSongBlockCount) + 1

	local vals = currSongBlocks[currBlock]

	return vals
end

function FlowJam.SoundThink(dt)
	if activeSong == "none" then
		return
	end


	local cTime = LKHooks.CurTime()
	if nextPlay > cTime then
		return
	end


	local buff = generateBuffer()
	local played = speaker.playAudio(buff)
	if played then
		nextPlay = cTime + (#buff / 48000)
	end
end