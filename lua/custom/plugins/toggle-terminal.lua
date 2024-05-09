return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm size=10 direction=horizontal<cr>', desc = 'Open a horizontal terminal at the Desktop directory' },
  },
  config = function()
    require('toggleterm').setup {
      autochdir = true,
      start_in_insert = true,
      close_on_exit = true,
      size = 10,
      float_ops = {
        height = 10,
      },
    }
  end,
}
