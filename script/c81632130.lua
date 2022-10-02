--Hydradrive Mutation
local s,id=GetID()
function s.initial_effect(c)
	--Cannot be Normal Summoned/Set, must first be ssd by own effect
	c:EnableReviveLimit()

	--Special Summon this card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	--att change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.costg)
	e3:SetOperation(s.cosop)
	c:RegisterEffect(e3)
end

function s.attfilter(c,att)
	return c:IsFaceup() and not c:IsAttribute(att)
end

function s.costg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc:IsDifferentAttribute(e:GetHandler():GetAttribute()) end
	if chk==0 then return Duel.IsExistingTarget(s.attfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e:GetHandler():GetAttribute()) end
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsCanBeEffectTarget,e),tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sel=g:FilterSelect(tp,Card.IsDifferentAttribute,1,1,nil,e:GetHandler():GetAttribute())
	Duel.SetTargetCard(sel)
end
function s.cosop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(tc:GetAttribute())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
	end
end

function s.trapfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end

function s.fucardfilter(c)
	return c:IsAbleToHand() and c:IsFaceup()
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(s.fucardfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,s.fucardfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) then
			if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP) then
				e:GetHandler():CompleteProcedure()
				if Duel.IsExistingMatchingCard(s.trapfilter, tp, LOCATION_GRAVE, 0, 1, nil) and Duel.GetLocationCount(tp, LOCATION_SZONE) and Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
					Duel.BreakEffect()
					local g=Duel.SelectMatchingCard(tp, s.trapfilter, tp, LOCATION_GRAVE, 0, 1, 1,false,nil)
					if #g>0 then
						Duel.SSet(tp, g)
					end
				end
			end
		end
	end
end
