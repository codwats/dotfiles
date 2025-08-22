local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Configuration
local UPDATE_FREQUENCY = 120 -- Update frequency in seconds

-- Create the timer item
local toggl_timer = sbar.add("item", "widgets.toggl", {
	position = "center",
	icon = {
		string = "󱎫",
		color = colors.blue, -- Using your existing color scheme
		padding_right = 8,
		font = {
			style = settings.font.style_map["Regular"],
			size = 14.0,
		},
	},
	label = {
		string = "Loading...",
		color = colors.white,
		font = {
			style = settings.font.style_map["SemiBold"],
			size = 12.0,
		},
	},
	background = {
		color = colors.bg1,
		height = 26,
		corner_radius = 6,
	},
	padding_left = 10,
	padding_right = 10,
	update_freq = UPDATE_FREQUENCY,
})

-- Path to our shell script
local script_path = os.getenv("HOME") .. "/.config/sketchybar/helpers/toggl_fetcher.sh"

-- Function to format the displayed string
local function format_display(display_name, project_name, elapsed_time)
	-- Format with project only if it exists and differs from display name
	if project_name and project_name ~= "" and project_name ~= display_name then
		return display_name .. " [" .. project_name .. "] (" .. elapsed_time .. ")"
	else
		return display_name .. " (" .. elapsed_time .. ")"
	end
end

-- Update timer function
local function update_timer()
	-- Run the script to get toggl data
	sbar.exec(script_path, function(response)
		if not response or response == "" then
			toggl_timer:set({
				icon = { color = colors.red },
				label = { string = "No response" },
			})
			return
		end

		if response:match("^no_timer") then
			toggl_timer:set({
				icon = { color = colors.grey },
				label = { string = "No timer" },
			})
			return
		end

		-- Parse the response (format: running|display_name|project_name|time)
		local parts = {}
		for part in response:gmatch("[^|]+") do
			table.insert(parts, part)
		end

		if #parts >= 4 and parts[1] == "running" then
			local display_name = parts[2] or ""
			local project_name = parts[3] or ""
			local elapsed_time = parts[4] or "00:00:00"

			-- Update display based on what we got
			toggl_timer:set({
				icon = { color = colors.green },
				label = {
					string = format_display(display_name, project_name, elapsed_time),
					color = colors.white,
				},
			})
		else
			toggl_timer:set({
				icon = { color = colors.yellow },
				label = { string = "Parse error" },
			})
		end
	end)
end

-- Add click actions
toggl_timer:subscribe("mouse.clicked", function(env)
	sbar.exec("open -a Timery")
end)
-- toggl_timer:subscribe("mouse.clicked", function(env)
-- 	local button = tonumber(env.BUTTON)
--
-- 	if button == 1 then -- Left-click: Open Toggl in browser
-- 		sbar.exec("open -a Timery")
-- 	elseif button == 2 then -- Right-click: Stop current timer
-- 		toggl_timer:set({
-- 			label = { string = "Stopping..." },
-- 			icon = { color = colors.yellow },
-- 		})
--
-- 		-- Call our script with stop parameter
-- 		sbar.exec(script_path .. " stop", function(response)
-- 			if response and response:match("^stopped") then
-- 				toggl_timer:set({
-- 					icon = { color = colors.grey },
-- 					label = { string = "No timer" },
-- 				})
-- 			else
-- 				-- Update timer display (will show "No timer" if it was actually stopped)
-- 				update_timer()
-- 			end
-- 		end)
-- 	elseif button == 3 then -- Middle-click: Force refresh
-- 		toggl_timer:set({
-- 			label = { string = "Refreshing..." },
-- 		})
-- 		update_timer()
-- 	end
-- end)

-- Add a subtle pulse animation when timer is running
local function animate_pulse()
	sbar.exec(script_path, function(response)
		if response and response:match("^running") then
			-- Only animate if there's an active timer
			sbar.animate("sin", 120, function()
				toggl_timer:set({
					background = {
						color = colors.with_alpha(colors.bg1, 0.7),
					},
				})
			end)

			sbar.delay(120, function()
				sbar.animate("sin", 120, function()
					toggl_timer:set({
						background = {
							color = colors.bg1,
						},
					})
				end)
			end)
		end
	end)
end

-- Initial update
update_timer()

-- Set update events
toggl_timer:subscribe("routine", function()
	update_timer()
	animate_pulse()
end)

-- Bracket to make it look cohesive with other items
sbar.add("bracket", "widgets.toggl.bracket", { toggl_timer.name }, {
	background = { color = colors.bg1 },
})

-- Add padding for consistency with other widgets
sbar.add("item", "widgets.toggl.padding", {
	position = "right",
	width = settings.group_paddings,
})

return toggl_timer
