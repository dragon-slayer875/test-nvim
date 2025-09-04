return {
  'rebelot/heirline.nvim',
  config = function()
    local conditions = require 'heirline.conditions'
    local utils = require 'heirline.utils'
    local colors = require('onedarkpro.helpers').get_colors()
    require('heirline').load_colors(colors)

    local Padding = { provider = '  ' }

    local Align = { provider = '%=' }

    local ShowCmd = {
      provider = '%3.5(%S%)',
    }

    local ViMode = {
      -- get vim current mode, this information will be required by the provider
      -- and the highlight functions, so we compute it only once per component
      -- evaluation and store it as a component attribute
      init = function(self)
        self.mode = vim.fn.mode(1) -- :h mode()
      end,
      -- Now we define some dictionaries to map the output of mode() to the
      -- corresponding string and color. We can put these into `static` to compute
      -- them at initialisation time.
      static = {
        mode_names = { -- change the strings if you like it vvvvverbose!
          n = 'N',
          no = 'N?',
          nov = 'N?',
          noV = 'N?',
          ['no\22'] = 'N?',
          niI = 'Ni',
          niR = 'Nr',
          niV = 'Nv',
          nt = 'Nt',
          v = 'V',
          vs = 'Vs',
          V = 'V_',
          Vs = 'Vs',
          ['\22'] = '^V',
          ['\22s'] = '^V',
          s = 'S',
          S = 'S_',
          ['\19'] = '^S',
          i = 'I',
          ic = 'Ic',
          ix = 'Ix',
          R = 'R',
          Rc = 'Rc',
          Rx = 'Rx',
          Rv = 'Rv',
          Rvc = 'Rv',
          Rvx = 'Rv',
          c = 'C',
          cv = 'Ex',
          r = '...',
          rm = 'M',
          ['r?'] = '?',
          ['!'] = '!',
          t = 'T',
        },
        mode_colors = {
          n = 'red',
          i = 'green',
          v = 'cyan',
          V = 'cyan',
          ['\22'] = 'cyan',
          c = 'orange',
          s = 'purple',
          S = 'purple',
          ['\19'] = 'purple',
          R = 'orange',
          r = 'orange',
          ['!'] = 'red',
          t = 'red',
        },
      },

      provider = function()
        return ' '
      end,

      hl = function(self)
        local mode = self.mode:sub(1, 1) -- get only the first mode character
        return { bg = self.mode_colors[mode], bold = true }
      end,
      -- Re-evaluate the component only on ModeChanged event!
      -- Also allows the statusline to be re-evaluated when entering operator-pending mode
      update = {
        'ModeChanged',
        pattern = '*:*',
        callback = vim.schedule_wrap(function()
          vim.cmd 'redrawstatus'
        end),
      },
    }

    local FileNameBlock = {
      init = function(self)
        self.filename = vim.api.nvim_buf_get_name(0)
      end,
    }

    local FileIcon = {
      init = function(self)
        local filename = self.filename
        local extension = vim.fn.fnamemodify(filename, ':e')
        self.icon, self.icon_color = require('nvim-web-devicons').get_icon_color(filename, extension, { default = true })
      end,
      provider = function(self)
        return self.icon and (self.icon .. ' ')
      end,
      hl = function(self)
        return { fg = self.icon_color }
      end,
    }

    local FileName = {
      provider = function(self)
        -- trim filename to extension
        local filename = vim.fn.fnamemodify(self.filename, ':e')
        if filename == '' then
          return '[No Name]'
        end
        -- now, if the filename would occupy more than 1/4th of the available
        -- space, would trim the file path to its initials
        -- See Flexible Components section below for dynamic truncation
        if not conditions.width_percent_below(#filename, 0.25) then
          filename = vim.fn.pathshorten(filename)
        end
        return filename
      end,
      hl = { fg = utils.get_highlight('Statusline').bg },
    }

    local FileEncoding = {
      provider = function()
        local enc = (vim.bo.fenc ~= '' and vim.bo.fenc) or vim.o.enc -- :h 'enc'
        return enc ~= 'utf-8' and enc:upper()
      end,
    }

    local FileFlags = {
      {
        condition = function()
          return vim.bo.modified
        end,
        provider = '  ',
        hl = { fg = 'green' },
      },
      {
        condition = function()
          return not vim.bo.modifiable or vim.bo.readonly
        end,
        provider = '  ',
        hl = { fg = 'orange' },
      },
    }

    -- Now, let's say that we want the filename color to change if the buffer is
    -- modified. Of course, we could do that directly using the FileName.hl field,
    -- but we'll see how easy it is to alter existing components using a "modifier"
    -- component

    -- local FileNameModifer = {
    --   hl = function()
    --     if vim.bo.modified then
    --       -- use `force` because we need to override the child's hl foreground
    --       return { fg = 'cyan', bold = true, force = true }
    --     end
    --   end,
    -- }

    -- let's add the children to our FileNameBlock component
    FileNameBlock = utils.insert(
      FileNameBlock,
      FileIcon,
      FileName,
      FileEncoding,
      FileFlags,
      { provider = '%<' } -- this means that the statusline is cut here when there's not enough space
    )

    local Diagnostics = {
      condition = conditions.has_diagnostics,
      -- Fetching custom diagnostic icons
      static = {
        error_icon = '󰅚 ',
        warn_icon = '󰀪 ',
        info_icon = '󰋽 ',
        hint_icon = '󰌶 ',
      },

      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,

      update = { 'DiagnosticChanged', 'BufEnter' },

      {
        provider = function(self)
          -- 0 is just another output, we can decide to print it or not!
          return self.errors > 0 and (self.error_icon .. self.errors .. ' ')
        end,
        hl = { fg = utils.get_highlight('DiagnosticError').fg },
      },
      {
        provider = function(self)
          return self.warnings > 0 and (self.warn_icon .. self.warnings .. ' ')
        end,
        hl = { fg = utils.get_highlight('DiagnosticWarn').fg },
      },
      {
        provider = function(self)
          return self.info > 0 and (self.info_icon .. self.info .. ' ')
        end,
        hl = { fg = utils.get_highlight('DiagnosticInfo').fg },
      },
      {
        provider = function(self)
          return self.hints > 0 and (self.hint_icon .. self.hints)
        end,
        hl = { fg = utils.get_highlight('DiagnosticHint').fg },
      },
    }

    local LSPActive = {
      condition = conditions.lsp_attached,
      update = { 'LspAttach', 'LspDetach' },

      provider = function()
        local names = {}
        for i, server in pairs(vim.lsp.get_clients { bufnr = 0 }) do
          table.insert(names, server.name)
        end
        return ' ' .. table.concat(names, ' ')
      end,
      hl = { fg = utils.get_highlight('Statusline').bg },
    }

    local Git = {
      condition = conditions.is_git_repo,

      init = function(self)
        self.status_dict = vim.b.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
      end,

      hl = { fg = 'orange' },

      { -- git branch name
        provider = function(self)
          return ' ' .. self.status_dict.head
        end,
        hl = { bold = true },
      },
      -- You could handle delimiters, icons and counts similar to Diagnostics
      {
        provider = function(self)
          local count = self.status_dict.added or 0
          return count > 0 and (' +' .. count)
        end,
        hl = { fg = utils.get_highlight('GitSignsAdd').fg },
      },
      {
        provider = function(self)
          local count = self.status_dict.removed or 0
          return count > 0 and (' -' .. count)
        end,
        hl = { fg = utils.get_highlight('GitSignsDelete').fg },
      },
      {
        provider = function(self)
          local count = self.status_dict.changed or 0
          return count > 0 and (' ~' .. count)
        end,
        hl = { fg = utils.get_highlight('GitSignsChange').fg },
      },
    }

    local Ruler = {
      -- %l = current line number
      -- %c = column number
      -- %P = percentage through file of displayed window
      provider = '%4l:%2c %P  ',
    }

    local ScrollBar = {
      static = {
        -- sbar = { '▁', '▂', '▃', '▄', '▅', '▆', '▇', '█' },
        sbar = { '🭶', '🭷', '🭸', '🭹', '🭺', '🭻' },
      },
      provider = function(self)
        local curr_line = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_line_count(0)
        local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
        return string.rep(self.sbar[i], 2)
      end,
      hl = { fg = 'blue', bg = utils.get_highlight('Statusline').fg },
    }

    local DefaultStatusline = {
      ViMode,
      Padding,
      Git,
      Padding,
      FileNameBlock,
      Padding,
      Diagnostics,
      Align,
      LSPActive,
      Padding,
      ShowCmd,
      Padding,
      Ruler,
      ScrollBar,
    }

    require('heirline').setup {
      statusline = DefaultStatusline,
    }
  end,
}
