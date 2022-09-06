--Draw Paradox (CT)
local s,id=GetID()
function s.initial_effect(c)

	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e4)

	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.scon0)
	e1:SetTarget(s.stg0)
	e1:SetOperation(s.sop0)
	c:RegisterEffect(e1)


--protect relav field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_FZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(s.relavfilter))
	e3:SetValue(1)
	c:RegisterEffect(e3)


--draw2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,{id,1})
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.relavfilter(c)
	return c:IsCode(511000479) and c:IsFaceup()
end

function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function s.scon0(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW and eg:IsExists(s.cfilter,1,nil,1-tp)
				and Duel.IsPlayerCanDraw(tp)
end
function s.stg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,0,LOCATION_DECK)
end
function s.sop0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

function s.fucontspellfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsFaceup() and c:IsAbleToGrave()
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp, 1, REASON_EFFECT) then
		if Duel.IsExistingMatchingCard(s.fucontspellfilter, tp, LOCATION_ONFIELD, 0, 1, nil) then
			Duel.BreakEffect()
				if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
					local g=Duel.SelectMatchingCard(tp, s.fucontspellfilter, tp, LOCATION_ONFIELD, 0, 1, 1,false,nil)
						if #g>0 then
							if Duel.SendtoGrave(g, REASON_EFFECT) then
								Duel.Draw(tp, 1, REASON_EFFECT)
							end
						end
				end
		end
	end

end
