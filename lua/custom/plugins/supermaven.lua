return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      disable_inline_completion = true,
      disable_autocomplete = true,
      disable_autoformat = true,
    }
  end,
}