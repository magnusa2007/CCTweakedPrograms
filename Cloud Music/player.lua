input = {...}
rs.setOutput("top",true)
x = 1
url = input[1]
file = http.get(url).readAll()
byte = 16*1024
line = string.sub(file,(x-1)*byte+1,byte+(byte)*(x-1))

local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local decoder = dfpwm.make_decoder()
temp = true
function play()
	while not (line=="") do
		buffer = decoder(line)

		while not speaker.playAudio(buffer) do
			os.pullEvent("speaker_audio_empty")
		end
		x=x+1
		line = string.sub(file,(x-1)*byte+1,byte+(byte)*(x-1))
		if not rs.getOutput("top") then
			return
		end
	end
end
play()
speaker.stop()
