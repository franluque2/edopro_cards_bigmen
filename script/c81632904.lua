--Master Storm Access
local s,id=GetID()
function s.initial_effect(c)

--Prevent destruction by opponent's effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.indestg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--Prevent effect target
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)


--Unnafected by other cards' effects
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
end

function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.indestg(e,c)
	return c:IsLink(5)
end

