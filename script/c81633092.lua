--Shackles of Steadfast Traditions
Duel.EnableUnofficialProc(PROC_CANNOT_BATTLE_INDES)

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
end

local SHS_HEAVYSTRONG=511009519
local SHS_BLUEBRW=41628550
local SHS_FLUTIST=27978707


function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)

		--other passive duel effects go here

        local e11=Effect.CreateEffect(e:GetHandler())
        e11:SetType(EFFECT_TYPE_FIELD)
        e11:SetCode(EFFECT_CANNOT_TRIGGER)
        e11:SetTargetRange(LOCATION_GRAVE,0)
        e11:SetCondition(s.discon)
        e11:SetTarget(s.actfilter)
        Duel.RegisterEffect(e11, tp)

        local e2=Effect.CreateEffect(e:GetHandler())
        e2:SetType(EFFECT_TYPE_FIELD)
        e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
        e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e2:SetTargetRange(LOCATION_MZONE,0)
        e2:SetTarget(s.immtar)
        e2:SetValue(s.value)
        Duel.RegisterEffect(e2,tp)


	end
	e:SetLabel(1)
end

function s.value(e,re,rp)
	local trig_cod,eff=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CODE,CHAININFO_TRIGGERING_EFFECT)
	return re:IsActiveType(TYPE_MONSTER) and re:GetActivateLocation()==LOCATION_MZONE
		and (re:GetHandler():IsCode(SHS_HEAVYSTRONG) or (eff==re and trig_cod==SHS_HEAVYSTRONG))
end

function s.immtar(e,c)
	return c:IsCode(SHS_HEAVYSTRONG)
end


function s.discon(e)
	return Duel.IsExistingMatchingCard(Card.IsSpellTrap, e:GetOwnerPlayer(), LOCATION_GRAVE, 0, 1, nil)
end

function s.actfilter(e,c)
	return c:IsCode(SHS_FLUTIST)
end






function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1 and Duel.GetFlagEffect(tp, id)==0
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)

    local g=Duel.GetMatchingGroup(Card.IsCode, tp, LOCATION_ALL, LOCATION_ALL, nil, SHS_BLUEBRW)

    if #g>0 then
		local tc=g:GetFirst()
		while tc do

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BATTLE_INDES)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetValue(s.batval)
		tc:RegisterEffect(e1)

            tc=g:GetNext()
        end
    end

	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.batval(e,re,c)
	return Duel.IsExistingMatchingCard(Card.IsSpellTrap, c:GetControler(), LOCATION_GRAVE, 0, 1, nil) and c:IsCode(SHS_BLUEBRW)
end