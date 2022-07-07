--Seeds of Providence
local s,id=GetID()
function s.initial_effect(c)
	--skill
		--Activate
	aux.AddSkillProcedure(c,1,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	aux.AddSkillProcedure(c,1,false,s.flipcon2,s.flipop2)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)

		--Disable left and right-most zones
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetOperation(s.disabledzones)
		Duel.RegisterEffect(e2,tp)

		--Draw till you have 5 cards in hand
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DRAW_COUNT)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetValue(s.getcarddraw)
		Duel.RegisterEffect(e3,tp)

		--Give almost infinite normal summons
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetTargetRange(1,0)
		e4:SetValue(999999999)
		Duel.RegisterEffect(e4,tp)

		--skip MP2

		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(EFFECT_SKIP_M2)
		e5:SetTargetRange(1,0)
		Duel.RegisterEffect(e5,tp)

		--skip SP

		--local e7=Effect.CreateEffect(e:GetHandler())
		--e7:SetType(EFFECT_TYPE_FIELD)
		--e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		--e7:SetCode(EFFECT_SKIP_SP)
		--e7:SetTargetRange(1,0)
		--Duel.RegisterEffect(e7,tp)

		--disable EMZs
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_FORCE_MZONE)
		e6:SetRange(LOCATION_MZONE)
		e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e6:SetTargetRange(1,0)
		e6:SetValue(s.znval)
		Duel.RegisterEffect(e6,tp)

		--give infinite hand size
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_HAND_LIMIT)
		e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e7:SetTargetRange(1,0)
		e7:SetValue(100)
		Duel.RegisterEffect(e7,tp)
		--At the start of the Duel, place 1 "Femtron" in your GY.
			local femtron=Duel.CreateToken(tp, 160202014)
			Duel.SendtoGrave(femtron, REASON_EFFECT, tp)

	end
	e:SetLabel(1)
end

function s.flipcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)

end


function s.getcarddraw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0) < 5 then
		return 5-Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)
	else
		return 1
end
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	--condition
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.znval(e)
	return ~(0x60)
end


function s.disabledzones(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandlerPlayer()==tp then
			return 0x00001111
	else
			return 0x11110000
	end
end

function s.tronfilter(c)
	return c:IsCode(160202014) or c:IsCode(160202015) or c:IsCode(160202016) or c:IsCode(160202017)
end

function s.addfilter(c,e,tp,fc)
	return c:IsAbleToHand() and c:IsType(TYPE_MAXIMUM) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPD check
	if Duel.GetFlagEffect(tp,id+2)>0 then return end
	--
-- Once per duel, you can add any number of LIGHT Maximum Monster's from your GY
--to your hand up to the number of "Femtron", "Attron", "Zeptron", and "Yoctron" with different names in your GY.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.tronfilter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,1,nil)


	return aux.CanActivateSkill(tp) and (b1)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	-- Once per duel, you can add any number of LIGHT Maximum Monster's from your GY
	--to your hand up to the number of "Femtron", "Attron", "Zeptron", and "Yoctron" with different names in your GY.

	local trons=Duel.GetMatchingGroup(s.tronfilter, tp, LOCATION_GRAVE, 0, nil)
	local tronscount= trons:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_MESSAGE, tp, HINTMSG_ATOHAND)
	local yggpieces=Duel.SelectMatchingCard(tp, s.addfilter, tp, LOCATION_GRAVE, 0, 1, tronscount, false, nil)
	Duel.SendtoHand(yggpieces, tp, REASON_EFFECT)
	Duel.ConfirmCards(1-tp, yggpieces)
	Duel.RegisterFlagEffect(tp, id+2, 0, 0, 0)
end
