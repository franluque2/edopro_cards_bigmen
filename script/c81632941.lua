--Forbidden Memory Sealing Incantation
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

		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e8:SetCode(EVENT_SPSUMMON_SUCCESS)
		e8:SetOperation(s.mreborncheck)
		Duel.RegisterEffect(e8,tp)




	end
	e:SetLabel(1)
end

function s.mreborncheck(e,tp,eg,ev,ep,re,r,rp)
	if not re then return end
	local rc=re:GetHandler()
	if (rc:IsCode(83764718) or rc:IsCode(160417004) or rc:IsCode(160417006)) and rc:IsType(TYPE_SPELL) then
		local ec=eg:GetFirst()
		while ec do
			ec:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
			ec=eg:GetNext()
		end
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

function s.monsterfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
	and (c:IsSummonType(SUMMON_TYPE_SPECIAL+SUMMON_WITH_MONSTER_REBORN) or c:GetFlagEffect(id)>0) and c:IsStatus(STATUS_SPSUMMON_TURN)
	and c:GetOwner()~=c:GetControler()
end


function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPD check
	if Duel.GetFlagEffect(tp,id+2)>0 then return end
	--
-- Once per Duel, if you activated "Monster Reborn" to Special Summon a monster from your Opponent's GY
--this turn, you can apply this effect:
-- -For the rest of this turn, your opponent cannot activate cards or effects.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.monsterfilter,tp,LOCATION_MZONE,0,1,nil)


	return aux.CanActivateSkill(tp) and (b1)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.monsterfilter,tp,LOCATION_MZONE,0,1,nil)


		local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,0)})
		op=op-1

	if op==0 then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)

		Duel.RegisterFlagEffect(tp,id+2,0,0,0)

	end
end
