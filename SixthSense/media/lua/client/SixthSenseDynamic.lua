function SixthSenseDynamic()
	for playerIndex = 0, getNumActivePlayers() - 1 do
        local player = getSpecificPlayer(playerIndex);
		if not player:HasTrait("SixthSense") and (player:getPerkLevel(Perks.Lightfoot) + player:getPerkLevel(Perks.Nimble)) >= SandboxVars.SixthSense.SixthSenseLevelsRequired and player:getHoursSurvived() >= (SandboxVars.SixthSense.SixthSenseDaysSurvived * 24) and player:getZombieKills() >= SandboxVars.SixthSense.SixthSenseKillsRequired then
			player:getTraits():add("SixthSense");
			HaloTextHelper.addTextWithArrow(player, getText("UI_trait_SixthSense"), true, HaloTextHelper.getColorGreen());
		end
    end
end

function SixthSenseDynamicInit()
	if SandboxVars.SixthSense.SixthSenseDynamic == true then
		if SandboxVars.SixthSense.SixthSenseLevelsRequired >= 1 then
			Events.LevelPerk.Add(SixthSenseDynamic);
		end
		if SandboxVars.SixthSense.SixthSenseDaysSurvived >= 1 then
			Events.EveryDays.Add(SixthSenseDynamic);
		end
		if SandboxVars.SixthSense.SixthSenseKillsRequired >= 1 then
			Events.OnZombieDead.Add(SixthSenseDynamic);
		end
	end
end

Events.OnGameStart.Add(SixthSenseDynamicInit)