--Version 2.5
mon = peripheral.find("monitor")
speaker = peripheral.find("speaker")
if fs.exists("playlist.table") then
	print("Found custom playlist")
	songlist = textutils.unserialize(fs.open("playlist.table","rb").readAll())
else
	songlist = textutils.unserialize(http.get("https://raw.githubusercontent.com/magnusa2007/CCTweakedPrograms/main/playlist.table").readAll())
end
song = 1
width, height = mon.getSize()
n=1
os.startTimer(0.25)
p="-"
rs.setOutput("top",false)
pl = 1
while true do
	
    mon.clear()
    mon.setCursorPos(1,1)
	if #songlist[pl][song].name>width then
		mon.write(songlist[pl][song].name:sub(n,n+width).." | "..songlist[song].name)
	else
		mon.write(songlist[pl][song].name)
	end
    mon.setCursorPos(10, 2)
    mon.write("<   >")
	mon.setCursorPos(12, 2)
	if rs.getOutput("top") then
		p  =  "+"
	else
		p=  "-"
	end
	mon.write(p)
	mon.setCursorPos(1, 3)
	mon.write("Playlist <   >")
	mon.setCursorPos(1, 4)
	mon.write(songlist[pl].name)
	
    event = {os.pullEvent()}
	--print(textutils.serialize(event))
	if event[1] == "monitor_touch" then
		x=event[3]
		y=event[4]
		if y == 2 then
			if x == 10 and song > 1 then
				song = song-1
				n=1
			elseif x == 12 then
				if rs.getOutput("top") then
					rs.setOutput("top",false)

				else
					rs.setOutput("top",true)         
					shell.run("bg","player.lua", songlist[pl][song].song)
				end
			elseif x == 14 and song < #songlist[pl] then
				song = song+1
				n=1
			end   
		elseif y==3 then
			if x == 10 and pl > 1 then
				pl = pl-1
			elseif x == 14 and pl < #songlist then
				pl = pl+1
			end
		end
	end
	
	if n>#songlist[pl][song].name+3 then n=1 end
	if event[1] == "timer" then
		n=n+1
		os.startTimer(0.5)
	end
end
