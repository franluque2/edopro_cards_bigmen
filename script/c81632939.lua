--Glory to the Heavy Cavalry Duel Club
Duel.LoadScript ("big_aux.lua")

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

		--enable rush rules
		bRush.addrules()(e,tp,eg,ep,ev,re,r,rp)

		--At the start of the Duel, Activate a fieldspell from your deck

		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e8:SetCode(EVENT_PREDRAW)
		e8:SetCondition(s.flipcon3)
		e8:SetOperation(s.flipop3)
		e8:SetCountLimit(1)
		Duel.RegisterEffect(e8,tp)


	end
	e:SetLabel(1)
end

function s.fieldfilter(c)
	return c:IsType(TYPE_FIELD)
end

function s.flipcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
	and Duel.IsExistingMatchingCard(s.fieldfilter, tp, LOCATION_DECK, 0, 1, nil)
end
function s.flipop3(e,tp,eg,ep,ev,re,r,rp)
	local field=Duel.SelectMatchingCard(tp, s.fieldfilter, tp, LOCATION_DECK, 0, 1, 1,false,nil)
	if field then
		aux.PlayFieldSpell(field:GetFirst(),e,tp,eg,ep,ev,re,r,rp)
	end
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


function s.addfilter(c,e,tp,fc)
	return c:IsAbleToHand() and c:IsType(TYPE_MAXIMUM) and c:IsAttribute(ATTRIBUTE_EARTH)
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 then return end
	--
-- Once per turn, if you do not control a Field Spell,
--you can send the top 2 cards of your Deck to the GY, set 1 Field Spell from your GY to your Field Spell Zone.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
			and Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_GRAVE,0,1,nil)
			and not Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_FZONE,0,1,nil)


-- Once per duel, you can add any number of EARTH Maximum monsters from
-- your GY to your Hand up to the number of Field Spells on your Field and in your GY.
local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_GRAVE+LOCATION_FZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,1,nil)

	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	-- Once per turn, if you do not control a Field Spell,
	--you can send the top 2 cards of your Deck to the GY, set 1 Field Spell from your GY to your Field Spell Zone.
		local b1=Duel.GetFlagEffect(tp,id+2)==0
				and Duel.IsPlayerCanDiscardDeckAsCost(tp,2)
				and Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_GRAVE,0,1,nil)
				and not Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_FZONE,0,1,nil)


	-- Once per duel, you can add any number of EARTH Maximum monsters from
	-- your GY to your Hand up to the number of Field Spells on your Field and in your GY.
	local b2=Duel.GetFlagEffect(tp, id+3)==0
			and Duel.IsExistingMatchingCard(s.fieldfilter,tp,LOCATION_GRAVE+LOCATION_FZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.addfilter,tp,LOCATION_GRAVE,0,1,nil)

		local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,1)})
		op=op-1

	if op==0 then
		Duel.DiscardDeck(tp,2,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
		local field=Duel.SelectMatchingCard(tp, s.fieldfilter, tp, LOCATION_GRAVE, 0, 1, 1,false,nil)
		if field then
			Duel.SSet(tp, field)
			--aux.PlayFieldSpell(field:GetFirst(),e,tp,eg,ep,ev,re,r,rp)
		end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then
			local fields=Duel.GetMatchingGroup(s.fieldfilter, tp, LOCATION_GRAVE+LOCATION_FZONE, 0, nil)
			local fieldsscount= #fields
			Duel.Hint(HINT_MESSAGE, tp, HINTMSG_ATOHAND)
			local excavpieces=Duel.SelectMatchingCard(tp, s.addfilter, tp, LOCATION_GRAVE, 0, 1, fieldsscount, false, nil)
			Duel.SendtoHand(excavpieces, tp, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, excavpieces)
			Duel.RegisterFlagEffect(tp, id+3, 0, 0, 0)
end
end
