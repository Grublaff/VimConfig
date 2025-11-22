-- =========================
-- Basic settings
-- =========================
vim.g.mapleader = " "  -- <leader> key is space

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    print("✅ Neovim config loaded")
  end,
})

-- =========================
-- Bootstrap lazy.nvim
-- =========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =========================
-- Plugins
-- =========================
require("lazy").setup({
  {
    "mg979/vim-visual-multi",
    branch = "master",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
  },
    -- Harpoon (quick file switching)
    {
      "ThePrimeagen/harpoon",
      branch = "harpoon2",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
    -- Project management (auto project root)
    {
      "ahmedkhalf/project.nvim",
    },
  
  {
    "folke/which-key.nvim",
  },
  {
    "lewis6991/gitsigns.nvim",
  },
  -- LSP
  { "neovim/nvim-lspconfig" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Treesitter (better syntax highlighting & indentation)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
})

-- =========================
-- Treesitter config
-- =========================
require("nvim-treesitter.configs").setup({
  ensure_installed = { "c_sharp", "lua", "json", "markdown" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- =========================
-- Completion (nvim-cmp)
-- =========================
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- =========================
-- LSP: C# with csharp-ls
-- -- =========================
-- local lspconfig = require("lspconfig")
-- local cmp_nvim_lsp = require("cmp_nvim_lsp")
-- local capabilities = cmp_nvim_lsp.default_capabilities()

-- lspconfig.csharp_ls.setup({
--   cmd = { "csharp-ls" }, -- uses the global dotnet tool
--   capabilities = capabilities,
--   on_attach = function(client, bufnr)
--     print("🔧 csharp-ls attached")
--     local opts = { buffer = bufnr, noremap = true, silent = true }

--     vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--     vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--     vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
--     vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
--   end,
-- })

-- vim.diagnostic.config({
--   virtual_text = true,
--   signs = true,
--   underline = true,
--   update_in_insert = false,
-- })
-- =========================
-- New-style LSP config (Neovim 0.11+)
-- =========================

-- If you're using nvim-cmp, keep this:
local cmp_nvim_lsp = require("cmp_nvim_lsp")

-- Global defaults for all LSPs
vim.lsp.config("*", {
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

-- C# specific config (csharp-ls)
vim.lsp.config("csharp_ls", {
  cmd = { "csharp-ls" }, -- uses your global dotnet tool
})

-- Enable C# LSP
vim.lsp.enable("csharp_ls")

-- Keymaps applied whenever any LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local opts = { buffer = bufnr, noremap = true, silent = true }

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)

    print("🔧 LSP attached to buffer " .. bufnr)
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.cs",
  callback = function()
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
  end,
})

-- Make Ctrl+Z behave like traditional Undo
vim.keymap.set("n", "<C-z>", "u", { noremap = true, silent = true })
vim.keymap.set("i", "<C-z>", "<C-o>u", { noremap = true, silent = true })

-- Optional: Ctrl+Y as Redo
vim.keymap.set("n", "<C-y>", "<C-r>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-y>", "<C-o><C-r>", { noremap = true, silent = true })
-- =========================
-- Windows-style keybindings
-- =========================

-- Enable system clipboard integration
vim.opt.clipboard = "unnamedplus"

-- CTRL+S to save
vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
  vim.cmd("w")
end, { noremap = true, silent = true })

-- CTRL+C to copy
vim.keymap.set("v", "<C-c>", '"+y', { noremap = true, silent = true })

-- CTRL+X to cut
vim.keymap.set("v", "<C-x>", '"+d', { noremap = true, silent = true })

-- CTRL+V to paste
vim.keymap.set({ "n", "i" }, "<C-v>", '"+p', { noremap = true, silent = true })
vim.keymap.set("v", "<C-v>", '"+p', { noremap = true, silent = true })

-- Optional: Copy whole line with Ctrl+C in normal mode
vim.keymap.set("n", "<C-c>", '"+yy', { noremap = true, silent = true })
-- Ctrl+F = Global search (project-wide)
vim.keymap.set("n", "<C-f>", function()
  require("telescope.builtin").live_grep()
end, { desc = "Global search" })
-- Ctrl+A = Select all
vim.keymap.set("n", "<C-a>", "ggVG", { noremap = true, silent = true })
vim.keymap.set("n", "<C-x>", '"+dd', { noremap = true, silent = true })

-- =========================
-- File explorer (nvim-tree)
-- =========================
require("nvim-tree").setup({
  view = {
    side = "left",
    width = 30,
  },
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
        file = true,
        folder = true,
        folder_arrow = true,
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  hijack_cursor = true,
  respect_buf_cwd = true,
})

require("lualine").setup({
  options = {
    theme = "catppuccin",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { "filename" },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

-- =========================
-- Gitsigns configuration
-- =========================
require("gitsigns").setup({
  signs = {
    add          = { text = "+" },
    change       = { text = "~" },
    delete       = { text = "_" },
    topdelete    = { text = "‾" },
    changedelete = { text = "~" },
  },
  current_line_blame = true,
})

-- =========================
-- which-key
-- =========================
local wk = require("which-key")
wk.setup({})
wk.register({
  ["<leader>f"] = { name = "+file/find" },
  ["<leader>g"] = { name = "+git" },
  ["<leader>d"] = { name = "+debug" },
  ["<leader>p"] = { name = "+project" },
}, { prefix = "<leader>" })

-- =========================
-- project.nvim
-- =========================
require("project_nvim").setup({
  detection_methods = { "lsp", "pattern" },
  patterns = { ".git", "package.json", "*.sln", "*.csproj" },
})

-- Optional: integrate with Telescope if you use it
pcall(function()
  require("telescope").load_extension("projects")
end)

-- Keybinding: open projects picker (if Telescope installed)
vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Find project" })

-- =========================
-- Harpoon
-- =========================
local harpoon = require("harpoon")

harpoon:setup()

-- Keymaps:
vim.keymap.set("n", "<leader>ha", function()
  harpoon:list():add()
end, { desc = "Harpoon: add file" })

vim.keymap.set("n", "<leader>hh", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: quick menu" })

-- Quick slots (like 1–4 main files)
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

-- =========================
-- Catppuccin setup
-- =========================
require("catppuccin").setup({
  flavour = "mocha", -- latte, frappe, macchiato, mocha
  transparent_background = false,
  integrations = {
    nvimtree = true,
    treesitter = true,
    gitsigns = true,
    which_key = true,
    lsp_saga = false,
    telescope = true,
  },
})

vim.cmd.colorscheme("catppuccin")

-- =========================
-- Project picker on startup
-- =========================
local projects_root = "C:/Users/Filip/Projects"  -- <- change if you want another folder

local function pick_project()
  local uv = vim.loop
  local dirs = {}

  local handle = uv.fs_scandir(projects_root)
  if not handle then
    vim.notify("Project root not found: " .. projects_root, vim.log.levels.ERROR)
    return
  end

  while true do
    local name, t = uv.fs_scandir_next(handle)
    if not name then break end
    if t == "directory" then
      table.insert(dirs, projects_root .. "/" .. name)
    end
  end

  if #dirs == 0 then
    vim.notify("No subfolders in " .. projects_root, vim.log.levels.WARN)
    return
  end

  vim.ui.select(dirs, { prompt = "Select project" }, function(choice)
    if not choice then return end
    vim.cmd("cd " .. choice)
    -- open current dir; you can change this to something else if you like
    vim.cmd("edit .")
    -- if you use nvim-tree, open it automatically:
    pcall(function() vim.cmd("NvimTreeOpen") end)
  end)
end

-- Command to open the picker manually
vim.api.nvim_create_user_command("PickProject", pick_project, {})

-- Auto-open project picker when starting nvim with no args
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      pick_project()
    end
  end,
})

-- Optional keybinding as well: <leader>pp
vim.keymap.set("n", "<leader>pp", pick_project, { desc = "Pick project" })

-- Always open nvim-tree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only open if starting without specific file
    if vim.fn.argc() == 0 then
      vim.cmd("NvimTreeOpen")
    end
  end,
})

-- Reopen nvim-tree if accidentally closed
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.fn.bufname() ~= "NvimTree_1" then
      local view = require("nvim-tree.view")
      if not view.is_visible() then
        vim.cmd("NvimTreeOpen")
      end
    end
  end,
})

-- =========================
-- Toggle terminal
-- =========================
vim.keymap.set("n", "<leader>t", function()
  vim.cmd("botright split | resize 15 | terminal")
end, { desc = "Open terminal" })

-- =========================
-- Multi-cursor configuration (vim-visual-multi)
-- =========================

vim.g.VM_maps = {
  ["Add Cursor Down"] = "<C-Down>",
  ["Add Cursor Up"]   = "<C-Up>",
}

-- =========================
-- Visual Multi cursor appearance
-- =========================

vim.g.VM_theme = "dark"

vim.cmd([[
  highlight VM_Mono guibg=#f5c2e7 guifg=#1e1e2e gui=bold
  highlight VM_Cursor guibg=#ff0000 guifg=#ffffff gui=bold
  highlight VM_Extend guibg=#a6e3a1 guifg=#1e1e2e gui=bold
  highlight VM_Insert guibg=#89b4fa guifg=#1e1e2e gui=bold
]])

vim.g.VM_set_statusline = 1