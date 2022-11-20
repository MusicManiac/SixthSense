
local function initTraits()
    TraitFactory.addTrait("SixthSense", getText("UI_trait_SixthSense"), 4, getText("UI_trait_SixthSenseDesc"), false, false);
end

local function initItem(player)
    local itemContainer = player:getInventory();
    if player:HasTrait("SixthSense") then
        --itemContainer:AddItem("Base.myItemIfINeedOne");
    end
end


Events.OnGameBoot.Add(initTraits);
Events.OnNewGame.Add(initItem);


