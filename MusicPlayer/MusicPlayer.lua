local soundType = { --list used for local variable sounds to determine type of sound, 
                    --list contains vairables with mutliple assignments
    SOUND = 1, 
    GAME_MUSIC = 2,
    CUSTOM = 3
}

local sounds = { --sounds list containing sublists of each songs, their sound address, description and sound type,
                    --sound type will call upon local list variable to gather type
    ["murloc"] ={
        ["sounds"] = 416,
        ["description"] = "Mglrlrlrlrlrl!",
        ["type"] = soundType.SOUND
    },
    ["ding"] = {
        ["sounds"] = 888, 
        ["description"] = "Grats!",
        ["type"] = soundType.SOUND
    },
    ["main theme"] = {
        ["sounds"] = "Sound\\Music\\GlueScreenMusic\\wow_main_theme.mp3", 
        ["description"] = "DUN DUN... DUNNNNNNNN",
        ["type"] = soundType.GAME_MUSIC
    },
    ["LABUBU"] = {
        ["sounds"] = "Interface\\AddOns\\MusicPlayer\\Sounds\\customs1.mp3", 
        ["description"] = "LABUBU LABUBUUUUUU",
        ["type"] = soundType.CUSTOM
    },
    ["JET2 HOLIDAY"] = {
        ["sounds"] = "Interface\\AddOns\\MusicPlayer\\Sounds\\customs2.mp3", 
        ["description"] = "NOTHING BEATS A JET 2 HOLIDAY",
        ["type"] = soundType.CUSTOM
    },
    ["STAR TREK"] = {
        ["sounds"] = "Interface\\AddOns\\MusicPlayer\\Sounds\\customs3.mp3", 
        ["description"] = "WHOOSH",
        ["type"] = soundType.CUSTOM
    }
}

SLASH_SOUND1 = "/playsound" --variable containing sound /command for wow to intrepret 
SLASH_STOPSOUND1 = "/stopsound" --variable containing sound /command for wow to intrepret 

local customSoundId --intialize variable for soundID

local function playTrack(name, track) --prints description and plays sound

    if(track.type == soundType.GAME_MUSIC) then --check sound type
        PlayMusic(track.sounds)
        print("Playing: " .. name)
        print("Description: " .. track.description)
        print("To Stop music, type in /stopsound")
    elseif(track.type == soundType.SOUND) then
        print("Playing: " .. name)
        print("Description: " .. track.description)
        PlaySound(track.sounds)
    elseif(track.type == soundType.CUSTOM) then
        print("Playing: " .. name)
        print("Description: " .. track.description)
        --play custom sound
        customSoundId = select(2, PlaySoundFile(track.sounds)) --extracts second file from function using parameter track.sounds 
        --Play a sound file using the file path track.sounds. WIll return true or false if played correctly
        --willplay sound but struggles to stop sound

        print("To Stop music, type in /stopsound")
    end
end

local function stopSoundHandler() --function which will end sound and revert to previous zone sound
    print("Music Stopped")
    StopMusic()

    if(customSoundId ~= nil) then --check if CustomSoundId have content or is empty
        StopSound(customSoundId) --stop specific sound using file path
        print(customSoundId) -------------------------------------------------------------debugg code000000000000000000
        customSoundId = nil --reset sound id 
    end

end

local function displaySoundList() --function which will print out all available sounds 
    print("--------------------------")
    for command in pairs(sounds) do -- for loop (will iterate over every sound in sound table list)
        local description = sounds[command].description --Get description string from command list
        print("Command: /playsound " .. command .. " - description: " .. description) --play sound sound name(command variable)
    end
    print("--------------------------")
    
end

local function playSoundHandler(trackID) --function with parameter 

    if (string.len(trackID) > 0) then  --if track id has text, run if statement and content
        local matchesKnownTrack = sounds[trackID] ~= nil --if sounds[trackId string] is not empty, it will match and return true
        if(matchesKnownTrack) then
            --playTrack
            local track = sounds[trackID]
            playTrack(trackID, track)
        else
            displaySoundList() --displays prompt again 
            print(trackID .. "- Doesnt match a known track")
        end
    else --else display sound list
        displaySoundList() --calls displaysoundlist function
    end
end


SlashCmdList["SOUND"] = playSoundHandler;
SlashCmdList["STOPSOUND"] = stopSoundHandler;