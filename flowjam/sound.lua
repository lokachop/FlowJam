FlowJam = FlowJam or {}
local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

if not speaker then
	print("/!\\ No speaker found! /!\\")
	function FlowJam.SoundThink() end

	return
end

local volume = 0.1
-- generates and returns the sound buffer to play
local targetSampleRate = 44100


local buffSize = 128 * 1024
local decoder = dfpwm.make_decoder()

local currSongBlocks = {}
local currSongBlockCount = 0
local function loadSong(path, sampleRate)
	local tW, tH = FlowJam.GetTermDimensions()

	print("-> songLoad \"" .. path .. "\"")
	print("step1")
	print("[                                ]")
	currSongBlocks = {}

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
	for i = 1, #listFull, buffSize do
		local deltaProg = i / #listFull
		term.setCursorPos(2, tH - 1)
		term.write(string.rep(":", deltaProg * 32))

		local newBlock = {}

		for j = 1, buffSize do
			newBlock[#newBlock + 1] = listFull[j + i] or 0
		end

		currSongBlocks[#currSongBlocks + 1] = newBlock
	end



	currSongBlockCount = #currSongBlocks
end

loadSong("sound/general1.dfpwm", 11500)


local currLine = 0
local function generateBuffer()
	currLine = (currLine % currSongBlockCount) + 1

	local vals = currSongBlocks[currLine]

	return vals
end

local nextPlay = 0
function FlowJam.SoundThink(dt)
	local cTime = LKHooks.CurTime()
	if nextPlay > cTime then
		return
	end

	nextPlay = cTime + (buffSize / 48000)

	local buff = generateBuffer()
	speaker.playAudio(buff)
end