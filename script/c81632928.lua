--Pharaoh of the Shadows
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

		--Face-up "Sarcophagus" Spells/Traps cannot be targeted by your opponent's card effects.
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e3:SetTargetRange(LOCATION_SZONE,0)
		e3:SetTarget(aux.TargetBoolFunction(s.sarcfilter))
		e3:SetValue(1)
		Duel.RegisterEffect(e3,tp)

		--While you control a Level 2 or lower Normal Zombie monster, "Spirit of the Pharaoh" you control cannot be destroyed by battle or by card effects.
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_INDESTRUCTABLE)
		e4:SetTargetRange(LOCATION_MZONE,0)
		e4:SetTarget(aux.TargetBoolFunction(s.spiritpharaohfilter,tp))
		e4:SetValue(1)
		Duel.RegisterEffect(e4,tp)

		--opp can't activate cards or effs in response to your pharaoh
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e5:SetCode(EVENT_CHAINING)
		e5:SetOperation(s.actop)
		Duel.RegisterEffect(e5,tp)

		--during the end phase, recycle your sarcophagi
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e6:SetCountLimit(1)
		e6:SetCode(EVENT_PHASE+PHASE_END)
		e6:SetCondition(s.adcon)
		e6:SetOperation(s.adop)
		Duel.RegisterEffect(e6,tp)


		end
e:SetLabel(1)
end

function s.sarc1setfilter(c)
	return c:IsCode(31076103) and c:IsSSetable()
end

function s.sarc2deckfilter(c)
	return c:IsCode(04081094) and c:IsAbleToDeck()
end
function s.sarc3deckfilter(c)
	return c:IsCode(78697395) and c:IsAbleToDeck()
end

function s.adcon(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(s.sarc1setfilter, tp, LOCATION_GRAVE, 0, 1, nil)
		and Duel.IsExistingMatchingCard(s.sarc2deckfilter, tp, LOCATION_GRAVE, 0, 1, nil) and
		Duel.IsExistingMatchingCard(s.sarc3deckfilter, tp, LOCATION_GRAVE, 0, 1, nil)
end

function s.adop(e,tp,eg,ep,ev,re,r,rp)
if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
	Duel.Hint(HINT_CARD,tp,id)
	local g=Duel.SelectMatchingCard(tp,s.sarc1setfilter,tp,LOCATION_GRAVE,0,1,1,false,nil)
	local g2=Duel.SelectMatchingCard(tp,s.sarc2deckfilter,tp,LOCATION_GRAVE,0,1,1,false,nil)
	local g3=Duel.SelectMatchingCard(tp,s.sarc3deckfilter,tp,LOCATION_GRAVE,0,1,1,false,nil)
	g2:Merge(g3)
	if #g2>0 then
		Duel.SendtoDeck(g2, tp, SEQ_DECKBOTTOM, REASON_EFFECT)
		Duel.SSet(tp, g)
	end
end
end


function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsCode(25343280) and re:IsActiveType(TYPE_MONSTER) and ep==tp then
		Duel.SetChainLimit(s.chainlm)
	end
end

function s.chainlm(e,rp,tp)
	return tp==rp
end

function s.sarcfilter(c)
	return (c:IsCode(31076103) or c:IsCode(04081094) or c:IsCode(78697395)) and c:IsFaceup()
end

function s.faceupvanillafilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL) and c:IsLevelBelow(2) and c:IsFaceup()
end

function s.spiritpharaohfilter(c,tp)
	return c:IsCode(25343280) and c:IsFaceup() and Duel.IsExistingMatchingCard(s.faceupvanillafilter,tp,LOCATION_MZONE,0,1,nil)
end


function s.spiritpharaohfilterfaceup(c)
	return c:IsCode(25343280) and c:IsFaceup()
end

function s.vanilla_grave_filter(c,e,tp)
	return  c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL) and c:IsLevelBelow(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.place_sarc(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

		--Activate 1 "The First Sarcophagus" face-up in your Spell/Trap Zone from outside the duel.
function s.place_sarc(e,tp,eg,ep,ev,re,r,rp)
	local sarc=Duel.CreateToken(tp,31076103)
	Duel.MoveToField(sarc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function s.vanillamillfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_NORMAL) and c:IsLevelBelow(2) and c:IsAbleToGrave()
end

function s.tenergyfilter(c)
	return c:IsCode(05703682) and c:IsSSetable()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 and Duel.GetFlagEffect(tp, id+4)>0 then return end

	--Once per turn, during the Main Phase, you can send 1 Level 2 or lower Normal Zombie monster from your Deck to the GY.

	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.vanillamillfilter,tp,LOCATION_DECK,0,1,nil)

			-- Once per turn, if you control "Spirit of the Pharaoh", you can Special Summon 1 Level 2 or lower Normal Zombie monster from your GY.

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.spiritpharaohfilterfaceup,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.vanilla_grave_filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp, LOCATION_MZONE)>0


		--Once per turn, if you control 2 or more Level 2 or lower Normal Zombie monsters, you can set 1 "Thousand Energy" from your
		--Deck or GY to your Spell/Trap Zone.

		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsExistingMatchingCard(s.faceupvanillafilter,tp,LOCATION_MZONE,0,2,nil)
			and Duel.IsExistingMatchingCard(s.tenergyfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	--Once per turn, during the Main Phase, you can send 1 Level 2 or lower Normal Zombie monster from your Deck to the GY.

	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.vanillamillfilter,tp,LOCATION_DECK,0,1,nil)

			-- Once per turn, if you control "Spirit of the Pharaoh", you can Special Summon 1 Level 2 or lower Normal Zombie monster from your GY.

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.spiritpharaohfilterfaceup,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.vanilla_grave_filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp, LOCATION_MZONE)>0


		--Once per turn, if you control 2 or more Level 2 or lower Normal Zombie monsters, you can set 1 "Thousand Energy" from your
		--Deck or GY to your Spell/Trap Zone.

		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsExistingMatchingCard(s.faceupvanillafilter,tp,LOCATION_MZONE,0,2,nil)
			and Duel.IsExistingMatchingCard(s.tenergyfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


		local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,1)},
									{b3,aux.Stringid(id,2)})
		op=op-1

	if op==0 then
			local zomb=Duel.SelectMatchingCard(tp, s.vanillamillfilter, tp, LOCATION_DECK, 0, 1, 1,false,nil)
			Duel.SendtoGrave(zomb, REASON_EFFECT)
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then
		local zomb=Duel.SelectMatchingCard(tp, s.vanilla_grave_filter, tp, LOCATION_GRAVE, 0, 1, 1,false,nil,e,tp)
		if #zomb>0 then
			Duel.SpecialSummon(zomb,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==2 then
		local tenerg=Duel.SelectMatchingCard(tp, s.tenergyfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1,false,nil)
		Duel.SSet(tp, tenerg)
		Duel.RegisterFlagEffect(tp,id+4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
