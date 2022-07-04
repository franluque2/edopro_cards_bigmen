--Alchemist of the Shadows

local s,id=GetID()

-- [ Effect ]

-- Face-up "Helios - The Primordial Sun", "Helios Duo Megistus" and "Helios Trice Megistus" you control cannot be Banished
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
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_REMOVE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(aux.TargetBoolFunction(s.heliosfilter))
		e3:SetValue(1)
		Duel.RegisterEffect(e3,tp)
end
e:SetLabel(1)
	end

function s.heliosfilter(c)
	return (c:IsCode(54493213) or c:IsCode(80887952) or c:IsCode(17286057)) and c:IsFaceup()
end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end
--At the start of the duel, activate 1 "Chaos Distill" from outside the duel.
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.activate_chaos_distill(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.activate_chaos_distill(e,tp,eg,ep,ev,re,r,rp)
	local dist=Duel.CreateToken(tp,81632119)
	Duel.MoveToField(dist,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end

function s.chaos_distill_filter(c)
	return c:IsCode(100000650) and c:IsFaceup()
end

function s.summon_spell_filter(c)
	return (c:IsCode(100000657) or c:IsCode(100000658) or c:IsCode(100000659) or c:IsCode(100000660) or c:IsCode(100000661) or c:IsCode(100000662)) and c:IsAbleToHand()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 then return end
	--Once per turn, if you control "Chaos Distill" you can add 1 "Tin Spell Circle", "Steel Lamp", "Bronze Scale", "Lead Compass",
	-- "Silver Key" or "Mercury Hourglass" from your Deck to your Hand.

	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.chaos_distill_filter,tp,LOCATION_SZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.summon_spell_filter,tp,LOCATION_DECK,0,1,nil)
	return aux.CanActivateSkill(tp) and b1
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	--Once per turn, if you control "Chaos Distill" you can add 1 "Tin Spell Circle", "Steel Lamp", "Bronze Scale", "Lead Compass",
	-- "Silver Key" or "Mercury Hourglass" from your Deck to your Hand.

  local b1=Duel.GetFlagEffect(tp,id+2)==0
		 and Duel.IsExistingMatchingCard(s.chaos_distill_filter,tp,LOCATION_SZONE,0,1,nil)
		 and Duel.IsExistingMatchingCard(s.summon_spell_filter,tp,LOCATION_DECK,0,1,nil)
	if b1==true then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.summon_spell_filter,tp,LOCATION_DECK,0,1,1,tpid)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end

function s.helios_small_filter(c)
	return c:IsCode(54493213) and c:IsFaceup()
end

function s.helios_mid_filter(c)
	return c:IsCode(80887952) and c:IsFaceup()
end


-- During your Standby Phase you can apply one of these effects:
-- - Once per duel, if you control "Helios - The Primordial Sun",  set 1 "Yellow Process - Kitolenics" to your Spell/Trap Zone from outside the duel.
-- - Once per duel, if you control "Helios - Duo Megistus",  set 1 "Red Process - Rubedo" to your Spell/Trap Zone from outside the duel.
-- -Once per duel, if you have 10 or more banished cards, set 1 "White Process - Albedo" to your Spell/Trap Zone from outside the duel.


function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetTurnPlayer()==tp and not (Duel.GetFlagEffect(tp,id+3)>0 and Duel.GetFlagEffect(tp,id+4)>0 and Duel.GetFlagEffect(tp,id+5)>0) then return end
	local b1=Duel.GetFlagEffect(tp,id+3)==0
			and Duel.IsExistingMatchingCard(s.helios_small_filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0

	local b2=Duel.GetFlagEffect(tp,id+4)==0
			and Duel.IsExistingMatchingCard(s.helios_mid_filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b3=Duel.GetFlagEffect(tp,id+5)==0
			and Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>=10
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0

	return Duel.GetTurnPlayer()==tp and (b1 or b2 or b3)
end

function s.adop(e,tp,eg,ep,ev,re,r,rp)
	--ask if you want to activate the skill or not
	if not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end

	local b1=Duel.GetFlagEffect(tp,id+3)==0
			and Duel.IsExistingMatchingCard(s.helios_small_filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0

	local b2=Duel.GetFlagEffect(tp,id+4)==0
			and Duel.IsExistingMatchingCard(s.helios_mid_filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b3=Duel.GetFlagEffect(tp,id+5)==0
			and Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>=10
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0

	local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,1)},
								  {b2,aux.Stringid(id,2)},
								  {b3,aux.Stringid(id,3)})
	op=op-1

	if op==0 then
		s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
	elseif op==1 then
		s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		s.operation_for_res2(e,tp,eg,ep,ev,re,r,rp)
	end
end



function s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
	local process=Duel.CreateToken(tp, 511001138)
	Duel.SSet(tp,process)
	Duel.RegisterFlagEffect(tp, id+3, 0, 0, 0)
end

function s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
	local process=Duel.CreateToken(tp, 511001127)
	Duel.SSet(tp,process)
	Duel.RegisterFlagEffect(tp, id+4, 0, 0, 0)
end

function s.operation_for_res2(e,tp,eg,ep,ev,re,r,rp)
	local process=Duel.CreateToken(tp, 100000663)
	Duel.SSet(tp,process)
	Duel.RegisterFlagEffect(tp, id+5, 0, 0, 0)
end
