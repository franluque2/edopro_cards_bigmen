--Hope for the Future
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
        e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
        e2:SetCode(EVENT_DESTROYED)
        e2:SetCondition(s.gycon)
        e2:SetOperation(s.gyop)
		Duel.RegisterEffect(e2,tp)


	end
	e:SetLabel(1)
end

function s.cfilter(c,tp)
	return c:GetPreviousControler()==tp
end
function s.adfilter(c)
    return c:IsSpellTrap() and (c:IsType(TYPE_FIELD) or (c:IsType(TYPE_CONTINUOUS) and Duel.GetLocationCount(c:GetOwner(), LOCATION_SZONE)>0))
end
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and Duel.GetFlagEffect(tp, id)==1 and Duel.IsExistingMatchingCard(s.adfilter, tp, LOCATION_GRAVE|LOCATION_DECK, 0, 1, nil)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
        Duel.Hint(HINT_CARD, tp, id)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
        local toadd=Duel.SelectMatchingCard(tp, s.adfilter, tp, LOCATION_GRAVE|LOCATION_DECK, 0, 1,1,false,nil)
        if toadd then
			local tc=toadd:GetFirst()
			if tc then
				if tc:IsType(TYPE_FIELD) then
					Duel.ActivateFieldSpell(tc,e,tp,eg,ep,ev,re,r,rp)
				else
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				end
			end
        end
        Duel.RegisterFlagEffect(tp,id,0,0,0)
    end
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,0),nil)
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
