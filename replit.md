# Whispering Wilds - Text Adventure Game

## Overview
Whispering Wilds is a browser-based, static web text adventure game that uses PyScript (Pyodide) to run Python code directly in the browser. It offers an interactive console-style RPG experience, allowing players to explore a fantasy world, interact with NPCs, complete quests, craft items, and engage in combat. The game is self-contained in a single HTML file, making it ideal for GitHub Pages deployment without any build process or server requirements. Key features include a 10-level progression system, a micro-goal reward system, an expanded economy with gold sinks and item drops, advanced crafting, an achievement system, and a dynamic sound system.

## Recent Changes (October 2025)

### Critical Fixes (2025-10-09)
- **Fixed IndentationError in `_p13_cmd_buy` function**: Removed unreachable code block (lines 4780-4801) that existed after a `return True` statement, causing Python syntax errors
- **Fixed SyntaxError with `history_index` variable**: Moved `global history_index` declaration to the top of `_on_key` function to prevent "used prior to global declaration" error
- Game now loads successfully and is fully playable

### Previous Features
- Added buyback system (items you sell appear in a "Buyback" section at the shop so you can buy them back)
- Added sell command (can now sell items at Trading Post for gold - items sell for ~50% of shop price)
- Added gold display to inventory (typing "inv" now shows your gold amount)

### Previous Bug Fixes
- Fixed empty buy/sell commands (now show helpful messages instead of "Unknown command")
- Fixed buy command to support partial item names (e.g., "buy dagger" now works for "Iron Dagger")
- Added "trade" command alias (now works as shortcut for "shop" at the Trading Post)
- Fixed empty craft command (typing "craft" alone now shows helpful message instead of "Unknown command")
- Fixed leather armor functionality (now actually reduces damage by ~25% when in inventory during combat)
- Fixed advanced crafting system (leather armor, fishing rod, etc. now work - basic craft no longer blocks advanced recipes)
- Fixed healing potion and fish stew usage (consumables can now be used with "use potion" or "use stew" commands)
- Fixed consumables inventory display (healing potions, fish, gems, echo crystals now show in a "Consumables" section)
- Fixed consumable storage consistency (healing potions and fish stew now stored as integers consistently whether crafted or dropped from combat)
- Fixed drop command for consumables (can now drop healing potions, fish, gems, echo crystals with proper command handling)
- Fixed lore command memory system (now remembers all items/NPCs/rooms from visited locations)
- Fixed quest acceptance restrictions (only NPCs who offered quests can have them accepted)
- Fixed up/down movement (u/d/up/down commands now work alongside n/s/e/w for vertical navigation)
- Fixed take command without arguments (now shows proper error message instead of incorrectly matching NPCs)
- Fixed tutorial skip shortcut (now just "skip" works)

## User Preferences
Preferred communication style: Simple, everyday language.

## System Architecture
### Frontend Architecture
The game is a single-page static application, entirely contained within `index.html`, with embedded CSS and JavaScript. It features a console-style UI with a monospace font, auto-scrolling output, a command input field with history, quick-access button panels, and side panels for Quests, Map, Inventory, and Help. Client-side state management is handled via LocalStorage for persisting UI preferences and game saves, with auto-save/load functionality.

### Backend Architecture
The game logic runs entirely in-browser using PyScript/Pyodide (v2024.6.1), eliminating the need for server-side processing. The core game engine is structured around a `dispatch()` function for command parsing and a `println()` function for console output. Key systems include a parser with command aliasing, a 5x5 grid-based navigation, dialogue trees, a crafting system with 8+ recipes, resource gathering (forage, fish, mine), a turn-based combat system, bestiary tracking, 6 quest chains, 16 achievements, and a sound system utilizing the Web Audio API.

### Data Storage Solutions
All game state, player data, inventory, and quest progress are stored in-memory within Python objects. Persistence across sessions is achieved through JSON serialization for save/load functionality and LocalStorage for UI preferences. There is no database backend or authentication system.

## External Dependencies
### Core Runtime Dependencies
- **PyScript/Pyodide** (v2024.6.1): Used for executing Python game logic directly in the browser via WebAssembly. Delivered via CDN.

### Browser APIs
- **Web Storage API (LocalStorage)**: Utilized for persisting UI preferences, command history, and game save data.
- **DOM APIs**: Employed for direct manipulation of the HTML document to render output and handle user input.

### PWA Infrastructure
- **Web App Manifest** (`manifest.webmanifest`): Provides metadata for Progressive Web App (PWA) installation.

### No External Services
The project has no dependencies on third-party APIs, cloud services, analytics, or external CDN requirements beyond the PyScript runtime.

### Asset Dependencies
- **None**: All game content is embedded directly within the HTML file; there are no external image, audio, or data files.

## Running the Game
The game is configured to run on port 5000 using Python's built-in HTTP server:
```bash
python -m http.server 5000
```

Simply open your browser to `http://localhost:5000` to play the game. The game loads entirely in the browser via PyScript - no server-side processing required.
