--Skiel Attack (CT)
local s,id=GetID()
function s.initial_effect(c)

	c:SetUniqueOnField(1,0,c:Alias())

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)

	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(s.sdcon)
	c:RegisterEffect(e1)

end
s.listed_series={0x3013}
function s.sdcon(e)
	return not Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,0x3013),0,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
