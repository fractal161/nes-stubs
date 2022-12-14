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
--- @param duration? integer Number of frames to display (Default: 1 frame)
--- @param delay? integer Number of frames to wait before drawing the pixel (Default: 0 frames)
function emu.drawPixel(x, y, color, duration, delay) end

--- Draws a line between (x, y) to (x2, y2) using the specified color for a specific number of frames.
--- @param x integer X position (start of line)  
--- @param y integer Y position (start of line)  
--- @param x2 integer X position (end of line)  
--- @param y2 integer Y position (end of line)  
--- @param color integer Color  
--- @param duration? integer Number of frames to display (Default: 1 frame)  
--- @param delay? integer Number of frames to wait before drawing the line (Default: 0 frames)
function emu.drawLine(x, y, x2, y2, color, duration, delay) end

--- Draws a rectangle between (x, y) to (x+width, y+height) using the specified color for a specific number of frames.  
--- @param x integer X position  
--- @param y integer Y position
--- @param width integer The rectangle's width  
--- @param height integer The rectangle's height  
--- @param color integer Color  
--- @param fill boolean Whether or not to draw an outline, or a filled rectangle.  
--- @param duration? integer Number of frames to display (Default: 1 frame)  
--- @param delay? integer Number of frames to wait before drawing the rectangle (Default: 0 frames)
function emu.drawRectangle(x, y, width, height, color, fill, duration, delay) end

--- Draws text at (x, y) using the specified text and colors for a specific number of frames.
--- @param x integer X position  
--- @param y integer Y position  
--- @param text string The text to display  
--- @param textColor integer Color to use for the text  
--- @param backgroundColor integer Color to use for the text's background color  
--- @param duration? integer Number of frames to display (Default: 1 frame)  
--- @param delay? integer Number of frames to wait before drawing the text (Default: 0 frames)
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

--- @class Cpu
--- @field status integer
--- @field a integer
--- @field irqFlag integer
--- @field cycleCount integer
--- @field pc integer
--- @field y integer
--- @field x integer
--- @field sp integer
--- @field nmiFlag boolean

--- @class PpuCtrl
--- @field backgroundEnabled boolean
--- @field intensifyBlue boolean
--- @field intensifyRed boolean
--- @field backgroundPatternAddr integer
--- @field grayscale boolean
--- @field verticalWrite boolean
--- @field intensifyGreen boolean
--- @field nmiOnVBlank boolean
--- @field spritesEnabled boolean
--- @field spritePatternAddr integer
--- @field spriteMask boolean
--- @field largeSprites boolean
--- @field backgroundMask boolean

--- @class PpuStatus
--- @field spriteOverflow boolean
--- @field verticalBlank boolean
--- @field sprite0Hit boolean

--- @class PpuState
--- @field status integer
--- @field lowBitShift integer
--- @field xScroll integer
--- @field highBitShift integer
--- @field videoRamAddr integer
--- @field control integer
--- @field mask integer
--- @field tmpVideoRamAddr integer
--- @field writeToggle boolean
--- @field spriteRamAddr integer

--- @class Ppu
--- @field cycle integer
--- @field scanline integer
--- @field framecount integer
--- @field control PpuCtrl
--- @field status PpuStatus
--- @field stat PpuState

--- @class Envelope
--- @field counter integer
--- @field loop boolean
--- @field divider integer
--- @field volumne integer
--- @field startFlag boolean
--- @field constantVolume boolean

--- @class LengthCounter
--- @field halt boolean
--- @field counter integer
--- @field reloadValue integer

--- @class ApuSquare
--- @field outputVolume integer
--- @field frequency number
--- @field duty integer
--- @field period integer
--- @field enabled boolean
--- @field dutyPosition integer
--- @field sweepShift integer
--- @field sweepPeriod integer
--- @field sweepEnabled boolean
--- @field sweepNegate boolean
--- @field envelope Envelope
--- @field lengthCounter LengthCounter

--- @class ApuTriangle
--- @field outputVolume integer
--- @field frequency number
--- @field sequencePosition integer
--- @field period integer
--- @field enabled boolean
--- @field lengthCounter LengthCounter

