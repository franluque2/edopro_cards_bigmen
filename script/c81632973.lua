--Sub-Zero Conscription
--add archetype Template
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
end



--change this to change the locations where this acts
local LOCATIONS=LOCATION_ALL-LOCATION_OVERLAY

--add archetype setcode here
local ARCHETYPE=0x2f

--All "Glacial Beast" monsters in your possession are also treated as "Ice Barrier" monsters.
function s.archetypefilter(c)
  return c:IsCode(43175027, 79169622, 06568731)
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


    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_ADD_SETCODE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetTargetRange(LOCATIONS,0)
    e3:SetTarget(aux.TargetBoolFunction(s.archetypefilter))
    e3:SetValue(ARCHETYPE)
    Duel.RegisterEffect(e3,tp)

		-- ice barriers cannot activate
		local e8=Effect.CreateEffect(e:GetHandler())
        e8:SetType(EFFECT_TYPE_FIELD)
        e8:SetCode(EFFECT_CANNOT_TRIGGER)
		e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e8:SetTargetRange(LOCATION_MZONE,0)
        e8:SetCondition(s.discon)
        e8:SetTarget(s.actfilter)
        Duel.RegisterEffect(e8, tp)

	end
	e:SetLabel(1)
end

function s.funarwhalfilter(c)
	return c:IsCode(06568731) and c:IsFaceup()
end

function s.discon(e)
	return not Duel.IsExistingMatchingCard(s.funarwhalfilter, e:GetHandlerPlayer(), LOCATION_MZONE, 0, 1, nil)
end

function s.actfilter(e,c)
	return c:IsOriginalSetCard(0x2f) and c:IsSummonLocation(LOCATION_EXTRA)
end




function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)



	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

