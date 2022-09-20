--Waking the Sleeping Giant
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
local LOCATION_DCK_GY=LOCATION_DECK+LOCATION_GRAVE
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PREDRAW)
		e1:SetCondition(s.flipcon)
		e1:SetOperation(s.flipop)
		Duel.RegisterEffect(e1,tp)
	end
	e:SetLabel(1)
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
function s.summon_genie(e,tp,eg,ep,ev,re,r,rp)
	local genie=Duel.CreateToken(tp,94535485)
	Duel.SpecialSummon(genie,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.zushin_add_filter(c)
	return c:IsCode(67547370) and c:IsAbleToHand()
end
function s.zushin_filter(c)
	return c:IsCode(67547370) and c:IsFaceup()
end

function s.normal_filter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:GetLevel()==1 and (c:IsSummonType(SUMMON_TYPE_NORMAL) or c:IsSummonType(SUMMON_TYPE_SPECIAL)) and (c:IsStatus(STATUS_SUMMON_TURN) or c:IsStatus(STATUS_SPSUMMON_TURN))
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	--OPT check
	if Duel.GetFlagEffect(tp,id+1)>0 and Duel.GetFlagEffect(ep,id+2)>0 then return end
	--Boolean checks for the activation condition: b1, b2, b3
	local b1=Duel.GetFlagEffect(tp,id+1)==0
			and Duel.IsExistingMatchingCard(s.normal_filter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.zushin_filter,tp,LOCATION_MZONE,0,1,nil,tp)

	return aux.CanActivateSkill(tp) and (b1 or b2)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	--Boolean check for effect 1:
	local b1=Duel.GetFlagEffect(tp,id+1)==0
			and Duel.IsExistingMatchingCard(s.normal_filter,tp,LOCATION_MZONE,0,1,nil)
			and (Duel.IsExistingMatchingCard(s.zushin_add_filter,tp,LOCATION_DECK,0,1,nil) or
			Duel.IsExistingMatchingCard(s.st_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil))

	--Boolean check for effect2:
	local b2=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.zushin_filter,tp,LOCATION_MZONE,0,1,nil)

	--Select Effect
	local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,0)},
								  {b2,aux.Stringid(id,1)})
	op=op-1 --SelectEffect returns indexes starting at 1, so we decrease the result by 1 to match your "if"s

	if op==0 then
		s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
	elseif op==1 then
		s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
	end
end

function s.st_filter(c)
	return (c:IsCode(511000027) or c:IsCode(20920083)) and c:IsSSetable()
end

--op=0, If you normal or ssd a level 1 normal, add zushin or set a floodgate
function s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local b1=Duel.IsExistingMatchingCard(s.zushin_add_filter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.st_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,2)},
								  {b2,aux.Stringid(id,3)})
	op=op-1 --SelectEffect returns indexes starting at 1, so we decrease the result by 1 to match your "if"s

	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.zushin_add_filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	elseif op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.st_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g:GetFirst())
	end
	end
	Duel.RegisterFlagEffect(tp,id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
function s.spfilter2(c,e,tp,rmg)
	return c:IsCode(18891691) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
	and Duel.GetLocationCountFromEx(tp,tp,rmg,SUMMON_TYPE_FUSION)>0
end
function s.matlfilter(c)
	return c:IsCode(46700124,44203504) and c:IsAbleToRemove()
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(Card.IsCode,1,nil,46700124) and sg:IsExists(Card.IsCode,1,nil,44203504)
end

function s.posfilter(c)
	return c:IsPosition(POS_DEFENSE) and c:IsCanChangePosition()
end
--op=1, If you control Zushin the Sleeping Giant, flip all opponents to attack position
function s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK)
	Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
