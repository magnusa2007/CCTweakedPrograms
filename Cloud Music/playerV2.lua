mon = peripheral.find("monitor")
speaker = peripheral.find("speaker")
songlist = textutils.unserialize(http.get("https://raw.githubusercontent.com/magnusa2007/CCTweakedPrograms/main/playlist.table").readAll())
print(textutils.serialize(songlist))
song = 1
playing = false

while true do
    mon.clear()
    mon.setCursorPos(1,1)
    mon.write(songlist[song].name)
    mon.setCursorPos(7, 2)
    mon.write("< x >")
 
    event, side, x, y = os.pullEvent("monitor_touch")
    print("event: "..event.. "x,y "..x..","..y)
    if y == 2 then
        if x == 7 and song > 1 then
            song = song-1
        elseif x == 9 then
            if playing then
				rs.setOutput("top",false)

                playing = false
            else
				rs.setOutput("top",true)         
				shell.run("bg","player.lua", songlist[song].song)
                playing = true
				--print("on")
			end
		--print(fs.open("playing","r").readLine())
        elseif x == 11 and song < #songlist then
            song = song+1
        end   
   end
end
