return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '3.*',
  specs = {
    { 'nvim-lua/plenary.nvim', lazy = true },
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    { 'MunifTanjim/nui.nvim', lazy = true },
  },
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<CR>', desc = 'Toggle explorer', silent = true },
    {
      '<leader>o',
      function()
        if vim.bo.filetype == 'neo-tree' then
          vim.cmd.wincmd 'p'
        else
          vim.cmd.Neotree 'focus'
        end
      end,
      desc = 'NeoTree focus',
      silent = true,
    },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    window = {
      width = 30,
      position = 'right',
      mappings = {
        ['<space>'] = false,
        O = 'system_open',
      },
      fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
        ['<C-J>'] = 'move_cursor_down',
        ['<C-K>'] = 'move_cursor_up',
      },
    },
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      follow_current_file = { enabled = true },
    },
    close_if_last_window = true,
  },
  config = function(_, opts)
    require('neo-tree').setup(opts)
  end,
}
