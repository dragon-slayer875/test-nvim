local has_words_before = function()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if col == 0 then
    return false
  end
  local line = vim.api.nvim_get_current_line()
  return line:sub(col, col):match '%s' == nil
end

return { -- Autocompletion
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '1.*',
  dependencies = {
    { 'rafamadriz/friendly-snippets', event = 'InsertEnter' },
    -- 'folke/lazydev.nvim',
    -- {
    --   'L3MON4D3/LuaSnip',
    --   version = '2.*',
    --   build = 'make install_jsregexp',
    -- },
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      ['<Up>'] = { 'select_prev', 'fallback' },
      ['<Down>'] = { 'select_next', 'fallback' },
      ['<C-N>'] = { 'select_next', 'show' },
      ['<C-P>'] = { 'select_prev', 'show' },
      ['<C-J>'] = { 'select_next', 'fallback' },
      ['<C-K>'] = { 'select_prev', 'fallback' },
      ['<C-U>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-D>'] = { 'scroll_documentation_down', 'fallback' },
      ['<C-e>'] = { 'hide', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
      ['<Tab>'] = {
        function(cmp)
          if has_words_before() then
            return cmp.insert_next()
          end
        end,
        'fallback',
      },
      ['<S-Tab>'] = {
        function(cmp)
          if has_words_before() then
            return cmp.insert_prev()
          end
        end,
        'fallback',
      },
      preset = 'none',
    },

    appearance = {
      nerd_font_variant = 'normal',
    },

    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
      menu = {
        enabled = true,
        auto_show = function(ctx)
          return ctx.mode ~= 'cmdline'
        end,
      },
      accept = {
        auto_brackets = { enabled = true },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
        window = {
          border = 'rounded',
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
        },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'buffer' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    fuzzy = { implementation = 'prefer_rust_with_warning' },

    cmdline = {
      keymap = {
        ['<End>'] = { 'hide', 'fallback' },
      },
      completion = { ghost_text = { enabled = false } },
    },
    signature = {
      window = {
        border = 'rounded',
        winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
      },
    },
  },
}
