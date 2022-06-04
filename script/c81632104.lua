--Absorbing Lamp
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
	--enable placing rub counters
	c:EnableCounterPermit(0x8654)
	c:SetCounterLimit(0x8654,3)
	--place 1 rub counter on flip of a lamp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCondition(s.spcon)
	e3:SetOperation(s.ctop)
	c:RegisterEffect(e3)	

	--remove 3 counters to summon a fusion
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e2:SetCountLimit(1,{id,1})
	e2:SetCost(s.descost)
	e2:SetTarget(s.etar)
	e2:SetOperation(s.ecop)
	c:RegisterEffect(e2)


	--steal card
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,{id,2})
	e4:SetLabelObject(nil)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.target)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)

	--shuffle and draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,{id,3})
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(s.drtg)
	e5:SetOperation(s.drop)
	c:RegisterEffect(e5)
	

end

s.counter_place_list={0x8654}

function s.cfilter(c,tp)
	return c:IsSetCard(0x8654) and c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown() and c:IsControler(tp)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x8654,1)
	end
end

function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x8654,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x8654,3,REASON_COST)
end


function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=re:GetHandler()
	if chk==0 then return ec:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(ec)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if ec:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
	end
	e:SetLabelObject(nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.NegateActivation(ev)
	if tc and tc:IsRelateToEffect(e) and tc:IsRelateToEffect(re) then
		tc:CancelToGrave()
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		c:SetCardTarget(tc)
		e:SetLabelObject(tc)
	end
end

function s.filter5(c)
	return (c:IsSetCard(0x8654) or c:IsCode(97590747) or c:IsCode(99510761)) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter5(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(s.filter5,tp,LOCATION_GRAVE,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.filter5,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function s.filterfu(c,e,tp)
	return c:IsType(TYPE_FUSION) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and (c:IsSetCard(0x8654) or 
		c:IsCode(0x19066538) or c:IsCode(0x72869010) or c:IsCode(0x81997228))
end

function s.etar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filterfu,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.ecop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filterfu,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
end
end

