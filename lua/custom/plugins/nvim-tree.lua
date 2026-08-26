vim.pack.add { 'https://github.com/nvim-tree/nvim-web-devicons', 'https://github.com/nvim-tree/nvim-tree.lua' }

vim.pack.add {}

---@type nvim_tree.config
local config = {
  view = {
    width = 30,
    side = 'left',
  },
  renderer = {
    group_empty = true,
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = { '.DS_Store' },
  },
  git = {
    enable = true,
    ignore = false,
  },
}

require('nvim-tree').setup(config)

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<cr>', { desc = 'Toggle file explorer' })
