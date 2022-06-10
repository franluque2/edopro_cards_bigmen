--Curse of Lucky Straight
local s,id=GetID()


function s.initial_effect(c)
	--Activate Skill
	aux.AddSkillProcedure(c,1,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	aux.AddSkillProcedure(c,1,false,s.flipcon2,s.flipop2)
end


function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id+1,0,0,0)
end
e:SetLabel(1)
	end


function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and (Duel.GetTurnCount()==1 or Duel.GetTurnCount()==2) and Duel.GetTurnPlayer()==tp
end
--At the start of your first Standby Phase, set 1 "Monster Slots" from outside the duel to your Spell/Trap Zone, then Special Summon 1 "Slot Machine" in Attack Position from outside the duel, then place 1 "Slot Machine" in your GY and on the top of your deck from outside the duel.
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.replace_number_seven(e,tp,eg,ep,ev,re,r,rp)
	s.summon_slotmachine(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.summon_slotmachine(e,tp,eg,ep,ev,re,r,rp)
	local slo1=Duel.CreateToken(tp,03797883)
	Duel.SpecialSummon(slo1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	local slo2=Duel.CreateToken(tp,03797883)
	Duel.SendtoDeck(slo2,nil,SEQ_DECKTOP,REASON_EFFECT)
	local slo3=Duel.CreateToken(tp,03797883)
	Duel.SendtoGrave(slo3,REASON_EFFECT)
	local mslots=Duel.CreateToken(tp,09576193)
	Duel.SSet(tp,mslots)
end

function s.number_seven_filter_extra(c)
return c:IsCode(82308875)
end

function s.dice_leveler_filter_hand(c)
return c:IsCode(100000190)
end

function s.dice_leveler_filter_deck(c)
return c:IsCode(100000190) and c:IsAbleToHand()
end

function s.replace_number_seven(e,tp,eg,ep,ev,re,r,rp)
local hg=Duel.GetMatchingGroup(s.number_seven_filter_extra,tp,LOCATION_EXTRA,0,nil)
if #hg>0 then		   
			for card in aux.Next(hg)do
			Duel.SendtoDeck(card,tp,-2,REASON_EFFECT)
			local newnoseven=Duel.CreateToken(tp,81632111)
			Duel.SendtoDeck(newnoseven,tp,SEQ_DECKTOP,REASON_EFFECT)
	end

end
end
function s.spell_banish_filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function s.monster_banish_filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(6) and c:IsLevelBelow(8)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


--. Once per turn, you can banish 1 Spell from your GY to target 1 Level 7 monster that's either banished or in your GY, then Special Summon it in Attack Position.
function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	
	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp,id+3)>0 then return end
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.spell_banish_filter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.monster_banish_filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)

		local b2=Duel.GetFlagEffect(ep,id+3)==0
			and Duel.IsExistingMatchingCard(s.dice_leveler_filter_hand,tp,LOCATION_HAND,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(s.dice_leveler_filter_deck,tp,LOCATION_DECK,0,2,nil)

	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)

		local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.spell_banish_filter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.monster_banish_filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)

		local b2=Duel.GetFlagEffect(ep,id+3)==0
			and Duel.IsExistingMatchingCard(s.dice_leveler_filter_hand,tp,LOCATION_HAND,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(s.dice_leveler_filter_deck,tp,LOCATION_DECK,0,2,nil)

	local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
								  {b2,aux.Stringid(id,1)})

	op=op1-1
	if op==0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cg=Duel.SelectMatchingCard(tp,s.spell_banish_filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.monster_banish_filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.dice_leveler_filter_hand,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	if #g>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectMatchingCard(tp,s.dice_leveler_filter_deck,tp,LOCATION_DECK,0,2,2,nil)
	if #g2>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)
	end
	local trace=Duel.CreateToken(tp,10000191)
	Duel.SSet(tp,trace)
	end
		Duel.RegisterFlagEffect(tp,id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
