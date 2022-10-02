--Capture Snare (CT)
local s,id=GetID()
function s.initial_effect(c)
	--atk stop
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
s.listed_names={511004336}
function s.filter(c)
	return c:GetCounter(0x1107)>0
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function s.backrowfilter(c)
	return (c:IsCode(511004336) or c:IsCode(511004328)) and c:IsSSetable()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetAttacker()
	if (Duel.NegateAttack() and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)) then
		if (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
		and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
			Duel.MoveToField(g,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			g:AddCounter(0x1107,1)
		else
			Duel.MoveToField(g,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			g:AddCounter(0x1107,1)
		end
		if Duel.IsExistingMatchingCard(s.backrowfilter, tp, LOCATION_DECK, 0, 1, nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 1)) then
			local tc=Duel.SelectMatchingCard(tp, s.backrowfilter, tp, LOCATION_DECK, 0, 1,1,false,nil)
			if tc then
				Duel.SSet(tp, tc)
			end
		end
	end

end
