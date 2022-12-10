--Gold Rush (CT)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(s.condition)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end

function s.cfilter(c,tp)
	return c:IsSummonPlayer(1-tp) and (c:IsLevelAbove(7) or c:IsPreviousLocation(LOCATION_EXTRA)) and c:IsFaceup()
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp) and Duel.IsPlayerCanDraw(tp) and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,1,nil) end
end
function s.filter2(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e, SUMMON_TYPE_SPECIAL, tp, false, false)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(aux.FilterMaximumSideFunctionEx(Card.IsAbleToGraveAsCost),tp,LOCATION_MZONE,0,1,1,nil)
	g=g:AddMaximumCheck()
	local ct=Duel.SendtoGrave(g,REASON_COST)
	if ct>0 then
			local g=Duel.GetDecktopGroup(tp, 3)
			Duel.Draw(tp, 3, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, g)
			g=g:Filter(s.filter2, nil, e,tp)
			if #g>0 then
					for tc in g:Iter() do
						Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
					end
					Duel.SpecialSummonComplete()


			end
	end
end
