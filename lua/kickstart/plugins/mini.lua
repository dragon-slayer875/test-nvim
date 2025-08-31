return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }
    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
    -- Statusline.
    local statusline = require 'mini.statusline'
    -- set use_icons to true if you have a Nerd Font
    statusline.setup {
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
    }

    -- Custom definitions
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_fileinfo = function()
      return string.format(' %s', vim.bo.filetype)
    end
  end,
}
