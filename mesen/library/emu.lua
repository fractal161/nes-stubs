--- @meta

--- @class emu
emu = {}

--- ENUMS ---

--- Used by addEventCallback / removeEventCallback calls.
--- @enum eventType
---| 'reset' # Triggered when a soft reset occurs
---| 'nmi' # Triggered when an nmi occurs
---| 'irq' # Triggered when an irq occurs
---| 'startFrame' # Triggered at the start of a frame (cycle 0, scanline -1)
---| 'endFrame' # Triggered at the end of a frame (cycle 0, scanline 240)
---| 'codeBreak' # Triggered when code execution breaks (e.g. due to a breakpoint, etc.)
---| 'stateLoaded' # Triggered when a user manually loads a savestate
---| 'stateSaved' # Triggered when a user manually saves a savestate
---| 'inputPolled' # Triggered when the emulation core polls the state of the input devices for the next frame
---| 'spriteZeroHit' # Triggered when the PPU sets the sprite zero hit flag
---| 'scriptEnded' # Triggered when the current Lua script ends (script window closed, execution stopped, etc.)
emu.eventType = {
	reset = 0,
	nmi = 1,
	irq = 2,
	startFrame = 3,
	endFrame = 4,
	codeBreak = 5,
	stateLoaded = 6,
	stateSaved = 7,
	inputPolled = 8,
	spriteZeroHit = 9,
	scriptEnded = 10
}

--- Used by execute calls.
--- @enum executeCountType
--- | 'cpuCycles' # Count the number of CPU cycles
--- | 'ppuCycles' # Count the number of PPU cycles
--- | 'cpuInstructions' # Count the number of CPU instructions
emu.executeCountType = {
	cpuCycles = 0,
	ppuCycles = 1,
	cpuInstructions = 2
}

--- Used by addMemoryCallback / removeMemoryCallback calls.
--- @enum memCallbackType
--- | 'cpuRead' # Triggered when a read instruction is executed
--- | 'cpuWrite' # Triggered when a write instruction is executed
--- | 'cpuExec' # Triggered when any memory read occurs due to the CPU's code execution
--- | 'ppuRead' # Triggered when the PPU reads from its memory bus
--- | 'ppuWrite' # Triggered when the PPU writes to its memory bus
emu.memCallbackType = {
	cpuRead = 0,
	cpuWrite = 1,
	cpuExec = 2,
	ppuRead = 3,
	ppuWrite = 4
}

--- Used by read / write calls.
--- @enum memType
--- | 'cpu' # CPU memory - $0000 to $FFFF. Warning: Reading or writing to this memory type may cause side-effects!
--- | 'ppu' # PPU memory - $0000 to $3FFF. Warning: Reading or writing to this memory type may cause side-effects!
--- | 'palette' # Palette memory - $00 to $3F
--- | 'oam' # OAM memory - $00 to $FF
--- | 'secondaryOam' # Secondary OAM memory - $00 to $1F
--- | 'prgRom' # PRG ROM - Range varies by game
--- | 'chrRom' # CHR ROM - Range varies by game
--- | 'chrRam' # CHR RAM - Range varies by game
--- | 'workRam' # Work RAM - Range varies by game
--- | 'saveRam' # Save RAM - Range varies by game
--- | 'cpuDebug' # CPU memory - $0000 to $FFFF. Same as memType.cpu but does NOT cause any side-effects.
--- | 'ppuDebug' # PPU memory - $0000 to $3FFF. Same as memType.ppu but does NOT cause any side-effects.
emu.memType = {
	cpu = 0,
	ppu = 1,
	palette = 2,
	oam = 3,
	secondaryOam = 4,
	prgRom = 5,
	chrRom = 6,
	chrRam = 7,
	workRam = 8,
	saveRam = 9,
	cpuDebug = 256,
	ppuDebug = 257
}

--- Used by getAccessCounters calls.
--- @enum counterMemType
--- | 'nesRam'
--- | 'prgRom'
--- | 'workRam'
--- | 'saveRam'
emu.counterMemType = {
	nesRam = 0,
	prgRom = 1,
	workRam = 2,
	saveRam = 3
}

--- Used by getAccessCounters calls.
--- @enum counterOpType
--- | 'read'
--- | 'write'
--- | 'exec'
emu.counterOpType = {
	read = 0,
	write = 1,
	exec = 2
}

