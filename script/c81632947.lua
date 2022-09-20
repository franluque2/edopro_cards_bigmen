--Sartyr's Curry Recipe
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

		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ADD_SETCODE)
		e3:SetTargetRange(LOCATION_GRAVE,0)
		e3:SetTarget(aux.TargetBoolFunction(s.mooyancurryfilter))
		e3:SetValue(0x54d)
		Duel.RegisterEffect(e3,tp)

		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e8:SetCode(EVENT_SPSUMMON_SUCCESS)
		e8:SetOperation(s.currypotcheck)
		Duel.RegisterEffect(e8,tp)

end
e:SetLabel(1)
	end

	function s.currypotcheck(e,tp,eg,ev,ep,re,r,rp)
		if not re then return end
		local rc=re:GetHandler()
		if rc:IsCode(511001219) then
			local ec=eg:GetFirst()
			while ec do
				ec:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
				ec=eg:GetNext()
			end
		end
	end


	function s.mooyancurryfilter(c)
		return c:IsCode(58074572)
	end

function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
end

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.generatespices(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end
local spices={}

local spicestoadd={511001220,511001221,511001222,511001223,511001224}

function s.generatespices(e,tp,eg,ep,ev,re,r,rp)
	for key,value in ipairs(spicestoadd) do
					newcard=Duel.CreateToken(tp, value)
					table.insert(spices,newcard)
	end
end

function ripairs(t)
    -- Try not to use break when using this function;
    -- it may cause the array to be left with empty slots
    local ci = 0
    local remove = function()
        t[ci] = nil
    end
    return function(t, i)
        --print("I", table.concat(array, ','))
        i = i+1
        ci = i
        local v = t[i]
        if v == nil then
            local rj = 0
            for ri = 1, i-1 do
                if t[ri] ~= nil then
                    rj = rj+1
                    t[rj] = t[ri]
                    --print("R", table.concat(array, ','))
                end
            end
            for ri = rj+1, i do
                t[ri] = nil
            end
            return
        end
        return i, v, remove
    end, t, ci
end


function s.curryfiendroofilter(c)
	return c:IsFaceup() and c:IsCode(511001218) and (c:GetFlagEffect(id)>0)
end

function s.veggiemanfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER)
		and (c:IsCode(511001216) or c:IsCode(511001215) or c:IsCode(511001217))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.fucurrypotfilter(c)
	return c:IsFaceup() and c:IsCode(511001219)
end

function s.curryaddfilter(c)
	return c:IsCode(511001219) and c:IsAbleToHand()
end

function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+6)>0 and Duel.GetFlagEffect(tp, id+4)>0 then return end
--
--  Once per Duel, you can discard 1 card, add 1 "Curry Pot" from your Deck to your Hand.
	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(s.curryaddfilter,tp,LOCATION_DECK,0,1,nil)

--Once per turn, if you control "Curry Pot", you can Special Summon 1 "Potato Man", "Onion Man" or "Carrot Man" from your Hand, Deck or GY.
local b2=Duel.GetFlagEffect(tp, id+6)==0
		and Duel.IsExistingMatchingCard(s.fucurrypotfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.veggiemanfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)

--Once per turn, if you control a "Curry Fiend Roo" that was Special Summoned by the effect of "Curry Pot" you can apply this effect:
-- "Set as many "Mooyan Curry" from outside the duel to your Spell/Trap Zone as possible".
		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsExistingMatchingCard(s.curryfiendroofilter,tp,LOCATION_MZONE,0,1,nil)
			and (Duel.GetLocationCount(tp, LOCATION_SZONE)>0)


	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)

	--  Once per Duel, you can discard 1 card, add 1 "Curry Pot" from your Deck to your Hand.
		local b1=Duel.GetFlagEffect(tp,id+2)==0
				and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
				and Duel.IsExistingMatchingCard(s.curryaddfilter,tp,LOCATION_DECK,0,1,nil)

	--Once per turn, if you control "Curry Pot", you can Special Summon 1 "Potato Man", "Onion Man" or "Carrot Man" from your Hand, Deck or GY.
	local b2=Duel.GetFlagEffect(tp, id+6)==0
			and Duel.IsExistingMatchingCard(s.fucurrypotfilter,tp,LOCATION_SZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.veggiemanfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)

	--Once per turn, if you control a "Curry Fiend Roo" that was Special Summoned by the effect of "Curry Pot" you can apply this effect:
	-- "Set as many "Mooyan Curry" from outside the duel to your Spell/Trap Zone as possible".
			local b3=Duel.GetFlagEffect(tp, id+4)==0
				and Duel.IsExistingMatchingCard(s.curryfiendroofilter,tp,LOCATION_MZONE,0,1,nil)
				and (Duel.GetLocationCount(tp, LOCATION_SZONE)>0)


		local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,1)},
									  {b2,aux.Stringid(id,2)},
									{b3,aux.Stringid(id,3)})
		op=op-1

	if op==0 then
		local g=Duel.SelectMatchingCard(tp, Card.IsDiscardable, tp,LOCATION_HAND,0,1,1,false,nil)
		if #g>0 then
			Duel.SendtoGrave(g, REASON_EFFECT)
			local tc=Duel.SelectMatchingCard(tp, s.curryaddfilter, tp, LOCATION_DECK,0,1,1,false,nil)
			if #tc>0 then
				Duel.SendtoHand(tc, tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp, tc)
			end
		end
			--opt register
			Duel.RegisterFlagEffect(tp,id+2,0,0,0)
	elseif op==1 then
			local g=Duel.SelectMatchingCard(tp, s.veggiemanfilter, tp, LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,false,nil,e,tp)
			if #g>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
			Duel.RegisterFlagEffect(tp, id+6, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
	elseif op==2 then

		for i = 1,Duel.GetLocationCount(tp, LOCATION_SZONE),1
		do
			local curry=Duel.CreateToken(tp, 58074572)
			Duel.SSet(tp, curry)
		end

		Duel.RegisterFlagEffect(tp, id+4, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
	end
end



-- Once per turn, during each of your Standby Phases, you can add 1 spice spell/trap from outside to hand

function s.adcon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetTurnPlayer()==tp and not (Duel.GetFlagEffect(tp,id+3)>0) then return end



	return Duel.GetTurnPlayer()==tp
end

function s.adop(e,tp,eg,ep,ev,re,r,rp)

		s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
end



function s.operation_for_res0(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp, aux.Stringid(id, 0)) then
		Duel.Hint(HINT_CARD,tp,id)
		local ng=Group.CreateGroup()
		for i, v, remove in ripairs(spices) do
			Group.AddCard(ng,v)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=ng:Select(tp,1,1,nil)
		for i, v, remove in ripairs(spices) do
			if v:GetCode()==sg:GetFirst():GetCode() then
				remove()
			end
		end
	local newcard=Duel.CreateToken(tp, sg:GetFirst():GetCode())
	table.insert(spices,newcard)

	Duel.SendtoHand(sg, tp, REASON_EFFECT)
	Duel.ConfirmCards(1-tp, sg)
	Duel.RegisterFlagEffect(tp, id+3, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 0)
end
end
