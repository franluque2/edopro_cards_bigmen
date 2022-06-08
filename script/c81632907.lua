--Machine King Evolution
local s,id=GetID()
function s.initial_effect(c)
	--skill
		--Activate
	aux.AddSkillProcedure(c,2,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	aux.AddSkillProcedure(c,1,false,s.flipcon2(Fusion.SummonEffTG()),s.flipop2(Fusion.SummonEffOP))
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
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.summon_king(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,id,0,0,0)
end

function s.summon_king(e,tp,eg,ep,ev,re,r,rp)
	local king=Duel.CreateToken(tp,89222931)
			local e1=Effect.CreateEffect(king)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetValue(TYPE_TOKEN)
			king:RegisterEffect(e1,true)
			Duel.SpecialSummon(king,0,tp,tp,false,false,POS_FACEUP)
end


function s.king_proto_filter(c)
return c:IsOriginalCode(89222931)
end

function s.king_filter(c)
return c:IsOriginalCode(46700124)
end

function s.king_filter_summon(c)
return c:IsOriginalCode(46700124)
end

function s.perfect_king_filter_anime(c)
return c:IsOriginalCode(511001057)
end

function s.perfect_king_filter_anime_summon(c)
return c:IsOriginalCode(511001057)
end

function s.perfect_king_filter_tcg(c)
return c:IsOriginalCode(18891691)
end

function s.robotic_knight(c)
return c:IsOriginalCode(44203504) or c:IsCode(EFFECT_FUSION_SUBSTITUTE)
end

function s.flipcon2(fustg)
	return function(e,tp,eg,ep,ev,re,r,rp)
	--opt check
	if Duel.GetFlagEffect(ep,id+1)>0 and Duel.GetFlagEffect(ep,id+2)>0 and Duel.GetFlagEffect(ep,id+3)>0 then return end
	--condition
	local params = {aux.FilterBoolFunction(Card.IsCode,511001057),Fusion.OnFieldMat(Card.IsAbleToRemove),s.fextra,Fusion.BanishMaterial}
	local b1=Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.king_proto_filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.king_filter_summon,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(ep,id+2)==0 and Duel.IsExistingMatchingCard(s.king_filter,tp,LOCATION_MZONE,0,1,nil,tp) 
and Duel.IsExistingMatchingCard(s.perfect_king_filter_anime_summon,tp,LOCATION_EXTRA,0,1,nil,tp)
 and Duel.IsExistingMatchingCard(s.king_filter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.robotic_knight,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp)
	local b3=Duel.GetFlagEffect(ep,id+3)==0 and Duel.IsExistingMatchingCard(s.king_proto_filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.king_filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.perfect_king_filter_anime,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tp)

return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
end

function s.flipop2(fusop)
	return function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,HINT_SELECTMSG)
	local params = {aux.FilterBoolFunction(Card.IsCode,511001057),Fusion.OnFieldMat(Card.IsAbleToRemove),s.fextra,Fusion.BanishMaterial}
	local b1=Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(king_proto_filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(king_filter_summon,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(ep,id+2)==0 and Duel.IsExistingMatchingCard(s.king_filter,tp,LOCATION_MZONE,0,1,nil,tp) 
and Duel.IsExistingMatchingCard(s.perfect_king_filter_anime_summon,tp,LOCATION_EXTRA,0,1,nil,tp)
 and Duel.IsExistingMatchingCard(s.king_filter,tp,LOCATION_ONFIELD+LOCATION_REMOVED,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.robotic_knight,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,tp)
	local b3=Duel.GetFlagEffect(ep,id+3)==0 and Duel.IsExistingMatchingCard(king_proto_filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tp) and Duel.IsExistingMatchingCard(king_filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tp) and Duel.IsExistingMatchingCard(perfect_king_filter_anime,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,tp)

	if (b2 and b1 and b3) then
		p=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1),aux.Stringid(id,2))
	elseif (b1 and b3) then
		p=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,2))
		if p==2 then p=p+1 end
	elseif (b2 and b3) then
		p=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))+1
	elseif(b1 and b2) then
		p=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		p=Duel.SelectOption(tp,aux.Stringid(id,0))
	elseif b2 then
		p=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	else
		p=Duel.SelectOption(tp,aux.Stringid(id,2))+2
	end
	if p==0 then
		--tribute 1 machine king prototype, summon a machine king from h/d/gy
		local g=Duel.GetMatchingGroup(s.king_proto_filter,tp,LOCATION_MZONE,0,nil)
			local tc=g:FilterSelect(tp,Card.IsReleasable,1,1,nil):GetFirst()
			if Duel.Release(tc,REASON_COST)>0 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g1=Duel.SelectMatchingCard(tp,s.king_filter_summon,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
				if g1 then
					Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		Duel.RegisterFlagEffect(ep,id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		
	elseif p==1 then
		--tribute 1 machine king, fusion summon anime perfect machine king from extra by banishing monsters from field/grave
		local g=Duel.GetMatchingGroup(s.king_filter,tp,LOCATION_MZONE,0,nil)
		local tc=g:FilterSelect(tp,Card.IsReleasable,1,1,nil):GetFirst()
			if Duel.Release(tc,REASON_COST)>0 then
				Duel.BreakEffect()
				fusop(e,tp,eg,ep,ev,re,r,rp,aux.FilterBoolFunction(Card.IsCode,511001057),Fusion.OnFieldMat(Card.IsAbleToRemove),s.fextra,Fusion.BanishMaterial)
			end
		Duel.RegisterFlagEffect(ep,id+2,0,0,0)
	elseif p==2 then
		--if machine king prototype, machine king and perfect machine king are all in the gy or banished, summon tcg perfect machine from outside the duel, then turn the field into machines for 1 turn
		local perfectking=Duel.CreateToken(tp,18891691)
			local e1=Effect.CreateEffect(perfectking)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetValue(TYPE_TOKEN)
			perfectking:RegisterEffect(e1,true)
			Duel.SpecialSummon(perfectking,0,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CHANGE_RACE)
				e1:SetValue(RACE_MACHINE)
				e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
				Duel.RegisterFlagEffect(ep,id+3,0,0,0)
	end
		--opt register
		

	end
end
function s.fextra(e,tp,mg)
	if not Duel.IsPlayerAffectedByEffect(tp,69832741) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,0,nil)
	end
	return nil
end
