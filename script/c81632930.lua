--Going Going Goblin
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

		end
e:SetLabel(1)
end


function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.summon_goblins(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

		--At the start of the duel, Special Summon 1 "Giant Orc" and 1 "Second Goblin" from outside the duel.
function s.summon_goblins(e,tp,eg,ep,ev,re,r,rp)
	local giantorc=Duel.CreateToken(tp,73698349)
	local secondgoblin=Duel.CreateToken(tp, 19086954)
	Duel.SpecialSummon(giantorc,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(secondgoblin,0,tp,tp,false,false,POS_FACEUP)
end

function s.giantorc_filter(c)
	return c:IsCode(73698349) and c:IsFaceup() and not (c:GetFlagEffect(id)>0)
end

function s.goblinfufilter(c,tp)
	return c:IsSetCard(0xac) and c:IsFaceup() and c:IsLevelAbove(4)
	 and not c:IsType(TYPE_TOKEN)
end

function s.goblinfudeffilter(c)
	return c:IsSetCard(0xac) and c:IsPosition(POS_FACEUP_DEFENSE)
end

function s.squadbackrowfilter(c)
	return (c:IsCode(17626381) or c:IsCode(28486799) or c:IsCode(33622465) or c:IsCode(40633084) or c:IsCode(80584548))
	 and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSSetable()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 and Duel.GetFlagEffect(tp, id+4)>0 then return end

	--Once per turn, you can target 1 "Giant Orc" you control, it gains the following effect:


	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.giantorc_filter,tp,LOCATION_MZONE,0,1,nil)

			--target a "Goblin" monster you control, Special Summon up to 2 Tokens with the same original

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.goblinfufilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp, LOCATION_MZONE)>0

--Once per turn you can target 1 DEF position "Goblin" monster you control and apply one of the following effects
		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsExistingMatchingCard(s.goblinfudeffilter,tp,LOCATION_MZONE,0,1,nil)

	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	--Once per turn, you can target 1 "Giant Orc" you control, it gains the following effect:


	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.giantorc_filter,tp,LOCATION_MZONE,0,1,nil)

			--target a "Goblin" monster you control, Special Summon up to 2 Tokens with the same original

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.goblinfufilter,tp,LOCATION_MZONE,0,1,nil,tp)
		and Duel.GetLocationCount(tp, LOCATION_MZONE)>0

