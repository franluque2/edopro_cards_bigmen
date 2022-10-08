--Dark Emissary
local s,id=GetID()
function s.initial_effect(c)
	--Activate Skill
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)

end



function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)





	end
	e:SetLabel(1)
end


function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
	Duel.SendtoDeck(e:GetHandler(), tp, -2, REASON_EFFECT)
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp, 1, REASON_EFFECT)
	end

	if Duel.IsExistingMatchingCard(Card.IsCode, tp, LOCATION_DECK, 0, 1,nil, 44330098) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler(),REASON_EFFECT)
	 and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		 Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DISCARD)
		 local discard=Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp, LOCATION_HAND, 0, 1,1,false,nil)
		 if Duel.SendtoGrave(discard, REASON_DISCARD) then
			 local gorz=Duel.GetFirstMatchingCard(Card.IsCode, tp, LOCATION_DECK, 0, nil, 44330098)

			 Duel.SendtoHand(gorz, tp, REASON_EFFECT)

		 end
	 end
end
