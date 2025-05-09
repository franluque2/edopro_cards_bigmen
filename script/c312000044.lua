--Schrödinger's Cat (CT)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,{id,2})
	e1:SetTarget(s.target2)
	e1:SetOperation(s.activate2)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DRAW)
    e2:SetCountLimit(1,{id,0})
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)

    local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,{id,1})
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.thcon)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>2 end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter2(c)
	return c:IsCode(511001234, 511000478, 511000479, 41386308, 72880377, 511001235, 511000156, 32484853) and c:IsAbleToHand()
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	local g=Duel.GetDecktopGroup(tp,3)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(s.filter2,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,s.filter2,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		local ct=#g
		if ct>0 then
			Duel.MoveToDeckBottom(ct,tp)
			Duel.SortDeckbottom(tp,tp,2)
		end end
end
function s.relavfieldfilter(c)
    return c.IsCode(c, 511000479) and c:IsFaceup()
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local opt=Duel.SelectOption(1-tp,70,71,72)
    if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	
	if (opt==0 and not tc:IsMonster()) or (opt==1 and not tc:IsSpell()) or (opt==2 and not tc:IsTrap()) then
        Duel.Damage(1-tp, 500, REASON_EFFECT)
        if not (Duel.IsExistingMatchingCard(s.relavfieldfilter, tp, LOCATION_ONFIELD, 0, 1,nil) and Duel.SelectYesNo(tp, aux.Stringid(id, 0))) then
            Duel.SendtoGrave(g, REASON_EFFECT)
        else
            Duel.SendtoHand(g, tp, REASON_EFFECT)
            Duel.ConfirmCards(1-tp, g)
        end
    else
        Duel.Remove(g, POS_FACEUP, REASON_EFFECT)
    end


end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return (not re or re:GetHandler():GetCode()~=id)
end
function s.filter(c,tp)
	return c:IsControler(tp) and c:IsAbleToDeck() and c:IsLocation(LOCATION_HAND)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp)
		and eg:IsExists(s.filter,1,nil,tp) end
	local g=eg:Filter(s.filter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsPlayerCanDraw(tp) then return end
	local g=eg:Filter(s.filter,nil,tp)
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,#g,REASON_EFFECT)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD|LOCATION_HAND)
end