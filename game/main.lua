local IS_DEBUG = os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" and arg[2] == "debug"
if IS_DEBUG then
	require("lldebugger").start()

	function love.errorhandler(msg)
		error(msg, 2)
	end
end

function love.load()
    x = 100 
end

function love.update()
    x = x + 5
end

function love.draw()
    love.graphics.rectangle("line", x, 50, 200, 150)
end
