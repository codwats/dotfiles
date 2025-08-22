return {
	black = 0xff313244, -- surface0 #313244
	white = 0xffcdd6f4, -- text #cdd6f4
	red = 0xfff38ba8, -- red #f38ba8
	green = 0xffa6e3a1, -- green #a6e3a1
	blue = 0xff74c7ec, -- sapphire #74c7ec
	yellow = 0xfff9e2af, -- yellow #f9e2af
	orange = 0xfffab387, -- peach #fab387
	magenta = 0xffcba6f7, --mauve #cba6f7
	grey = 0xff6c7086, -- overlay0 #6c7086
	teal = 0xff94e2d5, -- teal #94e2d5
	transparent = 0x00000000,

	bar = {
		bg = 0xcc1e1e2e, -- base #1e1e2e
		border = 0xff181825, -- mantle #181825
	},
	popup = {
		bg = 0xcc1e1e2e, -- base #1e1e2e
		border = 0xff181825, -- mantle #181825
		card = 0xff313244, -- surface0 #313244
	},
	spaces = {
		active = 0xccb4befe, -- lavender #b4befe
		inactive = 0x806c7086, -- overlay0 #7f8490
	},
	bg1 = 0x80313244, -- surface0 #313244
	bg2 = 0xcc7f849c, -- overlay1 #7f849c

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
