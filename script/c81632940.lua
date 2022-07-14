--Providence's Throne
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
		--Once per turn during your End Phase, if you control 3 Attack Position
		--DARK monsters whose original ATK is 0, you can set 1 Trap Card from your Deck.

		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e8:SetCode(EVENT_PHASE+PHASE_END)
		e8:SetCondition(s.flipcon3)
		e8:SetOperation(s.flipop3)
		e8:SetCountLimit(1)
		Duel.RegisterEffect(e8,tp)


	end
	e:SetLabel(1)
end

function s.fuatkfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and (c:Attack()==0) and c:IsPosition(POS_FACEUP_ATTACK)
end

function s.trapfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end

function s.flipcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.IsExistingMatchingCard(s.fuatkfilter, tp, LOCATION_MZONE, 0, 3, nil)
	and (Duel.GetLocationCount(tp, LOCATION_SZONE)>0)
	and Duel.IsExistingMatchingCard(s.trapfilter, tp, LOCATION_DECK, 0, 1, nil)
	and Duel.GetTurnPlayer()==tp

end
function s.flipop3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		Duel.Hint(HINT_MESSAGE, tp, HINTMSG_SET)
		local trap=Duel.SelectMatchingCard(tp, s.trapfilter, tp, LOCATION_DECK, 0, 1, 1,false, nil)
		if trap then
			Duel.SSet(tp, trap)
		end
	end
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

function s.filter(c)
	return c:IsFaceup()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 then return end
	--
-- Once per turn, you can send the top card of your Deck to the GY,
--switch the original ATK and DEF of all monsters you control until the end of this turn.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsPlayerCanDiscardDeckAsCost(tp,1)
			and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)


-- Once per Duel, if you have 1000 or less LP and you have 10 or less cards left in your Deck, you can add
-- 1 "Yggdrago the Sky Emperor [L]", "Yggdrago the Sky Emperor" and "Yggdrago the Sky Emperor [R]" to your Hand
-- from outside the Duel.
local b2=Duel.GetFlagEffect(tp, id+3)==0
		and (Duel.GetLP(tp)<=1000)
		and (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=10)


	return aux.CanActivateSkill(tp) and (b1 or b2)
end



function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	-- Once per turn, you can send the top card of your Deck to the GY,
	--switch the original ATK and DEF of all monsters you control until the end of this turn.
		local b1=Duel.GetFlagEffect(tp,id+2)==0
				and Duel.IsPlayerCanDiscardDeckAsCost(tp,1)
				and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)


	-- Once per Duel, if you have 1000 or less LP and you have 10 or less cards left in your Deck, you can add
	-- 1 "Yggdrago the Sky Emperor [L]", "Yggdrago the Sky Emperor" and "Yggdrago the Sky Emperor [R]" to your Hand
	-- from outside the Duel.
	local b2=Duel.GetFlagEffect(tp, id+3)==0
			and (Duel.GetLP(tp)<=1000)
			and (Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=10)


		local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,2)})
		op=op-1

	if op==0 then
		Duel.DiscardDeck(tp,1,REASON_EFFECT)

			local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
			local c=e:GetHandler()
			local tc=sg:GetFirst()
			for tc in aux.Next(sg) do
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SWAP_BASE_AD)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
			end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then

			local ygg1=Duel.CreateToken(tp, 160202011)
			local ygg2=Duel.CreateToken(tp, 160202010)
			local ygg3=Duel.CreateToken(tp, 160202012)

			Duel.SendtoHand(ygg1, tp, REASON_EFFECT)
			Duel.SendtoHand(ygg2, tp, REASON_EFFECT)
			Duel.SendtoHand(ygg3, tp, REASON_EFFECT)

			Duel.RegisterFlagEffect(tp, id+3, 0, 0, 0)
	end
end
