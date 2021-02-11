local lib = {}
local comp = require "component"
local COIN_DAMAGE = 98 -- This should be the damage value for invar coins
    
-- get the first empty slot in the inventory attached to side
function lib.empty_slot(trans, side)
    local count = 1
    for i in trans.getAllStacks(side) do
        if i.name == nil then return count end
        count = count + 1
    end
    return nil
end

-- get total coins in inventory
function lib.total_coins(trans, side)
    local total = 0
    for i in trans.getAllStacks(side) do
        -- All thermal coins have the same name so you need to check the damage value to determine if the coin is right
        if i.name == "thermalfoundation:coin" and i.damage == COIN_DAMAGE then total = total + i.count end
    end
end

-- print the names of all items in transposer
function lib.print(trans, side)
    for i in trans.getAllStacks(side) do
        if i.name then print(i.name ..": "..i.size) end
    end
end

-- print the sides with valid inventories
function lib.valid_sides(trans)
    local tab = {}
    for i=0,5 do
        if trans.getInventorySize(i) and trans.getInventorySize(i) > 1 then table.insert(tab, {side=i, name=trans.getInventoryName(i)}) end
    end
   return tab 
end

-- charge x amount of coins
function lib.charge(trans, in_side, out_side, amount)
    if lib.total_coins(trans, in_side) >= amount then
        lib.find(trans, in_side, "thermalfoundation:coin", COIN_DAMAGE)
    end
end

-- get first stack of item, damage is optional (useful for finding coins)
function lib.find(trans, side, name, damage)
    local count = 1
   for i in trans.getAllStacks(side) do
      if i.name == name and (i.damage == damage or not damage) then
         return count
      else
          count = count + 1
      end
   end
   return nil
end

for i,v in pairs(lib.valid_sides(comp.transposer)) do
    print("Side: " .. v.side .. " Name: ".. v.name)
    lib.print(comp.transposer, v.side)
end

return lib