--- @class ApuNoise
--- @field modeFlag boolean
--- @field enabled boolean
--- @field outputVolume integer
--- @field frequency number
--- @field period integer
--- @field shiftRegister integer
--- @field envelope Envelope
--- @field lengthCounter LengthCounter

--- @class ApuDmc
--- @field sampleLength integer
--- @field irqEnabled boolean
--- @field loop boolean
--- @field outputVolume integer
--- @field bytesRemaining integer
--- @field sampleAddr integer
--- @field period integer
--- @field sampleRate number

--- @class ApuFrameCounter
--- @field fiveStepMode integer
--- @field irqEnabled integer
--- @field sequencePosition integer

--- @class Apu
--- @field square1 ApuSquare
--- @field square2 ApuSquare
--- @field triangle ApuTriangle
--- @field noise ApuNoise
--- @field dmc ApuDmc
--- @field frameCounter ApuFrameCounter

--- @class Cart
--- @field selectedPrgPages integer[]
--- @field chrRomSize integer
--- @field chrRamSize integer
--- @field prgPageCount integer
--- @field chrPageSize integer
--- @field selectedChrPages integer[]
--- @field chrPageCount integer
--- @field prgRomSize integer
--- @field prgPageSize integer

--- @class EmuState
--- @field region integer
--- @field clockRate integer
--- @field cpu Cpu
--- @field ppu Ppu
--- @field apu Apu
--- @field cart Cart

--- Return a table containing information about the state of the CPU, PPU, APU, and cartridge.
--- @return EmuState # Current emulation state.
function emu.getState() end

--- Updates the CPU and PPU???s state. The state parameter must be a table in the same format as the one returned by getState()
--- Note: the state of the APU or cartridge cannot be modified by using setState().
--- @param state EmuState A table containing the state of the emulation to apply.
function emu.setState(state) end

--- Breaks the execution of the game and displays the debugger window.
function emu.breakExecution() end

--- Runs the emulator for the specified number of cycles/instructions and then breaks the execution.
--- @param count integer The number of cycles or instructions to run before breaking
--- @param executeType executeCountType
function emu.execute(count, executeType) end

--- Resets the current game.
function emu.reset() end

--- Stops and unloads the current game. When in test runner mode, this will also exit Mesen itself and the Mesen process will return the specified exit code.
--- @param exitCode integer The exit code that the Mesen process will return when exiting (when used in test runner mode)
function emu.stop(exitCode) end

--- Resumes execution after breaking.
function emu.resume() end

--- Instantly rewinds the emulation by the number of seconds specified.
--- Note: this can only be called from within a ???StartFrame??? event callback.
--- seconds integer The number of seconds to rewind
function emu.rewind(seconds) end

-- INPUT --

--- @class Input
--- @field a boolean
--- @field b boolean
--- @field select boolean
--- @field start boolean
--- @field up boolean
--- @field down boolean
--- @field left boolean
--- @field right boolean

--- Returns a table containing the status of all 8 buttons.
--- @param port integer The port number to read (0 to 3)
--- @return Input # A table containing the status of all 8 buttons.
function emu.getInput(port) end

--- Buttons enabled or disabled via setInput will keep their state until the next inputPolled event.
--- If a button???s value is not specified to either true or false in the input argument, then the player retains control of that button. For example, setInput(0, { select = false, start = false}) will prevent the player 1 from using both the start and select buttons, but all other buttons will still work as normal. To properly control the emulation, it is recommended to use this function within a callback for the inputPolled event. Otherwise, the inputs may not be applied before the ROM has the chance to read them.
--- @param port integer The port number to apply the input to (0 to 3)
--- @param input Input A table containing the state of some (or all) of the 8 buttons (same format as returned by getInput)
function emu.setInput(port, input) end

--- @class MouseState
--- @field x integer
--- @field y integer
--- @field left boolean
--- @field middle boolean
--- @field right boolean

--- Returns a table containing the position and the state of all 3 buttons.
--- @return MouseState
function emu.getMouseState() end

--- Returns whether or not a specific key is pressed. The ???keyName??? must be the same as the string shown in the UI when the key is bound to a button.
--- @param keyName string The name of the key to check
--- @return boolean # The key's state (true = pressed)
function emu.isKeyPressed(keyName) end

