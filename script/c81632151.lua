--Scrap Storage (CT)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)


	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	e2:SetCountLimit(1,id)
	c:RegisterEffect(e2)
end
function s.filter(c,code)
	return c:IsCode(code) and (c:IsAbleToGrave() or c:IsAbleToHand())
end
function s.tgfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end


function s.filter2(c,code)
	return c:IsCode(code) and c:IsAbleToGrave()
end

function s.tgfilter2(c,tp)
	return c:IsFaceup() and (c:IsCode(511002301) or c:IsCode(511002302))
		and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c:GetCode())
end

function s.filterprotop(c)
	return c:IsCode(511002306) and c:IsSSetable()
end

function s.indesarmorfilter(c)
	return c:IsCode(511002304) and c:IsSSetable()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetFirst():IsAbleToGrave() and Duel.SelectYesNo(tp, aux.Stringid(id, 4)) then
			Duel.SendtoGrave(g,REASON_EFFECT)
		else
			Duel.SendtoHand(g, tp, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, g)
		end

		if Duel.IsExistingMatchingCard(s.filterprotop, tp, LOCATION_DECK, 0, 1,nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.BreakEffect()
			local g2=Duel.SelectMatchingCard(tp, s.filterprotop, tp, LOCATION_DECK, 0, 1 , 1, false, nil)
			Duel.SSet(tp, g2)
		end
	end
end




function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter2(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter2,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc, REASON_EFFECT) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,0,99,false,nil,511002301)
		if #g>0 then
			Duel.BreakEffect()
			Duel.SendtoGrave(g,REASON_EFFECT)


		if Duel.IsExistingMatchingCard(s.indesarmorfilter, tp, LOCATION_DECK, 0, 1,nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 3)) then
			Duel.BreakEffect()
			local g2=Duel.SelectMatchingCard(tp, s.indesarmorfilter, tp, LOCATION_DECK, 0, 1 , 1, false, nil)
			Duel.SSet(tp, g2)
		end
	end
end
end
