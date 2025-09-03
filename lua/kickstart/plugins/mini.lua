local win_config = function()
  local height = math.floor(0.618 * vim.o.lines)
  local width = math.floor(0.618 * vim.o.columns)
  return {
    anchor = 'NW',
    height = height,
    width = width,
    row = math.floor(0.5 * (vim.o.lines - height)),
    col = math.floor(0.5 * (vim.o.columns - width)),
  }
end

return {
  {
    'echasnovski/mini.pick',
    dependencies = {
      'echasnovski/mini.extra',
      opts = {},
    },
    keys = {
      { '<leader>fh', '<cmd>Pick help<CR>', desc = 'Find Help', mode = { 'n' } },
      { '<leader>fb', '<cmd>Pick buffers<CR>', desc = 'Find Buffers', mode = { 'n' } },
      { '<leader>ff', '<cmd>Pick files<CR>', desc = 'Find Files', mode = { 'n' } },
      { '<leader>fw', '<cmd>Pick grep_live<CR>', desc = 'Find Words', mode = { 'n' } },
      { '<leader>fR', '<cmd>Pick resume<CR>', desc = 'Find Resume', mode = { 'n' } },
      { '<leader>fc', '<cmd>Pick colorschemes<CR>', desc = 'Find Colorscheme', mode = { 'n' } },
      { '<leader>fk', '<cmd>Pick keymaps<CR>', desc = 'Find Keymaps', mode = { 'n' } },
      { '<leader>fd', '<cmd>Pick diagnostic scope=current<CR>', desc = 'Find Diagnostics', mode = { 'n' } },
    },
    opts = {
      mappings = {
        toggle_info = '<C-k>',
        toggle_preview = '<C-p>',
        move_down = '<Tab>',
        move_up = '<S-Tab>',
      },
      window = {
        config = win_config,
        -- {
        --         relative = 'cursor',
        --         anchor = 'NW',
        --         row = 0,
        --         col = 0,
        --         width = 40,
        --         height = 20,
        --       },
      },
    },
    config = function(_, opts)
      require('mini.pick').setup(opts)
      vim.ui.select = require('mini.pick').ui_select
    end,
  },
  -- Better Around/Inside textobjects
  -- Examples:
  --  - va)  - [V]isually select [A]round [)]paren
  --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --  - ci'  - [C]hange [I]nside [']quote
  {
    'echasnovski/mini.ai',
    event = 'BufReadPre',
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
    event = 'BufReadPre',
  },
  -- statusline
  -- {
  --   'echasnovski/mini.statusline',
  --   opts = {
  --     use_icons = vim.g.have_nerd_font,
  --     content = {
  --       active = function()
  --         local _, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
  --         local git = MiniStatusline.section_git { trunc_width = 40 }
  --         local diff = MiniStatusline.section_diff {
  --           icon = '',
  --           trunc_width = 75,
  --         }
  --         local diagnostics = MiniStatusline.section_diagnostics {
  --           signs = {
  --             ERROR = '󰅚 ',
  --             WARN = '󰀪 ',
  --             INFO = '󰋽 ',
  --             HINT = '󰌶 ',
  --           },
  --           icon = '',
  --           trunc_width = 75,
  --         }
  --         local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
  --         local fileinfo, file_hl = MiniStatusline.section_fileinfo { trunc_width = 120 }
  --         local location = MiniStatusline.section_location { trunc_width = 75 }
  --
  --         -- -- Custom definitions
  --         ---@diagnostic disable-next-line: duplicate-set-field
  --         MiniStatusline.section_fileinfo = function()
  --           local icon, hl_group = require('nvim-web-devicons').get_icon_by_filetype(vim.bo.filetype, { default = true })
  --           return string.format(' %s %s[%s]', icon, vim.bo.filetype, vim.bo.fileencoding), hl_group
  --         end
  --
  --         ---@diagnostic disable-next-line: duplicate-set-field
  --         MiniStatusline.section_location = function()
  --           return '%P %2l:%-2v'
  --         end
  --
  --         ---@diagnostic disable-next-line: duplicate-set-field
  --         MiniStatusline.section_lsp = function()
  --           local function get_active_lsps()
  --             local clients = vim.lsp.get_clients { bufnr = 0 }
  --             local client_names = {}
  --
  --             for _, client in pairs(clients) do
  --               table.insert(client_names, client.name)
  --             end
  --
  --             return client_names
  --           end
  --           local active_lsps = get_active_lsps()
  --           return table.concat(active_lsps, ', ')
  --         end
  --
  --         return MiniStatusline.combine_groups {
  --           { hl = mode_hl, strings = { ' ' } },
  --           { hl = 'GitGraphBranchTag', strings = { git } },
  --           { hl = file_hl, strings = { fileinfo } },
  --           { hl = 'MiniStatuslineDevinfo', strings = { diff } },
  --           { hl = 'MiniStatuslineDevinfo', strings = { diagnostics } },
  --           '%=', -- End left alignment
  --           { hl = 'MiniStatuslineDevinfo', strings = { lsp } },
  --           { hl = 'MiniStatuslineFileinfo', strings = { location } },
  --           { strings = { ' ' }, hl = mode_hl },
  --         }
  --       end,
  --     },
  --   },
  --   config = function(_, opts)
  --     require('mini.statusline').setup(opts)
  --   end,
  -- },
}
