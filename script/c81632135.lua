--Gem of Lycanthropy (CT)
local s,id=GetID()
function s.initial_effect(c)
	--Tribute 1 monster and Special Summon 1 "Mutant Lycanthrope" from your Hand or Deck,
	--then, if you control "Mutant Mindmaster", you can draw 1 card.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	e1:SetCountLimit(1,id)
	c:RegisterEffect(e1)
end

function s.spcfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0
end

function s.mmasterfilter(c)
	return c:IsCode(11508758) and c:IsFaceup()
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.spcfilter,1,false,nil,nil,tp) end
	local sg=Duel.SelectReleaseGroupCost(tp,s.spcfilter,1,1,false,nil,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsCode(81632136) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and c:IsType(TYPE_EFFECT)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		if Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP) then
			if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.mmasterfilter, tp, LOCATION_MZONE, 0, 1, nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.BreakEffect()
				Duel.ShuffleDeck(tp)
				Duel.Draw(tp,1,REASON_EFFECT)
			end
			end
		end
	end
