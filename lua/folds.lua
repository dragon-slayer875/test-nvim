local M = {}

M.setup = function()
  --  default to Tree‑sitter folding
  vim.o.foldmethod = 'expr'
  vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  vim.o.foldenable = true
  vim.o.foldlevel = 99 -- open most folds on startup
  vim.o.fdc = '1'
  vim.o.fdt = ''

  --  use LSP-based folding when available
  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.supports_method 'textDocument/foldingRange' then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win].foldexpr = 'v:lua.vim.lsp.foldexpr()'
      end
    end,
  })

  -- auto-close imports on open
  vim.api.nvim_create_autocmd('LspNotify', {
    callback = function(args)
      if args.data.method == 'textDocument/didOpen' then
        vim.lsp.foldclose('imports', vim.fn.bufwinid(args.buf))
      end
    end,
  })
end

return M
