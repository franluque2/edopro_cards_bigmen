--Corrupted Vessel of Falsehoods

Duel.LoadScript("big_aux.lua")


local s,id=GetID()
function s.initial_effect(c)
	--Activate Skill
	aux.AddSkillProcedure(c,2,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
	e1:SetLabel(0)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	aux.AddSkillProcedure(c,2,false,s.flipcon2,s.flipop2)
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)

		--other passive duel effects go here

		--uncomment (remove the --) the line below to make it a rush skill
		--bRush.addrules()(e,tp,eg,ep,ev,re,r,rp)

        local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetTargetRange(LOCATION_ALL-LOCATION_OVERLAY,0)
		e3:SetTarget(function (_, tc) return tc:IsCode(44682448, 18698739) end)
		e3:SetValue(0x10c)
		Duel.RegisterEffect(e3,tp)

        local e4=e3:Clone()
        e4:SetValue(SET_PHOTON)
		Duel.RegisterEffect(e4,tp)



        --conscription effects go here
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetTargetRange(LOCATION_ALL-LOCATION_OVERLAY,0)
		e5:SetCode(EFFECT_ADD_ATTRIBUTE)
		e5:SetTarget(function (_, tc) return tc:IsCode(44682448, 18698739) end)
		e5:SetValue(ATTRIBUTE_LIGHT)
		Duel.RegisterEffect(e5, tp)


        local e10=Effect.CreateEffect(e:GetHandler())
		e10:SetType(EFFECT_TYPE_FIELD)
		e10:SetCode(EFFECT_XYZ_LEVEL)
		e10:SetTargetRange(LOCATION_MZONE, 0)
		e10:SetTarget(function (_,c) return c:IsAttribute(ATTRIBUTE_LIGHT) end)
		e10:SetValue(s.xyzlv)
        Duel.RegisterEffect(e10,tp)
	end
	e:SetLabel(1)
end


function s.xyzlv(e,c,rc)
	return 0x50000+rc:GetLevel()
end





function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)

	--start of duel effects go here
    Duel.SetLP(tp,24000)


	s.startofdueleff(e,tp,eg,ep,ev,re,r,rp)

	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.startofdueleff(e,tp,eg,ep,ev,re,r,rp)


end

function s.cxyznomatfilter(c)
    return c:IsCode(97403510) and c:GetOverlayCount()==0
end

--effects to activate during the main phase go here
function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	--OPT check
	--checks to not let you activate anything if you can't, add every flag effect used for opt/opd here
	if Duel.GetFlagEffect(tp,id+2)>0  then return end
	--Boolean checks for the activation condition: b1, b2

	local b2=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.cxyznomatfilter,tp,LOCATION_MZONE,0,1,nil)
            and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


--return the b1 or b2 or .... in parenthesis at the end
	return aux.CanActivateSkill(tp) and (b2)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	--"pop" the skill card
	Duel.Hint(HINT_CARD,tp,id)
	--Boolean check for effect 1:

--copy the bxs from above
	local b2=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.cxyznomatfilter,tp,LOCATION_MZONE,0,1,nil)
            and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

--effect selector
	local op=Duel.SelectEffect(tp,{b2,aux.Stringid(id,1)})
	op=op-1 --SelectEffect returns indexes starting at 1, so we decrease the result by 1 to match your "if"s

	if op==0 then
		s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
	end
end


function s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
    local bforce=Duel.CreateToken(tp, 47660516)
    Duel.SSet(tp, bforce)

	--sets the opd
	Duel.RegisterFlagEffect(tp,id+2,0,0,0)
end