-- LOGGING -- 

--- Displays a message on the main window in the format ???[category] text???
--- @param category string The portion shown between brackets []
--- @param text string Text to show on the screen
function emu.displayMessage(category, text) end

--- Logs the given string in the script???s log window - useful for debugging scripts.
--- @param text string Text to log
function emu.log(text) end

-- MEMORY ACCESS --

--- Reads a value from the specified memory type.
---
--- When calling read with the memType.cpu or memType.ppu memory types, emulation side-effects may occur.
--- To avoid triggering side-effects, use the memType.cpuDebug or memType.ppuDebug types, which will not cause side-effects.
--- @param address integer The address/offset to read from.
--- @param memType memType The type of memory to read from.
--- @param signed? boolean If true, the value returned will be interpreted as a signed value.
function emu.read(address, memType, signed) end

--- Reads a value from the specified memory type.
---
--- When calling readWord with the memType.cpu or memType.ppu memory types, emulation side-effects may occur.
--- To avoid triggering side-effects, use the memType.cpuDebug or memType.ppuDebug types, which will not cause side-effects.
--- @param address integer The address/offset to read from.
--- @param memType memType The type of memory to read from.
--- @param signed? boolean If true, the value returned will be interpreted as a signed value.
function emu.readWord(address, memType, signed) end

--- Writes an 8-bit or 16-bit value to the specified memory type.
--- 
--- Normally read-only types such as PRG-ROM or CHR-ROM can be written to when using memType.prgRom or memType.chrRom.
--- Changes will remain in effect until a power cycle occurs.
--- To revert changes done to ROM, see revertPrgChrChanges.
--- 
--- When calling write with the memType.cpu or memType.ppu memory types, emulation side-effects may occur.
--- To avoid triggering side-effects, use the memType.cpuDebug or memType.ppuDebug types, which will not cause side-effects.
--- @param address integer The address/offset to write to.
--- @param value integer The value to write.
--- @param memType memType The type of memory to write to.
function emu.write(address, value, memType) end

--- Writes an 8-bit or 16-bit value to the specified memory type.
--- 
--- Normally read-only types such as PRG-ROM or CHR-ROM can be written to when using memType.prgRom or memType.chrRom.
--- Changes will remain in effect until a power cycle occurs.
--- To revert changes done to ROM, see revertPrgChrChanges.
--- 
--- When calling writeWord with the memType.cpu or memType.ppu memory types, emulation side-effects may occur.
--- To avoid triggering side-effects, use the memType.cpuDebug or memType.ppuDebug types, which will not cause side-effects.
--- @param address integer The address/offset to write to.
--- @param value integer The value to write.
--- @param memType memType The type of memory to write to.
function emu.writeWord(address, value, memType) end

--- Reverts all modifications done to PRG-ROM and CHR-ROM via write/writeWord calls.
function emu.revertPrgChrChanges() end

--- Returns an integer representing the byte offset of the specified CPU address in PRG ROM based on the mapper???s current configuration. Returns -1 when the specified address is not mapped to PRG ROM.
--- @param address integer A CPU address (Valid range: $0000-$FFFF)
--- @return integer # The corresponding byte offset in PRG ROM
function emu.getPrgRomOffset(address) end

--- Returns an integer representing the byte offset of the specified PPU address in CHR ROM based on the mapper???s current configuration. Returns -1 when the specified address is not mapped to CHR ROM.
--- @param address integer A PPU address (Valid range: $0000-$3FFF)
--- @return integer # The corresponding byte offset in CHR ROM
function emu.getChrRomOffset(address) end

--- Returns the address of the specified label. This address can be used with the memory read/write functions (read(), readWord(), write(), writeWord()) using the emu.memType.cpu or emu.memType.cpuDebug memory types.
--- @param label string The label to look up
--- @return integer # The corresponding CPU address
function emu.getLabelAddress(label) end

-- MISC --

--- Creates a savestate and returns it as a binary string. (The savestate is not saved on disk)
--- Note: this can only be called from within a ???startFrame??? event callback or ???cpuExec??? memory callback.
--- @return string # A string containing a binary blob representing the emulation's current state.
function emu.saveSavestate() end

