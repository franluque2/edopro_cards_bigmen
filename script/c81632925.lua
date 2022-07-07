--Aria Angel - Angelic Draw
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


	end
	e:SetLabel(1)
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

function s.spelltrapfilter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToDeck()
end


function s.setfilter(c)
	return c:IsSSetable() and c:IsCode(160202024)
end

function s.cleanmenfilter(c)
	return (c:IsCode(160202021) or c:IsCode(160202022) or c:IsCode(160202023)) and c:IsAbleToDeck()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 then return end
	--
-- Once per turn, you can shuffle 1 Spell/Trap from your Hand into your Deck,
--then set 1 "Bleach Mortar" from from your Deck to your Field.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.spelltrapfilter, tp, LOCATION_HAND, 0, 1, nil)
			and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil)
			and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


-- Once per turn, during your Main Phase, you can place up to 1 each of "Clean Beret - Colonel Mop",
-- "Scrubbing Santa Cloth", and "Washsprayer the Cleansketeer" from your GY on top of your Deck in any order.
local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.cleanmenfilter,tp,LOCATION_GRAVE,0,1,nil)


	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	-- Once per turn, you can shuffle 1 Spell/Trap from your Hand into your Deck,
	--then set 1 "Bleach Mortar" from from your Deck to your Field.
		local b1=Duel.GetFlagEffect(tp,id+2)==0
				and Duel.IsExistingMatchingCard(s.spelltrapfilter, tp, LOCATION_HAND, 0, 1, nil)
				and Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil)
				and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

	-- Once per turn, during your Main Phase, you can place up to 1 each of "Clean Beret - Colonel Mop",
	-- "Scrubbing Santa Cloth", and "Washsprayer the Cleansketeer" from your GY on top of your Deck in any order.
	local b2=Duel.GetFlagEffect(tp, id+3)==0
			and Duel.IsExistingMatchingCard(s.cleanmenfilter,tp,LOCATION_GRAVE,0,1,nil)


		local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,1)})
		op=op-1

	if op==0 then
			local st=Duel.SelectMatchingCard(tp, s.spelltrapfilter, tp, LOCATION_HAND, 0, 1, 1, false, nil)
			Duel.ConfirmCards(1-tp, st)
			if Duel.SendtoDeck(st, tp, SEQ_DECKSHUFFLE, REASON_EFFECT) then
				local g=Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, false, nil)
				Duel.SSet(tp, g, tp, true)
			end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then
			local tg=Duel.GetMatchingGroup(s.cleanmenfilter,tp,LOCATION_GRAVE,0,nil)
			local g=aux.SelectUnselectGroup(tg,e,tp,1,3,aux.dncheck,1,tp,HINTMSG_TODECK)
			Duel.SendtoDeck(g, tp, SEQ_DECKTOP, REASON_EFFECT)
			Duel.SortDecktop(tp,tp,#g)
			Duel.ConfirmCards(1-tp, g)
			Duel.RegisterFlagEffect(tp, id+3, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
	end
end
