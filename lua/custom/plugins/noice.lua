return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    messages = {
      enabled = false,
    },
    notify = {
      enabled = false,
    },
    lsp = {
      progress = {
        enabled = false, -- Disable LSP progress to avoid the token error
      },
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}
