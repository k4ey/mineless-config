local function changeDirection()
    if VerticalMovementDirection == "up" then
        VerticalMovementDirection = "down"
    elseif VerticalMovementDirection == "down" then
        VerticalMovementDirection = "up"
    end
end


--- add no reset to once types
return {cb = changeDirection, options = {saveState = true}}
