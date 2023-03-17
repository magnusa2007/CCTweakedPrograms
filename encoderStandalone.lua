local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")
s = {}
x = 1
local decoder = dfpwm.make_decoder()
file = fs.find("*.dfpwm")
for i=1,#file do
	playlist[#playlist+1] = {name = name,song = song}
	s = {}
	x = 1
	print(file[i])
	for chunk in io.lines(file[i], 16 * 1024) do
		s[x] = chunk
		x=x+1
		sleep(0)
	end

	local file = fs.open("data/"..string.gsub(file[i],"dfpwm","table",1),"w")
	file.write(textutils.serialize(s))
	file.close()
	
end
