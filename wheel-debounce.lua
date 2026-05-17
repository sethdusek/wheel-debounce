libinput:register({1})

local MOUSE_NAME = "Compx LAMZU 4K Receiver"
local DEBOUNCE_TIME_MICROS = 50000
local last_wheel_timestamp = 0
local last_wheel_value = 0

local function signum(a)
    if a < 0 then
        return -1
    else
        return 1
    end
end

libinput:connect("new-evdev-device", function (device)
    if device:name() == MOUSE_NAME then
        -- Logged as an error since KWin seems to ignore anything from libinput with a lower log level (info, debug)
        libinput:log_error(string.format("wheel-debounce: Loaded for mouse %s", device:name()))
        device:connect("evdev-frame", function (device, frame, timestamp)
            for _, event in ipairs(frame) do
                if event.usage == evdev.REL_WHEEL_HI_RES or event.usage == evdev.REL_WHEEL then
                    local discard = false
                    if timestamp - last_wheel_timestamp < DEBOUNCE_TIME_MICROS and signum(event.value) ~= signum(last_wheel_value) then
                        discard = true
                    end
                    last_wheel_timestamp = timestamp
                    last_wheel_value = event.value
                    if discard then
                        return {}
                    end
                end
            end
            return frame
        end)
    end
end)
