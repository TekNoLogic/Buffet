
local ids, bests, allitems, items, dirty = LibStub("tekIDmemo"), {}, {}, {
	bandage = "2581:114,8545:1104,21991:3400,14530:2000,6451:640,3531:301,1251:66,8544:800,21990:2800,14529:1360,6450:400,3530:161",
	hstone = "11951:800,5509:500,5510:800,5511:250,5512:100,9421:1200,19004:110,19005:120,19006:275,19007:300,19008:550,19009:600,19010:880,19011:960,19012:1320,19013:1440,22103:2080,22104:2288,22105:2496",
	mstone = "5513:600,5514:400,8007:850,8008:1100,22044:1250",
	hppot = "33934:2000,737:400,34440:2200,33092:2000,118:80,858:160,4596:160,929:320,1710:520,11562:670,3928:800,18839:800,13446:1400,31838:1400,31839:1400,31852:1400,31853:1400,28100:1400,23822:2000,22829:2000,32947:2000",
	mppot = "33935:2400,737:400,34440:2200,33093:2400,2455:160,3385:320,3827:520,6149:800,13443:1200,18841:1200,13444:1800,31840:1800,31841:1800,31854:1800,31855:1800,28101:1800,23823:2400,22832:2400,32948:2400,31677:3200",
	water = "34780:7200,33053:7200,18300:4200,21071:315,21153:882,2682:294,3448:294,13724:4410,20031:4410,19301:4410,28112:4410,1401:60,159:151,1179:436,17404:436,1205:835,9451:835,19299:835,1708:1344,4791:1344,10841:1344,17405:1344,1645:1992,19300:1992,8766:2934,23161:2934,28399:5100,27860:7200,29395:7200,24007:4200,30457:7200,29454:5100,29401:7200,24006:2934,23585:2934",
	food = "34780:7500,33053:7500,21071:155,21153:567,2682:294,3448:294,13724:2148,20031:2550,19301:4410,28112:4410,3448:294,17344:61,5473:294,17407:874,19225:2148,733:552,5526:552,7228:552,6316:243,13933:2148,16166:61,16167:243,16170:552,16171:2148,18255:1392,29412:4320,24338:2148,24408:4320,21235:50,19995:50,2679:61,17407:874,19305:552,19224:874,19223:61,19304:243,117:61,2287:243,2681:61,2685:552,3770:552,3771:874,4599:1392,5478:552,6890:243,8952:2148,19306:1392,9681:1392,9681:61,29451:7500,30610:4320,27854:4320,23495:61,17119:243,11444:2148,32685:7500,32686:7500,4604:61,4605:243,4606:552,4607:874,4608:1392,8948:2148,27859:4320,30355:7500,29453:7500,29450:7500,19994:50,22324:2148,4536:61,4537:243,4538:552,4539:874,4602:1392,8953:2148,16168:1392,21033:2148,21031:2148,21030:1392,29393:4320,27856:4320,19696:50,20857:61,4540:61,4541:243,4542:552,4544:874,16169:874,4601:1392,8950:2148,23160:2148,29394:7500,27855:4320,28486:4320,24072:243,30816:61,29449:7500,2070:61,414:243,17406:243,422:552,1707:874,3927:1392,8932:2148,27857:4320,29448:7500,30458:4320,19996:50,6316:243,21552:1392,16766:1392,2682:294,4592:243,4593:552,4594:874,5095:243,6290:61,6887:1392,787:61,8364:874,8957:2148,13546:1392,13930:1392,13935:2148,27661:4320,27858:4320,12238:243,13933:2148,29452:7500",
	conjfood = "34062:7500,1113:243,1114:552,1487:874,5349:61,8075:1392,8076:2148,22895:4320,22019:7500",
	conjwater = "34062:7200,5350:151,2288:436,2136:835,3772:1344,8077:1992,8078:2934,8079:4200,30703:5100,22018:7200",
	percfood = "19696:50,19994:50,19995:50,21235:50,19996:50,21537:100,20388:75,20389:75,20390:75,21215:100",
	percwater = "21537:100,20388:75,20389:75,20390:75,21215:100",
}


local function TableStuffer(...)
	local t = {}
	for i=1,select("#", ...) do
		local id, v = string.split(":", (select(i, ...)))
		t[tonumber(id)] = tonumber(v) or 0
		allitems[tonumber(id)] = tonumber(v) or 0
	end
	return t
end
for i,v in pairs(items) do bests[i], items[i] = {}, TableStuffer(string.split(" ,", v)) end


local function edit(name, food, pot, stone, shift)
	local macroid = GetMacroIndexByName(name)
	if not macroid then return end

	local body = "#showtooltip\n/use "
	if shift then body = body .. "[mod:shift,target=player] item:"..shift.."; " end
	if (pot and not stone) or (stone and not pot) then body = body .. "[combat] item:"..(pot or stone).."; " end
	body = body .. (pot and stone and "[nocombat] " or "").."item:"..(food or "6948")

	if pot and stone then body = body .. "\n/castsequence [combat,nomod] item:"..stone..", item:"..pot end

	EditMacro(macroid, name, 1, body, 1)
end


local function scan()
	for _,t in pairs(bests) do for i in pairs(t) do t[i] = nil end end
	local mylevel = UnitLevel("player")

	for bag=0,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local link = GetContainerItemLink(bag, slot)
			local id = link and ids[link]
			local _, _, _, _, reqlvl = link and GetItemInfo(link)
			if id and allitems[id] and (not reqlvl or reqlvl <= mylevel) then
				local _, stack = GetContainerItemInfo(bag,slot)
				for set,setitems in pairs(items) do
					local thisbest, val = bests[set], setitems[id]
					if val and (not thisbest.val or (thisbest.val < val or thisbest.val == val and thisbest.stack > stack)) then
						thisbest.id, thisbest.val, thisbest.stack = id, val, stack
					end
				end
			end
		end
	end

	edit("AutoHP", bests.conjfood.id or bests.percfood.id or bests.food.id or bests.hstone.id or bests.hppot.id, bests.hppot.id, bests.hstone.id, bests.bandage.id)
	edit("AutoMP", bests.conjwater.id or bests.percwater.id or bests.water.id or bests.mstone.id or bests.mppot.id, bests.mppot.id, bests.mstone.id)
	dirty = false
end


local f = CreateFrame("Frame")
f:SetScript("OnEvent", function(self, event, ...)
	if event ~= "PLAYER_REGEN_ENABLED" then dirty = true end
	if dirty and not InCombatLockdown() then scan() end
end)
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("BAG_UPDATE")

scan()

BUFFET_SCAN = scan
