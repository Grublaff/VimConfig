# 🧠 Neovim Cheat Sheet – Filip's Custom Setup

A beginner-friendly reference for your current Neovim configuration.
Designed to feel like Rider / Windows IDE workflow.

---

## 🚦 Modes (Most Important Concept)

| Mode   | What it means         | How to enter                               |
| ------ | --------------------- | ------------------------------------------ |
| Normal | Commands & navigation | `Esc`                                      |
| Insert | Typing text           | `i` (before) / `a` (after)                 |
| Visual | Select text           | `v` (char) / `V` (line) / `Ctrl+V` (block) |

---

## 💾 Files & Exiting

| Action      | Shortcut           |
| ----------- | ------------------ |
| Save        | `Ctrl + S` or `:w` |
| Quit        | `:q`               |
| Save & Quit | `:wq`              |
| Force Quit  | `:qa!`             |

---

## 🧭 Movement (Normal Mode)

| Key     | Action                   |
| ------- | ------------------------ |
| h j k l | Left / Down / Up / Right |
| w / b   | Next / previous word     |
| 0 / $   | Start / end of line      |
| gg / G  | Top / Bottom of file     |

---

## 🪟 Windows-style Shortcuts (Your custom setup)

| Shortcut | Action                       |
| -------- | ---------------------------- |
| Ctrl + S | Save                         |
| Ctrl + Z | Undo                         |
| Ctrl + Y | Redo                         |
| Ctrl + C | Copy selection / line        |
| Ctrl + X | Cut selection / line         |
| Ctrl + V | Paste                        |
| Ctrl + A | Select all                   |
| Ctrl + F | Global search (project-wide) |

---

## 📁 File Explorer (nvim-tree)

| Action           | Shortcut          |
| ---------------- | ----------------- |
| Toggle file tree | `:NvimTreeToggle` |
| Open file        | `Enter`           |
| New file         | `a`               |
| Delete           | `d`               |
| Rename           | `r`               |

---

## 🔎 Project Management

| Action                 | Shortcut     |
| ---------------------- | ------------ |
| Pick project           | `<leader>pp` |
| Telescope project list | `<leader>fp` |
| Leader key             | `Space`      |

---

## 🧩 LSP (C# Intelligence)

| Action                         | Shortcut     |
| ------------------------------ | ------------ |
| Go to definition               | `gd`         |
| Hover docs                     | `K`          |
| Rename                         | `<leader>rn` |
| Code action (add using, fixes) | `<leader>ca` |
| Format file                    | `<leader>cf` |

> 💡 On save, C# files auto-organise `using` statements.

---

## ✂️ Multi Cursor (vim-visual-multi)

### Vertical cursors

| Action           | Shortcut    |
| ---------------- | ----------- |
| Add cursor below | Ctrl + Down |
| Add cursor above | Ctrl + Up   |

### Word-based

| Action                 | Shortcut         |
| ---------------------- | ---------------- |
| Select next occurrence | Ctrl + N         |
| Select all occurrences | Ctrl + Shift + N |
| Exit                   | Esc              |

> You can type normally with multiple cursors active.

---

## 🧱 Multi-line Editing (Vim native)

| Task                | Steps                                  |
| ------------------- | -------------------------------------- |
| Edit columns        | Ctrl+V → select → Shift+I → type → Esc |
| Append end of lines | Ctrl+V → select → Shift+A → type → Esc |

---

## ⚓ Harpoon (Quick file switching)

| Action           | Shortcut                    |
| ---------------- | --------------------------- |
| Add file         | `<leader>ha`                |
| Show menu        | `<leader>hh`                |
| Jump to slot 1–4 | `<leader>h1` → `<leader>h4` |

---

## 💻 Terminal

| Action         | Shortcut           |
| -------------- | ------------------ |
| Open terminal  | `<leader>t`        |
| Back to normal | Ctrl+\ then Ctrl+n |
| Close terminal | `:bd!`             |

---

## 🧠 Important to Remember

* Always hit **Esc** if something feels weird
* Normal mode = Control mode
* Insert mode = Typing mode
* Leader key = **Space bar**

---

## ✅ Minimum survival kit

If you remember only these, you're productive:

* `i` → type
* `Esc` → normal
* `Ctrl+S` → save
* `Ctrl+Z` → undo
* `Ctrl+F` → search
* `gd` → go to definition
* `Space + ca` → fix problems
* `Ctrl + Down` → multi cursor

---

🟢 From here you are officially IDE-powered inside Neovim.
Welcome to the dark side 😄
