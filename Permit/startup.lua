monitors = {peripheral.find("monitor")}
if monitors[1] == nil then
    mon = term
    function KBInput(screen,lock)
        return read(lock)
    end
    function getKey()
        while true do
            event,key = os.pullEvent()
            if event=="char" then
                if key =="q" then
                    return "esc"
                else
                    return key
                end
            elseif event=="key" and #keys.getName(key) > 1 then
                return keys.getName(key)
            end
        end
    end

else
    require("keyboard")
    mon = nil
    for _,m in ipairs(monitors) do
        local l,h = m.getSize()
        if h ~= 5 then
            mon = m
        end
    end
    if not mon then
        error("No Screen found(2+,3 monitor)")
    end
end

disk = ""
if fs.exists("disk") then
    disk= "disk/"
end

l,h = mon.getSize()


function header(menu)
	mon.setCursorPos(1,1)
	mon.setBackgroundColor(colors.gray)
	mon.clearLine()
	mon.write(center(menu))
	mon.setBackgroundColor(colors.black)
	mon.setCursorPos(1,2)
end

function write(text,x,y,color,clear)
	if x ~= nil then
		mon.setCursorPos(x,y)
	end
	if color ~=nil then
		mon.setTextColor(colors[color])
	else
		mon.setTextColor(colors.white)
	end
	if clear then mon.clearLine() end
	mon.write(text)
end

