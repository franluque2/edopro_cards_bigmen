--Burrito Break
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
		e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id+1,0,0,0)

		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCondition(s.adcon)
		e2:SetOperation(s.adop)
		Duel.RegisterEffect(e2,tp)
		end
e:SetLabel(1)
end



function s.mking_win_filter(c)
	return c:IsCode(13803864) and c:IsFaceup() and c:GetCounter(0x1655)==6
end

function s.mking_fu_filter(c)
	return c:IsCode(13803864) and c:IsFaceup()
end

function s.winop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.mking_win_filter, tp, LOCATION_MZONE, 0, 1, nil) then
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Win(tp,0x1659)
	end
end


function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(s.mking_fu_filter, tp, LOCATION_MZONE, 0, 1, nil)
end

function s.adop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.SelectMatchingCard(tp,s.mking_fu_filter,tp,LOCATION_MZONE,0,1,1,false,nil)
		if g then
			g:GetFirst():AddCounter(0x1655+COUNTER_NEED_ENABLE,1)
			s.winop(e,tp,eg,ep,ev,re,r,rp)
		end
end


function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.place_mokeys(e,tp,eg,ep,ev,re,r,rp)
	s.swap_kings(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

		--At the start of the duel, place 2 "Mokey Mokey" in your GY from outside the duel,
		-- then place 2 "Mokey Mokey" on the bottom of your Deck. also your "Mokey Mokey King"(s) become like, more chill dude...
function s.place_mokeys(e,tp,eg,ep,ev,re,r,rp)
	local mokey1=Duel.CreateToken(tp,27288416)
	local mokey2=Duel.CreateToken(tp,27288416)
	local mokey3=Duel.CreateToken(tp,27288416)
	local mokey4=Duel.CreateToken(tp,27288416)

	Duel.SendtoGrave(mokey1, REASON_EFFECT)
	Duel.SendtoGrave(mokey2, REASON_EFFECT)

	Duel.SendtoDeck(mokey3, tp, SEQ_DECKBOTTOM, REASON_EFFECT)
	Duel.SendtoDeck(mokey4, tp, SEQ_DECKBOTTOM, REASON_EFFECT)
end

function s.mking_filter(c)
	return c:IsCode(13803864)
end
--also your "Mokey Mokey King"(s) become like, more chill dude...
function s.swap_kings(e,tp,eg,ep,ev,re,r,rp)
local hg=Duel.GetMatchingGroup(s.mking_filter,tp,LOCATION_EXTRA,0,nil)
if #hg>0 then
			for card in aux.Next(hg)do
			Duel.SendtoDeck(card,tp,-2,REASON_EFFECT)
			local newking=Duel.CreateToken(tp,81632126)
			Duel.SendtoDeck(newking,tp,SEQ_DECKTOP,REASON_EFFECT)
	end

end
end

function s.polyfilter(c)
	return c:IsCode(CARD_POLYMERIZATION) and c:IsAbleToHand()
end

function s.destroyfairyfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsFaceup()
end

function s.mokeymokeyfilter(c)
	return c:IsSetCard(0x184) and c:IsFaceup()
end

function s.mmsmackdownfilter(c)
	return c:IsCode(01965724) and c:IsSSetable()
end

function s.mmaddfilter(c)
	return c:IsSetCard(0x184) and c:IsAbleToHand()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 then return end

	local g=Duel.GetMatchingGroup(s.mokeymokeyfilter,tp,LOCATION_MZONE,0,nil)

	--Destroy 1 Fairy monster you control, add 1 "Polymerization" from your Deck to your Hand.
	local c1=Duel.IsExistingMatchingCard(s.destroyfairyfilter,tp,LOCATION_MZONE,0,1,nil)
					and Duel.IsExistingMatchingCard(s.polyfilter,tp,LOCATION_DECK,0,1,nil)
					and #g>0

	--Set 1 "Mokey Mokey Smackdown" from your Deck or GY to your Spell/Trap Zone.
	local c2=Duel.IsExistingMatchingCard(s.mmsmackdownfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
					and Duel.GetLocationCount(tp, LOCATION_SZONE)>0
					and #g>1

	--Monsters your opponent controls loses 500 ATK/DEF for each "Mokey Mokey" monster you control.
	local c3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
					and #g>3
	--Target any number of "Mokey Mokey" monsters that are banished or in your GY, add those targets to your hand,
	--then set 1 "The Revenge of the Normal" from outside the duel to your Spell/Trap Zone. It can be activated this turn.
	local c4=Duel.IsExistingMatchingCard(s.mmaddfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
					and Duel.GetLocationCount(tp, LOCATION_SZONE)>0
					and #g>4
--"Mokey Mokey" monsters you control are unaffected by your opponent's card effects until the end of your opponent's turn.
	local c5=#g>4
--Set 1 "The Law of the Normal" from outside the duel to your Spell/Trap Zone.
	local c6=Duel.GetLocationCount(tp, LOCATION_SZONE)>0
					and #g==6

--Once per turn, you can apply one of the following effects depending on the amount of "Mokey Mokey" monsters you control:
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and (c1 or c2 or c3 or c4 or c5)

	return aux.CanActivateSkill(tp) and (b1)
end

function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	local g=Duel.GetMatchingGroup(s.mokeymokeyfilter,tp,LOCATION_MZONE,0,nil)

	--Destroy 1 Fairy monster you control, add 1 "Polymerization" from your Deck to your Hand.
	local c1=Duel.IsExistingMatchingCard(s.destroyfairyfilter,tp,LOCATION_MZONE,0,1,nil)
					and Duel.IsExistingMatchingCard(s.polyfilter,tp,LOCATION_DECK,0,1,nil)
					and #g>0

	--Set 1 "Mokey Mokey Smackdown" from your Deck or GY to your Spell/Trap Zone.
	local c2=Duel.IsExistingMatchingCard(s.mmsmackdownfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
					and Duel.GetLocationCount(tp, LOCATION_SZONE)>0
					and #g>1

	--Monsters your opponent controls loses 500 ATK/DEF for each "Mokey Mokey" monster you control.
	local c3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
					and #g>2
	--Target any number of "Mokey Mokey" monsters that are banished or in your GY, add those targets to your hand,
	--then set 1 "The Revenge of the Normal" from outside the duel to your Spell/Trap Zone. It can be activated this turn.
	local c4=Duel.IsExistingMatchingCard(s.mmaddfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
					and Duel.GetLocationCount(tp, LOCATION_SZONE)>0
					and #g>3
--"Mokey Mokey" monsters you control are unaffected by your opponent's card effects until the end of your opponent's turn.
	local c5=#g>4
--Set 1 "The Law of the Normal" from outside the duel to your Spell/Trap Zone.
	local c6=Duel.GetLocationCount(tp, LOCATION_SZONE)>0
					and #g==6

--Once per turn, you can apply one of the following effects depending on the amount of "Mokey Mokey" monsters you control:
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and (c1 or c2 or c3 or c4 or c5)

		local op=aux.SelectEffect(tp, {c1,aux.Stringid(id,0)},
									  {c2,aux.Stringid(id,1)},
									{c3,aux.Stringid(id,2)},
									{c4,aux.Stringid(id,3)},
									{c5,aux.Stringid(id,4)},
									{c6,aux.Stringid(id,5)})
		op=op-1

	if op==0 then
	--Destroy 1 Fairy monster you control, add 1 "Polymerization" from your Deck to your Hand.
		local g5=Duel.SelectMatchingCard(tp,s.destroyfairyfilter,tp,LOCATION_MZONE,0,1,1,false,nil):GetFirst()
		if Duel.Destroy(g5, REASON_EFFECT) then
			local pol=Duel.SelectMatchingCard(tp,s.polyfilter,tp,LOCATION_DECK,0,1,1,false,nil):GetFirst()
				if pol then
					Duel.SendtoHand(pol, tp, REASON_EFFECT)
					Duel.ConfirmCards(tp, pol)
				end
		end
	elseif op==1 then
		--Set 1 "Mokey Mokey Smackdown" from your Deck or GY to your Spell/Trap Zone.
		local g4=Duel.SelectMatchingCard(tp,s.mmsmackdownfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,false,nil):GetFirst()
		Duel.SSet(tp, g4)
	elseif op==2 then
		--Monsters your opponent controls loses 500 ATK/DEF for each "Mokey Mokey" monster you control.
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local num=#g
		local tc=g2:GetFirst()
		for tc in aux.Next(g2) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-500*num)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)

			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)

		end
	elseif op==3 then
		--Target any number of "Mokey Mokey" monsters that are banished or in your GY, add those targets to your hand,
		--then set 1 "The Revenge of the Normal" from outside the duel to your Spell/Trap Zone. It can be activated this turn.
		local g3=Duel.SelectMatchingCard(tp,s.mmaddfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,false,nil)
		if Duel.SendtoHand(g3, tp, REASON_EFFECT) then
			local rev=Duel.CreateToken(tp, 17509503)
			Duel.SSet(tp, rev)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rev:RegisterEffect(e2)
		end
	elseif op==4 then
		--"Mokey Mokey" monsters you control are unaffected by your opponent's card effects until the end of your opponent's turn.
			local cards=Duel.GetMatchingGroup(s.mokeymokeyfilter,tp,LOCATION_MZONE,0,0,nil)
			for tc in aux.Next(cards) do
			--Unaffected by opponent's card effects
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(3110)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_IMMUNE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetRange(LOCATION_MZONE)
			e3:SetValue(s.efilter)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			e3:SetOwnerPlayer(tp)
			tc:RegisterEffect(e3)
			end
	elseif op==5 then
		--Set 1 "The Law of the Normal" from outside the duel to your Spell/Trap Zone.
		local law=Duel.CreateToken(tp, 66926224)
		Duel.SSet(tp, law)
	end
	Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
