--Cosmic Space (CT)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--remove counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(s.target)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	--add counter on summoned
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_FLIP)
	c:RegisterEffect(e5)
	local e9=e3:Clone()
	e9:SetCode(EVENT_MOVE)
	e9:SetCondition(s.movcon)
	c:RegisterEffect(e9)

	--replace counters
	-- local e6=Effect.CreateEffect(c)
	-- e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	-- e6:SetRange(LOCATION_FZONE)
	-- e6:SetCountLimit(1)
	-- e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	-- e6:SetOperation(s.activate)
	-- c:RegisterEffect(e6)

	--protect quasar

	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetTarget(s.reptg)
	e7:SetValue(s.repval)
	c:RegisterEffect(e7)

	--remove 7 counters from field, ss quasar
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1,id)
	e8:SetCost(s.spcost)
	e8:SetTarget(s.sptg)
	e8:SetOperation(s.spop)
	c:RegisterEffect(e8)

end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
		Duel.SetChainLimit(aux.FALSE)
end


function s.efilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) and
		 not (c:IsReason(REASON_SPSUMMON) or c:IsReason(REASON_SUMMON) or c:IsReason(REASON_FLIP) or c:IsPreviousLocation(LOCATION_DECK)
	 or c:IsPreviousLocation(LOCATION_HAND) or c:IsPreviousLocation(LOCATION_EXTRA) or c:IsPreviousLocation(LOCATION_GRAVE))
end

function s.movcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.efilter,1,nil)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1109,7,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1109,7,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsCode(50263751) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then

		return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:GetCounter(0x1109)>2 and c:IsCode(50263751)
		and not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) end
	Duel.Hint(HINT_CARD,1-tp,id)
	local g=eg:Filter(s.repfilter,nil,tp)
	for tc in aux.Next(g) do
		tc:RemoveCounter(tp,0x1109,3,REASON_EFFECT)
	end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function s.repval(e,c)
	return e:GetLabelObject():IsContains(c)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetCounter(0x1109)==0 then
			tc:AddCounter(0x1109,(tc:GetLevel()+tc:GetRank()+tc:GetLink()),REASON_EFFECT)
		end
		tc=g:GetNext()
	end
end
function s.desfilter(c,tc)
	return c==tc and c:IsFaceup() and not c:IsDisabled()
end
function s.descon(e)
	if e:GetHandler():GetCounter(0x1109)>0 then return false end
	return Duel.IsExistingMatchingCard(s.desfilter,0,LOCATION_FZONE,LOCATION_FZONE,1,nil,e:GetLabelObject())
end
function s.rmcfilter(c)
	return c:GetCounter(0x1109)~=0
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		if tc:GetCounter(0x1109)>0 then
			tc:RemoveCounter(tp,0x1109,1,REASON_EFFECT)
		end
		if tc:GetCounter(0x1109)==0 then
			Duel.NegateRelatedChain(tc,RESET_TURN_SET)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)
			end
			Duel.Destroy(tc, REASON_EFFECT)
		end

		tc=g:GetNext()
	end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsFaceup,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1109,(tc:GetLevel()+tc:GetRank()+tc:GetLink()),REASON_EFFECT)
		tc=g:GetNext()
	end
end
