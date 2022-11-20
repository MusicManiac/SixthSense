require "MF_ISMoodle"
require "SixthSenseModel"

MF.createMoodle("SixthSense");

SixthSense.playerLogLimiter = false
SixthSense.displayedValue = nil
SixthSense.epsilon = 0.01
SixthSense.distance = SixthSense.maxCheckSquare+1
SixthSense.chevronTime = 0
SixthSense.chevronMemoryDelay = 500

function SixthSense.MoodleSixthSenseUpdate(player)
    if player == getPlayer() and player:HasTrait("SixthSense") then
        local moodle = MF.getMoodle("SixthSense");--get access to the moodle with that name associated to getPlayer
        if moodle then 
            SixthSense.OwnUpdate(player);
            local sixthSenseDistance = SixthSense.getSixthSenseDistance(player);
            if SixthSense.Verbose then print ("MoodleSixthSenseUpdate distance = "..tostring(sixthSenseDistance or "nil")) end
            local moodleValue = 0.5;--hide
            if sixthSenseDistance < 2 then
                moodleValue =0.;--very close
            elseif sixthSenseDistance < 4 then
                moodleValue =0.2;--
            elseif sixthSenseDistance < 6 then
                moodleValue =0.3;--
            elseif sixthSenseDistance < 8 then
                moodleValue =0.4;--
            elseif sixthSenseDistance < 10 then
                moodleValue =0.6;--
            elseif sixthSenseDistance < 12 then
                moodleValue =0.7;--
            elseif sixthSenseDistance < 14 then
                moodleValue =0.8;--
            elseif sixthSenseDistance < 16 then
                moodleValue =0.9;--
            end
---
            local displayedValue = string.format("%.1f",sixthSenseDistance)
            local displayChanged = SixthSense.displayedValue ~= displayedValue
            if moodleValue ~= moodle:getValue() or displayChanged then
                --local previousLevel = moodle:getLevel()
                moodle:setValue(moodleValue);--update
                --print("SixthSense.MoodleSixthSenseUpdate "..getText("Moodles_SixthSense_Custom",displayedValue))
                moodle:setDescription(moodle:getGoodBadNeutral(),moodle:getLevel(), getText("Moodles_SixthSense_Custom",displayedValue));--update
                SixthSense.displayedValue = displayedValue;
                --if displayChanged and previousLevel == moodle:getLevel() then
                --    moodle:doWiggle();--force wiggling
                --end
            end
            
            --chevron
            if sixthSenseDistance < SixthSense.distance - SixthSense.epsilon then
                moodle:setChevronCount(2);
                moodle:setChevronIsUp(false)
                SixthSense.chevronTime = getTimestampMs()
            elseif sixthSenseDistance > SixthSense.distance + SixthSense.epsilon then
                moodle:setChevronCount(2);
                moodle:setChevronIsUp(true)
                SixthSense.chevronTime = getTimestampMs()
            else
                local ts = getTimestampMs()
                if ts - SixthSense.chevronTime > SixthSense.chevronMemoryDelay then
                    SixthSense.chevronTime = ts
                    moodle:setChevronCount(0);
                end
            end
            SixthSense.distance = sixthSenseDistance;
---
        end
    else
        if SixthSense.Verbose and not SixthSense.playerLogLimiter then print ("MoodleSixthSenseUpdate not being getPlayer "..player:getPlayerNum()) end
        SixthSense.playerLogLimiter = true;
    end
end

Events.OnPlayerUpdate.Add(SixthSense.MoodleSixthSenseUpdate);
