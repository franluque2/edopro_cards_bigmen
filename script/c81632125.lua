--Eye Contact (CT)
local s,id=GetID()
function s.initial_effect(c)
	-- add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
s.listed_names={810000058, 450000110}
function s.tgfilter(c)
	return c:IsCode(810000058) and (c:IsAbleToHand() or c:IsSSetable()) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end

function s.tgfilter2(c)
	return aux.IsCodeListed(c, 450000110) and (c:IsAbleToHand() or c:IsSSetable()) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not c:IsCode(81000061)
end

function s.staddreamsfilter(c)
	return c:IsCode(450000110) and c:IsFaceup()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:GetControler()==tp and s.tgfilter(chkc) end
	if chk==0 then return (Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE,0,1,nil) or (Duel.IsExistingTarget(s.tgfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.staddreamsfilter, tp, LOCATION_ONFIELD, 0, 1, nil))) end

	local b1=Duel.IsExistingMatchingCard(s.tgfilter, tp, LOCATION_GRAVE, 0, 1, nil)
	local b2=Duel.IsExistingMatchingCard(s.tgfilter2, tp, LOCATION_GRAVE, 0, 1, nil) and Duel.IsExistingMatchingCard(s.staddreamsfilter, tp, LOCATION_ONFIELD, 0, 1, nil)

	local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,2)},
									{b2,aux.Stringid(id,0)})
	op=op-1

	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectTarget(tp,s.tgfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
			if not tc:IsCode(810000058) then
				if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) and (Duel.GetLocationCount(tp, LOCATION_SZONE)>0) then
					Duel.SSet(tp, tc)
					if tc:IsType(TYPE_QUICKPLAY) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					elseif tc:IsType(TYPE_TRAP) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
						e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						tc:RegisterEffect(e1)
					end
				else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
				end
			else
				Duel.SSet(tp, tc)
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				elseif tc:IsType(TYPE_TRAP) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
	end
end
