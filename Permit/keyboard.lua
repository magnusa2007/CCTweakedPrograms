local mon = {peripheral.find("monitor")}
local kb = nil
for _,m in pairs(mon) do
    local l,h  = m.getSize()
    if h == 5 then
        kb = m
    end
end
if not kb then
    error("No Keyboard found(1,3 monitor)")
end
kb.clear()
local kbkey = {}
kbkey[1]="ESC1 2 3 4 5 6 7 8 9 0 "..string.char(171)
kbkey[2]=" "..string.char(18).." q w e r t y u i o p "..string.char(27)
kbkey[3]="   a s d f g h j k l _    "..string.char(30)
kbkey[4]="   z x c v b n m . + -   "..string.char(17)..string.char(31)..string.char(16)
kbkey[5]="        [       ]"
local caps = false
local function drawkeys()
    for k,v in pairs(kbkey) do
        kb.setCursorPos(1,k)
        if caps then
            kb.write(v:upper())
        else
            kb.write(v)
        end
    end
end
drawkeys()

function getKey()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        if side == peripheral.getName(kb) then

            local key = kbkey[y]:sub(x,x)
            if key ~= " " or  y==5 then
                if key == string.char(171) then key = "backspace"
                elseif key == string.char(27) then key = "enter"
                elseif key == string.char(30) then key = "up"
                elseif key == string.char(17) then key = "left"
                elseif key == string.char(31) then key = "down"
                elseif key == string.char(16) then key = "right"
                elseif x<=3 and y==1 then key= "esc"
                elseif key == string.char(18) then 
                    key = false
                    caps = not caps 
                    drawkeys()
                end 
                if caps and key then key = key:upper() end
                if y ==5 then key = " " end
                if key then
                    return key
                end
            end
        end
    end
end

function KBInput(mon)
    local x,y= mon.getCursorPos()
    local string = ""
    while true do
        local key = getKey()
        if #key==1 then
            string=string..key
            mon.setCursorPos(x,y)
            mon.write(string.." ")
        elseif key == "enter" then
            return string
        elseif key == "backspace" then
            string = string:sub(1,#string-1)
        end
    end
end


