--Version 2.79
--Made by MagBot
--https://github.com/magnusa2007/CCTweakedPrograms
per = peripheral.getNames()
mon = table.pack(term)
speaker = true
TouchEvent = "mouse_click"
tabs = "bg"
for i=1,#per do
	perT =  peripheral.getType(per[i])
	if perT == "monitor" then
		monitor = table.pack(peripheral.find("monitor"))
		TouchEvent = "monitor_touch"
		tabs = "fg"
	elseif perT == "speaker" then
		speaker = false
	end
end

if speaker then print("No speaker found") end

if fs.exists("playlist.table") then
	print("Found custom playlist")
	songlist = textutils.unserialize(fs.open("playlist.table","rb").readAll())
else
	songlist = textutils.unserialize(http.get("https://raw.githubusercontent.com/magnusa2007/CCTweakedPrograms/main/playlist.table").readAll())
end

song = 1
width, height = monitor[1].getSize()
n=1
timer = os.startTimer(0.25)
p="-"
rs.setOutput("top",false)
pl = 1
loop = true

function mon.clear()
	for i=1,monitor.n do
		monitor[i].clear()
	end
end
function mon.write(text)
	for i=1,monitor.n do
		monitor[i].write(text)
	end
end
function mon.setCursorPos(x,y)
	for i=1,monitor.n do
		monitor[i].setCursorPos(x,y)
	end
end

while true do
	
    mon.clear()
    mon.setCursorPos(1,1)
	if #songlist[pl][song].name>width then
		mon.write((songlist[pl][song].name.." | "..songlist[pl][song].name):sub(n,n+width))
	else
		mon.write(songlist[pl][song].name)
	end
    mon.setCursorPos(10, 2)
    mon.write("<   >")
	mon.setCursorPos(12, 2)
	if rs.getOutput("top") then
		p =  "+"
	else
		p =  "-"
	end
	mon.write(p)
	mon.setCursorPos(1, 4)
	mon.write("Playlist <   >")
	mon.setCursorPos(12, 4)
	if loop then
		p =  "+"
	else
		p =  "-"
	end
	mon.write(p)
	mon.setCursorPos(1, 5)
	mon.write(songlist[pl].name)
	
    event = {os.pullEvent()}
	--print(textutils.serialize(event))
	if event[1] == TouchEvent then
		x=event[3]
		y=event[4]
		if y == 2 then
			if x == 10 then
				song = song-1
				n=1
			elseif x == 12 then
				if rs.getOutput("top") then
					rs.setOutput("top",false)

				else
					
					shell.run(tabs,"player.lua", songlist[pl][song].song)
					--print(songlist[pl][song].song)
				end
			elseif x == 14 then
				song = song+1
				n=1
			end   
		elseif y==4 then
			if x == 10 then
				pl = pl-1
			elseif x == 12 then
				loop = not loop
			elseif x == 14 then
				pl = pl+1
			end
		end
		os.cancelTimer(timer)
		timer = os.startTimer(0.25)
	elseif event[1] == "timer" then
		n=n+1
		timer = os.startTimer(0.5)
	end
	

	if multishell.getCount() == 1 and rs.getOutput("top") and loop == true then
		song = song + 1
		shell.run(tabs,"player.lua", songlist[pl][song].song)
	elseif multishell.getCount() == 1 and rs.getOutput("top") and loop == false then
		shell.run(tabs,"player.lua", songlist[pl][song].song)
	end
	if song > #songlist[pl]+0.1  then song = 1 
	elseif song < 0.9 then song = songlist[pl] end
	
	if pl > #songlist+0.1  then pl = 1 
	elseif pl < 0.9 then pl = songlist end
	
	if n>#songlist[pl][song].name+3 then --bug location
		n=1 
	end

end
