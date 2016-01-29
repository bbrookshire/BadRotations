-- Inherit from: ../cCharacter.lua
-- All Warlock specs inherit from this file
if select(2, UnitClass("player")) == "WARLOCK" then
cWarlock = {}

	function cWarlock:new(spec)
		local self = cCharacter:new("Warlock")

		local player = "player" -- if someone forgets ""

		self.profile         	= spec
		self.buff.duration	 	= {}		-- Buff Durations
		self.buff.remain 	 	= {}		-- Buff Time Remaining
		self.debuff.duration 	= {}		-- Debuff Durations
		self.debuff.remain 	 	= {}		-- Debuff Time Remaining
		self.ember 				= {}		-- Ember Information
		self.warlockSpell 			= {

			-- Ability - Crowd Control
			banish	 						= 710,
			bloodHorror 					= 111397,
			enslaveDemon	 				= 1098,
			fear	 						= 5782,
			howlofTerror 					= 5484,
			mortalCoil 						= 6789,
			shadowFury 						= 30283,

	        -- Ability - Defensive
	        darkBargain 					= 110913,
	        darkRegen 						= 108359,
	        sacPact 						= 108416,
	        soulshatter 					= 29858,
	        unboundWill 					= 108482,
	        unendingResolve					= 104733,
	        
	        -- Ability - Offensive
	        cataclysm 						= 152108,
	        commandDemon 					= 119898,
	        darkIntent						= 109773,
	        grimoireofSacrifice 			= 108503,
	        mannsFury 						= 108508,
	        
	        -- Ability - Presense

	        -- Ability - Summons
	        summonDoomGuard					= 18540,
	        summonFelHunter					= 691,
	        summonImp						= 688,
	        summonInfernal					= 1122,
	        summonSuccubus					= 712,
	        summonVoidWalker				= 697,

	        -- Ability - Utility
	        burningRush 					= 111400,
	        createHealthstone				= 6201,
	        createSoulwell					= 29893,
	        kjsCunning 						= 137587,
	        ritualofSummoning				= 698,
	        soulstone	 					= 20707,
	        unendingBreath					= 5697,
	        
	        -- Buff - Defensive
	        unendingResolveBuff				= 104773,
	        darkRegenBuff					= 108359,
	        -- Buff - Forms

	        -- Buff - Offensive
	        darkIntentBuff					 = 109773,
	        grimoireofSacrificeBuff			 = 108503,
	        
	        -- Buff - Presense

	        -- Buff - Utility

	        -- Debuff - Offensive
	        
	        -- Debuff - Defensive

	        -- Glyphs
	        
	        -- Perks

	        -- Talents
	        darkRegenTalent					= 108359,
	        soulLeechTalent					= 108370,
	        searingFlamesTalent				= 174848,
	        howlofTerrorTalent				= 5484,
	        mortalCoilTalent				= 6789,
	        shadowFuryTalent 				= 30283,
	        soulLinkTalent					= 108415,
	        sacPactTalent 					= 108416,
	        darkBargainTalent				= 110913,
	        bloodHorrorTalent				= 111397,
	        burningRushTalent				= 111400,
	        unboundWillTalent				= 108482,
	        grimoireofSupremacyTalent		= 108499,
	        grimoireofServiceTalent			= 108501,
	        grimoireofSacrificeTalent		= 108503,
	        archiesDarknessTalent			= 108505,
	        kjsCunningTalent				= 137587,
	        mannsFuryTalent					= 108508,
	        charredRemainsTalent			= 157696,
	        cataclysmTalent					= 152108,
	        demonicServitudeTalent			= 152107,
		}

	-- Update 
		function self.classUpdate()
			-- Call baseUpdate()
			self.baseUpdate()
			self.ember.count= getEmber("player")
			self.ember.max 	= getEmberMax("player")
			self.getClassOptions()
			--self.getClassBuffs()
			self.getClassBuffsDuration()
			self.getClassBuffsRemain()
			self.getClassCharges()
			self.getClassCooldowns()
			self.getClassDynamicUnits()
			self.getClassDebuffs()
			self.getClassDebuffsDuration()
			self.getClassDebuffsRemain()
			self.getClassRecharge()
		end

	-- Update OOC
		function self.classUpdateOOC()
			-- Call baseUpdateOOC()
			self.baseUpdateOOC()
			self.getClassGlyphs()
			self.getClassTalents()
		end

	-- Dynamic Units updates
		function self.getClassDynamicUnits()
			local dynamicTarget = dynamicTarget

			self.units.dyn8AoE = dynamicTarget(8, false) 
			self.units.dyn10 = dynamicTarget(10, true)
			self.units.dyn15 = dynamicTarget(15, true)
		end

	-- Buff updates
		function self.getClassBuffs()
			local UnitBuffID = UnitBuffID

			self.buff.darkIntent 				= UnitBuffID("player",self.spell.darkIntentBuff)~=nil or false
			self.buff.grimoireofSacrifice 		= UnitBuffID("player",self.spell.grimoireofSacrificeBuff)
		
		end	

		function self.getClassBuffsDuration()
			local getBuffDuration = getBuffDuration

		--	self.buff.duration.darkIntent 		= getBuffDuration("player",self.spell.darkIntentBuff) or 0
		--	self.buff.duration.darkIntent 		= getBuffDuration("player",self.spell.grimoireofSacrificeBuff) or 0

		end

		function self.getClassBuffsRemain()
			local getBuffRemain = getBuffRemain

		--	self.buff.remain.darkIntent 		= getBuffRemain("player",self.spell.darkIntentBuff) or 0
		--	self.buff.remain.darkIntent 		= getBuffRemain("player",self.spell.grimoireofSacrificeBuff) or 0

		end

		function self.getClassCharges()
		end

	-- Cooldown updates
		function self.getClassCooldowns()
			local getSpellCD = getSpellCD

			self.cd.bloodHorror			= getSpellCD(self.spell.bloodHorror)
			self.cd.howlofTerror		= getSpellCD(self.spell.howlofTerror)
			self.cd.mortalCoil 			= getSpellCD(self.spell.mortalCoil)
			self.cd.shadowFury 			= getSpellCD(self.spell.shadowFury)
			self.cd.darkBargain			= getSpellCD(self.spell.darkBargain)
			self.cd.darkRegen 			= getSpellCD(self.spell.darkRegen) 
			self.cd.sacPactTalent 		= getSpellCD(self.spell.sacPact)
			self.cd.soulshatter 		= getSpellCD(self.spell.soulshatter)
			self.cd.unboundWill 		= getSpellCD(self.spell.unboundWill)
			self.cd.unendingResolve 	= getSpellCD(self.spell.unendingResolve)
			self.cd.cataclysm 			= getSpellCD(self.spell.cataclysm)
			self.cd.grimoireofSacrifice = getSpellCD(self.spell.grimoireofSacrifice)
			self.cd.mannsFuryTalent		= getSpellCD(self.spell.mannsFury)
			self.cd.summonDoomGuard		= getSpellCD(self.spell.summonDoomGuard)
			self.cd.summonInfernal 		= getSpellCD(self.spell.summonInfernal)
			self.cd.createSoulwell	 	= getSpellCD(self.spell.createSoulwell)
			self.cd.kjsCunning 			= getSpellCD(self.spell.kjsCunning)
			self.cd.ritualofSummoning	= getSpellCD(self.spell.ritualofSummoning)
			self.cd.soulstone			= getSpellCD(self.spell.soulstone)
		end

	-- Debuff updates
		function self.getClassDebuffs()

		end

		function self.getClassDebuffsDuration()
		end

		function self.getClassDebuffsRemain()
		end

	-- Recharge updates
		function self.getClassRecharge()
		end

	-- Glyph updates
		function self.getClassGlyphs()
		end

	-- Talent updates
		function self.getClassTalents()
			local getTalent = getTalent

			self.talent.darkRegen 			= getTalent(1,1)
			self.talent.soulLeech 			= getTalent(1,2)
			self.talent.searingFlames 		= getTalent(1,3)
			self.talent.howlofTerror		= getTalent(2,1)
			self.talent.mortalCoil 			= getTalent(2,2)
			self.talent.shadowFury 			= getTalent(2,3)
			self.talent.soulLink 			= getTalent(3,1)
			self.talent.sacPact 			= getTalent(3,2)
			self.talent.darkBargain			= getTalent(3,3)
			self.talent.bloodHorror 		= getTalent(4,1)
			self.talent.burningRush 		= getTalent(4,2)
			self.talent.unboundWill			= getTalent(4,3)
			self.talent.grimoireofSupremacy = getTalent(5,1)
			self.talent.grimoireofService	= getTalent(5,2)
			self.talent.grimoireofSacrifice = getTalent(5,3)
			self.talent.archiesDarkness 	= getTalent(6,1)
			self.talent.kjsCunning 	 		= getTalent(6,2)
			self.talent.mannsFury 		  	= getTalent(6,3)
			self.talent.charredRemains 	 	= getTalent(7,1)
			self.talent.cataclysm 		 	= getTalent(7,2)
			self.talent.demonicServitude	= getTalent(7,3)
		end

	-- Get Class option modes
		function self.getClassOptions()
			--self.poisonTimer = getValue("Poison remain")
		end

	---------------
	--- OPTIONS ---
	---------------

		-- Class options
		-- Options which every Warlock should have
		function self.createClassOptions()
	        -- Create Base Options
	        self.createBaseOptions()

	        -- Class Wrap
	        local section = createNewSection(bb.profile_window,  "Class Options")
	        checkSectionState(section)
		end

	------------------------------
	--- SPELLS - CROWD CONTROL --- 
	------------------------------
		-- Banish
		function self.castBanish(thisUnit)
			--ToDo
		end
		-- Enslave Demon
		function self.castenslaveDemon(thisUnit)
			-- ToDo
		end
		-- Fear
		function self.castFear(thisUnit)
			if getDistance(thisUnit) < 30 then
				if castSpell(thisUnit,self.spell.fear,true,false,false) then return end
			end		
		end
		-- Howl of Terror
		function self.castHowlofTerror(thisUnit)
			if self.talent.howlofTerror and self.cd.howlofTerror then
				if castSpell(thisUnit,self.spell.howlofTerror,true,false,false) then return end
			end		
		end
		function self.castMortalCoil(thisUnit)
			if self.talent.mortalCoil and getDistance(thisUnit) < 30 and self.cd.mortalCoil == 0 then
				if castSpell(thisUnit,self.spell.mortalCoil,true,false,false) then return end
			end		
		end
		-- Shadowfury
		function self.castShadowFury(thisUnit)
			if self.cd.shadowFury==0 and getDistance(thisUnit) < 30 and self.cd.shadowFury == 0 then
				if castGround(thisUnit,self.spell.shadowFury,30) then return end
			end
		end

	--------------------------
	--- SPELLS - DEFENSIVE ---
	--------------------------
		-- Dark Bargain
		function self.castDarkBargain()
			if self.talent.darkBargain and self.cd.darkBargain ==0 then
				if castSpell("player",self.spell.darkBargain,false,false,false) then return end
			end
		end
		-- Dark Regeneration
		function self.castDarkRegen()
			if self.talent.darkRegen and self.cd.darkRegen ==0 then
				if castSpell("player",self.spell.darkRegen,false,false,false) then return end
			end
		end
		-- Sacrifical Pact
		function self.castSacPact()
			if self.talent.sacPact and self.cd.sacPact ==0 then
				if castSpell("player",self.spell.sacPact,false,false,false) then return end
			end
		end
		-- Soulshatter
		function self.castSoulshatter()
			if self.cd.soulshatter ==0 then
				if castSpell("player",self.spell.soulshatter,false,false,false) then return end
			end
		end
		-- Unbound Will
		function self.castUnboundWill()
			if self.talent.unboundWill and self.cd.unboundWill ==0 then
				if castSpell("player",self.spell.unboundWill,false,false,false) then return end
			end
		end
		-- Unending Resolve
		function self.castUnendingResolve()
			if self.cd.unendingResolve == 0 then
				if castSpell("player",self.spell.unendingResolve,false,false,false) then return end
			end
		end
	--------------------------
	--- SPELLS - OFFENSIVE ---
	--------------------------
		-- Cataclysm
		function self.castCataclysm()
			if self.talent.cataclysm and getDistance(self.units.dyn40)< 40 then
				if castGoundAtBestLocation(self.spell.cataclysm, 8, 3, 40, 5) then return end
			end
		end
		-- Command Demon
		function self.castCommandDemon()
			-- ToDo
		end
		-- Grimoire of Sacrifice
		function self.castGrimoireofSacrifice()
			if self.talent.grimoireofSacrifice and self.cd.grimoireofSacrifice ==0 then
				if castSpell("player",self.spell.grimoireofSacrifice,false,false,false) then return end
			end
		end
		-- Mannoroth's Fury
		function self.castMannsFury()
			if self.talent.mannsFury and self.cd.mannsFury ==0 then
				if castSpell("player",self.spell.mannsFury,false,false,false) then return end
			end
		end
		-- Dark Intent
		function self.castDarkIntent()
	        if self.instance=="none" and not isBuffed("player",{1459,61316,160205,128433,90364,126309,109773}) then
	        	if castSpell("player",self.spell.darkIntent,false,false,false) then return end
	        else
		        local totalCount = GetNumGroupMembers()
		        local currentCount = currentCount or 0
		        local needsBuff = needsBuff or 0
		        for i=1,#nNova do
		            local thisUnit = nNova[i].unit
		            local distance = getDistance(thisUnit)
		            local dead = UnitIsDeadOrGhost(thisUnit)
		            if distance<30 then
		                currentCount = currentCount+1
		            end
		            if not isBuffed(thisUnit,{1459,61316,160205,128433,90364,126309,109773}) and not dead then
		            	needsBuff = needsBuff+1
		            end
		        end
		        if currentCount>=totalCount and needsBuff>0 then
		            if castSpell("player",self.spell.darkIntent,false,false,false) then return end
		        end
		    end
	    end
	------------------------
	--- SPELLS - SUMMONS ---
	------------------------
	    -- Summon DoomGuard
	    function self.castSummonDoomGuard(thisUnit)
			if not self.talent.demonicServitude and self.cd.summonDoomGuard ==0 and getDistance("target")< 40 then
				if castSpell(thisUnit,self.spell.summonDoomGuard,true,false,false) then return end
			end
		end
		-- Summon FelHunter
		function self.castSummonFelHunter()
			if not UnitExists("pet") then
				if castSpell("player",self.spell.summonFelHunter,false,false,false) then return end
			end
		end
		-- Summon Imp
		function self.castSummonImp()
			if not UnitExists("pet") then
				if castSpell("player",self.spell.summonImp,false,false,false) then return end
			end
		end
		-- Summon Infernal
		function self.castSummonInfernal(thisUnit)
			if self.cd.summonInfernal ==0 and getDistance("target")< 30 then
				if castSpell(thisUnit,self.spell.summonInfernal,true,false,false) then return end
			end
		end
		-- Summon Succubus
		function self.castSummonSuccubus()
			if not UnitExists("pet") then
				if castSpell("player",self.spell.summonSuccubus,false,false,false) then return end
			end
		end
		-- Summon VoidWalker
		function self.castSummonVoidWalker()
			if not UnitExists("pet") then
				if castSpell("player",self.spell.summonVoidWalker,false,false,false) then return end
			end
		end
	------------------------
	--- SPELLS - UTILITY ---
	------------------------
		-- Burning Rush
		function self.castBurningRush()
			if self.talent.burningRush then
				if castSpell("player",self.spell.burningRush,false,false,false) then return end
			end
		end
		-- Create Healthstone
		function self.castCreateHealthstone()
			if castSpell("player",self.spell.createHealthstone,false,false,false) then return end
		end
		-- Create Soul Well
		function self.castCreateSoulWell()
				if castSpell("player",self.spell.createSoulWell,false,false,false) then return end
		end
		-- Kil'jaeden's Cunning
		function self.castKJsCunning()
			if self.talent.kjsCunning and self.cd.kjsCunning == 0 then
				if castSpell("player",self.spell.kjsCunning,false,false,false) then return end
			end
		end
		-- Ritual of Summoning
		function self.castRitualofSummoning()
				if castSpell("player",self.spell.ritualofSummoning,false,false,false) then return end
		end
		-- Soulstone
		function self.castSoulstone(thisUnit)
			if self.cd.soulstone ==0 then
				if castSpell(thisUnit,self.spell.soulstone,true,false,false) then return end
			end
		end
		-- Unending Breath
		function self.castUnendingBreath(thisUnit)
				if castSpell(thisUnit,self.spell.unendingBreath,true,false,false) then return end
		end

	-- Return
		return self
	end
end