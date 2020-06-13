ARC.kMoveSpeed = 1.2 -- was 2.0
ARC.kCombatMoveSpeed = 0.4 -- was 0.8

function ARC:GetIsSighted()
	return true
end

if Server then
	
	local oldOnUpdate = ARC.OnUpdate
	
	local function findTarget(targets, arcOrigin, targetSearching, distToTarget, target)
		if targetSearching then
			for _, enemy in ipairs (targets) do
				if enemy:GetIsAlive() then
					local distToTargetSub = (enemy:GetOrigin() - arcOrigin):GetLength()
					if (distToTargetSub < distToTarget) then
						target = enemy
						distToTarget = distToTargetSub
						targetSearching = false
						break
					end
				end
			end
		end
		return targetSearching, distToTarget, target
	end
	
	function ARC:OnUpdate(deltaTime)
		oldOnUpdate(self, deltaTime)
		
		if not self.parasited then
			-- todo: Do something less hacky
			self:SetParasited()
		end
		
		if self.deployMode == ARC.kDeployMode.Undeployed or self.deployMode == ARC.kDeployMode.Deployed then
			
			local teamNumber = GetEnemyTeamNumber(self:GetTeamNumber())
			local arcOrigin = self:GetOrigin()
			
			-- drive to CC, if on the way gorge structures appear, target them
			-- prio: shade, crag, entrance, whip unless cc is nearer
			
			local enemyCCs = GetEntitiesForTeam("CommandStructure", teamNumber)
			
			
			local distToTarget = math.huge
			local target
			local targetSearching = true
			
			-- find nearest cc
			targetSearching, distToTarget, target =  findTarget(enemyCCs, arcOrigin, targetSearching, distToTarget, target)
			targetSearching = true
			
			-- find nearest shade
			local enemyGSs = GetEntitiesForTeam("GorgeShade", teamNumber, arcOrigin, kARCRangeDetection)
			targetSearching, distToTarget, target =  findTarget(enemyGSs, arcOrigin, targetSearching, distToTarget, target)
			
			-- find nearest crag
			if targetSearching then
				local enemyGCs = GetEntitiesForTeam("GorgeCrag", teamNumber, arcOrigin, kARCRangeDetection)
				targetSearching, distToTarget, target =  findTarget(enemyGCs, arcOrigin, targetSearching, distToTarget, target)
			end
			
			-- find nearest tunnel
			if targetSearching then
				local entrances = GetEntitiesForTeam("TunnelEntrance", teamNumber, arcOrigin, kARCRangeDetection)
				targetSearching, distToTarget, target =  findTarget(entrances, arcOrigin, targetSearching, distToTarget, target)
			end
			
			-- find nearest Whip
			if targetSearching then
				local enemyGWs = GetEntitiesForTeam("GorgeWhip", teamNumber, arcOrigin, kARCRangeDetection)
				targetSearching, distToTarget, target =  findTarget(enemyGWs, arcOrigin, targetSearching, distToTarget, target)
			end
			
			if distToTarget < kARCRange - 2 then
				if self.deployMode == ARC.kDeployMode.Undeployed then
					self:GiveOrder(kTechId.ARCDeploy, self:GetId(), arcOrigin, nil, true, true)
				end
			elseif self:GetCurrentOrder() == nil or self:GetCurrentOrder():GetType() ~= kTechId.Move then
				if self.deployMode == ARC.kDeployMode.Undeployed then
					if target then
						self:GiveOrder(kTechId.Move, target:GetId(), target:GetOrigin(), nil, true, true)
					end
				else
					self:PerformActivation(kTechId.ARCUndeploy, nil, nil, nil)
				end
			end
		end
	end
end
