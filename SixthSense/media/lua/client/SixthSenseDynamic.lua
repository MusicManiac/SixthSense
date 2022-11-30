function SixthSenseDynamic()
	for playerIndex = 0, getNumActivePlayers() - 1 do
		local player = getSpecificPlayer(playerIndex);
		if not player:HasTrait("SixthSense") and (player:getPerkLevel(Perks.Lightfoot) + player:getPerkLevel(Perks.Nimble)) >= SandboxVars.Moodles.SixthSenseLevelsRequired and player:getHoursSurvived() >= (SandboxVars.Moodles.SixthSenseDaysSurvived * 24) and player:getZombieKills() >= SandboxVars.Moodles.SixthSenseKillsRequired then
			player:getTraits():add("SixthSense");
			HaloTextHelper.addTextWithArrow(player, getText("UI_trait_SixthSense"), true, HaloTextHelper.getColorGreen());
		end
	end
end

function SixthSenseDynamicInit()
	if SandboxVars.Moodles.SixthSenseDynamic == true then
		if SandboxVars.Moodles.SixthSenseLevelsRequired >= 1 then
			Events.LevelPerk.Add(SixthSenseDynamic);
		end
		if SandboxVars.Moodles.SixthSenseDaysSurvived >= 1 then
			Events.EveryDays.Add(SixthSenseDynamic);
		end
		if SandboxVars.Moodles.SixthSenseKillsRequired >= 1 then
			Events.OnZombieDead.Add(SixthSenseDynamic);
		end
	end
end

Events.OnGameStart.Add(SixthSenseDynamicInit)
