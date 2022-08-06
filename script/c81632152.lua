--Tricolor Illusion (CT)
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	c:SetUniqueOnField(1,0,511000954)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+TIMING_BATTLE_START)
	e1:SetCondition(s.actcon)
	e1:SetTarget(s.target)
	c:RegisterEffect(e1)
	--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e2)

	--reveal
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCondition(s.revcon)
	e4:SetCost(s.revcost)
	e4:SetOperation(s.revop)
	c:RegisterEffect(e4)

	--Destroy itself
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(s.descon)
	e6:SetTarget(s.destg)
	e6:SetOperation(s.desop)
	c:RegisterEffect(e6)
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) end
	local c=e:GetHandler()
	c:SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(s.descon2)
	e1:SetOperation(s.desop2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	c:RegisterEffect(e1)
end

function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		if re then re:Reset() end
	end
end

function s.has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end


local unicorns={77506119,13995824,49389523}
function s.flipconfilter(c)
	return c:IsFaceup() and s.has_value(unicorns,c:GetCode())
end

function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil)
end


function s.revcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1
end
function s.revcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END,0,0)
end
function s.revop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.DisableShuffleCheck()
	Duel.ConfirmDecktop(1-tp,1)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_SPELL) then
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,tc)
			Duel.BreakEffect()
			Duel.ShuffleHand(1-tp)

			local g=Duel.GetMatchingGroup(s.flipconfilter, tp, LOCATION_MZONE, 0, nil)
			if #g>0 then
				for sc in g:Iter() do
					--Increase ATK
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					e1:SetValue(2000)
					sc:RegisterEffect(e1)
				end
			end

		end
	elseif tc:IsType(TYPE_TRAP) then
		Duel.DiscardDeck(1-tp,1,REASON_EFFECT+REASON_REVEAL+REASON_DISCARD)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DISCARD)
		local sg=g:Select(1-tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)

		local g2=Duel.GetMatchingGroup(s.flipconfilter, tp, LOCATION_MZONE, 0, nil)
		if #g2>0 then
				Duel.BreakEffect()

				local sc=g2:Select(tp,1,1,nil)
				--Increase ATK
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				e1:SetValue(1000)
				sc:RegisterEffect(e1)
		end
	else
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(tp,tc)
			local hg=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,1,1,tc)
			Duel.SendtoDeck(hg,nil,0,REASON_EFFECT)
			Duel.BreakEffect()
			Duel.ShuffleHand(1-tp)

			local g=Duel.GetMatchingGroup(s.flipconfilter, tp, LOCATION_MZONE, 0, nil)
			if #g>0 then
				for sc in g:Iter() do
					--Make indestructible
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(3001)
					e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
					e1:SetValue(1)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					sc:RegisterEffect(e1)
				end
			end


		end
	end
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
