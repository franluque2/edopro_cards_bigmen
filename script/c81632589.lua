--Mystic Eruption (CT)
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
    e1:SetCountLimit(1,{id,1})
	c:RegisterEffect(e1)

    --to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCondition(s.condition2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
    e2:SetCountLimit(1,{id,2})
	c:RegisterEffect(e2)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,81632585)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function s.filter(c,e,tp,tid)
	return c:IsReason(REASON_DESTROY) and c:GetTurnID()==tid and (c:IsSpellTrap() or c:IsMonster())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tid=Duel.GetTurnCount()
	if chkc then return s.filter(chkc,e,tp,tid) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp,tid) end
	if Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp,tid) then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,1000)
	elseif Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) then
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	else
		Duel.SetTargetPlayer(1-tp)
		Duel.SetTargetParam(1000)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	if Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,tid) and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp,tid) then
		Duel.Damage(1-tp,1000,REASON_EFFECT)
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.DLfilter, tp, LOCATION_MZONE, 0, 1, nil) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	else
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Damage(p,d,REASON_EFFECT)
		if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(s.DLfilter, tp, LOCATION_MZONE, 0, 1, nil) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function s.DLfilter(c)
	return c:IsCode(81632585) and c:IsFaceup()
end
