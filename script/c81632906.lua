--Chosen by the Legendary Planet
local s,id=GetID()
function s.initial_effect(c)
		aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
		aux.AddSkillProcedure(c,1,false,s.flipcon2,s.flipop2)
end
local planets={24413299,74711057,88071625,15033525,34004470,51402908,03912064,05645210,16255173,32588805}
function s.flipconfilter(c)
	return c:IsFaceup() and s.has_value(planets,c:GetOriginalCode()) 
end

function s.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToGrave()
end

function s.planetfilter(c)
return s.has_value(planets,c:GetOriginalCode()) and Duel.IsExistingMatchingCard(s.thfilter,c:GetOwner(),LOCATION_DECK+LOCATION_EXTRA,0,1,c,c:GetOriginalCode()) 
end

function s.has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end


function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--"cost" check
	if not (Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_ONFIELD,0,1,nil)) then return false end
	--condition
	return aux.CanActivateSkill(tp) and Duel.GetFlagEffect(tp,id)==0
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id,0,0,0)

end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(tp,id)==0 then return end
	if Duel.GetFlagEffect(tp,id+1)>0 and Duel.GetFlagEffect(tp,id+2)>0 then return end
	--condition
	local b1=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(tp,id+2)==0 and Duel.IsExistingMatchingCard(s.planetfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	
	return aux.CanActivateSkill(tp) and (b1 or b2)
end

function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

function s.idfilter(c,code)
	return c:GetOriginalCode()==code
end

function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler(e)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,HINT_SELECTMSG)
	local b1=Duel.GetFlagEffect(ep,id+1)==0 and Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(ep,id+2)==0 and Duel.IsExistingMatchingCard(s.planetfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	if (b2 and b1) then
		p=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		p=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		p=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	if p==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,s.flipconfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local cards=Duel.GetMatchingGroup(s.idfilter,tp,LOCATION_MZONE,0,0,g:GetOriginalCode())
	if g then
		for tc in aux.Next(cards) do
		--Unaffected by opponent's card effects
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(3110)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(s.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e3:SetOwnerPlayer(tp)
		tc:RegisterEffect(e3)
		end
	end
		--opd register
		Duel.RegisterFlagEffect(tp,id+1,0,0,0)
	else
		local tc=Duel.SelectMatchingCard(tp,s.planetfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,tc:GetOriginalCode())
		if #sg>0 then
			if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
		end
		--opt register
		Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)

	end
end
