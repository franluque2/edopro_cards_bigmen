--Hot Sauce Express
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
	aux.AddSkillProcedure(c,2,false,s.flipcon2,s.flipop2) 
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
	s.swap_tables(e,tp,eg,ep,ev,re,r,rp)
	s.set_table(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.table_filter(c)
return c:IsCode(100000323)
end

function s.table_filter_field(c)
return c:IsCode(100000323) and c:IsFaceup()
end

function s.set_table(e,tp,eg,ep,ev,re,r,rp)
	local newtab=Duel.CreateToken(tp,81632109)
			local e1=Effect.CreateEffect(newtab)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetValue(TYPE_TOKEN)
			newtab:RegisterEffect(e1,true)
			Duel.SSet(tp,newtab)
end

function s.swap_tables(e,tp,eg,ep,ev,re,r,rp)
local ng=Duel.GetMatchingGroup(s.table_filter,tp,LOCATION_HAND,0,nil)
if #ng>0 then
		for card in aux.Next(ng)do
			Duel.SendtoDeck(card,tp,-2,REASON_EFFECT)
			local newtab=Duel.CreateToken(tp,81632109)
			local e1=Effect.CreateEffect(newtab)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetValue(TYPE_TOKEN)
			newtab:RegisterEffect(e1,true)
			Duel.SendtoHand(newtab,tp,REASON_EFFECT)
			
	end
end
local hg=Duel.GetMatchingGroup(s.table_filter,tp,LOCATION_DECK,0,nil)
if #hg>0 then
		for card in aux.Next(hg)do
			Duel.SendtoDeck(card,tp,-2,REASON_EFFECT)
			local newtab=Duel.CreateToken(tp,81632109)
			local e1=Effect.CreateEffect(newtab)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_REMOVE_TYPE)
			e1:SetValue(TYPE_TOKEN)
			newtab:RegisterEffect(e1,true)
			Duel.SendtoDeck(newtab,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
			
	end
end
end
function s.cfilter(c)
	return c:IsCode(81632109) and c:IsSSetable()
end


function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	--opd check
	if Duel.GetFlagEffect(tp,id+1)>0 then return end
	--condition
	return aux.CanActivateSkill(tp) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) and not Duel.IsExistingMatchingCard(s.table_filter_field,tp,LOCATION_ONFIELD,0,1,nil)
end

function s.tdfilter(c)
	return c:IsCode(100000320) and c:IsAbleToDeck()
end

function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--opd register
	Duel.RegisterFlagEffect(tp,id+1,0,0,0)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SSet(tp,tc)>0 then
		local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end