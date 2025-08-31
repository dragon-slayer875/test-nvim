return { -- Autocompletion
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    'rafamadriz/friendly-snippets',
    -- 'folke/lazydev.nvim',
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
        'select_next',
        'snippet_forward',
        function(cmp)
          if has_words_before() or vim.api.nvim_get_mode().mode == 'c' then
            return cmp.show()
          end
        end,
        'fallback',
      },
      ['<S-Tab>'] = {
        'select_prev',
        'snippet_backward',
        function(cmp)
          if vim.api.nvim_get_mode().mode == 'c' then
            return cmp.show()
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
      default = { 'lsp', 'path', 'snippets', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
      },
    },

    snippets = { preset = 'luasnip' },

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
