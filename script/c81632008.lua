--Chimera Hydradrive Dragrid
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x577)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),1,1) --,s.lcheck
	c:EnableReviveLimit()
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.ctcon)
	e1:SetOperation(s.ctop)
	c:RegisterEffect(e1)
	
	--remove a counter, summon a random draghead
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptar)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end
s.roll_dice=true
function s.lcheck(g,lc,sumtype,tp)
	return g:CheckDifferentPropertyBinary(Card.GetAttribute,lc,sumtype,tp)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonLocation()==LOCATION_EXTRA
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x577,1)
	end
end



function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x577,1,REASON_COST) end
	c:RemoveCounter(tp,0x577,1,REASON_COST)
end
function s.spcon(e) 
	return Duel.IsMainPhase() and e:GetHandler():IsInExtraMZone()
end

function s.draghead_filter(c,e,tp,att)
return c:IsSetCard(0x1577) and c:IsAttribute(att) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.draghead_filter_no_att(c,e,tp)
return c:IsSetCard(0x1577) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end


function s.draghead_filter_fire(c,e,tp)
return c:IsCode(81632002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.draghead_filter_water(c,e,tp)
return c:IsCode(81632003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.draghead_filter_earth(c,e,tp)
return c:IsCode(81632007) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.draghead_filter_wind(c,e,tp)
return c:IsCode(81632006) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.draghead_filter_light(c,e,tp)
return c:IsCode(81632005) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

function s.draghead_filter_dark(c,e,tp)
return c:IsCode(81632004) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end




function s.chlimit(e,ep,tp)
	return tp==ep
end

function s.sptar(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.SetChainLimit(s.chlimit)
	local att=0
	for gc in aux.Next(Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)) do
		att=att|gc:GetAttribute()
	end
	if chk==0 and att==0 then return Duel.IsExistingMatchingCard(s.draghead_filter_no_att,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.draghead_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,att) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.fieldfilter(c)
	return c:IsCode(81632904) and (c:IsFaceup())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_FZONE,0,1,nil,e,tp,nil) then
	p=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	else
		p=0
	end
	if p==1 then
		local att=0
		for gc in aux.Next(Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,nil)) do
			att=att|gc:GetAttribute()
		end
		if att==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.draghead_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,att):GetFirst()
		if tc and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		local d=Duel.TossDice(tp,1)
		if d==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.draghead_filter_earth,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		elseif d==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.draghead_filter_water,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		elseif d==3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.draghead_filter_fire,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		elseif d==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.draghead_filter_wind,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		elseif d==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.draghead_filter_light,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.draghead_filter_dark,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SendtoDeck(c,nil,0,REASON_EFFECT) then 
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
		end
end
end
