libinput:register({1})

local MOUSE_NAME = "Compx LAMZU 4K Receiver"
local DEBOUNCE_TIME_MICROS = 100000
local last_wheel_timestamp = 0
local last_wheel_value = 0

libinput:connect("new-evdev-device", function (device)
    if device:name() == MOUSE_NAME then
        -- Logged as an error since KWin seems to ignore anything from libinput with a lower log level (info, debug)
        libinput:log_error(string.format("wheel-debounce: Loaded for mouse %s", device:name()))
        device:connect("evdev-frame", function (device, frame, timestamp)
            local events = {}
            for _, event in ipairs(frame) do
                if event.usage == evdev.REL_WHEEL_HI_RES or event.usage == evdev.REL_WHEEL then
                    if timestamp - last_wheel_timestamp < DEBOUNCE_TIME_MICROS and (event.value < 0) ~= (last_wheel_value < 0) then
                        goto continue
                    end
                    last_wheel_timestamp = timestamp
                    last_wheel_value = event.value
                end
                table.insert(events, {usage = event.usage, value = event.value})
                ::continue::
            end
            if #events > 0 then
                device:append_frame(events)
            end
            return {}
        end)
    end
end)
