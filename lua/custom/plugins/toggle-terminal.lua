return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm size=20 direction=horizontal<cr>', desc = 'Open a horizontal terminal at the Desktop directory' },
  },
  config = function()
    require('toggleterm').setup {
      autochdir = true,
      start_in_insert = true,
      close_on_exit = true,
      size = 20,
      float_ops = {
        height = 20,
      },
    }
  end,
}
