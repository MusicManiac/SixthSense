
SixthSense = {}
SixthSense.Verbose = false
SixthSense.maxCheckSquare = 17
SixthSense.memo = {}

function SixthSense.getSixthSenseDistance(playerObj)
    local memo = SixthSense.memo[tostring(playerObj)]
    if memo.currentCycleTargetDistance < memo.lastCycleTargetDistance then return memo.currentCycleTargetDistance end
    return memo.lastCycleTargetDistance;
end

function SixthSense.OwnUpdate(playerObj)
    if SixthSense.Verbose then print ("SixthSense.OwnUpdate "..tostring(playerObj or 'nil').."/"..playerObj:getPlayerNum()) end
    local playerKey = tostring(playerObj)
    --local timestamp = getTimestampMs()
    local memo = SixthSense.memo[playerKey]
    if not memo then--create memo to spread search among time
        SixthSense.memo[playerKey] = {distanceMin = 0, distanceMax = 3, currentCycleTargetDistance = 1000, lastCycleTargetDistance = 1000}
        memo = SixthSense.memo[playerKey]
        if memo.distanceMax > SixthSense.maxCheckSquare then memo.distanceMax = SixthSense.maxCheckSquare end
    end
    
    local zStart = playerObj:getZ()-1
    local zEnd = zStart+2
    if memo.distanceMin > 6 then zStart = playerObj:getZ(); zEnd = zStart end--check other levels only for the closest checks (0-3 and 4-6)
    for z = zStart, zEnd do
        for distance = memo.distanceMin, memo.distanceMax do
            local y = playerObj:getY()-distance
            for x = playerObj:getX()-distance, playerObj:getX()+distance do
                SixthSense.SquareUpdate(x,y,z,playerObj,memo)
            end
            if (distance > 0) then
                y = playerObj:getY()+distance
                for x = playerObj:getX()-distance, playerObj:getX()+distance do
                    SixthSense.SquareUpdate(x,y,z,playerObj,memo)
                end
                local x = playerObj:getX()-distance
                for y = playerObj:getY()-distance+1, playerObj:getY()+distance-1 do
                    SixthSense.SquareUpdate(x,y,z,playerObj,memo)
                end
                x = playerObj:getX()+distance
                for y = playerObj:getY()-distance+1, playerObj:getY()+distance-1 do
                    SixthSense.SquareUpdate(x,y,z,playerObj,memo)
                end
            end
        end
    end
    
    if memo.distanceMax >= SixthSense.maxCheckSquare then--end of cycle
        SixthSense.resetCycle(memo);
    elseif memo.currentCycleTargetDistance < memo.distanceMax then--stop the cycle if the target is closer than next step min check distance
        SixthSense.resetCycle(memo);
    else
        memo.distanceMin = memo.distanceMax+1
        if memo.distanceMax < 9 then
            memo.distanceMax = memo.distanceMin + 2--3
        elseif memo.distanceMax < 12 then
            memo.distanceMax = memo.distanceMin + 1--2
        else
            memo.distanceMax = memo.distanceMin--1
        end
    end
    if memo.distanceMax > SixthSense.maxCheckSquare then memo.distanceMax = SixthSense.maxCheckSquare end
end

function SixthSense.resetCycle(memo)
    memo.distanceMin = 0
    memo.distanceMax = 5
    memo.lastCycleTargetDistance = memo.currentCycleTargetDistance;
    memo.currentCycleTargetDistance = 1000;
end

function SixthSense.SquareUpdate(x,y,z,playerObj,memo)
    local square = getCell():getGridSquare(x,y,z);
    if square then
        if SixthSense.Verbose then print ("SixthSense.SquareUpdate "..tostring(x or 'nil').."/"..tostring(y or 'nil')) end
        for i=0,square:getMovingObjects():size()-1 do
            local moving = square:getMovingObjects():get(i);
            if (instanceof(moving, "IsoPlayer") and moving ~= playerObj and (not SandboxVars or not SandboxVars.Moodles or SandboxVars.Moodles.SixthSenseWorksOnHumans)) or instanceof(moving, "IsoZombie") then--TODO add the humanoid NPCs, maybe animals too ?
                local distance = SixthSense.getDistance(playerObj, moving);
                if distance < memo.currentCycleTargetDistance then
                    memo.currentCycleTargetDistance = distance;
                    --TODO if there are too many Moving objects (big horde) it could cost too much and we should not focus on precision but on speed in this case
                end
            end
        end
    end
end

function SixthSense.getDistance(ownPlayer, target)
    return IsoUtils.DistanceTo(ownPlayer:getX(),ownPlayer:getY(),ownPlayer:getZ(),target:getX(),target:getY(),target:getZ())
end
