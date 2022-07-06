--Guardians of the Labyrinth

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

		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCountLimit(1)
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetCondition(s.adcon)
		e2:SetOperation(s.adop)
		Duel.RegisterEffect(e2,tp)


		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCountLimit(1)
		e3:SetCode(EVENT_PHASE+PHASE_END)
		e3:SetCondition(s.setcon)
		e3:SetOperation(s.setop)
		Duel.RegisterEffect(e3,tp)

end
e:SetLabel(1)
	end



function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

function s.gate_piece_filter(c,e,tp)
	return (c:IsCode(25955164) or c:IsCode(98434877) or c:IsCode(62340868)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end


function s.gate_piece_filter_onfield(c)
	return (c:IsCode(25955164) or c:IsCode(98434877) or c:IsCode(62340868)) and c:IsFaceup()
end

function s.gateguardian_filter(c)
	return c:IsCode(25833572) and c:IsAbleToHand()
end

function s.gateguardian_filter_onfield(c)
	return c:IsCode(25833572) and c:IsFaceup()
end
function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+6)>0 and Duel.GetFlagEffect(tp, id+7)>0 then return end
	local g=Duel.GetMatchingGroup(s.gate_piece_filter_onfield,tp,LOCATION_MZONE,0,nil)
	local cg=g:GetClassCount(Card.GetCode)==3
--
-- Once per turn, you can Special Summon 1 "Sanga of the Thunder", "Suijin" or "Kazejin" from your Hand.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.gate_piece_filter,tp,LOCATION_HAND,0,1,nil,e,tp)

-- Once per turn, if you control "Sanga of the Thunder", "Suijin" and "Kazejin",
-- you can add 1 "Gate Guardian" from your Deck or GY to your Hand.
local b2=Duel.GetFlagEffect(tp, id+6)==0
		and cg
		and Duel.IsExistingMatchingCard(s.gateguardian_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)

		--Once per turn, you can target 1 "Gate Guardian" you control, then roll a six-sided die.
		--Until the end of this turn, the targeted monster gains one of the following effects:

		local b3=Duel.GetFlagEffect(tp, id+7)==0
			and Duel.IsExistingMatchingCard(s.gateguardian_filter_onfield,tp,LOCATION_MZONE,0,1,nil)

	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	local g=Duel.GetMatchingGroup(s.gate_piece_filter_onfield,tp,LOCATION_MZONE,0,nil)
	local cg=g:GetClassCount(Card.GetCode)==3
--
-- Once per turn, you can Special Summon 1 "Sanga of the Thunder", "Suijin" or "Kazejin" from your Hand.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.gate_piece_filter,tp,LOCATION_HAND,0,1,nil,e,tp)