function center(text,with)
		if with == nil then
			with = l
		end
		return string.rep(" ",(with-#text)/2)..text
end

function hash(text)
	x = 0
	for s in string.gmatch(text,"%S") do
		x=x+string.byte(s)
	end
	return x
end



function signin()
	mon.clear()
	header("Sign in")
	local x=0
	local reg= {user="",password=""}
	while true do
		write("Username:  "..reg.user.." ",1,2)
		write("Password:  "..string.rep("*",#reg.password).." ",1,3)
		write(">",10,x+2,"yellow")
        write("",nil,nil,"white")
		local key = getKey()
		if #key==1 then
			if x ==0 then
				reg.user=reg.user..key
			else
				reg.password=reg.password..key
			end
		elseif key == "up" or key == "down" then
			x=(x+1)%2
		elseif key == "backspace" then
			if x ==0 then
				reg.user=reg.user:sub(1,#reg.user-1)
			else
				reg.password=reg.password:sub(1,#reg.password-1)
			end
		elseif key == "enter" then
			if users[reg.user] ~= nil then
				if users[reg.user] == hash(reg.password) then
					curentUser = reg.user
					return
				else
					write("Wrong Password",1,4,"red",true)
				end
			else
				write("Unkown Username!",1,4,"red",true)
			end
		end
	end
end

function register()
	mon.clear()
	header("Register")
	local x=0
	local reg= {user="",password=""}
	while true do
		write("Username:  "..reg.user.." ",1,2)
		write("Password:  "..string.rep("*",#reg.password).." ",1,3)
		write(">",10,x+2,"yellow")
		local key = getKey()
		if #key==1 then
			if x ==0 then
				reg.user=reg.user..key
			else
				reg.password=reg.password..key
			end
		elseif key == "up" or key == "down" then
			x=(x+1)%2
		elseif key == "backspace" then
			if x ==0 then
				reg.user=reg.user:sub(1,#reg.user-1)
			else
				reg.password=reg.password:sub(1,#reg.password-1)
			end
		elseif key == "enter" then
			if users[reg.user] ~= nil then
				write("Username is already in use!",1,4,"red")
			else
				users[reg.user] = hash(reg.password)
				file = fs.open(disk.."users","w")
				file.write(textutils.serialise(users))
				file.close()
				curentUser = reg.user
				return
			end
		end
	end
end

function newPermit()
	mon.clear()
	header("Register")
	local x=0
	local permit= {}
	permit["Permit Holder"] = ""
	permit["Permit Type"] = ""
	permit["Expiration"] = "" 
	while true do
		write("Permit Holder  :  "..permit["Permit Holder"].." ",1,2)
		write("Permit Type    :  "..permit["Permit Type"].." ",1,3)
		write("Expiration Date:  "..permit["Expiration"].." Days",1,4)
		write(">",17,x+2,"yellow")
		local key = getKey()
		if #key==1 then
			if x ==0 then
				permit["Permit Holder"]=permit["Permit Holder"]..key
			elseif x == 1 then
				permit["Permit Type"]=permit["Permit Type"]..key
			else
				permit["Expiration"]=permit["Expiration"]..key
			end
		elseif key == "up" or key == "down" then
			x=(x+1)%3
		elseif key == "backspace" then
			if x ==0 then
				permit["Permit Holder"]=permit["Permit Holder"]:sub(1,#permit["Permit Holder"]-1)
			elseif x==1 then
				permit["Permit Type"]=permit["Permit Type"]:sub(1,#permit["Permit Type"]-1)
			else
				permit["Expiration"]=permit["Expiration"]:sub(1,#permit["Expiration"]-1)
			end
        elseif key == "esc" then
            return
		elseif key == "enter" then
			created = false
			for k,v in pairs(permits) do
				if v["Permit Type"] == permit["Permit Type"] then
					write("Permit is already created!",1,5,"red")
					created=true
				end
            end
			if not created then
				permit["Permit No"] = ((hash(permit["Permit Type"])*hash(permit["Permit Holder"]))..""):sub(1, 9)
				permit["Auth No"] = hash(permit["Permit Holder"]..permit["Permit Type"])
				permit["Issue Date"] = os.date("%Y-%m-%d",os.epoch("utc")/1000)
				permit["Issue Time"] = os.date("%H:%M:%S",os.epoch("utc")/1000)
				permit["Admin Id"] = hash(curentUser)
				if permit["Expiration"] == "" then
					permit["Expiration"] = "None"
				else
					permit["Expiration"] = os.date("%Y-%m-%d",os.epoch("utc")/1000+(86400*tonumber(permit["Expiration"])))
				end
				
				table.insert(permits,permit)
				file = fs.open(disk.."permits","w")
				file.write(textutils.serialise(permits))
				file.close()
                printPermit(permit)
				return
			end
		end
	end
end


function listPermits()
    mon.clear()
    x=0
    header("Permit list")
    while true do
        if #permits == 0 then
            newPermit()
			if #permits == 0 then
				return
			end
        end
        permit=permits[x+1]
        write("Sellers Permit",1,2,nil,true)
        write("Permit Holder: "..permit["Permit Holder"],1,2,nil,true)
        write("Permit Type: "..permit["Permit Type"],1,3,nil,true)
        write("Permit No: "..permit["Permit No"],1,4,nil,true)
        write("Auth No: "..permit["Auth No"],1,5,nil,true)
        write("Issue Date: "..permit["Issue Date"],1,6,nil,true)
        write("Issue Time: "..permit["Issue Time"],1,7,nil,true)
		write("Expires: "..permit["Expiration"],1,8,nil,true)
        write("Admin Id: "..permit["Admin Id"],1,9,nil,true)
		write("",1,h,nil,true)
        write("",1,h-1,nil,true)
		write("ESC/½ to exit",1,h-5,nil,true)
		write("Enter to print",1,h-4,nil,true)
		write("backspace to delete",1,h-3,nil,true)
		write("e to edit",1,h-2,nil,true)
        key = getKey()

        if key == "right" then
            x=x+1
        elseif key=="left" then
            x=x-1
        elseif key== "enter" then
            printPermit(permit)
            write("Permit printed!",1,h)
		elseif key =="e" then
			write("New Permit Holder",1,h-1)
			write(">",1,h,"yellow")
			write(" ",nil,nil,"white")
			permits[x+1]["Permit Holder"] = KBInput(mon)
			print(permits[x+1]["Permit Holder"])
			printPermit(permits[x+1])
			file = fs.open(disk.."permits","w")
			file.write(textutils.serialise(permits))
			file.close()
        elseif key=="backspace" then
            write("Delete "..permit["Permit Type"].."?",1,h-1,"red")
            write(">",1,h,"yellow")
            write(" ",nil,nil,"white")
            answer = KBInput(mon)
            if answer:lower() == "yes" then
	            table.remove(permits,x+1)
	            file = fs.open(disk.."permits","w")
	            file.write(textutils.serialise(permits))
	            file.close()
            end
        elseif key == "esc" then
            return
        end
        x=x%#permits
    end
end

function printPermit(permit)
    local printer = peripheral.find("printer")
    if not printer then
        write(center("Printer not found!"),1,h/2,"red",true)
        os.sleep(1)
		return
    end
	if printer.getInkLevel() ==0 or printer.getPaperLevel() == 0 then
		write(center("Check Paper and ink level"),1,h/2+1,"red",true)
		write(center("Permit is saved"),1,h/2+2,"red",true)
        os.sleep(1)
		return
	end
	
    pos = 1
    function line(text)
        printer.setCursorPos(1, pos)
        printer.write(text)
        pos=pos+1
    end
	
    printer.newPage()
	width,hight = printer.getPageSize()
    printer.setPageTitle("Sellers Permit")
	line(center("Sellers Permit",width))
    line("Holder: "..permit["Permit Holder"])
    line("Type: "..permit["Permit Type"])
    line("No: "..permit["Permit No"])
    line("Auth No: "..permit["Auth No"])
    line("Issue Date: "..permit["Issue Date"])
    line("Issue Time: "..permit["Issue Time"])
	line("Expires : "..permit["Expiration"])
    line("Admin Id: "..permit["Admin Id"])
    printer.endPage()
end

function edituser()
	mon.clear()
	header("User Edit Pannel")
	local x = 0
	userlist = {}
	for k,v in pairs(users) do
		table.insert(userlist,k)
	end
	table.insert(userlist,"Register New User")
	while true do
		for k,v in pairs(userlist) do
			if k == x+1 then
				write(center("["..v.."]"),1,k+1)
			else
				write(center(" "..v.." "),1,k+1)
			end
		end
        if x+1<#userlist then
            write("User Id: "..hash(userlist[x+1]),1,h-2)
        else
            write("",1,h,nil,true)
        end
		key = getKey()
		if key == "up" then
			x=x-1
		elseif key == "down" then
			x=x+1
        elseif key == "esc" then
            return
		elseif key=="enter" then
			if x == #userlist-1 then
				register()
				return
			else
				write("Delete "..userlist[x+1].."?",1,h-1,"red")
				write(">",1,h,"yellow")
				write(" ",nil,nil,"white")
				answer = KBInput(mon)
				if answer:lower() == "yes" then
					users[userlist[x+1]]=nil
					file = fs.open(disk.."users","w")
					file.write(textutils.serialise(users))
					file.close()
					edituser()
					if #users == 0 then
						register() 
					end
					return
				else
					write("",1,h-1,nil,true)
					write("",1,h,nil,true)
				end

			end
		end
		x = x%#userlist
	end
end

function menu()
	mon.clear()
	header("Admin Panel")
	write("Curent User: "..curentUser,1,h)
	local x = 0
	menus = {}
	menus[1]="Create New Permit"
	menus[2]="List All Permits"
	menus[3]="Edit Users"
	menus[4]="Sign Out"
	while true do
		for k,v in pairs(menus) do
			if k == x+1 then
				write(center("["..v.."]"),1,k+1)
			else
				write(center(" "..v.." "),1,k+1)
			end
		end
		key = getKey()
		if key == "up" then
			x=x-1
		elseif key == "down" then
			x=x+1
		elseif key=="enter" then
			if x == 0 then
				newPermit()
			elseif x==1 then
				listPermits()
			elseif x==2 then
				edituser()
			elseif x==3 then
				curentUser = false
				signin()
			end
			return
		end
		x = x%#menus
	end
end

if fs.exists(disk.."users") then
	users = textutils.unserialise(fs.open(disk.."users","rb").readAll())
else
	users = {}
	
end
needreg = true
for k,v in pairs(users) do needreg = false end
if needreg then
	register()
end

if fs.exists(disk.."permits") then
	permits = textutils.unserialise(fs.open(disk.."permits","rb").readAll())
else
	permits = {}
end

curentUser = "false"
signin()
while true do
	menu()
end