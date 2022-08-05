--White Process - Albedo (CT)
local s,id=GetID()
function s.initial_effect(c)
 --Activate
 local e1=Effect.CreateEffect(c)
 e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
 e1:SetType(EFFECT_TYPE_ACTIVATE)
 e1:SetCode(EVENT_FREE_CHAIN)
 e1:SetCondition(s.condition)
 e1:SetTarget(s.target)
 e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
 e1:SetOperation(s.activate)
 c:RegisterEffect(e1)
end
s.listed_names={27408609,100000650}
function s.spfilter(c,e,tp)
 return c:IsCode(27408609) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.cfilter(c)
 return c:IsFaceup() and c:IsCode(100000650)
end
function s.fufilter(c)
	return c:IsFaceup()
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.fufilter,tp,LOCATION_REMOVED,0,nil)
 return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp)
 and #g>=10
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return true end
 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK+LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
 local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
 local tc=g:GetFirst()
 if tc then
	 Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	 tc:CompleteProcedure()
 end
end
