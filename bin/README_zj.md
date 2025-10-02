# Zellij Session Manager (zj)

A tmuxinator-like tool for managing Zellij sessions with layouts.

## Installation

The script is already installed in `~/.bin/zj` and should be executable.

## Usage

### Interactive Mode (Default)
```bash
zj
```

This will show you:
1. List of active sessions (if any)
2. List of available layouts
3. Options to either attach to existing sessions or create new ones

### Command Line Options
```bash
zj --list    # List all active sessions
zj --kill    # Kill all sessions
zj --help    # Show help
```

## How It Works

1. **List Sessions**: Shows all active zellij sessions
2. **Attach to Session**: Select from existing sessions to attach
3. **Create New Session**: 
   - Select a layout from available layouts
   - Creates a new session using the layout name as the session name
   - Automatically opens the session

## Layouts

The script looks for layouts in these locations:
- Built-in layouts: `default`, `compact`, `strider`
- Custom layouts: `~/.config/zellij/layouts/*.kdl`

### Creating Custom Layouts

Create `.kdl` files in `~/.config/zellij/layouts/`. For example:

```kdl
// ~/.config/zellij/layouts/dev.kdl
layout {
    pane size=1 borderless=true {
        plugin location="tab-bar"
    }
    pane {
        pane split_direction="vertical" {
            pane {
                name "editor"
            }
            pane split_direction="horizontal" {
                pane {
                    name "terminal"
                }
                pane {
                    name "logs"
                }
            }
        }
    }
    pane size=1 borderless=true {
        plugin location="status-bar"
    }
}
```

This layout will appear as "dev" in the layout selection menu.

## Features

- ✅ Interactive menu system
- ✅ List and attach to existing sessions
- ✅ Create new sessions with custom layouts
- ✅ Automatic session naming (uses layout name)
- ✅ Support for both built-in and custom layouts
- ✅ Clean session name parsing (removes ANSI colors)
- ✅ Command line options for scripting
- ✅ Colored output for better UX

## Example Workflow

1. Run `zj`
2. If you have sessions, choose to attach or create new
3. If creating new, select from available layouts
4. Script automatically creates session named after the layout
5. You're dropped into the new zellij session

The session name will match the layout name, making it easy to identify and manage your sessions.
