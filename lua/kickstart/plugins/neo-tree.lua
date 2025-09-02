return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '3.*',
  specs = {
    { 'nvim-lua/plenary.nvim', lazy = true },
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    { 'MunifTanjim/nui.nvim', lazy = true },
  },
  init = function()
    -- the remote file handling part
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('RemoteFileInit', { clear = true }),
      callback = function()
        local f = vim.fn.expand '%:p'
        for _, v in ipairs { 'dav', 'fetch', 'ftp', 'http', 'rcp', 'rsync', 'scp', 'sftp' } do
          local p = v .. '://'
          if f:sub(1, #p) == p then
            vim.cmd [[
              unlet g:loaded_netrw
              unlet g:loaded_netrwPlugin
              runtime! plugin/netrwPlugin.vim
              silent Explore %
            ]]
            break
          end
        end
        vim.api.nvim_clear_autocmds { group = 'RemoteFileInit' }
      end,
    })
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('NeoTreeInit', { clear = true }),
      callback = function()
        local f = vim.fn.expand '%:p'
        if vim.fn.isdirectory(f) ~= 0 then
          vim.cmd('Neotree current dir=' .. f)
          vim.api.nvim_clear_autocmds { group = 'NeoTreeInit' }
        end
      end,
    })
    -- keymaps
  end,
  lazy = false,
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
