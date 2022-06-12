--C/C Photoshoot
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
--At the start of the duel, Special Summon 1 "C/C Critical Eye" from outside the duel. 
function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.replace_film_magician(e,tp,eg,ep,ev,re,r,rp)
	s.summon_critical_eye(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
function s.summon_critical_eye(e,tp,eg,ep,ev,re,r,rp)
	local eye=Duel.CreateToken(tp,511003050)
	Duel.SpecialSummon(eye,0,tp,tp,false,false,POS_FACEUP)
end

function s.film_magician_filter(c)
return c:IsCode(511002386)
end


function s.film_magician_replaced_filter(c)
return c:IsCode(81632114)
end

function s.replace_film_magician(e,tp,eg,ep,ev,re,r,rp)
local ng=Duel.GetMatchingGroup(s.film_magician_filter,tp,LOCATION_HAND,0,nil)
if #ng>0 then
		for card in aux.Next(ng)do
			Duel.SendtoDeck(card,tp,-2,REASON_EFFECT)
			local newtab=Duel.CreateToken(tp,81632114)
			Duel.SendtoHand(newtab,tp,REASON_EFFECT)
			
	end
end
local hg=Duel.GetMatchingGroup(s.film_magician_filter,tp,LOCATION_DECK,0,nil)
if #hg>0 then
		for card in aux.Next(hg)do
			Duel.SendtoDeck(card,tp,-2,REASON_EFFECT)
			local newtab=Duel.CreateToken(tp,81632114)
			Duel.SendtoDeck(newtab,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
			
	end
end
end

function s.critical_eye_filter(c)
return c:IsCode(511003050) 
end

function s.critical_eye_control_filter(c)
return c:IsCode(511003050) and c:IsFaceup()
end

function s.spells_filter(c)
return (c:IsCode(511003051) or c:IsCode(511003052) or c:IsCode(511003053) or c:IsCode(511001555) or c:IsCode(810000080) or
		c:IsCode(511001556) or c:IsCode(511015113) or c:IsCode(511004411)) and c:IsSSetable()
end

function s.level_filter(c)
return c:HasLevel() and c:IsFaceup()
end

function s.attribute_filter(c)
return c:IsFaceup()
end
function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)
	
	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp,id+3)>0 and Duel.GetFlagEffect(tp,id+4)>0 and Duel.GetFlagEffect(tp,id+5)>0 then return end
	--. Once per turn, if you do not control "C/C Critical Eye", you can Special Summon 1 "C/C Critical Eye" from your GY by sending 1 "Film Magician" from either your Field, Hand or Deck to the GY.
	local b1=Duel.GetFlagEffect(ep,id+2)==0
			and not Duel.IsExistingMatchingCard(s.critical_eye_control_filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.critical_eye_filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(s.film_magician_replaced_filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	--Once per turn, if you control "C/C Critical Eye" you can apply one of these effects:
		local b2=Duel.GetFlagEffect(ep,id+3)==0
			and Duel.IsExistingMatchingCard(s.critical_eye_control_filter,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(s.spells_filter,tp,LOCATION_DECK,0,1,nil)
	--Once per turn, you can target 1 monster your opponent controls with a Level and declare a Level from 1 to 7, until the end of this turn, that monster becomes that Level.
	 local b3=Duel.GetFlagEffect(ep,id+4)==0
			and Duel.IsExistingMatchingCard(s.level_filter,tp,0,LOCATION_MZONE,1,nil)
	--Once per turn, you can target 1 monster your opponent controls and declare an Attribute, until the end of this turn, that monster becomes that Attribute.
		local b4=Duel.GetFlagEffect(ep,id+5)==0
			and Duel.IsExistingMatchingCard(s.attribute_filter,tp,0,LOCATION_MZONE,1,nil,tp)
	return aux.CanActivateSkill(tp) and (b1 or b2 or b3 or b4)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
 --. Once per turn, if you do not control "C/C Critical Eye", you can Special Summon 1 "C/C Critical Eye" from your GY by sending 1 "Film Magician" from either your Field, Hand or Deck to the GY.
	local b1=Duel.GetFlagEffect(ep,id+2)==0
			and not Duel.IsExistingMatchingCard(s.critical_eye_control_filter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.critical_eye_filter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.IsExistingMatchingCard(s.film_magician_replaced_filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	--Once per turn, if you control "C/C Critical Eye" you can apply one of these effects:
		local b2=Duel.GetFlagEffect(ep,id+3)==0
			and Duel.IsExistingMatchingCard(s.critical_eye_control_filter,tp,LOCATION_MZONE,0,1,nil,tp)
			and Duel.IsExistingMatchingCard(s.spells_filter,tp,LOCATION_DECK,0,1,nil)
	--Once per turn, you can target 1 monster your opponent controls with a Level and declare a Level from 1 to 7, until the end of this turn, that monster becomes that Level.
	 local b3=Duel.GetFlagEffect(ep,id+4)==0
			and Duel.IsExistingMatchingCard(s.level_filter,tp,0,LOCATION_MZONE,1,nil)
	--Once per turn, you can target 1 monster your opponent controls and declare an Attribute, until the end of this turn, that monster becomes that Attribute.
		local b4=Duel.GetFlagEffect(ep,id+5)==0
			and Duel.IsExistingMatchingCard(s.attribute_filter,tp,0,LOCATION_MZONE,1,nil,tp)

	local op=aux.SelectEffect(tp, {b1,aux.Stringid(id,0)},
								  {b2,aux.Stringid(id,1)},
								  {b2,aux.Stringid(id,2)},
								  {b2,aux.Stringid(id,3)})-1


	if op==0 then
		s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
	elseif op==1 then
		s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
	elseif op==2 then
		s.operation_for_res2(e,tp,eg,ep,ev,re,r,rp)
	elseif op==3 then
		s.operation_for_res3(e,tp,eg,ep,ev,re,r,rp)
	end
end
 --. Once per turn, if you do not control "C/C Critical Eye", you can Special Summon 1 "C/C Critical Eye" from your GY by sending 1 "Film Magician" from either your Field, Hand or Deck to the GY.
function s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,s.film_magician_replaced_filter,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK,0,1,1,nil):GetFirst()
	local c=Duel.SelectMatchingCard(tp,s.critical_eye_filter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
--Once per turn, if you control "C/C Critical Eye" you can apply one of these effects:
function s.operation_for_res1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.spells_filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if Duel.SSet(tp,tc)>0 then
		if tc:IsType(TYPE_QUICKPLAY) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		elseif tc:IsType(TYPE_TRAP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	Duel.RegisterFlagEffect(tp,id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
--Once per turn, you can target 1 monster your opponent controls with a Level and declare a Level from 1 to 7, until the end of this turn, that monster becomes that Level.
function s.operation_for_res2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,s.level_filter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,4))
		local lvl=Duel.AnnounceLevel(tp,1,7,tc:GetLevel())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.RegisterFlagEffect(tp,id+4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
--Once per turn, you can target 1 monster your opponent controls and declare an Attribute, until the end of this turn, that monster becomes that Attribute.
function s.operation_for_res3(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.SelectMatchingCard(tp,s.attribute_filter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
		local att=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
	Duel.RegisterFlagEffect(tp,id+5,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
end
