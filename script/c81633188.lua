--Action Field - Crossover
Duel.LoadScript("c151000000.lua")

local s,id=GetID()
function s.initial_effect(c)
	--Activate Skill
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

local tableActionCards={
	150000024,150000033,
	150000042,
	150000011,150000044,
	150000020
}



function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)


		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e6:SetCode(EFFECT_BECOME_QUICK)
		e6:SetTargetRange(0xff,0)
		e6:SetTarget(aux.TargetBoolFunction(Card.IsActionSpell))
		Duel.RegisterEffect(e6,tp)
		local e7=e6:Clone()
		e7:SetDescription(aux.Stringid(id,7))
		e7:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		Duel.RegisterEffect(e7,tp)
		local e8=e6:Clone()
		e8:SetDescription(aux.Stringid(id,7))
		e8:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		Duel.RegisterEffect(e8,tp)


	end
	e:SetLabel(1)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	aux.RegisterClientHint(e:GetHandler(),nil,tp,1,0,aux.Stringid(id,0),nil)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
	Duel.SendtoDeck(e:GetHandler(), tp, -2, REASON_EFFECT)
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp, 1, REASON_EFFECT)
	end
end


function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPD check
	if Duel.GetFlagEffect(tp,id)>1 or Duel.GetFlagEffect(tp, id+500)>1  then return end

	return aux.CanActivateSkill(tp)
end



function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
       
	Duel.Hint(HINT_CARD,tp,id)
	local token=Duel.CreateToken(tp,tableActionCards[Duel.GetRandomNumber(1,#tableActionCards)])
	Duel.SendtoHand(token, tp, REASON_RULE)
	Duel.RegisterFlagEffect(tp, id, RESET_PHASE+PHASE_END, 0, 0)
	Duel.RegisterFlagEffect(tp, id+500, 0, 0, 0)

end
