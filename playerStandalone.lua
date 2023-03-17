url = "https://github.com/magnusa2007/CCTweakedPrograms/raw/main/data/Pray.table" 
local function  play()
	local dfpwm = require("cc.audio.dfpwm")
	local speaker = peripheral.find("speaker")
	local decoder = dfpwm.make_decoder()
	local file = http.get(url)
	local data = file.readAll()
	file.close()
	song = textutils.unserialize(data)


	for i = 1,#song do
		local buffer = decoder(song[i])

		while not speaker.playAudio(buffer) do
			
			os.pullEvent("speaker_audio_empty")
		end
	end
end
play()
