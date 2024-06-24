ESX = nil

Items = {}
local DataStoresIndex = {}
local DataStores = {}
local SharedDataStores2 = {}

TriggerEvent("LandLife:GetSharedObject", function(obj)
  ESX = obj
end)

AddEventHandler("onMySQLReady", function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM data_inventory")
    local data = nil
    if #result ~= 0 then
      for i = 1, #result, 1 do
        local plate = result[i].plate
        local owned = result[i].owned
        local data = (result[i].data == nil and {} or json.decode(result[i].data))
        local dataStore = CreateDataStore(plate, owned, data)
        SharedDataStores2[plate] = dataStore
      end
   end
end)

function loadInvent2(plate)
  local result = MySQL.Sync.fetchAll("SELECT * FROM data_inventory WHERE plate = @plate", {["@plate"] = plate})
  local data = nil
  if #result ~= 0 then
    for i = 1, #result, 1 do
      local plate = result[i].plate
      local owned = result[i].owned
      local data = (result[i].data == nil and {} or json.decode(result[i].data))
      local dataStore = CreateDataStore(plate, owned, data)
      SharedDataStores2[plate] = dataStore
    end
  end
end

function MakeDataStore2(plate)
  local data = {}
  local owned = true
  local dataStore = CreateDataStore(plate, owned, data)
  SharedDataStores2[plate] = dataStore
  MySQL.Async.execute("INSERT INTO data_inventory(plate,data,owned) VALUES (@plate,'{}',@owned)", {
      ["@plate"] = plate,
      ["@owned"] = owned
    }
  )
  loadInvent2(plate)
end

function GetSharedDataStore2(plate)
  if SharedDataStores2[plate] == nil then
    MakeDataStore2(plate)
  end
  return SharedDataStores2[plate]
end

AddEventHandler("dataproperty:getSharedDataStore", function(plate, cb)
    cb(GetSharedDataStore2(plate))
end)