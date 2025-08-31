return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '3.*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  event = 'VimEnter',
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'Toggle explorer', silent = true },
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
  opts = {
    window = {
      position = 'right',
      width = 30,
      mappings = {
        ['<space>'] = {
          nowait = false,
        },
      },
    },
    filesystem = {
      hijack_netrw_behavior = 'open_current',
    },
  },
}
