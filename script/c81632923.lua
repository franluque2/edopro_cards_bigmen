--Goha Mastermind
local s,id=GetID()
function s.initial_effect(c)
	--skill
		--Activate
	aux.AddSkillProcedure(c,1,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	aux.AddSkillProcedure(c,1,false,s.flipcon2,s.flipop2)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)

		--Disable left and right-most zones
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetOperation(s.disabledzones)
		Duel.RegisterEffect(e2,tp)

		--Draw till you have 5 cards in hand
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DRAW_COUNT)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetValue(s.getcarddraw)
		Duel.RegisterEffect(e3,tp)

		--Give almost infinite normal summons
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,0)
		e4:SetValue(999999999)
		Duel.RegisterEffect(e4,tp)

		--skip MP2

		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(EFFECT_SKIP_M2)
		e5:SetTargetRange(1,0)
		Duel.RegisterEffect(e5,tp)

		--skip SP

		--local e7=Effect.CreateEffect(e:GetHandler())
		--e7:SetType(EFFECT_TYPE_FIELD)
		--e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		--e7:SetCode(EFFECT_SKIP_SP)
		--e7:SetTargetRange(1,0)
		--Duel.RegisterEffect(e7,tp)

		--disable EMZs
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_FORCE_MZONE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetTargetRange(1,0)
		e6:SetValue(s.znval)
		Duel.RegisterEffect(e6,tp)

		--give infinite hand size
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_HAND_LIMIT)
		e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e7:SetTargetRange(1,0)
		e7:SetValue(100)
		Duel.RegisterEffect(e7,tp)
		--At the start of the Duel, Special Summon 1 "Imaginary Actor" from outside the duel.

		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e8:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e8:SetCondition(s.flipcon3)
		e8:SetOperation(s.flipop3)
		e8:SetCountLimit(1)
		Duel.RegisterEffect(e8,tp)


	end
	e:SetLabel(1)
end

function s.flipcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local actor=Duel.CreateToken(tp, 160204006)
	Duel.SpecialSummon(actor,0,tp,tp,false,false,POS_FACEUP)
end


function s.getcarddraw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0) < 5 then
		return 5-Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)
	else
		return 1
end
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.znval(e)
	return ~(0x60)
end


function s.disabledzones(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandlerPlayer()==tp then
			return 0x00001111
	else
			return 0x11110000
	end
end

function s.monsterfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function s.fusionfilter(c)
	return c:IsCode(160204050) and c:IsAbleToHand()
end

function s.exfilter(c,e,tp)
	return c.material and c:IsType(TYPE_FUSION) and Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end

function s.addfilter(c,e,tp,fc)
	return c:IsAbleToHand() and c:IsCode(table.unpack(fc.material))
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 and Duel.GetFlagEffect(tp, id+4)>0 then return end
	--
-- Once per turn, you can send the top 2 cards of your Deck to the GY, then declare 1 type.
--Until the end of this turn, all monsters your opponent controls becomes that type.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
			and Duel.GetMatchingGroupCount(s.monsterfilter, tp, 0, LOCATION_MZONE, nil)>0


-- Once per turn, you can discard 1 card, add 1 "Fusion" from your Deck to your Hand.
local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_DECK,0,1,nil)

		--Once per turn, you send the top card of your Deck to the GY, reveal 1 Fusion monster in your Extra Deck,
		-- add one of the listed Fusion Materials from your GY to your Hand.

		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsPlayerCanDiscardDeckAsCost(tp,1)
			and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)

	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	-- Once per turn, you can send the top 2 cards of your Deck to the GY, then declare 1 type.
	--Until the end of this turn, all monsters your opponent controls becomes that type.
		local b1=Duel.GetFlagEffect(tp,id+2)==0
				and Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
				and Duel.GetMatchingGroupCount(s.monsterfilter, tp, 0, LOCATION_MZONE, nil)>0


	-- Once per turn, you can discard 1 card, add 1 "Fusion" from your Deck to your Hand.
	local b2=Duel.GetFlagEffect(tp, id+3)==0
			and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_EFFECT)
			and Duel.IsExistingMatchingCard(s.fusionfilter,tp,LOCATION_DECK,0,1,nil)

			--Once per turn, you send the top card of your Deck to the GY, reveal 1 Fusion monster in your Extra Deck,
			-- add one of the listed Fusion Materials from your GY to your Hand.

			local b3=Duel.GetFlagEffect(tp, id+4)==0
				and Duel.IsPlayerCanDiscardDeckAsCost(tp,1)
				and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)

		local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,1)},
											{b3,aux.Stringid(id, 2)})
		op=op-1

	if op==0 then
		Duel.DiscardDeck(tp,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
		local rc=Duel.AnnounceRace(tp,1,RACE_ALL)

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetValue(rc)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
		if Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.fusionfilter,tp,LOCATION_DECK,0,1,1,nil)
			if #g>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
	end
			Duel.RegisterFlagEffect(tp, id+3, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
	elseif op==2 then
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local cg=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #cg==0 then return end
		Duel.ConfirmCards(1-tp,cg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.addfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,cg:GetFirst())
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		Duel.RegisterFlagEffect(tp, id+4, 0, 0, 0)
	end
end