--Once per turn you can target 1 DEF position "Goblin" monster you control and apply one of the following effects
		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsExistingMatchingCard(s.goblinfudeffilter,tp,LOCATION_MZONE,0,1,nil)

		local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,2)},
										{b3,aux.Stringid(id,3)})
		op=op-1

	if op==0 then

		local gorc=Duel.SelectMatchingCard(tp,s.giantorc_filter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		gorc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)

		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetCondition(s.eqcon)
		e2:SetValue(s.unval)
		e2:SetDescription(aux.Stringid(id, 1))
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		gorc:RegisterEffect(e2)



			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then
		local gob=Duel.SelectMatchingCard(tp,s.goblinfufilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
		local gobtoken1=Duel.CreateToken(tp,63442605)




		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_SET_BASE_ATTACK)
		e5:SetValue(gob:GetBaseAttack())
		e5:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		gobtoken1:RegisterEffect(e5)
		local e2=e5:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(gob:GetBaseDefense())
		gobtoken1:RegisterEffect(e2)
		local e3=e5:Clone()
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetValue(gob:GetOriginalLevel())
		gobtoken1:RegisterEffect(e3)
		local e4=e5:Clone()
		e4:SetCode(EFFECT_CHANGE_RACE)
		e4:SetValue(gob:GetOriginalRace())
		gobtoken1:RegisterEffect(e4)
		local e6=e5:Clone()
		e6:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e6:SetValue(gob:GetOriginalAttribute())
		gobtoken1:RegisterEffect(e6)

		local e7=e5:Clone()
		e7:SetCode(EFFECT_REMOVE_TYPE)
		e7:SetValue(TYPE_NORMAL)
		gobtoken1:RegisterEffect(e7)

		local e8=e5:Clone()
		e8:SetCode(EFFECT_ADD_TYPE)
		e8:SetValue(TYPE_EFFECT)
		gobtoken1:RegisterEffect(e8)


		Duel.SpecialSummon(gobtoken1,0,tp,tp,false,false,POS_FACEUP)

		gobtoken1:CopyEffect(gob:GetCode(),RESET_EVENT+RESETS_STANDARD,1)

		gobtoken1:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(s.descon)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetCountLimit(1)
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetLabelObject(gobtoken1)
		Duel.RegisterEffect(e1,tp)

		if Duel.IsExistingMatchingCard(s.goblinfufilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp, LOCATION_MZONE)>0
		 and Duel.SelectYesNo(tp, aux.Stringid(id, 6)) then
			 local gobtoken2=Duel.CreateToken(tp,63442605)




	 		local e10=Effect.CreateEffect(e:GetHandler())
	 		e10:SetType(EFFECT_TYPE_SINGLE)
	 		e10:SetCode(EFFECT_SET_BASE_ATTACK)
	 		e10:SetValue(gob:GetBaseAttack())
	 		e10:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	 		gobtoken2:RegisterEffect(e10)
	 		local e11=e10:Clone()
	 		e11:SetCode(EFFECT_SET_BASE_DEFENSE)
	 		e11:SetValue(gob:GetBaseDefense())
	 		gobtoken2:RegisterEffect(e11)
	 		local e12=e10:Clone()
	 		e12:SetCode(EFFECT_CHANGE_LEVEL)
	 		e12:SetValue(gob:GetOriginalLevel())
	 		gobtoken2:RegisterEffect(e12)
	 		local e13=e10:Clone()
	 		e13:SetCode(EFFECT_CHANGE_RACE)
	 		e13:SetValue(gob:GetOriginalRace())
	 		gobtoken2:RegisterEffect(e13)
	 		local e14=e10:Clone()
	 		e14:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	 		e14:SetValue(gob:GetOriginalAttribute())
	 		gobtoken2:RegisterEffect(e14)

	 		local e15=e10:Clone()
	 		e15:SetCode(EFFECT_REMOVE_TYPE)
	 		e15:SetValue(TYPE_NORMAL)
	 		gobtoken2:RegisterEffect(e15)

	 		local e16=e10:Clone()
	 		e16:SetCode(EFFECT_ADD_TYPE)
	 		e16:SetValue(TYPE_EFFECT)
	 		gobtoken2:RegisterEffect(e16)


	 		Duel.SpecialSummon(gobtoken2,0,tp,tp,false,false,POS_FACEUP)

			gobtoken2:CopyEffect(gob:GetCode(),RESET_EVENT+RESETS_STANDARD,1)

			gobtoken2:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)

			local e9=Effect.CreateEffect(e:GetHandler())
	 		e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	 		e9:SetCode(EVENT_PHASE+PHASE_END)
	 		e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	 		e9:SetCondition(s.descon)
	 		e9:SetOperation(s.desop)
	 		e9:SetReset(RESET_PHASE+PHASE_END,2)
	 		e9:SetCountLimit(1)
	 		e9:SetLabel(Duel.GetTurnCount())
	 		e9:SetLabelObject(gobtoken2)
	 		Duel.RegisterEffect(e9,tp)
		end

		Duel.RegisterFlagEffect(tp,id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==2 then

		local defgob=Duel.SelectMatchingCard(tp,s.goblinfudeffilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()

		local b4=defgob:IsDestructable() and Duel.IsExistingMatchingCard(s.squadbackrowfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp, LOCATION_SZONE)>0

		local b5=defgob:IsCanChangePosition()

		local op=aux.SelectEffect(tp, {b4,aux.Stringid(id,4)},
									  {b5,aux.Stringid(id,5)})
		op=op-1

		if op==0 then

			if Duel.Destroy(defgob, REASON_EFFECT)>0 then
				local squadst=Duel.SelectMatchingCard(tp,s.squadbackrowfilter,tp,LOCATION_DECK,0,1,1,nil)
				Duel.SSet(tp, squadst)
			end

		elseif op==1 then
			if Duel.ChangePosition(defgob, POS_FACEUP_ATTACK)>0 then
				local g=Duel.GetMatchingGroup(s.codefilter,tp,LOCATION_MZONE,0,nil,defgob:GetCode())
				local tc=g:GetFirst()
				for tc in aux.Next(g) do
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DIRECT_ATTACK)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
				end
			end
		end

		Duel.RegisterFlagEffect(tp,id+4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end

function s.codefilter(c,code)
	return c:GetCode()==code and c:IsFaceup()
end

function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and tc:GetFlagEffect(id)~=0
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end

function s.eqcon(e)
	eg= e:GetHandler():GetEquipGroup()
	return #eg>0 and eg:IsExists(Card.IsCode,1,nil,19086954)
end
function s.unval(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
