local function SetBagItemGlow(bagId, slot)
	local item
	for i = 1, NUM_CONTAINER_FRAMES, 1 do
		local frame = _G["ContainerFrame"..i]
		if frame:GetID() == bagId and frame:IsShown() then
			item = _G["ContainerFrame"..i.."Item"..(GetContainerNumSlots(bagId) + 1 - slot)]
		end
	end
	if item then
		item.NewItemTexture:SetAtlas("bags-glow-orange")
		item.NewItemTexture:Show()
		item.flashAnim:Play()
		item.newitemglowAnim:Play()
	end
end

local function GlowCheapestGrey()
	local lastPrice, bagNum, slotNum
	for bag = 0, NUM_BAG_SLOTS do
		for bagSlot = 1, GetContainerNumSlots(bag) do
			local itemid = GetContainerItemID(bag, bagSlot)
			if itemid then
				local _, _, itemRarity, _, _, _, _, itemStackCount, _, _, vendorPrice = GetItemInfo(itemid)
				if itemRarity == 0 and vendorPrice > 0 then
					local _, itemCount = GetContainerItemInfo(bag, bagSlot)
					local totalVendorPrice = vendorPrice * itemCount
					if not lastPrice then
						lastPrice = totalVendorPrice
						bagNum = bag
						slotNum = bagSlot
					elseif lastPrice > totalVendorPrice then
						lastPrice = totalVendorPrice
						bagNum = bag
						slotNum = bagSlot
					end
				end
			end
		end
	end
	if bagNum and slotNum then
		SetBagItemGlow(bagNum, slotNum)
	end
end

local function OnEvent(self, event, key, state)
	if key == "LCTRL" and state == 1 then
		local bagOpen = false
		for bag = 0, NUM_BAG_SLOTS do
			if IsBagOpen(bag) then
				bagOpen = true
				break
			end
		end
		if bagOpen then
			GlowCheapestGrey()
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("MODIFIER_STATE_CHANGED")
f:SetScript("OnEvent", OnEvent)
