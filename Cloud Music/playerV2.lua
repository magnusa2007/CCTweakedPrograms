--Version 2.4
mon = peripheral.find("monitor")
speaker = peripheral.find("speaker")
songlist = textutils.unserialize(http.get("https://raw.githubusercontent.com/magnusa2007/CCTweakedPrograms/main/playlist.table").readAll())
song = 1
width, height = mon.getSize()
n=1
os.startTimer(0.25)
p="-"
rs.setOutput("top",false)

while true do
	
    mon.clear()
    mon.setCursorPos(1,1)
	if #songlist[song].name>width then
		mon.write(songlist[song].name:sub(n,n+width).." | "..songlist[song].name)
	end
	mon.write(songlist[song].name)
    mon.setCursorPos(7, 2)
    mon.write("<   >")
	mon.setCursorPos(9, 2)
	if rs.getOutput("top") then
		p  =  "+"
	else
		p=  "-"
	end
	mon.write(p)
	
    event = {os.pullEvent()}
	--print(textutils.serialize(event))
	if event[1] == "monitor_touch" then
		x=event[3]
		y=event[4]
		if y == 2 then
			if x == 7 and song > 1 then
				song = song-1
				n=1
			elseif x == 9 then
				if rs.getOutput("top") then
					rs.setOutput("top",false)

				else
					rs.setOutput("top",true)         
					shell.run("bg","player.lua", songlist[song].song)
				end
			elseif x == 11 and song < #songlist then
				song = song+1
				n=1
			end   
		end
	end
	
	if n>#songlist[song].name+3 then n=1 end
	if event[1] == "timer" then
		n=n+1
		os.startTimer(0.5)
	end
end
