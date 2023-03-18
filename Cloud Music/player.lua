--Made by MagBot
--https://github.com/magnusa2007/CCTweakedPrograms
input = {...}
--rs.setOutput("top",true)
x = 1
url = input[1]
file = http.get(url, nil, true).readAll()
byte = 16*1024

local dfpwm = require("cc.audio.dfpwm")
local decoder = dfpwm.make_decoder()
speakers = { peripheral.find("speaker") }

function pBuffer(buffer)
	local speakersF = {}
	for i, speaker in next, speakers do
		speakersF[i] = function()
			while not speaker.playAudio(buffer) do
				os.pullEvent("speaker_audio_empty")
			end
		end
	end
	parallel.waitForAll(table.unpack(speakersF))
end

function play()
	for i =1,#file,byte do
		buffer = decoder(file:sub(i, i + byte - 1))
		pBuffer(buffer)
		if not rs.getOutput("top") then
			return
		end
	end
end
play()

for i, speaker in next, speakers do
	speaker.stop()
end
shell.exit()

