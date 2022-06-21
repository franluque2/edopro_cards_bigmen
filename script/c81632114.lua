--Ｄスケイル・トーピード
--D-Scale Torpedo
--scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x579))

	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(54514594,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.mvchk)
		Duel.RegisterEffect(ge1,0)
	end)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetCountLimit(1)
	e3:SetValue(s.valcon)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(s.value)
	c:RegisterEffect(e4)
end
s.listed_series={0x579}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipTarget():GetFlagEffect(id+1000)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetEquipTarget():GetFlagEffect(id+1000)*800,REASON_EFFECT)
end
function s.mvchk(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		if not tc:GetFlagEffectLabel(id) then
			tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetSequence())
		elseif tc:GetSequence()~=tc:GetFlagEffectLabel(id) or tc:GetControler()~=tc:GetPreviousControler() then
			tc:SetFlagEffectLabel(id,tc:GetSequence())
			tc:RegisterFlagEffect(id+1000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
	end
end

function s.valcon(e,re,r,rp)
	if ((r&REASON_BATTLE)~=0 or (r&REASON_EFFECT)) then
		return true
	else return false end
end

function s.value(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	if ec:IsType(TYPE_LINK) then
			return 200*ec:GetLink()
	else
		return 0
	end
end