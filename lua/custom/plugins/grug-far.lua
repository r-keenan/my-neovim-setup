return {
  'MagicDuck/grug-far.nvim',
  config = function()
    local gf = require 'grug-far'

    gf.setup()

    vim.keymap.set('n', '<leader>gf', function()
      gf.open()
    end)
  end,
}
