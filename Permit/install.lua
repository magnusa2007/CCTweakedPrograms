peri = peripheral.getNames()
list = {}
term.clear()
term.setCursorPos(1,1)

print("Usable Peripherals")
for k,p in pairs(peri) do
    name = peripheral.getType(p)
    if name == "monitor"then
        l,h = peripheral.wrap(p).getSize()
        l,h = math.floor(l/9),math.floor(h/5)
        print("Monitor: "..l..","..h)
        if l == 3 and h==1 then
            list["Keyboard"] = true
        elseif l >= 3 and h>=2  then
            list["Screen"] = true
        end
    
    elseif name == "drive" then
        list["Disk Drive"] = true
        print("Disk Drive")
    elseif name == "printer" then
        list["printer"] = true
        print("Printer")
    end
end
print()
downloadlist = {"https://github.com/magnusa2007/CCTweakedPrograms/raw/main/Permit/startup.lua"}
if list["Screen"] and list["Keyboard"] then
    print("Want to install keyboard to use monitors(need a 3+x2+ and 3x1)")
    term.write("> ")
    if read() == "yes" then
        table.insert(downloadlist,"https://github.com/magnusa2007/CCTweakedPrograms/raw/main/Permit/keyboard.lua")
    end
end
for k,v in pairs(downloadlist) do
    shell.run("wget",v)
end
if list["Disk Drive"] then
    print("Move to Disk Drive?")
    if read() == "yes" then
        if fs.exists("keyboard.lua") then
            fs.move("keyboard.lua","disk/keyboard.lua")
        end
        if fs.exists("startup.lua") then
            fs.move("startup.lua","disk/startup.lua")
        end
    end
end
if list["printer"] then
    print("Recomening adding a printer")
end
print("Start program?")
if read() == "yes" then
    os.reboot()
end