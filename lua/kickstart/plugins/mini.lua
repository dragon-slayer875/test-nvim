return {
  {
    'echasnovski/mini.pick',
    dependencies = {
      'echasnovski/mini.extra',
      opts = {},
    },
    keys = {
      { '<leader>fh', ':Pick help<CR>', desc = 'Find Help', mode = { 'n' } },
      { '<leader>fb', ':Pick buffers<CR>', desc = 'Find Buffers', mode = { 'n' } },
      { '<leader>ff', ':Pick files<CR>', desc = 'Find Files', mode = { 'n' } },
      { '<leader>fw', ':Pick grep_live<CR>', desc = 'Find Words', mode = { 'n' } },
      { '<leader>fR', ':Pick resume<CR>', desc = 'Find Resume', mode = { 'n' } },
      { '<leader>fc', ':Pick colorschemes<CR>', desc = 'Find Colorscheme', mode = { 'n' } },
      { '<leader>fk', ':Pick keymaps<CR>', desc = 'Find Keymaps', mode = { 'n' } },
      { '<leader>fd', ':Pick diagnostic scope=current<CR>', desc = 'Find Diagnostics', mode = { 'n' } },
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
          local fileinfo, file_hl = MiniStatusline.section_fileinfo { trunc_width = 120 }
          local location = MiniStatusline.section_location { trunc_width = 75 }

          -- -- Custom definitions
          ---@diagnostic disable-next-line: duplicate-set-field
          MiniStatusline.section_fileinfo = function()
            local icon, hl_group = require('nvim-web-devicons').get_icon_by_filetype(vim.bo.filetype, { default = true })
            return string.format(' %s %s[%s]', icon, vim.bo.filetype, vim.bo.fileencoding), hl_group
          end

          ---@diagnostic disable-next-line: duplicate-set-field
          MiniStatusline.section_location = function()
            return '%2l:%-2v'
          end

          ---@diagnostic disable-next-line: duplicate-set-field
          MiniStatusline.section_lsp = function()
            local function get_active_lsps()
              local clients = vim.lsp.get_clients { bufnr = 0 }
              local client_names = {}

              for _, client in pairs(clients) do
                table.insert(client_names, client.name)
              end

              return client_names
            end
            local active_lsps = get_active_lsps()
            return table.concat(active_lsps, ', ')
          end

          return MiniStatusline.combine_groups {
            { hl = mode_hl, strings = { ' ' } },
            { hl = 'GitGraphBranchTag', strings = { git } },
            { hl = file_hl, strings = { fileinfo } },
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
