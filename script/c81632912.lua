--Capsulated Mutation
local s,id=GetID()
function s.initial_effect(c)
	aux.AddSkillProcedure(c,1,false,s.flipcon,s.flipop,1)
	aux.AddSkillProcedure(c,1,false,s.flipcon2,s.flipop2)
end


function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	   --condition
	return aux.CanActivateSkill(tp) and Duel.GetFlagEffect(tp,id)==0
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	Duel.RegisterEffect(e3,tp)
	--During the End Phase, you can switch all "Mutant Mindmaster" you control to Defense Position.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(s.swapcon)
	e1:SetOperation(s.swapop)
	Duel.RegisterEffect(e1,tp)

	--while you control 2 or more monsters, your opponent cannot choose Mutant Mindmaster you control for attacks
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(s.cannottgcon)
	e2:SetValue(s.cannotatk)
	Duel.RegisterEffect(e2,tp)

	Duel.RegisterFlagEffect(tp,id,0,0,0)
end


function s.cannottgcon(e)
	return Duel.GetMatchingGroupCount(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)>1
end

function s.cannotatk(e,c)
	return c:IsCode(11508758) and c:IsFaceup()
end

function s.flipconfilter(c)
	return c:IsCode(11508758) and c:IsFaceup()
end


function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	--opt check
	if Duel.GetFlagEffect(tp,id)==0 then return end
	if Duel.GetFlagEffect(tp,id+1)>0 then return end
	--condition
	local b1=Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil,tp)

	return aux.CanActivateSkill(tp) and b1
end


function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local c=e:GetHandler(e)

	local tc=Duel.SelectMatchingCard(tp,s.flipconfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
	   --Cannot be destroyed by card effects
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3001)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
		--opd register
		Duel.RegisterFlagEffect(tp,id+1,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(id,tp)~=0
end
--At the end of the Battle Phase, you can tribute any amount of monsters you control that are owned by your opponent, draw that many cards.


function s.trifilter(c)
	return c:IsReleasableByEffect() and c:GetOwner()~=c:GetControler()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_DECK)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #sg>0 and Duel.IsPlayerCanDraw(tp,1) end
	local rg=Duel.SelectReleaseGroupCost(tp,s.trifilter,0,5,false,nil,nil,ft,tp)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local sg=Duel.SelectReleaseGroupCost(tp,s.trifilter,0,5,false,nil,nil,ft,tp)
	if Duel.Release(sg,REASON_EFFECT)>0 then
		sg=Duel.GetOperatedGroup()
		Duel.Draw(p,#sg,REASON_EFFECT)
	end
end

function s.swapcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)~=0 and Duel.IsExistingMatchingCard(s.flipconfilter,tp,LOCATION_MZONE,0,1,nil)
end

function s.swapop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_CARD,tp,id)
		local g=Duel.GetMatchingGroup(s.flipconfilter,tp,LOCATION_MZONE,0,nil)
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
end
	Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end


function s.econ(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
end

function s.etarget(e,c)
	return c:IsCode(11508758) and c:IsFaceup()
end
