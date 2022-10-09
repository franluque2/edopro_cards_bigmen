--Digging For Treasure!
Duel.LoadScript ("big_aux.lua")

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


		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CUSTOM+81632500)
		e2:SetCondition(s.sscon)
		e2:SetOperation(s.ssef)
		Duel.RegisterEffect(e2, tp)


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
end


function s.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp, LOCATION_DECK,0)>0 and rp==tp
end
function s.ssef(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	local g=Duel.GetDecktopGroup(tp, 5)

	Duel.ConfirmDecktop(tp, 5)

	local cards=g:Filter(Card.IsTreasure, nil)
	if #cards>0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
		local tc=cards:Select(tp,1,1,nil)
		if #tc>0 then
			Duel.SendtoHand(tc, tp, REASON_EFFECT)
		end
	end

	Duel.ShuffleDeck(tp)


end
