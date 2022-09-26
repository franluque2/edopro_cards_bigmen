--Eradication Protocols
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

end
e:SetLabel(1)
end

	function s.flipcon(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetCurrentChain()==0 and Duel.GetTurnCount()==1
	end

	function s.flipop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
		Duel.Hint(HINT_CARD,tp,id)
		s.copydeck(e,tp,eg,ep,ev,re,r,rp)
		s.copyhand(e,tp,eg,ep,ev,re,r,rp)
		s.copyextra(e,tp,eg,ep,ev,re,r,rp)


		s.placeallyofjustices(e,tp,eg,ep,ev,re,r,rp)
		s.morpharchetypes(e,tp,eg,ep,ev,re,r,rp)

		Duel.ShuffleDeck(tp)
		Duel.Draw(tp, 5, REASON_EFFECT)
	end


function s.copyhand(e,tp,eg,ep,ev,re,r,rp)
		local location=LOCATION_HAND
		local to_limbo=Duel.GetMatchingGroup(aux.TRUE, tp, location, 0, nil)
		Duel.SendtoDeck(to_limbo, tp, -2, REASON_EFFECT)
		Duel.DisableShuffleCheck(true)
		local oppcards=Duel.GetMatchingGroup(aux.TRUE, tp, 0, location, nil)

		if #oppcards>0 then
			local tc=oppcards:GetFirst()
			local newcard=nil
			while tc do

				newcard=Duel.CreateToken(tp, tc:GetCode())
				Duel.SendtoDeck(newcard, tp, SEQ_DECKTOP, REASON_EFFECT)


				tc=oppcards:GetNext()
			end

		end
		Duel.DisableShuffleCheck(false)

end
local aoj_tuners={}
function s.copyextra(e,tp,eg,ep,ev,re,r,rp)
		local location=LOCATION_EXTRA
		local to_limbo=Duel.GetMatchingGroup(aux.TRUE, tp, location, 0, nil)
		Duel.SendtoDeck(to_limbo, tp, -2, REASON_EFFECT)

		local oppcards=Duel.GetMatchingGroup(aux.TRUE, tp, 0, location, nil)

		if #oppcards>0 then
			local tc=oppcards:GetFirst()
			local newcard=nil
			while tc do

				newcard=Duel.CreateToken(tp, tc:GetCode())
				Duel.SendtoDeck(newcard, tp, SEQ_DECKTOP, REASON_EFFECT)

				tc=oppcards:GetNext()
			end

		end


end


function s.copydeck(e,tp,eg,ep,ev,re,r,rp)
		local location=LOCATION_DECK
		local to_limbo=Duel.GetMatchingGroup(aux.TRUE, tp, location, 0, nil)
		Duel.DisableShuffleCheck(true)
		Duel.SendtoDeck(to_limbo, tp, -2, REASON_EFFECT)

		local oppcardnum=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
		local oppcards=Duel.GetDecktopGroup(1-tp, oppcardnum)

		if #oppcards>0 then
			local tc=oppcards:GetFirst()
			local newcard=nil
			while tc do

				newcard=Duel.CreateToken(tp, tc:GetCode())
				Duel.SendtoDeck(newcard, tp, SEQ_DECKTOP, REASON_EFFECT)

				tc=oppcards:GetNext()
			end

		end

		Duel.DisableShuffleCheck(false)
end

function s.placeallyofjustices(e,tp,eg,ep,ev,re,r,rp)
	local allyofjustices={09888196,69461394,19204398,26593852}

	local newcard=nil
	for key,value in ipairs(allyofjustices) do

		for i = 1,3,1
			do
			    newcard=Duel.CreateToken(tp, value)
					Duel.SendtoDeck(newcard, tp, SEQ_DECKTOP, REASON_EFFECT)
			end

	end



end

local archetypes=nil

function s.morpharchetypes(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp, Card.IsType, tp, LOCATION_DECK+LOCATION_EXTRA, 0, 1, 1,false,nil,TYPE_MONSTER)
	Duel.ConfirmCards(1-tp, g)

	archetypes={g:GetFirst():Setcode()}


	local g2=Duel.GetMatchingGroup(Card.IsSetCard, tp, LOCATION_ALL, LOCATION_ALL, nil, 0x1)

	if #g2>0 then
		local tc=g2:GetFirst()
		while tc do
			for key,value in ipairs(archetypes) do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_ADD_SETCODE)
				e2:SetValue(value)
				tc:RegisterEffect(e2)
			end

			tc=g2:GetNext()
		end
	end


	local aojtunerstoadd={08233522,45586855,89386122,71438011,08822710,45033006,
												45450218,52265835,85876417,76650663,25771826,55982698,
												03648368,22371016,36629203,82377606,511001968}

	for key,value in ipairs(aojtunerstoadd) do

					newcard=Duel.CreateToken(tp, value)
					for key,value in ipairs(archetypes) do
						local e2=Effect.CreateEffect(e:GetHandler())
						e2:SetType(EFFECT_TYPE_SINGLE)
						e2:SetCode(EFFECT_ADD_SETCODE)
						e2:SetValue(value)
						newcard:RegisterEffect(e2)
					end

					table.insert(aoj_tuners,newcard)

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



