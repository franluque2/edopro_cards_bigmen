--Offside Trap (CT)
local s,id=GetID()
function s.initial_effect(c)
--battle effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)

	--effect destruction effect

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)

end

s.listed_names={450000110}

function s.fieldfilter(c)
	return c:IsFaceup() and c:IsCode(450000110)
end


function s.cfilter(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and Duel.IsExistingMatchingCard(s.fieldfilter, tp, LOCATION_FZONE, 0, 1,nil)
end
function s.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			local ct=eg:FilterCount(s.spfilter,nil,e,tp)
			return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(s.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local sg=eg:Filter(s.spfilter2,nil,e,tp)
	if ft<#sg then return end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	local a=Duel.GetAttacker()
	local tc=a:GetBattleTarget()
	if tc and tc:IsControler(1-tp) then a,tc=tc,a end
	local dam=Duel.GetBattleDamage(tp)
	if not tc or dam<=0 then return 1 end
	if Duel.Recover(tp, dam, REASON_EFFECT) then
		if Duel.GetTurnPlayer()==(1-tp) then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	else
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
	end
end



function s.cfilter2(c,tp)
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(s.cfilter2,1,nil,tp) and Duel.IsExistingMatchingCard(s.fieldfilter, tp, LOCATION_FZONE, 0, 1,nil)
end

function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(s.spfilter,nil,e,tp)
		return ct>0 and (ct==1 or not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT))
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(s.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,0,0)
end
function s.spfilter2(c,e,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local sg=eg:Filter(s.spfilter2,nil,e,tp)
	if ft<#sg then return end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end

end
