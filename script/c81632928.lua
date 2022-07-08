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


		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCondition(s.adcon)
		e2:SetOperation(s.adop)
		Duel.RegisterEffect(e2,tp)
		end
e:SetLabel(1)
end

	function s.genexcontroller_gy_filter(c)
		return c:IsCode(68505803) and c:IsAbleToDeck()
	end

	function s.genexcontroller_send_filter(c)
		return c:IsCode(68505803) and c:IsAbleToGraveAsCost()
	end

function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(s.genexcontroller_gy_filter, tp, LOCATION_GRAVE, 0, 1, nil)
end

function s.adop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.SelectMatchingCard(tp,s.genexcontroller_gy_filter,tp,LOCATION_GRAVE,0,1,1,false,nil)
		if #g then
			Duel.SendtoDeck(g, tp, SEQ_DECKSHUFFLE, REASON_EFFECT)
		end
	end
end



function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.summon_genex_controller(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

		--At the start of the duel, Special Summon 1 "Genex Controller" from outside the duel.
function s.summon_genex_controller(e,tp,eg,ep,ev,re,r,rp)
	local controller=Duel.CreateToken(tp,68505803)
	Duel.SpecialSummon(controller,0,tp,tp,false,false,POS_FACEUP)
end

function s.genex_filter_deck(c)
	return c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.genex_tuner_filter(c)
	return c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 and Duel.GetFlagEffect(tp, id+4) then return end

	--Once per turn, you can send 1 "Genex Controller" from your Hand or Deck to the GY, then add 1 "Genex" monster from your Deck to your Hand.


	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.genexcontroller_send_filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.genex_filter_deck,tp,LOCATION_DECK,0,1,nil)

			--Once per turn, you can target 1 "Genex" Tuner monster you control and declare a level from 1 to 3,
		-- until the end of this turn, that becomes that level, it's name becomes "Genex Controller" and gains the following effect:

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.genex_tuner_filter,tp,LOCATION_MZONE,0,1,nil)

	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	--Once per turn, you can send 1 "Genex Controller" from your Hand or Deck to the GY, then add 1 "Genex" monster from your Deck to your Hand.


	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.genexcontroller_send_filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
			and Duel.IsExistingMatchingCard(s.genex_filter_deck,tp,LOCATION_DECK,0,1,nil)

			--Once per turn, you can target 1 "Genex" Tuner monster you control and declare a level from 1 to 3,
		-- until the end of this turn, that becomes that level, it's name becomes "Genex Controller" and gains the following effect:

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.genex_tuner_filter,tp,LOCATION_MZONE,0,1,nil)

		local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,1)})
		op=op-1

	if op==0 then
		local tg=Duel.SelectMatchingCard(tp, s.genexcontroller_send_filter, tp, LOCATION_HAND+LOCATION_DECK, 0, 1, 1,false,nil)
		if Duel.SendtoGrave(tg, REASON_EFFECT) then
			local g=Duel.SelectMatchingCard(tp, s.genex_filter_deck, tp, LOCATION_DECK, 0, 1, 1,false,nil)
			Duel.SendtoHand(g, tp, REASON_EFFECT)
			Duel.ConfirmCards(1-tp, g)
		end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then

		Duel.RegisterFlagEffect(tp,id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==2 then
		
		Duel.RegisterFlagEffect(tp,id+4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
