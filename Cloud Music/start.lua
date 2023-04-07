function download()
	file = fs.open("playerV2.lua","a")
	file.write(http.get("https://raw.githubusercontent.com/magnusa2007/CCTweakedPrograms/main/Cloud%20Music/playerV2.lua").readAll())
	file.close()
	file = fs.open("player.lua","a")
	file.write(http.get("https://raw.githubusercontent.com/magnusa2007/CCTweakedPrograms/main/Cloud%20Music/player.lua").readAll())
	file.close()
end

if fs.exists("playerV2.lua") then
	print("File exists")
	if not (fs.open("playerV2.lua","r").readLine()== http.get("https://raw.githubusercontent.com/magnusa2007/CCTweakedPrograms/main/Cloud%20Music/playerV2.lua").readLine()) then
		print("New version want to update? y/n")
		write("> ")
		if read() == "y" then
			fs.delete("playerV2.lua")
			fs.delete("player.lua")
			download()
			print("Done")
			print("Starting")
			shell.run("playerV2.lua")
		end
	else
		print("Starting")
		shell.run("playerV2.lua")
	end
else
	print("Downloading")
	download()
	print("Done")
	shell.run("playerV2.lua")
end
