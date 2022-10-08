big_aux={}

baux=big_aux

if not CustomArchetype then
	CustomArchetype = {}

	local MakeCheck=function(setcodes,archtable,extrafuncs)
		return function(c,sc,sumtype,playerid)
			sumtype=sumtype or 0
			playerid=playerid or PLAYER_NONE
			if extrafuncs then
				for _,func in pairs(extrafuncs) do
					if Card[func](c,sc,sumtype,playerid) then return true end
				end
			end
			if setcodes then
				for _,setcode in pairs(setcodes) do
					if c:IsSetCard(setcode,sc,sumtype,playerid) then return true end
				end
			end
			if archtable then
				if c:IsSummonCode(sc,sumtype,playerid,table.unpack(archtable)) then return true end
			end
			return false
		end
	end


	CustomArchetype.Kdr_legendary={
    74677422,06368038,43793530,49563947,78060096,CARD_SKULL_SERVANT,
		31447217,60862676,87322377, 47986555,78780140, 
		58538870, 12143771, 85936485, --the trio of the peasant
		03797883
  }

	Card.IsLegendary=MakeCheck(nil,CustomArchetype.Kdr_legendary)


  CustomArchetype.Jester={
    62962630,25280974,80275707,511000000,511000026,08487449,72992744,100000195,511000810,88722973,
  }



Card.IsJester=MakeCheck({0x152c},CustomArchetype.Jester)

end


if not baux.RushProcedure then
	baux.RushProcedure = {}
	bRush = baux.RushProcedure
end
if not bRush then
	bRush = baux.RushProcedure
end

function bRush.addrules()
  return function(e,tp,eg,ep,ev,re,r,rp)
    --Disable left and right-most zones
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_DISABLE_FIELD)
    e2:SetOperation(bRush.disabledzones)
    Duel.RegisterEffect(e2,tp)

    --Draw till you have 5 cards in hand
    local e3=Effect.CreateEffect(e:GetHandler())
    e3:SetType(EFFECT_TYPE_FIELD)
    e3:SetCode(EFFECT_DRAW_COUNT)
    e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e3:SetTargetRange(1,0)
    e3:SetValue(bRush.getcarddraw)
    Duel.RegisterEffect(e3,tp)

    --Give almost infinite normal summons
    local e4=Effect.CreateEffect(e:GetHandler())
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
    e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e4:SetTargetRange(1,0)
    e4:SetValue(999999999)
    Duel.RegisterEffect(e4,tp)

    --skip MP2

    local e5=Effect.CreateEffect(e:GetHandler())
    e5:SetType(EFFECT_TYPE_FIELD)
    e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e5:SetCode(EFFECT_SKIP_M2)
    e5:SetTargetRange(1,0)
    Duel.RegisterEffect(e5,tp)

    --skip SP

    --local e7=Effect.CreateEffect(e:GetHandler())
    --e7:SetType(EFFECT_TYPE_FIELD)
    --e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    --e7:SetCode(EFFECT_SKIP_SP)
    --e7:SetTargetRange(1,0)
    --Duel.RegisterEffect(e7,tp)

    --disable EMZs
    local e6=Effect.CreateEffect(e:GetHandler())
    e6:SetType(EFFECT_TYPE_FIELD)
    e6:SetCode(EFFECT_FORCE_MZONE)
    e6:SetRange(LOCATION_MZONE)
    e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e6:SetTargetRange(1,0)
    e6:SetValue(bRush.znval)
    Duel.RegisterEffect(e6,tp)

    --give infinite hand size
    local e7=Effect.CreateEffect(e:GetHandler())
    e7:SetType(EFFECT_TYPE_FIELD)
    e7:SetCode(EFFECT_HAND_LIMIT)
    e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e7:SetTargetRange(1,0)
    e7:SetValue(100)
    Duel.RegisterEffect(e7,tp)
  end
end

function bRush.getcarddraw(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0) < 5 then
		return 5-Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)
	else
		return 1
end
end

function bRush.znval(e)
	return ~(0x60)
end


function bRush.disabledzones(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandlerPlayer()==tp then
			return 0x00001111
	else
			return 0x11110000
	end
end


if not kdr then

	kdr_aux={}

	kdr=kdr_aux


	function kdr.IsQuestDone(tp)
		return Duel.GetFlagEffect(tp, 81632500)>0
	end

	function kdr.CompleteQuest(tp,card,e)
		Duel.RegisterFlagEffect(tp, 81632500, 0, 0, 0)

		Duel.RaiseEvent(card, EVENT_CUSTOM+81632500, e, REASON_RULE, tp, tp, 1)
	end

	function kdr.GetDex(tp)
		return Duel.GetFlagEffect(tp, 81632650)
	end

	function kdr.GetCon(tp)
		return Duel.GetFlagEffect(tp, 81632651)
	end

	function kdr.GetStr(tp)
		return Duel.GetFlagEffect(tp, 81632652)
	end





end
