vim.pack.add {'https://github.com/MagicDuck/grug-far.nvim'}

require('grug-far').setup()

vim.keymap.set('n', '<leader>gf', require('grug-far').open, { desc = 'Open GrugFar' })