-- Once per turn, if you control "Sanga of the Thunder", "Suijin" and "Kazejin",
-- you can add 1 "Gate Guardian" from your Deck or GY to your Hand.
	local b2=Duel.GetFlagEffect(tp, id+6)==0
		and cg
		and Duel.IsExistingMatchingCard(s.gateguardian_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)

		--Once per turn, you can target 1 "Gate Guardian" you control, then roll a six-sided die.
		--Until the end of this turn, the targeted monster gains one of the following effects:

		local b3=Duel.GetFlagEffect(tp, id+7)==0
			and Duel.IsExistingMatchingCard(s.gateguardian_filter_onfield,tp,LOCATION_MZONE,0,1,nil)

		local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,1)},
									  {b2,aux.Stringid(id,2)},
											{b3,aux.Stringid(id, 3)})
		op=op-1

	if op==0 then
		local g=Duel.SelectMatchingCard(tp,s.gate_piece_filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then
		local tc=Duel.SelectMatchingCard(tp, s.gateguardian_filter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 1, 1, nil):GetFirst()
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			Duel.RegisterFlagEffect(tp, id+6, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
	elseif op==2 then
		s.give_gate_guardian_effects(e,tp,eg,ep,ev,re,r,rp)
		Duel.RegisterFlagEffect(tp, id+7, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
	end
end

function s.labwall_onfield(c)
	return c:IsCode(67284908) and c:IsFaceup()
end

function s.labwall_hand_deck_gy(c,e,tp)
	return c:IsCode(67284908) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
-- During your Standby Phase, if you do not control "Labyrinth Wall",
-- 	You can Special Summon 1 "Labyrinth Wall" from your Hand, Deck or GY in Defense Position.
function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetTurnPlayer()==tp and not (Duel.GetFlagEffect(tp,id+3)>0) then return end

	local b1=Duel.GetFlagEffect(tp,id+3)==0
			and Duel.IsExistingMatchingCard(s.labwall_hand_deck_gy,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
			and not Duel.IsExistingMatchingCard(s.labwall_onfield,tp,LOCATION_ONFIELD,0,1,nil)


	return Duel.GetTurnPlayer()==tp and (b1)
end

function s.adop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,tp,id)
		s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)

end



function s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		local g=Duel.SelectMatchingCard(tp,s.labwall_hand_deck_gy,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
		if #g>0 then

				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
		end
	Duel.RegisterFlagEffect(tp, id+3, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
end
function s.destroyed_filter(c,tid,e,tp)
	return c:IsReason(REASON_DESTROY) and c:IsCode(25833572) and c:GetTurnID()==tid and c:IsPreviousControler(tp)
end

function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFlagEffect(tp,id+4)>0) then return false end
	local g=Duel.GetMatchingGroup(s.destroyed_filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,Duel.GetTurnCount(),e,tp)
	return (#g>0) and (Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end

--Once per turn, during the End Phase of the turn a "Gate Guardian" you control was destroyed
-- you can set 1 "Dark Element" from outside the duel to your Spell/Trap Zone,
--then place 1 "Dark Guardian" on the bottom of your deck from outside the duel.
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp, aux.Stringid(id, 11)) then
	Duel.Hint(HINT_CARD,tp,id)
	local delement=Duel.CreateToken(tp, 511000138)
	Duel.SSet(tp, delement, tp, true)
	local dguardian=Duel.CreateToken(tp,511000137)
	Duel.SendtoDeck(dguardian, tp, SEQ_DECKBOTTOM, REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp, id+4, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
end

function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

function s.give_gate_guardian_effects(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,s.gateguardian_filter_onfield,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if g then
		local c=e:GetHandler()
		local d=Duel.TossDice(tp,1)
		if d==1 then
-- 1: "If this card attacks, your opponent cannot activate cards or effects until the end of the damage step."
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetDescription(aux.Stringid(id, 4))
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(0,1)
		e1:SetValue(1)
		e1:SetCondition(s.actcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:RegisterEffect(e1)
		elseif d==2 then
			-- 2: "This card can attack twice during each Battle Phase this turn."
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id, 5))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			g:RegisterEffect(e1)
		elseif d==3 then
			-- 3: "If this card attacks, destroy all Spell/Trap Cards your opponent controls."
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,6))
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EVENT_BATTLED)
			e1:SetCondition(s.actcon)
			e1:SetTarget(s.destg)
			e1:SetOperation(s.desop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			g:RegisterEffect(e1)
		elseif d==4 then
			--- 4: "If this card attacks, destroy all Face-up Attack Position monsters your opponent controls."
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,7))
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F+EFFECT_FLAG_CLIENT_HINT)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EVENT_BATTLED)
			e1:SetCondition(s.actcon)
			e1:SetTarget(s.destg2)
			e1:SetOperation(s.desop2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			g:RegisterEffect(e1)
		elseif d==5 then
			--- 5: "If this card attacks, this card gains 1000 ATK."
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,8))
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
			e1:SetCondition(s.actcon)
			e1:SetOperation(s.atkgainop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			g:RegisterEffect(e1)
		else
			--- 6: "At the end of the damage step, if this card attacked, you can send this card to the GY,
			--then Special Summon 1 "Sanga of the Thunder", "Suijin" and "Kazejin" from your GY."
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e1:SetCode(EVENT_DAMAGE_STEP_END)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCondition(s.actcon2)
			e1:SetOperation(s.actoperation)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			g:RegisterEffect(e1)
		end
	end
end

function s.actcon2(e)
	local g=Duel.GetMatchingGroup(s.gate_piece_filter,tp,LOCATION_GRAVE,0,nil)
	local cg=g:GetClassCount(Card.GetCode)==3
	return Duel.GetAttacker()==e:GetHandler() and cg and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and e:GetHandler():IsAbleToGrave() and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
end

function s.actoperation(e,tp,eg,ep,ev,re,r,rp)
local g=Duel.GetMatchingGroup(s.gate_piece_filter,tp,LOCATION_GRAVE,0,nil,e,tp)
local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
local tg=aux.SelectUnselectGroup(g,e,tp,3,3,s.spcheck,1,tp,HINTMSG_SPSUMMON)

if #tg>0 then
	if Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)>0 then
		Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP)
	end
end
end

function s.desfilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end


function s.desfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP_ATTACK)
end

function s.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.desfilter2,tp,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end

function s.atkgainop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1000)
	e:GetHandler():RegisterEffect(e1)
end
