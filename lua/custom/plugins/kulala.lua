vim.pack.add {'https://github.com/mistweaverco/kulala.nvim'}

require('kulala').setup{
  keys = {
    { '<leader>Rs', desc = 'Send request' },
    { '<leader>Ra', desc = 'Send all requests' },
    { '<leader>sp', desc = 'Open scratchpad' },
  },
  ft = { 'http', 'rest' },
  opts = {
    global_keymaps = true,
  },
}
