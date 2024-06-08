--The Millennium Ring
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
		e2:SetCode(EVENT_PREDRAW)
		e2:SetCondition(s.flipcon2)
		e2:SetOperation(s.flipop2)
        e2:SetCountLimit(1)
		Duel.RegisterEffect(e2,tp)

	end
	e:SetLabel(1)
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()>1 and Duel.GetFlagEffect(tp, id-500)==0 and Duel.GetDrawCount(tp)>0 and Duel.GetTurnPlayer()==tp
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)


    if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
		if Duel.GetFlagEffect(1-tp, 81633193)>0 then
			Duel.Hint(HINT_CARD,tp,81633193)
			return
		end
        Duel.Hint(HINT_CARD,tp,id)
		Duel.RegisterFlagEffect(tp,id-500,0,0,0)
	
        local dt=Duel.GetDrawCount(tp)
        if dt~=0 then
            _replace_count=0
            _replace_max=dt
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e1:SetCode(EFFECT_DRAW_COUNT)
            e1:SetTargetRange(1,0)
            e1:SetReset(RESET_PHASE+PHASE_DRAW)
            e1:SetValue(0)
            Duel.RegisterEffect(e1,tp)
        end
        
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATOHAND)
        local card=Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_DECK, 0, 1, 1, false, nil)
        Duel.SendtoHand(card, tp, REASON_RULE)
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


