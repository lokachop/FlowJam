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
local lastTCounter = 0
local buffSize = 16 * 1024
local function generateBuffer()
	local buff = {}
	for i = 1, buffSize do
		local realTime = (i + lastTCounter)

		local t = (realTime / buffSize) * 3000

		--buff[i] = bit32.band(bit32.rshift(t, 10), 42) * t
		--buff[i] = (bit32.band(t*(bit32.bxor(bit32.bor(t/10, 0), bit32.bor(t/10, 0)-1280)%11)/2, 127) + bit32.band(t*(bit32.bxor(bit32.bor(t/640, 0), bit32.bor(t/640, 0)-2)%13)/2, 127))

		buff[i] = ((buff[i] % 256) - 127) * volume
		--buff[i] = math.sin((realTime / buffSize) * 440) * 127
	end
	lastTCounter = lastTCounter + buffSize

	return buff
end

local nextPlay = 0
function FlowJam.SoundThink(dt)
	local cTime = LKHooks.CurTime()
	if nextPlay > cTime then
		return
	end

	nextPlay = cTime + (buffSize / 48000)
	print("PLAY")

	local buff = generateBuffer()
	speaker.playAudio(buff)
	--while not speaker.playAudio(buff) do
		--os.pullEvent("speaker_audio_empty")
	--end
end