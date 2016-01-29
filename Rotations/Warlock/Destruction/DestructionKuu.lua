if select(2, UnitClass("player")) == "WARLOCK" then
    function cDestruction:DestructionKuu()
    
       DestructionToggles()
		local inCombat          = self.inCombat 
        local canFlask          = canUse(self.flask.wod.intellectBig) 
        local solo              = select(2,IsInInstance())=="none"
        local ttd               = getTimeToDie(self.units.dyn40)      
        local t17_2pc           = self.eq.t17_2pc
    --------------------
    --- Action Lists ---
    --------------------
    -- Action List - Extras
        function actionList_Extras()
        -- Dummy Test
            if isChecked("DPS Testing") then
                if ObjectExists("target") then
                    if combatTime >= (tonumber(getValue("DPS Testing"))*60) and isDummy() then
                        StopAttack()
                        ClearTarget()
                        StopAttack()
                        ClearTarget()
                        print(tonumber(getValue("DPS Testing")) .." Minute Dummy Test Concluded - Profile Stopped")
                    end
                end
            end
         -- Summon Pet
            if isChecked("Summon Demon") then
                if not self.talent.demonicServitude and not UnitExists("pet") and not UnitBuffID("player",self.spell.grimoireofSacrificeBuff) then
                    if getValue("Summon Demon") == 1 then
                        if petTimer == nil then petTimer = 0; end
                        if GetTime() - petTimer > 5.75 then
                            if self.castSummonFelHunter() then petTimer = GetTime() end   
                        end
                    elseif getValue("Summon Demon") == 2 then
                        if petTimer == nil then petTimer = 0; end
                        if GetTime() - petTimer > 5.75 then
                            if self.castSummonImp() then petTimer = GetTime() end
                        end
                    elseif getValue("Summon Demon") == 3 then
                        if petTimer == nil then petTimer = 0; end
                        if GetTime() - petTimer > 5.75 then
                            if self.castSummonSuccubus() then petTimer = GetTime() end
                        end
                    elseif getValue("Summon Demon") == 4 then 
                        if petTimer == nil then petTimer = 0; end
                        if GetTime() - petTimer > 5.75 then
                            if self.castSummonVoidWalker() then petTimer = GetTime() end
                        end
                    end
                elseif self.talent.demonicServitude and getEnemies("player",40) < 9 then
                    if petTimer == nil then petTimer = 0; end
                        if GetTime() - petTimer > 0.75 then
                            if self.castSummonDoomGuard("player") then petTimer = GetTime() end
                        end
                elseif self.talent.demonicServitude and getEnemies("player", 40) >= 9 then
                    if petTimer == nil then petTimer = 0; end
                        if GetTime() - petTimer > 0.75 then
                            if self.castSummonInfernal("player") then petTimer = GetTime() end
                        end
                end
            end
        end -- End Action List - Extras
    -- Action List - Defensive
        function actionList_Defensive()
                -- Pot/Stoned
                if isChecked("Pot/Stoned") and getHP("player") <= getValue("Pot/Stoned") and inCombat then
                    if canUse(5512) then
                        useItem(5512)
                    end
                end
                -- Heirloom Neck
                if isChecked("Heirloom Neck") and getHP("player") <= getValue("Heirloom Neck") then
                    if hasEquiped(122668) then
                        if GetItemCooldown(122668)==0 then
                            useItem(122668)
                        end
                    end
                end
                -- Ember Tap
                if isChecked("Ember Tap") and getHP("player") <= getValue ("Ember Tap") and inCombat then
                    if self.castEmberTap() then return end
                end
                -- Unending Resolve
                if isChecked("Unending Resolve") and getHP("player") <= getValue("Unending Resolve") and inCombat then
                    if self.castUnendingResolve() then return end
                end
        end -- End Action List - Defensive
    -- Action List - Interrupts
        function actionList_Interrupts()
        end -- End Action List - Interrupts
    -- Action List - Pre-Combat
        function actionList_PreCombat()
            if not inCombat then
                -- Flask
                -- flask,type=warm_sun
                if isChecked("Flask") then
                    if inRaid and canFlask and flaskBuff==0 and not UnitBuffID("player",176151) then
                        useItem(self.flask.wod.intellectBig)
                        return true
                    end
                    if flaskBuff==0 then
                        if self.useCrystal() then return end
                    end
                end
                -- Dark Intent
                if isChecked("Dark Intent") then
                    if self.castDarkIntent() then end
                end
                --actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled&!talent.demonic_servitude.enabled
                if self.talent.grimoireofSacrifice and not self.talent.demonicServitude and UnitExists("pet") then
                    if self.castGrimoireofSacrifice() then end
                end
                --actions.precombat+=/incinerate
                if self.castIncinerate("target") then end
                -- Food 
                -- food,type=type=mogu_fish_stew
            end -- End No Combat Check
        end --End Action List - Pre-Combat
    -- Action list - Opener
        function actionList_Cooldowns()
            --actions=summon_doomguard,if=!talent.demonic_servitude.enabled&spell_targets.infernal_awakening<9
            if not self.talent.demonicServitude and self.enemies.yards40 < 9 then
                if self.castSummonDoomGuard("target") then end
            end
            --actions+=/summon_infernal,if=!talent.demonic_servitude.enabled&spell_targets.infernal_awakening>=9
            if not self.talent.demonicServitude and self.enemies.yards40 >= 9 then
                if self.castSummonInfernal("target") then end
            end
            --actions+=/berserking
            --actions+=/blood_fury
            --actions+=/arcane_torrent
            if (self.race == "Orc" or self.race == "Troll" or self.race == "Blood Elf") then
                if self.castRacial() then end
            end
            --actions+=/mannoroths_fury
            if self.talent.mannsFury then
                if self.castMannsFury() then end
            end
            --actions+=/service_pet,if=talent.grimoire_of_service.enabled&(target.time_to_die>120|target.time_to_die<=25|(buff.dark_soul.remains&target.health.pct<20))
            --Unclear what service_pet is
            --actions+=/dark_soul,if=!talent.archimondes_darkness.enabled|(talent.archimondes_darkness.enabled&(charges=2|target.time_to_die<40|trinket.proc.any.react|trinket.stacking_proc.any.react))
            if not self.talent.archiesDarkness or (self.talent.archiesDarkness and (self.charges.darkSoulInstability == 2 or ttd<40)) then
                if dsTimer == nil then dsTimer = 0; end
                if GetTime() - dsTimer > 0.75 then
                   if self.castDarkSoulInstability() then dsTimer = GetTime() return end
                end
            end
        end -- End Action List - Opener

    -- Action List - Single Target
        function actionList_SingleTarget()
            --actions.single_target+=/havoc,target=2,if=!raid_event.adds.exists
            if self.enemies.yards40 < 2 then
                for i = 1, #getEnemies("player",40) do
                    local thisUnit = getEnemies("player",40)[i]
                    if hasThreat(thisUnit) and not UnitIsUnit(thisUnit,self.units.dyn40) then
                        if self.castHavoc(thisUnit) then return end
                    end
                end
            end
            --actions.single_target+=/shadowburn,if=talent.charred_remains.enabled&target.time_to_die<10
            if self.talent.charredRemains and ttd<10 then
                if self.castShadowburn(self.units.dyn40) then return end
            end
            --actions.single_target+=/kiljaedens_cunning,if=(talent.cataclysm.enabled&!cooldown.cataclysm.remains)
            if self.talent.cataclysm and self.cd.cataclysm == 0 then
                if self.castKJsCunning() then return end
            end
            --actions.single_target+=/kiljaedens_cunning,moving=1,if=!talent.cataclysm.enabled
            if isMoving("player") and not self.talent.cataclysm then
                if self.castKJsCunning() then return end
            end
            --actions.single_target+=/cataclysm,if=spell_targets.cataclysm>1
            if self.enemies.yards40 > 1 and self.talent.cataclysm then
                if castGroundAtBestLocation(self.spell.cataclysm,8,2,40,1) then return end
            end
            --actions.single_target+=/fire_and_brimstone,if=buff.fire_and_brimstone.down&dot.immolate.remains<=action.immolate.cast_time&(cooldown.cataclysm.remains>action.immolate.cast_time|!talent.cataclysm.enabled)&spell_targets.fire_and_brimstone>4
            if not self.buff.fireandBrimstone and (getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") <= select(4,GetSpellInfo(self.spell.immolate))/1000) and ((self.cd.cataclysm > select(4,GetSpellInfo(self.spell.immolate))/1000) or not self.talent.cataclysm) and #getEnemies(self.units.dyn40, 10) > 4 then
                if self.castFireandBrimstone() then return end
            end
            --actions.single_target+=/immolate,cycle_targets=1,if=(sim.target=target|!buff.havoc.remains|!raid_event.adds.exists)&remains<=cast_time&(cooldown.cataclysm.remains>cast_time|!talent.cataclysm.enabled)
            if not self.buff.havoc then
                for i=1, #getEnemies("player",20) do
                     if hasThreat(thisUnit) and ((getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") <= select(4,GetSpellInfo(self.spell.immolate))/1000)) and (self.cd.cataclysm > select(4,GetSpellInfo(self.spell.immolate))/1000 or not self.talent.cataclysm) then
                        local thisUnit = getEnemies("player",20)[i]
                    -- if hasThreat then
                            if self.castImmolate(thisUnit) then return end
                        --end
                    end
                end
            end
            --actions.single_target+=/cancel_buff,name=fire_and_brimstone,if=buff.fire_and_brimstone.up&dot.immolate.remains-action.immolate.cast_time>(dot.immolate.duration*0.3)
            if self.buff.fireandBrimstone and (getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") - select(4,GetSpellInfo(self.spell.immolate))/1000) > (self.debuff.remain.immolate*0.3) then
                if self.castFireandBrimstone() then return end
            end
            --actions.single_target+=/shadowburn,if=!raid_event.adds.exists&buff.havoc.remains
            if self.buff.havoc then
                if self.castShadowburn(self.units.dyn20) then return end
            end
            --actions.single_target+=/chaos_bolt,if=!raid_event.adds.exists&buff.havoc.remains>cast_time&buff.havoc.stack>=3
            if self.buff.remain.havoc > select(4,GetSpellInfo(self.spell.chaosBolt))/1000 and self.charges.havoc >= 3 then
                if self.castChaosBolt("target") then return end
            end
            --actions.single_target+=/conflagrate,if=charges=2
            if self.charges.conflagrate == 2 then
                if self.castConflagrate("target") then return end
            end
            --actions.single_target+=/cataclysm
            if self.talent.cataclysm then
                if self.castCataclysm() then return end
            end
            --actions.single_target+=/rain_of_fire,if=remains<=tick_time&(spell_targets.rain_of_fire>4|(buff.mannoroths_fury.up&spell_targets.rain_of_fire>2))
            if self.enemies.yards40 > 4 or (self.buff.mannsFury and self.enemies.yards40 > 2) then
  --              for i=1, #getEnemies("player",40) do
--                    if hasThreat("player", getEnemies("player",40)[i]) then
                if castGroundAtBestLocation(self.spell.rainofFire,8,2,20,1) then return end
            end
            --actions.single_target+=/chaos_bolt,if=talent.charred_remains.enabled&spell_targets.fire_and_brimstone>1&target.health.pct>20
            if self.talent.charredRemains and #getEnemies(self.units.dyn40, 10) > 1 and getHP(self.units.dyn40) > 20 then
                if self.castChaosBolt("target") then return end
            end
            --actions.single_target+=/chaos_bolt,if=talent.charred_remains.enabled&buff.backdraft.stack<3&burning_ember>=2.5
            if self.talent.charredRemains and self.charges.backdraft < 3 and self.ember.count >= 2.5 then
                if self.castChaosBolt("target") then return end
            end
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&(burning_ember>=3.5|buff.dark_soul.up|target.time_to_die<20)
            if self.charges.backdraft < 3 and (self.ember.count >= 3.5 or self.buff.darkSoulInstability or ttd<20) then
                if self.castChaosBolt("target") then return end
            end
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&set_bonus.tier17_2pc=1&burning_ember>=2.5
            if self.charges.backdraft < 3 and t17_2pc and self.ember.count >= 2.5 then
                if self.castChaosBolt("target") then return end
            end
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&buff.archmages_greater_incandescence_int.react&buff.archmages_greater_incandescence_int.remains>cast_time
            -- To do
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.intellect.react&trinket.proc.intellect.remains>cast_time
            -- To do
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.crit.react&trinket.proc.crit.remains>cast_time
            -- To do
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.stacking_proc.multistrike.react>=8&trinket.stacking_proc.multistrike.remains>=cast_time
            -- To do
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.multistrike.react&trinket.proc.multistrike.remains>cast_time
            -- To do
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.versatility.react&trinket.proc.versatility.remains>cast_time
            -- To do
            --actions.single_target+=/chaos_bolt,if=buff.backdraft.stack<3&trinket.proc.mastery.react&trinket.proc.mastery.remains>cast_time
            -- To do
            --actions.single_target+=/fire_and_brimstone,if=buff.fire_and_brimstone.down&dot.immolate.remains-action.immolate.cast_time<=(dot.immolate.duration*0.3)&spell_targets.fire_and_brimstone>4
            if not self.buff.fireandBrimstone and (getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") - select(4,GetSpellInfo(self.spell.immolate))/1000) <= self.debuff.duration.immolate*0.3 and #getEnemies(self.units.dyn40, 10) > 4 then
                if self.castFireandBrimstone() then return end
            end
            --actions.single_target+=/immolate,cycle_targets=1,if=(sim.target=target|!buff.havoc.remains|!raid_event.adds.exists)&remains-cast_time<=(duration*0.3)
            if not self.buff.havoc then
                for i=1, #getEnemies("player",40) do
                    local thisUnit = getEnemies("player",40)[i]
                    if hasThreat(thisUnit) and (getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") - select(4,GetSpellInfo(self.spell.immolate))/1000) <= getDebuffDuration(thisUnit,self.spell.immolateDebuff,"player")*0.3 then
                        if self.castImmolate(thisUnit) then  return end
                    end
                end
            end
            --actions.single_target+=/conflagrate,if=buff.backdraft.stack=0
            if self.charges.backdraft == 0 then
                if self.castConflagrate("target") then return end
            end
            --actions.single_target+=/incinerate
            if self.castIncinerate("target") then return end
        end -- End Action List - Single Target
    -- Action List - AoE
        function actionList_MultiTarget()
            --actions.aoe+=/havoc,target=2,if=!talent.charred_remains.enabled&buff.fire_and_brimstone.down
            if #getEnemies("player",40) == 2 and not self.talent.charredRemains and not self.buff.fireandBrimstone then
                if self.castHavoc(self.units.dyn40) then return end
            end
            --actions.aoe+=/shadowburn,if=!talent.charred_remains.enabled&buff.havoc.remains
            if not self.talent.charredRemains and self.buff.havoc then
                if self.castShadowBurn(self.units.dyn40) then return end
            end
            --actions.aoe+=/chaos_bolt,if=!talent.charred_remains.enabled&buff.havoc.remains>cast_time&buff.havoc.stack>=3
            if not self.talent.charredRemains and (getDebuffRemain(thisUnit,self.spell.havoc,"player") > select(4,GetSpellInfo(self.spell.chaosBolt))/1000) and self.charges.havoc >= 3 then
                if self.castChaosBolt("target") then return end
            end
            --actions.aoe+=/kiljaedens_cunning,if=(talent.cataclysm.enabled&!cooldown.cataclysm.remains)
             if self.talent.cataclysm and self.cd.cataclysm == 0 then
                if self.castKJsCunning() then return end
            end
            --actions.aoe+=/kiljaedens_cunning,moving=1,if=!talent.cataclysm.enabled
            if not self.talent.cataclysm and isMoving("player") then
                if self.castKJsCunning() then return end
            end
            --actions.aoe+=/cataclysm
             if self.castCataclysm() then return end
            --actions.aoe+=/fire_and_brimstone,if=buff.fire_and_brimstone.down
            if not self.buff.fireandBrimstone then
                if self.castFireandBrimstone then return end
            end
            --actions.aoe+=/immolate,if=buff.fire_and_brimstone.up&!dot.immolate.ticking&burning_ember>=2
            if self.buff.fireandBrimstone and not self.debuff.immolate and self.ember.count >= 2 then
                if self.castImmolate(self.units.dyn15) then return end
            end
            --actions.aoe+=/conflagrate,if=buff.fire_and_brimstone.up&charges=2&(burning_ember>=2|!talent.charred_remains.enabled)
            if self.buff.fireandBrimstone and self.charges.conflagrate == 2 and self.ember.count >= 2 then
                if self.castConflagrate("target") then return end
            end
            --actions.aoe+=/immolate,if=buff.fire_and_brimstone.up&dot.immolate.remains-action.immolate.cast_time<=(dot.immolate.duration*0.3)&(burning_ember>=2|!talent.charred_remains.enabled)
            if self.buff.fireandBrimstone and ((getDebuffRemain(thisUnit,self.spell.immolateDebuff,"player") - select(4,GetSpellInfo(self.spell.immolate))/1000) <= self.debuff.duration.immolate*0.3) and self.ember.count >= 2 then
                if self.castImmolate("target") then return end
            end
            --actions.aoe+=/chaos_bolt,if=talent.charred_remains.enabled&buff.fire_and_brimstone.up&burning_ember>=3
            if self.talent.charredRemains and self.buff.fireandBrimstone and self.ember.count >=3 then
                if self.castChaosBolt("target") then return end
            end
        end
---------------------
--- Begin Profile ---
---------------------
    -- Pause
    --    if pause() or (UnitExists("target") and (UnitIsDeadOrGhost("target") or not UnitCanAttack("target", "player"))) then
--            return true
  --      else
--------------
--- Extras ---
--------------
    -- Run Action List - Extras
            if actionList_Extras() then end
-----------------
--- Defensive ---
-----------------
    -- Run Action List - Defensive
            if useDefensiveDestro() then
                if actionList_Defensive() then end
            end
------------------
--- Pre-Combat ---
------------------
    -- Run Action List - Pre-Combat
            if ObjectExists("target") and not UnitIsDeadOrGhost("target") and UnitCanAttack("target", "player") then
                if actionList_PreCombat() then end
            end
-----------------
--- In Combat ---
-----------------
            if inCombat then
    ------------------
    --- Interrupts ---
    ------------------
    -- Run Action List - Interrupts
                if useInterruptsDestro() then
                    if actionList_Interrupts() then end
                end
    ----------------------
    --- Start Rotation ---
    ----------------------
    -- Call Action List - Cooldowns      
                if useCDsDestro() then
                    if actionList_Cooldowns() then end
                end
    -- Call Action List - Single Target
                --actions+=/run_action_list,name=single_target,if=spell_targets.fire_and_brimstone<6&(!talent.charred_remains.enabled|spell_targets.rain_of_fire<4)
                if useSTDestro() then
                    if  (#getEnemies(self.units.dyn40, 10) < 6 and not self.talent.charredRemains) or (#getEnemies(self.units.dyn40, 10) < 4) then
                        if actionList_SingleTarget() then return end
                    end
                end
                --actions+=/run_action_list,name=aoe,if=spell_targets.fire_and_brimstone>=6|(talent.charred_remains.enabled&spell_targets.rain_of_fire>=4)
                if useAoEDestro() then
                    if (#getEnemies(self.units.dyn40, 10) >= 6 and not self.talent.charredRemains) or (#getEnemies(self.units.dyn40, 10) >= 4) then
                        if actionList_MultiTarget() then return end
                    end
                end
            end -- End Combat Check 
--        end -- End Pause
    end -- End Rotation Function
end -- End Class Check



