local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer

-- Biến global lưu trữ tween hiện tại để có thể dừng lại khi cần
_G.CurrentFlyTween = nil

local Locations = {
    [1231] = {
        Spawn = CFrame.new(-5023.9, 371.4, -3191.4),
    },
    [31323] = {
        Spawn  = CFrame.new(100, 50, 200),
    },
}

local function fly(locationName, speed)
    -- 1. Kiểm tra xem PlaceId hiện tại có trong danh sách không
    local placeLocations = Locations[game.PlaceId]
    if not placeLocations or not placeLocations[locationName] then
        warn("❌ E101 " .. tostring(locationName))
        return
    end

    -- 2. Lấy thông tin nhân vật
    local char = Player.Character
    if not char then return end

    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildWhichIsA("Humanoid")
    if not root or not hum then return end

    -- 3. Hủy tween cũ nếu đang chạy
    if _G.CurrentFlyTween then
        _G.CurrentFlyTween:Cancel()
    end

    -- 4. Cấu hình trạng thái bay
    root.CanCollide = false
    hum.PlatformStand = true

    -- 5. Tính toán thời gian bay
    local targetCFrame = placeLocations[locationName]
    local distance = (targetCFrame.Position - root.Position).Magnitude
    local duration = distance / (speed or 300)

    -- 6. Tạo và chạy Tween
    _G.CurrentFlyTween = TweenService:Create(
        root,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        { CFrame = targetCFrame }
    )

    _G.CurrentFlyTween.Completed:Connect(function(state)
        -- Khôi phục trạng thái nhân vật khi bay xong hoặc bị hủy
        root.CanCollide = true
        hum.PlatformStand = false
        _G.CurrentFlyTween = nil

        -- Chỉ print "hello" khi bay đến nơi thành công
        if state == Enum.PlaybackState.Completed then
            print("hello")
        end
    end)

    _G.CurrentFlyTween:Play()
end

fly("Spawn")
