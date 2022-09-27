--Chaos Distill
local s,id=GetID()
--
-- Any card sent to your GY is banished instead.
-- Once per turn: you can reveal any number of "Alchemy Beast" monsters in your hand; Shuffle those cards into the deck,
-- then you can add Spell Cards that list "Chaos Distill" in it's text from your deck to your hand, equal to the number of monsters shuffled,
-- 	except "Chaos Distill", "White Process - Albedo" and "Black Process - Negledo".
-- 	If this card would be destroyed by a card effect, you can shuffle into the deck 1 card from your hand, GY or that is banished, instead.

function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(s.rmtarget)
	e2:SetTargetRange(0xff,0)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)

	-- Once per turn: you can reveal any number of "Alchemy Beast" monsters in your hand; Shuffle those cards into the deck,
	-- then you can add Spell Cards that list "Chaos Distill" in it's text from your deck to your hand, up to the number of monsters shuffled,
	-- 	except "Chaos Distill", "White Process - Albedo" and "Black Process - Negledo".
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(s.atarget)
	e4:SetOperation(s.aoperation)
	c:RegisterEffect(e4)


	-- 	If this card would be destroyed by a card effect, you can shuffle into the deck 1 card from your hand, GY or that is banished, instead.

	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(s.desreptg)
	c:RegisterEffect(e5)

end
function s.rmtarget(e,c)
	return c:GetOwner()==e:GetHandlerPlayer()
end

function s.failter(c)
	return c:IsSetCard(0x501) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and not c:IsPublic()
end

function s.addfilter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and Card.ListsCode(c,100000650) and not (c:IsCode(100000650) or c:IsCode(100000664) or c:IsCode(100000663))
end
function s.atarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.addfilter, tp, LOCATION_DECK, 0, 1, nil)
		and Duel.IsExistingMatchingCard(s.failter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function s.aoperation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(p,s.failter,p,LOCATION_HAND,0,1,99,nil)
	if #g>0 then
		Duel.ConfirmCards(1-p,g)
		local ct=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(p)
		Duel.BreakEffect()
		local cad=Duel.SelectMatchingCard(p, s.addfilter, p, LOCATION_DECK, 0, 1, #g, nil)
		Duel.SendtoHand(cad, tp, REASON_EFFECT)
		Duel.ConfirmCards(1-tp,cad)
		Duel.ShuffleHand(p)
	end
end


function s.repfilter(c)
	return c:IsAbleToDeckAsCost()
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,c) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND,0,1,1,c)
		Duel.SendtoDeck(g, tp, SEQ_DECKSHUFFLE,REASON_REPLACE)
		Duel.ShuffleDeck(tp)
		return true
	else return false end
end