function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id-100+2)>0 then return end
--
-- Once per turn, you can target 1 monster you control, reveal it's True Form (It is removed from the duel.)
--Special Summon 1 "Ally of Justice" Tuner Monster from outside the duel as either a Level 1, 2, 3 or 4 monster,
-- then until the end of this turn, all monsters on your opponent's Field and in their GY become LIGHT monsters.
	local b1=Duel.GetFlagEffect(tp,id-100+2)==0
			and Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_MZONE, 0, 1, nil)

	return aux.CanActivateSkill(tp) and (b1)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)


	-- Once per turn, you can target 1 monster you control, reveal it's True Form (It is removed from the duel.)
	--Special Summon 1 "Ally of Justice" Tuner Monster from outside the duel as either a Level 1, 2, 3 or 4 monster,
	-- then until the end of this turn, all monsters on your opponent's Field and in their GY become LIGHT monsters.
	local b1=Duel.GetFlagEffect(tp,id-100+2)==0
			and Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_MZONE, 0, 1, nil)

		-- local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,0)},
		-- 							  {b2,aux.Stringid(id,1)})
		-- op=op-1

		local op=0
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local mg=Duel.SelectMatchingCard(tp, aux.TRUE, tp, LOCATION_MZONE, 0, 1, 1,false,nil)


		if #mg>0 then
			Duel.SendtoDeck(mg, tp, -2, REASON_EFFECT)
			local ng=Group.CreateGroup()

			for i, v, remove in ripairs(aoj_tuners) do
				Group.AddCard(ng,v)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=ng:Select(tp,1,1,nil)

			for i, v, remove in ripairs(aoj_tuners) do
				if v:GetCode()==sg:GetFirst():GetCode() then
					remove()
				end
			end
			-- local newcard=Duel.CreateToken(tp, sg:GetFirst():GetCode())
			--
			-- for key,value in ipairs(archetypes) do
			-- 	local e2=Effect.CreateEffect(e:GetHandler())
			-- 	e2:SetType(EFFECT_TYPE_SINGLE)
			-- 	e2:SetCode(EFFECT_ADD_SETCODE)
			-- 	e2:SetValue(value)
			-- 	newcard:RegisterEffect(e2)
			-- end
			-- table.insert(aoj_tuners,newcard)

			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)

			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetValue(TYPE_TUNER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
			sg:GetFirst():RegisterEffect(e1)

			for key,value in ipairs(archetypes) do
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_ADD_SETCODE)
				e2:SetTargetRange(LOCATION_MZONE,0)
				e2:SetValue(value)
				e2:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e2,tp)
			end

			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_ADD_SETCODE)
			e3:SetTargetRange(LOCATION_MZONE,0)
			e3:SetValue(0x1)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)


			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e4:SetTargetRange(0,LOCATION_MZONE+LOCATION_GRAVE)
			e4:SetValue(ATTRIBUTE_LIGHT)
			e4:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e4,tp)
		end
			--opt register
			Duel.RegisterFlagEffect(tp,id-100+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)

end
end
