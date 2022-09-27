--Kick-Off of Dreams

--bokita el mas grande papa
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

function s.flipop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SKILL_FLIP,tp,id|(1<<32))
	Duel.Hint(HINT_CARD,tp,id)
	s.place_field(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,0,0,0)
end

		--Set 1 "Stadium of Dreams" from outside the duel to your Field Spell Zone
function s.place_field(e,tp,eg,ep,ev,re,r,rp)
	local field=Duel.CreateToken(tp,81632124)
	Duel.SSet(tp, field)
end

function s.summonfilter(c,e,tp)
	return (Card.ListsCode(c, 450000110) or c:IsCode(450000111) or c:IsCode(450000112) or c:IsCode(810000059)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end

function s.alforonefilter(c)
	return c:IsCode(100000349) and c:IsSSetable()
end

function s.discardlevelfilter(c)
	return c:IsLevel(5) and c:IsAbleToGrave()
end

function s.levelfilter(c)
	return c:IsLevel(5) and c:IsFaceup()
end

function s.playmakerfilter(c)
	return c:IsCode(511000041) and c:IsFaceup()
end

function s.perfectpassfilter(c)
	return c:IsCode(810000060) and c:IsSSetable()
end
function s.flipcon2(e,tp,eg,ep,ev,re,r,rp)

	--OPT check
	if Duel.GetFlagEffect(tp,id+2)>0 and Duel.GetFlagEffect(tp, id+3)>0 and Duel.GetFlagEffect(tp, id+4)>0 then return end

	--Special Summon 1 monster that lists "Stadium of Dreams" in it's text from either your Hand or GY as either a level 4 or 5 monster.

	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.summonfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp, LOCATION_MZONE)>0

			-- Once per turn, if you control 2 level 5 monsters, you can send 1 Level 5 monster from your hand to the GY,
			--set 1 "All for One" from either your Deck or GY to your Spell/Trap Zone.

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.levelfilter,tp,LOCATION_MZONE,0,2,nil)
		and Duel.IsExistingMatchingCard(s.discardlevelfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.alforonefilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


		--Once per turn, if you control "Playmaker", you can set 1 "Perfect Pass" from your Deck or GY to your Spell/Trap Zone

		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsExistingMatchingCard(s.playmakerfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(s.perfectpassfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
			and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


	return aux.CanActivateSkill(tp) and (b1 or b2 or b3)
end
function s.flipop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	--Special Summon 1 monster that lists "Stadium of Dreams" in it's text from either your Hand or GY as either a level 4 or 5 monster.

	local b1=Duel.GetFlagEffect(tp,id+2)==0
			and Duel.IsExistingMatchingCard(s.summonfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp)
			and Duel.GetLocationCount(tp, LOCATION_MZONE)>0

			-- Once per turn, if you control 2 level 5 monsters, you can send 1 Level 5 monster from your hand to the GY,
			--set 1 "All for One" from either your Deck or GY to your Spell/Trap Zone.

	local b2=Duel.GetFlagEffect(tp, id+3)==0
		and Duel.IsExistingMatchingCard(s.levelfilter,tp,LOCATION_MZONE,0,2,nil)
		and Duel.IsExistingMatchingCard(s.discardlevelfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(s.alforonefilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil)
		and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


		--Once per turn, if you control "Playmaker", you can set 1 "Perfect Pass" from your Deck or GY to your Spell/Trap Zone

		local b3=Duel.GetFlagEffect(tp, id+4)==0
			and Duel.IsExistingMatchingCard(s.playmakerfilter,tp,LOCATION_MZONE,0,1,nil)
			and Duel.GetLocationCount(tp, LOCATION_SZONE)>0


		local op=Duel.SelectEffect(tp, {b1,aux.Stringid(id,0)},
									  {b2,aux.Stringid(id,1)},
									{b3,aux.Stringid(id,2)})
		op=op-1

	if op==0 then
		--Special Summon 1 monster that lists "Stadium of Dreams" in it's text from either your Hand or GY as either a level 4 or 5 monster.

		local g=Duel.SelectMatchingCard(tp,s.summonfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		if g then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			local lvl=Duel.AnnounceLevel(tp,4,5)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lvl)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:RegisterEffect(e1)
		end
			Duel.RegisterFlagEffect(tp,id+2,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==1 then

		-- Once per turn, if you control 2 level 5 monsters, you can send 1 Level 5 monster from your hand to the GY,
		--set 1 "All for One" from either your Deck or GY to your Spell/Trap Zone.
		local dis=Duel.SelectMatchingCard(tp,s.discardlevelfilter,tp,LOCATION_HAND,0,1,1,nil)

		if Duel.SendtoGrave(dis, REASON_EFFECT) then
			local tc=Duel.SelectMatchingCard(tp,s.alforonefilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
			Duel.SSet(tp, tc)
		end

		Duel.RegisterFlagEffect(tp,id+3,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	elseif op==2 then
		--Once per turn, if you control "Playmaker", you can set 1 "Perfect Pass" from your Deck or GY to your Spell/Trap Zone
		local tc=Duel.SelectMatchingCard(tp,s.perfectpassfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
		Duel.SSet(tp, tc)
		Duel.RegisterFlagEffect(tp,id+4,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
	end
end
