--Clean Beret - Colonel Mop (CT)
local s,id=GetID()
function s.initial_effect(c)
	-- atk change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_names={160202024}
function s.tdfilter(c)
	return c:IsAbleToDeck() and c:IsCode(160202024)
end

function s.levelfilter(c)
    return c:IsLevelAbove(7) or c:IsRankAbove(7) or c:IsLinkAbove (3)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(s.levelfilter),tp,0,LOCATION_MZONE,nil)>0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
end