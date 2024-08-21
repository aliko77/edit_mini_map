-- test.lua

-- Load the script with the 'usePlacer' export
Citizen.CreateThread(function()
    Citizen.Wait(1000)
    RegisterCommand('test_minimap_placer', function()
        -- Start the minimap placer mode
        local data = exports['edit_mini_map']:usePlacer(1)
        lib.print.info(data)
    end, false)
end)
