--Kartumata
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

	end
	e:SetLabel(1)
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



function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPD check
	if Duel.GetFlagEffect(tp,id)>1  then return end

	return aux.CanActivateSkill(tp) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<5 and Duel.IsPlayerCanDraw(tp,1) and not (Duel.GetCurrentPhase()==PHASE_MAIN2)
end

function s.sumfilter(c,e,tp)
    return c:IsLevelAbove(5) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SPECIAL, tp, false,false,POS_FACEUP)
end


function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
        
	Duel.Hint(HINT_CARD,tp,id)

    local drawnum=5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
    Duel.Draw(tp, drawnum, REASON_RULE)

    local g=Duel.GetMatchingGroup(s.sumfilter, tp, LOCATION_HAND, 0, nil, e,tp)
    if #g>0 and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
        local g2=g:Select(tp, 1,3,nil)
        if g2 then
            Duel.SpecialSummon(g2, SUMMON_TYPE_SPECIAL, tp, tp, false,false, POS_FACEUP)
            for tc in g2:Iter() do
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_SET_BASE_ATTACK)
                e1:SetValue(1000)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                tc:RegisterEffect(e1)
            end
        end
    end



	Duel.RegisterFlagEffect(tp, id, 0, 0, 0)

    end
end