-- CALLBACKS --

--- Registers a callback function to be called whenever the specified event occurs.  
--- The callback function receives no parameters.
--- @param func function A Lua function.
--- @param event eventType 
--- @return integer # An integer value that can be used to remove the callback by calling removeEventCallback
function emu.addEventCallback(func, event) end

--- Removes a previously registered callback function.
--- @param reference integer The value returned by the call to addEventCallback.
--- @param event eventType
function emu.removeEventCallback(reference, event) end

--- Registers a callback function to be called whenever the specified event occurs.  
--- The callback function receives 2 parameters `address` and `value` that correspond to the address being written to or read from, and the value that is being read/written.  
---
--- For reads, the callback is called *after* the read is performed.  
--- For writes, the callback is called *before* the write is performed.  
---
--- If the callback returns an integer value, it will replace the value -- you can alter the results of read/write operation using this.
--- @param func function A Lua function
--- @param memCallback memCallbackType
--- @param startAddress integer Start of the CPU memory address range to register the callback on.
--- @param endAddress? integer End of the CPU memory address range to register the callback on.
--- @return integer # An integer value that can be uresd to remove the callback by calling removeMemoryCallback
function emu.addMemoryCallback(func, memCallback, startAddress, endAddress) end

--- Removes a previously registered callback function.
--- @param reference integer The value returned by the call to addMemoryCallback
--- @param memCallback memCallbackType
--- @param startAddress integer Start of the CPU memory address range to unregister the callback from.
--- @param endAddress? integer End of the CPU memory address range to unregister the callback from.
function emu.removeMemoryCallback(reference, memCallback, startAddress, endAddress) end

-- DRAWING --

--- Draws a pixel at the specified (x, y) coordinates using the specified color for a specific number of frames.
--- @param x integer X position
--- @param y integer Y position
--- @param color integer Color
--- @param duration integer Number of frames to display (Default: 1 frame)
--- @param delay integer Number of frames to wait before drawing the pixel (Default: 0 frames)
function emu.drawPixel(x, y, color, duration, delay) end

--- Draws a line between (x, y) to (x2, y2) using the specified color for a specific number of frames.
--- @param x integer X position (start of line)  
--- @param y integer Y position (start of line)  
--- @param x2 integer X position (end of line)  
--- @param y2 integer Y position (end of line)  
--- @param color integer Color  
--- @param duration integer Number of frames to display (Default: 1 frame)  
--- @param delay integer Number of frames to wait before drawing the line (Default: 0 frames)
function emu.drawLine(x, y, x2, y2, color, duration, delay) end

--- Draws a rectangle between (x, y) to (x+width, y+height) using the specified color for a specific number of frames.  
--- @param x integer X position  
--- @param y integer Y position
--- @param width integer The rectangle's width  
--- @param height integer The rectangle's height  
--- @param color integer Color  
--- @param fill boolean Whether or not to draw an outline, or a filled rectangle.  
--- @param duration integer Number of frames to display (Default: 1 frame)  
--- @param delay integer Number of frames to wait before drawing the rectangle (Default: 0 frames)
function emu.drawRectangle(x, y, width, height, color, fill, duration, delay) end

--- Draws text at (x, y) using the specified text and colors for a specific number of frames.
--- @param x integer X position  
--- @param y integer Y position  
--- @param text string The text to display  
--- @param textColor integer Color to use for the text  
--- @param backgroundColor integer Color to use for the text's background color  
--- @param duration integer Number of frames to display (Default: 1 frame)  
--- @param delay integer Number of frames to wait before drawing the text (Default: 0 frames)
function emu.drawString(x, y, text, textColor, backgroundColor, duration, delay) end

--- Removes all drawings from the screen.
function emu.clearScreen() end

--- Returns the color (in ARGB format) of the PPU's output for the specified location.
--- @param x integer X position  
--- @param y integer Y position    
--- @return integer # ARBG color
function emu.getPixel(x, y) end

--- Returns an array of ARGB values for the entire screen (256px by 240px) - can be used with [emu.setScreenBuffer()](#setscreenbuffer) to alter the frame.
--- @return table # 32-bit integers in ARBG format
function emu.getScreenBuffer() end

--- Replaces the current frame with the contents of the specified array.
--- @param screenBuffer table An array of 32-bit integers in ARGB format
function emu.setScreenBuffer(screenBuffer) end

-- EMULATION --
