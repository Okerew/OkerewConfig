call plug#begin('~/.local/share/nvim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'romgrk/barbar.nvim'
Plug 'dense-analysis/ale'
Plug 'tibabit/vim-templates'
Plug 'nvim-orgmode/orgmode'
Plug 'morhetz/gruvbox'
Plug 'jbyuki/instant.nvim'
Plug 'chipsenkbeil/distant.nvim', { 'branch': 'v0.3' }
Plug 'stevearc/conform.nvim'
Plug 'lervag/vimtex'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'goerz/jupytext.nvim'
Plug 'jiaoshijie/undotree'
Plug 'rcarriga/nvim-notify'
Plug 'simrat39/symbols-outline.nvim'
Plug 'github/copilot.vim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }
Plug 'hat0uma/csvview.nvim'
Plug 'brianhuster/live-preview.nvim'
Plug 'Okerew/depramanager-nvim'
Plug 'nvim-orgmode/org-bullets.nvim'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}

call plug#end()

" === SETTINGS ===
let mapleader = " "             " Use space as leader (I prefer space, changed from comma for consistency)
set clipboard=unnamedplus      " Use system clipboard
set number                    " Show line numbers
colorscheme gruvbox      " Default colorscheme
set fillchars=eob:\ 
:setlocal spell
:setlocal spelllang=en_us
autocmd BufReadPost,BufNewFile * Copilot disable

" === KEYMAPS ===
" Buffer navigation
nnoremap gt :bnext<CR>
nnoremap gT :bprev<CR>

" Disable 'Q' in normal mode (usually ex mode, to avoid mistakes)
nnoremap Q <nop>

