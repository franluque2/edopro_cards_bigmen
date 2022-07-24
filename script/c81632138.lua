--Defending Sweeper (CT)
local s,id=GetID()
function s.initial_effect(c)

	--make level 5
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(5)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	c:RegisterEffect(e1)

	--discard to search stadium or a card that mentions it except self

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)


	--stadium of dreams cannot be destroyed
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_FZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,450000110))
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

s.listed_names={450000110}

function s.condition(e)
	return Duel.IsEnvironment(450000110)
end


function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function s.thfilter1(c)
	return (c:IsCode(450000110) or ((aux.IsCodeListed(c, 450000110) or c:IsCode(450000111) or c:IsCode(450000112) or c:IsCode(810000059)) and not c:IsCode(id))) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.SelectMatchingCard(tp, s.thfilter1, tp,LOCATION_DECK,0, 1, 1,false,nil)
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
