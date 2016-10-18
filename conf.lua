-- Configuration
function love.conf(t)
	t.title = "Space Fam"
	t.version = "0.10.1"
	t.author = "Shane Holden"
	t.window.width = 1056
	t.window.height = 672
	t.window.resizable = true
	t.console = false

	--disabled LOVE modules
	t.modules.physics = false
	t.modules.joystick = true
end