" Move selected lines up/down in visual mode
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Join lines without moving cursor
nnoremap J mzJ`z

" Scroll and center cursor
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Search results center screen
nnoremap n nzzzv
nnoremap N Nzzzv

" Quickfix navigation centered
nnoremap <C-k> :cnext<CR>zz
nnoremap <C-j> :cprev<CR>zz

" Location list navigation centered
nnoremap <leader>k :lnext<CR>zz
nnoremap <leader>j :lprev<CR>zz

" Substitute word under cursor globally and ignore case
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Delete without yank (blackhole)
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Surround text with '=' (for example)
nnoremap =ap ma=ap'a

" Paste over visual selection without yanking replaced text
xnoremap <leader>p "_dP

" Shortcuts
noremap <leader>f :Telescope find_files<CR>
noremap <leader>t :NvimTreeOpen<CR>
noremap <leader>[ :tab new<CR>
noremap <leader>] :bd<CR>
noremap <leader>u :lua require('undotree').toggle()<CR>
noremap <leader>l :Telescope live_grep<CR>
noremap <leader>o :SymbolsOutline<CR>
noremap <leader>p :LivePreview start<CR>

" Command alias for Gitsigns
command! -nargs=* Gits Gitsigns <args>
command! -nargs=* Ha HopAnywhere <args> 

let g:auto_pairs_map = {'(': ')', '[': ']', '{': '}', '"': '"', "'": "'"}

let g:vimtex_view_method = 'zathura'
let g:vimtex_view_zathura_use_synctex = 0
" Gitsigns
lua << EOF
require('gitsigns').setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,
  numhl      = false,
  linehl     = false,
  word_diff  = false,
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol',
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  preview_config = {
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}
EOF

" ALE settings
let g:ale_completion_enabled = 1

let g:ale_linters = {
\   'python': ['flake8'],
\   'javascript': ['eslint'],
\   'c': ['clangtidy'],
\   'cpp': ['clangtidy'],
\   'go': ['golangci-lint'],
\   'rust': ['clippy'],
\}


lua << EOF
require("distant"):setup()
EOF

lua <<EOF
require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    go = { "gofmt", "goimports" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf })
  end,
})
EOF

lua << EOF
require("nvim-tree").setup()
EOF

lua << EOF
opts = {
  jupytext = 'jupytext',
  format = "markdown",
  update = true,
  filetype = require("jupytext").get_filetype,
  new_template = require("jupytext").default_new_template(),
  sync_patterns = { '*.md', '*.py', '*.jl', '*.R', '*.Rmd', '*.qmd' },
  autosync = true,
  handle_url_schemes = true,
}
require("jupytext").setup(opts)
EOF

lua << EOF
local undotree = require('undotree')

undotree.setup({
  float_diff = true,  -- using float window previews diff, set this `true` will disable layout option
  layout = "left_bottom", -- "left_bottom", "left_left_bottom"
  position = "left", -- "right", "bottom"
  ignore_filetype = { 'undotree', 'undotreeDiff', 'qf', 'TelescopePrompt', 'spectre_panel', 'tsplayground' },
  window = {
    winblend = 30,
  },
  keymaps = {
    ['j'] = "move_next",
    ['k'] = "move_prev",
    ['gj'] = "move2parent",
    ['J'] = "move_change_next",
    ['K'] = "move_change_prev",
    ['<cr>'] = "action_enter",
    ['p'] = "enter_diffbuf",
    ['q'] = "quit",
  },
})
EOF


lua << EOF
require('orgmode').setup({
  org_agenda_files = '~/orgfiles/**/*',
  org_default_notes_file = '~/orgfiles/refile.org',
})
EOF

lua << EOF
require("org-bullets").setup {
  concealcursor = false,
  symbols = {
    list = "•",
    headlines = {
      { "◉", "MyBulletL1" },
      { "○", "MyBulletL2" },
      { "✸", "MyBulletL3" },
      { "✿", "MyBulletL4" },
    },
    checkboxes = {
      half = { "", "@org.checkbox.halfchecked" },
      done = { "✓", "@org.keyword.done" },
      todo = { "˟", "@org.keyword.todo" },
    },
  }
}
EOF


lua << EOF
-- nvim-notify setup
require("notify").setup({
  -- Animation style (see below for options)
  stages = "fade_in_slide_out",
  
  -- Function called when a new window is opened, use for changing win settings/config
  on_open = nil,
  
  -- Function called when a window is closed
  on_close = nil,
  
  -- Render function for notifications. See notify-render()
  render = "default",
  
  -- Default timeout for notifications
  timeout = 500,
  
  -- For stages that change opacity this is treated as the highlight behind the window
  -- Set this to either a highlight group, an RGB hex value e.g. "#000000" or a function returning an RGB code for dynamic values
  background_colour = "Normal",
  
  -- Minimum width for notification windows
  minimum_width = 50,
  
  -- Icons for the different levels
  icons = {
    ERROR = "",
    WARN = "",
    INFO = "",
    DEBUG = "",
    TRACE = "✎",
  },
})

-- Set nvim-notify as the default notification handler
vim.notify = require("notify")

local blocked_prefixes = {
  "config.mappings.show_system_prompt",
  "config.mappings.show_user_selection",
  "'canary' branch is deprecated",
}

vim.notify = function(msg, level, opts)
  for _, prefix in ipairs(blocked_prefixes) do
    if msg:sub(1, #prefix) == prefix then
      return
    end
  end
  vim.schedule(function()
    vim.api.nvim_echo({{msg}}, true, {})
  end)
end

EOF

lua << EOF
local opts = {
  highlight_hovered_item = true,
  show_guides = true,
  auto_preview = false,
  position = 'right',
  relative_width = true,
  width = 25,
  auto_close = false,
  show_numbers = false,
  show_relative_numbers = false,
  show_symbol_details = true,
  preview_bg_highlight = 'Pmenu',
  autofold_depth = nil,
  auto_unfold_hover = true,
  fold_markers = { '', '' },
  wrap = false,
  keymaps = { -- These keymaps can be a string or a table for multiple keys
    close = {"<Esc>", "q"},
    goto_location = "<Cr>",
    focus_location = "o",
    hover_symbol = "<C-space>",
    toggle_preview = "K",
    rename_symbol = "r",
    code_actions = "a",
    fold = "h",
    unfold = "l",
    fold_all = "W",
    unfold_all = "E",
    fold_reset = "R",
  },
  lsp_blacklist = {},
  symbol_blacklist = {},
  symbols = {
    File = { icon = "", hl = "@text.uri" },
    Module = { icon = "", hl = "@namespace" },
    Namespace = { icon = "", hl = "@namespace" },
    Package = { icon = "", hl = "@namespace" },
    Class = { icon = "𝓒", hl = "@type" },
    Method = { icon = "ƒ", hl = "@method" },
    Property = { icon = "", hl = "@method" },
    Field = { icon = "", hl = "@field" },
    Constructor = { icon = "", hl = "@constructor" },
    Enum = { icon = "ℰ", hl = "@type" },
    Interface = { icon = "ﰮ", hl = "@type" },
    Function = { icon = "", hl = "@function" },
    Variable = { icon = "", hl = "@constant" },
    Constant = { icon = "", hl = "@constant" },
    String = { icon = "𝓐", hl = "@string" },
    Number = { icon = "#", hl = "@number" },
    Boolean = { icon = "⊨", hl = "@boolean" },
    Array = { icon = "", hl = "@constant" },
    Object = { icon = "⦿", hl = "@type" },
    Key = { icon = "🔐", hl = "@type" },
    Null = { icon = "NULL", hl = "@type" },
    EnumMember = { icon = "", hl = "@field" },
    Struct = { icon = "𝓢", hl = "@type" },
    Event = { icon = "🗲", hl = "@type" },
    Operator = { icon = "+", hl = "@operator" },
    TypeParameter = { icon = "𝙏", hl = "@parameter" },
    Component = { icon = "", hl = "@function" },
    Fragment = { icon = "", hl = "@constant" },
  },
}
require("symbols-outline").setup(opts)
EOF

nnoremap <leader>cce :CopilotChatExplain<CR>
nnoremap <leader>ccr :CopilotChatReview<CR>
nnoremap <leader>ccf :CopilotChatFix<CR>
nnoremap <leader>cco :CopilotChatOptimize<CR>
nnoremap <leader>ccd :CopilotChatDocs<CR>
nnoremap <leader>cct :CopilotChatTests<CR>
nnoremap <leader>ccq :CopilotChatClose<CR>
vnoremap <leader>cc :CopilotChatVisual<CR>
vnoremap <leader>cce :CopilotChatExplain<CR>
command! -nargs=* Cc CopilotChat <args> 

" Add this Lua configuration block after your other Lua configs
lua << EOF
require("CopilotChat").setup {
  debug = false, -- Enable debugging
  
  -- See Configuration section for rest
  model = 'gpt-4', -- GPT model to use, 'gpt-3.5-turbo' or 'gpt-4'
  
  -- System prompts
  system_prompt = "You are a helpful AI assistant. You explain code, suggest improvements, and help with programming tasks.",
  
  -- Chat window configuration
  window = {
    layout = 'vertical', -- 'vertical', 'horizontal', 'float', 'replace'
    width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
    height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
    -- Options below only apply to floating windows
    relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
    border = 'single', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil, -- row position of the window, default is centered
    col = nil, -- column position of the window, default is centered
    title = 'Copilot Chat', -- title of chat window
    footer = nil, -- footer of chat window
    zindex = 1, -- determines if window is on top or below other floating windows
  },

  -- Chat configuration
  chat = {
    welcome_message = "Hello! I'm your AI coding assistant. How can I help you today?",
    loading_text = "Loading, please wait ...",
    question_sign = "", -- 🙂
    answer_sign = "ﮧ", -- 🤖
    border_follow_highlight = true, -- follow color of border
    error_header = "Error: ",
    separator = " ", -- separator to use in chat
    show_folds = true, -- Shows folds for sections in chat
    show_help = true, -- Shows help message as virtual lines when waiting for user input
    auto_follow_cursor = true, -- Auto-follow cursor in chat
    auto_insert_mode = false, -- Automatically enter insert mode when opening window and if auto follow cursor is enabled on new prompt
    insert_at_end = false, -- Move cursor to end of buffer when inserting text
    clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
    highlight_selection = true, -- Highlight selection in the source buffer when in the chat window
  },

  -- Context configuration
  context = 'buffer', -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
  history_path = vim.fn.stdpath('data') .. '/copilotchat_history', -- Default path to stored history
  callback = nil, -- Callback to use when ask response is received

  -- default selection (visual or line)
  selection = function(source)
    return require("CopilotChat.select").visual(source) or require("CopilotChat.select").line(source)
  end,

  -- default prompts
  prompts = {
    Explain = {
      prompt = '/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text.',
    },
    Review = {
      prompt = '/COPILOT_REVIEW Review the selected code.',
      callback = function(response, source)
        -- see config.lua for implementation
      end,
    },
    Fix = {
      prompt = '/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.',
    },
    Optimize = {
      prompt = '/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.',
    },
    Docs = {
      prompt = '/COPILOT_GENERATE Please add documentation comment for the selection.',
    },
    Tests = {
      prompt = '/COPILOT_GENERATE Please generate tests for my code.',
    },
    FixDiagnostic = {
      prompt = 'Please assist with the following diagnostic issue in file:',
      selection = require('CopilotChat.select').diagnostics,
    },
    Commit = {
      prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
      selection = require('CopilotChat.select').gitdiff,
    },
    CommitStaged = {
      prompt = 'Write commit message for the change with commitizen convention. Make sure the title has maximum 50 characters and message is wrapped at 72 characters. Wrap the whole message in code block with language gitcommit.',
      selection = function(source)
        return require('CopilotChat.select').gitdiff(source, true)
      end,
    },
  },

  -- default mappings
  mappings = {
    complete = {
      detail = 'Use @<Tab> or /<Tab> for options.',
      insert ='<Tab>',
    },
    close = {
      normal = 'q',
      insert = '<C-c>'
    },
    reset = {
      normal ='<C-l>',
      insert = '<C-l>'
    },
    submit_prompt = {
      normal = '<CR>',
      insert = '<C-s>'
    },
    accept_diff = {
      normal = '<C-y>',
      insert = '<C-y>'
    },
    show_diff = {
      normal = 'gd'
    },
    show_system_prompt = {
      normal = 'gp'
    },
    show_user_selection = {
      normal = 'gs'
    },
  },
}
EOF

lua require('csvview').setup()

" Depramanager setup

lua << EOF
local depramanager = require('depramanager')

-- Enable auto-highlighting
depramanager.setup()

-- Bind telescope functions to keys
vim.keymap.set('n', '<leader>dp', depramanager.python_telescope, { desc = 'Outdated Python packages' })
vim.keymap.set('n', '<leader>dg', depramanager.go_telescope, { desc = 'Outdated Go modules' })
vim.keymap.set('n', '<leader>dn', depramanager.npm_telescope, { desc = 'Outdated npm packages' })
vim.keymap.set('n', '<leader>dvp', depramanager.python_vulnerabilities_telescope, { desc = 'Outdated Python packages' })
vim.keymap.set('n', '<leader>dvg', depramanager.go_vulnerabilities_telescope, { desc = 'Outdated Go modules' })
vim.keymap.set('n', '<leader>dvn', depramanager.npm_vulnerabilities_telescope, { desc = 'Outdated npm packages' })
EOF

"" More configs
lua << EOF
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.cu",
    callback = function()
        vim.bo.filetype = "cpp"
    end
})

vim.g.gruvbox_contrast_light = "soft"
EOF

set laststatus=0

let g:coq_settings ={'auto_start': 'shut-up'}
