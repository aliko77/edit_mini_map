--variables
local enabled = false
local minimapScale = 0.0
local minimapBlurScale = 0.0
local minimapOffsetX = 0.0
local minimapOffsetY = 0.0
local clipType = 0

local positions = {
    [0] = {
        minimap = {
            x = -0.007, y = -0.075, w = 0.1685, h = 0.19
        },
        minimap_blur = {
            x = -0.0085, y = -0.045, w = 0.27, h = 0.3
        },
    },
    [1] = {
        minimap = {
            x = 0.0085, y = -0.075, w = 0.14, h = 0.18
        },
        minimap_blur = {
            x = 0.007, y = -0.075, w = 0.14, h = 0.18
        },
    },
}

local function updateMinimap()
    -- Update the minimap position
    SetMinimapComponentPosition('minimap', 'L', 'B',
        positions[clipType].minimap.x + minimapOffsetX,
        positions[clipType].minimap.y + minimapOffsetY,
        positions[clipType].minimap.w + minimapScale,
        positions[clipType].minimap.h + minimapScale
    )
    -- Update the blur background of the minimap
    SetMinimapComponentPosition('minimap_blur', 'L', 'B',
        positions[clipType].minimap_blur.x + minimapOffsetX,
        positions[clipType].minimap_blur.y + minimapOffsetY,
        positions[clipType].minimap_blur.w + minimapBlurScale,
        positions[clipType].minimap_blur.h + minimapBlurScale
    )
end

local function showTextUI()
    lib.showTextUI(
        ('Edit Mini Map:         \n') ..
        '[Arrow Keys] -> Move    \n' ..
        '[+] -> +Scale           \n' ..
        '[-] -> -Scale           \n' ..
        '[ENTER] - Done Editing  \n' ..
        '[SHIFT] - Faster  \n' ..
        '[CTRL] - Slower  \n'
    )
end

local function hideTextUI()
    lib.hideTextUI()
end

local function placerLoop()
    updateMinimap()
    while enabled do
        local up = false
        local moveSpeed = 0.0005

        -- Check for Shift or Ctrl being pressed to adjust speed
        if IsControlPressed(0, 21) then     -- Shift key (default speed x2)
            moveSpeed = 0.002
        elseif IsControlPressed(0, 36) then -- Ctrl key (default speed x0.5)
            moveSpeed = 0.00025
        end

        if IsControlPressed(0, 172) then -- Arrow Up
            minimapOffsetY = minimapOffsetY - moveSpeed
            up = true
        end
        if IsControlPressed(0, 173) then -- Arrow Down
            minimapOffsetY = minimapOffsetY + moveSpeed
            up = true
        end
        if IsControlPressed(0, 174) then -- Arrow Left
            minimapOffsetX = minimapOffsetX - moveSpeed
            up = true
        end
        if IsControlPressed(0, 175) then -- Arrow Right
            minimapOffsetX = minimapOffsetX + moveSpeed
            up = true
        end
        if IsControlPressed(0, 96) then                   -- Keypad +
            minimapScale = minimapScale + 0.005
            minimapBlurScale = minimapBlurScale + 0.00475 -- Adjust this value as needed
            up = true
        end
        if IsControlPressed(0, 97) then                   -- Keypad -
            minimapScale = minimapScale - 0.005
            minimapBlurScale = minimapBlurScale - 0.00475 -- Adjust this value as needed
            up = true
        end
        if up then
            updateMinimap()
        end
        Citizen.Wait(16)
    end
end

local function stopEditing()
    enabled = false
    hideTextUI()
    return { offsetX = minimapOffsetX, offsetY = minimapOffsetY, scale = minimapScale }
end

-- exports
local function usePlacer(_clipType)
    if enabled then
        print("Minimap placer is already active.")
        return false
    end
    -- Reset
    minimapScale = 0.0
    minimapBlurScale = 0.0
    minimapOffsetX = 0.0
    minimapOffsetY = 0.0
    --<
    clipType = _clipType or 0
    DisplayRadar(true)
    -- Enable the placer and show UI instructions
    enabled = true
    showTextUI()
    -- Start the placer loop for real-time adjustments
    placerLoop()
    -- Hide radar and activate big map to refresh the minimap display
    DisplayRadar(false)
    SetBigmapActive(true, false)
    -- Wait for the map refresh to take effect
    Wait(100)
    -- Deactivate big map and redisplay the minimap
    SetBigmapActive(false, false)
    DisplayRadar(true)
    -- Finalize and return the minimap configuration
    return stopEditing()
end
exports('usePlacer', usePlacer)

lib.addKeybind({
    name = '_map_placer_done',
    description = 'Finalize the minimap placement',
    defaultKey = 'return',
    onPressed = function(self)
        if not enabled then return end
        stopEditing()
    end
})
