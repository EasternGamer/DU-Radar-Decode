local function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

local function tobool(bool)
    if type(bool) == "string" then
        if string.lower(bool) == "true" then
            return true
        elseif string.lower(bool) == "false" then
            return false
        end
    elseif type(bool) == "number" then
        if bool == 1 then
            return true
        elseif bool == 0 then
            return false
        end
    end
    return nil
end

function decodeRadar()
    local propertiesArray = {}
    local identifiedConstructs = {}
    local constructData = {}
    local identifying = {}
    
    local radarData = radar_1.getData()
    local find = string.find(radarData,"%],")
    local constructs = string.sub(radarData, 19, find)

    local constructDataArray = (constructs..[[{"constructId":]]):gmatch("(.-)"..[[{"constructId":]])
    local i = 1
    for v in constructDataArray do
        --system.print(v)
        if i > 1 and i < (limit + 1) then
        	local subData = v
           
        	local infoStart, infoEnd = string.find(subData, [["info":]]), string.find(subData, "},")
        	local primaryData = string.sub(subData, 1, infoStart) .. string.sub(subData, infoEnd + 3, string.len(subData))
        	local info = string.sub(subData, infoStart + 7, infoEnd)
        	primaryData = split(primaryData, ",")
        	primaryData[1] = string.sub(primaryData[1], 2, primaryData[1]:len() - 1) --ID
        	primaryData[2] = tonumber(string.sub(primaryData[2], 12, primaryData[2]:len())) --Distance
        	primaryData[3] = tobool(string.sub(primaryData[3], 19, primaryData[3]:len())) --inIdentifyRange
        	primaryData[4] = tobool(string.sub(primaryData[4], 16, primaryData[4]:len())) --isIdentified
        	primaryData[5] = tonumber(string.sub(primaryData[5], 25, primaryData[5]:len())) --myThreatStateToTarget
        	primaryData[6] = string.sub(primaryData[6], 9, primaryData[6]:len() - 1) --name
        	primaryData[7] = string.sub(primaryData[7], 9, primaryData[7]:len() - 1) --size
        	primaryData[8] = tonumber(string.sub(primaryData[8], 21, primaryData[8]:len() - 2)) --targetThreatState
        	local infoArray = {}
        	if info ~= "{}" then
            	local infoSplit = split(info, ",")
            	if #infoSplit ~= 2 then --ignore locking data
                	infoArray[1] = tonumber(string.sub(infoSplit[1], 17, string.len(infoSplit[1]))) -- angular speed
                	infoArray[2] = tonumber(string.sub(infoSplit[2], 15, string.len(infoSplit[2]))) -- anti gravity
                infoArray[3] = tonumber(string.sub(infoSplit[3], 15, string.len(infoSplit[3]))) -- atmo engines
                infoArray[4] = tonumber(string.sub(infoSplit[4], 17, string.len(infoSplit[4]))) -- construct type
                infoArray[5] = tonumber(string.sub(infoSplit[5], 8, string.len(infoSplit[5]))) -- mass
                infoArray[6] = tonumber(string.sub(infoSplit[6], 10, string.len(infoSplit[6]))) -- radars
                infoArray[7] = tonumber(string.sub(infoSplit[7], 15, string.len(infoSplit[7]))) -- radial speed
                infoArray[8] = tonumber(string.sub(infoSplit[8], 18, string.len(infoSplit[8]))) -- rocket boosters
                infoArray[9] = tonumber(string.sub(infoSplit[9], 16, string.len(infoSplit[9]))) -- space engines
                infoArray[10] = tonumber(string.sub(infoSplit[10], 9, string.len(infoSplit[10]))) -- speed
                infoArray[11] = tonumber(string.sub(infoSplit[11], 11, string.len(infoSplit[11]) - 1)) -- weapons
            end
        end
        constructData[i - 1] = {primaryData, infoArray}
        end
        i = i + 1
    end
    local properties = string.sub(radarData, find + 2, string.len(radarData) - 1)
    find = string.find(properties, [["staticProperties":{]])
    local findOther = string.find(properties, [["properties":{]])
    properties = string.sub(properties, findOther + 14, find - 3)
    find = string.find(properties, [["identifiedConstructs"]])
    findOther = string.find(properties, [[%],]])
    local identifiedConstructsString = string.sub(properties, find + 24, findOther - 1)
    identifiedConstructs = split(identifiedConstructsString, ",")
    for i=1, #identifiedConstructs do
        local targetString = string.sub(identifiedConstructs[i], 2, #identifiedConstructs[i]-1)
        if targetString ~= "" then
        	identifiedConstructs[i] = targetString
        end
    end
    properties = string.sub(properties, 1, find) .. string.sub(properties, findOther + 3, string.len(properties))
    find = string.find(properties, [["identifyConstructs"]])
    findOther = string.find(properties, [[%},]])
    local targetsBeingIdentified = string.sub(properties, find + 23, findOther - 1)
    identifying = split(targetsBeingIdentified, ",")
    for i=1, #identifying do
        local targetString = string.sub(identifying[i], 2, #identifying[i]-1)
        if targetString ~= "" then
            local target = {}
            local find = string.find(targetString, ":")
            target[1] = string.sub(targetString, 1, find - 2) --id 
            target[2] = tonumber(string.sub(targetString, find + 1, string.len(targetString))) --time
            identifying[i] = target
        end
    end
    properties = string.sub(properties, 1, find - 1) .. string.sub(properties, findOther + 2, string.len(properties))
    propertiesArray = split(properties, ",")
    propertiesArray[1] = tobool(string.sub(propertiesArray[1], 10, string.len(propertiesArray[1]))) -- broken
    propertiesArray[2] = string.sub(propertiesArray[2], 17, string.len(propertiesArray[2])-1) -- error message
    propertiesArray[3] = tonumber(string.sub(propertiesArray[3], 15, string.len(propertiesArray[3]))) -- radar status
    propertiesArray[4] = string.sub(propertiesArray[4], 22, string.len(propertiesArray[4]) - 1) -- selected Construct
    propertiesArray[5] = tobool(string.sub(propertiesArray[5], 22, string.len(propertiesArray[5]))) -- works in environment
    
    return constructData, propertiesArray, identifiedConstructs, indentifying
end