--Wedding Gifts

local s,id=GetID()


function s.initial_effect(c)
	--Activate Skill
	aux.AddSkillProcedure(c,1,false,nil,nil)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_STARTUP)
	e1:SetCountLimit(1)
	e1:SetRange(0x5f)
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
		e1:SetCountLimit(1)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,id+1,0,0,0)

		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(aux.TargetBoolFunction(s.maidenfilter,tp))
		e3:SetValue(1)
		Duel.RegisterEffect(e3,tp)
		--At the start of the duel, Special Summon 1 "Maiden in Love" from outside the duel.

end
e:SetLabel(1)
	end

function s.maidenfilter(c,tp)
	return c:IsCode(100000139) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.defmaidenfilter, tp, LOCATION_SZONE, 0, 1, nil)
end

function s.defmaidenfilter(c)
	return c:IsCode(100000136) and c:IsFaceup()
end


function s.maidenfilter_fup(c)
	return c:IsCode(100000139) and c:IsFaceup()
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.summon_maiden_in_love(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.summon_maiden_in_love(e,tp,eg,ep,ev,re,r,rp)
	local maiden=Duel.CreateToken(tp,100000139)
	Duel.SpecialSummon(maiden,0,tp,tp,false,false,POS_FACEUP)
end

function s.tosetfilter(c)
	return (c:IsCode(100000138) or c:IsCode(100000137) or c:IsCode(100000136)) and c:IsSSetable()
end

function s.tokenfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function s.tokencardfilter(c)
	return (c:IsCode(52971673) or c:IsCode(57182235) or c:IsCode(83675475) or c:IsCode(97173708) or c:IsCode(14342283)) and c:IsSSetable()
end

function s.mbabydragonfilter(c)
	return c:IsCode(511009183) and c:IsFaceup()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 and Duel.GetFlagEffect(tp, id+4) then return end

	--Once per turn, if you control "Maiden in Love", you can apply one of the following effects:
	--Set 1 "Cupid's Kiss",  "Happy Marriage" or "Defense Maiden" from your Deck to your Spell/Trap Zone. It can be activated this turn.

	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.maidenfilter_fup,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.tosetfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

			-- . Once per turn, if you control a Token monster, you can set 1 "Token" Spell/Trap Card
			--from your Deck to your Spell/Trap Zone. It can be activated this turn.

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.tokenfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tokencardfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

--Once per turn, if you control "Mystic Baby Dragon", you can set 1 "Mystic Revolution" from outside the duel to your Spell/Trap Zone.
		local b3=Duel.GetFlagEffect(tp,id+4)==0
				and Duel.IsExistingMatchingCard(s.mbabydragonfilter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)


	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.maidenfilter_fup,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.tosetfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

			-- . Once per turn, if you control a Token monster, you can set 1 "Token" Spell/Trap Card
			--from your Deck to your Spell/Trap Zone. It can be activated this turn.

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.tokenfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.tokencardfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

--Once per turn, if you control "Mystic Baby Dragon", you can set 1 "Mystic Revolution" from outside the duel to your Spell/Trap Zone.
		local b3=Duel.GetFlagEffect(tp,id+4)==0
				and Duel.IsExistingMatchingCard(s.mbabydragonfilter,tp,LOCATION_MZONE,0,1,nil)
				and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

		local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,1)},
										{b3,aux.Stringid(id, 2)})
		op=op-1

	if op==0 then

		--Once per turn, if you control "Maiden in Love", you can apply one of the following effects:
		--Set 1 "Cupid's Kiss",  "Happy Marriage" or "Defense Maiden" from your Deck to your Spell/Trap Zone. It can be activated this turn.

		local g=Duel.SelectMatchingCard(tp, s.tosetfilter, tp, LOCATION_DECK, 0, 1, 1,false,nil):GetFirst()

		Duel.SSet(tp, g)
		-- Duel.ConfirmCards(1-tp, g)
		if g:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:RegisterEffect(e2)
		end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then
		local g=Duel.SelectMatchingCard(tp, s.tokencardfilter, tp, LOCATION_DECK, 0, 1, 1,false,nil):GetFirst()
		Duel.SSet(tp, g)
		-- Duel.ConfirmCards(1-tp, g)
		if g:IsType(TYPE_TRAP) then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:RegisterEffect(e2)
		end

		Duel.RegisterFlagEffect(tp,id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==2 then
		local mrevoltuion=Duel.CreateToken(tp, 511009189)
		Duel.SSet(tp, mrevolution)
		-- Duel.ConfirmCards(tp, mrevoltuion)
		Duel.RegisterFlagEffect(tp,id+4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
