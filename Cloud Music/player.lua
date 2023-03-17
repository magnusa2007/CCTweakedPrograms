input = {...}
rs.setOutput("top",true)
x = 1
url = input[1]
file = textutils.unserialise(http.get(url).readAll())
byte = 16*1024

local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local decoder = dfpwm.make_decoder()
function play()
	for line = 1,#file do
		buffer = decoder(file[line])

		while not speaker.playAudio(buffer) do
			os.pullEvent("speaker_audio_empty")
		end
		if not rs.getOutput("top") then
			return
		end
	end
end
play()
speaker.stop()
