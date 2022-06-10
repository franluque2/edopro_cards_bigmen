--Curse of Lucky Straight
local s,id=GetID()
function s.initial_effect(c)
	--Activate Skill
	aux.AddSkillProcedure(c,2,false,nil,nil)
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

s.roll_dice=true
local tossd=Duel.TossDice
Duel.TossDice=register(tossd)


function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EFFECT_TOSS_DICE_CHOOSE)
		ge1:SetCondition(s.dicecon)
		ge1:SetOperation(s.repop("dice",Duel.GetDiceResult,Duel.SetDiceResult))
		Duel.RegisterEffect(ge1,0)
	end)
end
	end
	e:SetLabel(1)
end

function s.dicecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(ep,id)>0 and Duel.IsExistingMatchingCard(s.number_seven_filter,tp,LOCATION_MZONE,0,1,nil)
end


function s.repop(typ,func1,func2)
	return function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		local dc={func1()}
		local ct=(ev&0xff)+(ev>>16)
		local ac=1
		if ct>1 then
			if typ=="dice" then
				Duel.Hint(HINT_SELECTMSG,ep,aux.Stringid(id,1))
				local val,idx=Duel.AnnounceNumber(ep,table.unpack(dc,1,ct))
				ac=idx+1
			else
				local tab={}
				for i=1,ct do
					table.insert(tab,60+(1-dc[i]))
				end
				Duel.Hint(HINT_SELECTMSG,ep,aux.Stringid(id,2))
				Duel.SelectOption(ep,table.unpack(tab))
			end
			dc[ac]=6
		else
			dc[1]=6
		end
		func2(table.unpack(dc))
	end
end
function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and (Duel.GetTurnCount()==1 or Duel.GetTurnCount()==2) and Duel.GetTurnPlayer()==tp
end
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.summon_genie(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.summon_slotmachine(e,tp,eg,ep,ev,re,r,rp)
	local slo1=Duel.CreateToken(tp,03797883)
	Duel.SpecialSummon(slot1,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	local slo2=Duel.CreateToken(tp,03797883)
	Duel.SendtoDeck(slo2,nil,SEQ_DECKTOP,REASON_EFFECT)
	local slo3=Duel.CreateToken(tp,03797883)
	Duel.SendtoGrave(slo3,REASON_EFFECT)
	local mslots=Duel.CreateToken(tp,09576193)
	Duel.SSet(tp,mslots)
end
function s.spell_banish_filter(c)
	return c:IsType(TYPE_SPELL) c:IsAbleToRemove()
end
function s.monster_banish_filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSpecialSummonable()
end

function s.number_seven_filter(c)
	return c:IsCode(82308875) and c:IsFaceup()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 then return end
	--Boolean checks for the activation condition: b1
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.spell_banish_filter,tp,LOCATION_GRAVE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.monster_banish_filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)

	return aux.CanActivateSkill(tp) and b1
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local cg=Duel.SelectMatchingCard(tp,s.spell_banish_filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.Remove(cg,POS_FACEUP,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.monster_banish_filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
