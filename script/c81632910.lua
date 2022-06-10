--Team Unicorn! Full Lap!
local s,id=GetID()
function s.initial_effect(c)
		aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
		aux.AddSkillProcedure(c,1,false,s.flipcon2,s.flipop2)
end
local unicorns={77506119,13995824,49389523}
function s.flipconfilter(c)
	return c:IsFaceup() and s.has_value(unicorns,c:GetOriginalCode()) 
end

function s.summfilter(c)
	return c:IsType(TYPE_TUNER)
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

function s.unicornfilter(c)
	return c:IsCode(77506119)
end

function s.bicornfilter(c)
	return c:IsCode(13995824) 
end

function s.tricornfilter(c)
	return c:IsCode(49389523)
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(tp,id)==0 then return end
	if Duel.GetFlagEffect(tp,id+1)>0 and Duel.GetFlagEffect(tp,id+2)>0 then return end
	--condition
	local b1=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(tp,id+2)==0 and Duel.IsExistingMatchingCard(s.unicornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp)
	and Duel.IsExistingMatchingCard(s.bicornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.tricornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
	
	return aux.CanActivateSkill(tp) and (b1 or b2)
end

function s.trap_filter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable()
end

function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler(e)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,HINT_SELECTMSG)
	local b1=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil,tp)
	local b2=Duel.GetFlagEffect(tp,id+2)==0 and Duel.IsExistingMatchingCard(s.unicornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp)
	and Duel.IsExistingMatchingCard(s.bicornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.IsExistingMatchingCard(s.tricornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>2
   if (b2 and b1) then
		p=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		p=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		p=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	if p==0 then
		--opt register
		Duel.RegisterFlagEffect(tp,id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		
		h1=Duel.IsExistingMatchingCard(s.summfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
		h2=Duel.IsExistingMatchingCard(s.trap_filter,tp,LOCATION_DECK,0,1,nil,tp)
		local m=aux.SelectEffect(tp, {h1,aux.Stringid(id,2)},
								  {h2,aux.Stringid(id,3)})
		m=m-1
		if m==0 then
		local tc=Duel.SelectMatchingCard(tp,s.summfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LVRANK)
		local lv=Duel.AnnounceLevel(tp,1,2)
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
		end
		else
			local g=Duel.SelectMatchingCard(tp,s.trap_filter,tp,LOCATION_DECK,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				Duel.SSet(tp,tc)
			end
		end
	   
		
	else
		--opd register
		Duel.RegisterFlagEffect(tp,id+2,0,0,0)


		local tc=Duel.SelectMatchingCard(tp,s.unicornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		local tc2=Duel.SelectMatchingCard(tp,s.bicornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		local tc3=Duel.SelectMatchingCard(tp,s.tricornfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummon(tc2,0,tp,tp,true,false,POS_FACEUP)
		Duel.SpecialSummon(tc3,0,tp,tp,true,false,POS_FACEUP)
		horn1=Duel.CreateToken(tp,64047146)
		horn2=Duel.CreateToken(tp,64047146)
		horn3=Duel.CreateToken(tp,64047146)

		Duel.Equip(tp,horn1,tc)
		Duel.Equip(tp,horn2,tc2)
		Duel.Equip(tp,horn3,tc3)
		end

		
		

end