--- Queues a save savestate request. As soon at the emulator is able to process the request, it will be saved into the specified slot.
--- This API is asynchronous because save states can only be taken in-between 2 CPU instructions, not in the middle of an instruction. When called while the CPU is in-between 2 instructions (e.g: inside the callback of an cpuExec or startFrame event), the save state will be taken immediately and its data will be available via getSavestateData right after the call to saveSavestateAsync.
--- The savestate can be loaded by calling the loadSavestateAsync function.
--- @param slotNumber integer A slot number to which the savestate data will be stored (slotNumber must be >= 0)
function emu.saveSavestateAsync(slotNumber) end

--- Loads the specified savestate.
--- Note: this can only be called from within a ???startFrame??? event callback or ???cpuExec??? memory callback.
--- @param savestate string A binary blob representing a savestate, as returned by saveSavestate()
function emu.loadSavestate(savestate) end

--- Queues a load savestate request. As soon at the emulator is able to process the request, the savestate will be loaded from the specified slot.
--- This API is asynchronous because save states can only be loaded in-between 2 CPU instructions, not in the middle of an instruction. When called while the CPU is in-between 2 instructions (e.g: inside the callback of an cpuExec or startFrame event), the savestate will be loaded immediately.
--- @param slotNumber integer The slot number to load the savestate data from (must be a slot number that was used in a preceding saveSavestateAsync call)
--- @return boolean # Returns true if the slot number was valid.
function emu.loadSavestateAsync(slotNumber) end

--- Returns the savestate stored in the specified savestate slot.
--- @param slotNumber integer The slot number to get the savestate data from (must be a slot number that was used in a preceding saveSavestateAsync call)
--- @return string # A binary string containing the savestate
function emu.getSavestateData(slotNumber) end

--- Clears the specified savestate slot (any savestate data in that slot will be removed from memory).
--- @param slotNumber integer The slot number to get the savestate data from (must be a slot number that was used in a preceding saveSavestateAsync call)
function emu.clearSavestateData(slotNumber) end

--- Activates a game genie cheat code (6 or 8 characters).
--- Note: cheat codes added via this function are not permanent and not visible in the UI.
--- @param cheatCode string A game genie format cheat code.
function emu.addCheat(cheatCode) end

--- Removes all active cheat codes (has no impact on cheat codes saved within the UI)
function emu.clearCheats() end

--- Returns an array of access counters for the specified memory and operation types.
--- @param counterMemType counterMemType
--- @param counterOpType counterOpType
function emu.getAccessCounters(counterMemType, counterOpType) end

--- Resets all access counters.
function emu.resetAccessCounters() end

--- Returns the same text as what is shown in the emulator???s Log Window.
--- @return string # A string containing the log shown in the log window
function emu.getLogWindowLog() end

--- @class RomInfo
--- @field name string Filename of the current ROM
--- @field path string Full path to the current ROM (including parent compressed archive when needed)
--- @field fileCrc32Hash integer The CRC32 value for the whole ROM file
--- @field fileSha1Hash string The SHA1 hash for the whole ROM file
--- @field prgChrCrc32Hash integer The CRC32 value for the file excluding its 16-byte header
--- @field prgChrMd5Hash string The MD5 hash for the file excluding its 16-byte header
--- @field format integer Value that represents the ROM format: 1 = iNES 2 = UNIF 3 = FDS 4 = NSF
--- @field isChrRam boolean true when the game uses CHR RAM false otherwise

--- Returns information about the ROM file that is currently running.
--- @return RomInfo # Information about the current ROM
function emu.getRomInfo() end

--- This function returns the path to a unique folder (based on the script???s filename) where the script should store its data (if any data needs to be saved).
--- The data will be saved in subfolders inside the LuaScriptData folder in Mesen???s home folder.
--- @return string The script's data folder
function emu.getScriptDataFolder() end

--- Takes a screenshot and returns a PNG file as a string.
--- The screenshot is not saved to the disk.
--- @return string # A binary string containing a PNG image.
function emu.takeScreenshot() end
