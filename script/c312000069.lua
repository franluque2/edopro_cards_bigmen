--Decoy Baby (CT)
local s,id=GetID()
function s.initial_effect(c)
	--Place 1 monsters in the S/T zone and place 1 Prey Counter on it
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter1(c,tp)
	return c:IsFaceup() and c:GetCounter(0x1107)~=0 and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil,c:GetRace())
end
function s.filter2(c,rc)
	return c:IsFaceup() and c:IsRace(rc)
end
function s.target(e,tp,eg,ev,ep,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and s.filter1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_SZONE,0,1,nil,tp)
		and ((Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_SZONE,0,1,1,nil,tp)
end
function s.activate(e,tp,eg,ev,ep,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,0,LOCATION_MZONE,1,1,nil,tc:GetRace())
		local tc2=g:GetFirst()
		if tc2 and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0) and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
            Duel.MoveToField(tc2,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			--Treated as a Continuous Spell
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT|(RESETS_STANDARD&~RESET_TURN_SET))
			tc2:RegisterEffect(e1)
            tc2:AddCounter(0x1107,1)
        else
            Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			--Treated as a Continuous Spell
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetValue(TYPE_SPELL|TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT|(RESETS_STANDARD&~RESET_TURN_SET))
			tc2:RegisterEffect(e1)
            tc2:AddCounter(0x1107,1)
        end
	end
end
