return {
  {
    'echasnovski/mini.pick',
    dependencies = {
      'echasnovski/mini.extra',
      opts = {},
    },
    keymap = {
      set = function()
        vim.keymap.set({ 'v', 'n' }, '<leader>fh', MiniPick.builtin.help, { desc = 'Find Help' })
        vim.keymap.set({ 'v', 'n' }, '<leader>fb', MiniPick.builtin.buffers, { desc = 'Find Buffers' })
        vim.keymap.set({ 'v', 'n' }, '<leader>ff', MiniPick.builtin.files, { desc = 'Find Files' })
        vim.keymap.set({ 'v', 'n' }, '<leader>fw', MiniPick.builtin.grep, { desc = 'Find Words' })
        vim.keymap.set({ 'v', 'n' }, '<leader>fr', MiniPick.builtin.resume, { desc = 'Find Resume' })
      end,
    },
    opts = {},
  },
  -- Better Around/Inside textobjects
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  {
    'echasnovski/mini.ai',
    opts = {
      n_lines = 500,
    },
  },
  -- Add/delete/replace surroundings (brackets, quotes, etc.)
  -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  -- - sd'   - [S]urround [D]elete [']quotes
  -- - sr)'  - [S]urround [R]eplace [)] [']
  {
    'echasnovski/mini.surround',
  },
  -- statusline
  {
    'echasnovski/mini.statusline',
    opts = {
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local _, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
          local git = MiniStatusline.section_git { trunc_width = 40 }
          local diff = MiniStatusline.section_diff {
            icon = '',
            trunc_width = 75,
          }
          local diagnostics = MiniStatusline.section_diagnostics {
            icon = '',
            trunc_width = 75,
          }
          local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
          local fileinfo = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local location = MiniStatusline.section_location { trunc_width = 75 }

          -- -- Custom definitions
          -- ---@diagnostic disable-next-line: duplicate-set-field
          -- MiniStatusline.section_fileinfo = function()
          --   return string.format(' %s', vim.bo.filetype)
          -- end
          ---@diagnostic disable-next-line: duplicate-set-field
          MiniStatusline.section_location = function()
            return '%2l:%-2v'
          end

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { ' ' } },
            { hl = 'MiniStatuslineDevinfo', strings = { git } },
            { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
            { hl = 'MiniStatuslineDevinfo', strings = { diff } },
            { hl = 'MiniStatuslineDevinfo', strings = { diagnostics } },
            '%=', -- End left alignment
            { hl = 'MiniStatuslineDevinfo', strings = { lsp } },
            { hl = 'MiniStatuslineFileinfo', strings = { location } },
            { strings = { ' ' }, hl = mode_hl },
          }
        end,
      },
    },
  },
}

--     --   -- vim.keymap.set('n', '<leader>sh', MiniPick.builtin.help_tags, { desc = '[S]earch [H]elp' })
--     --   -- vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
--     --   -- vim.keymap.set('n', '<leader>sf', MiniPick.builtin.find_files, { desc = '[S]earch [F]iles' })
--     --   -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
--     --   -- vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
--     --   -- vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
--     --   -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
--     --   -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
--     --   -- vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
--     --   vim.keymap.set('n', '<leader><leader>', MiniPick.builtin.buffers(), { desc = '[ ] Find existing buffers' }),
--     --   --
--     --   -- -- Slightly advanced example of overriding default behavior and theme
--     --   -- vim.keymap.set('n', '<leadew>/', function()
--     --   --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
--     --   --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--     --   --     winblend = 10,
--     --   --     previewer = false,
--     --   --   })
--     --   -- end, { desc = '[/] Fuzzily search in current buffer' })
--     --   --
--     --   -- -- It's also possible to pass additional configuration options.
--     --   -- --  See `:help telescope.builtin.live_grep()` for information about particular keys
--     --   -- vim.keymap.set('n', '<leader>s/', function()
--     --   --   builtin.live_grep {
--     --   --     grep_open_files = true,
--     --   --     prompt_title = 'Live Grep in Open Files',
--     --   --   }
--     --   -- end, { desc = '[S]earch [/] in Open Files' })
--     --   --
--     --   -- -- Shortcut for searching your Neovim configuration files
--     --   -- vim.keymap.set('n', '<leader>sn', function()
--     --   --   builtin.find_files { cwd = vim.fn.stdpath 'config' }
--     --   -- end, { desc = '[S]earch [N]eovim files' })
