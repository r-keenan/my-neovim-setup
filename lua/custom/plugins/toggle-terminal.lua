return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm size=10 dir=~/Desktop direction=horizontal<cr>', desc = 'Open a horizontal terminal at the Desktop directory' },
  },
  config = function()
    require('toggleterm').setup {
      autochdir = true,
      size = 5,
      float_ops = {
        height = 5,
      },
    }
  end,
}
