-------------------------
-- Config my custom tools
-------------------------
-- Variables
local hyper = {"cmd","alt","ctrl"};
local hyperShift = {"cmd","alt","ctrl","shift"};
-------------------------
-- Own functions
-- Function for test alert show
function alertHelloWorld()
    hs.alert.show("Hello World")
end
-- Functions for use hyper in hotkey.bind
function h_bind(key, func) 
    hs.hotkey.bind(hyper, key, func)
end
-- Functions for use hyperShift in hotkey.bind
function hs_bind(key, func) 
    hs.hotkey.bind(hyperShift, key, func)
end
-- Function for check file exists
function file_exists(path)
    local f = io.open(path, "r")
    -- ~= is != in other language
    if f ~= nil then 
        io.close(f) 
        return true 
    else 
        return false
    end
end
-------------------------
-- Customized
-- Function for show alert Hello World
h_bind("W", alertHelloWorld);

-- Function to reload Hammerspoon
h_bind("r", hs.reload)

-- Function to show/hide console
hs_bind("r", hs.toggleConsole)

-- Function to launch app
function launchApp(name)
    return function()
        -- .. is concatenation string operator
        local path = '/Applications/' .. name .. '.app'
        if file_exists(path) then
            hs.application.launchOrFocus(path)
            return
        end
        path = '/System/Applications/' .. name .. '.app'
        if file_exists(path) then
            hs.application.launchOrFocus(path)
            return
        end
        path = '/System/Library/CoreServices/' .. name .. '.app'
        if file_exists(path) then
            hs.application.launchOrFocus(path)
            return
        end
        
        hs.alert.show("Ops!!! no pude abrir " .. path)
    end 
end
-- Open Visual Studio Code / Brave Browser / iTerm / Finder
h_bind("c", launchApp("Visual Studio Code"))
h_bind("b", launchApp("Brave Browser"))
h_bind("t", launchApp("iTerm"))
h_bind("f", launchApp("Finder"))
-------------------------
-- Windows customization (we need allow permissions to Hammerspoon in or system)
-- Disalow animation
hs.window.animationDuration = 0
-- Position window
function positionWindow(x, y, w,   h)
    return function()
        local win = hs.window.focusedWindow()
        if win == nil then return end
        local f = win:frame()
        local s = win:screen():frame()
        f.x = s.x + s.w * x
        f.y = s.y + s.h * y
        f.w = s.w * w
        f.h = s.h * h
        win:setFrame(f)
    end
end
-- Half window to left
h_bind("1", positionWindow(0, 0, 1/2, 1))
-- Half window to right
h_bind("2", positionWindow(1/2, 0, 1/2, 1))
-- Quarter window to top left, top right, bottom left, bottom right
h_bind("3", positionWindow(0, 0, 1/2, 1/2))
h_bind("4", positionWindow(1/2, 0, 1/2, 1/2))
h_bind("5", positionWindow(0, 1/2, 1/2, 1/2))
h_bind("6", positionWindow(1/2, 1/2, 1/2, 1/2))

hs.grid.setGrid('12x6')
hs.grid.setMargins('0x0')
-- Resize
h_bind("right", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    local screen = win:screen()
    local sg = hs.grid.getGrid(screen)
    local g = hs.grid.get(win)
    if g.x + g.w == sg.w then
        g.x = g.x + 1
        g.w = g.w - 1
    else
        g.w = g.w + 1
    end
    hs.grid.set(win, g)
end)
h_bind("left", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    local screen = win:screen()
    local sg = hs.grid.getGrid(screen)
    local g = hs.grid.get(win)
    if g.x + g.w >= sg.w and g.x ~= 0 then
        g.x = g.x -1
        g.w = g.w + 1
    else
        g.w = g.w - 1
    end
    hs.grid.set(win, g)
end)
h_bind("down", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    local screen = win:screen()
    local sg = hs.grid.getGrid(screen)
    local g = hs.grid.get(win)
    if g.y + g.h == sg.h then
        g.y = g.y + 1
        g.h = g.h - 1
    else
        g.h = g.h + 1
    end
    hs.grid.set(win, g)
end)
h_bind("up", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    local screen = win:screen()
    local sg = hs.grid.getGrid(screen)
    local g = hs.grid.get(win)
    if g.y + g.h >= sg.h and g.y ~= 0 then
        g.y = g.y -1
        g.h = g.h + 1
    else
        g.h = g.h - 1
    end
    hs.grid.set(win, g)
end)
-- Moving
hs_bind("right", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    hs.grid.pushWindowRight(win)
end)
hs_bind("left", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    hs.grid.pushWindowLeft(win)
end)
hs_bind("down", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    hs.grid.pushWindowDown(win)
end)
hs_bind("up", function()
    local win = hs.window.focusedWindow()
    if win == nil then return end
    hs.grid.pushWindowUp(win)
end)

-- Sppons 
-- https://www.hammerspoon.org/Spoons/
-- ClipboardTools
clipboardTool = hs.loadSpoon('ClipboardTool')
clipboardTool.paste_on_selected = true
clipboardTool.show_in_menubar = true
clipboardTool:start()
h_bind("v", function() clipboardTool:toggleClipboard() end)
hs_bind("v", function() clipboardTool:clearAll() end)

-- Show message after reload
hs.alert.show("Hammerspoon started ;)")
