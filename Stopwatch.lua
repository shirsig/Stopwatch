Stopwatch_frame_coordinates = { x = 0, y = 0 }
Stopwatch_is_visible = true

local REFRESH_INTERVAL = 0.05

local update_display

local last_update = 0

local running

local t0

local saved_time = 0

SLASH_STOPWATCH1 = '/stopwatch'
function SlashCmdList.STOPWATCH(cmd)
	if cmd == '' then
		if Stopwatch_is_visible then
			Stopwatch_frame:Hide()
			Stopwatch_is_visible = false
			t0 = nil
		else
			Stopwatch_frame:Show()
			Stopwatch_is_visible = true
		end
	end
end

function Stopwatch_on_update()
	if GetTime() - last_update > REFRESH_INTERVAL then
		last_update = GetTime()
		
		local seconds = (t0 and floor(GetTime() - t0) or 0) + saved_time
		local hours = floor(seconds / 3600)
		seconds = seconds - hours * 3600
		local minutes = floor(seconds / 60)
		seconds = seconds - minutes * 60
		
		update_display(hours, minutes, seconds)
	end
end

function Stopwatch_start()
	t0 = GetTime()
	running = true
end

function Stopwatch_stop()
	saved_time = floor(saved_time + GetTime() - t0)
	t0 = nil
	running = false
end

function Stopwatch_reset()
	saved_time = 0
	t0 = nil
	running = false
end

function update_display(hours, minutes, seconds)
	local function pad(number)
		return strlen(number) == 2 and number or '0' .. number
	end
	Stopwatch_frame_html:SetText(string.format(
			[[
			<html>
			<body>
				<h1 align="center">%s:%s:%s</h1>
			</body>
			</html>
			]],
			pad(hours),
			pad(minutes),
			pad(seconds)
	))
end




